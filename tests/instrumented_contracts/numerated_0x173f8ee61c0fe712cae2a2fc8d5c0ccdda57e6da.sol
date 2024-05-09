1 # https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
2 
3 from vyper.interfaces import ERC20
4 
5 implements: ERC20
6 
7 Transfer: event({_from: indexed(address), _to: indexed(address), _value: uint256})
8 Approval: event({_owner: indexed(address), _spender: indexed(address), _value: uint256})
9 
10 name: public(string[64])
11 symbol: public(string[32])
12 decimals: public(uint256)
13 
14 # NOTE: By declaring `balanceOf` as public, vyper automatically generates a 'balanceOf()' getter
15 #       method to allow access to account balances.
16 #       The _KeyType will become a required parameter for the getter and it will return _ValueType.
17 #       See: https://vyper.readthedocs.io/en/v0.1.0-beta.8/types.html?highlight=getter#mappings
18 balanceOf: public(map(address, uint256))
19 allowances: map(address, map(address, uint256))
20 total_supply: uint256
21 minter: address
22 
23 
24 @public
25 def __init__(_name: string[64], _symbol: string[32], _decimals: uint256, _supply: uint256):
26     init_supply: uint256 = _supply * 10 ** _decimals
27     self.name = _name
28     self.symbol = _symbol
29     self.decimals = _decimals
30     self.balanceOf[msg.sender] = init_supply
31     self.total_supply = init_supply
32     self.minter = msg.sender
33     log.Transfer(ZERO_ADDRESS, msg.sender, init_supply)
34 
35 
36 @public
37 def set_minter(_minter: address):
38     assert msg.sender == self.minter
39     self.minter = _minter
40 
41 
42 @public
43 @constant
44 def totalSupply() -> uint256:
45     """
46     @dev Total number of tokens in existence.
47     """
48     return self.total_supply
49 
50 
51 @public
52 @constant
53 def allowance(_owner : address, _spender : address) -> uint256:
54     """
55     @dev Function to check the amount of tokens that an owner allowed to a spender.
56     @param _owner The address which owns the funds.
57     @param _spender The address which will spend the funds.
58     @return An uint256 specifying the amount of tokens still available for the spender.
59     """
60     return self.allowances[_owner][_spender]
61 
62 
63 @public
64 def transfer(_to : address, _value : uint256) -> bool:
65     """
66     @dev Transfer token for a specified address
67     @param _to The address to transfer to.
68     @param _value The amount to be transferred.
69     """
70     # NOTE: vyper does not allow underflows
71     #       so the following subtraction would revert on insufficient balance
72     self.balanceOf[msg.sender] -= _value
73     self.balanceOf[_to] += _value
74     log.Transfer(msg.sender, _to, _value)
75     return True
76 
77 
78 @public
79 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
80     """
81      @dev Transfer tokens from one address to another.
82           Note that while this function emits a Transfer event, this is not required as per the specification,
83           and other compliant implementations may not emit the event.
84      @param _from address The address which you want to send tokens from
85      @param _to address The address which you want to transfer to
86      @param _value uint256 the amount of tokens to be transferred
87     """
88     # NOTE: vyper does not allow underflows
89     #       so the following subtraction would revert on insufficient balance
90     self.balanceOf[_from] -= _value
91     self.balanceOf[_to] += _value
92     if msg.sender != self.minter:  # minter is allowed to transfer anything
93         # NOTE: vyper does not allow underflows
94         # so the following subtraction would revert on insufficient allowance
95         self.allowances[_from][msg.sender] -= _value
96     log.Transfer(_from, _to, _value)
97     return True
98 
99 
100 @public
101 def approve(_spender : address, _value : uint256) -> bool:
102     """
103     @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
104          Beware that changing an allowance with this method brings the risk that someone may use both the old
105          and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
106          race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
107          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108     @param _spender The address which will spend the funds.
109     @param _value The amount of tokens to be spent.
110     """
111     assert _value == 0 or self.allowances[msg.sender][_spender] == 0
112     self.allowances[msg.sender][_spender] = _value
113     log.Approval(msg.sender, _spender, _value)
114     return True
115 
116 
117 @public
118 def mint(_to: address, _value: uint256):
119     """
120     @dev Mint an amount of the token and assigns it to an account. 
121          This encapsulates the modification of balances such that the
122          proper events are emitted.
123     @param _to The account that will receive the created tokens.
124     @param _value The amount that will be created.
125     """
126     assert msg.sender == self.minter
127     assert _to != ZERO_ADDRESS
128     self.total_supply += _value
129     self.balanceOf[_to] += _value
130     log.Transfer(ZERO_ADDRESS, _to, _value)
131 
132 
133 @private
134 def _burn(_to: address, _value: uint256):
135     """
136     @dev Internal function that burns an amount of the token of a given
137          account.
138     @param _to The account whose tokens will be burned.
139     @param _value The amount that will be burned.
140     """
141     assert _to != ZERO_ADDRESS
142     self.total_supply -= _value
143     self.balanceOf[_to] -= _value
144     log.Transfer(_to, ZERO_ADDRESS, _value)
145 
146 
147 @public
148 def burn(_value: uint256):
149     """
150     @dev Burn an amount of the token of msg.sender.
151     @param _value The amount that will be burned.
152     """
153     assert msg.sender == self.minter, "Only minter is allowed to burn"
154     self._burn(msg.sender, _value)
155 
156 
157 @public
158 def burnFrom(_to: address, _value: uint256):
159     """
160     @dev Burn an amount of the token from a given account.
161     @param _to The account whose tokens will be burned.
162     @param _value The amount that will be burned.
163     """
164     assert msg.sender == self.minter, "Only minter is allowed to burn"
165     self._burn(_to, _value)