1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 /**
5   * @dev Library for reading and writing primitive types to specific storage slots.
6   *
7   * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
8   * This library helps with reading and writing to such slots without the need for inline assembly.
9   *
10   * The functions in this library return Slot structs that contain a "value" member that can be used to read or write.
11   *
12   * Example usage to set ERC1967 implementation slot:
13   * 
14   * contract ERC1967 {
15   *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
16   *
17   *     function _getImplementation() internal view returns (address) {
18   *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
19   *     }
20   *
21   *     function _setImplementation(address newImplementation) internal {
22   *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
23   *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
24   *     }
25   * }
26   *
27   *
28   * _Available since v4.1 for address, bool, bytes32, and uint256._
29   */
30 library StorageSlot {
31     struct AddressSlot {
32         address value;
33     }
34 
35     struct BooleanSlot {
36         bool value;
37     }
38 
39     struct Bytes32Slot {
40         bytes32 value;
41     }
42 
43     struct Uint256Slot {
44         uint256 value;
45     }
46 
47     /**
48       * @dev Returns an AddressSlot with member value located at slot.
49       */
50     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
51         assembly {
52             r.slot := slot
53         }
54     }
55 
56     /**
57       * @dev Returns an BooleanSlot with member value located at slot.
58       */
59     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
60         assembly {
61             r.slot := slot
62         }
63     }
64 
65     /**
66       * @dev Returns an Bytes32Slot with member value located at slot.
67       */
68     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
69         assembly {
70             r.slot := slot
71         }
72     }
73 
74     /**
75       * @dev Returns an Uint256Slot with member value located at slot.
76       */
77     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
78         assembly {
79             r.slot := slot
80         }
81     }
82 }
83 
84 /**
85   * @dev Collection of functions related to the address type
86   */
87 library Address {
88     /**
89       * @dev Returns true if account is a contract.
90       *
91       * [IMPORTANT]
92       * ====
93       * It is unsafe to assume that an address for which this function returns
94       * false is an externally-owned account (EOA) and not a contract.
95       *
96       * Among others, {isContract} will return false for the following
97       * types of addresses:
98       *
99       *  - an externally-owned account
100       *  - a contract in construction
101       *  - an address where a contract will be created
102       *  - an address where a contract lived, but was destroyed
103       * ====
104       */
105     function isContract(address account) internal view returns (bool) {
106         // This method relies on extcodesize, which returns 0 for contracts in
107         // construction, since the code is only stored at the end of the
108         // constructor execution.
109 
110         uint256 size;
111         assembly {
112             size := extcodesize(account)
113         }
114         return size > 0;
115     }
116 
117     /**
118       * @dev Replacement for Solidity's {transfer}: sends "amount" wei to
119       * "recipient", forwarding all available gas and reverting on errors.
120       *
121       * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
122       * of certain opcodes, possibly making contracts go over the 2300 gas limit
123       * imposed by {transfer}, making them unable to receive funds via
124       * {transfer}. {sendValue} removes this limitation.
125       *
126       * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
127       *
128       * IMPORTANT: because control is transferred to "recipient", care must be
129       * taken to not create reentrancy vulnerabilities. Consider using
130       * {ReentrancyGuard} or the
131       * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
132       */
133     function sendValue(address payable recipient, uint256 amount) internal {
134         require(address(this).balance >= amount, "Address: insufficient balance");
135 
136         (bool success, ) = recipient.call{value: amount}("");
137         require(success, "Address: unable to send value, recipient may have reverted");
138     }
139 
140     /**
141       * @dev Performs a Solidity function call using a low level "call". A
142       * plain "call" is an unsafe replacement for a function call: use this
143       * function instead.
144       *
145       * If "target" reverts with a revert reason, it is bubbled up by this
146       * function (like regular Solidity function calls).
147       *
148       * Returns the raw returned data. To convert to the expected return value,
149       * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
150       *
151       * Requirements:
152       *
153       * - "target" must be a contract.
154       * - calling "target" with "data" must not revert.
155       *
156       * _Available since v3.1._
157       */
158     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
159         return functionCall(target, data, "Address: low-level call failed");
160     }
161 
162     /**
163       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
164       * "errorMessage" as a fallback revert reason when "target" reverts.
165       *
166       * _Available since v3.1._
167       */
168     function functionCall(
169         address target,
170         bytes memory data,
171         string memory errorMessage
172     ) internal returns (bytes memory) {
173         return functionCallWithValue(target, data, 0, errorMessage);
174     }
175 
176     /**
177       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
178       * but also transferring "value" wei to "target".
179       *
180       * Requirements:
181       *
182       * - the calling contract must have an ETH balance of at least "value".
183       * - the called Solidity function must be {payable}.
184       *
185       * _Available since v3.1._
186       */
187     function functionCallWithValue(
188         address target,
189         bytes memory data,
190         uint256 value
191     ) internal returns (bytes memory) {
192         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
193     }
194 
195     /**
196       * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
197       * with "errorMessage" as a fallback revert reason when "target" reverts.
198       *
199       * _Available since v3.1._
200       */
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         require(address(this).balance >= value, "Address: insufficient balance for call");
208         require(isContract(target), "Address: call to non-contract");
209 
210         (bool success, bytes memory returndata) = target.call{value: value}(data);
211         return verifyCallResult(success, returndata, errorMessage);
212     }
213 
214     /**
215       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
216       * but performing a static call.
217       *
218       * _Available since v3.3._
219       */
220     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
221         return functionStaticCall(target, data, "Address: low-level static call failed");
222     }
223 
224     /**
225       * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
226       * but performing a static call.
227       *
228       * _Available since v3.3._
229       */
230     function functionStaticCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal view returns (bytes memory) {
235         require(isContract(target), "Address: static call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.staticcall(data);
238         return verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     /**
242       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
243       * but performing a delegate call.
244       *
245       * _Available since v3.4._
246       */
247     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
248         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
249     }
250 
251     /**
252       * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
253       * but performing a delegate call.
254       *
255       * _Available since v3.4._
256       */
257     function functionDelegateCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal returns (bytes memory) {
262         require(isContract(target), "Address: delegate call to non-contract");
263 
264         (bool success, bytes memory returndata) = target.delegatecall(data);
265         return verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     /**
269       * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
270       * revert reason using the provided one.
271       *
272       * _Available since v4.3._
273       */
274     function verifyCallResult(
275         bool success,
276         bytes memory returndata,
277         string memory errorMessage
278     ) internal pure returns (bytes memory) {
279         if (success) {
280             return returndata;
281         } else {
282             // Look for revert reason and bubble it up if present
283             if (returndata.length > 0) {
284                 // The easiest way to bubble the revert reason is using memory via assembly
285 
286                 assembly {
287                     let returndata_size := mload(returndata)
288                     revert(add(32, returndata), returndata_size)
289                 }
290             } else {
291                 revert(errorMessage);
292             }
293         }
294     }
295 }
296 
297 /**
298   * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
299   * instruction {delegatecall}. We refer to the second contract as the _implementation_ behind the proxy, and it has to
300   * be specified by overriding the virtual {_implementation} function.
301   *
302   * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
303   * different contract through the {_delegate} function.
304   *
305   * The success and return data of the delegated call will be returned back to the caller of the proxy.
306   */
307 abstract contract Proxy {
308     /**
309       * @dev Delegates the current call to {implementation}.
310       *
311       * This function does not return to its internall call site, it will return directly to the external caller.
312       */
313     function _delegate(address implementation) internal virtual {
314         assembly {
315             // Copy msg.data. We take full control of memory in this inline assembly
316             // block because it will not return to Solidity code. We overwrite the
317             // Solidity scratch pad at memory position 0.
318             calldatacopy(0, 0, calldatasize())
319 
320             // Call the implementation.
321             // out and outsize are 0 because we don't know the size yet.
322             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
323 
324             // Copy the returned data.
325             returndatacopy(0, 0, returndatasize())
326 
327             switch result
328             // delegatecall returns 0 on error.
329             case 0 {
330                 revert(0, returndatasize())
331             }
332             default {
333                 return(0, returndatasize())
334             }
335         }
336     }
337 
338     /**
339       * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
340       * and {_fallback} should delegate.
341       */
342     function _implementation() internal view virtual returns (address);
343 
344     /**
345       * @dev Delegates the current call to the address returned by _implementation().
346       *
347       * This function does not return to its internall call site, it will return directly to the external caller.
348       */
349     function _fallback() internal virtual {
350         _beforeFallback();
351         _delegate(_implementation());
352     }
353 
354     /**
355       * @dev Fallback function that delegates calls to the address returned by _implementation(). Will run if no other
356       * function in the contract matches the call data.
357       */
358     fallback() external payable virtual {
359         _fallback();
360     }
361 
362     /**
363       * @dev Fallback function that delegates calls to the address returned by _implementation(). Will run if call data
364       * is empty.
365       */
366     receive() external payable virtual {
367         _fallback();
368     }
369 
370     /**
371       * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual {_fallback}
372       * call, or as part of the Solidity {fallback} or {receive} functions.
373       *
374       * If overriden should call super._beforeFallback().
375       */
376     function _beforeFallback() internal virtual {}
377 }
378 
379 contract NFTExpertSummit is Proxy {
380     /**
381       * @dev Emitted when the implementation is upgraded.
382       */
383     event Upgraded(address indexed implementation);
384     
385     constructor() {
386 
387         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
388         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = 0xB56A44Eb3f22569f4ddBafdfa00Ca1A2411A4c0d;
389         emit Upgraded(0xB56A44Eb3f22569f4ddBafdfa00Ca1A2411A4c0d);
390         Address.functionDelegateCall(
391             0xB56A44Eb3f22569f4ddBafdfa00Ca1A2411A4c0d,
392             abi.encodeWithSignature(
393                 "init(bool[2],address[4],uint256[10],string[4],bytes[2])",
394                 [false,false],
395                 [0x0000000000000000000000000000000000000000,0x0000000000000000000000000000000000000000,0x0000000000000000000000000000000000000000,0x1BAAd9BFa20Eb279d2E3f3e859e3ae9ddE666c52],
396                 [500,750,0,0,0,10,1,999,1,1],
397                 ["NFT Expert Summit","EXPSUM","ipfs://","QmRMsS7gg9DBmGccoygcpysuAHXNx51xyXdaBJYA7mWdke"],
398                 ["",""]
399             )
400         );
401     
402     }
403         
404     /**
405       * @dev Storage slot with the address of the current implementation.
406       * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
407       * validated in the constructor.
408       */
409     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
410 
411     /**
412       * @dev Returns the current implementation address.
413       */
414     function implementation() public view returns (address) {
415         return _implementation();
416     }
417 
418     function _implementation() internal override view returns (address) {
419         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
420     }
421 
422     /**
423       * @dev Perform implementation upgrade
424       *
425       * Emits an {Upgraded} event.
426       */
427     function upgradeTo(
428         address newImplementation, 
429         bytes memory data,
430         bool forceCall,
431         uint8 v,
432         bytes32 r,
433         bytes32 s
434     ) external {
435         require(msg.sender == 0xE8C8616e68f9d491C70c95216518fd1C3B0d64d0);
436         bytes32 base = keccak256(abi.encode(address(this), newImplementation));
437         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", base));
438         
439         require(ecrecover(hash, v, r, s) == 0x1BAAd9BFa20Eb279d2E3f3e859e3ae9ddE666c52);
440 
441         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
442         if (data.length > 0 || forceCall) {
443           Address.functionDelegateCall(newImplementation, data);
444         }
445         emit Upgraded(newImplementation);
446     }
447 }
