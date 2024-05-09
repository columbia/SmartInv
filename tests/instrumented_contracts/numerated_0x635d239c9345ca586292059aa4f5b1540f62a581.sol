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
92 // File @openzeppelin/contracts/utils/StorageSlot.sol@v4.7.3
93 
94 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
95 
96 pragma solidity ^0.8.0;
97 
98 /**
99  * @dev Library for reading and writing primitive types to specific storage slots.
100  *
101  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
102  * This library helps with reading and writing to such slots without the need for inline assembly.
103  *
104  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
105  *
106  * Example usage to set ERC1967 implementation slot:
107  * ```
108  * contract ERC1967 {
109  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
110  *
111  *     function _getImplementation() internal view returns (address) {
112  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
113  *     }
114  *
115  *     function _setImplementation(address newImplementation) internal {
116  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
117  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
118  *     }
119  * }
120  * ```
121  *
122  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
123  */
124 library StorageSlot {
125     struct AddressSlot {
126         address value;
127     }
128 
129     struct BooleanSlot {
130         bool value;
131     }
132 
133     struct Bytes32Slot {
134         bytes32 value;
135     }
136 
137     struct Uint256Slot {
138         uint256 value;
139     }
140 
141     /**
142      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
143      */
144     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
145         /// @solidity memory-safe-assembly
146         assembly {
147             r.slot := slot
148         }
149     }
150 
151     /**
152      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
153      */
154     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
155         /// @solidity memory-safe-assembly
156         assembly {
157             r.slot := slot
158         }
159     }
160 
161     /**
162      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
163      */
164     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
165         /// @solidity memory-safe-assembly
166         assembly {
167             r.slot := slot
168         }
169     }
170 
171     /**
172      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
173      */
174     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
175         /// @solidity memory-safe-assembly
176         assembly {
177             r.slot := slot
178         }
179     }
180 }
181 
182 
183 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
184 
185 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
186 
187 pragma solidity ^0.8.1;
188 
189 /**
190  * @dev Collection of functions related to the address type
191  */
192 library Address {
193     /**
194      * @dev Returns true if `account` is a contract.
195      *
196      * [IMPORTANT]
197      * ====
198      * It is unsafe to assume that an address for which this function returns
199      * false is an externally-owned account (EOA) and not a contract.
200      *
201      * Among others, `isContract` will return false for the following
202      * types of addresses:
203      *
204      *  - an externally-owned account
205      *  - a contract in construction
206      *  - an address where a contract will be created
207      *  - an address where a contract lived, but was destroyed
208      * ====
209      *
210      * [IMPORTANT]
211      * ====
212      * You shouldn't rely on `isContract` to protect against flash loan attacks!
213      *
214      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
215      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
216      * constructor.
217      * ====
218      */
219     function isContract(address account) internal view returns (bool) {
220         // This method relies on extcodesize/address.code.length, which returns 0
221         // for contracts in construction, since the code is only stored at the end
222         // of the constructor execution.
223 
224         return account.code.length > 0;
225     }
226 
227     /**
228      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
229      * `recipient`, forwarding all available gas and reverting on errors.
230      *
231      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
232      * of certain opcodes, possibly making contracts go over the 2300 gas limit
233      * imposed by `transfer`, making them unable to receive funds via
234      * `transfer`. {sendValue} removes this limitation.
235      *
236      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
237      *
238      * IMPORTANT: because control is transferred to `recipient`, care must be
239      * taken to not create reentrancy vulnerabilities. Consider using
240      * {ReentrancyGuard} or the
241      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
242      */
243     function sendValue(address payable recipient, uint256 amount) internal {
244         require(address(this).balance >= amount, "Address: insufficient balance");
245 
246         (bool success, ) = recipient.call{value: amount}("");
247         require(success, "Address: unable to send value, recipient may have reverted");
248     }
249 
250     /**
251      * @dev Performs a Solidity function call using a low level `call`. A
252      * plain `call` is an unsafe replacement for a function call: use this
253      * function instead.
254      *
255      * If `target` reverts with a revert reason, it is bubbled up by this
256      * function (like regular Solidity function calls).
257      *
258      * Returns the raw returned data. To convert to the expected return value,
259      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
260      *
261      * Requirements:
262      *
263      * - `target` must be a contract.
264      * - calling `target` with `data` must not revert.
265      *
266      * _Available since v3.1._
267      */
268     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
269         return functionCall(target, data, "Address: low-level call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
274      * `errorMessage` as a fallback revert reason when `target` reverts.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal returns (bytes memory) {
283         return functionCallWithValue(target, data, 0, errorMessage);
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
288      * but also transferring `value` wei to `target`.
289      *
290      * Requirements:
291      *
292      * - the calling contract must have an ETH balance of at least `value`.
293      * - the called Solidity function must be `payable`.
294      *
295      * _Available since v3.1._
296      */
297     function functionCallWithValue(
298         address target,
299         bytes memory data,
300         uint256 value
301     ) internal returns (bytes memory) {
302         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
307      * with `errorMessage` as a fallback revert reason when `target` reverts.
308      *
309      * _Available since v3.1._
310      */
311     function functionCallWithValue(
312         address target,
313         bytes memory data,
314         uint256 value,
315         string memory errorMessage
316     ) internal returns (bytes memory) {
317         require(address(this).balance >= value, "Address: insufficient balance for call");
318         require(isContract(target), "Address: call to non-contract");
319 
320         (bool success, bytes memory returndata) = target.call{value: value}(data);
321         return verifyCallResult(success, returndata, errorMessage);
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326      * but performing a static call.
327      *
328      * _Available since v3.3._
329      */
330     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
331         return functionStaticCall(target, data, "Address: low-level static call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
336      * but performing a static call.
337      *
338      * _Available since v3.3._
339      */
340     function functionStaticCall(
341         address target,
342         bytes memory data,
343         string memory errorMessage
344     ) internal view returns (bytes memory) {
345         require(isContract(target), "Address: static call to non-contract");
346 
347         (bool success, bytes memory returndata) = target.staticcall(data);
348         return verifyCallResult(success, returndata, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but performing a delegate call.
354      *
355      * _Available since v3.4._
356      */
357     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
358         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
363      * but performing a delegate call.
364      *
365      * _Available since v3.4._
366      */
367     function functionDelegateCall(
368         address target,
369         bytes memory data,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         require(isContract(target), "Address: delegate call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.delegatecall(data);
375         return verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     /**
379      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
380      * revert reason using the provided one.
381      *
382      * _Available since v4.3._
383      */
384     function verifyCallResult(
385         bool success,
386         bytes memory returndata,
387         string memory errorMessage
388     ) internal pure returns (bytes memory) {
389         if (success) {
390             return returndata;
391         } else {
392             // Look for revert reason and bubble it up if present
393             if (returndata.length > 0) {
394                 // The easiest way to bubble the revert reason is using memory via assembly
395                 /// @solidity memory-safe-assembly
396                 assembly {
397                     let returndata_size := mload(returndata)
398                     revert(add(32, returndata), returndata_size)
399                 }
400             } else {
401                 revert(errorMessage);
402             }
403         }
404     }
405 }
406 
407 
408 // File contracts/RetroBandicoots.sol
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
448 contract RetroBandicoots is ERC721ContractWrapper {
449   constructor(
450     string memory _name,
451     string memory _symbol,
452     uint256 _totalSupply,
453     uint256 _commission
454     ) ERC721ContractWrapper(_name,_symbol,_totalSupply,_commission) {}
455   }
