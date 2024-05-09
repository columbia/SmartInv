1 // SPDX-License-Identifier: No License (None)
2 
3 // File: openzeppelin-solidity/contracts/proxy/Proxy.sol
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
8  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
9  * be specified by overriding the virtual {_implementation} function.
10  * 
11  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
12  * different contract through the {_delegate} function.
13  * 
14  * The success and return data of the delegated call will be returned back to the caller of the proxy.
15  */
16 abstract contract Proxy {
17     /**
18      * @dev Delegates the current call to `implementation`.
19      * 
20      * This function does not return to its internall call site, it will return directly to the external caller.
21      */
22     function _delegate(address implementation) internal {
23         // solhint-disable-next-line no-inline-assembly
24         assembly {
25             // Copy msg.data. We take full control of memory in this inline assembly
26             // block because it will not return to Solidity code. We overwrite the
27             // Solidity scratch pad at memory position 0.
28             calldatacopy(0, 0, calldatasize())
29 
30             // Call the implementation.
31             // out and outsize are 0 because we don't know the size yet.
32             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
33 
34             // Copy the returned data.
35             returndatacopy(0, 0, returndatasize())
36 
37             switch result
38             // delegatecall returns 0 on error.
39             case 0 { revert(0, returndatasize()) }
40             default { return(0, returndatasize()) }
41         }
42     }
43 
44     /**
45      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
46      * and {_fallback} should delegate.
47      */
48     function _implementation() internal virtual view returns (address);
49 
50     /**
51      * @dev Delegates the current call to the address returned by `_implementation()`.
52      * 
53      * This function does not return to its internall call site, it will return directly to the external caller.
54      */
55     function _fallback() internal {
56         _beforeFallback();
57         _delegate(_implementation());
58     }
59 
60     /**
61      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
62      * function in the contract matches the call data.
63      */
64     fallback () external payable {
65         _fallback();
66     }
67 
68     /**
69      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
70      * is empty.
71      */
72     receive () external payable {
73         _fallback();
74     }
75 
76     /**
77      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
78      * call, or as part of the Solidity `fallback` or `receive` functions.
79      * 
80      * If overriden should call `super._beforeFallback()`.
81      */
82     function _beforeFallback() internal virtual {
83     }
84 }
85 
86 // File: openzeppelin-solidity/contracts/utils/Address.sol
87 
88 /**
89  * @dev Collection of functions related to the address type
90  */
91 library Address {
92     /**
93      * @dev Returns true if `account` is a contract.
94      *
95      * [IMPORTANT]
96      * ====
97      * It is unsafe to assume that an address for which this function returns
98      * false is an externally-owned account (EOA) and not a contract.
99      *
100      * Among others, `isContract` will return false for the following
101      * types of addresses:
102      *
103      *  - an externally-owned account
104      *  - a contract in construction
105      *  - an address where a contract will be created
106      *  - an address where a contract lived, but was destroyed
107      * ====
108      */
109     function isContract(address account) internal view returns (bool) {
110         // This method relies on extcodesize, which returns 0 for contracts in
111         // construction, since the code is only stored at the end of the
112         // constructor execution.
113 
114         uint256 size;
115         // solhint-disable-next-line no-inline-assembly
116         assembly { size := extcodesize(account) }
117         return size > 0;
118     }
119 
120     /**
121      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
122      * `recipient`, forwarding all available gas and reverting on errors.
123      *
124      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
125      * of certain opcodes, possibly making contracts go over the 2300 gas limit
126      * imposed by `transfer`, making them unable to receive funds via
127      * `transfer`. {sendValue} removes this limitation.
128      *
129      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
130      *
131      * IMPORTANT: because control is transferred to `recipient`, care must be
132      * taken to not create reentrancy vulnerabilities. Consider using
133      * {ReentrancyGuard} or the
134      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
135      */
136     function sendValue(address payable recipient, uint256 amount) internal {
137         require(address(this).balance >= amount, "Address: insufficient balance");
138 
139         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
140         (bool success, ) = recipient.call{ value: amount }("");
141         require(success, "Address: unable to send value, recipient may have reverted");
142     }
143 
144     /**
145      * @dev Performs a Solidity function call using a low level `call`. A
146      * plain`call` is an unsafe replacement for a function call: use this
147      * function instead.
148      *
149      * If `target` reverts with a revert reason, it is bubbled up by this
150      * function (like regular Solidity function calls).
151      *
152      * Returns the raw returned data. To convert to the expected return value,
153      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
154      *
155      * Requirements:
156      *
157      * - `target` must be a contract.
158      * - calling `target` with `data` must not revert.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
163       return functionCall(target, data, "Address: low-level call failed");
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
168      * `errorMessage` as a fallback revert reason when `target` reverts.
169      *
170      * _Available since v3.1._
171      */
172     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
173         return functionCallWithValue(target, data, 0, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but also transferring `value` wei to `target`.
179      *
180      * Requirements:
181      *
182      * - the calling contract must have an ETH balance of at least `value`.
183      * - the called Solidity function must be `payable`.
184      *
185      * _Available since v3.1._
186      */
187     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
193      * with `errorMessage` as a fallback revert reason when `target` reverts.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
198         require(address(this).balance >= value, "Address: insufficient balance for call");
199         require(isContract(target), "Address: call to non-contract");
200 
201         // solhint-disable-next-line avoid-low-level-calls
202         (bool success, bytes memory returndata) = target.call{ value: value }(data);
203         return _verifyCallResult(success, returndata, errorMessage);
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
208      * but performing a static call.
209      *
210      * _Available since v3.3._
211      */
212     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
213         return functionStaticCall(target, data, "Address: low-level static call failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
218      * but performing a static call.
219      *
220      * _Available since v3.3._
221      */
222     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
223         require(isContract(target), "Address: static call to non-contract");
224 
225         // solhint-disable-next-line avoid-low-level-calls
226         (bool success, bytes memory returndata) = target.staticcall(data);
227         return _verifyCallResult(success, returndata, errorMessage);
228     }
229 
230     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
231         if (success) {
232             return returndata;
233         } else {
234             // Look for revert reason and bubble it up if present
235             if (returndata.length > 0) {
236                 // The easiest way to bubble the revert reason is using memory via assembly
237 
238                 // solhint-disable-next-line no-inline-assembly
239                 assembly {
240                     let returndata_size := mload(returndata)
241                     revert(add(32, returndata), returndata_size)
242                 }
243             } else {
244                 revert(errorMessage);
245             }
246         }
247     }
248 }
249 
250 // File: openzeppelin-solidity/contracts/proxy/UpgradeableProxy.sol
251 
252 /**
253  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
254  * implementation address that can be changed. This address is stored in storage in the location specified by
255  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
256  * implementation behind the proxy.
257  * 
258  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
259  * {TransparentUpgradeableProxy}.
260  */
261 contract UpgradeableProxy is Proxy {
262     /**
263      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
264      * 
265      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
266      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
267      */
268     constructor(address _logic, bytes memory _data) payable {
269         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
270         _setImplementation(_logic);
271         if(_data.length > 0) {
272             // solhint-disable-next-line avoid-low-level-calls
273             (bool success,) = _logic.delegatecall(_data);
274             require(success);
275         }
276     }
277 
278     /**
279      * @dev Emitted when the implementation is upgraded.
280      */
281     event Upgraded(address indexed implementation);
282 
283     /**
284      * @dev Storage slot with the address of the current implementation.
285      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
286      * validated in the constructor.
287      */
288     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
289 
290     /**
291      * @dev Returns the current implementation address.
292      */
293     function _implementation() internal override view returns (address impl) {
294         bytes32 slot = _IMPLEMENTATION_SLOT;
295         // solhint-disable-next-line no-inline-assembly
296         assembly {
297             impl := sload(slot)
298         }
299     }
300 
301     /**
302      * @dev Upgrades the proxy to a new implementation.
303      * 
304      * Emits an {Upgraded} event.
305      */
306     function _upgradeTo(address newImplementation) internal {
307         _setImplementation(newImplementation);
308         emit Upgraded(newImplementation);
309     }
310 
311     /**
312      * @dev Stores a new address in the EIP1967 implementation slot.
313      */
314     function _setImplementation(address newImplementation) private {
315         require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
316 
317         bytes32 slot = _IMPLEMENTATION_SLOT;
318 
319         // solhint-disable-next-line no-inline-assembly
320         assembly {
321             sstore(slot, newImplementation)
322         }
323     }
324 }
325 
326 // File: openzeppelin-solidity/contracts/proxy/TransparentUpgradeableProxy.sol
327 
328 
329 /**
330  * @dev This contract implements a proxy that is upgradeable by an admin.
331  * 
332  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
333  * clashing], which can potentially be used in an attack, this contract uses the
334  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
335  * things that go hand in hand:
336  * 
337  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
338  * that call matches one of the admin functions exposed by the proxy itself.
339  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
340  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
341  * "admin cannot fallback to proxy target".
342  * 
343  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
344  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
345  * to sudden errors when trying to call a function from the proxy implementation.
346  * 
347  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
348  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
349  */
350 contract TransparentUpgradeableProxy is UpgradeableProxy {
351     /**
352      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
353      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
354      */
355     constructor(address _logic, address admin_, bytes memory _data) payable UpgradeableProxy(_logic, _data) {
356         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
357         _setAdmin(admin_);
358     }
359 
360     /**
361      * @dev Emitted when the admin account has changed.
362      */
363     event AdminChanged(address previousAdmin, address newAdmin);
364 
365     /**
366      * @dev Storage slot with the admin of the contract.
367      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
368      * validated in the constructor.
369      */
370     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
371 
372     /**
373      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
374      */
375     modifier ifAdmin() {
376         if (msg.sender == _admin()) {
377             _;
378         } else {
379             _fallback();
380         }
381     }
382 
383     /**
384      * @dev Returns the current admin.
385      * 
386      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
387      * 
388      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
389      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
390      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
391      */
392     function admin() external view returns (address admin_) {
393         admin_ = _admin();
394     }
395 
396     /**
397      * @dev Returns the current implementation.
398      * 
399      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
400      * 
401      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
402      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
403      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
404      */
405     function implementation() external view returns (address implementation_) {
406         implementation_ = _implementation();
407     }
408 
409     /**
410      * @dev Changes the admin of the proxy.
411      * 
412      * Emits an {AdminChanged} event.
413      * 
414      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
415      */
416     function changeAdmin(address newAdmin) external ifAdmin {
417         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
418         emit AdminChanged(_admin(), newAdmin);
419         _setAdmin(newAdmin);
420     }
421 
422     /**
423      * @dev Upgrade the implementation of the proxy.
424      * 
425      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
426      */
427     function upgrade() external ifAdmin {
428         address newImplementation = IBridge(address(this)).upgradeTo();
429         _upgradeTo(newImplementation);
430     }
431 
432     /**
433      * @dev Returns the current admin.
434      */
435     function _admin() internal view returns (address adm) {
436         bytes32 slot = _ADMIN_SLOT;
437         // solhint-disable-next-line no-inline-assembly
438         assembly {
439             adm := sload(slot)
440         }
441     }
442 
443     /**
444      * @dev Stores a new address in the EIP1967 admin slot.
445      */
446     function _setAdmin(address newAdmin) private {
447         bytes32 slot = _ADMIN_SLOT;
448 
449         // solhint-disable-next-line no-inline-assembly
450         assembly {
451             sstore(slot, newAdmin)
452         }
453     }
454 }
455 
456 interface IBridge {
457     function upgradeTo() external view returns(address);
458 }
459 
460 // initialize() = 0x8129fc1c
461 contract BridgeUpgradeableProxy is TransparentUpgradeableProxy {
462 
463     constructor(address logic, address admin, bytes memory data) TransparentUpgradeableProxy(logic, admin, data) {
464 
465     }
466 }