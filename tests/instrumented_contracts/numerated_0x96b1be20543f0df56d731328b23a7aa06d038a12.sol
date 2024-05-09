1 # @version 0.2.16
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
18 
19 event CommitAdmin:
20     admin: address
21 
22 event ApplyAdmin:
23     admin: address
24 
25 event ToggleAllowCheckpointToken:
26     toggle_flag: bool
27 
28 event CheckpointToken:
29     time: uint256
30     tokens: uint256
31 
32 event Claimed:
33     recipient: indexed(address)
34     amount: uint256
35     claim_epoch: uint256
36     max_epoch: uint256
37 
38 
39 struct Point:
40     bias: int128
41     slope: int128  # - dweight / dt
42     ts: uint256
43     blk: uint256  # block
44 
45 
46 WEEK: constant(uint256) = 7 * 86400
47 TOKEN_CHECKPOINT_DEADLINE: constant(uint256) = 86400
48 
49 start_time: public(uint256)
50 time_cursor: public(uint256)
51 time_cursor_of: public(HashMap[address, uint256])
52 user_epoch_of: public(HashMap[address, uint256])
53 
54 last_token_time: public(uint256)
55 tokens_per_week: public(uint256[1000000000000000])
56 
57 voting_escrow: public(address)
58 token: public(address)
59 total_received: public(uint256)
60 token_last_balance: public(uint256)
61 
62 ve_supply: public(uint256[1000000000000000])  # VE total supply at week bounds
63 
64 admin: public(address)
65 future_admin: public(address)
66 can_checkpoint_token: public(bool)
67 emergency_return: public(address)
68 is_killed: public(bool)
69 
70 
71 @external
72 def __init__(
73     _voting_escrow: address,
74     _start_time: uint256,
75     _token: address,
76     _admin: address,
77     _emergency_return: address
78 ):
79     """
80     @notice Contract constructor
81     @param _voting_escrow VotingEscrow contract address
82     @param _start_time Epoch time for fee distribution to start
83     @param _token Fee token address (3CRV)
84     @param _admin Admin address
85     @param _emergency_return Address to transfer `_token` balance to
86                              if this contract is killed
87     """
88     t: uint256 = _start_time / WEEK * WEEK
89     self.start_time = t
90     self.last_token_time = t
91     self.time_cursor = t
92     self.token = _token
93     self.voting_escrow = _voting_escrow
94     self.admin = _admin
95     self.emergency_return = _emergency_return
96 
97 
98 @internal
99 def _checkpoint_token():
100     token_balance: uint256 = ERC20(self.token).balanceOf(self)
101     to_distribute: uint256 = token_balance - self.token_last_balance
102     self.token_last_balance = token_balance
103 
104     t: uint256 = self.last_token_time
105     since_last: uint256 = block.timestamp - t
106     self.last_token_time = block.timestamp
107     this_week: uint256 = t / WEEK * WEEK
108     next_week: uint256 = 0
109 
110     for i in range(20):
111         next_week = this_week + WEEK
112         if block.timestamp < next_week:
113             if since_last == 0 and block.timestamp == t:
114                 self.tokens_per_week[this_week] += to_distribute
115             else:
116                 self.tokens_per_week[this_week] += to_distribute * (block.timestamp - t) / since_last
117             break
118         else:
119             if since_last == 0 and next_week == t:
120                 self.tokens_per_week[this_week] += to_distribute
121             else:
122                 self.tokens_per_week[this_week] += to_distribute * (next_week - t) / since_last
123         t = next_week
124         this_week = next_week
125 
126     log CheckpointToken(block.timestamp, to_distribute)
127 
128 
129 @external
130 def checkpoint_token():
131     """
132     @notice Update the token checkpoint
133     @dev Calculates the total number of tokens to be distributed in a given week.
134          During setup for the initial distribution this function is only callable
135          by the contract owner. Beyond initial distro, it can be enabled for anyone
136          to call.
137     """
138     assert (msg.sender == self.admin) or\
139            (self.can_checkpoint_token and (block.timestamp > self.last_token_time + TOKEN_CHECKPOINT_DEADLINE))
140     self._checkpoint_token()
141 
142 
143 @internal
144 def _find_timestamp_epoch(ve: address, _timestamp: uint256) -> uint256:
145     _min: uint256 = 0
146     _max: uint256 = VotingEscrow(ve).epoch()
147     for i in range(128):
148         if _min >= _max:
149             break
150         _mid: uint256 = (_min + _max + 2) / 2
151         pt: Point = VotingEscrow(ve).point_history(_mid)
152         if pt.ts <= _timestamp:
153             _min = _mid
154         else:
155             _max = _mid - 1
156     return _min
157 
158 
159 @view
160 @internal
161 def _find_timestamp_user_epoch(ve: address, user: address, _timestamp: uint256, max_user_epoch: uint256) -> uint256:
162     _min: uint256 = 0
163     _max: uint256 = max_user_epoch
164     for i in range(128):
165         if _min >= _max:
166             break
167         _mid: uint256 = (_min + _max + 2) / 2
168         pt: Point = VotingEscrow(ve).user_point_history(user, _mid)
169         if pt.ts <= _timestamp:
170             _min = _mid
171         else:
172             _max = _mid - 1
173     return _min
174 
175 
176 @view
177 @external
178 def ve_for_at(_user: address, _timestamp: uint256) -> uint256:
179     """
180     @notice Get the veCRV balance for `_user` at `_timestamp`
181     @param _user Address to query balance for
182     @param _timestamp Epoch time
183     @return uint256 veCRV balance
184     """
185     zero: int128 = 0
186     ve: address = self.voting_escrow
187     max_user_epoch: uint256 = VotingEscrow(ve).user_point_epoch(_user)
188     epoch: uint256 = self._find_timestamp_user_epoch(ve, _user, _timestamp, max_user_epoch)
189     pt: Point = VotingEscrow(ve).user_point_history(_user, epoch)
190     return convert(max(pt.bias - pt.slope * convert(_timestamp - pt.ts, int128), zero), uint256)
191 
192 
193 @internal
194 def _checkpoint_total_supply():
195     zero: int128 = 0
196     ve: address = self.voting_escrow
197     t: uint256 = self.time_cursor
198     rounded_timestamp: uint256 = block.timestamp / WEEK * WEEK
199     VotingEscrow(ve).checkpoint()
200 
201     for i in range(20):
202         if t > rounded_timestamp:
203             break
204         else:
205             epoch: uint256 = self._find_timestamp_epoch(ve, t)
206             pt: Point = VotingEscrow(ve).point_history(epoch)
207             dt: int128 = 0
208             if t > pt.ts:
209                 # If the point is at 0 epoch, it can actually be earlier than the first deposit
210                 # Then make dt 0
211                 dt = convert(t - pt.ts, int128)
212             self.ve_supply[t] = convert(max(pt.bias - pt.slope * dt, zero), uint256)
213         t += WEEK
214 
215     self.time_cursor = t
216 
217 
218 @external
219 def checkpoint_total_supply():
220     """
221     @notice Update the veCRV total supply checkpoint
222     @dev The checkpoint is also updated by the first claimant each
223          new epoch week. This function may be called independently
224          of a claim, to reduce claiming gas costs.
225     """
226     self._checkpoint_total_supply()
227 
228 
229 @internal
230 def _claim(addr: address, ve: address, _last_token_time: uint256) -> uint256:
231     # Minimal user_epoch is 0 (if user had no point)
232     zero: int128 = 0
233     user_epoch: uint256 = 0
234     to_distribute: uint256 = 0
235 
236     max_user_epoch: uint256 = VotingEscrow(ve).user_point_epoch(addr)
237     _start_time: uint256 = self.start_time
238 
239     if max_user_epoch == 0:
240         # No lock = no fees
241         return 0
242 
243     week_cursor: uint256 = self.time_cursor_of[addr]
244     if week_cursor == 0:
245         # Need to do the initial binary search
246         user_epoch = self._find_timestamp_user_epoch(ve, addr, _start_time, max_user_epoch)
247     else:
248         user_epoch = self.user_epoch_of[addr]
249 
250     if user_epoch == 0:
251         user_epoch = 1
252 
253     user_point: Point = VotingEscrow(ve).user_point_history(addr, user_epoch)
254 
255     if week_cursor == 0:
256         week_cursor = (user_point.ts + WEEK - 1) / WEEK * WEEK
257 
258     if week_cursor >= _last_token_time:
259         return 0
260 
261     if week_cursor < _start_time:
262         week_cursor = _start_time
263     old_user_point: Point = empty(Point)
264 
265     # Iterate over weeks
266     for i in range(50):
267         if week_cursor >= _last_token_time:
268             break
269 
270         if week_cursor >= user_point.ts and user_epoch <= max_user_epoch:
271             user_epoch += 1
272             old_user_point = user_point
273             if user_epoch > max_user_epoch:
274                 user_point = empty(Point)
275             else:
276                 user_point = VotingEscrow(ve).user_point_history(addr, user_epoch)
277 
278         else:
279             # Calc
280             # + i * 2 is for rounding errors
281             dt: int128 = convert(week_cursor - old_user_point.ts, int128)
282             balance_of: uint256 = convert(max(old_user_point.bias - dt * old_user_point.slope, zero), uint256)
283             if balance_of == 0 and user_epoch > max_user_epoch:
284                 break
285             if balance_of > 0:
286                 to_distribute += balance_of * self.tokens_per_week[week_cursor] / self.ve_supply[week_cursor]
287 
288             week_cursor += WEEK
289 
290     user_epoch = min(max_user_epoch, user_epoch - 1)
291     self.user_epoch_of[addr] = user_epoch
292     self.time_cursor_of[addr] = week_cursor
293 
294     log Claimed(addr, to_distribute, user_epoch, max_user_epoch)
295 
296     return to_distribute
297 
298 @view
299 @internal
300 def _claimable(addr: address, ve: address, _last_token_time: uint256) -> uint256:
301     # Minimal user_epoch is 0 (if user had no point)
302     zero: int128 = 0
303     user_epoch: uint256 = 0
304     to_distribute: uint256 = 0
305 
306     max_user_epoch: uint256 = VotingEscrow(ve).user_point_epoch(addr)
307     _start_time: uint256 = self.start_time
308 
309     if max_user_epoch == 0:
310         # No lock = no fees
311         return 0
312 
313     week_cursor: uint256 = self.time_cursor_of[addr]
314     if week_cursor == 0:
315         # Need to do the initial binary search
316         user_epoch = self._find_timestamp_user_epoch(ve, addr, _start_time, max_user_epoch)
317     else:
318         user_epoch = self.user_epoch_of[addr]
319 
320     if user_epoch == 0:
321         user_epoch = 1
322 
323     user_point: Point = VotingEscrow(ve).user_point_history(addr, user_epoch)
324 
325     if week_cursor == 0:
326         week_cursor = (user_point.ts + WEEK - 1) / WEEK * WEEK
327 
328     if week_cursor >= _last_token_time:
329         return 0
330 
331     if week_cursor < _start_time:
332         week_cursor = _start_time
333     old_user_point: Point = empty(Point)
334 
335     # Iterate over weeks
336     for i in range(50):
337         if week_cursor >= _last_token_time:
338             break
339 
340         if week_cursor >= user_point.ts and user_epoch <= max_user_epoch:
341             user_epoch += 1
342             old_user_point = user_point
343             if user_epoch > max_user_epoch:
344                 user_point = empty(Point)
345             else:
346                 user_point = VotingEscrow(ve).user_point_history(addr, user_epoch)
347 
348         else:
349             # Calc
350             # + i * 2 is for rounding errors
351             dt: int128 = convert(week_cursor - old_user_point.ts, int128)
352             balance_of: uint256 = convert(max(old_user_point.bias - dt * old_user_point.slope, zero), uint256)
353             if balance_of == 0 and user_epoch > max_user_epoch:
354                 break
355             if balance_of > 0:
356                 to_distribute += balance_of * self.tokens_per_week[week_cursor] / self.ve_supply[week_cursor]
357 
358             week_cursor += WEEK
359 
360     return to_distribute
361 
362 @view
363 @external
364 def claimable(_addr: address = msg.sender) -> uint256:
365     """
366     @notice See claimable fees for `_addr`
367     @dev Each call to claim looks at a maximum of 50 user veCRV points.
368          For accounts with many veCRV related actions, this function
369          may need to be called more than once to claim all available
370          fees. In the `Claimed` event that fires, if `claim_epoch` is
371          less than `max_epoch`, the account may claim again.
372     @param _addr Address to claim fees for
373     @return uint256 Amount of fees claimed in the call
374     """
375     last_token_time: uint256 = self.last_token_time / WEEK * WEEK
376     return self._claimable(_addr, self.voting_escrow, last_token_time)
377 
378 @external
379 @nonreentrant('lock')
380 def claim(_addr: address = msg.sender) -> uint256:
381     """
382     @notice Claim fees for `_addr`
383     @dev Each call to claim look at a maximum of 50 user veCRV points.
384          For accounts with many veCRV related actions, this function
385          may need to be called more than once to claim all available
386          fees. In the `Claimed` event that fires, if `claim_epoch` is
387          less than `max_epoch`, the account may claim again.
388     @param _addr Address to claim fees for
389     @return uint256 Amount of fees claimed in the call
390     """
391     assert not self.is_killed
392 
393     if block.timestamp >= self.time_cursor:
394         self._checkpoint_total_supply()
395 
396     last_token_time: uint256 = self.last_token_time
397 
398     if self.can_checkpoint_token and (block.timestamp > last_token_time + TOKEN_CHECKPOINT_DEADLINE):
399         self._checkpoint_token()
400         last_token_time = block.timestamp
401 
402     last_token_time = last_token_time / WEEK * WEEK
403 
404     amount: uint256 = self._claim(_addr, self.voting_escrow, last_token_time)
405     if amount != 0:
406         token: address = self.token
407         assert ERC20(token).transfer(_addr, amount)
408         self.token_last_balance -= amount
409 
410     return amount
411 
412 
413 @external
414 @nonreentrant('lock')
415 def claim_many(_receivers: address[20]) -> bool:
416     """
417     @notice Make multiple fee claims in a single call
418     @dev Used to claim for many accounts at once, or to make
419          multiple claims for the same address when that address
420          has significant veCRV history
421     @param _receivers List of addresses to claim for. Claiming
422                       terminates at the first `ZERO_ADDRESS`.
423     @return bool success
424     """
425     assert not self.is_killed
426 
427     if block.timestamp >= self.time_cursor:
428         self._checkpoint_total_supply()
429 
430     last_token_time: uint256 = self.last_token_time
431 
432     if self.can_checkpoint_token and (block.timestamp > last_token_time + TOKEN_CHECKPOINT_DEADLINE):
433         self._checkpoint_token()
434         last_token_time = block.timestamp
435 
436     last_token_time = last_token_time / WEEK * WEEK
437     voting_escrow: address = self.voting_escrow
438     token: address = self.token
439     total: uint256 = 0
440 
441     for addr in _receivers:
442         if addr == ZERO_ADDRESS:
443             break
444 
445         amount: uint256 = self._claim(addr, voting_escrow, last_token_time)
446         if amount != 0:
447             assert ERC20(token).transfer(addr, amount)
448             total += amount
449 
450     if total != 0:
451         self.token_last_balance -= total
452 
453     return True
454 
455 
456 @external
457 def burn(_coin: address) -> bool:
458     """
459     @notice Receive 3CRV into the contract and trigger a token checkpoint
460     @param _coin Address of the coin being received (must be 3CRV)
461     @return bool success
462     """
463     assert _coin == self.token
464     assert not self.is_killed
465 
466     amount: uint256 = ERC20(_coin).balanceOf(msg.sender)
467     if amount != 0:
468         ERC20(_coin).transferFrom(msg.sender, self, amount)
469         if self.can_checkpoint_token and (block.timestamp > self.last_token_time + TOKEN_CHECKPOINT_DEADLINE):
470             self._checkpoint_token()
471 
472     return True
473 
474 
475 @external
476 def commit_admin(_addr: address):
477     """
478     @notice Commit transfer of ownership
479     @param _addr New admin address
480     """
481     assert msg.sender == self.admin  # dev: access denied
482     self.future_admin = _addr
483     log CommitAdmin(_addr)
484 
485 
486 @external
487 def apply_admin():
488     """
489     @notice Apply transfer of ownership
490     """
491     assert msg.sender == self.admin
492     assert self.future_admin != ZERO_ADDRESS
493     future_admin: address = self.future_admin
494     self.admin = future_admin
495     log ApplyAdmin(future_admin)
496 
497 
498 @external
499 def toggle_allow_checkpoint_token():
500     """
501     @notice Toggle permission for checkpointing by any account
502     """
503     assert msg.sender == self.admin
504     flag: bool = not self.can_checkpoint_token
505     self.can_checkpoint_token = flag
506     log ToggleAllowCheckpointToken(flag)
507 
508 
509 @external
510 def kill_me():
511     """
512     @notice Kill the contract
513     @dev Killing transfers the entire 3CRV balance to the emergency return address
514          and blocks the ability to claim or burn. The contract cannot be unkilled.
515     """
516     assert msg.sender == self.admin
517 
518     self.is_killed = True
519 
520     token: address = self.token
521     assert ERC20(token).transfer(self.emergency_return, ERC20(token).balanceOf(self))
522 
523 
524 @external
525 def recover_balance(_coin: address) -> bool:
526     """
527     @notice Recover ERC20 tokens from this contract
528     @dev Tokens are sent to the emergency return address.
529     @param _coin Token address
530     @return bool success
531     """
532     assert msg.sender == self.admin
533     assert _coin != self.token
534 
535     amount: uint256 = ERC20(_coin).balanceOf(self)
536     response: Bytes[32] = raw_call(
537         _coin,
538         concat(
539             method_id("transfer(address,uint256)"),
540             convert(self.emergency_return, bytes32),
541             convert(amount, bytes32),
542         ),
543         max_outsize=32,
544     )
545     if len(response) != 0:
546         assert convert(response, bool)
547 
548     return True