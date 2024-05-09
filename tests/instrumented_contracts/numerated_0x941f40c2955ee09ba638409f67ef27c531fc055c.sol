1 # Contract multisend
2 # This contract is meant to send ethereum
3 # and ethereum tokens to several addresses
4 # in at most two ethereum transactions
5 
6 # erc20 token abstract
7 class Token():
8     def transfer(_to: address, _value: uint256) -> bool: modifying
9     def transferFrom(_from: address, _to: address, _value: uint256) -> bool: modifying
10     def allowance(_owner: address, _spender: address) -> uint256: constant
11 
12 
13 # Events
14 
15 
16 
17 # Variables
18 owner: public(address)
19 sendTokenFee: public(wei_value) # wei
20 sendEthFee: public(wei_value) # wei
21 
22 
23 # Functions
24 
25 # Set owner of the contract
26 @public
27 @payable
28 def __init__():
29     self.owner = msg.sender
30 
31 
32 # MultisendEther
33 # accepts lists of addresses and corresponding amounts to be sent to them
34 # calculates the total amount and add fee
35 # distribute ether if sent ether is suficient
36 # return change back to the owner
37 @public
38 @payable
39 def multiSendEther(addresses: address[100], amounts: wei_value[100]) -> bool:
40     sender: address = msg.sender
41     total: wei_value = as_wei_value(0, "wei")
42     zero_wei: wei_value = total
43     value_sent: wei_value = msg.value
44     
45     # calculate total
46     for n in range(100):
47         if(amounts[n] <= zero_wei):
48             break
49         total += amounts[n]
50         
51     # required amount is amount plus fee
52     requiredAmount: wei_value = total + (self.sendEthFee)
53 
54     # Check if sufficient eth amount was sent
55     assert value_sent >= requiredAmount
56 
57     # Distribute ethereum
58     for n in range(100):
59         if(amounts[n] <= zero_wei):
60             break
61         send(addresses[n], as_wei_value(amounts[n], "wei"))
62 
63     # Send back excess amount
64     if value_sent > requiredAmount:
65         change: wei_value = value_sent - requiredAmount
66         send(sender, as_wei_value(change, "wei"))
67 
68     return True
69 
70 
71 # Multisend tokens
72 # accepts token address, lists of addresses and corresponding amounts to be sent to them
73 # calculates the total amount and add fee
74 # distribute ether if sent ether is suficient
75 # return change back to the owner
76 @public
77 @payable
78 def multiSendToken(tokenAddress: address, addresses: address[100], amounts: uint256[100]) -> bool:
79     sender: address = msg.sender
80     total: int128 = 0
81     value_sent: wei_value = msg.value
82     for amount in amounts:
83         total += convert(amount, int128)
84 
85     requiredWeiAmount: wei_value = self.sendTokenFee
86 
87     # Check if the correct amount of ether was sent
88     assert value_sent >= requiredWeiAmount
89 
90     # Check if this contract is allowed to transfer
91     # the required amount of token
92     assert Token(tokenAddress).allowance(sender, self) >= convert(total, uint256)
93 
94     # Distribute the token
95     for n in range(100):
96         if amounts[n] <= 0:
97             break
98         assert Token(tokenAddress).transferFrom(sender, addresses[n], amounts[n])
99 
100     # Send back excess amount
101     if value_sent > requiredWeiAmount:
102         change: wei_value = value_sent - requiredWeiAmount
103         send(sender, as_wei_value(change, "wei"))
104 
105     return True
106 
107 
108 # Other functions
109 @public
110 @constant
111 def getBalance(_address: address) -> wei_value:
112     return _address.balance
113 
114 
115 @public
116 @constant
117 def calc_total(numbs: wei_value[100]) -> wei_value:
118     total: wei_value = as_wei_value(0, "wei")
119     zero_wei: wei_value = total
120     for numb in numbs:
121         if(as_wei_value(numb, "wei") <= zero_wei):
122             break
123         total += as_wei_value(numb, "wei")
124     return total
125 
126     
127 @public
128 @constant
129 def find(numbs: wei_value[100], n: int128) -> wei_value:
130     return numbs[n]
131 
132 @public
133 @payable
134 def deposit() -> bool:
135     return True
136 
137 
138 @public
139 def withdrawEther(_to: address, _value: uint256) -> bool:
140     assert msg.sender == self.owner
141     send(_to, as_wei_value(_value, "wei"))
142     return True
143 
144 @public
145 def withdrawToken(tokenAddress: address, _to: address, _value: uint256) -> bool:
146     assert msg.sender == self.owner
147     assert Token(tokenAddress).transfer(_to, _value)
148     return True
149 
150 
151 @public
152 def setSendTokenFee(_sendTokenFee: uint256) -> bool:
153     assert msg.sender == self.owner
154     self.sendTokenFee = as_wei_value(_sendTokenFee, "wei")
155     return True
156 
157 
158 @public
159 def setSendEthFee(_sendEthFee: wei_value) -> bool:
160     assert msg.sender == self.owner
161     self.sendEthFee = _sendEthFee
162     return True
163 
164 
165 @public
166 def destroy(_to: address):
167     assert msg.sender == self.owner
168     selfdestruct(_to)