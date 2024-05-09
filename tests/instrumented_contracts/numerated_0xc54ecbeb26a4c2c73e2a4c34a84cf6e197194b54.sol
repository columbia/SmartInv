1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.16;
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
252     function functionDelegateCall(address _target, bytes memory _data) internal returns (bytes memory) {
253         if (!isContract(_target)) revert INVALID_TARGET();
254 
255         (bool success, bytes memory returndata) = _target.delegatecall(_data);
256 
257         return verifyCallResult(success, returndata);
258     }
259 
260     /// @dev Verifies a delegatecall was successful
261     function verifyCallResult(bool _success, bytes memory _returndata) internal pure returns (bytes memory) {
262         if (_success) {
263             return _returndata;
264         } else {
265             if (_returndata.length > 0) {
266                 assembly {
267                     let returndata_size := mload(_returndata)
268 
269                     revert(add(32, _returndata), returndata_size)
270                 }
271             } else {
272                 revert DELEGATE_CALL_FAILED();
273             }
274         }
275     }
276 }
277 
278 /// @title ERC1967Upgrade
279 /// @author Rohan Kulkarni
280 /// @notice Modified from OpenZeppelin Contracts v4.7.3 (proxy/ERC1967/ERC1967Upgrade.sol)
281 /// - Uses custom errors declared in IERC1967Upgrade
282 /// - Removes ERC1967 admin and beacon support
283 abstract contract ERC1967Upgrade is IERC1967Upgrade {
284     ///                                                          ///
285     ///                          CONSTANTS                       ///
286     ///                                                          ///
287 
288     /// @dev bytes32(uint256(keccak256('eip1967.proxy.rollback')) - 1)
289     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
290 
291     /// @dev bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1)
292     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
293 
294     ///                                                          ///
295     ///                          FUNCTIONS                       ///
296     ///                                                          ///
297 
298     /// @dev Upgrades to an implementation with security checks for UUPS proxies and an additional function call
299     /// @param _newImpl The new implementation address
300     /// @param _data The encoded function call
301     function _upgradeToAndCallUUPS(
302         address _newImpl,
303         bytes memory _data,
304         bool _forceCall
305     ) internal {
306         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
307             _setImplementation(_newImpl);
308         } else {
309             try IERC1822Proxiable(_newImpl).proxiableUUID() returns (bytes32 slot) {
310                 if (slot != _IMPLEMENTATION_SLOT) revert UNSUPPORTED_UUID();
311             } catch {
312                 revert ONLY_UUPS();
313             }
314 
315             _upgradeToAndCall(_newImpl, _data, _forceCall);
316         }
317     }
318 
319     /// @dev Upgrades to an implementation with an additional function call
320     /// @param _newImpl The new implementation address
321     /// @param _data The encoded function call
322     function _upgradeToAndCall(
323         address _newImpl,
324         bytes memory _data,
325         bool _forceCall
326     ) internal {
327         _upgradeTo(_newImpl);
328 
329         if (_data.length > 0 || _forceCall) {
330             Address.functionDelegateCall(_newImpl, _data);
331         }
332     }
333 
334     /// @dev Performs an implementation upgrade
335     /// @param _newImpl The new implementation address
336     function _upgradeTo(address _newImpl) internal {
337         _setImplementation(_newImpl);
338 
339         emit Upgraded(_newImpl);
340     }
341 
342     /// @dev Stores the address of an implementation
343     /// @param _impl The implementation address
344     function _setImplementation(address _impl) private {
345         if (!Address.isContract(_impl)) revert INVALID_UPGRADE(_impl);
346 
347         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = _impl;
348     }
349 
350     /// @dev The address of the current implementation
351     function _getImplementation() internal view returns (address) {
352         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
353     }
354 }
355 
356 /// @title ERC1967Proxy
357 /// @author Rohan Kulkarni
358 /// @notice Modified from OpenZeppelin Contracts v4.7.3 (proxy/ERC1967/ERC1967Proxy.sol)
359 /// - Inherits a modern, minimal ERC1967Upgrade
360 contract ERC1967Proxy is IERC1967Upgrade, Proxy, ERC1967Upgrade {
361     ///                                                          ///
362     ///                         CONSTRUCTOR                      ///
363     ///                                                          ///
364 
365     /// @dev Initializes the proxy with an implementation contract and encoded function call
366     /// @param _logic The implementation address
367     /// @param _data The encoded function call
368     constructor(address _logic, bytes memory _data) payable {
369         _upgradeToAndCall(_logic, _data, false);
370     }
371 
372     ///                                                          ///
373     ///                          FUNCTIONS                       ///
374     ///                                                          ///
375 
376     /// @dev The address of the current implementation
377     function _implementation() internal view virtual override returns (address) {
378         return ERC1967Upgrade._getImplementation();
379     }
380 }