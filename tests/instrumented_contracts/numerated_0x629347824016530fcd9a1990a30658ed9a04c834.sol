1 # @version 0.2.4
2 """
3 @title Simple Vesting Escrow
4 @author Curve Finance
5 @license MIT
6 @notice Vests `ERC20CRV` tokens for a single address
7 @dev Intended to be deployed many times via `VotingEscrowFactory`
8 """
9 
10 from vyper.interfaces import ERC20
11 
12 event Fund:
13     recipient: indexed(address)
14     amount: uint256
15 
16 event Claim:
17     recipient: indexed(address)
18     claimed: uint256
19 
20 event ToggleDisable:
21     recipient: address
22     disabled: bool
23 
24 event CommitOwnership:
25     admin: address
26 
27 event ApplyOwnership:
28     admin: address
29 
30 
31 token: public(address)
32 start_time: public(uint256)
33 end_time: public(uint256)
34 initial_locked: public(HashMap[address, uint256])
35 total_claimed: public(HashMap[address, uint256])
36 
37 initial_locked_supply: public(uint256)
38 
39 can_disable: public(bool)
40 disabled_at: public(HashMap[address, uint256])
41 
42 admin: public(address)
43 future_admin: public(address)
44 
45 @external
46 def __init__():
47     # ensure that the original contract cannot be initialized
48     self.admin = msg.sender
49 
50 
51 @external
52 @nonreentrant('lock')
53 def initialize(
54     _admin: address,
55     _token: address,
56     _recipient: address,
57     _amount: uint256,
58     _start_time: uint256,
59     _end_time: uint256,
60     _can_disable: bool
61 ) -> bool:
62     """
63     @notice Initialize the contract.
64     @dev This function is seperate from `__init__` because of the factory pattern
65          used in `VestingEscrowFactory.deploy_vesting_contract`. It may be called
66          once per deployment.
67     @param _admin Admin address
68     @param _token Address of the ERC20 token being distributed
69     @param _recipient Address to vest tokens for
70     @param _amount Amount of tokens being vested for `_recipient`
71     @param _start_time Epoch time at which token distribution starts
72     @param _end_time Time until everything should be vested
73     @param _can_disable Can admin disable recipient's ability to claim tokens?
74     """
75     assert self.admin == ZERO_ADDRESS  # dev: can only initialize once
76 
77     self.token = _token
78     self.admin = _admin
79     self.start_time = _start_time
80     self.end_time = _end_time
81     self.can_disable = _can_disable
82 
83     assert ERC20(_token).transferFrom(msg.sender, self, _amount)
84 
85     self.initial_locked[_recipient] = _amount
86     self.initial_locked_supply = _amount
87     log Fund(_recipient, _amount)
88 
89     return True
90 
91 
92 @external
93 def toggle_disable(_recipient: address):
94     """
95     @notice Disable or re-enable a vested address's ability to claim tokens
96     @dev When disabled, the address is only unable to claim tokens which are still
97          locked at the time of this call. It is not possible to block the claim
98          of tokens which have already vested.
99     @param _recipient Address to disable or enable
100     """
101     assert msg.sender == self.admin  # dev: admin only
102     assert self.can_disable, "Cannot disable"
103 
104     is_disabled: bool = self.disabled_at[_recipient] == 0
105     if is_disabled:
106         self.disabled_at[_recipient] = block.timestamp
107     else:
108         self.disabled_at[_recipient] = 0
109 
110     log ToggleDisable(_recipient, is_disabled)
111 
112 
113 @external
114 def disable_can_disable():
115     """
116     @notice Disable the ability to call `toggle_disable`
117     """
118     assert msg.sender == self.admin  # dev: admin only
119     self.can_disable = False
120 
121 
122 @internal
123 @view
124 def _total_vested_of(_recipient: address, _time: uint256 = block.timestamp) -> uint256:
125     start: uint256 = self.start_time
126     end: uint256 = self.end_time
127     locked: uint256 = self.initial_locked[_recipient]
128     if _time < start:
129         return 0
130     return min(locked * (_time - start) / (end - start), locked)
131 
132 
133 @internal
134 @view
135 def _total_vested() -> uint256:
136     start: uint256 = self.start_time
137     end: uint256 = self.end_time
138     locked: uint256 = self.initial_locked_supply
139     if block.timestamp < start:
140         return 0
141     return min(locked * (block.timestamp - start) / (end - start), locked)
142 
143 
144 @external
145 @view
146 def vestedSupply() -> uint256:
147     """
148     @notice Get the total number of tokens which have vested, that are held
149             by this contract
150     """
151     return self._total_vested()
152 
153 
154 @external
155 @view
156 def lockedSupply() -> uint256:
157     """
158     @notice Get the total number of tokens which are still locked
159             (have not yet vested)
160     """
161     return self.initial_locked_supply - self._total_vested()
162 
163 
164 @external
165 @view
166 def vestedOf(_recipient: address) -> uint256:
167     """
168     @notice Get the number of tokens which have vested for a given address
169     @param _recipient address to check
170     """
171     return self._total_vested_of(_recipient)
172 
173 
174 @external
175 @view
176 def balanceOf(_recipient: address) -> uint256:
177     """
178     @notice Get the number of unclaimed, vested tokens for a given address
179     @param _recipient address to check
180     """
181     return self._total_vested_of(_recipient) - self.total_claimed[_recipient]
182 
183 
184 @external
185 @view
186 def lockedOf(_recipient: address) -> uint256:
187     """
188     @notice Get the number of locked tokens for a given address
189     @param _recipient address to check
190     """
191     return self.initial_locked[_recipient] - self._total_vested_of(_recipient)
192 
193 
194 @external
195 @nonreentrant('lock')
196 def claim(addr: address = msg.sender):
197     """
198     @notice Claim tokens which have vested
199     @param addr Address to claim tokens for
200     """
201     t: uint256 = self.disabled_at[addr]
202     if t == 0:
203         t = block.timestamp
204     claimable: uint256 = self._total_vested_of(addr, t) - self.total_claimed[addr]
205     self.total_claimed[addr] += claimable
206     assert ERC20(self.token).transfer(addr, claimable)
207 
208     log Claim(addr, claimable)
209 
210 
211 @external
212 def commit_transfer_ownership(addr: address) -> bool:
213     """
214     @notice Transfer ownership of GaugeController to `addr`
215     @param addr Address to have ownership transferred to
216     """
217     assert msg.sender == self.admin  # dev: admin only
218     self.future_admin = addr
219     log CommitOwnership(addr)
220 
221     return True
222 
223 
224 @external
225 def apply_transfer_ownership() -> bool:
226     """
227     @notice Apply pending ownership transfer
228     """
229     assert msg.sender == self.admin  # dev: admin only
230     _admin: address = self.future_admin
231     assert _admin != ZERO_ADDRESS  # dev: admin not set
232     self.admin = _admin
233     log ApplyOwnership(_admin)
234 
235     return True