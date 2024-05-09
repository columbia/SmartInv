1 # @version 0.2.4
2 # https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 
4 from vyper.interfaces import ERC20
5 
6 implements: ERC20
7 
8 interface Curve:
9     def owner() -> address: view
10 
11 
12 event Transfer:
13     _from: indexed(address)
14     _to: indexed(address)
15     _value: uint256
16 
17 event Approval:
18     _owner: indexed(address)
19     _spender: indexed(address)
20     _value: uint256
21 
22 
23 name: public(String[64])
24 symbol: public(String[32])
25 decimals: public(uint256)
26 
27 # NOTE: By declaring `balanceOf` as public, vyper automatically generates a 'balanceOf()' getter
28 #       method to allow access to account balances.
29 #       The _KeyType will become a required parameter for the getter and it will return _ValueType.
30 #       See: https://vyper.readthedocs.io/en/v0.1.0-beta.8/types.html?highlight=getter#mappings
31 balanceOf: public(HashMap[address, uint256])
32 allowances: HashMap[address, HashMap[address, uint256]]
33 total_supply: uint256
34 minter: address
35 
36 
37 @external
38 def __init__(_name: String[64], _symbol: String[32], _decimals: uint256, _supply: uint256):
39     init_supply: uint256 = _supply * 10 ** _decimals
40     self.name = _name
41     self.symbol = _symbol
42     self.decimals = _decimals
43     self.balanceOf[msg.sender] = init_supply
44     self.total_supply = init_supply
45     self.minter = msg.sender
46     log Transfer(ZERO_ADDRESS, msg.sender, init_supply)
47 
48 
49 @external
50 def set_minter(_minter: address):
51     assert msg.sender == self.minter
52     self.minter = _minter
53 
54 
55 @external
56 def set_name(_name: String[64], _symbol: String[32]):
57     assert Curve(self.minter).owner() == msg.sender
58     self.name = _name
59     self.symbol = _symbol
60 
61 
62 @view
63 @external
64 def totalSupply() -> uint256:
65     """
66     @dev Total number of tokens in existence.
67     """
68     return self.total_supply
69 
70 
71 @view
72 @external
73 def allowance(_owner : address, _spender : address) -> uint256:
74     """
75     @dev Function to check the amount of tokens that an owner allowed to a spender.
76     @param _owner The address which owns the funds.
77     @param _spender The address which will spend the funds.
78     @return An uint256 specifying the amount of tokens still available for the spender.
79     """
80     return self.allowances[_owner][_spender]
81 
82 
83 @external
84 def transfer(_to : address, _value : uint256) -> bool:
85     """
86     @dev Transfer token for a specified address
87     @param _to The address to transfer to.
88     @param _value The amount to be transferred.
89     """
90     # NOTE: vyper does not allow underflows
91     #       so the following subtraction would revert on insufficient balance
92     self.balanceOf[msg.sender] -= _value
93     self.balanceOf[_to] += _value
94     log Transfer(msg.sender, _to, _value)
95     return True
96 
97 
98 @external
99 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
100     """
101      @dev Transfer tokens from one address to another.
102      @param _from address The address which you want to send tokens from
103      @param _to address The address which you want to transfer to
104      @param _value uint256 the amount of tokens to be transferred
105     """
106     # NOTE: vyper does not allow underflows
107     #       so the following subtraction would revert on insufficient balance
108     self.balanceOf[_from] -= _value
109     self.balanceOf[_to] += _value
110     if msg.sender != self.minter:  # minter is allowed to transfer anything
111         # NOTE: vyper does not allow underflows
112         # so the following subtraction would revert on insufficient allowance
113         self.allowances[_from][msg.sender] -= _value
114     log Transfer(_from, _to, _value)
115     return True
116 
117 
118 @external
119 def approve(_spender : address, _value : uint256) -> bool:
120     """
121     @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
122          Beware that changing an allowance with this method brings the risk that someone may use both the old
123          and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
124          race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
125          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126     @param _spender The address which will spend the funds.
127     @param _value The amount of tokens to be spent.
128     """
129     assert _value == 0 or self.allowances[msg.sender][_spender] == 0
130     self.allowances[msg.sender][_spender] = _value
131     log Approval(msg.sender, _spender, _value)
132     return True
133 
134 
135 @external
136 def mint(_to: address, _value: uint256) -> bool:
137     """
138     @dev Mint an amount of the token and assigns it to an account.
139          This encapsulates the modification of balances such that the
140          proper events are emitted.
141     @param _to The account that will receive the created tokens.
142     @param _value The amount that will be created.
143     """
144     assert msg.sender == self.minter
145     assert _to != ZERO_ADDRESS
146     self.total_supply += _value
147     self.balanceOf[_to] += _value
148     log Transfer(ZERO_ADDRESS, _to, _value)
149     return True
150 
151 
152 @external
153 def burnFrom(_to: address, _value: uint256) -> bool:
154     """
155     @dev Burn an amount of the token from a given account.
156     @param _to The account whose tokens will be burned.
157     @param _value The amount that will be burned.
158     """
159     assert msg.sender == self.minter
160     assert _to != ZERO_ADDRESS
161 
162     self.total_supply -= _value
163     self.balanceOf[_to] -= _value
164     log Transfer(_to, ZERO_ADDRESS, _value)
165 
166     return True