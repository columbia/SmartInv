1 # @version 0.3.1
2 """
3 @title Guild
4 @author Versailles heroes
5 @license MIT
6 @notice Used for measuring owner and members rewards
7 """
8 
9 from vyper.interfaces import ERC20
10 
11 interface VRH20:
12     def future_epoch_time_write() -> uint256: nonpayable
13     def rate() -> uint256: view
14 
15 interface GuildController:
16     def guild_relative_weight(addr: address, time: uint256) -> uint256: view
17     def get_guild_weight(addr: address) -> uint256: view
18     def add_member(guild_addr: address, user_addr: address): nonpayable
19     def remove_member(user_addr: address): nonpayable
20     def voting_escrow() -> address: view
21     def gas_type_escrow(token: address) -> address: view
22     def checkpoint_guild(addr: address): nonpayable
23     def refresh_guild_votes(user_addr: address, guild_addr: address): nonpayable
24     def belongs_to_guild(user_addr: address, guild_addr: address) -> bool: view
25 
26 interface Minter:
27     def minted(user: address, guild: address) -> uint256: view
28     def controller() -> address: view
29     def token() -> address: view
30     def rewardVestingEscrow() -> address: view
31 
32 interface VotingEscrow:
33     def user_point_epoch(addr: address) -> uint256: view
34     def user_point_history__ts(addr: address, epoch: uint256) -> uint256: view
35 
36 interface GasEscrow:
37     def user_point_epoch(addr: address) -> uint256: view
38     def user_point_history__ts(addr: address, epoch: uint256) -> uint256: view
39 
40 interface RewardVestingEscrow:
41     def claimable_tokens(addr: address) -> uint256: nonpayable
42 
43 
44 DECIMALS: constant(uint256) = 10 ** 18
45 
46 TOKENLESS_PRODUCTION: constant(uint256) = 40
47 
48 minter: public(address)
49 vrh_token: public(address)
50 controller: public(address)
51 voting_escrow: public(address)
52 gas_escrow: public(address)
53 future_epoch_time: public(uint256)
54 
55 working_balances: public(HashMap[address, uint256])
56 working_supply: public(uint256)
57 period_timestamp: public(uint256[100000000000000000000000000000])
58 period: public(int128)
59 
60 last_change_rate: public(uint256)
61 
62 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from 0 till checkpoint
63 integrate_inv_supply: public(uint256[100000000000000000000000000000])  # bump epoch when rate() changes
64 
65 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from (last_action) till checkpoint
66 integrate_inv_supply_of: public(HashMap[address, uint256])
67 integrate_checkpoint_of: public(HashMap[address, uint256])
68 
69 # ∫(balance * rate(t) / totalSupply(t) dt) from 0 till checkpoint
70 # Units: rate * t = already number of coins per address to issue
71 integrate_fraction: public(HashMap[address, uint256])
72 
73 inflation_rate: public(uint256)
74 is_paused: public(bool)
75 WEEK: constant(uint256) = 604800
76 DAY: constant(uint256) = 86400
77 
78 # guild variables
79 owner: public(address) # guild owner address
80 
81 # Proportion of what the guild owner gets
82 commission_rate: public(HashMap[uint256, uint256])  # time -> commission_rate
83 total_owner_bonus: public(HashMap[address, uint256]) # owner address -> owner bonus
84 
85 event UpdateLiquidityLimit:
86     user: address
87     original_balance: uint256
88     original_supply: uint256
89     working_balance: uint256
90     working_supply: uint256
91 
92 event TriggerPause:
93     guild: address
94     pause: bool
95 
96 event SetCommissionRate:
97     commission_rate: uint256
98     effective_time: uint256
99 
100 @external
101 def __init__():
102     self.owner = msg.sender
103 
104 
105 @external
106 @nonreentrant('lock')
107 def initialize(_owner: address, _commission_rate: uint256, _token: address, _gas_escrow: address, _minter: address) -> bool:
108 
109     #@notice Initialize the contract to create a guild
110     assert self.owner == ZERO_ADDRESS  # dev: can only initialize once
111 
112     self.is_paused = False
113     self.owner = _owner
114     self.period_timestamp[0] = block.timestamp
115 
116     assert _minter != ZERO_ADDRESS
117     self.minter = _minter
118 
119     self.vrh_token = _token
120     _controller: address = Minter(_minter).controller()
121     self.controller = _controller
122     self.voting_escrow = GuildController(_controller).voting_escrow()
123 
124     assert _gas_escrow != ZERO_ADDRESS
125     self.gas_escrow = _gas_escrow
126 
127     assert _commission_rate >= 0 and _commission_rate <= 20, 'Rate has to be minimally 0% and maximum 20%'
128     next_time: uint256 = (block.timestamp + WEEK) / WEEK * WEEK
129     self.commission_rate[next_time] = _commission_rate
130     self.last_change_rate = next_time # Record last updated commission rate
131     self.inflation_rate = VRH20(self.vrh_token).rate()
132     self.future_epoch_time = VRH20(self.vrh_token).future_epoch_time_write()
133 
134     return True
135 
136 
137 @internal
138 def _get_commission_rate():
139     """
140     @notice Fill historic commission rate week-over-week for missed checkins
141             and return the commission rate for the future week
142     """
143     t: uint256 = self.last_change_rate
144     if t > 0:
145         w: uint256 = self.commission_rate[t]
146         for i in range(500):
147             if t > block.timestamp:
148                 break
149             t += WEEK
150             self.commission_rate[t] = w
151 
152 
153 @internal
154 def _checkpoint(addr: address):
155     """
156     @notice Checkpoint for a user
157     @param addr User address
158     """
159     _token: address = self.vrh_token
160     _controller: address = self.controller
161     _period: int128 = self.period
162     _period_time: uint256 = self.period_timestamp[_period]
163     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
164     _owner_bonus: uint256 = 0
165 
166     rate: uint256 = self.inflation_rate
167     new_rate: uint256 = rate
168     prev_future_epoch: uint256 = self.future_epoch_time
169     if prev_future_epoch >= _period_time:
170         self.future_epoch_time = VRH20(_token).future_epoch_time_write()
171         new_rate = VRH20(_token).rate()
172         self.inflation_rate = new_rate
173 
174     GuildController(_controller).checkpoint_guild(self)
175 
176     _working_balance: uint256 = self.working_balances[addr]
177     _working_supply: uint256 = self.working_supply
178     
179     if self.is_paused:
180         rate = 0  # Stop distributing inflation as soon as paused
181 
182     # Update integral of 1/supply
183     if block.timestamp > _period_time:
184         prev_week_time: uint256 = _period_time
185         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
186 
187         # Fill missing check-in for commission rate
188         self._get_commission_rate()
189 
190         for i in range(500):
191             dt: uint256 = week_time - prev_week_time
192             w: uint256 = GuildController(_controller).guild_relative_weight(self, prev_week_time / WEEK * WEEK)
193             commission_rate: uint256 = self.commission_rate[prev_week_time / WEEK * WEEK]
194 
195             if _working_supply > 0:
196                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
197                     # If we went across one or multiple epochs, apply the rate
198                     # of the first epoch until it ends, and then the rate of
199                     # the last epoch.
200                     # If more than one epoch is crossed - the gauge gets less,
201                     # but that'd meen it wasn't called for more than 1 year
202                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply * (100 - commission_rate) / 100
203                     _owner_bonus += rate * w * (prev_future_epoch - prev_week_time) * commission_rate / 100
204                     
205                     rate = new_rate
206                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply * (100 - commission_rate) / 100
207                     _owner_bonus += rate * w * (week_time - prev_future_epoch) * commission_rate / 100
208                 else:
209                     _integrate_inv_supply += rate * w * dt / _working_supply * (100 - commission_rate) / 100
210                     _owner_bonus += rate * w * dt * commission_rate / 100
211                     
212                 # On precisions of the calculation
213                 # rate ~= 10e18
214                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
215                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
216                 # The largest loss is at dt = 1
217                 # Loss is 1e-9 - acceptable
218 
219             if week_time == block.timestamp:
220                 break
221             prev_week_time = week_time
222             week_time = min(week_time + WEEK, block.timestamp)
223 
224     _period += 1
225     self.period = _period
226     self.period_timestamp[_period] = block.timestamp
227     self.integrate_inv_supply[_period] = _integrate_inv_supply
228 
229     # Update user-specific integrals
230     # calculate owner bonus
231     if _owner_bonus > 0:
232         self.integrate_fraction[self.owner] += _owner_bonus / 10 ** 18
233         self.total_owner_bonus[self.owner] += _owner_bonus / 10 ** 18
234 
235     # calculate for all members (including owner)
236     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
237     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
238     self.integrate_checkpoint_of[addr] = block.timestamp
239 
240 
241 @external
242 def set_commission_rate(increase: bool):
243     assert self.owner == msg.sender,'Only guild owner can change commission rate'
244     assert block.timestamp >= self.last_change_rate, "Can only change commission rate once every week"
245     
246     next_time: uint256 = (block.timestamp + WEEK) / WEEK * WEEK
247     commission_rate: uint256 = self.commission_rate[self.last_change_rate]
248 
249     # 0 == decrease, 1 equals increase
250     if increase == True :
251         commission_rate += 1
252         assert commission_rate <= 20, 'Maximum is 20'
253     else:
254         commission_rate -= 1
255         assert commission_rate >= 0, 'Minimum is 0'
256     
257     self.commission_rate[next_time] = commission_rate
258     self.last_change_rate = next_time
259     log SetCommissionRate(commission_rate, next_time)
260 
261 
262 @internal
263 def _update_liquidity_limit(addr: address, bu: uint256, S: uint256):
264     """
265     @notice Calculate limits which depend on the amount of VRH token per-user.
266             Effectively it calculates working balances to apply amplification
267             of veVRH production by gas
268     @param addr User address
269     @param bu User's amount of veVRH
270     @param S Total amount of veVRH in a guild
271     """
272     # To be called after totalSupply is updated
273     _gas_escrow: address = self.gas_escrow
274     wi: uint256 = ERC20(_gas_escrow).balanceOf(addr) # gas balance of a user
275     W: uint256 = ERC20(_gas_escrow).totalSupply() # gas total of all users
276 
277     lim: uint256 = bu * TOKENLESS_PRODUCTION / 100 # 0.4bu
278 
279     # Boost portion below : game tokens (gas)
280     if (S > 0) and wi > 0:
281         lim += S * wi / W * (100 - TOKENLESS_PRODUCTION) / 100
282 
283     lim = min(bu, lim)
284     old_bal: uint256 = self.working_balances[addr]
285     self.working_balances[addr] = lim
286     _working_supply: uint256 = self.working_supply + lim - old_bal
287     self.working_supply = _working_supply
288 
289     log UpdateLiquidityLimit(addr, bu, S, lim, _working_supply)
290 
291 
292 @external
293 def user_checkpoint(addr: address) -> bool:
294     """
295     @notice Record a checkpoint for `addr`
296     @param addr User address
297     @return bool success
298     """
299     assert (msg.sender == addr) or (msg.sender == self.minter)  # dev: unauthorized
300 
301     # check that user truly belongs to guild
302     _controller: address = self.controller
303     assert GuildController(_controller).belongs_to_guild(addr, self), "Not in guild"
304     
305     _user_voting_power: uint256 = ERC20(self.voting_escrow).balanceOf(addr)
306     if _user_voting_power != 0:
307         GuildController(_controller).refresh_guild_votes(addr, self)
308     self._checkpoint(addr)
309     _guild_voting_power: uint256 = GuildController(_controller).get_guild_weight(self)
310     self._update_liquidity_limit(addr, _user_voting_power, _guild_voting_power)
311     
312     return True
313 
314 
315 @external
316 def update_working_balance(addr: address) -> bool:
317     """
318     @notice Record a checkpoint for `addr`
319     @param addr User address
320     @return bool success
321     """
322     assert msg.sender == self.minter  # dev: unauthorized
323 
324     _controller: address = self.controller
325     assert GuildController(_controller).belongs_to_guild(addr, self), "Not in guild"
326 
327     self._checkpoint(addr)
328     _user_voting_power: uint256 = ERC20(self.voting_escrow).balanceOf(addr)
329     _guild_voting_power: uint256 = GuildController(_controller).get_guild_weight(self)
330     self._update_liquidity_limit(addr, _user_voting_power, _guild_voting_power)
331     return True
332 
333 
334 @external
335 def claimable_tokens(addr: address) -> uint256:
336     """
337     @notice Get the number of claimable tokens per user
338     @dev This function should be manually changed to "view" in the ABI
339     @return uint256 number of claimable tokens per user
340     """
341     self._checkpoint(addr)
342     _rewardVestingEscrow: address = Minter(self.minter).rewardVestingEscrow()
343     _reward_vesting_claimable: uint256 = RewardVestingEscrow(_rewardVestingEscrow).claimable_tokens(addr)
344     return self.integrate_fraction[addr] - Minter(self.minter).minted(addr, self) + _reward_vesting_claimable
345 
346 
347 @external
348 def kick(addr: address):
349     """
350     @notice Kick `addr` for abusing their boost
351     @dev Only if either they had abusing gas boost, or their voting escrow lock expired
352     @param addr Address to kick
353     """
354 
355     _voting_escrow: address = self.voting_escrow
356     _gas_escrow: address = self.gas_escrow
357     t_last: uint256 = self.integrate_checkpoint_of[addr]
358     t_gas: uint256 = GasEscrow(_gas_escrow).user_point_history__ts(
359         addr, GasEscrow(_gas_escrow).user_point_epoch(addr))
360     _balance: uint256 = ERC20(self.voting_escrow).balanceOf(addr)
361     _gas_balance: uint256 = ERC20(self.gas_escrow).balanceOf(addr)
362 
363     assert (_balance == 0) or (_gas_balance == 0 or t_gas > t_last)  # dev: kick not allowed
364     assert self.working_balances[addr] > _balance * 2 * TOKENLESS_PRODUCTION / 100 # dev: kick not needed
365 
366     self._checkpoint(addr)
367     _user_voting_power: uint256 = _balance
368     _guild_voting_power: uint256 = GuildController(self.controller).get_guild_weight(self)
369     self._update_liquidity_limit(addr, _user_voting_power, _guild_voting_power)
370 
371 
372 @external
373 @nonreentrant('lock')
374 def join_guild():
375     """
376     @notice Join into this guild and start mining
377     """
378     addr: address = msg.sender
379     GuildController(self.controller).add_member(self, addr)
380     self._checkpoint(addr)
381     _user_voting_power: uint256 = ERC20(self.voting_escrow).balanceOf(addr)
382     _guild_voting_power: uint256 = GuildController(self.controller).get_guild_weight(self)
383     self._update_liquidity_limit(addr, _user_voting_power, _guild_voting_power)
384 
385 
386 @external
387 @nonreentrant('lock')
388 def leave_guild():
389     """
390     @notice Leave this guild and stop mining
391     """
392     GuildController(self.controller).remove_member(msg.sender)
393     _user_voting_power: uint256 = 0 # set user's working balance to 0 after minting remaining and leave guild
394     _guild_voting_power: uint256 = GuildController(self.controller).get_guild_weight(self)
395     self._update_liquidity_limit(msg.sender, _user_voting_power, _guild_voting_power)
396 
397 
398 @external
399 def transfer_ownership(new_owner: address):
400     """
401     @notice Transfer ownership of Guild to `new_owner`
402     @param new_owner Address to have ownership transferred to
403     """
404     assert msg.sender == self.controller # only GuildController can access this
405     old_owner: address = self.owner
406     self._checkpoint(old_owner) # updates current owner integrate fraction and bonus before transferring ownership
407     _user_voting_power: uint256 = ERC20(self.voting_escrow).balanceOf(old_owner)
408     _guild_voting_power: uint256 = GuildController(self.controller).get_guild_weight(self)
409     self._update_liquidity_limit(old_owner, _user_voting_power, _guild_voting_power)
410     self.owner = new_owner
411 
412 
413 @external
414 def toggle_pause():
415     assert msg.sender == self.controller # only GuildController can access this
416     self.is_paused = not self.is_paused
417 
418     log TriggerPause(self, self.is_paused)