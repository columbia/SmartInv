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
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipRenounced(address indexed previousOwner);
50   event OwnershipTransferred(
51     address indexed previousOwner,
52     address indexed newOwner
53   );
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   constructor() public {
61     owner = msg.sender;
62   }
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   /**
73    * @dev Allows the current owner to relinquish control of the contract.
74    */
75   function renounceOwnership() public onlyOwner {
76     emit OwnershipRenounced(owner);
77     owner = address(0);
78   }
79 
80   /**
81    * @dev Allows the current owner to transfer control of the contract to a newOwner.
82    * @param _newOwner The address to transfer ownership to.
83    */
84   function transferOwnership(address _newOwner) public onlyOwner {
85     _transferOwnership(_newOwner);
86   }
87 
88   /**
89    * @dev Transfers control of the contract to a newOwner.
90    * @param _newOwner The address to transfer ownership to.
91    */
92   function _transferOwnership(address _newOwner) internal {
93     require(_newOwner != address(0));
94     emit OwnershipTransferred(owner, _newOwner);
95     owner = _newOwner;
96   }
97 }
98 
99 contract EthicHubArbitrage is EthicHubBase, Ownable {
100 
101     event ArbiterAssigned (
102         address indexed _arbiter,                    // Address of the arbiter
103         address indexed _lendingContract            // Address of the lending contract
104     );
105 
106     event ArbiterRevoked (
107         address indexed _arbiter,                    // Address of the arbiter
108         address indexed _lendingContract            // Address of the lending contract
109     );
110 
111     constructor(address _storageAddress) EthicHubBase(_storageAddress) public {
112         // Version
113         version = 1;
114     }
115 
116     function assignArbiterForLendingContract(address _arbiter, address _lendingContract) public onlyOwner {
117         require(_arbiter != address(0));
118         require(_lendingContract != address(0));
119         require(_lendingContract == ethicHubStorage.getAddress(keccak256("contract.address", _lendingContract)));
120         ethicHubStorage.setAddress(keccak256("arbiter", _lendingContract), _arbiter);
121         emit ArbiterAssigned(_arbiter, _lendingContract);
122     }
123 
124     function revokeArbiterForLendingContract(address _arbiter, address _lendingContract) public onlyOwner {
125         require(_arbiter != address(0));
126         require(_lendingContract != address(0));
127         require(_lendingContract == ethicHubStorage.getAddress(keccak256("contract.address", _lendingContract)));
128         require(arbiterForLendingContract(_lendingContract) == _arbiter);
129         ethicHubStorage.deleteAddress(keccak256("arbiter", _lendingContract));
130         emit ArbiterRevoked(_arbiter, _lendingContract);
131     }
132 
133     function arbiterForLendingContract(address _lendingContract) public view returns(address) {
134         return ethicHubStorage.getAddress(keccak256("arbiter", _lendingContract));
135     }
136 
137 }