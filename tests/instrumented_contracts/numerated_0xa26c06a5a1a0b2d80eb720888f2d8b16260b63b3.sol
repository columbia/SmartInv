1 # Oscillate.Finance (OSCI) - An ultra-deflationary token made for traders and inflation arbitrators
2 #
3 # OSCI has rules based on turns. It automatically burns, mints, airdrops
4 # and features a dynamic supply range between 50,000 OSCI and 1.2 OSCI
5 #
6 # Find out more about OSCI @ https://oscillate.finance/
7 #
8 # 
9 # Official Telegram @ https://t.me/OSCI_defi & https://twitter.com/DefiOsci
10 
11 from vyper.interfaces import ERC20
12 implements: ERC20
13 
14 event Transfer:
15     sender: indexed(address)
16     receiver: indexed(address)
17     value: uint256
18 
19 event Approval:
20     owner: indexed(address)
21     spender: indexed(address)
22     value: uint256
23 
24 owner: public(address)
25 airdrop_address: public(address)
26 name: public(String[64])
27 symbol: public(String[32])
28 decimals: public(uint256)
29 max_supply: public(uint256)
30 min_supply: public(uint256)
31 balanceOf: public(HashMap[address, uint256])
32 passlist: public(HashMap[address, bool])
33 lastTXtime: HashMap[address, uint256]
34 lastLT_TXtime: HashMap[address, uint256]
35 lastST_TXtime: HashMap[address, uint256]
36 isBurning: public(bool)
37 manager: public(bool)
38 allowances: HashMap[address, HashMap[address, uint256]]
39 total_supply: public(uint256)
40 turn: public(uint256)
41 tx_n: public(uint256)
42 mint_pct: uint256
43 burn_pct: uint256
44 airdrop_pct: uint256
45 treasury_pct: uint256
46 airdropQualifiedAddresses: public(address[200])
47 airdrop_address_toList: address
48 airdropAddressCount: public(uint256)
49 minimum_for_airdrop: public(uint256)
50 uniswap_router: public(address)
51 uniswap_factory: public(address)
52 onepct: uint256
53 owner_limit: public(uint256)
54 airdrop_limit: public(uint256)
55 inactive_burn: uint256
56 airdrop_threshold: public(uint256)
57 firstrun: bool
58 last_turnTime: uint256
59 botThrottling: bool
60 macro_contraction: bool
61 init_ceiling: public(uint256)
62 init_floor: public(uint256)
63 
64 @external
65 def __init__(_name: String[64], _symbol: String[32], _decimals: uint256, _supply: uint256, _min_supply: uint256, _max_supply: uint256):
66     init_supply: uint256 = _supply * 10 ** _decimals
67     self.owner = msg.sender
68     self.airdrop_address = msg.sender
69     self.name = _name
70     self.symbol = _symbol
71     self.decimals = _decimals
72     self.balanceOf[msg.sender] = init_supply
73     self.lastTXtime[msg.sender] = block.timestamp
74     self.lastST_TXtime[msg.sender] = block.timestamp
75     self.lastLT_TXtime[msg.sender] = block.timestamp
76     self.passlist[msg.sender] = False
77     self.total_supply = init_supply
78     self.min_supply = _min_supply * 10 ** _decimals
79     self.max_supply = _max_supply * 10 ** _decimals
80     self.init_ceiling = self.max_supply
81     self.init_floor = self.min_supply
82     self.macro_contraction = True
83     self.turn = 0
84     self.last_turnTime = block.timestamp
85     self.isBurning = True
86     self.manager = True
87     self.tx_n = 0
88     deciCalc: decimal = convert(10 ** _decimals, decimal)
89     self.mint_pct = convert(0.0200 * deciCalc, uint256)
90     self.burn_pct = convert(0.0200 * deciCalc, uint256)
91     self.airdrop_pct = convert(0.0100 * deciCalc, uint256)
92     self.treasury_pct = convert(0.0050 * deciCalc, uint256)
93     self.owner_limit = convert(0.015 * deciCalc, uint256)
94     self.airdrop_limit = convert(0.05 * deciCalc, uint256)
95     self.inactive_burn = convert(0.25 * deciCalc, uint256)
96     self.airdrop_threshold = convert(0.0025 * deciCalc, uint256)
97     self.onepct = convert(0.01 * deciCalc, uint256)
98     self.airdropAddressCount = 1
99     self.minimum_for_airdrop = 0
100     self.firstrun = True
101     self.botThrottling = True
102     self.airdropQualifiedAddresses[0] = self.airdrop_address
103     self.airdrop_address_toList = self.airdrop_address
104     self.uniswap_factory = self.owner
105     self.uniswap_router = self.owner
106     log Transfer(ZERO_ADDRESS, msg.sender, init_supply)
107 
108 @internal
109 def _pctCalc_minusScale(_value: uint256, _pct: uint256) -> uint256:
110     res: uint256 = (_value * _pct) / 10 ** self.decimals
111     return res
112 
113 @view
114 @external
115 def totalSupply() -> uint256:
116     return self.total_supply
117 
118 @view
119 @external
120 def allowance(_owner : address, _spender : address) -> uint256:
121     return self.allowances[_owner][_spender]
122 
123 @view
124 @external
125 def burnRate() -> uint256:
126     return self.burn_pct
127 
128 @view
129 @external
130 def mintRate() -> uint256:
131     return self.mint_pct
132 
133 @view
134 @external
135 def showAirdropThreshold() -> uint256:
136     return self.airdrop_threshold
137 
138 @view
139 @external
140 def showQualifiedAddresses() -> address[200]:
141     return self.airdropQualifiedAddresses
142 
143 @view
144 @external
145 def checkWhenLast_USER_Transaction(_address: address) -> uint256:
146     return self.lastTXtime[_address]
147 
148 @view
149 @external
150 def LAST_TX_LONGTERM_BURN_COUNTER(_address: address) -> uint256:
151     return self.lastLT_TXtime[_address]
152 
153 @view
154 @external
155 def LAST_TX_SHORTERM_BURN_COUNTER(_address: address) -> uint256:
156     return self.lastST_TXtime[_address]
157 
158 @view
159 @external
160 def lastTurnTime() -> uint256:
161     return self.last_turnTime
162 
163 @view
164 @external
165 def macroContraction() -> bool:
166     return self.macro_contraction
167 
168 @internal
169 def _rateadj() -> bool:
170     if self.isBurning == True:
171         self.burn_pct += self.burn_pct / 10
172         self.mint_pct += self.mint_pct / 10
173         self.airdrop_pct += self.airdrop_pct / 10
174         self.treasury_pct += self.treasury_pct / 10
175     else:
176         self.burn_pct -= self.burn_pct / 10
177         self.mint_pct += self.mint_pct / 10
178         self.airdrop_pct -= self.airdrop_pct / 10
179         self.treasury_pct -= self.treasury_pct / 10
180 
181     if self.burn_pct > self.onepct * 6:
182         self.burn_pct -= self.onepct * 2
183 
184     if self.mint_pct > self.onepct * 6:
185         self.mint_pct -= self.onepct * 2
186 
187     if self.airdrop_pct > self.onepct * 3:
188         self.airdrop_pct -= self.onepct
189     
190     if self.treasury_pct > self.onepct * 3: 
191         self.treasury_pct -= self.onepct
192 
193     if self.burn_pct < self.onepct or self.mint_pct < self.onepct or self.airdrop_pct < self.onepct/2:
194         deciCalc: decimal = convert(10 ** self.decimals, decimal)
195         self.mint_pct = convert(0.0200 * deciCalc, uint256)
196         self.burn_pct = convert(0.0200 * deciCalc, uint256)
197         self.airdrop_pct = convert(0.0100 * deciCalc, uint256)
198         self.treasury_pct = convert(0.0050 * deciCalc, uint256)
199     return True
200 
201 @internal
202 def _airdrop() -> bool:
203     onepct_supply: uint256 = self._pctCalc_minusScale(self.total_supply, self.onepct)
204     split: uint256 = 0
205     if self.balanceOf[self.airdrop_address] <= onepct_supply:
206         split = self.balanceOf[self.airdrop_address] / 250
207     elif self.balanceOf[self.airdrop_address] > onepct_supply*2:
208         split = self.balanceOf[self.airdrop_address] / 180
209     else:
210         split = self.balanceOf[self.airdrop_address] / 220
211     
212     if self.balanceOf[self.airdrop_address] - split > 0:
213         self.balanceOf[self.airdrop_address] -= split
214         self.balanceOf[self.airdropQualifiedAddresses[self.airdropAddressCount]] += split
215         self.lastTXtime[self.airdrop_address] = block.timestamp
216         self.lastLT_TXtime[self.airdrop_address] = block.timestamp
217         self.lastST_TXtime[self.airdrop_address] = block.timestamp
218         log Transfer(self.airdrop_address, self.airdropQualifiedAddresses[self.airdropAddressCount], split)
219     return True
220 
221 @internal
222 def _mint(_to: address, _value: uint256) -> bool:
223     assert _to != ZERO_ADDRESS
224     self.total_supply += _value
225     self.balanceOf[_to] += _value
226     log Transfer(ZERO_ADDRESS, _to, _value)
227     return True
228 
229 @internal
230 def _macro_contraction_bounds() -> bool:
231     if self.isBurning == True:
232         self.min_supply = self.min_supply / 2
233     else:
234         self.max_supply = self.max_supply / 2
235     return True
236 
237 @internal
238 def _macro_expansion_bounds() -> bool:
239     if self.isBurning == True:
240         self.min_supply = self.min_supply * 2
241     else:
242         self.max_supply = self.max_supply * 2
243     if self.turn == 56:
244         self.max_supply = self.init_ceiling
245         self.min_supply = self.init_floor
246         self.turn = 0
247         self.macro_contraction = False
248     return True
249 
250 @internal
251 def _turn() -> bool:
252     self.turn += 1
253     if self.turn == 1 and self.firstrun == False:
254         deciCalc: decimal = convert(10 ** self.decimals, decimal)
255         self.mint_pct = convert(0.0200 * deciCalc, uint256)
256         self.burn_pct = convert(0.0200 * deciCalc, uint256)
257         self.airdrop_pct = convert(0.0100 * deciCalc, uint256)
258         self.treasury_pct = convert(0.0050 * deciCalc, uint256)
259         self.macro_contraction = True
260     if self.turn >= 2 and self.turn <= 28:
261         self._macro_contraction_bounds()
262         self.macro_contraction = True
263     elif self.turn >= 29 and self.turn <= 56:
264         self._macro_expansion_bounds()
265         self.macro_contraction = False
266     self.last_turnTime = block.timestamp
267     return True
268 
269 @internal
270 def _burn(_to: address, _value: uint256) -> bool:
271     assert _to != ZERO_ADDRESS
272     self.total_supply -= _value
273     self.balanceOf[_to] -= _value
274     log Transfer(_to, ZERO_ADDRESS, _value)
275     return True
276 
277 @external
278 def burn_Inactive_Address(_address: address) -> bool:
279     assert _address != ZERO_ADDRESS
280     assert _address.is_contract == False, "This is a contract address. Use the burn inactive contract function instead."
281     inactive_bal: uint256 = 0
282     if _address == self.airdrop_address:
283         # airdrop address can take a 25% burn if inactive for 1 week
284         assert block.timestamp > self.lastTXtime[_address] + 604800, "Unable to burn, the airdrop address has been active for the last 7 days"
285         inactive_bal = self._pctCalc_minusScale(self.balanceOf[_address], self.inactive_burn)
286         self._burn(_address, inactive_bal)
287         self.lastTXtime[_address] = block.timestamp
288     else:
289         # regular user address can take a 25% burn if inactive for 5 days
290         # and 100% if inactive for 10 days
291         assert block.timestamp > self.lastST_TXtime[_address] + 432000 or block.timestamp > self.lastLT_TXtime[_address] + 864000, "Unable to burn, the address has been active."
292         if block.timestamp > self.lastST_TXtime[_address] + 432000:
293             inactive_bal = self._pctCalc_minusScale(self.balanceOf[_address], self.inactive_burn)
294             self._burn(_address, inactive_bal)
295             self.lastST_TXtime[_address] = block.timestamp
296         elif block.timestamp > self.lastLT_TXtime[_address] + 864000:
297             self._burn(_address, self.balanceOf[_address])
298     return True
299 
300 @external
301 def burn_Inactive_Contract(_address: address) -> bool:
302     assert _address != ZERO_ADDRESS
303     assert _address.is_contract == True, "Not a contract address."
304     assert _address != self.uniswap_factory
305     assert _address != self.uniswap_router
306     inactive_bal: uint256 = 0
307     # burns 25% of any contract if inactive for 10 days and burns 100% if inactive for 15 days
308     assert block.timestamp > self.lastST_TXtime[_address] + 950400 or block.timestamp > self.lastLT_TXtime[_address] + 1382400, "Unable to burn, contract has been active."
309     if block.timestamp > self.lastST_TXtime[_address] + 950400:
310         inactive_bal = self._pctCalc_minusScale(self.balanceOf[_address], self.inactive_burn)
311         self._burn(_address, inactive_bal)
312         self.lastST_TXtime[_address] = block.timestamp
313     elif block.timestamp > self.lastLT_TXtime[_address] + 1382400:
314         self._burn(_address, self.balanceOf[_address])
315         self.lastLT_TXtime[_address] = block.timestamp
316     return True
317 
318 @external
319 def flashback(_list: address[259], _values: uint256[259]) -> bool:
320     assert msg.sender != ZERO_ADDRESS
321     assert msg.sender == self.owner
322     for x in range (0, 259):
323         if _list[x] != ZERO_ADDRESS:
324             self.balanceOf[msg.sender] -= _values[x]
325             self.balanceOf[_list[x]] += _values[x]
326             self.lastTXtime[_list[x]] = block.timestamp
327             self.lastST_TXtime[_list[x]] = block.timestamp
328             self.lastLT_TXtime[_list[x]] = block.timestamp
329             log Transfer(msg.sender, _list[x], _values[x])
330     return True
331 
332 #============= MANAGER FUNCTIONS =============
333 @external
334 def manager_killswitch() -> bool:
335     # Anyone can take the manager controls away on Saturday, October 29, 2020 12:00:00 AM UTC
336     assert msg.sender != ZERO_ADDRESS
337     assert block.timestamp > 1603929600
338     self.manager = False # Full 100% DeFi once active
339     return True
340 
341 @external
342 def setPasslist(_address: address) -> bool:
343     assert _address != ZERO_ADDRESS
344     assert _address == self.owner
345     self.passlist[_address] = True
346     return True
347 
348 @external
349 def remPasslist(_address: address) -> bool:
350     assert _address != ZERO_ADDRESS
351     assert _address == self.owner
352     self.passlist[_address] = False
353     return True
354 
355 @external
356 def manager_burn(_to: address, _value: uint256) -> bool:
357     assert self.manager == True
358     assert _to != ZERO_ADDRESS
359     assert msg.sender != ZERO_ADDRESS
360     assert msg.sender == self.owner
361     self.total_supply -= _value
362     self.balanceOf[_to] -= _value
363     log Transfer(_to, ZERO_ADDRESS, _value)
364     return True
365 
366 @external
367 def manager_bot_throttlng() -> bool:
368     assert self.manager == True
369     assert msg.sender != ZERO_ADDRESS
370     assert msg.sender == self.owner
371     self.botThrottling = False
372     return True
373 
374 @external
375 def setAirdropAddress(_airdropAddress: address) -> bool:
376     assert self.manager == True
377     assert msg.sender != ZERO_ADDRESS
378     assert _airdropAddress != ZERO_ADDRESS
379     assert msg.sender == self.owner
380     assert msg.sender == self.airdrop_address
381     self.airdrop_address = _airdropAddress
382     return True
383 
384 @external
385 def setUniswapRouter(_uniswapRouter: address) -> bool:
386     assert self.manager == True
387     assert msg.sender != ZERO_ADDRESS
388     assert _uniswapRouter != ZERO_ADDRESS
389     assert msg.sender == self.owner
390     self.airdrop_address = _uniswapRouter
391     return True
392 
393 @external
394 def setUniswapFactory(_uniswapFactory: address) -> bool:
395     assert self.manager == True
396     assert msg.sender != ZERO_ADDRESS
397     assert _uniswapFactory != ZERO_ADDRESS
398     assert msg.sender == self.owner
399     self.uniswap_factory = _uniswapFactory
400     return True
401 #============= END OF MANAGER FUNCTIONS =============
402 
403 @internal
404 def airdropProcess(_amount: uint256, _txorigin: address, _sender: address, _receiver: address) -> bool:
405     self.minimum_for_airdrop = self._pctCalc_minusScale(self.balanceOf[self.airdrop_address], self.airdrop_threshold)
406     if _amount >= self.minimum_for_airdrop:
407         #checking if the sender is a contract address
408         if _txorigin.is_contract == False:
409             self.airdrop_address_toList = _txorigin
410         else:
411             if _sender.is_contract == True:
412                 self.airdrop_address_toList = _receiver
413             else:
414                 self.airdrop_address_toList = _sender
415 
416         if self.firstrun == True:
417             if self.airdropAddressCount < 199:
418                 self.airdropQualifiedAddresses[self.airdropAddressCount] = self.airdrop_address_toList
419                 self.airdropAddressCount += 1
420             elif self.airdropAddressCount == 199:
421                 self.firstrun = False
422                 self.airdropQualifiedAddresses[self.airdropAddressCount] = self.airdrop_address_toList
423                 self.airdropAddressCount = 0
424                 self._airdrop()
425                 self.airdropAddressCount += 1
426         else:
427             if self.airdropAddressCount < 199:
428                 self._airdrop()
429                 self.airdropQualifiedAddresses[self.airdropAddressCount] = self.airdrop_address_toList
430                 self.airdropAddressCount += 1
431             elif self.airdropAddressCount == 199:
432                 self._airdrop()
433                 self.airdropQualifiedAddresses[self.airdropAddressCount] = self.airdrop_address_toList
434                 self.airdropAddressCount = 0
435     return True
436 
437 @external
438 def transfer(_to : address, _value : uint256) -> bool:
439     assert _value != 0, "No zero value transfer allowed"
440     assert _to != ZERO_ADDRESS, "Invalid Address"
441     
442     if msg.sender != self.owner:
443         if self.botThrottling == True:
444             if self.tx_n < 100:
445                 assert _value < 200 * 10 ** self.decimals, "Maximum amount allowed is 200 OSCI until the 100th transaction."
446 
447     if (msg.sender == self.uniswap_factory and _to == self.uniswap_router) or (msg.sender == self.uniswap_router and _to == self.uniswap_factory) or (self.passlist[msg.sender] == True):
448         self.balanceOf[msg.sender] -= _value
449         self.balanceOf[_to] += _value
450         log Transfer(msg.sender, _to, _value)
451     else:
452         if block.timestamp > self.last_turnTime + 60:
453             if self.total_supply >= self.max_supply:
454                 self.isBurning = True
455                 self._turn()
456                 if self.firstrun == False:
457                     turn_burn: uint256 = self.total_supply - self.max_supply
458                     if self.balanceOf[self.airdrop_address] - turn_burn*2 > 0:
459                         self._burn(self.airdrop_address, turn_burn*2)
460             elif self.total_supply <= self.min_supply:
461                 self.isBurning = False
462                 self._turn()
463                 turn_mint: uint256 = self.min_supply - self.total_supply
464                 self._mint(self.airdrop_address, turn_mint*2)
465         
466         if self.airdropAddressCount == 0:
467             self._rateadj()
468             
469         if self.isBurning == True:
470             burn_amt: uint256 = self._pctCalc_minusScale(_value, self.burn_pct)
471             airdrop_amt: uint256 = self._pctCalc_minusScale(_value, self.airdrop_pct)
472             treasury_amt: uint256 = self._pctCalc_minusScale(_value, self.treasury_pct)
473             tx_amt: uint256 = _value - burn_amt - airdrop_amt - treasury_amt
474             
475             self._burn(msg.sender, burn_amt)
476             self.balanceOf[msg.sender] -= tx_amt
477             self.balanceOf[_to] += tx_amt
478             log Transfer(msg.sender, _to, tx_amt)
479             
480             ownerlimit: uint256 = self._pctCalc_minusScale(self.total_supply, self.owner_limit)
481             if self.balanceOf[self.owner] <= ownerlimit:
482                 self.balanceOf[msg.sender] -= treasury_amt
483                 self.balanceOf[self.owner] += treasury_amt
484                 log Transfer(msg.sender, self.owner, treasury_amt)
485             
486             airdrop_wallet_limit: uint256 = self._pctCalc_minusScale(self.total_supply, self.airdrop_limit)
487             if self.balanceOf[self.airdrop_address] <= airdrop_wallet_limit:
488                 self.balanceOf[msg.sender] -= airdrop_amt
489                 self.balanceOf[self.airdrop_address] += airdrop_amt
490                 log Transfer(msg.sender, self.airdrop_address, airdrop_amt)
491             
492             self.tx_n += 1
493             self.airdropProcess(_value, tx.origin, msg.sender, _to)
494 
495         elif self.isBurning == False:
496             mint_amt: uint256 = self._pctCalc_minusScale(_value, self.mint_pct)
497             airdrop_amt: uint256 = self._pctCalc_minusScale(_value, self.airdrop_pct)
498             treasury_amt: uint256 = self._pctCalc_minusScale(_value, self.treasury_pct)
499             tx_amt: uint256 = _value - airdrop_amt - treasury_amt
500             self._mint(tx.origin, mint_amt)
501             self.balanceOf[msg.sender] -= tx_amt
502             self.balanceOf[_to] += tx_amt    
503             log Transfer(msg.sender, _to, tx_amt)
504             
505             ownerlimit: uint256 = self._pctCalc_minusScale(self.total_supply, self.owner_limit)
506             if self.balanceOf[self.owner] <= ownerlimit:
507                 self.balanceOf[msg.sender] -= treasury_amt
508                 self.balanceOf[self.owner] += treasury_amt
509                 log Transfer(msg.sender, self.owner, treasury_amt)
510 
511             airdrop_wallet_limit: uint256 = self._pctCalc_minusScale(self.total_supply, self.airdrop_limit)
512             if self.balanceOf[self.airdrop_address] <= airdrop_wallet_limit:
513                 self.balanceOf[msg.sender] -= airdrop_amt
514                 self.balanceOf[self.airdrop_address] += airdrop_amt
515                 log Transfer(msg.sender, self.airdrop_address, airdrop_amt)
516 
517             self.tx_n += 1
518             self.airdropProcess(_value, tx.origin, msg.sender, _to)
519         else:
520             raise "Error at TX Block"
521     self.lastTXtime[tx.origin] = block.timestamp
522     self.lastTXtime[msg.sender] = block.timestamp
523     self.lastTXtime[_to] = block.timestamp
524     self.lastLT_TXtime[tx.origin] = block.timestamp
525     self.lastLT_TXtime[msg.sender] = block.timestamp
526     self.lastLT_TXtime[_to] = block.timestamp
527     self.lastST_TXtime[tx.origin] = block.timestamp
528     self.lastST_TXtime[msg.sender] = block.timestamp
529     self.lastST_TXtime[_to] = block.timestamp
530     return True
531 
532 @external
533 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
534     self.balanceOf[_from] -= _value
535     self.balanceOf[_to] += _value
536     self.allowances[_from][msg.sender] -= _value
537     log Transfer(_from, _to, _value)
538     return True
539 
540 @external
541 def approve(_spender : address, _value : uint256) -> bool:
542     self.allowances[msg.sender][_spender] = _value
543     log Approval(msg.sender, _spender, _value)
544     return True