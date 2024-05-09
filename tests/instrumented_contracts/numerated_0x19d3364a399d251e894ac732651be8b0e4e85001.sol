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
38 API_VERSION: constant(String[28]) = "0.3.0"
39 
40 # TODO: Add ETH Configuration
41 from vyper.interfaces import ERC20
42 
43 implements: ERC20
44 
45 
46 interface DetailedERC20:
47     def name() -> String[42]: view
48     def symbol() -> String[20]: view
49     def decimals() -> uint256: view
50 
51 
52 interface Strategy:
53     def want() -> address: view
54     def vault() -> address: view
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
95     rateLimit: uint256  # Limit on the increase of debt per unit time since last harvest
96     lastReport: uint256  # block.timestamp of the last time a report occured
97     totalDebt: uint256  # Total outstanding debt that Strategy has
98     totalGain: uint256  # Total returns that Strategy has realized for Vault
99     totalLoss: uint256  # Total losses that Strategy has realized for Vault
100 
101 
102 event StrategyAdded:
103     strategy: indexed(address)
104     debtRatio: uint256  # Maximum borrow amount (in BPS of total assets)
105     rateLimit: uint256  # Limit on the increase of debt per unit time since last harvest
106     performanceFee: uint256  # Strategist's fee (basis points)
107 
108 
109 event StrategyReported:
110     strategy: indexed(address)
111     gain: uint256
112     loss: uint256
113     totalGain: uint256
114     totalLoss: uint256
115     totalDebt: uint256
116     debtAdded: uint256
117     debtRatio: uint256
118 
119 
120 event UpdateGovernance:
121     governance: address # New active governance
122 
123 
124 event UpdateManagement:
125     management: address # New active manager
126 
127 
128 event UpdateGuestList:
129     guestList: address # Vault guest list address
130 
131 
132 event UpdateRewards:
133     rewards: address # New active rewards recipient
134 
135 
136 event UpdateDepositLimit:
137     depositLimit: uint256 # New active deposit limit
138 
139 
140 event UpdatePerformanceFee:
141     performanceFee: uint256 # New active performance fee
142 
143 
144 event UpdateManagementFee:
145     managementFee: uint256 # New active management fee
146 
147 
148 event UpdateGuardian:
149     guardian: address # Address of the active guardian
150 
151 
152 event EmergencyShutdown:
153     active: bool # New emergency shutdown state (if false, normal operation enabled)
154 
155 
156 event UpdateWithdrawalQueue:
157     queue: address[MAXIMUM_STRATEGIES] # New active withdrawal queue
158 
159 
160 event StrategyUpdateDebtRatio:
161     strategy: indexed(address) # Address of the strategy for the debt ratio adjustment
162     debtRatio: uint256 # The new debt limit for the strategy (in BPS of total assets)
163 
164 
165 event StrategyUpdateRateLimit:
166     strategy: indexed(address) # Address of the strategy for the rate limit adjustment
167     rateLimit: uint256 # The new rate limit for the strategy
168 
169 
170 event StrategyUpdatePerformanceFee:
171     strategy: indexed(address) # Address of the strategy for the performance fee adjustment
172     performanceFee: uint256 # The new performance fee for the strategy
173 
174 
175 event StrategyMigrated:
176     oldVersion: indexed(address) # Old version of the strategy to be migrated
177     newVersion: indexed(address) # New version of the strategy
178 
179 
180 event StrategyRevoked:
181     strategy: indexed(address) # Address of the strategy that is revoked
182 
183 
184 event StrategyRemovedFromQueue:
185     strategy: indexed(address) # Address of the strategy that is removed from the withdrawal queue
186 
187 
188 event StrategyAddedToQueue:
189     strategy: indexed(address) # Address of the strategy that is added to the withdrawal queue
190 
191 
192 
193 # NOTE: Track the total for overhead targeting purposes
194 strategies: public(HashMap[address, StrategyParams])
195 MAXIMUM_STRATEGIES: constant(uint256) = 20
196 
197 # Ordering that `withdraw` uses to determine which strategies to pull funds from
198 # NOTE: Does *NOT* have to match the ordering of all the current strategies that
199 #       exist, but it is recommended that it does or else withdrawal depth is
200 #       limited to only those inside the queue.
201 # NOTE: Ordering is determined by governance, and should be balanced according
202 #       to risk, slippage, and/or volatility. Can also be ordered to increase the
203 #       withdrawal speed of a particular Strategy.
204 # NOTE: The first time a ZERO_ADDRESS is encountered, it stops withdrawing
205 withdrawalQueue: public(address[MAXIMUM_STRATEGIES])
206 
207 emergencyShutdown: public(bool)
208 
209 depositLimit: public(uint256)  # Limit for totalAssets the Vault can hold
210 debtRatio: public(uint256)  # Debt ratio for the Vault across all strategies (in BPS, <= 10k)
211 totalDebt: public(uint256)  # Amount of tokens that all strategies have borrowed
212 lastReport: public(uint256)  # block.timestamp of last report
213 activation: public(uint256)  # block.timestamp of contract deployment
214 
215 rewards: public(address)  # Rewards contract where Governance fees are sent to
216 # Governance Fee for management of Vault (given to `rewards`)
217 managementFee: public(uint256)
218 # Governance Fee for performance of Vault (given to `rewards`)
219 performanceFee: public(uint256)
220 MAX_BPS: constant(uint256) = 10_000  # 100%, or 10k basis points
221 SECS_PER_YEAR: constant(uint256) = 31_557_600  # 365.25 days
222 # `nonces` track `permit` approvals with signature.
223 nonces: public(HashMap[address, uint256])
224 DOMAIN_SEPARATOR: public(bytes32)
225 DOMAIN_TYPE_HASH: constant(bytes32) = keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)')
226 PERMIT_TYPE_HASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
227 
228 
229 @external
230 def initialize(
231     token: address,
232     governance: address,
233     rewards: address,
234     nameOverride: String[64],
235     symbolOverride: String[32],
236     guardian: address = msg.sender,
237 ):
238     """
239     @notice
240         Initializes the Vault, this is called only once, when the contract is
241         deployed.
242         The performance fee is set to 10% of yield, per Strategy.
243         The management fee is set to 2%, per year.
244         The initial deposit limit is set to 0 (deposits disabled); it must be
245         updated after initialization.
246     @dev
247         If `nameOverride` is not specified, the name will be 'yearn'
248         combined with the name of `token`.
249 
250         If `symbolOverride` is not specified, the symbol will be 'y'
251         combined with the symbol of `token`.
252     @param token The token that may be deposited into this Vault.
253     @param governance The address authorized for governance interactions.
254     @param rewards The address to distribute rewards to.
255     @param nameOverride Specify a custom Vault name. Leave empty for default choice.
256     @param symbolOverride Specify a custom Vault symbol name. Leave empty for default choice.
257     @param guardian The address authorized for guardian interactions. Defaults to caller.
258     """
259     assert self.activation == 0  # dev: no devops199
260     self.token = ERC20(token)
261     if nameOverride == "":
262         self.name = concat(DetailedERC20(token).symbol(), " yVault")
263     else:
264         self.name = nameOverride
265     if symbolOverride == "":
266         self.symbol = concat("yv", DetailedERC20(token).symbol())
267     else:
268         self.symbol = symbolOverride
269     self.decimals = DetailedERC20(token).decimals()
270     self.governance = governance
271     log UpdateGovernance(governance)
272     self.management = governance
273     log UpdateManagement(governance)
274     self.rewards = rewards
275     log UpdateRewards(rewards)
276     self.guardian = guardian
277     log UpdateGuardian(guardian)
278     self.performanceFee = 1000  # 10% of yield (per Strategy)
279     log UpdatePerformanceFee(convert(1000, uint256))
280     self.managementFee = 200  # 2% per year
281     log UpdateManagementFee(convert(200, uint256))
282     self.lastReport = block.timestamp
283     self.activation = block.timestamp
284     # EIP-712
285     self.DOMAIN_SEPARATOR = keccak256(
286         concat(
287             DOMAIN_TYPE_HASH,
288             keccak256(convert("Yearn Vault", Bytes[11])),
289             keccak256(convert(API_VERSION, Bytes[28])),
290             convert(chain.id, bytes32),
291             convert(self, bytes32)
292         )
293     )
294 
295 
296 @pure
297 @external
298 def apiVersion() -> String[28]:
299     """
300     @notice
301         Used to track the deployed version of this contract. In practice you
302         can use this version number to compare with Yearn's GitHub and
303         determine which version of the source matches this deployed contract.
304     @dev
305         All strategies must have an `apiVersion()` that matches the Vault's
306         `API_VERSION`.
307     @return API_VERSION which holds the current version of this contract.
308     """
309     return API_VERSION
310 
311 
312 @external
313 def setName(name: String[42]):
314     """
315     @notice
316         Used to change the value of `name`.
317 
318         This may only be called by governance.
319     @param name The new name to use.
320     """
321     assert msg.sender == self.governance
322     self.name = name
323 
324 
325 @external
326 def setSymbol(symbol: String[20]):
327     """
328     @notice
329         Used to change the value of `symbol`.
330 
331         This may only be called by governance.
332     @param symbol The new symbol to use.
333     """
334     assert msg.sender == self.governance
335     self.symbol = symbol
336 
337 
338 # 2-phase commit for a change in governance
339 @external
340 def setGovernance(governance: address):
341     """
342     @notice
343         Nominate a new address to use as governance.
344 
345         The change does not go into effect immediately. This function sets a
346         pending change, and the governance address is not updated until
347         the proposed governance address has accepted the responsibility.
348 
349         This may only be called by the current governance address.
350     @param governance The address requested to take over Vault governance.
351     """
352     assert msg.sender == self.governance
353     self.pendingGovernance = governance
354 
355 
356 @external
357 def acceptGovernance():
358     """
359     @notice
360         Once a new governance address has been proposed using setGovernance(),
361         this function may be called by the proposed address to accept the
362         responsibility of taking over governance for this contract.
363 
364         This may only be called by the proposed governance address.
365     @dev
366         setGovernance() should be called by the existing governance address,
367         prior to calling this function.
368     """
369     assert msg.sender == self.pendingGovernance
370     self.governance = msg.sender
371     log UpdateGovernance(msg.sender)
372 
373 
374 @external
375 def setManagement(management: address):
376     """
377     @notice
378         Changes the management address.
379         Management is able to make some investment decisions adjusting parameters.
380 
381         This may only be called by governance.
382     @param management The address to use for managing.
383     """
384     assert msg.sender == self.governance
385     self.management = management
386     log UpdateManagement(management)
387 
388 
389 @external
390 def setGuestList(guestList: address):
391     """
392     @notice
393         Used to set or change `guestList`. A guest list is another contract
394         that dictates who is allowed to participate in a Vault (and transfer
395         shares).
396 
397         This may only be called by governance.
398     @param guestList The address of the `GuestList` contract to use.
399     """
400     assert msg.sender == self.governance
401     self.guestList = GuestList(guestList)
402     log UpdateGuestList(guestList)
403 
404 
405 @external
406 def setRewards(rewards: address):
407     """
408     @notice
409         Changes the rewards address. Any distributed rewards
410         will cease flowing to the old address and begin flowing
411         to this address once the change is in effect.
412 
413         This will not change any Strategy reports in progress, only
414         new reports made after this change goes into effect.
415 
416         This may only be called by governance.
417     @param rewards The address to use for collecting rewards.
418     """
419     assert msg.sender == self.governance
420     self.rewards = rewards
421     log UpdateRewards(rewards)
422 
423 
424 @external
425 def setDepositLimit(limit: uint256):
426     """
427     @notice
428         Changes the maximum amount of tokens that can be deposited in this Vault.
429 
430         Note, this is not how much may be deposited by a single depositor,
431         but the maximum amount that may be deposited across all depositors.
432 
433         This may only be called by governance.
434     @param limit The new deposit limit to use.
435     """
436     assert msg.sender == self.governance
437     self.depositLimit = limit
438     log UpdateDepositLimit(limit)
439 
440 
441 @external
442 def setPerformanceFee(fee: uint256):
443     """
444     @notice
445         Used to change the value of `performanceFee`.
446 
447         Should set this value below the maximum strategist performance fee.
448 
449         This may only be called by governance.
450     @param fee The new performance fee to use.
451     """
452     assert msg.sender == self.governance
453     assert fee <= MAX_BPS
454     self.performanceFee = fee
455     log UpdatePerformanceFee(fee)
456 
457 
458 @external
459 def setManagementFee(fee: uint256):
460     """
461     @notice
462         Used to change the value of `managementFee`.
463 
464         This may only be called by governance.
465     @param fee The new management fee to use.
466     """
467     assert msg.sender == self.governance
468     assert fee <= MAX_BPS
469     self.managementFee = fee
470     log UpdateManagementFee(fee)
471 
472 
473 @external
474 def setGuardian(guardian: address):
475     """
476     @notice
477         Used to change the address of `guardian`.
478 
479         This may only be called by governance or the existing guardian.
480     @param guardian The new guardian address to use.
481     """
482     assert msg.sender in [self.guardian, self.governance]
483     self.guardian = guardian
484     log UpdateGuardian(guardian)
485 
486 
487 @external
488 def setEmergencyShutdown(active: bool):
489     """
490     @notice
491         Activates or deactivates Vault mode where all Strategies go into full
492         withdrawal.
493 
494         During Emergency Shutdown:
495         1. No Users may deposit into the Vault (but may withdraw as usual.)
496         2. Governance may not add new Strategies.
497         3. Each Strategy must pay back their debt as quickly as reasonable to
498             minimally affect their position.
499         4. Only Governance may undo Emergency Shutdown.
500 
501         See contract level note for further details.
502 
503         This may only be called by governance or the guardian.
504     @param active
505         If true, the Vault goes into Emergency Shutdown. If false, the Vault
506         goes back into Normal Operation.
507     """
508     if active:
509         assert msg.sender in [self.guardian, self.governance]
510     else:
511         assert msg.sender == self.governance
512     self.emergencyShutdown = active
513     log EmergencyShutdown(active)
514 
515 
516 @external
517 def setWithdrawalQueue(queue: address[MAXIMUM_STRATEGIES]):
518     """
519     @notice
520         Updates the withdrawalQueue to match the addresses and order specified
521         by `queue`.
522 
523         There can be fewer strategies than the maximum, as well as fewer than
524         the total number of strategies active in the vault. `withdrawalQueue`
525         will be updated in a gas-efficient manner, assuming the input is well-
526         ordered with 0x0 only at the end.
527 
528         This may only be called by governance or management.
529     @dev
530         This is order sensitive, specify the addresses in the order in which
531         funds should be withdrawn (so `queue`[0] is the first Strategy withdrawn
532         from, `queue`[1] is the second, etc.)
533 
534         This means that the least impactful Strategy (the Strategy that will have
535         its core positions impacted the least by having funds removed) should be
536         at `queue`[0], then the next least impactful at `queue`[1], and so on.
537     @param queue
538         The array of addresses to use as the new withdrawal queue. This is
539         order sensitive.
540     """
541     assert msg.sender in [self.management, self.governance]
542     # HACK: Temporary until Vyper adds support for Dynamic arrays
543     for i in range(MAXIMUM_STRATEGIES):
544         if queue[i] == ZERO_ADDRESS and self.withdrawalQueue[i] == ZERO_ADDRESS:
545             break
546         assert self.strategies[queue[i]].activation > 0
547         self.withdrawalQueue[i] = queue[i]
548     log UpdateWithdrawalQueue(queue)
549 
550 
551 @internal
552 def _transfer(sender: address, receiver: address, amount: uint256):
553     # See note on `transfer()`.
554 
555     # Protect people from accidentally sending their shares to bad places
556     assert not (receiver in [self, ZERO_ADDRESS])
557     self.balanceOf[sender] -= amount
558     self.balanceOf[receiver] += amount
559     log Transfer(sender, receiver, amount)
560 
561 
562 @external
563 def transfer(receiver: address, amount: uint256) -> bool:
564     """
565     @notice
566         Transfers shares from the caller's address to `receiver`. This function
567         will always return true, unless the user is attempting to transfer
568         shares to this contract's address, or to 0x0.
569     @param receiver
570         The address shares are being transferred to. Must not be this contract's
571         address, must not be 0x0.
572     @param amount The quantity of shares to transfer.
573     @return
574         True if transfer is sent to an address other than this contract's or
575         0x0, otherwise the transaction will fail.
576     """
577     self._transfer(msg.sender, receiver, amount)
578     return True
579 
580 
581 @external
582 def transferFrom(sender: address, receiver: address, amount: uint256) -> bool:
583     """
584     @notice
585         Transfers `amount` shares from `sender` to `receiver`. This operation will
586         always return true, unless the user is attempting to transfer shares
587         to this contract's address, or to 0x0.
588 
589         Unless the caller has given this contract unlimited approval,
590         transfering shares will decrement the caller's `allowance` by `amount`.
591     @param sender The address shares are being transferred from.
592     @param receiver
593         The address shares are being transferred to. Must not be this contract's
594         address, must not be 0x0.
595     @param amount The quantity of shares to transfer.
596     @return
597         True if transfer is sent to an address other than this contract's or
598         0x0, otherwise the transaction will fail.
599     """
600     # Unlimited approval (saves an SSTORE)
601     if (self.allowance[sender][msg.sender] < MAX_UINT256):
602         allowance: uint256 = self.allowance[sender][msg.sender] - amount
603         self.allowance[sender][msg.sender] = allowance
604         # NOTE: Allows log filters to have a full accounting of allowance changes
605         log Approval(sender, msg.sender, allowance)
606     self._transfer(sender, receiver, amount)
607     return True
608 
609 
610 @external
611 def approve(spender: address, amount: uint256) -> bool:
612     """
613     @dev Approve the passed address to spend the specified amount of tokens on behalf of
614          `msg.sender`. Beware that changing an allowance with this method brings the risk
615          that someone may use both the old and the new allowance by unfortunate transaction
616          ordering. See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
617     @param spender The address which will spend the funds.
618     @param amount The amount of tokens to be spent.
619     """
620     self.allowance[msg.sender][spender] = amount
621     log Approval(msg.sender, spender, amount)
622     return True
623 
624 
625 @external
626 def increaseAllowance(spender: address, amount: uint256) -> bool:
627     """
628     @dev Increase the allowance of the passed address to spend the total amount of tokens
629          on behalf of msg.sender. This method mitigates the risk that someone may use both
630          the old and the new allowance by unfortunate transaction ordering.
631          See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
632     @param spender The address which will spend the funds.
633     @param amount The amount of tokens to increase the allowance by.
634     """
635     self.allowance[msg.sender][spender] += amount
636     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
637     return True
638 
639 
640 @external
641 def decreaseAllowance(spender: address, amount: uint256) -> bool:
642     """
643     @dev Decrease the allowance of the passed address to spend the total amount of tokens
644          on behalf of msg.sender. This method mitigates the risk that someone may use both
645          the old and the new allowance by unfortunate transaction ordering.
646          See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
647     @param spender The address which will spend the funds.
648     @param amount The amount of tokens to decrease the allowance by.
649     """
650     self.allowance[msg.sender][spender] -= amount
651     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
652     return True
653 
654 
655 @external
656 def permit(owner: address, spender: address, amount: uint256, expiry: uint256, signature: Bytes[65]) -> bool:
657     """
658     @notice
659         Approves spender by owner's signature to expend owner's tokens.
660         See https://eips.ethereum.org/EIPS/eip-2612.
661 
662     @param owner The address which is a source of funds and has signed the Permit.
663     @param spender The address which is allowed to spend the funds.
664     @param amount The amount of tokens to be spent.
665     @param expiry The timestamp after which the Permit is no longer valid.
666     @param signature A valid secp256k1 signature of Permit by owner encoded as r, s, v.
667     @return True, if transaction completes successfully
668     """
669     assert owner != ZERO_ADDRESS  # dev: invalid owner
670     assert expiry == 0 or expiry >= block.timestamp  # dev: permit expired
671     nonce: uint256 = self.nonces[owner]
672     digest: bytes32 = keccak256(
673         concat(
674             b'\x19\x01',
675             self.DOMAIN_SEPARATOR,
676             keccak256(
677                 concat(
678                     PERMIT_TYPE_HASH,
679                     convert(owner, bytes32),
680                     convert(spender, bytes32),
681                     convert(amount, bytes32),
682                     convert(nonce, bytes32),
683                     convert(expiry, bytes32),
684                 )
685             )
686         )
687     )
688     # NOTE: signature is packed as r, s, v
689     r: uint256 = convert(slice(signature, 0, 32), uint256)
690     s: uint256 = convert(slice(signature, 32, 32), uint256)
691     v: uint256 = convert(slice(signature, 64, 1), uint256)
692     assert ecrecover(digest, v, r, s) == owner  # dev: invalid signature
693     self.allowance[owner][spender] = amount
694     self.nonces[owner] = nonce + 1
695     log Approval(owner, spender, amount)
696     return True
697 
698 
699 @view
700 @internal
701 def _totalAssets() -> uint256:
702     # See note on `totalAssets()`.
703     return self.token.balanceOf(self) + self.totalDebt
704 
705 
706 @view
707 @external
708 def totalAssets() -> uint256:
709     """
710     @notice
711         Returns the total quantity of all assets under control of this
712         Vault, whether they're loaned out to a Strategy, or currently held in
713         the Vault.
714     @return The total assets under control of this Vault.
715     """
716     return self._totalAssets()
717 
718 
719 @internal
720 def _issueSharesForAmount(to: address, amount: uint256) -> uint256:
721     # Issues `amount` Vault shares to `to`.
722     # Shares must be issued prior to taking on new collateral, or
723     # calculation will be wrong. This means that only *trusted* tokens
724     # (with no capability for exploitative behavior) can be used.
725     shares: uint256 = 0
726     # HACK: Saves 2 SLOADs (~4000 gas)
727     totalSupply: uint256 = self.totalSupply
728     if totalSupply > 0:
729         # Mint amount of shares based on what the Vault is managing overall
730         # NOTE: if sqrt(token.totalSupply()) > 1e39, this could potentially revert
731         shares = amount * totalSupply / self._totalAssets()
732     else:
733         # No existing shares, so mint 1:1
734         shares = amount
735 
736     # Mint new shares
737     self.totalSupply = totalSupply + shares
738     self.balanceOf[to] += shares
739     log Transfer(ZERO_ADDRESS, to, shares)
740 
741     return shares
742 
743 
744 @external
745 def deposit(_amount: uint256 = MAX_UINT256, recipient: address = msg.sender) -> uint256:
746     """
747     @notice
748         Deposits `_amount` `token`, issuing shares to `recipient`. If the
749         Vault is in Emergency Shutdown, deposits will not be accepted and this
750         call will fail.
751     @dev
752         Measuring quantity of shares to issues is based on the total
753         outstanding debt that this contract has ("expected value") instead
754         of the total balance sheet it has ("estimated value") has important
755         security considerations, and is done intentionally. If this value were
756         measured against external systems, it could be purposely manipulated by
757         an attacker to withdraw more assets than they otherwise should be able
758         to claim by redeeming their shares.
759 
760         On deposit, this means that shares are issued against the total amount
761         that the deposited capital can be given in service of the debt that
762         Strategies assume. If that number were to be lower than the "expected
763         value" at some future point, depositing shares via this method could
764         entitle the depositor to *less* than the deposited value once the
765         "realized value" is updated from further reports by the Strategies
766         to the Vaults.
767 
768         Care should be taken by integrators to account for this discrepancy,
769         by using the view-only methods of this contract (both off-chain and
770         on-chain) to determine if depositing into the Vault is a "good idea".
771     @param _amount The quantity of tokens to deposit, defaults to all.
772     @param recipient
773         The address to issue the shares in this Vault to. Defaults to the
774         caller's address.
775     @return The issued Vault shares.
776     """
777     assert not self.emergencyShutdown  # Deposits are locked out
778 
779     amount: uint256 = _amount
780 
781     # If _amount not specified, transfer the full token balance,
782     # up to deposit limit
783     if amount == MAX_UINT256:
784         amount = min(
785             self.depositLimit - self._totalAssets(),
786             self.token.balanceOf(msg.sender),
787         )
788     else:
789         # Ensure deposit limit is respected
790         assert self._totalAssets() + amount <= self.depositLimit
791 
792     # Ensure we are depositing something
793     assert amount > 0
794 
795     # Ensure deposit is permitted by guest list
796     if self.guestList.address != ZERO_ADDRESS:
797         assert self.guestList.authorized(msg.sender, amount)
798 
799     # Issue new shares (needs to be done before taking deposit to be accurate)
800     # Shares are issued to recipient (may be different from msg.sender)
801     # See @dev note, above.
802     shares: uint256 = self._issueSharesForAmount(recipient, amount)
803 
804     # Tokens are transferred from msg.sender (may be different from _recipient)
805     assert self.token.transferFrom(msg.sender, self, amount)
806 
807     return shares  # Just in case someone wants them
808 
809 
810 @view
811 @internal
812 def _shareValue(shares: uint256) -> uint256:
813     # Determines the current value of `shares`.
814         # NOTE: if sqrt(Vault.totalAssets()) >>> 1e39, this could potentially revert
815     return (shares * (self._totalAssets())) / self.totalSupply
816 
817 
818 @view
819 @internal
820 def _sharesForAmount(amount: uint256) -> uint256:
821     # Determines how many shares `amount` of token would receive.
822     # See dev note on `deposit`.
823     if self._totalAssets() > 0:
824         # NOTE: if sqrt(token.totalSupply()) > 1e39, this could potentially revert
825         return (amount * self.totalSupply) / self._totalAssets()
826     else:
827         return 0
828 
829 
830 @view
831 @external
832 def maxAvailableShares() -> uint256:
833     """
834     @notice
835         Determines the total quantity of shares this Vault can provide,
836         factoring in assets currently residing in the Vault, as well as
837         those deployed to strategies.
838     @dev
839         Regarding how shares are calculated, see dev note on `deposit`.
840 
841         If you want to calculated the maximum a user could withdraw up to,
842         you want to use this function.
843     @return The total quantity of shares this Vault can provide.
844     """
845     shares: uint256 = self._sharesForAmount(self.token.balanceOf(self))
846 
847     for strategy in self.withdrawalQueue:
848         if strategy == ZERO_ADDRESS:
849             break
850         shares += self._sharesForAmount(self.strategies[strategy].totalDebt)
851 
852     return shares
853 
854 
855 @external
856 @nonreentrant("withdraw")
857 def withdraw(
858     maxShares: uint256 = MAX_UINT256,
859     recipient: address = msg.sender,
860     maxLoss: uint256 = 1,  # 0.01% [BPS]
861 ) -> uint256:
862     """
863     @notice
864         Withdraws the calling account's tokens from this Vault, redeeming
865         amount `_shares` for an appropriate amount of tokens.
866 
867         See note on `setWithdrawalQueue` for further details of withdrawal
868         ordering and behavior.
869     @dev
870         Measuring the value of shares is based on the total outstanding debt
871         that this contract has ("expected value") instead of the total balance
872         sheet it has ("estimated value") has important security considerations,
873         and is done intentionally. If this value were measured against external
874         systems, it could be purposely manipulated by an attacker to withdraw
875         more assets than they otherwise should be able to claim by redeeming
876         their shares.
877 
878         On withdrawal, this means that shares are redeemed against the total
879         amount that the deposited capital had "realized" since the point it
880         was deposited, up until the point it was withdrawn. If that number
881         were to be higher than the "expected value" at some future point,
882         withdrawing shares via this method could entitle the depositor to
883         *more* than the expected value once the "realized value" is updated
884         from further reports by the Strategies to the Vaults.
885 
886         Under exceptional scenarios, this could cause earlier withdrawals to
887         earn "more" of the underlying assets than Users might otherwise be
888         entitled to, if the Vault's estimated value were otherwise measured
889         through external means, accounting for whatever exceptional scenarios
890         exist for the Vault (that aren't covered by the Vault's own design.)
891     @param maxShares
892         How many shares to try and redeem for tokens, defaults to all.
893     @param recipient
894         The address to issue the shares in this Vault to. Defaults to the
895         caller's address.
896     @param maxLoss
897         The maximum acceptable loss to sustain on withdrawal. Defaults to 0%.
898     @return The quantity of tokens redeemed for `_shares`.
899     """
900     shares: uint256 = maxShares  # May reduce this number below
901 
902     # If _shares not specified, transfer full share balance
903     if shares == MAX_UINT256:
904         shares = self.balanceOf[msg.sender]
905 
906     # Limit to only the shares they own
907     assert shares <= self.balanceOf[msg.sender]
908 
909     # See @dev note, above.
910     value: uint256 = self._shareValue(shares)
911 
912     if value > self.token.balanceOf(self):
913         # We need to go get some from our strategies in the withdrawal queue
914         # NOTE: This performs forced withdrawals from each Strategy. During
915         #       forced withdrawal, a Strategy may realize a loss. That loss
916         #       is reported back to the Vault, and the will affect the amount
917         #       of tokens that the withdrawer receives for their shares. They
918         #       can optionally specify the maximum acceptable loss (in BPS)
919         #       to prevent excessive losses on their withdrawals (which may
920         #       happen in certain edge cases where Strategies realize a loss)
921         totalLoss: uint256 = 0
922         for strategy in self.withdrawalQueue:
923             if strategy == ZERO_ADDRESS:
924                 break  # We've exhausted the queue
925 
926             if value <= self.token.balanceOf(self):
927                 break  # We're done withdrawing
928 
929             amountNeeded: uint256 = value - self.token.balanceOf(self)
930 
931             # NOTE: Don't withdraw more than the debt so that Strategy can still
932             #       continue to work based on the profits it has
933             # NOTE: This means that user will lose out on any profits that each
934             #       Strategy in the queue would return on next harvest, benefiting others
935             amountNeeded = min(amountNeeded, self.strategies[strategy].totalDebt)
936             if amountNeeded == 0:
937                 continue  # Nothing to withdraw from this Strategy, try the next one
938 
939             # Force withdraw amount from each Strategy in the order set by governance
940             before: uint256 = self.token.balanceOf(self)
941             loss: uint256 = Strategy(strategy).withdraw(amountNeeded)
942             withdrawn: uint256 = self.token.balanceOf(self) - before
943 
944             # NOTE: Withdrawer incurs any losses from liquidation
945             if loss > 0:
946                 value -= loss
947                 totalLoss += loss
948                 self.strategies[strategy].totalLoss += loss
949 
950             # Reduce the Strategy's debt by the amount withdrawn ("realized returns")
951             # NOTE: This doesn't add to returns as it's not earned by "normal means"
952             self.strategies[strategy].totalDebt -= withdrawn + loss
953             self.totalDebt -= withdrawn + loss
954 
955         # NOTE: This loss protection is put in place to revert if losses from
956         #       withdrawing are more than what is considered acceptable.
957         assert totalLoss <= maxLoss * (value + totalLoss) / MAX_BPS
958 
959     # NOTE: We have withdrawn everything possible out of the withdrawal queue
960     #       but we still don't have enough to fully pay them back, so adjust
961     #       to the total amount we've freed up through forced withdrawals
962     if value > self.token.balanceOf(self):
963         value = self.token.balanceOf(self)
964         shares = self._sharesForAmount(value)
965 
966     # Burn shares (full value of what is being withdrawn)
967     self.totalSupply -= shares
968     self.balanceOf[msg.sender] -= shares
969     log Transfer(msg.sender, ZERO_ADDRESS, shares)
970 
971     # Withdraw remaining balance to _recipient (may be different to msg.sender) (minus fee)
972     assert self.token.transfer(recipient, value)
973 
974     return value
975 
976 
977 @view
978 @external
979 def pricePerShare() -> uint256:
980     """
981     @notice Gives the price for a single Vault share.
982     @dev See dev note on `withdraw`.
983     @return The value of a single share.
984     """
985     if self.totalSupply == 0:
986         return 10 ** self.decimals  # price of 1:1
987     else:
988         return self._shareValue(10 ** self.decimals)
989 
990 
991 @internal
992 def _organizeWithdrawalQueue():
993     # Reorganize `withdrawalQueue` based on premise that if there is an
994     # empty value between two actual values, then the empty value should be
995     # replaced by the later value.
996     # NOTE: Relative ordering of non-zero values is maintained.
997     offset: uint256 = 0
998     for idx in range(MAXIMUM_STRATEGIES):
999         strategy: address = self.withdrawalQueue[idx]
1000         if strategy == ZERO_ADDRESS:
1001             offset += 1  # how many values we need to shift, always `<= idx`
1002         elif offset > 0:
1003             self.withdrawalQueue[idx - offset] = strategy
1004             self.withdrawalQueue[idx] = ZERO_ADDRESS
1005 
1006 
1007 @external
1008 def addStrategy(
1009     strategy: address,
1010     debtRatio: uint256,
1011     rateLimit: uint256,
1012     performanceFee: uint256,
1013 ):
1014     """
1015     @notice
1016         Add a Strategy to the Vault.
1017 
1018         This may only be called by governance.
1019     @dev
1020         The Strategy will be appended to `withdrawalQueue`, call
1021         `setWithdrawalQueue` to change the order.
1022     @param strategy The address of the Strategy to add.
1023     @param debtRatio The ratio of the total assets in the `vault that the `strategy` can manage.
1024     @param rateLimit
1025         Limit on the increase of debt per unit time since last harvest
1026     @param performanceFee
1027         The fee the strategist will receive based on this Vault's performance.
1028     """
1029     assert strategy != ZERO_ADDRESS
1030     assert not self.emergencyShutdown
1031 
1032     assert msg.sender == self.governance
1033     assert self.debtRatio + debtRatio <= MAX_BPS
1034     assert performanceFee <= MAX_BPS - self.performanceFee
1035     assert self.strategies[strategy].activation == 0
1036     assert self == Strategy(strategy).vault()
1037     assert self.token.address == Strategy(strategy).want()
1038     self.strategies[strategy] = StrategyParams({
1039         performanceFee: performanceFee,
1040         activation: block.timestamp,
1041         debtRatio: debtRatio,
1042         rateLimit: rateLimit,
1043         lastReport: block.timestamp,
1044         totalDebt: 0,
1045         totalGain: 0,
1046         totalLoss: 0,
1047     })
1048     self.debtRatio += debtRatio
1049     log StrategyAdded(strategy, debtRatio, rateLimit, performanceFee)
1050 
1051     # queue is full
1052     assert self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] == ZERO_ADDRESS
1053     self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] = strategy
1054     self._organizeWithdrawalQueue()
1055 
1056 
1057 @external
1058 def updateStrategyDebtRatio(
1059     strategy: address,
1060     debtRatio: uint256,
1061 ):
1062     """
1063     @notice
1064         Change the quantity of assets `strategy` may manage.
1065 
1066         This may be called by governance or management.
1067     @param strategy The Strategy to update.
1068     @param debtRatio The quantity of assets `strategy` may now manage.
1069     """
1070     assert msg.sender in [self.management, self.governance]
1071     assert self.strategies[strategy].activation > 0
1072     self.debtRatio -= self.strategies[strategy].debtRatio
1073     self.strategies[strategy].debtRatio = debtRatio
1074     self.debtRatio += debtRatio
1075     assert self.debtRatio <= MAX_BPS
1076     log StrategyUpdateDebtRatio(strategy, debtRatio)
1077 
1078 
1079 @external
1080 def updateStrategyRateLimit(
1081     strategy: address,
1082     rateLimit: uint256,
1083 ):
1084     """
1085     @notice
1086         Change the quantity assets per block this Vault may deposit to or
1087         withdraw from `strategy`.
1088 
1089         This may only be called by governance or management.
1090     @param strategy The Strategy to update.
1091     @param rateLimit Limit on the increase of debt per unit time since last harvest
1092     """
1093     assert msg.sender in [self.management, self.governance]
1094     assert self.strategies[strategy].activation > 0
1095     self.strategies[strategy].rateLimit = rateLimit
1096     log StrategyUpdateRateLimit(strategy, rateLimit)
1097 
1098 
1099 @external
1100 def updateStrategyPerformanceFee(
1101     strategy: address,
1102     performanceFee: uint256,
1103 ):
1104     """
1105     @notice
1106         Change the fee the strategist will receive based on this Vault's
1107         performance.
1108 
1109         This may only be called by governance.
1110     @param strategy The Strategy to update.
1111     @param performanceFee The new fee the strategist will receive.
1112     """
1113     assert msg.sender == self.governance
1114     assert performanceFee <= MAX_BPS - self.performanceFee
1115     assert self.strategies[strategy].activation > 0
1116     self.strategies[strategy].performanceFee = performanceFee
1117     log StrategyUpdatePerformanceFee(strategy, performanceFee)
1118 
1119 
1120 @internal
1121 def _revokeStrategy(strategy: address):
1122     self.debtRatio -= self.strategies[strategy].debtRatio
1123     self.strategies[strategy].debtRatio = 0
1124     log StrategyRevoked(strategy)
1125 
1126 
1127 @external
1128 def migrateStrategy(oldVersion: address, newVersion: address):
1129     """
1130     @notice
1131         Migrates a Strategy, including all assets from `oldVersion` to
1132         `newVersion`.
1133 
1134         This may only be called by governance.
1135     @dev
1136         Strategy must successfully migrate all capital and positions to new
1137         Strategy, or else this will upset the balance of the Vault.
1138 
1139         The new Strategy should be "empty" e.g. have no prior commitments to
1140         this Vault, otherwise it could have issues.
1141     @param oldVersion The existing Strategy to migrate from.
1142     @param newVersion The new Strategy to migrate to.
1143     """
1144     assert msg.sender == self.governance
1145     assert newVersion != ZERO_ADDRESS
1146     assert self.strategies[oldVersion].activation > 0
1147     assert self.strategies[newVersion].activation == 0
1148 
1149     strategy: StrategyParams = self.strategies[oldVersion]
1150 
1151     self._revokeStrategy(oldVersion)
1152     # _revokeStrategy will lower the debtRatio
1153     self.debtRatio += strategy.debtRatio
1154     # Debt is migrated to new strategy
1155     self.strategies[oldVersion].totalDebt = 0
1156 
1157     self.strategies[newVersion] = StrategyParams({
1158         performanceFee: strategy.performanceFee,
1159         activation: block.timestamp,
1160         debtRatio: strategy.debtRatio,
1161         rateLimit: strategy.rateLimit,
1162         lastReport: block.timestamp,
1163         totalDebt: strategy.totalDebt,
1164         totalGain: 0,
1165         totalLoss: 0,
1166     })
1167 
1168     Strategy(oldVersion).migrate(newVersion)
1169     log StrategyMigrated(oldVersion, newVersion)
1170     # TODO: Ensure a smooth transition in terms of  Strategy return
1171 
1172     for idx in range(MAXIMUM_STRATEGIES):
1173         if self.withdrawalQueue[idx] == oldVersion:
1174             self.withdrawalQueue[idx] = newVersion
1175             return  # Don't need to reorder anything because we swapped
1176 
1177 
1178 @external
1179 def revokeStrategy(strategy: address = msg.sender):
1180     """
1181     @notice
1182         Revoke a Strategy, setting its debt limit to 0 and preventing any
1183         future deposits.
1184 
1185         This function should only be used in the scenario where the Strategy is
1186         being retired but no migration of the positions are possible, or in the
1187         extreme scenario that the Strategy needs to be put into "Emergency Exit"
1188         mode in order for it to exit as quickly as possible. The latter scenario
1189         could be for any reason that is considered "critical" that the Strategy
1190         exits its position as fast as possible, such as a sudden change in market
1191         conditions leading to losses, or an imminent failure in an external
1192         dependency.
1193 
1194         This may only be called by governance, the guardian, or the Strategy
1195         itself. Note that a Strategy will only revoke itself during emergency
1196         shutdown.
1197     @param strategy The Strategy to revoke.
1198     """
1199     assert msg.sender in [strategy, self.governance, self.guardian]
1200     self._revokeStrategy(strategy)
1201 
1202 
1203 @external
1204 def addStrategyToQueue(strategy: address):
1205     """
1206     @notice
1207         Adds `strategy` to `withdrawalQueue`.
1208 
1209         This may only be called by governance or management.
1210     @dev
1211         The Strategy will be appended to `withdrawalQueue`, call
1212         `setWithdrawalQueue` to change the order.
1213     @param strategy The Strategy to add.
1214     """
1215     assert msg.sender in [self.management, self.governance]
1216     # Must be a current Strategy
1217     assert self.strategies[strategy].activation > 0
1218     # Check if queue is full
1219     assert self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] == ZERO_ADDRESS
1220     # Can't already be in the queue
1221     for s in self.withdrawalQueue:
1222         if strategy == ZERO_ADDRESS:
1223             break
1224         assert s != strategy
1225     self.withdrawalQueue[MAXIMUM_STRATEGIES - 1] = strategy
1226     self._organizeWithdrawalQueue()
1227     log StrategyAddedToQueue(strategy)
1228 
1229 
1230 @external
1231 def removeStrategyFromQueue(strategy: address):
1232     """
1233     @notice
1234         Remove `strategy` from `withdrawalQueue`.
1235 
1236         This may only be called by governance or management.
1237     @dev
1238         We don't do this with revokeStrategy because it should still
1239         be possible to withdraw from the Strategy if it's unwinding.
1240     @param strategy The Strategy to remove.
1241     """
1242     assert msg.sender in [self.management, self.governance]
1243     for idx in range(MAXIMUM_STRATEGIES):
1244         if self.withdrawalQueue[idx] == strategy:
1245             self.withdrawalQueue[idx] = ZERO_ADDRESS
1246             self._organizeWithdrawalQueue()
1247             log StrategyRemovedFromQueue(strategy)
1248             return  # We found the right location and cleared it
1249     raise  # We didn't find the Strategy in the queue
1250 
1251 
1252 @view
1253 @internal
1254 def _debtOutstanding(strategy: address) -> uint256:
1255     # See note on `debtOutstanding()`.
1256     strategy_debtLimit: uint256 = self.strategies[strategy].debtRatio * self._totalAssets() / MAX_BPS
1257     strategy_totalDebt: uint256 = self.strategies[strategy].totalDebt
1258 
1259     if self.emergencyShutdown:
1260         return strategy_totalDebt
1261     elif strategy_totalDebt <= strategy_debtLimit:
1262         return 0
1263     else:
1264         return strategy_totalDebt - strategy_debtLimit
1265 
1266 
1267 @view
1268 @external
1269 def debtOutstanding(strategy: address = msg.sender) -> uint256:
1270     """
1271     @notice
1272         Determines if `strategy` is past its debt limit and if any tokens
1273         should be withdrawn to the Vault.
1274     @param strategy The Strategy to check. Defaults to the caller.
1275     @return The quantity of tokens to withdraw.
1276     """
1277     return self._debtOutstanding(strategy)
1278 
1279 
1280 @view
1281 @internal
1282 def _creditAvailable(strategy: address) -> uint256:
1283     # See note on `creditAvailable()`.
1284     if self.emergencyShutdown:
1285         return 0
1286 
1287     vault_totalAssets: uint256 = self._totalAssets()
1288     vault_debtLimit: uint256 = self.debtRatio * vault_totalAssets / MAX_BPS
1289     vault_totalDebt: uint256 = self.totalDebt
1290     strategy_debtLimit: uint256 = self.strategies[strategy].debtRatio * vault_totalAssets / MAX_BPS
1291     strategy_totalDebt: uint256 = self.strategies[strategy].totalDebt
1292     strategy_rateLimit: uint256 = self.strategies[strategy].rateLimit
1293     strategy_lastReport: uint256 = self.strategies[strategy].lastReport
1294 
1295     # Exhausted credit line
1296     if strategy_debtLimit <= strategy_totalDebt or vault_debtLimit <= vault_totalDebt:
1297         return 0
1298 
1299     # Start with debt limit left for the Strategy
1300     available: uint256 = strategy_debtLimit - strategy_totalDebt
1301 
1302     # Adjust by the global debt limit left
1303     available = min(available, vault_debtLimit - vault_totalDebt)
1304 
1305     # Adjust by the rate limit algorithm (limits the step size per reporting period)
1306     delta: uint256 = block.timestamp - strategy_lastReport
1307     # NOTE: Protect against unnecessary overflow faults here
1308     # NOTE: Set `strategy_rateLimit` to 0 to disable the rate limit
1309     if strategy_rateLimit > 0 and available / strategy_rateLimit >= delta:
1310         available = strategy_rateLimit * delta
1311 
1312     # Can only borrow up to what the contract has in reserve
1313     # NOTE: Running near 100% is discouraged
1314     return min(available, self.token.balanceOf(self))
1315 
1316 
1317 @view
1318 @external
1319 def creditAvailable(strategy: address = msg.sender) -> uint256:
1320     """
1321     @notice
1322         Amount of tokens in Vault a Strategy has access to as a credit line.
1323 
1324         This will check the Strategy's debt limit, as well as the tokens
1325         available in the Vault, and determine the maximum amount of tokens
1326         (if any) the Strategy may draw on.
1327 
1328         In the rare case the Vault is in emergency shutdown this will return 0.
1329     @param strategy The Strategy to check. Defaults to caller.
1330     @return The quantity of tokens available for the Strategy to draw on.
1331     """
1332     return self._creditAvailable(strategy)
1333 
1334 
1335 @view
1336 @internal
1337 def _expectedReturn(strategy: address) -> uint256:
1338     # See note on `expectedReturn()`.
1339     delta: uint256 = block.timestamp - self.strategies[strategy].lastReport
1340     if delta > 0:
1341         # NOTE: Unlikely to throw unless strategy accumalates >1e68 returns
1342         # NOTE: Will not throw for DIV/0 because activation <= lastReport
1343         return (self.strategies[strategy].totalGain * delta) / (
1344             block.timestamp - self.strategies[strategy].activation
1345         )
1346     else:
1347         return 0  # Covers the scenario when block.timestamp == activation
1348 
1349 
1350 @view
1351 @external
1352 def availableDepositLimit() -> uint256:
1353     if self.depositLimit > self._totalAssets():
1354         return self.depositLimit - self._totalAssets()
1355     else:
1356         return 0
1357 
1358 
1359 @view
1360 @external
1361 def expectedReturn(strategy: address = msg.sender) -> uint256:
1362     """
1363     @notice
1364         Provide an accurate expected value for the return this `strategy`
1365         would provide to the Vault the next time `report()` is called
1366         (since the last time it was called).
1367     @param strategy The Strategy to determine the expected return for. Defaults to caller.
1368     @return
1369         The anticipated amount `strategy` should make on its investment
1370         since its last report.
1371     """
1372     return self._expectedReturn(strategy)
1373 
1374 
1375 @internal
1376 def _reportLoss(strategy: address, loss: uint256):
1377     # Loss can only be up the amount of debt issued to strategy
1378     totalDebt: uint256 = self.strategies[strategy].totalDebt
1379     assert totalDebt >= loss
1380     self.strategies[strategy].totalLoss += loss
1381     self.strategies[strategy].totalDebt = totalDebt - loss
1382     self.totalDebt -= loss
1383 
1384     # Also, make sure we reduce our trust with the strategy by the same amount
1385     debtRatio: uint256 = self.strategies[strategy].debtRatio
1386     self.strategies[strategy].debtRatio -= min(loss * MAX_BPS / self._totalAssets(), debtRatio)
1387 
1388 
1389 @internal
1390 def _assessFees(strategy: address, gain: uint256):
1391     # Issue new shares to cover fees
1392     # NOTE: In effect, this reduces overall share price by the combined fee
1393     # NOTE: may throw if Vault.totalAssets() > 1e64, or not called for more than a year
1394     governance_fee: uint256 = (
1395         (self._totalAssets() * (block.timestamp - self.lastReport) * self.managementFee)
1396         / MAX_BPS
1397         / SECS_PER_YEAR
1398     )
1399     strategist_fee: uint256 = 0  # Only applies in certain conditions
1400 
1401     # NOTE: Applies if Strategy is not shutting down, or it is but all debt paid off
1402     # NOTE: No fee is taken when a Strategy is unwinding it's position, until all debt is paid
1403     if gain > 0:
1404         # NOTE: Unlikely to throw unless strategy reports >1e72 harvest profit
1405         strategist_fee = (
1406             gain * self.strategies[strategy].performanceFee
1407         ) / MAX_BPS
1408         # NOTE: Unlikely to throw unless strategy reports >1e72 harvest profit
1409         governance_fee += gain * self.performanceFee / MAX_BPS
1410 
1411     # NOTE: This must be called prior to taking new collateral,
1412     #       or the calculation will be wrong!
1413     # NOTE: This must be done at the same time, to ensure the relative
1414     #       ratio of governance_fee : strategist_fee is kept intact
1415     total_fee: uint256 = governance_fee + strategist_fee
1416     if total_fee > 0:  # NOTE: If mgmt fee is 0% and no gains were realized, skip
1417         reward: uint256 = self._issueSharesForAmount(self, total_fee)
1418 
1419         # Send the rewards out as new shares in this Vault
1420         if strategist_fee > 0:  # NOTE: Guard against DIV/0 fault
1421             # NOTE: Unlikely to throw unless sqrt(reward) >>> 1e39
1422             strategist_reward: uint256 = (strategist_fee * reward) / total_fee
1423             self._transfer(self, strategy, strategist_reward)
1424             # NOTE: Strategy distributes rewards at the end of harvest()
1425         # NOTE: Governance earns any dust leftover from flooring math above
1426         if self.balanceOf[self] > 0:
1427             self._transfer(self, self.rewards, self.balanceOf[self])
1428 
1429 
1430 @external
1431 def report(gain: uint256, loss: uint256, _debtPayment: uint256) -> uint256:
1432     """
1433     @notice
1434         Reports the amount of assets the calling Strategy has free (usually in
1435         terms of ROI).
1436 
1437         The performance fee is determined here, off of the strategy's profits
1438         (if any), and sent to governance.
1439 
1440         The strategist's fee is also determined here (off of profits), to be
1441         handled according to the strategist on the next harvest.
1442 
1443         This may only be called by a Strategy managed by this Vault.
1444     @dev
1445         For approved strategies, this is the most efficient behavior.
1446         The Strategy reports back what it has free, then Vault "decides"
1447         whether to take some back or give it more. Note that the most it can
1448         take is `gain + _debtPayment`, and the most it can give is all of the
1449         remaining reserves. Anything outside of those bounds is abnormal behavior.
1450 
1451         All approved strategies must have increased diligence around
1452         calling this function, as abnormal behavior could become catastrophic.
1453     @param gain
1454         Amount Strategy has realized as a gain on it's investment since its
1455         last report, and is free to be given back to Vault as earnings
1456     @param loss
1457         Amount Strategy has realized as a loss on it's investment since its
1458         last report, and should be accounted for on the Vault's balance sheet
1459     @param _debtPayment
1460         Amount Strategy has made available to cover outstanding debt
1461     @return Amount of debt outstanding (if totalDebt > debtLimit or emergency shutdown).
1462     """
1463 
1464     # Only approved strategies can call this function
1465     assert self.strategies[msg.sender].activation > 0
1466     # No lying about total available to withdraw!
1467     assert self.token.balanceOf(msg.sender) >= gain + _debtPayment
1468 
1469     # We have a loss to report, do it before the rest of the calculations
1470     if loss > 0:
1471         self._reportLoss(msg.sender, loss)
1472 
1473     # Assess both management fee and performance fee, and issue both as shares of the vault
1474     self._assessFees(msg.sender, gain)
1475 
1476     # Returns are always "realized gains"
1477     self.strategies[msg.sender].totalGain += gain
1478 
1479     # Outstanding debt the Strategy wants to take back from the Vault (if any)
1480     # NOTE: debtOutstanding <= StrategyParams.totalDebt
1481     debt: uint256 = self._debtOutstanding(msg.sender)
1482     debtPayment: uint256 = min(_debtPayment, debt)
1483 
1484     if debtPayment > 0:
1485         self.strategies[msg.sender].totalDebt -= debtPayment
1486         self.totalDebt -= debtPayment
1487         debt -= debtPayment
1488         # NOTE: `debt` is being tracked for later
1489 
1490     # Compute the line of credit the Vault is able to offer the Strategy (if any)
1491     credit: uint256 = self._creditAvailable(msg.sender)
1492 
1493     # Update the actual debt based on the full credit we are extending to the Strategy
1494     # or the returns if we are taking funds back
1495     # NOTE: credit + self.strategies[msg.sender].totalDebt is always < self.debtLimit
1496     # NOTE: At least one of `credit` or `debt` is always 0 (both can be 0)
1497     if credit > 0:
1498         self.strategies[msg.sender].totalDebt += credit
1499         self.totalDebt += credit
1500 
1501     # Give/take balance to Strategy, based on the difference between the reported gains
1502     # (if any), the debt payment (if any), the credit increase we are offering (if any),
1503     # and the debt needed to be paid off (if any)
1504     # NOTE: This is just used to adjust the balance of tokens between the Strategy and
1505     #       the Vault based on the Strategy's debt limit (as well as the Vault's).
1506     totalAvail: uint256 = gain + debtPayment
1507     if totalAvail < credit:  # credit surplus, give to Strategy
1508         assert self.token.transfer(msg.sender, credit - totalAvail)
1509     elif totalAvail > credit:  # credit deficit, take from Strategy
1510         assert self.token.transferFrom(msg.sender, self, totalAvail - credit)
1511     # else, don't do anything because it is balanced
1512 
1513     # Update reporting time
1514     self.strategies[msg.sender].lastReport = block.timestamp
1515     self.lastReport = block.timestamp
1516 
1517     log StrategyReported(
1518         msg.sender,
1519         gain,
1520         loss,
1521         self.strategies[msg.sender].totalGain,
1522         self.strategies[msg.sender].totalLoss,
1523         self.strategies[msg.sender].totalDebt,
1524         credit,
1525         self.strategies[msg.sender].debtRatio,
1526     )
1527 
1528     if self.strategies[msg.sender].debtRatio == 0 or self.emergencyShutdown:
1529         # Take every last penny the Strategy has (Emergency Exit/revokeStrategy)
1530         # NOTE: This is different than `debt` in order to extract *all* of the returns
1531         return Strategy(msg.sender).estimatedTotalAssets()
1532     else:
1533         # Otherwise, just return what we have as debt outstanding
1534         return debt
1535 
1536 
1537 @internal
1538 def erc20_safe_transfer(token: address, to: address, amount: uint256):
1539     # Used only to send tokens that are not the type managed by this Vault.
1540     # HACK: Used to handle non-compliant tokens like USDT
1541     response: Bytes[32] = raw_call(
1542         token,
1543         concat(
1544             method_id("transfer(address,uint256)"),
1545             convert(to, bytes32),
1546             convert(amount, bytes32),
1547         ),
1548         max_outsize=32,
1549     )
1550     if len(response) > 0:
1551         assert convert(response, bool), "Transfer failed!"
1552 
1553 
1554 @external
1555 def sweep(token: address, amount: uint256 = MAX_UINT256):
1556     """
1557     @notice
1558         Removes tokens from this Vault that are not the type of token managed
1559         by this Vault. This may be used in case of accidentally sending the
1560         wrong kind of token to this Vault.
1561 
1562         Tokens will be sent to `governance`.
1563 
1564         This will fail if an attempt is made to sweep the tokens that this
1565         Vault manages.
1566 
1567         This may only be called by governance.
1568     @param token The token to transfer out of this vault.
1569     @param amount The quantity or tokenId to transfer out.
1570     """
1571     assert msg.sender == self.governance
1572     # Can't be used to steal what this Vault is protecting
1573     assert token != self.token.address
1574     value: uint256 = amount
1575     if value == MAX_UINT256:
1576         value = ERC20(token).balanceOf(self)
1577     self.erc20_safe_transfer(token, self.governance, value)