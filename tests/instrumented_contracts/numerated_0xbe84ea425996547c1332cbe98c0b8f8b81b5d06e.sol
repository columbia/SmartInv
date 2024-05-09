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
12 balanceOf: public(map(address, uint256))
13 allowances: map(address, map(address, uint256))
14 total_supply: uint256
15 minter: address
16 
17 
18 @public
19 def __init__(_name: string[64], _symbol: string[32], _decimals: uint256, _supply: uint256):
20     init_supply: uint256 = _supply * 10 ** _decimals
21     self.name = _name
22     self.symbol = _symbol
23     self.decimals = _decimals
24     self.balanceOf[msg.sender] = init_supply
25     self.total_supply = init_supply
26     self.minter = msg.sender
27     log.Transfer(ZERO_ADDRESS, msg.sender, init_supply)
28 
29 
30 @public
31 @constant
32 def totalSupply() -> uint256:
33     """
34     @dev Total number of tokens in existence.
35     """
36     return self.total_supply
37 
38 
39 @public
40 @constant
41 def allowance(_owner : address, _spender : address) -> uint256:
42     """
43     @dev Function to check the amount of tokens that an owner allowed to a spender.
44     @param _owner The address which owns the funds.
45     @param _spender The address which will spend the funds.
46     @return An uint256 specifying the amount of tokens still available for the spender.
47     """
48     return self.allowances[_owner][_spender]
49 
50 
51 @public
52 def transfer(_to : address, _value : uint256) -> bool:
53     """
54     @dev Transfer token for a specified address
55     @param _to The address to transfer to.
56     @param _value The amount to be transferred.
57     """
58 
59     self.balanceOf[msg.sender] -= _value
60     self.balanceOf[_to] += _value
61     log.Transfer(msg.sender, _to, _value)
62     return True
63 
64 
65 @public
66 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
67     """
68      @dev Transfer tokens from one address to another.
69           Note that while this function emits a Transfer event, this is not required as per the specification,
70           and other compliant implementations may not emit the event.
71      @param _from address The address which you want to send tokens from
72      @param _to address The address which you want to transfer to
73      @param _value uint256 the amount of tokens to be transferred
74     """
75     
76     self.balanceOf[_from] -= _value
77     self.balanceOf[_to] += _value
78 
79     self.allowances[_from][msg.sender] -= _value
80     log.Transfer(_from, _to, _value)
81     return True
82 
83 
84 @public
85 def approve(_spender : address, _value : uint256) -> bool:
86     """
87     @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
88          Beware that changing an allowance with this method brings the risk that someone may use both the old
89          and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
90          race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
91          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
92     @param _spender The address which will spend the funds.
93     @param _value The amount of tokens to be spent.
94     """
95     self.allowances[msg.sender][_spender] = _value
96     log.Approval(msg.sender, _spender, _value)
97     return True
98 
99 
100 @public
101 def mint(_to: address, _value: uint256):
102     """
103     @dev Mint an amount of the token and assigns it to an account. 
104          This encapsulates the modification of balances such that the
105          proper events are emitted.
106     @param _to The account that will receive the created tokens.
107     @param _value The amount that will be created.
108     """
109     assert msg.sender == self.minter
110     assert _to != ZERO_ADDRESS
111     self.total_supply += _value
112     self.balanceOf[_to] += _value
113     log.Transfer(ZERO_ADDRESS, _to, _value)
114 
115 
116 @private
117 def _burn(_to: address, _value: uint256):
118     """
119     @dev Internal function that burns an amount of the token of a given
120          account.
121     @param _to The account whose tokens will be burned.
122     @param _value The amount that will be burned.
123     """
124     assert _to != ZERO_ADDRESS
125     self.total_supply -= _value
126     self.balanceOf[_to] -= _value
127     log.Transfer(_to, ZERO_ADDRESS, _value)
128 
129 
130 @public
131 def burn(_value: uint256):
132     """
133     @dev Burn an amount of the token of msg.sender.
134     @param _value The amount that will be burned.
135     """
136     self._burn(msg.sender, _value)
137 
138 
139 @public
140 def burnFrom(_to: address, _value: uint256):
141     """
142     @dev Burn an amount of the token from a given account.
143     @param _to The account whose tokens will be burned.
144     @param _value The amount that will be burned.
145     """
146     self.allowances[_to][msg.sender] -= _value
147     self._burn(_to, _value)