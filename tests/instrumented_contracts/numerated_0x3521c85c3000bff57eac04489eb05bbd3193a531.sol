1 # MetaWhale BTC by DEFILABS
2 #
3 # Find out more about MetaWhale @ metawhale.io
4 #
5 # A TOKEN TESTED BY DEFI LABS @ HTTPS://DEFILABS.ETH.LINK
6 # CREATOR: Dr. Mantis => @dr_mantis_defilabs
7 #
8 # Official Announcement Channel @ https://t.me/metawhale_official
9 # But better join the fantastic community @ https://t.me/defilabs_community
10 
11 from vyper.interfaces import ERC20
12 
13 implements: ERC20
14 
15 interface IReserves:
16     def swapInactiveToWETH(amountIn: uint256, inactive: address) -> bool: nonpayable
17     def swapTokensForWETH(amountIn: uint256) -> bool: nonpayable
18     def addLiquidity(reserveBal: uint256) -> bool: nonpayable
19     def swapForSecondaryAndBurn() -> bool: nonpayable
20     def swapForTerciary() -> bool: nonpayable
21     def checkTerciarySize() -> bool: nonpayable
22     def close() -> bool: nonpayable
23     def baseAssetLP() -> address: view
24     def reserveAsset() -> address: view
25     def KingAsset() -> address: view
26     def AirdropAddress() -> address: view
27     def NFTFaucet() -> address: view
28     def MarketingFaucet() -> address: view
29     def devFaucet() -> address: view
30 
31 event Transfer:
32     sender: indexed(address)
33     receiver: indexed(address)
34     value: uint256
35 
36 event Approval:
37     owner: indexed(address)
38     spender: indexed(address)
39     value: uint256
40 
41 name: public(String[64])
42 symbol: public(String[32])
43 decimals: public(uint256)
44 min_supply: public(uint256)
45 final_supply: public(uint256)
46 final_reserve: public(uint256)
47 balanceOf: public(HashMap[address, uint256])
48 allowances: HashMap[address, HashMap[address, uint256]]
49 last5pctmove: public(HashMap[address, uint256])
50 lastIndividualTrade: public(HashMap[address, uint256])
51 lastTrade: public(uint256)
52 passlist: public(HashMap[address, bool])
53 dexReserve: public(address)
54 total_supply: uint256
55 deployer: public(address)
56 reserve: public(address)
57 inactive_sell: public(uint256)
58 dividends: uint256
59 dividend_split: uint256
60 nft_total_dividend: public(HashMap[uint256, uint256])
61 dev_total_dividend: public(HashMap[uint256, uint256])
62 marketing_total_dividend: public(HashMap[uint256, uint256])
63 reserveManager: public(address[50])
64 reservecounter: public(uint256)
65 onepct: public(uint256)
66 burn_pct: public(uint256)
67 reserve_pct: public(uint256)
68 reserve_threshold: public(uint256)
69 tradingIO: public(bool)
70 n_trades: public(uint256)
71 switcher: public(uint256)
72 incentive: public(uint256)
73 conclusiontime: public(uint256)
74 Airdrop_Eligibility: public(HashMap[address, uint256])
75 manager: public(uint256)
76 airdropExpiryDate: public(uint256)
77 lpaddress: public(address)
78 airdropAddress: public(address)
79 nftyield_addy: public(address)
80 marketing_addy: public(address)
81 dev_addy: public(address)
82 reserve_asset: public(address)
83 dexcheckpoint: public(uint256)
84 dexstep: public(uint256)
85 dexAllocation: public(uint256)
86 dexRebaseCount: public(uint256)
87 
88 @external
89 def __init__(_name: String[64], _symbol: String[32], _decimals: uint256, _supply: uint256):
90     init_supply: uint256 = _supply * 10 ** _decimals
91     self.name = _name
92     self.symbol = _symbol
93     self.decimals = _decimals
94     self.balanceOf[msg.sender] = init_supply
95     self.total_supply = init_supply
96     self.min_supply = 1 * 10 ** _decimals
97     self.deployer = msg.sender
98     deciCalc: decimal = convert(10 ** _decimals, decimal)
99     self.onepct = convert(0.01 * deciCalc, uint256)
100     self.burn_pct = convert(0.0125 * deciCalc, uint256)
101     self.reserve_pct = convert(0.0125 * deciCalc, uint256)
102     self.inactive_sell = convert(0.06 * deciCalc, uint256)
103     self.reserve_threshold = convert(0.0035 * deciCalc, uint256)
104     self.passlist[msg.sender] = False
105     self.reserve = self.deployer
106     self.last5pctmove[self.deployer] = block.timestamp
107     self.tradingIO = True
108     self.switcher = 1
109     self.reservecounter = 0
110     self.dividends = 0
111     self.dividend_split = 0
112     self.dexRebaseCount = 0
113     self.lastTrade = block.timestamp
114     self.airdropExpiryDate = block.timestamp + 2600000
115     self.lpaddress = ZERO_ADDRESS
116     self.reserve_asset = ZERO_ADDRESS
117     self.airdropAddress = ZERO_ADDRESS
118     self.nftyield_addy = ZERO_ADDRESS
119     self.marketing_addy = ZERO_ADDRESS
120     self.dev_addy = ZERO_ADDRESS
121     self.manager = 3
122     self.incentive = 0
123     self.n_trades = 0
124     log Transfer(ZERO_ADDRESS, msg.sender, init_supply)
125 
126 @internal
127 def _pctCalc_minusScale(_value: uint256, _pct: uint256) -> uint256:
128     res: uint256 = (_value * _pct) / 10 ** self.decimals
129     return res
130 
131 @internal
132 def _pctCalc_pctofwhole(_portion: uint256, _ofWhole: uint256) -> uint256:
133     res: uint256 = (_portion*10**self.decimals)/_ofWhole
134     return res
135 
136 @view
137 @external
138 def totalSupply() -> uint256:
139     return self.total_supply
140 
141 @view
142 @external
143 def minSupply() -> uint256:
144     return self.min_supply
145 
146 @view
147 @external
148 def allowance(_owner : address, _spender : address) -> uint256:
149     return self.allowances[_owner][_spender]
150 
151 @view
152 @external
153 def nDIVIDEND() -> uint256:
154     return self.dividends
155 
156 @view
157 @external
158 def nftDividend(_tranche: uint256) -> uint256:
159     return self.nft_total_dividend[_tranche]
160 
161 @view
162 @external
163 def marketingDividend(_tranche: uint256) -> uint256:
164     return self.marketing_total_dividend[_tranche]
165 
166 @view
167 @external
168 def devDividend(_tranche: uint256) -> uint256:
169     return self.dev_total_dividend[_tranche]
170 
171 @view
172 @external
173 def showReserveManagers() -> address[50]:
174     return self.reserveManager
175 
176 @external
177 def setReserve(_address: address) -> bool:
178     assert self.manager == 3
179     assert msg.sender == self.deployer
180     assert _address != ZERO_ADDRESS
181     self.reserve = _address
182     return True
183 
184 @external
185 def setDEXcheckpointAndAllocation(_allocation: uint256) -> bool:
186     assert self.manager == 3
187     assert msg.sender == self.deployer
188     self.dexstep = self._pctCalc_minusScale(self.total_supply, self.onepct*5)
189     self.dexcheckpoint = self.total_supply - self.dexstep
190     self.dexAllocation = _allocation * 10 ** self.decimals
191     return True
192 
193 @external
194 def setPasslist(_address: address) -> bool:
195     assert self.manager >= 1
196     assert _address != ZERO_ADDRESS
197     assert msg.sender == self.deployer
198     self.passlist[_address] = True
199     return True
200 
201 @external
202 def remPasslist(_address: address) -> bool:
203     assert self.manager >= 1
204     assert _address != ZERO_ADDRESS
205     assert msg.sender == self.deployer
206     self.passlist[_address] = False
207     return True
208 
209 @internal
210 def _approve(_owner: address, _spender: address, _amount: uint256):
211     assert _owner != ZERO_ADDRESS, "ERC20: Approve from zero addy"
212     assert _spender != ZERO_ADDRESS, "ERC20: Approve to zero addy"
213     self.allowances[_owner][_spender] = _amount
214     log Approval(_owner, _spender, _amount)
215 
216 @external
217 def approve(_spender : address, _value : uint256) -> bool:
218     self._approve(msg.sender, _spender, _value)
219     return True
220 
221 @internal
222 def _burn(_to: address, _value: uint256):
223     assert _to != ZERO_ADDRESS
224     self.total_supply -= _value
225     self.balanceOf[_to] -= _value
226     log Transfer(_to, ZERO_ADDRESS, _value)
227 
228 @internal
229 def _sendtoReserve(_from: address, _value: uint256):
230     self.balanceOf[_from] -= _value
231     self.balanceOf[self.reserve] += _value
232     log Transfer(_from, self.reserve, _value)
233 
234 @external
235 def inactivityBurn(_address: address) -> bool:
236     assert _address != ZERO_ADDRESS
237     assert msg.sender != ZERO_ADDRESS
238     assert self.passlist[_address] != True
239     assert block.timestamp > self.lastIndividualTrade[_address] + 10518972, "MetaWhale: Addy is still active." #4 months 
240     half: uint256 = self.balanceOf[_address]/2
241     self.balanceOf[_address] -= half
242     self.balanceOf[msg.sender] += half
243     log Transfer(_address, msg.sender, half)
244     self._burn(_address, self.balanceOf[_address])
245     return True
246 
247 @internal
248 def _mint(_to: address, _value: uint256) -> bool:
249     assert _to != ZERO_ADDRESS
250     self.total_supply += _value
251     self.balanceOf[_to] += _value
252     log Transfer(ZERO_ADDRESS, _to, _value)
253     return True
254 
255 @external
256 def setAirdropEligibility(_eligibleAddresses: address[100], _amounts: uint256[100]) -> bool:
257     assert msg.sender == self.deployer
258     assert self.manager == 3
259     for x in range(0, 100):
260         if _eligibleAddresses[x] != ZERO_ADDRESS:
261             self.Airdrop_Eligibility[_eligibleAddresses[x]] = _amounts[x]*10**(self.decimals-4)
262         else:
263             break
264     return True
265 
266 @external
267 def managerLevelDecrease() -> bool:
268     assert msg.sender != ZERO_ADDRESS
269     assert msg.sender == self.deployer
270     assert self.manager >= 1
271     if self.manager == 2:
272         self.airdropExpiryDate = block.timestamp + 86400 #1day
273     self.manager -= 1
274     return True
275 
276 @external
277 def claimAirdrop() -> bool:
278     assert self.manager <= 1
279     assert msg.sender != ZERO_ADDRESS
280     assert self.Airdrop_Eligibility[msg.sender] > 0
281     assert block.timestamp < self.airdropExpiryDate
282     self._mint(msg.sender, self.Airdrop_Eligibility[msg.sender])
283     self.Airdrop_Eligibility[msg.sender] = 0
284     self.last5pctmove[msg.sender] = block.timestamp
285     self.lastIndividualTrade[msg.sender] = block.timestamp
286     return True
287 
288 @external
289 def setQuaternaryDividend() -> bool:
290     assert msg.sender != ZERO_ADDRESS
291     Polaris: address = 0x36F7E77A392a7B4a6fCB781aCE715ec2450F3Aca
292     self.reserve_asset = IReserves(Polaris).KingAsset()
293     self.airdropAddress = IReserves(Polaris).AirdropAddress()
294     self.nftyield_addy = IReserves(Polaris).NFTFaucet()
295     self.marketing_addy = IReserves(Polaris).MarketingFaucet()
296     self.dev_addy = IReserves(Polaris).devFaucet()
297     return True
298 
299 @external
300 def forcedSell(_address: address) -> bool:
301     assert msg.sender != ZERO_ADDRESS
302     assert _address != ZERO_ADDRESS
303     assert self.passlist[_address] != True
304     assert block.timestamp > self.last5pctmove[_address] + 3024000 #35days
305     amount: uint256 = self._pctCalc_minusScale(self.balanceOf[_address], self.inactive_sell-self.onepct)
306     callerIncentive: uint256 = self._pctCalc_minusScale(self.balanceOf[_address], self.onepct)
307     self._sendtoReserve(_address, amount)
308     IReserves(self.reserve).swapInactiveToWETH(amount, _address)
309     self.last5pctmove[_address] = block.timestamp
310     self.balanceOf[_address] -= callerIncentive
311     self.balanceOf[msg.sender] += callerIncentive
312     log Transfer(_address, msg.sender, callerIncentive)
313     return True
314 
315 @external
316 def setDEXreserve(_exReserve: address) -> bool:
317     assert msg.sender == self.deployer
318     assert self.manager >= 1
319     assert _exReserve != ZERO_ADDRESS
320     self.dexReserve = _exReserve
321     return True
322 
323 @external
324 def rebaseExchangeReserve() -> bool:
325     assert msg.sender != ZERO_ADDRESS
326     assert self.dexReserve != ZERO_ADDRESS
327     assert self.dexReserve != self
328     if self.dexRebaseCount == 19:
329         self._burn(self.dexReserve, self.balanceOf[self.dexReserve])
330     else:
331         if self.total_supply < self.dexcheckpoint:
332             amount: uint256 = self._pctCalc_minusScale(self.dexAllocation, self.onepct*5)
333             self._burn(self.dexReserve, amount)
334             self.dexcheckpoint -= self.dexstep
335             self.dexRebaseCount += 1
336         else:
337             pass
338     return True
339 
340 @external
341 def DEXchecker() -> bool:
342     assert msg.sender != ZERO_ADDRESS
343     assert self.dexReserve != ZERO_ADDRESS
344     assert self.dexReserve != self
345     amount: uint256 = self._pctCalc_minusScale(self.dexAllocation, self.onepct*5)
346     if self.balanceOf[self.dexReserve] > self.dexAllocation - (amount*self.dexRebaseCount):
347         amt2correct: uint256 = self.balanceOf[self.dexReserve] - (self.dexAllocation - amount*self.dexRebaseCount)
348         self._burn(self.dexReserve, amt2correct)
349     return True
350 
351 @internal
352 def _prepReserve() -> bool:
353     assert self.total_supply <= self.min_supply
354     assert self.tradingIO == True
355     weth_addy: address = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
356     secundary_asset_addy: address = IReserves(self.reserve).reserveAsset()
357     self.final_supply = self.total_supply
358     self.final_reserve = ERC20(secundary_asset_addy).balanceOf(self)
359     _LPcontract: address = IReserves(self.reserve).baseAssetLP()
360     LPbal: uint256 = ERC20(_LPcontract).balanceOf(self)
361     ERC20(_LPcontract).transfer(self.reserve, LPbal)
362     wethbal: uint256 = ERC20(weth_addy).balanceOf(self)
363     ERC20(weth_addy).transfer(self.reserve, wethbal)
364     IReserves(self.reserve).close()
365     self.tradingIO = False
366     self.switcher = 1
367     self.conclusiontime = block.timestamp
368     return True
369 
370 @external
371 def finish() -> bool:
372     assert self.total_supply <= self.min_supply
373     assert self.tradingIO == True
374     assert self.manager == 0
375     self.switcher = 1
376     self._prepReserve()
377     return True
378 
379 @external
380 def inactivityFinish() -> bool:
381     assert self.tradingIO == True
382     assert self.manager == 0
383     if block.timestamp > self.lastTrade + 7889229: #3months
384         self.min_supply = self.total_supply
385         self.switcher = 1
386         self._prepReserve()
387     return True
388 
389 @external
390 def claimReserve() -> bool:
391     assert msg.sender != ZERO_ADDRESS
392     assert self.tradingIO == False
393     assert self.manager == 0
394     callerbalance: uint256 = self.balanceOf[msg.sender]
395     pctofbase: uint256 = self._pctCalc_pctofwhole(callerbalance, self.final_supply)
396     pctofreserve: uint256 = self._pctCalc_minusScale(self.final_reserve, pctofbase)
397     ERC20(IReserves(self.reserve).reserveAsset()).transfer(msg.sender, pctofreserve)
398     self._burn(msg.sender, callerbalance)
399     return True
400 
401 @external
402 def bigreset() -> bool:
403     assert self.conclusiontime != 0
404     assert block.timestamp > self.conclusiontime + 2629743 #1month
405     assert self.manager == 0
406     newsupply: uint256 = (1000000*10**self.decimals) - self.total_supply
407     self._mint(self.reserve, newsupply)
408     #self._mint(self.dexReserve, self.dexAllocation)
409     self.dexRebaseCount = 0
410     self.dexcheckpoint = self.total_supply - self.dexstep
411     self.min_supply = 1*10**self.decimals
412     self.conclusiontime = 0
413     self.switcher = 1
414     self.tradingIO = True
415     IReserves(self.reserve).swapTokensForWETH(self.balanceOf[self.reserve])
416     return True
417 
418 @internal
419 def _manageReserve(_caller: address) -> bool:
420     assert _caller != ZERO_ADDRESS
421     assert self.tradingIO == True
422     assert self.manager <= 2
423     if _caller in self.reserveManager:
424         pass
425     else:
426         if self.reservecounter == 50:
427             self.reservecounter = 0
428         rsv_check: uint256 = self._pctCalc_minusScale(self.total_supply, self.reserve_threshold)
429         if self.balanceOf[self.reserve] > rsv_check and self.n_trades > 40 and self.switcher == 1:
430             amountIn: uint256 = self._pctCalc_minusScale(self.balanceOf[self.reserve], self.onepct*85)
431             IReserves(self.reserve).swapTokensForWETH(amountIn)
432             self.reserveManager[self.reservecounter] = _caller
433             self.reservecounter += 1
434             self.switcher = 2
435             self.incentive = self._pctCalc_minusScale(amountIn, self.onepct)
436             self._mint(_caller, self.incentive*2)
437             return True
438         elif self.switcher == 2:
439             self._approve(self.reserve, 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, self.balanceOf[self.reserve]/2)
440             IReserves(self.reserve).addLiquidity(self.balanceOf[self.reserve]/2)
441             self.reserveManager[self.reservecounter] = _caller
442             self.reservecounter += 1
443             self.switcher = 3
444             self._mint(_caller, self.incentive*2)
445             return True
446         elif self.switcher == 3:
447             IReserves(self.reserve).swapForSecondaryAndBurn()
448             self.reserveManager[self.reservecounter] = _caller
449             self.reservecounter += 1
450             self.switcher = 4
451             self._mint(_caller, self.incentive*6)
452             return True
453         elif self.switcher == 4:
454             IReserves(self.reserve).swapForTerciary()
455             self.reserveManager[self.reservecounter] = _caller
456             self.reservecounter += 1
457             self.switcher = 5
458             self._mint(_caller, self.incentive*2)
459             return True
460         elif self.switcher == 5:
461             terciarySize: uint256 = ERC20(self.reserve_asset).balanceOf(self)
462             terciaryTS: uint256 = ERC20(self.reserve_asset).totalSupply()
463             terciaryThreshold: uint256 = self._pctCalc_minusScale(terciaryTS, self.onepct)
464             if terciarySize > terciaryThreshold:
465                 self.dividend_split = terciarySize/20
466                 ERC20(self.reserve_asset).transfer(self.airdropAddress, self.dividend_split*4)
467                 self.reserveManager[self.reservecounter] = _caller
468                 self.reservecounter += 1
469                 self.switcher = 6
470                 self._mint(_caller, self.incentive*2)
471             else:
472                 self.reserveManager[self.reservecounter] = _caller
473                 self.reservecounter += 1
474                 self.switcher = 1
475                 self._mint(_caller, self.incentive)
476             return True
477         elif self.switcher == 6:
478             pretxbal: uint256 = ERC20(self.reserve_asset).balanceOf(self.nftyield_addy)
479             ERC20(self.reserve_asset).transfer(self.nftyield_addy, self.dividend_split*14)
480             posttxbal: uint256 = ERC20(self.reserve_asset).balanceOf(self.nftyield_addy)
481             self.nft_total_dividend[self.dividends] = posttxbal - pretxbal
482             self._mint(_caller, self.incentive*2)
483             self.reserveManager[self.reservecounter] = _caller
484             self.reservecounter += 1
485             self.switcher = 7
486             return True
487         elif self.switcher == 7:
488             pretxbal: uint256 = ERC20(self.reserve_asset).balanceOf(self.marketing_addy)
489             ERC20(self.reserve_asset).transfer(self.marketing_addy, self.dividend_split)
490             posttxbal: uint256 = ERC20(self.reserve_asset).balanceOf(self.marketing_addy)
491             self.marketing_total_dividend[self.dividends] = posttxbal - pretxbal
492             self._mint(_caller, self.incentive*2)
493             self.reserveManager[self.reservecounter] = _caller
494             self.reservecounter += 1
495             self.switcher = 8
496             return True
497         elif self.switcher == 8:
498             pretxbal: uint256 = ERC20(self.reserve_asset).balanceOf(self.dev_addy)
499             ERC20(self.reserve_asset).transfer(self.dev_addy, self.dividend_split)
500             posttxbal: uint256 = ERC20(self.reserve_asset).balanceOf(self.dev_addy)
501             self.dev_total_dividend[self.dividends] = posttxbal - pretxbal
502             self._mint(_caller, self.incentive*2)
503             self.reserveManager[self.reservecounter] = _caller
504             self.reservecounter += 1
505             self.switcher = 1
506             self.dividends += 1
507             return True
508     return True
509 
510 @internal
511 def _transfer(_from: address, _to: address, _value: uint256) -> bool:
512     assert self.balanceOf[_from] >= _value, "Insufficient balance"
513     assert _value != 0, "No zero value transfer allowed"
514     assert _to != ZERO_ADDRESS, "Invalid To Address"
515     assert _from != ZERO_ADDRESS, "Invalid From Address"
516     
517     if self.manager >= 2:
518         if _from != self.deployer:
519             if self.n_trades <= 1000:
520                 assert _value <= 1000 * 10 ** self.decimals, "Maximum amount allowed is 1000 MWBTC until the 100th transaction."
521                 assert self.lastIndividualTrade[_to] != block.timestamp, "One buy per block."
522             else:
523                 pass
524         else:
525             self.manager = 2
526     else:
527         pass
528 
529     if self.tradingIO == True:
530         if self.last5pctmove[_from] == 0:
531             self.last5pctmove[_from] = block.timestamp
532             self.lastIndividualTrade[_from] = block.timestamp
533         if self.last5pctmove[_to] == 0:
534             self.last5pctmove[_to] = block.timestamp
535             self.lastIndividualTrade[_to] = block.timestamp
536         if self.total_supply > self.min_supply:
537             burn_amt: uint256 = self._pctCalc_minusScale(_value, self.burn_pct)
538             reserve_amt: uint256 = self._pctCalc_minusScale(_value, self.reserve_pct)
539             minForActive: uint256 = self._pctCalc_minusScale(self.balanceOf[_from], self.inactive_sell)
540             if self.passlist[_from] == True and self.passlist[_to] == True:
541                 self.balanceOf[_from] -= _value
542                 self.balanceOf[_to] += _value
543                 log Transfer(_from, _to, _value)
544             elif self.passlist[_from] == False and self.passlist[_to] == True:
545                 rsv: uint256 = reserve_amt*3
546                 val: uint256 = _value - burn_amt*2 - rsv
547                 self.balanceOf[_from] -= val
548                 self.balanceOf[_to] += val
549                 log Transfer(_from, _to, val)
550                 self._burn(_from, burn_amt*2)
551                 self._sendtoReserve(_from, rsv)              
552                 if _value > minForActive:
553                     self.last5pctmove[_from] = block.timestamp
554                 self.lastIndividualTrade[_from] = block.timestamp
555             elif self.passlist[_from] == True and self.passlist[_to] == False:
556                 self.balanceOf[_from] -= _value
557                 self.balanceOf[_to] += _value
558                 log Transfer(_from, _to, _value)
559                 self._burn(_to, burn_amt)
560                 self._sendtoReserve(_to, reserve_amt)
561                 if _value > minForActive:
562                     self.last5pctmove[_to] = block.timestamp
563                 self.lastIndividualTrade[_to] = block.timestamp
564             else:
565                 val: uint256 = _value - burn_amt - reserve_amt
566                 self._burn(_from, burn_amt)
567                 self._sendtoReserve(_to, reserve_amt)
568                 self.balanceOf[_from] -= val
569                 self.balanceOf[_to] += val
570                 log Transfer(_from, _to, val)
571                 if _value > minForActive:
572                     self.last5pctmove[_from] = block.timestamp
573                 self.lastIndividualTrade[_from] = block.timestamp
574             self.lastTrade = block.timestamp
575             self.n_trades += 1
576         else:
577             pass
578     else:
579         pass
580     return True
581 
582 @external
583 def manageReserve() -> bool:
584     self._manageReserve(msg.sender)
585     return True
586 
587 @external
588 def transfer(_to : address, _value : uint256) -> bool:
589     self._transfer(msg.sender, _to, _value)
590     return True
591 
592 @external
593 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
594     assert self.allowances[_from][msg.sender] >= _value, "Insufficient Allowance."
595     assert _from != ZERO_ADDRESS, "Unable from Zero Addy"
596     assert _to != ZERO_ADDRESS, "Unable to Zero Addy"
597     self._transfer(_from, _to, _value)
598     self._approve(_from, msg.sender, self.allowances[_from][msg.sender] - _value)
599     return True