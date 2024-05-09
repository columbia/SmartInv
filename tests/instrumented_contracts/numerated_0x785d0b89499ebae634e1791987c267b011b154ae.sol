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
14 interface IERC721TL:
15     def externalMint(_recipient: address, _uri: String[1337]): nonpayable
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
51     base_uri: String[100]
52     initial_supply: uint256
53     supply: uint256
54     decay_rate: int256
55     allowance: uint256
56     payout_receiver: address
57     start_time: uint256
58     presale_duration: uint256
59     presale_cost: uint256
60     presale_merkle_root: bytes32
61     public_duration: uint256
62     public_cost: uint256
63 
64 #//////////////////////////////////////////////////////////////////////////
65 #                                Events
66 #//////////////////////////////////////////////////////////////////////////
67 
68 event OwnershipTransferred:
69     previousOwner: indexed(address)
70     newOwner: indexed(address)
71 
72 event DropConfigured:
73     configurer: indexed(address)
74     nft_contract: indexed(address)
75 
76 event Purchase:
77     buyer: indexed(address)
78     receiver: indexed(address)
79     nft_addr: indexed(address)
80     amount: uint256
81     price: uint256
82     is_presale: bool
83 
84 event DropClosed:
85     closer: indexed(address)
86     nft_contract: indexed(address)
87 
88 event DropUpdated:
89     phase_param: DropPhase
90     param_updated: DropParam
91     value: bytes32
92 
93 event Paused:
94     status: bool
95 
96 #//////////////////////////////////////////////////////////////////////////
97 #                                Contract Vars
98 #//////////////////////////////////////////////////////////////////////////
99 owner: public(address)
100 
101 # nft_caddr => Drop
102 drops: HashMap[address, Drop]
103 
104 # nft_caddr => round_id => user => num_minted
105 num_minted: HashMap[address, HashMap[uint256, HashMap[address, uint256]]]
106 
107 # nft_addr => round_num
108 drop_round: HashMap[address, uint256]
109 
110 # determine if the contract is paused or not
111 paused: bool
112 
113 #//////////////////////////////////////////////////////////////////////////
114 #                                Constructor
115 #//////////////////////////////////////////////////////////////////////////
116 
117 @external
118 def __init__(_owner: address):
119     self.owner = _owner
120     log OwnershipTransferred(empty(address), _owner)
121 
122 #//////////////////////////////////////////////////////////////////////////
123 #                         Owner Write Function
124 #//////////////////////////////////////////////////////////////////////////
125 
126 @external
127 def set_paused(_paused: bool):
128     if self.owner != msg.sender:
129         raise "not authorized"
130 
131     self.paused = _paused
132 
133     log Paused(_paused)
134 
135 #//////////////////////////////////////////////////////////////////////////
136 #                         Admin Write Function
137 #//////////////////////////////////////////////////////////////////////////
138 
139 @external 
140 def configure_drop(
141     _nft_addr: address,
142     _base_uri: String[100],
143     _supply: uint256,
144     _decay_rate: int256,
145     _allowance: uint256,
146     _payout_receiver: address,
147     _start_time: uint256,
148     _presale_duration: uint256,
149     _presale_cost: uint256,
150     _presale_merkle_root: bytes32,
151     _public_duration: uint256,
152     _public_cost: uint256
153 ):
154     # Check if paused
155     if self.paused:
156         raise "contract is paused"
157 
158     if _start_time == 0:
159         raise "start time cannot be 0"
160 
161     # Make sure the sender is the owner or admin on the contract
162     if not self._is_drop_admin(_nft_addr, msg.sender):
163         raise "not authorized"
164 
165     drop: Drop = self.drops[_nft_addr]
166 
167     # Check if theres an existing drop that needs to be closed
168     if self._get_drop_phase(_nft_addr) != DropPhase.NOT_CONFIGURED:
169         raise "there is an existing drop"
170 
171     # Allowlist doesnt work with burn down/extending mints
172     if _decay_rate != 0 and _presale_duration != 0:
173         raise "cant have allowlist with burn/extending"
174 
175     # No supply for velocity mint
176     if _decay_rate < 0 and _supply != max_value(uint256):
177         raise "cant have burn down and a supply"
178 
179     drop = Drop({
180         base_uri: _base_uri,
181         initial_supply: _supply,
182         supply: _supply,
183         decay_rate: _decay_rate,
184         allowance: _allowance,
185         payout_receiver: _payout_receiver,
186         start_time: _start_time,
187         presale_duration: _presale_duration,
188         presale_cost: _presale_cost,
189         presale_merkle_root: _presale_merkle_root,
190         public_duration: _public_duration,
191         public_cost: _public_cost
192     })
193 
194     self.drops[_nft_addr] = drop
195 
196     log DropConfigured(msg.sender, _nft_addr)
197 
198 @external
199 def close_drop(
200     _nft_addr: address
201 ):
202     if self.paused:
203         raise "contract is paused"
204         
205     if not self._is_drop_admin(_nft_addr, msg.sender):
206         raise "unauthorized"
207     
208     self.drops[_nft_addr] = empty(Drop)
209     self.drop_round[_nft_addr] += 1
210 
211     log DropClosed(msg.sender, _nft_addr)
212 
213 @external
214 def update_drop_param(
215     _nft_addr: address, 
216     _phase: DropPhase, 
217     _param: DropParam, 
218     _param_value: bytes32
219 ):
220     if not self._is_drop_admin(_nft_addr, msg.sender):
221         raise "unauthorized"
222 
223     if _phase == DropPhase.PRESALE:
224         if _param == DropParam.MERKLE_ROOT:
225             self.drops[_nft_addr].presale_merkle_root = _param_value
226         elif _param == DropParam.COST:
227             self.drops[_nft_addr].presale_cost = convert(_param_value, uint256)
228         elif _param == DropParam.DURATION:
229             self.drops[_nft_addr].presale_duration = convert(_param_value, uint256)
230         else:
231             raise "unknown param update"
232     elif _phase == DropPhase.PUBLIC_SALE:
233         if _param == DropParam.ALLOWANCE:
234             self.drops[_nft_addr].allowance = convert(_param_value, uint256)
235         elif _param == DropParam.COST:
236             self.drops[_nft_addr].presale_cost = convert(_param_value, uint256)
237         elif _param == DropParam.DURATION:
238             self.drops[_nft_addr].public_duration = convert(_param_value, uint256)
239         else:
240             raise "unknown param update"
241     elif _phase == DropPhase.NOT_CONFIGURED:
242         if _param == DropParam.PAYOUT_ADDRESS:
243             self.drops[_nft_addr].payout_receiver = convert(_param_value, address)
244         else:
245             raise "unknown param update"
246     else:
247         raise "unknown param update"
248 
249     log DropUpdated(_phase, _param, _param_value)
250 
251 
252 #//////////////////////////////////////////////////////////////////////////
253 #                         External Write Function
254 #//////////////////////////////////////////////////////////////////////////
255 
256 @external
257 @payable
258 @nonreentrant("lock")
259 def mint(
260     _nft_addr: address,
261     _num_mint: uint256,
262     _receiver: address,
263     _proof: DynArray[bytes32, 100],
264     _allowlist_allocation: uint256
265 ):
266     if self.paused:
267         raise "contract is paused"
268 
269     drop: Drop = self.drops[_nft_addr]
270 
271     if drop.supply == 0:
272         raise "no supply left"
273     
274     drop_phase: DropPhase = self._get_drop_phase(_nft_addr)
275 
276     if drop_phase == DropPhase.PRESALE:
277         leaf: bytes32 = keccak256(
278             concat(
279                 convert(_receiver, bytes32), 
280                 convert(_allowlist_allocation, bytes32)
281             )
282         )
283         root: bytes32 = self.drops[_nft_addr].presale_merkle_root
284         
285         # Check if user is part of allowlist
286         if not self._verify_proof(_proof, root, leaf):
287             raise "not part of allowlist"
288 
289         mint_num: uint256 = self._determine_mint_num(
290             _nft_addr,
291             _receiver,
292             _num_mint,
293             _allowlist_allocation,
294             drop.presale_cost
295         )
296 
297         self._settle_up(
298             _nft_addr,
299             _receiver,
300             mint_num,
301             drop.presale_cost
302         )
303 
304         log Purchase(msg.sender, _receiver, _nft_addr, mint_num, drop.presale_cost, True)
305 
306     elif drop_phase == DropPhase.PUBLIC_SALE:
307         if block.timestamp > drop.start_time + drop.presale_duration + drop.public_duration:
308             raise "public sale is no more"
309 
310         mint_num: uint256 = self._determine_mint_num(
311             _nft_addr,
312             _receiver,
313             _num_mint,
314             drop.allowance,
315             drop.public_cost
316         )
317 
318         adjust: uint256 = mint_num * convert(abs(drop.decay_rate), uint256)
319         if drop.decay_rate < 0:
320             if adjust > drop.public_duration:
321                 self.drops[_nft_addr].public_duration = 0
322             else:
323                 self.drops[_nft_addr].public_duration -= adjust
324         elif drop.decay_rate > 0:
325             self.drops[_nft_addr].public_duration += adjust
326 
327         self._settle_up(
328             _nft_addr,
329             _receiver,
330             mint_num,
331             drop.public_cost
332         )
333 
334         log Purchase(msg.sender, _receiver, _nft_addr, mint_num, drop.public_cost, False)
335 
336     else:
337         raise "you shall not mint"
338 
339 #//////////////////////////////////////////////////////////////////////////
340 #                         External Read Function
341 #//////////////////////////////////////////////////////////////////////////
342 
343 @view
344 @external
345 def get_drop(_nft_addr: address) -> Drop:
346     return self.drops[_nft_addr]
347 
348 @view
349 @external
350 def get_num_minted(_nft_addr: address, _user: address) -> uint256:
351     round_id: uint256 = self.drop_round[_nft_addr]
352     return self.num_minted[_nft_addr][round_id][_user]
353 
354 @view
355 @external
356 def get_drop_phase(_nft_addr: address) -> DropPhase:
357     return self._get_drop_phase(_nft_addr)
358 
359 @view
360 @external
361 def is_paused() -> bool:
362     return self.paused
363 
364 #//////////////////////////////////////////////////////////////////////////
365 #                         Internal Read Function
366 #//////////////////////////////////////////////////////////////////////////
367 
368 @view
369 @internal
370 def _is_drop_admin(_nft_addr: address, _operator: address) -> bool:
371     return IOwnableAccessControl(_nft_addr).owner() == _operator \
372         or IOwnableAccessControl(_nft_addr).hasRole(ADMIN_ROLE, _operator)
373 
374 @view
375 @internal
376 def _get_drop_phase(_nft_addr: address) -> DropPhase:
377     drop: Drop = self.drops[_nft_addr]
378 
379     if drop.start_time == 0:
380         return DropPhase.NOT_CONFIGURED
381 
382     if drop.supply == 0:
383         return DropPhase.ENDED
384 
385     if block.timestamp < drop.start_time:
386         return DropPhase.BEFORE_SALE
387 
388     if drop.start_time <= block.timestamp and block.timestamp < drop.start_time + drop.presale_duration:
389         return DropPhase.PRESALE
390 
391     if drop.start_time + drop.presale_duration <= block.timestamp \
392         and block.timestamp < drop.start_time + drop.presale_duration + drop.public_duration:
393         return DropPhase.PUBLIC_SALE
394 
395     return DropPhase.ENDED
396 
397 @pure
398 @internal
399 def _verify_proof(_proof: DynArray[bytes32, 100], _root: bytes32, _leaf: bytes32) -> bool:
400     computed_hash: bytes32 = _leaf
401     for p in _proof:
402         if convert(computed_hash, uint256) < convert(p, uint256):
403             computed_hash = keccak256(concat(computed_hash, p))  
404         else: 
405             computed_hash = keccak256(concat(p, computed_hash))
406     return computed_hash == _root
407 
408 @internal
409 @payable
410 def _determine_mint_num(
411     _nft_addr: address,
412     _receiver: address,
413     _num_mint: uint256,
414     _allowance: uint256,
415     _cost: uint256
416 ) -> uint256:
417     drop: Drop = self.drops[_nft_addr]
418 
419     drop_round: uint256 = self.drop_round[_nft_addr]
420     curr_minted: uint256 = self.num_minted[_nft_addr][drop_round][_receiver]
421 
422     mint_num: uint256 = _num_mint
423 
424     if curr_minted == _allowance:
425         raise "already hit mint allowance"
426 
427     if curr_minted + _num_mint > _allowance:
428         mint_num = _allowance - curr_minted
429 
430     if mint_num > drop.supply:
431         mint_num = drop.supply
432 
433     if msg.value < mint_num * _cost:
434         raise "not enough funds sent"
435 
436     self.drops[_nft_addr].supply -= mint_num
437     self.num_minted[_nft_addr][drop_round][_receiver] += mint_num
438 
439     return mint_num
440 
441 @internal
442 @payable
443 def _settle_up(
444     _nft_addr: address,
445     _receiver: address,
446     _mint_num: uint256,
447     _cost: uint256
448 ):
449     drop: Drop = self.drops[_nft_addr]
450 
451     if msg.value > _mint_num * _cost:
452         raw_call(
453             msg.sender,
454             b"",
455             max_outsize=0,
456             value=msg.value - (_mint_num * _cost),
457             revert_on_failure=True
458         )
459     
460     token_id_counter: uint256 = drop.initial_supply - self.drops[_nft_addr].supply - _mint_num
461 
462     for i in range(0, max_value(uint8)):
463         if i == _mint_num:
464             break
465         IERC721TL(_nft_addr).externalMint(
466             _receiver,
467             concat(drop.base_uri, uint2str(token_id_counter))
468         )
469         token_id_counter += 1
470 
471     raw_call(
472         drop.payout_receiver,
473         b"",
474         max_outsize=0,
475         value=_mint_num * _cost,
476         revert_on_failure=True
477     )