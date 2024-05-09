1 # @version 0.2.7
2 """
3 @title Curve Fee Distribution
4 @author Curve Finance
5 @license MIT
6 """
7 
8 from vyper.interfaces import ERC20
9 
10 
11 interface VotingEscrow:
12     def user_point_epoch(addr: address) -> uint256: view
13     def epoch() -> uint256: view
14     def user_point_history(addr: address, loc: uint256) -> Point: view
15     def point_history(loc: uint256) -> Point: view
16     def checkpoint(): nonpayable
17 
18 interface WETH:
19     def withdraw(wad: uint256): nonpayable
20 
21 event SetEmergencyReturn:
22     admin: address
23 
24 event CommitAdmin:
25     admin: address
26 
27 event ApplyAdmin:
28     admin: address
29 
30 event ToggleAllowCheckpointToken:
31     toggle_flag: bool
32 
33 event CheckpointToken:
34     time: uint256
35     tokens: uint256
36 
37 event Claimed:
38     recipient: indexed(address)
39     amount: uint256
40     claim_epoch: uint256
41     max_epoch: uint256
42 
43 
44 struct Point:
45     bias: int128
46     slope: int128  # - dweight / dt
47     ts: uint256
48     blk: uint256  # block
49 
50 
51 WEEK: constant(uint256) = 7 * 86400
52 TOKEN_CHECKPOINT_DEADLINE: constant(uint256) = 86400
53 
54 start_time: public(uint256)
55 time_cursor: public(uint256)
56 time_cursor_of: public(HashMap[address, uint256])
57 user_epoch_of: public(HashMap[address, uint256])
58 
59 last_token_time: public(uint256)
60 tokens_per_week: public(uint256[1000000000000000])
61 
62 voting_escrow: public(address)
63 token: public(address)
64 total_received: public(uint256)
65 token_last_balance: public(uint256)
66 
67 ve_supply: public(uint256[1000000000000000])  # VE total supply at week bounds
68 
69 admin: public(address)
70 future_admin: public(address)
71 can_checkpoint_token: public(bool)
72 emergency_return: public(address)
73 is_killed: public(bool)
74 
75 
76 @external
77 def __init__(
78     _voting_escrow: address,
79     _start_time: uint256,
80     _token: address,
81     _admin: address,
82     _emergency_return: address
83 ):
84     """
85     @notice Contract constructor
86     @param _voting_escrow VotingEscrow contract address
87     @param _start_time Epoch time for fee distribution to start
88     @param _token Fee token address (ETH)
89     @param _admin Admin address
90     @param _emergency_return Address to transfer `_token` balance to
91                              if this contract is killed
92     """
93     t: uint256 = _start_time / WEEK * WEEK
94     self.start_time = t
95     self.last_token_time = t
96     self.time_cursor = t
97     self.token = _token
98     self.voting_escrow = _voting_escrow
99     self.admin = _admin
100     self.emergency_return = _emergency_return
101     self.can_checkpoint_token = True
102 
103 @external
104 @payable
105 def __default__():
106   return
107 
108 @internal
109 def _checkpoint_token():
110     token_balance: uint256 = self.balance
111     to_distribute: uint256 = token_balance - self.token_last_balance
112     self.token_last_balance = token_balance
113 
114     t: uint256 = self.last_token_time
115     since_last: uint256 = block.timestamp - t
116     self.last_token_time = block.timestamp
117     this_week: uint256 = t / WEEK * WEEK
118     next_week: uint256 = 0
119 
120     for i in range(20):
121         next_week = this_week + WEEK
122         if block.timestamp < next_week:
123             if since_last == 0 and block.timestamp == t:
124                 self.tokens_per_week[this_week] += to_distribute
125             else:
126                 self.tokens_per_week[this_week] += to_distribute * (block.timestamp - t) / since_last
127             break
128         else:
129             if since_last == 0 and next_week == t:
130                 self.tokens_per_week[this_week] += to_distribute
131             else:
132                 self.tokens_per_week[this_week] += to_distribute * (next_week - t) / since_last
133         t = next_week
134         this_week = next_week
135 
136     log CheckpointToken(block.timestamp, to_distribute)
137 
138 
139 @external
140 def checkpoint_token():
141     """
142     @notice Update the token checkpoint
143     @dev Calculates the total number of tokens to be distributed in a given week.
144          During setup for the initial distribution this function is only callable
145          by the contract owner. Beyond initial distro, it can be enabled for anyone
146          to call.
147     """
148     assert (msg.sender == self.admin) or\
149            (self.can_checkpoint_token and (block.timestamp > self.last_token_time + TOKEN_CHECKPOINT_DEADLINE))
150     self._checkpoint_token()
151 
152 
153 @internal
154 def _find_timestamp_epoch(ve: address, _timestamp: uint256) -> uint256:
155     _min: uint256 = 0
156     _max: uint256 = VotingEscrow(ve).epoch()
157     for i in range(128):
158         if _min >= _max:
159             break
160         _mid: uint256 = (_min + _max + 2) / 2
161         pt: Point = VotingEscrow(ve).point_history(_mid)
162         if pt.ts <= _timestamp:
163             _min = _mid
164         else:
165             _max = _mid - 1
166     return _min
167 
168 
169 @view
170 @internal
171 def _find_timestamp_user_epoch(ve: address, user: address, _timestamp: uint256, max_user_epoch: uint256) -> uint256:
172     _min: uint256 = 0
173     _max: uint256 = max_user_epoch
174     for i in range(128):
175         if _min >= _max:
176             break
177         _mid: uint256 = (_min + _max + 2) / 2
178         pt: Point = VotingEscrow(ve).user_point_history(user, _mid)
179         if pt.ts <= _timestamp:
180             _min = _mid
181         else:
182             _max = _mid - 1
183     return _min
184 
185 
186 @view
187 @external
188 def ve_for_at(_user: address, _timestamp: uint256) -> uint256:
189     """
190     @notice Get the veCRV balance for `_user` at `_timestamp`
191     @param _user Address to query balance for
192     @param _timestamp Epoch time
193     @return uint256 veCRV balance
194     """
195     ve: address = self.voting_escrow
196     max_user_epoch: uint256 = VotingEscrow(ve).user_point_epoch(_user)
197     epoch: uint256 = self._find_timestamp_user_epoch(ve, _user, _timestamp, max_user_epoch)
198     pt: Point = VotingEscrow(ve).user_point_history(_user, epoch)
199     return convert(max(pt.bias - pt.slope * convert(_timestamp - pt.ts, int128), 0), uint256)
200 
201 @internal
202 def _checkpoint_total_supply():
203     ve: address = self.voting_escrow
204     t: uint256 = self.time_cursor
205     rounded_timestamp: uint256 = block.timestamp / WEEK * WEEK
206     VotingEscrow(ve).checkpoint()
207 
208     for i in range(20):
209         if t > rounded_timestamp:
210             break
211         else:
212             epoch: uint256 = self._find_timestamp_epoch(ve, t)
213             pt: Point = VotingEscrow(ve).point_history(epoch)
214             dt: int128 = 0
215             if t > pt.ts:
216                 # If the point is at 0 epoch, it can actually be earlier than the first deposit
217                 # Then make dt 0
218                 dt = convert(t - pt.ts, int128)
219             self.ve_supply[t] = convert(max(pt.bias - pt.slope * dt, 0), uint256)
220         t += WEEK
221 
222     self.time_cursor = t
223 
224 
225 @external
226 def checkpoint_total_supply():
227     """
228     @notice Update the veCRV total supply checkpoint
229     @dev The checkpoint is also updated by the first claimant each
230          new epoch week. This function may be called independently
231          of a claim, to reduce claiming gas costs.
232     """
233     self._checkpoint_total_supply()
234 
235 
236 @view
237 @internal
238 def _claim(addr: address, ve: address, _last_token_time: uint256) -> (uint256, uint256, uint256, uint256, bool):
239     # Minimal user_epoch is 0 (if user had no point)
240     user_epoch: uint256 = 0
241     to_distribute: uint256 = 0
242 
243     max_user_epoch: uint256 = VotingEscrow(ve).user_point_epoch(addr)
244     _start_time: uint256 = self.start_time
245 
246     if max_user_epoch == 0:
247         # No lock = no fees
248         return (0, 0, 0, 0, False)
249 
250     week_cursor: uint256 = self.time_cursor_of[addr]
251     if week_cursor == 0:
252         # Need to do the initial binary search
253         user_epoch = self._find_timestamp_user_epoch(ve, addr, _start_time, max_user_epoch)
254     else:
255         user_epoch = self.user_epoch_of[addr]
256 
257     if user_epoch == 0:
258         user_epoch = 1
259 
260     user_point: Point = VotingEscrow(ve).user_point_history(addr, user_epoch)
261 
262     if week_cursor == 0:
263         week_cursor = (user_point.ts + WEEK - 1) / WEEK * WEEK
264 
265     if week_cursor >= _last_token_time:
266         return (0, 0, 0, 0, False)
267 
268     if week_cursor < _start_time:
269         week_cursor = _start_time
270     old_user_point: Point = empty(Point)
271 
272     # Iterate over weeks
273     for i in range(50):
274         if week_cursor >= _last_token_time:
275             break
276 
277         if week_cursor >= user_point.ts and user_epoch <= max_user_epoch:
278             user_epoch += 1
279             old_user_point = user_point
280             if user_epoch > max_user_epoch:
281                 user_point = empty(Point)
282             else:
283                 user_point = VotingEscrow(ve).user_point_history(addr, user_epoch)
284 
285         else:
286             # Calc
287             # + i * 2 is for rounding errors
288             dt: int128 = convert(week_cursor - old_user_point.ts, int128)
289             balance_of: uint256 = convert(max(old_user_point.bias - dt * old_user_point.slope, 0), uint256)
290             if balance_of == 0 and user_epoch > max_user_epoch:
291                 break
292             if balance_of > 0:
293                 to_distribute += balance_of * self.tokens_per_week[week_cursor] / self.ve_supply[week_cursor]
294 
295             week_cursor += WEEK
296 
297     user_epoch = min(max_user_epoch, user_epoch - 1)
298 
299     return (to_distribute, user_epoch, week_cursor, max_user_epoch, True)
300 
301 @external
302 @nonreentrant('lock')
303 def claim(_addr: address = msg.sender) -> uint256:
304     """
305     @notice Claim fees for `_addr`
306     @dev Each call to claim look at a maximum of 50 user veCRV points.
307          For accounts with many veCRV related actions, this function
308          may need to be called more than once to claim all available
309          fees. In the `Claimed` event that fires, if `claim_epoch` is
310          less than `max_epoch`, the account may claim again.
311     @param _addr Address to claim fees for
312     @return uint256 Amount of fees claimed in the call
313     """
314     assert not self.is_killed
315 
316     if block.timestamp >= self.time_cursor:
317         self._checkpoint_total_supply()
318 
319     last_token_time: uint256 = self.last_token_time
320 
321     if self.can_checkpoint_token and (block.timestamp > last_token_time + TOKEN_CHECKPOINT_DEADLINE):
322         self._checkpoint_token()
323         last_token_time = block.timestamp
324 
325     last_token_time = last_token_time / WEEK * WEEK
326 
327     amount: uint256 = 0
328     user_epoch: uint256 = 0
329     week_cursor: uint256 = 0
330     max_user_epoch: uint256 = 0
331     is_update: bool = True
332     amount, user_epoch, week_cursor, max_user_epoch, is_update = self._claim(_addr, self.voting_escrow, last_token_time)
333 
334     if is_update:
335       self.user_epoch_of[_addr] = user_epoch
336       self.time_cursor_of[_addr] = week_cursor
337       log Claimed(_addr, amount, user_epoch, max_user_epoch)
338 
339     if amount != 0:
340         self.token_last_balance -= amount
341         send(_addr, amount)
342 
343     return amount
344 
345 
346 @external
347 @nonreentrant('lock')
348 def claim_many(_receivers: address[20]) -> bool:
349     """
350     @notice Make multiple fee claims in a single call
351     @dev Used to claim for many accounts at once, or to make
352          multiple claims for the same address when that address
353          has significant veCRV history
354     @param _receivers List of addresses to claim for. Claiming
355                       terminates at the first `ZERO_ADDRESS`.
356     @return bool success
357     """
358     assert not self.is_killed
359 
360     if block.timestamp >= self.time_cursor:
361         self._checkpoint_total_supply()
362 
363     last_token_time: uint256 = self.last_token_time
364 
365     if self.can_checkpoint_token and (block.timestamp > last_token_time + TOKEN_CHECKPOINT_DEADLINE):
366         self._checkpoint_token()
367         last_token_time = block.timestamp
368 
369     last_token_time = last_token_time / WEEK * WEEK
370     voting_escrow: address = self.voting_escrow
371     token: address = self.token
372     total: uint256 = 0
373 
374     amount: uint256 = 0
375     user_epoch: uint256 = 0
376     week_cursor: uint256 = 0
377     max_user_epoch: uint256 = 0
378     is_update: bool = True
379 
380     for addr in _receivers:
381         if addr == ZERO_ADDRESS:
382             break
383 
384         amount, user_epoch, week_cursor, max_user_epoch, is_update = self._claim(addr, voting_escrow, last_token_time)
385 
386         if is_update:
387           self.user_epoch_of[addr] = user_epoch
388           self.time_cursor_of[addr] = week_cursor
389           log Claimed(addr, amount, user_epoch, max_user_epoch)
390 
391         if amount != 0:
392             total += amount
393             send(addr, amount)
394 
395     if total != 0:
396         self.token_last_balance -= total
397 
398     return True
399 
400 
401 @external
402 @payable
403 def burn(_coin: address, _amount: uint256) -> bool:
404     """
405     @notice Receive WETH into the contract and trigger a token checkpoint
406     @param _coin Address of the coin being received (must be WETH)
407     @param _amount Amount to transfer
408     @return bool success
409     """
410     assert _coin == self.token
411     assert _amount != 0
412     assert not self.is_killed
413 
414     ERC20(_coin).transferFrom(msg.sender, self, _amount)
415     WETH(_coin).withdraw(_amount)
416 
417     if self.can_checkpoint_token and (block.timestamp > self.last_token_time + TOKEN_CHECKPOINT_DEADLINE):
418         self._checkpoint_token()
419 
420     return True
421 
422 @external
423 def set_emergency_return(_addr: address):
424     """
425     @notice Set new emergency return address
426     @param _addr New emergency return address
427     """
428     assert msg.sender == self.admin  # dev: access denied
429     self.emergency_return = _addr
430     log SetEmergencyReturn(_addr)
431 
432 @external
433 def commit_admin(_addr: address):
434     """
435     @notice Commit transfer of ownership
436     @param _addr New admin address
437     """
438     assert msg.sender == self.admin  # dev: access denied
439     self.future_admin = _addr
440     log CommitAdmin(_addr)
441 
442 
443 @external
444 def apply_admin():
445     """
446     @notice Apply transfer of ownership
447     """
448     assert msg.sender == self.admin
449     assert self.future_admin != ZERO_ADDRESS
450     future_admin: address = self.future_admin
451     self.admin = future_admin
452     log ApplyAdmin(future_admin)
453 
454 
455 @external
456 def toggle_allow_checkpoint_token():
457     """
458     @notice Toggle permission for checkpointing by any account
459     """
460     assert msg.sender == self.admin
461     flag: bool = not self.can_checkpoint_token
462     self.can_checkpoint_token = flag
463     log ToggleAllowCheckpointToken(flag)
464 
465 
466 @external
467 def kill_me():
468     """
469     @notice Kill the contract
470     @dev Killing transfers the entire ETH balance to the emergency return address
471          and blocks the ability to claim or burn. The contract cannot be unkilled.
472     """
473     assert msg.sender == self.admin
474 
475     self.is_killed = True
476 
477     send(self.emergency_return, self.balance)
478 
479 @external
480 def recover_balance(_coin: address) -> bool:
481     """
482     @notice Recover ERC20 tokens from this contract
483     @dev Tokens are sent to the emergency return address.
484     @param _coin Token address
485     @return bool success
486     """
487     assert msg.sender == self.admin
488     assert _coin != self.token
489 
490     amount: uint256 = ERC20(_coin).balanceOf(self)
491     response: Bytes[32] = raw_call(
492         _coin,
493         concat(
494             method_id("transfer(address,uint256)"),
495             convert(self.emergency_return, bytes32),
496             convert(amount, bytes32),
497         ),
498         max_outsize=32,
499     )
500     if len(response) != 0:
501         assert convert(response, bool)
502 
503     return True
504 
505 @external
506 @payable
507 def recover_eth_balance() -> bool:
508     """
509     @notice Recover ETH from this contract
510     @dev ETH sent to the emergency return address.
511     @return bool success
512     """
513     assert msg.sender == self.admin
514 
515     send(self.emergency_return, self.balance)
516 
517     return True