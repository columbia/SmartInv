1 # @dev Implementation of ERC-20 token standard.
2 # @author Takayuki Jimba (@yudetamago)
3 # https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
4 
5 Transfer: event({_from: indexed(address), _to: indexed(address), _value: uint256})
6 Approval: event({_owner: indexed(address), _spender: indexed(address), _value: uint256})
7 
8 name: public(string[64])
9 symbol: public(string[32])
10 decimals: public(uint256)
11 
12 # NOTE: By declaring `balanceOf` as public, vyper automatically generates a 'balanceOf()' getter
13 #       method to allow access to account balances.
14 #       The _KeyType will become a required parameter for the getter and it will return _ValueType.
15 #       See: https://vyper.readthedocs.io/en/v0.1.0-beta.8/types.html?highlight=getter#mappings
16 balanceOf: public(map(address, uint256))
17 burninatedBy: public(map(address, uint256))
18 top_burninators: address[10]
19 allowances: map(address, map(address, uint256))
20 total_supply: uint256
21 total_burninated: uint256
22 minter: address
23 
24 
25 @public
26 def __init__(_name: string[64], _symbol: string[32], _decimals: uint256, _supply: uint256):
27     init_supply: uint256 = _supply * 10 ** _decimals
28     self.name = _name
29     self.symbol = _symbol
30     self.decimals = _decimals
31     self.balanceOf[msg.sender] = init_supply
32     self.total_supply = init_supply
33     self.minter = msg.sender
34     log.Transfer(ZERO_ADDRESS, msg.sender, init_supply)
35 
36 @public
37 @constant
38 def topBurninators() -> address[10]:
39     return self.top_burninators
40 
41 @public
42 @constant
43 def totalSupply() -> uint256:
44     """
45     @dev Total number of tokens in existence.
46     """
47     return self.total_supply
48 
49 
50 @public
51 @constant
52 def allowance(_owner : address, _spender : address) -> uint256:
53     """
54     @dev Function to check the amount of tokens that an owner allowed to a spender.
55     @param _owner The address which owns the funds.
56     @param _spender The address which will spend the funds.
57     @return An uint256 specifying the amount of tokens still available for the spender.
58     """
59     return self.allowances[_owner][_spender]
60 
61 
62 @public
63 def transfer(_to : address, _value : uint256) -> bool:
64     """
65     @dev Transfer token for a specified address
66     @param _to The address to transfer to.
67     @param _value The amount to be transferred.
68     """
69     # NOTE: vyper does not allow underflows
70     #       so the following subtraction would revert on insufficient balance
71     self.balanceOf[msg.sender] -= _value
72     self.balanceOf[_to] += _value
73     log.Transfer(msg.sender, _to, _value)
74     return True
75 
76 
77 @public
78 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
79     """
80      @dev Transfer tokens from one address to another.
81           Note that while this function emits a Transfer event, this is not required as per the specification,
82           and other compliant implementations may not emit the event.
83      @param _from address The address which you want to send tokens from
84      @param _to address The address which you want to transfer to
85      @param _value uint256 the amount of tokens to be transferred
86     """
87     # NOTE: vyper does not allow underflows
88     #       so the following subtraction would revert on insufficient balance
89     self.balanceOf[_from] -= _value
90     self.balanceOf[_to] += _value
91     # NOTE: vyper does not allow underflows
92     #      so the following subtraction would revert on insufficient allowance
93     self.allowances[_from][msg.sender] -= _value
94     log.Transfer(_from, _to, _value)
95     return True
96 
97 
98 @public
99 def approve(_spender : address, _value : uint256) -> bool:
100     """
101     @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
102          Beware that changing an allowance with this method brings the risk that someone may use both the old
103          and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
104          race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
105          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106     @param _spender The address which will spend the funds.
107     @param _value The amount of tokens to be spent.
108     """
109     self.allowances[msg.sender][_spender] = _value
110     log.Approval(msg.sender, _spender, _value)
111     return True
112 
113 
114 @public
115 def mint(_to: address, _value: uint256):
116     """
117     @dev Mint an amount of the token and assigns it to an account. 
118          This encapsulates the modification of balances such that the
119          proper events are emitted.
120     @param _to The account that will receive the created tokens.
121     @param _value The amount that will be created.
122     """
123     assert msg.sender == self.minter
124     assert _to != ZERO_ADDRESS
125     self.total_supply += _value
126     self.balanceOf[_to] += _value
127     log.Transfer(ZERO_ADDRESS, _to, _value)
128 
129 @private
130 def _burn(_to: address, _value: uint256):
131     """
132     @dev Internal function that burns an amount of the token of a given
133          account.
134     @param _to The account whose tokens will be burned.
135     @param _value The amount that will be burned.
136     """
137     assert _to != ZERO_ADDRESS
138     self.total_supply -= _value
139     self.balanceOf[_to] -= _value
140     self.burninatedBy[_to] += _value
141     log.Transfer(_to, ZERO_ADDRESS, _value)
142 
143 @public
144 def burn(_value: uint256):
145     """
146     @dev Burn an amount of the token of msg.sender.
147     @param _value The amount that will be burned.
148     """
149     self._burn(msg.sender, _value)
150 
151 @public
152 def burnFrom(_to: address, _value: uint256):
153     """
154     @dev Burn an amount of the token from a given account.
155     @param _to The account whose tokens will be burned.
156     @param _value The amount that will be burned.
157     """
158     self.allowances[_to][msg.sender] -= _value
159     self._burn(_to, _value)
160 
161 @public
162 def claimVictory() -> bool:
163     weakest_burninator: int128  
164     for i in range(10):
165         if msg.sender == self.top_burninators[i]:
166             return True
167         if self.burninatedBy[self.top_burninators[weakest_burninator]] > self.burninatedBy[self.top_burninators[i]]:
168             weakest_burninator = i
169     assert self.burninatedBy[self.top_burninators[weakest_burninator]] < self.burninatedBy[msg.sender]
170     self.top_burninators[weakest_burninator] = msg.sender
171     return True