1 # @version ^0.2.0
2 """
3 @title Curve LP Token
4 @author Curve.Fi
5 @notice Base implementation for an LP token provided for
6         supplying liquidity to `StableSwap`
7 @dev Follows the ERC-20 token standard as defined at
8      https://eips.ethereum.org/EIPS/eip-20
9 """
10 
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
29 
30 name: public(String[64])
31 symbol: public(String[32])
32 
33 balanceOf: public(HashMap[address, uint256])
34 allowance: public(HashMap[address, HashMap[address, uint256]])
35 totalSupply: public(uint256)
36 
37 minter: public(address)
38 
39 
40 @external
41 def __init__(_name: String[64], _symbol: String[32]):
42     self.name = _name
43     self.symbol = _symbol
44     self.minter = msg.sender
45     log Transfer(ZERO_ADDRESS, msg.sender, 0)
46 
47 
48 @view
49 @external
50 def decimals() -> uint256:
51     """
52     @notice Get the number of decimals for this token
53     @dev Implemented as a view method to reduce gas costs
54     @return uint256 decimal places
55     """
56     return 18
57 
58 
59 @external
60 def transfer(_to : address, _value : uint256) -> bool:
61     """
62     @dev Transfer token for a specified address
63     @param _to The address to transfer to.
64     @param _value The amount to be transferred.
65     """
66     # NOTE: vyper does not allow underflows
67     #       so the following subtraction would revert on insufficient balance
68     self.balanceOf[msg.sender] -= _value
69     self.balanceOf[_to] += _value
70 
71     log Transfer(msg.sender, _to, _value)
72     return True
73 
74 
75 @external
76 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
77     """
78      @dev Transfer tokens from one address to another.
79      @param _from address The address which you want to send tokens from
80      @param _to address The address which you want to transfer to
81      @param _value uint256 the amount of tokens to be transferred
82     """
83     self.balanceOf[_from] -= _value
84     self.balanceOf[_to] += _value
85 
86     _allowance: uint256 = self.allowance[_from][msg.sender]
87     if _allowance != MAX_UINT256:
88         self.allowance[_from][msg.sender] = _allowance - _value
89 
90     log Transfer(_from, _to, _value)
91     return True
92 
93 
94 @external
95 def approve(_spender : address, _value : uint256) -> bool:
96     """
97     @notice Approve the passed address to transfer the specified amount of
98             tokens on behalf of msg.sender
99     @dev Beware that changing an allowance via this method brings the risk
100          that someone may use both the old and new allowance by unfortunate
101          transaction ordering. This may be mitigated with the use of
102          {increaseAllowance} and {decreaseAllowance}.
103          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104     @param _spender The address which will transfer the funds
105     @param _value The amount of tokens that may be transferred
106     @return bool success
107     """
108     self.allowance[msg.sender][_spender] = _value
109 
110     log Approval(msg.sender, _spender, _value)
111     return True
112 
113 
114 @external
115 def increaseAllowance(_spender: address, _added_value: uint256) -> bool:
116     """
117     @notice Increase the allowance granted to `_spender` by the caller
118     @dev This is alternative to {approve} that can be used as a mitigation for
119          the potential race condition
120     @param _spender The address which will transfer the funds
121     @param _added_value The amount of to increase the allowance
122     @return bool success
123     """
124     allowance: uint256 = self.allowance[msg.sender][_spender] + _added_value
125     self.allowance[msg.sender][_spender] = allowance
126 
127     log Approval(msg.sender, _spender, allowance)
128     return True
129 
130 
131 @external
132 def decreaseAllowance(_spender: address, _subtracted_value: uint256) -> bool:
133     """
134     @notice Decrease the allowance granted to `_spender` by the caller
135     @dev This is alternative to {approve} that can be used as a mitigation for
136          the potential race condition
137     @param _spender The address which will transfer the funds
138     @param _subtracted_value The amount of to decrease the allowance
139     @return bool success
140     """
141     allowance: uint256 = self.allowance[msg.sender][_spender] - _subtracted_value
142     self.allowance[msg.sender][_spender] = allowance
143 
144     log Approval(msg.sender, _spender, allowance)
145     return True
146 
147 
148 @external
149 def mint(_to: address, _value: uint256) -> bool:
150     """
151     @dev Mint an amount of the token and assigns it to an account.
152          This encapsulates the modification of balances such that the
153          proper events are emitted.
154     @param _to The account that will receive the created tokens.
155     @param _value The amount that will be created.
156     """
157     assert msg.sender == self.minter
158 
159     self.totalSupply += _value
160     self.balanceOf[_to] += _value
161 
162     log Transfer(ZERO_ADDRESS, _to, _value)
163     return True
164 
165 
166 @external
167 def burnFrom(_to: address, _value: uint256) -> bool:
168     """
169     @dev Burn an amount of the token from a given account.
170     @param _to The account whose tokens will be burned.
171     @param _value The amount that will be burned.
172     """
173     assert msg.sender == self.minter
174 
175     self.totalSupply -= _value
176     self.balanceOf[_to] -= _value
177 
178     log Transfer(_to, ZERO_ADDRESS, _value)
179     return True
180 
181 
182 @external
183 def set_minter(_minter: address):
184     assert msg.sender == self.minter
185     self.minter = _minter
186 
187 
188 @external
189 def set_name(_name: String[64], _symbol: String[32]):
190     assert Curve(self.minter).owner() == msg.sender
191     self.name = _name
192     self.symbol = _symbol