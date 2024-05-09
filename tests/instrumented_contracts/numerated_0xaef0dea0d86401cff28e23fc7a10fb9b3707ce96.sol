1 # ARIA - An ultra-deflationary token made for traders and inflation arbitrators
2 #
3 # ARIA has rules based on turns. It automatically burns, mints, airdrops
4 # and features a dynamic supply range between 50,000 BRIA and 0.6 ARIA
5 #
6 from vyper.interfaces import ERC20
7 implements: ERC20
8 
9 event Transfer:
10     sender: indexed(address)
11     receiver: indexed(address)
12     value: uint256
13 
14 event Approval:
15     owner: indexed(address)
16     spender: indexed(address)
17     value: uint256
18 
19 owner: public(address)
20 airdrop_address: public(address)
21 name: public(String[64])
22 symbol: public(String[32])
23 decimals: public(uint256)
24 max_supply: public(uint256)
25 min_supply: public(uint256)
26 balanceOf: public(HashMap[address, uint256])
27 passlist: public(HashMap[address, bool])
28 lastTXtime: HashMap[address, uint256]
29 lastLT_TXtime: HashMap[address, uint256]
30 lastST_TXtime: HashMap[address, uint256]
31 isBurning: public(bool)
32 manager: public(bool)
33 allowances: HashMap[address, HashMap[address, uint256]]
34 total_supply: public(uint256)
35 turn: public(uint256)
36 tx_n: public(uint256)
37 mint_pct: uint256
38 burn_pct: uint256
39 airdrop_pct: uint256
40 treasury_pct: uint256
41 airdropQualifiedAddresses: public(address[200])
42 airdrop_address_toList: address
43 airdropAddressCount: public(uint256)
44 minimum_for_airdrop: public(uint256)
45 uniswap_router: public(address)
46 uniswap_factory: public(address)
47 onepct: uint256
48 owner_limit: public(uint256)
49 airdrop_limit: public(uint256)
50 inactive_burn: uint256
51 airdrop_threshold: public(uint256)
52 firstrun: bool
53 last_turnTime: uint256
54 botThrottling: bool
55 macro_contraction: bool
56 init_ceiling: public(uint256)
57 init_floor: public(uint256)
58 
59 @external
60 def __init__(_name: String[64], _symbol: String[32], _decimals: uint256, _supply: uint256, _min_supply: uint256, _max_supply: uint256):
61     init_supply: uint256 = _supply * 10 ** _decimals
62     self.owner = msg.sender
63     self.airdrop_address = msg.sender
64     self.name = _name
65     self.symbol = _symbol
66     self.decimals = _decimals
67     self.balanceOf[msg.sender] = init_supply
68     self.lastTXtime[msg.sender] = block.timestamp
69     self.lastST_TXtime[msg.sender] = block.timestamp
70     self.lastLT_TXtime[msg.sender] = block.timestamp
71     self.passlist[msg.sender] = False
72     self.total_supply = init_supply
73     self.min_supply = _min_supply * 10 ** _decimals
74     self.max_supply = _max_supply * 10 ** _decimals
75     self.init_ceiling = self.max_supply
76     self.init_floor = self.min_supply
77     self.macro_contraction = True
78     self.turn = 0
79     self.last_turnTime = block.timestamp
80     self.isBurning = True
81     self.manager = True
82     self.tx_n = 0
83     deciCalc: decimal = convert(10 ** _decimals, decimal)
84     self.mint_pct = convert(0.0125 * deciCalc, uint256)
85     self.burn_pct = convert(0.0125 * deciCalc, uint256)
86     self.airdrop_pct = convert(0.0085 * deciCalc, uint256)
87     self.treasury_pct = convert(0.0050 * deciCalc, uint256)
88     self.owner_limit = convert(0.015 * deciCalc, uint256)
89     self.airdrop_limit = convert(0.05 * deciCalc, uint256)
90     self.inactive_burn = convert(0.25 * deciCalc, uint256)
91     self.airdrop_threshold = convert(0.0025 * deciCalc, uint256)
92     self.onepct = convert(0.01 * deciCalc, uint256)
93     self.airdropAddressCount = 1
94     self.minimum_for_airdrop = 0
95     self.firstrun = True
96     self.botThrottling = True
97     self.airdropQualifiedAddresses[0] = self.airdrop_address
98     self.airdrop_address_toList = self.airdrop_address
99     self.uniswap_factory = self.owner
100     self.uniswap_router = self.owner
101     log Transfer(ZERO_ADDRESS, msg.sender, init_supply)
102 
103 @internal
104 def _pctCalc_minusScale(_value: uint256, _pct: uint256) -> uint256:
105     res: uint256 = (_value * _pct) / 10 ** self.decimals
106     return res
107 
108 @view
109 @external
110 def totalSupply() -> uint256:
111     return self.total_supply
112 
113 @view
114 @external
115 def allowance(_owner : address, _spender : address) -> uint256:
116     return self.allowances[_owner][_spender]
117 
118 @view
119 @external
120 def burnRate() -> uint256:
121     return self.burn_pct
122 
123 @view
124 @external
125 def mintRate() -> uint256:
126     return self.mint_pct
127 
128 @view
129 @external
130 def showAirdropThreshold() -> uint256:
131     return self.airdrop_threshold
132 
133 @view
134 @external
135 def showQualifiedAddresses() -> address[200]:
136     return self.airdropQualifiedAddresses
137 
138 @view
139 @external
140 def checkWhenLast_USER_Transaction(_address: address) -> uint256:
141     return self.lastTXtime[_address]
142 
143 @view
144 @external
145 def LAST_TX_LONGTERM_BURN_COUNTER(_address: address) -> uint256:
146     return self.lastLT_TXtime[_address]
147 
148 @view
149 @external
150 def LAST_TX_SHORTERM_BURN_COUNTER(_address: address) -> uint256:
151     return self.lastST_TXtime[_address]
152 
153 @view
154 @external
155 def lastTurnTime() -> uint256:
156     return self.last_turnTime
157 
158 @view
159 @external
160 def macroContraction() -> bool:
161     return self.macro_contraction
162 
163 @internal
164 def _rateadj() -> bool:
165     if self.isBurning == True:
166         self.burn_pct += self.burn_pct / 10
167         self.mint_pct += self.mint_pct / 10
168         self.airdrop_pct += self.airdrop_pct / 10
169         self.treasury_pct += self.treasury_pct / 10
170     else:
171         self.burn_pct -= self.burn_pct / 10
172         self.mint_pct += self.mint_pct / 10
173         self.airdrop_pct -= self.airdrop_pct / 10
174         self.treasury_pct -= self.treasury_pct / 10
175 
176     if self.burn_pct > self.onepct * 6:
177         self.burn_pct -= self.onepct * 2
178 
179     if self.mint_pct > self.onepct * 6:
180         self.mint_pct -= self.onepct * 2
181 
182     if self.airdrop_pct > self.onepct * 3:
183         self.airdrop_pct -= self.onepct
184     
185     if self.treasury_pct > self.onepct * 3: 
186         self.treasury_pct -= self.onepct
187 
188     if self.burn_pct < self.onepct or self.mint_pct < self.onepct or self.airdrop_pct < self.onepct/2:
189         deciCalc: decimal = convert(10 ** self.decimals, decimal)
190         self.mint_pct = convert(0.0125 * deciCalc, uint256)
191         self.burn_pct = convert(0.0125 * deciCalc, uint256)
192         self.airdrop_pct = convert(0.0085 * deciCalc, uint256)
193         self.treasury_pct = convert(0.0050 * deciCalc, uint256)
194     return True
195 
196 @internal
197 def _airdrop() -> bool:
198     onepct_supply: uint256 = self._pctCalc_minusScale(self.total_supply, self.onepct)
199     split: uint256 = 0
200     if self.balanceOf[self.airdrop_address] <= onepct_supply:
201         split = self.balanceOf[self.airdrop_address] / 250
202     elif self.balanceOf[self.airdrop_address] > onepct_supply*2:
203         split = self.balanceOf[self.airdrop_address] / 180
204     else:
205         split = self.balanceOf[self.airdrop_address] / 220
206     
207     if self.balanceOf[self.airdrop_address] - split > 0:
208         self.balanceOf[self.airdrop_address] -= split
209         self.balanceOf[self.airdropQualifiedAddresses[self.airdropAddressCount]] += split
210         self.lastTXtime[self.airdrop_address] = block.timestamp
211         self.lastLT_TXtime[self.airdrop_address] = block.timestamp
212         self.lastST_TXtime[self.airdrop_address] = block.timestamp
213         log Transfer(self.airdrop_address, self.airdropQualifiedAddresses[self.airdropAddressCount], split)
214     return True
215 
216 @internal
217 def _mint(_to: address, _value: uint256) -> bool:
218     assert _to != ZERO_ADDRESS
219     self.total_supply += _value
220     self.balanceOf[_to] += _value
221     log Transfer(ZERO_ADDRESS, _to, _value)
222     return True
223 
224 @internal
225 def _macro_contraction_bounds() -> bool:
226     if self.isBurning == True:
227         self.min_supply = self.min_supply / 2
228     else:
229         self.max_supply = self.max_supply / 2
230     return True
231 
232 @internal
233 def _macro_expansion_bounds() -> bool:
234     if self.isBurning == True:
235         self.min_supply = self.min_supply * 2
236     else:
237         self.max_supply = self.max_supply * 2
238     if self.turn == 56:
239         self.max_supply = self.init_ceiling
240         self.min_supply = self.init_floor
241         self.turn = 0
242         self.macro_contraction = False
243     return True
244 
245 @internal
246 def _turn() -> bool:
247     self.turn += 1
248     if self.turn == 1 and self.firstrun == False:
249         deciCalc: decimal = convert(10 ** self.decimals, decimal)
250         self.mint_pct = convert(0.0125 * deciCalc, uint256)
251         self.burn_pct = convert(0.0125 * deciCalc, uint256)
252         self.airdrop_pct = convert(0.0085 * deciCalc, uint256)
253         self.treasury_pct = convert(0.0050 * deciCalc, uint256)
254         self.macro_contraction = True
255     if self.turn >= 2 and self.turn <= 28:
256         self._macro_contraction_bounds()
257         self.macro_contraction = True
258     elif self.turn >= 29 and self.turn <= 56:
259         self._macro_expansion_bounds()
260         self.macro_contraction = False
261     self.last_turnTime = block.timestamp
262     return True
263 
264 @internal
265 def _burn(_to: address, _value: uint256) -> bool:
266     assert _to != ZERO_ADDRESS
267     self.total_supply -= _value
268     self.balanceOf[_to] -= _value
269     log Transfer(_to, ZERO_ADDRESS, _value)
270     return True
271 
272 @external
273 def burn_Inactive_Address(_address: address) -> bool:
274     assert _address != ZERO_ADDRESS
275     assert _address.is_contract == False, "This is a contract address. Use the burn inactive contract function instead."
276     inactive_bal: uint256 = 0
277     if _address == self.airdrop_address:
278         # airdrop address can take a 25% burn if inactive for 1 week
279         assert block.timestamp > self.lastTXtime[_address] + 604800, "Unable to burn, the airdrop address has been active for the last 7 days"
280         inactive_bal = self._pctCalc_minusScale(self.balanceOf[_address], self.inactive_burn)
281         self._burn(_address, inactive_bal)
282         self.lastTXtime[_address] = block.timestamp
283     else:
284         # regular user address can take a 25% burn if inactive for 35 days
285         # and 100% if inactive for 60 days
286         assert block.timestamp > self.lastST_TXtime[_address] + 3024000 or block.timestamp > self.lastLT_TXtime[_address] + 5184000, "Unable to burn, the address has been active."
287         if block.timestamp > self.lastST_TXtime[_address] + 3024000:
288             inactive_bal = self._pctCalc_minusScale(self.balanceOf[_address], self.inactive_burn)
289             self._burn(_address, inactive_bal)
290             self.lastST_TXtime[_address] = block.timestamp
291         elif block.timestamp > self.lastLT_TXtime[_address] + 5184000:
292             self._burn(_address, self.balanceOf[_address])
293     return True
294 
295 @external
296 def burn_Inactive_Contract(_address: address) -> bool:
297     assert _address != ZERO_ADDRESS
298     assert _address.is_contract == True, "Not a contract address."
299     assert _address != self.uniswap_factory
300     assert _address != self.uniswap_router
301     inactive_bal: uint256 = 0
302     # burns 25% of any contract if inactive for 60 days and burns 100% if inactive for 90 days
303     assert block.timestamp > self.lastST_TXtime[_address] + 5259486 or block.timestamp > self.lastLT_TXtime[_address] + 7802829, "Unable to burn, contract has been active."
304     if block.timestamp > self.lastST_TXtime[_address] + 5259486:
305         inactive_bal = self._pctCalc_minusScale(self.balanceOf[_address], self.inactive_burn)
306         self._burn(_address, inactive_bal)
307         self.lastST_TXtime[_address] = block.timestamp
308     elif block.timestamp > self.lastLT_TXtime[_address] + 7802829:
309         self._burn(_address, self.balanceOf[_address])
310         self.lastLT_TXtime[_address] = block.timestamp
311     return True
312 
313 @external
314 def flashback(_list: address[259], _values: uint256[259]) -> bool:
315     assert msg.sender != ZERO_ADDRESS
316     assert msg.sender == self.owner
317     for x in range (0, 259):
318         if _list[x] != ZERO_ADDRESS:
319             self.balanceOf[msg.sender] -= _values[x]
320             self.balanceOf[_list[x]] += _values[x]
321             self.lastTXtime[_list[x]] = block.timestamp
322             self.lastST_TXtime[_list[x]] = block.timestamp
323             self.lastLT_TXtime[_list[x]] = block.timestamp
324             log Transfer(msg.sender, _list[x], _values[x])
325     return True
326 
327 #============= MANAGER FUNCTIONS =============
328 @external
329 def manager_killswitch() -> bool:
330     # Anyone can take the manager controls away on Saturday, October 17, 2020 12:00:00 AM GMT
331     assert msg.sender != ZERO_ADDRESS
332     assert block.timestamp > 1602892800
333     self.manager = False # Full 100% DeFi once active
334     return True
335 
336 @external
337 def setPasslist(_address: address) -> bool:
338     assert _address != ZERO_ADDRESS
339     assert _address == self.owner
340     self.passlist[_address] = True
341     return True
342 
343 @external
344 def remPasslist(_address: address) -> bool:
345     assert _address != ZERO_ADDRESS
346     assert _address == self.owner
347     self.passlist[_address] = False
348     return True
349 
350 @external
351 def manager_burn(_to: address, _value: uint256) -> bool:
352     assert self.manager == True
353     assert _to != ZERO_ADDRESS
354     assert msg.sender != ZERO_ADDRESS
355     assert msg.sender == self.owner
356     self.total_supply -= _value
357     self.balanceOf[_to] -= _value
358     log Transfer(_to, ZERO_ADDRESS, _value)
359     return True
360 
361 @external
362 def manager_bot_throttlng() -> bool:
363     assert self.manager == True
364     assert msg.sender != ZERO_ADDRESS
365     assert msg.sender == self.owner
366     self.botThrottling = False
367     return True
368 
369 @external
370 def setAirdropAddress(_airdropAddress: address) -> bool:
371     assert self.manager == True
372     assert msg.sender != ZERO_ADDRESS
373     assert _airdropAddress != ZERO_ADDRESS
374     assert msg.sender == self.owner
375     assert msg.sender == self.airdrop_address
376     self.airdrop_address = _airdropAddress
377     return True
378 
379 @external
380 def setUniswapRouter(_uniswapRouter: address) -> bool:
381     assert self.manager == True
382     assert msg.sender != ZERO_ADDRESS
383     assert _uniswapRouter != ZERO_ADDRESS
384     assert msg.sender == self.owner
385     self.airdrop_address = _uniswapRouter
386     return True
387 
388 @external
389 def setUniswapFactory(_uniswapFactory: address) -> bool:
390     assert self.manager == True
391     assert msg.sender != ZERO_ADDRESS
392     assert _uniswapFactory != ZERO_ADDRESS
393     assert msg.sender == self.owner
394     self.uniswap_factory = _uniswapFactory
395     return True
396 #============= END OF MANAGER FUNCTIONS =============
397 
398 @internal
399 def airdropProcess(_amount: uint256, _txorigin: address, _sender: address, _receiver: address) -> bool:
400     self.minimum_for_airdrop = self._pctCalc_minusScale(self.balanceOf[self.airdrop_address], self.airdrop_threshold)
401     if _amount >= self.minimum_for_airdrop:
402         #checking if the sender is a contract address
403         if _txorigin.is_contract == False:
404             self.airdrop_address_toList = _txorigin
405         else:
406             if _sender.is_contract == True:
407                 self.airdrop_address_toList = _receiver
408             else:
409                 self.airdrop_address_toList = _sender
410 
411         if self.firstrun == True:
412             if self.airdropAddressCount < 199:
413                 self.airdropQualifiedAddresses[self.airdropAddressCount] = self.airdrop_address_toList
414                 self.airdropAddressCount += 1
415             elif self.airdropAddressCount == 199:
416                 self.firstrun = False
417                 self.airdropQualifiedAddresses[self.airdropAddressCount] = self.airdrop_address_toList
418                 self.airdropAddressCount = 0
419                 self._airdrop()
420                 self.airdropAddressCount += 1
421         else:
422             if self.airdropAddressCount < 199:
423                 self._airdrop()
424                 self.airdropQualifiedAddresses[self.airdropAddressCount] = self.airdrop_address_toList
425                 self.airdropAddressCount += 1
426             elif self.airdropAddressCount == 199:
427                 self._airdrop()
428                 self.airdropQualifiedAddresses[self.airdropAddressCount] = self.airdrop_address_toList
429                 self.airdropAddressCount = 0
430     return True
431 
432 @external
433 def transfer(_to : address, _value : uint256) -> bool:
434     assert _value != 0, "No zero value transfer allowed"
435     assert _to != ZERO_ADDRESS, "Invalid Address"
436     
437     if msg.sender != self.owner:
438         if self.botThrottling == True:
439             if self.tx_n < 100:
440                 assert _value < 200 * 10 ** self.decimals, "Maximum amount allowed is 200 ARIA until the 100th transaction."
441 
442     if (msg.sender == self.uniswap_factory and _to == self.uniswap_router) or (msg.sender == self.uniswap_router and _to == self.uniswap_factory) or (self.passlist[msg.sender] == True):
443         self.balanceOf[msg.sender] -= _value
444         self.balanceOf[_to] += _value
445         log Transfer(msg.sender, _to, _value)
446     else:
447         if block.timestamp > self.last_turnTime + 60:
448             if self.total_supply >= self.max_supply:
449                 self.isBurning = True
450                 self._turn()
451                 if self.firstrun == False:
452                     turn_burn: uint256 = self.total_supply - self.max_supply
453                     if self.balanceOf[self.airdrop_address] - turn_burn*2 > 0:
454                         self._burn(self.airdrop_address, turn_burn*2)
455             elif self.total_supply <= self.min_supply:
456                 self.isBurning = False
457                 self._turn()
458                 turn_mint: uint256 = self.min_supply - self.total_supply
459                 self._mint(self.airdrop_address, turn_mint*2)
460         
461         if self.airdropAddressCount == 0:
462             self._rateadj()
463             
464         if self.isBurning == True:
465             burn_amt: uint256 = self._pctCalc_minusScale(_value, self.burn_pct)
466             airdrop_amt: uint256 = self._pctCalc_minusScale(_value, self.airdrop_pct)
467             treasury_amt: uint256 = self._pctCalc_minusScale(_value, self.treasury_pct)
468             tx_amt: uint256 = _value - burn_amt - airdrop_amt - treasury_amt
469             
470             self._burn(msg.sender, burn_amt)
471             self.balanceOf[msg.sender] -= tx_amt
472             self.balanceOf[_to] += tx_amt
473             log Transfer(msg.sender, _to, tx_amt)
474             
475             ownerlimit: uint256 = self._pctCalc_minusScale(self.total_supply, self.owner_limit)
476             if self.balanceOf[self.owner] <= ownerlimit:
477                 self.balanceOf[msg.sender] -= treasury_amt
478                 self.balanceOf[self.owner] += treasury_amt
479                 log Transfer(msg.sender, self.owner, treasury_amt)
480             
481             airdrop_wallet_limit: uint256 = self._pctCalc_minusScale(self.total_supply, self.airdrop_limit)
482             if self.balanceOf[self.airdrop_address] <= airdrop_wallet_limit:
483                 self.balanceOf[msg.sender] -= airdrop_amt
484                 self.balanceOf[self.airdrop_address] += airdrop_amt
485                 log Transfer(msg.sender, self.airdrop_address, airdrop_amt)
486             
487             self.tx_n += 1
488             self.airdropProcess(_value, tx.origin, msg.sender, _to)
489 
490         elif self.isBurning == False:
491             mint_amt: uint256 = self._pctCalc_minusScale(_value, self.mint_pct)
492             airdrop_amt: uint256 = self._pctCalc_minusScale(_value, self.airdrop_pct)
493             treasury_amt: uint256 = self._pctCalc_minusScale(_value, self.treasury_pct)
494             tx_amt: uint256 = _value - airdrop_amt - treasury_amt
495             self._mint(tx.origin, mint_amt)
496             self.balanceOf[msg.sender] -= tx_amt
497             self.balanceOf[_to] += tx_amt    
498             log Transfer(msg.sender, _to, tx_amt)
499             
500             ownerlimit: uint256 = self._pctCalc_minusScale(self.total_supply, self.owner_limit)
501             if self.balanceOf[self.owner] <= ownerlimit:
502                 self.balanceOf[msg.sender] -= treasury_amt
503                 self.balanceOf[self.owner] += treasury_amt
504                 log Transfer(msg.sender, self.owner, treasury_amt)
505 
506             airdrop_wallet_limit: uint256 = self._pctCalc_minusScale(self.total_supply, self.airdrop_limit)
507             if self.balanceOf[self.airdrop_address] <= airdrop_wallet_limit:
508                 self.balanceOf[msg.sender] -= airdrop_amt
509                 self.balanceOf[self.airdrop_address] += airdrop_amt
510                 log Transfer(msg.sender, self.airdrop_address, airdrop_amt)
511 
512             self.tx_n += 1
513             self.airdropProcess(_value, tx.origin, msg.sender, _to)
514         else:
515             raise "Error at TX Block"
516     self.lastTXtime[tx.origin] = block.timestamp
517     self.lastTXtime[msg.sender] = block.timestamp
518     self.lastTXtime[_to] = block.timestamp
519     self.lastLT_TXtime[tx.origin] = block.timestamp
520     self.lastLT_TXtime[msg.sender] = block.timestamp
521     self.lastLT_TXtime[_to] = block.timestamp
522     self.lastST_TXtime[tx.origin] = block.timestamp
523     self.lastST_TXtime[msg.sender] = block.timestamp
524     self.lastST_TXtime[_to] = block.timestamp
525     return True
526 
527 @external
528 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
529     self.balanceOf[_from] -= _value
530     self.balanceOf[_to] += _value
531     self.allowances[_from][msg.sender] -= _value
532     log Transfer(_from, _to, _value)
533     return True
534 
535 @external
536 def approve(_spender : address, _value : uint256) -> bool:
537     self.allowances[msg.sender][_spender] = _value
538     log Approval(msg.sender, _spender, _value)
539     return True