1 # @version 0.2.12
2 
3 """
4 @title Unagii EthVault V2 0.1.1
5 @author stakewith.us
6 @license AGPL-3.0-or-later
7 """
8 
9 from vyper.interfaces import ERC20
10 
11 
12 interface UnagiiToken:
13     def minter() -> address: view
14     def token() -> address: view
15     def decimals() -> uint256: view
16     def totalSupply() -> uint256: view
17     def balanceOf(owner: address) -> uint256: view
18     def mint(receiver: address, amount: uint256): nonpayable
19     def burn(spender: address, amount: uint256): nonpayable
20     def lastBlock(owner: address) -> uint256: view
21 
22 
23 # used for migrating to new Vault contract
24 interface Vault:
25     def oldVault() -> address: view
26     def token() -> address: view
27     def uToken() -> address: view
28     def fundManager() -> address: view
29     def initialize(): payable
30     def balanceOfVault() -> uint256: view
31     def debt() -> uint256: view
32     def lockedProfit() -> uint256: view
33     def lastReport() -> uint256: view
34 
35 
36 interface FundManager:
37     def vault() -> address: view
38     def token() -> address: view
39     # returns loss = debt - total assets in fund manager
40     def withdraw(amount: uint256) -> uint256: nonpayable
41 
42 
43 event Migrate:
44     vault: address
45     balanceOfVault: uint256
46     debt: uint256
47     lockedProfit: uint256
48 
49 
50 event SetNextTimeLock:
51     nextTimeLock: address
52 
53 
54 event AcceptTimeLock:
55     timeLock: address
56 
57 
58 event SetGuardian:
59     guardian: address
60 
61 
62 event SetAdmin:
63     admin: address
64 
65 
66 event SetFundManager:
67     fundManager: address
68 
69 
70 event SetPause:
71     paused: bool
72 
73 
74 event SetWhitelist:
75     addr: indexed(address)
76     approved: bool
77 
78 
79 event ReceiveEth:
80     sender: indexed(address)
81     amount: uint256
82 
83 
84 event Deposit:
85     sender: indexed(address)
86     amount: uint256
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
125 ETH: constant(address) = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
126 uToken: public(UnagiiToken)
127 fundManager: public(FundManager)
128 # privileges: time lock >= admin >= guardian
129 timeLock: public(address)
130 nextTimeLock: public(address)
131 guardian: public(address)
132 admin: public(address)
133 
134 depositLimit: public(uint256)
135 # ETH balance of vault tracked internally to protect against share dilution
136 # from sending ETH directly to this contract
137 balanceOfVault: public(uint256)
138 debt: public(uint256)  # debt to users (amount borrowed by fund manager)
139 # minimum amount of ETH to be kept in this vault for cheap withdraw
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
155 
156 # address of old Vault contract, used for migration
157 oldVault: public(Vault)
158 
159 
160 @external
161 def __init__(uToken: address, guardian: address, oldVault: address):
162     self.timeLock = msg.sender
163     self.admin = msg.sender
164     self.guardian = guardian
165     self.uToken = UnagiiToken(uToken)
166 
167     assert self.uToken.token() == ETH, "uToken token != ETH"
168 
169     self.paused = True
170     self.blockDelay = 1
171     self.minReserve = 500  # 5% of free funds
172     # 6 hours
173     self.lockedProfitDegradation = convert(MAX_DEGRADATION / 21600, uint256)
174 
175     if oldVault != ZERO_ADDRESS:
176         self.oldVault = Vault(oldVault)
177         assert self.oldVault.token() == ETH, "old vault token != ETH"
178         assert self.oldVault.uToken() == uToken, "old vault uToken != uToken"
179 
180 
181 @external
182 @payable
183 def __default__():
184     """
185     @dev Prevent users from accidentally sending ETH to this vault
186     """
187     assert msg.sender == self.fundManager.address, "!fund manager"
188     log ReceiveEth(msg.sender, msg.value)
189 
190 
191 @external
192 @view
193 def token() -> address:
194     return ETH
195 
196 
197 @internal
198 def _sendEth(to: address, amount: uint256):
199     assert to != ZERO_ADDRESS, "to = 0 address"
200     raw_call(to, b"", value=amount)
201 
202 
203 @internal
204 def _safeTransfer(token: address, receiver: address, amount: uint256):
205     res: Bytes[32] = raw_call(
206         token,
207         concat(
208             method_id("transfer(address,uint256)"),
209             convert(receiver, bytes32),
210             convert(amount, bytes32),
211         ),
212         max_outsize=32,
213     )
214     if len(res) > 0:
215         assert convert(res, bool), "transfer failed"
216 
217 
218 @external
219 @payable
220 def initialize():
221     """
222     @notice Initialize vault. Transfer ETH and copy states if old vault is set.
223     """
224     assert not self.initialized, "initialized"
225 
226     if self.oldVault.address == ZERO_ADDRESS:
227         assert msg.sender in [self.timeLock, self.admin], "!auth"
228         self.lastReport = block.timestamp
229     else:
230         assert msg.sender == self.oldVault.address, "!old vault"
231 
232         assert self.uToken.minter() == self, "minter != self"
233 
234         assert (
235             self.fundManager.address == self.oldVault.fundManager()
236         ), "fund manager != old vault fund manager"
237         if self.fundManager.address != ZERO_ADDRESS:
238             assert self.fundManager.vault() == self, "fund manager vault != self"
239 
240         # check ETH sent from old vault >= old balanceOfVault
241         balOfVault: uint256 = self.oldVault.balanceOfVault()
242         assert msg.value >= balOfVault, "value < vault"
243 
244         self.balanceOfVault = min(balOfVault, msg.value)
245         self.debt = self.oldVault.debt()
246         self.lockedProfit = self.oldVault.lockedProfit()
247         self.lastReport = self.oldVault.lastReport()
248 
249     self.initialized = True
250 
251 
252 # Migration steps from this vault to new vault
253 #
254 # ut = unagi token
255 # v1 = vault 1
256 # v2 = vault 2
257 # f = fund manager
258 #
259 # action                         | caller
260 # ----------------------------------------
261 # 1. v2.setPause(true)           | admin
262 # 2. v1.setPause(true)           | admin
263 # 3. ut.setMinter(v2)            | time lock
264 # 4. f.setVault(v2)              | time lock
265 # 5. v2.setFundManager(f)        | time lock
266 # 6. transfer ETH                | v1
267 # 7. v2 copy states from v1      | v2
268 #    - balanceOfVault            |
269 #    - debt                      |
270 #    - locked profit             |
271 #    - last report               |
272 # 8. v1 set state = 0            | v1
273 #    - balanceOfVault            |
274 #    - debt                      |
275 #    - locked profit             |
276 
277 
278 @external
279 def migrate(vault: address):
280     """
281     @notice Migrate to new vault
282     @param vault Address of new vault
283     """
284     assert msg.sender == self.timeLock, "!time lock"
285     assert self.initialized, "!initialized"
286     assert self.paused, "!paused"
287 
288     assert Vault(vault).token() == ETH, "new vault token != ETH"
289     assert Vault(vault).uToken() == self.uToken.address, "new vault uToken != uToken"
290     # minter is set to new vault
291     assert self.uToken.minter() == vault, "minter != new vault"
292     # new vault's fund manager is set to current fund manager
293     assert (
294         Vault(vault).fundManager() == self.fundManager.address
295     ), "new vault fund manager != fund manager"
296     if self.fundManager.address != ZERO_ADDRESS:
297         # fund manager's vault is set to new vault
298         assert self.fundManager.vault() == vault, "fund manager vault != new vault"
299 
300     # check balance of vault >= balanceOfVault
301     bal: uint256 = self.balance
302     assert bal >= self.balanceOfVault, "bal < vault"
303 
304     assert Vault(vault).oldVault() == self, "old vault != self"
305 
306     Vault(vault).initialize(value=bal)
307 
308     log Migrate(vault, self.balanceOfVault, self.debt, self.lockedProfit)
309 
310     # reset state
311     self.balanceOfVault = 0
312     self.debt = 0
313     self.lockedProfit = 0
314 
315 
316 @external
317 def setNextTimeLock(nextTimeLock: address):
318     """
319     @notice Set next time lock
320     @param nextTimeLock Address of next time lock
321     """
322     assert msg.sender == self.timeLock, "!time lock"
323     self.nextTimeLock = nextTimeLock
324     log SetNextTimeLock(nextTimeLock)
325 
326 
327 @external
328 def acceptTimeLock():
329     """
330     @notice Accept time lock
331     @dev Only `nextTimeLock` can claim time lock
332     """
333     assert msg.sender == self.nextTimeLock, "!next time lock"
334     self.timeLock = msg.sender
335     self.nextTimeLock = ZERO_ADDRESS
336     log AcceptTimeLock(msg.sender)
337 
338 
339 @external
340 def setAdmin(admin: address):
341     assert msg.sender in [self.timeLock, self.admin], "!auth"
342     self.admin = admin
343     log SetAdmin(admin)
344 
345 
346 @external
347 def setGuardian(guardian: address):
348     assert msg.sender in [self.timeLock, self.admin], "!auth"
349     self.guardian = guardian
350     log SetGuardian(guardian)
351 
352 
353 @external
354 def setFundManager(fundManager: address):
355     """
356     @notice Set fund manager
357     @param fundManager Address of new fund manager
358     """
359     assert msg.sender == self.timeLock, "!time lock"
360 
361     assert FundManager(fundManager).vault() == self, "fund manager vault != self"
362     assert FundManager(fundManager).token() == ETH, "fund manager token != ETH"
363 
364     self.fundManager = FundManager(fundManager)
365     log SetFundManager(fundManager)
366 
367 
368 @external
369 def setPause(paused: bool):
370     assert msg.sender in [self.timeLock, self.admin, self.guardian], "!auth"
371     self.paused = paused
372     log SetPause(paused)
373 
374 
375 @external
376 def setMinReserve(minReserve: uint256):
377     """
378     @notice Set minimum amount of ETH reserved in this vault for cheap
379             withdrawn by user
380     @param minReserve Numerator to calculate min reserve
381            0 = all funds can be transferred to fund manager
382            MAX_MIN_RESERVE = 0 ETH can be transferred to fund manager
383     """
384     assert msg.sender in [self.timeLock, self.admin], "!auth"
385     assert minReserve <= MAX_MIN_RESERVE, "min reserve > max"
386     self.minReserve = minReserve
387 
388 
389 @external
390 def setLockedProfitDegradation(degradation: uint256):
391     """
392     @notice Set locked profit degradation (rate locked profit is released)
393     @param degradation Rate of degradation
394                  0 = profit is locked forever
395                  MAX_DEGRADATION = 100% of profit is released 1 block after report
396     """
397     assert msg.sender in [self.timeLock, self.admin], "!auth"
398     assert degradation <= MAX_DEGRADATION, "degradation > max"
399     self.lockedProfitDegradation = degradation
400 
401 
402 @external
403 def setDepositLimit(limit: uint256):
404     """
405     @notice Set limit to total deposit
406     @param limit Limit for total deposit
407     """
408     assert msg.sender in [self.timeLock, self.admin], "!auth"
409     self.depositLimit = limit
410 
411 
412 @external
413 def setBlockDelay(delay: uint256):
414     """
415     @notice Set block delay, used to protect against flash attacks
416     @param delay Number of blocks to delay before user can deposit / withdraw
417     """
418     assert msg.sender in [self.timeLock, self.admin], "!auth"
419     assert delay >= 1, "delay = 0"
420     self.blockDelay = delay
421 
422 
423 @external
424 def setWhitelist(addr: address, approved: bool):
425     """
426     @notice Approve or disapprove address to skip check on block delay.
427             Approved address can deposit, withdraw and transfer uToken in
428             a single transaction
429     @param approved Boolean True = approve
430                              False = disapprove
431     """
432     assert msg.sender in [self.timeLock, self.admin], "!auth"
433     self.whitelist[addr] = approved
434     log SetWhitelist(addr, approved)
435 
436 
437 @internal
438 @view
439 def _totalAssets() -> uint256:
440     """
441     @notice Total amount of ETH in this vault + amount in fund manager
442     @dev State variable `balanceOfVault` is used to track balance of ETH in
443          this contract instead of `self.balance`. This is done to
444          protect against uToken shares being diluted by directly sending ETH
445          to this contract.
446     @dev Returns total amount of ETH in this contract
447     """
448     return self.balanceOfVault + self.debt
449 
450 
451 @external
452 @view
453 def totalAssets() -> uint256:
454     return self._totalAssets()
455 
456 
457 @internal
458 @view
459 def _calcLockedProfit() -> uint256:
460     """
461     @notice Calculated locked profit
462     @dev Returns amount of profit locked from last report. Profit is released
463          over time, depending on the release rate `lockedProfitDegradation`.
464          Profit is locked after `report` to protect against sandwich attack.
465     """
466     lockedFundsRatio: uint256 = (
467         block.timestamp - self.lastReport
468     ) * self.lockedProfitDegradation
469 
470     if lockedFundsRatio < MAX_DEGRADATION:
471         lockedProfit: uint256 = self.lockedProfit
472         return lockedProfit - lockedFundsRatio * lockedProfit / MAX_DEGRADATION
473     else:
474         return 0
475 
476 
477 @external
478 @view
479 def calcLockedProfit() -> uint256:
480     return self._calcLockedProfit()
481 
482 
483 @internal
484 @view
485 def _calcFreeFunds() -> uint256:
486     """
487     @notice Calculate free funds (total assets - locked profit)
488     @dev Returns total amount of ETH that can be withdrawn
489     """
490     return self._totalAssets() - self._calcLockedProfit()
491 
492 
493 @external
494 @view
495 def calcFreeFunds() -> uint256:
496     return self._calcFreeFunds()
497 
498 
499 @internal
500 @pure
501 def _calcSharesToMint(
502     amount: uint256, totalSupply: uint256, freeFunds: uint256
503 ) -> uint256:
504     """
505     @notice Calculate uToken shares to mint
506     @param amount Amount of ETH to deposit
507     @param totalSupply Total amount of shares
508     @param freeFunds Free funds before deposit
509     @dev Returns amount of uToken to mint. Input must be numbers before deposit
510     @dev Calculated with `freeFunds`, not `totalAssets`
511     """
512     # s = shares to mint
513     # T = total shares before mint
514     # a = deposit amount
515     # P = total amount of ETH in vault + fund manager before deposit
516     # s / (T + s) = a / (P + a)
517     # sP = aT
518     # a = 0               | mint s = 0
519     # a > 0, T = 0, P = 0 | mint s = a
520     # a > 0, T = 0, P > 0 | mint s = a as if P = 0
521     # a > 0, T > 0, P = 0 | invalid, equation cannot be true for any s
522     # a > 0, T > 0, P > 0 | mint s = aT / P
523     if amount == 0:
524         return 0
525     if totalSupply == 0:
526         return amount
527     # reverts if free funds = 0
528     return amount * totalSupply / freeFunds
529 
530 
531 @external
532 @view
533 def calcSharesToMint(amount: uint256) -> uint256:
534     return self._calcSharesToMint(
535         amount, self.uToken.totalSupply(), self._calcFreeFunds()
536     )
537 
538 
539 @internal
540 @pure
541 def _calcWithdraw(shares: uint256, totalSupply: uint256, freeFunds: uint256) -> uint256:
542     """
543     @notice Calculate amount of ETH to withdraw
544     @param shares Amount of uToken shares to burn
545     @param totalSupply Total amount of shares before burn
546     @param freeFunds Free funds
547     @dev Returns amount of ETH to withdraw
548     @dev Calculated with `freeFunds`, not `totalAssets`
549     """
550     # s = shares
551     # T = total supply of shares
552     # a = amount to withdraw
553     # P = total amount of ETH in vault + fund manager
554     # s / T = a / P (constraints T >= s, P >= a)
555     # sP = aT
556     # s = 0               | a = 0
557     # s > 0, T = 0, P = 0 | invalid (violates constraint T >= s)
558     # s > 0, T = 0, P > 0 | invalid (violates constraint T >= s)
559     # s > 0, T > 0, P = 0 | a = 0
560     # s > 0, T > 0, P > 0 | a = sP / T
561     if shares == 0:
562         return 0
563     # invalid if total supply = 0
564     return shares * freeFunds / totalSupply
565 
566 
567 @external
568 @view
569 def calcWithdraw(shares: uint256) -> uint256:
570     return self._calcWithdraw(shares, self.uToken.totalSupply(), self._calcFreeFunds())
571 
572 
573 @external
574 @payable
575 @nonreentrant("lock")
576 def deposit(amount: uint256, _min: uint256) -> uint256:
577     """
578     @notice Deposit ETH into vault
579     @param amount Amount of ETH to deposit
580     @param _min Minimum amount of uToken to be minted
581     @dev Returns actual amount of uToken minted
582     """
583     assert self.initialized, "!initialized"
584     assert not self.paused, "paused"
585     # check block delay or whitelisted
586     assert (
587         block.number >= self.uToken.lastBlock(msg.sender) + self.blockDelay
588         or self.whitelist[msg.sender]
589     ), "block < delay"
590 
591     assert amount == msg.value, "amount != msg.value"
592     assert amount > 0, "deposit = 0"
593 
594     # check deposit limit
595     assert self._totalAssets() + amount <= self.depositLimit, "deposit limit"
596 
597     # calculate with free funds before deposit (msg.value is not included in freeFunds)
598     shares: uint256 = self._calcSharesToMint(
599         amount, self.uToken.totalSupply(), self._calcFreeFunds()
600     )
601     assert shares >= _min, "shares < min"
602 
603     self.balanceOfVault += amount
604     self.uToken.mint(msg.sender, shares)
605 
606     # check ETH balance >= balanceOfVault
607     assert self.balance >= self.balanceOfVault, "bal < vault"
608 
609     log Deposit(msg.sender, amount, shares)
610 
611     return shares
612 
613 
614 @external
615 @nonreentrant("lock")
616 def withdraw(shares: uint256, _min: uint256) -> uint256:
617     """
618     @notice Withdraw ETH from vault
619     @param shares Amount of uToken to burn
620     @param _min Minimum amount of ETH that msg.sender will receive
621     @dev Returns actual amount of ETH transferred to msg.sender
622     """
623     assert self.initialized, "!initialized"
624     # check block delay or whitelisted
625     assert (
626         block.number >= self.uToken.lastBlock(msg.sender) + self.blockDelay
627         or self.whitelist[msg.sender]
628     ), "block < delay"
629 
630     _shares: uint256 = min(shares, self.uToken.balanceOf(msg.sender))
631     assert _shares > 0, "shares = 0"
632 
633     amount: uint256 = self._calcWithdraw(
634         _shares, self.uToken.totalSupply(), self._calcFreeFunds()
635     )
636 
637     # withdraw from fund manager if amount to withdraw > balance of vault
638     if amount > self.balanceOfVault:
639         diff: uint256 = self.balance
640         # loss = debt - total assets in fund manager + any loss from strategies
641         # ETH received by __default__
642         loss: uint256 = self.fundManager.withdraw(amount - self.balanceOfVault)
643         diff = self.balance - diff
644 
645         # diff + loss may be >= amount
646         if loss > 0:
647             # msg.sender must cover all of loss
648             amount -= loss
649             self.debt -= loss
650 
651         self.debt -= diff
652         self.balanceOfVault += diff
653 
654         if amount > self.balanceOfVault:
655             amount = self.balanceOfVault
656 
657     self.uToken.burn(msg.sender, _shares)
658 
659     assert amount >= _min, "amount < min"
660     self.balanceOfVault -= amount
661 
662     self._sendEth(msg.sender, amount)
663 
664     # check ETH balance >= balanceOfVault
665     assert self.balance >= self.balanceOfVault, "bal < vault"
666 
667     log Withdraw(msg.sender, _shares, amount)
668 
669     return amount
670 
671 
672 @internal
673 @view
674 def _calcMinReserve() -> uint256:
675     """
676     @notice Calculate minimum amount of ETH that is reserved in vault for
677             cheap withdraw by users
678     @dev Returns min reserve
679     """
680     freeFunds: uint256 = self._calcFreeFunds()
681     return freeFunds * self.minReserve / MAX_MIN_RESERVE
682 
683 
684 @external
685 def calcMinReserve() -> uint256:
686     return self._calcMinReserve()
687 
688 
689 @internal
690 @view
691 def _calcMaxBorrow() -> uint256:
692     """
693     @notice Calculate amount of ETH available for fund manager to borrow
694     @dev Returns amount of ETH fund manager can borrow
695     """
696     if (
697         (not self.initialized)
698         or self.paused
699         or self.fundManager.address == ZERO_ADDRESS
700     ):
701         return 0
702 
703     minBal: uint256 = self._calcMinReserve()
704 
705     if self.balanceOfVault > minBal:
706         return self.balanceOfVault - minBal
707     return 0
708 
709 
710 @external
711 @view
712 def calcMaxBorrow() -> uint256:
713     return self._calcMaxBorrow()
714 
715 
716 @external
717 def borrow(amount: uint256) -> uint256:
718     """
719     @notice Borrow ETH from vault
720     @dev Only fund manager can borrow
721     @dev Returns actual amount that was given to fund manager
722     """
723     assert self.initialized, "!initialized"
724     assert not self.paused, "paused"
725     assert msg.sender == self.fundManager.address, "!fund manager"
726 
727     available: uint256 = self._calcMaxBorrow()
728     _amount: uint256 = min(amount, available)
729     assert _amount > 0, "borrow = 0"
730 
731     self._sendEth(msg.sender, _amount)
732 
733     self.balanceOfVault -= _amount
734     self.debt += _amount
735 
736     # check ETH balance >= balanceOfVault
737     assert self.balance >= self.balanceOfVault, "bal < vault"
738 
739     log Borrow(msg.sender, amount, _amount)
740 
741     return _amount
742 
743 
744 @external
745 @payable
746 def repay(amount: uint256) -> uint256:
747     """
748     @notice Repay ETH to vault
749     @dev Only fund manager can borrow
750     @dev Returns actual amount that was repaid by fund manager
751     """
752     assert self.initialized, "!initialized"
753     assert msg.sender == self.fundManager.address, "!fund manager"
754 
755     assert amount == msg.value, "amount != msg.value"
756     assert amount > 0, "repay = 0"
757 
758     self.balanceOfVault += amount
759     self.debt -= amount
760 
761     # check ETH balance >= balanceOfVault
762     assert self.balance >= self.balanceOfVault, "bal < vault"
763 
764     log Repay(msg.sender, amount, amount)
765 
766     return amount
767 
768 
769 @external
770 @payable
771 def report(gain: uint256, loss: uint256):
772     """
773     @notice Report profit or loss
774     @param gain Profit since last report
775     @param loss Loss since last report
776     @dev Only fund manager can call
777     @dev Locks profit to be release over time
778     """
779     assert self.initialized, "!initialized"
780     assert msg.sender == self.fundManager.address, "!fund manager"
781     # can't have both gain and loss > 0
782     assert (gain >= 0 and loss == 0) or (gain == 0 and loss >= 0), "gain and loss > 0"
783     assert gain == msg.value, "gain != msg.value"
784 
785     # calculate current locked profit
786     lockedProfit: uint256 = self._calcLockedProfit()
787     diff: uint256 = msg.value  # actual amount transferred if gain > 0
788 
789     if gain > 0:
790         # free funds = bal + diff + debt - (locked profit + diff)
791         self.balanceOfVault += diff
792         self.lockedProfit = lockedProfit + diff
793     elif loss > 0:
794         # free funds = bal + debt - loss - (locked profit - loss)
795         self.debt -= loss
796         # deduct locked profit
797         if lockedProfit > loss:
798             self.lockedProfit -= loss
799         else:
800             # no locked profit to be released
801             self.lockedProfit = 0
802 
803     self.lastReport = block.timestamp
804 
805     # check ETH balance >= balanceOfVault
806     assert self.balance >= self.balanceOfVault, "bal < vault"
807 
808     # log updated debt and lockedProfit
809     log Report(
810         msg.sender, self.balanceOfVault, self.debt, gain, loss, diff, self.lockedProfit
811     )
812 
813 
814 @external
815 def forceUpdateBalanceOfVault():
816     """
817     @notice Force `balanceOfVault` to equal `self.balance`
818     @dev Only use in case of emergency if `balanceOfVault` is > actual balance
819     """
820     assert self.initialized, "!initialized"
821     assert msg.sender in [self.timeLock, self.admin], "!auth"
822 
823     bal: uint256 = self.balance
824     assert bal < self.balanceOfVault, "bal >= vault"
825 
826     self.balanceOfVault = bal
827     log ForceUpdateBalanceOfVault(bal)
828 
829 
830 @external
831 def skim():
832     """
833     @notice Transfer excess ETH sent to this contract to admin or time lock
834     @dev actual ETH balance must be >= `balanceOfVault`
835     """
836     assert msg.sender == self.timeLock, "!time lock"
837     self._sendEth(msg.sender, self.balance - self.balanceOfVault)
838 
839 
840 @external
841 def sweep(token: address):
842     """
843     @notice Transfer any token accidentally sent to this contract
844             to admin or time lock
845     """
846     assert msg.sender in [self.timeLock, self.admin], "!auth"
847     self._safeTransfer(token, msg.sender, ERC20(token).balanceOf(self))