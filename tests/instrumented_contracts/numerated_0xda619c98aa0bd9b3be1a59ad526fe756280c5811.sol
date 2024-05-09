1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 /////////////////////////////////////////////////////////////////////////
5 //                                                                     //
6 //                                                                     //
7 //    BBBBBBBBBBBBBBBBB           CCCCCCCCCCCCCPPPPPPPPPPPPPPPPP       //
8 //    B::::::::::::::::B       CCC::::::::::::CP::::::::::::::::P      //
9 //    B::::::BBBBBB:::::B    CC:::::::::::::::CP::::::PPPPPP:::::P     //
10 //    BB:::::B     B:::::B  C:::::CCCCCCCC::::CPP:::::P     P:::::P    //
11 //      B::::B     B:::::B C:::::C       CCCCCC  P::::P     P:::::P    //
12 //      B::::B     B:::::BC:::::C                P::::P     P:::::P    //
13 //      B::::BBBBBB:::::B C:::::C                P::::PPPPPP:::::P     //
14 //      B:::::::::::::BB  C:::::C                P:::::::::::::PP      //
15 //      B::::BBBBBB:::::B C:::::C                P::::PPPPPPPPP        //
16 //      B::::B     B:::::BC:::::C                P::::P                //
17 //      B::::B     B:::::BC:::::C                P::::P                //
18 //      B::::B     B:::::B C:::::C       CCCCCC  P::::P                //
19 //    BB:::::BBBBBB::::::B  C:::::CCCCCCCC::::CPP::::::PP              //
20 //    B:::::::::::::::::B    CC:::::::::::::::CP::::::::P              //
21 //    B::::::::::::::::B       CCC::::::::::::CP::::::::P              //
22 //    BBBBBBBBBBBBBBBBB           CCCCCCCCCCCCCPPPPPPPPPP              //
23 //                                                                     //
24 //                                                                     //
25 //                                                                     //
26 /////////////////////////////////////////////////////////////////////////
27 
28 /**
29   * @dev Library for reading and writing primitive types to specific storage slots.
30   *
31   * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
32   * This library helps with reading and writing to such slots without the need for inline assembly.
33   *
34   * The functions in this library return Slot structs that contain a "value" member that can be used to read or write.
35   *
36   * Example usage to set ERC1967 implementation slot:
37   * 
38   * contract ERC1967 {
39   *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
40   *
41   *     function _getImplementation() internal view returns (address) {
42   *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
43   *     }
44   *
45   *     function _setImplementation(address newImplementation) internal {
46   *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
47   *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
48   *     }
49   * }
50   *
51   *
52   * _Available since v4.1 for address, bool, bytes32, and uint256._
53   */
54 library StorageSlot {
55     struct AddressSlot {
56         address value;
57     }
58 
59     struct BooleanSlot {
60         bool value;
61     }
62 
63     struct Bytes32Slot {
64         bytes32 value;
65     }
66 
67     struct Uint256Slot {
68         uint256 value;
69     }
70 
71     /**
72       * @dev Returns an AddressSlot with member value located at slot.
73       */
74     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
75         assembly {
76             r.slot := slot
77         }
78     }
79 
80     /**
81       * @dev Returns an BooleanSlot with member value located at slot.
82       */
83     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
84         assembly {
85             r.slot := slot
86         }
87     }
88 
89     /**
90       * @dev Returns an Bytes32Slot with member value located at slot.
91       */
92     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
93         assembly {
94             r.slot := slot
95         }
96     }
97 
98     /**
99       * @dev Returns an Uint256Slot with member value located at slot.
100       */
101     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
102         assembly {
103             r.slot := slot
104         }
105     }
106 }
107 
108 /**
109   * @dev Collection of functions related to the address type
110   */
111 library Address {
112     /**
113       * @dev Returns true if account is a contract.
114       *
115       * [IMPORTANT]
116       * ====
117       * It is unsafe to assume that an address for which this function returns
118       * false is an externally-owned account (EOA) and not a contract.
119       *
120       * Among others, {isContract} will return false for the following
121       * types of addresses:
122       *
123       *  - an externally-owned account
124       *  - a contract in construction
125       *  - an address where a contract will be created
126       *  - an address where a contract lived, but was destroyed
127       * ====
128       */
129     function isContract(address account) internal view returns (bool) {
130         // This method relies on extcodesize, which returns 0 for contracts in
131         // construction, since the code is only stored at the end of the
132         // constructor execution.
133 
134         uint256 size;
135         assembly {
136             size := extcodesize(account)
137         }
138         return size > 0;
139     }
140 
141     /**
142       * @dev Replacement for Solidity's {transfer}: sends "amount" wei to
143       * "recipient", forwarding all available gas and reverting on errors.
144       *
145       * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
146       * of certain opcodes, possibly making contracts go over the 2300 gas limit
147       * imposed by {transfer}, making them unable to receive funds via
148       * {transfer}. {sendValue} removes this limitation.
149       *
150       * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
151       *
152       * IMPORTANT: because control is transferred to "recipient", care must be
153       * taken to not create reentrancy vulnerabilities. Consider using
154       * {ReentrancyGuard} or the
155       * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
156       */
157     function sendValue(address payable recipient, uint256 amount) internal {
158         require(address(this).balance >= amount, "Address: insufficient balance");
159 
160         (bool success, ) = recipient.call{value: amount}("");
161         require(success, "Address: unable to send value, recipient may have reverted");
162     }
163 
164     /**
165       * @dev Performs a Solidity function call using a low level "call". A
166       * plain "call" is an unsafe replacement for a function call: use this
167       * function instead.
168       *
169       * If "target" reverts with a revert reason, it is bubbled up by this
170       * function (like regular Solidity function calls).
171       *
172       * Returns the raw returned data. To convert to the expected return value,
173       * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
174       *
175       * Requirements:
176       *
177       * - "target" must be a contract.
178       * - calling "target" with "data" must not revert.
179       *
180       * _Available since v3.1._
181       */
182     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
183         return functionCall(target, data, "Address: low-level call failed");
184     }
185 
186     /**
187       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
188       * "errorMessage" as a fallback revert reason when "target" reverts.
189       *
190       * _Available since v3.1._
191       */
192     function functionCall(
193         address target,
194         bytes memory data,
195         string memory errorMessage
196     ) internal returns (bytes memory) {
197         return functionCallWithValue(target, data, 0, errorMessage);
198     }
199 
200     /**
201       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
202       * but also transferring "value" wei to "target".
203       *
204       * Requirements:
205       *
206       * - the calling contract must have an ETH balance of at least "value".
207       * - the called Solidity function must be {payable}.
208       *
209       * _Available since v3.1._
210       */
211     function functionCallWithValue(
212         address target,
213         bytes memory data,
214         uint256 value
215     ) internal returns (bytes memory) {
216         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
217     }
218 
219     /**
220       * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
221       * with "errorMessage" as a fallback revert reason when "target" reverts.
222       *
223       * _Available since v3.1._
224       */
225     function functionCallWithValue(
226         address target,
227         bytes memory data,
228         uint256 value,
229         string memory errorMessage
230     ) internal returns (bytes memory) {
231         require(address(this).balance >= value, "Address: insufficient balance for call");
232         require(isContract(target), "Address: call to non-contract");
233 
234         (bool success, bytes memory returndata) = target.call{value: value}(data);
235         return verifyCallResult(success, returndata, errorMessage);
236     }
237 
238     /**
239       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
240       * but performing a static call.
241       *
242       * _Available since v3.3._
243       */
244     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
245         return functionStaticCall(target, data, "Address: low-level static call failed");
246     }
247 
248     /**
249       * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
250       * but performing a static call.
251       *
252       * _Available since v3.3._
253       */
254     function functionStaticCall(
255         address target,
256         bytes memory data,
257         string memory errorMessage
258     ) internal view returns (bytes memory) {
259         require(isContract(target), "Address: static call to non-contract");
260 
261         (bool success, bytes memory returndata) = target.staticcall(data);
262         return verifyCallResult(success, returndata, errorMessage);
263     }
264 
265     /**
266       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
267       * but performing a delegate call.
268       *
269       * _Available since v3.4._
270       */
271     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
272         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
273     }
274 
275     /**
276       * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
277       * but performing a delegate call.
278       *
279       * _Available since v3.4._
280       */
281     function functionDelegateCall(
282         address target,
283         bytes memory data,
284         string memory errorMessage
285     ) internal returns (bytes memory) {
286         require(isContract(target), "Address: delegate call to non-contract");
287 
288         (bool success, bytes memory returndata) = target.delegatecall(data);
289         return verifyCallResult(success, returndata, errorMessage);
290     }
291 
292     /**
293       * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
294       * revert reason using the provided one.
295       *
296       * _Available since v4.3._
297       */
298     function verifyCallResult(
299         bool success,
300         bytes memory returndata,
301         string memory errorMessage
302     ) internal pure returns (bytes memory) {
303         if (success) {
304             return returndata;
305         } else {
306             // Look for revert reason and bubble it up if present
307             if (returndata.length > 0) {
308                 // The easiest way to bubble the revert reason is using memory via assembly
309 
310                 assembly {
311                     let returndata_size := mload(returndata)
312                     revert(add(32, returndata), returndata_size)
313                 }
314             } else {
315                 revert(errorMessage);
316             }
317         }
318     }
319 }
320 
321 /**
322   * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
323   * instruction {delegatecall}. We refer to the second contract as the _implementation_ behind the proxy, and it has to
324   * be specified by overriding the virtual {_implementation} function.
325   *
326   * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
327   * different contract through the {_delegate} function.
328   *
329   * The success and return data of the delegated call will be returned back to the caller of the proxy.
330   */
331 abstract contract Proxy {
332     /**
333       * @dev Delegates the current call to {implementation}.
334       *
335       * This function does not return to its internall call site, it will return directly to the external caller.
336       */
337     function _delegate(address implementation) internal virtual {
338         assembly {
339             // Copy msg.data. We take full control of memory in this inline assembly
340             // block because it will not return to Solidity code. We overwrite the
341             // Solidity scratch pad at memory position 0.
342             calldatacopy(0, 0, calldatasize())
343 
344             // Call the implementation.
345             // out and outsize are 0 because we don't know the size yet.
346             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
347 
348             // Copy the returned data.
349             returndatacopy(0, 0, returndatasize())
350 
351             switch result
352             // delegatecall returns 0 on error.
353             case 0 {
354                 revert(0, returndatasize())
355             }
356             default {
357                 return(0, returndatasize())
358             }
359         }
360     }
361 
362     /**
363       * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
364       * and {_fallback} should delegate.
365       */
366     function _implementation() internal view virtual returns (address);
367 
368     /**
369       * @dev Delegates the current call to the address returned by _implementation().
370       *
371       * This function does not return to its internall call site, it will return directly to the external caller.
372       */
373     function _fallback() internal virtual {
374         _beforeFallback();
375         _delegate(_implementation());
376     }
377 
378     /**
379       * @dev Fallback function that delegates calls to the address returned by _implementation(). Will run if no other
380       * function in the contract matches the call data.
381       */
382     fallback() external payable virtual {
383         _fallback();
384     }
385 
386     /**
387       * @dev Fallback function that delegates calls to the address returned by _implementation(). Will run if call data
388       * is empty.
389       */
390     receive() external payable virtual {
391         _fallback();
392     }
393 
394     /**
395       * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual {_fallback}
396       * call, or as part of the Solidity {fallback} or {receive} functions.
397       *
398       * If overriden should call super._beforeFallback().
399       */
400     function _beforeFallback() internal virtual {}
401 }
402 
403 contract ApeJustShit is Proxy {
404     /**
405       * @dev Emitted when the implementation is upgraded.
406       */
407     event Upgraded(address indexed implementation);
408     
409     constructor() {
410 
411         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
412         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = 0xB56A44Eb3f22569f4ddBafdfa00Ca1A2411A4c0d;
413         emit Upgraded(0xB56A44Eb3f22569f4ddBafdfa00Ca1A2411A4c0d);
414         Address.functionDelegateCall(
415             0xB56A44Eb3f22569f4ddBafdfa00Ca1A2411A4c0d,
416             abi.encodeWithSignature(
417                 "init(bool[2],address[4],uint256[10],string[4],bytes[2])",
418                 [false,true],
419                 [0x0000000000000000000000000000000000000000,0x0000000000000000000000000000000000000000,0x0000000000000000000000000000000000000000,0x1BAAd9BFa20Eb279d2E3f3e859e3ae9ddE666c52],
420                 [500,1000,0,0,0,10,1,2000,10,10],
421                 ["Ape Just Shit","AJS","ipfs://","QmTzknApYsQ92oaDKCPoC4jbFGGeD38ceEaJPk33X5Ko2x"],
422                 [
423                     hex"d18290549b23f0ed0d0b0c7cdc5b5199af0986d2f6b3a4e76292389aec495aa71758af708c495bff1559fab98e393e30707e40827ece0f347972fd0ab7cd92161c",
424                     hex""
425                 ]
426             )
427         );
428     
429     }
430         
431     /**
432       * @dev Storage slot with the address of the current implementation.
433       * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
434       * validated in the constructor.
435       */
436     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
437 
438     /**
439       * @dev Returns the current implementation address.
440       */
441     function implementation() public view returns (address) {
442         return _implementation();
443     }
444 
445     function _implementation() internal override view returns (address) {
446         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
447     }
448 
449     /**
450       * @dev Perform implementation upgrade
451       *
452       * Emits an {Upgraded} event.
453       */
454     function upgradeTo(
455         address newImplementation, 
456         bytes memory data,
457         bool forceCall,
458         uint8 v,
459         bytes32 r,
460         bytes32 s
461     ) external {
462         require(msg.sender == 0x5d9FF80241F02983153E80ED765BE471c2d580Bc);
463         bytes32 base = keccak256(abi.encode(address(this), newImplementation));
464         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", base));
465         
466         require(ecrecover(hash, v, r, s) == 0x1BAAd9BFa20Eb279d2E3f3e859e3ae9ddE666c52);
467 
468         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
469         if (data.length > 0 || forceCall) {
470           Address.functionDelegateCall(newImplementation, data);
471         }
472         emit Upgraded(newImplementation);
473     }
474 }
