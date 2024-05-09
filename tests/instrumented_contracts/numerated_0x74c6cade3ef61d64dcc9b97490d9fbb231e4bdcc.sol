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
185     ve: address = self.voting_escrow
186     max_user_epoch: uint256 = VotingEscrow(ve).user_point_epoch(_user)
187     epoch: uint256 = self._find_timestamp_user_epoch(ve, _user, _timestamp, max_user_epoch)
188     pt: Point = VotingEscrow(ve).user_point_history(_user, epoch)
189     return convert(max(pt.bias - pt.slope * convert(_timestamp - pt.ts, int128), 0), uint256)
190 
191 
192 @internal
193 def _checkpoint_total_supply():
194     ve: address = self.voting_escrow
195     t: uint256 = self.time_cursor
196     rounded_timestamp: uint256 = block.timestamp / WEEK * WEEK
197     VotingEscrow(ve).checkpoint()
198 
199     for i in range(20):
200         if t > rounded_timestamp:
201             break
202         else:
203             epoch: uint256 = self._find_timestamp_epoch(ve, t)
204             pt: Point = VotingEscrow(ve).point_history(epoch)
205             dt: int128 = 0
206             if t > pt.ts:
207                 # If the point is at 0 epoch, it can actually be earlier than the first deposit
208                 # Then make dt 0
209                 dt = convert(t - pt.ts, int128)
210             self.ve_supply[t] = convert(max(pt.bias - pt.slope * dt, 0), uint256)
211         t += WEEK
212 
213     self.time_cursor = t
214 
215 
216 @external
217 def checkpoint_total_supply():
218     """
219     @notice Update the veCRV total supply checkpoint
220     @dev The checkpoint is also updated by the first claimant each
221          new epoch week. This function may be called independently
222          of a claim, to reduce claiming gas costs.
223     """
224     self._checkpoint_total_supply()
225 
226 
227 @internal
228 def _claim(addr: address, ve: address, _last_token_time: uint256) -> uint256:
229     # Minimal user_epoch is 0 (if user had no point)
230     user_epoch: uint256 = 0
231     to_distribute: uint256 = 0
232 
233     max_user_epoch: uint256 = VotingEscrow(ve).user_point_epoch(addr)
234     _start_time: uint256 = self.start_time
235 
236     if max_user_epoch == 0:
237         # No lock = no fees
238         return 0
239 
240     week_cursor: uint256 = self.time_cursor_of[addr]
241     if week_cursor == 0:
242         # Need to do the initial binary search
243         user_epoch = self._find_timestamp_user_epoch(ve, addr, _start_time, max_user_epoch)
244     else:
245         user_epoch = self.user_epoch_of[addr]
246 
247     if user_epoch == 0:
248         user_epoch = 1
249 
250     user_point: Point = VotingEscrow(ve).user_point_history(addr, user_epoch)
251 
252     if week_cursor == 0:
253         week_cursor = (user_point.ts + WEEK - 1) / WEEK * WEEK
254 
255     if week_cursor >= _last_token_time:
256         return 0
257 
258     if week_cursor < _start_time:
259         week_cursor = _start_time
260     old_user_point: Point = empty(Point)
261 
262     # Iterate over weeks
263     for i in range(50):
264         if week_cursor >= _last_token_time:
265             break
266 
267         if week_cursor >= user_point.ts and user_epoch <= max_user_epoch:
268             user_epoch += 1
269             old_user_point = user_point
270             if user_epoch > max_user_epoch:
271                 user_point = empty(Point)
272             else:
273                 user_point = VotingEscrow(ve).user_point_history(addr, user_epoch)
274 
275         else:
276             # Calc
277             # + i * 2 is for rounding errors
278             dt: int128 = convert(week_cursor - old_user_point.ts, int128)
279             balance_of: uint256 = convert(max(old_user_point.bias - dt * old_user_point.slope, 0), uint256)
280             if balance_of == 0 and user_epoch > max_user_epoch:
281                 break
282             if balance_of > 0:
283                 to_distribute += balance_of * self.tokens_per_week[week_cursor] / self.ve_supply[week_cursor]
284 
285             week_cursor += WEEK
286 
287     user_epoch = min(max_user_epoch, user_epoch - 1)
288     self.user_epoch_of[addr] = user_epoch
289     self.time_cursor_of[addr] = week_cursor
290 
291     log Claimed(addr, to_distribute, user_epoch, max_user_epoch)
292 
293     return to_distribute
294 
295 
296 @external
297 @nonreentrant('lock')
298 def claim(_addr: address = msg.sender) -> uint256:
299     """
300     @notice Claim fees for `_addr`
301     @dev Each call to claim look at a maximum of 50 user veCRV points.
302          For accounts with many veCRV related actions, this function
303          may need to be called more than once to claim all available
304          fees. In the `Claimed` event that fires, if `claim_epoch` is
305          less than `max_epoch`, the account may claim again.
306     @param _addr Address to claim fees for
307     @return uint256 Amount of fees claimed in the call
308     """
309     assert not self.is_killed
310 
311     if block.timestamp >= self.time_cursor:
312         self._checkpoint_total_supply()
313 
314     last_token_time: uint256 = self.last_token_time
315 
316     if self.can_checkpoint_token and (block.timestamp > last_token_time + TOKEN_CHECKPOINT_DEADLINE):
317         self._checkpoint_token()
318         last_token_time = block.timestamp
319 
320     last_token_time = last_token_time / WEEK * WEEK
321 
322     amount: uint256 = self._claim(_addr, self.voting_escrow, last_token_time)
323     if amount != 0:
324         token: address = self.token
325         assert ERC20(token).transfer(_addr, amount)
326         self.token_last_balance -= amount
327 
328     return amount
329 
330 
331 @external
332 @nonreentrant('lock')
333 def claim_many(_receivers: address[20]) -> bool:
334     """
335     @notice Make multiple fee claims in a single call
336     @dev Used to claim for many accounts at once, or to make
337          multiple claims for the same address when that address
338          has significant veCRV history
339     @param _receivers List of addresses to claim for. Claiming
340                       terminates at the first `ZERO_ADDRESS`.
341     @return bool success
342     """
343     assert not self.is_killed
344 
345     if block.timestamp >= self.time_cursor:
346         self._checkpoint_total_supply()
347 
348     last_token_time: uint256 = self.last_token_time
349 
350     if self.can_checkpoint_token and (block.timestamp > last_token_time + TOKEN_CHECKPOINT_DEADLINE):
351         self._checkpoint_token()
352         last_token_time = block.timestamp
353 
354     last_token_time = last_token_time / WEEK * WEEK
355     voting_escrow: address = self.voting_escrow
356     token: address = self.token
357     total: uint256 = 0
358 
359     for addr in _receivers:
360         if addr == ZERO_ADDRESS:
361             break
362 
363         amount: uint256 = self._claim(addr, voting_escrow, last_token_time)
364         if amount != 0:
365             assert ERC20(token).transfer(addr, amount)
366             total += amount
367 
368     if total != 0:
369         self.token_last_balance -= total
370 
371     return True
372 
373 
374 @external
375 def burn(_coin: address) -> bool:
376     """
377     @notice Receive 3CRV into the contract and trigger a token checkpoint
378     @param _coin Address of the coin being received (must be 3CRV)
379     @return bool success
380     """
381     assert _coin == self.token
382     assert not self.is_killed
383 
384     amount: uint256 = ERC20(_coin).balanceOf(msg.sender)
385     if amount != 0:
386         ERC20(_coin).transferFrom(msg.sender, self, amount)
387         if self.can_checkpoint_token and (block.timestamp > self.last_token_time + TOKEN_CHECKPOINT_DEADLINE):
388             self._checkpoint_token()
389 
390     return True
391 
392 
393 @external
394 def commit_admin(_addr: address):
395     """
396     @notice Commit transfer of ownership
397     @param _addr New admin address
398     """
399     assert msg.sender == self.admin  # dev: access denied
400     self.future_admin = _addr
401     log CommitAdmin(_addr)
402 
403 
404 @external
405 def apply_admin():
406     """
407     @notice Apply transfer of ownership
408     """
409     assert msg.sender == self.admin
410     assert self.future_admin != ZERO_ADDRESS
411     future_admin: address = self.future_admin
412     self.admin = future_admin
413     log ApplyAdmin(future_admin)
414 
415 
416 @external
417 def toggle_allow_checkpoint_token():
418     """
419     @notice Toggle permission for checkpointing by any account
420     """
421     assert msg.sender == self.admin
422     flag: bool = not self.can_checkpoint_token
423     self.can_checkpoint_token = flag
424     log ToggleAllowCheckpointToken(flag)
425 
426 
427 @external
428 def kill_me():
429     """
430     @notice Kill the contract
431     @dev Killing transfers the entire 3CRV balance to the emergency return address
432          and blocks the ability to claim or burn. The contract cannot be unkilled.
433     """
434     assert msg.sender == self.admin
435 
436     self.is_killed = True
437 
438     token: address = self.token
439     assert ERC20(token).transfer(self.emergency_return, ERC20(token).balanceOf(self))
440 
441 
442 @external
443 def recover_balance(_coin: address) -> bool:
444     """
445     @notice Recover ERC20 tokens from this contract
446     @dev Tokens are sent to the emergency return address.
447     @param _coin Token address
448     @return bool success
449     """
450     assert msg.sender == self.admin
451     assert _coin != self.token
452 
453     amount: uint256 = ERC20(_coin).balanceOf(self)
454     response: Bytes[32] = raw_call(
455         _coin,
456         concat(
457             method_id("transfer(address,uint256)"),
458             convert(self.emergency_return, bytes32),
459             convert(amount, bytes32),
460         ),
461         max_outsize=32,
462     )
463     if len(response) != 0:
464         assert convert(response, bool)
465 
466     return True