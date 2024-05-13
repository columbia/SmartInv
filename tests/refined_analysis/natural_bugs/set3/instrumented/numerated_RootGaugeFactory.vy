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
14     def initialize(_bridger: address, _chain_id: uint256, _name: String[32]): nonpayable
15     def transmit_emissions(): nonpayable
16 
17 interface CallProxy:
18     def anyCall(
19         _to: address, _data: Bytes[1024], _fallback: address, _to_chain_id: uint256, _flags: uint256
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
48 
49 call_proxy: public(address)
50 
51 get_bridger: public(HashMap[uint256, address])
52 get_implementation: public(address)
53 
54 get_gauge: public(HashMap[uint256, address[MAX_UINT256]])
55 get_gauge_count: public(HashMap[uint256, uint256])
56 is_valid_gauge: public(HashMap[address, bool])
57 
58 owner: public(address)
59 future_owner: public(address)
60 
61 
62 @external
63 def __init__(_call_proxy: address, _owner: address):
64     self.call_proxy = _call_proxy
65     log UpdateCallProxy(ZERO_ADDRESS, _call_proxy)
66 
67     self.owner = _owner
68     log TransferOwnership(ZERO_ADDRESS, _owner)
69 
70 
71 @external
72 def transmit_emissions(_gauge: address):
73     """
74     @notice Call `transmit_emissions` on a root gauge
75     @dev Entrypoint for anycall to request emissions for a child gauge.
76         The way that gauges work, this can also be called on the root
77         chain without a request.
78     """
79     # in most cases this will return True
80     # for special bridges *cough cough Multichain, we can only do
81     # one bridge per tx, therefore this will verify msg.sender in [tx.origin, self.call_proxy]
82     assert Bridger(RootGauge(_gauge).bridger()).check(msg.sender)
83     RootGauge(_gauge).transmit_emissions()
84 
85 
86 @payable
87 @external
88 def deploy_gauge(_chain_id: uint256, _salt: bytes32, _name: String[32]) -> address:
89     """
90     @notice Deploy a root liquidity gauge
91     @param _chain_id The chain identifier of the counterpart child gauge
92     @param _salt A value to deterministically deploy a gauge
93     """
94 
95     bridger: address = self.get_bridger[_chain_id]
96     assert bridger != ZERO_ADDRESS, "chain id not supported" # dev: chain id not supported
97 
98     implementation: address = self.get_implementation
99     gauge: address = create_forwarder_to(
100         implementation,
101         value=msg.value,
102         salt=keccak256(_abi_encode(_chain_id, msg.sender, _salt))
103     )
104 
105     idx: uint256 = self.get_gauge_count[_chain_id]
106     self.get_gauge[_chain_id][idx] = gauge
107     self.get_gauge_count[_chain_id] = idx + 1
108     self.is_valid_gauge[gauge] = True
109 
110     RootGauge(gauge).initialize(bridger, _chain_id, _name)
111 
112     log DeployedGauge(implementation, _chain_id, msg.sender, _salt, gauge)
113     return gauge
114 
115 
116 @external
117 def deploy_child_gauge(_chain_id: uint256, _lp_token: address, _salt: bytes32, _name:String[32], _manager: address = msg.sender):
118     bridger: address = self.get_bridger[_chain_id]
119     assert bridger != ZERO_ADDRESS  # dev: chain id not supported
120 
121     CallProxy(self.call_proxy).anyCall(
122         self,
123         _abi_encode(
124             _lp_token,
125             _salt,
126             _name,
127             _manager,
128             method_id=method_id("deploy_gauge(address,bytes32,string,address)")
129         ),
130         ZERO_ADDRESS,
131         _chain_id,
132         0
133     )
134 
135 
136 @external
137 def set_bridger(_chain_id: uint256, _bridger: address):
138     """
139     @notice Set the bridger for `_chain_id`
140     @param _chain_id The chain identifier to set the bridger for
141     @param _bridger The bridger contract to use
142     """
143     assert msg.sender == self.owner  # dev: only owner
144 
145     log BridgerUpdated(_chain_id, self.get_bridger[_chain_id], _bridger)
146     self.get_bridger[_chain_id] = _bridger
147 
148 
149 @external
150 def set_implementation(_implementation: address):
151     """
152     @notice Set the implementation
153     @param _implementation The address of the implementation to use
154     """
155     assert msg.sender == self.owner  # dev: only owner
156 
157     log UpdateImplementation(self.get_implementation, _implementation)
158     self.get_implementation = _implementation
159 
160 
161 @external
162 def set_call_proxy(_new_call_proxy: address):
163     """
164     @notice Set the address of the call proxy used
165     @dev _new_call_proxy should adhere to the same interface as defined
166     @param _new_call_proxy Address of the cross chain call proxy
167     """
168     assert msg.sender == self.owner
169 
170     log UpdateCallProxy(self.call_proxy, _new_call_proxy)
171     self.call_proxy = _new_call_proxy
172 
173 
174 @external
175 def commit_transfer_ownership(_future_owner: address):
176     """
177     @notice Transfer ownership to `_future_owner`
178     @param _future_owner The account to commit as the future owner
179     """
180     assert msg.sender == self.owner  # dev: only owner
181 
182     self.future_owner = _future_owner
183 
184 
185 @external
186 def accept_transfer_ownership():
187     """
188     @notice Accept the transfer of ownership
189     @dev Only the committed future owner can call this function
190     """
191     assert msg.sender == self.future_owner  # dev: only future owner
192 
193     log TransferOwnership(self.owner, msg.sender)
194     self.owner = msg.sender