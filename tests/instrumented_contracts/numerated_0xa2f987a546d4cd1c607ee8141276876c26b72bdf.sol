1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.4;
4 
5 
6 ////////////////////////////////////////////////////////////////////////////////////////////////////
7 /// PART: OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/utils/Address.sol ////////////////////
8 ////////////////////////////////////////////////////////////////////////////////////////////////////
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library Address {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      */
31     function isContract(address account) internal view returns (bool) {
32         // This method relies on extcodesize, which returns 0 for contracts in
33         // construction, since the code is only stored at the end of the
34         // constructor execution.
35 
36         uint256 size;
37         // solhint-disable-next-line no-inline-assembly
38         assembly { size := extcodesize(account) }
39         return size > 0;
40     }
41 
42     /**
43      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
44      * `recipient`, forwarding all available gas and reverting on errors.
45      *
46      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
47      * of certain opcodes, possibly making contracts go over the 2300 gas limit
48      * imposed by `transfer`, making them unable to receive funds via
49      * `transfer`. {sendValue} removes this limitation.
50      *
51      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
52      *
53      * IMPORTANT: because control is transferred to `recipient`, care must be
54      * taken to not create reentrancy vulnerabilities. Consider using
55      * {ReentrancyGuard} or the
56      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
57      */
58     function sendValue(address payable recipient, uint256 amount) internal {
59         require(address(this).balance >= amount, "Address: insufficient balance");
60 
61         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
62         (bool success, ) = recipient.call{ value: amount }("");
63         require(success, "Address: unable to send value, recipient may have reverted");
64     }
65 
66     /**
67      * @dev Performs a Solidity function call using a low level `call`. A
68      * plain`call` is an unsafe replacement for a function call: use this
69      * function instead.
70      *
71      * If `target` reverts with a revert reason, it is bubbled up by this
72      * function (like regular Solidity function calls).
73      *
74      * Returns the raw returned data. To convert to the expected return value,
75      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
76      *
77      * Requirements:
78      *
79      * - `target` must be a contract.
80      * - calling `target` with `data` must not revert.
81      *
82      * _Available since v3.1._
83      */
84     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
85       return functionCall(target, data, "Address: low-level call failed");
86     }
87 
88     /**
89      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
90      * `errorMessage` as a fallback revert reason when `target` reverts.
91      *
92      * _Available since v3.1._
93      */
94     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
95         return functionCallWithValue(target, data, 0, errorMessage);
96     }
97 
98     /**
99      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
100      * but also transferring `value` wei to `target`.
101      *
102      * Requirements:
103      *
104      * - the calling contract must have an ETH balance of at least `value`.
105      * - the called Solidity function must be `payable`.
106      *
107      * _Available since v3.1._
108      */
109     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
110         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
111     }
112 
113     /**
114      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
115      * with `errorMessage` as a fallback revert reason when `target` reverts.
116      *
117      * _Available since v3.1._
118      */
119     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
120         require(address(this).balance >= value, "Address: insufficient balance for call");
121         require(isContract(target), "Address: call to non-contract");
122 
123         // solhint-disable-next-line avoid-low-level-calls
124         (bool success, bytes memory returndata) = target.call{ value: value }(data);
125         return _verifyCallResult(success, returndata, errorMessage);
126     }
127 
128     /**
129      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
130      * but performing a static call.
131      *
132      * _Available since v3.3._
133      */
134     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
135         return functionStaticCall(target, data, "Address: low-level static call failed");
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
140      * but performing a static call.
141      *
142      * _Available since v3.3._
143      */
144     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
145         require(isContract(target), "Address: static call to non-contract");
146 
147         // solhint-disable-next-line avoid-low-level-calls
148         (bool success, bytes memory returndata) = target.staticcall(data);
149         return _verifyCallResult(success, returndata, errorMessage);
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
154      * but performing a delegate call.
155      *
156      * _Available since v3.4._
157      */
158     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
159         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
164      * but performing a delegate call.
165      *
166      * _Available since v3.4._
167      */
168     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
169         require(isContract(target), "Address: delegate call to non-contract");
170 
171         // solhint-disable-next-line avoid-low-level-calls
172         (bool success, bytes memory returndata) = target.delegatecall(data);
173         return _verifyCallResult(success, returndata, errorMessage);
174     }
175 
176     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
177         if (success) {
178             return returndata;
179         } else {
180             // Look for revert reason and bubble it up if present
181             if (returndata.length > 0) {
182                 // The easiest way to bubble the revert reason is using memory via assembly
183 
184                 // solhint-disable-next-line no-inline-assembly
185                 assembly {
186                     let returndata_size := mload(returndata)
187                     revert(add(32, returndata), returndata_size)
188                 }
189             } else {
190                 revert(errorMessage);
191             }
192         }
193     }
194 }
195 
196 
197 ////////////////////////////////////////////////////////////////////////////////////////////////////
198 /// PART: OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/proxy/Proxy.sol //////////////////////
199 ////////////////////////////////////////////////////////////////////////////////////////////////////
200 
201 /**
202  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
203  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
204  * be specified by overriding the virtual {_implementation} function.
205  *
206  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
207  * different contract through the {_delegate} function.
208  *
209  * The success and return data of the delegated call will be returned back to the caller of the proxy.
210  */
211 abstract contract Proxy {
212     /**
213      * @dev Delegates the current call to `implementation`.
214      *
215      * This function does not return to its internall call site, it will return directly to the external caller.
216      */
217     function _delegate(address implementation) internal virtual {
218         // solhint-disable-next-line no-inline-assembly
219         assembly {
220             // Copy msg.data. We take full control of memory in this inline assembly
221             // block because it will not return to Solidity code. We overwrite the
222             // Solidity scratch pad at memory position 0.
223             calldatacopy(0, 0, calldatasize())
224 
225             // Call the implementation.
226             // out and outsize are 0 because we don't know the size yet.
227             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
228 
229             // Copy the returned data.
230             returndatacopy(0, 0, returndatasize())
231 
232             switch result
233             // delegatecall returns 0 on error.
234             case 0 { revert(0, returndatasize()) }
235             default { return(0, returndatasize()) }
236         }
237     }
238 
239     /**
240      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
241      * and {_fallback} should delegate.
242      */
243     function _implementation() internal view virtual returns (address);
244 
245     /**
246      * @dev Delegates the current call to the address returned by `_implementation()`.
247      *
248      * This function does not return to its internall call site, it will return directly to the external caller.
249      */
250     function _fallback() internal virtual {
251         _beforeFallback();
252         _delegate(_implementation());
253     }
254 
255     /**
256      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
257      * function in the contract matches the call data.
258      */
259     fallback () external payable virtual {
260         _fallback();
261     }
262 
263     /**
264      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
265      * is empty.
266      */
267     receive () external payable virtual {
268         _fallback();
269     }
270 
271     /**
272      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
273      * call, or as part of the Solidity `fallback` or `receive` functions.
274      *
275      * If overriden should call `super._beforeFallback()`.
276      */
277     function _beforeFallback() internal virtual {
278     }
279 }
280 
281 
282 ////////////////////////////////////////////////////////////////////////////////////////////////////
283 /// PART: OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/proxy/ERC1967/ERC1967Proxy.sol ///////
284 ////////////////////////////////////////////////////////////////////////////////////////////////////
285 
286 /**
287  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
288  * implementation address that can be changed. This address is stored in storage in the location specified by
289  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
290  * implementation behind the proxy.
291  *
292  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
293  * {TransparentUpgradeableProxy}.
294  */
295 contract ERC1967Proxy is Proxy {
296     /**
297      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
298      *
299      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
300      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
301      */
302     constructor(address _logic, bytes memory _data) payable {
303         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
304         _setImplementation(_logic);
305         if(_data.length > 0) {
306             Address.functionDelegateCall(_logic, _data);
307         }
308     }
309 
310     /**
311      * @dev Emitted when the implementation is upgraded.
312      */
313     event Upgraded(address indexed implementation);
314 
315     /**
316      * @dev Storage slot with the address of the current implementation.
317      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
318      * validated in the constructor.
319      */
320     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
321 
322     /**
323      * @dev Returns the current implementation address.
324      */
325     function _implementation() internal view virtual override returns (address impl) {
326         bytes32 slot = _IMPLEMENTATION_SLOT;
327         // solhint-disable-next-line no-inline-assembly
328         assembly {
329             impl := sload(slot)
330         }
331     }
332 
333     /**
334      * @dev Upgrades the proxy to a new implementation.
335      *
336      * Emits an {Upgraded} event.
337      */
338     function _upgradeTo(address newImplementation) internal virtual {
339         _setImplementation(newImplementation);
340         emit Upgraded(newImplementation);
341     }
342 
343     /**
344      * @dev Stores a new address in the EIP1967 implementation slot.
345      */
346     function _setImplementation(address newImplementation) private {
347         require(Address.isContract(newImplementation), "ERC1967Proxy: new implementation is not a contract");
348 
349         bytes32 slot = _IMPLEMENTATION_SLOT;
350 
351         // solhint-disable-next-line no-inline-assembly
352         assembly {
353             sstore(slot, newImplementation)
354         }
355     }
356 }
357 
358 
359 ////////////////////////////////////////////////////////////////////////////////////////////////////
360 /// PART: AnchorVaultProxy.sol /////////////////////////////////////////////////////////////////////
361 ////////////////////////////////////////////////////////////////////////////////////////////////////
362 
363 /**
364  * @dev Copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.1.0/contracts/utils/StorageSlot.sol
365  */
366 library StorageSlot {
367     struct AddressSlot {
368         address value;
369     }
370 
371     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
372         assembly {
373             r.slot := slot
374         }
375     }
376 }
377 
378 /**
379  * @dev An ossifiable proxy for AnchorVault contract.
380  */
381 contract AnchorVaultProxy is ERC1967Proxy {
382     /**
383      * @dev Storage slot with the admin of the contract.
384      *
385      * Equals `bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1)`.
386      */
387     bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
388 
389     /**
390      * @dev Emitted when the admin account has changed.
391      */
392     event AdminChanged(address previousAdmin, address newAdmin);
393 
394     /**
395      * @dev Initializes the upgradeable proxy with the initial implementation and admin.
396      */
397     constructor(address implementation, address admin)
398         ERC1967Proxy(implementation, new bytes(0))
399     {
400         _setAdmin(admin);
401     }
402 
403     /**
404      * @return Returns the current implementation address.
405      */
406     function implementation() external view returns (address) {
407         return _implementation();
408     }
409 
410     /**
411      * @dev Upgrades the proxy to a new implementation, optionally performing an additional
412      * setup call.
413      *
414      * Can only be called by the proxy admin until the proxy is ossified.
415      * Cannot be called after the proxy is ossified.
416      *
417      * Emits an {Upgraded} event.
418      *
419      * @param setupCalldata Data for the setup call. The call is skipped if data is empty.
420      */
421     function proxy_upgradeTo(address newImplementation, bytes memory setupCalldata) external {
422         address admin = _getAdmin();
423         require(admin != address(0), "proxy: ossified");
424         require(msg.sender == admin, "proxy: unauthorized");
425 
426         _upgradeTo(newImplementation);
427 
428         if (setupCalldata.length > 0) {
429             Address.functionDelegateCall(newImplementation, setupCalldata, "proxy: setup failed");
430         }
431     }
432 
433     /**
434      * @dev Returns the current admin.
435      */
436     function _getAdmin() internal view returns (address) {
437         return StorageSlot.getAddressSlot(ADMIN_SLOT).value;
438     }
439 
440     /**
441      * @dev Stores a new address in the EIP1967 admin slot.
442      */
443     function _setAdmin(address newAdmin) private {
444         StorageSlot.getAddressSlot(ADMIN_SLOT).value = newAdmin;
445     }
446 
447     /**
448      * @dev Returns the current admin of the proxy.
449      */
450     function proxy_getAdmin() external view returns (address) {
451         return _getAdmin();
452     }
453 
454     /**
455      * @dev Changes the admin of the proxy.
456      *
457      * Emits an {AdminChanged} event.
458      */
459     function proxy_changeAdmin(address newAdmin) external {
460         address admin = _getAdmin();
461         require(admin != address(0), "proxy: ossified");
462         require(msg.sender == admin, "proxy: unauthorized");
463         emit AdminChanged(admin, newAdmin);
464         _setAdmin(newAdmin);
465     }
466 
467     /**
468      * @dev Returns whether the implementation is locked forever.
469      */
470     function proxy_getIsOssified() external view returns (bool) {
471         return _getAdmin() == address(0);
472     }
473 }