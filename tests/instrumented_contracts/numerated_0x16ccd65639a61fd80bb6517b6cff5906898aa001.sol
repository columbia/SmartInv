1 pragma solidity ^0.4.13;
2 
3 contract EthicHubStorageInterface {
4 
5     //modifier for access in sets and deletes
6     modifier onlyEthicHubContracts() {_;}
7 
8     // Setters
9     function setAddress(bytes32 _key, address _value) external;
10     function setUint(bytes32 _key, uint _value) external;
11     function setString(bytes32 _key, string _value) external;
12     function setBytes(bytes32 _key, bytes _value) external;
13     function setBool(bytes32 _key, bool _value) external;
14     function setInt(bytes32 _key, int _value) external;
15     // Deleters
16     function deleteAddress(bytes32 _key) external;
17     function deleteUint(bytes32 _key) external;
18     function deleteString(bytes32 _key) external;
19     function deleteBytes(bytes32 _key) external;
20     function deleteBool(bytes32 _key) external;
21     function deleteInt(bytes32 _key) external;
22 
23     // Getters
24     function getAddress(bytes32 _key) external view returns (address);
25     function getUint(bytes32 _key) external view returns (uint);
26     function getString(bytes32 _key) external view returns (string);
27     function getBytes(bytes32 _key) external view returns (bytes);
28     function getBool(bytes32 _key) external view returns (bool);
29     function getInt(bytes32 _key) external view returns (int);
30 }
31 
32 contract EthicHubBase {
33 
34     uint8 public version;
35 
36     EthicHubStorageInterface public ethicHubStorage = EthicHubStorageInterface(0);
37 
38     constructor(address _storageAddress) public {
39         require(_storageAddress != address(0));
40         ethicHubStorage = EthicHubStorageInterface(_storageAddress);
41     }
42 
43 }
44 
45 contract EthicHubReputationInterface {
46     modifier onlyUsersContract(){_;}
47     modifier onlyLendingContract(){_;}
48     function burnReputation(uint delayDays)  external;
49     function incrementReputation(uint completedProjectsByTier)  external;
50     function initLocalNodeReputation(address localNode)  external;
51     function initCommunityReputation(address community)  external;
52     function getCommunityReputation(address target) public view returns(uint256);
53     function getLocalNodeReputation(address target) public view returns(uint256);
54 }
55 
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipRenounced(address indexed previousOwner);
61   event OwnershipTransferred(
62     address indexed previousOwner,
63     address indexed newOwner
64   );
65 
66 
67   /**
68    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69    * account.
70    */
71   constructor() public {
72     owner = msg.sender;
73   }
74 
75   /**
76    * @dev Throws if called by any account other than the owner.
77    */
78   modifier onlyOwner() {
79     require(msg.sender == owner);
80     _;
81   }
82 
83   /**
84    * @dev Allows the current owner to relinquish control of the contract.
85    */
86   function renounceOwnership() public onlyOwner {
87     emit OwnershipRenounced(owner);
88     owner = address(0);
89   }
90 
91   /**
92    * @dev Allows the current owner to transfer control of the contract to a newOwner.
93    * @param _newOwner The address to transfer ownership to.
94    */
95   function transferOwnership(address _newOwner) public onlyOwner {
96     _transferOwnership(_newOwner);
97   }
98 
99   /**
100    * @dev Transfers control of the contract to a newOwner.
101    * @param _newOwner The address to transfer ownership to.
102    */
103   function _transferOwnership(address _newOwner) internal {
104     require(_newOwner != address(0));
105     emit OwnershipTransferred(owner, _newOwner);
106     owner = _newOwner;
107   }
108 }
109 
110 contract EthicHubUser is Ownable, EthicHubBase {
111 
112 
113     event UserStatusChanged(address target, string profile, bool isRegistered);
114 
115     constructor(address _storageAddress)
116         EthicHubBase(_storageAddress)
117         public
118     {
119         // Version
120         version = 4;
121     }
122 
123     /**
124      * @dev Changes registration status of an address for participation.
125      * @param target Address that will be registered/deregistered.
126      * @param profile profile of user.
127      * @param isRegistered New registration status of address.
128      */
129     function changeUserStatus(address target, string profile, bool isRegistered)
130         internal
131         onlyOwner
132     {
133         require(target != address(0));
134         require(bytes(profile).length != 0);
135         ethicHubStorage.setBool(keccak256(abi.encodePacked("user", profile, target)), isRegistered);
136         emit UserStatusChanged(target, profile, isRegistered);
137     }
138 
139 
140     /**
141      * @dev delete an address for participation.
142      * @param target Address that will be deleted.
143      * @param profile profile of user.
144      */
145     function deleteUserStatus(address target, string profile)
146         internal
147         onlyOwner
148     {
149         require(target != address(0));
150         require(bytes(profile).length != 0);
151         ethicHubStorage.deleteBool(keccak256(abi.encodePacked("user", profile, target)));
152         emit UserStatusChanged(target, profile, false);
153     }
154 
155 
156     /**
157      * @dev View registration status of an address for participation.
158      * @return isRegistered boolean registration status of address for a specific profile.
159      */
160     function viewRegistrationStatus(address target, string profile)
161         view public
162         returns(bool isRegistered)
163     {
164         require(target != address(0));
165         require(bytes(profile).length != 0);
166         isRegistered = ethicHubStorage.getBool(keccak256(abi.encodePacked("user", profile, target)));
167     }
168 
169     /**
170      * @dev register a localNode address.
171      */
172     function registerLocalNode(address target)
173         external
174         onlyOwner
175     {
176         require(target != address(0));
177         bool isRegistered = ethicHubStorage.getBool(keccak256(abi.encodePacked("user", "localNode", target)));
178         if (!isRegistered) {
179             changeUserStatus(target, "localNode", true);
180             EthicHubReputationInterface rep = EthicHubReputationInterface (ethicHubStorage.getAddress(keccak256(abi.encodePacked("contract.name", "reputation"))));
181             rep.initLocalNodeReputation(target);
182         }
183     }
184 
185     /**
186      * @dev unregister a localNode address.
187      */
188     function unregisterLocalNode(address target)
189         external
190         onlyOwner
191     {
192         require(target != address(0));
193         bool isRegistered = ethicHubStorage.getBool(keccak256(abi.encodePacked("user", "localNode", target)));
194         if (isRegistered) {
195             deleteUserStatus(target, "localNode");
196         }
197     }
198 
199     /**
200      * @dev register a community address.
201      */
202     function registerCommunity(address target)
203         external
204         onlyOwner
205     {
206         require(target != address(0));
207         bool isRegistered = ethicHubStorage.getBool(keccak256(abi.encodePacked("user", "community", target)));
208         if (!isRegistered) {
209             changeUserStatus(target, "community", true);
210             EthicHubReputationInterface rep = EthicHubReputationInterface(ethicHubStorage.getAddress(keccak256(abi.encodePacked("contract.name", "reputation"))));
211             rep.initCommunityReputation(target);
212         }
213     }
214 
215     /**
216      * @dev unregister a community address.
217      */
218     function unregisterCommunity(address target)
219         external
220         onlyOwner
221     {
222         require(target != address(0));
223         bool isRegistered = ethicHubStorage.getBool(keccak256(abi.encodePacked("user", "community", target)));
224         if (isRegistered) {
225             deleteUserStatus(target, "community");
226         }
227     }
228 
229 
230 
231     /**
232      * @dev register a invertor address.
233      */
234     function registerInvestor(address target)
235         external
236         onlyOwner
237     {
238         require(target != address(0));
239         changeUserStatus(target, "investor", true);
240     }
241 
242     /**
243      * @dev unregister a investor address.
244      */
245     function unregisterInvestor(address target)
246         external
247         onlyOwner
248     {
249         require(target != address(0));
250         bool isRegistered = ethicHubStorage.getBool(keccak256(abi.encodePacked("user", "investor", target)));
251         if (isRegistered) {
252             deleteUserStatus(target, "investor");
253         }
254     }
255 
256     /**
257      * @dev register a community representative address.
258      */
259     function registerRepresentative(address target)
260         external
261         onlyOwner
262     {
263         require(target != address(0));
264         changeUserStatus(target, "representative", true);
265     }
266 
267     /**
268      * @dev unregister a representative address.
269      */
270     function unregisterRepresentative(address target)
271         external
272         onlyOwner
273     {
274         require(target != address(0));
275         bool isRegistered = ethicHubStorage.getBool(keccak256(abi.encodePacked("user", "representative", target)));
276         if (isRegistered) {
277             deleteUserStatus(target, "representative");
278         }
279     }
280 
281     /**
282      * @dev register a paymentGateway address.
283      */
284     function registerPaymentGateway(address target)
285         external
286         onlyOwner
287     {
288         require(target != address(0));
289         changeUserStatus(target, "paymentGateway", true);
290     }
291 
292     /**
293      * @dev unregister a paymentGateway address.
294      */
295     function unregisterPaymentGateway(address target)
296         external
297         onlyOwner
298     {
299         require(target != address(0));
300         bool isRegistered = ethicHubStorage.getBool(keccak256(abi.encodePacked("user", "paymentGateway", target)));
301         if (isRegistered) {
302             deleteUserStatus(target, "paymentGateway");
303         }
304     }
305 
306 }