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
18 // File: node_modules/zos-lib/contracts/upgradeability/Proxy.sol
19 
20 /**
21  * @title Proxy
22  * @dev Implements delegation of calls to other contracts, with proper
23  * forwarding of return values and bubbling of failures.
24  * It defines a fallback function that delegates all calls to the address
25  * returned by the abstract _implementation() internal function.
26  */
27 contract Proxy {
28   /**
29    * @dev Fallback function.
30    * Implemented entirely in `_fallback`.
31    */
32   function () payable external {
33     _fallback();
34   }
35 
36   /**
37    * @return The Address of the implementation.
38    */
39   function _implementation() internal view returns (address);
40 
41   /**
42    * @dev Delegates execution to an implementation contract.
43    * This is a low level function that doesn't return to its internal call site.
44    * It will return to the external caller whatever the implementation returns.
45    * @param implementation Address to delegate.
46    */
47   function _delegate(address implementation) internal {
48     assembly {
49       // Copy msg.data. We take full control of memory in this inline assembly
50       // block because it will not return to Solidity code. We overwrite the
51       // Solidity scratch pad at memory position 0.
52       calldatacopy(0, 0, calldatasize)
53 
54       // Call the implementation.
55       // out and outsize are 0 because we don't know the size yet.
56       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
57 
58       // Copy the returned data.
59       returndatacopy(0, 0, returndatasize)
60 
61       switch result
62       // delegatecall returns 0 on error.
63       case 0 { revert(0, returndatasize) }
64       default { return(0, returndatasize) }
65     }
66   }
67 
68   /**
69    * @dev Function that is run as the first thing in the fallback function.
70    * Can be redefined in derived contracts to add functionality.
71    * Redefinitions must call super._willFallback().
72    */
73   function _willFallback() internal {
74   }
75 
76   /**
77    * @dev fallback implementation.
78    * Extracted to enable manual triggering.
79    */
80   function _fallback() internal {
81     _willFallback();
82     _delegate(_implementation());
83   }
84 }
85 
86 // File: openzeppelin-solidity/contracts/AddressUtils.sol
87 
88 /**
89  * Utility library of inline functions on addresses
90  */
91 library AddressUtils {
92 
93   /**
94    * Returns whether the target address is a contract
95    * @dev This function will return false if invoked during the constructor of a contract,
96    * as the code is not actually created until after the constructor finishes.
97    * @param _addr address to check
98    * @return whether the target address is a contract
99    */
100   function isContract(address _addr) internal view returns (bool) {
101     uint256 size;
102     // XXX Currently there is no better way to check if there is a contract in an address
103     // than to check the size of the code at that address.
104     // See https://ethereum.stackexchange.com/a/14016/36603
105     // for more details about how this works.
106     // TODO Check this again before the Serenity release, because all addresses will be
107     // contracts then.
108     // solium-disable-next-line security/no-inline-assembly
109     assembly { size := extcodesize(_addr) }
110     return size > 0;
111   }
112 
113 }
114 
115 // File: node_modules/zos-lib/contracts/upgradeability/UpgradeabilityProxy.sol
116 
117 /**
118  * @title UpgradeabilityProxy
119  * @dev This contract implements a proxy that allows to change the
120  * implementation address to which it will delegate.
121  * Such a change is called an implementation upgrade.
122  */
123 contract UpgradeabilityProxy is Proxy {
124   /**
125    * @dev Emitted when the implementation is upgraded.
126    * @param implementation Address of the new implementation.
127    */
128   event Upgraded(address implementation);
129 
130   /**
131    * @dev Storage slot with the address of the current implementation.
132    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
133    * validated in the constructor.
134    */
135   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
136 
137   /**
138    * @dev Contract constructor.
139    * @param _implementation Address of the initial implementation.
140    */
141   constructor(address _implementation) public {
142     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
143 
144     _setImplementation(_implementation);
145   }
146 
147   /**
148    * @dev Returns the current implementation.
149    * @return Address of the current implementation
150    */
151   function _implementation() internal view returns (address impl) {
152     bytes32 slot = IMPLEMENTATION_SLOT;
153     assembly {
154       impl := sload(slot)
155     }
156   }
157 
158   /**
159    * @dev Upgrades the proxy to a new implementation.
160    * @param newImplementation Address of the new implementation.
161    */
162   function _upgradeTo(address newImplementation) internal {
163     _setImplementation(newImplementation);
164     emit Upgraded(newImplementation);
165   }
166 
167   /**
168    * @dev Sets the implementation address of the proxy.
169    * @param newImplementation Address of the new implementation.
170    */
171   function _setImplementation(address newImplementation) private {
172     require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
173 
174     bytes32 slot = IMPLEMENTATION_SLOT;
175 
176     assembly {
177       sstore(slot, newImplementation)
178     }
179   }
180 }
181 
182 // File: node_modules/zos-lib/contracts/upgradeability/AdminUpgradeabilityProxy.sol
183 
184 /**
185  * @title AdminUpgradeabilityProxy
186  * @dev This contract combines an upgradeability proxy with an authorization
187  * mechanism for administrative tasks.
188  * All external functions in this contract must be guarded by the
189  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
190  * feature proposal that would enable this to be done automatically.
191  */
192 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
193   /**
194    * @dev Emitted when the administration has been transferred.
195    * @param previousAdmin Address of the previous admin.
196    * @param newAdmin Address of the new admin.
197    */
198   event AdminChanged(address previousAdmin, address newAdmin);
199 
200   /**
201    * @dev Storage slot with the admin of the contract.
202    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
203    * validated in the constructor.
204    */
205   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
206 
207   /**
208    * @dev Modifier to check whether the `msg.sender` is the admin.
209    * If it is, it will run the function. Otherwise, it will delegate the call
210    * to the implementation.
211    */
212   modifier ifAdmin() {
213     if (msg.sender == _admin()) {
214       _;
215     } else {
216       _fallback();
217     }
218   }
219 
220   /**
221    * Contract constructor.
222    * It sets the `msg.sender` as the proxy administrator.
223    * @param _implementation address of the initial implementation.
224    */
225   constructor(address _implementation) UpgradeabilityProxy(_implementation) public {
226     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
227 
228     _setAdmin(msg.sender);
229   }
230 
231   /**
232    * @return The address of the proxy admin.
233    */
234   function admin() external view ifAdmin returns (address) {
235     return _admin();
236   }
237 
238   /**
239    * @return The address of the implementation.
240    */
241   function implementation() external view ifAdmin returns (address) {
242     return _implementation();
243   }
244 
245   /**
246    * @dev Changes the admin of the proxy.
247    * Only the current admin can call this function.
248    * @param newAdmin Address to transfer proxy administration to.
249    */
250   function changeAdmin(address newAdmin) external ifAdmin {
251     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
252     emit AdminChanged(_admin(), newAdmin);
253     _setAdmin(newAdmin);
254   }
255 
256   /**
257    * @dev Upgrade the backing implementation of the proxy.
258    * Only the admin can call this function.
259    * @param newImplementation Address of the new implementation.
260    */
261   function upgradeTo(address newImplementation) external ifAdmin {
262     _upgradeTo(newImplementation);
263   }
264 
265   /**
266    * @dev Upgrade the backing implementation of the proxy and call a function
267    * on the new implementation.
268    * This is useful to initialize the proxied contract.
269    * @param newImplementation Address of the new implementation.
270    * @param data Data to send as msg.data in the low level call.
271    * It should include the signature and the parameters of the function to be
272    * called, as described in
273    * https://solidity.readthedocs.io/en/develop/abi-spec.html#function-selector-and-argument-encoding.
274    */
275   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
276     _upgradeTo(newImplementation);
277     require(address(this).call.value(msg.value)(data));
278   }
279 
280   /**
281    * @return The admin slot.
282    */
283   function _admin() internal view returns (address adm) {
284     bytes32 slot = ADMIN_SLOT;
285     assembly {
286       adm := sload(slot)
287     }
288   }
289 
290   /**
291    * @dev Sets the address of the proxy admin.
292    * @param newAdmin Address of the new proxy admin.
293    */
294   function _setAdmin(address newAdmin) internal {
295     bytes32 slot = ADMIN_SLOT;
296 
297     assembly {
298       sstore(slot, newAdmin)
299     }
300   }
301 
302   /**
303    * @dev Only fall back when the sender is not the admin.
304    */
305   function _willFallback() internal {
306     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
307     super._willFallback();
308   }
309 }
310 
311 // File: node_modules/zos-lib/contracts/upgradeability/UpgradeabilityProxyFactory.sol
312 
313 /**
314  * @title UpgradeabilityProxyFactory
315  * @dev Factory to create upgradeability proxies.
316  */
317 contract UpgradeabilityProxyFactory {
318   /**
319    * @dev Emitted when a new proxy is created.
320    * @param proxy Address of the created proxy.
321    */
322   event ProxyCreated(address proxy);
323 
324   /**
325    * @dev Creates an upgradeability proxy with an initial implementation.
326    * @param admin Address of the proxy admin.
327    * @param implementation Address of the initial implementation.
328    * @return Address of the new proxy.
329    */
330   function createProxy(address admin, address implementation) public returns (AdminUpgradeabilityProxy) {
331     AdminUpgradeabilityProxy proxy = _createProxy(implementation);
332     proxy.changeAdmin(admin);
333     return proxy;
334   }
335 
336   /**
337    * @dev Creates an upgradeability proxy with an initial implementation and calls it.
338    * This is useful to initialize the proxied contract.
339    * @param admin Address of the proxy admin.
340    * @param implementation Address of the initial implementation.
341    * @param data Data to send as msg.data in the low level call.
342    * It should include the signature and the parameters of the function to be
343    * called, as described in
344    * https://solidity.readthedocs.io/en/develop/abi-spec.html#function-selector-and-argument-encoding.
345    * @return Address of the new proxy.
346    */
347   function createProxyAndCall(address admin, address implementation, bytes data) public payable returns (AdminUpgradeabilityProxy) {
348     AdminUpgradeabilityProxy proxy = _createProxy(implementation);
349     proxy.changeAdmin(admin);
350     require(address(proxy).call.value(msg.value)(data));
351     return proxy;
352   }
353 
354   /**
355    * @dev Internal function to create an upgradeable proxy.
356    * @param implementation Address of the initial implementation.
357    * @return Address of the new proxy.
358    */
359   function _createProxy(address implementation) internal returns (AdminUpgradeabilityProxy) {
360     AdminUpgradeabilityProxy proxy = new AdminUpgradeabilityProxy(implementation);
361     emit ProxyCreated(proxy);
362     return proxy;
363   }
364 }
365 
366 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
367 
368 /**
369  * @title Ownable
370  * @dev The Ownable contract has an owner address, and provides basic authorization control
371  * functions, this simplifies the implementation of "user permissions".
372  */
373 contract Ownable {
374   address public owner;
375 
376 
377   event OwnershipRenounced(address indexed previousOwner);
378   event OwnershipTransferred(
379     address indexed previousOwner,
380     address indexed newOwner
381   );
382 
383 
384   /**
385    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
386    * account.
387    */
388   constructor() public {
389     owner = msg.sender;
390   }
391 
392   /**
393    * @dev Throws if called by any account other than the owner.
394    */
395   modifier onlyOwner() {
396     require(msg.sender == owner);
397     _;
398   }
399 
400   /**
401    * @dev Allows the current owner to relinquish control of the contract.
402    * @notice Renouncing to ownership will leave the contract without an owner.
403    * It will not be possible to call the functions with the `onlyOwner`
404    * modifier anymore.
405    */
406   function renounceOwnership() public onlyOwner {
407     emit OwnershipRenounced(owner);
408     owner = address(0);
409   }
410 
411   /**
412    * @dev Allows the current owner to transfer control of the contract to a newOwner.
413    * @param _newOwner The address to transfer ownership to.
414    */
415   function transferOwnership(address _newOwner) public onlyOwner {
416     _transferOwnership(_newOwner);
417   }
418 
419   /**
420    * @dev Transfers control of the contract to a newOwner.
421    * @param _newOwner The address to transfer ownership to.
422    */
423   function _transferOwnership(address _newOwner) internal {
424     require(_newOwner != address(0));
425     emit OwnershipTransferred(owner, _newOwner);
426     owner = _newOwner;
427   }
428 }
429 
430 // File: node_modules/zos-lib/contracts/application/BaseApp.sol
431 
432 /**
433  * @title BaseApp
434  * @dev Abstract base contract for upgradeable applications.
435  * It handles the creation and upgrading of proxies.
436  */
437 contract BaseApp is Ownable {
438   /// @dev Factory that creates proxies.
439   UpgradeabilityProxyFactory public factory;
440 
441   /**
442    * @dev Constructor function
443    * @param _factory Proxy factory
444    */
445   constructor(UpgradeabilityProxyFactory _factory) public {
446     require(address(_factory) != address(0), "Cannot set the proxy factory of an app to the zero address");
447     factory = _factory;
448   }
449 
450   /**
451    * @dev Abstract function to return the implementation provider.
452    * @return The implementation provider.
453    */
454   function getProvider() internal view returns (ImplementationProvider);
455 
456   /**
457    * @dev Returns the implementation address for a given contract name, provided by the `ImplementationProvider`.
458    * @param contractName Name of the contract.
459    * @return Address where the contract is implemented.
460    */
461   function getImplementation(string contractName) public view returns (address) {
462     return getProvider().getImplementation(contractName);
463   }
464 
465   /**
466    * @dev Creates a new proxy for the given contract.
467    * @param contractName Name of the contract.
468    * @return Address of the new proxy.
469    */
470   function create(string contractName) public returns (AdminUpgradeabilityProxy) {
471     address implementation = getImplementation(contractName);
472     return factory.createProxy(this, implementation);
473   }
474 
475   /**
476    * @dev Creates a new proxy for the given contract and forwards a function call to it.
477    * This is useful to initialize the proxied contract.
478    * @param contractName Name of the contract.
479    * @param data Data to send as msg.data in the low level call.
480    * It should include the signature and the parameters of the function to be
481    * called, as described in
482    * https://solidity.readthedocs.io/en/develop/abi-spec.html#function-selector-and-argument-encoding.
483    * @return Address of the new proxy.
484    */
485    function createAndCall(string contractName, bytes data) payable public returns (AdminUpgradeabilityProxy) {
486     address implementation = getImplementation(contractName);
487     return factory.createProxyAndCall.value(msg.value)(this, implementation, data);
488   }
489 
490   /**
491    * @dev Upgrades a proxy to the newest implementation of a contract.
492    * @param proxy Proxy to be upgraded.
493    * @param contractName Name of the contract.
494    */
495   function upgrade(AdminUpgradeabilityProxy proxy, string contractName) public onlyOwner {
496     address implementation = getImplementation(contractName);
497     proxy.upgradeTo(implementation);
498   }
499 
500   /**
501    * @dev Upgrades a proxy to the newest implementation of a contract and forwards a function call to it.
502    * This is useful to initialize the proxied contract.
503    * @param proxy Proxy to be upgraded.
504    * @param contractName Name of the contract.
505    * @param data Data to send as msg.data in the low level call.
506    * It should include the signature and the parameters of the function to be
507    * called, as described in
508    * https://solidity.readthedocs.io/en/develop/abi-spec.html#function-selector-and-argument-encoding.
509    */
510   function upgradeAndCall(AdminUpgradeabilityProxy proxy, string contractName, bytes data) payable public onlyOwner {
511     address implementation = getImplementation(contractName);
512     proxy.upgradeToAndCall.value(msg.value)(implementation, data);
513   }
514 
515   /**
516    * @dev Returns the current implementation of a proxy.
517    * This is needed because only the proxy admin can query it.
518    * @return The address of the current implementation of the proxy.
519    */
520   function getProxyImplementation(AdminUpgradeabilityProxy proxy) public view returns (address) {
521     return proxy.implementation();
522   }
523 
524   /**
525    * @dev Returns the admin of a proxy.
526    * Only the admin can query it.
527    * @return The address of the current admin of the proxy.
528    */
529   function getProxyAdmin(AdminUpgradeabilityProxy proxy) public view returns (address) {
530     return proxy.admin();
531   }
532 
533   /**
534    * @dev Changes the admin of a proxy.
535    * @param proxy Proxy to change admin.
536    * @param newAdmin Address to transfer proxy administration to.
537    */
538   function changeProxyAdmin(AdminUpgradeabilityProxy proxy, address newAdmin) public onlyOwner {
539     proxy.changeAdmin(newAdmin);
540   }
541 }
542 
543 // File: node_modules/zos-lib/contracts/application/versioning/Package.sol
544 
545 /**
546  * @title Package
547  * @dev Collection of contracts grouped into versions.
548  * Contracts with the same name can have different implementation addresses in different versions.
549  */
550 contract Package is Ownable {
551   /**
552    * @dev Emitted when a version is added to the package.
553    * XXX The version is not indexed due to truffle testing constraints.
554    * @param version Name of the added version.
555    * @param provider ImplementationProvider associated with the version.
556    */
557   event VersionAdded(string version, ImplementationProvider provider);
558 
559   /*
560    * @dev Mapping associating versions and their implementation providers.
561    */
562   mapping (string => ImplementationProvider) internal versions;
563 
564   /**
565    * @dev Returns the implementation provider of a version.
566    * @param version Name of the version.
567    * @return The implementation provider of the version.
568    */
569   function getVersion(string version) public view returns (ImplementationProvider) {
570     ImplementationProvider provider = versions[version];
571     return provider;
572   }
573 
574   /**
575    * @dev Adds the implementation provider of a new version to the package.
576    * @param version Name of the version.
577    * @param provider ImplementationProvider associated with the version.
578    */
579   function addVersion(string version, ImplementationProvider provider) public onlyOwner {
580     require(!hasVersion(version), "Given version is already registered in package");
581     versions[version] = provider;
582     emit VersionAdded(version, provider);
583   }
584 
585   /**
586    * @dev Checks whether a version is present in the package.
587    * @param version Name of the version.
588    * @return true if the version is already in the package, false otherwise.
589    */
590   function hasVersion(string version) public view returns (bool) {
591     return address(versions[version]) != address(0);
592   }
593 
594   /**
595    * @dev Returns the implementation address for a given version and contract name.
596    * @param version Name of the version.
597    * @param contractName Name of the contract.
598    * @return Address where the contract is implemented.
599    */
600   function getImplementation(string version, string contractName) public view returns (address) {
601     ImplementationProvider provider = getVersion(version);
602     return provider.getImplementation(contractName);
603   }
604 }
605 
606 // File: node_modules/zos-lib/contracts/application/PackagedApp.sol
607 
608 /**
609  * @title PackagedApp
610  * @dev App for an upgradeable project that can use different versions.
611  * This is the standard entry point for an upgradeable app.
612  */
613 contract PackagedApp is BaseApp {
614   /// @dev Package that stores the contract implementation addresses.
615   Package public package;
616   /// @dev App version.
617   string public version;
618 
619   /**
620    * @dev Constructor function.
621    * @param _package Package that stores the contract implementation addresses.
622    * @param _version Initial version of the app.
623    * @param _factory Proxy factory.
624    */
625   constructor(Package _package, string _version, UpgradeabilityProxyFactory _factory) BaseApp(_factory) public {
626     require(address(_package) != address(0), "Cannot set the package of an app to the zero address");
627     require(_package.hasVersion(_version), "The requested version must be registered in the given package");
628     package = _package;
629     version = _version;
630   }
631 
632   /**
633    * @dev Sets the current version of the application.
634    * Contract implementations for the given version must already be registered in the package.
635    * @param newVersion Name of the new version.
636    */
637   function setVersion(string newVersion) public onlyOwner {
638     require(package.hasVersion(newVersion), "The requested version must be registered in the given package");
639     version = newVersion;
640   }
641 
642   /**
643    * @dev Returns the provider for the current version.
644    * @return The provider for the current version.
645    */
646   function getProvider() internal view returns (ImplementationProvider) {
647     return package.getVersion(version);
648   }
649 }