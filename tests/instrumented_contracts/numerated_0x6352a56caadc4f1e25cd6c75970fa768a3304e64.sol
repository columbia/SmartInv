1 // File: @openzeppelin/contracts/proxy/Proxy.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
9  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
10  * be specified by overriding the virtual {_implementation} function.
11  *
12  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
13  * different contract through the {_delegate} function.
14  *
15  * The success and return data of the delegated call will be returned back to the caller of the proxy.
16  */
17 abstract contract Proxy {
18     /**
19      * @dev Delegates the current call to `implementation`.
20      *
21      * This function does not return to its internall call site, it will return directly to the external caller.
22      */
23     function _delegate(address implementation) internal virtual {
24         // solhint-disable-next-line no-inline-assembly
25         assembly {
26             // Copy msg.data. We take full control of memory in this inline assembly
27             // block because it will not return to Solidity code. We overwrite the
28             // Solidity scratch pad at memory position 0.
29             calldatacopy(0, 0, calldatasize())
30 
31             // Call the implementation.
32             // out and outsize are 0 because we don't know the size yet.
33             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
34 
35             // Copy the returned data.
36             returndatacopy(0, 0, returndatasize())
37 
38             switch result
39             // delegatecall returns 0 on error.
40             case 0 {
41                 revert(0, returndatasize())
42             }
43             default {
44                 return(0, returndatasize())
45             }
46         }
47     }
48 
49     /**
50      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
51      * and {_fallback} should delegate.
52      */
53     function _implementation() internal view virtual returns (address);
54 
55     /**
56      * @dev Delegates the current call to the address returned by `_implementation()`.
57      *
58      * This function does not return to its internall call site, it will return directly to the external caller.
59      */
60     function _fallback() internal virtual {
61         _beforeFallback();
62         _delegate(_implementation());
63     }
64 
65     /**
66      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
67      * function in the contract matches the call data.
68      */
69     fallback() external payable virtual {
70         _fallback();
71     }
72 
73     /**
74      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
75      * is empty.
76      */
77     receive() external payable virtual {
78         _fallback();
79     }
80 
81     /**
82      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
83      * call, or as part of the Solidity `fallback` or `receive` functions.
84      *
85      * If overriden should call `super._beforeFallback()`.
86      */
87     function _beforeFallback() internal virtual {}
88 }
89 
90 // File: @openzeppelin/contracts/utils/Address.sol
91 
92 pragma solidity >=0.6.2 <0.8.0;
93 
94 /**
95  * @dev Collection of functions related to the address type
96  */
97 library Address {
98     /**
99      * @dev Returns true if `account` is a contract.
100      *
101      * [IMPORTANT]
102      * ====
103      * It is unsafe to assume that an address for which this function returns
104      * false is an externally-owned account (EOA) and not a contract.
105      *
106      * Among others, `isContract` will return false for the following
107      * types of addresses:
108      *
109      *  - an externally-owned account
110      *  - a contract in construction
111      *  - an address where a contract will be created
112      *  - an address where a contract lived, but was destroyed
113      * ====
114      */
115     function isContract(address account) internal view returns (bool) {
116         // This method relies on extcodesize, which returns 0 for contracts in
117         // construction, since the code is only stored at the end of the
118         // constructor execution.
119 
120         uint256 size;
121         // solhint-disable-next-line no-inline-assembly
122         assembly {
123             size := extcodesize(account)
124         }
125         return size > 0;
126     }
127 
128     /**
129      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
130      * `recipient`, forwarding all available gas and reverting on errors.
131      *
132      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
133      * of certain opcodes, possibly making contracts go over the 2300 gas limit
134      * imposed by `transfer`, making them unable to receive funds via
135      * `transfer`. {sendValue} removes this limitation.
136      *
137      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
138      *
139      * IMPORTANT: because control is transferred to `recipient`, care must be
140      * taken to not create reentrancy vulnerabilities. Consider using
141      * {ReentrancyGuard} or the
142      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
143      */
144     function sendValue(address payable recipient, uint256 amount) internal {
145         require(address(this).balance >= amount, "Address: insufficient balance");
146 
147         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
148         (bool success, ) = recipient.call{value: amount}("");
149         require(success, "Address: unable to send value, recipient may have reverted");
150     }
151 
152     /**
153      * @dev Performs a Solidity function call using a low level `call`. A
154      * plain`call` is an unsafe replacement for a function call: use this
155      * function instead.
156      *
157      * If `target` reverts with a revert reason, it is bubbled up by this
158      * function (like regular Solidity function calls).
159      *
160      * Returns the raw returned data. To convert to the expected return value,
161      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
162      *
163      * Requirements:
164      *
165      * - `target` must be a contract.
166      * - calling `target` with `data` must not revert.
167      *
168      * _Available since v3.1._
169      */
170     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
171         return functionCall(target, data, "Address: low-level call failed");
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
176      * `errorMessage` as a fallback revert reason when `target` reverts.
177      *
178      * _Available since v3.1._
179      */
180     function functionCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal returns (bytes memory) {
185         return functionCallWithValue(target, data, 0, errorMessage);
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
190      * but also transferring `value` wei to `target`.
191      *
192      * Requirements:
193      *
194      * - the calling contract must have an ETH balance of at least `value`.
195      * - the called Solidity function must be `payable`.
196      *
197      * _Available since v3.1._
198      */
199     function functionCallWithValue(
200         address target,
201         bytes memory data,
202         uint256 value
203     ) internal returns (bytes memory) {
204         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
209      * with `errorMessage` as a fallback revert reason when `target` reverts.
210      *
211      * _Available since v3.1._
212      */
213     function functionCallWithValue(
214         address target,
215         bytes memory data,
216         uint256 value,
217         string memory errorMessage
218     ) internal returns (bytes memory) {
219         require(address(this).balance >= value, "Address: insufficient balance for call");
220         require(isContract(target), "Address: call to non-contract");
221 
222         // solhint-disable-next-line avoid-low-level-calls
223         (bool success, bytes memory returndata) = target.call{value: value}(data);
224         return _verifyCallResult(success, returndata, errorMessage);
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
229      * but performing a static call.
230      *
231      * _Available since v3.3._
232      */
233     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
234         return functionStaticCall(target, data, "Address: low-level static call failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
239      * but performing a static call.
240      *
241      * _Available since v3.3._
242      */
243     function functionStaticCall(
244         address target,
245         bytes memory data,
246         string memory errorMessage
247     ) internal view returns (bytes memory) {
248         require(isContract(target), "Address: static call to non-contract");
249 
250         // solhint-disable-next-line avoid-low-level-calls
251         (bool success, bytes memory returndata) = target.staticcall(data);
252         return _verifyCallResult(success, returndata, errorMessage);
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
278         // solhint-disable-next-line avoid-low-level-calls
279         (bool success, bytes memory returndata) = target.delegatecall(data);
280         return _verifyCallResult(success, returndata, errorMessage);
281     }
282 
283     function _verifyCallResult(
284         bool success,
285         bytes memory returndata,
286         string memory errorMessage
287     ) private pure returns (bytes memory) {
288         if (success) {
289             return returndata;
290         } else {
291             // Look for revert reason and bubble it up if present
292             if (returndata.length > 0) {
293                 // The easiest way to bubble the revert reason is using memory via assembly
294 
295                 // solhint-disable-next-line no-inline-assembly
296                 assembly {
297                     let returndata_size := mload(returndata)
298                     revert(add(32, returndata), returndata_size)
299                 }
300             } else {
301                 revert(errorMessage);
302             }
303         }
304     }
305 }
306 
307 // File: @openzeppelin/contracts/proxy/UpgradeableProxy.sol
308 
309 pragma solidity >=0.6.0 <0.8.0;
310 
311 /**
312  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
313  * implementation address that can be changed. This address is stored in storage in the location specified by
314  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
315  * implementation behind the proxy.
316  *
317  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
318  * {TransparentUpgradeableProxy}.
319  */
320 contract UpgradeableProxy is Proxy {
321     /**
322      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
323      *
324      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
325      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
326      */
327     constructor(address _logic, bytes memory _data) public payable {
328         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
329         _setImplementation(_logic);
330         if (_data.length > 0) {
331             Address.functionDelegateCall(_logic, _data);
332         }
333     }
334 
335     /**
336      * @dev Emitted when the implementation is upgraded.
337      */
338     event Upgraded(address indexed implementation);
339 
340     /**
341      * @dev Storage slot with the address of the current implementation.
342      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
343      * validated in the constructor.
344      */
345     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
346 
347     /**
348      * @dev Returns the current implementation address.
349      */
350     function _implementation() internal view virtual override returns (address impl) {
351         bytes32 slot = _IMPLEMENTATION_SLOT;
352         // solhint-disable-next-line no-inline-assembly
353         assembly {
354             impl := sload(slot)
355         }
356     }
357 
358     /**
359      * @dev Upgrades the proxy to a new implementation.
360      *
361      * Emits an {Upgraded} event.
362      */
363     function _upgradeTo(address newImplementation) internal virtual {
364         _setImplementation(newImplementation);
365         emit Upgraded(newImplementation);
366     }
367 
368     /**
369      * @dev Stores a new address in the EIP1967 implementation slot.
370      */
371     function _setImplementation(address newImplementation) private {
372         require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
373 
374         bytes32 slot = _IMPLEMENTATION_SLOT;
375 
376         // solhint-disable-next-line no-inline-assembly
377         assembly {
378             sstore(slot, newImplementation)
379         }
380     }
381 }
382 
383 // File: @openzeppelin/contracts/proxy/TransparentUpgradeableProxy.sol
384 
385 pragma solidity >=0.6.0 <0.8.0;
386 
387 /**
388  * @dev This contract implements a proxy that is upgradeable by an admin.
389  *
390  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
391  * clashing], which can potentially be used in an attack, this contract uses the
392  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
393  * things that go hand in hand:
394  *
395  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
396  * that call matches one of the admin functions exposed by the proxy itself.
397  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
398  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
399  * "admin cannot fallback to proxy target".
400  *
401  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
402  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
403  * to sudden errors when trying to call a function from the proxy implementation.
404  *
405  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
406  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
407  */
408 contract TransparentUpgradeableProxy is UpgradeableProxy {
409     /**
410      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
411      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
412      */
413     constructor(
414         address _logic,
415         address admin_,
416         bytes memory _data
417     ) public payable UpgradeableProxy(_logic, _data) {
418         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
419         _setAdmin(admin_);
420     }
421 
422     /**
423      * @dev Emitted when the admin account has changed.
424      */
425     event AdminChanged(address previousAdmin, address newAdmin);
426 
427     /**
428      * @dev Storage slot with the admin of the contract.
429      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
430      * validated in the constructor.
431      */
432     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
433 
434     /**
435      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
436      */
437     modifier ifAdmin() {
438         if (msg.sender == _admin()) {
439             _;
440         } else {
441             _fallback();
442         }
443     }
444 
445     /**
446      * @dev Returns the current admin.
447      *
448      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
449      *
450      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
451      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
452      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
453      */
454     function admin() external ifAdmin returns (address admin_) {
455         admin_ = _admin();
456     }
457 
458     /**
459      * @dev Returns the current implementation.
460      *
461      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
462      *
463      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
464      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
465      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
466      */
467     function implementation() external ifAdmin returns (address implementation_) {
468         implementation_ = _implementation();
469     }
470 
471     /**
472      * @dev Changes the admin of the proxy.
473      *
474      * Emits an {AdminChanged} event.
475      *
476      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
477      */
478     function changeAdmin(address newAdmin) external virtual ifAdmin {
479         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
480         emit AdminChanged(_admin(), newAdmin);
481         _setAdmin(newAdmin);
482     }
483 
484     /**
485      * @dev Upgrade the implementation of the proxy.
486      *
487      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
488      */
489     function upgradeTo(address newImplementation) external virtual ifAdmin {
490         _upgradeTo(newImplementation);
491     }
492 
493     /**
494      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
495      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
496      * proxied contract.
497      *
498      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
499      */
500     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable virtual ifAdmin {
501         _upgradeTo(newImplementation);
502         Address.functionDelegateCall(newImplementation, data);
503     }
504 
505     /**
506      * @dev Returns the current admin.
507      */
508     function _admin() internal view virtual returns (address adm) {
509         bytes32 slot = _ADMIN_SLOT;
510         // solhint-disable-next-line no-inline-assembly
511         assembly {
512             adm := sload(slot)
513         }
514     }
515 
516     /**
517      * @dev Stores a new address in the EIP1967 admin slot.
518      */
519     function _setAdmin(address newAdmin) private {
520         bytes32 slot = _ADMIN_SLOT;
521 
522         // solhint-disable-next-line no-inline-assembly
523         assembly {
524             sstore(slot, newAdmin)
525         }
526     }
527 
528     /**
529      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
530      */
531     function _beforeFallback() internal virtual override {
532         require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
533         super._beforeFallback();
534     }
535 }
536 
537 // File: contracts/OpenOceanExchangeProxy.sol
538 
539 pragma solidity ^0.6.12;
540 
541 contract OpenOceanExchangeProxy is TransparentUpgradeableProxy {
542     constructor(
543         address logic,
544         address admin,
545         bytes memory data
546     ) public TransparentUpgradeableProxy(logic, admin, data) {}
547 }