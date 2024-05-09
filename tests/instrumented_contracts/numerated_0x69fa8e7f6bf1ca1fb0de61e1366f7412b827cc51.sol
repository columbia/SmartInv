1 # @version ^0.2.11
2 # @dev Implementation of multi-layers space and time rebasing ERC-20 token standard.
3 # @dev copyright kader@enreach.io and kashaf@enreach.io
4 # based on https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
5 
6 from vyper.interfaces import ERC20
7 
8 implements: ERC20
9 
10 event Transfer:
11     sender: indexed(address)
12     receiver: indexed(address)
13     value: uint256
14 
15 event Approval:
16     owner: indexed(address)
17     spender: indexed(address)
18     value: uint256
19 
20 event ReceivedEther:
21     sender: indexed(address)
22     value: uint256
23 
24 event OwnershipTransferred:
25     previousOwner: indexed(address)
26     newOwner: indexed(address)
27 
28 # EIP-20 compliant name symbol and decimals
29 name: public(String[64])
30 symbol: public(String[32])
31 decimals: public(uint256)
32 
33 # additional decimals used for calculations
34 scale: public(uint256)
35 
36 # exponent
37 expanse: public(int128)
38 extent: public(uint256)
39 extent_max: public(uint256)
40 
41 # temporal timer
42 initpulse: public(uint256)
43 nextpulse: public(uint256)
44 
45 struct Account:
46     amount: uint256
47     lode: uint256
48     expanse: int128
49 
50 
51 struct Lode:
52     total: uint256
53     total_e: uint256
54     expanse: int128
55     tax_id: uint256
56     itaxfree: bool
57     etaxfree: bool
58    
59 NUM_OF_TEMPORAL_LODES: constant(uint256) = 25
60 STAKING_LODE: constant(uint256) = NUM_OF_TEMPORAL_LODES  # 25
61 FROZEN_LODE: constant(uint256) = STAKING_LODE + 1 #26
62 RESERVE_LODE: constant(uint256) = FROZEN_LODE + 1 #27
63 SAFE_LODE: constant(uint256) = RESERVE_LODE + 1 #28
64 RESERVED1_LODE: constant(uint256) = SAFE_LODE + 1 #29
65 NUM_OF_LODES: constant(uint256) = 32 
66 NUM_OF_TAX_POLICIES: constant(uint256) = 4
67 
68 
69 owner: address
70 currentLode: public(uint256)
71 transferLocked: public(bool)
72 taxOn: public(bool)
73 temporal_tax_num: public(uint256)
74 temporal_tax_num2: public(uint256)
75 temporal_tax_den: public(uint256)
76 tax_numerators: public(uint256[NUM_OF_LODES][NUM_OF_TAX_POLICIES])
77 tax_numeratorsum: public(uint256[NUM_OF_TAX_POLICIES])
78 tax_denominator: public(uint256[NUM_OF_TAX_POLICIES])
79 tax_toflush: public(uint256[NUM_OF_TAX_POLICIES])
80 tax_airdrop_num: public(uint256)
81 tax_airdrop_den: public(uint256)
82 lodes: Lode[NUM_OF_LODES]
83 
84 accounts: HashMap[address, Account]
85 allowances: HashMap[address, HashMap[address, uint256]]
86 privileged: HashMap[address, bool]
87 arbtrust: HashMap[address, bool]
88 
89 
90 @internal
91 def _deallocate0(_debtor: address) -> uint256:
92     """
93     @dev deallocate all funds from a wallet
94     @param _debtor The address to deallocate all the funds from.
95     @return An uint256 specifying the amount of scaled tokens remaining
96     """
97     debtor: Account = self.accounts[_debtor]
98     slode: Lode = self.lodes[debtor.lode]
99     amount_e: uint256 = debtor.amount
100     if amount_e == 0:
101         self.accounts[_debtor] = empty(Account)
102         return 0
103     if debtor.expanse != slode.expanse:
104         amount_e = shift(debtor.amount, debtor.expanse - slode.expanse)
105     amount_s: uint256 = amount_e * slode.total / slode.total_e
106     self.accounts[_debtor] = empty(Account)
107     self.lodes[debtor.lode].total -= amount_s
108     self.lodes[debtor.lode].total_e -= amount_e
109     return amount_s
110 
111 @internal
112 def _deallocate(_debtor: address, _amount_s: uint256):
113     """
114     @dev deallocate funds from a wallet
115     @param _debtor The address to deallocate the funds from.
116     @param _amount_s scaled amount of funds.
117     """
118     debtor: Account = self.accounts[_debtor]
119     slode: Lode = self.lodes[debtor.lode]
120     if debtor.expanse != slode.expanse:
121         self.accounts[_debtor].amount = shift(debtor.amount, debtor.expanse - slode.expanse)
122         self.accounts[_debtor].expanse = slode.expanse
123     amount_e: uint256 = _amount_s * slode.total_e / slode.total
124     self.accounts[_debtor].amount -= amount_e
125     if self.accounts[_debtor].amount < self.scale:
126         amount_e += self.accounts[_debtor].amount
127         self.accounts[_debtor].amount = 0
128         amount_s: uint256 = amount_e * slode.total / slode.total_e
129         self.lodes[debtor.lode].total -= amount_s
130     else:
131         self.lodes[debtor.lode].total -= _amount_s
132     self.lodes[debtor.lode].total_e -= amount_e
133     if self.accounts[_debtor].amount == 0:
134         self.accounts[_debtor] = empty(Account)
135 
136 
137 @internal
138 def _allocate(_creditor: address, _amount_s: uint256):
139     """
140     @dev deallocate funds from a wallet and from a lode
141     @param _creditor The address to allocate the funds to.
142     @param _amount_s The address to allocate the scaled funds to.
143     """
144     creditor: Account = self.accounts[_creditor]
145     if (creditor.amount ==0) and (creditor.lode ==0):
146         if _creditor.is_contract:
147             creditor.lode = FROZEN_LODE
148             self.accounts[_creditor].lode = FROZEN_LODE
149         else:
150             creditor.lode = self.currentLode
151             self.accounts[_creditor].lode = self.currentLode
152     dlode: Lode = self.lodes[creditor.lode]
153     if creditor.amount != 0:
154         self.accounts[_creditor].amount = shift(creditor.amount, creditor.expanse - dlode.expanse)
155     self.accounts[_creditor].expanse = dlode.expanse
156     if dlode.total_e == 0:
157         self.lodes[creditor.lode].total_e += _amount_s
158         self.accounts[_creditor].amount += _amount_s
159     else:
160         amount_e: uint256 = _amount_s * dlode.total_e / dlode.total
161         self.lodes[creditor.lode].total_e += amount_e
162         self.accounts[_creditor].amount += amount_e
163     self.lodes[creditor.lode].total += _amount_s
164 
165 
166 
167 @external
168 def setLode(_wallet:address, _lode:uint256):
169     """
170     @dev set the lode of a wallet
171     @param _wallet The address of the wallet
172     @param _lode The lode to which to allocate the wallet
173     """
174     if (msg.sender == self.owner):
175         assert (_lode < NUM_OF_LODES) #, "Out of bounds lode"
176     elif (self.privileged[msg.sender] == True):
177         assert _lode < NUM_OF_TEMPORAL_LODES #, "Out of bounds lode or access to priviledged lode"
178     else:
179         raise "Unauthorized"
180     amount: uint256 = self._deallocate0(_wallet)
181     self.accounts[_wallet].lode = _lode
182     self._allocate(_wallet, amount)
183 
184 @external
185 def setTaxStatus(_status: bool):
186     """
187     @dev tax Status (On->True or Off)
188     @param _status status of tax
189     """
190     assert msg.sender == self.owner
191     self.taxOn = _status
192 
193 @external
194 def setTax(_tax_id:uint256, _tax_numerators:uint256[NUM_OF_LODES], _tax_denominator:uint256):
195     """
196     @dev set the taxes of a tax_id
197     @param _tax_id the tax id 
198     @param _tax_numerators Tax numerator per lode
199     @param _tax_denominator Tax denominator
200     """
201     assert (msg.sender == self.owner)
202     self.tax_numerators[_tax_id] = _tax_numerators
203     self.tax_denominator[_tax_id] = _tax_denominator
204     sum:uint256 = 0
205     for i in range(NUM_OF_LODES):
206         sum += _tax_numerators[i]
207     self.tax_numeratorsum[_tax_id] = sum
208         
209 
210 
211 @external
212 def setLodeTaxId(_lode:uint256, _tax_id:uint256):
213     """
214     @dev set the tax_id of a lode
215     @param _lode the lode number
216     @param _tax_id Tax id
217     """
218     assert (msg.sender == self.owner)
219     self.lodes[_lode].tax_id = _tax_id
220 
221 @external
222 def setPrivileged(_wallet: address, _status: bool):
223     """
224     @dev change Privileged status of wallet
225     @param _wallet The address of the wallet
226     @param _status Which status to set to the wallet
227     """
228     assert (msg.sender == self.owner)
229     self.privileged[_wallet] = _status
230 
231 @external
232 def setArbTrusted(_wallet: address, _status: bool):
233     """
234     @dev change ArbTrust status of wallet
235     @param _wallet The address of the wallet
236     @param _status Which status to set to the wallet
237     """
238     assert (msg.sender == self.owner)
239     self.arbtrust[_wallet] = _status
240 
241 @view
242 @external
243 def isPrivileged(_wallet: address) -> bool:
244     """
245     @dev check Privileged status of wallet
246     @param _wallet The address of the wallet
247     @return A bool specifiying if the wallet is priviledged
248     """
249     return self.privileged[_wallet]
250 
251 @view
252 @external
253 def getLode(_wallet:address) -> uint256:
254     """
255     @dev get account lode
256     @param _wallet The address of the wallet
257     @return An uint256 specifying the lode of the wallet
258     """
259     assert (msg.sender == self.owner) or self.privileged[msg.sender]
260     return self.accounts[_wallet].lode
261 
262 
263 @view
264 @internal
265 def getBalance(_wallet : address) -> uint256:
266     """
267     @dev get balance of wallet
268     @param _wallet The address of the wallet
269     @return An uint256 specifying the scaled balance of the wallet
270     """
271     account: Account = self.accounts[_wallet]
272     lode: Lode = self.lodes[account.lode]
273     if lode.total_e == 0:
274         return 0
275     else:
276         return shift(account.amount, account.expanse - lode.expanse) * lode.total / lode.total_e
277 
278 @view
279 @external
280 def balanceLode(_wallet : address) -> (uint256, uint256, uint256, int128, int128):
281     """
282     @dev get detailed balance of a wallet
283     @param _wallet the wallet
284     @return internal balance of wallet, lode scaled balance, lode internal balance, account and lode expanse
285     """
286     assert (msg.sender == self.owner) or self.privileged[msg.sender] or (_wallet == msg.sender)
287     account: Account = self.accounts[_wallet]
288     lode: Lode = self.lodes[account.lode]
289     return (account.amount, lode.total, lode.total_e, account.expanse, lode.expanse)
290 
291 @view
292 @external
293 def lodeBalance(_lode: uint256) ->  (uint256, uint256, int128):
294     """
295     @dev get balance of a lode
296     @param _lode lode number
297     @return lode scaled balance, lode internal balance and lode expanse
298     """
299     assert (msg.sender == self.owner) or self.privileged[msg.sender]
300     lode: Lode = self.lodes[_lode]
301     return (lode.total, lode.total_e, lode.expanse)
302 
303 
304 @external
305 def setLodeTaxFree(_lode: uint256, _itaxfree: bool, _etaxfree: bool):
306     """
307     @dev set lode tax excemptions rules
308     @param _lode lode number
309     @param _itaxfree is tax free on credit
310     @param _etaxfree is tax free on debit
311     """
312     assert (msg.sender == self.owner)
313     self.lodes[_lode].itaxfree = _itaxfree
314     self.lodes[_lode].etaxfree = _etaxfree
315 
316 @view
317 @external
318 def getLodeTaxFree(_lode: uint256) -> (bool, bool, uint256):
319     """
320     @dev get lode tax rules
321     @param _lode lode number
322     @return _itaxfree, _etaxfree and tax_id
323     """
324     assert (msg.sender == self.owner) or self.privileged[msg.sender]
325     return (self.lodes[_lode].itaxfree, self.lodes[_lode].etaxfree, self.lodes[_lode].tax_id)
326 
327 
328 @external
329 def __init__(_name: String[64], _symbol: String[32], _decimals: uint256, _supply: uint256, _transferLocked: bool,
330     _tax_nums: uint256[NUM_OF_LODES], _tax_denom: uint256):
331     self.owner = msg.sender
332     self.tax_numerators[0] = _tax_nums
333     for i in range(NUM_OF_LODES):
334         self.tax_numeratorsum[0] += _tax_nums[i]
335     self.tax_denominator[0] = _tax_denom
336     self.tax_airdrop_num = 1
337     self.tax_airdrop_den = 20
338     self.temporal_tax_num = 10000
339     self.temporal_tax_num2 = 2664
340     self.temporal_tax_den = 30000
341     self.transferLocked = _transferLocked
342     self.taxOn = not _transferLocked
343     self.scale = 10 ** _decimals
344     init_supply: uint256 = _supply * 10 ** _decimals
345     self.extent = init_supply * self.scale
346     self.extent_max =  init_supply * self.scale * self.scale
347     a_supply: uint256 = init_supply * self.scale
348     self.name = _name
349     self.symbol = _symbol
350     self.decimals = _decimals
351     self.accounts[msg.sender].amount = a_supply
352     self.lodes[self.accounts[msg.sender].lode] = Lode({total: a_supply, total_e: a_supply, expanse: 0, itaxfree:False, etaxfree:False, tax_id:0})
353     self.lodes[STAKING_LODE] = Lode({total: 0, total_e: 0, expanse: 0, itaxfree: True, etaxfree: True, tax_id:0})    
354     self.lodes[RESERVE_LODE] = Lode({total: 0, total_e: 0, expanse: 0, itaxfree: True, etaxfree: False, tax_id:0})    
355     self.lodes[RESERVED1_LODE] = Lode({total: 0, total_e: 0, expanse: 0, itaxfree: True, etaxfree: True, tax_id:0})    
356     log Transfer(ZERO_ADDRESS, msg.sender, init_supply)
357     log OwnershipTransferred(ZERO_ADDRESS, msg.sender)
358 
359 
360 
361 @view
362 @external
363 def totalSupply() -> uint256:
364     """
365     @dev Total number of tokens in existence. EIP-20 function totalSupply()
366     @return total supply
367     """
368     sum:uint256 = 0
369     for i in range(NUM_OF_LODES):
370         sum += self.lodes[i].total
371     return sum / self.scale
372 
373 @view
374 @external
375 def balanceOf(_wallet : address) -> uint256:
376     """
377     @dev Total number of tokens in existence. EIP-20 function balanceOf(address _owner)
378     @return balance
379     """
380     return self.getBalance(_wallet) / self.scale
381 
382 @view
383 @external
384 def allowance(_owner : address, _spender : address) -> uint256:
385     """
386     @dev Function to check the amount of tokens that an owner allowed to a spender.
387          EIP-20 function allowance(address _owner, address _spender)
388     @param _owner The address which owns the funds.
389     @param _spender The address which will spend the funds.
390     @return An uint256 specifying the amount of tokens still available for the spender.
391     """
392     return self.allowances[_owner][_spender]
393 
394 @external
395 def setTemporalTax(_num: uint256, _num2: uint256, _den: uint256):
396     """
397     @dev modify the temporal tax
398     @param _num tax numerator
399     @param _num2 tax arb
400     @param _den tax denominator
401     """
402     assert msg.sender == self.owner
403     assert _den != 0
404     self.temporal_tax_num = _num
405     self.temporal_tax_num2 = _num2
406     self.temporal_tax_den = _den
407 
408 @internal
409 def temporalTax() -> bool:
410     """
411     @dev This function trigger a temporal tax event if required.
412     @return True if tax event happened, False otherwise
413     """
414     if (self.initpulse != 0):
415         self.currentLode = ((self.nextpulse - self.initpulse) / 86400) % NUM_OF_TEMPORAL_LODES
416         if (block.timestamp > self.nextpulse):
417             tax: uint256 = self.lodes[self.currentLode].total * self.temporal_tax_num / self.temporal_tax_den
418             self.lodes[self.currentLode].total -= tax
419             self.lodes[RESERVE_LODE].total += tax
420             self.nextpulse += 86400
421             if self.currentLode == 0:
422                 if (self.temporal_tax_den - self.temporal_tax_num) != 0:
423                     self.extent = self.extent * self.temporal_tax_den / (self.temporal_tax_den - self.temporal_tax_num)
424                     if self.extent  > self.extent_max:
425                         self.extent /= 2
426                         self.expanse += 1
427             if self.lodes[self.currentLode].expanse != self.expanse:
428                 self.lodes[self.currentLode].total_e = shift(self.lodes[self.currentLode].total_e,
429                     self.lodes[self.currentLode].expanse - self.expanse)
430                 self.lodes[self.currentLode].expanse = self.expanse
431             return True
432     return False
433 
434 @external
435 def changeTaxAirDrop(_num: uint256, _den:uint256):
436     assert (msg.sender == self.owner)
437     assert (_den != 0)
438     self.tax_airdrop_num = _num
439     self.tax_airdrop_den = _den
440 
441 @external
442 @view
443 def simTaxAirDrop() -> uint256:
444     sum:uint256 = 0
445     for tax_id in range(NUM_OF_TAX_POLICIES):
446         tax:uint256 = self.tax_toflush[tax_id]
447         if tax != 0:
448             sum += tax * self.tax_airdrop_num / self.tax_airdrop_den
449     return sum/self.scale
450 
451 @internal
452 def distributeTax(_to:address):
453     airdrop:uint256 = 0
454     for tax_id in range(NUM_OF_TAX_POLICIES):
455         tax:uint256 = self.tax_toflush[tax_id]
456         if tax != 0:
457             airdrop0:uint256 = tax * self.tax_airdrop_num / self.tax_airdrop_den
458             airdrop += airdrop0
459             tax -= airdrop0
460             tax_num:uint256 = self.tax_numeratorsum[tax_id]
461             for i in range(NUM_OF_LODES):
462                 self.lodes[i].total +=  tax * self.tax_numerators[tax_id][i] / tax_num
463         self.tax_toflush[tax_id] = 0
464     if airdrop != 0:
465         self._allocate(_to, airdrop)
466     self.temporalTax()
467 
468             
469 @external
470 def triggerDistributeTax():
471     self.distributeTax(msg.sender)
472 
473 @external
474 def triggerTemporalTax() -> bool:
475     """
476     @dev This function trigger a temporal tax event if required.
477     @return True if tax event happened, False otherwise
478     """
479     return self.temporalTax()
480 
481 @view
482 @external
483 def transferedAfterTax(_debtor: address, _creditor: address, _value: uint256) -> uint256:
484     """
485     @dev evaluate amount sent during Transfer 
486     @param _debtor The address to transfer from.
487     @param _creditor The address to transfer to.
488     @param _value The amount to be transferred.
489     @return amount remaining to be transferred
490     """
491     amount: uint256 = _value * self.scale
492     d_lode: uint256 = self.accounts[_debtor].lode
493     c_lode: uint256 = self.accounts[_creditor].lode
494     tax_id: uint256 = self.lodes[d_lode].tax_id
495     if (not self.lodes[d_lode].etaxfree) and (not self.lodes[c_lode].itaxfree) and self.taxOn:
496         tax: uint256 = amount * self.tax_numeratorsum[tax_id] / self.tax_denominator[tax_id]
497         amount -= tax
498     if self.arbtrust[_debtor] and self.arbtrust[_creditor]:
499         tax:uint256 = amount * self.temporal_tax_num2 / self.temporal_tax_den
500         amount -= tax
501     return amount / self.scale
502 
503 
504 @internal
505 def _transfer(_debtor: address, _creditor: address, _value: uint256):
506     """
507     @dev Transfer token for a specified address
508     @param _debtor The address to transfer from.
509     @param _creditor The address to transfer to.
510     @param _value The amount to be transferred.
511     """
512     #if (block.timestamp > self.nextpulse) and (self.initpulse != 0):
513     #    self.temporalTax()
514     amount: uint256 = _value * self.scale
515     d_lode: uint256 = self.accounts[_debtor].lode
516     c_lode: uint256 = self.accounts[_creditor].lode
517     tax_id: uint256 = self.lodes[d_lode].tax_id
518     self._deallocate(_debtor, amount)
519     if (not self.lodes[d_lode].etaxfree) and (not self.lodes[c_lode].itaxfree) and self.taxOn:
520         tax: uint256 = amount * self.tax_numeratorsum[tax_id] / self.tax_denominator[tax_id]
521         amount -= tax
522         self.tax_toflush[tax_id] += tax
523     if self.arbtrust[_debtor] and self.arbtrust[_creditor]:
524         tax:uint256 = amount * self.temporal_tax_num2 / self.temporal_tax_den
525         amount -= tax
526         self.lodes[RESERVED1_LODE].total += tax
527     if (self.initpulse != 0):
528         if (self.currentLode != d_lode) and (d_lode < NUM_OF_TEMPORAL_LODES):
529             amount0: uint256 = self._deallocate0(_debtor)
530             if amount0 != 0:
531                 self.accounts[_debtor].lode = self.currentLode
532                 self._allocate(_debtor, amount0)
533     self._allocate(_creditor, amount)
534 
535 
536 @external
537 def transfer(_to : address, _value : uint256) -> bool:
538     """
539     @dev Transfer token for a specified address. EIP-20 function transfer(address _to, uint256 _value) 
540     @param _to The address to transfer to.
541     @param _value The amount to be transferred.
542     """
543     assert (self.transferLocked == False) or self.privileged[msg.sender] or (msg.sender == self.owner), "You are not allowed to make transfer"
544     self._transfer(msg.sender, _to, _value)
545     log Transfer(msg.sender, _to, _value)
546     return True
547 
548 
549 @external
550 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
551     """
552      @dev Transfer tokens from one address to another. EIP function transferFrom(address _from, address _to, uint256 _value) 
553      @param _from address The address which you want to send tokens from
554      @param _to address The address which you want to transfer to
555      @param _value uint256 the amount of tokens to be transferred
556     """
557     assert (self.transferLocked == False) or self.privileged[msg.sender] or self.privileged[_from] or (msg.sender == self.owner), "You are not allowed to make transfer"
558     self._transfer(_from, _to, _value)
559     self.allowances[_from][msg.sender] -= _value
560     log Transfer(_from, _to, _value)
561     return True
562 
563 @internal
564 def _approve(_owner: address, _spender : address, _value : uint256) -> bool:
565     """
566     @dev Approve the passed address to spend the specified amount of tokens on behalf of _owner.
567     @param _owner The address which will provide the funds.
568     @param _spender The address which will spend the funds.
569     @param _value The amount of tokens to be spent.
570     """
571     self.allowances[_owner][_spender] = _value
572     log Approval(_owner, _spender, _value)
573     return True
574 
575 
576 @external
577 def approve(_spender : address, _value : uint256) -> bool:
578     """
579     @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
580          Beware that changing an allowance with this method brings the risk that someone may use both the old
581          and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
582          race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
583          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
584          EIP-20 function approve(address _spender, uint256 _value)
585     
586     @param _spender The address which will spend the funds.
587     @param _value The amount of tokens to be spent.
588     """
589     self._approve(msg.sender, _spender,_value)
590     return True
591 
592 
593 @external
594 def increaseAllowance(_spender : address, _addedValue : uint256) -> bool:
595     """
596     @dev Atomically increases the allowance granted to `spender` by the caller.
597     This is an alternative to {approve} that can be used as a mitigation 
598     for problems described in {IERC20-approve}.
599     Emits an {Approval} event indicating the updated allowance.
600     - `spender` cannot be the zero address.
601 
602     @param _spender The address which will spend the funds.
603     @param _addedValue The amount of additional tokens to be spent.
604     """
605     self._approve(msg.sender, _spender, self.allowances[msg.sender][_spender] + _addedValue)
606     return True
607 
608 @external
609 def decreaseAllowance(_spender : address, _subtractedValue : uint256) -> bool:
610     """
611     @dev Atomically decreases the allowance granted to `spender` by the caller.
612     This is an alternative to {approve} that can be used as a mitigation 
613     for problems described in {IERC20-approve}.
614     Emits an {Approval} event indicating the updated allowance.
615     - `spender` cannot be the zero address.
616     - `spender` must have allowance for the caller of at least __subtractedValue
617     @param _spender The address which will spend the funds.
618     @param _subtractedValue The amount of tokens to be Decreased from allowance.
619     """
620     self._approve(msg.sender, _spender, self.allowances[msg.sender][_spender] - _subtractedValue)
621     return True
622 
623 @external
624 def startPulse():
625     """
626     @dev start temporalTax Pulse
627     """
628     assert msg.sender == self.owner
629     assert self.initpulse == 0
630     self.taxOn = True
631     self.initpulse = block.timestamp / 86400 * 86400
632     self.nextpulse = self.initpulse + 86400 * NUM_OF_TEMPORAL_LODES
633 
634 
635 @external
636 def lockTransfer(_status: bool):
637     """
638     @dev lock or unlock transfer
639     @param _status status of normal transfer
640     """
641     assert msg.sender == self.owner
642     self.transferLocked = _status
643     
644 
645 
646 @external
647 @payable
648 def __default__():
649     """
650     @dev Process ether received by default function
651     """
652     log ReceivedEther(msg.sender, msg.value)
653 
654 
655 @external
656 def withdrawEth(_amount: uint256):
657     """
658     @dev Withdraw ether from smart contract
659     @param _amount number of wei 
660     """
661     assert msg.sender == self.owner
662     send(self.owner, _amount)
663 
664 @internal
665 def _consume(_debtor: address, _value: uint256):
666     """
667     @dev Consume token of a specified address
668     @param _debtor The address to transfer from.
669     @param _value The amount to be transferred.
670     """
671     amount: uint256 = _value * self.scale
672     dtotal: uint256 = 0
673     tax_id: uint256 = self.lodes[self.accounts[_debtor].lode].tax_id
674     self._deallocate(_debtor, amount)
675     for i in range(NUM_OF_LODES):
676         dtotal += self.tax_denominator[tax_id]
677     if dtotal ==0:
678         self.lodes[STAKING_LODE].total += amount
679     else:
680         for i in range(NUM_OF_LODES):
681             self.lodes[i].total += amount * self.tax_numerators[tax_id][i] / dtotal
682 
683 
684 @external
685 def consume(_value: uint256):
686     """
687     @dev Consume token of sender
688     @param _value The amount to be consumed.
689     """
690     self._consume(msg.sender, _value)
691     
692 @external
693 def consumeFrom(_wallet: address, _value: uint256):
694     """
695     @dev Consume token of sender
696     @param _wallet the wallet to 
697     @param _value The amount to be consumed
698     """
699     assert (msg.sender == self.owner)
700     assert self.accounts[_wallet].lode == FROZEN_LODE
701     self._consume(_wallet, _value)
702 
703 @internal
704 def _burn(_to: address, _value: uint256):
705     """
706     @dev Internal function that burns an amount of the token of a given
707          account.
708     @param _to The account whose tokens will be burned.
709     @param _value The amount that will be burned.
710     """
711     assert _to != ZERO_ADDRESS
712     self._deallocate(_to, _value * self.scale)
713     log Transfer(_to, ZERO_ADDRESS, _value)
714 
715 
716 @external
717 def burn(_value: uint256):
718     """
719     @dev Burn an amount of the token of msg.sender.
720     @param _value The amount that will be burned.
721     """
722     self._burn(msg.sender, _value)
723 
724 
725 @external
726 def burnFrom(_to: address, _value: uint256):
727     """
728     @dev Burn an amount of the token from a given account.
729     @param _to The account whose tokens will be burned.
730     @param _value The amount that will be burned.
731     """
732     self.allowances[_to][msg.sender] -= _value
733     self._burn(_to, _value)
734 
735 @external
736 def transferOwnership(_owner: address):
737     assert msg.sender == self.owner
738     assert _owner != ZERO_ADDRESS
739     log OwnershipTransferred(self.owner, _owner)
740     self.owner = _owner
741     
742 
743 @external
744 def xtransfer(_token: address, _creditor : address, _value : uint256) -> bool:
745     """
746     @dev Relay ERC-20 transfer request 
747     """
748     assert msg.sender == self.owner
749     return ERC20(_token).transfer(_creditor, _value)
750 
751 
752 @external
753 def xapprove(_token: address, _spender : address, _value : uint256) -> bool:
754     """
755     @dev Relay ERC-20 approve request 
756     """
757     assert msg.sender == self.owner
758     return ERC20(_token).approve(_spender, _value)