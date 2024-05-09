1 # @version 0.2.4
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
49 
50 TOKENLESS_PRODUCTION: constant(uint256) = 40
51 BOOST_WARMUP: constant(uint256) = 2 * 7 * 86400
52 WEEK: constant(uint256) = 604800
53 
54 minter: public(address)
55 crv_token: public(address)
56 lp_token: public(address)
57 controller: public(address)
58 voting_escrow: public(address)
59 balanceOf: public(HashMap[address, uint256])
60 totalSupply: public(uint256)
61 future_epoch_time: public(uint256)
62 
63 # caller -> recipient -> can deposit?
64 approved_to_deposit: public(HashMap[address, HashMap[address, bool]])
65 
66 working_balances: public(HashMap[address, uint256])
67 working_supply: public(uint256)
68 
69 # The goal is to be able to calculate ∫(rate * balance / totalSupply dt) from 0 till checkpoint
70 # All values are kept in units of being multiplied by 1e18
71 period: public(int128)
72 period_timestamp: public(uint256[100000000000000000000000000000])
73 
74 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from 0 till checkpoint
75 integrate_inv_supply: public(uint256[100000000000000000000000000000])  # bump epoch when rate() changes
76 
77 # 1e18 * ∫(rate(t) / totalSupply(t) dt) from (last_action) till checkpoint
78 integrate_inv_supply_of: public(HashMap[address, uint256])
79 integrate_checkpoint_of: public(HashMap[address, uint256])
80 
81 
82 # ∫(balance * rate(t) / totalSupply(t) dt) from 0 till checkpoint
83 # Units: rate * t = already number of coins per address to issue
84 integrate_fraction: public(HashMap[address, uint256])
85 
86 inflation_rate: public(uint256)
87 
88 
89 @external
90 def __init__(lp_addr: address, _minter: address):
91     """
92     @notice Contract constructor
93     @param lp_addr Liquidity Pool contract address
94     @param _minter Minter contract address
95     """
96 
97     assert lp_addr != ZERO_ADDRESS
98     assert _minter != ZERO_ADDRESS
99 
100     self.lp_token = lp_addr
101     self.minter = _minter
102     crv_addr: address = Minter(_minter).token()
103     self.crv_token = crv_addr
104     controller_addr: address = Minter(_minter).controller()
105     self.controller = controller_addr
106     self.voting_escrow = Controller(controller_addr).voting_escrow()
107     self.period_timestamp[0] = block.timestamp
108     self.inflation_rate = CRV20(crv_addr).rate()
109     self.future_epoch_time = CRV20(crv_addr).future_epoch_time_write()
110 
111 
112 @internal
113 def _update_liquidity_limit(addr: address, l: uint256, L: uint256):
114     """
115     @notice Calculate limits which depend on the amount of CRV token per-user.
116             Effectively it calculates working balances to apply amplification
117             of CRV production by CRV
118     @param addr User address
119     @param l User's amount of liquidity (LP tokens)
120     @param L Total amount of liquidity (LP tokens)
121     """
122     # To be called after totalSupply is updated
123     _voting_escrow: address = self.voting_escrow
124     voting_balance: uint256 = ERC20(_voting_escrow).balanceOf(addr)
125     voting_total: uint256 = ERC20(_voting_escrow).totalSupply()
126 
127     lim: uint256 = l * TOKENLESS_PRODUCTION / 100
128     if (voting_total > 0) and (block.timestamp > self.period_timestamp[0] + BOOST_WARMUP):
129         lim += L * voting_balance / voting_total * (100 - TOKENLESS_PRODUCTION) / 100
130 
131     lim = min(l, lim)
132     old_bal: uint256 = self.working_balances[addr]
133     self.working_balances[addr] = lim
134     _working_supply: uint256 = self.working_supply + lim - old_bal
135     self.working_supply = _working_supply
136 
137     log UpdateLiquidityLimit(addr, l, L, lim, _working_supply)
138 
139 
140 @internal
141 def _checkpoint(addr: address):
142     """
143     @notice Checkpoint for a user
144     @param addr User address
145     """
146     _token: address = self.crv_token
147     _controller: address = self.controller
148     _period: int128 = self.period
149     _period_time: uint256 = self.period_timestamp[_period]
150     _integrate_inv_supply: uint256 = self.integrate_inv_supply[_period]
151     rate: uint256 = self.inflation_rate
152     new_rate: uint256 = rate
153     prev_future_epoch: uint256 = self.future_epoch_time
154     if prev_future_epoch >= _period_time:
155         self.future_epoch_time = CRV20(_token).future_epoch_time_write()
156         new_rate = CRV20(_token).rate()
157         self.inflation_rate = new_rate
158     Controller(_controller).checkpoint_gauge(self)
159 
160     _working_balance: uint256 = self.working_balances[addr]
161     _working_supply: uint256 = self.working_supply
162 
163     # Update integral of 1/supply
164     if block.timestamp > _period_time:
165         prev_week_time: uint256 = _period_time
166         week_time: uint256 = min((_period_time + WEEK) / WEEK * WEEK, block.timestamp)
167 
168         for i in range(500):
169             dt: uint256 = week_time - prev_week_time
170             w: uint256 = Controller(_controller).gauge_relative_weight(self, prev_week_time / WEEK * WEEK)
171 
172             if _working_supply > 0:
173                 if prev_future_epoch >= prev_week_time and prev_future_epoch < week_time:
174                     # If we went across one or multiple epochs, apply the rate
175                     # of the first epoch until it ends, and then the rate of
176                     # the last epoch.
177                     # If more than one epoch is crossed - the gauge gets less,
178                     # but that'd meen it wasn't called for more than 1 year
179                     _integrate_inv_supply += rate * w * (prev_future_epoch - prev_week_time) / _working_supply
180                     rate = new_rate
181                     _integrate_inv_supply += rate * w * (week_time - prev_future_epoch) / _working_supply
182                 else:
183                     _integrate_inv_supply += rate * w * dt / _working_supply
184                 # On precisions of the calculation
185                 # rate ~= 10e18
186                 # last_weight > 0.01 * 1e18 = 1e16 (if pool weight is 1%)
187                 # _working_supply ~= TVL * 1e18 ~= 1e26 ($100M for example)
188                 # The largest loss is at dt = 1
189                 # Loss is 1e-9 - acceptable
190 
191             if week_time == block.timestamp:
192                 break
193             prev_week_time = week_time
194             week_time = min(week_time + WEEK, block.timestamp)
195 
196     _period += 1
197     self.period = _period
198     self.period_timestamp[_period] = block.timestamp
199     self.integrate_inv_supply[_period] = _integrate_inv_supply
200 
201     # Update user-specific integrals
202     self.integrate_fraction[addr] += _working_balance * (_integrate_inv_supply - self.integrate_inv_supply_of[addr]) / 10 ** 18
203     self.integrate_inv_supply_of[addr] = _integrate_inv_supply
204     self.integrate_checkpoint_of[addr] = block.timestamp
205 
206 
207 @external
208 def user_checkpoint(addr: address) -> bool:
209     """
210     @notice Record a checkpoint for `addr`
211     @param addr User address
212     @return bool success
213     """
214     assert (msg.sender == addr) or (msg.sender == self.minter)  # dev: unauthorized
215     self._checkpoint(addr)
216     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
217     return True
218 
219 
220 @external
221 def claimable_tokens(addr: address) -> uint256:
222     """
223     @notice Get the number of claimable tokens per user
224     @dev This function should be manually changed to "view" in the ABI
225     @return uint256 number of claimable tokens per user
226     """
227     self._checkpoint(addr)
228     return self.integrate_fraction[addr] - Minter(self.minter).minted(addr, self)
229 
230 
231 @external
232 def kick(addr: address):
233     """
234     @notice Kick `addr` for abusing their boost
235     @dev Only if either they had another voting event, or their voting escrow lock expired
236     @param addr Address to kick
237     """
238     _voting_escrow: address = self.voting_escrow
239     t_last: uint256 = self.integrate_checkpoint_of[addr]
240     t_ve: uint256 = VotingEscrow(_voting_escrow).user_point_history__ts(
241         addr, VotingEscrow(_voting_escrow).user_point_epoch(addr)
242     )
243     _balance: uint256 = self.balanceOf[addr]
244 
245     assert ERC20(self.voting_escrow).balanceOf(addr) == 0 or t_ve > t_last # dev: kick not allowed
246     assert self.working_balances[addr] > _balance * TOKENLESS_PRODUCTION / 100  # dev: kick not needed
247 
248     self._checkpoint(addr)
249     self._update_liquidity_limit(addr, self.balanceOf[addr], self.totalSupply)
250 
251 
252 @external
253 def set_approve_deposit(addr: address, can_deposit: bool):
254     """
255     @notice Set whether `addr` can deposit tokens for `msg.sender`
256     @param addr Address to set approval on
257     @param can_deposit bool - can this account deposit for `msg.sender`?
258     """
259     self.approved_to_deposit[addr][msg.sender] = can_deposit
260 
261 
262 @external
263 @nonreentrant('lock')
264 def deposit(_value: uint256, addr: address = msg.sender):
265     """
266     @notice Deposit `_value` LP tokens
267     @param _value Number of tokens to deposit
268     @param addr Address to deposit for
269     """
270     if addr != msg.sender:
271         assert self.approved_to_deposit[msg.sender][addr], "Not approved"
272 
273     self._checkpoint(addr)
274 
275     if _value != 0:
276         _balance: uint256 = self.balanceOf[addr] + _value
277         _supply: uint256 = self.totalSupply + _value
278         self.balanceOf[addr] = _balance
279         self.totalSupply = _supply
280 
281         self._update_liquidity_limit(addr, _balance, _supply)
282 
283         assert ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
284 
285     log Deposit(addr, _value)
286 
287 
288 @external
289 @nonreentrant('lock')
290 def withdraw(_value: uint256):
291     """
292     @notice Withdraw `_value` LP tokens
293     @param _value Number of tokens to withdraw
294     """
295     self._checkpoint(msg.sender)
296 
297     _balance: uint256 = self.balanceOf[msg.sender] - _value
298     _supply: uint256 = self.totalSupply - _value
299     self.balanceOf[msg.sender] = _balance
300     self.totalSupply = _supply
301 
302     self._update_liquidity_limit(msg.sender, _balance, _supply)
303 
304     assert ERC20(self.lp_token).transfer(msg.sender, _value)
305 
306     log Withdraw(msg.sender, _value)
307 
308 
309 @external
310 @view
311 def integrate_checkpoint() -> uint256:
312     return self.period_timestamp[self.period]