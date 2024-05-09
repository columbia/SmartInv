1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.8;
4 
5 
6 // 
7 /**
8  * @title Proxy
9  * @dev Implements delegation of calls to other contracts, with proper
10  * forwarding of return values and bubbling of failures.
11  * It defines a fallback function that delegates all calls to the address
12  * returned by the abstract _implementation() internal function.
13  */
14 abstract contract Proxy {
15   /**
16    * @dev Fallback function.
17    * Implemented entirely in `_fallback`.
18    */
19   fallback () payable external {
20     _fallback();
21   }
22 
23   /**
24    * @dev Receive function.
25    * Implemented entirely in `_fallback`.
26    */
27   receive () payable external {
28     // _fallback();
29   }
30 
31   /**
32    * @return The Address of the implementation.
33    */
34   function _implementation() internal virtual view returns (address);
35 
36   /**
37    * @dev Delegates execution to an implementation contract.
38    * This is a low level function that doesn't return to its internal call site.
39    * It will return to the external caller whatever the implementation returns.
40    * @param implementation Address to delegate.
41    */
42   function _delegate(address implementation) internal {
43     assembly {
44       // Copy msg.data. We take full control of memory in this inline assembly
45       // block because it will not return to Solidity code. We overwrite the
46       // Solidity scratch pad at memory position 0.
47       calldatacopy(0, 0, calldatasize())
48 
49       // Call the implementation.
50       // out and outsize are 0 because we don't know the size yet.
51       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
52 
53       // Copy the returned data.
54       returndatacopy(0, 0, returndatasize())
55 
56       switch result
57       // delegatecall returns 0 on error.
58       case 0 { revert(0, returndatasize()) }
59       default { return(0, returndatasize()) }
60     }
61   }
62 
63   /**
64    * @dev Function that is run as the first thing in the fallback function.
65    * Can be redefined in derived contracts to add functionality.
66    * Redefinitions must call super._willFallback().
67    */
68   function _willFallback() internal virtual {
69   }
70 
71   /**
72    * @dev fallback implementation.
73    * Extracted to enable manual triggering.
74    */
75   function _fallback() internal {
76     _willFallback();
77     _delegate(_implementation());
78   }
79 }
80 
81 // 
82 /**
83  * @dev Collection of functions related to the address type
84  */
85 library Address {
86     /**
87      * @dev Returns true if `account` is a contract.
88      *
89      * [IMPORTANT]
90      * ====
91      * It is unsafe to assume that an address for which this function returns
92      * false is an externally-owned account (EOA) and not a contract.
93      *
94      * Among others, `isContract` will return false for the following
95      * types of addresses:
96      *
97      *  - an externally-owned account
98      *  - a contract in construction
99      *  - an address where a contract will be created
100      *  - an address where a contract lived, but was destroyed
101      * ====
102      */
103     function isContract(address account) internal view returns (bool) {
104         // This method relies on extcodesize, which returns 0 for contracts in
105         // construction, since the code is only stored at the end of the
106         // constructor execution.
107 
108         uint256 size;
109         // solhint-disable-next-line no-inline-assembly
110         assembly { size := extcodesize(account) }
111         return size > 0;
112     }
113 
114     /**
115      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
116      * `recipient`, forwarding all available gas and reverting on errors.
117      *
118      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
119      * of certain opcodes, possibly making contracts go over the 2300 gas limit
120      * imposed by `transfer`, making them unable to receive funds via
121      * `transfer`. {sendValue} removes this limitation.
122      *
123      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
124      *
125      * IMPORTANT: because control is transferred to `recipient`, care must be
126      * taken to not create reentrancy vulnerabilities. Consider using
127      * {ReentrancyGuard} or the
128      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
129      */
130     function sendValue(address payable recipient, uint256 amount) internal {
131         require(address(this).balance >= amount, "Address: insufficient balance");
132 
133         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
134         (bool success, ) = recipient.call{ value: amount }("");
135         require(success, "Address: unable to send value, recipient may have reverted");
136     }
137 
138     /**
139      * @dev Performs a Solidity function call using a low level `call`. A
140      * plain`call` is an unsafe replacement for a function call: use this
141      * function instead.
142      *
143      * If `target` reverts with a revert reason, it is bubbled up by this
144      * function (like regular Solidity function calls).
145      *
146      * Returns the raw returned data. To convert to the expected return value,
147      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
148      *
149      * Requirements:
150      *
151      * - `target` must be a contract.
152      * - calling `target` with `data` must not revert.
153      *
154      * _Available since v3.1._
155      */
156     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
157       return functionCall(target, data, "Address: low-level call failed");
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
162      * `errorMessage` as a fallback revert reason when `target` reverts.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
167         return functionCallWithValue(target, data, 0, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but also transferring `value` wei to `target`.
173      *
174      * Requirements:
175      *
176      * - the calling contract must have an ETH balance of at least `value`.
177      * - the called Solidity function must be `payable`.
178      *
179      * _Available since v3.1._
180      */
181     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
182         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
187      * with `errorMessage` as a fallback revert reason when `target` reverts.
188      *
189      * _Available since v3.1._
190      */
191     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
192         require(address(this).balance >= value, "Address: insufficient balance for call");
193         require(isContract(target), "Address: call to non-contract");
194 
195         // solhint-disable-next-line avoid-low-level-calls
196         (bool success, bytes memory returndata) = target.call{ value: value }(data);
197         return _verifyCallResult(success, returndata, errorMessage);
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
202      * but performing a static call.
203      *
204      * _Available since v3.3._
205      */
206     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
207         return functionStaticCall(target, data, "Address: low-level static call failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
212      * but performing a static call.
213      *
214      * _Available since v3.3._
215      */
216     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
217         require(isContract(target), "Address: static call to non-contract");
218 
219         // solhint-disable-next-line avoid-low-level-calls
220         (bool success, bytes memory returndata) = target.staticcall(data);
221         return _verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but performing a delegate call.
227      *
228      * _Available since v3.4._
229      */
230     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
231         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
236      * but performing a delegate call.
237      *
238      * _Available since v3.4._
239      */
240     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
241         require(isContract(target), "Address: delegate call to non-contract");
242 
243         // solhint-disable-next-line avoid-low-level-calls
244         (bool success, bytes memory returndata) = target.delegatecall(data);
245         return _verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
249         if (success) {
250             return returndata;
251         } else {
252             // Look for revert reason and bubble it up if present
253             if (returndata.length > 0) {
254                 // The easiest way to bubble the revert reason is using memory via assembly
255 
256                 // solhint-disable-next-line no-inline-assembly
257                 assembly {
258                     let returndata_size := mload(returndata)
259                     revert(add(32, returndata), returndata_size)
260                 }
261             } else {
262                 revert(errorMessage);
263             }
264         }
265     }
266 }
267 
268 // 
269 /**
270  * @title UpgradeabilityProxy
271  * @dev This contract implements a proxy that allows to change the
272  * implementation address to which it will delegate.
273  * Such a change is called an implementation upgrade.
274  */
275 contract UpgradeabilityProxy is Proxy {
276   /**
277    * @dev Contract constructor.
278    * @param _logic Address of the initial implementation.
279    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
280    * It should include the signature and the parameters of the function to be called, as described in
281    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
282    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
283    */
284   constructor(address _logic, bytes memory _data) payable {
285     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
286     _setImplementation(_logic);
287     if(_data.length > 0) {
288       (bool success,) = _logic.delegatecall(_data);
289       require(success);
290     }
291   }  
292 
293   /**
294    * @dev Emitted when the implementation is upgraded.
295    * @param implementation Address of the new implementation.
296    */
297   event Upgraded(address indexed implementation);
298 
299   /**
300    * @dev Storage slot with the address of the current implementation.
301    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
302    * validated in the constructor.
303    */
304   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
305 
306   /**
307    * @dev Returns the current implementation.
308    * @return impl Address of the current implementation
309    */
310   function _implementation() internal override view returns (address impl) {
311     bytes32 slot = IMPLEMENTATION_SLOT;
312     assembly {
313       impl := sload(slot)
314     }
315   }
316 
317   /**
318    * @dev Upgrades the proxy to a new implementation.
319    * @param newImplementation Address of the new implementation.
320    */
321   function _upgradeTo(address newImplementation) internal {
322     _setImplementation(newImplementation);
323     emit Upgraded(newImplementation);
324   }
325 
326   /**
327    * @dev Sets the implementation address of the proxy.
328    * @param newImplementation Address of the new implementation.
329    */
330   function _setImplementation(address newImplementation) internal {
331     require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
332 
333     bytes32 slot = IMPLEMENTATION_SLOT;
334 
335     assembly {
336       sstore(slot, newImplementation)
337     }
338   }
339 }
340 
341 // 
342 /**
343  * @title AdminUpgradeabilityProxy
344  * @dev This contract combines an upgradeability proxy with an authorization
345  * mechanism for administrative tasks.
346  * All external functions in this contract must be guarded by the
347  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
348  * feature proposal that would enable this to be done automatically.
349  */
350 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
351   /**
352    * Contract constructor.
353    * @param _logic address of the initial implementation.
354    * @param _admin Address of the proxy administrator.
355    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
356    * It should include the signature and the parameters of the function to be called, as described in
357    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
358    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
359    */
360   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) payable {
361     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
362     _setAdmin(_admin);
363   }
364 
365   /**
366    * @dev Emitted when the administration has been transferred.
367    * @param previousAdmin Address of the previous admin.
368    * @param newAdmin Address of the new admin.
369    */
370   event AdminChanged(address previousAdmin, address newAdmin);
371 
372   /**
373    * @dev Storage slot with the admin of the contract.
374    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
375    * validated in the constructor.
376    */
377 
378   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
379 
380   /**
381    * @dev Modifier to check whether the `msg.sender` is the admin.
382    * If it is, it will run the function. Otherwise, it will delegate the call
383    * to the implementation.
384    */
385   modifier ifAdmin() {
386     if (msg.sender == _admin()) {
387       _;
388     } else {
389       _fallback();
390     }
391   }
392 
393   /**
394    * @return The address of the proxy admin.
395    */
396   function admin() external ifAdmin returns (address) {
397     return _admin();
398   }
399 
400   /**
401    * @return The address of the implementation.
402    */
403   function implementation() external ifAdmin returns (address) {
404     return _implementation();
405   }
406 
407   /**
408    * @dev Changes the admin of the proxy.
409    * Only the current admin can call this function.
410    * @param newAdmin Address to transfer proxy administration to.
411    */
412   function changeAdmin(address newAdmin) external ifAdmin {
413     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
414     emit AdminChanged(_admin(), newAdmin);
415     _setAdmin(newAdmin);
416   }
417 
418   /**
419    * @dev Upgrade the backing implementation of the proxy.
420    * Only the admin can call this function.
421    * @param newImplementation Address of the new implementation.
422    */
423   function upgradeTo(address newImplementation) external ifAdmin {
424     _upgradeTo(newImplementation);
425   }
426 
427   /**
428    * @dev Upgrade the backing implementation of the proxy and call a function
429    * on the new implementation.
430    * This is useful to initialize the proxied contract.
431    * @param newImplementation Address of the new implementation.
432    * @param data Data to send as msg.data in the low level call.
433    * It should include the signature and the parameters of the function to be called, as described in
434    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
435    */
436   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
437     _upgradeTo(newImplementation);
438     (bool success,) = newImplementation.delegatecall(data);
439     require(success);
440   }
441 
442   /**
443    * @return adm The admin slot.
444    */
445   function _admin() internal view returns (address adm) {
446     bytes32 slot = ADMIN_SLOT;
447     assembly {
448       adm := sload(slot)
449     }
450   }
451 
452   /**
453    * @dev Sets the address of the proxy admin.
454    * @param newAdmin Address of the new proxy admin.
455    */
456   function _setAdmin(address newAdmin) internal {
457     bytes32 slot = ADMIN_SLOT;
458 
459     assembly {
460       sstore(slot, newAdmin)
461     }
462   }
463 
464   /**
465    * @dev Only fall back when the sender is not the admin.
466    */
467   function _willFallback() internal override virtual {
468     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
469     super._willFallback();
470   }
471 }