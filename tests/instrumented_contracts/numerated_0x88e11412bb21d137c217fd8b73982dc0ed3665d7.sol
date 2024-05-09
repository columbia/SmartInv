1 # from https://etherscan.io/address/0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490#code
2 # @version 0.2.8
3 # https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
4 
5 from vyper.interfaces import ERC20
6 
7 implements: ERC20
8 
9 interface Curve:
10     def owner() -> address: view
11 
12 
13 event Transfer:
14     _from: indexed(address)
15     _to: indexed(address)
16     _value: uint256
17 
18 event Approval:
19     _owner: indexed(address)
20     _spender: indexed(address)
21     _value: uint256
22 
23 
24 name: public(String[64])
25 symbol: public(String[32])
26 decimals: public(uint256)
27 
28 # NOTE: By declaring `balanceOf` as public, vyper automatically generates a 'balanceOf()' getter
29 #       method to allow access to account balances.
30 #       The _KeyType will become a required parameter for the getter and it will return _ValueType.
31 #       See: https://vyper.readthedocs.io/en/v0.1.0-beta.8/types.html?highlight=getter#mappings
32 balanceOf: public(HashMap[address, uint256])
33 allowances: HashMap[address, HashMap[address, uint256]]
34 total_supply: uint256
35 minter: address
36 
37 
38 @external
39 def __init__(_name: String[64], _symbol: String[32], _decimals: uint256, _supply: uint256):
40     init_supply: uint256 = _supply * 10 ** _decimals
41     self.name = _name
42     self.symbol = _symbol
43     self.decimals = _decimals
44     self.balanceOf[msg.sender] = init_supply
45     self.total_supply = init_supply
46     self.minter = msg.sender
47     log Transfer(ZERO_ADDRESS, msg.sender, init_supply)
48 
49 
50 @external
51 def set_minter(_minter: address):
52     assert msg.sender == self.minter
53     self.minter = _minter
54 
55 
56 @external
57 def set_name(_name: String[64], _symbol: String[32]):
58     assert Curve(self.minter).owner() == msg.sender
59     self.name = _name
60     self.symbol = _symbol
61 
62 
63 @view
64 @external
65 def totalSupply() -> uint256:
66     """
67     @dev Total number of tokens in existence.
68     """
69     return self.total_supply
70 
71 
72 @view
73 @external
74 def allowance(_owner : address, _spender : address) -> uint256:
75     """
76     @dev Function to check the amount of tokens that an owner allowed to a spender.
77     @param _owner The address which owns the funds.
78     @param _spender The address which will spend the funds.
79     @return An uint256 specifying the amount of tokens still available for the spender.
80     """
81     return self.allowances[_owner][_spender]
82 
83 
84 @external
85 def transfer(_to : address, _value : uint256) -> bool:
86     """
87     @dev Transfer token for a specified address
88     @param _to The address to transfer to.
89     @param _value The amount to be transferred.
90     """
91     # NOTE: vyper does not allow underflows
92     #       so the following subtraction would revert on insufficient balance
93     self.balanceOf[msg.sender] -= _value
94     self.balanceOf[_to] += _value
95     log Transfer(msg.sender, _to, _value)
96     return True
97 
98 
99 @external
100 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
101     """
102      @dev Transfer tokens from one address to another.
103      @param _from address The address which you want to send tokens from
104      @param _to address The address which you want to transfer to
105      @param _value uint256 the amount of tokens to be transferred
106     """
107     # NOTE: vyper does not allow underflows
108     #       so the following subtraction would revert on insufficient balance
109     self.balanceOf[_from] -= _value
110     self.balanceOf[_to] += _value
111     if msg.sender != self.minter:  # minter is allowed to transfer anything
112         # NOTE: vyper does not allow underflows
113         # so the following subtraction would revert on insufficient allowance
114         self.allowances[_from][msg.sender] -= _value
115     log Transfer(_from, _to, _value)
116     return True
117 
118 
119 @external
120 def approve(_spender : address, _value : uint256) -> bool:
121     """
122     @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
123          Beware that changing an allowance with this method brings the risk that someone may use both the old
124          and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
125          race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
126          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127     @param _spender The address which will spend the funds.
128     @param _value The amount of tokens to be spent.
129     """
130     assert _value == 0 or self.allowances[msg.sender][_spender] == 0
131     self.allowances[msg.sender][_spender] = _value
132     log Approval(msg.sender, _spender, _value)
133     return True
134 
135 
136 @external
137 def mint(_to: address, _value: uint256) -> bool:
138     """
139     @dev Mint an amount of the token and assigns it to an account.
140          This encapsulates the modification of balances such that the
141          proper events are emitted.
142     @param _to The account that will receive the created tokens.
143     @param _value The amount that will be created.
144     """
145     assert msg.sender == self.minter
146     assert _to != ZERO_ADDRESS
147     self.total_supply += _value
148     self.balanceOf[_to] += _value
149     log Transfer(ZERO_ADDRESS, _to, _value)
150     return True
151 
152 
153 @external
154 def burnFrom(_to: address, _value: uint256) -> bool:
155     """
156     @dev Burn an amount of the token from a given account.
157     @param _to The account whose tokens will be burned.
158     @param _value The amount that will be burned.
159     """
160     assert msg.sender == self.minter
161     assert _to != ZERO_ADDRESS
162 
163     self.total_supply -= _value
164     self.balanceOf[_to] -= _value
165     log Transfer(_to, ZERO_ADDRESS, _value)
166 
167     return True