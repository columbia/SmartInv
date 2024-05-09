1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  D:\MDZA-TESTNET1\solidity-flattener\SolidityFlatteryGo\zos-lib\contracts\application\App.sol
6 // flattened :  Tuesday, 09-Apr-19 18:16:04 UTC
7 contract Proxy {
8   /**
9    * @dev Fallback function.
10    * Implemented entirely in `_fallback`.
11    */
12   function () payable external {
13     _fallback();
14   }
15 
16   /**
17    * @return The Address of the implementation.
18    */
19   function _implementation() internal view returns (address);
20 
21   /**
22    * @dev Delegates execution to an implementation contract.
23    * This is a low level function that doesn't return to its internal call site.
24    * It will return to the external caller whatever the implementation returns.
25    * @param implementation Address to delegate.
26    */
27   function _delegate(address implementation) internal {
28     assembly {
29       // Copy msg.data. We take full control of memory in this inline assembly
30       // block because it will not return to Solidity code. We overwrite the
31       // Solidity scratch pad at memory position 0.
32       calldatacopy(0, 0, calldatasize)
33 
34       // Call the implementation.
35       // out and outsize are 0 because we don't know the size yet.
36       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
37 
38       // Copy the returned data.
39       returndatacopy(0, 0, returndatasize)
40 
41       switch result
42       // delegatecall returns 0 on error.
43       case 0 { revert(0, returndatasize) }
44       default { return(0, returndatasize) }
45     }
46   }
47 
48   /**
49    * @dev Function that is run as the first thing in the fallback function.
50    * Can be redefined in derived contracts to add functionality.
51    * Redefinitions must call super._willFallback().
52    */
53   function _willFallback() internal {
54   }
55 
56   /**
57    * @dev fallback implementation.
58    * Extracted to enable manual triggering.
59    */
60   function _fallback() internal {
61     _willFallback();
62     _delegate(_implementation());
63   }
64 }
65 
66 library ZOSLibAddress {
67 
68   /**
69    * Returns whether the target address is a contract
70    * @dev This function will return false if invoked during the constructor of a contract,
71    * as the code is not actually created until after the constructor finishes.
72    * @param account address of the account to check
73    * @return whether the target address is a contract
74    */
75   function isContract(address account) internal view returns (bool) {
76     uint256 size;
77     // XXX Currently there is no better way to check if there is a contract in an address
78     // than to check the size of the code at that address.
79     // See https://ethereum.stackexchange.com/a/14016/36603
80     // for more details about how this works.
81     // TODO Check this again before the Serenity release, because all addresses will be
82     // contracts then.
83     // solium-disable-next-line security/no-inline-assembly
84     assembly { size := extcodesize(account) }
85     return size > 0;
86   }
87 
88 }
89 interface ImplementationProvider {
90   /**
91    * @dev Abstract function to return the implementation address of a contract.
92    * @param contractName Name of the contract.
93    * @return Implementation address of the contract.
94    */
95   function getImplementation(string contractName) public view returns (address);
96 }
97 
98 
99 contract ZOSLibOwnable {
100   address private _owner;
101 
102   event OwnershipTransferred(
103     address indexed previousOwner,
104     address indexed newOwner
105   );
106 
107   /**
108    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
109    * account.
110    */
111   constructor() internal {
112     _owner = msg.sender;
113     emit OwnershipTransferred(address(0), _owner);
114   }
115 
116   /**
117    * @return the address of the owner.
118    */
119   function owner() public view returns(address) {
120     return _owner;
121   }
122 
123   /**
124    * @dev Throws if called by any account other than the owner.
125    */
126   modifier onlyOwner() {
127     require(isOwner());
128     _;
129   }
130 
131   /**
132    * @return true if `msg.sender` is the owner of the contract.
133    */
134   function isOwner() public view returns(bool) {
135     return msg.sender == _owner;
136   }
137 
138   /**
139    * @dev Allows the current owner to relinquish control of the contract.
140    * @notice Renouncing to ownership will leave the contract without an owner.
141    * It will not be possible to call the functions with the `onlyOwner`
142    * modifier anymore.
143    */
144   function renounceOwnership() public onlyOwner {
145     emit OwnershipTransferred(_owner, address(0));
146     _owner = address(0);
147   }
148 
149   /**
150    * @dev Allows the current owner to transfer control of the contract to a newOwner.
151    * @param newOwner The address to transfer ownership to.
152    */
153   function transferOwnership(address newOwner) public onlyOwner {
154     _transferOwnership(newOwner);
155   }
156 
157   /**
158    * @dev Transfers control of the contract to a newOwner.
159    * @param newOwner The address to transfer ownership to.
160    */
161   function _transferOwnership(address newOwner) internal {
162     require(newOwner != address(0));
163     emit OwnershipTransferred(_owner, newOwner);
164     _owner = newOwner;
165   }
166 }
167 contract Package is ZOSLibOwnable {
168   /**
169    * @dev Emitted when a version is added to the package.
170    * @param semanticVersion Name of the added version.
171    * @param contractAddress Contract associated with the version.
172    * @param contentURI Optional content URI with metadata of the version.
173    */
174   event VersionAdded(uint64[3] semanticVersion, address contractAddress, bytes contentURI);
175 
176   struct Version {
177     uint64[3] semanticVersion;
178     address contractAddress;
179     bytes contentURI; 
180   }
181 
182   mapping (bytes32 => Version) internal versions;
183   mapping (uint64 => bytes32) internal majorToLatestVersion;
184   uint64 internal latestMajor;
185 
186   /**
187    * @dev Returns a version given its semver identifier.
188    * @param semanticVersion Semver identifier of the version.
189    * @return Contract address and content URI for the version, or zero if not exists.
190    */
191   function getVersion(uint64[3] semanticVersion) public view returns (address contractAddress, bytes contentURI) {
192     Version storage version = versions[semanticVersionHash(semanticVersion)];
193     return (version.contractAddress, version.contentURI); 
194   }
195 
196   /**
197    * @dev Returns a contract for a version given its semver identifier.
198    * This method is equivalent to `getVersion`, but returns only the contract address.
199    * @param semanticVersion Semver identifier of the version.
200    * @return Contract address for the version, or zero if not exists.
201    */
202   function getContract(uint64[3] semanticVersion) public view returns (address contractAddress) {
203     Version storage version = versions[semanticVersionHash(semanticVersion)];
204     return version.contractAddress;
205   }
206 
207   /**
208    * @dev Adds a new version to the package. Only the Owner can add new versions.
209    * Reverts if the specified semver identifier already exists. 
210    * Emits a `VersionAdded` event if successful.
211    * @param semanticVersion Semver identifier of the version.
212    * @param contractAddress Contract address for the version, must be non-zero.
213    * @param contentURI Optional content URI for the version.
214    */
215   function addVersion(uint64[3] semanticVersion, address contractAddress, bytes contentURI) public onlyOwner {
216     require(contractAddress != address(0), "Contract address is required");
217     require(!hasVersion(semanticVersion), "Given version is already registered in package");
218     require(!semanticVersionIsZero(semanticVersion), "Version must be non zero");
219 
220     // Register version
221     bytes32 versionId = semanticVersionHash(semanticVersion);
222     versions[versionId] = Version(semanticVersion, contractAddress, contentURI);
223     
224     // Update latest major
225     uint64 major = semanticVersion[0];
226     if (major > latestMajor) {
227       latestMajor = semanticVersion[0];
228     }
229 
230     // Update latest version for this major
231     uint64 minor = semanticVersion[1];
232     uint64 patch = semanticVersion[2];
233     uint64[3] latestVersionForMajor = versions[majorToLatestVersion[major]].semanticVersion;
234     if (semanticVersionIsZero(latestVersionForMajor) // No latest was set for this major
235        || (minor > latestVersionForMajor[1]) // Or current minor is greater 
236        || (minor == latestVersionForMajor[1] && patch > latestVersionForMajor[2]) // Or current patch is greater
237        ) { 
238       majorToLatestVersion[major] = versionId;
239     }
240 
241     emit VersionAdded(semanticVersion, contractAddress, contentURI);
242   }
243 
244   /**
245    * @dev Checks whether a version is present in the package.
246    * @param semanticVersion Semver identifier of the version.
247    * @return true if the version is registered in this package, false otherwise.
248    */
249   function hasVersion(uint64[3] semanticVersion) public view returns (bool) {
250     Version storage version = versions[semanticVersionHash(semanticVersion)];
251     return address(version.contractAddress) != address(0);
252   }
253 
254   /**
255    * @dev Returns the version with the highest semver identifier registered in the package.
256    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will always return `2.0.0`, regardless 
257    * of the order in which they were registered. Returns zero if no versions are registered.
258    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
259    */
260   function getLatest() public view returns (uint64[3] semanticVersion, address contractAddress, bytes contentURI) {
261     return getLatestByMajor(latestMajor);
262   }
263 
264   /**
265    * @dev Returns the version with the highest semver identifier for the given major.
266    * For instance, if `1.2.0`, `1.3.0`, and `2.0.0` are present, will return `1.3.0` for major `1`, 
267    * regardless of the order in which they were registered. Returns zero if no versions are registered
268    * for the specified major.
269    * @param major Major identifier to query
270    * @return Semver identifier, contract address, and content URI for the version, or zero if not exists.
271    */
272   function getLatestByMajor(uint64 major) public view returns (uint64[3] semanticVersion, address contractAddress, bytes contentURI) {
273     Version storage version = versions[majorToLatestVersion[major]];
274     return (version.semanticVersion, version.contractAddress, version.contentURI); 
275   }
276 
277   function semanticVersionHash(uint64[3] version) internal pure returns (bytes32) {
278     return keccak256(abi.encodePacked(version[0], version[1], version[2]));
279   }
280 
281   function semanticVersionIsZero(uint64[3] version) internal pure returns (bool) {
282     return version[0] == 0 && version[1] == 0 && version[2] == 0;
283   }
284 }
285 
286 contract UpgradeabilityProxy is Proxy {
287   /**
288    * @dev Emitted when the implementation is upgraded.
289    * @param implementation Address of the new implementation.
290    */
291   event Upgraded(address indexed implementation);
292 
293   /**
294    * @dev Storage slot with the address of the current implementation.
295    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
296    * validated in the constructor.
297    */
298   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
299 
300   /**
301    * @dev Contract constructor.
302    * @param _implementation Address of the initial implementation.
303    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
304    * It should include the signature and the parameters of the function to be called, as described in
305    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
306    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
307    */
308   constructor(address _implementation, bytes _data) public payable {
309     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
310     _setImplementation(_implementation);
311     if(_data.length > 0) {
312       require(_implementation.delegatecall(_data));
313     }
314   }
315 
316   /**
317    * @dev Returns the current implementation.
318    * @return Address of the current implementation
319    */
320   function _implementation() internal view returns (address impl) {
321     bytes32 slot = IMPLEMENTATION_SLOT;
322     assembly {
323       impl := sload(slot)
324     }
325   }
326 
327   /**
328    * @dev Upgrades the proxy to a new implementation.
329    * @param newImplementation Address of the new implementation.
330    */
331   function _upgradeTo(address newImplementation) internal {
332     _setImplementation(newImplementation);
333     emit Upgraded(newImplementation);
334   }
335 
336   /**
337    * @dev Sets the implementation address of the proxy.
338    * @param newImplementation Address of the new implementation.
339    */
340   function _setImplementation(address newImplementation) private {
341     require(ZOSLibAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
342 
343     bytes32 slot = IMPLEMENTATION_SLOT;
344 
345     assembly {
346       sstore(slot, newImplementation)
347     }
348   }
349 }
350 
351 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
352   /**
353    * @dev Emitted when the administration has been transferred.
354    * @param previousAdmin Address of the previous admin.
355    * @param newAdmin Address of the new admin.
356    */
357   event AdminChanged(address previousAdmin, address newAdmin);
358 
359   /**
360    * @dev Storage slot with the admin of the contract.
361    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
362    * validated in the constructor.
363    */
364   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
365 
366   /**
367    * @dev Modifier to check whether the `msg.sender` is the admin.
368    * If it is, it will run the function. Otherwise, it will delegate the call
369    * to the implementation.
370    */
371   modifier ifAdmin() {
372     if (msg.sender == _admin()) {
373       _;
374     } else {
375       _fallback();
376     }
377   }
378 
379   /**
380    * Contract constructor.
381    * @param _implementation address of the initial implementation.
382    * @param _admin Address of the proxy administrator.
383    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
384    * It should include the signature and the parameters of the function to be called, as described in
385    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
386    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
387    */
388   constructor(address _implementation, address _admin, bytes _data) UpgradeabilityProxy(_implementation, _data) public payable {
389     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
390 
391     _setAdmin(_admin);
392   }
393 
394   /**
395    * @return The address of the proxy admin.
396    */
397   function admin() external view ifAdmin returns (address) {
398     return _admin();
399   }
400 
401   /**
402    * @return The address of the implementation.
403    */
404   function implementation() external view ifAdmin returns (address) {
405     return _implementation();
406   }
407 
408   /**
409    * @dev Changes the admin of the proxy.
410    * Only the current admin can call this function.
411    * @param newAdmin Address to transfer proxy administration to.
412    */
413   function changeAdmin(address newAdmin) external ifAdmin {
414     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
415     emit AdminChanged(_admin(), newAdmin);
416     _setAdmin(newAdmin);
417   }
418 
419   /**
420    * @dev Upgrade the backing implementation of the proxy.
421    * Only the admin can call this function.
422    * @param newImplementation Address of the new implementation.
423    */
424   function upgradeTo(address newImplementation) external ifAdmin {
425     _upgradeTo(newImplementation);
426   }
427 
428   /**
429    * @dev Upgrade the backing implementation of the proxy and call a function
430    * on the new implementation.
431    * This is useful to initialize the proxied contract.
432    * @param newImplementation Address of the new implementation.
433    * @param data Data to send as msg.data in the low level call.
434    * It should include the signature and the parameters of the function to be called, as described in
435    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
436    */
437   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
438     _upgradeTo(newImplementation);
439     require(newImplementation.delegatecall(data));
440   }
441 
442   /**
443    * @return The admin slot.
444    */
445   function _admin() internal view returns (address adm) {
446     bytes32 slot = ADMIN_SLOT;
447     assembly {
448       adm := sload(slot)
449     }
450   }
451 
452   /**
453    * @dev Sets the address of the proxy admin.
454    * @param newAdmin Address of the new proxy admin.
455    */
456   function _setAdmin(address newAdmin) internal {
457     bytes32 slot = ADMIN_SLOT;
458 
459     assembly {
460       sstore(slot, newAdmin)
461     }
462   }
463 
464   /**
465    * @dev Only fall back when the sender is not the admin.
466    */
467   function _willFallback() internal {
468     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
469     super._willFallback();
470   }
471 }
472 
473 contract App is ZOSLibOwnable {
474   /**
475    * @dev Emitted when a new proxy is created.
476    * @param proxy Address of the created proxy.
477    */
478   event ProxyCreated(address proxy);
479 
480   /**
481    * @dev Emitted when a package dependency is changed in the application.
482    * @param providerName Name of the package that changed.
483    * @param package Address of the package associated to the name.
484    * @param version Version of the package in use.
485    */
486   event PackageChanged(string providerName, address package, uint64[3] version);
487 
488   /**
489    * @dev Tracks a package in a particular version, used for retrieving implementations
490    */
491   struct ProviderInfo {
492     Package package;
493     uint64[3] version;
494   }
495 
496   /**
497    * @dev Maps from dependency name to a tuple of package and version
498    */
499   mapping(string => ProviderInfo) internal providers;
500 
501   /**
502    * @dev Constructor function.
503    */
504   constructor() public { }
505 
506   /**
507    * @dev Returns the provider for a given package name, or zero if not set.
508    * @param packageName Name of the package to be retrieved.
509    * @return The provider.
510    */
511   function getProvider(string packageName) public view returns (ImplementationProvider provider) {
512     ProviderInfo storage info = providers[packageName];
513     if (address(info.package) == address(0)) return ImplementationProvider(0);
514     return ImplementationProvider(info.package.getContract(info.version));
515   }
516 
517   /**
518    * @dev Returns information on a package given its name.
519    * @param packageName Name of the package to be queried.
520    * @return A tuple with the package address and pinned version given a package name, or zero if not set
521    */
522   function getPackage(string packageName) public view returns (Package, uint64[3]) {
523     ProviderInfo storage info = providers[packageName];
524     return (info.package, info.version);
525   }
526 
527   /**
528    * @dev Sets a package in a specific version as a dependency for this application.
529    * Requires the version to be present in the package.
530    * @param packageName Name of the package to set or overwrite.
531    * @param package Address of the package to register.
532    * @param version Version of the package to use in this application.
533    */
534   function setPackage(string packageName, Package package, uint64[3] version) public onlyOwner {
535     require(package.hasVersion(version), "The requested version must be registered in the given package");
536     providers[packageName] = ProviderInfo(package, version);
537     emit PackageChanged(packageName, package, version);
538   }
539 
540   /**
541    * @dev Unsets a package given its name.
542    * Reverts if the package is not set in the application.
543    * @param packageName Name of the package to remove.
544    */
545   function unsetPackage(string packageName) public onlyOwner {
546     require(address(providers[packageName].package) != address(0), "Package to unset not found");
547     delete providers[packageName];
548     emit PackageChanged(packageName, address(0), [uint64(0), uint64(0), uint64(0)]);
549   }
550 
551   /**
552    * @dev Returns the implementation address for a given contract name, provided by the `ImplementationProvider`.
553    * @param packageName Name of the package where the contract is contained.
554    * @param contractName Name of the contract.
555    * @return Address where the contract is implemented.
556    */
557   function getImplementation(string packageName, string contractName) public view returns (address) {
558     ImplementationProvider provider = getProvider(packageName);
559     if (address(provider) == address(0)) return address(0);
560     return provider.getImplementation(contractName);
561   }
562 
563   /**
564    * @dev Creates a new proxy for the given contract and forwards a function call to it.
565    * This is useful to initialize the proxied contract.
566    * @param packageName Name of the package where the contract is contained.
567    * @param contractName Name of the contract.
568    * @param admin Address of the proxy administrator.
569    * @param data Data to send as msg.data to the corresponding implementation to initialize the proxied contract.
570    * It should include the signature and the parameters of the function to be called, as described in
571    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
572    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
573    * @return Address of the new proxy.
574    */
575    function create(string packageName, string contractName, address admin, bytes data) payable public returns (AdminUpgradeabilityProxy) {
576      address implementation = getImplementation(packageName, contractName);
577      AdminUpgradeabilityProxy proxy = (new AdminUpgradeabilityProxy).value(msg.value)(implementation, admin, data);
578      emit ProxyCreated(proxy);
579      return proxy;
580   }
581 }