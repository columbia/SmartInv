1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 ////////////////////////////////////////////////////////////////////////////////////////////
5 //                                                                                        //
6 //                                                                                        //
7 //    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
8 //    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
9 //    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
10 //    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
11 //    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
12 //    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
13 //    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,,,,,,..,,,,,........,,,,,,,,,,,,,,,,,,,,,,,    //
14 //    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,,,,,,,,,,,,,.,.,,,,******.,,,,,,,,,,,,,,,,,,,,,    //
15 //    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,,,,,**********,,,************.,,,,,,,,,,,,,,,,,,,    //
16 //    ,,,,,,,,,,,,,,,,,,,,,,,,,,,.,,,********,,,,,,,**,,**,,,,,,,,**.,,,,,,,,,,,,,,,,,    //
17 //    ,,,,,,,,,,,,,,,,,,,,,,,,,,.,,,******,**************,***********,,..,,,,,,,,,,,,,    //
18 //    ,,,,,,,,,,,,,,,,,,,,,,,,.,,,,,*********,,,**************,,,,,,,,,,,,.,,,,,,,,,,,    //
19 //    ,,,,,,,,,,,,,,,,,,,,,.,,,,,,,*****,**,,****,,,,,,,,,,,,,,&&&&&&&&&&*,.,,,,,,,,,,    //
20 //    ,,,,,,,,,,,,,,,,,,,,.,,,,,,,******,,,,,,&&&,..,@@@@@@,@@@@,....,@@@@*,.,,,,,,,,,    //
21 //    ,,,,,,,,,,,,,,,,,,,.,,,,,,,*********,*@@@@,@...,@@@**,***@,....,@%*, .,,,,,,,,,,    //
22 //    ,,,,,,,,,,,,,,,,..,,,,,,,***************,,,,,,,,,,***********,,,,..,,,,,,,,,,,,,    //
23 //    ,,,,,,,,,,,,,,,,..,,,,,,*****************,,,,*******************..,,,,,,,,,,,,,,    //
24 //    ,,,,,,,,,,,,,,,.,,,,,,,******************************************,.,,,,,,,,,,,,,    //
25 //    ,,,,,,,,,,,,,,,.,,,,,,,,*******************************************.,,,,,,,,,,,,    //
26 //    ,,,,,,,,,,,,,,,.,,,,,,,,*******,***(((((((((************************.,,,,,,,,,,,    //
27 //    ,,,,,,,,,,,,,,,,..,,,,,,,*****,****(((((((*,,******(((((((((((*****.,,,,,,,,,,,,    //
28 //    ,,,,,,,,,,,,,,,,,..,,,,,,,****,************,,,,((((((((((((((**...,,,,,,,,,,,,,,    //
29 //    ,,,,,,,,,,,,,,,,,...,,,,,,,,********************************.,,,,,,,,,,,,,,,,,,,    //
30 //    ,,,,,,,,,,,,,,,,......,,,,,,,,****************************.,,,,,,,,,,,,,,,,,,,,,    //
31 //    ,,,,,,,,,,,,,...***********...,,,,,*******************,,.,,,,,,,,,,,,,,,,,,,,,,,    //
32 //    ,,,,,,,,,,,...*******************************************..,,,,,,,,,,,,,,,,,,,,,    //
33 //    ,,,,,,,,,,..,*********,****************************/******,..,,,,,,,,,,,,,,,,,,,    //
34 //    ,,,,,,,,,...********.***************************************...,,,,,,,,,,,,,,,,,    //
35 //    ,,,,,,,,,...********.****************************************...,,,,,,,,,,,,,,,,    //
36 //    ,,,,,,,,,...********,,***************************************.....,,,,,,,,,,,,,,    //
37 //    ,,,,,,,,,....********.****************************************.....,,,,,,,,,,,,,    //
38 //    ,,,,,,,,,.....********.****************************************.....,,,,,,,,,,,,    //
39 //                                                                                        //
40 //                                                                                        //
41 ////////////////////////////////////////////////////////////////////////////////////////////
42 
43 /**
44   * @dev Library for reading and writing primitive types to specific storage slots.
45   *
46   * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
47   * This library helps with reading and writing to such slots without the need for inline assembly.
48   *
49   * The functions in this library return Slot structs that contain a "value" member that can be used to read or write.
50   *
51   * Example usage to set ERC1967 implementation slot:
52   * 
53   * contract ERC1967 {
54   *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
55   *
56   *     function _getImplementation() internal view returns (address) {
57   *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
58   *     }
59   *
60   *     function _setImplementation(address newImplementation) internal {
61   *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
62   *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
63   *     }
64   * }
65   *
66   *
67   * _Available since v4.1 for address, bool, bytes32, and uint256._
68   */
69 library StorageSlot {
70     struct AddressSlot {
71         address value;
72     }
73 
74     struct BooleanSlot {
75         bool value;
76     }
77 
78     struct Bytes32Slot {
79         bytes32 value;
80     }
81 
82     struct Uint256Slot {
83         uint256 value;
84     }
85 
86     /**
87       * @dev Returns an AddressSlot with member value located at slot.
88       */
89     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
90         assembly {
91             r.slot := slot
92         }
93     }
94 
95     /**
96       * @dev Returns an BooleanSlot with member value located at slot.
97       */
98     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
99         assembly {
100             r.slot := slot
101         }
102     }
103 
104     /**
105       * @dev Returns an Bytes32Slot with member value located at slot.
106       */
107     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
108         assembly {
109             r.slot := slot
110         }
111     }
112 
113     /**
114       * @dev Returns an Uint256Slot with member value located at slot.
115       */
116     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
117         assembly {
118             r.slot := slot
119         }
120     }
121 }
122 
123 /**
124   * @dev Collection of functions related to the address type
125   */
126 library Address {
127     /**
128       * @dev Returns true if account is a contract.
129       *
130       * [IMPORTANT]
131       * ====
132       * It is unsafe to assume that an address for which this function returns
133       * false is an externally-owned account (EOA) and not a contract.
134       *
135       * Among others, {isContract} will return false for the following
136       * types of addresses:
137       *
138       *  - an externally-owned account
139       *  - a contract in construction
140       *  - an address where a contract will be created
141       *  - an address where a contract lived, but was destroyed
142       * ====
143       */
144     function isContract(address account) internal view returns (bool) {
145         // This method relies on extcodesize, which returns 0 for contracts in
146         // construction, since the code is only stored at the end of the
147         // constructor execution.
148 
149         uint256 size;
150         assembly {
151             size := extcodesize(account)
152         }
153         return size > 0;
154     }
155 
156     /**
157       * @dev Replacement for Solidity's {transfer}: sends "amount" wei to
158       * "recipient", forwarding all available gas and reverting on errors.
159       *
160       * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
161       * of certain opcodes, possibly making contracts go over the 2300 gas limit
162       * imposed by {transfer}, making them unable to receive funds via
163       * {transfer}. {sendValue} removes this limitation.
164       *
165       * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
166       *
167       * IMPORTANT: because control is transferred to "recipient", care must be
168       * taken to not create reentrancy vulnerabilities. Consider using
169       * {ReentrancyGuard} or the
170       * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
171       */
172     function sendValue(address payable recipient, uint256 amount) internal {
173         require(address(this).balance >= amount, "Address: insufficient balance");
174 
175         (bool success, ) = recipient.call{value: amount}("");
176         require(success, "Address: unable to send value, recipient may have reverted");
177     }
178 
179     /**
180       * @dev Performs a Solidity function call using a low level "call". A
181       * plain "call" is an unsafe replacement for a function call: use this
182       * function instead.
183       *
184       * If "target" reverts with a revert reason, it is bubbled up by this
185       * function (like regular Solidity function calls).
186       *
187       * Returns the raw returned data. To convert to the expected return value,
188       * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
189       *
190       * Requirements:
191       *
192       * - "target" must be a contract.
193       * - calling "target" with "data" must not revert.
194       *
195       * _Available since v3.1._
196       */
197     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
198         return functionCall(target, data, "Address: low-level call failed");
199     }
200 
201     /**
202       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
203       * "errorMessage" as a fallback revert reason when "target" reverts.
204       *
205       * _Available since v3.1._
206       */
207     function functionCall(
208         address target,
209         bytes memory data,
210         string memory errorMessage
211     ) internal returns (bytes memory) {
212         return functionCallWithValue(target, data, 0, errorMessage);
213     }
214 
215     /**
216       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
217       * but also transferring "value" wei to "target".
218       *
219       * Requirements:
220       *
221       * - the calling contract must have an ETH balance of at least "value".
222       * - the called Solidity function must be {payable}.
223       *
224       * _Available since v3.1._
225       */
226     function functionCallWithValue(
227         address target,
228         bytes memory data,
229         uint256 value
230     ) internal returns (bytes memory) {
231         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
232     }
233 
234     /**
235       * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
236       * with "errorMessage" as a fallback revert reason when "target" reverts.
237       *
238       * _Available since v3.1._
239       */
240     function functionCallWithValue(
241         address target,
242         bytes memory data,
243         uint256 value,
244         string memory errorMessage
245     ) internal returns (bytes memory) {
246         require(address(this).balance >= value, "Address: insufficient balance for call");
247         require(isContract(target), "Address: call to non-contract");
248 
249         (bool success, bytes memory returndata) = target.call{value: value}(data);
250         return verifyCallResult(success, returndata, errorMessage);
251     }
252 
253     /**
254       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
255       * but performing a static call.
256       *
257       * _Available since v3.3._
258       */
259     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
260         return functionStaticCall(target, data, "Address: low-level static call failed");
261     }
262 
263     /**
264       * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
265       * but performing a static call.
266       *
267       * _Available since v3.3._
268       */
269     function functionStaticCall(
270         address target,
271         bytes memory data,
272         string memory errorMessage
273     ) internal view returns (bytes memory) {
274         require(isContract(target), "Address: static call to non-contract");
275 
276         (bool success, bytes memory returndata) = target.staticcall(data);
277         return verifyCallResult(success, returndata, errorMessage);
278     }
279 
280     /**
281       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
282       * but performing a delegate call.
283       *
284       * _Available since v3.4._
285       */
286     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
287         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
288     }
289 
290     /**
291       * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
292       * but performing a delegate call.
293       *
294       * _Available since v3.4._
295       */
296     function functionDelegateCall(
297         address target,
298         bytes memory data,
299         string memory errorMessage
300     ) internal returns (bytes memory) {
301         require(isContract(target), "Address: delegate call to non-contract");
302 
303         (bool success, bytes memory returndata) = target.delegatecall(data);
304         return verifyCallResult(success, returndata, errorMessage);
305     }
306 
307     /**
308       * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
309       * revert reason using the provided one.
310       *
311       * _Available since v4.3._
312       */
313     function verifyCallResult(
314         bool success,
315         bytes memory returndata,
316         string memory errorMessage
317     ) internal pure returns (bytes memory) {
318         if (success) {
319             return returndata;
320         } else {
321             // Look for revert reason and bubble it up if present
322             if (returndata.length > 0) {
323                 // The easiest way to bubble the revert reason is using memory via assembly
324 
325                 assembly {
326                     let returndata_size := mload(returndata)
327                     revert(add(32, returndata), returndata_size)
328                 }
329             } else {
330                 revert(errorMessage);
331             }
332         }
333     }
334 }
335 
336 /**
337   * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
338   * instruction {delegatecall}. We refer to the second contract as the _implementation_ behind the proxy, and it has to
339   * be specified by overriding the virtual {_implementation} function.
340   *
341   * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
342   * different contract through the {_delegate} function.
343   *
344   * The success and return data of the delegated call will be returned back to the caller of the proxy.
345   */
346 abstract contract Proxy {
347     /**
348       * @dev Delegates the current call to {implementation}.
349       *
350       * This function does not return to its internall call site, it will return directly to the external caller.
351       */
352     function _delegate(address implementation) internal virtual {
353         assembly {
354             // Copy msg.data. We take full control of memory in this inline assembly
355             // block because it will not return to Solidity code. We overwrite the
356             // Solidity scratch pad at memory position 0.
357             calldatacopy(0, 0, calldatasize())
358 
359             // Call the implementation.
360             // out and outsize are 0 because we don't know the size yet.
361             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
362 
363             // Copy the returned data.
364             returndatacopy(0, 0, returndatasize())
365 
366             switch result
367             // delegatecall returns 0 on error.
368             case 0 {
369                 revert(0, returndatasize())
370             }
371             default {
372                 return(0, returndatasize())
373             }
374         }
375     }
376 
377     /**
378       * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
379       * and {_fallback} should delegate.
380       */
381     function _implementation() internal view virtual returns (address);
382 
383     /**
384       * @dev Delegates the current call to the address returned by _implementation().
385       *
386       * This function does not return to its internall call site, it will return directly to the external caller.
387       */
388     function _fallback() internal virtual {
389         _beforeFallback();
390         _delegate(_implementation());
391     }
392 
393     /**
394       * @dev Fallback function that delegates calls to the address returned by _implementation(). Will run if no other
395       * function in the contract matches the call data.
396       */
397     fallback() external payable virtual {
398         _fallback();
399     }
400 
401     /**
402       * @dev Fallback function that delegates calls to the address returned by _implementation(). Will run if call data
403       * is empty.
404       */
405     receive() external payable virtual {
406         _fallback();
407     }
408 
409     /**
410       * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual {_fallback}
411       * call, or as part of the Solidity {fallback} or {receive} functions.
412       *
413       * If overriden should call super._beforeFallback().
414       */
415     function _beforeFallback() internal virtual {}
416 }
417 
418 contract MemeLords is Proxy {
419     /**
420       * @dev Emitted when the implementation is upgraded.
421       */
422     event Upgraded(address indexed implementation);
423     
424     constructor() {
425 
426         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
427         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = 0xB56A44Eb3f22569f4ddBafdfa00Ca1A2411A4c0d;
428         emit Upgraded(0xB56A44Eb3f22569f4ddBafdfa00Ca1A2411A4c0d);
429         Address.functionDelegateCall(
430             0xB56A44Eb3f22569f4ddBafdfa00Ca1A2411A4c0d,
431             abi.encodeWithSignature(
432                 "init(bool[2],address[4],uint256[10],string[4],bytes[2])",
433                 [false,false],
434                 [0x0000000000000000000000000000000000000000,0x0000000000000000000000000000000000000000,0x0000000000000000000000000000000000000000,0x1BAAd9BFa20Eb279d2E3f3e859e3ae9ddE666c52],
435                 [500,750,0,0,0,10,1,999,0,1],
436                 ["Meme Lords","MEME","ipfs://","QmcLhnqHVGitfm6weawNCQH4tjN8ZfMZAVoduhdkFMkKK7"],
437                 ["",""]
438             )
439         );
440     
441     }
442         
443     /**
444       * @dev Storage slot with the address of the current implementation.
445       * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
446       * validated in the constructor.
447       */
448     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
449 
450     /**
451       * @dev Returns the current implementation address.
452       */
453     function implementation() public view returns (address) {
454         return _implementation();
455     }
456 
457     function _implementation() internal override view returns (address) {
458         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
459     }
460 
461     /**
462       * @dev Perform implementation upgrade
463       *
464       * Emits an {Upgraded} event.
465       */
466     function upgradeTo(
467         address newImplementation, 
468         bytes memory data,
469         bool forceCall,
470         uint8 v,
471         bytes32 r,
472         bytes32 s
473     ) external {
474         require(msg.sender == 0x73f3954E363A0c340D73C82De10058774C2e3310);
475         bytes32 base = keccak256(abi.encode(address(this), newImplementation));
476         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", base));
477         
478         require(ecrecover(hash, v, r, s) == 0x1BAAd9BFa20Eb279d2E3f3e859e3ae9ddE666c52);
479 
480         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
481         if (data.length > 0 || forceCall) {
482           Address.functionDelegateCall(newImplementation, data);
483         }
484         emit Upgraded(newImplementation);
485     }
486 }
