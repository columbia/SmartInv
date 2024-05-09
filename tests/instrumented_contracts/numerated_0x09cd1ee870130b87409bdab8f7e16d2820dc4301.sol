1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.23;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 // File: contracts/application/Package.sol
66 
67 pragma solidity ^0.4.24;
68 
69 
70 /**
71  * @title Package
72  * @dev A package is composed by a set of versions, identified via semantic versioning,
73  * where each version has a contract address that refers to a reusable implementation,
74  * plus an optional content URI with metadata. Note that the semver identifier is restricted
75  * to major, minor, and patch, as prerelease tags are not supported.
76  */
77 contract Package is Ownable {
78   /**
79    * @dev Emitted when a version is added to the package.
80    * @param semanticVersion Name of the added version.
81    * @param contractAddress Contract associated with the version.
82    * @param contentURI Optional content URI with metadata of the version.
83    */
84   event VersionAdded(uint64[3] semanticVersion, address contractAddress, bytes contentURI);
85 
86   struct Version {
87     uint64[3] semanticVersion;
88     address contractAddress;
89     bytes contentURI; 
90   }
91 
92   mapping (bytes32 => Version) internal versions;
93   mapping (uint64 => bytes32) internal majorToLatestVersion;
94   uint64 internal latestMajor;
95 
96   /**
97    * @dev Returns a version given its semver identifier.
98    * @param semanticVersion Semver identifier of the version.
99    * @return Contract address and content URI for the version, or zero if not exists.
100    */
101   function getVersion(uint64[3] semanticVersion) public view returns (address contractAddress, bytes contentURI) {
102     Version storage version = versions[semanticVersionHash(semanticVersion)];
103     return (version.contractAddress, version.contentURI); 
104   }
105 
106   /**
107    * @dev Returns a contract for a version given its semver identifier.
108    * This method is equivalent to `getVersion`, but returns only the contract address.
109    * @param semanticVersion Semver identifier of the version.
110    * @return Contract address for the version, or zero if not exists.
111    */
112   function getContract(uint64[3] semanticVersion) public view returns (address contractAddress) {
113     Version storage version = versions[semanticVersionHash(semanticVersion)];
114     return version.contractAddress;
115   }
116 
117   /**
118    * @dev Adds a new version to the package. Only the Owner can add new versions.
119    * Reverts if the specified semver identifier already exists. 
120    * Emits a `VersionAdded` event if successful.
121    * @param semanticVersion Semver identifier of the version.
122    * @param contractAddress Contract address for the version, must be non-zero.
123    * @param contentURI Optional content URI for the version.
124    */
125   function addVersion(uint64[3] semanticVersion, address contractAddress, bytes contentURI) public onlyOwner {
126     require(contractAddress != address(0), "Contract address is required");
127     require(!hasVersion(semanticVersion), "Given version is already registered in package");
128     require(!semanticVersionIsZero(semanticVersion), "Version must be non zero");
129 
130     // Register version
131     bytes32 versionId = semanticVersionHash(semanticVersion);
132     versions[versionId] = Version(semanticVersion, contractAddress, contentURI);
133     
134     // Update latest major
135     uint64 major = semanticVersion[0];
136     if (major > latestMajor) {
137       latestMajor = semanticVersion[0];
138     }
139 
140     // Update latest version for this major
141     uint64 minor = semanticVersion[1];
142     uint64 patch = semanticVersion[2];
143     uint64[3] latestVersionForMajor = versions[majorToLatestVersion[major]].semanticVersion;
144     if (semanticVersionIsZero(latestVersionForMajor) // No latest was set for this major
145        || (minor > latestVersionForMajor[1]) // Or current minor is greater 
146        || (minor == latestVersionForMajor[1] && patch > latestVersionForMajor[2]) // Or current patch is greater
147        ) { 
148       majorToLatestVersion[major] = versionId;
149     }
150 
151     emit VersionAdded(semanticVersion, contractAddress, contentURI);
152   }
153 
154   /**
155    * @dev Checks whether a version is present in the package.
156    * @param semanticVersion Semver identifier of the version.
157    * @return true if the version is registered in this package, false otherwise.
158    */
159   function hasVersion(uint64[3] semanticVersion) public view returns (bool) {
160     Version storage version = versions[semanticVersionHash(semanticVersion)];
161     return address(version.contractAddress) != address(0);
162   }
163 
164   /**
165    * @dev Returns the version with the highest semver identifier registered in the package.
166    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will always return `2.0.0`, regardless 
167    * of the order in which they were registered. Returns zero if no versions are registered.
168    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
169    */
170   function getLatest() public view returns (uint64[3] semanticVersion, address contractAddress, bytes contentURI) {
171     return getLatestByMajor(latestMajor);
172   }
173 
174   /**
175    * @dev Returns the version with the highest semver identifier for the given major.
176    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will return `1.3.0` for major `1`, 
177    * regardless of the order in which they were registered. Returns zero if no versions are registered
178    * for the specified major.
179    * @param major Major identifier to query
180    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
181    */
182   function getLatestByMajor(uint64 major) public view returns (uint64[3] semanticVersion, address contractAddress, bytes contentURI) {
183     Version storage version = versions[majorToLatestVersion[major]];
184     return (version.semanticVersion, version.contractAddress, version.contentURI); 
185   }
186 
187   function semanticVersionHash(uint64[3] version) internal pure returns (bytes32) {
188     return keccak256(abi.encodePacked(version[0], version[1], version[2]));
189   }
190 
191   function semanticVersionIsZero(uint64[3] version) internal pure returns (bool) {
192     return version[0] == 0 && version[1] == 0 && version[2] == 0;
193   }
194 }