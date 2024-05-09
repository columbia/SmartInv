1 # @version 0.2.8
2 from vyper.interfaces import ERC20
3 
4 implements: ERC20
5 
6 
7 event Transfer:
8     sender: indexed(address)
9     receiver: indexed(address)
10     value: uint256
11 
12 
13 event Approval:
14     owner: indexed(address)
15     spender: indexed(address)
16     value: uint256
17 
18 
19 name: public(String[64])
20 symbol: public(String[32])
21 decimals: public(uint256)
22 balanceOf: public(HashMap[address, uint256])
23 allowances: HashMap[address, HashMap[address, uint256]]
24 totalSupply: public(uint256)
25 COL: constant(address) = 0xC76FB75950536d98FA62ea968E1D6B45ffea2A55
26 DEAD: constant(address) = 0x000000000000000000000000000000000000dEaD
27 RATIO: constant(uint256) = 100  # 1 DUCK equals 100 COL
28 
29 
30 @external
31 def __init__():
32     self.name = 'Unit Protocol'
33     self.symbol = 'DUCK'
34     self.decimals = 18
35 
36 
37 @external
38 def quack():
39     """
40     Migrate and burn COL for DUCK. Quack quack.
41     """
42     cols: uint256 = ERC20(COL).balanceOf(msg.sender)
43     ducks: uint256 = cols / RATIO
44     assert ERC20(COL).transferFrom(msg.sender, DEAD, cols)  # dev: not approved
45     self.totalSupply += ducks
46     self.balanceOf[msg.sender] += ducks
47     log Transfer(ZERO_ADDRESS, msg.sender, ducks)
48 
49 
50 @view
51 @external
52 def allowance(owner: address, spender: address) -> uint256:
53     return self.allowances[owner][spender]
54 
55 
56 @external
57 def transfer(receiver: address, amount: uint256) -> bool:
58     assert receiver not in [self, ZERO_ADDRESS]
59     self.balanceOf[msg.sender] -= amount
60     self.balanceOf[receiver] += amount
61     log Transfer(msg.sender, receiver, amount)
62     return True
63 
64 
65 @external
66 def transferFrom(owner: address, receiver: address, amount: uint256) -> bool:
67     assert receiver not in [self, ZERO_ADDRESS]
68     self.balanceOf[owner] -= amount
69     self.balanceOf[receiver] += amount
70     if owner != msg.sender and self.allowances[owner][msg.sender] != MAX_UINT256:
71         self.allowances[owner][msg.sender] -= amount
72         log Approval(owner, msg.sender, self.allowances[owner][msg.sender])
73     log Transfer(owner, receiver, amount)
74     return True
75 
76 
77 @external
78 def approve(spender: address, amount: uint256) -> bool:
79     self.allowances[msg.sender][spender] = amount
80     log Approval(msg.sender, spender, amount)
81     return True
82 
83 
84 @external
85 def burn(amount: uint256):
86     self.totalSupply -= amount
87     self.balanceOf[msg.sender] -= amount
88     log Transfer(msg.sender, ZERO_ADDRESS, amount)