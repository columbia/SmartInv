1 /**
2  *Submitted for verification at BscScan.com on 2021-06-04
3 */
4 
5 // Root file: contracts/library/AdminUpgradeabilityProxy.sol
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity ^0.6.0;
9 
10 /**
11  * @title Proxy
12  * @dev Implements delegation of calls to other contracts, with proper
13  * forwarding of return values and bubbling of failures.
14  * It defines a fallback function that delegates all calls to the address
15  * returned by the abstract _implementation() internal function.
16  */
17 abstract contract Proxy {
18     /**
19      * @dev Fallback function.
20      * Implemented entirely in `_fallback`.
21      */
22     fallback () payable external {
23         _fallback();
24     }
25 
26     /**
27      * @dev Receive function.
28      * Implemented entirely in `_fallback`.
29      */
30     receive () payable external {
31         _fallback();
32     }
33 
34     /**
35      * @return The Address of the implementation.
36      */
37     function _implementation() internal virtual view returns (address);
38 
39     /**
40      * @dev Delegates execution to an implementation contract.
41      * This is a low level function that doesn't return to its internal call site.
42      * It will return to the external caller whatever the implementation returns.
43      * @param implementation Address to delegate.
44      */
45     function _delegate(address implementation) internal {
46         assembly {
47         // Copy msg.data. We take full control of memory in this inline assembly
48         // block because it will not return to Solidity code. We overwrite the
49         // Solidity scratch pad at memory position 0.
50             calldatacopy(0, 0, calldatasize())
51 
52         // Call the implementation.
53         // out and outsize are 0 because we don't know the size yet.
54             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
55 
56         // Copy the returned data.
57             returndatacopy(0, 0, returndatasize())
58 
59             switch result
60             // delegatecall returns 0 on error.
61             case 0 { revert(0, returndatasize()) }
62             default { return(0, returndatasize()) }
63         }
64     }
65 
66     /**
67      * @dev Function that is run as the first thing in the fallback function.
68      * Can be redefined in derived contracts to add functionality.
69      * Redefinitions must call super._willFallback().
70      */
71     function _willFallback() internal virtual {
72     }
73 
74     /**
75      * @dev fallback implementation.
76      * Extracted to enable manual triggering.
77      */
78     function _fallback() internal {
79         _willFallback();
80         _delegate(_implementation());
81     }
82 }
83 
84 // File: @openzeppelin/contracts/utils/Address.sol
85 
86 pragma solidity >=0.6.2 <0.8.0;
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
163         return functionCall(target, data, "Address: low-level call failed");
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
250 // File: MasterChef/contracts-proxy/UpgradeabilityProxy.sol
251 
252 pragma solidity ^0.6.0;
253 
254 
255 
256 /**
257  * @title UpgradeabilityProxy
258  * @dev This contract implements a proxy that allows to change the
259  * implementation address to which it will delegate.
260  * Such a change is called an implementation upgrade.
261  */
262 contract UpgradeabilityProxy is Proxy {
263     /**
264      * @dev Contract constructor.
265      * @param _logic Address of the initial implementation.
266      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
267      * It should include the signature and the parameters of the function to be called, as described in
268      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
269      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
270      */
271     constructor(address _logic, bytes memory _data) public payable {
272         assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
273         _setImplementation(_logic);
274         if(_data.length > 0) {
275             (bool success,) = _logic.delegatecall(_data);
276             require(success);
277         }
278     }
279 
280     /**
281      * @dev Emitted when the implementation is upgraded.
282      * @param implementation Address of the new implementation.
283      */
284     event Upgraded(address indexed implementation);
285 
286     /**
287      * @dev Storage slot with the address of the current implementation.
288      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
289      * validated in the constructor.
290      */
291     bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
292 
293     /**
294      * @dev Returns the current implementation.
295      * @return impl Address of the current implementation
296      */
297     function _implementation() internal override view returns (address impl) {
298         bytes32 slot = IMPLEMENTATION_SLOT;
299         assembly {
300             impl := sload(slot)
301         }
302     }
303 
304     /**
305      * @dev Upgrades the proxy to a new implementation.
306      * @param newImplementation Address of the new implementation.
307      */
308     function _upgradeTo(address newImplementation) internal {
309         _setImplementation(newImplementation);
310         emit Upgraded(newImplementation);
311     }
312 
313     /**
314      * @dev Sets the implementation address of the proxy.
315      * @param newImplementation Address of the new implementation.
316      */
317     function _setImplementation(address newImplementation) internal {
318         require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
319 
320         bytes32 slot = IMPLEMENTATION_SLOT;
321 
322         assembly {
323             sstore(slot, newImplementation)
324         }
325     }
326 }
327 
328 // File: MasterChef/contracts-proxy/AdminUpgradeabilityProxy.sol
329 
330 pragma solidity ^0.6.0;
331 
332 
333 /**
334  * @title AdminUpgradeabilityProxy
335  * @dev This contract combines an upgradeability proxy with an authorization
336  * mechanism for administrative tasks.
337  * All external functions in this contract must be guarded by the
338  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
339  * feature proposal that would enable this to be done automatically.
340  */
341 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
342     /**
343      * Contract constructor.
344      * @param _logic address of the initial implementation.
345      * @param _admin Address of the proxy administrator.
346      * It should include the signature and the parameters of the function to be called, as described in
347      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
348      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
349      */
350     constructor(address _logic, address _admin) UpgradeabilityProxy(_logic, abi.encodeWithSignature("initialize()")) public payable {
351         assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
352         _setAdmin(_admin);
353     }
354 
355     /**
356      * @dev Emitted when the administration has been transferred.
357      * @param previousAdmin Address of the previous admin.
358      * @param newAdmin Address of the new admin.
359      */
360     event AdminChanged(address previousAdmin, address newAdmin);
361 
362     /**
363      * @dev Storage slot with the admin of the contract.
364      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
365      * validated in the constructor.
366      */
367 
368     bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
369 
370     /**
371      * @dev Modifier to check whether the `msg.sender` is the admin.
372      * If it is, it will run the function. Otherwise, it will delegate the call
373      * to the implementation.
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
384      * @return The address of the proxy admin.
385      */
386     function admin() external ifAdmin returns (address) {
387         return _admin();
388     }
389 
390     /**
391      * @return The address of the implementation.
392      */
393     function implementation() external ifAdmin returns (address) {
394         return _implementation();
395     }
396 
397     /**
398      * @dev Changes the admin of the proxy.
399      * Only the current admin can call this function.
400      * @param newAdmin Address to transfer proxy administration to.
401      */
402     function changeAdmin(address newAdmin) external ifAdmin {
403         require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
404         emit AdminChanged(_admin(), newAdmin);
405         _setAdmin(newAdmin);
406     }
407 
408     /**
409      * @dev Upgrade the backing implementation of the proxy.
410      * Only the admin can call this function.
411      * @param newImplementation Address of the new implementation.
412      */
413     function upgradeTo(address newImplementation) external ifAdmin {
414         _upgradeTo(newImplementation);
415     }
416 
417     /**
418      * @dev Upgrade the backing implementation of the proxy and call a function
419      * on the new implementation.
420      * This is useful to initialize the proxied contract.
421      * @param newImplementation Address of the new implementation.
422      * @param data Data to send as msg.data in the low level call.
423      * It should include the signature and the parameters of the function to be called, as described in
424      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
425      */
426     function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
427         _upgradeTo(newImplementation);
428         (bool success,) = newImplementation.delegatecall(data);
429         require(success);
430     }
431 
432     /**
433      * @return adm The admin slot.
434      */
435     function _admin() internal view returns (address adm) {
436         bytes32 slot = ADMIN_SLOT;
437         assembly {
438             adm := sload(slot)
439         }
440     }
441 
442     /**
443      * @dev Sets the address of the proxy admin.
444      * @param newAdmin Address of the new proxy admin.
445      */
446     function _setAdmin(address newAdmin) internal {
447         bytes32 slot = ADMIN_SLOT;
448 
449         assembly {
450             sstore(slot, newAdmin)
451         }
452     }
453 
454     /**
455      * @dev Only fall back when the sender is not the admin.
456      */
457     function _willFallback() internal override virtual {
458         require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
459         super._willFallback();
460     }
461 }