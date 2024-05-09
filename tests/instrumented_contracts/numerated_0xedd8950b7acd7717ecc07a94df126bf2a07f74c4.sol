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
57 contract EthicHubReputationInterface {
58     modifier onlyUsersContract(){_;}
59     modifier onlyLendingContract(){_;}
60     function burnReputation(uint delayDays)  external;
61     function incrementReputation(uint completedProjectsByTier)  external;
62     function initLocalNodeReputation(address localNode)  external;
63     function initCommunityReputation(address community)  external;
64     function getCommunityReputation(address target) public view returns(uint256);
65     function getLocalNodeReputation(address target) public view returns(uint256);
66 }
67 
68 contract EthicHubStorageInterface {
69 
70     //modifier for access in sets and deletes
71     modifier onlyEthicHubContracts() {_;}
72 
73     // Setters
74     function setAddress(bytes32 _key, address _value) external;
75     function setUint(bytes32 _key, uint _value) external;
76     function setString(bytes32 _key, string _value) external;
77     function setBytes(bytes32 _key, bytes _value) external;
78     function setBool(bytes32 _key, bool _value) external;
79     function setInt(bytes32 _key, int _value) external;
80     // Deleters
81     function deleteAddress(bytes32 _key) external;
82     function deleteUint(bytes32 _key) external;
83     function deleteString(bytes32 _key) external;
84     function deleteBytes(bytes32 _key) external;
85     function deleteBool(bytes32 _key) external;
86     function deleteInt(bytes32 _key) external;
87 
88     // Getters
89     function getAddress(bytes32 _key) external view returns (address);
90     function getUint(bytes32 _key) external view returns (uint);
91     function getString(bytes32 _key) external view returns (string);
92     function getBytes(bytes32 _key) external view returns (bytes);
93     function getBool(bytes32 _key) external view returns (bool);
94     function getInt(bytes32 _key) external view returns (int);
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
120         version = 1;
121     }
122 
123     /**
124      * @dev Changes registration status of an address for participation.
125      * @param target Address that will be registered/deregistered.
126      * @param profile profile of user.
127      * @param isRegistered New registration status of address.
128      */
129     function changeUserStatus(address target, string profile, bool isRegistered)
130         public
131         onlyOwner
132     {
133         require(target != address(0));
134         require(bytes(profile).length != 0);
135         ethicHubStorage.setBool(keccak256("user", profile, target), isRegistered);
136         emit UserStatusChanged(target, profile, isRegistered);
137     }
138 
139     /**
140      * @dev Changes registration statuses of addresses for participation.
141      * @param targets Addresses that will be registered/deregistered.
142      * @param profile profile of user.
143      * @param isRegistered New registration status of addresses.
144      */
145     function changeUsersStatus(address[] targets, string profile, bool isRegistered)
146         external
147         onlyOwner
148     {
149         require(targets.length > 0);
150         require(bytes(profile).length != 0);
151         for (uint i = 0; i < targets.length; i++) {
152             changeUserStatus(targets[i], profile, isRegistered);
153         }
154     }
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
179             ethicHubStorage.setBool(keccak256("user", "localNode", target), true);
180             EthicHubReputationInterface rep = EthicHubReputationInterface (ethicHubStorage.getAddress(keccak256("contract.name", "reputation")));
181             rep.initLocalNodeReputation(target);
182         }
183     }
184 
185     /**
186      * @dev register a community address.
187      */
188     function registerCommunity(address target)
189         external
190         onlyOwner
191     {
192         require(target != address(0));
193         bool isRegistered = ethicHubStorage.getBool(keccak256("user", "community", target));
194         if (!isRegistered) {
195             ethicHubStorage.setBool(keccak256("user", "community", target), true);
196             EthicHubReputationInterface rep = EthicHubReputationInterface(ethicHubStorage.getAddress(keccak256("contract.name", "reputation")));
197             rep.initCommunityReputation(target);
198         }
199     }
200 
201     /**
202      * @dev register a invertor address.
203      */
204     function registerInvestor(address target)
205         external
206         onlyOwner
207     {
208         require(target != address(0));
209         ethicHubStorage.setBool(keccak256("user", "investor", target), true);
210     }
211 
212     /**
213      * @dev register a community representative address.
214      */
215     function registerRepresentative(address target)
216         external
217         onlyOwner
218     {
219         require(target != address(0));
220         ethicHubStorage.setBool(keccak256("user", "representative", target), true);
221     }
222 
223 
224 }