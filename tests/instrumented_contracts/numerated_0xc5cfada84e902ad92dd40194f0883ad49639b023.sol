1 # @version 0.2.5
2 """
3 @title Liquidity Gauge
4 @author Curve Finance
5 @license MIT
6 @notice Used for measuring liquidity and insurance
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
33 
34 event Deposit:
35     provider: indexed(address)
36     value: uint256
37 
38 event Withdraw:
39     provider: indexed(address)
40     value: uint256
41 
42 event UpdateLiquidityLimit:
43     user: address
44     original_balance: uint256
45     original_supply: uint256
46     working_balance: uint256
47     working_supply: uint256
48 
49 event CommitOwnership:
50     admin: address
51 
52 event ApplyOwnership:
53     admin: address
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
87 
88 # ∫(balance * rate(t) / totalSupply(t) dt) from 0 till checkpoint
89 # Units: rate * t = already number of coins per address to issue
90 integrate_fraction: public(HashMap[address, uint256])
91 
92 inflation_rate: public(uint256)
93 
94 admin: public(address)
95 future_admin: public(address)  # Can and will be a smart contract
96 is_killed: public(bool)
97 
98 
99 @external
100 def __init__(lp_addr: address, _minter: address, _admin: address):
101     """
102     @notice Contract constructor
103     @param lp_addr Liquidity Pool contract address
104     @param _minter Minter contract address
105     @param _admin Admin who can kill the gauge
106     """
107 
108     assert lp_addr != ZERO_ADDRESS
109     assert _minter != ZERO_ADDRESS
110 
111     self.lp_token = lp_addr
112     self.minter = _minter
113     crv_addr: address = Minter(_minter).token()
114     self.crv_token = crv_addr
115     controller_addr: address = Minter(_minter).controller()
116     self.controller = controller_addr
117     self.voting_escrow = Controller(controller_addr).voting_escrow()
118     self.period_timestamp[0] = block.timestamp
119     self.inflation_rate = CRV20(crv_addr).rate()
120     self.future_epoch_time = CRV20(crv_addr).future_epoch_time_write()
121     self.admin = _admin
122 
123 
124 @internal
125 def _update_liquidity_limit(addr: address, l: uint256, L: uint256):
126     """
127     @notice Calculate limits which depend on the amount of CRV token per-user.
128             Effectively it calculates working balances to apply amplification
129             of CRV production by CRV
130     @param addr User address
131     @param l User's amount of liquidity (LP tokens)
132     @param L Total amount of liquidity (LP tokens)
133     """
134     # To be called after totalSupply is updated
135     _voting_escrow: address = self.voting_escrow
136     voting_balance: uint256 = ERC20(_voting_escrow).balanceOf(addr)
137     voting_total: uint256 = ERC20(_voting_escrow).totalSupply()
138 
139     lim: uint256 = l * TOKENLESS_PRODUCTION / 100
140     if (voting_total > 0) and (block.timestamp > self.period_timestamp[0] + BOOST_WARMUP):
141         lim += L * voting_balance / voting_total * (100 - TOKENLESS_PRODUCTION) / 100
142 
143     lim = min(l, lim)
144     old_bal: uint256 = self.working_balances[addr]
145     self.working_balances[addr] = lim
146     _working_supply: uint256 = self.working_supply + lim - old_bal
147     self.working_supply = _working_supply
148 
149     log UpdateLiquidityLimit(addr, l, L, lim, _working_supply)
150 
151 
152 @internal
153 def _checkpoint(addr: address):
154     """
155     @notice Checkpoint for a user
156     @param addr User address
157     """
158     _token: address = self.crv_token
159     _controller: address = self.controller
160     _period: int128 = self.period
161     _period_time: uint256 = self.period_timestamp[_period]
162     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
163     rate: uint256 = self.inflation_rate
164     new_rate: uint256 = rate
165     prev_future_epoch: uint256 = self.future_epoch_time
166     if prev_future_epoch >= _period_time:
167         self.future_epoch_time = CRV20(_token).future_epoch_time_write()
168         new_rate = CRV20(_token).rate()
169         self.inflation_rate = new_rate
170     Controller(_controller).checkpoint_gauge(self)
171 
172     _working_balance: uint256 = self.working_balances[addr]
173     _working_supply: uint256 = self.working_supply
174 
175     if self.is_killed:
176         # Stop distributing inflation as soon as killed
177         rate = 0
178 
179     # Update integral of 1/supply
180     if block.timestamp > _period_time:
181         prev_week_time: uint256 = _period_time
182         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
183 
184         for i in range(500):
185             dt: uint256 = week_time - prev_week_time
186             w: uint256 = Controller(_controller).gauge_relative_weight(self, prev_week_time / WEEK * WEEK)
187 
188             if _working_supply > 0:
189                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
190                     # If we went across one or multiple epochs, apply the rate
191                     # of the first epoch until it ends, and then the rate of
192                     # the last epoch.
193                     # If more than one epoch is crossed - the gauge gets less,
194                     # but that'd meen it wasn't called for more than 1 year
195                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
196                     rate = new_rate
197                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
198                 else:
199                     _integrate_inv_supply += rate * w * dt / _working_supply
200                 # On precisions of the calculation
201                 # rate ~= 10e18
202                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
203                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
204                 # The largest loss is at dt = 1
205                 # Loss is 1e-9 - acceptable
206 
207             if week_time == block.timestamp:
208                 break
209             prev_week_time = week_time
210             week_time = min(week_time + WEEK, block.timestamp)
211 
212     _period += 1
213     self.period = _period
214     self.period_timestamp[_period] = block.timestamp
215     self.integrate_inv_supply[_period] = _integrate_inv_supply
216 
217     # Update user-specific integrals
218     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
219     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
220     self.integrate_checkpoint_of[addr] = block.timestamp
221 
222 
223 @external
224 def user_checkpoint(addr: address) -> bool:
225     """
226     @notice Record a checkpoint for `addr`
227     @param addr User address
228     @return bool success
229     """
230     assert (msg.sender == addr) or (msg.sender == self.minter)  # dev: unauthorized
231     self._checkpoint(addr)
232     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
233     return True
234 
235 
236 @external
237 def claimable_tokens(addr: address) -> uint256:
238     """
239     @notice Get the number of claimable tokens per user
240     @dev This function should be manually changed to "view" in the ABI
241     @return uint256 number of claimable tokens per user
242     """
243     self._checkpoint(addr)
244     return self.integrate_fraction[addr] - Minter(self.minter).minted(addr, self)
245 
246 
247 @external
248 def kick(addr: address):
249     """
250     @notice Kick `addr` for abusing their boost
251     @dev Only if either they had another voting event, or their voting escrow lock expired
252     @param addr Address to kick
253     """
254     _voting_escrow: address = self.voting_escrow
255     t_last: uint256 = self.integrate_checkpoint_of[addr]
256     t_ve: uint256 = VotingEscrow(_voting_escrow).user_point_history__ts(
257         addr, VotingEscrow(_voting_escrow).user_point_epoch(addr)
258     )
259     _balance: uint256 = self.balanceOf[addr]
260 
261     assert ERC20(self.voting_escrow).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
262     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
263 
264     self._checkpoint(addr)
265     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
266 
267 
268 @external
269 def set_approve_deposit(addr: address, can_deposit: bool):
270     """
271     @notice Set whether `addr` can deposit tokens for `msg.sender`
272     @param addr Address to set approval on
273     @param can_deposit bool - can this account deposit for `msg.sender`?
274     """
275     self.approved_to_deposit[addr][msg.sender] = can_deposit
276 
277 
278 @external
279 @nonreentrant('lock')
280 def deposit(_value: uint256, addr: address = msg.sender):
281     """
282     @notice Deposit `_value` LP tokens
283     @param _value Number of tokens to deposit
284     @param addr Address to deposit for
285     """
286     if addr != msg.sender:
287         assert self.approved_to_deposit[msg.sender][addr], "Not approved"
288 
289     self._checkpoint(addr)
290 
291     if _value != 0:
292         _balance: uint256 = self.balanceOf[addr] + _value
293         _supply: uint256 = self.totalSupply + _value
294         self.balanceOf[addr] = _balance
295         self.totalSupply = _supply
296 
297         self._update_liquidity_limit(addr, _balance, _supply)
298 
299         assert ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
300 
301     log Deposit(addr, _value)
302 
303 
304 @external
305 @nonreentrant('lock')
306 def withdraw(_value: uint256):
307     """
308     @notice Withdraw `_value` LP tokens
309     @param _value Number of tokens to withdraw
310     """
311     self._checkpoint(msg.sender)
312 
313     _balance: uint256 = self.balanceOf[msg.sender] - _value
314     _supply: uint256 = self.totalSupply - _value
315     self.balanceOf[msg.sender] = _balance
316     self.totalSupply = _supply
317 
318     self._update_liquidity_limit(msg.sender, _balance, _supply)
319 
320     assert ERC20(self.lp_token).transfer(msg.sender, _value)
321 
322     log Withdraw(msg.sender, _value)
323 
324 
325 @external
326 @view
327 def integrate_checkpoint() -> uint256:
328     return self.period_timestamp[self.period]
329 
330 
331 @external
332 def kill_me():
333     assert msg.sender == self.admin
334     self.is_killed = not self.is_killed
335 
336 
337 @external
338 def commit_transfer_ownership(addr: address):
339     """
340     @notice Transfer ownership of GaugeController to `addr`
341     @param addr Address to have ownership transferred to
342     """
343     assert msg.sender == self.admin  # dev: admin only
344     self.future_admin = addr
345     log CommitOwnership(addr)
346 
347 
348 @external
349 def apply_transfer_ownership():
350     """
351     @notice Apply pending ownership transfer
352     """
353     assert msg.sender == self.admin  # dev: admin only
354     _admin: address = self.future_admin
355     assert _admin != ZERO_ADDRESS  # dev: admin not set
356     self.admin = _admin
357     log ApplyOwnership(_admin)