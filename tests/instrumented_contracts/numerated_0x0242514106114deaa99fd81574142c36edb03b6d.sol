1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-22
3 */
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
18 // File: zos-lib/contracts/ownership/Ownable.sol
19 
20 
21 /**
22  * @title Ownable
23  * @dev The Ownable contract has an owner address, and provides basic authorization control
24  * functions, this simplifies the implementation of "user permissions".
25  *
26  * Source: https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.0.0/contracts/ownership/Ownable.sol
27  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
28  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
29  * build/artifacts folder) as well as the vanilla Ownable implementation from an openzeppelin version.
30  */
31 contract ZOSLibOwnable {
32   address private _owner;
33 
34   event OwnershipTransferred(
35     address indexed previousOwner,
36     address indexed newOwner
37   );
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   constructor() internal {
44     _owner = msg.sender;
45     emit OwnershipTransferred(address(0), _owner);
46   }
47 
48   /**
49    * @return the address of the owner.
50    */
51   function owner() public view returns(address) {
52     return _owner;
53   }
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(isOwner());
60     _;
61   }
62 
63   /**
64    * @return true if `msg.sender` is the owner of the contract.
65    */
66   function isOwner() public view returns(bool) {
67     return msg.sender == _owner;
68   }
69 
70   /**
71    * @dev Allows the current owner to relinquish control of the contract.
72    * @notice Renouncing to ownership will leave the contract without an owner.
73    * It will not be possible to call the functions with the `onlyOwner`
74    * modifier anymore.
75    */
76   function renounceOwnership() public onlyOwner {
77     emit OwnershipTransferred(_owner, address(0));
78     _owner = address(0);
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     _transferOwnership(newOwner);
87   }
88 
89   /**
90    * @dev Transfers control of the contract to a newOwner.
91    * @param newOwner The address to transfer ownership to.
92    */
93   function _transferOwnership(address newOwner) internal {
94     require(newOwner != address(0));
95     emit OwnershipTransferred(_owner, newOwner);
96     _owner = newOwner;
97   }
98 }
99 
100 // File: zos-lib/contracts/application/Package.sol
101 
102 
103 
104 /**
105  * @title Package
106  * @dev A package is composed by a set of versions, identified via semantic versioning,
107  * where each version has a contract address that refers to a reusable implementation,
108  * plus an optional content URI with metadata. Note that the semver identifier is restricted
109  * to major, minor, and patch, as prerelease tags are not supported.
110  */
111 contract Package is ZOSLibOwnable {
112   /**
113    * @dev Emitted when a version is added to the package.
114    * @param semanticVersion Name of the added version.
115    * @param contractAddress Contract associated with the version.
116    * @param contentURI Optional content URI with metadata of the version.
117    */
118   event VersionAdded(uint64[3] semanticVersion, address contractAddress, bytes contentURI);
119 
120   struct Version {
121     uint64[3] semanticVersion;
122     address contractAddress;
123     bytes contentURI; 
124   }
125 
126   mapping (bytes32 => Version) internal versions;
127   mapping (uint64 => bytes32) internal majorToLatestVersion;
128   uint64 internal latestMajor;
129 
130   /**
131    * @dev Returns a version given its semver identifier.
132    * @param semanticVersion Semver identifier of the version.
133    * @return Contract address and content URI for the version, or zero if not exists.
134    */
135   function getVersion(uint64[3] semanticVersion) public view returns (address contractAddress, bytes contentURI) {
136     Version storage version = versions[semanticVersionHash(semanticVersion)];
137     return (version.contractAddress, version.contentURI); 
138   }
139 
140   /**
141    * @dev Returns a contract for a version given its semver identifier.
142    * This method is equivalent to `getVersion`, but returns only the contract address.
143    * @param semanticVersion Semver identifier of the version.
144    * @return Contract address for the version, or zero if not exists.
145    */
146   function getContract(uint64[3] semanticVersion) public view returns (address contractAddress) {
147     Version storage version = versions[semanticVersionHash(semanticVersion)];
148     return version.contractAddress;
149   }
150 
151   /**
152    * @dev Adds a new version to the package. Only the Owner can add new versions.
153    * Reverts if the specified semver identifier already exists. 
154    * Emits a `VersionAdded` event if successful.
155    * @param semanticVersion Semver identifier of the version.
156    * @param contractAddress Contract address for the version, must be non-zero.
157    * @param contentURI Optional content URI for the version.
158    */
159   function addVersion(uint64[3] semanticVersion, address contractAddress, bytes contentURI) public onlyOwner {
160     require(contractAddress != address(0), "Contract address is required");
161     require(!hasVersion(semanticVersion), "Given version is already registered in package");
162     require(!semanticVersionIsZero(semanticVersion), "Version must be non zero");
163 
164     // Register version
165     bytes32 versionId = semanticVersionHash(semanticVersion);
166     versions[versionId] = Version(semanticVersion, contractAddress, contentURI);
167     
168     // Update latest major
169     uint64 major = semanticVersion[0];
170     if (major > latestMajor) {
171       latestMajor = semanticVersion[0];
172     }
173 
174     // Update latest version for this major
175     uint64 minor = semanticVersion[1];
176     uint64 patch = semanticVersion[2];
177     uint64[3] latestVersionForMajor = versions[majorToLatestVersion[major]].semanticVersion;
178     if (semanticVersionIsZero(latestVersionForMajor) // No latest was set for this major
179        || (minor > latestVersionForMajor[1]) // Or current minor is greater 
180        || (minor == latestVersionForMajor[1] && patch > latestVersionForMajor[2]) // Or current patch is greater
181        ) { 
182       majorToLatestVersion[major] = versionId;
183     }
184 
185     emit VersionAdded(semanticVersion, contractAddress, contentURI);
186   }
187 
188   /**
189    * @dev Checks whether a version is present in the package.
190    * @param semanticVersion Semver identifier of the version.
191    * @return true if the version is registered in this package, false otherwise.
192    */
193   function hasVersion(uint64[3] semanticVersion) public view returns (bool) {
194     Version storage version = versions[semanticVersionHash(semanticVersion)];
195     return address(version.contractAddress) != address(0);
196   }
197 
198   /**
199    * @dev Returns the version with the highest semver identifier registered in the package.
200    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will always return `2.0.0`, regardless 
201    * of the order in which they were registered. Returns zero if no versions are registered.
202    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
203    */
204   function getLatest() public view returns (uint64[3] semanticVersion, address contractAddress, bytes contentURI) {
205     return getLatestByMajor(latestMajor);
206   }
207 
208   /**
209    * @dev Returns the version with the highest semver identifier for the given major.
210    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will return `1.3.0` for major `1`, 
211    * regardless of the order in which they were registered. Returns zero if no versions are registered
212    * for the specified major.
213    * @param major Major identifier to query
214    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
215    */
216   function getLatestByMajor(uint64 major) public view returns (uint64[3] semanticVersion, address contractAddress, bytes contentURI) {
217     Version storage version = versions[majorToLatestVersion[major]];
218     return (version.semanticVersion, version.contractAddress, version.contentURI); 
219   }
220 
221   function semanticVersionHash(uint64[3] version) internal pure returns (bytes32) {
222     return keccak256(abi.encodePacked(version[0], version[1], version[2]));
223   }
224 
225   function semanticVersionIsZero(uint64[3] version) internal pure returns (bool) {
226     return version[0] == 0 && version[1] == 0 && version[2] == 0;
227   }
228 }
229 
230 // File: zos-lib/contracts/upgradeability/Proxy.sol
231 
232 
233 /**
234  * @title Proxy
235  * @dev Implements delegation of calls to other contracts, with proper
236  * forwarding of return values and bubbling of failures.
237  * It defines a fallback function that delegates all calls to the address
238  * returned by the abstract _implementation() internal function.
239  */
240 contract Proxy {
241   /**
242    * @dev Fallback function.
243    * Implemented entirely in `_fallback`.
244    */
245   function () payable external {
246     _fallback();
247   }
248 
249   /**
250    * @return The Address of the implementation.
251    */
252   function _implementation() internal view returns (address);
253 
254   /**
255    * @dev Delegates execution to an implementation contract.
256    * This is a low level function that doesn't return to its internal call site.
257    * It will return to the external caller whatever the implementation returns.
258    * @param implementation Address to delegate.
259    */
260   function _delegate(address implementation) internal {
261     assembly {
262       // Copy msg.data. We take full control of memory in this inline assembly
263       // block because it will not return to Solidity code. We overwrite the
264       // Solidity scratch pad at memory position 0.
265       calldatacopy(0, 0, calldatasize)
266 
267       // Call the implementation.
268       // out and outsize are 0 because we don't know the size yet.
269       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
270 
271       // Copy the returned data.
272       returndatacopy(0, 0, returndatasize)
273 
274       switch result
275       // delegatecall returns 0 on error.
276       case 0 { revert(0, returndatasize) }
277       default { return(0, returndatasize) }
278     }
279   }
280 
281   /**
282    * @dev Function that is run as the first thing in the fallback function.
283    * Can be redefined in derived contracts to add functionality.
284    * Redefinitions must call super._willFallback().
285    */
286   function _willFallback() internal {
287   }
288 
289   /**
290    * @dev fallback implementation.
291    * Extracted to enable manual triggering.
292    */
293   function _fallback() internal {
294     _willFallback();
295     _delegate(_implementation());
296   }
297 }
298 
299 // File: zos-lib/contracts/utils/Address.sol
300 
301 
302 /**
303  * Utility library of inline functions on addresses
304  *
305  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.0.0/contracts/utils/Address.sol
306  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
307  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
308  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
309  */
310 library ZOSLibAddress {
311 
312   /**
313    * Returns whether the target address is a contract
314    * @dev This function will return false if invoked during the constructor of a contract,
315    * as the code is not actually created until after the constructor finishes.
316    * @param account address of the account to check
317    * @return whether the target address is a contract
318    */
319   function isContract(address account) internal view returns (bool) {
320     uint256 size;
321     // XXX Currently there is no better way to check if there is a contract in an address
322     // than to check the size of the code at that address.
323     // See https://ethereum.stackexchange.com/a/14016/36603
324     // for more details about how this works.
325     // TODO Check this again before the Serenity release, because all addresses will be
326     // contracts then.
327     // solium-disable-next-line security/no-inline-assembly
328     assembly { size := extcodesize(account) }
329     return size > 0;
330   }
331 
332 }
333 
334 // File: zos-lib/contracts/upgradeability/UpgradeabilityProxy.sol
335 
336 
337 
338 
339 /**
340  * @title UpgradeabilityProxy
341  * @dev This contract implements a proxy that allows to change the
342  * implementation address to which it will delegate.
343  * Such a change is called an implementation upgrade.
344  */
345 contract UpgradeabilityProxy is Proxy {
346   /**
347    * @dev Emitted when the implementation is upgraded.
348    * @param implementation Address of the new implementation.
349    */
350   event Upgraded(address indexed implementation);
351 
352   /**
353    * @dev Storage slot with the address of the current implementation.
354    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
355    * validated in the constructor.
356    */
357   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
358 
359   /**
360    * @dev Contract constructor.
361    * @param _implementation Address of the initial implementation.
362    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
363    * It should include the signature and the parameters of the function to be called, as described in
364    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
365    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
366    */
367   constructor(address _implementation, bytes _data) public payable {
368     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
369     _setImplementation(_implementation);
370     if(_data.length > 0) {
371       require(_implementation.delegatecall(_data));
372     }
373   }
374 
375   /**
376    * @dev Returns the current implementation.
377    * @return Address of the current implementation
378    */
379   function _implementation() internal view returns (address impl) {
380     bytes32 slot = IMPLEMENTATION_SLOT;
381     assembly {
382       impl := sload(slot)
383     }
384   }
385 
386   /**
387    * @dev Upgrades the proxy to a new implementation.
388    * @param newImplementation Address of the new implementation.
389    */
390   function _upgradeTo(address newImplementation) internal {
391     _setImplementation(newImplementation);
392     emit Upgraded(newImplementation);
393   }
394 
395   /**
396    * @dev Sets the implementation address of the proxy.
397    * @param newImplementation Address of the new implementation.
398    */
399   function _setImplementation(address newImplementation) private {
400     require(ZOSLibAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
401 
402     bytes32 slot = IMPLEMENTATION_SLOT;
403 
404     assembly {
405       sstore(slot, newImplementation)
406     }
407   }
408 }
409 
410 // File: zos-lib/contracts/upgradeability/AdminUpgradeabilityProxy.sol
411 
412 
413 
414 /**
415  * @title AdminUpgradeabilityProxy
416  * @dev This contract combines an upgradeability proxy with an authorization
417  * mechanism for administrative tasks.
418  * All external functions in this contract must be guarded by the
419  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
420  * feature proposal that would enable this to be done automatically.
421  */
422 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
423   /**
424    * @dev Emitted when the administration has been transferred.
425    * @param previousAdmin Address of the previous admin.
426    * @param newAdmin Address of the new admin.
427    */
428   event AdminChanged(address previousAdmin, address newAdmin);
429 
430   /**
431    * @dev Storage slot with the admin of the contract.
432    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
433    * validated in the constructor.
434    */
435   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
436 
437   /**
438    * @dev Modifier to check whether the `msg.sender` is the admin.
439    * If it is, it will run the function. Otherwise, it will delegate the call
440    * to the implementation.
441    */
442   modifier ifAdmin() {
443     if (msg.sender == _admin()) {
444       _;
445     } else {
446       _fallback();
447     }
448   }
449 
450   /**
451    * Contract constructor.
452    * @param _implementation address of the initial implementation.
453    * @param _admin Address of the proxy administrator.
454    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
455    * It should include the signature and the parameters of the function to be called, as described in
456    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
457    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
458    */
459   constructor(address _implementation, address _admin, bytes _data) UpgradeabilityProxy(_implementation, _data) public payable {
460     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
461 
462     _setAdmin(_admin);
463   }
464 
465   /**
466    * @return The address of the proxy admin.
467    */
468   function admin() external view ifAdmin returns (address) {
469     return _admin();
470   }
471 
472   /**
473    * @return The address of the implementation.
474    */
475   function implementation() external view ifAdmin returns (address) {
476     return _implementation();
477   }
478 
479   /**
480    * @dev Changes the admin of the proxy.
481    * Only the current admin can call this function.
482    * @param newAdmin Address to transfer proxy administration to.
483    */
484   function changeAdmin(address newAdmin) external ifAdmin {
485     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
486     emit AdminChanged(_admin(), newAdmin);
487     _setAdmin(newAdmin);
488   }
489 
490   /**
491    * @dev Upgrade the backing implementation of the proxy.
492    * Only the admin can call this function.
493    * @param newImplementation Address of the new implementation.
494    */
495   function upgradeTo(address newImplementation) external ifAdmin {
496     _upgradeTo(newImplementation);
497   }
498 
499   /**
500    * @dev Upgrade the backing implementation of the proxy and call a function
501    * on the new implementation.
502    * This is useful to initialize the proxied contract.
503    * @param newImplementation Address of the new implementation.
504    * @param data Data to send as msg.data in the low level call.
505    * It should include the signature and the parameters of the function to be called, as described in
506    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
507    */
508   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
509     _upgradeTo(newImplementation);
510     require(newImplementation.delegatecall(data));
511   }
512 
513   /**
514    * @return The admin slot.
515    */
516   function _admin() internal view returns (address adm) {
517     bytes32 slot = ADMIN_SLOT;
518     assembly {
519       adm := sload(slot)
520     }
521   }
522 
523   /**
524    * @dev Sets the address of the proxy admin.
525    * @param newAdmin Address of the new proxy admin.
526    */
527   function _setAdmin(address newAdmin) internal {
528     bytes32 slot = ADMIN_SLOT;
529 
530     assembly {
531       sstore(slot, newAdmin)
532     }
533   }
534 
535   /**
536    * @dev Only fall back when the sender is not the admin.
537    */
538   function _willFallback() internal {
539     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
540     super._willFallback();
541   }
542 }
543 
544 // File: zos-lib/contracts/application/App.sol
545 
546 
547 
548 
549 
550 
551 /**
552  * @title App
553  * @dev Contract for upgradeable applications.
554  * It handles the creation of proxies.
555  */
556 contract App is ZOSLibOwnable {
557   /**
558    * @dev Emitted when a new proxy is created.
559    * @param proxy Address of the created proxy.
560    */
561   event ProxyCreated(address proxy);
562 
563   /**
564    * @dev Emitted when a package dependency is changed in the application.
565    * @param providerName Name of the package that changed.
566    * @param package Address of the package associated to the name.
567    * @param version Version of the package in use.
568    */
569   event PackageChanged(string providerName, address package, uint64[3] version);
570 
571   /**
572    * @dev Tracks a package in a particular version, used for retrieving implementations
573    */
574   struct ProviderInfo {
575     Package package;
576     uint64[3] version;
577   }
578 
579   /**
580    * @dev Maps from dependency name to a tuple of package and version
581    */
582   mapping(string => ProviderInfo) internal providers;
583 
584   /**
585    * @dev Constructor function.
586    */
587   constructor() public { }
588 
589   /**
590    * @dev Returns the provider for a given package name, or zero if not set.
591    * @param packageName Name of the package to be retrieved.
592    * @return The provider.
593    */
594   function getProvider(string packageName) public view returns (ImplementationProvider provider) {
595     ProviderInfo storage info = providers[packageName];
596     if (address(info.package) == address(0)) return ImplementationProvider(0);
597     return ImplementationProvider(info.package.getContract(info.version));
598   }
599 
600   /**
601    * @dev Returns information on a package given its name.
602    * @param packageName Name of the package to be queried.
603    * @return A tuple with the package address and pinned version given a package name, or zero if not set
604    */
605   function getPackage(string packageName) public view returns (Package, uint64[3]) {
606     ProviderInfo storage info = providers[packageName];
607     return (info.package, info.version);
608   }
609 
610   /**
611    * @dev Sets a package in a specific version as a dependency for this application.
612    * Requires the version to be present in the package.
613    * @param packageName Name of the package to set or overwrite.
614    * @param package Address of the package to register.
615    * @param version Version of the package to use in this application.
616    */
617   function setPackage(string packageName, Package package, uint64[3] version) public onlyOwner {
618     require(package.hasVersion(version), "The requested version must be registered in the given package");
619     providers[packageName] = ProviderInfo(package, version);
620     emit PackageChanged(packageName, package, version);
621   }
622 
623   /**
624    * @dev Unsets a package given its name.
625    * Reverts if the package is not set in the application.
626    * @param packageName Name of the package to remove.
627    */
628   function unsetPackage(string packageName) public onlyOwner {
629     require(address(providers[packageName].package) != address(0), "Package to unset not found");
630     delete providers[packageName];
631     emit PackageChanged(packageName, address(0), [uint64(0), uint64(0), uint64(0)]);
632   }
633 
634   /**
635    * @dev Returns the implementation address for a given contract name, provided by the `ImplementationProvider`.
636    * @param packageName Name of the package where the contract is contained.
637    * @param contractName Name of the contract.
638    * @return Address where the contract is implemented.
639    */
640   function getImplementation(string packageName, string contractName) public view returns (address) {
641     ImplementationProvider provider = getProvider(packageName);
642     if (address(provider) == address(0)) return address(0);
643     return provider.getImplementation(contractName);
644   }
645 
646   /**
647    * @dev Creates a new proxy for the given contract and forwards a function call to it.
648    * This is useful to initialize the proxied contract.
649    * @param packageName Name of the package where the contract is contained.
650    * @param contractName Name of the contract.
651    * @param admin Address of the proxy administrator.
652    * @param data Data to send as msg.data to the corresponding implementation to initialize the proxied contract.
653    * It should include the signature and the parameters of the function to be called, as described in
654    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
655    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
656    * @return Address of the new proxy.
657    */
658    function create(string packageName, string contractName, address admin, bytes data) payable public returns (AdminUpgradeabilityProxy) {
659      address implementation = getImplementation(packageName, contractName);
660      AdminUpgradeabilityProxy proxy = (new AdminUpgradeabilityProxy).value(msg.value)(implementation, admin, data);
661      emit ProxyCreated(proxy);
662      return proxy;
663   }
664 }