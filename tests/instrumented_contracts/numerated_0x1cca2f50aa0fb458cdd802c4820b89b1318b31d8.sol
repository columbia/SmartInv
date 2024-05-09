1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-27
3 */
4 
5 // File: ownership/Ownable.sol
6 
7 pragma solidity ^0.5.0;
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  *
14  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/ownership/Ownable.sol
15  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
16  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
17  * build/artifacts folder) as well as the vanilla Ownable implementation from an openzeppelin version.
18  */
19 contract OpenZeppelinUpgradesOwnable {
20     address private _owner;
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24     /**
25      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26      * account.
27      */
28     constructor () internal {
29         _owner = msg.sender;
30         emit OwnershipTransferred(address(0), _owner);
31     }
32 
33     /**
34      * @return the address of the owner.
35      */
36     function owner() public view returns (address) {
37         return _owner;
38     }
39 
40     /**
41      * @dev Throws if called by any account other than the owner.
42      */
43     modifier onlyOwner() {
44         require(isOwner());
45         _;
46     }
47 
48     /**
49      * @return true if `msg.sender` is the owner of the contract.
50      */
51     function isOwner() public view returns (bool) {
52         return msg.sender == _owner;
53     }
54 
55     /**
56      * @dev Allows the current owner to relinquish control of the contract.
57      * @notice Renouncing to ownership will leave the contract without an owner.
58      * It will not be possible to call the functions with the `onlyOwner`
59      * modifier anymore.
60      */
61     function renounceOwnership() public onlyOwner {
62         emit OwnershipTransferred(_owner, address(0));
63         _owner = address(0);
64     }
65 
66     /**
67      * @dev Allows the current owner to transfer control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function transferOwnership(address newOwner) public onlyOwner {
71         _transferOwnership(newOwner);
72     }
73 
74     /**
75      * @dev Transfers control of the contract to a newOwner.
76      * @param newOwner The address to transfer ownership to.
77      */
78     function _transferOwnership(address newOwner) internal {
79         require(newOwner != address(0));
80         emit OwnershipTransferred(_owner, newOwner);
81         _owner = newOwner;
82     }
83 }
84 
85 // File: upgradeability/Proxy.sol
86 
87 pragma solidity ^0.5.0;
88 
89 /**
90  * @title Proxy
91  * @dev Implements delegation of calls to other contracts, with proper
92  * forwarding of return values and bubbling of failures.
93  * It defines a fallback function that delegates all calls to the address
94  * returned by the abstract _implementation() internal function.
95  */
96 contract Proxy {
97   /**
98    * @dev Fallback function.
99    * Implemented entirely in `_fallback`.
100    */
101   function () payable external {
102     _fallback();
103   }
104 
105   /**
106    * @return The Address of the implementation.
107    */
108   function _implementation() internal view returns (address);
109 
110   /**
111    * @dev Delegates execution to an implementation contract.
112    * This is a low level function that doesn't return to its internal call site.
113    * It will return to the external caller whatever the implementation returns.
114    * @param implementation Address to delegate.
115    */
116   function _delegate(address implementation) internal {
117     assembly {
118       // Copy msg.data. We take full control of memory in this inline assembly
119       // block because it will not return to Solidity code. We overwrite the
120       // Solidity scratch pad at memory position 0.
121       calldatacopy(0, 0, calldatasize)
122 
123       // Call the implementation.
124       // out and outsize are 0 because we don't know the size yet.
125       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
126 
127       // Copy the returned data.
128       returndatacopy(0, 0, returndatasize)
129 
130       switch result
131       // delegatecall returns 0 on error.
132       case 0 { revert(0, returndatasize) }
133       default { return(0, returndatasize) }
134     }
135   }
136 
137   /**
138    * @dev Function that is run as the first thing in the fallback function.
139    * Can be redefined in derived contracts to add functionality.
140    * Redefinitions must call super._willFallback().
141    */
142   function _willFallback() internal {
143   }
144 
145   /**
146    * @dev fallback implementation.
147    * Extracted to enable manual triggering.
148    */
149   function _fallback() internal {
150     _willFallback();
151     _delegate(_implementation());
152   }
153 }
154 
155 // File: utils/Address.sol
156 
157 pragma solidity ^0.5.0;
158 
159 /**
160  * Utility library of inline functions on addresses
161  *
162  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
163  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
164  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
165  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
166  */
167 library OpenZeppelinUpgradesAddress {
168     /**
169      * Returns whether the target address is a contract
170      * @dev This function will return false if invoked during the constructor of a contract,
171      * as the code is not actually created until after the constructor finishes.
172      * @param account address of the account to check
173      * @return whether the target address is a contract
174      */
175     function isContract(address account) internal view returns (bool) {
176         uint256 size;
177         // XXX Currently there is no better way to check if there is a contract in an address
178         // than to check the size of the code at that address.
179         // See https://ethereum.stackexchange.com/a/14016/36603
180         // for more details about how this works.
181         // TODO Check this again before the Serenity release, because all addresses will be
182         // contracts then.
183         // solhint-disable-next-line no-inline-assembly
184         assembly { size := extcodesize(account) }
185         return size > 0;
186     }
187 }
188 
189 // File: upgradeability/BaseUpgradeabilityProxy.sol
190 
191 pragma solidity ^0.5.0;
192 
193 
194 
195 /**
196  * @title BaseUpgradeabilityProxy
197  * @dev This contract implements a proxy that allows to change the
198  * implementation address to which it will delegate.
199  * Such a change is called an implementation upgrade.
200  */
201 contract BaseUpgradeabilityProxy is Proxy {
202   /**
203    * @dev Emitted when the implementation is upgraded.
204    * @param implementation Address of the new implementation.
205    */
206   event Upgraded(address indexed implementation);
207 
208   /**
209    * @dev Storage slot with the address of the current implementation.
210    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
211    * validated in the constructor.
212    */
213   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
214 
215   /**
216    * @dev Returns the current implementation.
217    * @return Address of the current implementation
218    */
219   function _implementation() internal view returns (address impl) {
220     bytes32 slot = IMPLEMENTATION_SLOT;
221     assembly {
222       impl := sload(slot)
223     }
224   }
225 
226   /**
227    * @dev Upgrades the proxy to a new implementation.
228    * @param newImplementation Address of the new implementation.
229    */
230   function _upgradeTo(address newImplementation) internal {
231     _setImplementation(newImplementation);
232     emit Upgraded(newImplementation);
233   }
234 
235   /**
236    * @dev Sets the implementation address of the proxy.
237    * @param newImplementation Address of the new implementation.
238    */
239   function _setImplementation(address newImplementation) internal {
240     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
241 
242     bytes32 slot = IMPLEMENTATION_SLOT;
243 
244     assembly {
245       sstore(slot, newImplementation)
246     }
247   }
248 }
249 
250 // File: upgradeability/UpgradeabilityProxy.sol
251 
252 pragma solidity ^0.5.0;
253 
254 
255 /**
256  * @title UpgradeabilityProxy
257  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
258  * implementation and init data.
259  */
260 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
261   /**
262    * @dev Contract constructor.
263    * @param _logic Address of the initial implementation.
264    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
265    * It should include the signature and the parameters of the function to be called, as described in
266    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
267    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
268    */
269   constructor(address _logic, bytes memory _data) public payable {
270     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
271     _setImplementation(_logic);
272     if(_data.length > 0) {
273       (bool success,) = _logic.delegatecall(_data);
274       require(success);
275     }
276   }  
277 }
278 
279 // File: upgradeability/BaseAdminUpgradeabilityProxy.sol
280 
281 pragma solidity ^0.5.0;
282 
283 
284 /**
285  * @title BaseAdminUpgradeabilityProxy
286  * @dev This contract combines an upgradeability proxy with an authorization
287  * mechanism for administrative tasks.
288  * All external functions in this contract must be guarded by the
289  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
290  * feature proposal that would enable this to be done automatically.
291  */
292 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
293   /**
294    * @dev Emitted when the administration has been transferred.
295    * @param previousAdmin Address of the previous admin.
296    * @param newAdmin Address of the new admin.
297    */
298   event AdminChanged(address previousAdmin, address newAdmin);
299 
300   /**
301    * @dev Storage slot with the admin of the contract.
302    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
303    * validated in the constructor.
304    */
305 
306   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
307 
308   /**
309    * @dev Modifier to check whether the `msg.sender` is the admin.
310    * If it is, it will run the function. Otherwise, it will delegate the call
311    * to the implementation.
312    */
313   modifier ifAdmin() {
314     if (msg.sender == _admin()) {
315       _;
316     } else {
317       _fallback();
318     }
319   }
320 
321   /**
322    * @return The address of the proxy admin.
323    */
324   function admin() external ifAdmin returns (address) {
325     return _admin();
326   }
327 
328   /**
329    * @return The address of the implementation.
330    */
331   function implementation() external ifAdmin returns (address) {
332     return _implementation();
333   }
334 
335   /**
336    * @dev Changes the admin of the proxy.
337    * Only the current admin can call this function.
338    * @param newAdmin Address to transfer proxy administration to.
339    */
340   function changeAdmin(address newAdmin) external ifAdmin {
341     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
342     emit AdminChanged(_admin(), newAdmin);
343     _setAdmin(newAdmin);
344   }
345 
346   /**
347    * @dev Upgrade the backing implementation of the proxy.
348    * Only the admin can call this function.
349    * @param newImplementation Address of the new implementation.
350    */
351   function upgradeTo(address newImplementation) external ifAdmin {
352     _upgradeTo(newImplementation);
353   }
354 
355   /**
356    * @dev Upgrade the backing implementation of the proxy and call a function
357    * on the new implementation.
358    * This is useful to initialize the proxied contract.
359    * @param newImplementation Address of the new implementation.
360    * @param data Data to send as msg.data in the low level call.
361    * It should include the signature and the parameters of the function to be called, as described in
362    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
363    */
364   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
365     _upgradeTo(newImplementation);
366     (bool success,) = newImplementation.delegatecall(data);
367     require(success);
368   }
369 
370   /**
371    * @return The admin slot.
372    */
373   function _admin() internal view returns (address adm) {
374     bytes32 slot = ADMIN_SLOT;
375     assembly {
376       adm := sload(slot)
377     }
378   }
379 
380   /**
381    * @dev Sets the address of the proxy admin.
382    * @param newAdmin Address of the new proxy admin.
383    */
384   function _setAdmin(address newAdmin) internal {
385     bytes32 slot = ADMIN_SLOT;
386 
387     assembly {
388       sstore(slot, newAdmin)
389     }
390   }
391 
392   /**
393    * @dev Only fall back when the sender is not the admin.
394    */
395   function _willFallback() internal {
396     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
397     super._willFallback();
398   }
399 }
400 
401 // File: upgradeability/AdminUpgradeabilityProxy.sol
402 
403 pragma solidity ^0.5.0;
404 
405 
406 /**
407  * @title AdminUpgradeabilityProxy
408  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for 
409  * initializing the implementation, admin, and init data.
410  */
411 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
412   /**
413    * Contract constructor.
414    * @param _logic address of the initial implementation.
415    * @param _admin Address of the proxy administrator.
416    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
417    * It should include the signature and the parameters of the function to be called, as described in
418    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
419    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
420    */
421   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
422     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
423     _setAdmin(_admin);
424   }
425 }
426 
427 // File: upgradeability/ProxyAdmin.sol
428 
429 pragma solidity ^0.5.0;
430 
431 
432 
433 /**
434  * @title ProxyAdmin
435  * @dev This contract is the admin of a proxy, and is in charge
436  * of upgrading it as well as transferring it to another admin.
437  */
438 contract ProxyAdmin is OpenZeppelinUpgradesOwnable {
439 
440   /**
441    * @dev Returns the current implementation of a proxy.
442    * This is needed because only the proxy admin can query it.
443    * @return The address of the current implementation of the proxy.
444    */
445   function getProxyImplementation(AdminUpgradeabilityProxy proxy) public view returns (address) {
446     // We need to manually run the static call since the getter cannot be flagged as view
447     // bytes4(keccak256("implementation()")) == 0x5c60da1b
448     (bool success, bytes memory returndata) = address(proxy).staticcall(hex"5c60da1b");
449     require(success);
450     return abi.decode(returndata, (address));
451   }
452 
453   /**
454    * @dev Returns the admin of a proxy. Only the admin can query it.
455    * @return The address of the current admin of the proxy.
456    */
457   function getProxyAdmin(AdminUpgradeabilityProxy proxy) public view returns (address) {
458     // We need to manually run the static call since the getter cannot be flagged as view
459     // bytes4(keccak256("admin()")) == 0xf851a440
460     (bool success, bytes memory returndata) = address(proxy).staticcall(hex"f851a440");
461     require(success);
462     return abi.decode(returndata, (address));
463   }
464 
465   /**
466    * @dev Changes the admin of a proxy.
467    * @param proxy Proxy to change admin.
468    * @param newAdmin Address to transfer proxy administration to.
469    */
470   function changeProxyAdmin(AdminUpgradeabilityProxy proxy, address newAdmin) public onlyOwner {
471     proxy.changeAdmin(newAdmin);
472   }
473 
474   /**
475    * @dev Upgrades a proxy to the newest implementation of a contract.
476    * @param proxy Proxy to be upgraded.
477    * @param implementation the address of the Implementation.
478    */
479   function upgrade(AdminUpgradeabilityProxy proxy, address implementation) public onlyOwner {
480     proxy.upgradeTo(implementation);
481   }
482 
483   /**
484    * @dev Upgrades a proxy to the newest implementation of a contract and forwards a function call to it.
485    * This is useful to initialize the proxied contract.
486    * @param proxy Proxy to be upgraded.
487    * @param implementation Address of the Implementation.
488    * @param data Data to send as msg.data in the low level call.
489    * It should include the signature and the parameters of the function to be called, as described in
490    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
491    */
492   function upgradeAndCall(AdminUpgradeabilityProxy proxy, address implementation, bytes memory data) payable public onlyOwner {
493     proxy.upgradeToAndCall.value(msg.value)(implementation, data);
494   }
495 }