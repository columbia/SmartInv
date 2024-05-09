1 # @version 0.3.7
2 # @license Apache-2.0
3 
4 #    ____        _ __    __   ____  _ ________                     __ 
5 #   / __ )__  __(_) /___/ /  / __ \(_) __/ __/__  ________  ____  / /_
6 #  / __  / / / / / / __  /  / / / / / /_/ /_/ _ \/ ___/ _ \/ __ \/ __/
7 # / /_/ / /_/ / / / /_/ /  / /_/ / / __/ __/  __/ /  /  __/ / / / /__ 
8 #/_____/\__,_/_/_/\__,_/  /_____/_/_/ /_/  \___/_/   \___/_/ /_/\__(_)
9 
10 #//////////////////////////////////////////////////////////////////////////
11 #                              Interfaces
12 #//////////////////////////////////////////////////////////////////////////
13 
14 interface IERC1155TL:
15     def externalMint(_tokenId: uint256, _addresses: DynArray[address, 100], _amounts: DynArray[uint256, 100]): nonpayable
16 
17 interface IOwnableAccessControl:
18     def owner() -> address: view
19     def hasRole(_role: bytes32, _operator: address) -> bool: view
20     
21 
22 #//////////////////////////////////////////////////////////////////////////
23 #                              Constants
24 #//////////////////////////////////////////////////////////////////////////
25 
26 ADMIN_ROLE: constant(bytes32) = keccak256("ADMIN_ROLE")
27 
28 #//////////////////////////////////////////////////////////////////////////
29 #                                Enums
30 #//////////////////////////////////////////////////////////////////////////
31 
32 enum DropPhase:
33     NOT_CONFIGURED
34     BEFORE_SALE
35     PRESALE
36     PUBLIC_SALE
37     ENDED
38 
39 enum DropParam:
40     MERKLE_ROOT
41     ALLOWANCE
42     COST
43     DURATION
44     PAYOUT_ADDRESS
45 
46 #//////////////////////////////////////////////////////////////////////////
47 #                                Struct
48 #//////////////////////////////////////////////////////////////////////////
49 
50 struct Drop:
51     supply: uint256
52     decay_rate: int256
53     allowance: uint256
54     payout_receiver: address
55     start_time: uint256
56     presale_duration: uint256
57     presale_cost: uint256
58     presale_merkle_root: bytes32
59     public_duration: uint256
60     public_cost: uint256
61 
62 #//////////////////////////////////////////////////////////////////////////
63 #                                Events
64 #//////////////////////////////////////////////////////////////////////////
65 
66 event OwnershipTransferred:
67     previousOwner: indexed(address)
68     newOwner: indexed(address)
69 
70 event DropConfigured:
71     configurer: indexed(address)
72     nft_contract: indexed(address)
73     token_id: uint256
74 
75 event Purchase:
76     buyer: indexed(address)
77     receiver: indexed(address)
78     nft_addr: indexed(address)
79     token_id: uint256
80     amount: uint256
81     price: uint256
82     is_presale: bool
83 
84 event DropClosed:
85     closer: indexed(address)
86     nft_contract: indexed(address)
87     token_id: uint256
88 
89 event DropUpdated:
90     phase_param: DropPhase
91     param_updated: DropParam
92     value: bytes32
93 
94 event Paused:
95     status: bool
96 
97 #//////////////////////////////////////////////////////////////////////////
98 #                                Contract Vars
99 #//////////////////////////////////////////////////////////////////////////
100 owner: public(address)
101 
102 # nft_caddr => token_id => Drop
103 drops: HashMap[address, HashMap[uint256, Drop]]
104 
105 # nft_caddr => token_id => round_id => user => num_minted
106 num_minted: HashMap[address, HashMap[uint256, HashMap[uint256, HashMap[address, uint256]]]]
107 
108 # nft_addr => token_id => round_num
109 drop_round: HashMap[address, HashMap[uint256, uint256]]
110 
111 # determine if the contract is paused or not
112 paused: bool
113 
114 #//////////////////////////////////////////////////////////////////////////
115 #                                Constructor
116 #//////////////////////////////////////////////////////////////////////////
117 
118 @external
119 def __init__(_owner: address):
120     self.owner = _owner
121     log OwnershipTransferred(empty(address), _owner)
122 
123 #//////////////////////////////////////////////////////////////////////////
124 #                         Owner Write Function
125 #//////////////////////////////////////////////////////////////////////////
126 
127 @external
128 def set_paused(_paused: bool):
129     if self.owner != msg.sender:
130         raise "not authorized"
131 
132     self.paused = _paused
133 
134     log Paused(_paused)
135 
136 #//////////////////////////////////////////////////////////////////////////
137 #                         Admin Write Function
138 #//////////////////////////////////////////////////////////////////////////
139 
140 @external 
141 def configure_drop(
142     _nft_addr: address,
143     _token_id: uint256,
144     _supply: uint256,
145     _decay_rate: int256,
146     _allowance: uint256,
147     _payout_receiver: address,
148     _start_time: uint256,
149     _presale_duration: uint256,
150     _presale_cost: uint256,
151     _presale_merkle_root: bytes32,
152     _public_duration: uint256,
153     _public_cost: uint256
154 ):
155     # Check if paused
156     if self.paused:
157         raise "contract is paused"
158 
159     if _start_time == 0:
160         raise "start time cannot be 0"
161 
162     # Make sure the sender is the owner or admin on the contract
163     if not self._is_drop_admin(_nft_addr, msg.sender):
164         raise "not authorized"
165 
166     drop: Drop = self.drops[_nft_addr][_token_id]
167 
168     # Check if theres an existing drop that needs to be closed
169     if self._get_drop_phase(_nft_addr, _token_id) != DropPhase.NOT_CONFIGURED:
170         raise "there is an existing drop"
171 
172     # Allowlist doesnt work with burn down/extending mints
173     if _decay_rate != 0 and _presale_duration != 0:
174         raise "cant have allowlist with burn/extending"
175 
176     # No supply for velocity mint
177     if _decay_rate < 0 and _supply != max_value(uint256):
178         raise "cant have burn down and a supply"
179 
180     drop = Drop({
181         supply: _supply,
182         decay_rate: _decay_rate,
183         allowance: _allowance,
184         payout_receiver: _payout_receiver,
185         start_time: _start_time,
186         presale_duration: _presale_duration,
187         presale_cost: _presale_cost,
188         presale_merkle_root: _presale_merkle_root,
189         public_duration: _public_duration,
190         public_cost: _public_cost
191     })
192 
193     self.drops[_nft_addr][_token_id] = drop
194 
195     log DropConfigured(msg.sender, _nft_addr, _token_id)
196 
197 @external
198 def close_drop(
199     _nft_addr: address,
200     _token_id: uint256
201 ):
202     if self.paused:
203         raise "contract is paused"
204         
205     if not self._is_drop_admin(_nft_addr, msg.sender):
206         raise "unauthorized"
207     
208     self.drops[_nft_addr][_token_id] = empty(Drop)
209     self.drop_round[_nft_addr][_token_id] += 1
210 
211     log DropClosed(msg.sender, _nft_addr, _token_id)
212 
213 @external
214 def update_drop_param(
215     _nft_addr: address, 
216     _token_id: uint256, 
217     _phase: DropPhase, 
218     _param: DropParam, 
219     _param_value: bytes32
220 ):
221     if not self._is_drop_admin(_nft_addr, msg.sender):
222         raise "unauthorized"
223 
224     if _phase == DropPhase.PRESALE:
225         if _param == DropParam.MERKLE_ROOT:
226             self.drops[_nft_addr][_token_id].presale_merkle_root = _param_value
227         elif _param == DropParam.COST:
228             self.drops[_nft_addr][_token_id].presale_cost = convert(_param_value, uint256)
229         elif _param == DropParam.DURATION:
230             self.drops[_nft_addr][_token_id].presale_duration = convert(_param_value, uint256)
231         else:
232             raise "unknown param update"
233     elif _phase == DropPhase.PUBLIC_SALE:
234         if _param == DropParam.ALLOWANCE:
235             self.drops[_nft_addr][_token_id].allowance = convert(_param_value, uint256)
236         elif _param == DropParam.COST:
237             self.drops[_nft_addr][_token_id].presale_cost = convert(_param_value, uint256)
238         elif _param == DropParam.DURATION:
239             self.drops[_nft_addr][_token_id].public_duration = convert(_param_value, uint256)
240         else:
241             raise "unknown param update"
242     elif _phase == DropPhase.NOT_CONFIGURED:
243         if _param == DropParam.PAYOUT_ADDRESS:
244             self.drops[_nft_addr][_token_id].payout_receiver = convert(_param_value, address)
245         else:
246             raise "unknown param update"
247     else:
248         raise "unknown param update"
249 
250     log DropUpdated(_phase, _param, _param_value)
251 
252 
253 #//////////////////////////////////////////////////////////////////////////
254 #                         External Write Function
255 #//////////////////////////////////////////////////////////////////////////
256 
257 @external
258 @payable
259 @nonreentrant("lock")
260 def mint(
261     _nft_addr: address,
262     _token_id: uint256,
263     _num_mint: uint256,
264     _receiver: address,
265     _proof: DynArray[bytes32, 100],
266     _allowlist_allocation: uint256
267 ):
268     if self.paused:
269         raise "contract is paused"
270 
271     drop: Drop = self.drops[_nft_addr][_token_id]
272 
273     if drop.supply == 0:
274         raise "no supply left"
275     
276     drop_phase: DropPhase = self._get_drop_phase(_nft_addr, _token_id)
277 
278     if drop_phase == DropPhase.PRESALE:
279         leaf: bytes32 = keccak256(
280             concat(
281                 convert(_receiver, bytes32), 
282                 convert(_allowlist_allocation, bytes32)
283             )
284         )
285         root: bytes32 = self.drops[_nft_addr][_token_id].presale_merkle_root
286         
287         # Check if user is part of allowlist
288         if not self._verify_proof(_proof, root, leaf):
289             raise "not part of allowlist"
290 
291         mint_num: uint256 = self._determine_mint_num(
292             _nft_addr, 
293             _token_id,
294             _receiver,
295             _num_mint,
296             _allowlist_allocation, 
297             drop.presale_cost
298         )
299 
300         self._settle_up(
301             _nft_addr,
302             _token_id,
303             _receiver,
304             drop.payout_receiver,
305             mint_num,
306             drop.presale_cost
307         )
308 
309         log Purchase(msg.sender, _receiver, _nft_addr, _token_id, mint_num, drop.presale_cost, True)
310 
311     elif drop_phase == DropPhase.PUBLIC_SALE:
312         if block.timestamp > drop.start_time + drop.presale_duration + drop.public_duration:
313             raise "public sale is no more"
314 
315         mint_num: uint256 = self._determine_mint_num(
316             _nft_addr, 
317             _token_id,
318             _receiver,
319             _num_mint,
320             drop.allowance,
321             drop.public_cost
322         )
323 
324         adjust: uint256 = mint_num * convert(abs(drop.decay_rate), uint256)
325         if drop.decay_rate < 0:
326             if adjust > drop.public_duration:
327                 self.drops[_nft_addr][_token_id].public_duration = 0
328             else:
329                 self.drops[_nft_addr][_token_id].public_duration -= adjust
330         elif drop.decay_rate > 0:
331             self.drops[_nft_addr][_token_id].public_duration += adjust
332 
333         self._settle_up(
334             _nft_addr,
335             _token_id,
336             _receiver,
337             drop.payout_receiver,
338             mint_num,
339             drop.public_cost
340         )
341 
342         log Purchase(msg.sender, _receiver, _nft_addr, _token_id, mint_num, drop.public_cost, False)
343 
344     else:
345         raise "you shall not mint"
346 
347 #//////////////////////////////////////////////////////////////////////////
348 #                         External Read Function
349 #//////////////////////////////////////////////////////////////////////////
350 
351 @view
352 @external
353 def get_drop(_nft_addr: address, _token_id: uint256) -> Drop:
354     return self.drops[_nft_addr][_token_id]
355 
356 @view
357 @external
358 def get_num_minted(_nft_addr: address, _token_id: uint256, _user: address) -> uint256:
359     round_id: uint256 = self.drop_round[_nft_addr][_token_id]
360     return self.num_minted[_nft_addr][_token_id][round_id][_user]
361 
362 @view
363 @external
364 def get_drop_phase(_nft_addr: address, _token_id: uint256) -> DropPhase:
365     return self._get_drop_phase(_nft_addr, _token_id)
366 
367 @view
368 @external
369 def is_paused() -> bool:
370     return self.paused
371 
372 #//////////////////////////////////////////////////////////////////////////
373 #                         Internal Read Function
374 #//////////////////////////////////////////////////////////////////////////
375 
376 @view
377 @internal
378 def _is_drop_admin(_nft_addr: address, _operator: address) -> bool:
379     return IOwnableAccessControl(_nft_addr).owner() == _operator \
380         or IOwnableAccessControl(_nft_addr).hasRole(ADMIN_ROLE, _operator)
381 
382 @view
383 @internal
384 def _get_drop_phase(_nft_addr: address, _token_id: uint256) -> DropPhase:
385     drop: Drop = self.drops[_nft_addr][_token_id]
386 
387     if drop.start_time == 0:
388         return DropPhase.NOT_CONFIGURED
389 
390     if drop.supply == 0:
391         return DropPhase.ENDED
392 
393     if block.timestamp < drop.start_time:
394         return DropPhase.BEFORE_SALE
395 
396     if drop.start_time <= block.timestamp and block.timestamp < drop.start_time + drop.presale_duration:
397         return DropPhase.PRESALE
398 
399     if drop.start_time + drop.presale_duration <= block.timestamp \
400         and block.timestamp < drop.start_time + drop.presale_duration + drop.public_duration:
401         return DropPhase.PUBLIC_SALE
402 
403     return DropPhase.ENDED
404 
405 @pure
406 @internal
407 def _verify_proof(_proof: DynArray[bytes32, 100], _root: bytes32, _leaf: bytes32) -> bool:
408     computed_hash: bytes32 = _leaf
409     for p in _proof:
410         if convert(computed_hash, uint256) < convert(p, uint256):
411             computed_hash = keccak256(concat(computed_hash, p))  
412         else: 
413             computed_hash = keccak256(concat(p, computed_hash))
414     return computed_hash == _root
415 
416 #//////////////////////////////////////////////////////////////////////////
417 #                         Internal Write Function
418 #//////////////////////////////////////////////////////////////////////////
419 
420 @internal
421 @payable
422 def _determine_mint_num(
423     _nft_addr: address,
424     _token_id: uint256,
425     _receiver: address,
426     _num_mint: uint256,
427     _allowance: uint256,
428     _cost: uint256
429 ) -> uint256:
430     drop: Drop = self.drops[_nft_addr][_token_id]
431 
432     drop_round: uint256 = self.drop_round[_nft_addr][_token_id]
433     curr_minted: uint256 = self.num_minted[_nft_addr][_token_id][drop_round][_receiver]
434 
435     mint_num: uint256 = _num_mint
436 
437     if curr_minted == _allowance:
438         raise "already hit mint allowance"
439 
440     if curr_minted + _num_mint > _allowance:
441         mint_num = _allowance - curr_minted
442 
443     if mint_num > drop.supply:
444         mint_num = drop.supply
445 
446     if msg.value < mint_num * _cost:
447         raise "not enough funds sent"
448 
449     self.drops[_nft_addr][_token_id].supply -= mint_num
450     self.num_minted[_nft_addr][_token_id][drop_round][_receiver] += mint_num
451 
452     return mint_num
453 
454 @internal
455 @payable
456 def _settle_up(
457     _nft_addr: address,
458     _token_id: uint256,
459     _receiver: address,
460     _payout_receiver: address,
461     _mint_num: uint256,
462     _cost: uint256
463 ):
464     if msg.value > _mint_num * _cost:
465         raw_call(
466             msg.sender,
467             b"",
468             max_outsize=0,
469             value=msg.value - (_mint_num * _cost),
470             revert_on_failure=True
471         )
472     
473     addrs: DynArray[address, 1] = [_receiver]
474     amts: DynArray[uint256, 1] = [_mint_num]
475 
476     IERC1155TL(_nft_addr).externalMint(_token_id, addrs, amts)
477 
478     raw_call(
479         _payout_receiver,
480         b"",
481         max_outsize=0,
482         value=_mint_num * _cost,
483         revert_on_failure=True
484     )