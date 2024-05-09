1 // Sources flattened with hardhat v2.11.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/proxy/Proxy.sol@v4.7.3
4 
5 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
11  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
12  * be specified by overriding the virtual {_implementation} function.
13  *
14  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
15  * different contract through the {_delegate} function.
16  *
17  * The success and return data of the delegated call will be returned back to the caller of the proxy.
18  */
19 abstract contract Proxy {
20     /**
21      * @dev Delegates the current call to `implementation`.
22      *
23      * This function does not return to its internal call site, it will return directly to the external caller.
24      */
25     function _delegate(address implementation) internal virtual {
26         assembly {
27             // Copy msg.data. We take full control of memory in this inline assembly
28             // block because it will not return to Solidity code. We overwrite the
29             // Solidity scratch pad at memory position 0.
30             calldatacopy(0, 0, calldatasize())
31 
32             // Call the implementation.
33             // out and outsize are 0 because we don't know the size yet.
34             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
35 
36             // Copy the returned data.
37             returndatacopy(0, 0, returndatasize())
38 
39             switch result
40             // delegatecall returns 0 on error.
41             case 0 {
42                 revert(0, returndatasize())
43             }
44             default {
45                 return(0, returndatasize())
46             }
47         }
48     }
49 
50     /**
51      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
52      * and {_fallback} should delegate.
53      */
54     function _implementation() internal view virtual returns (address);
55 
56     /**
57      * @dev Delegates the current call to the address returned by `_implementation()`.
58      *
59      * This function does not return to its internal call site, it will return directly to the external caller.
60      */
61     function _fallback() internal virtual {
62         _beforeFallback();
63         _delegate(_implementation());
64     }
65 
66     /**
67      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
68      * function in the contract matches the call data.
69      */
70     fallback() external payable virtual {
71         _fallback();
72     }
73 
74     /**
75      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
76      * is empty.
77      */
78     receive() external payable virtual {
79         _fallback();
80     }
81 
82     /**
83      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
84      * call, or as part of the Solidity `fallback` or `receive` functions.
85      *
86      * If overridden should call `super._beforeFallback()`.
87      */
88     function _beforeFallback() internal virtual {}
89 }
90 
91 
92 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
93 
94 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
95 
96 pragma solidity ^0.8.1;
97 
98 /**
99  * @dev Collection of functions related to the address type
100  */
101 library Address {
102     /**
103      * @dev Returns true if `account` is a contract.
104      *
105      * [IMPORTANT]
106      * ====
107      * It is unsafe to assume that an address for which this function returns
108      * false is an externally-owned account (EOA) and not a contract.
109      *
110      * Among others, `isContract` will return false for the following
111      * types of addresses:
112      *
113      *  - an externally-owned account
114      *  - a contract in construction
115      *  - an address where a contract will be created
116      *  - an address where a contract lived, but was destroyed
117      * ====
118      *
119      * [IMPORTANT]
120      * ====
121      * You shouldn't rely on `isContract` to protect against flash loan attacks!
122      *
123      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
124      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
125      * constructor.
126      * ====
127      */
128     function isContract(address account) internal view returns (bool) {
129         // This method relies on extcodesize/address.code.length, which returns 0
130         // for contracts in construction, since the code is only stored at the end
131         // of the constructor execution.
132 
133         return account.code.length > 0;
134     }
135 
136     /**
137      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
138      * `recipient`, forwarding all available gas and reverting on errors.
139      *
140      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
141      * of certain opcodes, possibly making contracts go over the 2300 gas limit
142      * imposed by `transfer`, making them unable to receive funds via
143      * `transfer`. {sendValue} removes this limitation.
144      *
145      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
146      *
147      * IMPORTANT: because control is transferred to `recipient`, care must be
148      * taken to not create reentrancy vulnerabilities. Consider using
149      * {ReentrancyGuard} or the
150      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
151      */
152     function sendValue(address payable recipient, uint256 amount) internal {
153         require(address(this).balance >= amount, "Address: insufficient balance");
154 
155         (bool success, ) = recipient.call{value: amount}("");
156         require(success, "Address: unable to send value, recipient may have reverted");
157     }
158 
159     /**
160      * @dev Performs a Solidity function call using a low level `call`. A
161      * plain `call` is an unsafe replacement for a function call: use this
162      * function instead.
163      *
164      * If `target` reverts with a revert reason, it is bubbled up by this
165      * function (like regular Solidity function calls).
166      *
167      * Returns the raw returned data. To convert to the expected return value,
168      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
169      *
170      * Requirements:
171      *
172      * - `target` must be a contract.
173      * - calling `target` with `data` must not revert.
174      *
175      * _Available since v3.1._
176      */
177     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
178         return functionCall(target, data, "Address: low-level call failed");
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
183      * `errorMessage` as a fallback revert reason when `target` reverts.
184      *
185      * _Available since v3.1._
186      */
187     function functionCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal returns (bytes memory) {
192         return functionCallWithValue(target, data, 0, errorMessage);
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
197      * but also transferring `value` wei to `target`.
198      *
199      * Requirements:
200      *
201      * - the calling contract must have an ETH balance of at least `value`.
202      * - the called Solidity function must be `payable`.
203      *
204      * _Available since v3.1._
205      */
206     function functionCallWithValue(
207         address target,
208         bytes memory data,
209         uint256 value
210     ) internal returns (bytes memory) {
211         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
216      * with `errorMessage` as a fallback revert reason when `target` reverts.
217      *
218      * _Available since v3.1._
219      */
220     function functionCallWithValue(
221         address target,
222         bytes memory data,
223         uint256 value,
224         string memory errorMessage
225     ) internal returns (bytes memory) {
226         require(address(this).balance >= value, "Address: insufficient balance for call");
227         require(isContract(target), "Address: call to non-contract");
228 
229         (bool success, bytes memory returndata) = target.call{value: value}(data);
230         return verifyCallResult(success, returndata, errorMessage);
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
235      * but performing a static call.
236      *
237      * _Available since v3.3._
238      */
239     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
240         return functionStaticCall(target, data, "Address: low-level static call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
245      * but performing a static call.
246      *
247      * _Available since v3.3._
248      */
249     function functionStaticCall(
250         address target,
251         bytes memory data,
252         string memory errorMessage
253     ) internal view returns (bytes memory) {
254         require(isContract(target), "Address: static call to non-contract");
255 
256         (bool success, bytes memory returndata) = target.staticcall(data);
257         return verifyCallResult(success, returndata, errorMessage);
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
262      * but performing a delegate call.
263      *
264      * _Available since v3.4._
265      */
266     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
267         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
272      * but performing a delegate call.
273      *
274      * _Available since v3.4._
275      */
276     function functionDelegateCall(
277         address target,
278         bytes memory data,
279         string memory errorMessage
280     ) internal returns (bytes memory) {
281         require(isContract(target), "Address: delegate call to non-contract");
282 
283         (bool success, bytes memory returndata) = target.delegatecall(data);
284         return verifyCallResult(success, returndata, errorMessage);
285     }
286 
287     /**
288      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
289      * revert reason using the provided one.
290      *
291      * _Available since v4.3._
292      */
293     function verifyCallResult(
294         bool success,
295         bytes memory returndata,
296         string memory errorMessage
297     ) internal pure returns (bytes memory) {
298         if (success) {
299             return returndata;
300         } else {
301             // Look for revert reason and bubble it up if present
302             if (returndata.length > 0) {
303                 // The easiest way to bubble the revert reason is using memory via assembly
304                 /// @solidity memory-safe-assembly
305                 assembly {
306                     let returndata_size := mload(returndata)
307                     revert(add(32, returndata), returndata_size)
308                 }
309             } else {
310                 revert(errorMessage);
311             }
312         }
313     }
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
408 // File contracts/MaowLoudyMaker.sol
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
448 contract MaowLoudyMaker is ERC721ContractWrapper {
449   constructor(
450     string memory _name,
451     string memory _symbol,
452     uint256 _totalSupply,
453     uint256 _commission
454     ) ERC721ContractWrapper(_name,_symbol,_totalSupply,_commission) {}
455   }
