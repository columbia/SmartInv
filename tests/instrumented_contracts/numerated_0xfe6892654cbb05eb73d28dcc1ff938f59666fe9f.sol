1 // File: ownership/Ownable.sol
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
15 contract OpenZeppelinUpgradesOwnable {
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
81 // File: upgradeability/Proxy.sol
82 
83 pragma solidity ^0.5.0;
84 
85 /**
86  * @title Proxy
87  * @dev Implements delegation of calls to other contracts, with proper
88  * forwarding of return values and bubbling of failures.
89  * It defines a fallback function that delegates all calls to the address
90  * returned by the abstract _implementation() internal function.
91  */
92 contract Proxy {
93   /**
94    * @dev Fallback function.
95    * Implemented entirely in `_fallback`.
96    */
97   function () payable external {
98     _fallback();
99   }
100 
101   /**
102    * @return The Address of the implementation.
103    */
104   function _implementation() internal view returns (address);
105 
106   /**
107    * @dev Delegates execution to an implementation contract.
108    * This is a low level function that doesn't return to its internal call site.
109    * It will return to the external caller whatever the implementation returns.
110    * @param implementation Address to delegate.
111    */
112   function _delegate(address implementation) internal {
113     assembly {
114       // Copy msg.data. We take full control of memory in this inline assembly
115       // block because it will not return to Solidity code. We overwrite the
116       // Solidity scratch pad at memory position 0.
117       calldatacopy(0, 0, calldatasize)
118 
119       // Call the implementation.
120       // out and outsize are 0 because we don't know the size yet.
121       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
122 
123       // Copy the returned data.
124       returndatacopy(0, 0, returndatasize)
125 
126       switch result
127       // delegatecall returns 0 on error.
128       case 0 { revert(0, returndatasize) }
129       default { return(0, returndatasize) }
130     }
131   }
132 
133   /**
134    * @dev Function that is run as the first thing in the fallback function.
135    * Can be redefined in derived contracts to add functionality.
136    * Redefinitions must call super._willFallback().
137    */
138   function _willFallback() internal {
139   }
140 
141   /**
142    * @dev fallback implementation.
143    * Extracted to enable manual triggering.
144    */
145   function _fallback() internal {
146     _willFallback();
147     _delegate(_implementation());
148   }
149 }
150 
151 // File: utils/Address.sol
152 
153 pragma solidity ^0.5.0;
154 
155 /**
156  * Utility library of inline functions on addresses
157  *
158  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
159  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
160  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
161  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
162  */
163 library OpenZeppelinUpgradesAddress {
164     /**
165      * Returns whether the target address is a contract
166      * @dev This function will return false if invoked during the constructor of a contract,
167      * as the code is not actually created until after the constructor finishes.
168      * @param account address of the account to check
169      * @return whether the target address is a contract
170      */
171     function isContract(address account) internal view returns (bool) {
172         uint256 size;
173         // XXX Currently there is no better way to check if there is a contract in an address
174         // than to check the size of the code at that address.
175         // See https://ethereum.stackexchange.com/a/14016/36603
176         // for more details about how this works.
177         // TODO Check this again before the Serenity release, because all addresses will be
178         // contracts then.
179         // solhint-disable-next-line no-inline-assembly
180         assembly { size := extcodesize(account) }
181         return size > 0;
182     }
183 }
184 
185 // File: upgradeability/BaseUpgradeabilityProxy.sol
186 
187 pragma solidity ^0.5.0;
188 
189 
190 
191 /**
192  * @title BaseUpgradeabilityProxy
193  * @dev This contract implements a proxy that allows to change the
194  * implementation address to which it will delegate.
195  * Such a change is called an implementation upgrade.
196  */
197 contract BaseUpgradeabilityProxy is Proxy {
198   /**
199    * @dev Emitted when the implementation is upgraded.
200    * @param implementation Address of the new implementation.
201    */
202   event Upgraded(address indexed implementation);
203 
204   /**
205    * @dev Storage slot with the address of the current implementation.
206    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
207    * validated in the constructor.
208    */
209   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
210 
211   /**
212    * @dev Returns the current implementation.
213    * @return Address of the current implementation
214    */
215   function _implementation() internal view returns (address impl) {
216     bytes32 slot = IMPLEMENTATION_SLOT;
217     assembly {
218       impl := sload(slot)
219     }
220   }
221 
222   /**
223    * @dev Upgrades the proxy to a new implementation.
224    * @param newImplementation Address of the new implementation.
225    */
226   function _upgradeTo(address newImplementation) internal {
227     _setImplementation(newImplementation);
228     emit Upgraded(newImplementation);
229   }
230 
231   /**
232    * @dev Sets the implementation address of the proxy.
233    * @param newImplementation Address of the new implementation.
234    */
235   function _setImplementation(address newImplementation) internal {
236     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
237 
238     bytes32 slot = IMPLEMENTATION_SLOT;
239 
240     assembly {
241       sstore(slot, newImplementation)
242     }
243   }
244 }
245 
246 // File: upgradeability/UpgradeabilityProxy.sol
247 
248 pragma solidity ^0.5.0;
249 
250 
251 /**
252  * @title UpgradeabilityProxy
253  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
254  * implementation and init data.
255  */
256 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
257   /**
258    * @dev Contract constructor.
259    * @param _logic Address of the initial implementation.
260    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
261    * It should include the signature and the parameters of the function to be called, as described in
262    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
263    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
264    */
265   constructor(address _logic, bytes memory _data) public payable {
266     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
267     _setImplementation(_logic);
268     if(_data.length > 0) {
269       (bool success,) = _logic.delegatecall(_data);
270       require(success);
271     }
272   }  
273 }
274 
275 // File: upgradeability/BaseAdminUpgradeabilityProxy.sol
276 
277 pragma solidity ^0.5.0;
278 
279 
280 /**
281  * @title BaseAdminUpgradeabilityProxy
282  * @dev This contract combines an upgradeability proxy with an authorization
283  * mechanism for administrative tasks.
284  * All external functions in this contract must be guarded by the
285  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
286  * feature proposal that would enable this to be done automatically.
287  */
288 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
289   /**
290    * @dev Emitted when the administration has been transferred.
291    * @param previousAdmin Address of the previous admin.
292    * @param newAdmin Address of the new admin.
293    */
294   event AdminChanged(address previousAdmin, address newAdmin);
295 
296   /**
297    * @dev Storage slot with the admin of the contract.
298    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
299    * validated in the constructor.
300    */
301 
302   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
303 
304   /**
305    * @dev Modifier to check whether the `msg.sender` is the admin.
306    * If it is, it will run the function. Otherwise, it will delegate the call
307    * to the implementation.
308    */
309   modifier ifAdmin() {
310     if (msg.sender == _admin()) {
311       _;
312     } else {
313       _fallback();
314     }
315   }
316 
317   /**
318    * @return The address of the proxy admin.
319    */
320   function admin() external ifAdmin returns (address) {
321     return _admin();
322   }
323 
324   /**
325    * @return The address of the implementation.
326    */
327   function implementation() external ifAdmin returns (address) {
328     return _implementation();
329   }
330 
331   /**
332    * @dev Changes the admin of the proxy.
333    * Only the current admin can call this function.
334    * @param newAdmin Address to transfer proxy administration to.
335    */
336   function changeAdmin(address newAdmin) external ifAdmin {
337     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
338     emit AdminChanged(_admin(), newAdmin);
339     _setAdmin(newAdmin);
340   }
341 
342   /**
343    * @dev Upgrade the backing implementation of the proxy.
344    * Only the admin can call this function.
345    * @param newImplementation Address of the new implementation.
346    */
347   function upgradeTo(address newImplementation) external ifAdmin {
348     _upgradeTo(newImplementation);
349   }
350 
351   /**
352    * @dev Upgrade the backing implementation of the proxy and call a function
353    * on the new implementation.
354    * This is useful to initialize the proxied contract.
355    * @param newImplementation Address of the new implementation.
356    * @param data Data to send as msg.data in the low level call.
357    * It should include the signature and the parameters of the function to be called, as described in
358    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
359    */
360   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
361     _upgradeTo(newImplementation);
362     (bool success,) = newImplementation.delegatecall(data);
363     require(success);
364   }
365 
366   /**
367    * @return The admin slot.
368    */
369   function _admin() internal view returns (address adm) {
370     bytes32 slot = ADMIN_SLOT;
371     assembly {
372       adm := sload(slot)
373     }
374   }
375 
376   /**
377    * @dev Sets the address of the proxy admin.
378    * @param newAdmin Address of the new proxy admin.
379    */
380   function _setAdmin(address newAdmin) internal {
381     bytes32 slot = ADMIN_SLOT;
382 
383     assembly {
384       sstore(slot, newAdmin)
385     }
386   }
387 
388   /**
389    * @dev Only fall back when the sender is not the admin.
390    */
391   function _willFallback() internal {
392     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
393     super._willFallback();
394   }
395 }
396 
397 // File: upgradeability/AdminUpgradeabilityProxy.sol
398 
399 pragma solidity ^0.5.0;
400 
401 
402 /**
403  * @title AdminUpgradeabilityProxy
404  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for 
405  * initializing the implementation, admin, and init data.
406  */
407 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
408   /**
409    * Contract constructor.
410    * @param _logic address of the initial implementation.
411    * @param _admin Address of the proxy administrator.
412    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
413    * It should include the signature and the parameters of the function to be called, as described in
414    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
415    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
416    */
417   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
418     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
419     _setAdmin(_admin);
420   }
421 }
422 
423 // File: upgradeability/ProxyAdmin.sol
424 
425 pragma solidity ^0.5.0;
426 
427 
428 
429 /**
430  * @title ProxyAdmin
431  * @dev This contract is the admin of a proxy, and is in charge
432  * of upgrading it as well as transferring it to another admin.
433  */
434 contract ProxyAdmin is OpenZeppelinUpgradesOwnable {
435 
436   /**
437    * @dev Returns the current implementation of a proxy.
438    * This is needed because only the proxy admin can query it.
439    * @return The address of the current implementation of the proxy.
440    */
441   function getProxyImplementation(AdminUpgradeabilityProxy proxy) public view returns (address) {
442     // We need to manually run the static call since the getter cannot be flagged as view
443     // bytes4(keccak256("implementation()")) == 0x5c60da1b
444     (bool success, bytes memory returndata) = address(proxy).staticcall(hex"5c60da1b");
445     require(success);
446     return abi.decode(returndata, (address));
447   }
448 
449   /**
450    * @dev Returns the admin of a proxy. Only the admin can query it.
451    * @return The address of the current admin of the proxy.
452    */
453   function getProxyAdmin(AdminUpgradeabilityProxy proxy) public view returns (address) {
454     // We need to manually run the static call since the getter cannot be flagged as view
455     // bytes4(keccak256("admin()")) == 0xf851a440
456     (bool success, bytes memory returndata) = address(proxy).staticcall(hex"f851a440");
457     require(success);
458     return abi.decode(returndata, (address));
459   }
460 
461   /**
462    * @dev Changes the admin of a proxy.
463    * @param proxy Proxy to change admin.
464    * @param newAdmin Address to transfer proxy administration to.
465    */
466   function changeProxyAdmin(AdminUpgradeabilityProxy proxy, address newAdmin) public onlyOwner {
467     proxy.changeAdmin(newAdmin);
468   }
469 
470   /**
471    * @dev Upgrades a proxy to the newest implementation of a contract.
472    * @param proxy Proxy to be upgraded.
473    * @param implementation the address of the Implementation.
474    */
475   function upgrade(AdminUpgradeabilityProxy proxy, address implementation) public onlyOwner {
476     proxy.upgradeTo(implementation);
477   }
478 
479   /**
480    * @dev Upgrades a proxy to the newest implementation of a contract and forwards a function call to it.
481    * This is useful to initialize the proxied contract.
482    * @param proxy Proxy to be upgraded.
483    * @param implementation Address of the Implementation.
484    * @param data Data to send as msg.data in the low level call.
485    * It should include the signature and the parameters of the function to be called, as described in
486    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
487    */
488   function upgradeAndCall(AdminUpgradeabilityProxy proxy, address implementation, bytes memory data) payable public onlyOwner {
489     proxy.upgradeToAndCall.value(msg.value)(implementation, data);
490   }
491 }