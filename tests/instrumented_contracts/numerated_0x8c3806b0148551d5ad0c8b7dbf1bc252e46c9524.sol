1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns(uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns(uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns(uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns(uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 
30 contract EthToSmthSwaps {
31 
32   using SafeMath for uint;
33 
34   address public owner;
35   address public ratingContractAddress;
36   uint256 SafeTime = 1 hours; // atomic swap timeOut
37 
38   struct Swap {
39     address targetWallet;
40     bytes32 secret;
41     bytes20 secretHash;
42     uint256 createdAt;
43     uint256 balance;
44   }
45 
46   // ETH Owner => BTC Owner => Swap
47   mapping(address => mapping(address => Swap)) public swaps;
48   mapping(address => mapping(address => uint)) public participantSigns;
49 
50   constructor () public {
51     owner = msg.sender;
52   }
53 
54 
55 
56 
57   event CreateSwap(address _buyer, address _seller, uint256 _value, bytes20 _secretHash, uint256 createdAt);
58 
59   // ETH Owner creates Swap with secretHash
60   // ETH Owner make token deposit
61   function createSwap(bytes20 _secretHash, address _participantAddress) public payable {
62     require(msg.value > 0);
63     require(swaps[msg.sender][_participantAddress].balance == uint256(0));
64 
65     swaps[msg.sender][_participantAddress] = Swap(
66       _participantAddress,
67       bytes32(0),
68       _secretHash,
69       now,
70       msg.value
71     );
72 
73     CreateSwap(_participantAddress, msg.sender, msg.value, _secretHash, now);
74   }
75 
76   // ETH Owner creates Swap with secretHash
77   // ETH Owner make token deposit
78   function createSwapTarget(bytes20 _secretHash, address _participantAddress, address _targetWallet) public payable {
79     require(msg.value > 0);
80     require(swaps[msg.sender][_participantAddress].balance == uint256(0));
81 
82     swaps[msg.sender][_participantAddress] = Swap(
83       _targetWallet,
84       bytes32(0),
85       _secretHash,
86       now,
87       msg.value
88     );
89 
90     CreateSwap(_participantAddress, msg.sender, msg.value, _secretHash, now);
91   }
92 
93   function getBalance(address _ownerAddress) public view returns (uint256) {
94     return swaps[_ownerAddress][msg.sender].balance;
95   }
96 
97   // Get target wallet (buyer check)
98   function getTargetWallet(address _ownerAddress) public returns (address) {
99       return swaps[_ownerAddress][msg.sender].targetWallet;
100   }
101 
102   event Withdraw(address _buyer, address _seller, uint256 withdrawnAt);
103 
104   // BTC Owner withdraw money and adds secret key to swap
105   // BTC Owner receive +1 reputation
106   function withdraw(bytes32 _secret, address _ownerAddress) public {
107     Swap memory swap = swaps[_ownerAddress][msg.sender];
108 
109     require(swap.secretHash == ripemd160(_secret));
110     require(swap.balance > uint256(0));
111     require(swap.createdAt.add(SafeTime) > now);
112 
113     swap.targetWallet.transfer(swap.balance);
114 
115     swaps[_ownerAddress][msg.sender].balance = 0;
116     swaps[_ownerAddress][msg.sender].secret = _secret;
117 
118     Withdraw(msg.sender, _ownerAddress, now); 
119   }
120   // BTC Owner withdraw money and adds secret key to swap
121   // BTC Owner receive +1 reputation
122   function withdrawNoMoney(bytes32 _secret, address participantAddress) public {
123     Swap memory swap = swaps[msg.sender][participantAddress];
124 
125     require(swap.secretHash == ripemd160(_secret));
126     require(swap.balance > uint256(0));
127     require(swap.createdAt.add(SafeTime) > now);
128 
129     swap.targetWallet.transfer(swap.balance);
130 
131     swaps[msg.sender][participantAddress].balance = 0;
132     swaps[msg.sender][participantAddress].secret = _secret;
133 
134     Withdraw(participantAddress, msg.sender, now); 
135   }
136   // BTC Owner withdraw money and adds secret key to swap
137   // BTC Owner receive +1 reputation
138   function withdrawOther(bytes32 _secret, address _ownerAddress, address participantAddress) public {
139     Swap memory swap = swaps[_ownerAddress][participantAddress];
140 
141     require(swap.secretHash == ripemd160(_secret));
142     require(swap.balance > uint256(0));
143     require(swap.createdAt.add(SafeTime) > now);
144 
145     swap.targetWallet.transfer(swap.balance);
146 
147     swaps[_ownerAddress][participantAddress].balance = 0;
148     swaps[_ownerAddress][participantAddress].secret = _secret;
149 
150     Withdraw(participantAddress, _ownerAddress, now); 
151   }
152 
153   // ETH Owner receive secret
154   function getSecret(address _participantAddress) public view returns (bytes32) {
155     return swaps[msg.sender][_participantAddress].secret;
156   }
157 
158   event Close(address _buyer, address _seller);
159 
160 
161 
162   event Refund(address _buyer, address _seller);
163 
164   // ETH Owner refund money
165   // BTC Owner gets -1 reputation
166   function refund(address _participantAddress) public {
167     Swap memory swap = swaps[msg.sender][_participantAddress];
168 
169     require(swap.balance > uint256(0));
170     require(swap.createdAt.add(SafeTime) < now);
171 
172     msg.sender.transfer(swap.balance);
173 
174     clean(msg.sender, _participantAddress);
175 
176     Refund(_participantAddress, msg.sender);
177   }
178 
179   function clean(address _ownerAddress, address _participantAddress) internal {
180     delete swaps[_ownerAddress][_participantAddress];
181     delete participantSigns[_ownerAddress][_participantAddress];
182   }
183 }