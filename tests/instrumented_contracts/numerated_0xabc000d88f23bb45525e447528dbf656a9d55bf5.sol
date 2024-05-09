1 # @version 0.3.1
2 """
3 @title Root Liquidity Gauge Factory
4 @license MIT
5 @author Curve Finance
6 """
7 
8 
9 interface Bridger:
10     def check(_addr: address) -> bool: view
11 
12 interface RootGauge:
13     def bridger() -> address: view
14     def initialize(_bridger: address, _chain_id: uint256): nonpayable
15     def transmit_emissions(): nonpayable
16 
17 interface CallProxy:
18     def anyCall(
19         _to: address, _data: Bytes[1024], _fallback: address, _to_chain_id: uint256
20     ): nonpayable
21 
22 
23 event BridgerUpdated:
24     _chain_id: indexed(uint256)
25     _old_bridger: address
26     _new_bridger: address
27 
28 event DeployedGauge:
29     _implementation: indexed(address)
30     _chain_id: indexed(uint256)
31     _deployer: indexed(address)
32     _salt: bytes32
33     _gauge: address
34 
35 event TransferOwnership:
36     _old_owner: address
37     _new_owner: address
38 
39 event UpdateCallProxy:
40     _old_call_proxy: address
41     _new_call_proxy: address
42 
43 event UpdateImplementation:
44     _old_implementation: address
45     _new_implementation: address
46 
47 
48 call_proxy: public(address)
49 
50 get_bridger: public(HashMap[uint256, address])
51 get_implementation: public(address)
52 
53 get_gauge: public(HashMap[uint256, address[MAX_UINT256]])
54 get_gauge_count: public(HashMap[uint256, uint256])
55 is_valid_gauge: public(HashMap[address, bool])
56 
57 owner: public(address)
58 future_owner: public(address)
59 
60 
61 @external
62 def __init__(_call_proxy: address, _owner: address):
63     self.call_proxy = _call_proxy
64     log UpdateCallProxy(ZERO_ADDRESS, _call_proxy)
65 
66     self.owner = _owner
67     log TransferOwnership(ZERO_ADDRESS, _owner)
68 
69 
70 @external
71 def transmit_emissions(_gauge: address):
72     """
73     @notice Call `transmit_emissions` on a root gauge
74     @dev Entrypoint for anycall to request emissions for a child gauge.
75         The way that gauges work, this can also be called on the root
76         chain without a request.
77     """
78     # in most cases this will return True
79     # for special bridges *cough cough Multichain, we can only do
80     # one bridge per tx, therefore this will verify msg.sender in [tx.origin, self.call_proxy]
81     assert Bridger(RootGauge(_gauge).bridger()).check(msg.sender)
82     RootGauge(_gauge).transmit_emissions()
83 
84 
85 @payable
86 @external
87 def deploy_gauge(_chain_id: uint256, _salt: bytes32) -> address:
88     """
89     @notice Deploy a root liquidity gauge
90     @param _chain_id The chain identifier of the counterpart child gauge
91     @param _salt A value to deterministically deploy a gauge
92     """
93     bridger: address = self.get_bridger[_chain_id]
94     assert bridger != ZERO_ADDRESS  # dev: chain id not supported
95 
96     implementation: address = self.get_implementation
97     gauge: address = create_forwarder_to(
98         implementation,
99         value=msg.value,
100         salt=keccak256(_abi_encode(_chain_id, msg.sender, _salt))
101     )
102 
103     idx: uint256 = self.get_gauge_count[_chain_id]
104     self.get_gauge[_chain_id][idx] = gauge
105     self.get_gauge_count[_chain_id] = idx + 1
106     self.is_valid_gauge[gauge] = True
107 
108     RootGauge(gauge).initialize(bridger, _chain_id)
109 
110     log DeployedGauge(implementation, _chain_id, msg.sender, _salt, gauge)
111     return gauge
112 
113 
114 @external
115 def deploy_child_gauge(_chain_id: uint256, _lp_token: address, _salt: bytes32, _manager: address = msg.sender):
116     bridger: address = self.get_bridger[_chain_id]
117     assert bridger != ZERO_ADDRESS  # dev: chain id not supported
118 
119     CallProxy(self.call_proxy).anyCall(
120         self,
121         _abi_encode(
122             _lp_token,
123             _salt,
124             _manager,
125             method_id=method_id("deploy_gauge(address,bytes32,address)")
126         ),
127         ZERO_ADDRESS,
128         _chain_id
129     )
130 
131 
132 @external
133 def set_bridger(_chain_id: uint256, _bridger: address):
134     """
135     @notice Set the bridger for `_chain_id`
136     @param _chain_id The chain identifier to set the bridger for
137     @param _bridger The bridger contract to use
138     """
139     assert msg.sender == self.owner  # dev: only owner
140 
141     log BridgerUpdated(_chain_id, self.get_bridger[_chain_id], _bridger)
142     self.get_bridger[_chain_id] = _bridger
143 
144 
145 @external
146 def set_implementation(_implementation: address):
147     """
148     @notice Set the implementation
149     @param _implementation The address of the implementation to use
150     """
151     assert msg.sender == self.owner  # dev: only owner
152 
153     log UpdateImplementation(self.get_implementation, _implementation)
154     self.get_implementation = _implementation
155 
156 
157 @external
158 def set_call_proxy(_new_call_proxy: address):
159     """
160     @notice Set the address of the call proxy used
161     @dev _new_call_proxy should adhere to the same interface as defined
162     @param _new_call_proxy Address of the cross chain call proxy
163     """
164     assert msg.sender == self.owner
165 
166     log UpdateCallProxy(self.call_proxy, _new_call_proxy)
167     self.call_proxy = _new_call_proxy
168 
169 
170 @external
171 def commit_transfer_ownership(_future_owner: address):
172     """
173     @notice Transfer ownership to `_future_owner`
174     @param _future_owner The account to commit as the future owner
175     """
176     assert msg.sender == self.owner  # dev: only owner
177 
178     self.future_owner = _future_owner
179 
180 
181 @external
182 def accept_transfer_ownership():
183     """
184     @notice Accept the transfer of ownership
185     @dev Only the committed future owner can call this function
186     """
187     assert msg.sender == self.future_owner  # dev: only future owner
188 
189     log TransferOwnership(self.owner, msg.sender)
190     self.owner = msg.sender