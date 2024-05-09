1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-22
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.6.12;
8 
9 /**
10  * @title Proxy
11  * @dev Implements delegation of calls to other contracts, with proper
12  * forwarding of return values and bubbling of failures.
13  * It defines a fallback function that delegates all calls to the address
14  * returned by the abstract _implementation() internal function.
15  */
16 abstract contract Proxy {
17     /**
18      * @dev Fallback function.
19      * Implemented entirely in `_fallback`.
20      */
21     fallback() external payable {
22         _fallback();
23     }
24 
25     /**
26      * @dev Receive function.
27      * Implemented entirely in `_fallback`.
28      */
29     receive() external payable {
30         _fallback();
31     }
32 
33     /**
34      * @return The Address of the implementation.
35      */
36     function _implementation() internal view virtual returns (address);
37 
38     /**
39      * @dev Delegates execution to an implementation contract.
40      * This is a low level function that doesn't return to its internal call site.
41      * It will return to the external caller whatever the implementation returns.
42      * @param implementation Address to delegate.
43      */
44     function _delegate(address implementation) internal {
45         assembly {
46             // Copy msg.data. We take full control of memory in this inline assembly
47             // block because it will not return to Solidity code. We overwrite the
48             // Solidity scratch pad at memory position 0.
49             calldatacopy(0, 0, calldatasize())
50 
51             // Call the implementation.
52             // out and outsize are 0 because we don't know the size yet.
53             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
54 
55             // Copy the returned data.
56             returndatacopy(0, 0, returndatasize())
57 
58             switch result
59                 // delegatecall returns 0 on error.
60                 case 0 {
61                     revert(0, returndatasize())
62                 }
63                 default {
64                     return(0, returndatasize())
65                 }
66         }
67     }
68 
69     /**
70      * @dev Function that is run as the first thing in the fallback function.
71      * Can be redefined in derived contracts to add functionality.
72      * Redefinitions must call super._willFallback().
73      */
74     function _willFallback() internal virtual {}
75 
76     /**
77      * @dev fallback implementation.
78      * Extracted to enable manual triggering.
79      */
80     function _fallback() internal {
81         _willFallback();
82         _delegate(_implementation());
83     }
84 }
85 
86 /**
87  * @dev Collection of functions related to the address type
88  */
89 library Address {
90     /**
91      * @dev Returns true if `account` is a contract.
92      *
93      * [IMPORTANT]
94      * ====
95      * It is unsafe to assume that an address for which this function returns
96      * false is an externally-owned account (EOA) and not a contract.
97      *
98      * Among others, `isContract` will return false for the following
99      * types of addresses:
100      *
101      *  - an externally-owned account
102      *  - a contract in construction
103      *  - an address where a contract will be created
104      *  - an address where a contract lived, but was destroyed
105      * ====
106      */
107     function isContract(address account) internal view returns (bool) {
108         // This method relies in extcodesize, which returns 0 for contracts in
109         // construction, since the code is only stored at the end of the
110         // constructor execution.
111 
112         uint256 size;
113         // solhint-disable-next-line no-inline-assembly
114         assembly {
115             size := extcodesize(account)
116         }
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
140         (bool success, ) = recipient.call{value: amount}("");
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
172     function functionCall(
173         address target,
174         bytes memory data,
175         string memory errorMessage
176     ) internal returns (bytes memory) {
177         return _functionCallWithValue(target, data, 0, errorMessage);
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
191     function functionCallWithValue(
192         address target,
193         bytes memory data,
194         uint256 value
195     ) internal returns (bytes memory) {
196         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
201      * with `errorMessage` as a fallback revert reason when `target` reverts.
202      *
203      * _Available since v3.1._
204      */
205     function functionCallWithValue(
206         address target,
207         bytes memory data,
208         uint256 value,
209         string memory errorMessage
210     ) internal returns (bytes memory) {
211         require(address(this).balance >= value, "Address: insufficient balance for call");
212         return _functionCallWithValue(target, data, value, errorMessage);
213     }
214 
215     function _functionCallWithValue(
216         address target,
217         bytes memory data,
218         uint256 weiValue,
219         string memory errorMessage
220     ) private returns (bytes memory) {
221         require(isContract(target), "Address: call to non-contract");
222 
223         // solhint-disable-next-line avoid-low-level-calls
224         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
225         if (success) {
226             return returndata;
227         } else {
228             // Look for revert reason and bubble it up if present
229             if (returndata.length > 0) {
230                 // The easiest way to bubble the revert reason is using memory via assembly
231 
232                 // solhint-disable-next-line no-inline-assembly
233                 assembly {
234                     let returndata_size := mload(returndata)
235                     revert(add(32, returndata), returndata_size)
236                 }
237             } else {
238                 revert(errorMessage);
239             }
240         }
241     }
242 }
243 
244 /**
245  * @title UpgradeabilityProxy
246  * @dev This contract implements a proxy that allows to change the
247  * implementation address to which it will delegate.
248  * Such a change is called an implementation upgrade.
249  */
250 contract UpgradeabilityProxy is Proxy {
251     /**
252      * @dev Contract constructor.
253      * @param _logic Address of the initial implementation.
254      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
255      * It should include the signature and the parameters of the function to be called, as described in
256      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
257      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
258      */
259     constructor(address _logic, bytes memory _data) public payable {
260         assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
261         _setImplementation(_logic);
262         if (_data.length > 0) {
263             (bool success, ) = _logic.delegatecall(_data);
264             require(success);
265         }
266     }
267 
268     /**
269      * @dev Emitted when the implementation is upgraded.
270      * @param implementation Address of the new implementation.
271      */
272     event Upgraded(address indexed implementation);
273 
274     /**
275      * @dev Storage slot with the address of the current implementation.
276      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
277      * validated in the constructor.
278      */
279     bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
280 
281     /**
282      * @dev Returns the current implementation.
283      * @return impl Address of the current implementation
284      */
285     function _implementation() internal view override returns (address impl) {
286         bytes32 slot = IMPLEMENTATION_SLOT;
287         assembly {
288             impl := sload(slot)
289         }
290     }
291 
292     /**
293      * @dev Upgrades the proxy to a new implementation.
294      * @param newImplementation Address of the new implementation.
295      */
296     function _upgradeTo(address newImplementation) internal {
297         _setImplementation(newImplementation);
298         emit Upgraded(newImplementation);
299     }
300 
301     /**
302      * @dev Sets the implementation address of the proxy.
303      * @param newImplementation Address of the new implementation.
304      */
305     function _setImplementation(address newImplementation) internal {
306         require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
307 
308         bytes32 slot = IMPLEMENTATION_SLOT;
309 
310         assembly {
311             sstore(slot, newImplementation)
312         }
313     }
314 }
315 
316 /**
317  * @title AdminUpgradeabilityProxy
318  * @dev This contract combines an upgradeability proxy with an authorization
319  * mechanism for administrative tasks.
320  * All external functions in this contract must be guarded by the
321  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
322  * feature proposal that would enable this to be done automatically.
323  */
324 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
325     /**
326      * Contract constructor.
327      * @param _logic address of the initial implementation.
328      * @param _admin Address of the proxy administrator.
329      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
330      * It should include the signature and the parameters of the function to be called, as described in
331      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
332      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
333      */
334     constructor(
335         address _logic,
336         address _admin,
337         bytes memory _data
338     ) public payable UpgradeabilityProxy(_logic, _data) {
339         assert(ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
340         _setAdmin(_admin);
341     }
342 
343     /**
344      * @dev Emitted when the administration has been transferred.
345      * @param previousAdmin Address of the previous admin.
346      * @param newAdmin Address of the new admin.
347      */
348     event AdminChanged(address previousAdmin, address newAdmin);
349 
350     /**
351      * @dev Storage slot with the admin of the contract.
352      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
353      * validated in the constructor.
354      */
355 
356     bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
357 
358     /**
359      * @dev Modifier to check whether the `msg.sender` is the admin.
360      * If it is, it will run the function. Otherwise, it will delegate the call
361      * to the implementation.
362      */
363     modifier ifAdmin() {
364         if (msg.sender == _admin()) {
365             _;
366         } else {
367             _fallback();
368         }
369     }
370 
371     /**
372      * @return The address of the proxy admin.
373      */
374     function admin() external ifAdmin returns (address) {
375         return _admin();
376     }
377 
378     /**
379      * @return The address of the implementation.
380      */
381     function implementation() external ifAdmin returns (address) {
382         return _implementation();
383     }
384 
385     /**
386      * @dev Changes the admin of the proxy.
387      * Only the current admin can call this function.
388      * @param newAdmin Address to transfer proxy administration to.
389      */
390     function changeAdmin(address newAdmin) external ifAdmin {
391         require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
392         emit AdminChanged(_admin(), newAdmin);
393         _setAdmin(newAdmin);
394     }
395 
396     /**
397      * @dev Upgrade the backing implementation of the proxy.
398      * Only the admin can call this function.
399      * @param newImplementation Address of the new implementation.
400      */
401     function upgradeTo(address newImplementation) external ifAdmin {
402         _upgradeTo(newImplementation);
403     }
404 
405     /**
406      * @dev Upgrade the backing implementation of the proxy and call a function
407      * on the new implementation.
408      * This is useful to initialize the proxied contract.
409      * @param newImplementation Address of the new implementation.
410      * @param data Data to send as msg.data in the low level call.
411      * It should include the signature and the parameters of the function to be called, as described in
412      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
413      */
414     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
415         _upgradeTo(newImplementation);
416         (bool success, ) = newImplementation.delegatecall(data);
417         require(success);
418     }
419 
420     /**
421      * @return adm The admin slot.
422      */
423     function _admin() internal view returns (address adm) {
424         bytes32 slot = ADMIN_SLOT;
425         assembly {
426             adm := sload(slot)
427         }
428     }
429 
430     /**
431      * @dev Sets the address of the proxy admin.
432      * @param newAdmin Address of the new proxy admin.
433      */
434     function _setAdmin(address newAdmin) internal {
435         bytes32 slot = ADMIN_SLOT;
436 
437         assembly {
438             sstore(slot, newAdmin)
439         }
440     }
441 
442     /**
443      * @dev Only fall back when the sender is not the admin.
444      */
445     function _willFallback() internal virtual override {
446         require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
447         super._willFallback();
448     }
449 }