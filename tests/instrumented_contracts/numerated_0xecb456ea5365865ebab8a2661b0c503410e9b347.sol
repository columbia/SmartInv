1 # @version 0.2.7
2 """
3 @title Curve StableSwap Proxy
4 @author Curve Finance
5 @license MIT
6 """
7 
8 interface Burner:
9     def burn(_coin: address) -> bool: payable
10 
11 interface Curve:
12     def withdraw_admin_fees(): nonpayable
13     def kill_me(): nonpayable
14     def unkill_me(): nonpayable
15     def commit_transfer_ownership(new_owner: address): nonpayable
16     def apply_transfer_ownership(): nonpayable
17     def accept_transfer_ownership(): nonpayable
18     def revert_transfer_ownership(): nonpayable
19     def commit_new_parameters(amplification: uint256, new_fee: uint256, new_admin_fee: uint256): nonpayable
20     def apply_new_parameters(): nonpayable
21     def revert_new_parameters(): nonpayable
22     def commit_new_fee(new_fee: uint256, new_admin_fee: uint256): nonpayable
23     def apply_new_fee(): nonpayable
24     def ramp_A(_future_A: uint256, _future_time: uint256): nonpayable
25     def stop_ramp_A(): nonpayable
26     def set_aave_referral(referral_code: uint256): nonpayable
27     def donate_admin_fees(): nonpayable
28 
29 interface AddressProvider:
30     def get_registry() -> address: view
31 
32 interface Registry:
33     def get_decimals(_pool: address) -> uint256[8]: view
34     def get_underlying_balances(_pool: address) -> uint256[8]: view
35 
36 
37 MAX_COINS: constant(int128) = 8
38 ADDRESS_PROVIDER: constant(address) = 0x0000000022D53366457F9d5E68Ec105046FC4383
39 
40 struct PoolInfo:
41     balances: uint256[MAX_COINS]
42     underlying_balances: uint256[MAX_COINS]
43     decimals: uint256[MAX_COINS]
44     underlying_decimals: uint256[MAX_COINS]
45     lp_token: address
46     A: uint256
47     fee: uint256
48 
49 event CommitAdmins:
50     ownership_admin: address
51     parameter_admin: address
52     emergency_admin: address
53 
54 event ApplyAdmins:
55     ownership_admin: address
56     parameter_admin: address
57     emergency_admin: address
58 
59 event AddBurner:
60     burner: address
61 
62 
63 ownership_admin: public(address)
64 parameter_admin: public(address)
65 emergency_admin: public(address)
66 
67 future_ownership_admin: public(address)
68 future_parameter_admin: public(address)
69 future_emergency_admin: public(address)
70 
71 min_asymmetries: public(HashMap[address, uint256])
72 
73 burners: public(HashMap[address, address])
74 burner_kill: public(bool)
75 
76 # pool -> caller -> can call `donate_admin_fees`
77 donate_approval: public(HashMap[address, HashMap[address, bool]])
78 
79 @external
80 def __init__(
81     _ownership_admin: address,
82     _parameter_admin: address,
83     _emergency_admin: address
84 ):
85     self.ownership_admin = _ownership_admin
86     self.parameter_admin = _parameter_admin
87     self.emergency_admin = _emergency_admin
88 
89 
90 @payable
91 @external
92 def __default__():
93     # required to receive ETH fees
94     pass
95 
96 
97 @external
98 def commit_set_admins(_o_admin: address, _p_admin: address, _e_admin: address):
99     """
100     @notice Set ownership admin to `_o_admin`, parameter admin to `_p_admin` and emergency admin to `_e_admin`
101     @param _o_admin Ownership admin
102     @param _p_admin Parameter admin
103     @param _e_admin Emergency admin
104     """
105     assert msg.sender == self.ownership_admin, "Access denied"
106 
107     self.future_ownership_admin = _o_admin
108     self.future_parameter_admin = _p_admin
109     self.future_emergency_admin = _e_admin
110 
111     log CommitAdmins(_o_admin, _p_admin, _e_admin)
112 
113 
114 @external
115 def apply_set_admins():
116     """
117     @notice Apply the effects of `commit_set_admins`
118     """
119     assert msg.sender == self.ownership_admin, "Access denied"
120 
121     _o_admin: address = self.future_ownership_admin
122     _p_admin: address = self.future_parameter_admin
123     _e_admin: address = self.future_emergency_admin
124     self.ownership_admin = _o_admin
125     self.parameter_admin = _p_admin
126     self.emergency_admin = _e_admin
127 
128     log ApplyAdmins(_o_admin, _p_admin, _e_admin)
129 
130 
131 @internal
132 def _set_burner(_coin: address, _burner: address):
133     old_burner: address = self.burners[_coin]
134     if _coin != 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
135         if old_burner != ZERO_ADDRESS:
136             # revoke approval on previous burner
137             response: Bytes[32] = raw_call(
138                 _coin,
139                 concat(
140                     method_id("approve(address,uint256)"),
141                     convert(old_burner, bytes32),
142                     convert(0, bytes32),
143                 ),
144                 max_outsize=32,
145             )
146             if len(response) != 0:
147                 assert convert(response, bool)
148 
149         if _burner != ZERO_ADDRESS:
150             # infinite approval for current burner
151             response: Bytes[32] = raw_call(
152                 _coin,
153                 concat(
154                     method_id("approve(address,uint256)"),
155                     convert(_burner, bytes32),
156                     convert(MAX_UINT256, bytes32),
157                 ),
158                 max_outsize=32,
159             )
160             if len(response) != 0:
161                 assert convert(response, bool)
162 
163     self.burners[_coin] = _burner
164 
165     log AddBurner(_burner)
166 
167 
168 @external
169 @nonreentrant('lock')
170 def set_burner(_coin: address, _burner: address):
171     """
172     @notice Set burner of `_coin` to `_burner` address
173     @param _coin Token address
174     @param _burner Burner contract address
175     """
176     assert msg.sender == self.ownership_admin, "Access denied"
177 
178     self._set_burner(_coin, _burner)
179 
180 
181 @external
182 @nonreentrant('lock')
183 def set_many_burners(_coins: address[20], _burners: address[20]):
184     """
185     @notice Set burner of `_coin` to `_burner` address
186     @param _coins Token address
187     @param _burners Burner contract address
188     """
189     assert msg.sender == self.ownership_admin, "Access denied"
190 
191     for i in range(20):
192         coin: address = _coins[i]
193         if coin == ZERO_ADDRESS:
194             break
195         self._set_burner(coin, _burners[i])
196 
197 
198 @external
199 @nonreentrant('lock')
200 def withdraw_admin_fees(_pool: address):
201     """
202     @notice Withdraw admin fees from `_pool`
203     @param _pool Pool address to withdraw admin fees from
204     """
205     Curve(_pool).withdraw_admin_fees()
206 
207 
208 @external
209 @nonreentrant('lock')
210 def withdraw_many(_pools: address[20]):
211     """
212     @notice Withdraw admin fees from multiple pools
213     @param _pools List of pool address to withdraw admin fees from
214     """
215     for pool in _pools:
216         if pool == ZERO_ADDRESS:
217             break
218         Curve(pool).withdraw_admin_fees()
219 
220 
221 @external
222 @nonreentrant('burn')
223 def burn(_coin: address):
224     """
225     @notice Burn accrued `_coin` via a preset burner
226     @dev Only callable by an EOA to prevent flashloan exploits
227     @param _coin Coin address
228     """
229     assert tx.origin == msg.sender
230     assert not self.burner_kill
231 
232     _value: uint256 = 0
233     if _coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
234         _value = self.balance
235 
236     Burner(self.burners[_coin]).burn(_coin, value=_value)  # dev: should implement burn()
237 
238 
239 @external
240 @nonreentrant('burn')
241 def burn_many(_coins: address[20]):
242     """
243     @notice Burn accrued admin fees from multiple coins
244     @dev Only callable by an EOA to prevent flashloan exploits
245     @param _coins List of coin addresses
246     """
247     assert tx.origin == msg.sender
248     assert not self.burner_kill
249 
250     for coin in _coins:
251         if coin == ZERO_ADDRESS:
252             break
253 
254         _value: uint256 = 0
255         if coin == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE:
256             _value = self.balance
257 
258         Burner(self.burners[coin]).burn(coin, value=_value)  # dev: should implement burn()
259 
260 
261 @external
262 @nonreentrant('lock')
263 def kill_me(_pool: address):
264     """
265     @notice Pause the pool `_pool` - only remove_liquidity will be callable
266     @param _pool Pool address to pause
267     """
268     assert msg.sender == self.emergency_admin, "Access denied"
269     Curve(_pool).kill_me()
270 
271 
272 @external
273 @nonreentrant('lock')
274 def unkill_me(_pool: address):
275     """
276     @notice Unpause the pool `_pool`, re-enabling all functionality
277     @param _pool Pool address to unpause
278     """
279     assert msg.sender == self.emergency_admin or msg.sender == self.ownership_admin, "Access denied"
280     Curve(_pool).unkill_me()
281 
282 
283 @external
284 def set_burner_kill(_is_killed: bool):
285     """
286     @notice Kill or unkill `burn` functionality
287     @param _is_killed Burner kill status
288     """
289     assert msg.sender == self.emergency_admin or msg.sender == self.ownership_admin, "Access denied"
290     self.burner_kill = _is_killed
291 
292 
293 @external
294 @nonreentrant('lock')
295 def commit_transfer_ownership(_pool: address, new_owner: address):
296     """
297     @notice Transfer ownership for `_pool` pool to `new_owner` address
298     @param _pool Pool which ownership is to be transferred
299     @param new_owner New pool owner address
300     """
301     assert msg.sender == self.ownership_admin, "Access denied"
302     Curve(_pool).commit_transfer_ownership(new_owner)
303 
304 
305 @external
306 @nonreentrant('lock')
307 def apply_transfer_ownership(_pool: address):
308     """
309     @notice Apply transferring ownership of `_pool`
310     @param _pool Pool address
311     """
312     Curve(_pool).apply_transfer_ownership()
313 
314 
315 @external
316 @nonreentrant('lock')
317 def accept_transfer_ownership(_pool: address):
318     """
319     @notice Apply transferring ownership of `_pool`
320     @param _pool Pool address
321     """
322     Curve(_pool).accept_transfer_ownership()
323 
324 
325 @external
326 @nonreentrant('lock')
327 def revert_transfer_ownership(_pool: address):
328     """
329     @notice Revert commited transferring ownership for `_pool`
330     @param _pool Pool address
331     """
332     assert msg.sender in [self.ownership_admin, self.emergency_admin], "Access denied"
333     Curve(_pool).revert_transfer_ownership()
334 
335 
336 @external
337 @nonreentrant('lock')
338 def commit_new_parameters(_pool: address,
339                           amplification: uint256,
340                           new_fee: uint256,
341                           new_admin_fee: uint256,
342                           min_asymmetry: uint256):
343     """
344     @notice Commit new parameters for `_pool`, A: `amplification`, fee: `new_fee` and admin fee: `new_admin_fee`
345     @param _pool Pool address
346     @param amplification Amplification coefficient
347     @param new_fee New fee
348     @param new_admin_fee New admin fee
349     @param min_asymmetry Minimal asymmetry factor allowed.
350             Asymmetry factor is:
351             Prod(balances) / (Sum(balances) / N) ** N
352     """
353     assert msg.sender == self.parameter_admin, "Access denied"
354     self.min_asymmetries[_pool] = min_asymmetry
355     Curve(_pool).commit_new_parameters(amplification, new_fee, new_admin_fee)  # dev: if implemented by the pool
356 
357 
358 @external
359 @nonreentrant('lock')
360 def apply_new_parameters(_pool: address):
361     """
362     @notice Apply new parameters for `_pool` pool
363     @dev Only callable by an EOA
364     @param _pool Pool address
365     """
366     assert msg.sender == tx.origin
367 
368     min_asymmetry: uint256 = self.min_asymmetries[_pool]
369 
370     if min_asymmetry > 0:
371         registry: address = AddressProvider(ADDRESS_PROVIDER).get_registry()
372         underlying_balances: uint256[8] = Registry(registry).get_underlying_balances(_pool)
373         decimals: uint256[8] = Registry(registry).get_decimals(_pool)
374 
375         balances: uint256[MAX_COINS] = empty(uint256[MAX_COINS])
376         # asymmetry = prod(x_i) / (sum(x_i) / N) ** N =
377         # = prod( (N * x_i) / sum(x_j) )
378         S: uint256 = 0
379         N: uint256 = 0
380         for i in range(MAX_COINS):
381             x: uint256 = underlying_balances[i]
382             if x == 0:
383                 N = i
384                 break
385             x *= 10 ** (18 - decimals[i])
386             balances[i] = x
387             S += x
388 
389         asymmetry: uint256 = N * 10 ** 18
390         for i in range(MAX_COINS):
391             x: uint256 = balances[i]
392             if x == 0:
393                 break
394             asymmetry = asymmetry * x / S
395 
396         assert asymmetry >= min_asymmetry, "Unsafe to apply"
397 
398     Curve(_pool).apply_new_parameters()  # dev: if implemented by the pool
399 
400 
401 @external
402 @nonreentrant('lock')
403 def revert_new_parameters(_pool: address):
404     """
405     @notice Revert comitted new parameters for `_pool` pool
406     @param _pool Pool address
407     """
408     assert msg.sender in [self.ownership_admin, self.parameter_admin, self.emergency_admin], "Access denied"
409     Curve(_pool).revert_new_parameters()  # dev: if implemented by the pool
410 
411 
412 @external
413 @nonreentrant('lock')
414 def commit_new_fee(_pool: address, new_fee: uint256, new_admin_fee: uint256):
415     """
416     @notice Commit new fees for `_pool` pool, fee: `new_fee` and admin fee: `new_admin_fee`
417     @param _pool Pool address
418     @param new_fee New fee
419     @param new_admin_fee New admin fee
420     """
421     assert msg.sender == self.parameter_admin, "Access denied"
422     Curve(_pool).commit_new_fee(new_fee, new_admin_fee)
423 
424 
425 @external
426 @nonreentrant('lock')
427 def apply_new_fee(_pool: address):
428     """
429     @notice Apply new fees for `_pool` pool
430     @param _pool Pool address
431     """
432     Curve(_pool).apply_new_fee()
433 
434 
435 @external
436 @nonreentrant('lock')
437 def ramp_A(_pool: address, _future_A: uint256, _future_time: uint256):
438     """
439     @notice Start gradually increasing A of `_pool` reaching `_future_A` at `_future_time` time
440     @param _pool Pool address
441     @param _future_A Future A
442     @param _future_time Future time
443     """
444     assert msg.sender == self.parameter_admin, "Access denied"
445     Curve(_pool).ramp_A(_future_A, _future_time)
446 
447 
448 @external
449 @nonreentrant('lock')
450 def stop_ramp_A(_pool: address):
451     """
452     @notice Stop gradually increasing A of `_pool`
453     @param _pool Pool address
454     """
455     assert msg.sender in [self.parameter_admin, self.emergency_admin], "Access denied"
456     Curve(_pool).stop_ramp_A()
457 
458 
459 @external
460 @nonreentrant('lock')
461 def set_aave_referral(_pool: address, referral_code: uint256):
462     """
463     @notice Set Aave referral for undelying tokens of `_pool` to `referral_code`
464     @param _pool Pool address
465     @param referral_code Aave referral code
466     """
467     assert msg.sender == self.ownership_admin, "Access denied"
468     Curve(_pool).set_aave_referral(referral_code)  # dev: if implemented by the pool
469 
470 
471 @external
472 def set_donate_approval(_pool: address, _caller: address, _is_approved: bool):
473     """
474     @notice Set approval of `_caller` to donate admin fees for `_pool`
475     @param _pool Pool address
476     @param _caller Adddress to set approval for
477     @param _is_approved Approval status
478     """
479     assert msg.sender == self.ownership_admin, "Access denied"
480 
481     self.donate_approval[_pool][_caller] = _is_approved
482 
483 
484 @external
485 @nonreentrant('lock')
486 def donate_admin_fees(_pool: address):
487     """
488     @notice Donate admin fees of `_pool` pool
489     @param _pool Pool address
490     """
491     if msg.sender != self.ownership_admin:
492         assert self.donate_approval[_pool][msg.sender], "Access denied"
493 
494     Curve(_pool).donate_admin_fees()  # dev: if implemented by the pool