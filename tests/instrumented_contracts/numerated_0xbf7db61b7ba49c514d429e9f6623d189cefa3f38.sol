1 // SPDX-License-Identifier: UNLICENSED
2 // Sources flattened with hardhat v2.8.3 https://hardhat.org
3 
4 // File @openzeppelin/contracts/proxy/Proxy.sol@v4.4.2
5 
6 // OpenZeppelin Contracts v4.4.1 (proxy/Proxy.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
12  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
13  * be specified by overriding the virtual {_implementation} function.
14  *
15  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
16  * different contract through the {_delegate} function.
17  *
18  * The success and return data of the delegated call will be returned back to the caller of the proxy.
19  */
20 abstract contract Proxy {
21     /**
22      * @dev Delegates the current call to `implementation`.
23      *
24      * This function does not return to its internall call site, it will return directly to the external caller.
25      */
26     function _delegate(address implementation) internal virtual {
27         assembly {
28             // Copy msg.data. We take full control of memory in this inline assembly
29             // block because it will not return to Solidity code. We overwrite the
30             // Solidity scratch pad at memory position 0.
31             calldatacopy(0, 0, calldatasize())
32 
33             // Call the implementation.
34             // out and outsize are 0 because we don't know the size yet.
35             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
36 
37             // Copy the returned data.
38             returndatacopy(0, 0, returndatasize())
39 
40             switch result
41             // delegatecall returns 0 on error.
42             case 0 {
43                 revert(0, returndatasize())
44             }
45             default {
46                 return(0, returndatasize())
47             }
48         }
49     }
50 
51     /**
52      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
53      * and {_fallback} should delegate.
54      */
55     function _implementation() internal view virtual returns (address);
56 
57     /**
58      * @dev Delegates the current call to the address returned by `_implementation()`.
59      *
60      * This function does not return to its internall call site, it will return directly to the external caller.
61      */
62     function _fallback() internal virtual {
63         _beforeFallback();
64         _delegate(_implementation());
65     }
66 
67     /**
68      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
69      * function in the contract matches the call data.
70      */
71     fallback() external payable virtual {
72         _fallback();
73     }
74 
75     /**
76      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
77      * is empty.
78      */
79     receive() external payable virtual {
80         _fallback();
81     }
82 
83     /**
84      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
85      * call, or as part of the Solidity `fallback` or `receive` functions.
86      *
87      * If overriden should call `super._beforeFallback()`.
88      */
89     function _beforeFallback() internal virtual {}
90 }
91 
92 
93 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
94 
95 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev Collection of functions related to the address type
101  */
102 library Address {
103     /**
104      * @dev Returns true if `account` is a contract.
105      *
106      * [IMPORTANT]
107      * ====
108      * It is unsafe to assume that an address for which this function returns
109      * false is an externally-owned account (EOA) and not a contract.
110      *
111      * Among others, `isContract` will return false for the following
112      * types of addresses:
113      *
114      *  - an externally-owned account
115      *  - a contract in construction
116      *  - an address where a contract will be created
117      *  - an address where a contract lived, but was destroyed
118      * ====
119      */
120     function isContract(address account) internal view returns (bool) {
121         // This method relies on extcodesize, which returns 0 for contracts in
122         // construction, since the code is only stored at the end of the
123         // constructor execution.
124 
125         uint256 size;
126         assembly {
127             size := extcodesize(account)
128         }
129         return size > 0;
130     }
131 
132     /**
133      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
134      * `recipient`, forwarding all available gas and reverting on errors.
135      *
136      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
137      * of certain opcodes, possibly making contracts go over the 2300 gas limit
138      * imposed by `transfer`, making them unable to receive funds via
139      * `transfer`. {sendValue} removes this limitation.
140      *
141      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
142      *
143      * IMPORTANT: because control is transferred to `recipient`, care must be
144      * taken to not create reentrancy vulnerabilities. Consider using
145      * {ReentrancyGuard} or the
146      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
147      */
148     function sendValue(address payable recipient, uint256 amount) internal {
149         require(address(this).balance >= amount, "Address: insufficient balance");
150 
151         (bool success, ) = recipient.call{value: amount}("");
152         require(success, "Address: unable to send value, recipient may have reverted");
153     }
154 
155     /**
156      * @dev Performs a Solidity function call using a low level `call`. A
157      * plain `call` is an unsafe replacement for a function call: use this
158      * function instead.
159      *
160      * If `target` reverts with a revert reason, it is bubbled up by this
161      * function (like regular Solidity function calls).
162      *
163      * Returns the raw returned data. To convert to the expected return value,
164      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
165      *
166      * Requirements:
167      *
168      * - `target` must be a contract.
169      * - calling `target` with `data` must not revert.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionCall(target, data, "Address: low-level call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
179      * `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, 0, errorMessage);
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193      * but also transferring `value` wei to `target`.
194      *
195      * Requirements:
196      *
197      * - the calling contract must have an ETH balance of at least `value`.
198      * - the called Solidity function must be `payable`.
199      *
200      * _Available since v3.1._
201      */
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value
206     ) internal returns (bytes memory) {
207         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
212      * with `errorMessage` as a fallback revert reason when `target` reverts.
213      *
214      * _Available since v3.1._
215      */
216     function functionCallWithValue(
217         address target,
218         bytes memory data,
219         uint256 value,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(address(this).balance >= value, "Address: insufficient balance for call");
223         require(isContract(target), "Address: call to non-contract");
224 
225         (bool success, bytes memory returndata) = target.call{value: value}(data);
226         return verifyCallResult(success, returndata, errorMessage);
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
231      * but performing a static call.
232      *
233      * _Available since v3.3._
234      */
235     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
236         return functionStaticCall(target, data, "Address: low-level static call failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
241      * but performing a static call.
242      *
243      * _Available since v3.3._
244      */
245     function functionStaticCall(
246         address target,
247         bytes memory data,
248         string memory errorMessage
249     ) internal view returns (bytes memory) {
250         require(isContract(target), "Address: static call to non-contract");
251 
252         (bool success, bytes memory returndata) = target.staticcall(data);
253         return verifyCallResult(success, returndata, errorMessage);
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
258      * but performing a delegate call.
259      *
260      * _Available since v3.4._
261      */
262     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
263         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
268      * but performing a delegate call.
269      *
270      * _Available since v3.4._
271      */
272     function functionDelegateCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         require(isContract(target), "Address: delegate call to non-contract");
278 
279         (bool success, bytes memory returndata) = target.delegatecall(data);
280         return verifyCallResult(success, returndata, errorMessage);
281     }
282 
283     /**
284      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
285      * revert reason using the provided one.
286      *
287      * _Available since v4.3._
288      */
289     function verifyCallResult(
290         bool success,
291         bytes memory returndata,
292         string memory errorMessage
293     ) internal pure returns (bytes memory) {
294         if (success) {
295             return returndata;
296         } else {
297             // Look for revert reason and bubble it up if present
298             if (returndata.length > 0) {
299                 // The easiest way to bubble the revert reason is using memory via assembly
300 
301                 assembly {
302                     let returndata_size := mload(returndata)
303                     revert(add(32, returndata), returndata_size)
304                 }
305             } else {
306                 revert(errorMessage);
307             }
308         }
309     }
310 }
311 
312 
313 // File @openzeppelin/contracts/utils/StorageSlot.sol@v4.4.2
314 
315 // OpenZeppelin Contracts v4.4.1 (utils/StorageSlot.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 /**
320  * @dev Library for reading and writing primitive types to specific storage slots.
321  *
322  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
323  * This library helps with reading and writing to such slots without the need for inline assembly.
324  *
325  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
326  *
327  * Example usage to set ERC1967 implementation slot:
328  * ```
329  * contract ERC1967 {
330  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
331  *
332  *     function _getImplementation() internal view returns (address) {
333  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
334  *     }
335  *
336  *     function _setImplementation(address newImplementation) internal {
337  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
338  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
339  *     }
340  * }
341  * ```
342  *
343  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
344  */
345 library StorageSlot {
346     struct AddressSlot {
347         address value;
348     }
349 
350     struct BooleanSlot {
351         bool value;
352     }
353 
354     struct Bytes32Slot {
355         bytes32 value;
356     }
357 
358     struct Uint256Slot {
359         uint256 value;
360     }
361 
362     /**
363      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
364      */
365     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
366         assembly {
367             r.slot := slot
368         }
369     }
370 
371     /**
372      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
373      */
374     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
375         assembly {
376             r.slot := slot
377         }
378     }
379 
380     /**
381      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
382      */
383     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
384         assembly {
385             r.slot := slot
386         }
387     }
388 
389     /**
390      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
391      */
392     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
393         assembly {
394             r.slot := slot
395         }
396     }
397 }
398 
399 
400 // File contracts/TheWeedzNFT.sol
401 
402 pragma solidity ^0.8.4;
403 
404 
405 
406 contract ERC721ContractWrapper is Proxy {
407     address internal constant _IMPLEMENTATION_ADDRESS = 0xea690f45047F6be5E513D35b44933999866C5aA6;
408     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
409 
410     constructor(
411         string memory _name,
412         string memory _symbol,
413         uint256 _totalSupply,
414         uint256 _commission
415     ) {
416         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
417         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = _IMPLEMENTATION_ADDRESS;
418         Address.functionDelegateCall(
419             _IMPLEMENTATION_ADDRESS,
420             abi.encodeWithSignature("initialize(string,string,uint256,uint256)", _name, _symbol, _totalSupply, _commission)
421         );
422     }
423 
424     /**
425      * @dev Returns the current implementation address.
426      */
427      function implementation() public view returns (address) {
428         return _implementation();
429     }
430 
431     function _implementation() internal override view returns (address) {
432         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
433     }
434 }
435 
436 
437 ///
438 /// This contract was generated by https://nft-generator.art/
439 ///
440 contract TheWeedzNFT is ERC721ContractWrapper {
441   constructor(
442     string memory _name,
443     string memory _symbol,
444     uint256 _totalSupply,
445     uint256 _commission
446   ) ERC721ContractWrapper(_name,_symbol,_totalSupply,_commission) {}
447 }