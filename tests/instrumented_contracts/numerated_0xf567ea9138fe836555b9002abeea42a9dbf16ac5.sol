1 pragma solidity >=0.5.0 <0.6.0;
2 pragma experimental ABIEncoderV2;
3 
4 contract HashTimeLock {
5   mapping(bytes32 => LockContract) public contracts;
6 
7   enum SwapStatus { INVALID, ACTIVE, REFUNDED, WITHDRAWN, EXPIRED }
8 
9   struct LockContract {
10     uint256 inputAmount;
11     uint256 outputAmount;
12     uint256 expiration;
13     bytes32 hashLock;
14     SwapStatus status;
15     address payable sender;
16     address payable receiver;
17     string outputNetwork;
18     string outputAddress;
19   }
20 
21   event Withdraw(
22     bytes32 indexed id,
23     bytes32 secret,
24     bytes32 hashLock,
25     address indexed sender,
26     address indexed receiver
27   );
28 
29   event Refund(
30     bytes32 indexed id,
31     bytes32 hashLock,
32     address indexed sender,
33     address indexed receiver
34   );
35 
36   event NewContract(
37     uint256 inputAmount,
38     uint256 outputAmount,
39     uint256 expiration,
40     bytes32 indexed id,
41     bytes32 hashLock,
42     address indexed sender,
43     address indexed receiver,
44     string outputNetwork,
45     string outputAddress
46   );
47 
48   modifier withdrawable(bytes32 id, bytes32 secret) {
49     LockContract memory tempContract = contracts[id];
50     require(tempContract.status == SwapStatus.ACTIVE, 'SWAP_NOT_ACTIVE');
51     require(tempContract.expiration > block.timestamp, 'INVALID_TIME');
52     require(
53       tempContract.hashLock == sha256(abi.encodePacked(secret)),
54       'INVALID_SECRET'
55     );
56     _;
57   }
58 
59   modifier refundable(bytes32 id) {
60     LockContract memory tempContract = contracts[id];
61     require(tempContract.status == SwapStatus.ACTIVE, 'SWAP_NOT_ACTIVE');
62     require(tempContract.expiration <= block.timestamp, 'INVALID_TIME');
63     require(tempContract.sender == msg.sender, 'INVALID_SENDER');
64     _;
65   }
66 
67   function newContract(
68     uint256 outputAmount,
69     uint256 expiration,
70     bytes32 hashLock,
71     address payable receiver,
72     string memory outputNetwork,
73     string memory outputAddress
74   ) public payable {
75     address payable sender = msg.sender;
76     uint256 inputAmount = msg.value;
77 
78     require(expiration > block.timestamp, 'INVALID_TIME');
79 
80     require(inputAmount > 0, 'INVALID_AMOUNT');
81 
82     bytes32 id = sha256(
83       abi.encodePacked(sender, receiver, inputAmount, hashLock, expiration)
84     );
85 
86     contracts[id] = LockContract(
87       inputAmount,
88       outputAmount,
89       expiration,
90       hashLock,
91       SwapStatus.ACTIVE,
92       sender,
93       receiver,
94       outputNetwork,
95       outputAddress
96     );
97 
98     emit NewContract(
99       inputAmount,
100       outputAmount,
101       expiration,
102       id,
103       hashLock,
104       sender,
105       receiver,
106       outputNetwork,
107       outputAddress
108     );
109   }
110 
111   function withdraw(bytes32 id, bytes32 secret)
112     public
113     withdrawable(id, secret)
114     returns (bool)
115   {
116     LockContract storage c = contracts[id];
117     c.status = SwapStatus.WITHDRAWN;
118     c.receiver.transfer(c.inputAmount);
119     emit Withdraw(id, secret, c.hashLock, c.sender, c.receiver);
120     return true;
121   }
122 
123   function refund(bytes32 id) external refundable(id) returns (bool) {
124     LockContract storage c = contracts[id];
125     c.status = SwapStatus.REFUNDED;
126     c.sender.transfer(c.inputAmount);
127     emit Refund(id, c.hashLock, c.sender, c.receiver);
128     return true;
129   }
130 
131   function getContract(bytes32 id) public view returns (LockContract memory) {
132     LockContract memory c = contracts[id];
133     return c;
134   }
135 
136   function contractExists(bytes32 id) public view returns (bool) {
137     return contracts[id].status != SwapStatus.INVALID;
138   }
139 
140   function getStatus(bytes32[] memory ids)
141     public
142     view
143     returns (uint8[] memory)
144   {
145     uint8[] memory result = new uint8[](ids.length);
146 
147     for (uint256 index = 0; index < ids.length; index++) {
148       result[index] = getStatus(ids[index]);
149     }
150 
151     return result;
152   }
153 
154   function getStatus(bytes32 id) public view returns (uint8 result) {
155     LockContract memory tempContract = contracts[id];
156 
157     if (
158       tempContract.status == SwapStatus.ACTIVE &&
159       tempContract.expiration < block.timestamp
160     ) {
161       result = uint8(SwapStatus.EXPIRED);
162     } else {
163       result = uint8(tempContract.status);
164     }
165   }
166 }