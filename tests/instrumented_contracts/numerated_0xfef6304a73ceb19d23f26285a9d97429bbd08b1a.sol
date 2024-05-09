1 // File: zos-lib/contracts/application/ImplementationProvider.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title ImplementationProvider
7  * @dev Abstract contract for providing implementation addresses for other contracts by name.
8  */
9 contract ImplementationProvider {
10   /**
11    * @dev Abstract function to return the implementation address of a contract.
12    * @param contractName Name of the contract.
13    * @return Implementation address of the contract.
14    */
15   function getImplementation(string memory contractName) public view returns (address);
16 }
17 
18 // File: zos-lib/contracts/ownership/Ownable.sol
19 
20 pragma solidity ^0.5.0;
21 
22 /**
23  * @title Ownable
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * functions, this simplifies the implementation of "user permissions".
26  *
27  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/ownership/Ownable.sol
28  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
29  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
30  * build/artifacts folder) as well as the vanilla Ownable implementation from an openzeppelin version.
31  */
32 contract ZOSLibOwnable {
33     address private _owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     /**
38      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39      * account.
40      */
41     constructor () internal {
42         _owner = msg.sender;
43         emit OwnershipTransferred(address(0), _owner);
44     }
45 
46     /**
47      * @return the address of the owner.
48      */
49     function owner() public view returns (address) {
50         return _owner;
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(isOwner());
58         _;
59     }
60 
61     /**
62      * @return true if `msg.sender` is the owner of the contract.
63      */
64     function isOwner() public view returns (bool) {
65         return msg.sender == _owner;
66     }
67 
68     /**
69      * @dev Allows the current owner to relinquish control of the contract.
70      * @notice Renouncing to ownership will leave the contract without an owner.
71      * It will not be possible to call the functions with the `onlyOwner`
72      * modifier anymore.
73      */
74     function renounceOwnership() public onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     /**
80      * @dev Allows the current owner to transfer control of the contract to a newOwner.
81      * @param newOwner The address to transfer ownership to.
82      */
83     function transferOwnership(address newOwner) public onlyOwner {
84         _transferOwnership(newOwner);
85     }
86 
87     /**
88      * @dev Transfers control of the contract to a newOwner.
89      * @param newOwner The address to transfer ownership to.
90      */
91     function _transferOwnership(address newOwner) internal {
92         require(newOwner != address(0));
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: zos-lib/contracts/application/Package.sol
99 
100 pragma solidity ^0.5.0;
101 
102 
103 /**
104  * @title Package
105  * @dev A package is composed by a set of versions, identified via semantic versioning,
106  * where each version has a contract address that refers to a reusable implementation,
107  * plus an optional content URI with metadata. Note that the semver identifier is restricted
108  * to major, minor, and patch, as prerelease tags are not supported.
109  */
110 contract Package is ZOSLibOwnable {
111   /**
112    * @dev Emitted when a version is added to the package.
113    * @param semanticVersion Name of the added version.
114    * @param contractAddress Contract associated with the version.
115    * @param contentURI Optional content URI with metadata of the version.
116    */
117   event VersionAdded(uint64[3] semanticVersion, address contractAddress, bytes contentURI);
118 
119   struct Version {
120     uint64[3] semanticVersion;
121     address contractAddress;
122     bytes contentURI; 
123   }
124 
125   mapping (bytes32 => Version) internal versions;
126   mapping (uint64 => bytes32) internal majorToLatestVersion;
127   uint64 internal latestMajor;
128 
129   /**
130    * @dev Returns a version given its semver identifier.
131    * @param semanticVersion Semver identifier of the version.
132    * @return Contract address and content URI for the version, or zero if not exists.
133    */
134   function getVersion(uint64[3] memory semanticVersion) public view returns (address contractAddress, bytes memory contentURI) {
135     Version storage version = versions[semanticVersionHash(semanticVersion)];
136     return (version.contractAddress, version.contentURI); 
137   }
138 
139   /**
140    * @dev Returns a contract for a version given its semver identifier.
141    * This method is equivalent to `getVersion`, but returns only the contract address.
142    * @param semanticVersion Semver identifier of the version.
143    * @return Contract address for the version, or zero if not exists.
144    */
145   function getContract(uint64[3] memory semanticVersion) public view returns (address contractAddress) {
146     Version storage version = versions[semanticVersionHash(semanticVersion)];
147     return version.contractAddress;
148   }
149 
150   /**
151    * @dev Adds a new version to the package. Only the Owner can add new versions.
152    * Reverts if the specified semver identifier already exists. 
153    * Emits a `VersionAdded` event if successful.
154    * @param semanticVersion Semver identifier of the version.
155    * @param contractAddress Contract address for the version, must be non-zero.
156    * @param contentURI Optional content URI for the version.
157    */
158   function addVersion(uint64[3] memory semanticVersion, address contractAddress, bytes memory contentURI) public onlyOwner {
159     require(contractAddress != address(0), "Contract address is required");
160     require(!hasVersion(semanticVersion), "Given version is already registered in package");
161     require(!semanticVersionIsZero(semanticVersion), "Version must be non zero");
162 
163     // Register version
164     bytes32 versionId = semanticVersionHash(semanticVersion);
165     versions[versionId] = Version(semanticVersion, contractAddress, contentURI);
166     
167     // Update latest major
168     uint64 major = semanticVersion[0];
169     if (major > latestMajor) {
170       latestMajor = semanticVersion[0];
171     }
172 
173     // Update latest version for this major
174     uint64 minor = semanticVersion[1];
175     uint64 patch = semanticVersion[2];
176     uint64[3] storage latestVersionForMajor = versions[majorToLatestVersion[major]].semanticVersion;
177     if (semanticVersionIsZero(latestVersionForMajor) // No latest was set for this major
178        || (minor > latestVersionForMajor[1]) // Or current minor is greater 
179        || (minor == latestVersionForMajor[1] && patch > latestVersionForMajor[2]) // Or current patch is greater
180        ) { 
181       majorToLatestVersion[major] = versionId;
182     }
183 
184     emit VersionAdded(semanticVersion, contractAddress, contentURI);
185   }
186 
187   /**
188    * @dev Checks whether a version is present in the package.
189    * @param semanticVersion Semver identifier of the version.
190    * @return true if the version is registered in this package, false otherwise.
191    */
192   function hasVersion(uint64[3] memory semanticVersion) public view returns (bool) {
193     Version storage version = versions[semanticVersionHash(semanticVersion)];
194     return address(version.contractAddress) != address(0);
195   }
196 
197   /**
198    * @dev Returns the version with the highest semver identifier registered in the package.
199    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will always return `2.0.0`, regardless 
200    * of the order in which they were registered. Returns zero if no versions are registered.
201    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
202    */
203   function getLatest() public view returns (uint64[3] memory semanticVersion, address contractAddress, bytes memory contentURI) {
204     return getLatestByMajor(latestMajor);
205   }
206 
207   /**
208    * @dev Returns the version with the highest semver identifier for the given major.
209    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will return `1.3.0` for major `1`, 
210    * regardless of the order in which they were registered. Returns zero if no versions are registered
211    * for the specified major.
212    * @param major Major identifier to query
213    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
214    */
215   function getLatestByMajor(uint64 major) public view returns (uint64[3] memory semanticVersion, address contractAddress, bytes memory contentURI) {
216     Version storage version = versions[majorToLatestVersion[major]];
217     return (version.semanticVersion, version.contractAddress, version.contentURI); 
218   }
219 
220   function semanticVersionHash(uint64[3] memory version) internal pure returns (bytes32) {
221     return keccak256(abi.encodePacked(version[0], version[1], version[2]));
222   }
223 
224   function semanticVersionIsZero(uint64[3] memory version) internal pure returns (bool) {
225     return version[0] == 0 && version[1] == 0 && version[2] == 0;
226   }
227 }
228 
229 // File: zos-lib/contracts/upgradeability/Proxy.sol
230 
231 pragma solidity ^0.5.0;
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
301 pragma solidity ^0.5.0;
302 
303 /**
304  * Utility library of inline functions on addresses
305  *
306  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
307  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
308  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
309  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
310  */
311 library ZOSLibAddress {
312     /**
313      * Returns whether the target address is a contract
314      * @dev This function will return false if invoked during the constructor of a contract,
315      * as the code is not actually created until after the constructor finishes.
316      * @param account address of the account to check
317      * @return whether the target address is a contract
318      */
319     function isContract(address account) internal view returns (bool) {
320         uint256 size;
321         // XXX Currently there is no better way to check if there is a contract in an address
322         // than to check the size of the code at that address.
323         // See https://ethereum.stackexchange.com/a/14016/36603
324         // for more details about how this works.
325         // TODO Check this again before the Serenity release, because all addresses will be
326         // contracts then.
327         // solhint-disable-next-line no-inline-assembly
328         assembly { size := extcodesize(account) }
329         return size > 0;
330     }
331 }
332 
333 // File: zos-lib/contracts/upgradeability/BaseUpgradeabilityProxy.sol
334 
335 pragma solidity ^0.5.0;
336 
337 
338 
339 /**
340  * @title BaseUpgradeabilityProxy
341  * @dev This contract implements a proxy that allows to change the
342  * implementation address to which it will delegate.
343  * Such a change is called an implementation upgrade.
344  */
345 contract BaseUpgradeabilityProxy is Proxy {
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
357   bytes32 internal constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
358 
359   /**
360    * @dev Returns the current implementation.
361    * @return Address of the current implementation
362    */
363   function _implementation() internal view returns (address impl) {
364     bytes32 slot = IMPLEMENTATION_SLOT;
365     assembly {
366       impl := sload(slot)
367     }
368   }
369 
370   /**
371    * @dev Upgrades the proxy to a new implementation.
372    * @param newImplementation Address of the new implementation.
373    */
374   function _upgradeTo(address newImplementation) internal {
375     _setImplementation(newImplementation);
376     emit Upgraded(newImplementation);
377   }
378 
379   /**
380    * @dev Sets the implementation address of the proxy.
381    * @param newImplementation Address of the new implementation.
382    */
383   function _setImplementation(address newImplementation) internal {
384     require(ZOSLibAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
385 
386     bytes32 slot = IMPLEMENTATION_SLOT;
387 
388     assembly {
389       sstore(slot, newImplementation)
390     }
391   }
392 }
393 
394 // File: zos-lib/contracts/upgradeability/UpgradeabilityProxy.sol
395 
396 pragma solidity ^0.5.0;
397 
398 
399 /**
400  * @title UpgradeabilityProxy
401  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
402  * implementation and init data.
403  */
404 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
405   /**
406    * @dev Contract constructor.
407    * @param _logic Address of the initial implementation.
408    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
409    * It should include the signature and the parameters of the function to be called, as described in
410    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
411    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
412    */
413   constructor(address _logic, bytes memory _data) public payable {
414     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
415     _setImplementation(_logic);
416     if(_data.length > 0) {
417       (bool success,) = _logic.delegatecall(_data);
418       require(success);
419     }
420   }  
421 }
422 
423 // File: zos-lib/contracts/upgradeability/BaseAdminUpgradeabilityProxy.sol
424 
425 pragma solidity ^0.5.0;
426 
427 
428 /**
429  * @title BaseAdminUpgradeabilityProxy
430  * @dev This contract combines an upgradeability proxy with an authorization
431  * mechanism for administrative tasks.
432  * All external functions in this contract must be guarded by the
433  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
434  * feature proposal that would enable this to be done automatically.
435  */
436 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
437   /**
438    * @dev Emitted when the administration has been transferred.
439    * @param previousAdmin Address of the previous admin.
440    * @param newAdmin Address of the new admin.
441    */
442   event AdminChanged(address previousAdmin, address newAdmin);
443 
444   /**
445    * @dev Storage slot with the admin of the contract.
446    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
447    * validated in the constructor.
448    */
449   bytes32 internal constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
450 
451   /**
452    * @dev Modifier to check whether the `msg.sender` is the admin.
453    * If it is, it will run the function. Otherwise, it will delegate the call
454    * to the implementation.
455    */
456   modifier ifAdmin() {
457     if (msg.sender == _admin()) {
458       _;
459     } else {
460       _fallback();
461     }
462   }
463 
464   /**
465    * @return The address of the proxy admin.
466    */
467   function admin() external ifAdmin returns (address) {
468     return _admin();
469   }
470 
471   /**
472    * @return The address of the implementation.
473    */
474   function implementation() external ifAdmin returns (address) {
475     return _implementation();
476   }
477 
478   /**
479    * @dev Changes the admin of the proxy.
480    * Only the current admin can call this function.
481    * @param newAdmin Address to transfer proxy administration to.
482    */
483   function changeAdmin(address newAdmin) external ifAdmin {
484     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
485     emit AdminChanged(_admin(), newAdmin);
486     _setAdmin(newAdmin);
487   }
488 
489   /**
490    * @dev Upgrade the backing implementation of the proxy.
491    * Only the admin can call this function.
492    * @param newImplementation Address of the new implementation.
493    */
494   function upgradeTo(address newImplementation) external ifAdmin {
495     _upgradeTo(newImplementation);
496   }
497 
498   /**
499    * @dev Upgrade the backing implementation of the proxy and call a function
500    * on the new implementation.
501    * This is useful to initialize the proxied contract.
502    * @param newImplementation Address of the new implementation.
503    * @param data Data to send as msg.data in the low level call.
504    * It should include the signature and the parameters of the function to be called, as described in
505    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
506    */
507   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
508     _upgradeTo(newImplementation);
509     (bool success,) = newImplementation.delegatecall(data);
510     require(success);
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
544 // File: zos-lib/contracts/upgradeability/AdminUpgradeabilityProxy.sol
545 
546 pragma solidity ^0.5.0;
547 
548 
549 /**
550  * @title AdminUpgradeabilityProxy
551  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for 
552  * initializing the implementation, admin, and init data.
553  */
554 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
555   /**
556    * Contract constructor.
557    * @param _logic address of the initial implementation.
558    * @param _admin Address of the proxy administrator.
559    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
560    * It should include the signature and the parameters of the function to be called, as described in
561    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
562    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
563    */
564   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
565     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
566     _setAdmin(_admin);
567   }
568 }
569 
570 // File: zos-lib/contracts/application/App.sol
571 
572 pragma solidity ^0.5.0;
573 
574 
575 
576 
577 
578 /**
579  * @title App
580  * @dev Contract for upgradeable applications.
581  * It handles the creation of proxies.
582  */
583 contract App is ZOSLibOwnable {
584   /**
585    * @dev Emitted when a new proxy is created.
586    * @param proxy Address of the created proxy.
587    */
588   event ProxyCreated(address proxy);
589 
590   /**
591    * @dev Emitted when a package dependency is changed in the application.
592    * @param providerName Name of the package that changed.
593    * @param package Address of the package associated to the name.
594    * @param version Version of the package in use.
595    */
596   event PackageChanged(string providerName, address package, uint64[3] version);
597 
598   /**
599    * @dev Tracks a package in a particular version, used for retrieving implementations
600    */
601   struct ProviderInfo {
602     Package package;
603     uint64[3] version;
604   }
605 
606   /**
607    * @dev Maps from dependency name to a tuple of package and version
608    */
609   mapping(string => ProviderInfo) internal providers;
610 
611   /**
612    * @dev Constructor function.
613    */
614   constructor() public { }
615 
616   /**
617    * @dev Returns the provider for a given package name, or zero if not set.
618    * @param packageName Name of the package to be retrieved.
619    * @return The provider.
620    */
621   function getProvider(string memory packageName) public view returns (ImplementationProvider provider) {
622     ProviderInfo storage info = providers[packageName];
623     if (address(info.package) == address(0)) return ImplementationProvider(0);
624     return ImplementationProvider(info.package.getContract(info.version));
625   }
626 
627   /**
628    * @dev Returns information on a package given its name.
629    * @param packageName Name of the package to be queried.
630    * @return A tuple with the package address and pinned version given a package name, or zero if not set
631    */
632   function getPackage(string memory packageName) public view returns (Package, uint64[3] memory) {
633     ProviderInfo storage info = providers[packageName];
634     return (info.package, info.version);
635   }
636 
637   /**
638    * @dev Sets a package in a specific version as a dependency for this application.
639    * Requires the version to be present in the package.
640    * @param packageName Name of the package to set or overwrite.
641    * @param package Address of the package to register.
642    * @param version Version of the package to use in this application.
643    */
644   function setPackage(string memory packageName, Package package, uint64[3] memory version) public onlyOwner {
645     require(package.hasVersion(version), "The requested version must be registered in the given package");
646     providers[packageName] = ProviderInfo(package, version);
647     emit PackageChanged(packageName, address(package), version);
648   }
649 
650   /**
651    * @dev Unsets a package given its name.
652    * Reverts if the package is not set in the application.
653    * @param packageName Name of the package to remove.
654    */
655   function unsetPackage(string memory packageName) public onlyOwner {
656     require(address(providers[packageName].package) != address(0), "Package to unset not found");
657     delete providers[packageName];
658     emit PackageChanged(packageName, address(0), [uint64(0), uint64(0), uint64(0)]);
659   }
660 
661   /**
662    * @dev Returns the implementation address for a given contract name, provided by the `ImplementationProvider`.
663    * @param packageName Name of the package where the contract is contained.
664    * @param contractName Name of the contract.
665    * @return Address where the contract is implemented.
666    */
667   function getImplementation(string memory packageName, string memory contractName) public view returns (address) {
668     ImplementationProvider provider = getProvider(packageName);
669     if (address(provider) == address(0)) return address(0);
670     return provider.getImplementation(contractName);
671   }
672 
673   /**
674    * @dev Creates a new proxy for the given contract and forwards a function call to it.
675    * This is useful to initialize the proxied contract.
676    * @param packageName Name of the package where the contract is contained.
677    * @param contractName Name of the contract.
678    * @param admin Address of the proxy administrator.
679    * @param data Data to send as msg.data to the corresponding implementation to initialize the proxied contract.
680    * It should include the signature and the parameters of the function to be called, as described in
681    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
682    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
683    * @return Address of the new proxy.
684    */
685    function create(string memory packageName, string memory contractName, address admin, bytes memory data) payable public returns (AdminUpgradeabilityProxy) {
686      address implementation = getImplementation(packageName, contractName);
687      AdminUpgradeabilityProxy proxy = (new AdminUpgradeabilityProxy).value(msg.value)(implementation, admin, data);
688      emit ProxyCreated(address(proxy));
689      return proxy;
690   }
691 }