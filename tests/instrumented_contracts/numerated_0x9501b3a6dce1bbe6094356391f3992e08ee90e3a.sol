1 # @version 0.2.12
2 
3 """
4 @title Unagii EthFundManager 0.1.1
5 @author stakewith.us
6 @license AGPL-3.0-or-later
7 """
8 
9 from vyper.interfaces import ERC20
10 
11 
12 interface Vault:
13     def token() -> address: view
14     def debt() -> uint256: view
15     def borrow(amount: uint256) -> uint256: nonpayable
16     def repay(amount: uint256) -> uint256: payable
17     def report(gain: uint256, loss: uint256): payable
18 
19 
20 interface IStrategy:
21     def fundManager() -> address: view
22     def token() -> address: view
23     def withdraw(amount: uint256) -> uint256: nonpayable
24     def migrate(newVersion: address): nonpayable
25 
26 
27 # interface to new version of FundManager used for migration
28 interface FundManager:
29     def token() -> address: view
30     def vault() -> address: view
31     def totalDebt() -> uint256: view
32     def totalDebtRatio() -> uint256: view
33     def queue(i: uint256) -> address: view
34     def strategies(
35         addr: address,
36     ) -> (bool, bool, bool, uint256, uint256, uint256, uint256): view
37     def initialize(): payable
38 
39 
40 # maximum number of active strategies
41 MAX_QUEUE: constant(uint256) = 20
42 
43 
44 struct Strategy:
45     approved: bool
46     active: bool
47     activated: bool  # sent to True once after strategy is active
48     debtRatio: uint256  # ratio of total assets this strategy can borrow
49     debt: uint256  # current amount borrowed
50     minBorrow: uint256  # minimum amount to borrow per call to borrow()
51     maxBorrow: uint256  # maximum amount to borrow per call to borrow()
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
62 event SetAdmin:
63     admin: address
64 
65 
66 event SetGuardian:
67     guardian: address
68 
69 
70 event SetWorker:
71     worker: address
72 
73 
74 event SetPause:
75     paused: bool
76 
77 
78 event SetVault:
79     vault: address
80 
81 
82 event ApproveStrategy:
83     strategy: indexed(address)
84 
85 
86 event RevokeStrategy:
87     strategy: indexed(address)
88 
89 
90 event AddStrategyToQueue:
91     strategy: indexed(address)
92 
93 
94 event RemoveStrategyFromQueue:
95     strategy: indexed(address)
96 
97 
98 event SetQueue:
99     queue: address[MAX_QUEUE]
100 
101 
102 event SetDebtRatios:
103     debtRatios: uint256[MAX_QUEUE]
104 
105 
106 event SetMinMaxBorrow:
107     strategy: indexed(address)
108     minBorrow: uint256
109     maxBorrow: uint256
110 
111 
112 event ReceiveEth:
113     sender: indexed(address)
114     amount: uint256
115 
116 
117 event BorrowFromVault:
118     vault: indexed(address)
119     amount: uint256
120     borrowed: uint256
121 
122 
123 event RepayVault:
124     vault: indexed(address)
125     amount: uint256
126     repaid: uint256
127 
128 
129 event ReportToVault:
130     vault: indexed(address)
131     total: uint256
132     debt: uint256
133     gain: uint256
134     loss: uint256
135 
136 
137 event Withdraw:
138     vault: indexed(address)
139     amount: uint256
140     actual: uint256
141     loss: uint256
142 
143 
144 event WithdrawStrategy:
145     strategy: indexed(address)
146     debt: uint256
147     need: uint256
148     loss: uint256
149     diff: uint256
150 
151 
152 event Borrow:
153     strategy: indexed(address)
154     amount: uint256
155     borrowed: uint256
156 
157 
158 event Repay:
159     strategy: indexed(address)
160     amount: uint256
161     repaid: uint256
162 
163 
164 event Report:
165     strategy: indexed(address)
166     gain: uint256
167     loss: uint256
168     debt: uint256
169 
170 
171 event MigrateStrategy:
172     oldStrategy: indexed(address)
173     newStrategy: indexed(address)
174 
175 
176 event Migrate:
177     fundManager: address
178     bal: uint256
179     totalDebt: uint256
180 
181 
182 paused: public(bool)
183 initialized: public(bool)
184 
185 vault: public(Vault)
186 ETH: constant(address) = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
187 # privileges - time lock >= admin >= guardian, worker
188 timeLock: public(address)
189 nextTimeLock: public(address)
190 admin: public(address)
191 guardian: public(address)
192 worker: public(address)
193 
194 totalDebt: public(uint256)  # sum of all debts of strategies
195 MAX_TOTAL_DEBT_RATIO: constant(uint256) = 10000
196 totalDebtRatio: public(uint256)  # sum of all debtRatios of strategies
197 strategies: public(HashMap[address, Strategy])  # all strategies
198 queue: public(address[MAX_QUEUE])  # list of active strategies
199 
200 # migration
201 OLD_MAX_QUEUE: constant(uint256) = 20  # must be <= MAX_QUEUE
202 oldFundManager: public(FundManager)
203 
204 
205 @external
206 def __init__(guardian: address, worker: address, oldFundManager: address):
207     self.timeLock = msg.sender
208     self.admin = msg.sender
209     self.guardian = guardian
210     self.worker = worker
211 
212     if oldFundManager != ZERO_ADDRESS:
213         self.oldFundManager = FundManager(oldFundManager)
214         assert self.oldFundManager.token() == ETH, "old fund manager token != ETH"
215 
216 
217 @external
218 @payable
219 def __default__():
220     log ReceiveEth(msg.sender, msg.value)
221 
222 
223 @external
224 @view
225 def token() -> address:
226     return ETH
227 
228 
229 @internal
230 def _sendEth(to: address, amount: uint256):
231     assert to != ZERO_ADDRESS, "to = 0 address"
232     raw_call(to, b"", value=amount)
233 
234 
235 @internal
236 def _safeTransfer(token: address, receiver: address, amount: uint256):
237     res: Bytes[32] = raw_call(
238         token,
239         concat(
240             method_id("transfer(address,uint256)"),
241             convert(receiver, bytes32),
242             convert(amount, bytes32),
243         ),
244         max_outsize=32,
245     )
246     if len(res) > 0:
247         assert convert(res, bool), "transfer failed"
248 
249 
250 @external
251 @payable
252 def initialize():
253     """
254     @notice Initialize fund manager. Transfer ETH and copy states if
255             old fund manager is set.
256     """
257     assert not self.initialized, "initialized"
258 
259     if self.oldFundManager.address == ZERO_ADDRESS:
260         assert msg.sender in [self.timeLock, self.admin], "!auth"
261     else:
262         assert msg.sender == self.oldFundManager.address, "!old fund manager"
263 
264         assert (
265             self.vault.address == self.oldFundManager.vault()
266         ), "old fund manager vault != vault"
267 
268         self.totalDebt = self.oldFundManager.totalDebt()
269         self.totalDebtRatio = self.oldFundManager.totalDebtRatio()
270 
271         for i in range(OLD_MAX_QUEUE):
272             addr: address = self.oldFundManager.queue(i)
273             if addr == ZERO_ADDRESS:
274                 break
275 
276             assert (
277                 IStrategy(addr).fundManager() == self
278             ), "strategy fund manager != self"
279 
280             approved: bool = False
281             active: bool = False
282             activated: bool = False
283             debtRatio: uint256 = 0
284             debt: uint256 = 0
285             minBorrow: uint256 = 0
286             maxBorrow: uint256 = 0
287             (
288                 approved,
289                 active,
290                 activated,
291                 debtRatio,
292                 debt,
293                 minBorrow,
294                 maxBorrow,
295             ) = self.oldFundManager.strategies(addr)
296             assert approved, "!approved"
297             assert active, "!active"
298             assert activated, "!activated"
299 
300             self.queue[i] = addr
301             self.strategies[addr] = Strategy(
302                 {
303                     approved: True,
304                     active: True,
305                     activated: True,
306                     debtRatio: debtRatio,
307                     debt: debt,
308                     minBorrow: minBorrow,
309                     maxBorrow: maxBorrow,
310                 }
311             )
312 
313     self.initialized = True
314 
315 
316 # Migration steps to new fund manager
317 #
318 # v = vault
319 # f1 = fund manager 1
320 # f2 = fund manager 2
321 # strats = active strategies of f1
322 #
323 # action                         | caller
324 # ----------------------------------------
325 # 1. f2.setVault(v)              | time lock
326 # 2. f1.setPause(true)           | admin
327 # 3. for s in strats             |
328 #      s.setFundManager(f2)      | time lock
329 # 4. send ETH to f2              | f1
330 # 5. f2 copy states from f1      | f2
331 #    - totalDebt                 |
332 #    - totalDebtRatio            |
333 #    - queue                     |
334 #    - active strategy params    |
335 # 6. f1 reset state              | f1
336 #    - totalDebt                 |
337 #    - active strategy debt      |
338 # 7. v.setFundManager(f2)        | time lock
339 
340 
341 @external
342 def migrate(fundManager: address):
343     """
344     @notice Migrate to new fund manager
345     @param fundManager Address of new fund manager
346     """
347     assert msg.sender == self.timeLock, "!time lock"
348     assert self.initialized, "!initialized"
349     assert self.paused, "!paused"
350 
351     assert FundManager(fundManager).token() == ETH, "new fund manager token != ETH"
352     assert (
353         FundManager(fundManager).vault() == self.vault.address
354     ), "new fund manager vault != vault"
355 
356     for strat in self.queue:
357         if strat == ZERO_ADDRESS:
358             break
359         assert (
360             IStrategy(strat).fundManager() == fundManager
361         ), "strategy fund manager != new fund manager"
362 
363     bal: uint256 = self.balance
364     FundManager(fundManager).initialize(value=bal)
365 
366     log Migrate(fundManager, bal, self.totalDebt)
367 
368     self.totalDebt = 0
369 
370     for strat in self.queue:
371         if strat == ZERO_ADDRESS:
372             break
373         self.strategies[strat].debt = 0
374 
375 
376 @external
377 def setNextTimeLock(nextTimeLock: address):
378     """
379     @notice Set next time lock
380     @param nextTimeLock Address of next time lock
381     """
382     assert msg.sender == self.timeLock, "!time lock"
383     self.nextTimeLock = nextTimeLock
384     log SetNextTimeLock(nextTimeLock)
385 
386 
387 @external
388 def acceptTimeLock():
389     """
390     @notice Accept time lock
391     @dev Only `nextTimeLock` can claim time lock
392     """
393     assert msg.sender == self.nextTimeLock, "!next time lock"
394     self.timeLock = msg.sender
395     self.nextTimeLock = ZERO_ADDRESS
396     log AcceptTimeLock(msg.sender)
397 
398 
399 @external
400 def setAdmin(admin: address):
401     assert msg.sender in [self.timeLock, self.admin], "!auth"
402     self.admin = admin
403     log SetAdmin(admin)
404 
405 
406 @external
407 def setGuardian(guardian: address):
408     assert msg.sender in [self.timeLock, self.admin], "!auth"
409     self.guardian = guardian
410     log SetGuardian(guardian)
411 
412 
413 @external
414 def setWorker(worker: address):
415     assert msg.sender in [self.timeLock, self.admin], "!auth"
416     self.worker = worker
417     log SetWorker(worker)
418 
419 
420 @external
421 def setPause(paused: bool):
422     assert msg.sender in [self.timeLock, self.admin, self.guardian], "!auth"
423     self.paused = paused
424     log SetPause(paused)
425 
426 
427 @external
428 def setVault(vault: address):
429     """
430     @notice Set vault
431     @param vault Address of vault
432     """
433     assert msg.sender == self.timeLock, "!time lock"
434     assert Vault(vault).token() == ETH, "vault token != ETH"
435 
436     self.vault = Vault(vault)
437 
438     log SetVault(vault)
439 
440 
441 @internal
442 @view
443 def _totalAssets() -> uint256:
444     """
445     @notice Total amount of ETH in this fund manager + total amount borrowed
446             by strategies
447     @dev Returns total amount of ETH managed by this contract
448     """
449     return self.balance + self.totalDebt
450 
451 
452 @external
453 @view
454 def totalAssets() -> uint256:
455     return self._totalAssets()
456 
457 
458 # array functions tested in test/Array.vy
459 @internal
460 def _pack():
461     arr: address[MAX_QUEUE] = empty(address[MAX_QUEUE])
462     i: uint256 = 0
463     for strat in self.queue:
464         if strat != ZERO_ADDRESS:
465             arr[i] = strat
466             i += 1
467     self.queue = arr
468 
469 
470 @internal
471 def _append(strategy: address):
472     assert self.queue[MAX_QUEUE - 1] == ZERO_ADDRESS, "queue > max"
473     self.queue[MAX_QUEUE - 1] = strategy
474     self._pack()
475 
476 
477 @internal
478 def _remove(i: uint256):
479     assert i < MAX_QUEUE, "i >= max"
480     assert self.queue[i] != ZERO_ADDRESS, "!zero address"
481     self.queue[i] = ZERO_ADDRESS
482     self._pack()
483 
484 
485 @internal
486 @view
487 def _find(strategy: address) -> uint256:
488     for i in range(MAX_QUEUE):
489         if self.queue[i] == strategy:
490             return i
491     raise "not found"
492 
493 
494 @external
495 def approveStrategy(strategy: address):
496     """
497     @notice Approve strategy
498     @param strategy Address of strategy
499     """
500     assert msg.sender == self.timeLock, "!time lock"
501 
502     assert not self.strategies[strategy].approved, "approved"
503     assert IStrategy(strategy).fundManager() == self, "strategy fund manager != this"
504     assert IStrategy(strategy).token() == ETH, "strategy token != ETH"
505 
506     self.strategies[strategy] = Strategy(
507         {
508             approved: True,
509             active: False,
510             activated: False,
511             debtRatio: 0,
512             debt: 0,
513             minBorrow: 0,
514             maxBorrow: 0,
515         }
516     )
517 
518     log ApproveStrategy(strategy)
519 
520 
521 @external
522 def revokeStrategy(strategy: address):
523     """
524     @notice Disapprove strategy
525     @param strategy Address of strategy
526     """
527     assert msg.sender in [self.timeLock, self.admin], "!auth"
528     assert self.strategies[strategy].approved, "!approved"
529     assert not self.strategies[strategy].active, "active"
530 
531     self.strategies[strategy].approved = False
532     log RevokeStrategy(strategy)
533 
534 
535 @external
536 def addStrategyToQueue(
537     strategy: address, debtRatio: uint256, minBorrow: uint256, maxBorrow: uint256
538 ):
539     """
540     @notice Activate strategy
541     @param strategy Address of strategy
542     @param debtRatio Ratio of total assets this strategy can borrow
543     @param minBorrow Minimum amount to borrow per call to borrow()
544     @param maxBorrow Maximum amount to borrow per call to borrow()
545     """
546     assert msg.sender in [self.timeLock, self.admin], "!auth"
547     assert self.strategies[strategy].approved, "!approved"
548     assert not self.strategies[strategy].active, "active"
549     assert self.totalDebtRatio + debtRatio <= MAX_TOTAL_DEBT_RATIO, "ratio > max"
550     assert minBorrow <= maxBorrow, "min borrow > max borrow"
551 
552     self._append(strategy)
553     self.strategies[strategy].active = True
554     self.strategies[strategy].activated = True
555     self.strategies[strategy].debtRatio = debtRatio
556     self.strategies[strategy].minBorrow = minBorrow
557     self.strategies[strategy].maxBorrow = maxBorrow
558     self.totalDebtRatio += debtRatio
559 
560     log AddStrategyToQueue(strategy)
561 
562 
563 @external
564 def removeStrategyFromQueue(strategy: address):
565     """
566     @notice Deactivate strategy
567     @param strategy Addres of strategy
568     """
569     assert msg.sender in [self.timeLock, self.admin, self.guardian], "!auth"
570     assert self.strategies[strategy].active, "!active"
571 
572     self._remove(self._find(strategy))
573     self.strategies[strategy].active = False
574     self.totalDebtRatio -= self.strategies[strategy].debtRatio
575     self.strategies[strategy].debtRatio = 0
576 
577     log RemoveStrategyFromQueue(strategy)
578 
579 
580 @external
581 def setQueue(queue: address[MAX_QUEUE]):
582     """
583     @notice Reorder queue
584     @param queue Array of active strategies
585     """
586     assert msg.sender in [self.timeLock, self.admin], "!auth"
587 
588     # check no gaps in new queue
589     zero: bool = False
590     for i in range(MAX_QUEUE):
591         strat: address = queue[i]
592         if strat == ZERO_ADDRESS:
593             if not zero:
594                 zero = True
595         else:
596             assert not zero, "gap"
597 
598     # Check old and new queue counts of non zero strategies are equal
599     for i in range(MAX_QUEUE):
600         oldStrat: address = self.queue[i]
601         newStrat: address = queue[i]
602         if oldStrat == ZERO_ADDRESS:
603             assert newStrat == ZERO_ADDRESS, "new != 0"
604         else:
605             assert newStrat != ZERO_ADDRESS, "new = 0"
606 
607     # Check new strategy is active and no duplicate
608     for i in range(MAX_QUEUE):
609         strat: address = queue[i]
610         if strat == ZERO_ADDRESS:
611             break
612         # code below will fail if duplicate strategy in new queue
613         assert self.strategies[strat].active, "!active"
614         self.strategies[strat].active = False
615 
616     # update queue
617     for i in range(MAX_QUEUE):
618         strat: address = queue[i]
619         if strat == ZERO_ADDRESS:
620             break
621         self.strategies[strat].active = True
622         self.queue[i] = strat
623 
624     log SetQueue(queue)
625 
626 
627 @external
628 def setDebtRatios(debtRatios: uint256[MAX_QUEUE]):
629     """
630     @notice Update debt ratios of active strategies
631     @param debtRatios Array of debt ratios
632     """
633     assert msg.sender in [self.timeLock, self.admin], "!auth"
634 
635     # check that we're only setting debt ratio on active strategy
636     for i in range(MAX_QUEUE):
637         if self.queue[i] == ZERO_ADDRESS:
638             assert debtRatios[i] == 0, "debt ratio != 0"
639 
640     # use memory to save gas
641     totalDebtRatio: uint256 = 0
642     for i in range(MAX_QUEUE):
643         addr: address = self.queue[i]
644         if addr == ZERO_ADDRESS:
645             break
646 
647         debtRatio: uint256 = debtRatios[i]
648         self.strategies[addr].debtRatio = debtRatio
649         totalDebtRatio += debtRatio
650 
651     self.totalDebtRatio = totalDebtRatio
652 
653     assert self.totalDebtRatio <= MAX_TOTAL_DEBT_RATIO, "total > max"
654 
655     log SetDebtRatios(debtRatios)
656 
657 
658 @external
659 def setMinMaxBorrow(strategy: address, minBorrow: uint256, maxBorrow: uint256):
660     """
661     @notice Update `minBorrow` and `maxBorrow` of approved strategy
662     @param minBorrow Minimum amount to borrow per call to borrow()
663     @param maxBorrow Maximum amount to borrow per call to borrow()
664     """
665     assert msg.sender in [self.timeLock, self.admin], "!auth"
666     assert self.strategies[strategy].approved, "!approved"
667     assert minBorrow <= maxBorrow, "min borrow > max borrow"
668 
669     self.strategies[strategy].minBorrow = minBorrow
670     self.strategies[strategy].maxBorrow = maxBorrow
671 
672     log SetMinMaxBorrow(strategy, minBorrow, maxBorrow)
673 
674 
675 # functions between Vault and this contract #
676 @external
677 def borrowFromVault(amount: uint256, _min: uint256):
678     """
679     @notice Borrow ETH from vault
680     @param amount Amount of ETH to borrow
681     @param _min Minimum amount to borrow
682     """
683     assert self.initialized, "!initialized"
684     assert msg.sender in [self.timeLock, self.admin, self.worker], "!auth"
685     # fails if vault not set
686     borrowed: uint256 = self.vault.borrow(amount)
687     assert borrowed >= _min, "borrowed < min"
688 
689     log BorrowFromVault(self.vault.address, amount, borrowed)
690 
691 
692 @external
693 def repayVault(amount: uint256, _min: uint256):
694     """
695     @notice Repay ETH to vault
696     @param amount Amount to repay
697     @param _min Minimum amount to repay
698     """
699     assert self.initialized, "!initialized"
700     assert msg.sender in [self.timeLock, self.admin, self.worker], "!auth"
701     # fails if vault not set
702     repaid: uint256 = self.vault.repay(amount, value=amount)
703     assert repaid >= _min, "repaid < min"
704 
705     log RepayVault(self.vault.address, amount, repaid)
706 
707 
708 @external
709 def reportToVault(_minTotal: uint256, _maxTotal: uint256):
710     """
711     @notice Report gain and loss to vault
712     @param _minTotal Minumum of total assets
713     @param _maxTotal Maximum of total assets
714     @dev `_minTotal` and `_maxTotal` is used to check that totalAssets is
715          within a reasonable range before this function is called
716     """
717     assert self.initialized, "!initialized"
718     assert msg.sender in [self.timeLock, self.admin, self.worker], "!auth"
719 
720     total: uint256 = self._totalAssets()
721     assert total >= _minTotal and total <= _maxTotal, "total not in range"
722 
723     debt: uint256 = self.vault.debt()
724     gain: uint256 = 0
725     loss: uint256 = 0
726 
727     if total > debt:
728         gain = min(total - debt, self.balance)
729     else:
730         loss = debt - total
731 
732     if gain > 0 or loss > 0:
733         self.vault.report(gain, loss, value=gain)
734 
735     log ReportToVault(self.vault.address, total, debt, gain, loss)
736 
737 
738 # functions between vault -> this contract -> strategies #
739 @internal
740 def _withdraw(amount: uint256) -> uint256:
741     """
742     @notice Withdraw ETH from active strategies
743     @param amount Amount of ETH to withdraw
744     @dev Returns sum of losses from active strategies that were withdrawn.
745     """
746     _amount: uint256 = amount
747     totalLoss: uint256 = 0
748     for strategy in self.queue:
749         if strategy == ZERO_ADDRESS:
750             break
751 
752         bal: uint256 = self.balance
753         if bal >= _amount:
754             break
755 
756         debt: uint256 = self.strategies[strategy].debt
757         need: uint256 = min(_amount - bal, debt)
758         if need == 0:
759             continue
760 
761         # loss must be <= debt
762         loss: uint256 = IStrategy(strategy).withdraw(need)
763         diff: uint256 = self.balance - bal
764 
765         if loss > 0:
766             _amount -= loss
767             totalLoss += loss
768             self.strategies[strategy].debt -= loss
769             self.totalDebt -= loss
770 
771         self.strategies[strategy].debt -= diff
772         self.totalDebt -= diff
773 
774         log WithdrawStrategy(strategy, debt, need, loss, diff)
775 
776     return totalLoss
777 
778 
779 @external
780 def withdraw(amount: uint256) -> uint256:
781     """
782     @notice Withdraw ETH from fund manager back to vault
783     @param amount Amount of ETH to withdraw
784     @dev Returns sum of losses from active strategies that were withdrawn.
785     """
786     assert self.initialized, "!initialized"
787     assert msg.sender == self.vault.address, "!vault"
788 
789     total: uint256 = self._totalAssets()
790     _amount: uint256 = min(amount, total)
791     assert _amount > 0, "withdraw = 0"
792 
793     debt: uint256 = self.vault.debt()
794     loss: uint256 = 0
795     if debt > total:
796         # debt > total can occur when strategies reported losses to this contract
797         # but this contract has not reported losses back to vault
798         loss = debt - total
799 
800     bal: uint256 = self.balance
801     if _amount > bal:
802         # try to withdraw until balance of fund manager >= _amount
803         loss += self._withdraw(_amount)
804         _amount = min(_amount, self.balance)
805 
806     if _amount > 0:
807         self._sendEth(msg.sender, _amount)
808 
809     log Withdraw(msg.sender, amount, _amount, loss)
810 
811     return loss
812 
813 
814 # functions between this contract and strategies #
815 @internal
816 @view
817 def _calcMaxBorrow(strategy: address) -> uint256:
818     """
819     @notice Calculate how much ETH strategy can borrow
820     @param strategy Address of strategy
821     @dev Returns amount of ETH that `strategy` can borrow
822     """
823     if (not self.initialized) or self.paused or self.totalDebtRatio == 0:
824         return 0
825 
826     # strategy debtRatio > 0 only if strategy is active
827     limit: uint256 = (
828         self.strategies[strategy].debtRatio * self._totalAssets() / self.totalDebtRatio
829     )
830     debt: uint256 = self.strategies[strategy].debt
831 
832     if debt >= limit:
833         return 0
834 
835     available: uint256 = min(limit - debt, self.balance)
836 
837     if available < self.strategies[strategy].minBorrow:
838         return 0
839     else:
840         return min(available, self.strategies[strategy].maxBorrow)
841 
842 
843 @external
844 @view
845 def calcMaxBorrow(strategy: address) -> uint256:
846     return self._calcMaxBorrow(strategy)
847 
848 
849 @internal
850 @view
851 def _calcOutstandingDebt(strategy: address) -> uint256:
852     """
853     @notice Calculate amount of ETH that `strategy` should pay back to fund manager
854     @param strategy Address of strategy
855     @dev Returns minimum amount of ETH strategy should repay
856     """
857     if not self.initialized:
858         return 0
859 
860     if self.totalDebtRatio == 0:
861         return self.strategies[strategy].debt
862 
863     limit: uint256 = (
864         self.strategies[strategy].debtRatio * self.totalDebt / self.totalDebtRatio
865     )
866     debt: uint256 = self.strategies[strategy].debt
867 
868     if self.paused:
869         return debt
870     elif debt <= limit:
871         return 0
872     else:
873         return debt - limit
874 
875 
876 @external
877 @view
878 def calcOutstandingDebt(strategy: address) -> uint256:
879     return self._calcOutstandingDebt(strategy)
880 
881 
882 @external
883 @view
884 def getDebt(strategy: address) -> uint256:
885     """
886     @notice Return debt of strategy
887     @param strategy Address of strategy
888     @dev Returns current debt of strategy
889     """
890     return self.strategies[strategy].debt
891 
892 
893 @external
894 @nonreentrant("lock")
895 def borrow(amount: uint256) -> uint256:
896     """
897     @notice Borrow ETH from fund manager
898     @param amount Amount of ETH to borrow
899     @dev Returns actual amount sent
900     @dev Only active strategy can borrow
901     """
902     assert self.initialized, "!initialized"
903     assert not self.paused, "paused"
904     assert self.strategies[msg.sender].active, "!active"
905 
906     _amount: uint256 = min(amount, self._calcMaxBorrow(msg.sender))
907     assert _amount > 0, "borrow = 0"
908 
909     self._sendEth(msg.sender, _amount)
910 
911     # include any fee on transfer to debt
912     self.strategies[msg.sender].debt += _amount
913     self.totalDebt += _amount
914 
915     log Borrow(msg.sender, amount, _amount)
916 
917     return _amount
918 
919 
920 @external
921 @payable
922 def repay(amount: uint256) -> uint256:
923     """
924     @notice Repay debt to fund manager
925     @param amount Amount of ETH to repay
926     @dev Returns actual amount repaid
927     @dev Only approved strategy can repay
928     """
929     assert self.initialized, "!initialized"
930     assert self.strategies[msg.sender].approved, "!approved"
931 
932     assert amount == msg.value, "amount != msg.value"
933     assert amount > 0, "repay = 0"
934 
935     self.strategies[msg.sender].debt -= amount
936     self.totalDebt -= amount
937 
938     log Repay(msg.sender, amount, amount)
939 
940     return amount
941 
942 
943 @external
944 @payable
945 def report(gain: uint256, loss: uint256):
946     """
947     @notice Report gain and loss from strategy
948     @param gain Amount of profit
949     @param loss Amount of loss
950     """
951     assert self.initialized, "!initialized"
952     assert self.strategies[msg.sender].active, "!active"
953     # can't have both gain and loss > 0
954     assert (gain >= 0 and loss == 0) or (gain == 0 and loss >= 0), "gain and loss > 0"
955     assert gain == msg.value, "gain != msg.value"
956 
957     if gain > 0:
958         pass
959     elif loss > 0:
960         self.strategies[msg.sender].debt -= loss
961         self.totalDebt -= loss
962 
963     log Report(msg.sender, gain, loss, self.strategies[msg.sender].debt)
964 
965 
966 @external
967 def migrateStrategy(oldStrat: address, newStrat: address):
968     """
969     @notice Migrate strategy
970     @param oldStrat Address of current strategy
971     @param newStrat Address of strategy to migrate to
972     """
973     assert self.initialized, "!initialized"
974     assert msg.sender in [self.timeLock, self.admin], "!auth"
975     assert self.strategies[oldStrat].active, "old !active"
976     assert self.strategies[newStrat].approved, "new !approved"
977     assert not self.strategies[newStrat].activated, "activated"
978 
979     strat: Strategy = self.strategies[oldStrat]
980 
981     self.strategies[newStrat] = Strategy(
982         {
983             approved: True,
984             active: True,
985             activated: True,
986             debtRatio: strat.debtRatio,
987             debt: strat.debt,
988             minBorrow: strat.minBorrow,
989             maxBorrow: strat.maxBorrow,
990         }
991     )
992 
993     self.strategies[oldStrat].active = False
994     self.strategies[oldStrat].debtRatio = 0
995     self.strategies[oldStrat].debt = 0
996     self.strategies[oldStrat].minBorrow = 0
997     self.strategies[oldStrat].maxBorrow = 0
998 
999     # find and replace strategy
1000     i: uint256 = self._find(oldStrat)
1001     self.queue[i] = newStrat
1002 
1003     IStrategy(oldStrat).migrate(newStrat)
1004     log MigrateStrategy(oldStrat, newStrat)
1005 
1006 
1007 @external
1008 def sweep(token: address):
1009     """
1010     @notice Transfer any token accidentally sent to this contract to admin or
1011             time lock
1012     """
1013     assert msg.sender in [self.timeLock, self.admin], "!auth"
1014     self._safeTransfer(token, msg.sender, ERC20(token).balanceOf(self))