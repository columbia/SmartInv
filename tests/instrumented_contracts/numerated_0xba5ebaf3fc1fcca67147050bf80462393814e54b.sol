1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies in extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return _functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         return _functionCallWithValue(target, data, value, errorMessage);
121     }
122 
123     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
124         require(isContract(target), "Address: call to non-contract");
125 
126         // solhint-disable-next-line avoid-low-level-calls
127         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
128         if (success) {
129             return returndata;
130         } else {
131             // Look for revert reason and bubble it up if present
132             if (returndata.length > 0) {
133                 // The easiest way to bubble the revert reason is using memory via assembly
134 
135                 // solhint-disable-next-line no-inline-assembly
136                 assembly {
137                     let returndata_size := mload(returndata)
138                     revert(add(32, returndata), returndata_size)
139                 }
140             } else {
141                 revert(errorMessage);
142             }
143         }
144     }
145 }
146 
147 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Proxy
148 
149 /**
150  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
151  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
152  * be specified by overriding the virtual {_implementation} function.
153  * 
154  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
155  * different contract through the {_delegate} function.
156  * 
157  * The success and return data of the delegated call will be returned back to the caller of the proxy.
158  */
159 abstract contract Proxy {
160     /**
161      * @dev Delegates the current call to `implementation`.
162      * 
163      * This function does not return to its internall call site, it will return directly to the external caller.
164      */
165     function _delegate(address implementation) internal {
166         // solhint-disable-next-line no-inline-assembly
167         assembly {
168             // Copy msg.data. We take full control of memory in this inline assembly
169             // block because it will not return to Solidity code. We overwrite the
170             // Solidity scratch pad at memory position 0.
171             calldatacopy(0, 0, calldatasize())
172 
173             // Call the implementation.
174             // out and outsize are 0 because we don't know the size yet.
175             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
176 
177             // Copy the returned data.
178             returndatacopy(0, 0, returndatasize())
179 
180             switch result
181             // delegatecall returns 0 on error.
182             case 0 { revert(0, returndatasize()) }
183             default { return(0, returndatasize()) }
184         }
185     }
186 
187     /**
188      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
189      * and {_fallback} should delegate.
190      */
191     function _implementation() internal virtual view returns (address);
192 
193     /**
194      * @dev Delegates the current call to the address returned by `_implementation()`.
195      * 
196      * This function does not return to its internall call site, it will return directly to the external caller.
197      */
198     function _fallback() internal {
199         _beforeFallback();
200         _delegate(_implementation());
201     }
202 
203     /**
204      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
205      * function in the contract matches the call data.
206      */
207     fallback () payable external {
208         _fallback();
209     }
210 
211     /**
212      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
213      * is empty.
214      */
215     receive () payable external {
216         _fallback();
217     }
218 
219     /**
220      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
221      * call, or as part of the Solidity `fallback` or `receive` functions.
222      * 
223      * If overriden should call `super._beforeFallback()`.
224      */
225     function _beforeFallback() internal virtual {
226     }
227 }
228 
229 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/UpgradeableProxy
230 
231 /**
232  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
233  * implementation address that can be changed. This address is stored in storage in the location specified by
234  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
235  * implementation behind the proxy.
236  * 
237  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
238  * {TransparentUpgradeableProxy}.
239  */
240 contract UpgradeableProxy is Proxy {
241     /**
242      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
243      * 
244      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
245      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
246      */
247     constructor(address _logic, bytes memory _data) public payable {
248         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
249         _setImplementation(_logic);
250         if(_data.length > 0) {
251             // solhint-disable-next-line avoid-low-level-calls
252             (bool success,) = _logic.delegatecall(_data);
253             require(success);
254         }
255     }
256 
257     /**
258      * @dev Emitted when the implementation is upgraded.
259      */
260     event Upgraded(address indexed implementation);
261 
262     /**
263      * @dev Storage slot with the address of the current implementation.
264      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
265      * validated in the constructor.
266      */
267     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
268 
269     /**
270      * @dev Returns the current implementation address.
271      */
272     function _implementation() internal override view returns (address impl) {
273         bytes32 slot = _IMPLEMENTATION_SLOT;
274         // solhint-disable-next-line no-inline-assembly
275         assembly {
276             impl := sload(slot)
277         }
278     }
279 
280     /**
281      * @dev Upgrades the proxy to a new implementation.
282      * 
283      * Emits an {Upgraded} event.
284      */
285     function _upgradeTo(address newImplementation) internal {
286         _setImplementation(newImplementation);
287         emit Upgraded(newImplementation);
288     }
289 
290     /**
291      * @dev Stores a new address in the EIP1967 implementation slot.
292      */
293     function _setImplementation(address newImplementation) private {
294         require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
295 
296         bytes32 slot = _IMPLEMENTATION_SLOT;
297 
298         // solhint-disable-next-line no-inline-assembly
299         assembly {
300             sstore(slot, newImplementation)
301         }
302     }
303 }
304 
305 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/TransparentUpgradeableProxy
306 
307 /**
308  * @dev This contract implements a proxy that is upgradeable by an admin.
309  * 
310  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
311  * clashing], which can potentially be used in an attack, this contract uses the
312  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
313  * things that go hand in hand:
314  * 
315  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
316  * that call matches one of the admin functions exposed by the proxy itself.
317  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
318  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
319  * "admin cannot fallback to proxy target".
320  * 
321  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
322  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
323  * to sudden errors when trying to call a function from the proxy implementation.
324  * 
325  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
326  * you should think of the `ProxyAdmin` instance as the real administrative inerface of your proxy.
327  */
328 contract TransparentUpgradeableProxy is UpgradeableProxy {
329     /**
330      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
331      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
332      */
333     constructor(address _logic, address _admin, bytes memory _data) public payable UpgradeableProxy(_logic, _data) {
334         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
335         _setAdmin(_admin);
336     }
337 
338     /**
339      * @dev Emitted when the admin account has changed.
340      */
341     event AdminChanged(address previousAdmin, address newAdmin);
342 
343     /**
344      * @dev Storage slot with the admin of the contract.
345      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
346      * validated in the constructor.
347      */
348     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
349 
350     /**
351      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
352      */
353     modifier ifAdmin() {
354         if (msg.sender == _admin()) {
355             _;
356         } else {
357             _fallback();
358         }
359     }
360 
361     /**
362      * @dev Returns the current admin.
363      * 
364      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
365      * 
366      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
367      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
368      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
369      */
370     function admin() external ifAdmin returns (address) {
371         return _admin();
372     }
373 
374     /**
375      * @dev Returns the current implementation.
376      * 
377      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
378      * 
379      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
380      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
381      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
382      */
383     function implementation() external ifAdmin returns (address) {
384         return _implementation();
385     }
386 
387     /**
388      * @dev Changes the admin of the proxy.
389      * 
390      * Emits an {AdminChanged} event.
391      * 
392      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
393      */
394     function changeAdmin(address newAdmin) external ifAdmin {
395         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
396         emit AdminChanged(_admin(), newAdmin);
397         _setAdmin(newAdmin);
398     }
399 
400     /**
401      * @dev Upgrade the implementation of the proxy.
402      * 
403      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
404      */
405     function upgradeTo(address newImplementation) external ifAdmin {
406         _upgradeTo(newImplementation);
407     }
408 
409     /**
410      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
411      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
412      * proxied contract.
413      * 
414      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
415      */
416     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
417         _upgradeTo(newImplementation);
418         // solhint-disable-next-line avoid-low-level-calls
419         (bool success,) = newImplementation.delegatecall(data);
420         require(success);
421     }
422 
423     /**
424      * @dev Returns the current admin.
425      */
426     function _admin() internal view returns (address adm) {
427         bytes32 slot = _ADMIN_SLOT;
428         // solhint-disable-next-line no-inline-assembly
429         assembly {
430             adm := sload(slot)
431         }
432     }
433 
434     /**
435      * @dev Stores a new address in the EIP1967 admin slot.
436      */
437     function _setAdmin(address newAdmin) private {
438         bytes32 slot = _ADMIN_SLOT;
439 
440         // solhint-disable-next-line no-inline-assembly
441         assembly {
442             sstore(slot, newAdmin)
443         }
444     }
445 
446     /**
447      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
448      */
449     function _beforeFallback() internal override virtual {
450         require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
451         super._beforeFallback();
452     }
453 }
454 
455 // File: TransparentUpgradeableProxyImpl.sol
456 
457 contract TransparentUpgradeableProxyImpl is TransparentUpgradeableProxy {
458   constructor(
459     address _logic,
460     address _admin,
461     bytes memory _data
462   ) public payable TransparentUpgradeableProxy(_logic, _admin, _data) {}
463 }
