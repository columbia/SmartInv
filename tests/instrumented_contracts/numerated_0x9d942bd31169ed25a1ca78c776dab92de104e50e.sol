1 # ERC20 implementation adapted from https://github.com/ethereum/vyper/blob/master/examples/tokens/ERC20.vy
2 
3 Transfer: event({_from: indexed(address), _to: indexed(address), _value: uint256})
4 Approval: event({_owner: indexed(address), _spender: indexed(address), _value: uint256})
5 
6 name: public(string[32])
7 symbol: public(string[32])
8 decimals: public(uint256)
9 totalSupply: public(uint256)
10 balanceOf: public(map(address, uint256))
11 allowances: map(address, map(address, uint256))
12 
13 
14 @public
15 def __init__():
16     _supply: uint256 = 500*10**18
17     self.name = 'Unisocks Edition 0'
18     self.symbol = 'SOCKS'
19     self.decimals = 18
20     self.balanceOf[msg.sender] = _supply
21     self.totalSupply = _supply
22     log.Transfer(ZERO_ADDRESS, msg.sender, _supply)
23 
24 
25 @public
26 @constant
27 def allowance(_owner : address, _spender : address) -> uint256:
28     return self.allowances[_owner][_spender]
29 
30 
31 @public
32 def transfer(_to : address, _value : uint256) -> bool:
33     self.balanceOf[msg.sender] -= _value
34     self.balanceOf[_to] += _value
35     log.Transfer(msg.sender, _to, _value)
36     return True
37 
38 
39 @public
40 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
41     self.balanceOf[_from] -= _value
42     self.balanceOf[_to] += _value
43     if self.allowances[_from][msg.sender] < MAX_UINT256:
44         self.allowances[_from][msg.sender] -= _value
45     log.Transfer(_from, _to, _value)
46     return True
47 
48 
49 @public
50 def approve(_spender : address, _value : uint256) -> bool:
51     self.allowances[msg.sender][_spender] = _value
52     log.Approval(msg.sender, _spender, _value)
53     return True
54 
55 
56 @public
57 def burn(_value: uint256) -> bool:
58     self.totalSupply -= _value
59     self.balanceOf[msg.sender] -= _value
60     log.Transfer(msg.sender, ZERO_ADDRESS, _value)
61     return True
62 
63 
64 @public
65 def burnFrom(_from: address, _value: uint256) -> bool:
66     if self.allowances[_from][msg.sender] < MAX_UINT256:
67         self.allowances[_from][msg.sender] -= _value
68     self.totalSupply -= _value
69     self.balanceOf[_from] -= _value
70     log.Transfer(_from, ZERO_ADDRESS, _value)
71     return True