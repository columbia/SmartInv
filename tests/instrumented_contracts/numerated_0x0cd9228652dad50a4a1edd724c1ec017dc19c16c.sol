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
57 contract EthicHubStorageInterface {
58 
59     //modifier for access in sets and deletes
60     modifier onlyEthicHubContracts() {_;}
61 
62     // Setters
63     function setAddress(bytes32 _key, address _value) external;
64     function setUint(bytes32 _key, uint _value) external;
65     function setString(bytes32 _key, string _value) external;
66     function setBytes(bytes32 _key, bytes _value) external;
67     function setBool(bytes32 _key, bool _value) external;
68     function setInt(bytes32 _key, int _value) external;
69     // Deleters
70     function deleteAddress(bytes32 _key) external;
71     function deleteUint(bytes32 _key) external;
72     function deleteString(bytes32 _key) external;
73     function deleteBytes(bytes32 _key) external;
74     function deleteBool(bytes32 _key) external;
75     function deleteInt(bytes32 _key) external;
76 
77     // Getters
78     function getAddress(bytes32 _key) external view returns (address);
79     function getUint(bytes32 _key) external view returns (uint);
80     function getString(bytes32 _key) external view returns (string);
81     function getBytes(bytes32 _key) external view returns (bytes);
82     function getBool(bytes32 _key) external view returns (bool);
83     function getInt(bytes32 _key) external view returns (int);
84 }
85 
86 contract EthicHubReputationInterface {
87     modifier onlyUsersContract(){_;}
88     modifier onlyLendingContract(){_;}
89     function burnReputation(uint delayDays)  external;
90     function incrementReputation(uint completedProjectsByTier)  external;
91     function initLocalNodeReputation(address localNode)  external;
92     function initCommunityReputation(address community)  external;
93     function getCommunityReputation(address target) public view returns(uint256);
94     function getLocalNodeReputation(address target) public view returns(uint256);
95 }
96 
97 contract EthicHubBase {
98 
99     uint8 public version;
100 
101     EthicHubStorageInterface public ethicHubStorage = EthicHubStorageInterface(0);
102 
103     constructor(address _storageAddress) public {
104         require(_storageAddress != address(0));
105         ethicHubStorage = EthicHubStorageInterface(_storageAddress);
106     }
107 
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
120         version = 2;
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
135         ethicHubStorage.setBool(keccak256("user", profile, target), isRegistered);
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
151         ethicHubStorage.deleteBool(keccak256("user", profile, target));
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
166         isRegistered = ethicHubStorage.getBool(keccak256("user", profile, target));
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
177         bool isRegistered = ethicHubStorage.getBool(keccak256("user", "localNode", target));
178         if (!isRegistered) {
179             changeUserStatus(target, "localNode", true);
180             EthicHubReputationInterface rep = EthicHubReputationInterface (ethicHubStorage.getAddress(keccak256("contract.name", "reputation")));
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
193         bool isRegistered = ethicHubStorage.getBool(keccak256("user", "localNode", target));
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
207         bool isRegistered = ethicHubStorage.getBool(keccak256("user", "community", target));
208         if (!isRegistered) {
209             changeUserStatus(target, "community", true);
210             EthicHubReputationInterface rep = EthicHubReputationInterface(ethicHubStorage.getAddress(keccak256("contract.name", "reputation")));
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
223         bool isRegistered = ethicHubStorage.getBool(keccak256("user", "community", target));
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
250         bool isRegistered = ethicHubStorage.getBool(keccak256("user", "investor", target));
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
275         bool isRegistered = ethicHubStorage.getBool(keccak256("user", "representative", target));
276         if (isRegistered) {
277             deleteUserStatus(target, "representative");
278         }
279     }
280 
281 
282 }