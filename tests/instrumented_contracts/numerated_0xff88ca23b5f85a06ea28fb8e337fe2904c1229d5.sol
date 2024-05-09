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
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipRenounced(address indexed previousOwner);
37   event OwnershipTransferred(
38     address indexed previousOwner,
39     address indexed newOwner
40   );
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   constructor() public {
48     owner = msg.sender;
49   }
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   /**
60    * @dev Allows the current owner to relinquish control of the contract.
61    */
62   function renounceOwnership() public onlyOwner {
63     emit OwnershipRenounced(owner);
64     owner = address(0);
65   }
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param _newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address _newOwner) public onlyOwner {
72     _transferOwnership(_newOwner);
73   }
74 
75   /**
76    * @dev Transfers control of the contract to a newOwner.
77    * @param _newOwner The address to transfer ownership to.
78    */
79   function _transferOwnership(address _newOwner) internal {
80     require(_newOwner != address(0));
81     emit OwnershipTransferred(owner, _newOwner);
82     owner = _newOwner;
83   }
84 }
85 
86 contract EthicHubBase {
87 
88     uint8 public version;
89 
90     EthicHubStorageInterface public ethicHubStorage = EthicHubStorageInterface(0);
91 
92     constructor(address _storageAddress) public {
93         require(_storageAddress != address(0));
94         ethicHubStorage = EthicHubStorageInterface(_storageAddress);
95     }
96 
97 }
98 
99 contract EthicHubCMC is EthicHubBase, Ownable {
100 
101     event ContractUpgraded (
102         address indexed _oldContractAddress,                    // Address of the contract being upgraded
103         address indexed _newContractAddress,                    // Address of the new contract
104         uint256 created                                         // Creation timestamp
105     );
106 
107     event ContractRemoved (
108         address indexed _contractAddress,                       // Address of the contract being removed
109         uint256 removed                                         // Remove timestamp
110     );
111 
112     event LendingContractAdded (
113         address indexed _newContractAddress,                    // Address of the new contract
114         uint256 created                                         // Creation timestamp
115     );
116 
117 
118     modifier onlyOwnerOrLocalNode() {
119         bool isLocalNode = ethicHubStorage.getBool(keccak256(abi.encodePacked("user", "localNode", msg.sender)));
120         require(isLocalNode || owner == msg.sender);
121         _;
122     }
123 
124     constructor(address _storageAddress) EthicHubBase(_storageAddress) public {
125         // Version
126         version = 4;
127     }
128 
129     function addNewLendingContract(address _lendingAddress) public onlyOwnerOrLocalNode {
130         require(_lendingAddress != address(0));
131         ethicHubStorage.setAddress(keccak256(abi.encodePacked("contract.address", _lendingAddress)), _lendingAddress);
132         emit LendingContractAdded(_lendingAddress, now);
133     }
134 
135     function upgradeContract(address _newContractAddress, string _contractName) public onlyOwner {
136         require(_newContractAddress != address(0));
137         require(keccak256(abi.encodePacked("contract.name","")) != keccak256(abi.encodePacked("contract.name",_contractName)));
138         address oldAddress = ethicHubStorage.getAddress(keccak256(abi.encodePacked("contract.name", _contractName)));
139         ethicHubStorage.setAddress(keccak256(abi.encodePacked("contract.address", _newContractAddress)), _newContractAddress);
140         ethicHubStorage.setAddress(keccak256(abi.encodePacked("contract.name", _contractName)), _newContractAddress);
141         ethicHubStorage.deleteAddress(keccak256(abi.encodePacked("contract.address", oldAddress)));
142         emit ContractUpgraded(oldAddress, _newContractAddress, now);
143     }
144 
145     function removeContract(address _contractAddress, string _contractName) public onlyOwner {
146         require(_contractAddress != address(0));
147         address contractAddress = ethicHubStorage.getAddress(keccak256(abi.encodePacked("contract.name", _contractName)));
148         require(_contractAddress == contractAddress);
149         ethicHubStorage.deleteAddress(keccak256(abi.encodePacked("contract.address", _contractAddress)));
150         ethicHubStorage.deleteAddress(keccak256(abi.encodePacked("contract.name", _contractName)));
151         emit ContractRemoved(_contractAddress, now);
152     }
153 }