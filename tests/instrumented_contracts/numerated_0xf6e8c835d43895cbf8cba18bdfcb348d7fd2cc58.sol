1 # @title Vyper loveregister contract
2 # @author Kevin Foesenek
3 
4 #Struct
5 struct register: 
6     owner1: address
7     owner1_name: string[120]
8     owner2: address
9     owner2_name: string[120]
10     message: string[280]
11     private_message: string[280]
12     alive: bool
13 
14 # Events
15 Register: event({_from: indexed(address), _to: indexed(address), identifier: bytes32})
16 Search: event({Owner: indexed(address), _Identifier: bytes32})
17 
18 # Variables contract owner
19 owner1: public(address)
20 owner2: public(address)
21 payment_address: public(address)
22 price: public(wei_value)
23 
24 # Variables ERC20 
25 name: public(string[64])
26 register_entries: public(map(bytes32, register))
27 register_totalEntries: public(uint256)
28 register_publicmessage: public(map(uint256, string[280]))
29 register_identifier: map(address, bytes32)
30 
31 # Constructor
32 @public
33 def __init__(_name: string[64], _price: wei_value):
34         self.name = _name
35         self.owner1 = msg.sender
36         self.price = _price
37         self.payment_address = msg.sender
38 
39 # Function to set second owner
40 @public
41 def setsecondowner(newowner: address):
42     assert self.owner1 == msg.sender or self.owner2 == msg.sender
43     self.owner2 = newowner
44         
45 # Function to set price
46 @public
47 def setprice(newprice: wei_value):
48     assert self.owner1 == msg.sender or self.owner2 == msg.sender
49     self.price = newprice
50 
51 # Function to change payment address
52 @public
53 def changepaymentaddress(newaddress: address):
54     assert self.owner1 == msg.sender or self.owner2 == msg.sender
55     self.payment_address = newaddress
56 
57 # Function to send amount of ETH to owner determined address
58 @public
59 def clear_valuecontract():
60     assert self.owner1 == msg.sender or self.owner2 == msg.sender
61     receiver: address = self.payment_address
62     amount: wei_value = self.balance
63     send(receiver, amount)
64     
65 # Function to register
66 @public
67 @payable
68 def newRegister(_from: address, _fromName: string[120], _for: address, _forName: string[120], message: string[280], privatenote: string[280]):
69     index_entries: uint256 = self.register_totalEntries
70     
71     hash_index_entries: bytes32 = sha3(convert(index_entries, bytes32))
72     
73     assert _from != ZERO_ADDRESS
74     assert _for != ZERO_ADDRESS
75     assert msg.value >= self.price
76     self.register_entries[hash_index_entries] = register({owner1: _from, owner1_name: _fromName, owner2: _for, owner2_name: _forName, 
77     message: message, private_message: privatenote, alive: True})
78     
79     self.register_publicmessage[index_entries] = message
80     self.register_identifier[_from] = hash_index_entries
81     
82     index_entries += 1
83     self.register_totalEntries = index_entries
84     log.Register(_from, _for, hash_index_entries)
85     
86 # Function to deregister -> note it only closes the entry - removal is not possible
87 @public
88 def deRegister(register_entry: bytes32):
89     assert self.register_entries[register_entry].owner1 == msg.sender or self.register_entries[register_entry].owner2 == msg.sender
90     self.register_entries[register_entry].alive = False
91 
92 #Function to find the identifier for a relationship 
93 @public
94 def findIdentifier():
95     log.Search(msg.sender, self.register_identifier[msg.sender])