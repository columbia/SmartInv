1 pragma solidity ^0.4.19;
2 
3 // File: contracts/storage/interface/RocketStorageInterface.sol
4 
5 // Our eternal storage interface
6 contract RocketStorageInterface {
7     // Modifiers
8     modifier onlyLatestRocketNetworkContract() {_;}
9     // Getters
10     function getAddress(bytes32 _key) external view returns (address);
11     function getUint(bytes32 _key) external view returns (uint);
12     function getString(bytes32 _key) external view returns (string);
13     function getBytes(bytes32 _key) external view returns (bytes);
14     function getBool(bytes32 _key) external view returns (bool);
15     function getInt(bytes32 _key) external view returns (int);
16     // Setters
17     function setAddress(bytes32 _key, address _value) onlyLatestRocketNetworkContract external;
18     function setUint(bytes32 _key, uint _value) onlyLatestRocketNetworkContract external;
19     function setString(bytes32 _key, string _value) onlyLatestRocketNetworkContract external;
20     function setBytes(bytes32 _key, bytes _value) onlyLatestRocketNetworkContract external;
21     function setBool(bytes32 _key, bool _value) onlyLatestRocketNetworkContract external;
22     function setInt(bytes32 _key, int _value) onlyLatestRocketNetworkContract external;
23     // Deleters
24     function deleteAddress(bytes32 _key) onlyLatestRocketNetworkContract external;
25     function deleteUint(bytes32 _key) onlyLatestRocketNetworkContract external;
26     function deleteString(bytes32 _key) onlyLatestRocketNetworkContract external;
27     function deleteBytes(bytes32 _key) onlyLatestRocketNetworkContract external;
28     function deleteBool(bytes32 _key) onlyLatestRocketNetworkContract external;
29     function deleteInt(bytes32 _key) onlyLatestRocketNetworkContract external;
30     // Hash helpers
31     function kcck256str(string _key1) external pure returns (bytes32);
32     function kcck256strstr(string _key1, string _key2) external pure returns (bytes32);
33     function kcck256stradd(string _key1, address _key2) external pure returns (bytes32);
34     function kcck256straddadd(string _key1, address _key2, address _key3) external pure returns (bytes32);
35 }
36 
37 // File: contracts/storage/RocketBase.sol
38 
39 /// @title Base settings / modifiers for each contract in Rocket Pool
40 /// @author David Rugendyke
41 contract RocketBase {
42 
43     /*** Events ****************/
44 
45     event ContractAdded (
46         address indexed _newContractAddress,                    // Address of the new contract
47         uint256 created                                         // Creation timestamp
48     );
49 
50     event ContractUpgraded (
51         address indexed _oldContractAddress,                    // Address of the contract being upgraded
52         address indexed _newContractAddress,                    // Address of the new contract
53         uint256 created                                         // Creation timestamp
54     );
55 
56     /**** Properties ************/
57 
58     uint8 public version;                                                   // Version of this contract
59 
60 
61     /*** Contracts **************/
62 
63     RocketStorageInterface rocketStorage = RocketStorageInterface(0);       // The main storage contract where primary persistant storage is maintained
64 
65 
66     /*** Modifiers ************/
67 
68     /**
69     * @dev Throws if called by any account other than the owner.
70     */
71     modifier onlyOwner() {
72         roleCheck("owner", msg.sender);
73         _;
74     }
75 
76     /**
77     * @dev Modifier to scope access to admins
78     */
79     modifier onlyAdmin() {
80         roleCheck("admin", msg.sender);
81         _;
82     }
83 
84     /**
85     * @dev Modifier to scope access to admins
86     */
87     modifier onlySuperUser() {
88         require(roleHas("owner", msg.sender) || roleHas("admin", msg.sender));
89         _;
90     }
91 
92     /**
93     * @dev Reverts if the address doesn't have this role
94     */
95     modifier onlyRole(string _role) {
96         roleCheck(_role, msg.sender);
97         _;
98     }
99 
100   
101     /*** Constructor **********/
102    
103     /// @dev Set the main Rocket Storage address
104     constructor(address _rocketStorageAddress) public {
105         // Update the contract address
106         rocketStorage = RocketStorageInterface(_rocketStorageAddress);
107     }
108 
109 
110     /*** Role Utilities */
111 
112     /**
113     * @dev Check if an address is an owner
114     * @return bool
115     */
116     function isOwner(address _address) public view returns (bool) {
117         return rocketStorage.getBool(keccak256("access.role", "owner", _address));
118     }
119 
120     /**
121     * @dev Check if an address has this role
122     * @return bool
123     */
124     function roleHas(string _role, address _address) internal view returns (bool) {
125         return rocketStorage.getBool(keccak256("access.role", _role, _address));
126     }
127 
128      /**
129     * @dev Check if an address has this role, reverts if it doesn't
130     */
131     function roleCheck(string _role, address _address) view internal {
132         require(roleHas(_role, _address) == true);
133     }
134 
135 }
136 
137 // File: contracts/Upgradable.sol
138 
139 /// Based on Rocket Pool contracts by Davide Rugendyke
140 
141 /// @title Upgrades for network contracts
142 /// @author Steven Brendtro
143 contract Upgradable is RocketBase {
144 
145     /*** Events ****************/
146 
147     event ContractUpgraded (
148         address indexed _oldContractAddress,                    // Address of the contract being upgraded
149         address indexed _newContractAddress,                    // Address of the new contract
150         uint256 created                                         // Creation timestamp
151     );
152 
153 
154     /*** Constructor ***********/    
155 
156     /// @dev Upgrade constructor
157     constructor(address _rocketStorageAddress) RocketBase(_rocketStorageAddress) public {
158         // Set the version
159         version = 1;
160     }
161 
162     /**** Contract Upgrade Methods ***********/
163 
164     /**
165     * @dev Add a contract address to the contract storage, allowing it to access storage
166     * @param _name Name of the contract to add
167     * @param _newContractAddress Address of the contract to add
168     */
169     function addContract(string _name, address _newContractAddress) onlyOwner external {
170 
171         // Make sure the contract name isn't already in use.  If it is, upgradeContract() is the proper function to use
172         address existing_ = rocketStorage.getAddress(keccak256("contract.name", _name));
173         require(existing_ == 0x0);
174      
175         // Add the contract to the storage using a hash of the "contract.name" namespace and the name of the contract that was supplied as the 'key' and use the new contract address as the 'value'
176         // This means we can get the address of the contract later by looking it up using its name eg 'rocketUser'
177         rocketStorage.setAddress(keccak256("contract.name", _name), _newContractAddress);
178         // Add the contract to the storage using a hash of the "contract.address" namespace and the address of the contract that was supplied as the 'key' and use the new contract address as the 'value'
179         // This means we can verify this contract as belonging to the dApp by using it's address rather than its name.
180         // Handy when you need to protect certain methods from being accessed by any contracts that are not part of the dApp using msg.sender (see the modifier onlyLatestRocketNetworkContract() in the RocketStorage code)
181         rocketStorage.setAddress(keccak256("contract.address", _newContractAddress), _newContractAddress);
182         // Log it
183         emit ContractAdded(_newContractAddress, now);
184     }
185 
186     /// @param _name The name of an existing contract in the network
187     /// @param _upgradedContractAddress The new contracts address that will replace the current one
188     // TODO: Write unit tests to verify
189     function upgradeContract(string _name, address _upgradedContractAddress) onlyOwner external {
190         // Get the current contracts address
191         address oldContractAddress = rocketStorage.getAddress(keccak256("contract.name", _name));
192         // Check it exists
193         require(oldContractAddress != 0x0);
194         // Check it is not the contract's current address
195         require(oldContractAddress != _upgradedContractAddress);
196         // Replace the address for the name lookup - contract addresses can be looked up by their name or verified by a reverse address lookup
197         rocketStorage.setAddress(keccak256("contract.name", _name), _upgradedContractAddress);
198         // Add the new contract address for a direct verification using the address (used in RocketStorage to verify its a legit contract using only the msg.sender)
199         rocketStorage.setAddress(keccak256("contract.address", _upgradedContractAddress), _upgradedContractAddress);
200         // Remove the old contract address verification
201         rocketStorage.deleteAddress(keccak256("contract.address", oldContractAddress));
202         // Log it
203         emit ContractUpgraded(oldContractAddress, _upgradedContractAddress, now);
204     }
205 
206 }