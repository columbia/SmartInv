1 // File: contracts/application/ImplementationProvider.sol
2 
3 pragma solidity ^0.4.24;
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
20 pragma solidity ^0.4.23;
21 
22 
23 /**
24  * @title Ownable
25  * @dev The Ownable contract has an owner address, and provides basic authorization control
26  * functions, this simplifies the implementation of "user permissions".
27  */
28 contract Ownable {
29   address public owner;
30 
31 
32   event OwnershipRenounced(address indexed previousOwner);
33   event OwnershipTransferred(
34     address indexed previousOwner,
35     address indexed newOwner
36   );
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   constructor() public {
44     owner = msg.sender;
45   }
46 
47   /**
48    * @dev Throws if called by any account other than the owner.
49    */
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55   /**
56    * @dev Allows the current owner to relinquish control of the contract.
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
82 // File: contracts/application/Package.sol
83 
84 pragma solidity ^0.4.24;
85 
86 
87 /**
88  * @title Package
89  * @dev A package is composed by a set of versions, identified via semantic versioning,
90  * where each version has a contract address that refers to a reusable implementation,
91  * plus an optional content URI with metadata. Note that the semver identifier is restricted
92  * to major, minor, and patch, as prerelease tags are not supported.
93  */
94 contract Package is Ownable {
95   /**
96    * @dev Emitted when a version is added to the package.
97    * @param semanticVersion Name of the added version.
98    * @param contractAddress Contract associated with the version.
99    * @param contentURI Optional content URI with metadata of the version.
100    */
101   event VersionAdded(uint64[3] semanticVersion, address contractAddress, bytes contentURI);
102 
103   struct Version {
104     uint64[3] semanticVersion;
105     address contractAddress;
106     bytes contentURI; 
107   }
108 
109   mapping (bytes32 => Version) internal versions;
110   mapping (uint64 => bytes32) internal majorToLatestVersion;
111   uint64 internal latestMajor;
112 
113   /**
114    * @dev Returns a version given its semver identifier.
115    * @param semanticVersion Semver identifier of the version.
116    * @return Contract address and content URI for the version, or zero if not exists.
117    */
118   function getVersion(uint64[3] semanticVersion) public view returns (address contractAddress, bytes contentURI) {
119     Version storage version = versions[semanticVersionHash(semanticVersion)];
120     return (version.contractAddress, version.contentURI); 
121   }
122 
123   /**
124    * @dev Returns a contract for a version given its semver identifier.
125    * This method is equivalent to `getVersion`, but returns only the contract address.
126    * @param semanticVersion Semver identifier of the version.
127    * @return Contract address for the version, or zero if not exists.
128    */
129   function getContract(uint64[3] semanticVersion) public view returns (address contractAddress) {
130     Version storage version = versions[semanticVersionHash(semanticVersion)];
131     return version.contractAddress;
132   }
133 
134   /**
135    * @dev Adds a new version to the package. Only the Owner can add new versions.
136    * Reverts if the specified semver identifier already exists. 
137    * Emits a `VersionAdded` event if successful.
138    * @param semanticVersion Semver identifier of the version.
139    * @param contractAddress Contract address for the version, must be non-zero.
140    * @param contentURI Optional content URI for the version.
141    */
142   function addVersion(uint64[3] semanticVersion, address contractAddress, bytes contentURI) public onlyOwner {
143     require(contractAddress != address(0), "Contract address is required");
144     require(!hasVersion(semanticVersion), "Given version is already registered in package");
145     require(!semanticVersionIsZero(semanticVersion), "Version must be non zero");
146 
147     // Register version
148     bytes32 versionId = semanticVersionHash(semanticVersion);
149     versions[versionId] = Version(semanticVersion, contractAddress, contentURI);
150     
151     // Update latest major
152     uint64 major = semanticVersion[0];
153     if (major > latestMajor) {
154       latestMajor = semanticVersion[0];
155     }
156 
157     // Update latest version for this major
158     uint64 minor = semanticVersion[1];
159     uint64 patch = semanticVersion[2];
160     uint64[3] latestVersionForMajor = versions[majorToLatestVersion[major]].semanticVersion;
161     if (semanticVersionIsZero(latestVersionForMajor) // No latest was set for this major
162        || (minor > latestVersionForMajor[1]) // Or current minor is greater 
163        || (minor == latestVersionForMajor[1] && patch > latestVersionForMajor[2]) // Or current patch is greater
164        ) { 
165       majorToLatestVersion[major] = versionId;
166     }
167 
168     emit VersionAdded(semanticVersion, contractAddress, contentURI);
169   }
170 
171   /**
172    * @dev Checks whether a version is present in the package.
173    * @param semanticVersion Semver identifier of the version.
174    * @return true if the version is registered in this package, false otherwise.
175    */
176   function hasVersion(uint64[3] semanticVersion) public view returns (bool) {
177     Version storage version = versions[semanticVersionHash(semanticVersion)];
178     return address(version.contractAddress) != address(0);
179   }
180 
181   /**
182    * @dev Returns the version with the highest semver identifier registered in the package.
183    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will always return `2.0.0`, regardless 
184    * of the order in which they were registered. Returns zero if no versions are registered.
185    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
186    */
187   function getLatest() public view returns (uint64[3] semanticVersion, address contractAddress, bytes contentURI) {
188     return getLatestByMajor(latestMajor);
189   }
190 
191   /**
192    * @dev Returns the version with the highest semver identifier for the given major.
193    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will return `1.3.0` for major `1`, 
194    * regardless of the order in which they were registered. Returns zero if no versions are registered
195    * for the specified major.
196    * @param major Major identifier to query
197    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
198    */
199   function getLatestByMajor(uint64 major) public view returns (uint64[3] semanticVersion, address contractAddress, bytes contentURI) {
200     Version storage version = versions[majorToLatestVersion[major]];
201     return (version.semanticVersion, version.contractAddress, version.contentURI); 
202   }
203 
204   function semanticVersionHash(uint64[3] version) internal pure returns (bytes32) {
205     return keccak256(abi.encodePacked(version[0], version[1], version[2]));
206   }
207 
208   function semanticVersionIsZero(uint64[3] version) internal pure returns (bool) {
209     return version[0] == 0 && version[1] == 0 && version[2] == 0;
210   }
211 }
212 
213 // File: contracts/upgradeability/Proxy.sol
214 
215 pragma solidity ^0.4.24;
216 
217 /**
218  * @title Proxy
219  * @dev Implements delegation of calls to other contracts, with proper
220  * forwarding of return values and bubbling of failures.
221  * It defines a fallback function that delegates all calls to the address
222  * returned by the abstract _implementation() internal function.
223  */
224 contract Proxy {
225   /**
226    * @dev Fallback function.
227    * Implemented entirely in `_fallback`.
228    */
229   function () payable external {
230     _fallback();
231   }
232 
233   /**
234    * @return The Address of the implementation.
235    */
236   function _implementation() internal view returns (address);
237 
238   /**
239    * @dev Delegates execution to an implementation contract.
240    * This is a low level function that doesn't return to its internal call site.
241    * It will return to the external caller whatever the implementation returns.
242    * @param implementation Address to delegate.
243    */
244   function _delegate(address implementation) internal {
245     assembly {
246       // Copy msg.data. We take full control of memory in this inline assembly
247       // block because it will not return to Solidity code. We overwrite the
248       // Solidity scratch pad at memory position 0.
249       calldatacopy(0, 0, calldatasize)
250 
251       // Call the implementation.
252       // out and outsize are 0 because we don't know the size yet.
253       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
254 
255       // Copy the returned data.
256       returndatacopy(0, 0, returndatasize)
257 
258       switch result
259       // delegatecall returns 0 on error.
260       case 0 { revert(0, returndatasize) }
261       default { return(0, returndatasize) }
262     }
263   }
264 
265   /**
266    * @dev Function that is run as the first thing in the fallback function.
267    * Can be redefined in derived contracts to add functionality.
268    * Redefinitions must call super._willFallback().
269    */
270   function _willFallback() internal {
271   }
272 
273   /**
274    * @dev fallback implementation.
275    * Extracted to enable manual triggering.
276    */
277   function _fallback() internal {
278     _willFallback();
279     _delegate(_implementation());
280   }
281 }
282 
283 // File: openzeppelin-solidity/contracts/AddressUtils.sol
284 
285 pragma solidity ^0.4.23;
286 
287 
288 /**
289  * Utility library of inline functions on addresses
290  */
291 library AddressUtils {
292 
293   /**
294    * Returns whether the target address is a contract
295    * @dev This function will return false if invoked during the constructor of a contract,
296    *  as the code is not actually created until after the constructor finishes.
297    * @param addr address to check
298    * @return whether the target address is a contract
299    */
300   function isContract(address addr) internal view returns (bool) {
301     uint256 size;
302     // XXX Currently there is no better way to check if there is a contract in an address
303     // than to check the size of the code at that address.
304     // See https://ethereum.stackexchange.com/a/14016/36603
305     // for more details about how this works.
306     // TODO Check this again before the Serenity release, because all addresses will be
307     // contracts then.
308     // solium-disable-next-line security/no-inline-assembly
309     assembly { size := extcodesize(addr) }
310     return size > 0;
311   }
312 
313 }
314 
315 // File: contracts/upgradeability/UpgradeabilityProxy.sol
316 
317 pragma solidity ^0.4.24;
318 
319 
320 
321 /**
322  * @title UpgradeabilityProxy
323  * @dev This contract implements a proxy that allows to change the
324  * implementation address to which it will delegate.
325  * Such a change is called an implementation upgrade.
326  */
327 contract UpgradeabilityProxy is Proxy {
328   /**
329    * @dev Emitted when the implementation is upgraded.
330    * @param implementation Address of the new implementation.
331    */
332   event Upgraded(address indexed implementation);
333 
334   /**
335    * @dev Storage slot with the address of the current implementation.
336    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
337    * validated in the constructor.
338    */
339   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
340 
341   /**
342    * @dev Contract constructor.
343    * @param _implementation Address of the initial implementation.
344    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
345    * It should include the signature and the parameters of the function to be called, as described in
346    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
347    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
348    */
349   constructor(address _implementation, bytes _data) public payable {
350     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
351     _setImplementation(_implementation);
352     if(_data.length > 0) {
353       require(_implementation.delegatecall(_data));
354     }
355   }
356 
357   /**
358    * @dev Returns the current implementation.
359    * @return Address of the current implementation
360    */
361   function _implementation() internal view returns (address impl) {
362     bytes32 slot = IMPLEMENTATION_SLOT;
363     assembly {
364       impl := sload(slot)
365     }
366   }
367 
368   /**
369    * @dev Upgrades the proxy to a new implementation.
370    * @param newImplementation Address of the new implementation.
371    */
372   function _upgradeTo(address newImplementation) internal {
373     _setImplementation(newImplementation);
374     emit Upgraded(newImplementation);
375   }
376 
377   /**
378    * @dev Sets the implementation address of the proxy.
379    * @param newImplementation Address of the new implementation.
380    */
381   function _setImplementation(address newImplementation) private {
382     require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
383 
384     bytes32 slot = IMPLEMENTATION_SLOT;
385 
386     assembly {
387       sstore(slot, newImplementation)
388     }
389   }
390 }
391 
392 // File: contracts/upgradeability/AdminUpgradeabilityProxy.sol
393 
394 pragma solidity ^0.4.24;
395 
396 
397 /**
398  * @title AdminUpgradeabilityProxy
399  * @dev This contract combines an upgradeability proxy with an authorization
400  * mechanism for administrative tasks.
401  * All external functions in this contract must be guarded by the
402  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
403  * feature proposal that would enable this to be done automatically.
404  */
405 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
406   /**
407    * @dev Emitted when the administration has been transferred.
408    * @param previousAdmin Address of the previous admin.
409    * @param newAdmin Address of the new admin.
410    */
411   event AdminChanged(address previousAdmin, address newAdmin);
412 
413   /**
414    * @dev Storage slot with the admin of the contract.
415    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
416    * validated in the constructor.
417    */
418   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
419 
420   /**
421    * @dev Modifier to check whether the `msg.sender` is the admin.
422    * If it is, it will run the function. Otherwise, it will delegate the call
423    * to the implementation.
424    */
425   modifier ifAdmin() {
426     if (msg.sender == _admin()) {
427       _;
428     } else {
429       _fallback();
430     }
431   }
432 
433   /**
434    * Contract constructor.
435    * @param _implementation address of the initial implementation.
436    * @param _admin Address of the proxy administrator.
437    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
438    * It should include the signature and the parameters of the function to be called, as described in
439    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
440    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
441    */
442   constructor(address _implementation, address _admin, bytes _data) UpgradeabilityProxy(_implementation, _data) public payable {
443     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
444 
445     _setAdmin(_admin);
446   }
447 
448   /**
449    * @return The address of the proxy admin.
450    */
451   function admin() external view ifAdmin returns (address) {
452     return _admin();
453   }
454 
455   /**
456    * @return The address of the implementation.
457    */
458   function implementation() external view ifAdmin returns (address) {
459     return _implementation();
460   }
461 
462   /**
463    * @dev Changes the admin of the proxy.
464    * Only the current admin can call this function.
465    * @param newAdmin Address to transfer proxy administration to.
466    */
467   function changeAdmin(address newAdmin) external ifAdmin {
468     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
469     emit AdminChanged(_admin(), newAdmin);
470     _setAdmin(newAdmin);
471   }
472 
473   /**
474    * @dev Upgrade the backing implementation of the proxy.
475    * Only the admin can call this function.
476    * @param newImplementation Address of the new implementation.
477    */
478   function upgradeTo(address newImplementation) external ifAdmin {
479     _upgradeTo(newImplementation);
480   }
481 
482   /**
483    * @dev Upgrade the backing implementation of the proxy and call a function
484    * on the new implementation.
485    * This is useful to initialize the proxied contract.
486    * @param newImplementation Address of the new implementation.
487    * @param data Data to send as msg.data in the low level call.
488    * It should include the signature and the parameters of the function to be called, as described in
489    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
490    */
491   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
492     _upgradeTo(newImplementation);
493     require(newImplementation.delegatecall(data));
494   }
495 
496   /**
497    * @return The admin slot.
498    */
499   function _admin() internal view returns (address adm) {
500     bytes32 slot = ADMIN_SLOT;
501     assembly {
502       adm := sload(slot)
503     }
504   }
505 
506   /**
507    * @dev Sets the address of the proxy admin.
508    * @param newAdmin Address of the new proxy admin.
509    */
510   function _setAdmin(address newAdmin) internal {
511     bytes32 slot = ADMIN_SLOT;
512 
513     assembly {
514       sstore(slot, newAdmin)
515     }
516   }
517 
518   /**
519    * @dev Only fall back when the sender is not the admin.
520    */
521   function _willFallback() internal {
522     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
523     super._willFallback();
524   }
525 }
526 
527 // File: contracts/application/App.sol
528 
529 pragma solidity ^0.4.24;
530 
531 
532 
533 
534 
535 /**
536  * @title App
537  * @dev Contract for upgradeable applications.
538  * It handles the creation of proxies.
539  */
540 contract App is Ownable {
541   /**
542    * @dev Emitted when a new proxy is created.
543    * @param proxy Address of the created proxy.
544    */
545   event ProxyCreated(address proxy);
546 
547   /**
548    * @dev Emitted when a package dependency is changed in the application.
549    * @param providerName Name of the package that changed.
550    * @param package Address of the package associated to the name.
551    * @param version Version of the package in use.
552    */
553   event PackageChanged(string providerName, address package, uint64[3] version);
554 
555   /**
556    * @dev Tracks a package in a particular version, used for retrieving implementations
557    */
558   struct ProviderInfo {
559     Package package;
560     uint64[3] version;
561   }
562 
563   /**
564    * @dev Maps from dependency name to a tuple of package and version
565    */
566   mapping(string => ProviderInfo) internal providers;
567 
568   /**
569    * @dev Constructor function.
570    */
571   constructor() public { }
572 
573   /**
574    * @dev Returns the provider for a given package name, or zero if not set.
575    * @param packageName Name of the package to be retrieved.
576    * @return The provider.
577    */
578   function getProvider(string packageName) public view returns (ImplementationProvider provider) {
579     ProviderInfo storage info = providers[packageName];
580     if (address(info.package) == address(0)) return ImplementationProvider(0);
581     return ImplementationProvider(info.package.getContract(info.version));
582   }
583 
584   /**
585    * @dev Returns information on a package given its name.
586    * @param packageName Name of the package to be queried.
587    * @return A tuple with the package address and pinned version given a package name, or zero if not set
588    */
589   function getPackage(string packageName) public view returns (Package, uint64[3]) {
590     ProviderInfo storage info = providers[packageName];
591     return (info.package, info.version);
592   }
593 
594   /**
595    * @dev Sets a package in a specific version as a dependency for this application.
596    * Requires the version to be present in the package.
597    * @param packageName Name of the package to set or overwrite.
598    * @param package Address of the package to register.
599    * @param version Version of the package to use in this application.
600    */
601   function setPackage(string packageName, Package package, uint64[3] version) public onlyOwner {
602     require(package.hasVersion(version), "The requested version must be registered in the given package");
603     providers[packageName] = ProviderInfo(package, version);
604     emit PackageChanged(packageName, package, version);
605   }
606 
607   /**
608    * @dev Unsets a package given its name.
609    * Reverts if the package is not set in the application.
610    * @param packageName Name of the package to remove.
611    */
612   function unsetPackage(string packageName) public onlyOwner {
613     require(address(providers[packageName].package) != address(0), "Package to unset not found");
614     delete providers[packageName];
615     emit PackageChanged(packageName, address(0), [uint64(0), uint64(0), uint64(0)]);
616   }
617 
618   /**
619    * @dev Returns the implementation address for a given contract name, provided by the `ImplementationProvider`.
620    * @param packageName Name of the package where the contract is contained.
621    * @param contractName Name of the contract.
622    * @return Address where the contract is implemented.
623    */
624   function getImplementation(string packageName, string contractName) public view returns (address) {
625     ImplementationProvider provider = getProvider(packageName);
626     if (address(provider) == address(0)) return address(0);
627     return provider.getImplementation(contractName);
628   }
629 
630   /**
631    * @dev Creates a new proxy for the given contract and forwards a function call to it.
632    * This is useful to initialize the proxied contract.
633    * @param packageName Name of the package where the contract is contained.
634    * @param contractName Name of the contract.
635    * @param admin Address of the proxy administrator.
636    * @param data Data to send as msg.data to the corresponding implementation to initialize the proxied contract.
637    * It should include the signature and the parameters of the function to be called, as described in
638    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
639    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
640    * @return Address of the new proxy.
641    */
642    function create(string packageName, string contractName, address admin, bytes data) payable public returns (AdminUpgradeabilityProxy) {
643      address implementation = getImplementation(packageName, contractName);
644      AdminUpgradeabilityProxy proxy = (new AdminUpgradeabilityProxy).value(msg.value)(implementation, admin, data);
645      emit ProxyCreated(proxy);
646      return proxy;
647   }
648 }