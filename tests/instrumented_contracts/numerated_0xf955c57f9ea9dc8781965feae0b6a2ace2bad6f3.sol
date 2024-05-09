1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 
5 /**
6  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
7  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
8  * be specified by overriding the virtual {_implementation} function.
9  *
10  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
11  * different contract through the {_delegate} function.
12  *
13  * The success and return data of the delegated call will be returned back to the caller of the proxy.
14  */
15 abstract contract Proxy {
16     /**
17      * @dev Delegates the current call to `implementation`.
18      *
19      * This function does not return to its internall call site, it will return directly to the external caller.
20      */
21     function _delegate(address implementation) internal virtual {
22         // solhint-disable-next-line no-inline-assembly
23         assembly {
24             // Copy msg.data. We take full control of memory in this inline assembly
25             // block because it will not return to Solidity code. We overwrite the
26             // Solidity scratch pad at memory position 0.
27             calldatacopy(0, 0, calldatasize())
28 
29             // Call the implementation.
30             // out and outsize are 0 because we don't know the size yet.
31             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
32 
33             // Copy the returned data.
34             returndatacopy(0, 0, returndatasize())
35 
36             switch result
37             // delegatecall returns 0 on error.
38             case 0 { revert(0, returndatasize()) }
39             default { return(0, returndatasize()) }
40         }
41     }
42 
43     /**
44      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
45      * and {_fallback} should delegate.
46      */
47     function _implementation() internal view virtual returns (address);
48 
49     /**
50      * @dev Delegates the current call to the address returned by `_implementation()`.
51      *
52      * This function does not return to its internall call site, it will return directly to the external caller.
53      */
54     function _fallback() internal virtual {
55         _beforeFallback();
56         _delegate(_implementation());
57     }
58 
59     /**
60      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
61      * function in the contract matches the call data.
62      */
63     fallback () external payable virtual {
64         _fallback();
65     }
66 
67     /**
68      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
69      * is empty.
70      */
71     receive () external payable virtual {
72         _fallback();
73     }
74 
75     /**
76      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
77      * call, or as part of the Solidity `fallback` or `receive` functions.
78      *
79      * If overriden should call `super._beforeFallback()`.
80      */
81     function _beforeFallback() internal virtual {
82     }
83 }
84 
85 
86 // File contracts/@openzeppelin/contracts/utils/Address.sol
87 
88 // 
89 
90 
91 
92 /**
93  * @dev Collection of functions related to the address type
94  */
95 library Address {
96     /**
97      * @dev Returns true if `account` is a contract.
98      *
99      * [IMPORTANT]
100      * ====
101      * It is unsafe to assume that an address for which this function returns
102      * false is an externally-owned account (EOA) and not a contract.
103      *
104      * Among others, `isContract` will return false for the following
105      * types of addresses:
106      *
107      *  - an externally-owned account
108      *  - a contract in construction
109      *  - an address where a contract will be created
110      *  - an address where a contract lived, but was destroyed
111      * ====
112      */
113     function isContract(address account) internal view returns (bool) {
114         // This method relies on extcodesize, which returns 0 for contracts in
115         // construction, since the code is only stored at the end of the
116         // constructor execution.
117 
118         uint256 size;
119         // solhint-disable-next-line no-inline-assembly
120         assembly { size := extcodesize(account) }
121         return size > 0;
122     }
123 
124     /**
125      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
126      * `recipient`, forwarding all available gas and reverting on errors.
127      *
128      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
129      * of certain opcodes, possibly making contracts go over the 2300 gas limit
130      * imposed by `transfer`, making them unable to receive funds via
131      * `transfer`. {sendValue} removes this limitation.
132      *
133      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
134      *
135      * IMPORTANT: because control is transferred to `recipient`, care must be
136      * taken to not create reentrancy vulnerabilities. Consider using
137      * {ReentrancyGuard} or the
138      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
139      */
140     function sendValue(address payable recipient, uint256 amount) internal {
141         require(address(this).balance >= amount, "Address: insufficient balance");
142 
143         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
144         (bool success, ) = recipient.call{ value: amount }("");
145         require(success, "Address: unable to send value, recipient may have reverted");
146     }
147 
148     /**
149      * @dev Performs a Solidity function call using a low level `call`. A
150      * plain`call` is an unsafe replacement for a function call: use this
151      * function instead.
152      *
153      * If `target` reverts with a revert reason, it is bubbled up by this
154      * function (like regular Solidity function calls).
155      *
156      * Returns the raw returned data. To convert to the expected return value,
157      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
158      *
159      * Requirements:
160      *
161      * - `target` must be a contract.
162      * - calling `target` with `data` must not revert.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
167       return functionCall(target, data, "Address: low-level call failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
172      * `errorMessage` as a fallback revert reason when `target` reverts.
173      *
174      * _Available since v3.1._
175      */
176     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
177         return functionCallWithValue(target, data, 0, errorMessage);
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
182      * but also transferring `value` wei to `target`.
183      *
184      * Requirements:
185      *
186      * - the calling contract must have an ETH balance of at least `value`.
187      * - the called Solidity function must be `payable`.
188      *
189      * _Available since v3.1._
190      */
191     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
192         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
197      * with `errorMessage` as a fallback revert reason when `target` reverts.
198      *
199      * _Available since v3.1._
200      */
201     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
202         require(address(this).balance >= value, "Address: insufficient balance for call");
203         require(isContract(target), "Address: call to non-contract");
204 
205         // solhint-disable-next-line avoid-low-level-calls
206         (bool success, bytes memory returndata) = target.call{ value: value }(data);
207         return _verifyCallResult(success, returndata, errorMessage);
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
212      * but performing a static call.
213      *
214      * _Available since v3.3._
215      */
216     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
217         return functionStaticCall(target, data, "Address: low-level static call failed");
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
222      * but performing a static call.
223      *
224      * _Available since v3.3._
225      */
226     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
227         require(isContract(target), "Address: static call to non-contract");
228 
229         // solhint-disable-next-line avoid-low-level-calls
230         (bool success, bytes memory returndata) = target.staticcall(data);
231         return _verifyCallResult(success, returndata, errorMessage);
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
236      * but performing a delegate call.
237      *
238      * _Available since v3.4._
239      */
240     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
241         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
246      * but performing a delegate call.
247      *
248      * _Available since v3.4._
249      */
250     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
251         require(isContract(target), "Address: delegate call to non-contract");
252 
253         // solhint-disable-next-line avoid-low-level-calls
254         (bool success, bytes memory returndata) = target.delegatecall(data);
255         return _verifyCallResult(success, returndata, errorMessage);
256     }
257 
258     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
259         if (success) {
260             return returndata;
261         } else {
262             // Look for revert reason and bubble it up if present
263             if (returndata.length > 0) {
264                 // The easiest way to bubble the revert reason is using memory via assembly
265 
266                 // solhint-disable-next-line no-inline-assembly
267                 assembly {
268                     let returndata_size := mload(returndata)
269                     revert(add(32, returndata), returndata_size)
270                 }
271             } else {
272                 revert(errorMessage);
273             }
274         }
275     }
276 }
277 
278 
279 // File contracts/@openzeppelin/contracts/ERC1967Proxy.sol
280 
281 // 
282 
283 
284 
285 
286 /**
287  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
288  * implementation address that can be changed. This address is stored in storage in the location specified by
289  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
290  * implementation behind the proxy.
291  *
292  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
293  * {TransparentUpgradeableProxy}.
294  */
295 contract ERC1967Proxy is Proxy {
296     /**
297      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
298      *
299      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
300      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
301      */
302     constructor(address _logic, bytes memory _data) payable {
303         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
304         _setImplementation(_logic);
305         if(_data.length > 0) {
306             Address.functionDelegateCall(_logic, _data);
307         }
308     }
309 
310     /**
311      * @dev Emitted when the implementation is upgraded.
312      */
313     event Upgraded(address indexed implementation);
314 
315     /**
316      * @dev Storage slot with the address of the current implementation.
317      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
318      * validated in the constructor.
319      */
320     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
321 
322     /**
323      * @dev Returns the current implementation address.
324      */
325     function _implementation() internal view virtual override returns (address impl) {
326         bytes32 slot = _IMPLEMENTATION_SLOT;
327         // solhint-disable-next-line no-inline-assembly
328         assembly {
329             impl := sload(slot)
330         }
331     }
332 
333     /**
334      * @dev Upgrades the proxy to a new implementation.
335      *
336      * Emits an {Upgraded} event.
337      */
338     function _upgradeTo(address newImplementation) internal virtual {
339         _setImplementation(newImplementation);
340         emit Upgraded(newImplementation);
341     }
342 
343     /**
344      * @dev Stores a new address in the EIP1967 implementation slot.
345      */
346     function _setImplementation(address newImplementation) private {
347         require(Address.isContract(newImplementation), "ERC1967Proxy: new implementation is not a contract");
348 
349         bytes32 slot = _IMPLEMENTATION_SLOT;
350 
351         // solhint-disable-next-line no-inline-assembly
352         assembly {
353             sstore(slot, newImplementation)
354         }
355     }
356 }
357 
358 
359 // File contracts/@openzeppelin/contracts/TransparentUpgradeableProxy.sol
360 
361 // 
362 
363 
364 
365 /**
366  * @dev This contract implements a proxy that is upgradeable by an admin.
367  *
368  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
369  * clashing], which can potentially be used in an attack, this contract uses the
370  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
371  * things that go hand in hand:
372  *
373  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
374  * that call matches one of the admin functions exposed by the proxy itself.
375  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
376  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
377  * "admin cannot fallback to proxy target".
378  *
379  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
380  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
381  * to sudden errors when trying to call a function from the proxy implementation.
382  *
383  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
384  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
385  */
386 contract TransparentUpgradeableProxy is ERC1967Proxy {
387     /**
388      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
389      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
390      */
391     constructor(address _logic, address admin_, bytes memory _data) payable ERC1967Proxy(_logic, _data) {
392         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
393         _setAdmin(admin_);
394     }
395 
396     /**
397      * @dev Emitted when the admin account has changed.
398      */
399     event AdminChanged(address previousAdmin, address newAdmin);
400 
401     /**
402      * @dev Storage slot with the admin of the contract.
403      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
404      * validated in the constructor.
405      */
406     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
407 
408     /**
409      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
410      */
411     modifier ifAdmin() {
412         if (msg.sender == _admin()) {
413             _;
414         } else {
415             _fallback();
416         }
417     }
418 
419     /**
420      * @dev Returns the current admin.
421      *
422      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
423      *
424      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
425      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
426      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
427      */
428     function admin() external ifAdmin returns (address admin_) {
429         admin_ = _admin();
430     }
431 
432     /**
433      * @dev Returns the current implementation.
434      *
435      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
436      *
437      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
438      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
439      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
440      */
441     function implementation() external ifAdmin returns (address implementation_) {
442         implementation_ = _implementation();
443     }
444 
445     /**
446      * @dev Changes the admin of the proxy.
447      *
448      * Emits an {AdminChanged} event.
449      *
450      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
451      */
452     function changeAdmin(address newAdmin) external virtual ifAdmin {
453         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
454         emit AdminChanged(_admin(), newAdmin);
455         _setAdmin(newAdmin);
456     }
457 
458     /**
459      * @dev Upgrade the implementation of the proxy.
460      *
461      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
462      */
463     function upgradeTo(address newImplementation) external virtual ifAdmin {
464         _upgradeTo(newImplementation);
465     }
466 
467     /**
468      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
469      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
470      * proxied contract.
471      *
472      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
473      */
474     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable virtual ifAdmin {
475         _upgradeTo(newImplementation);
476         Address.functionDelegateCall(newImplementation, data);
477     }
478 
479     /**
480      * @dev Returns the current admin.
481      */
482     function _admin() internal view virtual returns (address adm) {
483         bytes32 slot = _ADMIN_SLOT;
484         // solhint-disable-next-line no-inline-assembly
485         assembly {
486             adm := sload(slot)
487         }
488     }
489 
490     /**
491      * @dev Stores a new address in the EIP1967 admin slot.
492      */
493     function _setAdmin(address newAdmin) private {
494         bytes32 slot = _ADMIN_SLOT;
495 
496         // solhint-disable-next-line no-inline-assembly
497         assembly {
498             sstore(slot, newAdmin)
499         }
500     }
501 
502     /**
503      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
504      */
505     function _beforeFallback() internal virtual override {
506         require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
507         super._beforeFallback();
508     }
509 }