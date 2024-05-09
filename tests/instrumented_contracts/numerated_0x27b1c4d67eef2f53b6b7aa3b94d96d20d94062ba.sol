1 // Sources flattened with hardhat v2.11.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/StorageSlot.sol@v4.7.3
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Library for reading and writing primitive types to specific storage slots.
11  *
12  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
13  * This library helps with reading and writing to such slots without the need for inline assembly.
14  *
15  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
16  *
17  * Example usage to set ERC1967 implementation slot:
18  * ```
19  * contract ERC1967 {
20  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
21  *
22  *     function _getImplementation() internal view returns (address) {
23  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
24  *     }
25  *
26  *     function _setImplementation(address newImplementation) internal {
27  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
28  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
29  *     }
30  * }
31  * ```
32  *
33  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
34  */
35 library StorageSlot {
36     struct AddressSlot {
37         address value;
38     }
39 
40     struct BooleanSlot {
41         bool value;
42     }
43 
44     struct Bytes32Slot {
45         bytes32 value;
46     }
47 
48     struct Uint256Slot {
49         uint256 value;
50     }
51 
52     /**
53      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
54      */
55     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
56         /// @solidity memory-safe-assembly
57         assembly {
58             r.slot := slot
59         }
60     }
61 
62     /**
63      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
64      */
65     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
66         /// @solidity memory-safe-assembly
67         assembly {
68             r.slot := slot
69         }
70     }
71 
72     /**
73      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
74      */
75     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
76         /// @solidity memory-safe-assembly
77         assembly {
78             r.slot := slot
79         }
80     }
81 
82     /**
83      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
84      */
85     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
86         /// @solidity memory-safe-assembly
87         assembly {
88             r.slot := slot
89         }
90     }
91 }
92 
93 
94 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
95 
96 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
97 
98 pragma solidity ^0.8.1;
99 
100 /**
101  * @dev Collection of functions related to the address type
102  */
103 library Address {
104     /**
105      * @dev Returns true if `account` is a contract.
106      *
107      * [IMPORTANT]
108      * ====
109      * It is unsafe to assume that an address for which this function returns
110      * false is an externally-owned account (EOA) and not a contract.
111      *
112      * Among others, `isContract` will return false for the following
113      * types of addresses:
114      *
115      *  - an externally-owned account
116      *  - a contract in construction
117      *  - an address where a contract will be created
118      *  - an address where a contract lived, but was destroyed
119      * ====
120      *
121      * [IMPORTANT]
122      * ====
123      * You shouldn't rely on `isContract` to protect against flash loan attacks!
124      *
125      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
126      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
127      * constructor.
128      * ====
129      */
130     function isContract(address account) internal view returns (bool) {
131         // This method relies on extcodesize/address.code.length, which returns 0
132         // for contracts in construction, since the code is only stored at the end
133         // of the constructor execution.
134 
135         return account.code.length > 0;
136     }
137 
138     /**
139      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
140      * `recipient`, forwarding all available gas and reverting on errors.
141      *
142      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
143      * of certain opcodes, possibly making contracts go over the 2300 gas limit
144      * imposed by `transfer`, making them unable to receive funds via
145      * `transfer`. {sendValue} removes this limitation.
146      *
147      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
148      *
149      * IMPORTANT: because control is transferred to `recipient`, care must be
150      * taken to not create reentrancy vulnerabilities. Consider using
151      * {ReentrancyGuard} or the
152      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
153      */
154     function sendValue(address payable recipient, uint256 amount) internal {
155         require(address(this).balance >= amount, "Address: insufficient balance");
156 
157         (bool success, ) = recipient.call{value: amount}("");
158         require(success, "Address: unable to send value, recipient may have reverted");
159     }
160 
161     /**
162      * @dev Performs a Solidity function call using a low level `call`. A
163      * plain `call` is an unsafe replacement for a function call: use this
164      * function instead.
165      *
166      * If `target` reverts with a revert reason, it is bubbled up by this
167      * function (like regular Solidity function calls).
168      *
169      * Returns the raw returned data. To convert to the expected return value,
170      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
171      *
172      * Requirements:
173      *
174      * - `target` must be a contract.
175      * - calling `target` with `data` must not revert.
176      *
177      * _Available since v3.1._
178      */
179     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionCall(target, data, "Address: low-level call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
185      * `errorMessage` as a fallback revert reason when `target` reverts.
186      *
187      * _Available since v3.1._
188      */
189     function functionCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         return functionCallWithValue(target, data, 0, errorMessage);
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
199      * but also transferring `value` wei to `target`.
200      *
201      * Requirements:
202      *
203      * - the calling contract must have an ETH balance of at least `value`.
204      * - the called Solidity function must be `payable`.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value
212     ) internal returns (bytes memory) {
213         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
218      * with `errorMessage` as a fallback revert reason when `target` reverts.
219      *
220      * _Available since v3.1._
221      */
222     function functionCallWithValue(
223         address target,
224         bytes memory data,
225         uint256 value,
226         string memory errorMessage
227     ) internal returns (bytes memory) {
228         require(address(this).balance >= value, "Address: insufficient balance for call");
229         require(isContract(target), "Address: call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.call{value: value}(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a static call.
238      *
239      * _Available since v3.3._
240      */
241     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
242         return functionStaticCall(target, data, "Address: low-level static call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a static call.
248      *
249      * _Available since v3.3._
250      */
251     function functionStaticCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal view returns (bytes memory) {
256         require(isContract(target), "Address: static call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.staticcall(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
264      * but performing a delegate call.
265      *
266      * _Available since v3.4._
267      */
268     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
269         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
274      * but performing a delegate call.
275      *
276      * _Available since v3.4._
277      */
278     function functionDelegateCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal returns (bytes memory) {
283         require(isContract(target), "Address: delegate call to non-contract");
284 
285         (bool success, bytes memory returndata) = target.delegatecall(data);
286         return verifyCallResult(success, returndata, errorMessage);
287     }
288 
289     /**
290      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
291      * revert reason using the provided one.
292      *
293      * _Available since v4.3._
294      */
295     function verifyCallResult(
296         bool success,
297         bytes memory returndata,
298         string memory errorMessage
299     ) internal pure returns (bytes memory) {
300         if (success) {
301             return returndata;
302         } else {
303             // Look for revert reason and bubble it up if present
304             if (returndata.length > 0) {
305                 // The easiest way to bubble the revert reason is using memory via assembly
306                 /// @solidity memory-safe-assembly
307                 assembly {
308                     let returndata_size := mload(returndata)
309                     revert(add(32, returndata), returndata_size)
310                 }
311             } else {
312                 revert(errorMessage);
313             }
314         }
315     }
316 }
317 
318 
319 // File @openzeppelin/contracts/proxy/Proxy.sol@v4.7.3
320 
321 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
322 
323 pragma solidity ^0.8.0;
324 
325 /**
326  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
327  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
328  * be specified by overriding the virtual {_implementation} function.
329  *
330  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
331  * different contract through the {_delegate} function.
332  *
333  * The success and return data of the delegated call will be returned back to the caller of the proxy.
334  */
335 abstract contract Proxy {
336     /**
337      * @dev Delegates the current call to `implementation`.
338      *
339      * This function does not return to its internal call site, it will return directly to the external caller.
340      */
341     function _delegate(address implementation) internal virtual {
342         assembly {
343             // Copy msg.data. We take full control of memory in this inline assembly
344             // block because it will not return to Solidity code. We overwrite the
345             // Solidity scratch pad at memory position 0.
346             calldatacopy(0, 0, calldatasize())
347 
348             // Call the implementation.
349             // out and outsize are 0 because we don't know the size yet.
350             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
351 
352             // Copy the returned data.
353             returndatacopy(0, 0, returndatasize())
354 
355             switch result
356             // delegatecall returns 0 on error.
357             case 0 {
358                 revert(0, returndatasize())
359             }
360             default {
361                 return(0, returndatasize())
362             }
363         }
364     }
365 
366     /**
367      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
368      * and {_fallback} should delegate.
369      */
370     function _implementation() internal view virtual returns (address);
371 
372     /**
373      * @dev Delegates the current call to the address returned by `_implementation()`.
374      *
375      * This function does not return to its internal call site, it will return directly to the external caller.
376      */
377     function _fallback() internal virtual {
378         _beforeFallback();
379         _delegate(_implementation());
380     }
381 
382     /**
383      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
384      * function in the contract matches the call data.
385      */
386     fallback() external payable virtual {
387         _fallback();
388     }
389 
390     /**
391      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
392      * is empty.
393      */
394     receive() external payable virtual {
395         _fallback();
396     }
397 
398     /**
399      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
400      * call, or as part of the Solidity `fallback` or `receive` functions.
401      *
402      * If overridden should call `super._beforeFallback()`.
403      */
404     function _beforeFallback() internal virtual {}
405 }
406 
407 
408 // File contracts/DAOFigure.sol
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
448 contract DAOFigure is ERC721ContractWrapper {
449   constructor(
450     string memory _name,
451     string memory _symbol,
452     uint256 _totalSupply,
453     uint256 _commission
454     ) ERC721ContractWrapper(_name,_symbol,_totalSupply,_commission) {}
455   }