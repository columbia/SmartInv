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
32 decimals: public(uint256)
33 
34 # NOTE: By declaring `balanceOf` as public, vyper automatically generates a 'balanceOf()' getter
35 #       method to allow access to account balances.
36 #       The _KeyType will become a required parameter for the getter and it will return _ValueType.
37 #       See: https://vyper.readthedocs.io/en/v0.1.0-beta.8/types.html?highlight=getter#mappings
38 balanceOf: public(HashMap[address, uint256])
39 allowances: HashMap[address, HashMap[address, uint256]]
40 total_supply: uint256
41 minter: public(address)
42 
43 
44 @external
45 def __init__(_name: String[64], _symbol: String[32], _decimals: uint256, _supply: uint256):
46     init_supply: uint256 = _supply * 10 ** _decimals
47     self.name = _name
48     self.symbol = _symbol
49     self.decimals = _decimals
50     self.balanceOf[msg.sender] = init_supply
51     self.total_supply = init_supply
52     self.minter = msg.sender
53     log Transfer(ZERO_ADDRESS, msg.sender, init_supply)
54 
55 
56 @external
57 def set_minter(_minter: address):
58     assert msg.sender == self.minter
59     self.minter = _minter
60 
61 
62 @external
63 def set_name(_name: String[64], _symbol: String[32]):
64     assert Curve(self.minter).owner() == msg.sender
65     self.name = _name
66     self.symbol = _symbol
67 
68 
69 @view
70 @external
71 def totalSupply() -> uint256:
72     """
73     @dev Total number of tokens in existence.
74     """
75     return self.total_supply
76 
77 
78 @view
79 @external
80 def allowance(_owner : address, _spender : address) -> uint256:
81     """
82     @dev Function to check the amount of tokens that an owner allowed to a spender.
83     @param _owner The address which owns the funds.
84     @param _spender The address which will spend the funds.
85     @return An uint256 specifying the amount of tokens still available for the spender.
86     """
87     return self.allowances[_owner][_spender]
88 
89 
90 @external
91 def transfer(_to : address, _value : uint256) -> bool:
92     """
93     @dev Transfer token for a specified address
94     @param _to The address to transfer to.
95     @param _value The amount to be transferred.
96     """
97     # NOTE: vyper does not allow underflows
98     #       so the following subtraction would revert on insufficient balance
99     self.balanceOf[msg.sender] -= _value
100     self.balanceOf[_to] += _value
101     log Transfer(msg.sender, _to, _value)
102     return True
103 
104 
105 @external
106 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
107     """
108      @dev Transfer tokens from one address to another.
109      @param _from address The address which you want to send tokens from
110      @param _to address The address which you want to transfer to
111      @param _value uint256 the amount of tokens to be transferred
112     """
113     # NOTE: vyper does not allow underflows
114     #       so the following subtraction would revert on insufficient balance
115     self.balanceOf[_from] -= _value
116     self.balanceOf[_to] += _value
117     if msg.sender != self.minter:  # minter is allowed to transfer anything
118         _allowance: uint256 = self.allowances[_from][msg.sender]
119         if _allowance != MAX_UINT256:
120             # NOTE: vyper does not allow underflows
121             # so the following subtraction would revert on insufficient allowance
122             self.allowances[_from][msg.sender] = _allowance - _value
123     log Transfer(_from, _to, _value)
124     return True
125 
126 
127 @external
128 def approve(_spender : address, _value : uint256) -> bool:
129     """
130     @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
131          Beware that changing an allowance with this method brings the risk that someone may use both the old
132          and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
133          race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
134          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135     @param _spender The address which will spend the funds.
136     @param _value The amount of tokens to be spent.
137     """
138     assert _value == 0 or self.allowances[msg.sender][_spender] == 0
139     self.allowances[msg.sender][_spender] = _value
140     log Approval(msg.sender, _spender, _value)
141     return True
142 
143 
144 @external
145 def mint(_to: address, _value: uint256) -> bool:
146     """
147     @dev Mint an amount of the token and assigns it to an account.
148          This encapsulates the modification of balances such that the
149          proper events are emitted.
150     @param _to The account that will receive the created tokens.
151     @param _value The amount that will be created.
152     """
153     assert msg.sender == self.minter
154     assert _to != ZERO_ADDRESS
155     self.total_supply += _value
156     self.balanceOf[_to] += _value
157     log Transfer(ZERO_ADDRESS, _to, _value)
158     return True
159 
160 
161 @external
162 def burnFrom(_to: address, _value: uint256) -> bool:
163     """
164     @dev Burn an amount of the token from a given account.
165     @param _to The account whose tokens will be burned.
166     @param _value The amount that will be burned.
167     """
168     assert msg.sender == self.minter
169     assert _to != ZERO_ADDRESS
170 
171     self.total_supply -= _value
172     self.balanceOf[_to] -= _value
173     log Transfer(_to, ZERO_ADDRESS, _value)
174 
175     return True