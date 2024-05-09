1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/zos-lib/contracts/application/versioning/ImplementationProvider.sol
4 
5 /**
6  * @title ImplementationProvider
7  * @dev Interface for providing implementation addresses for other contracts by name.
8  */
9 interface ImplementationProvider {
10   /**
11    * @dev Abstract function to return the implementation address of a contract.
12    * @param contractName Name of the contract.
13    * @return Implementation address of the contract.
14    */
15   function getImplementation(string contractName) public view returns (address);
16 }
17 
18 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
19 
20 /**
21  * @title Ownable
22  * @dev The Ownable contract has an owner address, and provides basic authorization control
23  * functions, this simplifies the implementation of "user permissions".
24  */
25 contract Ownable {
26   address public owner;
27 
28 
29   event OwnershipRenounced(address indexed previousOwner);
30   event OwnershipTransferred(
31     address indexed previousOwner,
32     address indexed newOwner
33   );
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   constructor() public {
41     owner = msg.sender;
42   }
43 
44   /**
45    * @dev Throws if called by any account other than the owner.
46    */
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   /**
53    * @dev Allows the current owner to relinquish control of the contract.
54    * @notice Renouncing to ownership will leave the contract without an owner.
55    * It will not be possible to call the functions with the `onlyOwner`
56    * modifier anymore.
57    */
58   function renounceOwnership() public onlyOwner {
59     emit OwnershipRenounced(owner);
60     owner = address(0);
61   }
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param _newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address _newOwner) public onlyOwner {
68     _transferOwnership(_newOwner);
69   }
70 
71   /**
72    * @dev Transfers control of the contract to a newOwner.
73    * @param _newOwner The address to transfer ownership to.
74    */
75   function _transferOwnership(address _newOwner) internal {
76     require(_newOwner != address(0));
77     emit OwnershipTransferred(owner, _newOwner);
78     owner = _newOwner;
79   }
80 }
81 
82 // File: node_modules/zos-lib/contracts/application/versioning/Package.sol
83 
84 /**
85  * @title Package
86  * @dev Collection of contracts grouped into versions.
87  * Contracts with the same name can have different implementation addresses in different versions.
88  */
89 contract Package is Ownable {
90   /**
91    * @dev Emitted when a version is added to the package.
92    * XXX The version is not indexed due to truffle testing constraints.
93    * @param version Name of the added version.
94    * @param provider ImplementationProvider associated with the version.
95    */
96   event VersionAdded(string version, ImplementationProvider provider);
97 
98   /*
99    * @dev Mapping associating versions and their implementation providers.
100    */
101   mapping (string => ImplementationProvider) internal versions;
102 
103   /**
104    * @dev Returns the implementation provider of a version.
105    * @param version Name of the version.
106    * @return The implementation provider of the version.
107    */
108   function getVersion(string version) public view returns (ImplementationProvider) {
109     ImplementationProvider provider = versions[version];
110     return provider;
111   }
112 
113   /**
114    * @dev Adds the implementation provider of a new version to the package.
115    * @param version Name of the version.
116    * @param provider ImplementationProvider associated with the version.
117    */
118   function addVersion(string version, ImplementationProvider provider) public onlyOwner {
119     require(!hasVersion(version), "Given version is already registered in package");
120     versions[version] = provider;
121     emit VersionAdded(version, provider);
122   }
123 
124   /**
125    * @dev Checks whether a version is present in the package.
126    * @param version Name of the version.
127    * @return true if the version is already in the package, false otherwise.
128    */
129   function hasVersion(string version) public view returns (bool) {
130     return address(versions[version]) != address(0);
131   }
132 
133   /**
134    * @dev Returns the implementation address for a given version and contract name.
135    * @param version Name of the version.
136    * @param contractName Name of the contract.
137    * @return Address where the contract is implemented.
138    */
139   function getImplementation(string version, string contractName) public view returns (address) {
140     ImplementationProvider provider = getVersion(version);
141     return provider.getImplementation(contractName);
142   }
143 }