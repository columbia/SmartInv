1 // SPDX-License-Identifier: MIT
2 // An example of a consumer contract that relies on a subscription for funding.
3 pragma solidity ^0.8.7;
4 
5 interface VRFCoordinatorV2Interface {
6   /**
7    * @notice Get configuration relevant for making requests
8    * @return minimumRequestConfirmations global min for request confirmations
9    * @return maxGasLimit global max for request gas limit
10    * @return s_provingKeyHashes list of registered key hashes
11    */
12   function getRequestConfig()
13     external
14     view
15     returns (
16       uint16,
17       uint32,
18       bytes32[] memory
19     );
20 
21   /**
22    * @notice Request a set of random words.
23    * @param keyHash - Corresponds to a particular oracle job which uses
24    * that key for generating the VRF proof. Different keyHash's have different gas price
25    * ceilings, so you can select a specific one to bound your maximum per request cost.
26    * @param subId  - The ID of the VRF subscription. Must be funded
27    * with the minimum subscription balance required for the selected keyHash.
28    * @param minimumRequestConfirmations - How many blocks you'd like the
29    * oracle to wait before responding to the request. See SECURITY CONSIDERATIONS
30    * for why you may want to request more. The acceptable range is
31    * [minimumRequestBlockConfirmations, 200].
32    * @param callbackGasLimit - How much gas you'd like to receive in your
33    * fulfillRandomWords callback. Note that gasleft() inside fulfillRandomWords
34    * may be slightly less than this amount because of gas used calling the function
35    * (argument decoding etc.), so you may need to request slightly more than you expect
36    * to have inside fulfillRandomWords. The acceptable range is
37    * [0, maxGasLimit]
38    * @param numWords - The number of uint256 random values you'd like to receive
39    * in your fulfillRandomWords callback. Note these numbers are expanded in a
40    * secure way by the VRFCoordinator from a single random value supplied by the oracle.
41    * @return requestId - A unique identifier of the request. Can be used to match
42    * a request to a response in fulfillRandomWords.
43    */
44   function requestRandomWords(
45     bytes32 keyHash,
46     uint64 subId,
47     uint16 minimumRequestConfirmations,
48     uint32 callbackGasLimit,
49     uint32 numWords
50   ) external returns (uint256 requestId);
51 
52   /**
53    * @notice Create a VRF subscription.
54    * @return subId - A unique subscription id.
55    * @dev You can manage the consumer set dynamically with addConsumer/removeConsumer.
56    * @dev Note to fund the subscription, use transferAndCall. For example
57    * @dev  LINKTOKEN.transferAndCall(
58    * @dev    address(COORDINATOR),
59    * @dev    amount,
60    * @dev    abi.encode(subId));
61    */
62   function createSubscription() external returns (uint64 subId);
63 
64   /**
65    * @notice Get a VRF subscription.
66    * @param subId - ID of the subscription
67    * @return balance - LINK balance of the subscription in juels.
68    * @return reqCount - number of requests for this subscription, determines fee tier.
69    * @return owner - owner of the subscription.
70    * @return consumers - list of consumer address which are able to use this subscription.
71    */
72   function getSubscription(uint64 subId)
73     external
74     view
75     returns (
76       uint96 balance,
77       uint64 reqCount,
78       address owner,
79       address[] memory consumers
80     );
81 
82   /**
83    * @notice Request subscription owner transfer.
84    * @param subId - ID of the subscription
85    * @param newOwner - proposed new owner of the subscription
86    */
87   function requestSubscriptionOwnerTransfer(uint64 subId, address newOwner) external;
88 
89   /**
90    * @notice Request subscription owner transfer.
91    * @param subId - ID of the subscription
92    * @dev will revert if original owner of subId has
93    * not requested that msg.sender become the new owner.
94    */
95   function acceptSubscriptionOwnerTransfer(uint64 subId) external;
96 
97   /**
98    * @notice Add a consumer to a VRF subscription.
99    * @param subId - ID of the subscription
100    * @param consumer - New consumer which can use the subscription
101    */
102   function addConsumer(uint64 subId, address consumer) external;
103 
104   /**
105    * @notice Remove a consumer from a VRF subscription.
106    * @param subId - ID of the subscription
107    * @param consumer - Consumer to remove from the subscription
108    */
109   function removeConsumer(uint64 subId, address consumer) external;
110 
111   /**
112    * @notice Cancel a subscription
113    * @param subId - ID of the subscription
114    * @param to - Where to send the remaining LINK to
115    */
116   function cancelSubscription(uint64 subId, address to) external;
117 }
118 abstract contract VRFConsumerBaseV2 {
119   error OnlyCoordinatorCanFulfill(address have, address want);
120   address private immutable vrfCoordinator;
121 
122   /**
123    * @param _vrfCoordinator address of VRFCoordinator contract
124    */
125   constructor(address _vrfCoordinator) {
126     vrfCoordinator = _vrfCoordinator;
127   }
128 
129   /**
130    * @notice fulfillRandomness handles the VRF response. Your contract must
131    * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
132    * @notice principles to keep in mind when implementing your fulfillRandomness
133    * @notice method.
134    *
135    * @dev VRFConsumerBaseV2 expects its subcontracts to have a method with this
136    * @dev signature, and will call it once it has verified the proof
137    * @dev associated with the randomness. (It is triggered via a call to
138    * @dev rawFulfillRandomness, below.)
139    *
140    * @param requestId The Id initially returned by requestRandomness
141    * @param randomWords the VRF output expanded to the requested number of words
142    */
143   function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal virtual;
144 
145   // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
146   // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
147   // the origin of the call
148   function rawFulfillRandomWords(uint256 requestId, uint256[] memory randomWords) external {
149     if (msg.sender != vrfCoordinator) {
150       revert OnlyCoordinatorCanFulfill(msg.sender, vrfCoordinator);
151     }
152     fulfillRandomWords(requestId, randomWords);
153   }
154 }
155 
156 contract Giveaway is VRFConsumerBaseV2 {
157     address [] public addresses;
158     mapping (address => bool) public rafflemap;
159     address [] private _winners;
160     event Winner(
161         address [] indexed _winners,
162         uint256 gameId
163     );
164     event Registered(
165         address indexed user
166     );
167 
168     VRFCoordinatorV2Interface COORDINATOR;
169 
170     // Your subscription ID.
171     uint64 s_subscriptionId;
172 
173 
174     address vrfCoordinator = 0x271682DEB8C4E0901D1a1550aD2e64D568E69909;
175 
176     bytes32 keyHash = 0x8af398995b04c28e9951adb9721ef74c74f93e6a478f39e7e0777be13527e7ef;
177 
178     uint32 callbackGasLimit = 500000;
179 
180     // The default is 3, but you can set this higher.
181     uint16 requestConfirmations = 3;
182 
183 
184     uint32 numRandoms =  5;
185 
186     uint256[] public s_randomWords;
187     uint256 public s_requestId;
188     address s_owner;
189 
190     constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
191         COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
192         s_owner = msg.sender;
193         s_subscriptionId = subscriptionId;
194     }
195 
196 
197     function insertAddress() public {
198       address who = msg.sender;
199       require(!rafflemap[who]);
200       addresses.push(who);
201       rafflemap[who] = true;
202       emit Registered(who);
203     }
204 
205     // Assumes the subscription is funded sufficiently.
206     function giveaway() external onlyOwner {
207         // Will revert if subscription is not set and funded.
208         s_requestId = COORDINATOR.requestRandomWords(
209             keyHash,
210             s_subscriptionId,
211             requestConfirmations,
212             callbackGasLimit,
213             numRandoms
214         );
215     }
216     
217     function fulfillRandomWords(
218         uint256, /* requestId */
219         uint256[] memory randomWords
220     ) internal override {
221         s_randomWords = randomWords;
222     }
223 
224     function pusharray() public onlyOwner {
225       //case which we have to raffle again
226       if(_winners.length > 0){
227         delete _winners;
228       }
229       for(uint i=0; i<numRandoms; i++){
230         uint256 randomNumber = (s_randomWords[i] % addresses.length);
231         _winners.push(addresses[randomNumber]);
232       }
233       emit Winner(_winners, s_requestId);
234     }
235 
236     function getwinners() public view returns (address[] memory){
237       return _winners;
238     }
239 
240     modifier onlyOwner() {
241         require(msg.sender == s_owner);
242         _;
243     }
244 }