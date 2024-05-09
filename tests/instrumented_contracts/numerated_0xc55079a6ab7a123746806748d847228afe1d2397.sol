1 pragma solidity ^0.7.5;
2 pragma experimental ABIEncoderV2;
3 
4 contract ENSCommitment {
5     struct Commitment {
6         string name;
7         address owner;
8         uint256 duration;
9         bytes32 secret;
10         address resolver;
11         bytes[] data;
12         bool reverseRecord;
13         uint32 fuses;
14         uint64 wrapperExpiry;
15     }
16     struct RegistrationWithConfig {
17         string name;
18         address owner;
19     }
20 }
21 
22 interface ENSController {
23     event NameRegistered(
24         string name,
25         bytes32 indexed label,
26         address indexed owner,
27         uint256 cost,
28         uint256 expires
29     );
30     event NameRenewed(
31         string name,
32         bytes32 indexed label,
33         uint256 cost,
34         uint256 expires
35     );
36     event NewPriceOracle(address indexed oracle);
37 
38     function rentPrice(string memory name, uint256 duration)
39         external
40         view
41         returns (uint256);
42 
43     function valid(string memory name) external pure returns (bool);
44 
45     function available(string memory name) external view returns (bool);
46 
47     function makeCommitment(
48         string memory name,
49         address owner,
50         bytes32 secret
51     ) external pure returns (bytes32);
52 
53     function makeCommitmentWithConfig(
54         string memory name,
55         address owner,
56         bytes32 secret,
57         address resolver,
58         address addr
59     ) external pure returns (bytes32);
60 
61     function commit(bytes32 commitment) external;
62 
63     function register(
64         string calldata name,
65         address owner,
66         uint256 duration,
67         bytes32 secret
68     ) external payable;
69 
70     function registerWithConfig(
71         string memory name,
72         address owner,
73         uint256 duration,
74         bytes32 secret,
75         address resolver,
76         address addr
77     ) external payable;
78 
79     function renew(string calldata name, uint256 duration) external payable;
80 }
81 
82 interface ENS {
83     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
84     event Transfer(bytes32 indexed node, address owner);
85     event NewResolver(bytes32 indexed node, address resolver);
86     event NewTTL(bytes32 indexed node, uint64 ttl);
87     event ApprovalForAll(
88         address indexed owner,
89         address indexed operator,
90         bool approved
91     );
92 
93     function setRecord(
94         bytes32 node,
95         address owner,
96         address resolver,
97         uint64 ttl
98     ) external;
99 
100     function setSubnodeRecord(
101         bytes32 node,
102         bytes32 label,
103         address owner,
104         address resolver,
105         uint64 ttl
106     ) external;
107 
108     function setSubnodeOwner(
109         bytes32 node,
110         bytes32 label,
111         address owner
112     ) external returns (bytes32);
113 
114     function setResolver(bytes32 node, address resolver) external;
115 
116     function setOwner(bytes32 node, address owner) external;
117 
118     function setTTL(bytes32 node, uint64 ttl) external;
119 
120     function setApprovalForAll(address operator, bool approved) external;
121 
122     function owner(bytes32 node) external view returns (address);
123 
124     function resolver(bytes32 node) external view returns (address);
125 
126     function ttl(bytes32 node) external view returns (uint64);
127 
128     function recordExists(bytes32 node) external view returns (bool);
129 
130     function isApprovedForAll(address owner, address operator)
131         external
132         view
133         returns (bool);
134 }
135 
136 contract BulkRegister {
137     address payable deployer;
138     ENSController ensRegistrarController =
139         ENSController(0x283Af0B28c62C092C9727F1Ee09c02CA627EB7F5);
140 
141     event error(bytes errorInfo);
142 
143     receive() external payable {}
144 
145     modifier onlyDeployer() {
146         require(deployer == msg.sender, "Not deployer.");
147         _;
148     }
149 
150     constructor() {
151         deployer = msg.sender;
152     }
153 
154     function recoverStuckETH() public onlyDeployer {
155         deployer.transfer(address(this).balance);
156     }
157 
158     function createCommitmentsForRegistration(
159         ENSCommitment.Commitment[] memory commitments,
160         uint256 duration,
161         bool withConfigs
162     ) public view returns (bytes32[] memory, uint256[] memory) {
163         bytes32[] memory createdCommitments = new bytes32[](commitments.length);
164         if (withConfigs == false) {
165             for (uint8 i = 0; i < commitments.length; i++) {
166                 createdCommitments[i] = ensRegistrarController.makeCommitment(
167                     commitments[i].name,
168                     commitments[i].owner,
169                     commitments[i].secret
170                 );
171             }
172         } else {
173             for (uint8 i = 0; i < commitments.length; i++) {
174                 createdCommitments[i] = ensRegistrarController
175                     .makeCommitmentWithConfig(
176                         commitments[i].name,
177                         commitments[i].owner,
178                         commitments[i].secret,
179                         commitments[i].resolver,
180                         commitments[i].owner
181                     );
182             }
183         }
184         uint256[] memory pricesRange = getPriceRanges(duration);
185         return (createdCommitments, pricesRange);
186     }
187 
188     function requestRegistration(bytes32[] memory commitments) public {
189         for (uint8 i = 0; i < commitments.length; i++) {
190             ensRegistrarController.commit(commitments[i]);
191         }
192     }
193 
194     function completeRegistration(
195         string[] memory names,
196         uint256[] memory nameLengths,
197         address owner,
198         uint256 duration,
199         bytes32 secret
200     ) public payable {
201         uint256 totalPrice;
202         uint256[] memory priceRanges = getPriceRanges(duration);
203         for (uint8 i = 0; i < names.length; i++) {
204             uint256 price;
205             uint256 nameLen = nameLengths[i];
206             if (nameLen == 3) {
207                 price = priceRanges[0];
208             } else if (nameLen == 4) {
209                 price = priceRanges[1];
210             } else {
211                 price = priceRanges[2];
212             }
213             bool hasErrorOccured = false;
214             try
215                 ensRegistrarController.register{value: price}(
216                     names[i],
217                     owner,
218                     duration,
219                     secret
220                 )
221             {} catch (bytes memory info) {
222                 hasErrorOccured = true;
223                 emit error(info);
224             }
225             if (hasErrorOccured == false) {
226                 totalPrice += price;
227             }
228         }
229         if (msg.value > totalPrice) {
230             msg.sender.transfer(msg.value - totalPrice);
231         }
232     }
233 
234     function completeRegistrationWithConfigs(
235         string[] memory names,
236         uint256[] memory nameLengths,
237         uint256 duration,
238         bytes32 secret,
239         address resolver,
240         address owner
241     ) public payable {
242         uint256 totalPrice;
243         uint256[] memory priceRanges = getPriceRanges(duration);
244         for (uint8 i = 0; i < names.length; i++) {
245             uint256 price;
246             uint256 nameLen = nameLengths[i];
247             if (nameLen == 3) {
248                 price = priceRanges[0];
249             } else if (nameLen == 4) {
250                 price = priceRanges[1];
251             } else {
252                 price = priceRanges[2];
253             }
254             bool hasErrorOccured = false;
255             try
256                 ensRegistrarController.registerWithConfig{value: price}(
257                     names[i],
258                     owner,
259                     duration,
260                     secret,
261                     resolver,
262                     owner
263                 )
264             {} catch (bytes memory info) {
265                 hasErrorOccured = true;
266                 emit error(info);
267             }
268             if (hasErrorOccured == false) {
269                 totalPrice += price;
270             }
271         }
272         if (msg.value > totalPrice) {
273             msg.sender.transfer(msg.value - totalPrice);
274         }
275     }
276 
277     function getPriceRanges(uint256 duration)
278         public
279         view
280         returns (uint256[] memory)
281     {
282         uint256[] memory priceRanges = new uint256[](3);
283         string[3] memory pricesRangeMatch = ["123", "1234", "12345"];
284         for (uint8 i = 0; i < 3; i++) {
285             uint256 priceMeasured = ensRegistrarController.rentPrice(
286                 pricesRangeMatch[i],
287                 duration
288             );
289             priceRanges[i] = priceMeasured;
290         }
291         return priceRanges;
292     }
293 }