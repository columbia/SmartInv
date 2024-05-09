1 # @dev Implementation of ERC-20 token standard.
2 # @author Takayuki Jimba (@yudetamago)
3 # https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
4 
5 from vyper.interfaces import ERC20
6 
7 implements: ERC20
8 
9 event Transfer:
10     sender: indexed(address)
11     receiver: indexed(address)
12     value: uint256
13 
14 event Approval:
15     owner: indexed(address)
16     spender: indexed(address)
17     value: uint256
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
45 @view
46 @external
47 def totalSupply() -> uint256:
48     """
49     @dev Total number of tokens in existence.
50     """
51     return self.total_supply
52 
53 
54 @view
55 @external
56 def allowance(_owner : address, _spender : address) -> uint256:
57     """
58     @dev Function to check the amount of tokens that an owner allowed to a spender.
59     @param _owner The address which owns the funds.
60     @param _spender The address which will spend the funds.
61     @return An uint256 specifying the amount of tokens still available for the spender.
62     """
63     return self.allowances[_owner][_spender]
64 
65 
66 @external
67 def transfer(_to : address, _value : uint256) -> bool:
68     """
69     @dev Transfer token for a specified address
70     @param _to The address to transfer to.
71     @param _value The amount to be transferred.
72     """
73     # NOTE: vyper does not allow underflows
74     #       so the following subtraction would revert on insufficient balance
75     self.balanceOf[msg.sender] -= _value
76     self.balanceOf[_to] += _value
77     log Transfer(msg.sender, _to, _value)
78     return True
79 
80 
81 @external
82 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
83     """
84      @dev Transfer tokens from one address to another.
85      @param _from address The address which you want to send tokens from
86      @param _to address The address which you want to transfer to
87      @param _value uint256 the amount of tokens to be transferred
88     """
89     # NOTE: vyper does not allow underflows
90     #       so the following subtraction would revert on insufficient balance
91     self.balanceOf[_from] -= _value
92     self.balanceOf[_to] += _value
93     # NOTE: vyper does not allow underflows
94     #      so the following subtraction would revert on insufficient allowance
95     self.allowances[_from][msg.sender] -= _value
96     log Transfer(_from, _to, _value)
97     return True
98 
99 
100 @external
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
111     self.allowances[msg.sender][_spender] = _value
112     log Approval(msg.sender, _spender, _value)
113     return True
114 
115 
116 @external
117 def mint(_to: address, _value: uint256):
118     """
119     @dev Mint an amount of the token and assigns it to an account.
120          This encapsulates the modification of balances such that the
121          proper events are emitted.
122     @param _to The account that will receive the created tokens.
123     @param _value The amount that will be created.
124     """
125     assert msg.sender == self.minter
126     assert _to != ZERO_ADDRESS
127     self.total_supply += _value
128     self.balanceOf[_to] += _value
129     log Transfer(ZERO_ADDRESS, _to, _value)
130 
131 
132 @internal
133 def _burn(_to: address, _value: uint256):
134     """
135     @dev Internal function that burns an amount of the token of a given
136          account.
137     @param _to The account whose tokens will be burned.
138     @param _value The amount that will be burned.
139     """
140     assert _to != ZERO_ADDRESS
141     self.total_supply -= _value
142     self.balanceOf[_to] -= _value
143     log Transfer(_to, ZERO_ADDRESS, _value)
144 
145 
146 @external
147 def burn(_value: uint256):
148     """
149     @dev Burn an amount of the token of msg.sender.
150     @param _value The amount that will be burned.
151     """
152     self._burn(msg.sender, _value)
153 
154 
155 @external
156 def burnFrom(_to: address, _value: uint256):
157     """
158     @dev Burn an amount of the token from a given account.
159     @param _to The account whose tokens will be burned.
160     @param _value The amount that will be burned.
161     """
162     self.allowances[_to][msg.sender] -= _value
163     self._burn(_to, _value)