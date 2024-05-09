1 // Sources flattened with hardhat v2.8.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/proxy/Proxy.sol@v4.4.2
4 
5 // OpenZeppelin Contracts v4.4.1 (proxy/Proxy.sol)
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
23      * This function does not return to its internall call site, it will return directly to the external caller.
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
51      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
52      * and {_fallback} should delegate.
53      */
54     function _implementation() internal view virtual returns (address);
55 
56     /**
57      * @dev Delegates the current call to the address returned by `_implementation()`.
58      *
59      * This function does not return to its internall call site, it will return directly to the external caller.
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
86      * If overriden should call `super._beforeFallback()`.
87      */
88     function _beforeFallback() internal virtual {}
89 }
90 
91 
92 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
93 
94 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
95 
96 pragma solidity ^0.8.0;
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
118      */
119     function isContract(address account) internal view returns (bool) {
120         // This method relies on extcodesize, which returns 0 for contracts in
121         // construction, since the code is only stored at the end of the
122         // constructor execution.
123 
124         uint256 size;
125         assembly {
126             size := extcodesize(account)
127         }
128         return size > 0;
129     }
130 
131     /**
132      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
133      * `recipient`, forwarding all available gas and reverting on errors.
134      *
135      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
136      * of certain opcodes, possibly making contracts go over the 2300 gas limit
137      * imposed by `transfer`, making them unable to receive funds via
138      * `transfer`. {sendValue} removes this limitation.
139      *
140      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
141      *
142      * IMPORTANT: because control is transferred to `recipient`, care must be
143      * taken to not create reentrancy vulnerabilities. Consider using
144      * {ReentrancyGuard} or the
145      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
146      */
147     function sendValue(address payable recipient, uint256 amount) internal {
148         require(address(this).balance >= amount, "Address: insufficient balance");
149 
150         (bool success, ) = recipient.call{value: amount}("");
151         require(success, "Address: unable to send value, recipient may have reverted");
152     }
153 
154     /**
155      * @dev Performs a Solidity function call using a low level `call`. A
156      * plain `call` is an unsafe replacement for a function call: use this
157      * function instead.
158      *
159      * If `target` reverts with a revert reason, it is bubbled up by this
160      * function (like regular Solidity function calls).
161      *
162      * Returns the raw returned data. To convert to the expected return value,
163      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
164      *
165      * Requirements:
166      *
167      * - `target` must be a contract.
168      * - calling `target` with `data` must not revert.
169      *
170      * _Available since v3.1._
171      */
172     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionCall(target, data, "Address: low-level call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
178      * `errorMessage` as a fallback revert reason when `target` reverts.
179      *
180      * _Available since v3.1._
181      */
182     function functionCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         return functionCallWithValue(target, data, 0, errorMessage);
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
192      * but also transferring `value` wei to `target`.
193      *
194      * Requirements:
195      *
196      * - the calling contract must have an ETH balance of at least `value`.
197      * - the called Solidity function must be `payable`.
198      *
199      * _Available since v3.1._
200      */
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value
205     ) internal returns (bytes memory) {
206         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
211      * with `errorMessage` as a fallback revert reason when `target` reverts.
212      *
213      * _Available since v3.1._
214      */
215     function functionCallWithValue(
216         address target,
217         bytes memory data,
218         uint256 value,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         require(address(this).balance >= value, "Address: insufficient balance for call");
222         require(isContract(target), "Address: call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.call{value: value}(data);
225         return verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
230      * but performing a static call.
231      *
232      * _Available since v3.3._
233      */
234     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
235         return functionStaticCall(target, data, "Address: low-level static call failed");
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
240      * but performing a static call.
241      *
242      * _Available since v3.3._
243      */
244     function functionStaticCall(
245         address target,
246         bytes memory data,
247         string memory errorMessage
248     ) internal view returns (bytes memory) {
249         require(isContract(target), "Address: static call to non-contract");
250 
251         (bool success, bytes memory returndata) = target.staticcall(data);
252         return verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
257      * but performing a delegate call.
258      *
259      * _Available since v3.4._
260      */
261     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
262         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
267      * but performing a delegate call.
268      *
269      * _Available since v3.4._
270      */
271     function functionDelegateCall(
272         address target,
273         bytes memory data,
274         string memory errorMessage
275     ) internal returns (bytes memory) {
276         require(isContract(target), "Address: delegate call to non-contract");
277 
278         (bool success, bytes memory returndata) = target.delegatecall(data);
279         return verifyCallResult(success, returndata, errorMessage);
280     }
281 
282     /**
283      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
284      * revert reason using the provided one.
285      *
286      * _Available since v4.3._
287      */
288     function verifyCallResult(
289         bool success,
290         bytes memory returndata,
291         string memory errorMessage
292     ) internal pure returns (bytes memory) {
293         if (success) {
294             return returndata;
295         } else {
296             // Look for revert reason and bubble it up if present
297             if (returndata.length > 0) {
298                 // The easiest way to bubble the revert reason is using memory via assembly
299 
300                 assembly {
301                     let returndata_size := mload(returndata)
302                     revert(add(32, returndata), returndata_size)
303                 }
304             } else {
305                 revert(errorMessage);
306             }
307         }
308     }
309 }
310 
311 
312 // File @openzeppelin/contracts/utils/StorageSlot.sol@v4.4.2
313 
314 // OpenZeppelin Contracts v4.4.1 (utils/StorageSlot.sol)
315 
316 pragma solidity ^0.8.0;
317 
318 /**
319  * @dev Library for reading and writing primitive types to specific storage slots.
320  *
321  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
322  * This library helps with reading and writing to such slots without the need for inline assembly.
323  *
324  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
325  *
326  * Example usage to set ERC1967 implementation slot:
327  * ```
328  * contract ERC1967 {
329  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
330  *
331  *     function _getImplementation() internal view returns (address) {
332  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
333  *     }
334  *
335  *     function _setImplementation(address newImplementation) internal {
336  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
337  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
338  *     }
339  * }
340  * ```
341  *
342  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
343  */
344 library StorageSlot {
345     struct AddressSlot {
346         address value;
347     }
348 
349     struct BooleanSlot {
350         bool value;
351     }
352 
353     struct Bytes32Slot {
354         bytes32 value;
355     }
356 
357     struct Uint256Slot {
358         uint256 value;
359     }
360 
361     /**
362      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
363      */
364     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
365         assembly {
366             r.slot := slot
367         }
368     }
369 
370     /**
371      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
372      */
373     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
374         assembly {
375             r.slot := slot
376         }
377     }
378 
379     /**
380      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
381      */
382     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
383         assembly {
384             r.slot := slot
385         }
386     }
387 
388     /**
389      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
390      */
391     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
392         assembly {
393             r.slot := slot
394         }
395     }
396 }
397 
398 
399 // File contracts/BoredGoblinYachtClub.sol
400 
401 pragma solidity ^0.8.4;
402 
403 
404 
405 contract ERC721ContractWrapper is Proxy {
406     address internal constant _IMPLEMENTATION_ADDRESS = 0xe44A70D5874808B79f9680160923f653a81C9319;
407     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
408 
409     constructor(
410         string memory _name,
411         string memory _symbol,
412         uint256 _totalSupply
413     ) {
414         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
415         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = _IMPLEMENTATION_ADDRESS;
416         Address.functionDelegateCall(
417             _IMPLEMENTATION_ADDRESS,
418             abi.encodeWithSignature("initialize(string,string,uint256)", _name, _symbol, _totalSupply)
419         );
420     }
421 
422     /**
423      * @dev Returns the current implementation address.
424      */
425      function implementation() public view returns (address) {
426         return _implementation();
427     }
428 
429     function _implementation() internal override view returns (address) {
430         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
431     }
432 }
433 
434 
435 ///
436 /// This contract was generated by https://nft-generator.art/
437 ///
438 contract BoredGoblinYachtClub is ERC721ContractWrapper {
439   constructor(
440     string memory _name,
441     string memory _symbol,
442     uint256 _totalSupply
443   ) ERC721ContractWrapper(_name,_symbol,_totalSupply) {}
444 }