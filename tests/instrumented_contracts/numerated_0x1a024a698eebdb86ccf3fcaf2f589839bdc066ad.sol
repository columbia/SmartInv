1 /**
2  * @title ImplementationProvider
3  * @dev Interface for providing implementation addresses for other contracts by name.
4  */
5 interface ImplementationProvider {
6   /**
7    * @dev Abstract function to return the implementation address of a contract.
8    * @param contractName Name of the contract.
9    * @return Implementation address of the contract.
10    */
11   function getImplementation(string contractName) public view returns (address);
12 }
13 
14 // File: zos-lib/contracts/ownership/Ownable.sol
15 
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  *
22  * Source: https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.0.0/contracts/ownership/Ownable.sol
23  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
24  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
25  * build/artifacts folder) as well as the vanilla Ownable implementation from an openzeppelin version.
26  */
27 contract ZOSLibOwnable {
28   address private _owner;
29 
30   event OwnershipTransferred(
31     address indexed previousOwner,
32     address indexed newOwner
33   );
34 
35   /**
36    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37    * account.
38    */
39   constructor() internal {
40     _owner = msg.sender;
41     emit OwnershipTransferred(address(0), _owner);
42   }
43 
44   /**
45    * @return the address of the owner.
46    */
47   function owner() public view returns(address) {
48     return _owner;
49   }
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(isOwner());
56     _;
57   }
58 
59   /**
60    * @return true if `msg.sender` is the owner of the contract.
61    */
62   function isOwner() public view returns(bool) {
63     return msg.sender == _owner;
64   }
65 
66   /**
67    * @dev Allows the current owner to relinquish control of the contract.
68    * @notice Renouncing to ownership will leave the contract without an owner.
69    * It will not be possible to call the functions with the `onlyOwner`
70    * modifier anymore.
71    */
72   function renounceOwnership() public onlyOwner {
73     emit OwnershipTransferred(_owner, address(0));
74     _owner = address(0);
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     _transferOwnership(newOwner);
83   }
84 
85   /**
86    * @dev Transfers control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function _transferOwnership(address newOwner) internal {
90     require(newOwner != address(0));
91     emit OwnershipTransferred(_owner, newOwner);
92     _owner = newOwner;
93   }
94 }
95 
96 // File: zos-lib/contracts/application/Package.sol
97 
98 
99 
100 /**
101  * @title Package
102  * @dev A package is composed by a set of versions, identified via semantic versioning,
103  * where each version has a contract address that refers to a reusable implementation,
104  * plus an optional content URI with metadata. Note that the semver identifier is restricted
105  * to major, minor, and patch, as prerelease tags are not supported.
106  */
107 contract Package is ZOSLibOwnable {
108   /**
109    * @dev Emitted when a version is added to the package.
110    * @param semanticVersion Name of the added version.
111    * @param contractAddress Contract associated with the version.
112    * @param contentURI Optional content URI with metadata of the version.
113    */
114   event VersionAdded(uint64[3] semanticVersion, address contractAddress, bytes contentURI);
115 
116   struct Version {
117     uint64[3] semanticVersion;
118     address contractAddress;
119     bytes contentURI; 
120   }
121 
122   mapping (bytes32 => Version) internal versions;
123   mapping (uint64 => bytes32) internal majorToLatestVersion;
124   uint64 internal latestMajor;
125 
126   /**
127    * @dev Returns a version given its semver identifier.
128    * @param semanticVersion Semver identifier of the version.
129    * @return Contract address and content URI for the version, or zero if not exists.
130    */
131   function getVersion(uint64[3] semanticVersion) public view returns (address contractAddress, bytes contentURI) {
132     Version storage version = versions[semanticVersionHash(semanticVersion)];
133     return (version.contractAddress, version.contentURI); 
134   }
135 
136   /**
137    * @dev Returns a contract for a version given its semver identifier.
138    * This method is equivalent to `getVersion`, but returns only the contract address.
139    * @param semanticVersion Semver identifier of the version.
140    * @return Contract address for the version, or zero if not exists.
141    */
142   function getContract(uint64[3] semanticVersion) public view returns (address contractAddress) {
143     Version storage version = versions[semanticVersionHash(semanticVersion)];
144     return version.contractAddress;
145   }
146 
147   /**
148    * @dev Adds a new version to the package. Only the Owner can add new versions.
149    * Reverts if the specified semver identifier already exists. 
150    * Emits a `VersionAdded` event if successful.
151    * @param semanticVersion Semver identifier of the version.
152    * @param contractAddress Contract address for the version, must be non-zero.
153    * @param contentURI Optional content URI for the version.
154    */
155   function addVersion(uint64[3] semanticVersion, address contractAddress, bytes contentURI) public onlyOwner {
156     require(contractAddress != address(0), "Contract address is required");
157     require(!hasVersion(semanticVersion), "Given version is already registered in package");
158     require(!semanticVersionIsZero(semanticVersion), "Version must be non zero");
159 
160     // Register version
161     bytes32 versionId = semanticVersionHash(semanticVersion);
162     versions[versionId] = Version(semanticVersion, contractAddress, contentURI);
163     
164     // Update latest major
165     uint64 major = semanticVersion[0];
166     if (major > latestMajor) {
167       latestMajor = semanticVersion[0];
168     }
169 
170     // Update latest version for this major
171     uint64 minor = semanticVersion[1];
172     uint64 patch = semanticVersion[2];
173     uint64[3] latestVersionForMajor = versions[majorToLatestVersion[major]].semanticVersion;
174     if (semanticVersionIsZero(latestVersionForMajor) // No latest was set for this major
175        || (minor > latestVersionForMajor[1]) // Or current minor is greater 
176        || (minor == latestVersionForMajor[1] && patch > latestVersionForMajor[2]) // Or current patch is greater
177        ) { 
178       majorToLatestVersion[major] = versionId;
179     }
180 
181     emit VersionAdded(semanticVersion, contractAddress, contentURI);
182   }
183 
184   /**
185    * @dev Checks whether a version is present in the package.
186    * @param semanticVersion Semver identifier of the version.
187    * @return true if the version is registered in this package, false otherwise.
188    */
189   function hasVersion(uint64[3] semanticVersion) public view returns (bool) {
190     Version storage version = versions[semanticVersionHash(semanticVersion)];
191     return address(version.contractAddress) != address(0);
192   }
193 
194   /**
195    * @dev Returns the version with the highest semver identifier registered in the package.
196    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will always return `2.0.0`, regardless 
197    * of the order in which they were registered. Returns zero if no versions are registered.
198    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
199    */
200   function getLatest() public view returns (uint64[3] semanticVersion, address contractAddress, bytes contentURI) {
201     return getLatestByMajor(latestMajor);
202   }
203 
204   /**
205    * @dev Returns the version with the highest semver identifier for the given major.
206    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will return `1.3.0` for major `1`, 
207    * regardless of the order in which they were registered. Returns zero if no versions are registered
208    * for the specified major.
209    * @param major Major identifier to query
210    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
211    */
212   function getLatestByMajor(uint64 major) public view returns (uint64[3] semanticVersion, address contractAddress, bytes contentURI) {
213     Version storage version = versions[majorToLatestVersion[major]];
214     return (version.semanticVersion, version.contractAddress, version.contentURI); 
215   }
216 
217   function semanticVersionHash(uint64[3] version) internal pure returns (bytes32) {
218     return keccak256(abi.encodePacked(version[0], version[1], version[2]));
219   }
220 
221   function semanticVersionIsZero(uint64[3] version) internal pure returns (bool) {
222     return version[0] == 0 && version[1] == 0 && version[2] == 0;
223   }
224 }
225 
226 // File: zos-lib/contracts/upgradeability/Proxy.sol
227 
228 
229 /**
230  * @title Proxy
231  * @dev Implements delegation of calls to other contracts, with proper
232  * forwarding of return values and bubbling of failures.
233  * It defines a fallback function that delegates all calls to the address
234  * returned by the abstract _implementation() internal function.
235  */
236 contract Proxy {
237   /**
238    * @dev Fallback function.
239    * Implemented entirely in `_fallback`.
240    */
241   function () payable external {
242     _fallback();
243   }
244 
245   /**
246    * @return The Address of the implementation.
247    */
248   function _implementation() internal view returns (address);
249 
250   /**
251    * @dev Delegates execution to an implementation contract.
252    * This is a low level function that doesn't return to its internal call site.
253    * It will return to the external caller whatever the implementation returns.
254    * @param implementation Address to delegate.
255    */
256   function _delegate(address implementation) internal {
257     assembly {
258       // Copy msg.data. We take full control of memory in this inline assembly
259       // block because it will not return to Solidity code. We overwrite the
260       // Solidity scratch pad at memory position 0.
261       calldatacopy(0, 0, calldatasize)
262 
263       // Call the implementation.
264       // out and outsize are 0 because we don't know the size yet.
265       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
266 
267       // Copy the returned data.
268       returndatacopy(0, 0, returndatasize)
269 
270       switch result
271       // delegatecall returns 0 on error.
272       case 0 { revert(0, returndatasize) }
273       default { return(0, returndatasize) }
274     }
275   }
276 
277   /**
278    * @dev Function that is run as the first thing in the fallback function.
279    * Can be redefined in derived contracts to add functionality.
280    * Redefinitions must call super._willFallback().
281    */
282   function _willFallback() internal {
283   }
284 
285   /**
286    * @dev fallback implementation.
287    * Extracted to enable manual triggering.
288    */
289   function _fallback() internal {
290     _willFallback();
291     _delegate(_implementation());
292   }
293 }
294 
295 // File: zos-lib/contracts/utils/Address.sol
296 
297 
298 /**
299  * Utility library of inline functions on addresses
300  *
301  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.0.0/contracts/utils/Address.sol
302  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
303  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
304  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
305  */
306 library ZOSLibAddress {
307 
308   /**
309    * Returns whether the target address is a contract
310    * @dev This function will return false if invoked during the constructor of a contract,
311    * as the code is not actually created until after the constructor finishes.
312    * @param account address of the account to check
313    * @return whether the target address is a contract
314    */
315   function isContract(address account) internal view returns (bool) {
316     uint256 size;
317     // XXX Currently there is no better way to check if there is a contract in an address
318     // than to check the size of the code at that address.
319     // See https://ethereum.stackexchange.com/a/14016/36603
320     // for more details about how this works.
321     // TODO Check this again before the Serenity release, because all addresses will be
322     // contracts then.
323     // solium-disable-next-line security/no-inline-assembly
324     assembly { size := extcodesize(account) }
325     return size > 0;
326   }
327 
328 }
329 
330 // File: zos-lib/contracts/upgradeability/UpgradeabilityProxy.sol
331 
332 
333 
334 
335 /**
336  * @title UpgradeabilityProxy
337  * @dev This contract implements a proxy that allows to change the
338  * implementation address to which it will delegate.
339  * Such a change is called an implementation upgrade.
340  */
341 contract UpgradeabilityProxy is Proxy {
342   /**
343    * @dev Emitted when the implementation is upgraded.
344    * @param implementation Address of the new implementation.
345    */
346   event Upgraded(address indexed implementation);
347 
348   /**
349    * @dev Storage slot with the address of the current implementation.
350    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
351    * validated in the constructor.
352    */
353   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
354 
355   /**
356    * @dev Contract constructor.
357    * @param _implementation Address of the initial implementation.
358    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
359    * It should include the signature and the parameters of the function to be called, as described in
360    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
361    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
362    */
363   constructor(address _implementation, bytes _data) public payable {
364     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
365     _setImplementation(_implementation);
366     if(_data.length > 0) {
367       require(_implementation.delegatecall(_data));
368     }
369   }
370 
371   /**
372    * @dev Returns the current implementation.
373    * @return Address of the current implementation
374    */
375   function _implementation() internal view returns (address impl) {
376     bytes32 slot = IMPLEMENTATION_SLOT;
377     assembly {
378       impl := sload(slot)
379     }
380   }
381 
382   /**
383    * @dev Upgrades the proxy to a new implementation.
384    * @param newImplementation Address of the new implementation.
385    */
386   function _upgradeTo(address newImplementation) internal {
387     _setImplementation(newImplementation);
388     emit Upgraded(newImplementation);
389   }
390 
391   /**
392    * @dev Sets the implementation address of the proxy.
393    * @param newImplementation Address of the new implementation.
394    */
395   function _setImplementation(address newImplementation) private {
396     require(ZOSLibAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
397 
398     bytes32 slot = IMPLEMENTATION_SLOT;
399 
400     assembly {
401       sstore(slot, newImplementation)
402     }
403   }
404 }
405 
406 // File: zos-lib/contracts/upgradeability/AdminUpgradeabilityProxy.sol
407 
408 
409 
410 /**
411  * @title AdminUpgradeabilityProxy
412  * @dev This contract combines an upgradeability proxy with an authorization
413  * mechanism for administrative tasks.
414  * All external functions in this contract must be guarded by the
415  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
416  * feature proposal that would enable this to be done automatically.
417  */
418 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
419   /**
420    * @dev Emitted when the administration has been transferred.
421    * @param previousAdmin Address of the previous admin.
422    * @param newAdmin Address of the new admin.
423    */
424   event AdminChanged(address previousAdmin, address newAdmin);
425 
426   /**
427    * @dev Storage slot with the admin of the contract.
428    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
429    * validated in the constructor.
430    */
431   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
432 
433   /**
434    * @dev Modifier to check whether the `msg.sender` is the admin.
435    * If it is, it will run the function. Otherwise, it will delegate the call
436    * to the implementation.
437    */
438   modifier ifAdmin() {
439     if (msg.sender == _admin()) {
440       _;
441     } else {
442       _fallback();
443     }
444   }
445 
446   /**
447    * Contract constructor.
448    * @param _implementation address of the initial implementation.
449    * @param _admin Address of the proxy administrator.
450    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
451    * It should include the signature and the parameters of the function to be called, as described in
452    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
453    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
454    */
455   constructor(address _implementation, address _admin, bytes _data) UpgradeabilityProxy(_implementation, _data) public payable {
456     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
457 
458     _setAdmin(_admin);
459   }
460 
461   /**
462    * @return The address of the proxy admin.
463    */
464   function admin() external view ifAdmin returns (address) {
465     return _admin();
466   }
467 
468   /**
469    * @return The address of the implementation.
470    */
471   function implementation() external view ifAdmin returns (address) {
472     return _implementation();
473   }
474 
475   /**
476    * @dev Changes the admin of the proxy.
477    * Only the current admin can call this function.
478    * @param newAdmin Address to transfer proxy administration to.
479    */
480   function changeAdmin(address newAdmin) external ifAdmin {
481     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
482     emit AdminChanged(_admin(), newAdmin);
483     _setAdmin(newAdmin);
484   }
485 
486   /**
487    * @dev Upgrade the backing implementation of the proxy.
488    * Only the admin can call this function.
489    * @param newImplementation Address of the new implementation.
490    */
491   function upgradeTo(address newImplementation) external ifAdmin {
492     _upgradeTo(newImplementation);
493   }
494 
495   /**
496    * @dev Upgrade the backing implementation of the proxy and call a function
497    * on the new implementation.
498    * This is useful to initialize the proxied contract.
499    * @param newImplementation Address of the new implementation.
500    * @param data Data to send as msg.data in the low level call.
501    * It should include the signature and the parameters of the function to be called, as described in
502    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
503    */
504   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
505     _upgradeTo(newImplementation);
506     require(newImplementation.delegatecall(data));
507   }
508 
509   /**
510    * @return The admin slot.
511    */
512   function _admin() internal view returns (address adm) {
513     bytes32 slot = ADMIN_SLOT;
514     assembly {
515       adm := sload(slot)
516     }
517   }
518 
519   /**
520    * @dev Sets the address of the proxy admin.
521    * @param newAdmin Address of the new proxy admin.
522    */
523   function _setAdmin(address newAdmin) internal {
524     bytes32 slot = ADMIN_SLOT;
525 
526     assembly {
527       sstore(slot, newAdmin)
528     }
529   }
530 
531   /**
532    * @dev Only fall back when the sender is not the admin.
533    */
534   function _willFallback() internal {
535     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
536     super._willFallback();
537   }
538 }
539 
540 // File: zos-lib/contracts/application/App.sol
541 
542 
543 
544 
545 
546 
547 /**
548  * @title App
549  * @dev Contract for upgradeable applications.
550  * It handles the creation of proxies.
551  */
552 contract App is ZOSLibOwnable {
553   /**
554    * @dev Emitted when a new proxy is created.
555    * @param proxy Address of the created proxy.
556    */
557   event ProxyCreated(address proxy);
558 
559   /**
560    * @dev Emitted when a package dependency is changed in the application.
561    * @param providerName Name of the package that changed.
562    * @param package Address of the package associated to the name.
563    * @param version Version of the package in use.
564    */
565   event PackageChanged(string providerName, address package, uint64[3] version);
566 
567   /**
568    * @dev Tracks a package in a particular version, used for retrieving implementations
569    */
570   struct ProviderInfo {
571     Package package;
572     uint64[3] version;
573   }
574 
575   /**
576    * @dev Maps from dependency name to a tuple of package and version
577    */
578   mapping(string => ProviderInfo) internal providers;
579 
580   /**
581    * @dev Constructor function.
582    */
583   constructor() public { }
584 
585   /**
586    * @dev Returns the provider for a given package name, or zero if not set.
587    * @param packageName Name of the package to be retrieved.
588    * @return The provider.
589    */
590   function getProvider(string packageName) public view returns (ImplementationProvider provider) {
591     ProviderInfo storage info = providers[packageName];
592     if (address(info.package) == address(0)) return ImplementationProvider(0);
593     return ImplementationProvider(info.package.getContract(info.version));
594   }
595 
596   /**
597    * @dev Returns information on a package given its name.
598    * @param packageName Name of the package to be queried.
599    * @return A tuple with the package address and pinned version given a package name, or zero if not set
600    */
601   function getPackage(string packageName) public view returns (Package, uint64[3]) {
602     ProviderInfo storage info = providers[packageName];
603     return (info.package, info.version);
604   }
605 
606   /**
607    * @dev Sets a package in a specific version as a dependency for this application.
608    * Requires the version to be present in the package.
609    * @param packageName Name of the package to set or overwrite.
610    * @param package Address of the package to register.
611    * @param version Version of the package to use in this application.
612    */
613   function setPackage(string packageName, Package package, uint64[3] version) public onlyOwner {
614     require(package.hasVersion(version), "The requested version must be registered in the given package");
615     providers[packageName] = ProviderInfo(package, version);
616     emit PackageChanged(packageName, package, version);
617   }
618 
619   /**
620    * @dev Unsets a package given its name.
621    * Reverts if the package is not set in the application.
622    * @param packageName Name of the package to remove.
623    */
624   function unsetPackage(string packageName) public onlyOwner {
625     require(address(providers[packageName].package) != address(0), "Package to unset not found");
626     delete providers[packageName];
627     emit PackageChanged(packageName, address(0), [uint64(0), uint64(0), uint64(0)]);
628   }
629 
630   /**
631    * @dev Returns the implementation address for a given contract name, provided by the `ImplementationProvider`.
632    * @param packageName Name of the package where the contract is contained.
633    * @param contractName Name of the contract.
634    * @return Address where the contract is implemented.
635    */
636   function getImplementation(string packageName, string contractName) public view returns (address) {
637     ImplementationProvider provider = getProvider(packageName);
638     if (address(provider) == address(0)) return address(0);
639     return provider.getImplementation(contractName);
640   }
641 
642   /**
643    * @dev Creates a new proxy for the given contract and forwards a function call to it.
644    * This is useful to initialize the proxied contract.
645    * @param packageName Name of the package where the contract is contained.
646    * @param contractName Name of the contract.
647    * @param admin Address of the proxy administrator.
648    * @param data Data to send as msg.data to the corresponding implementation to initialize the proxied contract.
649    * It should include the signature and the parameters of the function to be called, as described in
650    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
651    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
652    * @return Address of the new proxy.
653    */
654    function create(string packageName, string contractName, address admin, bytes data) payable public returns (AdminUpgradeabilityProxy) {
655      address implementation = getImplementation(packageName, contractName);
656      AdminUpgradeabilityProxy proxy = (new AdminUpgradeabilityProxy).value(msg.value)(implementation, admin, data);
657      emit ProxyCreated(proxy);
658      return proxy;
659   }
660 }