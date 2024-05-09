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
35     amount_eth: uint256
36     claim_epoch: uint256
37     max_epoch: uint256
38 
39 event EtherSent:
40     amount: uint256
41     sender: indexed(address)
42 
43 struct Point:
44     bias: int128
45     slope: int128  # - dweight / dt
46     ts: uint256
47     blk: uint256  # block
48 
49 
50 WEEK: constant(uint256) = 7 * 86400
51 TOKEN_CHECKPOINT_DEADLINE: constant(uint256) = 86400
52 
53 start_time: public(uint256)
54 time_cursor: public(uint256)
55 time_cursor_of: public(HashMap[address, uint256])
56 user_epoch_of: public(HashMap[address, uint256])
57 
58 last_token_time: public(uint256)
59 tokens_per_week: public(uint256[1000000000000000])
60 eth_per_week: public(uint256[1000000000000000])
61 
62 voting_escrow: public(address)
63 token: public(address)
64 total_received: public(uint256)
65 total_eth_received: public(uint256)
66 token_last_balance: public(uint256)
67 eth_last_balance: public(uint256)
68 
69 ve_supply: public(uint256[1000000000000000])  # VE total supply at week bounds
70 
71 admin: public(address)
72 future_admin: public(address)
73 can_checkpoint_token: public(bool)
74 emergency_return: public(address)
75 is_killed: public(bool)
76 
77 
78 @external
79 def __init__(
80     _voting_escrow: address,
81     _start_time: uint256,
82     _token: address,
83     _admin: address,
84     _emergency_return: address
85 ):
86     """
87     @notice Contract constructor
88     @param _voting_escrow VotingEscrow contract address
89     @param _start_time Epoch time for fee distribution to start
90     @param _token Fee token address (3CRV)
91     @param _admin Admin address
92     @param _emergency_return Address to transfer `_token` balance to
93                              if this contract is killed
94     """
95     t: uint256 = _start_time / WEEK * WEEK
96     self.start_time = t
97     self.last_token_time = t
98     self.time_cursor = t
99     self.token = _token
100     self.voting_escrow = _voting_escrow
101     self.admin = _admin
102     self.emergency_return = _emergency_return
103 
104 
105 @internal
106 def _checkpoint_token():
107     token_balance: uint256 = ERC20(self.token).balanceOf(self)
108     to_distribute: uint256 = token_balance - self.token_last_balance
109     self.token_last_balance = token_balance
110 
111     eth_balance: uint256 = self.balance
112     to_distribute_eth: uint256 = eth_balance - self.eth_last_balance
113     self.eth_last_balance = eth_balance
114 
115     t: uint256 = self.last_token_time
116     since_last: uint256 = block.timestamp - t
117     self.last_token_time = block.timestamp
118     this_week: uint256 = t / WEEK * WEEK
119     next_week: uint256 = 0
120 
121     for i in range(20):
122         next_week = this_week + WEEK
123         if block.timestamp < next_week:
124             if since_last == 0 and block.timestamp == t:
125                 self.tokens_per_week[this_week] += to_distribute
126                 self.eth_per_week[this_week] += to_distribute_eth
127             else:
128                 self.tokens_per_week[this_week] += to_distribute * (block.timestamp - t) / since_last
129                 self.eth_per_week[this_week] += to_distribute_eth * (block.timestamp - t) / since_last
130             break
131         else:
132             if since_last == 0 and next_week == t:
133                 self.tokens_per_week[this_week] += to_distribute
134                 self.eth_per_week[this_week] += to_distribute_eth
135             else:
136                 self.tokens_per_week[this_week] += to_distribute * (next_week - t) / since_last
137                 self.eth_per_week[this_week] += to_distribute_eth * (next_week - t) / since_last
138         t = next_week
139         this_week = next_week
140 
141     log CheckpointToken(block.timestamp, to_distribute)
142 
143 
144 @external
145 def checkpoint_token():
146     """
147     @notice Update the token checkpoint
148     @dev Calculates the total number of tokens to be distributed in a given week.
149          During setup for the initial distribution this function is only callable
150          by the contract owner. Beyond initial distro, it can be enabled for anyone
151          to call.
152     """
153     assert (msg.sender == self.admin) or\
154            (self.can_checkpoint_token and (block.timestamp > self.last_token_time + TOKEN_CHECKPOINT_DEADLINE))
155     self._checkpoint_token()
156 
157 
158 @internal
159 def _find_timestamp_epoch(ve: address, _timestamp: uint256) -> uint256:
160     _min: uint256 = 0
161     _max: uint256 = VotingEscrow(ve).epoch()
162     for i in range(128):
163         if _min >= _max:
164             break
165         _mid: uint256 = (_min + _max + 2) / 2
166         pt: Point = VotingEscrow(ve).point_history(_mid)
167         if pt.ts <= _timestamp:
168             _min = _mid
169         else:
170             _max = _mid - 1
171     return _min
172 
173 
174 @view
175 @internal
176 def _find_timestamp_user_epoch(ve: address, user: address, _timestamp: uint256, max_user_epoch: uint256) -> uint256:
177     _min: uint256 = 0
178     _max: uint256 = max_user_epoch
179     for i in range(128):
180         if _min >= _max:
181             break
182         _mid: uint256 = (_min + _max + 2) / 2
183         pt: Point = VotingEscrow(ve).user_point_history(user, _mid)
184         if pt.ts <= _timestamp:
185             _min = _mid
186         else:
187             _max = _mid - 1
188     return _min
189 
190 
191 @view
192 @external
193 def ve_for_at(_user: address, _timestamp: uint256) -> uint256:
194     """
195     @notice Get the veCRV balance for `_user` at `_timestamp`
196     @param _user Address to query balance for
197     @param _timestamp Epoch time
198     @return uint256 veCRV balance
199     """
200     ve: address = self.voting_escrow
201     max_user_epoch: uint256 = VotingEscrow(ve).user_point_epoch(_user)
202     epoch: uint256 = self._find_timestamp_user_epoch(ve, _user, _timestamp, max_user_epoch)
203     pt: Point = VotingEscrow(ve).user_point_history(_user, epoch)
204     return convert(max(pt.bias - pt.slope * convert(_timestamp - pt.ts, int128), 0), uint256)
205 
206 
207 @internal
208 def _checkpoint_total_supply():
209     ve: address = self.voting_escrow
210     t: uint256 = self.time_cursor
211     rounded_timestamp: uint256 = block.timestamp / WEEK * WEEK
212     VotingEscrow(ve).checkpoint()
213 
214     for i in range(20):
215         if t > rounded_timestamp:
216             break
217         else:
218             epoch: uint256 = self._find_timestamp_epoch(ve, t)
219             pt: Point = VotingEscrow(ve).point_history(epoch)
220             dt: int128 = 0
221             if t > pt.ts:
222                 # If the point is at 0 epoch, it can actually be earlier than the first deposit
223                 # Then make dt 0
224                 dt = convert(t - pt.ts, int128)
225             self.ve_supply[t] = convert(max(pt.bias - pt.slope * dt, 0), uint256)
226         t += WEEK
227 
228     self.time_cursor = t
229 
230 
231 @external
232 def checkpoint_total_supply():
233     """
234     @notice Update the veCRV total supply checkpoint
235     @dev The checkpoint is also updated by the first claimant each
236          new epoch week. This function may be called independently
237          of a claim, to reduce claiming gas costs.
238     """
239     self._checkpoint_total_supply()
240 
241 
242 @internal
243 def _claim(addr: address, ve: address, _last_token_time: uint256, claim_all: bool) -> (uint256, uint256):
244     # Minimal user_epoch is 0 (if user had no point)
245     user_epoch: uint256 = 0
246     to_distribute_tokens: uint256 = 0
247     to_distribute_eth: uint256 = 0
248 
249     max_user_epoch: uint256 = VotingEscrow(ve).user_point_epoch(addr)
250     _start_time: uint256 = self.start_time
251 
252     if max_user_epoch == 0:
253         # No lock = no fees
254         return 0, 0
255 
256     week_cursor: uint256 = self.time_cursor_of[addr]
257     if week_cursor == 0:
258         # Need to do the initial binary search
259         user_epoch = self._find_timestamp_user_epoch(ve, addr, _start_time, max_user_epoch)
260     else:
261         user_epoch = self.user_epoch_of[addr]
262 
263     if user_epoch == 0:
264         user_epoch = 1
265 
266     user_point: Point = VotingEscrow(ve).user_point_history(addr, user_epoch)
267 
268     if week_cursor == 0:
269         week_cursor = (user_point.ts + WEEK - 1) / WEEK * WEEK
270 
271     if week_cursor >= _last_token_time:
272         return 0, 0
273 
274     if week_cursor < _start_time:
275         week_cursor = _start_time
276     old_user_point: Point = empty(Point)
277 
278     # Iterate over weeks
279     for i in range(MAX_UINT256):
280         if (not claim_all and i > 50) or (week_cursor >= _last_token_time):
281             break
282 
283         if week_cursor >= user_point.ts and user_epoch <= max_user_epoch:
284             user_epoch += 1
285             old_user_point = user_point
286             if user_epoch > max_user_epoch:
287                 user_point = empty(Point)
288             else:
289                 user_point = VotingEscrow(ve).user_point_history(addr, user_epoch)
290 
291         else:
292             # Calc
293             # + i * 2 is for rounding errors
294             dt: int128 = convert(week_cursor - old_user_point.ts, int128)
295             balance_of: uint256 = convert(max(old_user_point.bias - dt * old_user_point.slope, 0), uint256)
296             if balance_of == 0 and user_epoch > max_user_epoch:
297                 break
298             if balance_of > 0:
299                 to_distribute_tokens += balance_of * self.tokens_per_week[week_cursor] / self.ve_supply[week_cursor]
300                 to_distribute_eth += balance_of * self.eth_per_week[week_cursor] / self.ve_supply[week_cursor]
301             week_cursor += WEEK
302 
303     user_epoch = min(max_user_epoch, user_epoch - 1)
304     self.user_epoch_of[addr] = user_epoch
305     self.time_cursor_of[addr] = week_cursor
306 
307     log Claimed(addr, to_distribute_tokens, to_distribute_eth, user_epoch, max_user_epoch)
308 
309     return to_distribute_tokens, to_distribute_eth
310 
311 @internal
312 def _checkpoint_and_claim(_addr: address, claim_all: bool) -> (uint256, uint256):
313     assert not self.is_killed
314 
315     if block.timestamp >= self.time_cursor:
316         self._checkpoint_total_supply()
317 
318     last_token_time: uint256 = self.last_token_time
319 
320     if self.can_checkpoint_token and (block.timestamp > last_token_time + TOKEN_CHECKPOINT_DEADLINE):
321         self._checkpoint_token()
322         last_token_time = block.timestamp
323 
324     last_token_time = last_token_time / WEEK * WEEK
325 
326     tokens_amount: uint256 = 0
327     eth_amount: uint256 = 0
328 
329     tokens_amount, eth_amount = self._claim(_addr, self.voting_escrow, last_token_time, claim_all)
330 
331     if tokens_amount != 0:
332         token: address = self.token
333         assert ERC20(token).transfer(_addr, tokens_amount)
334         self.token_last_balance -= tokens_amount
335 
336     if eth_amount != 0:
337         send(_addr, eth_amount)
338         self.eth_last_balance -= eth_amount
339 
340     return tokens_amount, eth_amount
341 
342 
343 @external
344 @nonreentrant('lock')
345 def claim(_addr: address = msg.sender) -> (uint256, uint256):
346     """
347     @notice Claim fees for `_addr`
348     @dev Each call to claim look at a maximum of 50 user veCRV points.
349          For accounts with many veCRV related actions, this function
350          may need to be called more than once to claim all available
351          fees. In the `Claimed` event that fires, if `claim_epoch` is
352          less than `max_epoch`, the account may claim again.
353     @param _addr Address to claim fees for
354     @return uint256 Amount of fees claimed in the call
355     """
356     return self._checkpoint_and_claim(_addr, False)
357 
358 
359 @external
360 @nonreentrant('lock')
361 def claim_all(_addr: address = msg.sender) -> (uint256, uint256):
362     """
363     @notice Claim fees without 50 week limit for `_addr`
364     @dev Call to claim look at all the possible user veCRV points
365          till now instead of 50 limit of simple claim.
366          For accounts with many veCRV related actions, this function
367          can be called once to claim all available fees.
368          Although the caller should be aware of gas limits as looping
369          over a large count of veCRV points could result in exceeding
370          block gas limits resulting in this function to fail/costing
371          a lot of gas at once.
372     @param _addr Address to claim fees for
373     @return uint256 Amount of fees claimed in the call
374     """
375     return self._checkpoint_and_claim(_addr, True)
376 
377 
378 @external
379 @nonreentrant('lock')
380 def claim_many(_receivers: address[20]) -> bool:
381     """
382     @notice Make multiple fee claims in a single call
383     @dev Used to claim for many accounts at once, or to make
384          multiple claims for the same address when that address
385          has significant veCRV history
386     @param _receivers List of addresses to claim for. Claiming
387                       terminates at the first `ZERO_ADDRESS`.
388     @return bool success
389     """
390     assert not self.is_killed
391 
392     if block.timestamp >= self.time_cursor:
393         self._checkpoint_total_supply()
394 
395     last_token_time: uint256 = self.last_token_time
396 
397     if self.can_checkpoint_token and (block.timestamp > last_token_time + TOKEN_CHECKPOINT_DEADLINE):
398         self._checkpoint_token()
399         last_token_time = block.timestamp
400 
401     last_token_time = last_token_time / WEEK * WEEK
402     voting_escrow: address = self.voting_escrow
403     token: address = self.token
404     total_tokens: uint256 = 0
405     total_eth: uint256 = 0
406 
407     for addr in _receivers:
408         if addr == ZERO_ADDRESS:
409             break
410 
411         tokens_amount: uint256 = 0
412         eth_amount: uint256 = 0
413 
414         tokens_amount, eth_amount = self._claim(addr, voting_escrow, last_token_time, False)
415         if tokens_amount != 0:
416             assert ERC20(token).transfer(addr, tokens_amount)
417             total_tokens += tokens_amount
418 
419         if eth_amount != 0:
420             send(addr, eth_amount)
421             total_eth += eth_amount
422 
423     if total_tokens != 0:
424         self.token_last_balance -= total_tokens
425     if total_eth != 0:
426         self.eth_last_balance -= total_eth
427 
428     return True
429 
430 
431 @external
432 @payable
433 def burn(_coin: address) -> bool:
434     """
435     @notice Receive 3CRV into the contract and trigger a token checkpoint
436     @param _coin Address of the coin being received (must be 3CRV)
437     @return bool success
438     """
439     assert _coin == self.token
440     assert not self.is_killed
441     
442     amount: uint256 = ERC20(_coin).balanceOf(msg.sender)
443     if amount != 0:
444         ERC20(_coin).transferFrom(msg.sender, self, amount)
445 
446     if (amount != 0 or msg.value != 0) and self.can_checkpoint_token and (block.timestamp > self.last_token_time + TOKEN_CHECKPOINT_DEADLINE):
447         self._checkpoint_token()
448 
449     return True
450 
451 
452 @external
453 @payable
454 def __default__():
455     assert not self.is_killed
456 
457     log EtherSent(msg.value, msg.sender)
458 
459     if self.can_checkpoint_token and (block.timestamp > self.last_token_time + TOKEN_CHECKPOINT_DEADLINE):
460             self._checkpoint_token()
461 
462 
463 @external
464 def commit_admin(_addr: address):
465     """
466     @notice Commit transfer of ownership
467     @param _addr New admin address
468     """
469     assert msg.sender == self.admin  # dev: access denied
470     self.future_admin = _addr
471     log CommitAdmin(_addr)
472 
473 
474 @external
475 def apply_admin():
476     """
477     @notice Apply transfer of ownership
478     """
479     assert msg.sender == self.admin
480     assert self.future_admin != ZERO_ADDRESS
481     future_admin: address = self.future_admin
482     self.admin = future_admin
483     log ApplyAdmin(future_admin)
484 
485 
486 @external
487 def toggle_allow_checkpoint_token():
488     """
489     @notice Toggle permission for checkpointing by any account
490     """
491     assert msg.sender == self.admin
492     flag: bool = not self.can_checkpoint_token
493     self.can_checkpoint_token = flag
494     log ToggleAllowCheckpointToken(flag)
495 
496 
497 @external
498 def kill_me():
499     """
500     @notice Kill the contract
501     @dev Killing transfers the entire 3CRV balance to the emergency return address
502          and blocks the ability to claim or burn. The contract cannot be unkilled.
503     """
504     assert msg.sender == self.admin
505 
506     self.is_killed = True
507 
508     send(self.emergency_return, self.balance)
509 
510     token: address = self.token
511     assert ERC20(token).transfer(self.emergency_return, ERC20(token).balanceOf(self))
512 
513 
514 @external
515 def recover_balance(_coin: address) -> bool:
516     """
517     @notice Recover ERC20 tokens from this contract
518     @dev Tokens are sent to the emergency return address.
519     @param _coin Token address
520     @return bool success
521     """
522     assert msg.sender == self.admin
523     assert _coin != self.token
524 
525     amount: uint256 = ERC20(_coin).balanceOf(self)
526     response: Bytes[32] = raw_call(
527         _coin,
528         concat(
529             method_id("transfer(address,uint256)"),
530             convert(self.emergency_return, bytes32),
531             convert(amount, bytes32),
532         ),
533         max_outsize=32,
534     )
535     if len(response) != 0:
536         assert convert(response, bool)
537 
538     return True