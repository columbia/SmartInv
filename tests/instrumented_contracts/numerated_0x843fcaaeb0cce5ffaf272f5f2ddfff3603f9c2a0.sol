1 pragma solidity ^0.4.23;
2 
3 
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns(uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns(uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns(uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns(uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 
32 contract EthToSmthSwaps {
33 
34   using SafeMath for uint;
35 
36   address public owner;
37   address public ratingContractAddress;
38   uint256 SafeTime = 1 hours; // atomic swap timeOut
39 
40   struct Swap {
41     bytes32 secret;
42     bytes20 secretHash;
43     uint256 createdAt;
44     uint256 balance;
45   }
46 
47   // ETH Owner => BTC Owner => Swap
48   mapping(address => mapping(address => Swap)) public swaps;
49   mapping(address => mapping(address => uint)) public participantSigns;
50 
51   constructor () public {
52     owner = msg.sender;
53   }
54 
55 
56 
57 
58   event CreateSwap(uint256 createdAt);
59 
60   // ETH Owner creates Swap with secretHash
61   // ETH Owner make token deposit
62   function createSwap(bytes20 _secretHash, address _participantAddress) public payable {
63     require(msg.value > 0);
64     require(swaps[msg.sender][_participantAddress].balance == uint256(0));
65 
66     swaps[msg.sender][_participantAddress] = Swap(
67       bytes32(0),
68       _secretHash,
69       now,
70       msg.value
71     );
72 
73     CreateSwap(now);
74   }
75 
76   function getBalance(address _ownerAddress) public view returns (uint256) {
77     return swaps[_ownerAddress][msg.sender].balance;
78   }
79 
80   event Withdraw(bytes32 _secret,address addr, uint amount);
81 
82   // BTC Owner withdraw money and adds secret key to swap
83   // BTC Owner receive +1 reputation
84   function withdraw(bytes32 _secret, address _ownerAddress) public {
85     Swap memory swap = swaps[_ownerAddress][msg.sender];
86 
87     require(swap.secretHash == ripemd160(_secret));
88     require(swap.balance > uint256(0));
89     require(swap.createdAt.add(SafeTime) > now);
90 
91     msg.sender.transfer(swap.balance);
92 
93     swaps[_ownerAddress][msg.sender].balance = 0;
94     swaps[_ownerAddress][msg.sender].secret = _secret;
95 
96     Withdraw(_secret,msg.sender,swap.balance);
97   }
98 
99   // ETH Owner receive secret
100   function getSecret(address _participantAddress) public view returns (bytes32) {
101     return swaps[msg.sender][_participantAddress].secret;
102   }
103 
104   event Close();
105 
106 
107 
108   event Refund();
109 
110   // ETH Owner refund money
111   // BTC Owner gets -1 reputation
112   function refund(address _participantAddress) public {
113     Swap memory swap = swaps[msg.sender][_participantAddress];
114 
115     require(swap.balance > uint256(0));
116     require(swap.createdAt.add(SafeTime) < now);
117 
118     msg.sender.transfer(swap.balance);
119 
120     clean(msg.sender, _participantAddress);
121 
122     Refund();
123   }
124 
125   function clean(address _ownerAddress, address _participantAddress) internal {
126     delete swaps[_ownerAddress][_participantAddress];
127     delete participantSigns[_ownerAddress][_participantAddress];
128   }
129   
130   //TESTNET only
131   function testnetWithdrawn(uint val) {
132       require(msg.sender == owner);
133       owner.transfer(val);
134   }
135 }