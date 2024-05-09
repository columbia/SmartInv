1 # @version 0.2.4
2 """
3 @title Vesting Escrow
4 @author Curve Finance
5 @license MIT
6 @notice Vests `ERC20CRV` tokens for multiple addresses over multiple vesting periods
7 """
8 
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
38 unallocated_supply: public(uint256)
39 
40 can_disable: public(bool)
41 disabled_at: public(HashMap[address, uint256])
42 
43 admin: public(address)
44 future_admin: public(address)
45 
46 fund_admins_enabled: public(bool)
47 fund_admins: public(HashMap[address, bool])
48 
49 
50 @external
51 def __init__(
52     _token: address,
53     _start_time: uint256,
54     _end_time: uint256,
55     _can_disable: bool,
56     _fund_admins: address[4]
57 ):
58     """
59     @param _token Address of the ERC20 token being distributed
60     @param _start_time Timestamp at which the distribution starts. Should be in
61         the future, so that we have enough time to VoteLock everyone
62     @param _end_time Time until everything should be vested
63     @param _can_disable Whether admin can disable accounts in this deployment
64     @param _fund_admins Temporary admin accounts used only for funding
65     """
66     assert _start_time >= block.timestamp
67     assert _end_time > _start_time
68 
69     self.token = _token
70     self.admin = msg.sender
71     self.start_time = _start_time
72     self.end_time = _end_time
73     self.can_disable = _can_disable
74 
75     _fund_admins_enabled: bool = False
76     for addr in _fund_admins:
77         if addr != ZERO_ADDRESS:
78             self.fund_admins[addr] = True
79             if not _fund_admins_enabled:
80                 _fund_admins_enabled = True
81                 self.fund_admins_enabled = True
82 
83 
84 
85 @external
86 def add_tokens(_amount: uint256):
87     """
88     @notice Transfer vestable tokens into the contract
89     @dev Handled separate from `fund` to reduce transaction count when using funding admins
90     @param _amount Number of tokens to transfer
91     """
92     assert msg.sender == self.admin  # dev: admin only
93     assert ERC20(self.token).transferFrom(msg.sender, self, _amount)  # dev: transfer failed
94     self.unallocated_supply += _amount
95 
96 
97 @external
98 @nonreentrant('lock')
99 def fund(_recipients: address[100], _amounts: uint256[100]):
100     """
101     @notice Vest tokens for multiple recipients
102     @param _recipients List of addresses to fund
103     @param _amounts Amount of vested tokens for each address
104     """
105     if msg.sender != self.admin:
106         assert self.fund_admins[msg.sender]  # dev: admin only
107         assert self.fund_admins_enabled  # dev: fund admins disabled
108 
109     _total_amount: uint256 = 0
110     for i in range(100):
111         amount: uint256 = _amounts[i]
112         recipient: address = _recipients[i]
113         if recipient == ZERO_ADDRESS:
114             break
115         _total_amount += amount
116         self.initial_locked[recipient] += amount
117         log Fund(recipient, amount)
118 
119     self.initial_locked_supply += _total_amount
120     self.unallocated_supply -= _total_amount
121 
122 
123 @external
124 def toggle_disable(_recipient: address):
125     """
126     @notice Disable or re-enable a vested address's ability to claim tokens
127     @dev When disabled, the address is only unable to claim tokens which are still
128          locked at the time of this call. It is not possible to block the claim
129          of tokens which have already vested.
130     @param _recipient Address to disable or enable
131     """
132     assert msg.sender == self.admin  # dev: admin only
133     assert self.can_disable, "Cannot disable"
134 
135     is_disabled: bool = self.disabled_at[_recipient] == 0
136     if is_disabled:
137         self.disabled_at[_recipient] = block.timestamp
138     else:
139         self.disabled_at[_recipient] = 0
140 
141     log ToggleDisable(_recipient, is_disabled)
142 
143 
144 @external
145 def disable_can_disable():
146     """
147     @notice Disable the ability to call `toggle_disable`
148     """
149     assert msg.sender == self.admin  # dev: admin only
150     self.can_disable = False
151 
152 
153 @external
154 def disable_fund_admins():
155     """
156     @notice Disable the funding admin accounts
157     """
158     assert msg.sender == self.admin  # dev: admin only
159     self.fund_admins_enabled = False
160 
161 
162 @internal
163 @view
164 def _total_vested_of(_recipient: address, _time: uint256 = block.timestamp) -> uint256:
165     start: uint256 = self.start_time
166     end: uint256 = self.end_time
167     locked: uint256 = self.initial_locked[_recipient]
168     if _time < start:
169         return 0
170     return min(locked * (_time - start) / (end - start), locked)
171 
172 
173 @internal
174 @view
175 def _total_vested() -> uint256:
176     start: uint256 = self.start_time
177     end: uint256 = self.end_time
178     locked: uint256 = self.initial_locked_supply
179     if block.timestamp < start:
180         return 0
181     return min(locked * (block.timestamp - start) / (end - start), locked)
182 
183 
184 @external
185 @view
186 def vestedSupply() -> uint256:
187     """
188     @notice Get the total number of tokens which have vested, that are held
189             by this contract
190     """
191     return self._total_vested()
192 
193 
194 @external
195 @view
196 def lockedSupply() -> uint256:
197     """
198     @notice Get the total number of tokens which are still locked
199             (have not yet vested)
200     """
201     return self.initial_locked_supply - self._total_vested()
202 
203 
204 @external
205 @view
206 def vestedOf(_recipient: address) -> uint256:
207     """
208     @notice Get the number of tokens which have vested for a given address
209     @param _recipient address to check
210     """
211     return self._total_vested_of(_recipient)
212 
213 
214 @external
215 @view
216 def balanceOf(_recipient: address) -> uint256:
217     """
218     @notice Get the number of unclaimed, vested tokens for a given address
219     @param _recipient address to check
220     """
221     return self._total_vested_of(_recipient) - self.total_claimed[_recipient]
222 
223 
224 @external
225 @view
226 def lockedOf(_recipient: address) -> uint256:
227     """
228     @notice Get the number of locked tokens for a given address
229     @param _recipient address to check
230     """
231     return self.initial_locked[_recipient] - self._total_vested_of(_recipient)
232 
233 
234 @external
235 @nonreentrant('lock')
236 def claim(addr: address = msg.sender):
237     """
238     @notice Claim tokens which have vested
239     @param addr Address to claim tokens for
240     """
241     t: uint256 = self.disabled_at[addr]
242     if t == 0:
243         t = block.timestamp
244     claimable: uint256 = self._total_vested_of(addr, t) - self.total_claimed[addr]
245     self.total_claimed[addr] += claimable
246     assert ERC20(self.token).transfer(addr, claimable)
247 
248     log Claim(addr, claimable)
249 
250 
251 @external
252 def commit_transfer_ownership(addr: address) -> bool:
253     """
254     @notice Transfer ownership of GaugeController to `addr`
255     @param addr Address to have ownership transferred to
256     """
257     assert msg.sender == self.admin  # dev: admin only
258     self.future_admin = addr
259     log CommitOwnership(addr)
260 
261     return True
262 
263 
264 @external
265 def apply_transfer_ownership() -> bool:
266     """
267     @notice Apply pending ownership transfer
268     """
269     assert msg.sender == self.admin  # dev: admin only
270     _admin: address = self.future_admin
271     assert _admin != ZERO_ADDRESS  # dev: admin not set
272     self.admin = _admin
273     log ApplyOwnership(_admin)
274 
275     return True