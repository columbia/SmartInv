1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two unsigned integers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 
68 contract ERC20 {
69     function transfer(address _to, uint256 _value) public;
70     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
71 }
72 
73 
74 contract EthTokenToSmthSwaps {
75 
76   using SafeMath for uint;
77 
78   address public owner;
79   uint256 SafeTime = 1 hours; // atomic swap timeOut
80 
81   struct Swap {
82     address token;
83     address payable targetWallet;
84     bytes32 secret;
85     bytes20 secretHash;
86     uint256 createdAt;
87     uint256 balance;
88   }
89 
90   // ETH Owner => BTC Owner => Swap
91   mapping(address => mapping(address => Swap)) public swaps;
92 
93   // ETH Owner => BTC Owner => secretHash => Swap
94   // mapping(address => mapping(address => mapping(bytes20 => Swap))) public swaps;
95 
96   constructor () public {
97     owner = msg.sender;
98   }
99 
100   event CreateSwap(address token, address _buyer, address _seller, uint256 _value, bytes20 _secretHash, uint256 createdAt);
101 
102   // ETH Owner creates Swap with secretHash
103   // ETH Owner make token deposit
104   function createSwap(bytes20 _secretHash, address payable _participantAddress, uint256 _value, address _token) public {
105     require(_value > 0);
106     require(swaps[msg.sender][_participantAddress].balance == uint256(0));
107     require(ERC20(_token).transferFrom(msg.sender, address(this), _value));
108 
109     swaps[msg.sender][_participantAddress] = Swap(
110       _token,
111       _participantAddress,
112       bytes32(0),
113       _secretHash,
114       now,
115       _value
116     );
117 
118     emit CreateSwap(_token, _participantAddress, msg.sender, _value, _secretHash, now);
119   }
120   // ETH Owner creates Swap with secretHash and targetWallet
121   // ETH Owner make token deposit
122   function createSwapTarget(bytes20 _secretHash, address payable _participantAddress, address payable _targetWallet, uint256 _value, address _token) public {
123     require(_value > 0);
124     require(swaps[msg.sender][_participantAddress].balance == uint256(0));
125     require(ERC20(_token).transferFrom(msg.sender, address(this), _value));
126 
127     swaps[msg.sender][_participantAddress] = Swap(
128       _token,
129       _targetWallet,
130       bytes32(0),
131       _secretHash,
132       now,
133       _value
134     );
135 
136     emit CreateSwap(_token, _participantAddress, msg.sender, _value, _secretHash, now);
137   }
138   function getBalance(address _ownerAddress) public view returns (uint256) {
139     return swaps[_ownerAddress][msg.sender].balance;
140   }
141 
142   event Withdraw(address _buyer, address _seller, bytes20 _secretHash, uint256 withdrawnAt);
143   // Get target wallet (buyer check)
144   function getTargetWallet(address tokenOwnerAddress) public view returns (address) {
145       return swaps[tokenOwnerAddress][msg.sender].targetWallet;
146   }
147   // BTC Owner withdraw money and adds secret key to swap
148   // BTC Owner receive +1 reputation
149   function withdraw(bytes32 _secret, address _ownerAddress) public {
150     Swap memory swap = swaps[_ownerAddress][msg.sender];
151 
152     require(swap.secretHash == ripemd160(abi.encodePacked(_secret)));
153     require(swap.balance > uint256(0));
154     require(swap.createdAt.add(SafeTime) > now);
155 
156     ERC20(swap.token).transfer(swap.targetWallet, swap.balance);
157 
158     swaps[_ownerAddress][msg.sender].balance = 0;
159     swaps[_ownerAddress][msg.sender].secret = _secret;
160 
161     emit Withdraw(msg.sender, _ownerAddress, swap.secretHash, now);
162   }
163   // Token Owner withdraw money when participan no money for gas and adds secret key to swap
164   // BTC Owner receive +1 reputation... may be
165   function withdrawNoMoney(bytes32 _secret, address participantAddress) public {
166     Swap memory swap = swaps[msg.sender][participantAddress];
167 
168     require(swap.secretHash == ripemd160(abi.encodePacked(_secret)));
169     require(swap.balance > uint256(0));
170     require(swap.createdAt.add(SafeTime) > now);
171 
172     ERC20(swap.token).transfer(swap.targetWallet, swap.balance);
173 
174     swaps[msg.sender][participantAddress].balance = 0;
175     swaps[msg.sender][participantAddress].secret = _secret;
176 
177     emit Withdraw(participantAddress, msg.sender, swap.secretHash, now);
178   }
179 
180   // BTC Owner withdraw money and adds secret key to swap
181   // BTC Owner receive +1 reputation
182   function withdrawOther(bytes32 _secret, address _ownerAddress, address participantAddress) public {
183     Swap memory swap = swaps[_ownerAddress][participantAddress];
184 
185     require(swap.secretHash == ripemd160(abi.encodePacked(_secret)));
186     require(swap.balance > uint256(0));
187     require(swap.createdAt.add(SafeTime) > now);
188 
189     ERC20(swap.token).transfer(swap.targetWallet, swap.balance);
190 
191     swaps[_ownerAddress][participantAddress].balance = 0;
192     swaps[_ownerAddress][participantAddress].secret = _secret;
193 
194     emit Withdraw(participantAddress, _ownerAddress, swap.secretHash, now);
195   }
196 
197   // ETH Owner receive secret
198   function getSecret(address _participantAddress) public view returns (bytes32) {
199     return swaps[msg.sender][_participantAddress].secret;
200   }
201 
202   event Refund(address _buyer, address _seller, bytes20 _secretHash);
203 
204   // ETH Owner refund money
205   // BTC Owner gets -1 reputation
206   function refund(address _participantAddress) public {
207     Swap memory swap = swaps[msg.sender][_participantAddress];
208 
209     require(swap.balance > uint256(0));
210     require(swap.createdAt.add(SafeTime) < now);
211 
212     ERC20(swap.token).transfer(msg.sender, swap.balance);
213     clean(msg.sender, _participantAddress);
214 
215     emit Refund(_participantAddress, msg.sender, swap.secretHash);
216   }
217 
218   function clean(address _ownerAddress, address _participantAddress) internal {
219     delete swaps[_ownerAddress][_participantAddress];
220   }
221 }