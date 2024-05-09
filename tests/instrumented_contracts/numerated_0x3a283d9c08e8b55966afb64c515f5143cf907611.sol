1 # @version 0.3.1
2 """
3 @title Curve LP Token
4 @author Curve.Fi
5 @notice Base implementation for an LP token provided for
6         supplying liquidity to `StableSwap`
7 @dev Follows the ERC-20 token standard as defined at
8      https://eips.ethereum.org/EIPS/eip-20
9 """
10 # 😵‍💫
11 from vyper.interfaces import ERC20
12 
13 implements: ERC20
14 
15 interface Curve:
16     def owner() -> address: view
17 
18 
19 event Transfer:
20     _from: indexed(address)
21     _to: indexed(address)
22     _value: uint256
23 
24 event Approval:
25     _owner: indexed(address)
26     _spender: indexed(address)
27     _value: uint256
28 
29 event SetName:
30     old_name: String[64]
31     old_symbol: String[32]
32     name: String[64]
33     symbol: String[32]
34     owner: address
35     time: uint256
36 
37 
38 name: public(String[64])
39 symbol: public(String[32])
40 
41 balanceOf: public(HashMap[address, uint256])
42 allowance: public(HashMap[address, HashMap[address, uint256]])
43 totalSupply: public(uint256)
44 
45 minter: public(address)
46 
47 
48 @external
49 def __init__(_name: String[64], _symbol: String[32]):
50     self.name = _name
51     self.symbol = _symbol
52     self.minter = msg.sender
53     log Transfer(ZERO_ADDRESS, msg.sender, 0)
54 
55 
56 @view
57 @external
58 def decimals() -> uint256:
59     """
60     @notice Get the number of decimals for this token
61     @dev Implemented as a view method to reduce gas costs
62     @return uint256 decimal places
63     """
64     return 18
65 
66 
67 @external
68 def transfer(_to : address, _value : uint256) -> bool:
69     """
70     @dev Transfer token for a specified address
71     @param _to The address to transfer to.
72     @param _value The amount to be transferred.
73     """
74     # NOTE: vyper does not allow underflows
75     #       so the following subtraction would revert on insufficient balance
76     self.balanceOf[msg.sender] -= _value
77     self.balanceOf[_to] += _value
78 
79     log Transfer(msg.sender, _to, _value)
80     return True
81 
82 
83 @external
84 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
85     """
86      @dev Transfer tokens from one address to another.
87      @param _from address The address which you want to send tokens from
88      @param _to address The address which you want to transfer to
89      @param _value uint256 the amount of tokens to be transferred
90     """
91     self.balanceOf[_from] -= _value
92     self.balanceOf[_to] += _value
93 
94     _allowance: uint256 = self.allowance[_from][msg.sender]
95     if _allowance != MAX_UINT256:
96         self.allowance[_from][msg.sender] = _allowance - _value
97 
98     log Transfer(_from, _to, _value)
99     return True
100 
101 
102 @external
103 def approve(_spender : address, _value : uint256) -> bool:
104     """
105     @notice Approve the passed address to transfer the specified amount of
106             tokens on behalf of msg.sender
107     @dev Beware that changing an allowance via this method brings the risk
108          that someone may use both the old and new allowance by unfortunate
109          transaction ordering. This may be mitigated with the use of
110          {increaseAllowance} and {decreaseAllowance}.
111          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
112     @param _spender The address which will transfer the funds
113     @param _value The amount of tokens that may be transferred
114     @return bool success
115     """
116     self.allowance[msg.sender][_spender] = _value
117 
118     log Approval(msg.sender, _spender, _value)
119     return True
120 
121 
122 @external
123 def increaseAllowance(_spender: address, _added_value: uint256) -> bool:
124     """
125     @notice Increase the allowance granted to `_spender` by the caller
126     @dev This is alternative to {approve} that can be used as a mitigation for
127          the potential race condition
128     @param _spender The address which will transfer the funds
129     @param _added_value The amount of to increase the allowance
130     @return bool success
131     """
132     allowance: uint256 = self.allowance[msg.sender][_spender] + _added_value
133     self.allowance[msg.sender][_spender] = allowance
134 
135     log Approval(msg.sender, _spender, allowance)
136     return True
137 
138 
139 @external
140 def decreaseAllowance(_spender: address, _subtracted_value: uint256) -> bool:
141     """
142     @notice Decrease the allowance granted to `_spender` by the caller
143     @dev This is alternative to {approve} that can be used as a mitigation for
144          the potential race condition
145     @param _spender The address which will transfer the funds
146     @param _subtracted_value The amount of to decrease the allowance
147     @return bool success
148     """
149     allowance: uint256 = self.allowance[msg.sender][_spender] - _subtracted_value
150     self.allowance[msg.sender][_spender] = allowance
151 
152     log Approval(msg.sender, _spender, allowance)
153     return True
154 
155 
156 @external
157 def mint(_to: address, _value: uint256) -> bool:
158     """
159     @dev Mint an amount of the token and assigns it to an account.
160          This encapsulates the modification of balances such that the
161          proper events are emitted.
162     @param _to The account that will receive the created tokens.
163     @param _value The amount that will be created.
164     """
165     assert msg.sender == self.minter
166 
167     self.totalSupply += _value
168     self.balanceOf[_to] += _value
169 
170     log Transfer(ZERO_ADDRESS, _to, _value)
171     return True
172 
173 
174 @external
175 def mint_relative(_to: address, frac: uint256) -> uint256:
176     """
177     @dev Increases supply by factor of (1 + frac/1e18) and mints it for _to
178     """
179     assert msg.sender == self.minter
180 
181     supply: uint256 = self.totalSupply
182     d_supply: uint256 = supply * frac / 10**18
183     if d_supply > 0:
184         self.totalSupply = supply + d_supply
185         self.balanceOf[_to] += d_supply
186         log Transfer(ZERO_ADDRESS, _to, d_supply)
187 
188     return d_supply
189 
190 
191 @external
192 def burnFrom(_to: address, _value: uint256) -> bool:
193     """
194     @dev Burn an amount of the token from a given account.
195     @param _to The account whose tokens will be burned.
196     @param _value The amount that will be burned.
197     """
198     assert msg.sender == self.minter
199 
200     self.totalSupply -= _value
201     self.balanceOf[_to] -= _value
202 
203     log Transfer(_to, ZERO_ADDRESS, _value)
204     return True
205 
206 
207 @external
208 def set_minter(_minter: address):
209     assert msg.sender == self.minter
210     self.minter = _minter
211 
212 
213 @external
214 def set_name(_name: String[64], _symbol: String[32]):
215     assert Curve(self.minter).owner() == msg.sender
216     old_name: String[64] = self.name
217     old_symbol: String[32] = self.symbol
218     self.name = _name
219     self.symbol = _symbol
220 
221     log SetName(old_name, old_symbol, _name, _symbol, msg.sender, block.timestamp)