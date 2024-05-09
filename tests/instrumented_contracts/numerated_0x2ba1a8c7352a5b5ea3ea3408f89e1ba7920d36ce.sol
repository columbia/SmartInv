1 pragma solidity ^0.4.24;
2 
3 // File: /home/blackjak/Projects/winding-tree/wt-contracts/node_modules/zos-lib/contracts/application/ImplementationProvider.sol
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
82 // File: /home/blackjak/Projects/winding-tree/wt-contracts/node_modules/zos-lib/contracts/application/Package.sol
83 
84 /**
85  * @title Package
86  * @dev A package is composed by a set of versions, identified via semantic versioning,
87  * where each version has a contract address that refers to a reusable implementation,
88  * plus an optional content URI with metadata. Note that the semver identifier is restricted
89  * to major, minor, and patch, as prerelease tags are not supported.
90  */
91 contract Package is Ownable {
92   /**
93    * @dev Emitted when a version is added to the package.
94    * @param semanticVersion Name of the added version.
95    * @param contractAddress Contract associated with the version.
96    * @param contentURI Optional content URI with metadata of the version.
97    */
98   event VersionAdded(uint64[3] semanticVersion, address contractAddress, bytes contentURI);
99 
100   struct Version {
101     uint64[3] semanticVersion;
102     address contractAddress;
103     bytes contentURI; 
104   }
105 
106   mapping (bytes32 => Version) internal versions;
107   mapping (uint64 => bytes32) internal majorToLatestVersion;
108   uint64 internal latestMajor;
109 
110   /**
111    * @dev Returns a version given its semver identifier.
112    * @param semanticVersion Semver identifier of the version.
113    * @return Contract address and content URI for the version, or zero if not exists.
114    */
115   function getVersion(uint64[3] semanticVersion) public view returns (address contractAddress, bytes contentURI) {
116     Version storage version = versions[semanticVersionHash(semanticVersion)];
117     return (version.contractAddress, version.contentURI); 
118   }
119 
120   /**
121    * @dev Returns a contract for a version given its semver identifier.
122    * This method is equivalent to `getVersion`, but returns only the contract address.
123    * @param semanticVersion Semver identifier of the version.
124    * @return Contract address for the version, or zero if not exists.
125    */
126   function getContract(uint64[3] semanticVersion) public view returns (address contractAddress) {
127     Version storage version = versions[semanticVersionHash(semanticVersion)];
128     return version.contractAddress;
129   }
130 
131   /**
132    * @dev Adds a new version to the package. Only the Owner can add new versions.
133    * Reverts if the specified semver identifier already exists. 
134    * Emits a `VersionAdded` event if successful.
135    * @param semanticVersion Semver identifier of the version.
136    * @param contractAddress Contract address for the version, must be non-zero.
137    * @param contentURI Optional content URI for the version.
138    */
139   function addVersion(uint64[3] semanticVersion, address contractAddress, bytes contentURI) public onlyOwner {
140     require(contractAddress != address(0), "Contract address is required");
141     require(!hasVersion(semanticVersion), "Given version is already registered in package");
142     require(!semanticVersionIsZero(semanticVersion), "Version must be non zero");
143 
144     // Register version
145     bytes32 versionId = semanticVersionHash(semanticVersion);
146     versions[versionId] = Version(semanticVersion, contractAddress, contentURI);
147     
148     // Update latest major
149     uint64 major = semanticVersion[0];
150     if (major > latestMajor) {
151       latestMajor = semanticVersion[0];
152     }
153 
154     // Update latest version for this major
155     uint64 minor = semanticVersion[1];
156     uint64 patch = semanticVersion[2];
157     uint64[3] latestVersionForMajor = versions[majorToLatestVersion[major]].semanticVersion;
158     if (semanticVersionIsZero(latestVersionForMajor) // No latest was set for this major
159        || (minor > latestVersionForMajor[1]) // Or current minor is greater 
160        || (minor == latestVersionForMajor[1] && patch > latestVersionForMajor[2]) // Or current patch is greater
161        ) { 
162       majorToLatestVersion[major] = versionId;
163     }
164 
165     emit VersionAdded(semanticVersion, contractAddress, contentURI);
166   }
167 
168   /**
169    * @dev Checks whether a version is present in the package.
170    * @param semanticVersion Semver identifier of the version.
171    * @return true if the version is registered in this package, false otherwise.
172    */
173   function hasVersion(uint64[3] semanticVersion) public view returns (bool) {
174     Version storage version = versions[semanticVersionHash(semanticVersion)];
175     return address(version.contractAddress) != address(0);
176   }
177 
178   /**
179    * @dev Returns the version with the highest semver identifier registered in the package.
180    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will always return `2.0.0`, regardless 
181    * of the order in which they were registered. Returns zero if no versions are registered.
182    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
183    */
184   function getLatest() public view returns (uint64[3] semanticVersion, address contractAddress, bytes contentURI) {
185     return getLatestByMajor(latestMajor);
186   }
187 
188   /**
189    * @dev Returns the version with the highest semver identifier for the given major.
190    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will return `1.3.0` for major `1`, 
191    * regardless of the order in which they were registered. Returns zero if no versions are registered
192    * for the specified major.
193    * @param major Major identifier to query
194    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
195    */
196   function getLatestByMajor(uint64 major) public view returns (uint64[3] semanticVersion, address contractAddress, bytes contentURI) {
197     Version storage version = versions[majorToLatestVersion[major]];
198     return (version.semanticVersion, version.contractAddress, version.contentURI); 
199   }
200 
201   function semanticVersionHash(uint64[3] version) internal pure returns (bytes32) {
202     return keccak256(abi.encodePacked(version[0], version[1], version[2]));
203   }
204 
205   function semanticVersionIsZero(uint64[3] version) internal pure returns (bool) {
206     return version[0] == 0 && version[1] == 0 && version[2] == 0;
207   }
208 }
209 
210 // File: /home/blackjak/Projects/winding-tree/wt-contracts/node_modules/zos-lib/contracts/upgradeability/Proxy.sol
211 
212 /**
213  * @title Proxy
214  * @dev Implements delegation of calls to other contracts, with proper
215  * forwarding of return values and bubbling of failures.
216  * It defines a fallback function that delegates all calls to the address
217  * returned by the abstract _implementation() internal function.
218  */
219 contract Proxy {
220   /**
221    * @dev Fallback function.
222    * Implemented entirely in `_fallback`.
223    */
224   function () payable external {
225     _fallback();
226   }
227 
228   /**
229    * @return The Address of the implementation.
230    */
231   function _implementation() internal view returns (address);
232 
233   /**
234    * @dev Delegates execution to an implementation contract.
235    * This is a low level function that doesn't return to its internal call site.
236    * It will return to the external caller whatever the implementation returns.
237    * @param implementation Address to delegate.
238    */
239   function _delegate(address implementation) internal {
240     assembly {
241       // Copy msg.data. We take full control of memory in this inline assembly
242       // block because it will not return to Solidity code. We overwrite the
243       // Solidity scratch pad at memory position 0.
244       calldatacopy(0, 0, calldatasize)
245 
246       // Call the implementation.
247       // out and outsize are 0 because we don't know the size yet.
248       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
249 
250       // Copy the returned data.
251       returndatacopy(0, 0, returndatasize)
252 
253       switch result
254       // delegatecall returns 0 on error.
255       case 0 { revert(0, returndatasize) }
256       default { return(0, returndatasize) }
257     }
258   }
259 
260   /**
261    * @dev Function that is run as the first thing in the fallback function.
262    * Can be redefined in derived contracts to add functionality.
263    * Redefinitions must call super._willFallback().
264    */
265   function _willFallback() internal {
266   }
267 
268   /**
269    * @dev fallback implementation.
270    * Extracted to enable manual triggering.
271    */
272   function _fallback() internal {
273     _willFallback();
274     _delegate(_implementation());
275   }
276 }
277 
278 // File: openzeppelin-solidity/contracts/AddressUtils.sol
279 
280 /**
281  * Utility library of inline functions on addresses
282  */
283 library AddressUtils {
284 
285   /**
286    * Returns whether the target address is a contract
287    * @dev This function will return false if invoked during the constructor of a contract,
288    * as the code is not actually created until after the constructor finishes.
289    * @param _addr address to check
290    * @return whether the target address is a contract
291    */
292   function isContract(address _addr) internal view returns (bool) {
293     uint256 size;
294     // XXX Currently there is no better way to check if there is a contract in an address
295     // than to check the size of the code at that address.
296     // See https://ethereum.stackexchange.com/a/14016/36603
297     // for more details about how this works.
298     // TODO Check this again before the Serenity release, because all addresses will be
299     // contracts then.
300     // solium-disable-next-line security/no-inline-assembly
301     assembly { size := extcodesize(_addr) }
302     return size > 0;
303   }
304 
305 }
306 
307 // File: /home/blackjak/Projects/winding-tree/wt-contracts/node_modules/zos-lib/contracts/upgradeability/UpgradeabilityProxy.sol
308 
309 /**
310  * @title UpgradeabilityProxy
311  * @dev This contract implements a proxy that allows to change the
312  * implementation address to which it will delegate.
313  * Such a change is called an implementation upgrade.
314  */
315 contract UpgradeabilityProxy is Proxy {
316   /**
317    * @dev Emitted when the implementation is upgraded.
318    * @param implementation Address of the new implementation.
319    */
320   event Upgraded(address indexed implementation);
321 
322   /**
323    * @dev Storage slot with the address of the current implementation.
324    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
325    * validated in the constructor.
326    */
327   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
328 
329   /**
330    * @dev Contract constructor.
331    * @param _implementation Address of the initial implementation.
332    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
333    * It should include the signature and the parameters of the function to be called, as described in
334    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
335    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
336    */
337   constructor(address _implementation, bytes _data) public payable {
338     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
339     _setImplementation(_implementation);
340     if(_data.length > 0) {
341       require(_implementation.delegatecall(_data));
342     }
343   }
344 
345   /**
346    * @dev Returns the current implementation.
347    * @return Address of the current implementation
348    */
349   function _implementation() internal view returns (address impl) {
350     bytes32 slot = IMPLEMENTATION_SLOT;
351     assembly {
352       impl := sload(slot)
353     }
354   }
355 
356   /**
357    * @dev Upgrades the proxy to a new implementation.
358    * @param newImplementation Address of the new implementation.
359    */
360   function _upgradeTo(address newImplementation) internal {
361     _setImplementation(newImplementation);
362     emit Upgraded(newImplementation);
363   }
364 
365   /**
366    * @dev Sets the implementation address of the proxy.
367    * @param newImplementation Address of the new implementation.
368    */
369   function _setImplementation(address newImplementation) private {
370     require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
371 
372     bytes32 slot = IMPLEMENTATION_SLOT;
373 
374     assembly {
375       sstore(slot, newImplementation)
376     }
377   }
378 }
379 
380 // File: /home/blackjak/Projects/winding-tree/wt-contracts/node_modules/zos-lib/contracts/upgradeability/AdminUpgradeabilityProxy.sol
381 
382 /**
383  * @title AdminUpgradeabilityProxy
384  * @dev This contract combines an upgradeability proxy with an authorization
385  * mechanism for administrative tasks.
386  * All external functions in this contract must be guarded by the
387  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
388  * feature proposal that would enable this to be done automatically.
389  */
390 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
391   /**
392    * @dev Emitted when the administration has been transferred.
393    * @param previousAdmin Address of the previous admin.
394    * @param newAdmin Address of the new admin.
395    */
396   event AdminChanged(address previousAdmin, address newAdmin);
397 
398   /**
399    * @dev Storage slot with the admin of the contract.
400    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
401    * validated in the constructor.
402    */
403   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
404 
405   /**
406    * @dev Modifier to check whether the `msg.sender` is the admin.
407    * If it is, it will run the function. Otherwise, it will delegate the call
408    * to the implementation.
409    */
410   modifier ifAdmin() {
411     if (msg.sender == _admin()) {
412       _;
413     } else {
414       _fallback();
415     }
416   }
417 
418   /**
419    * Contract constructor.
420    * It sets the `msg.sender` as the proxy administrator.
421    * @param _implementation address of the initial implementation.
422    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
423    * It should include the signature and the parameters of the function to be called, as described in
424    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
425    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
426    */
427   constructor(address _implementation, bytes _data) UpgradeabilityProxy(_implementation, _data) public payable {
428     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
429 
430     _setAdmin(msg.sender);
431   }
432 
433   /**
434    * @return The address of the proxy admin.
435    */
436   function admin() external view ifAdmin returns (address) {
437     return _admin();
438   }
439 
440   /**
441    * @return The address of the implementation.
442    */
443   function implementation() external view ifAdmin returns (address) {
444     return _implementation();
445   }
446 
447   /**
448    * @dev Changes the admin of the proxy.
449    * Only the current admin can call this function.
450    * @param newAdmin Address to transfer proxy administration to.
451    */
452   function changeAdmin(address newAdmin) external ifAdmin {
453     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
454     emit AdminChanged(_admin(), newAdmin);
455     _setAdmin(newAdmin);
456   }
457 
458   /**
459    * @dev Upgrade the backing implementation of the proxy.
460    * Only the admin can call this function.
461    * @param newImplementation Address of the new implementation.
462    */
463   function upgradeTo(address newImplementation) external ifAdmin {
464     _upgradeTo(newImplementation);
465   }
466 
467   /**
468    * @dev Upgrade the backing implementation of the proxy and call a function
469    * on the new implementation.
470    * This is useful to initialize the proxied contract.
471    * @param newImplementation Address of the new implementation.
472    * @param data Data to send as msg.data in the low level call.
473    * It should include the signature and the parameters of the function to be called, as described in
474    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
475    */
476   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
477     _upgradeTo(newImplementation);
478     require(newImplementation.delegatecall(data));
479   }
480 
481   /**
482    * @return The admin slot.
483    */
484   function _admin() internal view returns (address adm) {
485     bytes32 slot = ADMIN_SLOT;
486     assembly {
487       adm := sload(slot)
488     }
489   }
490 
491   /**
492    * @dev Sets the address of the proxy admin.
493    * @param newAdmin Address of the new proxy admin.
494    */
495   function _setAdmin(address newAdmin) internal {
496     bytes32 slot = ADMIN_SLOT;
497 
498     assembly {
499       sstore(slot, newAdmin)
500     }
501   }
502 
503   /**
504    * @dev Only fall back when the sender is not the admin.
505    */
506   function _willFallback() internal {
507     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
508     super._willFallback();
509   }
510 }
511 
512 // File: node_modules/zos-lib/contracts/application/App.sol
513 
514 /**
515  * @title App
516  * @dev Contract for upgradeable applications.
517  * It handles the creation and upgrading of proxies.
518  */
519 contract App is Ownable {
520   /**
521    * @dev Emitted when a new proxy is created.
522    * @param proxy Address of the created proxy.
523    */
524   event ProxyCreated(address proxy);
525 
526   /**
527    * @dev Emitted when a package dependency is changed in the application.
528    * @param providerName Name of the package that changed.
529    * @param package Address of the package associated to the name.
530    * @param version Version of the package in use.
531    */
532   event PackageChanged(string providerName, address package, uint64[3] version);
533 
534   /**
535    * @dev Tracks a package in a particular version, used for retrieving implementations
536    */
537   struct ProviderInfo {
538     Package package;
539     uint64[3] version;
540   }
541 
542   /**
543    * @dev Maps from dependency name to a tuple of package and version
544    */
545   mapping(string => ProviderInfo) internal providers;
546 
547   /**
548    * @dev Constructor function.
549    */
550   constructor() public { }
551 
552   /**
553    * @dev Returns the provider for a given package name, or zero if not set.
554    * @param packageName Name of the package to be retrieved.
555    * @return The provider.
556    */
557   function getProvider(string packageName) public view returns (ImplementationProvider provider) {
558     ProviderInfo storage info = providers[packageName];
559     if (address(info.package) == address(0)) return ImplementationProvider(0);
560     return ImplementationProvider(info.package.getContract(info.version));
561   }
562 
563   /**
564    * @dev Returns information on a package given its name.
565    * @param packageName Name of the package to be queried.
566    * @return A tuple with the package address and pinned version given a package name, or zero if not set
567    */
568   function getPackage(string packageName) public view returns (Package, uint64[3]) {
569     ProviderInfo storage info = providers[packageName];
570     return (info.package, info.version);
571   }
572 
573   /**
574    * @dev Sets a package in a specific version as a dependency for this application.
575    * Requires the version to be present in the package.
576    * @param packageName Name of the package to set or overwrite.
577    * @param package Address of the package to register.
578    * @param version Version of the package to use in this application.
579    */
580   function setPackage(string packageName, Package package, uint64[3] version) public onlyOwner {
581     require(package.hasVersion(version), "The requested version must be registered in the given package");
582     providers[packageName] = ProviderInfo(package, version);
583     emit PackageChanged(packageName, package, version);
584   }
585 
586   /**
587    * @dev Unsets a package given its name.
588    * Reverts if the package is not set in the application.
589    * @param packageName Name of the package to remove.
590    */
591   function unsetPackage(string packageName) public onlyOwner {
592     require(address(providers[packageName].package) != address(0), "Package to unset not found");
593     delete providers[packageName];
594     emit PackageChanged(packageName, address(0), [uint64(0), uint64(0), uint64(0)]);
595   }
596 
597   /**
598    * @dev Returns the implementation address for a given contract name, provided by the `ImplementationProvider`.
599    * @param packageName Name of the package where the contract is contained.
600    * @param contractName Name of the contract.
601    * @return Address where the contract is implemented.
602    */
603   function getImplementation(string packageName, string contractName) public view returns (address) {
604     ImplementationProvider provider = getProvider(packageName);
605     if (address(provider) == address(0)) return address(0);
606     return provider.getImplementation(contractName);
607   }
608 
609   /**
610    * @dev Returns the current implementation of a proxy.
611    * This is needed because only the proxy admin can query it.
612    * @return The address of the current implementation of the proxy.
613    */
614   function getProxyImplementation(AdminUpgradeabilityProxy proxy) public view returns (address) {
615     return proxy.implementation();
616   }
617 
618   /**
619    * @dev Returns the admin of a proxy. Only the admin can query it.
620    * @return The address of the current admin of the proxy.
621    */
622   function getProxyAdmin(AdminUpgradeabilityProxy proxy) public view returns (address) {
623     return proxy.admin();
624   }
625 
626   /**
627    * @dev Changes the admin of a proxy.
628    * @param proxy Proxy to change admin.
629    * @param newAdmin Address to transfer proxy administration to.
630    */
631   function changeProxyAdmin(AdminUpgradeabilityProxy proxy, address newAdmin) public onlyOwner {
632     proxy.changeAdmin(newAdmin);
633   }
634 
635   /**
636    * @dev Creates a new proxy for the given contract and forwards a function call to it.
637    * This is useful to initialize the proxied contract.
638    * @param packageName Name of the package where the contract is contained.
639    * @param contractName Name of the contract.
640    * @param data Data to send as msg.data to the corresponding implementation to initialize the proxied contract.
641    * It should include the signature and the parameters of the function to be called, as described in
642    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
643    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
644    * @return Address of the new proxy.
645    */
646    function create(string packageName, string contractName, bytes data) payable public returns (AdminUpgradeabilityProxy) {
647     address implementation = getImplementation(packageName, contractName);
648      AdminUpgradeabilityProxy proxy = (new AdminUpgradeabilityProxy).value(msg.value)(implementation, data);
649      emit ProxyCreated(proxy);
650      return proxy;
651   }
652 
653   /**
654    * @dev Upgrades a proxy to the newest implementation of a contract.
655    * @param proxy Proxy to be upgraded.
656    * @param packageName Name of the package where the contract is contained.
657    * @param contractName Name of the contract.
658    */
659   function upgrade(AdminUpgradeabilityProxy proxy, string packageName, string contractName) public onlyOwner {
660     address implementation = getImplementation(packageName, contractName);
661     proxy.upgradeTo(implementation);
662   }
663 
664   /**
665    * @dev Upgrades a proxy to the newest implementation of a contract and forwards a function call to it.
666    * This is useful to initialize the proxied contract.
667    * @param proxy Proxy to be upgraded.
668    * @param packageName Name of the package where the contract is contained.
669    * @param contractName Name of the contract.
670    * @param data Data to send as msg.data in the low level call.
671    * It should include the signature and the parameters of the function to be called, as described in
672    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
673    */
674   function upgradeAndCall(AdminUpgradeabilityProxy proxy, string packageName, string contractName, bytes data) payable public onlyOwner {
675     address implementation = getImplementation(packageName, contractName);
676     proxy.upgradeToAndCall.value(msg.value)(implementation, data);
677   }
678 }