1 # @version 0.3.1
2 """
3 @title Child Liquidity Gauge Factory
4 @license MIT
5 @author Curve Finance
6 """
7 
8 
9 interface ChildGauge:
10     def initialize(_lp_token: address, _manager: address, _name: String[32]): nonpayable
11     def integrate_fraction(_user: address) -> uint256: view
12     def user_checkpoint(_user: address) -> bool: nonpayable
13 
14 interface CallProxy:
15     def anyCall(
16         _to: address, _data: Bytes[1024], _fallback: address, _to_chain_id: uint256, _flags: uint256
17     ): nonpayable
18 
19 
20 event DeployedGauge:
21     _implementation: indexed(address)
22     _lp_token: indexed(address)
23     _deployer: indexed(address)
24     _salt: bytes32
25     _gauge: address
26     _name: String[32]
27 
28 event Minted:
29     _user: indexed(address)
30     _gauge: indexed(address)
31     _new_total: uint256
32 
33 event UpdateImplementation:
34     _old_implementation: address
35     _new_implementation: address
36 
37 event UpdateVotingEscrow:
38     _old_voting_escrow: address
39     _new_voting_escrow: address
40 
41 event UpdateCallProxy:
42     _old_call_proxy: address
43     _new_call_proxy: address
44 
45 event UpdateMirrored:
46     _gauge: indexed(address)
47     _mirrored: bool
48 
49 event TransferOwnership:
50     _old_owner: address
51     _new_owner: address
52 
53 
54 WEEK: constant(uint256) = 86400 * 7
55 
56 
57 SDL: immutable(address)
58 
59 
60 get_implementation: public(address)
61 voting_escrow: public(address)
62 
63 owner: public(address)
64 future_owner: public(address)
65 
66 call_proxy: public(address)
67 # [last_request][has_counterpart][is_valid_gauge]
68 gauge_data: public(HashMap[address, uint256])
69 # user -> gauge -> value
70 minted: public(HashMap[address, HashMap[address, uint256]])
71 
72 get_gauge_from_lp_token: public(HashMap[address, address])
73 get_gauge_count: public(uint256)
74 get_gauge: public(address[MAX_INT128])
75 
76 
77 @external
78 def __init__(_call_proxy: address, _sdl: address, _owner: address):
79     SDL = _sdl
80 
81     self.call_proxy = _call_proxy
82     log UpdateCallProxy(ZERO_ADDRESS, _call_proxy)
83 
84     self.owner = _owner
85     log TransferOwnership(ZERO_ADDRESS, _owner)
86 
87 
88 @internal
89 def _psuedo_mint(_gauge: address, _user: address):
90     gauge_data: uint256 = self.gauge_data[_gauge]
91     assert gauge_data != 0  # dev: invalid gauge
92 
93     # if is_mirrored and last_request != this week
94     if bitwise_and(gauge_data, 2) != 0 and shift(gauge_data, -2) / WEEK != block.timestamp / WEEK:
95         CallProxy(self.call_proxy).anyCall(
96             self,
97             _abi_encode(_gauge, method_id=method_id("transmit_emissions(address)")),
98             ZERO_ADDRESS,
99             1,
100             0
101         )
102         # update last request time
103         self.gauge_data[_gauge] = shift(block.timestamp, 2) + 3
104 
105     assert ChildGauge(_gauge).user_checkpoint(_user)
106     total_mint: uint256 = ChildGauge(_gauge).integrate_fraction(_user)
107     to_mint: uint256 = total_mint - self.minted[_user][_gauge]
108 
109     if to_mint != 0:
110         # transfer tokens to user
111         response: Bytes[32] = raw_call(
112             SDL,
113             _abi_encode(_user, to_mint, method_id=method_id("transfer(address,uint256)")),
114             max_outsize=32,
115         )
116         if len(response) != 0:
117             assert convert(response, bool)
118         self.minted[_user][_gauge] = total_mint
119 
120         log Minted(_user, _gauge, total_mint)
121 
122 
123 @external
124 @nonreentrant("lock")
125 def mint(_gauge: address):
126     """
127     @notice Mint everything which belongs to `msg.sender` and send to them
128     @param _gauge `LiquidityGauge` address to get mintable amount from
129     """
130     self._psuedo_mint(_gauge, msg.sender)
131 
132 
133 @external
134 @nonreentrant("lock")
135 def mint_many(_gauges: address[32]):
136     """
137     @notice Mint everything which belongs to `msg.sender` across multiple gauges
138     @param _gauges List of `LiquidityGauge` addresses
139     """
140     for i in range(32):
141         if _gauges[i] == ZERO_ADDRESS:
142             pass
143         self._psuedo_mint(_gauges[i], msg.sender)
144 
145 
146 @external
147 def deploy_gauge(_lp_token: address, _salt: bytes32,_name: String[32], _manager: address = msg.sender) -> address:
148     """
149     @notice Deploy a liquidity gauge
150     @param _lp_token The token to deposit in the gauge
151     @param _manager The address to set as manager of the gauge
152     @param _salt A value to deterministically deploy a gauge
153     @param _name The name of the gauge
154     """
155     if self.get_gauge_from_lp_token[_lp_token] != ZERO_ADDRESS:
156         # overwriting lp_token -> gauge mapping requires
157         assert msg.sender == self.owner  # dev: only owner
158 
159     gauge_data: uint256 = 1  # set is_valid_gauge = True
160     implementation: address = self.get_implementation
161     gauge: address = create_forwarder_to(
162         implementation, salt=keccak256(_abi_encode(chain.id, msg.sender, _salt))
163     )
164 
165     if msg.sender == self.call_proxy:
166         gauge_data += 2  # set mirrored = True
167         log UpdateMirrored(gauge, True)
168         # issue a call to the root chain to deploy a root gauge
169         CallProxy(self.call_proxy).anyCall(
170             self,
171             _abi_encode(chain.id, _salt, _name, method_id=method_id("deploy_gauge(uint256,bytes32,string)")),
172             ZERO_ADDRESS,
173             1,
174             0
175         )
176 
177     self.gauge_data[gauge] = gauge_data
178 
179     idx: uint256 = self.get_gauge_count
180     self.get_gauge[idx] = gauge
181     self.get_gauge_count = idx + 1
182     self.get_gauge_from_lp_token[_lp_token] = gauge
183 
184     ChildGauge(gauge).initialize(_lp_token, _manager, _name)
185 
186     log DeployedGauge(implementation, _lp_token, msg.sender, _salt, gauge, _name)
187     return gauge
188 
189 
190 @external
191 def set_voting_escrow(_voting_escrow: address):
192     """
193     @notice Update the voting escrow contract
194     @param _voting_escrow Contract to use as the voting escrow oracle
195     """
196     assert msg.sender == self.owner  # dev: only owner
197 
198     log UpdateVotingEscrow(self.voting_escrow, _voting_escrow)
199     self.voting_escrow = _voting_escrow
200 
201 
202 @external
203 def set_implementation(_implementation: address):
204     """
205     @notice Set the implementation
206     @param _implementation The address of the implementation to use
207     """
208     assert msg.sender == self.owner  # dev: only owner
209 
210     log UpdateImplementation(self.get_implementation, _implementation)
211     self.get_implementation = _implementation
212 
213 
214 @external
215 def set_mirrored(_gauge: address, _mirrored: bool):
216     """
217     @notice Set the mirrored bit of the gauge data for `_gauge`
218     @param _gauge The gauge of interest
219     @param _mirrored Boolean deteremining whether to set the mirrored bit to True/False
220     """
221     gauge_data: uint256 = self.gauge_data[_gauge]
222     assert gauge_data != 0  # dev: invalid gauge
223     assert msg.sender == self.owner  # dev: only owner
224 
225     gauge_data = shift(shift(gauge_data, -2), 2) + 1  # set is_valid_gauge = True
226     if _mirrored:
227         gauge_data += 2  # set is_mirrored = True
228 
229     self.gauge_data[_gauge] = gauge_data
230     log UpdateMirrored(_gauge, _mirrored)
231 
232 
233 @external
234 def set_call_proxy(_new_call_proxy: address):
235     """
236     @notice Set the address of the call proxy used
237     @dev _new_call_proxy should adhere to the same interface as defined
238     @param _new_call_proxy Address of the cross chain call proxy
239     """
240     assert msg.sender == self.owner
241 
242     log UpdateCallProxy(self.call_proxy, _new_call_proxy)
243     self.call_proxy = _new_call_proxy
244 
245 
246 @external
247 def commit_transfer_ownership(_future_owner: address):
248     """
249     @notice Transfer ownership to `_future_owner`
250     @param _future_owner The account to commit as the future owner
251     """
252     assert msg.sender == self.owner  # dev: only owner
253 
254     self.future_owner = _future_owner
255 
256 
257 @external
258 def accept_transfer_ownership():
259     """
260     @notice Accept the transfer of ownership
261     @dev Only the committed future owner can call this function
262     """
263     assert msg.sender == self.future_owner  # dev: only future owner
264 
265     log TransferOwnership(self.owner, msg.sender)
266     self.owner = msg.sender
267 
268 
269 @view
270 @external
271 def is_valid_gauge(_gauge: address) -> bool:
272     """
273     @notice Query whether the gauge is a valid one deployed via the factory
274     @param _gauge The address of the gauge of interest
275     """
276     return self.gauge_data[_gauge] != 0
277 
278 
279 @view
280 @external
281 def is_mirrored(_gauge: address) -> bool:
282     """
283     @notice Query whether the gauge is mirrored on Ethereum mainnet
284     @param _gauge The address of the gauge of interest
285     """
286     return bitwise_and(self.gauge_data[_gauge], 2) != 0
287 
288 
289 @view
290 @external
291 def last_request(_gauge: address) -> uint256:
292     """
293     @notice Query the timestamp of the last cross chain request for emissions
294     @param _gauge The address of the gauge of interest
295     """
296     return shift(self.gauge_data[_gauge], -2)
