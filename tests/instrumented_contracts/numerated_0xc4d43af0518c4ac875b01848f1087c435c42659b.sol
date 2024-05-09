1 pragma solidity ^0.5.0;
2 
3 contract EthToSmthSwaps {
4 
5   using SafeMath for uint;
6 
7   address public owner;
8   address public ratingContractAddress;
9   uint256 SafeTime = 1 hours; // atomic swap timeOut
10 
11   struct Swap {
12     address payable targetWallet;
13     bytes32 secret;
14     bytes20 secretHash;
15     uint256 createdAt;
16     uint256 balance;
17   }
18 
19   // ETH Owner => BTC Owner => Swap
20   mapping(address => mapping(address => Swap)) public swaps;
21   mapping(address => mapping(address => uint)) public participantSigns;
22 
23   constructor () public {
24     owner = msg.sender;
25   }
26 
27   event CreateSwap(address _buyer, address _seller, uint256 _value, bytes20 _secretHash, uint256 createdAt);
28 
29   // ETH Owner creates Swap with secretHash
30   // ETH Owner make token deposit
31   function createSwap(bytes20 _secretHash, address payable _participantAddress) public payable {
32     require(msg.value > 0);
33     require(swaps[msg.sender][_participantAddress].balance == uint256(0));
34 
35     swaps[msg.sender][_participantAddress] = Swap(
36       _participantAddress,
37       bytes32(0),
38       _secretHash,
39       now,
40       msg.value
41     );
42 
43     emit CreateSwap(_participantAddress, msg.sender, msg.value, _secretHash, now);
44   }
45 
46   // ETH Owner creates Swap with secretHash
47   // ETH Owner make token deposit
48   function createSwapTarget(bytes20 _secretHash, address payable _participantAddress, address payable _targetWallet) public payable {
49     require(msg.value > 0);
50     require(swaps[msg.sender][_participantAddress].balance == uint256(0));
51 
52     swaps[msg.sender][_participantAddress] = Swap(
53       _targetWallet,
54       bytes32(0),
55       _secretHash,
56       now,
57       msg.value
58     );
59 
60     emit CreateSwap(_participantAddress, msg.sender, msg.value, _secretHash, now);
61   }
62 
63   function getBalance(address _ownerAddress) public view returns (uint256) {
64     return swaps[_ownerAddress][msg.sender].balance;
65   }
66 
67   // Get target wallet (buyer check)
68   function getTargetWallet(address _ownerAddress) public view returns (address) {
69       return swaps[_ownerAddress][msg.sender].targetWallet;
70   }
71 
72   event Withdraw(address _buyer, address _seller, bytes20 _secretHash, uint256 withdrawnAt);
73 
74   // BTC Owner withdraw money and adds secret key to swap
75   // BTC Owner receive +1 reputation
76   function withdraw(bytes32 _secret, address _ownerAddress) public {
77     Swap memory swap = swaps[_ownerAddress][msg.sender];
78 
79     require(swap.secretHash == ripemd160(abi.encodePacked(_secret)));
80     require(swap.balance > uint256(0));
81     require(swap.createdAt.add(SafeTime) > now);
82 
83     swap.targetWallet.transfer(swap.balance);
84 
85     swaps[_ownerAddress][msg.sender].balance = 0;
86     swaps[_ownerAddress][msg.sender].secret = _secret;
87 
88     emit Withdraw(msg.sender, _ownerAddress, swap.secretHash, now);
89   }
90   // BTC Owner withdraw money and adds secret key to swap
91   // BTC Owner receive +1 reputation
92   function withdrawNoMoney(bytes32 _secret, address participantAddress) public {
93     Swap memory swap = swaps[msg.sender][participantAddress];
94 
95     require(swap.secretHash == ripemd160(abi.encodePacked(_secret)));
96     require(swap.balance > uint256(0));
97     require(swap.createdAt.add(SafeTime) > now);
98 
99     swap.targetWallet.transfer(swap.balance);
100 
101     swaps[msg.sender][participantAddress].balance = 0;
102     swaps[msg.sender][participantAddress].secret = _secret;
103 
104     emit Withdraw(participantAddress, msg.sender, swap.secretHash, now);
105   }
106   // BTC Owner withdraw money and adds secret key to swap
107   // BTC Owner receive +1 reputation
108   function withdrawOther(bytes32 _secret, address _ownerAddress, address participantAddress) public {
109     Swap memory swap = swaps[_ownerAddress][participantAddress];
110 
111     require(swap.secretHash == ripemd160(abi.encodePacked(_secret)));
112     require(swap.balance > uint256(0));
113     require(swap.createdAt.add(SafeTime) > now);
114 
115     swap.targetWallet.transfer(swap.balance);
116 
117     swaps[_ownerAddress][participantAddress].balance = 0;
118     swaps[_ownerAddress][participantAddress].secret = _secret;
119 
120     emit Withdraw(participantAddress, _ownerAddress, swap.secretHash, now);
121   }
122 
123   // ETH Owner receive secret
124   function getSecret(address _participantAddress) public view returns (bytes32) {
125     return swaps[msg.sender][_participantAddress].secret;
126   }
127 
128   event Close(address _buyer, address _seller);
129 
130 
131 
132   event Refund(address _buyer, address _seller, bytes20 _secretHash);
133 
134   // ETH Owner refund money
135   // BTC Owner gets -1 reputation
136   function refund(address _participantAddress) public {
137     Swap memory swap = swaps[msg.sender][_participantAddress];
138 
139     require(swap.balance > uint256(0));
140     require(swap.createdAt.add(SafeTime) < now);
141 
142     msg.sender.transfer(swap.balance);
143 
144     clean(msg.sender, _participantAddress);
145 
146     emit Refund(_participantAddress, msg.sender, swap.secretHash);
147   }
148 
149   function clean(address _ownerAddress, address _participantAddress) internal {
150     delete swaps[_ownerAddress][_participantAddress];
151     delete participantSigns[_ownerAddress][_participantAddress];
152   }
153 }
154 
155 library SafeMath {
156     /**
157     * @dev Multiplies two unsigned integers, reverts on overflow.
158     */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b);
169 
170         return c;
171     }
172 
173     /**
174     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
175     */
176     function div(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Solidity only automatically asserts when dividing by 0
178         require(b > 0);
179         uint256 c = a / b;
180         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
181 
182         return c;
183     }
184 
185     /**
186     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
187     */
188     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
189         require(b <= a);
190         uint256 c = a - b;
191 
192         return c;
193     }
194 
195     /**
196     * @dev Adds two unsigned integers, reverts on overflow.
197     */
198     function add(uint256 a, uint256 b) internal pure returns (uint256) {
199         uint256 c = a + b;
200         require(c >= a);
201 
202         return c;
203     }
204 
205     /**
206     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
207     * reverts when dividing by zero.
208     */
209     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
210         require(b != 0);
211         return a % b;
212     }
213 }