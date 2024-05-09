1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity ^0.8.13;
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
5 
6 /**
7  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
8  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
9  * be specified by overriding the virtual {_implementation} function.
10  *
11  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
12  * different contract through the {_delegate} function.
13  *
14  * The success and return data of the delegated call will be returned back to the caller of the proxy.
15  */
16 abstract contract Proxy {
17     /**
18      * @dev Delegates the current call to `implementation`.
19      *
20      * This function does not return to its internal call site, it will return directly to the external caller.
21      */
22     function _delegate(address implementation) internal virtual {
23         assembly {
24             // Copy msg.data. We take full control of memory in this inline assembly
25             // block because it will not return to Solidity code. We overwrite the
26             // Solidity scratch pad at memory position 0.
27             calldatacopy(0, 0, calldatasize())
28 
29             // Call the implementation.
30             // out and outsize are 0 because we don't know the size yet.
31             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
32 
33             // Copy the returned data.
34             returndatacopy(0, 0, returndatasize())
35 
36             switch result
37             // delegatecall returns 0 on error.
38             case 0 {
39                 revert(0, returndatasize())
40             }
41             default {
42                 return(0, returndatasize())
43             }
44         }
45     }
46 
47     /**
48      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
49      * and {_fallback} should delegate.
50      */
51     function _implementation() internal view virtual returns (address);
52 
53     /**
54      * @dev Delegates the current call to the address returned by `_implementation()`.
55      *
56      * This function does not return to its internal call site, it will return directly to the external caller.
57      */
58     function _fallback() internal virtual {
59         _beforeFallback();
60         _delegate(_implementation());
61     }
62 
63     /**
64      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
65      * function in the contract matches the call data.
66      */
67     fallback() external payable virtual {
68         _fallback();
69     }
70 
71     /**
72      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
73      * is empty.
74      */
75     receive() external payable virtual {
76         _fallback();
77     }
78 
79     /**
80      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
81      * call, or as part of the Solidity `fallback` or `receive` functions.
82      *
83      * If overridden should call `super._beforeFallback()`.
84      */
85     function _beforeFallback() internal virtual {}
86 }
87 
88 /// @title IERC1967Upgrade
89 /// @author Rohan Kulkarni
90 /// @notice The external ERC1967Upgrade events and errors
91 interface IERC1967Upgrade {
92     ///                                                          ///
93     ///                            EVENTS                        ///
94     ///                                                          ///
95 
96     /// @notice Emitted when the implementation is upgraded
97     /// @param impl The address of the implementation
98     event Upgraded(address impl);
99 
100     ///                                                          ///
101     ///                            ERRORS                        ///
102     ///                                                          ///
103 
104     /// @dev Reverts if an implementation is an invalid upgrade
105     /// @param impl The address of the invalid implementation
106     error INVALID_UPGRADE(address impl);
107 
108     /// @dev Reverts if an implementation upgrade is not stored at the storage slot of the original
109     error UNSUPPORTED_UUID();
110 
111     /// @dev Reverts if an implementation does not support ERC1822 proxiableUUID()
112     error ONLY_UUPS();
113 }
114 
115 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
116 
117 /**
118  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
119  * proxy whose upgrades are fully controlled by the current implementation.
120  */
121 interface IERC1822Proxiable {
122     /**
123      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
124      * address.
125      *
126      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
127      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
128      * function revert if invoked through a proxy.
129      */
130     function proxiableUUID() external view returns (bytes32);
131 }
132 
133 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
134 
135 /**
136  * @dev Library for reading and writing primitive types to specific storage slots.
137  *
138  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
139  * This library helps with reading and writing to such slots without the need for inline assembly.
140  *
141  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
142  *
143  * Example usage to set ERC1967 implementation slot:
144  * ```
145  * contract ERC1967 {
146  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
147  *
148  *     function _getImplementation() internal view returns (address) {
149  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
150  *     }
151  *
152  *     function _setImplementation(address newImplementation) internal {
153  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
154  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
155  *     }
156  * }
157  * ```
158  *
159  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
160  */
161 library StorageSlot {
162     struct AddressSlot {
163         address value;
164     }
165 
166     struct BooleanSlot {
167         bool value;
168     }
169 
170     struct Bytes32Slot {
171         bytes32 value;
172     }
173 
174     struct Uint256Slot {
175         uint256 value;
176     }
177 
178     /**
179      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
180      */
181     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
182         /// @solidity memory-safe-assembly
183         assembly {
184             r.slot := slot
185         }
186     }
187 
188     /**
189      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
190      */
191     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
192         /// @solidity memory-safe-assembly
193         assembly {
194             r.slot := slot
195         }
196     }
197 
198     /**
199      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
200      */
201     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
202         /// @solidity memory-safe-assembly
203         assembly {
204             r.slot := slot
205         }
206     }
207 
208     /**
209      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
210      */
211     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
212         /// @solidity memory-safe-assembly
213         assembly {
214             r.slot := slot
215         }
216     }
217 }
218 
219 /// @title EIP712
220 /// @author Rohan Kulkarni
221 /// @notice Modified from OpenZeppelin Contracts v4.7.3 (utils/Address.sol)
222 /// - Uses custom errors `INVALID_TARGET()` & `DELEGATE_CALL_FAILED()`
223 /// - Adds util converting address to bytes32
224 library Address {
225     ///                                                          ///
226     ///                            ERRORS                        ///
227     ///                                                          ///
228 
229     /// @dev Reverts if the target of a delegatecall is not a contract
230     error INVALID_TARGET();
231 
232     /// @dev Reverts if a delegatecall has failed
233     error DELEGATE_CALL_FAILED();
234 
235     ///                                                          ///
236     ///                           FUNCTIONS                      ///
237     ///                                                          ///
238 
239     /// @dev Utility to convert an address to bytes32
240     function toBytes32(address _account) internal pure returns (bytes32) {
241         return bytes32(uint256(uint160(_account)) << 96);
242     }
243 
244     /// @dev If an address is a contract
245     function isContract(address _account) internal view returns (bool rv) {
246         assembly {
247             rv := gt(extcodesize(_account), 0)
248         }
249     }
250 
251     /// @dev Performs a delegatecall on an address
252     function functionDelegateCall(
253         address _target,
254         bytes memory _data
255     ) internal returns (bytes memory) {
256         if (!isContract(_target)) revert INVALID_TARGET();
257 
258         (bool success, bytes memory returndata) = _target.delegatecall(_data);
259 
260         return verifyCallResult(success, returndata);
261     }
262 
263     /// @dev Verifies a delegatecall was successful
264     function verifyCallResult(
265         bool _success,
266         bytes memory _returndata
267     ) internal pure returns (bytes memory) {
268         if (_success) {
269             return _returndata;
270         } else {
271             if (_returndata.length > 0) {
272                 assembly {
273                     let returndata_size := mload(_returndata)
274 
275                     revert(add(32, _returndata), returndata_size)
276                 }
277             } else {
278                 revert DELEGATE_CALL_FAILED();
279             }
280         }
281     }
282 }
283 
284 /// @title ERC1967Upgrade
285 /// @author Rohan Kulkarni
286 /// @notice Modified from OpenZeppelin Contracts v4.7.3 (proxy/ERC1967/ERC1967Upgrade.sol)
287 /// - Uses custom errors declared in IERC1967Upgrade
288 /// - Removes ERC1967 admin and beacon support
289 abstract contract ERC1967Upgrade is IERC1967Upgrade {
290     ///                                                          ///
291     ///                          CONSTANTS                       ///
292     ///                                                          ///
293 
294     /// @dev bytes32(uint256(keccak256('eip1967.proxy.rollback')) - 1)
295     bytes32 private constant _ROLLBACK_SLOT =
296         0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
297 
298     /// @dev bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1)
299     bytes32 internal constant _IMPLEMENTATION_SLOT =
300         0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
301 
302     ///                                                          ///
303     ///                          FUNCTIONS                       ///
304     ///                                                          ///
305 
306     /// @dev Upgrades to an implementation with security checks for UUPS proxies and an additional function call
307     /// @param _newImpl The new implementation address
308     /// @param _data The encoded function call
309     function _upgradeToAndCallUUPS(
310         address _newImpl,
311         bytes memory _data,
312         bool _forceCall
313     ) internal {
314         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
315             _setImplementation(_newImpl);
316         } else {
317             try IERC1822Proxiable(_newImpl).proxiableUUID() returns (
318                 bytes32 slot
319             ) {
320                 if (slot != _IMPLEMENTATION_SLOT) revert UNSUPPORTED_UUID();
321             } catch {
322                 revert ONLY_UUPS();
323             }
324 
325             _upgradeToAndCall(_newImpl, _data, _forceCall);
326         }
327     }
328 
329     /// @dev Upgrades to an implementation with an additional function call
330     /// @param _newImpl The new implementation address
331     /// @param _data The encoded function call
332     function _upgradeToAndCall(
333         address _newImpl,
334         bytes memory _data,
335         bool _forceCall
336     ) internal {
337         _upgradeTo(_newImpl);
338 
339         if (_data.length > 0 || _forceCall) {
340             Address.functionDelegateCall(_newImpl, _data);
341         }
342     }
343 
344     /// @dev Performs an implementation upgrade
345     /// @param _newImpl The new implementation address
346     function _upgradeTo(address _newImpl) internal {
347         _setImplementation(_newImpl);
348 
349         emit Upgraded(_newImpl);
350     }
351 
352     /// @dev Stores the address of an implementation
353     /// @param _impl The implementation address
354     function _setImplementation(address _impl) private {
355         if (!Address.isContract(_impl)) revert INVALID_UPGRADE(_impl);
356 
357         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = _impl;
358     }
359 
360     /// @dev The address of the current implementation
361     function _getImplementation() internal view returns (address) {
362         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
363     }
364 }
365 
366 /// @title ERC1967Proxy
367 /// @author Rohan Kulkarni
368 /// @notice Modified from OpenZeppelin Contracts v4.7.3 (proxy/ERC1967/ERC1967Proxy.sol)
369 /// - Inherits a modern, minimal ERC1967Upgrade
370 contract ERC1967Proxy is IERC1967Upgrade, Proxy, ERC1967Upgrade {
371     ///                                                          ///
372     ///                         CONSTRUCTOR                      ///
373     ///                                                          ///
374 
375     /// @dev Initializes the proxy with an implementation contract and encoded function call
376     /// @param _logic The implementation address
377     /// @param _data The encoded function call
378     constructor(address _logic, bytes memory _data) payable {
379         _upgradeToAndCall(_logic, _data, false);
380     }
381 
382     ///                                                          ///
383     ///                          FUNCTIONS                       ///
384     ///                                                          ///
385 
386     /// @dev The address of the current implementation
387     function _implementation()
388         internal
389         view
390         virtual
391         override
392         returns (address)
393     {
394         return ERC1967Upgrade._getImplementation();
395     }
396 }
397 
398 contract TokenProxy is ERC1967Proxy {
399     constructor(address logic, bytes memory data) ERC1967Proxy(logic, data) {}
400 }
