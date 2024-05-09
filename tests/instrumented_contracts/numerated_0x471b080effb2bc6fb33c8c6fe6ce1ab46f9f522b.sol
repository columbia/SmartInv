1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 contract HashTimeLock {
5 
6     mapping(bytes32 => LockContract) public contracts;
7 
8     //                   / - WITHDRAWN
9     // INVALID - ACTIVE |
10     //                   \ - EXPIRED - REFUNDED
11 
12     uint256 public constant INVALID = 0; // Uninitialized  swap -> can go to ACTIVE
13     uint256 public constant ACTIVE = 1; // Active swap -> can go to WITHDRAWN or EXPIRED
14     uint256 public constant REFUNDED = 2; // Swap is refunded -> final state.
15     uint256 public constant WITHDRAWN = 3; // Swap is withdrawn -> final state.
16     uint256 public constant EXPIRED = 4; // Swap is expired -> can go to REFUNDED
17 
18     struct LockContract {
19         uint256 inputAmount;
20         uint256 outputAmount;
21         uint256 expiration;
22         uint256 status;
23         bytes32 hashLock;
24         address payable sender;
25         address payable receiver;
26         string outputNetwork;
27         string outputAddress;
28     }
29 
30     event Withdraw(
31         bytes32 indexed id,
32         bytes32 secret,
33         bytes32 hashLock,
34         address indexed sender,
35         address indexed receiver
36     );
37 
38     event Refund(
39         bytes32 indexed id,
40         bytes32 hashLock,
41         address indexed sender,
42         address indexed receiver
43     );
44 
45     event NewContract(
46         uint256 inputAmount,
47         uint256 outputAmount,
48         uint256 expiration,
49         bytes32 indexed id,
50         bytes32 hashLock,
51         address indexed sender,
52         address indexed receiver,
53         string outputNetwork,
54         string outputAddress
55     );
56 
57     function newContract(
58         uint256 outputAmount,
59         uint256 expiration,
60         bytes32 hashLock,
61         address payable receiver,
62         string calldata outputNetwork,
63         string calldata outputAddress
64     ) external payable {
65         address payable sender = msg.sender;
66         uint256 inputAmount = msg.value;
67 
68         require(expiration > block.timestamp, 'INVALID_TIME');
69 
70         require(inputAmount > 0, 'INVALID_AMOUNT');
71 
72         bytes32 id = sha256(
73             abi.encodePacked(sender, receiver, inputAmount, hashLock, expiration)
74         );
75 
76         require(contracts[id].status == INVALID, "SWAP_EXISTS");
77 
78         contracts[id] = LockContract(
79             inputAmount,
80             outputAmount,
81             expiration,
82             ACTIVE,
83             hashLock,
84             sender,
85             receiver,
86             outputNetwork,
87             outputAddress
88         );
89 
90         emit NewContract(
91             inputAmount,
92             outputAmount,
93             expiration,
94             id,
95             hashLock,
96             sender,
97             receiver,
98             outputNetwork,
99             outputAddress
100         );
101     }
102 
103     function withdraw(bytes32 id, bytes32 secret) external {
104         LockContract storage c = contracts[id];
105 
106         require(c.status == ACTIVE, "SWAP_NOT_ACTIVE");
107 
108         require(c.expiration > block.timestamp, "INVALID_TIME");
109 
110         require(c.hashLock == sha256(abi.encodePacked(secret)),"INVALID_SECRET");
111 
112         c.status = WITHDRAWN;
113 
114         c.receiver.transfer(c.inputAmount);
115 
116         emit Withdraw(id, secret, c.hashLock, c.sender, c.receiver);
117     }
118 
119     function refund(bytes32 id) external {
120         LockContract storage c = contracts[id];
121 
122         require(c.status == ACTIVE, "SWAP_NOT_ACTIVE");
123 
124         require(c.expiration <= block.timestamp, "INVALID_TIME");
125 
126         c.status = REFUNDED;
127 
128         c.sender.transfer(c.inputAmount);
129 
130         emit Refund(id, c.hashLock, c.sender, c.receiver);
131     }
132 
133     function getStatus(bytes32[] memory ids) public view returns (uint256[] memory) {
134         uint256[] memory result = new uint256[](ids.length);
135 
136         for (uint256 index = 0; index < ids.length; index++) {
137             result[index] = getSingleStatus(ids[index]);
138         }
139 
140         return result;
141     }
142 
143     function getSingleStatus(bytes32 id) public view returns (uint256 result) {
144         LockContract memory tempContract = contracts[id];
145 
146         if (
147             tempContract.status == ACTIVE &&
148             tempContract.expiration < block.timestamp
149         ) {
150             result = EXPIRED;
151         } else {
152             result = tempContract.status;
153         }
154     }
155 }