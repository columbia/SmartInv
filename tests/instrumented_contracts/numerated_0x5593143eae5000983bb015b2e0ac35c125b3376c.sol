1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 
7 
8 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/Address
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library Address {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      */
31     function isContract(address account) internal view returns (bool) {
32         // This method relies on extcodesize, which returns 0 for contracts in
33         // construction, since the code is only stored at the end of the
34         // constructor execution.
35 
36         uint256 size;
37         // solhint-disable-next-line no-inline-assembly
38         assembly { size := extcodesize(account) }
39         return size > 0;
40     }
41 
42     /**
43      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
44      * `recipient`, forwarding all available gas and reverting on errors.
45      *
46      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
47      * of certain opcodes, possibly making contracts go over the 2300 gas limit
48      * imposed by `transfer`, making them unable to receive funds via
49      * `transfer`. {sendValue} removes this limitation.
50      *
51      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
52      *
53      * IMPORTANT: because control is transferred to `recipient`, care must be
54      * taken to not create reentrancy vulnerabilities. Consider using
55      * {ReentrancyGuard} or the
56      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
57      */
58     function sendValue(address payable recipient, uint256 amount) internal {
59         require(address(this).balance >= amount, "Address: insufficient balance");
60 
61         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
62         (bool success, ) = recipient.call{ value: amount }("");
63         require(success, "Address: unable to send value, recipient may have reverted");
64     }
65 
66     /**
67      * @dev Performs a Solidity function call using a low level `call`. A
68      * plain`call` is an unsafe replacement for a function call: use this
69      * function instead.
70      *
71      * If `target` reverts with a revert reason, it is bubbled up by this
72      * function (like regular Solidity function calls).
73      *
74      * Returns the raw returned data. To convert to the expected return value,
75      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
76      *
77      * Requirements:
78      *
79      * - `target` must be a contract.
80      * - calling `target` with `data` must not revert.
81      *
82      * _Available since v3.1._
83      */
84     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
85       return functionCall(target, data, "Address: low-level call failed");
86     }
87 
88     /**
89      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
90      * `errorMessage` as a fallback revert reason when `target` reverts.
91      *
92      * _Available since v3.1._
93      */
94     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
95         return functionCallWithValue(target, data, 0, errorMessage);
96     }
97 
98     /**
99      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
100      * but also transferring `value` wei to `target`.
101      *
102      * Requirements:
103      *
104      * - the calling contract must have an ETH balance of at least `value`.
105      * - the called Solidity function must be `payable`.
106      *
107      * _Available since v3.1._
108      */
109     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
110         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
111     }
112 
113     /**
114      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
115      * with `errorMessage` as a fallback revert reason when `target` reverts.
116      *
117      * _Available since v3.1._
118      */
119     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
120         require(address(this).balance >= value, "Address: insufficient balance for call");
121         require(isContract(target), "Address: call to non-contract");
122 
123         // solhint-disable-next-line avoid-low-level-calls
124         (bool success, bytes memory returndata) = target.call{ value: value }(data);
125         return _verifyCallResult(success, returndata, errorMessage);
126     }
127 
128     /**
129      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
130      * but performing a static call.
131      *
132      * _Available since v3.3._
133      */
134     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
135         return functionStaticCall(target, data, "Address: low-level static call failed");
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
140      * but performing a static call.
141      *
142      * _Available since v3.3._
143      */
144     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
145         require(isContract(target), "Address: static call to non-contract");
146 
147         // solhint-disable-next-line avoid-low-level-calls
148         (bool success, bytes memory returndata) = target.staticcall(data);
149         return _verifyCallResult(success, returndata, errorMessage);
150     }
151 
152     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
153         if (success) {
154             return returndata;
155         } else {
156             // Look for revert reason and bubble it up if present
157             if (returndata.length > 0) {
158                 // The easiest way to bubble the revert reason is using memory via assembly
159 
160                 // solhint-disable-next-line no-inline-assembly
161                 assembly {
162                     let returndata_size := mload(returndata)
163                     revert(add(32, returndata), returndata_size)
164                 }
165             } else {
166                 revert(errorMessage);
167             }
168         }
169     }
170 }
171 
172 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/Proxy
173 
174 /**
175  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
176  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
177  * be specified by overriding the virtual {_implementation} function.
178  * 
179  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
180  * different contract through the {_delegate} function.
181  * 
182  * The success and return data of the delegated call will be returned back to the caller of the proxy.
183  */
184 abstract contract Proxy {
185     /**
186      * @dev Delegates the current call to `implementation`.
187      * 
188      * This function does not return to its internall call site, it will return directly to the external caller.
189      */
190     function _delegate(address implementation) internal {
191         // solhint-disable-next-line no-inline-assembly
192         assembly {
193             // Copy msg.data. We take full control of memory in this inline assembly
194             // block because it will not return to Solidity code. We overwrite the
195             // Solidity scratch pad at memory position 0.
196             calldatacopy(0, 0, calldatasize())
197 
198             // Call the implementation.
199             // out and outsize are 0 because we don't know the size yet.
200             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
201 
202             // Copy the returned data.
203             returndatacopy(0, 0, returndatasize())
204 
205             switch result
206             // delegatecall returns 0 on error.
207             case 0 { revert(0, returndatasize()) }
208             default { return(0, returndatasize()) }
209         }
210     }
211 
212     /**
213      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
214      * and {_fallback} should delegate.
215      */
216     function _implementation() internal virtual view returns (address);
217 
218     /**
219      * @dev Delegates the current call to the address returned by `_implementation()`.
220      * 
221      * This function does not return to its internall call site, it will return directly to the external caller.
222      */
223     function _fallback() internal {
224         _beforeFallback();
225         _delegate(_implementation());
226     }
227 
228     /**
229      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
230      * function in the contract matches the call data.
231      */
232     fallback () external payable {
233         _fallback();
234     }
235 
236     /**
237      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
238      * is empty.
239      */
240     receive () external payable {
241         _fallback();
242     }
243 
244     /**
245      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
246      * call, or as part of the Solidity `fallback` or `receive` functions.
247      * 
248      * If overriden should call `super._beforeFallback()`.
249      */
250     function _beforeFallback() internal virtual {
251     }
252 }
253 
254 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/UpgradeableProxy
255 
256 /**
257  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
258  * implementation address that can be changed. This address is stored in storage in the location specified by
259  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
260  * implementation behind the proxy.
261  * 
262  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
263  * {TransparentUpgradeableProxy}.
264  */
265 contract UpgradeableProxy is Proxy {
266     /**
267      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
268      * 
269      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
270      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
271      */
272     constructor(address _logic, bytes memory _data) public payable {
273         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
274         _setImplementation(_logic);
275         if(_data.length > 0) {
276             // solhint-disable-next-line avoid-low-level-calls
277             (bool success,) = _logic.delegatecall(_data);
278             require(success);
279         }
280     }
281 
282     /**
283      * @dev Emitted when the implementation is upgraded.
284      */
285     event Upgraded(address indexed implementation);
286 
287     /**
288      * @dev Storage slot with the address of the current implementation.
289      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
290      * validated in the constructor.
291      */
292     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
293 
294     /**
295      * @dev Returns the current implementation address.
296      */
297     function _implementation() internal override view returns (address impl) {
298         bytes32 slot = _IMPLEMENTATION_SLOT;
299         // solhint-disable-next-line no-inline-assembly
300         assembly {
301             impl := sload(slot)
302         }
303     }
304 
305     /**
306      * @dev Upgrades the proxy to a new implementation.
307      * 
308      * Emits an {Upgraded} event.
309      */
310     function _upgradeTo(address newImplementation) internal {
311         _setImplementation(newImplementation);
312         emit Upgraded(newImplementation);
313     }
314 
315     /**
316      * @dev Stores a new address in the EIP1967 implementation slot.
317      */
318     function _setImplementation(address newImplementation) private {
319         require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
320 
321         bytes32 slot = _IMPLEMENTATION_SLOT;
322 
323         // solhint-disable-next-line no-inline-assembly
324         assembly {
325             sstore(slot, newImplementation)
326         }
327     }
328 }
329 
330 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/TransparentUpgradeableProxy
331 
332 /**
333  * @dev This contract implements a proxy that is upgradeable by an admin.
334  * 
335  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
336  * clashing], which can potentially be used in an attack, this contract uses the
337  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
338  * things that go hand in hand:
339  * 
340  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
341  * that call matches one of the admin functions exposed by the proxy itself.
342  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
343  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
344  * "admin cannot fallback to proxy target".
345  * 
346  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
347  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
348  * to sudden errors when trying to call a function from the proxy implementation.
349  * 
350  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
351  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
352  */
353 contract TransparentUpgradeableProxy is UpgradeableProxy {
354     /**
355      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
356      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
357      */
358     constructor(address _logic, address admin_, bytes memory _data) public payable UpgradeableProxy(_logic, _data) {
359         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
360         _setAdmin(admin_);
361     }
362 
363     /**
364      * @dev Emitted when the admin account has changed.
365      */
366     event AdminChanged(address previousAdmin, address newAdmin);
367 
368     /**
369      * @dev Storage slot with the admin of the contract.
370      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
371      * validated in the constructor.
372      */
373     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
374 
375     /**
376      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
377      */
378     modifier ifAdmin() {
379         if (msg.sender == _admin()) {
380             _;
381         } else {
382             _fallback();
383         }
384     }
385 
386     /**
387      * @dev Returns the current admin.
388      * 
389      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
390      * 
391      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
392      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
393      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
394      */
395     function admin() external ifAdmin returns (address admin_) {
396         admin_ = _admin();
397     }
398 
399     /**
400      * @dev Returns the current implementation.
401      * 
402      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
403      * 
404      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
405      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
406      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
407      */
408     function implementation() external ifAdmin returns (address implementation_) {
409         implementation_ = _implementation();
410     }
411 
412     /**
413      * @dev Changes the admin of the proxy.
414      * 
415      * Emits an {AdminChanged} event.
416      * 
417      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
418      */
419     function changeAdmin(address newAdmin) external ifAdmin {
420         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
421         emit AdminChanged(_admin(), newAdmin);
422         _setAdmin(newAdmin);
423     }
424 
425     /**
426      * @dev Upgrade the implementation of the proxy.
427      * 
428      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
429      */
430     function upgradeTo(address newImplementation) external ifAdmin {
431         _upgradeTo(newImplementation);
432     }
433 
434     /**
435      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
436      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
437      * proxied contract.
438      * 
439      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
440      */
441     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
442         _upgradeTo(newImplementation);
443         // solhint-disable-next-line avoid-low-level-calls
444         (bool success,) = newImplementation.delegatecall(data);
445         require(success);
446     }
447 
448     /**
449      * @dev Returns the current admin.
450      */
451     function _admin() internal view returns (address adm) {
452         bytes32 slot = _ADMIN_SLOT;
453         // solhint-disable-next-line no-inline-assembly
454         assembly {
455             adm := sload(slot)
456         }
457     }
458 
459     /**
460      * @dev Stores a new address in the EIP1967 admin slot.
461      */
462     function _setAdmin(address newAdmin) private {
463         bytes32 slot = _ADMIN_SLOT;
464 
465         // solhint-disable-next-line no-inline-assembly
466         assembly {
467             sstore(slot, newAdmin)
468         }
469     }
470 
471     /**
472      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
473      */
474     function _beforeFallback() internal override virtual {
475         require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
476         super._beforeFallback();
477     }
478 }
479 
480 // File: UtilProxy.sol
481 
482 contract UtilProxy is TransparentUpgradeableProxy {
483   constructor(address _logic, address admin_, bytes memory _data)
484       public 
485       TransparentUpgradeableProxy(_logic, admin_, _data)
486   {}
487 }