1 // SPDX-License-Identifier: MIT
2 
3 
4 /**
5  * @author - Roi Di Segni (@sheeeev66 of @thecoredevs)
6  */
7 
8 pragma solidity ^0.8.7;
9 
10 /**
11  * @dev Library for reading and writing primitive types to specific storage slots.
12  *
13  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
14  * This library helps with reading and writing to such slots without the need for inline assembly.
15  *
16  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
17  */
18 library StorageSlot {
19     struct AddressSlot {
20         address value;
21     }
22 
23     struct BooleanSlot {
24         bool value;
25     }
26 
27     /**
28      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
29      */
30     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
31         assembly {
32             r.slot := slot
33         }
34     }
35 
36     /**
37      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
38      */
39     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
40         assembly {
41             r.slot := slot
42         }
43     }
44 }
45 
46 library Address {
47     /**
48      * @dev Returns true if `account` is a contract.
49      *
50      * [IMPORTANT]
51      * ====
52      * It is unsafe to assume that an address for which this function returns
53      * false is an externally-owned account (EOA) and not a contract.
54      *
55      * Among others, `isContract` will return false for the following
56      * types of addresses:
57      *
58      *  - an externally-owned account
59      *  - a contract in construction
60      *  - an address where a contract will be created
61      *  - an address where a contract lived, but was destroyed
62      * ====
63      *
64      * [IMPORTANT]
65      * ====
66      * You shouldn't rely on `isContract` to protect against flash loan attacks!
67      *
68      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
69      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
70      * constructor.
71      * ====
72      */
73     function isContract(address account) internal view returns (bool) {
74         // This method relies on extcodesize/address.code.length, which returns 0
75         // for contracts in construction, since the code is only stored at the end
76         // of the constructor execution.
77 
78         return account.code.length > 0;
79     }
80 
81     /**
82      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
83      * but performing a delegate call.
84      *
85      * _Available since v3.4._
86      */
87     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
93      * but performing a delegate call.
94      *
95      * _Available since v3.4._
96      */
97     function functionDelegateCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         (bool success, bytes memory returndata) = target.delegatecall(data);
103         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
104     }
105 
106     /**
107      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
108      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
109      *
110      * _Available since v4.8._
111      */
112     function verifyCallResultFromTarget(
113         address target,
114         bool success,
115         bytes memory returndata,
116         string memory errorMessage
117     ) internal view returns (bytes memory) {
118         if (success) {
119             if (returndata.length == 0) {
120                 // only check isContract if the call was successful and the return data is empty
121                 // otherwise we already know that it was a contract
122                 require(isContract(target), "Address: call to non-contract");
123             }
124             return returndata;
125         } else {
126             _revert(returndata, errorMessage);
127         }
128     }
129 
130     function _revert(bytes memory returndata, string memory errorMessage) private pure {
131         // Look for revert reason and bubble it up if present
132         if (returndata.length > 0) {
133             // The easiest way to bubble the revert reason is using memory via assembly
134             /// @solidity memory-safe-assembly
135             assembly {
136                 let returndata_size := mload(returndata)
137                 revert(add(32, returndata), returndata_size)
138             }
139         } else {
140             revert(errorMessage);
141         }
142     }
143 }
144 
145 /**
146  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
147  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
148  * be specified by overriding the virtual {_implementation} function.
149  *
150  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
151  * different contract through the {_delegate} function.
152  *
153  * The success and return data of the delegated call will be returned back to the caller of the proxy.
154  */
155 abstract contract Proxy {
156     /**
157      * @dev Delegates the current call to `implementation`.
158      *
159      * This function does not return to its internal call site, it will return directly to the external caller.
160      */
161     function _delegate(address implementation) internal virtual {
162         assembly {
163             // Copy msg.data. We take full control of memory in this inline assembly
164             // block because it will not return to Solidity code. We overwrite the
165             // Solidity scratch pad at memory position 0.
166             calldatacopy(0, 0, calldatasize())
167 
168             // Call the implementation.
169             // out and outsize are 0 because we don't know the size yet.
170             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
171 
172             // Copy the returned data.
173             returndatacopy(0, 0, returndatasize())
174 
175             switch result
176             // delegatecall returns 0 on error.
177             case 0 {
178                 revert(0, returndatasize())
179             }
180             default {
181                 return(0, returndatasize())
182             }
183         }
184     }
185 
186     /**
187      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
188      * and {_fallback} should delegate.
189      */
190     function _implementation() internal view virtual returns (address);
191 
192     /**
193      * @dev Delegates the current call to the address returned by `_implementation()`.
194      *
195      * This function does not return to its internal call site, it will return directly to the external caller.
196      */
197     function _fallback() internal virtual {
198         _beforeFallback();
199         _delegate(_implementation());
200     }
201 
202     /**
203      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
204      * function in the contract matches the call data.
205      */
206     fallback() external payable virtual {
207         _fallback();
208     }
209 
210     /**
211      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
212      * is empty.
213      */
214     receive() external payable virtual {
215         _fallback();
216     }
217 
218     /**
219      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
220      * call, or as part of the Solidity `fallback` or `receive` functions.
221      *
222      * If overridden should call `super._beforeFallback()`.
223      */
224     function _beforeFallback() internal virtual {}
225 }
226 
227 /**
228  * @dev This abstract contract provides getters and event emitting update functions for
229  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
230  */
231 abstract contract ERC1967Upgrade {
232     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
233     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
234 
235     /**
236      * @dev Storage slot with the address of the current implementation.
237      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
238      * validated in the constructor.
239      */
240     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
241 
242     /**
243      * @dev Emitted when the implementation is upgraded.
244      */
245     event Upgraded(address indexed implementation);
246 
247     /**
248      * @dev Returns the current implementation address.
249      */
250     function _getImplementation() internal view returns (address) {
251         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
252     }
253 
254     /**
255      * @dev Stores a new address in the EIP1967 implementation slot.
256      */
257     function _setImplementation(address newImplementation) private {
258         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
259         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
260     }
261 
262     /**
263      * @dev Perform implementation upgrade
264      *
265      * Emits an {Upgraded} event.
266      */
267     function _upgradeTo(address newImplementation) internal {
268         _setImplementation(newImplementation);
269         emit Upgraded(newImplementation);
270     }
271 
272     /**
273      * @dev Perform implementation upgrade with additional setup call.
274      *
275      * Emits an {Upgraded} event.
276      */
277     function _upgradeToAndCall(
278         address newImplementation,
279         bytes memory data,
280         bool forceCall
281     ) internal {
282         _upgradeTo(newImplementation);
283         if (data.length > 0 || forceCall) {
284             Address.functionDelegateCall(newImplementation, data);
285         }
286     }
287 
288     /**
289      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
290      *
291      * Emits an {Upgraded} event.
292      */
293     function _upgradeToAndCallSecure(
294         address newImplementation,
295         bytes memory data,
296         bool forceCall
297     ) internal {
298         address oldImplementation = _getImplementation();
299 
300         // Initial upgrade and setup call
301         _setImplementation(newImplementation);
302         if (data.length > 0 || forceCall) {
303             Address.functionDelegateCall(newImplementation, data);
304         }
305 
306         // Perform rollback test if not already in progress
307         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
308         if (!rollbackTesting.value) {
309             // Trigger rollback using upgradeTo from the new implementation
310             rollbackTesting.value = true;
311             Address.functionDelegateCall(
312                 newImplementation,
313                 abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
314             );
315             rollbackTesting.value = false;
316             // Check rollback was effective
317             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
318             // Finally reset to the new implementation and log the upgrade
319             _upgradeTo(newImplementation);
320         }
321     }
322 
323     /**
324      * @dev Storage slot with the admin of the contract.
325      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
326      * validated in the constructor.
327      */
328     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
329 
330     /**
331      * @dev Emitted when the admin account has changed.
332      */
333     event AdminChanged(address previousAdmin, address newAdmin);
334 
335     /**
336      * @dev Returns the current admin.
337      */
338     function _getAdmin() internal view returns (address) {
339         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
340     }
341 
342     /**
343      * @dev Stores a new address in the EIP1967 admin slot.
344      */
345     function _setAdmin(address newAdmin) private {
346         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
347         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
348     }
349 
350     /**
351      * @dev Changes the admin of the proxy.
352      *
353      * Emits an {AdminChanged} event.
354      */
355     function _changeAdmin(address newAdmin) internal {
356         emit AdminChanged(_getAdmin(), newAdmin);
357         _setAdmin(newAdmin);
358     }
359 }
360 
361 /**
362  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
363  * implementation address that can be changed. This address is stored in storage in the location specified by
364  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
365  * implementation behind the proxy.
366  */
367 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
368     /**
369      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
370      *
371      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
372      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
373      */
374     constructor(address _logic, bytes memory _data) payable {
375         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
376         _upgradeToAndCall(_logic, _data, false);
377     }
378 
379     /**
380      * @dev Returns the current implementation address.
381      */
382     function _implementation() internal view virtual override returns (address impl) {
383         return ERC1967Upgrade._getImplementation();
384     }
385 }
386 
387 contract ShroomiesProxy is ERC1967Proxy {
388 
389     modifier onlyAdmin() {
390         require(msg.sender == _getAdmin(), "Only Admin Function!");
391         _;
392     }
393     
394     constructor (address _logic, bytes memory _data) ERC1967Proxy(_logic, _data) {
395         _changeAdmin(msg.sender);
396     }
397 
398     function getAdmin() external view returns(address) {
399         return _getAdmin();
400     }
401 
402     function implementation() external view returns(address) {
403         return _implementation();
404     }
405     
406     function changeAdmin(address newAdmin) external onlyAdmin {
407         _changeAdmin(newAdmin);
408     }
409 
410     function upgradeTo(address _newImplementation) external onlyAdmin {
411         _upgradeTo(_newImplementation);
412     }
413 
414     function upgradeToAndCall(address newImplementation, bytes memory data) external onlyAdmin {
415         _upgradeToAndCall(newImplementation, data, false);
416     }
417 }