1 # @version 0.2.5
2 """
3 @title Staking Liquidity Gauge
4 @author Curve Finance
5 @license MIT
6 @notice Simultaneously stakes using Synthetix (== YFI) rewards contract
7 """
8 
9 from vyper.interfaces import ERC20
10 
11 interface CRV20:
12     def future_epoch_time_write() -> uint256: nonpayable
13     def rate() -> uint256: view
14 
15 interface Controller:
16     def period() -> int128: view
17     def period_write() -> int128: nonpayable
18     def period_timestamp(p: int128) -> uint256: view
19     def gauge_relative_weight(addr: address, time: uint256) -> uint256: view
20     def voting_escrow() -> address: view
21     def checkpoint(): nonpayable
22     def checkpoint_gauge(addr: address): nonpayable
23 
24 interface Minter:
25     def token() -> address: view
26     def controller() -> address: view
27     def minted(user: address, gauge: address) -> uint256: view
28 
29 interface VotingEscrow:
30     def user_point_epoch(addr: address) -> uint256: view
31     def user_point_history__ts(addr: address, epoch: uint256) -> uint256: view
32 
33 interface CurveRewards:
34     def stake(amount: uint256): nonpayable
35     def withdraw(amount: uint256): nonpayable
36     def getReward(): nonpayable
37     def earned(addr: address) -> uint256: view
38 
39 
40 event Deposit:
41     provider: indexed(address)
42     value: uint256
43 
44 event Withdraw:
45     provider: indexed(address)
46     value: uint256
47 
48 event UpdateLiquidityLimit:
49     user: address
50     original_balance: uint256
51     original_supply: uint256
52     working_balance: uint256
53     working_supply: uint256
54 
55 event CommitOwnership:
56     admin: address
57 
58 event ApplyOwnership:
59     admin: address
60 
61 
62 TOKENLESS_PRODUCTION: constant(uint256) = 40
63 BOOST_WARMUP: constant(uint256) = 2 * 7 * 86400
64 WEEK: constant(uint256) = 604800
65 
66 minter: public(address)
67 crv_token: public(address)
68 lp_token: public(address)
69 controller: public(address)
70 voting_escrow: public(address)
71 balanceOf: public(HashMap[address, uint256])
72 totalSupply: public(uint256)
73 future_epoch_time: public(uint256)
74 
75 # caller -> recipient -> can deposit?
76 approved_to_deposit: public(HashMap[address, HashMap[address, bool]])
77 
78 working_balances: public(HashMap[address, uint256])
79 working_supply: public(uint256)
80 
81 # The goal is to be able to calculate ∫(rate * balance / totalSupply dt) from 0 till checkpoint
82 # All values are kept in units of being multiplied by 1e18
83 period: public(int128)
84 period_timestamp: public(uint256[100000000000000000000000000000])
85 
86 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from 0 till checkpoint
87 integrate_inv_supply: public(uint256[100000000000000000000000000000])  # bump epoch when rate() changes
88 
89 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from (last_action) till checkpoint
90 integrate_inv_supply_of: public(HashMap[address, uint256])
91 integrate_checkpoint_of: public(HashMap[address, uint256])
92 
93 # ∫(balance * rate(t) / totalSupply(t) dt) from 0 till checkpoint
94 # Units: rate * t = already number of coins per address to issue
95 integrate_fraction: public(HashMap[address, uint256])
96 
97 inflation_rate: public(uint256)
98 
99 # For tracking external rewards
100 reward_contract: public(address)
101 rewarded_token: public(address)
102 
103 reward_integral: public(uint256)
104 reward_integral_for: public(HashMap[address, uint256])
105 rewards_for: public(HashMap[address, uint256])
106 claimed_rewards_for: public(HashMap[address, uint256])
107 
108 admin: public(address)
109 future_admin: public(address)  # Can and will be a smart contract
110 is_killed: public(bool)
111 
112 @external
113 def __init__(lp_addr: address, _minter: address, _reward_contract: address, _rewarded_token: address, _admin: address):
114     """
115     @notice Contract constructor
116     @param lp_addr Liquidity Pool contract address
117     @param _minter Minter contract address
118     @param _reward_contract Synthetix reward contract address
119     @param _rewarded_token Received synthetix token contract address
120     @param _admin Admin who can kill the gauge
121     """
122     assert lp_addr != ZERO_ADDRESS
123     assert _minter != ZERO_ADDRESS
124     assert _reward_contract != ZERO_ADDRESS
125 
126     self.lp_token = lp_addr
127     self.minter = _minter
128     crv_addr: address = Minter(_minter).token()
129     self.crv_token = crv_addr
130     controller_addr: address = Minter(_minter).controller()
131     self.controller = controller_addr
132     self.voting_escrow = Controller(controller_addr).voting_escrow()
133     self.period_timestamp[0] = block.timestamp
134     self.inflation_rate = CRV20(crv_addr).rate()
135     self.future_epoch_time = CRV20(crv_addr).future_epoch_time_write()
136     self.reward_contract = _reward_contract
137     assert ERC20(lp_addr).approve(_reward_contract, MAX_UINT256)
138     self.rewarded_token = _rewarded_token
139     self.admin = _admin
140 
141 
142 @internal
143 def _update_liquidity_limit(addr: address, l: uint256, L: uint256):
144     """
145     @notice Calculate limits which depend on the amount of CRV token per-user.
146             Effectively it calculates working balances to apply amplification
147             of CRV production by CRV
148     @param addr User address
149     @param l User's amount of liquidity (LP tokens)
150     @param L Total amount of liquidity (LP tokens)
151     """
152     # To be called after totalSupply is updated
153     _voting_escrow: address = self.voting_escrow
154     voting_balance: uint256 = ERC20(_voting_escrow).balanceOf(addr)
155     voting_total: uint256 = ERC20(_voting_escrow).totalSupply()
156 
157     lim: uint256 = l * TOKENLESS_PRODUCTION / 100
158     if (voting_total > 0) and (block.timestamp > self.period_timestamp[0] + BOOST_WARMUP):
159         lim += L * voting_balance / voting_total * (100 - TOKENLESS_PRODUCTION) / 100
160 
161     lim = min(l, lim)
162     old_bal: uint256 = self.working_balances[addr]
163     self.working_balances[addr] = lim
164     _working_supply: uint256 = self.working_supply + lim - old_bal
165     self.working_supply = _working_supply
166 
167     log UpdateLiquidityLimit(addr, l, L, lim, _working_supply)
168 
169 
170 @internal
171 def _checkpoint_rewards(addr: address, claim_rewards: bool):
172     # Update reward integrals (no gauge weights involved: easy)
173     _rewarded_token: address = self.rewarded_token
174 
175     d_reward: uint256 = 0
176     if claim_rewards:
177         d_reward = ERC20(_rewarded_token).balanceOf(self)
178         CurveRewards(self.reward_contract).getReward()
179         d_reward = ERC20(_rewarded_token).balanceOf(self) - d_reward
180 
181     user_balance: uint256 = self.balanceOf[addr]
182     total_balance: uint256 = self.totalSupply
183     dI: uint256 = 0
184     if total_balance > 0:
185         dI = 10 ** 18 * d_reward / total_balance
186     I: uint256 = self.reward_integral + dI
187     self.reward_integral = I
188     self.rewards_for[addr] += user_balance * (I - self.reward_integral_for[addr]) / 10 ** 18
189     self.reward_integral_for[addr] = I
190 
191 
192 @internal
193 def _checkpoint(addr: address, claim_rewards: bool):
194     """
195     @notice Checkpoint for a user
196     @param addr User address
197     """
198     _token: address = self.crv_token
199     _controller: address = self.controller
200     _period: int128 = self.period
201     _period_time: uint256 = self.period_timestamp[_period]
202     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
203     rate: uint256 = self.inflation_rate
204     new_rate: uint256 = rate
205     prev_future_epoch: uint256 = self.future_epoch_time
206     if prev_future_epoch >= _period_time:
207         self.future_epoch_time = CRV20(_token).future_epoch_time_write()
208         new_rate = CRV20(_token).rate()
209         self.inflation_rate = new_rate
210     Controller(_controller).checkpoint_gauge(self)
211 
212     _working_balance: uint256 = self.working_balances[addr]
213     _working_supply: uint256 = self.working_supply
214 
215     if self.is_killed:
216         # Stop distributing inflation as soon as killed
217         rate = 0
218 
219     # Update integral of 1/supply
220     if block.timestamp > _period_time:
221         prev_week_time: uint256 = _period_time
222         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
223 
224         for i in range(500):
225             dt: uint256 = week_time - prev_week_time
226             w: uint256 = Controller(_controller).gauge_relative_weight(self, prev_week_time / WEEK * WEEK)
227 
228             if _working_supply > 0:
229                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
230                     # If we went across one or multiple epochs, apply the rate
231                     # of the first epoch until it ends, and then the rate of
232                     # the last epoch.
233                     # If more than one epoch is crossed - the gauge gets less,
234                     # but that'd meen it wasn't called for more than 1 year
235                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
236                     rate = new_rate
237                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
238                 else:
239                     _integrate_inv_supply += rate * w * dt / _working_supply
240                 # On precisions of the calculation
241                 # rate ~= 10e18
242                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
243                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
244                 # The largest loss is at dt = 1
245                 # Loss is 1e-9 - acceptable
246 
247             if week_time == block.timestamp:
248                 break
249             prev_week_time = week_time
250             week_time = min(week_time + WEEK, block.timestamp)
251 
252     _period += 1
253     self.period = _period
254     self.period_timestamp[_period] = block.timestamp
255     self.integrate_inv_supply[_period] = _integrate_inv_supply
256 
257     # Update user-specific integrals
258     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
259     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
260     self.integrate_checkpoint_of[addr] = block.timestamp
261 
262     self._checkpoint_rewards(addr, claim_rewards)
263 
264 
265 @external
266 def user_checkpoint(addr: address) -> bool:
267     """
268     @notice Record a checkpoint for `addr`
269     @param addr User address
270     @return bool success
271     """
272     assert (msg.sender == addr) or (msg.sender == self.minter)  # dev: unauthorized
273     self._checkpoint(addr, True)
274     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
275     return True
276 
277 
278 @external
279 def claimable_tokens(addr: address) -> uint256:
280     """
281     @notice Get the number of claimable tokens per user
282     @dev This function should be manually changed to "view" in the ABI
283     @return uint256 number of claimable tokens per user
284     """
285     self._checkpoint(addr, True)
286     return self.integrate_fraction[addr] - Minter(self.minter).minted(addr, self)
287 
288 
289 @external
290 @view
291 def claimable_reward(addr: address) -> uint256:
292     """
293     @notice Get the number of claimable reward tokens for a user
294     @param addr Account to get reward amount for
295     @return uint256 Claimable reward token amount
296     """
297     d_reward: uint256 = CurveRewards(self.reward_contract).earned(self)
298 
299     user_balance: uint256 = self.balanceOf[addr]
300     total_balance: uint256 = self.totalSupply
301     dI: uint256 = 0
302     if total_balance > 0:
303         dI = 10 ** 18 * d_reward / total_balance
304     I: uint256 = self.reward_integral + dI
305 
306     return self.rewards_for[addr] + user_balance * (I - self.reward_integral_for[addr]) / 10 ** 18
307 
308 
309 @external
310 def kick(addr: address):
311     """
312     @notice Kick `addr` for abusing their boost
313     @dev Only if either they had another voting event, or their voting escrow lock expired
314     @param addr Address to kick
315     """
316     _voting_escrow: address = self.voting_escrow
317     t_last: uint256 = self.integrate_checkpoint_of[addr]
318     t_ve: uint256 = VotingEscrow(_voting_escrow).user_point_history__ts(
319         addr, VotingEscrow(_voting_escrow).user_point_epoch(addr)
320     )
321     _balance: uint256 = self.balanceOf[addr]
322 
323     assert ERC20(self.voting_escrow).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
324     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
325 
326     self._checkpoint(addr, True)
327     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
328 
329 
330 @external
331 def set_approve_deposit(addr: address, can_deposit: bool):
332     """
333     @notice Set whether `addr` can deposit tokens for `msg.sender`
334     @param addr Address to set approval on
335     @param can_deposit bool - can this account deposit for `msg.sender`?
336     """
337     self.approved_to_deposit[addr][msg.sender] = can_deposit
338 
339 
340 @external
341 @nonreentrant('lock')
342 def deposit(_value: uint256, addr: address = msg.sender):
343     """
344     @notice Deposit `_value` LP tokens
345     @param _value Number of tokens to deposit
346     @param addr Address to deposit for
347     """
348     if addr != msg.sender:
349         assert self.approved_to_deposit[msg.sender][addr], "Not approved"
350 
351     self._checkpoint(addr, True)
352 
353     if _value != 0:
354         _balance: uint256 = self.balanceOf[addr] + _value
355         _supply: uint256 = self.totalSupply + _value
356         self.balanceOf[addr] = _balance
357         self.totalSupply = _supply
358 
359         self._update_liquidity_limit(addr, _balance, _supply)
360 
361         assert ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
362         CurveRewards(self.reward_contract).stake(_value)
363 
364     log Deposit(addr, _value)
365 
366 
367 @external
368 @nonreentrant('lock')
369 def withdraw(_value: uint256, claim_rewards: bool = True):
370     """
371     @notice Withdraw `_value` LP tokens
372     @param _value Number of tokens to withdraw
373     """
374     self._checkpoint(msg.sender, claim_rewards)
375 
376     _balance: uint256 = self.balanceOf[msg.sender] - _value
377     _supply: uint256 = self.totalSupply - _value
378     self.balanceOf[msg.sender] = _balance
379     self.totalSupply = _supply
380 
381     self._update_liquidity_limit(msg.sender, _balance, _supply)
382 
383     if _value > 0:
384         CurveRewards(self.reward_contract).withdraw(_value)
385         assert ERC20(self.lp_token).transfer(msg.sender, _value)
386 
387     log Withdraw(msg.sender, _value)
388 
389 
390 @external
391 @nonreentrant('lock')
392 def claim_rewards(addr: address = msg.sender):
393     self._checkpoint_rewards(addr, True)
394     _rewards_for: uint256 = self.rewards_for[addr]
395     assert ERC20(self.rewarded_token).transfer(
396         addr, _rewards_for - self.claimed_rewards_for[addr])
397     self.claimed_rewards_for[addr] = _rewards_for
398 
399 
400 @external
401 @view
402 def integrate_checkpoint() -> uint256:
403     return self.period_timestamp[self.period]
404 
405 
406 @external
407 def kill_me():
408     assert msg.sender == self.admin
409     self.is_killed = not self.is_killed
410 
411 
412 @external
413 def commit_transfer_ownership(addr: address):
414     """
415     @notice Transfer ownership of GaugeController to `addr`
416     @param addr Address to have ownership transferred to
417     """
418     assert msg.sender == self.admin  # dev: admin only
419     self.future_admin = addr
420     log CommitOwnership(addr)
421 
422 
423 @external
424 def apply_transfer_ownership():
425     """
426     @notice Apply pending ownership transfer
427     """
428     assert msg.sender == self.admin  # dev: admin only
429     _admin: address = self.future_admin
430     assert _admin != ZERO_ADDRESS  # dev: admin not set
431     self.admin = _admin
432     log ApplyOwnership(_admin)