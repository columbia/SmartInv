1 from vyper.interfaces import ERC20
2 
3 implements: ERC20
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
17 allowances: map(address, map(address, uint256))
18 total_supply: uint256
19 minter: address
20 
21 
22 @public
23 def __init__(_name: string[64], _symbol: string[32], _decimals: uint256, _supply: uint256):
24     init_supply: uint256 = _supply * 10 ** _decimals
25     self.name = _name
26     self.symbol = _symbol
27     self.decimals = _decimals
28     self.balanceOf[msg.sender] = init_supply
29     self.total_supply = init_supply
30     self.minter = msg.sender
31     log.Transfer(ZERO_ADDRESS, msg.sender, init_supply)
32 
33 
34 @public
35 @constant
36 def totalSupply() -> uint256:
37     """
38     @dev Total number of tokens in existence.
39     """
40     return self.total_supply
41 
42 
43 @public
44 @constant
45 def allowance(_owner : address, _spender : address) -> uint256:
46     """
47     @dev Function to check the amount of tokens that an owner allowed to a spender.
48     @param _owner The address which owns the funds.
49     @param _spender The address which will spend the funds.
50     @return An uint256 specifying the amount of tokens still available for the spender.
51     """
52     return self.allowances[_owner][_spender]
53 
54 
55 @public
56 def transfer(_to : address, _value : uint256) -> bool:
57     """
58     @dev Transfer token for a specified address
59     @param _to The address to transfer to.
60     @param _value The amount to be transferred.
61     """
62     # NOTE: vyper does not allow underflows
63     #       so the following subtraction would revert on insufficient balance
64     self.balanceOf[msg.sender] -= _value
65     self.balanceOf[_to] += _value
66     log.Transfer(msg.sender, _to, _value)
67     return True
68 
69 
70 @public
71 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
72     """
73      @dev Transfer tokens from one address to another.
74           Note that while this function emits a Transfer event, this is not required as per the specification,
75           and other compliant implementations may not emit the event.
76      @param _from address The address which you want to send tokens from
77      @param _to address The address which you want to transfer to
78      @param _value uint256 the amount of tokens to be transferred
79     """
80     # NOTE: vyper does not allow underflows
81     #       so the following subtraction would revert on insufficient balance
82     self.balanceOf[_from] -= _value
83     self.balanceOf[_to] += _value
84     # NOTE: vyper does not allow underflows
85     #      so the following subtraction would revert on insufficient allowance
86     self.allowances[_from][msg.sender] -= _value
87     log.Transfer(_from, _to, _value)
88     return True
89 
90 
91 @public
92 def approve(_spender : address, _value : uint256) -> bool:
93     """
94     @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
95          Beware that changing an allowance with this method brings the risk that someone may use both the old
96          and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
97          race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
98          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
99     @param _spender The address which will spend the funds.
100     @param _value The amount of tokens to be spent.
101     """
102     self.allowances[msg.sender][_spender] = _value
103     log.Approval(msg.sender, _spender, _value)
104     return True
105 
106 
107 @public
108 def mint(_to: address, _value: uint256):
109     """
110     @dev Mint an amount of the token and assigns it to an account. 
111          This encapsulates the modification of balances such that the
112          proper events are emitted.
113     @param _to The account that will receive the created tokens.
114     @param _value The amount that will be created.
115     """
116     assert msg.sender == self.minter
117     assert _to != ZERO_ADDRESS
118     self.total_supply += _value
119     self.balanceOf[_to] += _value
120     log.Transfer(ZERO_ADDRESS, _to, _value)
121 
122 
123 @private
124 def _burn(_to: address, _value: uint256):
125     """
126     @dev Internal function that burns an amount of the token of a given
127          account.
128     @param _to The account whose tokens will be burned.
129     @param _value The amount that will be burned.
130     """
131     assert _to != ZERO_ADDRESS
132     self.total_supply -= _value
133     self.balanceOf[_to] -= _value
134     log.Transfer(_to, ZERO_ADDRESS, _value)
135 
136 
137 @public
138 def burn(_value: uint256):
139     """
140     @dev Burn an amount of the token of msg.sender.
141     @param _value The amount that will be burned.
142     """
143     self._burn(msg.sender, _value)
144 
145 
146 @public
147 def burnFrom(_to: address, _value: uint256):
148     """
149     @dev Burn an amount of the token from a given account.
150     @param _to The account whose tokens will be burned.
151     @param _value The amount that will be burned.
152     """
153     self.allowances[_to][msg.sender] -= _value
154     self._burn(_to, _value)