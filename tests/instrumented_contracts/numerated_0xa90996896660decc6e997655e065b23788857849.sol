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
55 
56 TOKENLESS_PRODUCTION: constant(uint256) = 40
57 BOOST_WARMUP: constant(uint256) = 2 * 7 * 86400
58 WEEK: constant(uint256) = 604800
59 
60 minter: public(address)
61 crv_token: public(address)
62 lp_token: public(address)
63 controller: public(address)
64 voting_escrow: public(address)
65 balanceOf: public(HashMap[address, uint256])
66 totalSupply: public(uint256)
67 future_epoch_time: public(uint256)
68 
69 # caller -> recipient -> can deposit?
70 approved_to_deposit: public(HashMap[address, HashMap[address, bool]])
71 
72 working_balances: public(HashMap[address, uint256])
73 working_supply: public(uint256)
74 
75 # The goal is to be able to calculate ∫(rate * balance / totalSupply dt) from 0 till checkpoint
76 # All values are kept in units of being multiplied by 1e18
77 period: public(int128)
78 period_timestamp: public(uint256[100000000000000000000000000000])
79 
80 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from 0 till checkpoint
81 integrate_inv_supply: public(uint256[100000000000000000000000000000])  # bump epoch when rate() changes
82 
83 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from (last_action) till checkpoint
84 integrate_inv_supply_of: public(HashMap[address, uint256])
85 integrate_checkpoint_of: public(HashMap[address, uint256])
86 
87 # ∫(balance * rate(t) / totalSupply(t) dt) from 0 till checkpoint
88 # Units: rate * t = already number of coins per address to issue
89 integrate_fraction: public(HashMap[address, uint256])
90 
91 inflation_rate: public(uint256)
92 
93 # For tracking external rewards
94 reward_contract: public(address)
95 rewarded_token: public(address)
96 
97 reward_integral: public(uint256)
98 reward_integral_for: public(HashMap[address, uint256])
99 rewards_for: public(HashMap[address, uint256])
100 claimed_rewards_for: public(HashMap[address, uint256])
101 
102 
103 @external
104 def __init__(lp_addr: address, _minter: address, _reward_contract: address, _rewarded_token: address):
105     """
106     @notice Contract constructor
107     @param lp_addr Liquidity Pool contract address
108     @param _minter Minter contract address
109     @param _reward_contract Synthetix reward contract address
110     @param _rewarded_token Received synthetix token contract address
111     """
112     assert lp_addr != ZERO_ADDRESS
113     assert _minter != ZERO_ADDRESS
114     assert _reward_contract != ZERO_ADDRESS
115 
116     self.lp_token = lp_addr
117     self.minter = _minter
118     crv_addr: address = Minter(_minter).token()
119     self.crv_token = crv_addr
120     controller_addr: address = Minter(_minter).controller()
121     self.controller = controller_addr
122     self.voting_escrow = Controller(controller_addr).voting_escrow()
123     self.period_timestamp[0] = block.timestamp
124     self.inflation_rate = CRV20(crv_addr).rate()
125     self.future_epoch_time = CRV20(crv_addr).future_epoch_time_write()
126     self.reward_contract = _reward_contract
127     assert ERC20(lp_addr).approve(_reward_contract, MAX_UINT256)
128     self.rewarded_token = _rewarded_token
129 
130 
131 @internal
132 def _update_liquidity_limit(addr: address, l: uint256, L: uint256):
133     """
134     @notice Calculate limits which depend on the amount of CRV token per-user.
135             Effectively it calculates working balances to apply amplification
136             of CRV production by CRV
137     @param addr User address
138     @param l User's amount of liquidity (LP tokens)
139     @param L Total amount of liquidity (LP tokens)
140     """
141     # To be called after totalSupply is updated
142     _voting_escrow: address = self.voting_escrow
143     voting_balance: uint256 = ERC20(_voting_escrow).balanceOf(addr)
144     voting_total: uint256 = ERC20(_voting_escrow).totalSupply()
145 
146     lim: uint256 = l * TOKENLESS_PRODUCTION / 100
147     if (voting_total > 0) and (block.timestamp > self.period_timestamp[0] + BOOST_WARMUP):
148         lim += L * voting_balance / voting_total * (100 - TOKENLESS_PRODUCTION) / 100
149 
150     lim = min(l, lim)
151     old_bal: uint256 = self.working_balances[addr]
152     self.working_balances[addr] = lim
153     _working_supply: uint256 = self.working_supply + lim - old_bal
154     self.working_supply = _working_supply
155 
156     log UpdateLiquidityLimit(addr, l, L, lim, _working_supply)
157 
158 
159 @internal
160 def _checkpoint_rewards(addr: address, claim_rewards: bool):
161     # Update reward integrals (no gauge weights involved: easy)
162     _rewarded_token: address = self.rewarded_token
163 
164     d_reward: uint256 = 0
165     if claim_rewards:
166         d_reward = ERC20(_rewarded_token).balanceOf(self)
167         CurveRewards(self.reward_contract).getReward()
168         d_reward = ERC20(_rewarded_token).balanceOf(self) - d_reward
169 
170     user_balance: uint256 = self.balanceOf[addr]
171     total_balance: uint256 = self.totalSupply
172     dI: uint256 = 0
173     if total_balance > 0:
174         dI = 10 ** 18 * d_reward / total_balance
175     I: uint256 = self.reward_integral + dI
176     self.reward_integral = I
177     self.rewards_for[addr] += user_balance * (I - self.reward_integral_for[addr]) / 10 ** 18
178     self.reward_integral_for[addr] = I
179 
180 
181 @internal
182 def _checkpoint(addr: address, claim_rewards: bool):
183     """
184     @notice Checkpoint for a user
185     @param addr User address
186     """
187     _token: address = self.crv_token
188     _controller: address = self.controller
189     _period: int128 = self.period
190     _period_time: uint256 = self.period_timestamp[_period]
191     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
192     rate: uint256 = self.inflation_rate
193     new_rate: uint256 = rate
194     prev_future_epoch: uint256 = self.future_epoch_time
195     if prev_future_epoch >= _period_time:
196         self.future_epoch_time = CRV20(_token).future_epoch_time_write()
197         new_rate = CRV20(_token).rate()
198         self.inflation_rate = new_rate
199     Controller(_controller).checkpoint_gauge(self)
200 
201     _working_balance: uint256 = self.working_balances[addr]
202     _working_supply: uint256 = self.working_supply
203 
204     # Update integral of 1/supply
205     if block.timestamp > _period_time:
206         prev_week_time: uint256 = _period_time
207         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
208 
209         for i in range(500):
210             dt: uint256 = week_time - prev_week_time
211             w: uint256 = Controller(_controller).gauge_relative_weight(self, prev_week_time / WEEK * WEEK)
212 
213             if _working_supply > 0:
214                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
215                     # If we went across one or multiple epochs, apply the rate
216                     # of the first epoch until it ends, and then the rate of
217                     # the last epoch.
218                     # If more than one epoch is crossed - the gauge gets less,
219                     # but that'd meen it wasn't called for more than 1 year
220                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
221                     rate = new_rate
222                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
223                 else:
224                     _integrate_inv_supply += rate * w * dt / _working_supply
225                 # On precisions of the calculation
226                 # rate ~= 10e18
227                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
228                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
229                 # The largest loss is at dt = 1
230                 # Loss is 1e-9 - acceptable
231 
232             if week_time == block.timestamp:
233                 break
234             prev_week_time = week_time
235             week_time = min(week_time + WEEK, block.timestamp)
236 
237     _period += 1
238     self.period = _period
239     self.period_timestamp[_period] = block.timestamp
240     self.integrate_inv_supply[_period] = _integrate_inv_supply
241 
242     # Update user-specific integrals
243     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
244     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
245     self.integrate_checkpoint_of[addr] = block.timestamp
246 
247     self._checkpoint_rewards(addr, claim_rewards)
248 
249 
250 @external
251 def user_checkpoint(addr: address) -> bool:
252     """
253     @notice Record a checkpoint for `addr`
254     @param addr User address
255     @return bool success
256     """
257     assert (msg.sender == addr) or (msg.sender == self.minter)  # dev: unauthorized
258     self._checkpoint(addr, True)
259     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
260     return True
261 
262 
263 @external
264 def claimable_tokens(addr: address) -> uint256:
265     """
266     @notice Get the number of claimable tokens per user
267     @dev This function should be manually changed to "view" in the ABI
268     @return uint256 number of claimable tokens per user
269     """
270     self._checkpoint(addr, True)
271     return self.integrate_fraction[addr] - Minter(self.minter).minted(addr, self)
272 
273 
274 @external
275 @view
276 def claimable_reward(addr: address) -> uint256:
277     """
278     @notice Get the number of claimable reward tokens for a user
279     @param addr Account to get reward amount for
280     @return uint256 Claimable reward token amount
281     """
282     d_reward: uint256 = CurveRewards(self.reward_contract).earned(self)
283 
284     user_balance: uint256 = self.balanceOf[addr]
285     total_balance: uint256 = self.totalSupply
286     dI: uint256 = 0
287     if total_balance > 0:
288         dI = 10 ** 18 * d_reward / total_balance
289     I: uint256 = self.reward_integral + dI
290 
291     return self.rewards_for[addr] + user_balance * (I - self.reward_integral_for[addr]) / 10 ** 18
292 
293 
294 @external
295 def kick(addr: address):
296     """
297     @notice Kick `addr` for abusing their boost
298     @dev Only if either they had another voting event, or their voting escrow lock expired
299     @param addr Address to kick
300     """
301     _voting_escrow: address = self.voting_escrow
302     t_last: uint256 = self.integrate_checkpoint_of[addr]
303     t_ve: uint256 = VotingEscrow(_voting_escrow).user_point_history__ts(
304         addr, VotingEscrow(_voting_escrow).user_point_epoch(addr)
305     )
306     _balance: uint256 = self.balanceOf[addr]
307 
308     assert ERC20(self.voting_escrow).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
309     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
310 
311     self._checkpoint(addr, True)
312     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
313 
314 
315 @external
316 def set_approve_deposit(addr: address, can_deposit: bool):
317     """
318     @notice Set whether `addr` can deposit tokens for `msg.sender`
319     @param addr Address to set approval on
320     @param can_deposit bool - can this account deposit for `msg.sender`?
321     """
322     self.approved_to_deposit[addr][msg.sender] = can_deposit
323 
324 
325 @external
326 @nonreentrant('lock')
327 def deposit(_value: uint256, addr: address = msg.sender):
328     """
329     @notice Deposit `_value` LP tokens
330     @param _value Number of tokens to deposit
331     @param addr Address to deposit for
332     """
333     if addr != msg.sender:
334         assert self.approved_to_deposit[msg.sender][addr], "Not approved"
335 
336     self._checkpoint(addr, True)
337 
338     if _value != 0:
339         _balance: uint256 = self.balanceOf[addr] + _value
340         _supply: uint256 = self.totalSupply + _value
341         self.balanceOf[addr] = _balance
342         self.totalSupply = _supply
343 
344         self._update_liquidity_limit(addr, _balance, _supply)
345 
346         assert ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
347         CurveRewards(self.reward_contract).stake(_value)
348 
349     log Deposit(addr, _value)
350 
351 
352 @external
353 @nonreentrant('lock')
354 def withdraw(_value: uint256, claim_rewards: bool = True):
355     """
356     @notice Withdraw `_value` LP tokens
357     @param _value Number of tokens to withdraw
358     """
359     self._checkpoint(msg.sender, claim_rewards)
360 
361     _balance: uint256 = self.balanceOf[msg.sender] - _value
362     _supply: uint256 = self.totalSupply - _value
363     self.balanceOf[msg.sender] = _balance
364     self.totalSupply = _supply
365 
366     self._update_liquidity_limit(msg.sender, _balance, _supply)
367 
368     if _value > 0:
369         CurveRewards(self.reward_contract).withdraw(_value)
370         assert ERC20(self.lp_token).transfer(msg.sender, _value)
371 
372     log Withdraw(msg.sender, _value)
373 
374 
375 @external
376 @nonreentrant('lock')
377 def claim_rewards(addr: address = msg.sender):
378     self._checkpoint_rewards(addr, True)
379     _rewards_for: uint256 = self.rewards_for[addr]
380     assert ERC20(self.rewarded_token).transfer(
381         addr, _rewards_for - self.claimed_rewards_for[addr])
382     self.claimed_rewards_for[addr] = _rewards_for
383 
384 
385 @external
386 @view
387 def integrate_checkpoint() -> uint256:
388     return self.period_timestamp[self.period]