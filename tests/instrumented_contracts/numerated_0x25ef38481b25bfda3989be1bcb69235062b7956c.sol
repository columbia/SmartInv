1 /**
2  *Submitted for verification at Etherscan.io on 2023-01-01
3 */
4 
5 // Sources flattened with hardhat v2.11.1 https://hardhat.org
6 
7 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
8 
9 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
10 
11 pragma solidity ^0.8.1;
12 
13 /**
14  * @dev Collection of functions related to the address type
15  */
16 library Address {
17     /**
18      * @dev Returns true if `account` is a contract.
19      *
20      * [IMPORTANT]
21      * ====
22      * It is unsafe to assume that an address for which this function returns
23      * false is an externally-owned account (EOA) and not a contract.
24      *
25      * Among others, `isContract` will return false for the following
26      * types of addresses:
27      *
28      *  - an externally-owned account
29      *  - a contract in construction
30      *  - an address where a contract will be created
31      *  - an address where a contract lived, but was destroyed
32      * ====
33      *
34      * [IMPORTANT]
35      * ====
36      * You shouldn't rely on `isContract` to protect against flash loan attacks!
37      *
38      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
39      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
40      * constructor.
41      * ====
42      */
43     function isContract(address account) internal view returns (bool) {
44         // This method relies on extcodesize/address.code.length, which returns 0
45         // for contracts in construction, since the code is only stored at the end
46         // of the constructor execution.
47 
48         return account.code.length > 0;
49     }
50 
51     /**
52      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
53      * `recipient`, forwarding all available gas and reverting on errors.
54      *
55      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
56      * of certain opcodes, possibly making contracts go over the 2300 gas limit
57      * imposed by `transfer`, making them unable to receive funds via
58      * `transfer`. {sendValue} removes this limitation.
59      *
60      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
61      *
62      * IMPORTANT: because control is transferred to `recipient`, care must be
63      * taken to not create reentrancy vulnerabilities. Consider using
64      * {ReentrancyGuard} or the
65      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
66      */
67     function sendValue(address payable recipient, uint256 amount) internal {
68         require(address(this).balance >= amount, "Address: insufficient balance");
69 
70         (bool success, ) = recipient.call{value: amount}("");
71         require(success, "Address: unable to send value, recipient may have reverted");
72     }
73 
74     /**
75      * @dev Performs a Solidity function call using a low level `call`. A
76      * plain `call` is an unsafe replacement for a function call: use this
77      * function instead.
78      *
79      * If `target` reverts with a revert reason, it is bubbled up by this
80      * function (like regular Solidity function calls).
81      *
82      * Returns the raw returned data. To convert to the expected return value,
83      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
84      *
85      * Requirements:
86      *
87      * - `target` must be a contract.
88      * - calling `target` with `data` must not revert.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
93         return functionCall(target, data, "Address: low-level call failed");
94     }
95 
96     /**
97      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
98      * `errorMessage` as a fallback revert reason when `target` reverts.
99      *
100      * _Available since v3.1._
101      */
102     function functionCall(
103         address target,
104         bytes memory data,
105         string memory errorMessage
106     ) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, 0, errorMessage);
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
112      * but also transferring `value` wei to `target`.
113      *
114      * Requirements:
115      *
116      * - the calling contract must have an ETH balance of at least `value`.
117      * - the called Solidity function must be `payable`.
118      *
119      * _Available since v3.1._
120      */
121     function functionCallWithValue(
122         address target,
123         bytes memory data,
124         uint256 value
125     ) internal returns (bytes memory) {
126         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
127     }
128 
129     /**
130      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
131      * with `errorMessage` as a fallback revert reason when `target` reverts.
132      *
133      * _Available since v3.1._
134      */
135     function functionCallWithValue(
136         address target,
137         bytes memory data,
138         uint256 value,
139         string memory errorMessage
140     ) internal returns (bytes memory) {
141         require(address(this).balance >= value, "Address: insufficient balance for call");
142         require(isContract(target), "Address: call to non-contract");
143 
144         (bool success, bytes memory returndata) = target.call{value: value}(data);
145         return verifyCallResult(success, returndata, errorMessage);
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
150      * but performing a static call.
151      *
152      * _Available since v3.3._
153      */
154     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
155         return functionStaticCall(target, data, "Address: low-level static call failed");
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
160      * but performing a static call.
161      *
162      * _Available since v3.3._
163      */
164     function functionStaticCall(
165         address target,
166         bytes memory data,
167         string memory errorMessage
168     ) internal view returns (bytes memory) {
169         require(isContract(target), "Address: static call to non-contract");
170 
171         (bool success, bytes memory returndata) = target.staticcall(data);
172         return verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
177      * but performing a delegate call.
178      *
179      * _Available since v3.4._
180      */
181     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
182         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
187      * but performing a delegate call.
188      *
189      * _Available since v3.4._
190      */
191     function functionDelegateCall(
192         address target,
193         bytes memory data,
194         string memory errorMessage
195     ) internal returns (bytes memory) {
196         require(isContract(target), "Address: delegate call to non-contract");
197 
198         (bool success, bytes memory returndata) = target.delegatecall(data);
199         return verifyCallResult(success, returndata, errorMessage);
200     }
201 
202     /**
203      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
204      * revert reason using the provided one.
205      *
206      * _Available since v4.3._
207      */
208     function verifyCallResult(
209         bool success,
210         bytes memory returndata,
211         string memory errorMessage
212     ) internal pure returns (bytes memory) {
213         if (success) {
214             return returndata;
215         } else {
216             // Look for revert reason and bubble it up if present
217             if (returndata.length > 0) {
218                 // The easiest way to bubble the revert reason is using memory via assembly
219                 /// @solidity memory-safe-assembly
220                 assembly {
221                     let returndata_size := mload(returndata)
222                     revert(add(32, returndata), returndata_size)
223                 }
224             } else {
225                 revert(errorMessage);
226             }
227         }
228     }
229 }
230 
231 
232 // File @openzeppelin/contracts/proxy/Proxy.sol@v4.7.3
233 
234 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
240  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
241  * be specified by overriding the virtual {_implementation} function.
242  *
243  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
244  * different contract through the {_delegate} function.
245  *
246  * The success and return data of the delegated call will be returned back to the caller of the proxy.
247  */
248 abstract contract Proxy {
249     /**
250      * @dev Delegates the current call to `implementation`.
251      *
252      * This function does not return to its internal call site, it will return directly to the external caller.
253      */
254     function _delegate(address implementation) internal virtual {
255         assembly {
256             // Copy msg.data. We take full control of memory in this inline assembly
257             // block because it will not return to Solidity code. We overwrite the
258             // Solidity scratch pad at memory position 0.
259             calldatacopy(0, 0, calldatasize())
260 
261             // Call the implementation.
262             // out and outsize are 0 because we don't know the size yet.
263             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
264 
265             // Copy the returned data.
266             returndatacopy(0, 0, returndatasize())
267 
268             switch result
269             // delegatecall returns 0 on error.
270             case 0 {
271                 revert(0, returndatasize())
272             }
273             default {
274                 return(0, returndatasize())
275             }
276         }
277     }
278 
279     /**
280      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
281      * and {_fallback} should delegate.
282      */
283     function _implementation() internal view virtual returns (address);
284 
285     /**
286      * @dev Delegates the current call to the address returned by `_implementation()`.
287      *
288      * This function does not return to its internal call site, it will return directly to the external caller.
289      */
290     function _fallback() internal virtual {
291         _beforeFallback();
292         _delegate(_implementation());
293     }
294 
295     /**
296      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
297      * function in the contract matches the call data.
298      */
299     fallback() external payable virtual {
300         _fallback();
301     }
302 
303     /**
304      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
305      * is empty.
306      */
307     receive() external payable virtual {
308         _fallback();
309     }
310 
311     /**
312      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
313      * call, or as part of the Solidity `fallback` or `receive` functions.
314      *
315      * If overridden should call `super._beforeFallback()`.
316      */
317     function _beforeFallback() internal virtual {}
318 }
319 
320 
321 // File @openzeppelin/contracts/utils/StorageSlot.sol@v4.7.3
322 
323 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
324 
325 pragma solidity ^0.8.0;
326 
327 /**
328  * @dev Library for reading and writing primitive types to specific storage slots.
329  *
330  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
331  * This library helps with reading and writing to such slots without the need for inline assembly.
332  *
333  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
334  *
335  * Example usage to set ERC1967 implementation slot:
336  * ```
337  * contract ERC1967 {
338  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
339  *
340  *     function _getImplementation() internal view returns (address) {
341  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
342  *     }
343  *
344  *     function _setImplementation(address newImplementation) internal {
345  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
346  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
347  *     }
348  * }
349  * ```
350  *
351  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
352  */
353 library StorageSlot {
354     struct AddressSlot {
355         address value;
356     }
357 
358     struct BooleanSlot {
359         bool value;
360     }
361 
362     struct Bytes32Slot {
363         bytes32 value;
364     }
365 
366     struct Uint256Slot {
367         uint256 value;
368     }
369 
370     /**
371      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
372      */
373     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
374         /// @solidity memory-safe-assembly
375         assembly {
376             r.slot := slot
377         }
378     }
379 
380     /**
381      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
382      */
383     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
384         /// @solidity memory-safe-assembly
385         assembly {
386             r.slot := slot
387         }
388     }
389 
390     /**
391      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
392      */
393     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
394         /// @solidity memory-safe-assembly
395         assembly {
396             r.slot := slot
397         }
398     }
399 
400     /**
401      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
402      */
403     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
404         /// @solidity memory-safe-assembly
405         assembly {
406             r.slot := slot
407         }
408     }
409 }
410 
411 
412 // File contracts/BitHeroes.sol
413 
414 pragma solidity ^0.8.7;
415 
416 
417 
418 contract ERC721ContractWrapper is Proxy {
419     address internal constant _IMPLEMENTATION_ADDRESS = 0xf96Fd95D60fB0318B639a8211ef60EE467F2892a;
420     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
421 
422     constructor(
423         string memory _name,
424         string memory _symbol,
425         uint256 _totalSupply,
426         uint256 _commission
427     ) {
428         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
429         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = _IMPLEMENTATION_ADDRESS;
430         Address.functionDelegateCall(
431             _IMPLEMENTATION_ADDRESS,
432             abi.encodeWithSignature("initialize(string,string,uint256,uint256)", _name, _symbol, _totalSupply, _commission)
433         );
434     }
435 
436     /**
437      * @dev Returns the current implementation address.
438      */
439      function implementation() public view returns (address) {
440         return _implementation();
441     }
442 
443     function _implementation() internal override view returns (address) {
444         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
445     }
446 }
447 
448 
449 ///
450 /// This contract was generated by Alcapoccino
451 ///
452 contract TheCherry is ERC721ContractWrapper {
453   constructor(
454     string memory _name,
455     string memory _symbol,
456     uint256 _totalSupply,
457     uint256 _commission
458   ) ERC721ContractWrapper(_name,_symbol,_totalSupply,_commission) {}
459 }