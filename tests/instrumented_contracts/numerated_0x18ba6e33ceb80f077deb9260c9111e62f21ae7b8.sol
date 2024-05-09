1 pragma solidity 0.8.17;
2 
3 interface IERC1822Proxiable {
4     /**
5      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
6      * address.
7      *
8      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
9      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
10      * function revert if invoked through a proxy.
11      */
12     function proxiableUUID() external view returns (bytes32);
13 }
14 
15 interface IBeacon {
16     /**
17      * @dev Must return an address that can be used as a delegate call target.
18      *
19      * {BeaconProxy} will check that this address is a contract.
20      */
21     function implementation() external view returns (address);
22 }
23 
24 abstract contract Proxy {
25     /**
26      * @dev Delegates the current call to `implementation`.
27      *
28      * This function does not return to its internal call site, it will return directly to the external caller.
29      */
30     function _delegate(address implementation) internal virtual {
31         assembly {
32             // Copy msg.data. We take full control of memory in this inline assembly
33             // block because it will not return to Solidity code. We overwrite the
34             // Solidity scratch pad at memory position 0.
35             calldatacopy(0, 0, calldatasize())
36 
37             // Call the implementation.
38             // out and outsize are 0 because we don't know the size yet.
39             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
40 
41             // Copy the returned data.
42             returndatacopy(0, 0, returndatasize())
43 
44             switch result
45             // delegatecall returns 0 on error.
46             case 0 {
47                 revert(0, returndatasize())
48             }
49             default {
50                 return(0, returndatasize())
51             }
52         }
53     }
54 
55     /**
56      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
57      * and {_fallback} should delegate.
58      */
59     function _implementation() internal view virtual returns (address);
60 
61     /**
62      * @dev Delegates the current call to the address returned by `_implementation()`.
63      *
64      * This function does not return to its internal call site, it will return directly to the external caller.
65      */
66     function _fallback() internal virtual {
67         _beforeFallback();
68         _delegate(_implementation());
69     }
70 
71     /**
72      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
73      * function in the contract matches the call data.
74      */
75     fallback() external payable virtual {
76         _fallback();
77     }
78 
79     /**
80      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
81      * is empty.
82      */
83     receive() external payable virtual {
84         _fallback();
85     }
86 
87     /**
88      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
89      * call, or as part of the Solidity `fallback` or `receive` functions.
90      *
91      * If overridden should call `super._beforeFallback()`.
92      */
93     function _beforeFallback() internal virtual {}
94 }
95 
96 library StorageSlot {
97     struct AddressSlot {
98         address value;
99     }
100 
101     struct BooleanSlot {
102         bool value;
103     }
104 
105     struct Bytes32Slot {
106         bytes32 value;
107     }
108 
109     struct Uint256Slot {
110         uint256 value;
111     }
112 
113     /**
114      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
115      */
116     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
117         /// @solidity memory-safe-assembly
118         assembly {
119             r.slot := slot
120         }
121     }
122 
123     /**
124      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
125      */
126     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
127         /// @solidity memory-safe-assembly
128         assembly {
129             r.slot := slot
130         }
131     }
132 
133     /**
134      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
135      */
136     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
137         /// @solidity memory-safe-assembly
138         assembly {
139             r.slot := slot
140         }
141     }
142 
143     /**
144      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
145      */
146     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
147         /// @solidity memory-safe-assembly
148         assembly {
149             r.slot := slot
150         }
151     }
152 }
153 
154 
155 library Address {
156     /**
157      * @dev Returns true if `account` is a contract.
158      *
159      * [IMPORTANT]
160      * ====
161      * It is unsafe to assume that an address for which this function returns
162      * false is an externally-owned account (EOA) and not a contract.
163      *
164      * Among others, `isContract` will return false for the following
165      * types of addresses:
166      *
167      *  - an externally-owned account
168      *  - a contract in construction
169      *  - an address where a contract will be created
170      *  - an address where a contract lived, but was destroyed
171      * ====
172      *
173      * [IMPORTANT]
174      * ====
175      * You shouldn't rely on `isContract` to protect against flash loan attacks!
176      *
177      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
178      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
179      * constructor.
180      * ====
181      */
182     function isContract(address account) internal view returns (bool) {
183         // This method relies on extcodesize/address.code.length, which returns 0
184         // for contracts in construction, since the code is only stored at the end
185         // of the constructor execution.
186 
187         return account.code.length > 0;
188     }
189 
190     /**
191      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
192      * `recipient`, forwarding all available gas and reverting on errors.
193      *
194      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
195      * of certain opcodes, possibly making contracts go over the 2300 gas limit
196      * imposed by `transfer`, making them unable to receive funds via
197      * `transfer`. {sendValue} removes this limitation.
198      *
199      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
200      *
201      * IMPORTANT: because control is transferred to `recipient`, care must be
202      * taken to not create reentrancy vulnerabilities. Consider using
203      * {ReentrancyGuard} or the
204      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
205      */
206     function sendValue(address payable recipient, uint256 amount) internal {
207         require(address(this).balance >= amount, "Address: insufficient balance");
208 
209         (bool success, ) = recipient.call{value: amount}("");
210         require(success, "Address: unable to send value, recipient may have reverted");
211     }
212 
213     /**
214      * @dev Performs a Solidity function call using a low level `call`. A
215      * plain `call` is an unsafe replacement for a function call: use this
216      * function instead.
217      *
218      * If `target` reverts with a revert reason, it is bubbled up by this
219      * function (like regular Solidity function calls).
220      *
221      * Returns the raw returned data. To convert to the expected return value,
222      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
223      *
224      * Requirements:
225      *
226      * - `target` must be a contract.
227      * - calling `target` with `data` must not revert.
228      *
229      * _Available since v3.1._
230      */
231     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
232         return functionCall(target, data, "Address: low-level call failed");
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
237      * `errorMessage` as a fallback revert reason when `target` reverts.
238      *
239      * _Available since v3.1._
240      */
241     function functionCall(
242         address target,
243         bytes memory data,
244         string memory errorMessage
245     ) internal returns (bytes memory) {
246         return functionCallWithValue(target, data, 0, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but also transferring `value` wei to `target`.
252      *
253      * Requirements:
254      *
255      * - the calling contract must have an ETH balance of at least `value`.
256      * - the called Solidity function must be `payable`.
257      *
258      * _Available since v3.1._
259      */
260     function functionCallWithValue(
261         address target,
262         bytes memory data,
263         uint256 value
264     ) internal returns (bytes memory) {
265         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
270      * with `errorMessage` as a fallback revert reason when `target` reverts.
271      *
272      * _Available since v3.1._
273      */
274     function functionCallWithValue(
275         address target,
276         bytes memory data,
277         uint256 value,
278         string memory errorMessage
279     ) internal returns (bytes memory) {
280         require(address(this).balance >= value, "Address: insufficient balance for call");
281         require(isContract(target), "Address: call to non-contract");
282 
283         (bool success, bytes memory returndata) = target.call{value: value}(data);
284         return verifyCallResult(success, returndata, errorMessage);
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
289      * but performing a static call.
290      *
291      * _Available since v3.3._
292      */
293     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
294         return functionStaticCall(target, data, "Address: low-level static call failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
299      * but performing a static call.
300      *
301      * _Available since v3.3._
302      */
303     function functionStaticCall(
304         address target,
305         bytes memory data,
306         string memory errorMessage
307     ) internal view returns (bytes memory) {
308         require(isContract(target), "Address: static call to non-contract");
309 
310         (bool success, bytes memory returndata) = target.staticcall(data);
311         return verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but performing a delegate call.
317      *
318      * _Available since v3.4._
319      */
320     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
321         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
326      * but performing a delegate call.
327      *
328      * _Available since v3.4._
329      */
330     function functionDelegateCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal returns (bytes memory) {
335         require(isContract(target), "Address: delegate call to non-contract");
336 
337         (bool success, bytes memory returndata) = target.delegatecall(data);
338         return verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     /**
342      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
343      * revert reason using the provided one.
344      *
345      * _Available since v4.3._
346      */
347     function verifyCallResult(
348         bool success,
349         bytes memory returndata,
350         string memory errorMessage
351     ) internal pure returns (bytes memory) {
352         if (success) {
353             return returndata;
354         } else {
355             // Look for revert reason and bubble it up if present
356             if (returndata.length > 0) {
357                 // The easiest way to bubble the revert reason is using memory via assembly
358                 /// @solidity memory-safe-assembly
359                 assembly {
360                     let returndata_size := mload(returndata)
361                     revert(add(32, returndata), returndata_size)
362                 }
363             } else {
364                 revert(errorMessage);
365             }
366         }
367     }
368 }
369 
370 /**
371  * @dev This abstract contract provides getters and event emitting update functions for
372  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
373  *
374  * _Available since v4.1._
375  *
376  * @custom:oz-upgrades-unsafe-allow delegatecall
377  */
378 abstract contract ERC1967Upgrade {
379     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
380     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
381 
382     /**
383      * @dev Storage slot with the address of the current implementation.
384      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
385      * validated in the constructor.
386      */
387     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
388 
389     /**
390      * @dev Emitted when the implementation is upgraded.
391      */
392     event Upgraded(address indexed implementation);
393 
394     /**
395      * @dev Returns the current implementation address.
396      */
397     function _getImplementation() internal view returns (address) {
398         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
399     }
400 
401     /**
402      * @dev Stores a new address in the EIP1967 implementation slot.
403      */
404     function _setImplementation(address newImplementation) private {
405         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
406         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
407     }
408 
409     /**
410      * @dev Perform implementation upgrade
411      *
412      * Emits an {Upgraded} event.
413      */
414     function _upgradeTo(address newImplementation) internal {
415         _setImplementation(newImplementation);
416         emit Upgraded(newImplementation);
417     }
418 
419     /**
420      * @dev Perform implementation upgrade with additional setup call.
421      *
422      * Emits an {Upgraded} event.
423      */
424     function _upgradeToAndCall(
425         address newImplementation,
426         bytes memory data,
427         bool forceCall
428     ) internal {
429         _upgradeTo(newImplementation);
430         if (data.length > 0 || forceCall) {
431             Address.functionDelegateCall(newImplementation, data);
432         }
433     }
434 
435     /**
436      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
437      *
438      * Emits an {Upgraded} event.
439      */
440     function _upgradeToAndCallUUPS(
441         address newImplementation,
442         bytes memory data,
443         bool forceCall
444     ) internal {
445         // Upgrades from old implementations will perform a rollback test. This test requires the new
446         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
447         // this special case will break upgrade paths from old UUPS implementation to new ones.
448         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
449             _setImplementation(newImplementation);
450         } else {
451             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
452                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
453             } catch {
454                 revert("ERC1967Upgrade: new implementation is not UUPS");
455             }
456             _upgradeToAndCall(newImplementation, data, forceCall);
457         }
458     }
459 
460     /**
461      * @dev Storage slot with the admin of the contract.
462      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
463      * validated in the constructor.
464      */
465     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
466 
467     /**
468      * @dev Emitted when the admin account has changed.
469      */
470     event AdminChanged(address previousAdmin, address newAdmin);
471 
472     /**
473      * @dev Returns the current admin.
474      */
475     function _getAdmin() internal view returns (address) {
476         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
477     }
478 
479     /**
480      * @dev Stores a new address in the EIP1967 admin slot.
481      */
482     function _setAdmin(address newAdmin) private {
483         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
484         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
485     }
486 
487     /**
488      * @dev Changes the admin of the proxy.
489      *
490      * Emits an {AdminChanged} event.
491      */
492     function _changeAdmin(address newAdmin) internal {
493         emit AdminChanged(_getAdmin(), newAdmin);
494         _setAdmin(newAdmin);
495     }
496 
497     /**
498      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
499      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
500      */
501     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
502 
503     /**
504      * @dev Emitted when the beacon is upgraded.
505      */
506     event BeaconUpgraded(address indexed beacon);
507 
508     /**
509      * @dev Returns the current beacon.
510      */
511     function _getBeacon() internal view returns (address) {
512         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
513     }
514 
515     /**
516      * @dev Stores a new beacon in the EIP1967 beacon slot.
517      */
518     function _setBeacon(address newBeacon) private {
519         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
520         require(
521             Address.isContract(IBeacon(newBeacon).implementation()),
522             "ERC1967: beacon implementation is not a contract"
523         );
524         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
525     }
526 
527     /**
528      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
529      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
530      *
531      * Emits a {BeaconUpgraded} event.
532      */
533     function _upgradeBeaconToAndCall(
534         address newBeacon,
535         bytes memory data,
536         bool forceCall
537     ) internal {
538         _setBeacon(newBeacon);
539         emit BeaconUpgraded(newBeacon);
540         if (data.length > 0 || forceCall) {
541             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
542         }
543     }
544 }
545 
546 
547 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
548     /**
549      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
550      *
551      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
552      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
553      */
554     constructor(address _logic, bytes memory _data) payable {
555         _upgradeToAndCall(_logic, _data, false);
556     }
557 
558     /**
559      * @dev Returns the current implementation address.
560      */
561     function _implementation() internal view virtual override returns (address impl) {
562         return ERC1967Upgrade._getImplementation();
563     }
564 }