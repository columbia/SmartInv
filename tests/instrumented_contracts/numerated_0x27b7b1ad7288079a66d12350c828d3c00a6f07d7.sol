1 # @version 0.2.8
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
38 API_VERSION: constant(String[28]) = "0.3.2"
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
232 SECS_PER_YEAR: constant(uint256) = 31_557_600  # 365.25 days
233 # `nonces` track `permit` approvals with signature.
234 nonces: public(HashMap[address, uint256])
235 DOMAIN_SEPARATOR: public(bytes32)
236 DOMAIN_TYPE_HASH: constant(bytes32) = keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)')
237 PERMIT_TYPE_HASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
238 
239 
240 @external
241 def initialize(
242     token: address,
243     governance: address,
244     rewards: address,
245     nameOverride: String[64],
246     symbolOverride: String[32],
247     guardian: address = msg.sender,
248 ):
249     """
250     @notice
251         Initializes the Vault, this is called only once, when the contract is
252         deployed.
253         The performance fee is set to 10% of yield, per Strategy.
254         The management fee is set to 2%, per year.
255         The initial deposit limit is set to 0 (deposits disabled); it must be
256         updated after initialization.
257     @dev
258         If `nameOverride` is not specified, the name will be 'yearn'
259         combined with the name of `token`.
260 
261         If `symbolOverride` is not specified, the symbol will be 'y'
262         combined with the symbol of `token`.
263     @param token The token that may be deposited into this Vault.
264     @param governance The address authorized for governance interactions.
265     @param rewards The address to distribute rewards to.
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
280     self.decimals = DetailedERC20(token).decimals()
281     self.governance = governance
282     log UpdateGovernance(governance)
283     self.management = governance
284     log UpdateManagement(governance)
285     self.rewards = rewards
286     log UpdateRewards(rewards)
287     self.guardian = guardian
288     log UpdateGuardian(guardian)
289     self.performanceFee = 1000  # 10% of yield (per Strategy)
290     log UpdatePerformanceFee(convert(1000, uint256))
291     self.managementFee = 200  # 2% per year
292     log UpdateManagementFee(convert(200, uint256))
293     self.lastReport = block.timestamp
294     self.activation = block.timestamp
295     self.lockedProfitDegration = convert(DEGREDATION_COEFFICIENT * 46 /10 ** 6 , uint256) # 6 hours in blocks
296     # EIP-712
297     self.DOMAIN_SEPARATOR = keccak256(
298         concat(
299             DOMAIN_TYPE_HASH,
300             keccak256(convert("Yearn Vault", Bytes[11])),
301             keccak256(convert(API_VERSION, Bytes[28])),
302             convert(chain.id, bytes32),
303             convert(self, bytes32)
304         )
305     )
306 
307 
308 @pure
309 @external
310 def apiVersion() -> String[28]:
311     """
312     @notice
313         Used to track the deployed version of this contract. In practice you
314         can use this version number to compare with Yearn's GitHub and
315         determine which version of the source matches this deployed contract.
316     @dev
317         All strategies must have an `apiVersion()` that matches the Vault's
318         `API_VERSION`.
319     @return API_VERSION which holds the current version of this contract.
320     """
321     return API_VERSION
322 
323 
324 @external
325 def setName(name: String[42]):
326     """
327     @notice
328         Used to change the value of `name`.
329 
330         This may only be called by governance.
331     @param name The new name to use.
332     """
333     assert msg.sender == self.governance
334     self.name = name
335 
336 
337 @external
338 def setSymbol(symbol: String[20]):
339     """
340     @notice
341         Used to change the value of `symbol`.
342 
343         This may only be called by governance.
344     @param symbol The new symbol to use.
345     """
346     assert msg.sender == self.governance
347     self.symbol = symbol
348 
349 
350 # 2-phase commit for a change in governance
351 @external
352 def setGovernance(governance: address):
353     """
354     @notice
355         Nominate a new address to use as governance.
356 
357         The change does not go into effect immediately. This function sets a
358         pending change, and the governance address is not updated until
359         the proposed governance address has accepted the responsibility.
360 
361         This may only be called by the current governance address.
362     @param governance The address requested to take over Vault governance.
363     """
364     assert msg.sender == self.governance
365     self.pendingGovernance = governance
366 
367 
368 @external
369 def acceptGovernance():
370     """
371     @notice
372         Once a new governance address has been proposed using setGovernance(),
373         this function may be called by the proposed address to accept the
374         responsibility of taking over governance for this contract.
375 
376         This may only be called by the proposed governance address.
377     @dev
378         setGovernance() should be called by the existing governance address,
379         prior to calling this function.
380     """
381     assert msg.sender == self.pendingGovernance
382     self.governance = msg.sender
383     log UpdateGovernance(msg.sender)
384 
385 
386 @external
387 def setManagement(management: address):
388     """
389     @notice
390         Changes the management address.
391         Management is able to make some investment decisions adjusting parameters.
392 
393         This may only be called by governance.
394     @param management The address to use for managing.
395     """
396     assert msg.sender == self.governance
397     self.management = management
398     log UpdateManagement(management)
399 
400 
401 @external
402 def setGuestList(guestList: address):
403     """
404     @notice
405         Used to set or change `guestList`. A guest list is another contract
406         that dictates who is allowed to participate in a Vault (and transfer
407         shares).
408 
409         This may only be called by governance.
410     @param guestList The address of the `GuestList` contract to use.
411     """
412     assert msg.sender == self.governance
413     self.guestList = GuestList(guestList)
414     log UpdateGuestList(guestList)
415 
416 
417 @external
418 def setRewards(rewards: address):
419     """
420     @notice
421         Changes the rewards address. Any distributed rewards
422         will cease flowing to the old address and begin flowing
423         to this address once the change is in effect.
424 
425         This will not change any Strategy reports in progress, only
426         new reports made after this change goes into effect.
427 
428         This may only be called by governance.
429     @param rewards The address to use for collecting rewards.
430     """
431     assert msg.sender == self.governance
432     self.rewards = rewards
433     log UpdateRewards(rewards)
434 
435 @external
436 def setLockedProfitDegration(degration: uint256):
437     """
438     @notice
439         Changes the locked profit degration. 
440     @param degration The rate of degration in percent per second scaled to 1e18.
441     """
442     assert msg.sender == self.governance
443     assert degration >= 0 and degration <= DEGREDATION_COEFFICIENT
444     self.lockedProfitDegration = degration
445 
446 @external
447 def setDepositLimit(limit: uint256):
448     """
449     @notice
450         Changes the maximum amount of tokens that can be deposited in this Vault.
451 
452         Note, this is not how much may be deposited by a single depositor,
453         but the maximum amount that may be deposited across all depositors.
454 
455         This may only be called by governance.
456     @param limit The new deposit limit to use.
457     """
458     assert msg.sender == self.governance
459     self.depositLimit = limit
460     log UpdateDepositLimit(limit)
461 
462 
463 @external
464 def setPerformanceFee(fee: uint256):
465     """
466     @notice
467         Used to change the value of `performanceFee`.
468 
469         Should set this value below the maximum strategist performance fee.
470 
471         This may only be called by governance.
472     @param fee The new performance fee to use.
473     """
474     assert msg.sender == self.governance
475     assert fee <= MAX_BPS
476     self.performanceFee = fee
477     log UpdatePerformanceFee(fee)
478 
479 
480 @external
481 def setManagementFee(fee: uint256):
482     """
483     @notice
484         Used to change the value of `managementFee`.
485 
486         This may only be called by governance.
487     @param fee The new management fee to use.
488     """
489     assert msg.sender == self.governance
490     assert fee <= MAX_BPS
491     self.managementFee = fee
492     log UpdateManagementFee(fee)
493 
494 
495 @external
496 def setGuardian(guardian: address):
497     """
498     @notice
499         Used to change the address of `guardian`.
500 
501         This may only be called by governance or the existing guardian.
502     @param guardian The new guardian address to use.
503     """
504     assert msg.sender in [self.guardian, self.governance]
505     self.guardian = guardian
506     log UpdateGuardian(guardian)
507 
508 
509 @external
510 def setEmergencyShutdown(active: bool):
511     """
512     @notice
513         Activates or deactivates Vault mode where all Strategies go into full
514         withdrawal.
515 
516         During Emergency Shutdown:
517         1. No Users may deposit into the Vault (but may withdraw as usual.)
518         2. Governance may not add new Strategies.
519         3. Each Strategy must pay back their debt as quickly as reasonable to
520             minimally affect their position.
521         4. Only Governance may undo Emergency Shutdown.
522 
523         See contract level note for further details.
524 
525         This may only be called by governance or the guardian.
526     @param active
527         If true, the Vault goes into Emergency Shutdown. If false, the Vault
528         goes back into Normal Operation.
529     """
530     if active:
531         assert msg.sender in [self.guardian, self.governance]
532     else:
533         assert msg.sender == self.governance
534     self.emergencyShutdown = active
535     log EmergencyShutdown(active)
536 
537 
538 @external
539 def setWithdrawalQueue(queue: address[MAXIMUM_STRATEGIES]):
540     """
541     @notice
542         Updates the withdrawalQueue to match the addresses and order specified
543         by `queue`.
544 
545         There can be fewer strategies than the maximum, as well as fewer than
546         the total number of strategies active in the vault. `withdrawalQueue`
547         will be updated in a gas-efficient manner, assuming the input is well-
548         ordered with 0x0 only at the end.
549 
550         This may only be called by governance or management.
551     @dev
552         This is order sensitive, specify the addresses in the order in which
553         funds should be withdrawn (so `queue`[0] is the first Strategy withdrawn
554         from, `queue`[1] is the second, etc.)
555 
556         This means that the least impactful Strategy (the Strategy that will have
557         its core positions impacted the least by having funds removed) should be
558         at `queue`[0], then the next least impactful at `queue`[1], and so on.
559     @param queue
560         The array of addresses to use as the new withdrawal queue. This is
561         order sensitive.
562     """
563     assert msg.sender in [self.management, self.governance]
564     # HACK: Temporary until Vyper adds support for Dynamic arrays
565     for i in range(MAXIMUM_STRATEGIES):
566         if queue[i] == ZERO_ADDRESS and self.withdrawalQueue[i] == ZERO_ADDRESS:
567             break
568         assert self.strategies[queue[i]].activation > 0
569         self.withdrawalQueue[i] = queue[i]
570     log UpdateWithdrawalQueue(queue)
571 
572 
573 @internal
574 def erc20_safe_transfer(token: address, receiver: address, amount: uint256):
575     # Used only to send tokens that are not the type managed by this Vault.
576     # HACK: Used to handle non-compliant tokens like USDT
577     response: Bytes[32] = raw_call(
578         token,
579         concat(
580             method_id("transfer(address,uint256)"),
581             convert(receiver, bytes32),
582             convert(amount, bytes32),
583         ),
584         max_outsize=32,
585     )
586     if len(response) > 0:
587         assert convert(response, bool), "Transfer failed!"
588 
589 
590 @internal
591 def erc20_safe_transferFrom(token: address, sender: address, receiver: address, amount: uint256):
592     # Used only to send tokens that are not the type managed by this Vault.
593     # HACK: Used to handle non-compliant tokens like USDT
594     response: Bytes[32] = raw_call(
595         token,
596         concat(
597             method_id("transferFrom(address,address,uint256)"),
598             convert(sender, bytes32),
599             convert(receiver, bytes32),
600             convert(amount, bytes32),
601         ),
602         max_outsize=32,
603     )
604     if len(response) > 0:
605         assert convert(response, bool), "Transfer failed!"
606 
607 
608 @internal
609 def _transfer(sender: address, receiver: address, amount: uint256):
610     # See note on `transfer()`.
611 
612     # Protect people from accidentally sending their shares to bad places
613     assert not (receiver in [self, ZERO_ADDRESS])
614     self.balanceOf[sender] -= amount
615     self.balanceOf[receiver] += amount
616     log Transfer(sender, receiver, amount)
617 
618 
619 @external
620 def transfer(receiver: address, amount: uint256) -> bool:
621     """
622     @notice
623         Transfers shares from the caller's address to `receiver`. This function
624         will always return true, unless the user is attempting to transfer
625         shares to this contract's address, or to 0x0.
626     @param receiver
627         The address shares are being transferred to. Must not be this contract's
628         address, must not be 0x0.
629     @param amount The quantity of shares to transfer.
630     @return
631         True if transfer is sent to an address other than this contract's or
632         0x0, otherwise the transaction will fail.
633     """
634     self._transfer(msg.sender, receiver, amount)
635     return True
636 
637 
638 @external
639 def transferFrom(sender: address, receiver: address, amount: uint256) -> bool:
640     """
641     @notice
642         Transfers `amount` shares from `sender` to `receiver`. This operation will
643         always return true, unless the user is attempting to transfer shares
644         to this contract's address, or to 0x0.
645 
646         Unless the caller has given this contract unlimited approval,
647         transfering shares will decrement the caller's `allowance` by `amount`.
648     @param sender The address shares are being transferred from.
649     @param receiver
650         The address shares are being transferred to. Must not be this contract's
651         address, must not be 0x0.
652     @param amount The quantity of shares to transfer.
653     @return
654         True if transfer is sent to an address other than this contract's or
655         0x0, otherwise the transaction will fail.
656     """
657     # Unlimited approval (saves an SSTORE)
658     if (self.allowance[sender][msg.sender] < MAX_UINT256):
659         allowance: uint256 = self.allowance[sender][msg.sender] - amount
660         self.allowance[sender][msg.sender] = allowance
661         # NOTE: Allows log filters to have a full accounting of allowance changes
662         log Approval(sender, msg.sender, allowance)
663     self._transfer(sender, receiver, amount)
664     return True
665 
666 
667 @external
668 def approve(spender: address, amount: uint256) -> bool:
669     """
670     @dev Approve the passed address to spend the specified amount of tokens on behalf of
671          `msg.sender`. Beware that changing an allowance with this method brings the risk
672          that someone may use both the old and the new allowance by unfortunate transaction
673          ordering. See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
674     @param spender The address which will spend the funds.
675     @param amount The amount of tokens to be spent.
676     """
677     self.allowance[msg.sender][spender] = amount
678     log Approval(msg.sender, spender, amount)
679     return True
680 
681 
682 @external
683 def increaseAllowance(spender: address, amount: uint256) -> bool:
684     """
685     @dev Increase the allowance of the passed address to spend the total amount of tokens
686          on behalf of msg.sender. This method mitigates the risk that someone may use both
687          the old and the new allowance by unfortunate transaction ordering.
688          See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
689     @param spender The address which will spend the funds.
690     @param amount The amount of tokens to increase the allowance by.
691     """
692     self.allowance[msg.sender][spender] += amount
693     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
694     return True
695 
696 
697 @external
698 def decreaseAllowance(spender: address, amount: uint256) -> bool:
699     """
700     @dev Decrease the allowance of the passed address to spend the total amount of tokens
701          on behalf of msg.sender. This method mitigates the risk that someone may use both
702          the old and the new allowance by unfortunate transaction ordering.
703          See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
704     @param spender The address which will spend the funds.
705     @param amount The amount of tokens to decrease the allowance by.
706     """
707     self.allowance[msg.sender][spender] -= amount
708     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
709     return True
710 
711 
712 @external
713 def permit(owner: address, spender: address, amount: uint256, expiry: uint256, signature: Bytes[65]) -> bool:
714     """
715     @notice
716         Approves spender by owner's signature to expend owner's tokens.
717         See https://eips.ethereum.org/EIPS/eip-2612.
718 
719     @param owner The address which is a source of funds and has signed the Permit.
720     @param spender The address which is allowed to spend the funds.
721     @param amount The amount of tokens to be spent.
722     @param expiry The timestamp after which the Permit is no longer valid.
723     @param signature A valid secp256k1 signature of Permit by owner encoded as r, s, v.
724     @return True, if transaction completes successfully
725     """
726     assert owner != ZERO_ADDRESS  # dev: invalid owner
727     assert expiry == 0 or expiry >= block.timestamp  # dev: permit expired
728     nonce: uint256 = self.nonces[owner]
729     digest: bytes32 = keccak256(
730         concat(
731             b'\x19\x01',
732             self.DOMAIN_SEPARATOR,
733             keccak256(
734                 concat(
735                     PERMIT_TYPE_HASH,
736                     convert(owner, bytes32),
737                     convert(spender, bytes32),
738                     convert(amount, bytes32),
739                     convert(nonce, bytes32),
740                     convert(expiry, bytes32),
741                 )
742             )
743         )
744     )
745     # NOTE: signature is packed as r, s, v
746     r: uint256 = convert(slice(signature, 0, 32), uint256)
747     s: uint256 = convert(slice(signature, 32, 32), uint256)
748     v: uint256 = convert(slice(signature, 64, 1), uint256)
749     assert ecrecover(digest, v, r, s) == owner  # dev: invalid signature
750     self.allowance[owner][spender] = amount
751     self.nonces[owner] = nonce + 1
752     log Approval(owner, spender, amount)
753     return True
754 
755 
756 @view
757 @internal
758 def _totalAssets() -> uint256:
759     # See note on `totalAssets()`.
760     return self.token.balanceOf(self) + self.totalDebt
761 
762 
763 @view
764 @external
765 def totalAssets() -> uint256:
766     """
767     @notice
768         Returns the total quantity of all assets under control of this
769         Vault, whether they're loaned out to a Strategy, or currently held in
770         the Vault.
771     @return The total assets under control of this Vault.
772     """
773     return self._totalAssets()
774 
775 
776 @internal
777 def _issueSharesForAmount(to: address, amount: uint256) -> uint256:
778     # Issues `amount` Vault shares to `to`.
779     # Shares must be issued prior to taking on new collateral, or
780     # calculation will be wrong. This means that only *trusted* tokens
781     # (with no capability for exploitative behavior) can be used.
782     shares: uint256 = 0
783     # HACK: Saves 2 SLOADs (~4000 gas)
784     totalSupply: uint256 = self.totalSupply
785     if totalSupply > 0:
786         # Mint amount of shares based on what the Vault is managing overall
787         # NOTE: if sqrt(token.totalSupply()) > 1e39, this could potentially revert
788         shares = amount * totalSupply / self._totalAssets()
789     else:
790         # No existing shares, so mint 1:1
791         shares = amount
792 
793     # Mint new shares
794     self.totalSupply = totalSupply + shares
795     self.balanceOf[to] += shares
796     log Transfer(ZERO_ADDRESS, to, shares)
797 
798     return shares
799 
800 
801 @external
802 @nonreentrant("withdraw")
803 def deposit(_amount: uint256 = MAX_UINT256, recipient: address = msg.sender) -> uint256:
804     """
805     @notice
806         Deposits `_amount` `token`, issuing shares to `recipient`. If the
807         Vault is in Emergency Shutdown, deposits will not be accepted and this
808         call will fail.
809     @dev
810         Measuring quantity of shares to issues is based on the total
811         outstanding debt that this contract has ("expected value") instead
812         of the total balance sheet it has ("estimated value") has important
813         security considerations, and is done intentionally. If this value were
814         measured against external systems, it could be purposely manipulated by
815         an attacker to withdraw more assets than they otherwise should be able
816         to claim by redeeming their shares.
817 
818         On deposit, this means that shares are issued against the total amount
819         that the deposited capital can be given in service of the debt that
820         Strategies assume. If that number were to be lower than the "expected
821         value" at some future point, depositing shares via this method could
822         entitle the depositor to *less* than the deposited value once the
823         "realized value" is updated from further reports by the Strategies
824         to the Vaults.
825 
826         Care should be taken by integrators to account for this discrepancy,
827         by using the view-only methods of this contract (both off-chain and
828         on-chain) to determine if depositing into the Vault is a "good idea".
829     @param _amount The quantity of tokens to deposit, defaults to all.
830     @param recipient
831         The address to issue the shares in this Vault to. Defaults to the
832         caller's address.
833     @return The issued Vault shares.
834     """
835     assert not self.emergencyShutdown  # Deposits are locked out
836 
837     amount: uint256 = _amount
838 
839     # If _amount not specified, transfer the full token balance,
840     # up to deposit limit
841     if amount == MAX_UINT256:
842         amount = min(
843             self.depositLimit - self._totalAssets(),
844             self.token.balanceOf(msg.sender),
845         )
846     else:
847         # Ensure deposit limit is respected
848         assert self._totalAssets() + amount <= self.depositLimit
849 
850     # Ensure we are depositing something
851     assert amount > 0
852 
853     # Ensure deposit is permitted by guest list
854     if self.guestList.address != ZERO_ADDRESS:
855         assert self.guestList.authorized(msg.sender, amount)
856 
857     # Issue new shares (needs to be done before taking deposit to be accurate)
858     # Shares are issued to recipient (may be different from msg.sender)
859     # See @dev note, above.
860     shares: uint256 = self._issueSharesForAmount(recipient, amount)
861 
862     # Tokens are transferred from msg.sender (may be different from _recipient)
863     self.erc20_safe_transferFrom(self.token.address, msg.sender, self, amount)
864 
865     return shares  # Just in case someone wants them
866 
867 
868 @view
869 @internal
870 def _shareValue(shares: uint256) -> uint256:
871     # Determines the current value of `shares`.
872         # NOTE: if sqrt(Vault.totalAssets()) >>> 1e39, this could potentially revert
873     lockedFundsRatio: uint256 = (block.timestamp - self.lastReport) * self.lockedProfitDegration
874     freeFunds: uint256 = self._totalAssets()
875 
876     if(lockedFundsRatio < DEGREDATION_COEFFICIENT):
877         freeFunds -= (self.lockedProfit - (lockedFundsRatio * self.lockedProfit / DEGREDATION_COEFFICIENT))
878     # NOTE: using 1e3 for extra precision here, when decimals is low
879     return ((10 ** 3 * (shares * freeFunds)) / self.totalSupply) / 10 ** 3
880 
881     
882 @view
883 @internal
884 def _sharesForAmount(amount: uint256) -> uint256:
885     # Determines how many shares `amount` of token would receive.
886     # See dev note on `deposit`.
887     if self._totalAssets() > 0:
888         # NOTE: if sqrt(token.totalSupply()) > 1e37, this could potentially revert
889         return ((10 ** 3 * (amount * self.totalSupply)) / self._totalAssets()) / 10 ** 3
890     else:
891         return 0
892 
893 
894 @view
895 @external
896 def maxAvailableShares() -> uint256:
897     """
898     @notice
899         Determines the maximum quantity of shares this Vault can facilitate a
900         withdrawal for, factoring in assets currently residing in the Vault,
901         as well as those deployed to strategies on the Vault's balance sheet.
902     @dev
903         Regarding how shares are calculated, see dev note on `deposit`.
904 
905         If you want to calculated the maximum a user could withdraw up to,
906         you want to use this function.
907 
908         Note that the amount provided by this function is the theoretical
909         maximum possible from withdrawing, the real amount depends on the
910         realized losses incurred during withdrawal.
911     @return The total quantity of shares this Vault can provide.
912     """
913     shares: uint256 = self._sharesForAmount(self.token.balanceOf(self))
914 
915     for strategy in self.withdrawalQueue:
916         if strategy == ZERO_ADDRESS:
917             break
918         shares += self._sharesForAmount(self.strategies[strategy].totalDebt)
919 
920     return shares
921 
922 
923 @external
924 @nonreentrant("withdraw")
925 def withdraw(
926     maxShares: uint256 = MAX_UINT256,
927     recipient: address = msg.sender,
928     maxLoss: uint256 = 1,  # 0.01% [BPS]
929 ) -> uint256:
930     """
931     @notice
932         Withdraws the calling account's tokens from this Vault, redeeming
933         amount `_shares` for an appropriate amount of tokens.
934 
935         See note on `setWithdrawalQueue` for further details of withdrawal
936         ordering and behavior.
937     @dev
938         Measuring the value of shares is based on the total outstanding debt
939         that this contract has ("expected value") instead of the total balance
940         sheet it has ("estimated value") has important security considerations,
941         and is done intentionally. If this value were measured against external
942         systems, it could be purposely manipulated by an attacker to withdraw
943         more assets than they otherwise should be able to claim by redeeming
944         their shares.
945 
946         On withdrawal, this means that shares are redeemed against the total
947         amount that the deposited capital had "realized" since the point it
948         was deposited, up until the point it was withdrawn. If that number
949         were to be higher than the "expected value" at some future point,
950         withdrawing shares via this method could entitle the depositor to
951         *more* than the expected value once the "realized value" is updated
952         from further reports by the Strategies to the Vaults.
953 
954         Under exceptional scenarios, this could cause earlier withdrawals to
955         earn "more" of the underlying assets than Users might otherwise be
956         entitled to, if the Vault's estimated value were otherwise measured
957         through external means, accounting for whatever exceptional scenarios
958         exist for the Vault (that aren't covered by the Vault's own design.)
959     @param maxShares
960         How many shares to try and redeem for tokens, defaults to all.
961     @param recipient
962         The address to issue the shares in this Vault to. Defaults to the
963         caller's address.
964     @param maxLoss
965         The maximum acceptable loss to sustain on withdrawal. Defaults to 0.01%.
966     @return The quantity of tokens redeemed for `_shares`.
967     """
968     shares: uint256 = maxShares  # May reduce this number below
969 
970     # If _shares not specified, transfer full share balance
971     if shares == MAX_UINT256:
972         shares = self.balanceOf[msg.sender]
973 
974     # Limit to only the shares they own
975     assert shares <= self.balanceOf[msg.sender]
976 
977     # See @dev note, above.
978     value: uint256 = self._shareValue(shares)
979 
980     totalLoss: uint256 = 0
981     if value > self.token.balanceOf(self):
982         # We need to go get some from our strategies in the withdrawal queue
983         # NOTE: This performs forced withdrawals from each Strategy. During
984         #       forced withdrawal, a Strategy may realize a loss. That loss
985         #       is reported back to the Vault, and the will affect the amount
986         #       of tokens that the withdrawer receives for their shares. They
987         #       can optionally specify the maximum acceptable loss (in BPS)
988         #       to prevent excessive losses on their withdrawals (which may
989         #       happen in certain edge cases where Strategies realize a loss)
990         for strategy in self.withdrawalQueue:
991             if strategy == ZERO_ADDRESS:
992                 break  # We've exhausted the queue
993 
994             vault_balance: uint256 = self.token.balanceOf(self)
995             if value <= vault_balance:
996                 break  # We're done withdrawing
997 
998             amountNeeded: uint256 = value - vault_balance
999 
1000             # NOTE: Don't withdraw more than the debt so that Strategy can still
1001             #       continue to work based on the profits it has
1002             # NOTE: This means that user will lose out on any profits that each
1003             #       Strategy in the queue would return on next harvest, benefiting others
1004             amountNeeded = min(amountNeeded, self.strategies[strategy].totalDebt)
1005             if amountNeeded == 0:
1006                 continue  # Nothing to withdraw from this Strategy, try the next one
1007 
1008             # Force withdraw amount from each Strategy in the order set by governance
1009             loss: uint256 = Strategy(strategy).withdraw(amountNeeded)
1010             withdrawn: uint256 = self.token.balanceOf(self) - vault_balance
1011 
1012             # NOTE: Withdrawer incurs any losses from liquidation
1013             if loss > 0:
1014                 value -= loss
1015                 totalLoss += loss
1016                 self.strategies[strategy].totalLoss += loss
1017 
1018             # Reduce the Strategy's debt by the amount withdrawn ("realized returns")
1019             # NOTE: This doesn't add to returns as it's not earned by "normal means"
1020             self.strategies[strategy].totalDebt -= withdrawn + loss
1021             self.totalDebt -= withdrawn + loss
1022 
1023     # NOTE: We have withdrawn everything possible out of the withdrawal queue
1024     #       but we still don't have enough to fully pay them back, so adjust
1025     #       to the total amount we've freed up through forced withdrawals
1026     vault_balance: uint256 = self.token.balanceOf(self)
1027     if value > vault_balance:
1028         value = vault_balance
1029         # NOTE: Burn # of shares that corresponds to what Vault has on-hand,
1030         #       including the losses that were incurred above during withdrawals
1031         shares = self._sharesForAmount(value + totalLoss)
1032 
1033     # NOTE: This loss protection is put in place to revert if losses from
1034     #       withdrawing are more than what is considered acceptable.
1035     assert totalLoss <= maxLoss * (value + totalLoss) / MAX_BPS
1036 
1037     # Burn shares (full value of what is being withdrawn)
1038     self.totalSupply -= shares
1039     self.balanceOf[msg.sender] -= shares
1040     log Transfer(msg.sender, ZERO_ADDRESS, shares)
1041 
1042     # Withdraw remaining balance to _recipient (may be different to msg.sender) (minus fee)
1043     self.erc20_safe_transfer(self.token.address, recipient, value)
1044 
1045     return value
1046 
1047 
1048 @view
1049 @external
1050 def pricePerShare() -> uint256:
1051     """
1052     @notice Gives the price for a single Vault share.
1053     @dev See dev note on `withdraw`.
1054     @return The value of a single share.
1055     """
1056     if self.totalSupply == 0:
1057         return 10 ** self.decimals  # price of 1:1
1058     else:
1059         return self._shareValue(10 ** self.decimals)
1060 
1061 
1062 @internal
1063 def _organizeWithdrawalQueue():
1064     # Reorganize `withdrawalQueue` based on premise that if there is an
1065     # empty value between two actual values, then the empty value should be
1066     # replaced by the later value.
1067     # NOTE: Relative ordering of non-zero values is maintained.
1068     offset: uint256 = 0
1069     for idx in range(MAXIMUM_STRATEGIES):
1070         strategy: address = self.withdrawalQueue[idx]
1071         if strategy == ZERO_ADDRESS:
1072             offset += 1  # how many values we need to shift, always `<= idx`
1073         elif offset > 0:
1074             self.withdrawalQueue[idx - offset] = strategy
1075             self.withdrawalQueue[idx] = ZERO_ADDRESS
1076 
1077 
1078 @external
1079 def addStrategy(
1080     strategy: address,
1081     debtRatio: uint256,
1082     minDebtPerHarvest: uint256,
1083     maxDebtPerHarvest: uint256,
1084     performanceFee: uint256,
1085 ):
1086     """
1087     @notice
1088         Add a Strategy to the Vault.
1089 
1090         This may only be called by governance.
1091     @dev
1092         The Strategy will be appended to `withdrawalQueue`, call
1093         `setWithdrawalQueue` to change the order.
1094     @param strategy The address of the Strategy to add.
1095     @param debtRatio
1096         The share of the total assets in the `vault that the `strategy` has access to.
1097     @param minDebtPerHarvest
1098         Lower limit on the increase of debt since last harvest
1099     @param maxDebtPerHarvest
1100         Upper limit on the increase of debt since last harvest
1101     @param performanceFee
1102         The fee the strategist will receive based on this Vault's performance.
1103     """
1104     # Check if queue is full
1105     assert self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] == ZERO_ADDRESS
1106 
1107     # Check calling conditions
1108     assert not self.emergencyShutdown
1109     assert msg.sender == self.governance
1110 
1111     # Check strategy configuration
1112     assert strategy != ZERO_ADDRESS
1113     assert self.strategies[strategy].activation == 0
1114     assert self == Strategy(strategy).vault()
1115     assert self.token.address == Strategy(strategy).want()
1116 
1117     # Check strategy parameters
1118     assert self.debtRatio + debtRatio <= MAX_BPS
1119     assert minDebtPerHarvest <= maxDebtPerHarvest
1120     assert performanceFee <= MAX_BPS - self.performanceFee
1121 
1122     # Add strategy to approved strategies
1123     self.strategies[strategy] = StrategyParams({
1124         performanceFee: performanceFee,
1125         activation: block.timestamp,
1126         debtRatio: debtRatio,
1127         minDebtPerHarvest: minDebtPerHarvest,
1128         maxDebtPerHarvest: maxDebtPerHarvest,
1129         lastReport: block.timestamp,
1130         totalDebt: 0,
1131         totalGain: 0,
1132         totalLoss: 0,
1133     })
1134     log StrategyAdded(strategy, debtRatio, minDebtPerHarvest, maxDebtPerHarvest, performanceFee)
1135 
1136     # Update Vault parameters
1137     self.debtRatio += debtRatio
1138 
1139     # Add strategy to the end of the withdrawal queue
1140     self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] = strategy
1141     self._organizeWithdrawalQueue()
1142 
1143 
1144 @external
1145 def updateStrategyDebtRatio(
1146     strategy: address,
1147     debtRatio: uint256,
1148 ):
1149     """
1150     @notice
1151         Change the quantity of assets `strategy` may manage.
1152 
1153         This may be called by governance or management.
1154     @param strategy The Strategy to update.
1155     @param debtRatio The quantity of assets `strategy` may now manage.
1156     """
1157     assert msg.sender in [self.management, self.governance]
1158     assert self.strategies[strategy].activation > 0
1159     self.debtRatio -= self.strategies[strategy].debtRatio
1160     self.strategies[strategy].debtRatio = debtRatio
1161     self.debtRatio += debtRatio
1162     assert self.debtRatio <= MAX_BPS
1163     log StrategyUpdateDebtRatio(strategy, debtRatio)
1164 
1165 
1166 @external
1167 def updateStrategyMinDebtPerHarvest(
1168     strategy: address,
1169     minDebtPerHarvest: uint256,
1170 ):
1171     """
1172     @notice
1173         Change the quantity assets per block this Vault may deposit to or
1174         withdraw from `strategy`.
1175 
1176         This may only be called by governance or management.
1177     @param strategy The Strategy to update.
1178     @param minDebtPerHarvest
1179         Lower limit on the increase of debt since last harvest
1180     """
1181     assert msg.sender in [self.management, self.governance]
1182     assert self.strategies[strategy].activation > 0
1183     assert self.strategies[strategy].maxDebtPerHarvest >= minDebtPerHarvest
1184     self.strategies[strategy].minDebtPerHarvest = minDebtPerHarvest
1185     log StrategyUpdateMinDebtPerHarvest(strategy, minDebtPerHarvest)
1186 
1187 
1188 @external
1189 def updateStrategyMaxDebtPerHarvest(
1190     strategy: address,
1191     maxDebtPerHarvest: uint256,
1192 ):
1193     """
1194     @notice
1195         Change the quantity assets per block this Vault may deposit to or
1196         withdraw from `strategy`.
1197 
1198         This may only be called by governance or management.
1199     @param strategy The Strategy to update.
1200     @param maxDebtPerHarvest
1201         Upper limit on the increase of debt since last harvest
1202     """
1203     assert msg.sender in [self.management, self.governance]
1204     assert self.strategies[strategy].activation > 0
1205     assert self.strategies[strategy].minDebtPerHarvest <= maxDebtPerHarvest
1206     self.strategies[strategy].maxDebtPerHarvest = maxDebtPerHarvest
1207     log StrategyUpdateMaxDebtPerHarvest(strategy, maxDebtPerHarvest)
1208 
1209 
1210 @external
1211 def updateStrategyPerformanceFee(
1212     strategy: address,
1213     performanceFee: uint256,
1214 ):
1215     """
1216     @notice
1217         Change the fee the strategist will receive based on this Vault's
1218         performance.
1219 
1220         This may only be called by governance.
1221     @param strategy The Strategy to update.
1222     @param performanceFee The new fee the strategist will receive.
1223     """
1224     assert msg.sender == self.governance
1225     assert performanceFee <= MAX_BPS - self.performanceFee
1226     assert self.strategies[strategy].activation > 0
1227     self.strategies[strategy].performanceFee = performanceFee
1228     log StrategyUpdatePerformanceFee(strategy, performanceFee)
1229 
1230 
1231 @internal
1232 def _revokeStrategy(strategy: address):
1233     self.debtRatio -= self.strategies[strategy].debtRatio
1234     self.strategies[strategy].debtRatio = 0
1235     log StrategyRevoked(strategy)
1236 
1237 
1238 @external
1239 def migrateStrategy(oldVersion: address, newVersion: address):
1240     """
1241     @notice
1242         Migrates a Strategy, including all assets from `oldVersion` to
1243         `newVersion`.
1244 
1245         This may only be called by governance.
1246     @dev
1247         Strategy must successfully migrate all capital and positions to new
1248         Strategy, or else this will upset the balance of the Vault.
1249 
1250         The new Strategy should be "empty" e.g. have no prior commitments to
1251         this Vault, otherwise it could have issues.
1252     @param oldVersion The existing Strategy to migrate from.
1253     @param newVersion The new Strategy to migrate to.
1254     """
1255     assert msg.sender == self.governance
1256     assert newVersion != ZERO_ADDRESS
1257     assert self.strategies[oldVersion].activation > 0
1258     assert self.strategies[newVersion].activation == 0
1259 
1260     strategy: StrategyParams = self.strategies[oldVersion]
1261 
1262     self._revokeStrategy(oldVersion)
1263     # _revokeStrategy will lower the debtRatio
1264     self.debtRatio += strategy.debtRatio
1265     # Debt is migrated to new strategy
1266     self.strategies[oldVersion].totalDebt = 0
1267 
1268     self.strategies[newVersion] = StrategyParams({
1269         performanceFee: strategy.performanceFee,
1270         # NOTE: use last report for activation time, so E[R] calc works
1271         activation: strategy.lastReport,
1272         debtRatio: strategy.debtRatio,
1273         minDebtPerHarvest: strategy.minDebtPerHarvest,
1274         maxDebtPerHarvest: strategy.maxDebtPerHarvest,
1275         lastReport: strategy.lastReport,
1276         totalDebt: strategy.totalDebt,
1277         totalGain: 0,
1278         totalLoss: 0,
1279     })
1280 
1281     Strategy(oldVersion).migrate(newVersion)
1282     log StrategyMigrated(oldVersion, newVersion)
1283 
1284     for idx in range(MAXIMUM_STRATEGIES):
1285         if self.withdrawalQueue[idx] == oldVersion:
1286             self.withdrawalQueue[idx] = newVersion
1287             return  # Don't need to reorder anything because we swapped
1288 
1289 
1290 @external
1291 def revokeStrategy(strategy: address = msg.sender):
1292     """
1293     @notice
1294         Revoke a Strategy, setting its debt limit to 0 and preventing any
1295         future deposits.
1296 
1297         This function should only be used in the scenario where the Strategy is
1298         being retired but no migration of the positions are possible, or in the
1299         extreme scenario that the Strategy needs to be put into "Emergency Exit"
1300         mode in order for it to exit as quickly as possible. The latter scenario
1301         could be for any reason that is considered "critical" that the Strategy
1302         exits its position as fast as possible, such as a sudden change in market
1303         conditions leading to losses, or an imminent failure in an external
1304         dependency.
1305 
1306         This may only be called by governance, the guardian, or the Strategy
1307         itself. Note that a Strategy will only revoke itself during emergency
1308         shutdown.
1309     @param strategy The Strategy to revoke.
1310     """
1311     assert msg.sender in [strategy, self.governance, self.guardian]
1312     self._revokeStrategy(strategy)
1313 
1314 
1315 @external
1316 def addStrategyToQueue(strategy: address):
1317     """
1318     @notice
1319         Adds `strategy` to `withdrawalQueue`.
1320 
1321         This may only be called by governance or management.
1322     @dev
1323         The Strategy will be appended to `withdrawalQueue`, call
1324         `setWithdrawalQueue` to change the order.
1325     @param strategy The Strategy to add.
1326     """
1327     assert msg.sender in [self.management, self.governance]
1328     # Must be a current Strategy
1329     assert self.strategies[strategy].activation > 0
1330     # Check if queue is full
1331     assert self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] == ZERO_ADDRESS
1332     # Can't already be in the queue
1333     for s in self.withdrawalQueue:
1334         if strategy == ZERO_ADDRESS:
1335             break
1336         assert s != strategy
1337     self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] = strategy
1338     self._organizeWithdrawalQueue()
1339     log StrategyAddedToQueue(strategy)
1340 
1341 
1342 @external
1343 def removeStrategyFromQueue(strategy: address):
1344     """
1345     @notice
1346         Remove `strategy` from `withdrawalQueue`.
1347 
1348         This may only be called by governance or management.
1349     @dev
1350         We don't do this with revokeStrategy because it should still
1351         be possible to withdraw from the Strategy if it's unwinding.
1352     @param strategy The Strategy to remove.
1353     """
1354     assert msg.sender in [self.management, self.governance]
1355     for idx in range(MAXIMUM_STRATEGIES):
1356         if self.withdrawalQueue[idx] == strategy:
1357             self.withdrawalQueue[idx] = ZERO_ADDRESS
1358             self._organizeWithdrawalQueue()
1359             log StrategyRemovedFromQueue(strategy)
1360             return  # We found the right location and cleared it
1361     raise  # We didn't find the Strategy in the queue
1362 
1363 
1364 @view
1365 @internal
1366 def _debtOutstanding(strategy: address) -> uint256:
1367     # See note on `debtOutstanding()`.
1368     strategy_debtLimit: uint256 = self.strategies[strategy].debtRatio * self._totalAssets() / MAX_BPS
1369     strategy_totalDebt: uint256 = self.strategies[strategy].totalDebt
1370 
1371     if self.emergencyShutdown:
1372         return strategy_totalDebt
1373     elif strategy_totalDebt <= strategy_debtLimit:
1374         return 0
1375     else:
1376         return strategy_totalDebt - strategy_debtLimit
1377 
1378 
1379 @view
1380 @external
1381 def debtOutstanding(strategy: address = msg.sender) -> uint256:
1382     """
1383     @notice
1384         Determines if `strategy` is past its debt limit and if any tokens
1385         should be withdrawn to the Vault.
1386     @param strategy The Strategy to check. Defaults to the caller.
1387     @return The quantity of tokens to withdraw.
1388     """
1389     return self._debtOutstanding(strategy)
1390 
1391 
1392 @view
1393 @internal
1394 def _creditAvailable(strategy: address) -> uint256:
1395     # See note on `creditAvailable()`.
1396     if self.emergencyShutdown:
1397         return 0
1398 
1399     vault_totalAssets: uint256 = self._totalAssets()
1400     vault_debtLimit: uint256 = self.debtRatio * vault_totalAssets / MAX_BPS
1401     vault_totalDebt: uint256 = self.totalDebt
1402     strategy_debtLimit: uint256 = self.strategies[strategy].debtRatio * vault_totalAssets / MAX_BPS
1403     strategy_totalDebt: uint256 = self.strategies[strategy].totalDebt
1404     strategy_minDebtPerHarvest: uint256 = self.strategies[strategy].minDebtPerHarvest
1405     strategy_maxDebtPerHarvest: uint256 = self.strategies[strategy].maxDebtPerHarvest
1406 
1407     # Exhausted credit line
1408     if strategy_debtLimit <= strategy_totalDebt or vault_debtLimit <= vault_totalDebt:
1409         return 0
1410 
1411     # Start with debt limit left for the Strategy
1412     available: uint256 = strategy_debtLimit - strategy_totalDebt
1413 
1414     # Adjust by the global debt limit left
1415     available = min(available, vault_debtLimit - vault_totalDebt)
1416 
1417     # Can only borrow up to what the contract has in reserve
1418     # NOTE: Running near 100% is discouraged
1419     available = min(available, self.token.balanceOf(self))
1420 
1421     # Adjust by min and max borrow limits (per harvest)
1422     # NOTE: min increase can be used to ensure that if a strategy has a minimum
1423     #       amount of capital needed to purchase a position, it's not given capital
1424     #       it can't make use of yet.
1425     # NOTE: max increase is used to make sure each harvest isn't bigger than what
1426     #       is authorized. This combined with adjusting min and max periods in
1427     #       `BaseStrategy` can be used to effect a "rate limit" on capital increase.
1428     if available < strategy_minDebtPerHarvest:
1429         return 0
1430     else:
1431         return min(available, strategy_maxDebtPerHarvest)
1432 
1433 @view
1434 @external
1435 def creditAvailable(strategy: address = msg.sender) -> uint256:
1436     """
1437     @notice
1438         Amount of tokens in Vault a Strategy has access to as a credit line.
1439 
1440         This will check the Strategy's debt limit, as well as the tokens
1441         available in the Vault, and determine the maximum amount of tokens
1442         (if any) the Strategy may draw on.
1443 
1444         In the rare case the Vault is in emergency shutdown this will return 0.
1445     @param strategy The Strategy to check. Defaults to caller.
1446     @return The quantity of tokens available for the Strategy to draw on.
1447     """
1448     return self._creditAvailable(strategy)
1449 
1450 
1451 @view
1452 @internal
1453 def _expectedReturn(strategy: address) -> uint256:
1454     # See note on `expectedReturn()`.
1455     strategy_lastReport: uint256 = self.strategies[strategy].lastReport
1456     timeSinceLastHarvest: uint256 = block.timestamp - strategy_lastReport
1457     totalHarvestTime: uint256 = strategy_lastReport - self.strategies[strategy].activation
1458 
1459     # NOTE: If either `timeSinceLastHarvest` or `totalHarvestTime` is 0, we can short-circuit to `0`
1460     if timeSinceLastHarvest > 0 and totalHarvestTime > 0 and Strategy(strategy).isActive():
1461         # NOTE: Unlikely to throw unless strategy accumalates >1e68 returns
1462         # NOTE: Calculate average over period of time where harvests have occured in the past
1463         return (self.strategies[strategy].totalGain * timeSinceLastHarvest) / totalHarvestTime
1464     else:
1465         return 0  # Covers the scenario when block.timestamp == activation
1466 
1467 
1468 @view
1469 @external
1470 def availableDepositLimit() -> uint256:
1471     if self.depositLimit > self._totalAssets():
1472         return self.depositLimit - self._totalAssets()
1473     else:
1474         return 0
1475 
1476 
1477 @view
1478 @external
1479 def expectedReturn(strategy: address = msg.sender) -> uint256:
1480     """
1481     @notice
1482         Provide an accurate expected value for the return this `strategy`
1483         would provide to the Vault the next time `report()` is called
1484         (since the last time it was called).
1485     @param strategy The Strategy to determine the expected return for. Defaults to caller.
1486     @return
1487         The anticipated amount `strategy` should make on its investment
1488         since its last report.
1489     """
1490     return self._expectedReturn(strategy)
1491 
1492 
1493 @internal
1494 def _reportLoss(strategy: address, loss: uint256):
1495     # Loss can only be up the amount of debt issued to strategy
1496     totalDebt: uint256 = self.strategies[strategy].totalDebt
1497     assert totalDebt >= loss
1498     self.strategies[strategy].totalLoss += loss
1499     self.strategies[strategy].totalDebt = totalDebt - loss
1500     self.totalDebt -= loss
1501 
1502     # Also, make sure we reduce our trust with the strategy by the same amount
1503     debtRatio: uint256 = self.strategies[strategy].debtRatio
1504     ratio_change: uint256 = min(loss * MAX_BPS / self._totalAssets(), debtRatio)
1505     self.strategies[strategy].debtRatio -= ratio_change 
1506     self.debtRatio -= ratio_change
1507 
1508 @internal
1509 def _assessFees(strategy: address, gain: uint256):
1510     # Issue new shares to cover fees
1511     # NOTE: In effect, this reduces overall share price by the combined fee
1512     # NOTE: may throw if Vault.totalAssets() > 1e64, or not called for more than a year
1513     governance_fee: uint256 = (
1514         (self.totalDebt * (block.timestamp - self.lastReport) * self.managementFee)
1515         / MAX_BPS
1516         / SECS_PER_YEAR
1517     )
1518     strategist_fee: uint256 = 0  # Only applies in certain conditions
1519 
1520     # NOTE: Applies if Strategy is not shutting down, or it is but all debt paid off
1521     # NOTE: No fee is taken when a Strategy is unwinding it's position, until all debt is paid
1522     if gain > 0:
1523         # NOTE: Unlikely to throw unless strategy reports >1e72 harvest profit
1524         strategist_fee = (
1525             gain * self.strategies[strategy].performanceFee
1526         ) / MAX_BPS
1527         # NOTE: Unlikely to throw unless strategy reports >1e72 harvest profit
1528         governance_fee += gain * self.performanceFee / MAX_BPS
1529 
1530     # NOTE: This must be called prior to taking new collateral,
1531     #       or the calculation will be wrong!
1532     # NOTE: This must be done at the same time, to ensure the relative
1533     #       ratio of governance_fee : strategist_fee is kept intact
1534     total_fee: uint256 = governance_fee + strategist_fee
1535     if total_fee > 0:  # NOTE: If mgmt fee is 0% and no gains were realized, skip
1536         reward: uint256 = self._issueSharesForAmount(self, total_fee)
1537 
1538         # Send the rewards out as new shares in this Vault
1539         if strategist_fee > 0:  # NOTE: Guard against DIV/0 fault
1540             # NOTE: Unlikely to throw unless sqrt(reward) >>> 1e39
1541             strategist_reward: uint256 = (strategist_fee * reward) / total_fee
1542             self._transfer(self, strategy, strategist_reward)
1543             # NOTE: Strategy distributes rewards at the end of harvest()
1544         # NOTE: Governance earns any dust leftover from flooring math above
1545         if self.balanceOf[self] > 0:
1546             self._transfer(self, self.rewards, self.balanceOf[self])
1547 
1548 
1549 @external
1550 def report(gain: uint256, loss: uint256, _debtPayment: uint256) -> uint256:
1551     """
1552     @notice
1553         Reports the amount of assets the calling Strategy has free (usually in
1554         terms of ROI).
1555 
1556         The performance fee is determined here, off of the strategy's profits
1557         (if any), and sent to governance.
1558 
1559         The strategist's fee is also determined here (off of profits), to be
1560         handled according to the strategist on the next harvest.
1561 
1562         This may only be called by a Strategy managed by this Vault.
1563     @dev
1564         For approved strategies, this is the most efficient behavior.
1565         The Strategy reports back what it has free, then Vault "decides"
1566         whether to take some back or give it more. Note that the most it can
1567         take is `gain + _debtPayment`, and the most it can give is all of the
1568         remaining reserves. Anything outside of those bounds is abnormal behavior.
1569 
1570         All approved strategies must have increased diligence around
1571         calling this function, as abnormal behavior could become catastrophic.
1572     @param gain
1573         Amount Strategy has realized as a gain on it's investment since its
1574         last report, and is free to be given back to Vault as earnings
1575     @param loss
1576         Amount Strategy has realized as a loss on it's investment since its
1577         last report, and should be accounted for on the Vault's balance sheet
1578     @param _debtPayment
1579         Amount Strategy has made available to cover outstanding debt
1580     @return Amount of debt outstanding (if totalDebt > debtLimit or emergency shutdown).
1581     """
1582 
1583     # Only approved strategies can call this function
1584     assert self.strategies[msg.sender].activation > 0
1585     # No lying about total available to withdraw!
1586     assert self.token.balanceOf(msg.sender) >= gain + _debtPayment
1587 
1588     # We have a loss to report, do it before the rest of the calculations
1589     if loss > 0:
1590         self._reportLoss(msg.sender, loss)
1591 
1592     # Assess both management fee and performance fee, and issue both as shares of the vault
1593     self._assessFees(msg.sender, gain)
1594 
1595     # Returns are always "realized gains"
1596     self.strategies[msg.sender].totalGain += gain
1597 
1598     # Outstanding debt the Strategy wants to take back from the Vault (if any)
1599     # NOTE: debtOutstanding <= StrategyParams.totalDebt
1600     debt: uint256 = self._debtOutstanding(msg.sender)
1601     debtPayment: uint256 = min(_debtPayment, debt)
1602 
1603     if debtPayment > 0:
1604         self.strategies[msg.sender].totalDebt -= debtPayment
1605         self.totalDebt -= debtPayment
1606         debt -= debtPayment
1607         # NOTE: `debt` is being tracked for later
1608 
1609     # Compute the line of credit the Vault is able to offer the Strategy (if any)
1610     credit: uint256 = self._creditAvailable(msg.sender)
1611 
1612     # Update the actual debt based on the full credit we are extending to the Strategy
1613     # or the returns if we are taking funds back
1614     # NOTE: credit + self.strategies[msg.sender].totalDebt is always < self.debtLimit
1615     # NOTE: At least one of `credit` or `debt` is always 0 (both can be 0)
1616     if credit > 0:
1617         self.strategies[msg.sender].totalDebt += credit
1618         self.totalDebt += credit
1619 
1620     # Give/take balance to Strategy, based on the difference between the reported gains
1621     # (if any), the debt payment (if any), the credit increase we are offering (if any),
1622     # and the debt needed to be paid off (if any)
1623     # NOTE: This is just used to adjust the balance of tokens between the Strategy and
1624     #       the Vault based on the Strategy's debt limit (as well as the Vault's).
1625     totalAvail: uint256 = gain + debtPayment
1626     if totalAvail < credit:  # credit surplus, give to Strategy
1627         self.erc20_safe_transfer(self.token.address, msg.sender, credit - totalAvail)
1628     elif totalAvail > credit:  # credit deficit, take from Strategy
1629         self.erc20_safe_transferFrom(self.token.address, msg.sender, self, totalAvail - credit)
1630     # else, don't do anything because it is balanced
1631 
1632     # Update reporting time
1633     self.strategies[msg.sender].lastReport = block.timestamp
1634     self.lastReport = block.timestamp
1635     self.lockedProfit = gain # profit is locked and gradually released per block
1636 
1637     log StrategyReported(
1638         msg.sender,
1639         gain,
1640         loss,
1641         debtPayment,
1642         self.strategies[msg.sender].totalGain,
1643         self.strategies[msg.sender].totalLoss,
1644         self.strategies[msg.sender].totalDebt,
1645         credit,
1646         self.strategies[msg.sender].debtRatio,
1647     )
1648 
1649     if self.strategies[msg.sender].debtRatio == 0 or self.emergencyShutdown:
1650         # Take every last penny the Strategy has (Emergency Exit/revokeStrategy)
1651         # NOTE: This is different than `debt` in order to extract *all* of the returns
1652         return Strategy(msg.sender).estimatedTotalAssets()
1653     else:
1654         # Otherwise, just return what we have as debt outstanding
1655         return debt
1656 
1657 
1658 @external
1659 def sweep(token: address, amount: uint256 = MAX_UINT256):
1660     """
1661     @notice
1662         Removes tokens from this Vault that are not the type of token managed
1663         by this Vault. This may be used in case of accidentally sending the
1664         wrong kind of token to this Vault.
1665 
1666         Tokens will be sent to `governance`.
1667 
1668         This will fail if an attempt is made to sweep the tokens that this
1669         Vault manages.
1670 
1671         This may only be called by governance.
1672     @param token The token to transfer out of this vault.
1673     @param amount The quantity or tokenId to transfer out.
1674     """
1675     assert msg.sender == self.governance
1676     # Can't be used to steal what this Vault is protecting
1677     assert token != self.token.address
1678     value: uint256 = amount
1679     if value == MAX_UINT256:
1680         value = ERC20(token).balanceOf(self)
1681     self.erc20_safe_transfer(token, self.governance, value)