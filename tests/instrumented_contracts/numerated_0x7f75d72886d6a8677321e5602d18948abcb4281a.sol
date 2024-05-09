1 # @version 0.2.12
2 
3 """
4 @title Unagii Vault V2 0.1.1
5 @author stakewith.us
6 @license AGPL-3.0-or-later
7 """
8 
9 from vyper.interfaces import ERC20
10 
11 
12 interface DetailedERC20:
13     def decimals() -> uint256: view
14 
15 
16 interface UnagiiToken:
17     def minter() -> address: view
18     def token() -> address: view
19     def decimals() -> uint256: view
20     def totalSupply() -> uint256: view
21     def balanceOf(owner: address) -> uint256: view
22     def mint(receiver: address, amount: uint256): nonpayable
23     def burn(spender: address, amount: uint256): nonpayable
24     def lastBlock(owner: address) -> uint256: view
25 
26 
27 # used for migrating to new Vault contract
28 interface Vault:
29     def oldVault() -> address: view
30     def token() -> address: view
31     def uToken() -> address: view
32     def fundManager() -> address: view
33     def initialize(): nonpayable
34     def balanceOfVault() -> uint256: view
35     def debt() -> uint256: view
36     def lockedProfit() -> uint256: view
37     def lastReport() -> uint256: view
38 
39 
40 interface FundManager:
41     def vault() -> address: view
42     def token() -> address: view
43     # returns loss = debt - total assets in fund manager
44     def withdraw(amount: uint256) -> uint256: nonpayable
45 
46 
47 event Migrate:
48     vault: address
49     balanceOfVault: uint256
50     debt: uint256
51     lockedProfit: uint256
52 
53 
54 event SetNextTimeLock:
55     nextTimeLock: address
56 
57 
58 event AcceptTimeLock:
59     timeLock: address
60 
61 
62 event SetGuardian:
63     guardian: address
64 
65 
66 event SetAdmin:
67     admin: address
68 
69 
70 event SetFundManager:
71     fundManager: address
72 
73 
74 event SetPause:
75     paused: bool
76 
77 
78 event SetWhitelist:
79     addr: indexed(address)
80     approved: bool
81 
82 
83 event Deposit:
84     sender: indexed(address)
85     amount: uint256
86     diff: uint256
87     shares: uint256
88 
89 
90 event Withdraw:
91     owner: indexed(address)
92     shares: uint256
93     amount: uint256
94 
95 
96 event Borrow:
97     fundManager: indexed(address)
98     amount: uint256
99     borrowed: uint256
100 
101 
102 event Repay:
103     fundManager: indexed(address)
104     amount: uint256
105     repaid: uint256
106 
107 
108 event Report:
109     fundManager: indexed(address)
110     balanceOfVault: uint256
111     debt: uint256
112     gain: uint256
113     loss: uint256
114     diff: uint256
115     lockedProfit: uint256
116 
117 
118 event ForceUpdateBalanceOfVault:
119     balanceOfVault: uint256
120 
121 
122 initialized: public(bool)
123 paused: public(bool)
124 
125 token: public(ERC20)
126 uToken: public(UnagiiToken)
127 fundManager: public(FundManager)
128 # privileges: time lock >= admin >= guardian
129 timeLock: public(address)
130 nextTimeLock: public(address)
131 guardian: public(address)
132 admin: public(address)
133 
134 depositLimit: public(uint256)
135 # token balance of vault tracked internally to protect against share dilution
136 # from sending tokens directly to this contract
137 balanceOfVault: public(uint256)
138 debt: public(uint256)  # debt to users (amount borrowed by fund manager)
139 # minimum amount of token to be kept in this vault for cheap withdraw
140 minReserve: public(uint256)
141 MAX_MIN_RESERVE: constant(uint256) = 10000
142 # timestamp of last report
143 lastReport: public(uint256)
144 # profit locked from report, released over time at a rate set by lockedProfitDegradation
145 lockedProfit: public(uint256)
146 MAX_DEGRADATION: constant(uint256) = 10 ** 18
147 # rate at which locked profit is released
148 # 0 = forever, MAX_DEGREDATION = 100% of profit is released 1 block after report
149 lockedProfitDegradation: public(uint256)
150 # minimum number of block to wait before deposit / withdraw
151 # used to protect agains flash attacks
152 blockDelay: public(uint256)
153 # whitelisted address can bypass block delay check
154 whitelist: public(HashMap[address, bool])
155 # set to true if token has fee on transfer
156 feeOnTransfer: public(bool)
157 
158 # address of old Vault contract, used for migration
159 oldVault: public(Vault)
160 # constants used for protection when migrating vault funds
161 MIN_OLD_BAL: constant(uint256) = 9990
162 MAX_MIN_OLD_BAL: constant(uint256) = 10000
163 
164 
165 @external
166 def __init__(token: address, uToken: address, guardian: address, oldVault: address):
167     self.timeLock = msg.sender
168     self.admin = msg.sender
169     self.guardian = guardian
170     self.token = ERC20(token)
171     self.uToken = UnagiiToken(uToken)
172 
173     assert self.uToken.token() == self.token.address, "uToken token != token"
174 
175     self.paused = True
176     self.blockDelay = 1
177     self.minReserve = 500  # 5% of free funds
178     # 6 hours
179     self.lockedProfitDegradation = convert(MAX_DEGRADATION / 21600, uint256)
180 
181     if oldVault != ZERO_ADDRESS:
182         self.oldVault = Vault(oldVault)
183         assert self.oldVault.token() == token, "old vault token != token"
184         assert self.oldVault.uToken() == uToken, "old vault uToken != uToken"
185 
186 
187 @internal
188 def _safeApprove(token: address, spender: address, amount: uint256):
189     res: Bytes[32] = raw_call(
190         token,
191         concat(
192             method_id("approve(address,uint256)"),
193             convert(spender, bytes32),
194             convert(amount, bytes32),
195         ),
196         max_outsize=32,
197     )
198     if len(res) > 0:
199         assert convert(res, bool), "approve failed"
200 
201 
202 @internal
203 def _safeTransfer(token: address, receiver: address, amount: uint256):
204     res: Bytes[32] = raw_call(
205         token,
206         concat(
207             method_id("transfer(address,uint256)"),
208             convert(receiver, bytes32),
209             convert(amount, bytes32),
210         ),
211         max_outsize=32,
212     )
213     if len(res) > 0:
214         assert convert(res, bool), "transfer failed"
215 
216 
217 @internal
218 def _safeTransferFrom(
219     token: address, owner: address, receiver: address, amount: uint256
220 ):
221     res: Bytes[32] = raw_call(
222         token,
223         concat(
224             method_id("transferFrom(address,address,uint256)"),
225             convert(owner, bytes32),
226             convert(receiver, bytes32),
227             convert(amount, bytes32),
228         ),
229         max_outsize=32,
230     )
231     if len(res) > 0:
232         assert convert(res, bool), "transferFrom failed"
233 
234 
235 @external
236 def initialize():
237     """
238     @notice Initialize vault. Transfer tokens and copy states if old vault is set.
239     """
240     assert not self.initialized, "initialized"
241 
242     if self.oldVault.address == ZERO_ADDRESS:
243         assert msg.sender in [self.timeLock, self.admin], "!auth"
244         self.lastReport = block.timestamp
245     else:
246         assert msg.sender == self.oldVault.address, "!old vault"
247 
248         assert self.uToken.minter() == self, "minter != self"
249 
250         assert (
251             self.fundManager.address == self.oldVault.fundManager()
252         ), "fund manager != old vault fund manager"
253         if self.fundManager.address != ZERO_ADDRESS:
254             assert self.fundManager.vault() == self, "fund manager vault != self"
255 
256         # check balance of old vault >= old balanceOfVault
257         bal: uint256 = self.token.balanceOf(self.oldVault.address)
258         balOfVault: uint256 = self.oldVault.balanceOfVault()
259         assert bal >= balOfVault, "bal < vault"
260 
261         diff: uint256 = self.token.balanceOf(self)
262         self._safeTransferFrom(self.token.address, self.oldVault.address, self, bal)
263         diff = self.token.balanceOf(self) - diff
264 
265         # diff may be <= balOfVault if fee on transfer
266         assert diff >= balOfVault * MIN_OLD_BAL / MAX_MIN_OLD_BAL, "diff < min"
267 
268         self.balanceOfVault = min(balOfVault, diff)
269         self.debt = self.oldVault.debt()
270         self.lockedProfit = self.oldVault.lockedProfit()
271         self.lastReport = self.oldVault.lastReport()
272 
273     self.initialized = True
274 
275 
276 # Migration steps from this vault to new vault
277 #
278 # t = token
279 # ut = unagi token
280 # v1 = vault 1
281 # v2 = vault 2
282 # f = fund manager
283 #
284 # action                         | caller
285 # ----------------------------------------
286 # 1. v2.setPause(true)           | admin
287 # 2. v1.setPause(true)           | admin
288 # 3. ut.setMinter(v2)            | time lock
289 # 4. f.setVault(v2)              | time lock
290 # 5. v2.setFundManager(f)        | time lock
291 # 6. t.approve(v2, bal)          | v1
292 # 7. t.transferFrom(v1, v2, bal) | v2
293 # 8. v2 copy states from v1      | v2
294 #    - balanceOfVault            |
295 #    - debt                      |
296 #    - locked profit             |
297 #    - last report               |
298 # 9. v1 set state = 0            | v1
299 #    - balanceOfVault            |
300 #    - debt                      |
301 #    - locked profit             |
302 
303 
304 @external
305 def migrate(vault: address):
306     """
307     @notice Migrate to new vault
308     @param vault Address of new vault
309     """
310     assert msg.sender == self.timeLock, "!time lock"
311     assert self.initialized, "!initialized"
312     assert self.paused, "!paused"
313 
314     assert Vault(vault).token() == self.token.address, "new vault token != token"
315     assert Vault(vault).uToken() == self.uToken.address, "new vault uToken != uToken"
316     # minter is set to new vault
317     assert self.uToken.minter() == vault, "minter != new vault"
318     # new vault's fund manager is set to current fund manager
319     assert (
320         Vault(vault).fundManager() == self.fundManager.address
321     ), "new vault fund manager != fund manager"
322     if self.fundManager.address != ZERO_ADDRESS:
323         # fund manager's vault is set to new vault
324         assert self.fundManager.vault() == vault, "fund manager vault != new vault"
325 
326     # check balance of vault >= balanceOfVault
327     bal: uint256 = self.token.balanceOf(self)
328     assert bal >= self.balanceOfVault, "bal < vault"
329 
330     assert Vault(vault).oldVault() == self, "old vault != self"
331 
332     self._safeApprove(self.token.address, vault, bal)
333     Vault(vault).initialize()
334 
335     # check all tokens where transferred
336     assert self.token.balanceOf(self) == 0, "bal != 0"
337 
338     log Migrate(vault, self.balanceOfVault, self.debt, self.lockedProfit)
339 
340     # reset state
341     self.balanceOfVault = 0
342     self.debt = 0
343     self.lockedProfit = 0
344 
345 
346 @external
347 def setNextTimeLock(nextTimeLock: address):
348     """
349     @notice Set next time lock
350     @param nextTimeLock Address of next time lock
351     """
352     assert msg.sender == self.timeLock, "!time lock"
353     self.nextTimeLock = nextTimeLock
354     log SetNextTimeLock(nextTimeLock)
355 
356 
357 @external
358 def acceptTimeLock():
359     """
360     @notice Accept time lock
361     @dev Only `nextTimeLock` can claim time lock
362     """
363     assert msg.sender == self.nextTimeLock, "!next time lock"
364     self.timeLock = msg.sender
365     self.nextTimeLock = ZERO_ADDRESS
366     log AcceptTimeLock(msg.sender)
367 
368 
369 @external
370 def setAdmin(admin: address):
371     assert msg.sender in [self.timeLock, self.admin], "!auth"
372     self.admin = admin
373     log SetAdmin(admin)
374 
375 
376 @external
377 def setGuardian(guardian: address):
378     assert msg.sender in [self.timeLock, self.admin], "!auth"
379     self.guardian = guardian
380     log SetGuardian(guardian)
381 
382 
383 @external
384 def setFundManager(fundManager: address):
385     """
386     @notice Set fund manager
387     @param fundManager Address of new fund manager
388     """
389     assert msg.sender == self.timeLock, "!time lock"
390 
391     assert FundManager(fundManager).vault() == self, "fund manager vault != self"
392     assert (
393         FundManager(fundManager).token() == self.token.address
394     ), "fund manager token != token"
395 
396     self.fundManager = FundManager(fundManager)
397     log SetFundManager(fundManager)
398 
399 
400 @external
401 def setPause(paused: bool):
402     assert msg.sender in [self.timeLock, self.admin, self.guardian], "!auth"
403     self.paused = paused
404     log SetPause(paused)
405 
406 
407 @external
408 def setMinReserve(minReserve: uint256):
409     """
410     @notice Set minimum amount of token reserved in this vault for cheap
411             withdrawn by user
412     @param minReserve Numerator to calculate min reserve
413            0 = all funds can be transferred to fund manager
414            MAX_MIN_RESERVE = 0 tokens can be transferred to fund manager
415     """
416     assert msg.sender in [self.timeLock, self.admin], "!auth"
417     assert minReserve <= MAX_MIN_RESERVE, "min reserve > max"
418     self.minReserve = minReserve
419 
420 
421 @external
422 def setLockedProfitDegradation(degradation: uint256):
423     """
424     @notice Set locked profit degradation (rate locked profit is released)
425     @param degradation Rate of degradation
426                  0 = profit is locked forever
427                  MAX_DEGRADATION = 100% of profit is released 1 block after report
428     """
429     assert msg.sender in [self.timeLock, self.admin], "!auth"
430     assert degradation <= MAX_DEGRADATION, "degradation > max"
431     self.lockedProfitDegradation = degradation
432 
433 
434 @external
435 def setDepositLimit(limit: uint256):
436     """
437     @notice Set limit to total deposit
438     @param limit Limit for total deposit
439     """
440     assert msg.sender in [self.timeLock, self.admin], "!auth"
441     self.depositLimit = limit
442 
443 
444 @external
445 def setBlockDelay(delay: uint256):
446     """
447     @notice Set block delay, used to protect against flash attacks
448     @param delay Number of blocks to delay before user can deposit / withdraw
449     """
450     assert msg.sender in [self.timeLock, self.admin], "!auth"
451     assert delay >= 1, "delay = 0"
452     self.blockDelay = delay
453 
454 
455 @external
456 def setFeeOnTransfer(feeOnTransfer: bool):
457     """
458     @notice Enable calculation of actual amount transferred to this vault
459             if token has fee on transfer
460     @param feeOnTransfer True = enable calculation
461                           False = disable calculation
462     """
463     assert msg.sender in [self.timeLock, self.admin], "!auth"
464     self.feeOnTransfer = feeOnTransfer
465 
466 
467 @external
468 def setWhitelist(addr: address, approved: bool):
469     """
470     @notice Approve or disapprove address to skip check on block delay.
471             Approved address can deposit, withdraw and transfer uToken in
472             a single transaction
473     @param approved Boolean True = approve
474                              False = disapprove
475     """
476     assert msg.sender in [self.timeLock, self.admin], "!auth"
477     self.whitelist[addr] = approved
478     log SetWhitelist(addr, approved)
479 
480 
481 @internal
482 @view
483 def _totalAssets() -> uint256:
484     """
485     @notice Total amount of token in this vault + amount in fund manager
486     @dev State variable `balanceOfVault` is used to track balance of token in
487          this contract instead of `token.balanceOf(self)`. This is done to
488          protect against uToken shares being diluted by directly sending token
489          to this contract.
490     @dev Returns total amount of token in this contract
491     """
492     return self.balanceOfVault + self.debt
493 
494 
495 @external
496 @view
497 def totalAssets() -> uint256:
498     return self._totalAssets()
499 
500 
501 @internal
502 @view
503 def _calcLockedProfit() -> uint256:
504     """
505     @notice Calculated locked profit
506     @dev Returns amount of profit locked from last report. Profit is released
507          over time, depending on the release rate `lockedProfitDegradation`.
508          Profit is locked after `report` to protect against sandwich attack.
509     """
510     lockedFundsRatio: uint256 = (
511         block.timestamp - self.lastReport
512     ) * self.lockedProfitDegradation
513 
514     if lockedFundsRatio < MAX_DEGRADATION:
515         lockedProfit: uint256 = self.lockedProfit
516         return lockedProfit - lockedFundsRatio * lockedProfit / MAX_DEGRADATION
517     else:
518         return 0
519 
520 
521 @external
522 @view
523 def calcLockedProfit() -> uint256:
524     return self._calcLockedProfit()
525 
526 
527 @internal
528 @view
529 def _calcFreeFunds() -> uint256:
530     """
531     @notice Calculate free funds (total assets - locked profit)
532     @dev Returns total amount of tokens that can be withdrawn
533     """
534     return self._totalAssets() - self._calcLockedProfit()
535 
536 
537 @external
538 @view
539 def calcFreeFunds() -> uint256:
540     return self._calcFreeFunds()
541 
542 
543 @internal
544 @pure
545 def _calcSharesToMint(
546     amount: uint256, totalSupply: uint256, freeFunds: uint256
547 ) -> uint256:
548     """
549     @notice Calculate uToken shares to mint
550     @param amount Amount of token to deposit
551     @param totalSupply Total amount of shares
552     @param freeFunds Free funds before deposit
553     @dev Returns amount of uToken to mint. Input must be numbers before deposit
554     @dev Calculated with `freeFunds`, not `totalAssets`
555     """
556     # s = shares to mint
557     # T = total shares before mint
558     # a = deposit amount
559     # P = total amount of underlying token in vault + fund manager before deposit
560     # s / (T + s) = a / (P + a)
561     # sP = aT
562     # a = 0               | mint s = 0
563     # a > 0, T = 0, P = 0 | mint s = a
564     # a > 0, T = 0, P > 0 | mint s = a as if P = 0
565     # a > 0, T > 0, P = 0 | invalid, equation cannot be true for any s
566     # a > 0, T > 0, P > 0 | mint s = aT / P
567     if amount == 0:
568         return 0
569     if totalSupply == 0:
570         return amount
571     # reverts if free funds = 0
572     return amount * totalSupply / freeFunds
573 
574 
575 @external
576 @view
577 def calcSharesToMint(amount: uint256) -> uint256:
578     return self._calcSharesToMint(
579         amount, self.uToken.totalSupply(), self._calcFreeFunds()
580     )
581 
582 
583 @internal
584 @pure
585 def _calcWithdraw(shares: uint256, totalSupply: uint256, freeFunds: uint256) -> uint256:
586     """
587     @notice Calculate amount of token to withdraw
588     @param shares Amount of uToken shares to burn
589     @param totalSupply Total amount of shares before burn
590     @param freeFunds Free funds
591     @dev Returns amount of token to withdraw
592     @dev Calculated with `freeFunds`, not `totalAssets`
593     """
594     # s = shares
595     # T = total supply of shares
596     # a = amount to withdraw
597     # P = total amount of underlying token in vault + fund manager
598     # s / T = a / P (constraints T >= s, P >= a)
599     # sP = aT
600     # s = 0               | a = 0
601     # s > 0, T = 0, P = 0 | invalid (violates constraint T >= s)
602     # s > 0, T = 0, P > 0 | invalid (violates constraint T >= s)
603     # s > 0, T > 0, P = 0 | a = 0
604     # s > 0, T > 0, P > 0 | a = sP / T
605     if shares == 0:
606         return 0
607     # invalid if total supply = 0
608     return shares * freeFunds / totalSupply
609 
610 
611 @external
612 @view
613 def calcWithdraw(shares: uint256) -> uint256:
614     return self._calcWithdraw(shares, self.uToken.totalSupply(), self._calcFreeFunds())
615 
616 
617 @external
618 @nonreentrant("lock")
619 def deposit(amount: uint256, _min: uint256) -> uint256:
620     """
621     @notice Deposit token into vault
622     @param amount Amount of token to deposit
623     @param _min Minimum amount of uToken to be minted
624     @dev Returns actual amount of uToken minted
625     """
626     assert self.initialized, "!initialized"
627     assert not self.paused, "paused"
628     # check block delay or whitelisted
629     assert (
630         block.number >= self.uToken.lastBlock(msg.sender) + self.blockDelay
631         or self.whitelist[msg.sender]
632     ), "block < delay"
633 
634     _amount: uint256 = min(amount, self.token.balanceOf(msg.sender))
635     assert _amount > 0, "deposit = 0"
636 
637     # check deposit limit
638     assert self._totalAssets() + _amount <= self.depositLimit, "deposit limit"
639 
640     totalSupply: uint256 = self.uToken.totalSupply()
641     freeFunds: uint256 = self._calcFreeFunds()
642 
643     # amount of tokens that this vault received
644     diff: uint256 = 0
645     if self.feeOnTransfer:
646         # actual amount transferred may be less than `amount`
647         # if token has fee on transfer
648         diff = self.token.balanceOf(self)
649         self._safeTransferFrom(self.token.address, msg.sender, self, _amount)
650         diff = self.token.balanceOf(self) - diff
651     else:
652         self._safeTransferFrom(self.token.address, msg.sender, self, _amount)
653         diff = _amount
654 
655     assert diff > 0, "diff = 0"
656 
657     # calculate with free funds before deposit
658     shares: uint256 = self._calcSharesToMint(diff, totalSupply, freeFunds)
659     assert shares >= _min, "shares < min"
660 
661     self.balanceOfVault += diff
662     self.uToken.mint(msg.sender, shares)
663 
664     # check token balance >= balanceOfVault
665     assert self.token.balanceOf(self) >= self.balanceOfVault, "bal < vault"
666 
667     log Deposit(msg.sender, _amount, diff, shares)
668 
669     return shares
670 
671 
672 @external
673 @nonreentrant("lock")
674 def withdraw(shares: uint256, _min: uint256) -> uint256:
675     """
676     @notice Withdraw token from vault
677     @param shares Amount of uToken to burn
678     @param _min Minimum amount of token that msg.sender will receive
679     @dev Returns actual amount of token transferred to msg.sender
680     """
681     assert self.initialized, "!initialized"
682     # check block delay or whitelisted
683     assert (
684         block.number >= self.uToken.lastBlock(msg.sender) + self.blockDelay
685         or self.whitelist[msg.sender]
686     ), "block < delay"
687 
688     _shares: uint256 = min(shares, self.uToken.balanceOf(msg.sender))
689     assert _shares > 0, "shares = 0"
690 
691     amount: uint256 = self._calcWithdraw(
692         _shares, self.uToken.totalSupply(), self._calcFreeFunds()
693     )
694 
695     # withdraw from fund manager if amount to withdraw > balance of vault
696     if amount > self.balanceOfVault:
697         diff: uint256 = self.token.balanceOf(self)
698         # loss = debt - total assets in fund manager + any loss from strategies
699         loss: uint256 = self.fundManager.withdraw(amount - self.balanceOfVault)
700         diff = self.token.balanceOf(self) - diff
701 
702         # diff + loss may be >= amount
703         if loss > 0:
704             # msg.sender must cover all of loss
705             amount -= loss
706             self.debt -= loss
707 
708         self.debt -= diff
709         self.balanceOfVault += diff
710 
711         if amount > self.balanceOfVault:
712             amount = self.balanceOfVault
713 
714     self.uToken.burn(msg.sender, _shares)
715 
716     assert amount >= _min, "amount < min"
717     self.balanceOfVault -= amount
718 
719     self._safeTransfer(self.token.address, msg.sender, amount)
720 
721     # check token balance >= balanceOfVault
722     assert self.token.balanceOf(self) >= self.balanceOfVault, "bal < vault"
723 
724     log Withdraw(msg.sender, _shares, amount)
725 
726     # actual amount received by msg.sender may be less if fee on transfer
727     return amount
728 
729 
730 @internal
731 @view
732 def _calcMinReserve() -> uint256:
733     """
734     @notice Calculate minimum amount of token that is reserved in vault for
735             cheap withdraw by users
736     @dev Returns min reserve
737     """
738     freeFunds: uint256 = self._calcFreeFunds()
739     return freeFunds * self.minReserve / MAX_MIN_RESERVE
740 
741 
742 @external
743 def calcMinReserve() -> uint256:
744     return self._calcMinReserve()
745 
746 
747 @internal
748 @view
749 def _calcMaxBorrow() -> uint256:
750     """
751     @notice Calculate amount of token available for fund manager to borrow
752     @dev Returns amount of token fund manager can borrow
753     """
754     if (
755         (not self.initialized)
756         or self.paused
757         or self.fundManager.address == ZERO_ADDRESS
758     ):
759         return 0
760 
761     minBal: uint256 = self._calcMinReserve()
762 
763     if self.balanceOfVault > minBal:
764         return self.balanceOfVault - minBal
765     return 0
766 
767 
768 @external
769 @view
770 def calcMaxBorrow() -> uint256:
771     return self._calcMaxBorrow()
772 
773 
774 @external
775 def borrow(amount: uint256) -> uint256:
776     """
777     @notice Borrow token from vault
778     @dev Only fund manager can borrow
779     @dev Returns actual amount that was given to fund manager
780     """
781     assert self.initialized, "!initialized"
782     assert not self.paused, "paused"
783     assert msg.sender == self.fundManager.address, "!fund manager"
784 
785     available: uint256 = self._calcMaxBorrow()
786     _amount: uint256 = min(amount, available)
787     assert _amount > 0, "borrow = 0"
788 
789     self._safeTransfer(self.token.address, msg.sender, _amount)
790 
791     self.balanceOfVault -= _amount
792     # include fee on trasfer to debt
793     self.debt += _amount
794 
795     # check token balance >= balanceOfVault
796     assert self.token.balanceOf(self) >= self.balanceOfVault, "bal < vault"
797 
798     log Borrow(msg.sender, amount, _amount)
799 
800     return _amount
801 
802 
803 @external
804 def repay(amount: uint256) -> uint256:
805     """
806     @notice Repay token to vault
807     @dev Only fund manager can borrow
808     @dev Returns actual amount that was repaid by fund manager
809     """
810     assert self.initialized, "!initialized"
811     assert msg.sender == self.fundManager.address, "!fund manager"
812 
813     _amount: uint256 = min(amount, self.debt)
814     assert _amount > 0, "repay = 0"
815 
816     diff: uint256 = self.token.balanceOf(self)
817     self._safeTransferFrom(self.token.address, msg.sender, self, _amount)
818     diff = self.token.balanceOf(self) - diff
819 
820     self.balanceOfVault += diff
821     # exclude fee on transfer from debt payment
822     self.debt -= diff
823 
824     # check token balance >= balanceOfVault
825     assert self.token.balanceOf(self) >= self.balanceOfVault, "bal < vault"
826 
827     log Repay(msg.sender, amount, diff)
828 
829     return diff
830 
831 
832 @external
833 def report(gain: uint256, loss: uint256):
834     """
835     @notice Report profit or loss
836     @param gain Profit since last report
837     @param loss Loss since last report
838     @dev Only fund manager can call
839     @dev Locks profit to be release over time
840     """
841     assert self.initialized, "!initialized"
842     assert msg.sender == self.fundManager.address, "!fund manager"
843     # can't have both gain and loss > 0
844     assert (gain >= 0 and loss == 0) or (gain == 0 and loss >= 0), "gain and loss > 0"
845 
846     # calculate current locked profit
847     lockedProfit: uint256 = self._calcLockedProfit()
848     diff: uint256 = 0  # actual amount transferred if gain > 0
849 
850     if gain > 0:
851         diff = self.token.balanceOf(self)
852         self._safeTransferFrom(self.token.address, msg.sender, self, gain)
853         diff = self.token.balanceOf(self) - diff
854 
855         # free funds = bal + diff + debt - (locked profit + diff)
856         self.balanceOfVault += diff
857         self.lockedProfit = lockedProfit + diff
858     elif loss > 0:
859         # free funds = bal + debt - loss - (locked profit - loss)
860         self.debt -= loss
861         # deduct locked profit
862         if lockedProfit > loss:
863             self.lockedProfit -= loss
864         else:
865             # no locked profit to be released
866             self.lockedProfit = 0
867 
868     self.lastReport = block.timestamp
869 
870     # check token balance >= balanceOfVault
871     assert self.token.balanceOf(self) >= self.balanceOfVault, "bal < vault"
872 
873     # log updated debt and lockedProfit
874     log Report(
875         msg.sender, self.balanceOfVault, self.debt, gain, loss, diff, self.lockedProfit
876     )
877 
878 
879 @external
880 def forceUpdateBalanceOfVault():
881     """
882     @notice Force `balanceOfVault` to equal `token.balanceOf(self)`
883     @dev Only use in case of emergency if `balanceOfVault` is > actual balance
884     """
885     assert self.initialized, "!initialized"
886     assert msg.sender in [self.timeLock, self.admin], "!auth"
887 
888     bal: uint256 = self.token.balanceOf(self)
889     assert bal < self.balanceOfVault, "bal >= vault"
890 
891     self.balanceOfVault = bal
892     log ForceUpdateBalanceOfVault(bal)
893 
894 
895 @external
896 def skim():
897     """
898     @notice Transfer excess token sent to this contract to admin or time lock
899     @dev actual token balance must be >= `balanceOfVault`
900     """
901     assert msg.sender == self.timeLock, "!time lock"
902     self._safeTransfer(
903         self.token.address, msg.sender, self.token.balanceOf(self) - self.balanceOfVault
904     )
905 
906 
907 @external
908 def sweep(token: address):
909     """
910     @notice Transfer any token (except `token`) accidentally sent to this contract
911             to admin or time lock
912     @dev Cannot transfer `token`
913     """
914     assert msg.sender in [self.timeLock, self.admin], "!auth"
915     assert token != self.token.address, "protected"
916     self._safeTransfer(token, msg.sender, ERC20(token).balanceOf(self))