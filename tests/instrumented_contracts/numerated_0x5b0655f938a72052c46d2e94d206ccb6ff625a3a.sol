1 # @version 0.3.1
2 """
3 @title Token Minter
4 @author Curve Finance
5 @license MIT
6 """
7 
8 interface LiquidityGauge:
9     # Presumably, other gauges will provide the same interfaces
10     def integrate_fraction(addr: address) -> uint256: view
11     def user_checkpoint(addr: address) -> bool: nonpayable
12 
13 interface ERC20:
14     def transfer(to: address, amount: uint256) -> bool: nonpayable
15     def balanceOf(account: address) -> uint256: nonpayable
16 
17 interface GaugeController:
18     def gauge_types(addr: address) -> int128: view
19 
20 event Minted:
21     recipient: indexed(address)
22     gauge: address
23     minted: uint256
24 
25 event UpdateMiningParameters:
26     time: uint256
27     rate: uint256
28 
29 event CommitNextEmission:
30     rate: uint256
31 
32 event CommitEmergencyReturn:
33     admin: address
34 
35 event ApplyEmergencyReturn:
36     admin: address
37 
38 event CommitOwnership:
39     admin: address
40 
41 event ApplyOwnership:
42     admin: address
43 
44 # General constants
45 WEEK: constant(uint256) = 86400 * 7
46 
47 # 250K RBN / WEEK
48 INITIAL_RATE: constant(uint256) = 250_000 * 10 ** 18 / WEEK
49 # Weekly
50 MAX_ABS_RATE: constant(uint256) = 10_000_000 * 10 ** 18
51 RATE_REDUCTION_TIME: constant(uint256) = WEEK * 2
52 INFLATION_DELAY: constant(uint256) = 86400
53 
54 mining_epoch: public(int128)
55 start_epoch_time: public(uint256)
56 rate: public(uint256)
57 committed_rate: public(uint256)
58 is_start: public(bool)
59 
60 token: public(address)
61 controller: public(address)
62 
63 # user -> gauge -> value
64 minted: public(HashMap[address, HashMap[address, uint256]])
65 
66 # minter -> user -> can mint?
67 allowed_to_mint_for: public(HashMap[address, HashMap[address, bool]])
68 
69 future_emergency_return: public(address)
70 emergency_return: public(address)
71 admin: public(address)  # Can and will be a smart contract
72 future_admin: public(address)  # Can and will be a smart contract
73 
74 @external
75 def __init__(_token: address, _controller: address, _emergency_return: address, _admin: address):
76     self.token = _token
77     self.controller = _controller
78     self.emergency_return = _emergency_return
79     self.admin = _admin
80 
81     self.start_epoch_time = block.timestamp + INFLATION_DELAY - RATE_REDUCTION_TIME
82     self.mining_epoch = -1
83     self.is_start = True
84     self.committed_rate = MAX_UINT256
85 
86 
87 @internal
88 def _update_mining_parameters():
89     """
90     @dev Update mining rate and supply at the start of the epoch
91          Any modifying mining call must also call this
92     """
93     _rate: uint256 = self.rate
94 
95     self.start_epoch_time += RATE_REDUCTION_TIME
96     self.mining_epoch += 1
97 
98     if _rate == 0 and self.is_start:
99         _rate = INITIAL_RATE
100         self.is_start = False
101     else:
102         _committed_rate: uint256 = self.committed_rate
103         if _committed_rate != MAX_UINT256:
104           _rate = _committed_rate
105           self.committed_rate = MAX_UINT256
106 
107     self.rate = _rate
108 
109     log UpdateMiningParameters(block.timestamp, _rate)
110 
111 @external
112 def update_mining_parameters():
113     """
114     @notice Update mining rate and supply at the start of the epoch
115     @dev Callable by any address, but only once per epoch
116          Total supply becomes slightly larger if this function is called late
117     """
118     assert block.timestamp >= self.start_epoch_time + RATE_REDUCTION_TIME  # dev: too soon!
119     self._update_mining_parameters()
120 
121 @external
122 def start_epoch_time_write() -> uint256:
123     """
124     @notice Get timestamp of the current mining epoch start
125             while simultaneously updating mining parameters
126     @return Timestamp of the epoch
127     """
128     _start_epoch_time: uint256 = self.start_epoch_time
129     if block.timestamp >= _start_epoch_time + RATE_REDUCTION_TIME:
130         self._update_mining_parameters()
131         return self.start_epoch_time
132     else:
133         return _start_epoch_time
134 
135 @external
136 def future_epoch_time_write() -> uint256:
137     """
138     @notice Get timestamp of the next mining epoch start
139             while simultaneously updating mining parameters
140     @return Timestamp of the next epoch
141     """
142     _start_epoch_time: uint256 = self.start_epoch_time
143     if block.timestamp >= _start_epoch_time + RATE_REDUCTION_TIME:
144         self._update_mining_parameters()
145         return self.start_epoch_time + RATE_REDUCTION_TIME
146     else:
147         return _start_epoch_time + RATE_REDUCTION_TIME
148 
149 @internal
150 def _mint_for(gauge_addr: address, _for: address):
151     assert GaugeController(self.controller).gauge_types(gauge_addr) >= 0  # dev: gauge is not added
152 
153     LiquidityGauge(gauge_addr).user_checkpoint(_for)
154     total_mint: uint256 = LiquidityGauge(gauge_addr).integrate_fraction(_for)
155     to_mint: uint256 = total_mint - self.minted[_for][gauge_addr]
156 
157     if to_mint != 0:
158         ERC20(self.token).transfer(_for, to_mint)
159         if block.timestamp >= self.start_epoch_time + RATE_REDUCTION_TIME:
160           self._update_mining_parameters()
161         self.minted[_for][gauge_addr] = total_mint
162 
163         log Minted(_for, gauge_addr, total_mint)
164 
165 
166 @external
167 @nonreentrant('lock')
168 def mint(gauge_addr: address):
169     """
170     @notice Mint everything which belongs to `msg.sender` and send to them
171     @param gauge_addr `LiquidityGauge` address to get mintable amount from
172     """
173     self._mint_for(gauge_addr, msg.sender)
174 
175 
176 @external
177 @nonreentrant('lock')
178 def mint_many(gauge_addrs: address[8]):
179     """
180     @notice Mint everything which belongs to `msg.sender` across multiple gauges
181     @param gauge_addrs List of `LiquidityGauge` addresses
182     """
183     for i in range(8):
184         if gauge_addrs[i] == ZERO_ADDRESS:
185             break
186         self._mint_for(gauge_addrs[i], msg.sender)
187 
188 
189 @external
190 @nonreentrant('lock')
191 def mint_for(gauge_addr: address, _for: address):
192     """
193     @notice Mint tokens for `_for`
194     @dev Only possible when `msg.sender` has been approved via `toggle_approve_mint`
195     @param gauge_addr `LiquidityGauge` address to get mintable amount from
196     @param _for Address to mint to
197     """
198     if self.allowed_to_mint_for[msg.sender][_for]:
199         self._mint_for(gauge_addr, _for)
200 
201 
202 @external
203 def toggle_approve_mint(minting_user: address):
204     """
205     @notice allow `minting_user` to mint for `msg.sender`
206     @param minting_user Address to toggle permission for
207     """
208     self.allowed_to_mint_for[minting_user][msg.sender] = not self.allowed_to_mint_for[minting_user][msg.sender]
209 
210 @external
211 def recover_balance(_coin: address) -> bool:
212     """
213     @notice Recover ERC20 tokens from this contract
214     @dev Tokens are sent to the emergency return address.
215     @param _coin Token address
216     @return bool success
217     """
218     assert msg.sender == self.admin # dev: admin only
219 
220     amount: uint256 = ERC20(_coin).balanceOf(self)
221     response: Bytes[32] = raw_call(
222         _coin,
223         concat(
224             method_id("transfer(address,uint256)"),
225             convert(self.emergency_return, bytes32),
226             convert(amount, bytes32),
227         ),
228         max_outsize=32,
229     )
230     if len(response) != 0:
231         assert convert(response, bool)
232 
233     return True
234 
235 @external
236 def commit_next_emission(_rate_per_week: uint256):
237   """
238   @notice Commit a new rate for the following week (we update by weeks).
239           _rate_per_week should have no decimals (ex: if we want to reward 600_000 RBN over the course of a week, we pass in 600_000 * 10 ** 18)
240   """
241   assert msg.sender == self.admin # dev: admin only
242   assert _rate_per_week <= MAX_ABS_RATE # dev: preventing fatfinger
243   new_rate: uint256 = _rate_per_week / WEEK
244   self.committed_rate = new_rate
245   log CommitNextEmission(new_rate)
246 
247 @external
248 def commit_transfer_emergency_return(addr: address):
249     """
250     @notice Update emergency ret. of Minter to `addr`
251     @param addr Address to have emergency ret. transferred to
252     """
253     assert msg.sender == self.admin  # dev: admin only
254     self.future_emergency_return = addr
255     log CommitEmergencyReturn(addr)
256 
257 @external
258 def apply_transfer_emergency_return():
259     """
260     @notice Apply pending emergency ret. update
261     """
262     assert msg.sender == self.admin  # dev: admin only
263     _emergency_return: address = self.future_emergency_return
264     assert _emergency_return != ZERO_ADDRESS  # dev: emergency return not set
265     self.emergency_return = _emergency_return
266     log ApplyEmergencyReturn(_emergency_return)
267 
268 @external
269 def commit_transfer_ownership(addr: address):
270     """
271     @notice Transfer ownership of GaugeController to `addr`
272     @param addr Address to have ownership transferred to
273     """
274     assert msg.sender == self.admin  # dev: admin only
275     self.future_admin = addr
276     log CommitOwnership(addr)
277 
278 @external
279 def apply_transfer_ownership():
280     """
281     @notice Apply pending ownership transfer
282     """
283     assert msg.sender == self.admin  # dev: admin only
284     _admin: address = self.future_admin
285     assert _admin != ZERO_ADDRESS  # dev: admin not set
286     self.admin = _admin
287     log ApplyOwnership(_admin)