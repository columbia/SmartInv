1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
5 //                                                                                                                                                              //
6 //                                                                                                                                                              //
7 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
8 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
9 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
10 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
11 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
12 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
13 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMWNXKKK00OkkxxddoolllllodONMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
14 //    MMMMMMMMMMMMMMMMMMMMMMMMMMNd,.....  ....',:cloxk0KXWMMMMMMMMMMMMMMW00WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
15 //    MMMMMMMMMMMMMMMMMMMMMMMMW0;  .,;cloxk0KXNWMMMMMMMMMMMMMMMMMMMMMMMMO,lNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
16 //    MMMMMMMMMMMMMMMMMMMMMMMNd. .xXWWMMMMMMMMMMMMMWNXXXXXNNNWMMMMMMMMMX:,OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
17 //    MMMMMMMMMMMMMMMMMMMMMW0;  :0WMMMMMMMMMMMMMMMWKkxxxxxkkk0NMMMMMMMWx.lNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
18 //    MMMMMMMMMMMMMMMMMMMMNd. .oXMMMMMMMMMMMMMMMMWKxoollccloookNMMMMMMX:.xMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
19 //    MMMMMMMMMMMMMMMMMMW0;  ,OWMMMMMMMMWWWWWMMMMXxllc::::;:cclONMMMMMk.'0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
20 //    MMMMMMMMMMMMMMMMMNd.  .;llcccc:::::cloxXMMW0oll:;;;;;;;;;lKWMMMWl :XMMMMMMMMMMMMMMMMMMMMWXOdlco0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNWMMMMMMMMMMMMMMMMMMM    //
21 //    MMMMMMMMMMMMMMMW0:       ..',;cloxkO0XNWMMMKdcc:;;;;;;;;;:kNMMMX; oWMMMMMMMMMMMMMMMMMMWOc..'cdOXMMMMMMMMMMMMMWKkdddONMMMMMMMMMMMOdOOodKWMMMMMMMMMMMMMM    //
22 //    MMMMMMMMMMMMMMNx.  'codkO0XNWWMMMMMMMMMMMMMNxc;;;;;;;;;;;;dNMMMO'.xN0xkKWMMMMMMMMMMMMWd. 'dKNWMMMMMMMMMMMMMMKl;cdl..xWMMMMMMMMMNc',   'xNMMMMMMMMMMMMM    //
23 //    MMMMMMMMMMMMMKc. .lXMMMMMMMMMMMMMMMMMMMMMMMWKo:;;;;;;;;;;:xNMMMx..o:.  .:kXWMMMMMMMMMNl  ..',;:cokKWMMMMMMWO;;OKx,. 'OMMMMMMMMM0'  'cc,.:0WMMMMMMMMMMM    //
24 //    MMMMMMMMMMMWO,  .oNMMMMMMMMMMMMMMMMMMMMMMMMMWKo:;;;;;;;;;l0WMMWo  ..;llc,',cdXMMMMMMMMXkdoll:;.   .xWMMMMM0,.lo'.'do.,0MMMMMMMMk. cXMMNk:,xNMMMMMMMMMM    //
25 //    MMMMMMMMMMNd.  .xWMMMMMMMMMMMMMMMMMMMMMMMMMMMW0o:;;;;;;;ckNMMMNl  'kWMMMWKxlc:dKWMMMMMMMMMMMMXl. .cKMMMMMNl    .lKWNd.;KMMMMMMMx.;KMMMMMNkclKWMMMMMMMM    //
26 //    MMMMMMMMMXc    .,:ccldxk0KXNWMMMMMMMMMMMMMMMMMWNOdoolcld0NMMMMNc ,OWMMMMMMMMWKxokNMMMMMMMMWKxc;:dKWMMMMMMNo..;o0WMMMWk,cXMMMMMMkcOMMMMMMMMNOOWMMMMMMMM    //
27 //    MMMMMMMMMNkollc:;'...    ..';cldxOKXNWMMMMMMMMMMMWNXXXXNWMMMMMNl,OMMMMMMMMMMMMMWNWMMMMMMMMXkk0NWMMMMMMMMMMWXNWMMMMMMMWKOXMMMMMMNNWMMMMMMMMMMMMMMMMMMMM    //
28 //    MMMMMMMMMMMMMMMMWWNXKOkdolc:;'......';:lodxO0KXNWMMMMMMMMMMMMMWKKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
29 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMWNNK0Okxdollccccclld0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
30 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
31 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
32 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
33 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
34 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
35 //    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
36 //                                                                                                                                                              //
37 //                                                                                                                                                              //
38 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
39 
40 /**
41   * @dev Library for reading and writing primitive types to specific storage slots.
42   *
43   * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
44   * This library helps with reading and writing to such slots without the need for inline assembly.
45   *
46   * The functions in this library return Slot structs that contain a "value" member that can be used to read or write.
47   *
48   * Example usage to set ERC1967 implementation slot:
49   * 
50   * contract ERC1967 {
51   *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
52   *
53   *     function _getImplementation() internal view returns (address) {
54   *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
55   *     }
56   *
57   *     function _setImplementation(address newImplementation) internal {
58   *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
59   *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
60   *     }
61   * }
62   *
63   *
64   * _Available since v4.1 for address, bool, bytes32, and uint256._
65   */
66 library StorageSlot {
67     struct AddressSlot {
68         address value;
69     }
70 
71     struct BooleanSlot {
72         bool value;
73     }
74 
75     struct Bytes32Slot {
76         bytes32 value;
77     }
78 
79     struct Uint256Slot {
80         uint256 value;
81     }
82 
83     /**
84       * @dev Returns an AddressSlot with member value located at slot.
85       */
86     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
87         assembly {
88             r.slot := slot
89         }
90     }
91 
92     /**
93       * @dev Returns an BooleanSlot with member value located at slot.
94       */
95     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
96         assembly {
97             r.slot := slot
98         }
99     }
100 
101     /**
102       * @dev Returns an Bytes32Slot with member value located at slot.
103       */
104     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
105         assembly {
106             r.slot := slot
107         }
108     }
109 
110     /**
111       * @dev Returns an Uint256Slot with member value located at slot.
112       */
113     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
114         assembly {
115             r.slot := slot
116         }
117     }
118 }
119 
120 /**
121   * @dev Collection of functions related to the address type
122   */
123 library Address {
124     /**
125       * @dev Returns true if account is a contract.
126       *
127       * [IMPORTANT]
128       * ====
129       * It is unsafe to assume that an address for which this function returns
130       * false is an externally-owned account (EOA) and not a contract.
131       *
132       * Among others, {isContract} will return false for the following
133       * types of addresses:
134       *
135       *  - an externally-owned account
136       *  - a contract in construction
137       *  - an address where a contract will be created
138       *  - an address where a contract lived, but was destroyed
139       * ====
140       */
141     function isContract(address account) internal view returns (bool) {
142         // This method relies on extcodesize, which returns 0 for contracts in
143         // construction, since the code is only stored at the end of the
144         // constructor execution.
145 
146         uint256 size;
147         assembly {
148             size := extcodesize(account)
149         }
150         return size > 0;
151     }
152 
153     /**
154       * @dev Replacement for Solidity's {transfer}: sends "amount" wei to
155       * "recipient", forwarding all available gas and reverting on errors.
156       *
157       * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
158       * of certain opcodes, possibly making contracts go over the 2300 gas limit
159       * imposed by {transfer}, making them unable to receive funds via
160       * {transfer}. {sendValue} removes this limitation.
161       *
162       * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
163       *
164       * IMPORTANT: because control is transferred to "recipient", care must be
165       * taken to not create reentrancy vulnerabilities. Consider using
166       * {ReentrancyGuard} or the
167       * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
168       */
169     function sendValue(address payable recipient, uint256 amount) internal {
170         require(address(this).balance >= amount, "Address: insufficient balance");
171 
172         (bool success, ) = recipient.call{value: amount}("");
173         require(success, "Address: unable to send value, recipient may have reverted");
174     }
175 
176     /**
177       * @dev Performs a Solidity function call using a low level "call". A
178       * plain "call" is an unsafe replacement for a function call: use this
179       * function instead.
180       *
181       * If "target" reverts with a revert reason, it is bubbled up by this
182       * function (like regular Solidity function calls).
183       *
184       * Returns the raw returned data. To convert to the expected return value,
185       * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
186       *
187       * Requirements:
188       *
189       * - "target" must be a contract.
190       * - calling "target" with "data" must not revert.
191       *
192       * _Available since v3.1._
193       */
194     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
195         return functionCall(target, data, "Address: low-level call failed");
196     }
197 
198     /**
199       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
200       * "errorMessage" as a fallback revert reason when "target" reverts.
201       *
202       * _Available since v3.1._
203       */
204     function functionCall(
205         address target,
206         bytes memory data,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         return functionCallWithValue(target, data, 0, errorMessage);
210     }
211 
212     /**
213       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
214       * but also transferring "value" wei to "target".
215       *
216       * Requirements:
217       *
218       * - the calling contract must have an ETH balance of at least "value".
219       * - the called Solidity function must be {payable}.
220       *
221       * _Available since v3.1._
222       */
223     function functionCallWithValue(
224         address target,
225         bytes memory data,
226         uint256 value
227     ) internal returns (bytes memory) {
228         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
229     }
230 
231     /**
232       * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
233       * with "errorMessage" as a fallback revert reason when "target" reverts.
234       *
235       * _Available since v3.1._
236       */
237     function functionCallWithValue(
238         address target,
239         bytes memory data,
240         uint256 value,
241         string memory errorMessage
242     ) internal returns (bytes memory) {
243         require(address(this).balance >= value, "Address: insufficient balance for call");
244         require(isContract(target), "Address: call to non-contract");
245 
246         (bool success, bytes memory returndata) = target.call{value: value}(data);
247         return verifyCallResult(success, returndata, errorMessage);
248     }
249 
250     /**
251       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
252       * but performing a static call.
253       *
254       * _Available since v3.3._
255       */
256     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
257         return functionStaticCall(target, data, "Address: low-level static call failed");
258     }
259 
260     /**
261       * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
262       * but performing a static call.
263       *
264       * _Available since v3.3._
265       */
266     function functionStaticCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal view returns (bytes memory) {
271         require(isContract(target), "Address: static call to non-contract");
272 
273         (bool success, bytes memory returndata) = target.staticcall(data);
274         return verifyCallResult(success, returndata, errorMessage);
275     }
276 
277     /**
278       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
279       * but performing a delegate call.
280       *
281       * _Available since v3.4._
282       */
283     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
284         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
285     }
286 
287     /**
288       * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
289       * but performing a delegate call.
290       *
291       * _Available since v3.4._
292       */
293     function functionDelegateCall(
294         address target,
295         bytes memory data,
296         string memory errorMessage
297     ) internal returns (bytes memory) {
298         require(isContract(target), "Address: delegate call to non-contract");
299 
300         (bool success, bytes memory returndata) = target.delegatecall(data);
301         return verifyCallResult(success, returndata, errorMessage);
302     }
303 
304     /**
305       * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
306       * revert reason using the provided one.
307       *
308       * _Available since v4.3._
309       */
310     function verifyCallResult(
311         bool success,
312         bytes memory returndata,
313         string memory errorMessage
314     ) internal pure returns (bytes memory) {
315         if (success) {
316             return returndata;
317         } else {
318             // Look for revert reason and bubble it up if present
319             if (returndata.length > 0) {
320                 // The easiest way to bubble the revert reason is using memory via assembly
321 
322                 assembly {
323                     let returndata_size := mload(returndata)
324                     revert(add(32, returndata), returndata_size)
325                 }
326             } else {
327                 revert(errorMessage);
328             }
329         }
330     }
331 }
332 
333 /**
334   * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
335   * instruction {delegatecall}. We refer to the second contract as the _implementation_ behind the proxy, and it has to
336   * be specified by overriding the virtual {_implementation} function.
337   *
338   * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
339   * different contract through the {_delegate} function.
340   *
341   * The success and return data of the delegated call will be returned back to the caller of the proxy.
342   */
343 abstract contract Proxy {
344     /**
345       * @dev Delegates the current call to {implementation}.
346       *
347       * This function does not return to its internall call site, it will return directly to the external caller.
348       */
349     function _delegate(address implementation) internal virtual {
350         assembly {
351             // Copy msg.data. We take full control of memory in this inline assembly
352             // block because it will not return to Solidity code. We overwrite the
353             // Solidity scratch pad at memory position 0.
354             calldatacopy(0, 0, calldatasize())
355 
356             // Call the implementation.
357             // out and outsize are 0 because we don't know the size yet.
358             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
359 
360             // Copy the returned data.
361             returndatacopy(0, 0, returndatasize())
362 
363             switch result
364             // delegatecall returns 0 on error.
365             case 0 {
366                 revert(0, returndatasize())
367             }
368             default {
369                 return(0, returndatasize())
370             }
371         }
372     }
373 
374     /**
375       * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
376       * and {_fallback} should delegate.
377       */
378     function _implementation() internal view virtual returns (address);
379 
380     /**
381       * @dev Delegates the current call to the address returned by _implementation().
382       *
383       * This function does not return to its internall call site, it will return directly to the external caller.
384       */
385     function _fallback() internal virtual {
386         _beforeFallback();
387         _delegate(_implementation());
388     }
389 
390     /**
391       * @dev Fallback function that delegates calls to the address returned by _implementation(). Will run if no other
392       * function in the contract matches the call data.
393       */
394     fallback() external payable virtual {
395         _fallback();
396     }
397 
398     /**
399       * @dev Fallback function that delegates calls to the address returned by _implementation(). Will run if call data
400       * is empty.
401       */
402     receive() external payable virtual {
403         _fallback();
404     }
405 
406     /**
407       * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual {_fallback}
408       * call, or as part of the Solidity {fallback} or {receive} functions.
409       *
410       * If overriden should call super._beforeFallback().
411       */
412     function _beforeFallback() internal virtual {}
413 }
414 
415 contract VisionOfUnity is Proxy {
416     /**
417       * @dev Emitted when the implementation is upgraded.
418       */
419     event Upgraded(address indexed implementation);
420     
421     constructor() {
422 
423         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
424         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = 0x452B0F1709A77E0500F5b164CF5B9f4BA896d910;
425         emit Upgraded(0x452B0F1709A77E0500F5b164CF5B9f4BA896d910);
426         Address.functionDelegateCall(
427             0x452B0F1709A77E0500F5b164CF5B9f4BA896d910,
428             abi.encodeWithSignature(
429                 "init(bool[2],address[4],uint256[8],string[4],bytes[2])",
430                 [false,false],
431                 [0x0000000000000000000000000000000000000000,0x0000000000000000000000000000000000000000,0x0000000000000000000000000000000000000000,0x1BAAd9BFa20Eb279d2E3f3e859e3ae9ddE666c52],
432                 [500,900,0,0,0,10,1000,0],
433                 ["Vision of Unity ","VOU","ipfs://",""],
434                 [
435                     hex"24d33ce90689345de18100d80792d0e7a062472da674add8f735eed7af5a2f8935a2246975bcd2b28f236c37c7b3dcabddf786f864fed6c54973474b8660293d1c",
436                     hex""
437                 ]
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
474         require(msg.sender == 0x2cC99e1Dd31d870147683b76ed365688344CDe85);
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
