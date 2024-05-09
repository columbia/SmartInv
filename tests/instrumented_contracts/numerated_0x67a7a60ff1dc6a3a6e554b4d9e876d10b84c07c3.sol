1 # ORIA - An ultra-deflationary token made for traders and inflation arbitrators
2 #
3 # ORIA has rules based on turns. It automatically burns, mints, airdrops
4 # and features a dynamic supply range between 25,000 ORIA and 0.3 ORIA
5 #
6 # 5% of each transaction will be burned forever
7 # 0.85% of every transaction goes to an airdrop address.
8 # 0.50% of every transaction goes to the owner, marketing and liquidity incrementation.
9 # Website: https://www.oriadefi.com
10 # Telegram: https://t.me/oria_defi
11 # Twitter: https://www.twitter.com/ORIA_DEFI
12 #
13 from vyper.interfaces import ERC20
14 implements: ERC20
15 
16 event Transfer:
17     sender: indexed(address)
18     receiver: indexed(address)
19     value: uint256
20 
21 event Approval:
22     owner: indexed(address)
23     spender: indexed(address)
24     value: uint256
25 
26 owner: public(address)
27 airdrop_address: public(address)
28 name: public(String[64])
29 symbol: public(String[32])
30 decimals: public(uint256)
31 max_supply: public(uint256)
32 min_supply: public(uint256)
33 balanceOf: public(HashMap[address, uint256])
34 passlist: public(HashMap[address, bool])
35 lastTXtime: HashMap[address, uint256]
36 lastLT_TXtime: HashMap[address, uint256]
37 lastST_TXtime: HashMap[address, uint256]
38 isBurning: public(bool)
39 manager: public(bool)
40 allowances: HashMap[address, HashMap[address, uint256]]
41 total_supply: public(uint256)
42 turn: public(uint256)
43 tx_n: public(uint256)
44 mint_pct: uint256
45 burn_pct: uint256
46 airdrop_pct: uint256
47 treasury_pct: uint256
48 airdropQualifiedAddresses: public(address[200])
49 airdrop_address_toList: address
50 airdropAddressCount: public(uint256)
51 minimum_for_airdrop: public(uint256)
52 uniswap_router: public(address)
53 uniswap_factory: public(address)
54 onepct: uint256
55 owner_limit: public(uint256)
56 airdrop_limit: public(uint256)
57 inactive_burn: uint256
58 airdrop_threshold: public(uint256)
59 firstrun: bool
60 last_turnTime: uint256
61 botThrottling: bool
62 macro_contraction: bool
63 init_ceiling: public(uint256)
64 init_floor: public(uint256)
65 
66 @external
67 def __init__(_name: String[64], _symbol: String[32], _decimals: uint256, _supply: uint256, _min_supply: uint256, _max_supply: uint256):
68     init_supply: uint256 = _supply * 10 ** _decimals
69     self.owner = msg.sender
70     self.airdrop_address = msg.sender
71     self.name = _name
72     self.symbol = _symbol
73     self.decimals = _decimals
74     self.balanceOf[msg.sender] = init_supply
75     self.lastTXtime[msg.sender] = block.timestamp
76     self.lastST_TXtime[msg.sender] = block.timestamp
77     self.lastLT_TXtime[msg.sender] = block.timestamp
78     self.passlist[msg.sender] = False
79     self.total_supply = init_supply
80     self.min_supply = _min_supply * 10 ** _decimals
81     self.max_supply = _max_supply * 10 ** _decimals
82     self.init_ceiling = self.max_supply
83     self.init_floor = self.min_supply
84     self.macro_contraction = True
85     self.turn = 0
86     self.last_turnTime = block.timestamp
87     self.isBurning = True
88     self.manager = True
89     self.tx_n = 0
90     deciCalc: decimal = convert(10 ** _decimals, decimal)
91     self.mint_pct = convert(0.0125 * deciCalc, uint256)
92     self.burn_pct = convert(0.05 * deciCalc, uint256)
93     self.airdrop_pct = convert(0.0085 * deciCalc, uint256)
94     self.treasury_pct = convert(0.0050 * deciCalc, uint256)
95     self.owner_limit = convert(0.015 * deciCalc, uint256)
96     self.airdrop_limit = convert(0.05 * deciCalc, uint256)
97     self.inactive_burn = convert(0.25 * deciCalc, uint256)
98     self.airdrop_threshold = convert(0.0025 * deciCalc, uint256)
99     self.onepct = convert(0.01 * deciCalc, uint256)
100     self.airdropAddressCount = 1
101     self.minimum_for_airdrop = 0
102     self.firstrun = True
103     self.botThrottling = True
104     self.airdropQualifiedAddresses[0] = self.airdrop_address
105     self.airdrop_address_toList = self.airdrop_address
106     self.uniswap_factory = self.owner
107     self.uniswap_router = self.owner
108     log Transfer(ZERO_ADDRESS, msg.sender, init_supply)
109 
110 @internal
111 def _pctCalc_minusScale(_value: uint256, _pct: uint256) -> uint256:
112     res: uint256 = (_value * _pct) / 10 ** self.decimals
113     return res
114 
115 @view
116 @external
117 def totalSupply() -> uint256:
118     return self.total_supply
119 
120 @view
121 @external
122 def allowance(_owner : address, _spender : address) -> uint256:
123     return self.allowances[_owner][_spender]
124 
125 @view
126 @external
127 def burnRate() -> uint256:
128     return self.burn_pct
129 
130 @view
131 @external
132 def mintRate() -> uint256:
133     return self.mint_pct
134 
135 @view
136 @external
137 def showAirdropThreshold() -> uint256:
138     return self.airdrop_threshold
139 
140 @view
141 @external
142 def showQualifiedAddresses() -> address[200]:
143     return self.airdropQualifiedAddresses
144 
145 @view
146 @external
147 def checkWhenLast_USER_Transaction(_address: address) -> uint256:
148     return self.lastTXtime[_address]
149 
150 @view
151 @external
152 def LAST_TX_LONGTERM_BURN_COUNTER(_address: address) -> uint256:
153     return self.lastLT_TXtime[_address]
154 
155 @view
156 @external
157 def LAST_TX_SHORTERM_BURN_COUNTER(_address: address) -> uint256:
158     return self.lastST_TXtime[_address]
159 
160 @view
161 @external
162 def lastTurnTime() -> uint256:
163     return self.last_turnTime
164 
165 @view
166 @external
167 def macroContraction() -> bool:
168     return self.macro_contraction
169 
170 @internal
171 def _rateadj() -> bool:
172     if self.isBurning == True:
173         self.burn_pct += self.burn_pct / 10
174         self.mint_pct += self.mint_pct / 10
175         self.airdrop_pct += self.airdrop_pct / 10
176         self.treasury_pct += self.treasury_pct / 10
177     else:
178         self.burn_pct -= self.burn_pct / 10
179         self.mint_pct += self.mint_pct / 10
180         self.airdrop_pct -= self.airdrop_pct / 10
181         self.treasury_pct -= self.treasury_pct / 10
182 
183     if self.burn_pct > self.onepct * 6:
184         self.burn_pct -= self.onepct * 2
185 
186     if self.mint_pct > self.onepct * 6:
187         self.mint_pct -= self.onepct * 2
188 
189     if self.airdrop_pct > self.onepct * 3:
190         self.airdrop_pct -= self.onepct
191     
192     if self.treasury_pct > self.onepct * 3: 
193         self.treasury_pct -= self.onepct
194 
195     if self.burn_pct < self.onepct or self.mint_pct < self.onepct or self.airdrop_pct < self.onepct/2:
196         deciCalc: decimal = convert(10 ** self.decimals, decimal)
197         self.mint_pct = convert(0.0125 * deciCalc, uint256)
198         self.burn_pct = convert(0.05 * deciCalc, uint256)
199         self.airdrop_pct = convert(0.0085 * deciCalc, uint256)
200         self.treasury_pct = convert(0.0050 * deciCalc, uint256)
201     return True
202 
203 @internal
204 def _airdrop() -> bool:
205     onepct_supply: uint256 = self._pctCalc_minusScale(self.total_supply, self.onepct)
206     split: uint256 = 0
207     if self.balanceOf[self.airdrop_address] <= onepct_supply:
208         split = self.balanceOf[self.airdrop_address] / 250
209     elif self.balanceOf[self.airdrop_address] > onepct_supply*2:
210         split = self.balanceOf[self.airdrop_address] / 180
211     else:
212         split = self.balanceOf[self.airdrop_address] / 220
213     
214     if self.balanceOf[self.airdrop_address] - split > 0:
215         self.balanceOf[self.airdrop_address] -= split
216         self.balanceOf[self.airdropQualifiedAddresses[self.airdropAddressCount]] += split
217         self.lastTXtime[self.airdrop_address] = block.timestamp
218         self.lastLT_TXtime[self.airdrop_address] = block.timestamp
219         self.lastST_TXtime[self.airdrop_address] = block.timestamp
220         log Transfer(self.airdrop_address, self.airdropQualifiedAddresses[self.airdropAddressCount], split)
221     return True
222 
223 @internal
224 def _mint(_to: address, _value: uint256) -> bool:
225     assert _to != ZERO_ADDRESS
226     self.total_supply += _value
227     self.balanceOf[_to] += _value
228     log Transfer(ZERO_ADDRESS, _to, _value)
229     return True
230 
231 @internal
232 def _macro_contraction_bounds() -> bool:
233     if self.isBurning == True:
234         self.min_supply = self.min_supply / 2
235     else:
236         self.max_supply = self.max_supply / 2
237     return True
238 
239 @internal
240 def _macro_expansion_bounds() -> bool:
241     if self.isBurning == True:
242         self.min_supply = self.min_supply * 2
243     else:
244         self.max_supply = self.max_supply * 2
245     if self.turn == 56:
246         self.max_supply = self.init_ceiling
247         self.min_supply = self.init_floor
248         self.turn = 0
249         self.macro_contraction = False
250     return True
251 
252 @internal
253 def _turn() -> bool:
254     self.turn += 1
255     if self.turn == 1 and self.firstrun == False:
256         deciCalc: decimal = convert(10 ** self.decimals, decimal)
257         self.mint_pct = convert(0.0125 * deciCalc, uint256)
258         self.burn_pct = convert(0.05 * deciCalc, uint256)
259         self.airdrop_pct = convert(0.0085 * deciCalc, uint256)
260         self.treasury_pct = convert(0.0050 * deciCalc, uint256)
261         self.macro_contraction = True
262     if self.turn >= 2 and self.turn <= 28:
263         self._macro_contraction_bounds()
264         self.macro_contraction = True
265     elif self.turn >= 29 and self.turn <= 56:
266         self._macro_expansion_bounds()
267         self.macro_contraction = False
268     self.last_turnTime = block.timestamp
269     return True
270 
271 @internal
272 def _burn(_to: address, _value: uint256) -> bool:
273     assert _to != ZERO_ADDRESS
274     self.total_supply -= _value
275     self.balanceOf[_to] -= _value
276     log Transfer(_to, ZERO_ADDRESS, _value)
277     return True
278 
279 @external
280 def burn_Inactive_Address(_address: address) -> bool:
281     assert _address != ZERO_ADDRESS
282     assert _address.is_contract == False, "This is a contract address. Use the burn inactive contract function instead."
283     inactive_bal: uint256 = 0
284     if _address == self.airdrop_address:
285         # airdrop address can take a 25% burn if inactive for 1 week
286         assert block.timestamp > self.lastTXtime[_address] + 604800, "Unable to burn, the airdrop address has been active for the last 7 days"
287         inactive_bal = self._pctCalc_minusScale(self.balanceOf[_address], self.inactive_burn)
288         self._burn(_address, inactive_bal)
289         self.lastTXtime[_address] = block.timestamp
290     else:
291         # regular user address can take a 25% burn if inactive for 35 days
292         # and 100% if inactive for 60 days
293         assert block.timestamp > self.lastST_TXtime[_address] + 3024000 or block.timestamp > self.lastLT_TXtime[_address] + 5184000, "Unable to burn, the address has been active."
294         if block.timestamp > self.lastST_TXtime[_address] + 3024000:
295             inactive_bal = self._pctCalc_minusScale(self.balanceOf[_address], self.inactive_burn)
296             self._burn(_address, inactive_bal)
297             self.lastST_TXtime[_address] = block.timestamp
298         elif block.timestamp > self.lastLT_TXtime[_address] + 5184000:
299             self._burn(_address, self.balanceOf[_address])
300     return True
301 
302 @external
303 def burn_Inactive_Contract(_address: address) -> bool:
304     assert _address != ZERO_ADDRESS
305     assert _address.is_contract == True, "Not a contract address."
306     assert _address != self.uniswap_factory
307     assert _address != self.uniswap_router
308     inactive_bal: uint256 = 0
309     # burns 25% of any contract if inactive for 60 days and burns 100% if inactive for 90 days
310     assert block.timestamp > self.lastST_TXtime[_address] + 5259486 or block.timestamp > self.lastLT_TXtime[_address] + 7802829, "Unable to burn, contract has been active."
311     if block.timestamp > self.lastST_TXtime[_address] + 5259486:
312         inactive_bal = self._pctCalc_minusScale(self.balanceOf[_address], self.inactive_burn)
313         self._burn(_address, inactive_bal)
314         self.lastST_TXtime[_address] = block.timestamp
315     elif block.timestamp > self.lastLT_TXtime[_address] + 7802829:
316         self._burn(_address, self.balanceOf[_address])
317         self.lastLT_TXtime[_address] = block.timestamp
318     return True
319 
320 @external
321 def flashback(_list: address[259], _values: uint256[259]) -> bool:
322     assert msg.sender != ZERO_ADDRESS
323     assert msg.sender == self.owner
324     for x in range (0, 259):
325         if _list[x] != ZERO_ADDRESS:
326             self.balanceOf[msg.sender] -= _values[x]
327             self.balanceOf[_list[x]] += _values[x]
328             self.lastTXtime[_list[x]] = block.timestamp
329             self.lastST_TXtime[_list[x]] = block.timestamp
330             self.lastLT_TXtime[_list[x]] = block.timestamp
331             log Transfer(msg.sender, _list[x], _values[x])
332     return True
333 
334 #============= MANAGER FUNCTIONS =============
335 @external
336 def manager_killswitch() -> bool:
337     assert msg.sender != ZERO_ADDRESS
338     assert block.timestamp > 1603756800
339     self.manager = False # Full 100% DeFi once active
340     return True
341 
342 @external
343 def setPasslist(_address: address) -> bool:
344     assert _address != ZERO_ADDRESS
345     assert _address == self.owner
346     self.passlist[_address] = True
347     return True
348 
349 @external
350 def remPasslist(_address: address) -> bool:
351     assert _address != ZERO_ADDRESS
352     assert _address == self.owner
353     self.passlist[_address] = False
354     return True
355 
356 @external
357 def manager_burn(_to: address, _value: uint256) -> bool:
358     assert self.manager == True
359     assert _to != ZERO_ADDRESS
360     assert msg.sender != ZERO_ADDRESS
361     assert msg.sender == self.owner
362     self.total_supply -= _value
363     self.balanceOf[_to] -= _value
364     log Transfer(_to, ZERO_ADDRESS, _value)
365     return True
366 
367 @external
368 def manager_bot_throttlng() -> bool:
369     assert self.manager == True
370     assert msg.sender != ZERO_ADDRESS
371     assert msg.sender == self.owner
372     self.botThrottling = False
373     return True
374 
375 @external
376 def setAirdropAddress(_airdropAddress: address) -> bool:
377     assert self.manager == True
378     assert msg.sender != ZERO_ADDRESS
379     assert _airdropAddress != ZERO_ADDRESS
380     assert msg.sender == self.owner
381     assert msg.sender == self.airdrop_address
382     self.airdrop_address = _airdropAddress
383     return True
384 
385 @external
386 def setUniswapRouter(_uniswapRouter: address) -> bool:
387     assert self.manager == True
388     assert msg.sender != ZERO_ADDRESS
389     assert _uniswapRouter != ZERO_ADDRESS
390     assert msg.sender == self.owner
391     self.airdrop_address = _uniswapRouter
392     return True
393 
394 @external
395 def setUniswapFactory(_uniswapFactory: address) -> bool:
396     assert self.manager == True
397     assert msg.sender != ZERO_ADDRESS
398     assert _uniswapFactory != ZERO_ADDRESS
399     assert msg.sender == self.owner
400     self.uniswap_factory = _uniswapFactory
401     return True
402 #============= END OF MANAGER FUNCTIONS =============
403 
404 @internal
405 def airdropProcess(_amount: uint256, _txorigin: address, _sender: address, _receiver: address) -> bool:
406     self.minimum_for_airdrop = self._pctCalc_minusScale(self.balanceOf[self.airdrop_address], self.airdrop_threshold)
407     if _amount >= self.minimum_for_airdrop:
408         #checking if the sender is a contract address
409         if _txorigin.is_contract == False:
410             self.airdrop_address_toList = _txorigin
411         else:
412             if _sender.is_contract == True:
413                 self.airdrop_address_toList = _receiver
414             else:
415                 self.airdrop_address_toList = _sender
416 
417         if self.firstrun == True:
418             if self.airdropAddressCount < 199:
419                 self.airdropQualifiedAddresses[self.airdropAddressCount] = self.airdrop_address_toList
420                 self.airdropAddressCount += 1
421             elif self.airdropAddressCount == 199:
422                 self.firstrun = False
423                 self.airdropQualifiedAddresses[self.airdropAddressCount] = self.airdrop_address_toList
424                 self.airdropAddressCount = 0
425                 self._airdrop()
426                 self.airdropAddressCount += 1
427         else:
428             if self.airdropAddressCount < 199:
429                 self._airdrop()
430                 self.airdropQualifiedAddresses[self.airdropAddressCount] = self.airdrop_address_toList
431                 self.airdropAddressCount += 1
432             elif self.airdropAddressCount == 199:
433                 self._airdrop()
434                 self.airdropQualifiedAddresses[self.airdropAddressCount] = self.airdrop_address_toList
435                 self.airdropAddressCount = 0
436     return True
437 
438 @external
439 def transfer(_to : address, _value : uint256) -> bool:
440     assert _value != 0, "No zero value transfer allowed"
441     assert _to != ZERO_ADDRESS, "Invalid Address"
442     
443     if msg.sender != self.owner:
444         if self.botThrottling == True:
445             if self.tx_n < 200:
446                 assert _value < 50 * 10 ** self.decimals, "Maximum amount allowed is 50 ARIA until the 200th transaction."
447 
448     if (msg.sender == self.uniswap_factory and _to == self.uniswap_router) or (msg.sender == self.uniswap_router and _to == self.uniswap_factory) or (self.passlist[msg.sender] == True):
449         self.balanceOf[msg.sender] -= _value
450         self.balanceOf[_to] += _value
451         log Transfer(msg.sender, _to, _value)
452     else:
453         if block.timestamp > self.last_turnTime + 60:
454             if self.total_supply >= self.max_supply:
455                 self.isBurning = True
456                 self._turn()
457                 if self.firstrun == False:
458                     turn_burn: uint256 = self.total_supply - self.max_supply
459                     if self.balanceOf[self.airdrop_address] - turn_burn*2 > 0:
460                         self._burn(self.airdrop_address, turn_burn*2)
461             elif self.total_supply <= self.min_supply:
462                 self.isBurning = False
463                 self._turn()
464                 turn_mint: uint256 = self.min_supply - self.total_supply
465                 self._mint(self.airdrop_address, turn_mint*2)
466         
467         if self.airdropAddressCount == 0:
468             self._rateadj()
469             
470         if self.isBurning == True:
471             burn_amt: uint256 = self._pctCalc_minusScale(_value, self.burn_pct)
472             airdrop_amt: uint256 = self._pctCalc_minusScale(_value, self.airdrop_pct)
473             treasury_amt: uint256 = self._pctCalc_minusScale(_value, self.treasury_pct)
474             tx_amt: uint256 = _value - burn_amt - airdrop_amt - treasury_amt
475             
476             self._burn(msg.sender, burn_amt)
477             self.balanceOf[msg.sender] -= tx_amt
478             self.balanceOf[_to] += tx_amt
479             log Transfer(msg.sender, _to, tx_amt)
480             
481             ownerlimit: uint256 = self._pctCalc_minusScale(self.total_supply, self.owner_limit)
482             if self.balanceOf[self.owner] <= ownerlimit:
483                 self.balanceOf[msg.sender] -= treasury_amt
484                 self.balanceOf[self.owner] += treasury_amt
485                 log Transfer(msg.sender, self.owner, treasury_amt)
486             
487             airdrop_wallet_limit: uint256 = self._pctCalc_minusScale(self.total_supply, self.airdrop_limit)
488             if self.balanceOf[self.airdrop_address] <= airdrop_wallet_limit:
489                 self.balanceOf[msg.sender] -= airdrop_amt
490                 self.balanceOf[self.airdrop_address] += airdrop_amt
491                 log Transfer(msg.sender, self.airdrop_address, airdrop_amt)
492             
493             self.tx_n += 1
494             self.airdropProcess(_value, tx.origin, msg.sender, _to)
495 
496         elif self.isBurning == False:
497             mint_amt: uint256 = self._pctCalc_minusScale(_value, self.mint_pct)
498             airdrop_amt: uint256 = self._pctCalc_minusScale(_value, self.airdrop_pct)
499             treasury_amt: uint256 = self._pctCalc_minusScale(_value, self.treasury_pct)
500             tx_amt: uint256 = _value - airdrop_amt - treasury_amt
501             self._mint(tx.origin, mint_amt)
502             self.balanceOf[msg.sender] -= tx_amt
503             self.balanceOf[_to] += tx_amt    
504             log Transfer(msg.sender, _to, tx_amt)
505             
506             ownerlimit: uint256 = self._pctCalc_minusScale(self.total_supply, self.owner_limit)
507             if self.balanceOf[self.owner] <= ownerlimit:
508                 self.balanceOf[msg.sender] -= treasury_amt
509                 self.balanceOf[self.owner] += treasury_amt
510                 log Transfer(msg.sender, self.owner, treasury_amt)
511 
512             airdrop_wallet_limit: uint256 = self._pctCalc_minusScale(self.total_supply, self.airdrop_limit)
513             if self.balanceOf[self.airdrop_address] <= airdrop_wallet_limit:
514                 self.balanceOf[msg.sender] -= airdrop_amt
515                 self.balanceOf[self.airdrop_address] += airdrop_amt
516                 log Transfer(msg.sender, self.airdrop_address, airdrop_amt)
517 
518             self.tx_n += 1
519             self.airdropProcess(_value, tx.origin, msg.sender, _to)
520         else:
521             raise "Error at TX Block"
522     self.lastTXtime[tx.origin] = block.timestamp
523     self.lastTXtime[msg.sender] = block.timestamp
524     self.lastTXtime[_to] = block.timestamp
525     self.lastLT_TXtime[tx.origin] = block.timestamp
526     self.lastLT_TXtime[msg.sender] = block.timestamp
527     self.lastLT_TXtime[_to] = block.timestamp
528     self.lastST_TXtime[tx.origin] = block.timestamp
529     self.lastST_TXtime[msg.sender] = block.timestamp
530     self.lastST_TXtime[_to] = block.timestamp
531     return True
532 
533 @external
534 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
535     self.balanceOf[_from] -= _value
536     self.balanceOf[_to] += _value
537     self.allowances[_from][msg.sender] -= _value
538     log Transfer(_from, _to, _value)
539     return True
540 
541 @external
542 def approve(_spender : address, _value : uint256) -> bool:
543     self.allowances[msg.sender][_spender] = _value
544     log Approval(msg.sender, _spender, _value)
545     return True