1 // File: zos-lib/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  *
10  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/ownership/Ownable.sol
11  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
12  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
13  * build/artifacts folder) as well as the vanilla Ownable implementation from an openzeppelin version.
14  */
15 contract ZOSLibOwnable {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     /**
21      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22      * account.
23      */
24     constructor () internal {
25         _owner = msg.sender;
26         emit OwnershipTransferred(address(0), _owner);
27     }
28 
29     /**
30      * @return the address of the owner.
31      */
32     function owner() public view returns (address) {
33         return _owner;
34     }
35 
36     /**
37      * @dev Throws if called by any account other than the owner.
38      */
39     modifier onlyOwner() {
40         require(isOwner());
41         _;
42     }
43 
44     /**
45      * @return true if `msg.sender` is the owner of the contract.
46      */
47     function isOwner() public view returns (bool) {
48         return msg.sender == _owner;
49     }
50 
51     /**
52      * @dev Allows the current owner to relinquish control of the contract.
53      * @notice Renouncing to ownership will leave the contract without an owner.
54      * It will not be possible to call the functions with the `onlyOwner`
55      * modifier anymore.
56      */
57     function renounceOwnership() public onlyOwner {
58         emit OwnershipTransferred(_owner, address(0));
59         _owner = address(0);
60     }
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner) public onlyOwner {
67         _transferOwnership(newOwner);
68     }
69 
70     /**
71      * @dev Transfers control of the contract to a newOwner.
72      * @param newOwner The address to transfer ownership to.
73      */
74     function _transferOwnership(address newOwner) internal {
75         require(newOwner != address(0));
76         emit OwnershipTransferred(_owner, newOwner);
77         _owner = newOwner;
78     }
79 }
80 
81 // File: zos-lib/contracts/application/Package.sol
82 
83 pragma solidity ^0.5.0;
84 
85 
86 /**
87  * @title Package
88  * @dev A package is composed by a set of versions, identified via semantic versioning,
89  * where each version has a contract address that refers to a reusable implementation,
90  * plus an optional content URI with metadata. Note that the semver identifier is restricted
91  * to major, minor, and patch, as prerelease tags are not supported.
92  */
93 contract Package is ZOSLibOwnable {
94   /**
95    * @dev Emitted when a version is added to the package.
96    * @param semanticVersion Name of the added version.
97    * @param contractAddress Contract associated with the version.
98    * @param contentURI Optional content URI with metadata of the version.
99    */
100   event VersionAdded(uint64[3] semanticVersion, address contractAddress, bytes contentURI);
101 
102   struct Version {
103     uint64[3] semanticVersion;
104     address contractAddress;
105     bytes contentURI; 
106   }
107 
108   mapping (bytes32 => Version) internal versions;
109   mapping (uint64 => bytes32) internal majorToLatestVersion;
110   uint64 internal latestMajor;
111 
112   /**
113    * @dev Returns a version given its semver identifier.
114    * @param semanticVersion Semver identifier of the version.
115    * @return Contract address and content URI for the version, or zero if not exists.
116    */
117   function getVersion(uint64[3] memory semanticVersion) public view returns (address contractAddress, bytes memory contentURI) {
118     Version storage version = versions[semanticVersionHash(semanticVersion)];
119     return (version.contractAddress, version.contentURI); 
120   }
121 
122   /**
123    * @dev Returns a contract for a version given its semver identifier.
124    * This method is equivalent to `getVersion`, but returns only the contract address.
125    * @param semanticVersion Semver identifier of the version.
126    * @return Contract address for the version, or zero if not exists.
127    */
128   function getContract(uint64[3] memory semanticVersion) public view returns (address contractAddress) {
129     Version storage version = versions[semanticVersionHash(semanticVersion)];
130     return version.contractAddress;
131   }
132 
133   /**
134    * @dev Adds a new version to the package. Only the Owner can add new versions.
135    * Reverts if the specified semver identifier already exists. 
136    * Emits a `VersionAdded` event if successful.
137    * @param semanticVersion Semver identifier of the version.
138    * @param contractAddress Contract address for the version, must be non-zero.
139    * @param contentURI Optional content URI for the version.
140    */
141   function addVersion(uint64[3] memory semanticVersion, address contractAddress, bytes memory contentURI) public onlyOwner {
142     require(contractAddress != address(0), "Contract address is required");
143     require(!hasVersion(semanticVersion), "Given version is already registered in package");
144     require(!semanticVersionIsZero(semanticVersion), "Version must be non zero");
145 
146     // Register version
147     bytes32 versionId = semanticVersionHash(semanticVersion);
148     versions[versionId] = Version(semanticVersion, contractAddress, contentURI);
149     
150     // Update latest major
151     uint64 major = semanticVersion[0];
152     if (major > latestMajor) {
153       latestMajor = semanticVersion[0];
154     }
155 
156     // Update latest version for this major
157     uint64 minor = semanticVersion[1];
158     uint64 patch = semanticVersion[2];
159     uint64[3] storage latestVersionForMajor = versions[majorToLatestVersion[major]].semanticVersion;
160     if (semanticVersionIsZero(latestVersionForMajor) // No latest was set for this major
161        || (minor > latestVersionForMajor[1]) // Or current minor is greater 
162        || (minor == latestVersionForMajor[1] && patch > latestVersionForMajor[2]) // Or current patch is greater
163        ) { 
164       majorToLatestVersion[major] = versionId;
165     }
166 
167     emit VersionAdded(semanticVersion, contractAddress, contentURI);
168   }
169 
170   /**
171    * @dev Checks whether a version is present in the package.
172    * @param semanticVersion Semver identifier of the version.
173    * @return true if the version is registered in this package, false otherwise.
174    */
175   function hasVersion(uint64[3] memory semanticVersion) public view returns (bool) {
176     Version storage version = versions[semanticVersionHash(semanticVersion)];
177     return address(version.contractAddress) != address(0);
178   }
179 
180   /**
181    * @dev Returns the version with the highest semver identifier registered in the package.
182    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will always return `2.0.0`, regardless 
183    * of the order in which they were registered. Returns zero if no versions are registered.
184    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
185    */
186   function getLatest() public view returns (uint64[3] memory semanticVersion, address contractAddress, bytes memory contentURI) {
187     return getLatestByMajor(latestMajor);
188   }
189 
190   /**
191    * @dev Returns the version with the highest semver identifier for the given major.
192    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will return `1.3.0` for major `1`, 
193    * regardless of the order in which they were registered. Returns zero if no versions are registered
194    * for the specified major.
195    * @param major Major identifier to query
196    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
197    */
198   function getLatestByMajor(uint64 major) public view returns (uint64[3] memory semanticVersion, address contractAddress, bytes memory contentURI) {
199     Version storage version = versions[majorToLatestVersion[major]];
200     return (version.semanticVersion, version.contractAddress, version.contentURI); 
201   }
202 
203   function semanticVersionHash(uint64[3] memory version) internal pure returns (bytes32) {
204     return keccak256(abi.encodePacked(version[0], version[1], version[2]));
205   }
206 
207   function semanticVersionIsZero(uint64[3] memory version) internal pure returns (bool) {
208     return version[0] == 0 && version[1] == 0 && version[2] == 0;
209   }
210 }