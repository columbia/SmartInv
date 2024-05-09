1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to relinquish control of the contract.
32    */
33   function renounceOwnership() public onlyOwner {
34     emit OwnershipRenounced(owner);
35     owner = address(0);
36   }
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param _newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address _newOwner) public onlyOwner {
43     _transferOwnership(_newOwner);
44   }
45 
46   /**
47    * @dev Transfers control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function _transferOwnership(address _newOwner) internal {
51     require(_newOwner != address(0));
52     emit OwnershipTransferred(owner, _newOwner);
53     owner = _newOwner;
54   }
55 }
56 
57 contract EthicHubBase {
58 
59     uint8 public version;
60 
61     EthicHubStorageInterface public ethicHubStorage = EthicHubStorageInterface(0);
62 
63     constructor(address _storageAddress) public {
64         require(_storageAddress != address(0));
65         ethicHubStorage = EthicHubStorageInterface(_storageAddress);
66     }
67 
68 }
69 
70 contract EthicHubReputationInterface {
71     modifier onlyUsersContract(){_;}
72     modifier onlyLendingContract(){_;}
73     function burnReputation(uint delayDays)  external;
74     function incrementReputation(uint completedProjectsByTier)  external;
75     function initLocalNodeReputation(address localNode)  external;
76     function initCommunityReputation(address community)  external;
77     function getCommunityReputation(address target) public view returns(uint256);
78     function getLocalNodeReputation(address target) public view returns(uint256);
79 }
80 
81 contract EthicHubUser is Ownable, EthicHubBase {
82 
83 
84     event UserStatusChanged(address target, string profile, bool isRegistered);
85 
86     constructor(address _storageAddress)
87         EthicHubBase(_storageAddress)
88         public
89     {
90         // Version
91         version = 3;
92     }
93 
94     /**
95      * @dev Changes registration status of an address for participation.
96      * @param target Address that will be registered/deregistered.
97      * @param profile profile of user.
98      * @param isRegistered New registration status of address.
99      */
100     function changeUserStatus(address target, string profile, bool isRegistered)
101         internal
102         onlyOwner
103     {
104         require(target != address(0));
105         require(bytes(profile).length != 0);
106         ethicHubStorage.setBool(keccak256("user", profile, target), isRegistered);
107         emit UserStatusChanged(target, profile, isRegistered);
108     }
109 
110 
111     /**
112      * @dev delete an address for participation.
113      * @param target Address that will be deleted.
114      * @param profile profile of user.
115      */
116     function deleteUserStatus(address target, string profile)
117         internal
118         onlyOwner
119     {
120         require(target != address(0));
121         require(bytes(profile).length != 0);
122         ethicHubStorage.deleteBool(keccak256("user", profile, target));
123         emit UserStatusChanged(target, profile, false);
124     }
125 
126 
127     /**
128      * @dev View registration status of an address for participation.
129      * @return isRegistered boolean registration status of address for a specific profile.
130      */
131     function viewRegistrationStatus(address target, string profile)
132         view public
133         returns(bool isRegistered)
134     {
135         require(target != address(0));
136         require(bytes(profile).length != 0);
137         isRegistered = ethicHubStorage.getBool(keccak256("user", profile, target));
138     }
139 
140     /**
141      * @dev register a localNode address.
142      */
143     function registerLocalNode(address target)
144         external
145         onlyOwner
146     {
147         require(target != address(0));
148         bool isRegistered = ethicHubStorage.getBool(keccak256("user", "localNode", target));
149         if (!isRegistered) {
150             changeUserStatus(target, "localNode", true);
151             EthicHubReputationInterface rep = EthicHubReputationInterface (ethicHubStorage.getAddress(keccak256("contract.name", "reputation")));
152             rep.initLocalNodeReputation(target);
153         }
154     }
155 
156     /**
157      * @dev unregister a localNode address.
158      */
159     function unregisterLocalNode(address target)
160         external
161         onlyOwner
162     {
163         require(target != address(0));
164         bool isRegistered = ethicHubStorage.getBool(keccak256("user", "localNode", target));
165         if (isRegistered) {
166             deleteUserStatus(target, "localNode");
167         }
168     }
169 
170     /**
171      * @dev register a community address.
172      */
173     function registerCommunity(address target)
174         external
175         onlyOwner
176     {
177         require(target != address(0));
178         bool isRegistered = ethicHubStorage.getBool(keccak256("user", "community", target));
179         if (!isRegistered) {
180             changeUserStatus(target, "community", true);
181             EthicHubReputationInterface rep = EthicHubReputationInterface(ethicHubStorage.getAddress(keccak256("contract.name", "reputation")));
182             rep.initCommunityReputation(target);
183         }
184     }
185 
186     /**
187      * @dev unregister a community address.
188      */
189     function unregisterCommunity(address target)
190         external
191         onlyOwner
192     {
193         require(target != address(0));
194         bool isRegistered = ethicHubStorage.getBool(keccak256("user", "community", target));
195         if (isRegistered) {
196             deleteUserStatus(target, "community");
197         }
198     }
199 
200 
201 
202     /**
203      * @dev register a invertor address.
204      */
205     function registerInvestor(address target)
206         external
207         onlyOwner
208     {
209         require(target != address(0));
210         changeUserStatus(target, "investor", true);
211     }
212 
213     /**
214      * @dev unregister a investor address.
215      */
216     function unregisterInvestor(address target)
217         external
218         onlyOwner
219     {
220         require(target != address(0));
221         bool isRegistered = ethicHubStorage.getBool(keccak256("user", "investor", target));
222         if (isRegistered) {
223             deleteUserStatus(target, "investor");
224         }
225     }
226 
227     /**
228      * @dev register a community representative address.
229      */
230     function registerRepresentative(address target)
231         external
232         onlyOwner
233     {
234         require(target != address(0));
235         changeUserStatus(target, "representative", true);
236     }
237 
238     /**
239      * @dev unregister a representative address.
240      */
241     function unregisterRepresentative(address target)
242         external
243         onlyOwner
244     {
245         require(target != address(0));
246         bool isRegistered = ethicHubStorage.getBool(keccak256("user", "representative", target));
247         if (isRegistered) {
248             deleteUserStatus(target, "representative");
249         }
250     }
251 
252     /**
253      * @dev register a paymentGateway address.
254      */
255     function registerPaymentGateway(address target)
256         external
257         onlyOwner
258     {
259         require(target != address(0));
260         changeUserStatus(target, "paymentGateway", true);
261     }
262 
263     /**
264      * @dev unregister a paymentGateway address.
265      */
266     function unregisterPaymentGateway(address target)
267         external
268         onlyOwner
269     {
270         require(target != address(0));
271         bool isRegistered = ethicHubStorage.getBool(keccak256("user", "paymentGateway", target));
272         if (isRegistered) {
273             deleteUserStatus(target, "paymentGateway");
274         }
275     }
276 
277 }
278 
279 contract EthicHubStorageInterface {
280 
281     //modifier for access in sets and deletes
282     modifier onlyEthicHubContracts() {_;}
283 
284     // Setters
285     function setAddress(bytes32 _key, address _value) external;
286     function setUint(bytes32 _key, uint _value) external;
287     function setString(bytes32 _key, string _value) external;
288     function setBytes(bytes32 _key, bytes _value) external;
289     function setBool(bytes32 _key, bool _value) external;
290     function setInt(bytes32 _key, int _value) external;
291     // Deleters
292     function deleteAddress(bytes32 _key) external;
293     function deleteUint(bytes32 _key) external;
294     function deleteString(bytes32 _key) external;
295     function deleteBytes(bytes32 _key) external;
296     function deleteBool(bytes32 _key) external;
297     function deleteInt(bytes32 _key) external;
298 
299     // Getters
300     function getAddress(bytes32 _key) external view returns (address);
301     function getUint(bytes32 _key) external view returns (uint);
302     function getString(bytes32 _key) external view returns (string);
303     function getBytes(bytes32 _key) external view returns (bytes);
304     function getBool(bytes32 _key) external view returns (bool);
305     function getInt(bytes32 _key) external view returns (int);
306 }