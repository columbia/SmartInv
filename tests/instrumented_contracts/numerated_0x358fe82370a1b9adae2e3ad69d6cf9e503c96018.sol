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
47 # 1.25M SDL / WEEK
48 INITIAL_RATE: constant(uint256) = 1_250_000 * 10 ** 18 / WEEK
49 # Weekly
50 MAX_ABS_RATE: constant(uint256) = 10_000_000 * 10 ** 18
51 RATE_REDUCTION_TIME: constant(uint256) = WEEK * 2
52 
53 mining_epoch: public(int128)
54 start_epoch_time: public(uint256)
55 rate: public(uint256)
56 committed_rate: public(uint256)
57 is_start: public(bool)
58 
59 token: public(address)
60 controller: public(address)
61 
62 # user -> gauge -> value
63 minted: public(HashMap[address, HashMap[address, uint256]])
64 
65 # minter -> user -> can mint?
66 allowed_to_mint_for: public(HashMap[address, HashMap[address, bool]])
67 
68 future_emergency_return: public(address)
69 emergency_return: public(address)
70 admin: public(address)  # Can and will be a smart contract
71 future_admin: public(address)  # Can and will be a smart contract
72 
73 @external
74 def __init__(_token: address, _controller: address, _emergency_return: address, _admin: address):
75     self.token = _token
76     self.controller = _controller
77     self.emergency_return = _emergency_return
78     self.admin = _admin
79 
80     self.start_epoch_time = block.timestamp - RATE_REDUCTION_TIME
81     self.mining_epoch = -1
82     self.is_start = True
83     self.committed_rate = MAX_UINT256
84 
85 
86 @internal
87 def _update_mining_parameters():
88     """
89     @dev Update mining rate and supply at the start of the epoch
90          Any modifying mining call must also call this
91     """
92     _rate: uint256 = self.rate
93 
94     self.start_epoch_time += RATE_REDUCTION_TIME
95     self.mining_epoch += 1
96 
97     if _rate == 0 and self.is_start:
98         _rate = INITIAL_RATE
99         self.is_start = False
100     else:
101         _committed_rate: uint256 = self.committed_rate
102         if _committed_rate != MAX_UINT256:
103           _rate = _committed_rate
104           self.committed_rate = MAX_UINT256
105 
106     self.rate = _rate
107 
108     log UpdateMiningParameters(block.timestamp, _rate)
109 
110 @external
111 def update_mining_parameters():
112     """
113     @notice Update mining rate and supply at the start of the epoch
114     @dev Callable by any address, but only once per epoch
115          Total supply becomes slightly larger if this function is called late
116     """
117     assert block.timestamp >= self.start_epoch_time + RATE_REDUCTION_TIME  # dev: too soon!
118     self._update_mining_parameters()
119 
120 @external
121 def start_epoch_time_write() -> uint256:
122     """
123     @notice Get timestamp of the current mining epoch start
124             while simultaneously updating mining parameters
125     @return Timestamp of the epoch
126     """
127     _start_epoch_time: uint256 = self.start_epoch_time
128     if block.timestamp >= _start_epoch_time + RATE_REDUCTION_TIME:
129         self._update_mining_parameters()
130         return self.start_epoch_time
131     else:
132         return _start_epoch_time
133 
134 @external
135 def future_epoch_time_write() -> uint256:
136     """
137     @notice Get timestamp of the next mining epoch start
138             while simultaneously updating mining parameters
139     @return Timestamp of the next epoch
140     """
141     _start_epoch_time: uint256 = self.start_epoch_time
142     if block.timestamp >= _start_epoch_time + RATE_REDUCTION_TIME:
143         self._update_mining_parameters()
144         return self.start_epoch_time + RATE_REDUCTION_TIME
145     else:
146         return _start_epoch_time + RATE_REDUCTION_TIME
147 
148 @internal
149 def _mint_for(gauge_addr: address, _for: address):
150     assert GaugeController(self.controller).gauge_types(gauge_addr) >= 0  # dev: gauge is not added
151 
152     LiquidityGauge(gauge_addr).user_checkpoint(_for)
153     total_mint: uint256 = LiquidityGauge(gauge_addr).integrate_fraction(_for)
154     to_mint: uint256 = total_mint - self.minted[_for][gauge_addr]
155 
156     if to_mint != 0:
157         ERC20(self.token).transfer(_for, to_mint)
158         if block.timestamp >= self.start_epoch_time + RATE_REDUCTION_TIME:
159           self._update_mining_parameters()
160         self.minted[_for][gauge_addr] = total_mint
161 
162         log Minted(_for, gauge_addr, total_mint)
163 
164 
165 @external
166 @nonreentrant('lock')
167 def mint(gauge_addr: address):
168     """
169     @notice Mint everything which belongs to `msg.sender` and send to them
170     @param gauge_addr `LiquidityGauge` address to get mintable amount from
171     """
172     self._mint_for(gauge_addr, msg.sender)
173 
174 
175 @external
176 @nonreentrant('lock')
177 def mint_many(gauge_addrs: address[8]):
178     """
179     @notice Mint everything which belongs to `msg.sender` across multiple gauges
180     @param gauge_addrs List of `LiquidityGauge` addresses
181     """
182     for i in range(8):
183         if gauge_addrs[i] == ZERO_ADDRESS:
184             break
185         self._mint_for(gauge_addrs[i], msg.sender)
186 
187 
188 @external
189 @nonreentrant('lock')
190 def mint_for(gauge_addr: address, _for: address):
191     """
192     @notice Mint tokens for `_for`
193     @dev Only possible when `msg.sender` has been approved via `toggle_approve_mint`
194     @param gauge_addr `LiquidityGauge` address to get mintable amount from
195     @param _for Address to mint to
196     """
197     if self.allowed_to_mint_for[msg.sender][_for]:
198         self._mint_for(gauge_addr, _for)
199 
200 
201 @external
202 def toggle_approve_mint(minting_user: address):
203     """
204     @notice allow `minting_user` to mint for `msg.sender`
205     @param minting_user Address to toggle permission for
206     """
207     self.allowed_to_mint_for[minting_user][msg.sender] = not self.allowed_to_mint_for[minting_user][msg.sender]
208 
209 @external
210 def recover_balance(_coin: address) -> bool:
211     """
212     @notice Recover ERC20 tokens from this contract
213     @dev Tokens are sent to the emergency return address.
214     @param _coin Token address
215     @return bool success
216     """
217     assert msg.sender == self.admin # dev: admin only
218 
219     amount: uint256 = ERC20(_coin).balanceOf(self)
220     response: Bytes[32] = raw_call(
221         _coin,
222         concat(
223             method_id("transfer(address,uint256)"),
224             convert(self.emergency_return, bytes32),
225             convert(amount, bytes32),
226         ),
227         max_outsize=32,
228     )
229     if len(response) != 0:
230         assert convert(response, bool)
231 
232     return True
233 
234 @external
235 def commit_next_emission(_rate_per_week: uint256):
236   """
237   @notice Commit a new rate for the following week (we update by weeks).
238           _rate_per_week should have no decimals (ex: if we want to reward 600_000 SDL over the course of a week, we pass in 600_000 * 10 ** 18)
239   """
240   assert msg.sender == self.admin # dev: admin only
241   assert _rate_per_week <= MAX_ABS_RATE # dev: preventing fatfinger
242   new_rate: uint256 = _rate_per_week / WEEK
243   self.committed_rate = new_rate
244   log CommitNextEmission(new_rate)
245 
246 @external
247 def commit_transfer_emergency_return(addr: address):
248     """
249     @notice Update emergency ret. of Minter to `addr`
250     @param addr Address to have emergency ret. transferred to
251     """
252     assert msg.sender == self.admin  # dev: admin only
253     self.future_emergency_return = addr
254     log CommitEmergencyReturn(addr)
255 
256 @external
257 def apply_transfer_emergency_return():
258     """
259     @notice Apply pending emergency ret. update
260     """
261     assert msg.sender == self.admin  # dev: admin only
262     _emergency_return: address = self.future_emergency_return
263     assert _emergency_return != ZERO_ADDRESS  # dev: emergency return not set
264     self.emergency_return = _emergency_return
265     log ApplyEmergencyReturn(_emergency_return)
266 
267 @external
268 def commit_transfer_ownership(addr: address):
269     """
270     @notice Transfer ownership of GaugeController to `addr`
271     @param addr Address to have ownership transferred to
272     """
273     assert msg.sender == self.admin  # dev: admin only
274     self.future_admin = addr
275     log CommitOwnership(addr)
276 
277 @external
278 def apply_transfer_ownership():
279     """
280     @notice Apply pending ownership transfer
281     """
282     assert msg.sender == self.admin  # dev: admin only
283     _admin: address = self.future_admin
284     assert _admin != ZERO_ADDRESS  # dev: admin not set
285     self.admin = _admin
286     log ApplyOwnership(_admin)