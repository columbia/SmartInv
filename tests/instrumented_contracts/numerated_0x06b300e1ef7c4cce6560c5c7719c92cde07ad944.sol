1 pragma solidity ^0.4.13;
2 
3 contract EthicHubBase {
4 
5     uint8 public version;
6 
7     EthicHubStorageInterface public ethicHubStorage = EthicHubStorageInterface(0);
8 
9     constructor(address _storageAddress) public {
10         require(_storageAddress != address(0));
11         ethicHubStorage = EthicHubStorageInterface(_storageAddress);
12     }
13 
14 }
15 
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipRenounced(address indexed previousOwner);
21   event OwnershipTransferred(
22     address indexed previousOwner,
23     address indexed newOwner
24   );
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   constructor() public {
32     owner = msg.sender;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   /**
44    * @dev Allows the current owner to relinquish control of the contract.
45    */
46   function renounceOwnership() public onlyOwner {
47     emit OwnershipRenounced(owner);
48     owner = address(0);
49   }
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address _newOwner) public onlyOwner {
56     _transferOwnership(_newOwner);
57   }
58 
59   /**
60    * @dev Transfers control of the contract to a newOwner.
61    * @param _newOwner The address to transfer ownership to.
62    */
63   function _transferOwnership(address _newOwner) internal {
64     require(_newOwner != address(0));
65     emit OwnershipTransferred(owner, _newOwner);
66     owner = _newOwner;
67   }
68 }
69 
70 contract EthicHubStorageInterface {
71 
72     //modifier for access in sets and deletes
73     modifier onlyEthicHubContracts() {_;}
74 
75     // Setters
76     function setAddress(bytes32 _key, address _value) external;
77     function setUint(bytes32 _key, uint _value) external;
78     function setString(bytes32 _key, string _value) external;
79     function setBytes(bytes32 _key, bytes _value) external;
80     function setBool(bytes32 _key, bool _value) external;
81     function setInt(bytes32 _key, int _value) external;
82     // Deleters
83     function deleteAddress(bytes32 _key) external;
84     function deleteUint(bytes32 _key) external;
85     function deleteString(bytes32 _key) external;
86     function deleteBytes(bytes32 _key) external;
87     function deleteBool(bytes32 _key) external;
88     function deleteInt(bytes32 _key) external;
89 
90     // Getters
91     function getAddress(bytes32 _key) external view returns (address);
92     function getUint(bytes32 _key) external view returns (uint);
93     function getString(bytes32 _key) external view returns (string);
94     function getBytes(bytes32 _key) external view returns (bytes);
95     function getBool(bytes32 _key) external view returns (bool);
96     function getInt(bytes32 _key) external view returns (int);
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
107     modifier onlyOwnerOrLocalNode() {
108         bool isLocalNode = ethicHubStorage.getBool(keccak256("user", "localNode", msg.sender));
109         require(isLocalNode || owner == msg.sender);
110         _;
111     }
112 
113     constructor(address _storageAddress) EthicHubBase(_storageAddress) public {
114         // Version
115         version = 1;
116     }
117 
118     function addNewLendingContract(address _lendingAddress) public onlyOwnerOrLocalNode {
119         require(_lendingAddress != address(0));
120         ethicHubStorage.setAddress(keccak256("contract.address", _lendingAddress), _lendingAddress);
121     }
122 
123     function upgradeContract(address _newContractAddress, string _contractName) public onlyOwner {
124         require(_newContractAddress != address(0));
125         require(keccak256("contract.name","") != keccak256("contract.name",_contractName));
126         address oldAddress = ethicHubStorage.getAddress(keccak256("contract.name", _contractName));
127         ethicHubStorage.setAddress(keccak256("contract.address", _newContractAddress), _newContractAddress);
128         ethicHubStorage.setAddress(keccak256("contract.name", _contractName), _newContractAddress);
129         ethicHubStorage.deleteAddress(keccak256("contract.address", oldAddress));
130         emit ContractUpgraded(oldAddress, _newContractAddress, now);
131     }
132     
133 }