1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: node_modules/zos-lib/contracts/application/Package.sol
68 
69 /**
70  * @title Package
71  * @dev A package is composed by a set of versions, identified via semantic versioning,
72  * where each version has a contract address that refers to a reusable implementation,
73  * plus an optional content URI with metadata. Note that the semver identifier is restricted
74  * to major, minor, and patch, as prerelease tags are not supported.
75  */
76 contract Package is Ownable {
77   /**
78    * @dev Emitted when a version is added to the package.
79    * @param semanticVersion Name of the added version.
80    * @param contractAddress Contract associated with the version.
81    * @param contentURI Optional content URI with metadata of the version.
82    */
83   event VersionAdded(uint64[3] semanticVersion, address contractAddress, bytes contentURI);
84 
85   struct Version {
86     uint64[3] semanticVersion;
87     address contractAddress;
88     bytes contentURI; 
89   }
90 
91   mapping (bytes32 => Version) internal versions;
92   mapping (uint64 => bytes32) internal majorToLatestVersion;
93   uint64 internal latestMajor;
94 
95   /**
96    * @dev Returns a version given its semver identifier.
97    * @param semanticVersion Semver identifier of the version.
98    * @return Contract address and content URI for the version, or zero if not exists.
99    */
100   function getVersion(uint64[3] semanticVersion) public view returns (address contractAddress, bytes contentURI) {
101     Version storage version = versions[semanticVersionHash(semanticVersion)];
102     return (version.contractAddress, version.contentURI); 
103   }
104 
105   /**
106    * @dev Returns a contract for a version given its semver identifier.
107    * This method is equivalent to `getVersion`, but returns only the contract address.
108    * @param semanticVersion Semver identifier of the version.
109    * @return Contract address for the version, or zero if not exists.
110    */
111   function getContract(uint64[3] semanticVersion) public view returns (address contractAddress) {
112     Version storage version = versions[semanticVersionHash(semanticVersion)];
113     return version.contractAddress;
114   }
115 
116   /**
117    * @dev Adds a new version to the package. Only the Owner can add new versions.
118    * Reverts if the specified semver identifier already exists. 
119    * Emits a `VersionAdded` event if successful.
120    * @param semanticVersion Semver identifier of the version.
121    * @param contractAddress Contract address for the version, must be non-zero.
122    * @param contentURI Optional content URI for the version.
123    */
124   function addVersion(uint64[3] semanticVersion, address contractAddress, bytes contentURI) public onlyOwner {
125     require(contractAddress != address(0), "Contract address is required");
126     require(!hasVersion(semanticVersion), "Given version is already registered in package");
127     require(!semanticVersionIsZero(semanticVersion), "Version must be non zero");
128 
129     // Register version
130     bytes32 versionId = semanticVersionHash(semanticVersion);
131     versions[versionId] = Version(semanticVersion, contractAddress, contentURI);
132     
133     // Update latest major
134     uint64 major = semanticVersion[0];
135     if (major > latestMajor) {
136       latestMajor = semanticVersion[0];
137     }
138 
139     // Update latest version for this major
140     uint64 minor = semanticVersion[1];
141     uint64 patch = semanticVersion[2];
142     uint64[3] latestVersionForMajor = versions[majorToLatestVersion[major]].semanticVersion;
143     if (semanticVersionIsZero(latestVersionForMajor) // No latest was set for this major
144        || (minor > latestVersionForMajor[1]) // Or current minor is greater 
145        || (minor == latestVersionForMajor[1] && patch > latestVersionForMajor[2]) // Or current patch is greater
146        ) { 
147       majorToLatestVersion[major] = versionId;
148     }
149 
150     emit VersionAdded(semanticVersion, contractAddress, contentURI);
151   }
152 
153   /**
154    * @dev Checks whether a version is present in the package.
155    * @param semanticVersion Semver identifier of the version.
156    * @return true if the version is registered in this package, false otherwise.
157    */
158   function hasVersion(uint64[3] semanticVersion) public view returns (bool) {
159     Version storage version = versions[semanticVersionHash(semanticVersion)];
160     return address(version.contractAddress) != address(0);
161   }
162 
163   /**
164    * @dev Returns the version with the highest semver identifier registered in the package.
165    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will always return `2.0.0`, regardless 
166    * of the order in which they were registered. Returns zero if no versions are registered.
167    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
168    */
169   function getLatest() public view returns (uint64[3] semanticVersion, address contractAddress, bytes contentURI) {
170     return getLatestByMajor(latestMajor);
171   }
172 
173   /**
174    * @dev Returns the version with the highest semver identifier for the given major.
175    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will return `1.3.0` for major `1`, 
176    * regardless of the order in which they were registered. Returns zero if no versions are registered
177    * for the specified major.
178    * @param major Major identifier to query
179    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
180    */
181   function getLatestByMajor(uint64 major) public view returns (uint64[3] semanticVersion, address contractAddress, bytes contentURI) {
182     Version storage version = versions[majorToLatestVersion[major]];
183     return (version.semanticVersion, version.contractAddress, version.contentURI); 
184   }
185 
186   function semanticVersionHash(uint64[3] version) internal pure returns (bytes32) {
187     return keccak256(abi.encodePacked(version[0], version[1], version[2]));
188   }
189 
190   function semanticVersionIsZero(uint64[3] version) internal pure returns (bool) {
191     return version[0] == 0 && version[1] == 0 && version[2] == 0;
192   }
193 }