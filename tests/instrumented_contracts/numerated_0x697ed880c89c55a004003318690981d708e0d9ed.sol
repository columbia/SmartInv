1 // Sources flattened with hardhat v2.11.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
6 
7 pragma solidity ^0.8.1;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      *
30      * [IMPORTANT]
31      * ====
32      * You shouldn't rely on `isContract` to protect against flash loan attacks!
33      *
34      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
35      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
36      * constructor.
37      * ====
38      */
39     function isContract(address account) internal view returns (bool) {
40         // This method relies on extcodesize/address.code.length, which returns 0
41         // for contracts in construction, since the code is only stored at the end
42         // of the constructor execution.
43 
44         return account.code.length > 0;
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      */
63     function sendValue(address payable recipient, uint256 amount) internal {
64         require(address(this).balance >= amount, "Address: insufficient balance");
65 
66         (bool success, ) = recipient.call{value: amount}("");
67         require(success, "Address: unable to send value, recipient may have reverted");
68     }
69 
70     /**
71      * @dev Performs a Solidity function call using a low level `call`. A
72      * plain `call` is an unsafe replacement for a function call: use this
73      * function instead.
74      *
75      * If `target` reverts with a revert reason, it is bubbled up by this
76      * function (like regular Solidity function calls).
77      *
78      * Returns the raw returned data. To convert to the expected return value,
79      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
80      *
81      * Requirements:
82      *
83      * - `target` must be a contract.
84      * - calling `target` with `data` must not revert.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
89         return functionCall(target, data, "Address: low-level call failed");
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
94      * `errorMessage` as a fallback revert reason when `target` reverts.
95      *
96      * _Available since v3.1._
97      */
98     function functionCall(
99         address target,
100         bytes memory data,
101         string memory errorMessage
102     ) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, 0, errorMessage);
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
108      * but also transferring `value` wei to `target`.
109      *
110      * Requirements:
111      *
112      * - the calling contract must have an ETH balance of at least `value`.
113      * - the called Solidity function must be `payable`.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(
118         address target,
119         bytes memory data,
120         uint256 value
121     ) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
127      * with `errorMessage` as a fallback revert reason when `target` reverts.
128      *
129      * _Available since v3.1._
130      */
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value,
135         string memory errorMessage
136     ) internal returns (bytes memory) {
137         require(address(this).balance >= value, "Address: insufficient balance for call");
138         require(isContract(target), "Address: call to non-contract");
139 
140         (bool success, bytes memory returndata) = target.call{value: value}(data);
141         return verifyCallResult(success, returndata, errorMessage);
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
146      * but performing a static call.
147      *
148      * _Available since v3.3._
149      */
150     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
151         return functionStaticCall(target, data, "Address: low-level static call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
156      * but performing a static call.
157      *
158      * _Available since v3.3._
159      */
160     function functionStaticCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal view returns (bytes memory) {
165         require(isContract(target), "Address: static call to non-contract");
166 
167         (bool success, bytes memory returndata) = target.staticcall(data);
168         return verifyCallResult(success, returndata, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but performing a delegate call.
174      *
175      * _Available since v3.4._
176      */
177     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
178         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
183      * but performing a delegate call.
184      *
185      * _Available since v3.4._
186      */
187     function functionDelegateCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal returns (bytes memory) {
192         require(isContract(target), "Address: delegate call to non-contract");
193 
194         (bool success, bytes memory returndata) = target.delegatecall(data);
195         return verifyCallResult(success, returndata, errorMessage);
196     }
197 
198     /**
199      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
200      * revert reason using the provided one.
201      *
202      * _Available since v4.3._
203      */
204     function verifyCallResult(
205         bool success,
206         bytes memory returndata,
207         string memory errorMessage
208     ) internal pure returns (bytes memory) {
209         if (success) {
210             return returndata;
211         } else {
212             // Look for revert reason and bubble it up if present
213             if (returndata.length > 0) {
214                 // The easiest way to bubble the revert reason is using memory via assembly
215                 /// @solidity memory-safe-assembly
216                 assembly {
217                     let returndata_size := mload(returndata)
218                     revert(add(32, returndata), returndata_size)
219                 }
220             } else {
221                 revert(errorMessage);
222             }
223         }
224     }
225 }
226 
227 
228 // File @openzeppelin/contracts/proxy/Proxy.sol@v4.7.3
229 
230 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
236  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
237  * be specified by overriding the virtual {_implementation} function.
238  *
239  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
240  * different contract through the {_delegate} function.
241  *
242  * The success and return data of the delegated call will be returned back to the caller of the proxy.
243  */
244 abstract contract Proxy {
245     /**
246      * @dev Delegates the current call to `implementation`.
247      *
248      * This function does not return to its internal call site, it will return directly to the external caller.
249      */
250     function _delegate(address implementation) internal virtual {
251         assembly {
252             // Copy msg.data. We take full control of memory in this inline assembly
253             // block because it will not return to Solidity code. We overwrite the
254             // Solidity scratch pad at memory position 0.
255             calldatacopy(0, 0, calldatasize())
256 
257             // Call the implementation.
258             // out and outsize are 0 because we don't know the size yet.
259             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
260 
261             // Copy the returned data.
262             returndatacopy(0, 0, returndatasize())
263 
264             switch result
265             // delegatecall returns 0 on error.
266             case 0 {
267                 revert(0, returndatasize())
268             }
269             default {
270                 return(0, returndatasize())
271             }
272         }
273     }
274 
275     /**
276      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
277      * and {_fallback} should delegate.
278      */
279     function _implementation() internal view virtual returns (address);
280 
281     /**
282      * @dev Delegates the current call to the address returned by `_implementation()`.
283      *
284      * This function does not return to its internal call site, it will return directly to the external caller.
285      */
286     function _fallback() internal virtual {
287         _beforeFallback();
288         _delegate(_implementation());
289     }
290 
291     /**
292      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
293      * function in the contract matches the call data.
294      */
295     fallback() external payable virtual {
296         _fallback();
297     }
298 
299     /**
300      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
301      * is empty.
302      */
303     receive() external payable virtual {
304         _fallback();
305     }
306 
307     /**
308      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
309      * call, or as part of the Solidity `fallback` or `receive` functions.
310      *
311      * If overridden should call `super._beforeFallback()`.
312      */
313     function _beforeFallback() internal virtual {}
314 }
315 
316 
317 // File @openzeppelin/contracts/utils/StorageSlot.sol@v4.7.3
318 
319 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 /**
324  * @dev Library for reading and writing primitive types to specific storage slots.
325  *
326  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
327  * This library helps with reading and writing to such slots without the need for inline assembly.
328  *
329  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
330  *
331  * Example usage to set ERC1967 implementation slot:
332  * ```
333  * contract ERC1967 {
334  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
335  *
336  *     function _getImplementation() internal view returns (address) {
337  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
338  *     }
339  *
340  *     function _setImplementation(address newImplementation) internal {
341  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
342  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
343  *     }
344  * }
345  * ```
346  *
347  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
348  */
349 library StorageSlot {
350     struct AddressSlot {
351         address value;
352     }
353 
354     struct BooleanSlot {
355         bool value;
356     }
357 
358     struct Bytes32Slot {
359         bytes32 value;
360     }
361 
362     struct Uint256Slot {
363         uint256 value;
364     }
365 
366     /**
367      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
368      */
369     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
370         /// @solidity memory-safe-assembly
371         assembly {
372             r.slot := slot
373         }
374     }
375 
376     /**
377      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
378      */
379     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
380         /// @solidity memory-safe-assembly
381         assembly {
382             r.slot := slot
383         }
384     }
385 
386     /**
387      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
388      */
389     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
390         /// @solidity memory-safe-assembly
391         assembly {
392             r.slot := slot
393         }
394     }
395 
396     /**
397      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
398      */
399     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
400         /// @solidity memory-safe-assembly
401         assembly {
402             r.slot := slot
403         }
404     }
405 }
406 
407 
408 // File contracts/DogeHeroes.sol
409 
410 pragma solidity ^0.8.7;
411 
412 
413 
414 contract ERC721ContractWrapper is Proxy {
415     address internal constant _IMPLEMENTATION_ADDRESS = 0xf96Fd95D60fB0318B639a8211ef60EE467F2892a;
416     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
417 
418     constructor(
419         string memory _name,
420         string memory _symbol,
421         uint256 _totalSupply,
422         uint256 _commission
423     ) {
424         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
425         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = _IMPLEMENTATION_ADDRESS;
426         Address.functionDelegateCall(
427             _IMPLEMENTATION_ADDRESS,
428             abi.encodeWithSignature("initialize(string,string,uint256,uint256)", _name, _symbol, _totalSupply, _commission)
429         );
430     }
431 
432     /**
433      * @dev Returns the current implementation address.
434      */
435      function implementation() public view returns (address) {
436         return _implementation();
437     }
438 
439     function _implementation() internal override view returns (address) {
440         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
441     }
442 }
443 
444 
445 ///
446 /// This contract was generated by https://nft-generator.art/
447 ///
448 contract DogeHeroes is ERC721ContractWrapper {
449   constructor(
450     string memory _name,
451     string memory _symbol,
452     uint256 _totalSupply,
453     uint256 _commission
454   ) ERC721ContractWrapper(_name,_symbol,_totalSupply,_commission) {}
455 }
