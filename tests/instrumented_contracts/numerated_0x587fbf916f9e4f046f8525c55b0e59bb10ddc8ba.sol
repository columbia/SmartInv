1 pragma solidity ^0.6.0;
2 
3 library Address {
4     /**
5      * @dev Returns true if `account` is a contract.
6      *
7      * [IMPORTANT]
8      * ====
9      * It is unsafe to assume that an address for which this function returns
10      * false is an externally-owned account (EOA) and not a contract.
11      *
12      * Among others, `isContract` will return false for the following
13      * types of addresses:
14      *
15      *  - an externally-owned account
16      *  - a contract in construction
17      *  - an address where a contract will be created
18      *  - an address where a contract lived, but was destroyed
19      * ====
20      */
21     function isContract(address account) internal view returns (bool) {
22         // This method relies on extcodesize, which returns 0 for contracts in
23         // construction, since the code is only stored at the end of the
24         // constructor execution.
25 
26         uint256 size;
27         // solhint-disable-next-line no-inline-assembly
28         assembly { size := extcodesize(account) }
29         return size > 0;
30     }
31 
32     /**
33      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
34      * `recipient`, forwarding all available gas and reverting on errors.
35      *
36      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
37      * of certain opcodes, possibly making contracts go over the 2300 gas limit
38      * imposed by `transfer`, making them unable to receive funds via
39      * `transfer`. {sendValue} removes this limitation.
40      *
41      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
42      *
43      * IMPORTANT: because control is transferred to `recipient`, care must be
44      * taken to not create reentrancy vulnerabilities. Consider using
45      * {ReentrancyGuard} or the
46      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
47      */
48     function sendValue(address payable recipient, uint256 amount) internal {
49         require(address(this).balance >= amount, "Address: insufficient balance");
50 
51         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
52         (bool success, ) = recipient.call{ value: amount }("");
53         require(success, "Address: unable to send value, recipient may have reverted");
54     }
55 
56     /**
57      * @dev Performs a Solidity function call using a low level `call`. A
58      * plain`call` is an unsafe replacement for a function call: use this
59      * function instead.
60      *
61      * If `target` reverts with a revert reason, it is bubbled up by this
62      * function (like regular Solidity function calls).
63      *
64      * Returns the raw returned data. To convert to the expected return value,
65      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
66      *
67      * Requirements:
68      *
69      * - `target` must be a contract.
70      * - calling `target` with `data` must not revert.
71      *
72      * _Available since v3.1._
73      */
74     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
75         return functionCall(target, data, "Address: low-level call failed");
76     }
77 
78     /**
79      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
80      * `errorMessage` as a fallback revert reason when `target` reverts.
81      *
82      * _Available since v3.1._
83      */
84     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
85         return functionCallWithValue(target, data, 0, errorMessage);
86     }
87 
88     /**
89      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
90      * but also transferring `value` wei to `target`.
91      *
92      * Requirements:
93      *
94      * - the calling contract must have an ETH balance of at least `value`.
95      * - the called Solidity function must be `payable`.
96      *
97      * _Available since v3.1._
98      */
99     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
100         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
101     }
102 
103     /**
104      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
105      * with `errorMessage` as a fallback revert reason when `target` reverts.
106      *
107      * _Available since v3.1._
108      */
109     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
110         require(address(this).balance >= value, "Address: insufficient balance for call");
111         require(isContract(target), "Address: call to non-contract");
112 
113         // solhint-disable-next-line avoid-low-level-calls
114         (bool success, bytes memory returndata) = target.call{ value: value }(data);
115         return _verifyCallResult(success, returndata, errorMessage);
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
120      * but performing a static call.
121      *
122      * _Available since v3.3._
123      */
124     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
125         return functionStaticCall(target, data, "Address: low-level static call failed");
126     }
127 
128     /**
129      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
130      * but performing a static call.
131      *
132      * _Available since v3.3._
133      */
134     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
135         require(isContract(target), "Address: static call to non-contract");
136 
137         // solhint-disable-next-line avoid-low-level-calls
138         (bool success, bytes memory returndata) = target.staticcall(data);
139         return _verifyCallResult(success, returndata, errorMessage);
140     }
141 
142     /**
143      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
144      * but performing a delegate call.
145      *
146      * _Available since v3.4._
147      */
148     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
149         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
154      * but performing a delegate call.
155      *
156      * _Available since v3.4._
157      */
158     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
159         require(isContract(target), "Address: delegate call to non-contract");
160 
161         // solhint-disable-next-line avoid-low-level-calls
162         (bool success, bytes memory returndata) = target.delegatecall(data);
163         return _verifyCallResult(success, returndata, errorMessage);
164     }
165 
166     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
167         if (success) {
168             return returndata;
169         } else {
170             // Look for revert reason and bubble it up if present
171             if (returndata.length > 0) {
172                 // The easiest way to bubble the revert reason is using memory via assembly
173 
174                 // solhint-disable-next-line no-inline-assembly
175                 assembly {
176                     let returndata_size := mload(returndata)
177                     revert(add(32, returndata), returndata_size)
178                 }
179             } else {
180                 revert(errorMessage);
181             }
182         }
183     }
184 }
185 
186 
187 /**
188  * @title Proxy
189  * @dev Implements delegation of calls to other contracts, with proper
190  * forwarding of return values and bubbling of failures.
191  * It defines a fallback function that delegates all calls to the address
192  * returned by the abstract _implementation() internal function.
193  */
194 abstract contract Proxy {
195     /**
196      * @dev Fallback function.
197      * Implemented entirely in `_fallback`.
198      */
199     fallback () payable external {
200         _fallback();
201     }
202 
203     /**
204      * @dev Receive function.
205      * Implemented entirely in `_fallback`.
206      */
207     receive () payable external {
208         _fallback();
209     }
210 
211     /**
212      * @return The Address of the implementation.
213      */
214     function _implementation() internal virtual view returns (address);
215 
216     /**
217      * @dev Delegates execution to an implementation contract.
218      * This is a low level function that doesn't return to its internal call site.
219      * It will return to the external caller whatever the implementation returns.
220      * @param implementation Address to delegate.
221      */
222     function _delegate(address implementation) internal {
223         assembly {
224         // Copy msg.data. We take full control of memory in this inline assembly
225         // block because it will not return to Solidity code. We overwrite the
226         // Solidity scratch pad at memory position 0.
227             calldatacopy(0, 0, calldatasize())
228 
229         // Call the implementation.
230         // out and outsize are 0 because we don't know the size yet.
231             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
232 
233         // Copy the returned data.
234             returndatacopy(0, 0, returndatasize())
235 
236             switch result
237             // delegatecall returns 0 on error.
238             case 0 { revert(0, returndatasize()) }
239             default { return(0, returndatasize()) }
240         }
241     }
242 
243     /**
244      * @dev Function that is run as the first thing in the fallback function.
245      * Can be redefined in derived contracts to add functionality.
246      * Redefinitions must call super._willFallback().
247      */
248     function _willFallback() internal virtual {
249     }
250 
251     /**
252      * @dev fallback implementation.
253      * Extracted to enable manual triggering.
254      */
255     function _fallback() internal {
256         _willFallback();
257         _delegate(_implementation());
258     }
259 }
260 /**
261  * @title UpgradeabilityProxy
262  * @dev This contract implements a proxy that allows to change the
263  * implementation address to which it will delegate.
264  * Such a change is called an implementation upgrade.
265  */
266 contract UpgradeabilityProxy is Proxy {
267     /**
268      * @dev Contract constructor.
269      * @param _logic Address of the initial implementation.
270      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
271      * It should include the signature and the parameters of the function to be called, as described in
272      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
273      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
274      */
275     constructor(address _logic, bytes memory _data) public payable {
276         assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
277         _setImplementation(_logic);
278         if(_data.length > 0) {
279             (bool success,) = _logic.delegatecall(_data);
280             require(success);
281         }
282     }
283 
284     /**
285      * @dev Emitted when the implementation is upgraded.
286      * @param implementation Address of the new implementation.
287      */
288     event Upgraded(address indexed implementation);
289 
290     /**
291      * @dev Storage slot with the address of the current implementation.
292      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
293      * validated in the constructor.
294      */
295     bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
296 
297     /**
298      * @dev Returns the current implementation.
299      * @return impl Address of the current implementation
300      */
301     function _implementation() internal override view returns (address impl) {
302         bytes32 slot = IMPLEMENTATION_SLOT;
303         assembly {
304             impl := sload(slot)
305         }
306     }
307 
308     /**
309      * @dev Upgrades the proxy to a new implementation.
310      * @param newImplementation Address of the new implementation.
311      */
312     function _upgradeTo(address newImplementation) internal {
313         _setImplementation(newImplementation);
314         emit Upgraded(newImplementation);
315     }
316 
317     /**
318      * @dev Sets the implementation address of the proxy.
319      * @param newImplementation Address of the new implementation.
320      */
321     function _setImplementation(address newImplementation) internal {
322         require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
323 
324         bytes32 slot = IMPLEMENTATION_SLOT;
325 
326         assembly {
327             sstore(slot, newImplementation)
328         }
329     }
330 }
331 
332 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
333     /**
334      * Contract constructor.
335      * @param _logic address of the initial implementation.
336      * @param _admin Address of the proxy administrator.
337      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
338      * It should include the signature and the parameters of the function to be called, as described in
339      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
340      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
341      */
342     constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
343         assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
344         _setAdmin(_admin);
345     }
346 
347     /**
348      * @dev Emitted when the administration has been transferred.
349      * @param previousAdmin Address of the previous admin.
350      * @param newAdmin Address of the new admin.
351      */
352     event AdminChanged(address previousAdmin, address newAdmin);
353 
354     /**
355      * @dev Storage slot with the admin of the contract.
356      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
357      * validated in the constructor.
358      */
359 
360     bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
361 
362     /**
363      * @dev Modifier to check whether the `msg.sender` is the admin.
364      * If it is, it will run the function. Otherwise, it will delegate the call
365      * to the implementation.
366      */
367     modifier ifAdmin() {
368         if (msg.sender == _admin()) {
369             _;
370         } else {
371             _fallback();
372         }
373     }
374 
375     /**
376      * @return The address of the proxy admin.
377      */
378     function admin() external ifAdmin returns (address) {
379         return _admin();
380     }
381 
382     /**
383      * @return The address of the implementation.
384      */
385     function implementation() external ifAdmin returns (address) {
386         return _implementation();
387     }
388 
389     /**
390      * @dev Changes the admin of the proxy.
391      * Only the current admin can call this function.
392      * @param newAdmin Address to transfer proxy administration to.
393      */
394     function changeAdmin(address newAdmin) external ifAdmin {
395         require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
396         emit AdminChanged(_admin(), newAdmin);
397         _setAdmin(newAdmin);
398     }
399 
400     /**
401      * @dev Upgrade the backing implementation of the proxy.
402      * Only the admin can call this function.
403      * @param newImplementation Address of the new implementation.
404      */
405     function upgradeTo(address newImplementation) external ifAdmin {
406         _upgradeTo(newImplementation);
407     }
408 
409     /**
410      * @dev Upgrade the backing implementation of the proxy and call a function
411      * on the new implementation.
412      * This is useful to initialize the proxied contract.
413      * @param newImplementation Address of the new implementation.
414      * @param data Data to send as msg.data in the low level call.
415      * It should include the signature and the parameters of the function to be called, as described in
416      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
417      */
418     function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
419         _upgradeTo(newImplementation);
420         (bool success,) = newImplementation.delegatecall(data);
421         require(success);
422     }
423 
424     /**
425      * @return adm The admin slot.
426      */
427     function _admin() internal view returns (address adm) {
428         bytes32 slot = ADMIN_SLOT;
429         assembly {
430             adm := sload(slot)
431         }
432     }
433 
434     /**
435      * @dev Sets the address of the proxy admin.
436      * @param newAdmin Address of the new proxy admin.
437      */
438     function _setAdmin(address newAdmin) internal {
439         bytes32 slot = ADMIN_SLOT;
440 
441         assembly {
442             sstore(slot, newAdmin)
443         }
444     }
445 
446     /**
447      * @dev Only fall back when the sender is not the admin.
448      */
449     function _willFallback() internal override virtual {
450         require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
451         super._willFallback();
452     }
453 }