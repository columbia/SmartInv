1 // File: contracts/UpgradeableOwnable.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 
8 /**
9  * @dev Contract module which provides a basic access control mechanism, where
10  * there is an account (an owner) that can be granted exclusive access to
11  * specific functions.
12  *
13  * By default, the owner account will be the one that deploys the contract. This
14  * can later be changed with {transferOwnership}.
15  *
16  * This module is used through inheritance. It will make available the modifier
17  * `onlyOwner`, which can be applied to your functions to restrict their use to
18  * the owner.
19  */
20 contract UpgradeableOwnable {
21     bytes32 private constant _OWNER_SLOT = 0xa7b53796fd2d99cb1f5ae019b54f9e024446c3d12b483f733ccc62ed04eb126a;
22 
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25     /**
26      * @dev Initializes the contract setting the deployer as the initial owner.
27      */
28     constructor () internal {
29         assert(_OWNER_SLOT == bytes32(uint256(keccak256("eip1967.proxy.owner")) - 1));
30         _setOwner(msg.sender);
31         emit OwnershipTransferred(address(0), msg.sender);
32     }
33 
34     function _setOwner(address newOwner) private {
35         bytes32 slot = _OWNER_SLOT;
36         // solium-disable-next-line security/no-inline-assembly
37         assembly {
38             sstore(slot, newOwner)
39         }
40     }
41 
42     /**
43      * @dev Returns the address of the current owner.
44      */
45     function owner() public view virtual returns (address o) {
46         bytes32 slot = _OWNER_SLOT;
47         // solium-disable-next-line security/no-inline-assembly
48         assembly {
49             o := sload(slot)
50         }
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(owner() == msg.sender, "Ownable: caller is not the owner");
58         _;
59     }
60 
61     /**
62      * @dev Leaves the contract without owner. It will not be possible to call
63      * `onlyOwner` functions anymore. Can only be called by the current owner.
64      *
65      * NOTE: Renouncing ownership will leave the contract without an owner,
66      * thereby removing any functionality that is only available to the owner.
67      */
68     function renounceOwnership() public virtual onlyOwner {
69         emit OwnershipTransferred(owner(), address(0));
70         _setOwner(address(0));
71     }
72 
73     /**
74      * @dev Transfers ownership of the contract to a new account (`newOwner`).
75      * Can only be called by the current owner.
76      */
77     function transferOwnership(address newOwner) public virtual onlyOwner {
78         require(newOwner != address(0), "Ownable: new owner is the zero address");
79         emit OwnershipTransferred(owner(), newOwner);
80         _setOwner(newOwner);
81     }
82 }
83 
84 // File: @openzeppelin/contracts/proxy/Proxy.sol
85 
86 
87 
88 pragma solidity >=0.6.0 <0.8.0;
89 
90 /**
91  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
92  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
93  * be specified by overriding the virtual {_implementation} function.
94  *
95  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
96  * different contract through the {_delegate} function.
97  *
98  * The success and return data of the delegated call will be returned back to the caller of the proxy.
99  */
100 abstract contract Proxy {
101     /**
102      * @dev Delegates the current call to `implementation`.
103      *
104      * This function does not return to its internall call site, it will return directly to the external caller.
105      */
106     function _delegate(address implementation) internal virtual {
107         // solhint-disable-next-line no-inline-assembly
108         assembly {
109             // Copy msg.data. We take full control of memory in this inline assembly
110             // block because it will not return to Solidity code. We overwrite the
111             // Solidity scratch pad at memory position 0.
112             calldatacopy(0, 0, calldatasize())
113 
114             // Call the implementation.
115             // out and outsize are 0 because we don't know the size yet.
116             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
117 
118             // Copy the returned data.
119             returndatacopy(0, 0, returndatasize())
120 
121             switch result
122             // delegatecall returns 0 on error.
123             case 0 { revert(0, returndatasize()) }
124             default { return(0, returndatasize()) }
125         }
126     }
127 
128     /**
129      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
130      * and {_fallback} should delegate.
131      */
132     function _implementation() internal view virtual returns (address);
133 
134     /**
135      * @dev Delegates the current call to the address returned by `_implementation()`.
136      *
137      * This function does not return to its internall call site, it will return directly to the external caller.
138      */
139     function _fallback() internal virtual {
140         _beforeFallback();
141         _delegate(_implementation());
142     }
143 
144     /**
145      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
146      * function in the contract matches the call data.
147      */
148     fallback () external payable virtual {
149         _fallback();
150     }
151 
152     /**
153      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
154      * is empty.
155      */
156     receive () external payable virtual {
157         _fallback();
158     }
159 
160     /**
161      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
162      * call, or as part of the Solidity `fallback` or `receive` functions.
163      *
164      * If overriden should call `super._beforeFallback()`.
165      */
166     function _beforeFallback() internal virtual {
167     }
168 }
169 
170 // File: @openzeppelin/contracts/utils/Address.sol
171 
172 
173 
174 pragma solidity >=0.6.2 <0.8.0;
175 
176 /**
177  * @dev Collection of functions related to the address type
178  */
179 library Address {
180     /**
181      * @dev Returns true if `account` is a contract.
182      *
183      * [IMPORTANT]
184      * ====
185      * It is unsafe to assume that an address for which this function returns
186      * false is an externally-owned account (EOA) and not a contract.
187      *
188      * Among others, `isContract` will return false for the following
189      * types of addresses:
190      *
191      *  - an externally-owned account
192      *  - a contract in construction
193      *  - an address where a contract will be created
194      *  - an address where a contract lived, but was destroyed
195      * ====
196      */
197     function isContract(address account) internal view returns (bool) {
198         // This method relies on extcodesize, which returns 0 for contracts in
199         // construction, since the code is only stored at the end of the
200         // constructor execution.
201 
202         uint256 size;
203         // solhint-disable-next-line no-inline-assembly
204         assembly { size := extcodesize(account) }
205         return size > 0;
206     }
207 
208     /**
209      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
210      * `recipient`, forwarding all available gas and reverting on errors.
211      *
212      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
213      * of certain opcodes, possibly making contracts go over the 2300 gas limit
214      * imposed by `transfer`, making them unable to receive funds via
215      * `transfer`. {sendValue} removes this limitation.
216      *
217      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
218      *
219      * IMPORTANT: because control is transferred to `recipient`, care must be
220      * taken to not create reentrancy vulnerabilities. Consider using
221      * {ReentrancyGuard} or the
222      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
223      */
224     function sendValue(address payable recipient, uint256 amount) internal {
225         require(address(this).balance >= amount, "Address: insufficient balance");
226 
227         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
228         (bool success, ) = recipient.call{ value: amount }("");
229         require(success, "Address: unable to send value, recipient may have reverted");
230     }
231 
232     /**
233      * @dev Performs a Solidity function call using a low level `call`. A
234      * plain`call` is an unsafe replacement for a function call: use this
235      * function instead.
236      *
237      * If `target` reverts with a revert reason, it is bubbled up by this
238      * function (like regular Solidity function calls).
239      *
240      * Returns the raw returned data. To convert to the expected return value,
241      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
242      *
243      * Requirements:
244      *
245      * - `target` must be a contract.
246      * - calling `target` with `data` must not revert.
247      *
248      * _Available since v3.1._
249      */
250     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
251       return functionCall(target, data, "Address: low-level call failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
256      * `errorMessage` as a fallback revert reason when `target` reverts.
257      *
258      * _Available since v3.1._
259      */
260     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
261         return functionCallWithValue(target, data, 0, errorMessage);
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
266      * but also transferring `value` wei to `target`.
267      *
268      * Requirements:
269      *
270      * - the calling contract must have an ETH balance of at least `value`.
271      * - the called Solidity function must be `payable`.
272      *
273      * _Available since v3.1._
274      */
275     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
276         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
281      * with `errorMessage` as a fallback revert reason when `target` reverts.
282      *
283      * _Available since v3.1._
284      */
285     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
286         require(address(this).balance >= value, "Address: insufficient balance for call");
287         require(isContract(target), "Address: call to non-contract");
288 
289         // solhint-disable-next-line avoid-low-level-calls
290         (bool success, bytes memory returndata) = target.call{ value: value }(data);
291         return _verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but performing a static call.
297      *
298      * _Available since v3.3._
299      */
300     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
301         return functionStaticCall(target, data, "Address: low-level static call failed");
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
306      * but performing a static call.
307      *
308      * _Available since v3.3._
309      */
310     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
311         require(isContract(target), "Address: static call to non-contract");
312 
313         // solhint-disable-next-line avoid-low-level-calls
314         (bool success, bytes memory returndata) = target.staticcall(data);
315         return _verifyCallResult(success, returndata, errorMessage);
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
320      * but performing a delegate call.
321      *
322      * _Available since v3.4._
323      */
324     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
325         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
330      * but performing a delegate call.
331      *
332      * _Available since v3.4._
333      */
334     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
335         require(isContract(target), "Address: delegate call to non-contract");
336 
337         // solhint-disable-next-line avoid-low-level-calls
338         (bool success, bytes memory returndata) = target.delegatecall(data);
339         return _verifyCallResult(success, returndata, errorMessage);
340     }
341 
342     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
343         if (success) {
344             return returndata;
345         } else {
346             // Look for revert reason and bubble it up if present
347             if (returndata.length > 0) {
348                 // The easiest way to bubble the revert reason is using memory via assembly
349 
350                 // solhint-disable-next-line no-inline-assembly
351                 assembly {
352                     let returndata_size := mload(returndata)
353                     revert(add(32, returndata), returndata_size)
354                 }
355             } else {
356                 revert(errorMessage);
357             }
358         }
359     }
360 }
361 
362 // File: @openzeppelin/contracts/proxy/UpgradeableProxy.sol
363 
364 
365 
366 pragma solidity >=0.6.0 <0.8.0;
367 
368 
369 
370 /**
371  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
372  * implementation address that can be changed. This address is stored in storage in the location specified by
373  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
374  * implementation behind the proxy.
375  *
376  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
377  * {TransparentUpgradeableProxy}.
378  */
379 contract UpgradeableProxy is Proxy {
380     /**
381      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
382      *
383      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
384      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
385      */
386     constructor(address _logic, bytes memory _data) public payable {
387         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
388         _setImplementation(_logic);
389         if(_data.length > 0) {
390             Address.functionDelegateCall(_logic, _data);
391         }
392     }
393 
394     /**
395      * @dev Emitted when the implementation is upgraded.
396      */
397     event Upgraded(address indexed implementation);
398 
399     /**
400      * @dev Storage slot with the address of the current implementation.
401      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
402      * validated in the constructor.
403      */
404     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
405 
406     /**
407      * @dev Returns the current implementation address.
408      */
409     function _implementation() internal view virtual override returns (address impl) {
410         bytes32 slot = _IMPLEMENTATION_SLOT;
411         // solhint-disable-next-line no-inline-assembly
412         assembly {
413             impl := sload(slot)
414         }
415     }
416 
417     /**
418      * @dev Upgrades the proxy to a new implementation.
419      *
420      * Emits an {Upgraded} event.
421      */
422     function _upgradeTo(address newImplementation) internal virtual {
423         _setImplementation(newImplementation);
424         emit Upgraded(newImplementation);
425     }
426 
427     /**
428      * @dev Stores a new address in the EIP1967 implementation slot.
429      */
430     function _setImplementation(address newImplementation) private {
431         require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
432 
433         bytes32 slot = _IMPLEMENTATION_SLOT;
434 
435         // solhint-disable-next-line no-inline-assembly
436         assembly {
437             sstore(slot, newImplementation)
438         }
439     }
440 }
441 
442 // File: contracts/UpgradeableOwnableProxy.sol
443 
444 
445 
446 pragma solidity >=0.6.0 <0.8.0;
447 
448 
449 
450 
451 /**
452  * @dev Contract module which provides a basic access control mechanism, where
453  * there is an account (an owner) that can be granted exclusive access to
454  * specific functions.
455  *
456  * By default, the owner account will be the one that deploys the contract. This
457  * can later be changed with {transferOwnership}.
458  *
459  * This module is used through inheritance. It will make available the modifier
460  * `onlyOwner`, which can be applied to your functions to restrict their use to
461  * the owner.
462  */
463 contract UpgradeableOwnableProxy is UpgradeableOwnable, UpgradeableProxy {
464     /**
465      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
466      *
467      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
468      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
469      */
470     constructor(address _logic, bytes memory _data)
471         public
472         payable
473         UpgradeableProxy(_logic, _data) {
474     }
475 
476     function upgradeTo(address newImplementation) external onlyOwner {
477         _upgradeTo(newImplementation);
478     }
479 
480     function implementation() external view returns (address) {
481         return _implementation();
482     }
483 }