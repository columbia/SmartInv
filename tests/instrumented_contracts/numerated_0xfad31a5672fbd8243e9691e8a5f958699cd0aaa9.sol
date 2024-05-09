1 /*
2  * Contracts' names:
3  * 1) UserfeedsClaim - prefix
4  * 2a) WithoutValueTransfer - simplest case, no transfer
5  * 2b) With - continuation
6  * 3) Configurable - optional, means there is function parameter to decide how much to send to each recipient
7  * 4) Value or Token - value means ether, token means ERC20 or ERC721
8  * 5) Multi - optional, means there are multiple recipients
9  * 6) Send or Transfer - using send or transfer in case of ether, or transferFrom in case of ERC20/ERC721 (no "Send" possible in this case)
10  * 7) Unsafe or NoCheck - optional, means that value returned from send or transferFrom is not checked
11  */
12 
13 pragma solidity ^0.4.23;
14 
15 contract ERC20 {
16 
17   function transferFrom(address from, address to, uint value) public returns (bool success);
18 }
19 
20 contract ERC721 {
21 
22   function transferFrom(address from, address to, uint value) public;
23 }
24 
25 contract Ownable {
26 
27   address owner;
28   address pendingOwner;
29 
30   modifier onlyOwner {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   modifier onlyPendingOwner {
36     require(msg.sender == pendingOwner);
37     _;
38   }
39 
40   constructor() public {
41     owner = msg.sender;
42   }
43 
44   function transferOwnership(address newOwner) public onlyOwner {
45     pendingOwner = newOwner;
46   }
47 
48   function claimOwnership() public onlyPendingOwner {
49     owner = pendingOwner;
50   }
51 }
52 
53 contract Destructible is Ownable {
54 
55   function destroy() public onlyOwner {
56     selfdestruct(msg.sender);
57   }
58 }
59 
60 contract WithClaim {
61 
62   event Claim(string data);
63 }
64 
65 // older version:
66 // Mainnet: 0xFd74f0ce337fC692B8c124c094c1386A14ec7901
67 // Rinkeby: 0xC5De286677AC4f371dc791022218b1c13B72DbBd
68 // Ropsten: 0x6f32a6F579CFEed1FFfDc562231C957ECC894001
69 // Kovan:   0x139d658eD55b78e783DbE9bD4eb8F2b977b24153
70 
71 contract UserfeedsClaimWithoutValueTransfer is Destructible, WithClaim {
72 
73   function post(string data) public {
74     emit Claim(data);
75   }
76 }
77 
78 // older version:
79 // Mainnet: 0x70B610F7072E742d4278eC55C02426Dbaaee388C
80 // Rinkeby: 0x00034B8397d9400117b4298548EAa59267953F8c
81 // Ropsten: 0x37C1CA7996CDdAaa31e13AA3eEE0C89Ee4f665B5
82 // Kovan:   0xc666c75C2bBA9AD8Df402138cE32265ac0EC7aaC
83 
84 contract UserfeedsClaimWithValueTransfer is Destructible, WithClaim {
85 
86   function post(address userfeed, string data) public payable {
87     emit Claim(data);
88     userfeed.transfer(msg.value);
89   }
90 }
91 
92 // older version:
93 // Mainnet: 0xfF8A1BA752fE5df494B02D77525EC6Fa76cecb93
94 // Rinkeby: 0xBd2A0FF74dE98cFDDe4653c610E0E473137534fB
95 // Ropsten: 0x54b4372fA0bd76664B48625f0e8c899Ff19DFc39
96 // Kovan:   0xd6Ede7F43882B100C6311a9dF801088eA91cEb64
97 
98 contract UserfeedsClaimWithTokenTransfer is Destructible, WithClaim {
99 
100   function post(address userfeed, ERC20 token, uint value, string data) public {
101     emit Claim(data);
102     require(token.transferFrom(msg.sender, userfeed, value));
103   }
104 }
105 
106 // Rinkeby: 0x73cDd7e5Cf3DA3985f985298597D404A90878BD9
107 // Ropsten: 0xA7828A4369B3e89C02234c9c05d12516dbb154BC
108 // Kovan:   0x5301F5b1Af6f00A61E3a78A9609d1D143B22BB8d
109 
110 contract UserfeedsClaimWithValueMultiSendUnsafe is Destructible, WithClaim {
111 
112   function post(string data, address[] recipients) public payable {
113     emit Claim(data);
114     send(recipients);
115   }
116 
117   function post(string data, bytes20[] recipients) public payable {
118     emit Claim(data);
119     send(recipients);
120   }
121 
122   function send(address[] recipients) public payable {
123     uint amount = msg.value / recipients.length;
124     for (uint i = 0; i < recipients.length; i++) {
125       recipients[i].send(amount);
126     }
127     msg.sender.transfer(address(this).balance);
128   }
129 
130   function send(bytes20[] recipients) public payable {
131     uint amount = msg.value / recipients.length;
132     for (uint i = 0; i < recipients.length; i++) {
133       address(recipients[i]).send(amount);
134     }
135     msg.sender.transfer(address(this).balance);
136   }
137 }
138 
139 // Mainnet: 0xfad31a5672fbd8243e9691e8a5f958699cd0aaa9
140 // Rinkeby: 0x1f8A01833A0B083CCcd87fffEe50EF1D35621fD2
141 // Ropsten: 0x298611B2798d280910274C222A9dbDfBA914B058
142 // Kovan:   0x0c20Daa719Cd4fD73eAf23d2Cb687cD07d500E17
143 
144 contract UserfeedsClaimWithConfigurableValueMultiTransfer is Destructible, WithClaim {
145 
146   function post(string data, address[] recipients, uint[] values) public payable {
147     emit Claim(data);
148     transfer(recipients, values);
149   }
150 
151   function transfer(address[] recipients, uint[] values) public payable {
152     for (uint i = 0; i < recipients.length; i++) {
153       recipients[i].transfer(values[i]);
154     }
155     msg.sender.transfer(address(this).balance);
156   }
157 }
158 
159 // Rinkeby: 0xA105908d1Bd7e76Ec4Dfddd08d9E0c89F6B39474
160 // Ropsten: 0x1A97Aba0fb047cd8cd8F4c14D890bE6E7004fae9
161 // Kovan:   0xcF53D90E7f71C7Db557Bc42C5a85D36dD53956C0
162 
163 contract UserfeedsClaimWithConfigurableTokenMultiTransfer is Destructible, WithClaim {
164 
165   function post(string data, address[] recipients, ERC20 token, uint[] values) public {
166     emit Claim(data);
167     transfer(recipients, token, values);
168   }
169 
170   function transfer(address[] recipients, ERC20 token, uint[] values) public {
171     for (uint i = 0; i < recipients.length; i++) {
172       require(token.transferFrom(msg.sender, recipients[i], values[i]));
173     }
174   }
175 }
176 
177 // Rinkeby: 0x042a52f30572A54f504102cc1Fbd1f2B53859D8A
178 // Ropsten: 0x616c0ee7C6659a99a99A36f558b318779C3ebC16
179 // Kovan:   0x30192DE195f393688ce515489E4E0e0b148e9D8d
180 
181 contract UserfeedsClaimWithConfigurableTokenMultiTransferNoCheck is Destructible, WithClaim {
182 
183   function post(string data, address[] recipients, ERC721 token, uint[] values) public {
184     emit Claim(data);
185     transfer(recipients, token, values);
186   }
187 
188   function transfer(address[] recipients, ERC721 token, uint[] values) public {
189     for (uint i = 0; i < recipients.length; i++) {
190       token.transferFrom(msg.sender, recipients[i], values[i]);
191     }
192   }
193 }