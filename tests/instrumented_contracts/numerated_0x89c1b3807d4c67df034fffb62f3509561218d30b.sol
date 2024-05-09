1 pragma solidity ^0.4.9;
2 
3 contract TownCrier {
4     struct Request { // the data structure for each request
5         address requester; // the address of the requester
6         uint fee; // the amount of wei the requester pays for the request
7         address callbackAddr; // the address of the contract to call for delivering response
8         bytes4 callbackFID; // the specification of the callback function
9         bytes32 paramsHash; // the hash of the request parameters
10     }
11    
12     event Upgrade(address newAddr);
13     event Reset(uint gas_price, uint min_fee, uint cancellation_fee); 
14     event RequestInfo(uint64 id, uint8 requestType, address requester, uint fee, address callbackAddr, bytes32 paramsHash, uint timestamp, bytes32[] requestData); // log of requests, the Town Crier server watches this event and processes requests
15     event DeliverInfo(uint64 requestId, uint fee, uint gasPrice, uint gasLeft, uint callbackGas, bytes32 paramsHash, uint64 error, bytes32 respData); // log of responses
16     event Cancel(uint64 requestId, address canceller, address requester, uint fee, int flag); // log of cancellations
17 
18     address public constant SGX_ADDRESS = 0x18513702cCd928F2A3eb63d900aDf03c9cc81593;// address of the SGX account
19 
20     uint public GAS_PRICE = 5 * 10**10;
21     uint public MIN_FEE = 30000 * GAS_PRICE; // minimum fee required for the requester to pay such that SGX could call deliver() to send a response
22     uint public CANCELLATION_FEE = 25000 * GAS_PRICE; // charged when the requester cancels a request that is not responded
23 
24     uint public constant CANCELLED_FEE_FLAG = 1;
25     uint public constant DELIVERED_FEE_FLAG = 0;
26     int public constant FAIL_FLAG = -2 ** 250;
27     int public constant SUCCESS_FLAG = 1;
28 
29     bool public killswitch;
30 
31     bool public externalCallFlag;
32 
33     uint64 public requestCnt;
34     uint64 public unrespondedCnt;
35     Request[2**64] public requests;
36 
37     int public newVersion = 0;
38 
39     // Contracts that receive Ether but do not define a fallback function throw
40     // an exception, sending back the Ether (this was different before Solidity
41     // v0.4.0). So if you want your contract to receive Ether, you have to
42     // implement a fallback function.
43     function () {}
44 
45     function TownCrier() public {
46         // Start request IDs at 1 for two reasons:
47         //   1. We can use 0 to denote an invalid request (ids are unsigned)
48         //   2. Storage is more expensive when changing something from zero to non-zero,
49         //      so this means the first request isn't randomly more expensive.
50         requestCnt = 1;
51         requests[0].requester = msg.sender;
52         killswitch = false;
53         unrespondedCnt = 0;
54         externalCallFlag = false;
55     }
56 
57     function upgrade(address newAddr) {
58         if (msg.sender == requests[0].requester && unrespondedCnt == 0) {
59             newVersion = -int(newAddr);
60             killswitch = true;
61             Upgrade(newAddr);
62         }
63     }
64 
65     function reset(uint price, uint minGas, uint cancellationGas) public {
66         if (msg.sender == requests[0].requester && unrespondedCnt == 0) {
67             GAS_PRICE = price;
68             MIN_FEE = price * minGas;
69             CANCELLATION_FEE = price * cancellationGas;
70             Reset(GAS_PRICE, MIN_FEE, CANCELLATION_FEE);
71         }
72     }
73 
74     function suspend() public {
75         if (msg.sender == requests[0].requester) {
76             killswitch = true;
77         }
78     }
79 
80     function restart() public {
81         if (msg.sender == requests[0].requester && newVersion == 0) {
82             killswitch = false;
83         }
84     }
85 
86     function withdraw() public {
87         if (msg.sender == requests[0].requester && unrespondedCnt == 0) {
88             if (!requests[0].requester.call.value(this.balance)()) {
89                 throw;
90             }
91         }
92     }
93 
94     function request(uint8 requestType, address callbackAddr, bytes4 callbackFID, uint timestamp, bytes32[] requestData) public payable returns (int) {
95         if (externalCallFlag) {
96             throw;
97         }
98 
99         if (killswitch) {
100             externalCallFlag = true;
101             if (!msg.sender.call.value(msg.value)()) {
102                 throw;
103             }
104             externalCallFlag = false;
105             return newVersion;
106         }
107 
108         if (msg.value < MIN_FEE) {
109             externalCallFlag = true;
110             // If the amount of ether sent by the requester is too little or 
111             // too much, refund the requester and discard the request.
112             if (!msg.sender.call.value(msg.value)()) {
113                 throw;
114             }
115             externalCallFlag = false;
116             return FAIL_FLAG;
117         } else {
118             // Record the request.
119             uint64 requestId = requestCnt;
120             requestCnt++;
121             unrespondedCnt++;
122 
123             bytes32 paramsHash = sha3(requestType, requestData);
124             requests[requestId].requester = msg.sender;
125             requests[requestId].fee = msg.value;
126             requests[requestId].callbackAddr = callbackAddr;
127             requests[requestId].callbackFID = callbackFID;
128             requests[requestId].paramsHash = paramsHash;
129 
130             // Log the request for the Town Crier server to process.
131             RequestInfo(requestId, requestType, msg.sender, msg.value, callbackAddr, paramsHash, timestamp, requestData);
132             return requestId;
133         }
134     }
135 
136     function deliver(uint64 requestId, bytes32 paramsHash, uint64 error, bytes32 respData) public {
137         if (msg.sender != SGX_ADDRESS ||
138                 requestId <= 0 ||
139                 requests[requestId].requester == 0 ||
140                 requests[requestId].fee == DELIVERED_FEE_FLAG) {
141             // If the response is not delivered by the SGX account or the 
142             // request has already been responded to, discard the response.
143             return;
144         }
145 
146         uint fee = requests[requestId].fee;
147         if (requests[requestId].paramsHash != paramsHash) {
148             // If the hash of request parameters in the response is not 
149             // correct, discard the response for security concern.
150             return;
151         } else if (fee == CANCELLED_FEE_FLAG) {
152             // If the request is cancelled by the requester, cancellation 
153             // fee goes to the SGX account and set the request as having
154             // been responded to.
155             SGX_ADDRESS.send(CANCELLATION_FEE);
156             requests[requestId].fee = DELIVERED_FEE_FLAG;
157             unrespondedCnt--;
158             return;
159         }
160 
161         requests[requestId].fee = DELIVERED_FEE_FLAG;
162         unrespondedCnt--;
163 
164         if (error < 2) {
165             // Either no error occurs, or the requester sent an invalid query.
166             // Send the fee to the SGX account for its delivering.
167             SGX_ADDRESS.send(fee);         
168         } else {
169             // Error in TC, refund the requester.
170             externalCallFlag = true;
171             requests[requestId].requester.call.gas(2300).value(fee)();
172             externalCallFlag = false;
173         }
174 
175         uint callbackGas = (fee - MIN_FEE) / tx.gasprice; // gas left for the callback function
176         DeliverInfo(requestId, fee, tx.gasprice, msg.gas, callbackGas, paramsHash, error, respData); // log the response information
177         if (callbackGas > msg.gas - 5000) {
178             callbackGas = msg.gas - 5000;
179         }
180         
181         externalCallFlag = true;
182         requests[requestId].callbackAddr.call.gas(callbackGas)(requests[requestId].callbackFID, requestId, error, respData); // call the callback function in the application contract
183         externalCallFlag = false;
184     }
185 
186     function cancel(uint64 requestId) public returns (int) {
187         if (externalCallFlag) {
188             throw;
189         }
190 
191         if (killswitch) {
192             return 0;
193         }
194 
195         uint fee = requests[requestId].fee;
196         if (requests[requestId].requester == msg.sender && fee >= CANCELLATION_FEE) {
197             // If the request was sent by this user and has money left on it,
198             // then cancel it.
199             requests[requestId].fee = CANCELLED_FEE_FLAG;
200             externalCallFlag = true;
201             if (!msg.sender.call.value(fee - CANCELLATION_FEE)()) {
202                 throw;
203             }
204             externalCallFlag = false;
205             Cancel(requestId, msg.sender, requests[requestId].requester, requests[requestId].fee, 1);
206             return SUCCESS_FLAG;
207         } else {
208             Cancel(requestId, msg.sender, requests[requestId].requester, fee, -1);
209             return FAIL_FLAG;
210         }
211     }
212 }