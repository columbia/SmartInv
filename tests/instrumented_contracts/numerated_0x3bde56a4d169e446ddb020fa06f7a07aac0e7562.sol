1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.7;
4 
5 /**
6  * @dev Library for reading and writing primitive types to specific storage slots.
7  *
8  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
9  * This library helps with reading and writing to such slots without the need for inline assembly.
10  *
11  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
12  */
13 library StorageSlot {
14     struct AddressSlot {
15         address value;
16     }
17 
18     struct BooleanSlot {
19         bool value;
20     }
21 
22     /**
23      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
24      */
25     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
26         assembly {
27             r.slot := slot
28         }
29     }
30 
31     /**
32      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
33      */
34     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
35         assembly {
36             r.slot := slot
37         }
38     }
39 }
40 
41 library Address {
42     /**
43      * @dev Returns true if `account` is a contract.
44      *
45      * [IMPORTANT]
46      * ====
47      * It is unsafe to assume that an address for which this function returns
48      * false is an externally-owned account (EOA) and not a contract.
49      *
50      * Among others, `isContract` will return false for the following
51      * types of addresses:
52      *
53      *  - an externally-owned account
54      *  - a contract in construction
55      *  - an address where a contract will be created
56      *  - an address where a contract lived, but was destroyed
57      * ====
58      *
59      * [IMPORTANT]
60      * ====
61      * You shouldn't rely on `isContract` to protect against flash loan attacks!
62      *
63      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
64      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
65      * constructor.
66      * ====
67      */
68     function isContract(address account) internal view returns (bool) {
69         // This method relies on extcodesize/address.code.length, which returns 0
70         // for contracts in construction, since the code is only stored at the end
71         // of the constructor execution.
72 
73         return account.code.length > 0;
74     }
75 
76     /**
77      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
78      * but performing a delegate call.
79      *
80      * _Available since v3.4._
81      */
82     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
83         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
84     }
85 
86     /**
87      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
88      * but performing a delegate call.
89      *
90      * _Available since v3.4._
91      */
92     function functionDelegateCall(
93         address target,
94         bytes memory data,
95         string memory errorMessage
96     ) internal returns (bytes memory) {
97         (bool success, bytes memory returndata) = target.delegatecall(data);
98         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
99     }
100 
101     /**
102      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
103      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
104      *
105      * _Available since v4.8._
106      */
107     function verifyCallResultFromTarget(
108         address target,
109         bool success,
110         bytes memory returndata,
111         string memory errorMessage
112     ) internal view returns (bytes memory) {
113         if (success) {
114             if (returndata.length == 0) {
115                 // only check isContract if the call was successful and the return data is empty
116                 // otherwise we already know that it was a contract
117                 require(isContract(target), "Address: call to non-contract");
118             }
119             return returndata;
120         } else {
121             _revert(returndata, errorMessage);
122         }
123     }
124 
125     function _revert(bytes memory returndata, string memory errorMessage) private pure {
126         // Look for revert reason and bubble it up if present
127         if (returndata.length > 0) {
128             // The easiest way to bubble the revert reason is using memory via assembly
129             /// @solidity memory-safe-assembly
130             assembly {
131                 let returndata_size := mload(returndata)
132                 revert(add(32, returndata), returndata_size)
133             }
134         } else {
135             revert(errorMessage);
136         }
137     }
138 }
139 
140 /**
141  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
142  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
143  * be specified by overriding the virtual {_implementation} function.
144  *
145  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
146  * different contract through the {_delegate} function.
147  *
148  * The success and return data of the delegated call will be returned back to the caller of the proxy.
149  */
150 abstract contract Proxy {
151     /**
152      * @dev Delegates the current call to `implementation`.
153      *
154      * This function does not return to its internal call site, it will return directly to the external caller.
155      */
156     function _delegate(address implementation) internal virtual {
157         assembly {
158             // Copy msg.data. We take full control of memory in this inline assembly
159             // block because it will not return to Solidity code. We overwrite the
160             // Solidity scratch pad at memory position 0.
161             calldatacopy(0, 0, calldatasize())
162 
163             // Call the implementation.
164             // out and outsize are 0 because we don't know the size yet.
165             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
166 
167             // Copy the returned data.
168             returndatacopy(0, 0, returndatasize())
169 
170             switch result
171             // delegatecall returns 0 on error.
172             case 0 {
173                 revert(0, returndatasize())
174             }
175             default {
176                 return(0, returndatasize())
177             }
178         }
179     }
180 
181     /**
182      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
183      * and {_fallback} should delegate.
184      */
185     function _implementation() internal view virtual returns (address);
186 
187     /**
188      * @dev Delegates the current call to the address returned by `_implementation()`.
189      *
190      * This function does not return to its internal call site, it will return directly to the external caller.
191      */
192     function _fallback() internal virtual {
193         _beforeFallback();
194         _delegate(_implementation());
195     }
196 
197     /**
198      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
199      * function in the contract matches the call data.
200      */
201     fallback() external payable virtual {
202         _fallback();
203     }
204 
205     /**
206      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
207      * is empty.
208      */
209     receive() external payable virtual {
210         _fallback();
211     }
212 
213     /**
214      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
215      * call, or as part of the Solidity `fallback` or `receive` functions.
216      *
217      * If overridden should call `super._beforeFallback()`.
218      */
219     function _beforeFallback() internal virtual {}
220 }
221 
222 /**
223  * @dev This abstract contract provides getters and event emitting update functions for
224  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
225  */
226 abstract contract ERC1967Upgrade {
227     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
228     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
229 
230     /**
231      * @dev Storage slot with the address of the current implementation.
232      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
233      * validated in the constructor.
234      */
235     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
236 
237     /**
238      * @dev Emitted when the implementation is upgraded.
239      */
240     event Upgraded(address indexed implementation);
241 
242     /**
243      * @dev Returns the current implementation address.
244      */
245     function _getImplementation() internal view returns (address) {
246         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
247     }
248 
249     /**
250      * @dev Stores a new address in the EIP1967 implementation slot.
251      */
252     function _setImplementation(address newImplementation) private {
253         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
254         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
255     }
256 
257     /**
258      * @dev Perform implementation upgrade
259      *
260      * Emits an {Upgraded} event.
261      */
262     function _upgradeTo(address newImplementation) internal {
263         _setImplementation(newImplementation);
264         emit Upgraded(newImplementation);
265     }
266 
267     /**
268      * @dev Perform implementation upgrade with additional setup call.
269      *
270      * Emits an {Upgraded} event.
271      */
272     function _upgradeToAndCall(
273         address newImplementation,
274         bytes memory data,
275         bool forceCall
276     ) internal {
277         _upgradeTo(newImplementation);
278         if (data.length > 0 || forceCall) {
279             Address.functionDelegateCall(newImplementation, data);
280         }
281     }
282 
283     /**
284      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
285      *
286      * Emits an {Upgraded} event.
287      */
288     function _upgradeToAndCallSecure(
289         address newImplementation,
290         bytes memory data,
291         bool forceCall
292     ) internal {
293         address oldImplementation = _getImplementation();
294 
295         // Initial upgrade and setup call
296         _setImplementation(newImplementation);
297         if (data.length > 0 || forceCall) {
298             Address.functionDelegateCall(newImplementation, data);
299         }
300 
301         // Perform rollback test if not already in progress
302         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
303         if (!rollbackTesting.value) {
304             // Trigger rollback using upgradeTo from the new implementation
305             rollbackTesting.value = true;
306             Address.functionDelegateCall(
307                 newImplementation,
308                 abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
309             );
310             rollbackTesting.value = false;
311             // Check rollback was effective
312             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
313             // Finally reset to the new implementation and log the upgrade
314             _upgradeTo(newImplementation);
315         }
316     }
317 
318     /**
319      * @dev Storage slot with the admin of the contract.
320      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
321      * validated in the constructor.
322      */
323     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
324 
325     /**
326      * @dev Emitted when the admin account has changed.
327      */
328     event AdminChanged(address previousAdmin, address newAdmin);
329 
330     /**
331      * @dev Returns the current admin.
332      */
333     function _getAdmin() internal view returns (address) {
334         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
335     }
336 
337     /**
338      * @dev Stores a new address in the EIP1967 admin slot.
339      */
340     function _setAdmin(address newAdmin) private {
341         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
342         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
343     }
344 
345     /**
346      * @dev Changes the admin of the proxy.
347      *
348      * Emits an {AdminChanged} event.
349      */
350     function _changeAdmin(address newAdmin) internal {
351         emit AdminChanged(_getAdmin(), newAdmin);
352         _setAdmin(newAdmin);
353     }
354 }
355 
356 /**
357  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
358  * implementation address that can be changed. This address is stored in storage in the location specified by
359  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
360  * implementation behind the proxy.
361  */
362 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
363     /**
364      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
365      *
366      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
367      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
368      */
369     constructor(address _logic, bytes memory _data) payable {
370         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
371         _upgradeToAndCall(_logic, _data, false);
372     }
373 
374     /**
375      * @dev Returns the current implementation address.
376      */
377     function _implementation() internal view virtual override returns (address impl) {
378         return ERC1967Upgrade._getImplementation();
379     }
380 }
381 
382 contract CyberFriendsProxy is ERC1967Proxy {
383 
384     modifier onlyAdmin() {
385         require(msg.sender == _getAdmin(), "Only Admin Function!");
386         _;
387     }
388     
389     constructor (address _logic, bytes memory _data) ERC1967Proxy(_logic, _data) {
390         _changeAdmin(msg.sender);
391     }
392 
393     function getAdmin() external view returns(address) {
394         return _getAdmin();
395     }
396 
397     function implementation() external view returns(address) {
398         return _implementation();
399     }
400     
401     function changeAdmin(address newAdmin) external onlyAdmin {
402         _changeAdmin(newAdmin);
403     }
404 
405     function upgradeTo(address _newImplementation) external onlyAdmin {
406         _upgradeTo(_newImplementation);
407     }
408 
409     function upgradeToAndCall(address newImplementation, bytes memory data) external onlyAdmin {
410         _upgradeToAndCall(newImplementation, data, false);
411     }
412 }