1 # https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
2 
3 from vyper.interfaces import ERC20
4 
5 implements: ERC20
6 
7 
8 event Transfer:
9     _from: indexed(address)
10     _to: indexed(address)
11     _value: uint256
12 
13 event Approval:
14     _owner: indexed(address)
15     _spender: indexed(address)
16     _value: uint256
17 
18 
19 name: public(String[64])
20 symbol: public(String[32])
21 decimals: public(uint256)
22 
23 # NOTE: By declaring `balanceOf` as public, vyper automatically generates a 'balanceOf()' getter
24 #       method to allow access to account balances.
25 #       The _KeyType will become a required parameter for the getter and it will return _ValueType.
26 #       See: https://vyper.readthedocs.io/en/v0.1.0-beta.8/types.html?highlight=getter#mappings
27 balanceOf: public(HashMap[address, uint256])
28 allowances: HashMap[address, HashMap[address, uint256]]
29 total_supply: uint256
30 minter: address
31 
32 
33 @external
34 def __init__(_name: String[64], _symbol: String[32], _decimals: uint256, _supply: uint256):
35     init_supply: uint256 = _supply * 10 ** _decimals
36     self.name = _name
37     self.symbol = _symbol
38     self.decimals = _decimals
39     self.balanceOf[msg.sender] = init_supply
40     self.total_supply = init_supply
41     self.minter = msg.sender
42     log Transfer(ZERO_ADDRESS, msg.sender, init_supply)
43 
44 
45 @external
46 def set_minter(_minter: address):
47     assert msg.sender == self.minter
48     self.minter = _minter
49 
50 
51 @external
52 @view
53 def totalSupply() -> uint256:
54     """
55     @dev Total number of tokens in existence.
56     """
57     return self.total_supply
58 
59 
60 @external
61 @view
62 def allowance(_owner : address, _spender : address) -> uint256:
63     """
64     @dev Function to check the amount of tokens that an owner allowed to a spender.
65     @param _owner The address which owns the funds.
66     @param _spender The address which will spend the funds.
67     @return An uint256 specifying the amount of tokens still available for the spender.
68     """
69     return self.allowances[_owner][_spender]
70 
71 
72 @external
73 def transfer(_to : address, _value : uint256) -> bool:
74     """
75     @dev Transfer token for a specified address
76     @param _to The address to transfer to.
77     @param _value The amount to be transferred.
78     """
79     # NOTE: vyper does not allow underflows
80     #       so the following subtraction would revert on insufficient balance
81     self.balanceOf[msg.sender] -= _value
82     self.balanceOf[_to] += _value
83     log Transfer(msg.sender, _to, _value)
84     return True
85 
86 
87 @external
88 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
89     """
90      @dev Transfer tokens from one address to another.
91           Note that while this function emits a Transfer event, this is not required as per the specification,
92           and other compliant implementations may not emit the event.
93      @param _from address The address which you want to send tokens from
94      @param _to address The address which you want to transfer to
95      @param _value uint256 the amount of tokens to be transferred
96     """
97     # NOTE: vyper does not allow underflows
98     #       so the following subtraction would revert on insufficient balance
99     self.balanceOf[_from] -= _value
100     self.balanceOf[_to] += _value
101     if msg.sender != self.minter:  # minter is allowed to transfer anything
102         # NOTE: vyper does not allow underflows
103         # so the following subtraction would revert on insufficient allowance
104         self.allowances[_from][msg.sender] -= _value
105     log Transfer(_from, _to, _value)
106     return True
107 
108 
109 @external
110 def approve(_spender : address, _value : uint256) -> bool:
111     """
112     @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
113          Beware that changing an allowance with this method brings the risk that someone may use both the old
114          and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
115          race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
116          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
117     @param _spender The address which will spend the funds.
118     @param _value The amount of tokens to be spent.
119     """
120     assert _value == 0 or self.allowances[msg.sender][_spender] == 0
121     self.allowances[msg.sender][_spender] = _value
122     log Approval(msg.sender, _spender, _value)
123     return True
124 
125 
126 @external
127 def mint(_to: address, _value: uint256):
128     """
129     @dev Mint an amount of the token and assigns it to an account.
130          This encapsulates the modification of balances such that the
131          proper events are emitted.
132     @param _to The account that will receive the created tokens.
133     @param _value The amount that will be created.
134     """
135     assert msg.sender == self.minter
136     assert _to != ZERO_ADDRESS
137     self.total_supply += _value
138     self.balanceOf[_to] += _value
139     log Transfer(ZERO_ADDRESS, _to, _value)
140 
141 
142 @internal
143 def _burn(_to: address, _value: uint256):
144     """
145     @dev Internal function that burns an amount of the token of a given
146          account.
147     @param _to The account whose tokens will be burned.
148     @param _value The amount that will be burned.
149     """
150     assert _to != ZERO_ADDRESS
151     self.total_supply -= _value
152     self.balanceOf[_to] -= _value
153     log Transfer(_to, ZERO_ADDRESS, _value)
154 
155 
156 @external
157 def burn(_value: uint256):
158     """
159     @dev Burn an amount of the token of msg.sender.
160     @param _value The amount that will be burned.
161     """
162     assert msg.sender == self.minter, "Only minter is allowed to burn"
163     self._burn(msg.sender, _value)
164 
165 
166 @external
167 def burnFrom(_to: address, _value: uint256):
168     """
169     @dev Burn an amount of the token from a given account.
170     @param _to The account whose tokens will be burned.
171     @param _value The amount that will be burned.
172     """
173     assert msg.sender == self.minter, "Only minter is allowed to burn"
174     self._burn(_to, _value)