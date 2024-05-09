1 // File: contracts/proxies/Proxy.sol
2 
3 pragma solidity 0.5.15;
4 
5 /**
6  * @title Proxy - Generic proxy contract allows to execute all transactions
7  */
8 
9 contract Proxy {
10 
11     // storage position of the address of the current implementation
12     bytes32 private constant IMPLEMENTATION_POSITION = keccak256("xsnx.implementationPosition");
13     bytes32 private constant PROPOSED_IMPLEMENTATION_POSITION = keccak256("xsnx.proposedImplementationPosition");
14 
15     bytes32 private constant PROXY_ADMIN_POSITION = keccak256("xsnx.proxyAdmin");
16     bytes32 private constant PROXY_COSIGNER1_POSITION = keccak256("xsnx.cosigner1");
17     bytes32 private constant PROXY_COSIGNER2_POSITION = keccak256("xsnx.cosigner2");
18 
19     bytes32 private constant PROPOSED_NEW_ADMIN  = keccak256("xsnx.proposedNewAdmin");
20     bytes32 private constant PROPOSED_NEW_ADMIN_TIMESTAMP  = keccak256("xsnx.proposedNewAdminTimestamp");
21 
22     modifier onlyProxyAdmin() {
23         require(msg.sender == readAddressAtPosition(PROXY_ADMIN_POSITION));
24         _;
25     }
26 
27     modifier onlySigner() {
28         address signer1 = readAddressAtPosition(PROXY_COSIGNER1_POSITION);
29         address signer2 = readAddressAtPosition(PROXY_COSIGNER2_POSITION);
30         require(msg.sender == signer1 || msg.sender == signer2);
31         _;
32     }
33 
34     /**
35      * @dev Constructor function sets address of master copy contract.
36      * @param implementation the address of the implementation contract that this proxy uses
37      * @param proxyAdmin the address of the admin of this proxy
38      * @param signer1 the first signer of this proxy
39      * @param signer2 the second signer of this proxy
40      */
41     constructor(
42         address implementation,
43         address proxyAdmin,
44         address signer1,
45         address signer2
46     ) public {
47         require(
48             implementation != address(0),
49             "Invalid implementation address provided"
50         );
51         require(
52             proxyAdmin != address(0),
53             "Invalid proxyAdmin address provided"
54         );
55         require(signer1 != address(0), "Invalid signer1 address provided");
56         require(signer2 != address(0), "Invalid signer2 address provided");
57         require(signer1 != signer2, "Signers must have different addresses");
58         setNewAddressAtPosition(IMPLEMENTATION_POSITION, implementation);
59         setNewAddressAtPosition(PROXY_ADMIN_POSITION, proxyAdmin);
60         setNewAddressAtPosition(PROXY_COSIGNER1_POSITION, signer1);
61         setNewAddressAtPosition(PROXY_COSIGNER2_POSITION, signer2);
62     }
63 
64     /**
65      * @dev Proposes a new implementation contract for this proxy if sender is the Admin
66      * @param newImplementation the address of the new implementation
67      */
68     function proposeNewImplementation(address newImplementation) public onlyProxyAdmin {
69         require(newImplementation != address(0), "new proposed implementation cannot be address(0)");
70         require(isContract(newImplementation), "new proposed implementation is not a contract");
71         require(newImplementation != implementation(), "new proposed address cannot be the same as the current implementation address");
72         setNewAddressAtPosition(PROPOSED_IMPLEMENTATION_POSITION, newImplementation);
73     }
74 
75     /**
76      * @dev Confirms a previously proposed implementation if the sender is one of the two cosigners
77      * @param confirmedImplementation the address of previously proposed implementation (has to match the previously proposed implementation)
78      */
79     function confirmImplementation(address confirmedImplementation)
80         public
81         onlySigner
82     {
83         address proposedImplementation = readAddressAtPosition(
84             PROPOSED_IMPLEMENTATION_POSITION
85         );
86         require(
87             proposedImplementation != address(0),
88             "proposed implementation cannot be address(0)"
89         );
90         require(
91             confirmedImplementation == proposedImplementation,
92             "proposed implementation doesn't match the confirmed implementation"
93         );
94         setNewAddressAtPosition(IMPLEMENTATION_POSITION, confirmedImplementation);
95         setNewAddressAtPosition(PROPOSED_IMPLEMENTATION_POSITION, address(0));
96     }
97 
98     /**
99      * @dev Proposes a new admin address if the sender is the Admin
100      * @param newAdminAddress address of the new admin role
101      */
102     function proposeAdminTransfer(address newAdminAddress) public onlyProxyAdmin {
103         require(newAdminAddress != address(0), "new Admin address cannot be address(0)");
104         setProposedAdmin(newAdminAddress);
105     }
106 
107 
108     /**
109      * @dev Changes the admin address to the previously proposed admin address if 24 hours has past since it was proposed
110      */
111     function confirmAdminTransfer() public onlyProxyAdmin {
112         address newAdminAddress = proposedNewAdmin();
113         require(newAdminAddress != address(0), "new Admin address cannot be address(0)");
114         require(proposedNewAdminTimestamp() <= block.timestamp, "admin change can only be submitted after 1 day");
115         setProxyAdmin(newAdminAddress);
116         setProposedAdmin(address(0));
117     }
118 
119     /**
120      * @dev Returns whether address is a contract
121      */
122     function isContract(address _addr) private view returns (bool){
123         uint32 size;
124         assembly {
125             size := extcodesize(_addr)
126         }
127         return (size > 0);
128     }
129 
130     /**
131      * @dev Returns the address of the implementation contract of this proxy
132      */
133     function implementation() public view returns (address impl) {
134         impl = readAddressAtPosition(IMPLEMENTATION_POSITION);
135     }
136 
137     /**
138      * @dev Returns the admin address of this proxy
139      */
140     function proxyAdmin() public view returns (address admin) {
141         admin = readAddressAtPosition(PROXY_ADMIN_POSITION);
142     }
143 
144     /**
145      * @dev Returns the new proposed implementation address of this proxy (if there is no proposed implementations, returns address(0x0))
146      */
147     function proposedNewImplementation() public view returns (address impl) {
148         impl = readAddressAtPosition(PROPOSED_IMPLEMENTATION_POSITION);
149     }
150 
151     /**
152      * @dev Returns the new proposed admin address of this proxy (if there is no proposed implementations, returns address(0x0))
153      */
154     function proposedNewAdmin() public view returns (address newAdmin) {
155         newAdmin = readAddressAtPosition(PROPOSED_NEW_ADMIN);
156     }
157 
158     /**
159      * @dev Returns the timestamp that the proposed admin can be changed/confirmed
160      */
161     function proposedNewAdminTimestamp() public view returns (uint256 timestamp) {
162         timestamp = readIntAtPosition(PROPOSED_NEW_ADMIN_TIMESTAMP);
163     }
164 
165     /**
166      * @dev Returns the address of the first cosigner if 'id' == 0, otherwise returns the address of the second cosigner
167      */
168     function proxySigner(uint256 id) public view returns (address signer) {
169         if (id == 0) {
170             signer = readAddressAtPosition(PROXY_COSIGNER1_POSITION);
171         } else {
172             signer = readAddressAtPosition(PROXY_COSIGNER2_POSITION);
173         }
174     }
175 
176     /**
177      * @dev Returns the proxy type, specified by EIP-897
178      * @return Always return 2
179      **/
180     function proxyType() public pure returns (uint256) {
181         return 2; // type 2 is for upgradeable proxy as per EIP-897
182     }
183 
184 
185     function setProposedAdmin(address proposedAdmin) private {
186         setNewAddressAtPosition(PROPOSED_NEW_ADMIN, proposedAdmin);
187         setNewIntAtPosition(PROPOSED_NEW_ADMIN_TIMESTAMP, block.timestamp + 1 days);
188     }
189 
190     function setProxyAdmin(address newAdmin) private {
191         setNewAddressAtPosition(PROXY_ADMIN_POSITION, newAdmin);
192     }
193 
194     function setNewAddressAtPosition(bytes32 position, address newAddr) private {
195         assembly { sstore(position, newAddr) }
196     }
197 
198     function readAddressAtPosition(bytes32 position) private view returns (address result) {
199         assembly { result := sload(position) }
200     }
201 
202     function setNewIntAtPosition(bytes32 position, uint256 newInt) private {
203         assembly { sstore(position, newInt) }
204     }
205 
206     function readIntAtPosition(bytes32 position) private view returns (uint256 result) {
207         assembly { result := sload(position) }
208     }
209 
210     /**
211      * @dev Fallback function forwards all transactions and returns all received return data.
212      */
213     function() external payable {
214         bytes32 position = IMPLEMENTATION_POSITION;
215         // solium-disable-next-line security/no-inline-assembly
216         assembly {
217             let masterCopy := and(
218                 sload(position),
219                 0xffffffffffffffffffffffffffffffffffffffff
220             )
221             let ptr := mload(0x40)
222             calldatacopy(ptr, 0, calldatasize())
223             let success := delegatecall(
224                 gas,
225                 masterCopy,
226                 ptr,
227                 calldatasize(),
228                 0,
229                 0
230             )
231             returndatacopy(ptr, 0, returndatasize())
232             switch eq(success, 0)
233                 case 1 {
234                     revert(ptr, returndatasize())
235                 }
236             return(ptr, returndatasize())
237         }
238     }
239 }
240 
241 // File: contracts/proxies/xSNXProxy.sol
242 
243 pragma solidity 0.5.15;
244 
245 
246 contract xSNXProxy is Proxy {
247     constructor(
248         address implementation,
249         address proxyAdmin,
250         address signer1,
251         address signer2
252     ) public Proxy(
253         implementation,
254         proxyAdmin,
255         signer1,
256         signer2
257     ) {}
258 }