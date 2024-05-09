1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths from OpenZeppelin
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns(uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns(uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns(uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns(uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ERC20 {
33     function transfer(address _to, uint256 _value) public;
34     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
35 }
36 
37 contract EthTokenToSmthSwaps {
38 
39   using SafeMath for uint;
40 
41   address public owner;
42   uint256 SafeTime = 3 hours; // atomic swap timeOut
43 
44   struct Swap {
45     address token;
46     address targetWallet;
47     bytes32 secret;
48     bytes20 secretHash;
49     uint256 createdAt;
50     uint256 balance;
51   }
52 
53   // ETH Owner => BTC Owner => Swap
54   mapping(address => mapping(address => Swap)) public swaps;
55 
56   // ETH Owner => BTC Owner => secretHash => Swap
57   // mapping(address => mapping(address => mapping(bytes20 => Swap))) public swaps;
58 
59   constructor () public {
60     owner = msg.sender;
61   }
62 
63   event CreateSwap(address token, address _buyer, address _seller, uint256 _value, bytes20 _secretHash, uint256 createdAt);
64 
65   // ETH Owner creates Swap with secretHash
66   // ETH Owner make token deposit
67   function createSwap(bytes20 _secretHash, address _participantAddress, uint256 _value, address _token) public {
68     require(_value > 0);
69     require(swaps[msg.sender][_participantAddress].balance == uint256(0));
70     require(ERC20(_token).transferFrom(msg.sender, this, _value));
71 
72     swaps[msg.sender][_participantAddress] = Swap(
73       _token,
74       _participantAddress,
75       bytes32(0),
76       _secretHash,
77       now,
78       _value
79     );
80 
81     CreateSwap(_token, _participantAddress, msg.sender, _value, _secretHash, now);
82   }
83   // ETH Owner creates Swap with secretHash and targetWallet
84   // ETH Owner make token deposit
85   function createSwapTarget(bytes20 _secretHash, address _participantAddress, address _targetWallet, uint256 _value, address _token) public {
86     require(_value > 0);
87     require(swaps[msg.sender][_participantAddress].balance == uint256(0));
88     require(ERC20(_token).transferFrom(msg.sender, this, _value));
89 
90     swaps[msg.sender][_participantAddress] = Swap(
91       _token,
92       _targetWallet,
93       bytes32(0),
94       _secretHash,
95       now,
96       _value
97     );
98 
99     CreateSwap(_token, _participantAddress, msg.sender, _value, _secretHash, now);
100   }
101   function getBalance(address _ownerAddress) public view returns (uint256) {
102     return swaps[_ownerAddress][msg.sender].balance;
103   }
104 
105   event Withdraw(address _buyer, address _seller, uint256 withdrawnAt);
106   // Get target wallet (buyer check)
107   function getTargetWallet(address tokenOwnerAddress) public returns (address) {
108       return swaps[tokenOwnerAddress][msg.sender].targetWallet;
109   }
110   // BTC Owner withdraw money and adds secret key to swap
111   // BTC Owner receive +1 reputation
112   function withdraw(bytes32 _secret, address _ownerAddress) public {
113     Swap memory swap = swaps[_ownerAddress][msg.sender];
114 
115     require(swap.secretHash == ripemd160(_secret));
116     require(swap.balance > uint256(0));
117     require(swap.createdAt.add(SafeTime) > now);
118 
119     ERC20(swap.token).transfer(swap.targetWallet, swap.balance);
120 
121     swaps[_ownerAddress][msg.sender].balance = 0;
122     swaps[_ownerAddress][msg.sender].secret = _secret;
123 
124     Withdraw(msg.sender, _ownerAddress, now); 
125   }
126   // Token Owner withdraw money when participan no money for gas and adds secret key to swap
127   // BTC Owner receive +1 reputation... may be
128   function withdrawNoMoney(bytes32 _secret, address participantAddress) public {
129     Swap memory swap = swaps[msg.sender][participantAddress];
130 
131     require(swap.secretHash == ripemd160(_secret));
132     require(swap.balance > uint256(0));
133     require(swap.createdAt.add(SafeTime) > now);
134 
135     ERC20(swap.token).transfer(swap.targetWallet, swap.balance);
136 
137     swaps[msg.sender][participantAddress].balance = 0;
138     swaps[msg.sender][participantAddress].secret = _secret;
139 
140     Withdraw(participantAddress, msg.sender, now); 
141   }
142 
143   // BTC Owner withdraw money and adds secret key to swap
144   // BTC Owner receive +1 reputation
145   function withdrawOther(bytes32 _secret, address _ownerAddress, address participantAddress) public {
146     Swap memory swap = swaps[_ownerAddress][participantAddress];
147 
148     require(swap.secretHash == ripemd160(_secret));
149     require(swap.balance > uint256(0));
150     require(swap.createdAt.add(SafeTime) > now);
151 
152     ERC20(swap.token).transfer(swap.targetWallet, swap.balance);
153 
154     swaps[_ownerAddress][participantAddress].balance = 0;
155     swaps[_ownerAddress][participantAddress].secret = _secret;
156 
157     Withdraw(participantAddress, _ownerAddress, now); 
158   }
159 
160   // ETH Owner receive secret
161   function getSecret(address _participantAddress) public view returns (bytes32) {
162     return swaps[msg.sender][_participantAddress].secret;
163   }
164 
165   event Refund();
166 
167   // ETH Owner refund money
168   // BTC Owner gets -1 reputation
169   function refund(address _participantAddress) public {
170     Swap memory swap = swaps[msg.sender][_participantAddress];
171 
172     require(swap.balance > uint256(0));
173     require(swap.createdAt.add(SafeTime) < now);
174 
175     ERC20(swap.token).transfer(msg.sender, swap.balance);
176     clean(msg.sender, _participantAddress);
177 
178     Refund();
179   }
180 
181   function clean(address _ownerAddress, address _participantAddress) internal {
182     delete swaps[_ownerAddress][_participantAddress];
183   }
184 }