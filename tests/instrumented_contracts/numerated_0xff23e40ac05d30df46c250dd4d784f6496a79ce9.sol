1 # @version 0.2.16
2 """
3 @title Angle Fee Distribution
4 @author Angle Protocol
5 @license MIT
6 """
7 
8 # Original idea and credit:
9 # Curve Finance's FeeDistributor
10 # https://github.com/curvefi/curve-dao-contracts/blob/master/contracts/FeeDistributor.vy
11 
12 from vyper.interfaces import ERC20
13 
14 
15 interface VotingEscrow:
16     def user_point_epoch(addr: address) -> uint256: view
17     def epoch() -> uint256: view
18     def user_point_history(addr: address, loc: uint256) -> Point: view
19     def point_history(loc: uint256) -> Point: view
20     def checkpoint(): nonpayable
21 
22 
23 event CommitAdmin:
24     admin: address
25 
26 event ApplyAdmin:
27     admin: address
28 
29 event ToggleAllowCheckpointToken:
30     toggle_flag: bool
31 
32 event CheckpointToken:
33     time: uint256
34     tokens: uint256
35 
36 event Claimed:
37     recipient: indexed(address)
38     amount: uint256
39     claim_epoch: uint256
40     max_epoch: uint256
41 
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
60 
61 voting_escrow: public(address)
62 token: public(address)
63 total_received: public(uint256)
64 token_last_balance: public(uint256)
65 
66 ve_supply: public(uint256[1000000000000000])  # VE total supply at week bounds
67 
68 admin: public(address)
69 future_admin: public(address)
70 can_checkpoint_token: public(bool)
71 emergency_return: public(address)
72 is_killed: public(bool)
73 
74 
75 @external
76 def __init__(
77     _voting_escrow: address,
78     _start_time: uint256,
79     _token: address,
80     _admin: address,
81     _emergency_return: address
82 ):
83     """
84     @notice Contract constructor
85     @param _voting_escrow VotingEscrow contract address
86     @param _start_time Epoch time for fee distribution to start
87     @param _token Fee token address
88     @param _admin Admin address
89     @param _emergency_return Address to transfer `_token` balance to
90                              if this contract is killed
91     """
92 
93     assert _voting_escrow != ZERO_ADDRESS
94     assert _token != ZERO_ADDRESS
95     assert _admin != ZERO_ADDRESS
96     assert _emergency_return != ZERO_ADDRESS
97 
98     t: uint256 = _start_time / WEEK * WEEK
99     self.start_time = t
100     self.last_token_time = t
101     self.time_cursor = t
102     self.token = _token
103     self.voting_escrow = _voting_escrow
104     self.admin = _admin
105     self.emergency_return = _emergency_return
106 
107 
108 @internal
109 def _checkpoint_token():
110     token_balance: uint256 = ERC20(self.token).balanceOf(self)
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
190     @notice Get the veANGLE balance for `_user` at `_timestamp`
191     @param _user Address to query balance for
192     @param _timestamp Epoch time
193     @return uint256 veANGLE balance
194     """
195     ve: address = self.voting_escrow
196     max_user_epoch: uint256 = VotingEscrow(ve).user_point_epoch(_user)
197     epoch: uint256 = self._find_timestamp_user_epoch(ve, _user, _timestamp, max_user_epoch)
198     pt: Point = VotingEscrow(ve).user_point_history(_user, epoch)
199     return convert(max(pt.bias - pt.slope * convert(_timestamp - pt.ts, int128), empty(int128)), uint256)
200 
201 
202 @internal
203 def _checkpoint_total_supply():
204     ve: address = self.voting_escrow
205     t: uint256 = self.time_cursor
206     rounded_timestamp: uint256 = block.timestamp / WEEK * WEEK
207     VotingEscrow(ve).checkpoint()
208 
209     for i in range(20):
210         if t > rounded_timestamp:
211             break
212         else:
213             epoch: uint256 = self._find_timestamp_epoch(ve, t)
214             pt: Point = VotingEscrow(ve).point_history(epoch)
215             dt: int128 = 0
216             if t > pt.ts:
217                 # If the point is at 0 epoch, it can actually be earlier than the first deposit
218                 # Then make dt 0
219                 dt = convert(t - pt.ts, int128)
220             self.ve_supply[t] = convert(max(pt.bias - pt.slope * dt, empty(int128)), uint256)
221         t += WEEK
222 
223     self.time_cursor = t
224 
225 
226 @external
227 def checkpoint_total_supply():
228     """
229     @notice Update the veANGLE total supply checkpoint
230     @dev The checkpoint is also updated by the first claimant each
231          new epoch week. This function may be called independently
232          of a claim, to reduce claiming gas costs.
233     """
234     self._checkpoint_total_supply()
235 
236 
237 @internal
238 def _claim(addr: address, ve: address, _last_token_time: uint256) -> uint256:
239     # Minimal user_epoch is 0 (if user had no point)
240     user_epoch: uint256 = 0
241     to_distribute: uint256 = 0
242 
243     max_user_epoch: uint256 = VotingEscrow(ve).user_point_epoch(addr)
244     _start_time: uint256 = self.start_time
245 
246     if max_user_epoch == 0:
247         # No lock = no fees
248         return 0
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
266         return 0
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
289             balance_of: uint256 = convert(max(old_user_point.bias - dt * old_user_point.slope, empty(int128)), uint256)
290             if balance_of == 0 and user_epoch > max_user_epoch:
291                 break
292             if balance_of > 0:
293                 to_distribute += balance_of * self.tokens_per_week[week_cursor] / self.ve_supply[week_cursor]
294 
295             week_cursor += WEEK
296 
297     user_epoch = min(max_user_epoch, user_epoch - 1)
298     self.user_epoch_of[addr] = user_epoch
299     self.time_cursor_of[addr] = week_cursor
300 
301     log Claimed(addr, to_distribute, user_epoch, max_user_epoch)
302 
303     return to_distribute
304 
305 
306 @external
307 @nonreentrant('lock')
308 def claim(_addr: address = msg.sender) -> uint256:
309     """
310     @notice Claim fees for `_addr`
311     @dev Each call to claim look at a maximum of 50 user veANGLE points.
312          For accounts with many veANGLE related actions, this function
313          may need to be called more than once to claim all available
314          fees. In the `Claimed` event that fires, if `claim_epoch` is
315          less than `max_epoch`, the account may claim again.
316     @param _addr Address to claim fees for
317     @return uint256 Amount of fees claimed in the call
318     """
319     assert not self.is_killed
320 
321     if block.timestamp >= self.time_cursor:
322         self._checkpoint_total_supply()
323 
324     last_token_time: uint256 = self.last_token_time
325 
326     if self.can_checkpoint_token and (block.timestamp > last_token_time + TOKEN_CHECKPOINT_DEADLINE):
327         self._checkpoint_token()
328         last_token_time = block.timestamp
329 
330     last_token_time = last_token_time / WEEK * WEEK
331 
332     amount: uint256 = self._claim(_addr, self.voting_escrow, last_token_time)
333     if amount != 0:
334         token: address = self.token
335         assert ERC20(token).transfer(_addr, amount)
336         self.token_last_balance -= amount
337 
338     return amount
339 
340 
341 @external
342 @nonreentrant('lock')
343 def claim_many(_receivers: address[20]) -> bool:
344     """
345     @notice Make multiple fee claims in a single call
346     @dev Used to claim for many accounts at once, or to make
347          multiple claims for the same address when that address
348          has significant veANGLE history
349     @param _receivers List of addresses to claim for. Claiming
350                       terminates at the first `ZERO_ADDRESS`.
351     @return bool success
352     """
353     assert not self.is_killed
354 
355     if block.timestamp >= self.time_cursor:
356         self._checkpoint_total_supply()
357 
358     last_token_time: uint256 = self.last_token_time
359 
360     if self.can_checkpoint_token and (block.timestamp > last_token_time + TOKEN_CHECKPOINT_DEADLINE):
361         self._checkpoint_token()
362         last_token_time = block.timestamp
363 
364     last_token_time = last_token_time / WEEK * WEEK
365     voting_escrow: address = self.voting_escrow
366     token: address = self.token
367     total: uint256 = 0
368 
369     for addr in _receivers:
370         if addr == ZERO_ADDRESS:
371             break
372 
373         amount: uint256 = self._claim(addr, voting_escrow, last_token_time)
374         if amount != 0:
375             assert ERC20(token).transfer(addr, amount)
376             total += amount
377 
378     if total != 0:
379         self.token_last_balance -= total
380 
381     return True
382 
383 
384 @external
385 def burn(_coin: address) -> bool:
386     """
387     @notice Receive _coin into the contract and trigger a token checkpoint
388     @param _coin Address of the coin being received (must be in the whitelisted tokens)
389     @return bool success
390     """
391     assert _coin == self.token
392     assert not self.is_killed
393 
394     amount: uint256 = ERC20(_coin).balanceOf(msg.sender)
395     if amount != 0:
396         ERC20(_coin).transferFrom(msg.sender, self, amount)
397         if self.can_checkpoint_token and (block.timestamp > self.last_token_time + TOKEN_CHECKPOINT_DEADLINE):
398             self._checkpoint_token()
399 
400     return True
401 
402 @external
403 def commit_admin(_addr: address):
404     """
405     @notice Commit transfer of ownership
406     @param _addr New admin address
407     """
408     assert msg.sender == self.admin  # dev: access denied
409     assert _addr != ZERO_ADDRESS  # dev: future admin cannot be the 0 address
410     self.future_admin = _addr
411     log CommitAdmin(_addr)
412 
413 
414 @external
415 def accept_admin():
416     """
417     @notice Accept a pending ownership transfer
418     """
419     _admin: address = self.future_admin
420     assert msg.sender == _admin  # dev: future admin only
421 
422     self.admin = _admin
423     log ApplyAdmin(_admin)
424 
425 @external
426 def toggle_allow_checkpoint_token():
427     """
428     @notice Toggle permission for checkpointing by any account
429     """
430     assert msg.sender == self.admin
431     flag: bool = not self.can_checkpoint_token
432     self.can_checkpoint_token = flag
433     log ToggleAllowCheckpointToken(flag)
434 
435 
436 @external
437 def kill_me():
438     """
439     @notice Kill the contract
440     @dev Killing transfers the entire tokens balance to the emergency return address
441          and blocks the ability to claim or burn. The contract cannot be unkilled.
442     """
443     assert msg.sender == self.admin
444 
445     self.is_killed = True
446 
447     token: address = self.token
448     assert ERC20(token).transfer(self.emergency_return, ERC20(token).balanceOf(self))
449 
450 
451 @external
452 def recover_balance(_coin: address) -> bool:
453     """
454     @notice Recover ERC20 tokens from this contract
455     @dev Tokens are sent to the emergency return address.
456     @param _coin Token address
457     @return bool success
458     """
459     assert msg.sender == self.admin
460     assert _coin != self.token
461 
462     amount: uint256 = ERC20(_coin).balanceOf(self)
463     response: Bytes[32] = raw_call(
464         _coin,
465         concat(
466             method_id("transfer(address,uint256)"),
467             convert(self.emergency_return, bytes32),
468             convert(amount, bytes32),
469         ),
470         max_outsize=32,
471     )
472     if len(response) != 0:
473         assert convert(response, bool)
474 
475     return True