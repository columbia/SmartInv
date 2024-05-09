1 pragma solidity ^0.4.23;
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
46     bytes32 secret;
47     bytes20 secretHash;
48     uint256 createdAt;
49     uint256 balance;
50   }
51 
52   // ETH Owner => BTC Owner => Swap
53   mapping(address => mapping(address => Swap)) public swaps;
54 
55   // ETH Owner => BTC Owner => secretHash => Swap
56   // mapping(address => mapping(address => mapping(bytes20 => Swap))) public swaps;
57 
58   constructor () public {
59     owner = msg.sender;
60   }
61 
62   event CreateSwap(uint256 createdAt);
63 
64   // ETH Owner creates Swap with secretHash
65   // ETH Owner make token deposit
66   function createSwap(bytes20 _secretHash, address _participantAddress, uint256 _value, address _token) public {
67     require(_value > 0);
68     require(swaps[msg.sender][_participantAddress].balance == uint256(0));
69     require(ERC20(_token).transferFrom(msg.sender, this, _value));
70 
71     swaps[msg.sender][_participantAddress] = Swap(
72       _token,
73       bytes32(0),
74       _secretHash,
75       now,
76       _value
77     );
78 
79     CreateSwap(now);
80   }
81 
82   function getBalance(address _ownerAddress) public view returns (uint256) {
83     return swaps[_ownerAddress][msg.sender].balance;
84   }
85 
86   event Withdraw(bytes32 _secret,address addr, uint amount);
87 
88   // BTC Owner withdraw money and adds secret key to swap
89   // BTC Owner receive +1 reputation
90   function withdraw(bytes32 _secret, address _ownerAddress) public {
91     Swap memory swap = swaps[_ownerAddress][msg.sender];
92 
93     require(swap.secretHash == ripemd160(_secret));
94     require(swap.balance > uint256(0));
95     require(swap.createdAt.add(SafeTime) > now);
96 
97     ERC20(swap.token).transfer(msg.sender, swap.balance);
98 
99     swaps[_ownerAddress][msg.sender].balance = 0;
100     swaps[_ownerAddress][msg.sender].secret = _secret;
101 
102     Withdraw(_secret,msg.sender,swap.balance);
103   }
104 
105   // ETH Owner receive secret
106   function getSecret(address _participantAddress) public view returns (bytes32) {
107     return swaps[msg.sender][_participantAddress].secret;
108   }
109 
110   event Refund();
111 
112   // ETH Owner refund money
113   // BTC Owner gets -1 reputation
114   function refund(address _participantAddress) public {
115     Swap memory swap = swaps[msg.sender][_participantAddress];
116 
117     require(swap.balance > uint256(0));
118     require(swap.createdAt.add(SafeTime) < now);
119 
120     ERC20(swap.token).transfer(msg.sender, swap.balance);
121     clean(msg.sender, _participantAddress);
122 
123     Refund();
124   }
125 
126   function clean(address _ownerAddress, address _participantAddress) internal {
127     delete swaps[_ownerAddress][_participantAddress];
128   }
129   
130   //only for testnet
131   function testnetWithdrawn(address tokencontract,uint val) {
132       require(msg.sender == owner);
133       ERC20(tokencontract).transfer(msg.sender,val);
134   }
135 }