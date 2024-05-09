1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
5 //                                                                                                                      //
6 //                                                                                                                      //
7 //                                                                                                                      //
8 //                                                                                                                      //
9 //                                                                                                                      //
10 //                                                   @****************@@                                                //
11 //                                           @********************************@                                         //
12 //                                       @****************************************@                                     //
13 //                 @@                 @**********************************************@                                  //
14 //                 ////@           @***************************************************@             @/                 //
15 //                  /////@       @*******************************************************@         @///                 //
16 //                   @//////@   @***********************************************************@     @////@                //
17 //               @////////////@@*************************************************************@  @////@                  //
18 //                 @/////@@@/@****************************************************************@@@/////////              //
19 //                     @/// @*************@@@@@***********************************************@@@@////@                 //
20 //                   .@     @***********@&&&&   &@**************************@@@@@**************@@/////@                 //
21 //                         @************@&&&&&&&&@***********************@&&&&   &@************@   //                   //
22 //                         @*************@@@@@@@***********@@@@@**********@&&&&&&&&@***********@                        //
23 //                         @***************************@@@@@@@@@@@@********@@@@@@@*************@                        //
24 //                        @********************************@@@@********************************@                        //
25 //                        @********************************************************************@                        //
26 //                        @********************************************************************@                        //
27 //                       (*********************************************************************@                        //
28 //                      @**********************************************************************@                        //
29 //                     @***********************************************************************@                        //
30 //                    @************************************************************************@                        //
31 //                   %***************************************************************************@                      //
32 //                 @******************************************************************************@                     //
33 //                #*****************************************@@@@@@@@@@@@@@*************************@                    //
34 //              @************************************@@...................@@@@@**********************@                  //
35 //                                                                                                                      //
36 //    --------------------------------------------------------------------------------------------------------------    //
37 //    --------------------------------------------------------------------------------------------------------------    //
38 //        .|'''.|  '||''''|    ..|'''.|  ..|''||   '|.   '|' '||''|.       .|'''.|  '||''''|  '||'      '||''''|        //
39 //        ||..  '   ||  .    .|'     '  .|'    ||   |'|   |   ||   ||      ||..  '   ||  .     ||        ||  .          //
40 //         ''|||.   ||''|    ||         ||      ||  | '|. |   ||    ||      ''|||.   ||''|     ||        ||''|          //
41 //       .     '||  ||       '|.      . '|.     ||  |   |||   ||    ||    .     '||  ||        ||        ||             //
42 //       |'....|'  .||.....|  ''|....'   ''|...|'  .|.   '|  .||...|'     |'....|'  .||.....| .||.....| .||.            //
43 //    --------------------------------------------------------------------------------------------------------------    //
44 //    --------------------------------------------------------------------------------------------------------------    //
45 //                                                                                                                      //
46 //                                                                                                                      //
47 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
48 
49 /**
50   * @dev Library for reading and writing primitive types to specific storage slots.
51   *
52   * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
53   * This library helps with reading and writing to such slots without the need for inline assembly.
54   *
55   * The functions in this library return Slot structs that contain a "value" member that can be used to read or write.
56   *
57   * Example usage to set ERC1967 implementation slot:
58   * 
59   * contract ERC1967 {
60   *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
61   *
62   *     function _getImplementation() internal view returns (address) {
63   *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
64   *     }
65   *
66   *     function _setImplementation(address newImplementation) internal {
67   *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
68   *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
69   *     }
70   * }
71   *
72   *
73   * _Available since v4.1 for address, bool, bytes32, and uint256._
74   */
75 library StorageSlot {
76     struct AddressSlot {
77         address value;
78     }
79 
80     struct BooleanSlot {
81         bool value;
82     }
83 
84     struct Bytes32Slot {
85         bytes32 value;
86     }
87 
88     struct Uint256Slot {
89         uint256 value;
90     }
91 
92     /**
93       * @dev Returns an AddressSlot with member value located at slot.
94       */
95     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
96         assembly {
97             r.slot := slot
98         }
99     }
100 
101     /**
102       * @dev Returns an BooleanSlot with member value located at slot.
103       */
104     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
105         assembly {
106             r.slot := slot
107         }
108     }
109 
110     /**
111       * @dev Returns an Bytes32Slot with member value located at slot.
112       */
113     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
114         assembly {
115             r.slot := slot
116         }
117     }
118 
119     /**
120       * @dev Returns an Uint256Slot with member value located at slot.
121       */
122     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
123         assembly {
124             r.slot := slot
125         }
126     }
127 }
128 
129 /**
130   * @dev Collection of functions related to the address type
131   */
132 library Address {
133     /**
134       * @dev Returns true if account is a contract.
135       *
136       * [IMPORTANT]
137       * ====
138       * It is unsafe to assume that an address for which this function returns
139       * false is an externally-owned account (EOA) and not a contract.
140       *
141       * Among others, {isContract} will return false for the following
142       * types of addresses:
143       *
144       *  - an externally-owned account
145       *  - a contract in construction
146       *  - an address where a contract will be created
147       *  - an address where a contract lived, but was destroyed
148       * ====
149       */
150     function isContract(address account) internal view returns (bool) {
151         // This method relies on extcodesize, which returns 0 for contracts in
152         // construction, since the code is only stored at the end of the
153         // constructor execution.
154 
155         uint256 size;
156         assembly {
157             size := extcodesize(account)
158         }
159         return size > 0;
160     }
161 
162     /**
163       * @dev Replacement for Solidity's {transfer}: sends "amount" wei to
164       * "recipient", forwarding all available gas and reverting on errors.
165       *
166       * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
167       * of certain opcodes, possibly making contracts go over the 2300 gas limit
168       * imposed by {transfer}, making them unable to receive funds via
169       * {transfer}. {sendValue} removes this limitation.
170       *
171       * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
172       *
173       * IMPORTANT: because control is transferred to "recipient", care must be
174       * taken to not create reentrancy vulnerabilities. Consider using
175       * {ReentrancyGuard} or the
176       * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
177       */
178     function sendValue(address payable recipient, uint256 amount) internal {
179         require(address(this).balance >= amount, "Address: insufficient balance");
180 
181         (bool success, ) = recipient.call{value: amount}("");
182         require(success, "Address: unable to send value, recipient may have reverted");
183     }
184 
185     /**
186       * @dev Performs a Solidity function call using a low level "call". A
187       * plain "call" is an unsafe replacement for a function call: use this
188       * function instead.
189       *
190       * If "target" reverts with a revert reason, it is bubbled up by this
191       * function (like regular Solidity function calls).
192       *
193       * Returns the raw returned data. To convert to the expected return value,
194       * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
195       *
196       * Requirements:
197       *
198       * - "target" must be a contract.
199       * - calling "target" with "data" must not revert.
200       *
201       * _Available since v3.1._
202       */
203     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
204         return functionCall(target, data, "Address: low-level call failed");
205     }
206 
207     /**
208       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
209       * "errorMessage" as a fallback revert reason when "target" reverts.
210       *
211       * _Available since v3.1._
212       */
213     function functionCall(
214         address target,
215         bytes memory data,
216         string memory errorMessage
217     ) internal returns (bytes memory) {
218         return functionCallWithValue(target, data, 0, errorMessage);
219     }
220 
221     /**
222       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
223       * but also transferring "value" wei to "target".
224       *
225       * Requirements:
226       *
227       * - the calling contract must have an ETH balance of at least "value".
228       * - the called Solidity function must be {payable}.
229       *
230       * _Available since v3.1._
231       */
232     function functionCallWithValue(
233         address target,
234         bytes memory data,
235         uint256 value
236     ) internal returns (bytes memory) {
237         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
238     }
239 
240     /**
241       * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
242       * with "errorMessage" as a fallback revert reason when "target" reverts.
243       *
244       * _Available since v3.1._
245       */
246     function functionCallWithValue(
247         address target,
248         bytes memory data,
249         uint256 value,
250         string memory errorMessage
251     ) internal returns (bytes memory) {
252         require(address(this).balance >= value, "Address: insufficient balance for call");
253         require(isContract(target), "Address: call to non-contract");
254 
255         (bool success, bytes memory returndata) = target.call{value: value}(data);
256         return verifyCallResult(success, returndata, errorMessage);
257     }
258 
259     /**
260       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
261       * but performing a static call.
262       *
263       * _Available since v3.3._
264       */
265     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
266         return functionStaticCall(target, data, "Address: low-level static call failed");
267     }
268 
269     /**
270       * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
271       * but performing a static call.
272       *
273       * _Available since v3.3._
274       */
275     function functionStaticCall(
276         address target,
277         bytes memory data,
278         string memory errorMessage
279     ) internal view returns (bytes memory) {
280         require(isContract(target), "Address: static call to non-contract");
281 
282         (bool success, bytes memory returndata) = target.staticcall(data);
283         return verifyCallResult(success, returndata, errorMessage);
284     }
285 
286     /**
287       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
288       * but performing a delegate call.
289       *
290       * _Available since v3.4._
291       */
292     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
293         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
294     }
295 
296     /**
297       * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
298       * but performing a delegate call.
299       *
300       * _Available since v3.4._
301       */
302     function functionDelegateCall(
303         address target,
304         bytes memory data,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         require(isContract(target), "Address: delegate call to non-contract");
308 
309         (bool success, bytes memory returndata) = target.delegatecall(data);
310         return verifyCallResult(success, returndata, errorMessage);
311     }
312 
313     /**
314       * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
315       * revert reason using the provided one.
316       *
317       * _Available since v4.3._
318       */
319     function verifyCallResult(
320         bool success,
321         bytes memory returndata,
322         string memory errorMessage
323     ) internal pure returns (bytes memory) {
324         if (success) {
325             return returndata;
326         } else {
327             // Look for revert reason and bubble it up if present
328             if (returndata.length > 0) {
329                 // The easiest way to bubble the revert reason is using memory via assembly
330 
331                 assembly {
332                     let returndata_size := mload(returndata)
333                     revert(add(32, returndata), returndata_size)
334                 }
335             } else {
336                 revert(errorMessage);
337             }
338         }
339     }
340 }
341 
342 /**
343   * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
344   * instruction {delegatecall}. We refer to the second contract as the _implementation_ behind the proxy, and it has to
345   * be specified by overriding the virtual {_implementation} function.
346   *
347   * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
348   * different contract through the {_delegate} function.
349   *
350   * The success and return data of the delegated call will be returned back to the caller of the proxy.
351   */
352 abstract contract Proxy {
353     /**
354       * @dev Delegates the current call to {implementation}.
355       *
356       * This function does not return to its internall call site, it will return directly to the external caller.
357       */
358     function _delegate(address implementation) internal virtual {
359         assembly {
360             // Copy msg.data. We take full control of memory in this inline assembly
361             // block because it will not return to Solidity code. We overwrite the
362             // Solidity scratch pad at memory position 0.
363             calldatacopy(0, 0, calldatasize())
364 
365             // Call the implementation.
366             // out and outsize are 0 because we don't know the size yet.
367             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
368 
369             // Copy the returned data.
370             returndatacopy(0, 0, returndatasize())
371 
372             switch result
373             // delegatecall returns 0 on error.
374             case 0 {
375                 revert(0, returndatasize())
376             }
377             default {
378                 return(0, returndatasize())
379             }
380         }
381     }
382 
383     /**
384       * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
385       * and {_fallback} should delegate.
386       */
387     function _implementation() internal view virtual returns (address);
388 
389     /**
390       * @dev Delegates the current call to the address returned by _implementation().
391       *
392       * This function does not return to its internall call site, it will return directly to the external caller.
393       */
394     function _fallback() internal virtual {
395         _beforeFallback();
396         _delegate(_implementation());
397     }
398 
399     /**
400       * @dev Fallback function that delegates calls to the address returned by _implementation(). Will run if no other
401       * function in the contract matches the call data.
402       */
403     fallback() external payable virtual {
404         _fallback();
405     }
406 
407     /**
408       * @dev Fallback function that delegates calls to the address returned by _implementation(). Will run if call data
409       * is empty.
410       */
411     receive() external payable virtual {
412         _fallback();
413     }
414 
415     /**
416       * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual {_fallback}
417       * call, or as part of the Solidity {fallback} or {receive} functions.
418       *
419       * If overriden should call super._beforeFallback().
420       */
421     function _beforeFallback() internal virtual {}
422 }
423 
424 contract SecondSelf is Proxy {
425     /**
426       * @dev Emitted when the implementation is upgraded.
427       */
428     event Upgraded(address indexed implementation);
429     
430     constructor() {
431 
432         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
433         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = 0x77F23779cFB1C30BE694F6664CE425D95c17049A;
434         emit Upgraded(0x77F23779cFB1C30BE694F6664CE425D95c17049A);
435         Address.functionDelegateCall(
436             0x77F23779cFB1C30BE694F6664CE425D95c17049A,
437             abi.encodeWithSignature(
438                 "init(bool[2],address[3],uint256[6],string[3])",
439                 [false,true],
440                 [0x0000000000000000000000000000000000000000,0x0000000000000000000000000000000000000000,0x1BAAd9BFa20Eb279d2E3f3e859e3ae9ddE666c52],
441                 [500,0,0,8888,100,300],
442                 ["Second Self","SELF","QmcWJFk8Ji83ZbcwxpPjizfEWbV7edibYT8bqpzV1uSYR9"]
443             )
444         );
445     
446     }
447         
448     /**
449       * @dev Storage slot with the address of the current implementation.
450       * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
451       * validated in the constructor.
452       */
453     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
454 
455     /**
456       * @dev Returns the current implementation address.
457       */
458     function implementation() public view returns (address) {
459         return _implementation();
460     }
461 
462     function _implementation() internal override view returns (address) {
463         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
464     }
465 
466     /**
467       * @dev Perform implementation upgrade
468       *
469       * Emits an {Upgraded} event.
470       */
471     function upgradeTo(
472         address newImplementation, 
473         bytes memory data,
474         bool forceCall,
475         uint8 v,
476         bytes32 r,
477         bytes32 s
478     ) external {
479         require(msg.sender == 0xca68BA6328Cc29D022B2b30A3B4f9d1Db4B55FfF);
480         bytes32 base = keccak256(abi.encode(address(this), newImplementation));
481         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", base));
482         
483         require(ecrecover(hash, v, r, s) == 0x1BAAd9BFa20Eb279d2E3f3e859e3ae9ddE666c52);
484 
485         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
486         if (data.length > 0 || forceCall) {
487           Address.functionDelegateCall(newImplementation, data);
488         }
489         emit Upgraded(newImplementation);
490     }
491 }
