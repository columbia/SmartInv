1 pragma solidity ^0.4.23;
2 
3 contract Reputation {
4 
5   address owner;
6   mapping(address => bool) whitelist;
7   mapping(address => int) ratings;
8 
9   constructor () public {
10     owner = msg.sender;
11   }
12 
13   function addToWhitelist(address _contractAddress) public {
14     require(msg.sender == owner);
15     whitelist[_contractAddress] = true;
16   }
17 
18   function change(address _userAddress, int _delta) public {
19     require(whitelist[msg.sender]);
20     ratings[_userAddress] += _delta;
21   }
22 
23   function getMy() public view returns (int) {
24     return ratings[msg.sender];
25   }
26 
27   function get(address _userAddress) public view returns (int) {
28     return ratings[_userAddress];
29   }
30 }
31 
32 library SafeMath {
33   function mul(uint256 a, uint256 b) internal pure returns(uint256) {
34     uint256 c = a * b;
35     assert(a == 0 || c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal pure returns(uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   function sub(uint256 a, uint256 b) internal pure returns(uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function add(uint256 a, uint256 b) internal pure returns(uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 
59 contract EthToSmthSwaps {
60 
61   using SafeMath for uint;
62 
63   address public owner;
64   address public ratingContractAddress;
65   uint256 SafeTime = 1 hours; // atomic swap timeOut
66 
67   struct Swap {
68     bytes32 secret;
69     bytes20 secretHash;
70     uint256 createdAt;
71     uint256 balance;
72   }
73 
74   // ETH Owner => BTC Owner => Swap
75   mapping(address => mapping(address => Swap)) public swaps;
76   mapping(address => mapping(address => uint)) public participantSigns;
77 
78   constructor () public {
79     owner = msg.sender;
80   }
81 
82   function setReputationAddress(address _ratingContractAddress) public {
83     require(owner == msg.sender);
84     ratingContractAddress = _ratingContractAddress;
85   }
86 
87   event Sign();
88 
89   // ETH Owner signs swap
90   // initializing time for correct work of close() method
91   function sign(address _participantAddress) public {
92     require(swaps[msg.sender][_participantAddress].balance == 0);
93     participantSigns[msg.sender][_participantAddress] = now;
94 
95     Sign();
96   }
97 
98   // BTC Owner checks if ETH Owner signed swap
99   function checkSign(address _ownerAddress) public view returns (uint) {
100     return participantSigns[_ownerAddress][msg.sender];
101   }
102 
103   event CreateSwap(uint256 createdAt);
104 
105   // ETH Owner creates Swap with secretHash
106   // ETH Owner make token deposit
107   function createSwap(bytes20 _secretHash, address _participantAddress) public payable {
108     require(msg.value > 0);
109     require(participantSigns[msg.sender][_participantAddress].add(SafeTime) > now);
110     require(swaps[msg.sender][_participantAddress].balance == uint256(0));
111 
112     swaps[msg.sender][_participantAddress] = Swap(
113       bytes32(0),
114       _secretHash,
115       now,
116       msg.value
117     );
118 
119     CreateSwap(now);
120   }
121 
122   function getBalance(address _ownerAddress) public view returns (uint256) {
123     return swaps[_ownerAddress][msg.sender].balance;
124   }
125 
126   event Withdraw();
127 
128   // BTC Owner withdraw money and adds secret key to swap
129   // BTC Owner receive +1 reputation
130   function withdraw(bytes32 _secret, address _ownerAddress) public {
131     Swap memory swap = swaps[_ownerAddress][msg.sender];
132 
133     require(swap.secretHash == ripemd160(_secret));
134     require(swap.balance > uint256(0));
135     require(swap.createdAt.add(SafeTime) > now);
136 
137     Reputation(ratingContractAddress).change(msg.sender, 1);
138     msg.sender.transfer(swap.balance);
139 
140     swaps[_ownerAddress][msg.sender].balance = 0;
141     swaps[_ownerAddress][msg.sender].secret = _secret;
142 
143     Withdraw();
144   }
145 
146   // ETH Owner receive secret
147   function getSecret(address _participantAddress) public view returns (bytes32) {
148     return swaps[msg.sender][_participantAddress].secret;
149   }
150 
151   event Close();
152 
153   // ETH Owner closes swap
154   // ETH Owner receive +1 reputation
155   function close(address _participantAddress) public {
156     require(swaps[msg.sender][_participantAddress].balance == 0);
157 
158     Reputation(ratingContractAddress).change(msg.sender, 1);
159     clean(msg.sender, _participantAddress);
160 
161     Close();
162   }
163 
164   event Refund();
165 
166   // ETH Owner refund money
167   // BTC Owner gets -1 reputation
168   function refund(address _participantAddress) public {
169     Swap memory swap = swaps[msg.sender][_participantAddress];
170 
171     require(swap.balance > uint256(0));
172     require(swap.createdAt.add(SafeTime) < now);
173 
174     msg.sender.transfer(swap.balance);
175     // TODO it looks like ETH Owner can create as many swaps as possible and refund them to decrease someone reputation
176     Reputation(ratingContractAddress).change(_participantAddress, -1);
177     clean(msg.sender, _participantAddress);
178 
179     Refund();
180   }
181 
182   event Abort();
183 
184   // BTC Owner closes Swap
185   // If ETH Owner don't create swap after init in in safeTime
186   // ETH Owner -1 reputation
187   function abort(address _ownerAddress) public {
188     require(swaps[_ownerAddress][msg.sender].balance == uint256(0));
189     require(participantSigns[_ownerAddress][msg.sender] != uint(0));
190     require(participantSigns[_ownerAddress][msg.sender].add(SafeTime) < now);
191 
192     Reputation(ratingContractAddress).change(_ownerAddress, -1);
193     clean(_ownerAddress, msg.sender);
194 
195     Abort();
196   }
197 
198   function clean(address _ownerAddress, address _participantAddress) internal {
199     delete swaps[_ownerAddress][_participantAddress];
200     delete participantSigns[_ownerAddress][_participantAddress];
201   }
202   
203   //WE ARE IN THE ALPHA, of course this function WILL BE removed in future
204   function withdr(uint amount) {
205      require(msg.sender == owner);
206      owner.transfer(amount);
207   }
208   
209 }