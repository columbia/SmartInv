1 pragma solidity ^0.4.24;
2 
3 // File: contracts/AraProxy.sol
4 
5 /**
6  * @title AraProxy
7  * @dev Gives the possibility to delegate any call to a foreign implementation.
8  */
9 contract AraProxy {
10 
11   bytes32 private constant registryPosition_ = keccak256("io.ara.proxy.registry");
12   bytes32 private constant implementationPosition_ = keccak256("io.ara.proxy.implementation");
13 
14   modifier restricted() {
15     bytes32 registryPosition = registryPosition_;
16     address registryAddress;
17     assembly {
18       registryAddress := sload(registryPosition)
19     }
20     require(
21       msg.sender == registryAddress,
22       "Only the AraRegistry can upgrade this proxy."
23     );
24     _;
25   }
26 
27   /**
28   * @dev the constructor sets the AraRegistry address
29   */
30   constructor(address _registryAddress, address _implementationAddress) public {
31     bytes32 registryPosition = registryPosition_;
32     bytes32 implementationPosition = implementationPosition_;
33     assembly {
34       sstore(registryPosition, _registryAddress)
35       sstore(implementationPosition, _implementationAddress)
36     }
37   }
38 
39   function setImplementation(address _newImplementation) public restricted {
40     require(_newImplementation != address(0));
41     bytes32 implementationPosition = implementationPosition_;
42     assembly {
43       sstore(implementationPosition, _newImplementation)
44     }
45   }
46 
47   /**
48   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
49   * This function will return whatever the implementation call returns
50   */
51   function () payable public {
52     bytes32 implementationPosition = implementationPosition_;
53     address _impl;
54     assembly {
55       _impl := sload(implementationPosition)
56     }
57 
58     assembly {
59       let ptr := mload(0x40)
60       calldatacopy(ptr, 0, calldatasize)
61       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
62       let size := returndatasize
63       returndatacopy(ptr, 0, size)
64 
65       switch result
66       case 0 { revert(ptr, size) }
67       default { return(ptr, size) }
68     }
69   }
70 }
71 
72 // File: contracts/AraRegistry.sol
73 
74 contract AraRegistry {
75   address public owner_;
76   mapping (bytes32 => UpgradeableContract) private contracts_; // keccak256(contractname) => struct
77 
78   struct UpgradeableContract {
79     bool initialized_;
80 
81     address proxy_;
82     string latestVersion_;
83     mapping (string => address) versions_;
84   }
85 
86   event UpgradeableContractAdded(bytes32 _contractName, string _version, address _address);
87   event ContractUpgraded(bytes32 _contractName, string _version, address _address);
88   event ProxyDeployed(bytes32 _contractName, address _address);
89 
90   constructor() public {
91     owner_ = msg.sender;
92   }
93 
94   modifier restricted() {
95     require (
96       msg.sender == owner_,
97       "Sender not authorized."
98     );
99     _;
100   }
101 
102   function getLatestVersionAddress(bytes32 _contractName) public view returns (address) {
103     return contracts_[_contractName].versions_[contracts_[_contractName].latestVersion_];
104   }
105 
106   function getUpgradeableContractAddress(bytes32 _contractName, string _version) public view returns (address) {
107     return contracts_[_contractName].versions_[_version];
108   }
109 
110   function addNewUpgradeableContract(bytes32 _contractName, string _version, bytes _code, bytes _data) public restricted {
111     require(!contracts_[_contractName].initialized_, "Upgradeable contract already exists. Try upgrading instead.");
112     address deployedAddress;
113     assembly {
114       deployedAddress := create(0, add(_code, 0x20), mload(_code))
115     }
116 
117     contracts_[_contractName].initialized_ = true;
118     contracts_[_contractName].latestVersion_ = _version;
119     contracts_[_contractName].versions_[_version] = deployedAddress;
120     _deployProxy(_contractName, deployedAddress, _data);
121 
122     emit UpgradeableContractAdded(_contractName, _version, deployedAddress);
123   }
124 
125   function upgradeContract(bytes32 _contractName, string _version, bytes _code) public restricted {
126     require(contracts_[_contractName].initialized_, "Upgradeable contract must exist before it can be upgraded. Try adding one instead.");
127     address deployedAddress;
128     assembly {
129       deployedAddress := create(0, add(_code, 0x20), mload(_code))
130     }
131 
132     AraProxy proxy = AraProxy(contracts_[_contractName].proxy_);
133     proxy.setImplementation(deployedAddress);
134 
135     contracts_[_contractName].latestVersion_ = _version;
136     contracts_[_contractName].versions_[_version] = deployedAddress;
137 
138     emit ContractUpgraded(_contractName, _version, deployedAddress);
139   }
140 
141   function _deployProxy(bytes32 _contractName, address _implementationAddress, bytes _data) private {
142     require(contracts_[_contractName].proxy_ == address(0), "Only one proxy can exist per upgradeable contract.");
143     AraProxy proxy = new AraProxy(address(this), _implementationAddress);
144     require(address(proxy).call(abi.encodeWithSignature("init(bytes)", _data)), "Init failed.");
145     contracts_[_contractName].proxy_ = proxy;
146 
147     emit ProxyDeployed(_contractName, proxy);
148   }
149 }