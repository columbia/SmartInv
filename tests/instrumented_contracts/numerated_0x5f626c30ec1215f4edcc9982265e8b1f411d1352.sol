1 # @version 0.2.4
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
36     def claimReward(): nonpayable
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
111 is_claiming_rewards: public(bool)
112 
113 @external
114 def __init__(lp_addr: address, _minter: address, _reward_contract: address, _rewarded_token: address, _admin: address):
115     """
116     @notice Contract constructor
117     @param lp_addr Liquidity Pool contract address
118     @param _minter Minter contract address
119     @param _reward_contract Synthetix reward contract address
120     @param _rewarded_token Received synthetix token contract address
121     @param _admin Admin who can kill the gauge
122     """
123     assert lp_addr != ZERO_ADDRESS
124     assert _minter != ZERO_ADDRESS
125     assert _reward_contract != ZERO_ADDRESS
126 
127     self.lp_token = lp_addr
128     self.minter = _minter
129     crv_addr: address = Minter(_minter).token()
130     self.crv_token = crv_addr
131     controller_addr: address = Minter(_minter).controller()
132     self.controller = controller_addr
133     self.voting_escrow = Controller(controller_addr).voting_escrow()
134     self.period_timestamp[0] = block.timestamp
135     self.inflation_rate = CRV20(crv_addr).rate()
136     self.future_epoch_time = CRV20(crv_addr).future_epoch_time_write()
137     self.reward_contract = _reward_contract
138     assert ERC20(lp_addr).approve(_reward_contract, MAX_UINT256)
139     self.rewarded_token = _rewarded_token
140     self.admin = _admin
141     self.is_claiming_rewards = True
142 
143 
144 @internal
145 def _update_liquidity_limit(addr: address, l: uint256, L: uint256):
146     """
147     @notice Calculate limits which depend on the amount of CRV token per-user.
148             Effectively it calculates working balances to apply amplification
149             of CRV production by CRV
150     @param addr User address
151     @param l User's amount of liquidity (LP tokens)
152     @param L Total amount of liquidity (LP tokens)
153     """
154     # To be called after totalSupply is updated
155     _voting_escrow: address = self.voting_escrow
156     voting_balance: uint256 = ERC20(_voting_escrow).balanceOf(addr)
157     voting_total: uint256 = ERC20(_voting_escrow).totalSupply()
158 
159     lim: uint256 = l * TOKENLESS_PRODUCTION / 100
160     if (voting_total > 0) and (block.timestamp > self.period_timestamp[0] + BOOST_WARMUP):
161         lim += L * voting_balance / voting_total * (100 - TOKENLESS_PRODUCTION) / 100
162 
163     lim = min(l, lim)
164     old_bal: uint256 = self.working_balances[addr]
165     self.working_balances[addr] = lim
166     _working_supply: uint256 = self.working_supply + lim - old_bal
167     self.working_supply = _working_supply
168 
169     log UpdateLiquidityLimit(addr, l, L, lim, _working_supply)
170 
171 
172 @internal
173 def _checkpoint_rewards(addr: address, claim_rewards: bool):
174     # Update reward integrals (no gauge weights involved: easy)
175     _rewarded_token: address = self.rewarded_token
176 
177     d_reward: uint256 = 0
178     if claim_rewards:
179         d_reward = ERC20(_rewarded_token).balanceOf(self)
180         CurveRewards(self.reward_contract).claimReward()
181         d_reward = ERC20(_rewarded_token).balanceOf(self) - d_reward
182 
183     user_balance: uint256 = self.balanceOf[addr]
184     total_balance: uint256 = self.totalSupply
185     dI: uint256 = 0
186     if total_balance > 0:
187         dI = 10 ** 18 * d_reward / total_balance
188     I: uint256 = self.reward_integral + dI
189     self.reward_integral = I
190     self.rewards_for[addr] += user_balance * (I - self.reward_integral_for[addr]) / 10 ** 18
191     self.reward_integral_for[addr] = I
192 
193 
194 @internal
195 def _checkpoint(addr: address, claim_rewards: bool):
196     """
197     @notice Checkpoint for a user
198     @param addr User address
199     """
200     _token: address = self.crv_token
201     _controller: address = self.controller
202     _period: int128 = self.period
203     _period_time: uint256 = self.period_timestamp[_period]
204     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
205     rate: uint256 = self.inflation_rate
206     new_rate: uint256 = rate
207     prev_future_epoch: uint256 = self.future_epoch_time
208     if prev_future_epoch >= _period_time:
209         self.future_epoch_time = CRV20(_token).future_epoch_time_write()
210         new_rate = CRV20(_token).rate()
211         self.inflation_rate = new_rate
212     Controller(_controller).checkpoint_gauge(self)
213 
214     _working_balance: uint256 = self.working_balances[addr]
215     _working_supply: uint256 = self.working_supply
216 
217     if self.is_killed:
218         rate = 0  # Stop distributing inflation as soon as killed
219 
220     # Update integral of 1/supply
221     if block.timestamp > _period_time:
222         prev_week_time: uint256 = _period_time
223         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
224 
225         for i in range(500):
226             dt: uint256 = week_time - prev_week_time
227             w: uint256 = Controller(_controller).gauge_relative_weight(self, prev_week_time / WEEK * WEEK)
228 
229             if _working_supply > 0:
230                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
231                     # If we went across one or multiple epochs, apply the rate
232                     # of the first epoch until it ends, and then the rate of
233                     # the last epoch.
234                     # If more than one epoch is crossed - the gauge gets less,
235                     # but that'd meen it wasn't called for more than 1 year
236                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
237                     rate = new_rate
238                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
239                 else:
240                     _integrate_inv_supply += rate * w * dt / _working_supply
241                 # On precisions of the calculation
242                 # rate ~= 10e18
243                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
244                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
245                 # The largest loss is at dt = 1
246                 # Loss is 1e-9 - acceptable
247 
248             if week_time == block.timestamp:
249                 break
250             prev_week_time = week_time
251             week_time = min(week_time + WEEK, block.timestamp)
252 
253     _period += 1
254     self.period = _period
255     self.period_timestamp[_period] = block.timestamp
256     self.integrate_inv_supply[_period] = _integrate_inv_supply
257 
258     # Update user-specific integrals
259     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
260     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
261     self.integrate_checkpoint_of[addr] = block.timestamp
262 
263     self._checkpoint_rewards(addr, claim_rewards)
264 
265 
266 @external
267 def user_checkpoint(addr: address) -> bool:
268     """
269     @notice Record a checkpoint for `addr`
270     @param addr User address
271     @return bool success
272     """
273     assert (msg.sender == addr) or (msg.sender == self.minter)  # dev: unauthorized
274     self._checkpoint(addr, self.is_claiming_rewards)
275     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
276     return True
277 
278 
279 @external
280 def claimable_tokens(addr: address) -> uint256:
281     """
282     @notice Get the number of claimable tokens per user
283     @dev This function should be manually changed to "view" in the ABI
284     @return uint256 number of claimable tokens per user
285     """
286     self._checkpoint(addr, True)
287     return self.integrate_fraction[addr] - Minter(self.minter).minted(addr, self)
288 
289 
290 @external
291 @view
292 def claimable_reward(addr: address) -> uint256:
293     """
294     @notice Get the number of claimable reward tokens for a user
295     @param addr Account to get reward amount for
296     @return uint256 Claimable reward token amount
297     """
298     d_reward: uint256 = CurveRewards(self.reward_contract).earned(self)
299 
300     user_balance: uint256 = self.balanceOf[addr]
301     total_balance: uint256 = self.totalSupply
302     dI: uint256 = 0
303     if total_balance > 0:
304         dI = 10 ** 18 * d_reward / total_balance
305     I: uint256 = self.reward_integral + dI
306 
307     return self.rewards_for[addr] + user_balance * (I - self.reward_integral_for[addr]) / 10 ** 18
308 
309 
310 @external
311 def kick(addr: address):
312     """
313     @notice Kick `addr` for abusing their boost
314     @dev Only if either they had another voting event, or their voting escrow lock expired
315     @param addr Address to kick
316     """
317     _voting_escrow: address = self.voting_escrow
318     t_last: uint256 = self.integrate_checkpoint_of[addr]
319     t_ve: uint256 = VotingEscrow(_voting_escrow).user_point_history__ts(
320         addr, VotingEscrow(_voting_escrow).user_point_epoch(addr)
321     )
322     _balance: uint256 = self.balanceOf[addr]
323 
324     assert ERC20(self.voting_escrow).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
325     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
326 
327     self._checkpoint(addr, self.is_claiming_rewards)
328     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
329 
330 
331 @external
332 def set_approve_deposit(addr: address, can_deposit: bool):
333     """
334     @notice Set whether `addr` can deposit tokens for `msg.sender`
335     @param addr Address to set approval on
336     @param can_deposit bool - can this account deposit for `msg.sender`?
337     """
338     self.approved_to_deposit[addr][msg.sender] = can_deposit
339 
340 
341 @external
342 @nonreentrant('lock')
343 def deposit(_value: uint256, addr: address = msg.sender):
344     """
345     @notice Deposit `_value` LP tokens
346     @param _value Number of tokens to deposit
347     @param addr Address to deposit for
348     """
349     if addr != msg.sender:
350         assert self.approved_to_deposit[msg.sender][addr], "Not approved"
351 
352     self._checkpoint(addr, True)
353 
354     if _value != 0:
355         _balance: uint256 = self.balanceOf[addr] + _value
356         _supply: uint256 = self.totalSupply + _value
357         self.balanceOf[addr] = _balance
358         self.totalSupply = _supply
359 
360         self._update_liquidity_limit(addr, _balance, _supply)
361 
362         assert ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
363         CurveRewards(self.reward_contract).stake(_value)
364 
365     log Deposit(addr, _value)
366 
367 
368 @external
369 @nonreentrant('lock')
370 def withdraw(_value: uint256, claim_rewards: bool = True):
371     """
372     @notice Withdraw `_value` LP tokens
373     @param _value Number of tokens to withdraw
374     """
375     self._checkpoint(msg.sender, claim_rewards)
376 
377     _balance: uint256 = self.balanceOf[msg.sender] - _value
378     _supply: uint256 = self.totalSupply - _value
379     self.balanceOf[msg.sender] = _balance
380     self.totalSupply = _supply
381 
382     self._update_liquidity_limit(msg.sender, _balance, _supply)
383 
384     if _value > 0:
385         CurveRewards(self.reward_contract).withdraw(_value)
386         assert ERC20(self.lp_token).transfer(msg.sender, _value)
387 
388     log Withdraw(msg.sender, _value)
389 
390 
391 @external
392 @nonreentrant('lock')
393 def claim_rewards(addr: address = msg.sender):
394     self._checkpoint_rewards(addr, True)
395     _rewards_for: uint256 = self.rewards_for[addr]
396     assert ERC20(self.rewarded_token).transfer(
397         addr, _rewards_for - self.claimed_rewards_for[addr])
398     self.claimed_rewards_for[addr] = _rewards_for
399 
400 
401 @external
402 @view
403 def integrate_checkpoint() -> uint256:
404     return self.period_timestamp[self.period]
405 
406 
407 @external
408 def kill_me():
409     assert msg.sender == self.admin
410     self.is_killed = not self.is_killed
411 
412 
413 @external
414 def commit_transfer_ownership(addr: address):
415     """
416     @notice Transfer ownership of GaugeController to `addr`
417     @param addr Address to have ownership transferred to
418     """
419     assert msg.sender == self.admin  # dev: admin only
420     self.future_admin = addr
421     log CommitOwnership(addr)
422 
423 
424 @external
425 def apply_transfer_ownership():
426     """
427     @notice Apply pending ownership transfer
428     """
429     assert msg.sender == self.admin  # dev: admin only
430     _admin: address = self.future_admin
431     assert _admin != ZERO_ADDRESS  # dev: admin not set
432     self.admin = _admin
433     log ApplyOwnership(_admin)
434 
435 @external
436 def toggle_external_rewards_claim(val: bool):
437     """
438     @notice Switch claiming rewards on/off. 
439             This is to prevent a malicious rewards contract from preventing CRV claiming
440     """ 
441     assert msg.sender == self.admin
442     self.is_claiming_rewards = val