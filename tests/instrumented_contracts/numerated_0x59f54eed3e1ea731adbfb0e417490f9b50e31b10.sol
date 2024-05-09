1 pragma solidity 0.7.5;
2 
3 /**
4  * @title UpgradeabilityStorage
5  * @dev This contract holds all the necessary state variables to support the upgrade functionality
6  */
7 contract UpgradeabilityStorage {
8     // Version name of the current implementation
9     uint256 internal _version;
10 
11     // Address of the current implementation
12     address internal _implementation;
13 
14     /**
15      * @dev Tells the version name of the current implementation
16      * @return uint256 representing the name of the current version
17      */
18     function version() external view returns (uint256) {
19         return _version;
20     }
21 
22     /**
23      * @dev Tells the address of the current implementation
24      * @return address of the current implementation
25      */
26     function implementation() public view virtual returns (address) {
27         return _implementation;
28     }
29 }
30 
31 
32 /**
33  * @title UpgradeabilityOwnerStorage
34  * @dev This contract keeps track of the upgradeability owner
35  */
36 contract UpgradeabilityOwnerStorage {
37     // Owner of the contract
38     address internal _upgradeabilityOwner;
39 
40     /**
41      * @dev Tells the address of the owner
42      * @return the address of the owner
43      */
44     function upgradeabilityOwner() public view returns (address) {
45         return _upgradeabilityOwner;
46     }
47 
48     /**
49      * @dev Sets the address of the owner
50      */
51     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
52         _upgradeabilityOwner = newUpgradeabilityOwner;
53     }
54 }
55 
56 
57 /**
58  * @title EternalStorage
59  * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
60  */
61 contract EternalStorage {
62     mapping(bytes32 => uint256) internal uintStorage;
63     mapping(bytes32 => string) internal stringStorage;
64     mapping(bytes32 => address) internal addressStorage;
65     mapping(bytes32 => bytes) internal bytesStorage;
66     mapping(bytes32 => bool) internal boolStorage;
67     mapping(bytes32 => int256) internal intStorage;
68 }
69 
70 
71 
72 
73 
74 
75 
76 // SPDX-License-Identifier: MIT
77 
78 
79 
80 /**
81  * @dev Collection of functions related to the address type
82  */
83 library Address {
84     /**
85      * @dev Returns true if `account` is a contract.
86      *
87      * [IMPORTANT]
88      * ====
89      * It is unsafe to assume that an address for which this function returns
90      * false is an externally-owned account (EOA) and not a contract.
91      *
92      * Among others, `isContract` will return false for the following
93      * types of addresses:
94      *
95      *  - an externally-owned account
96      *  - a contract in construction
97      *  - an address where a contract will be created
98      *  - an address where a contract lived, but was destroyed
99      * ====
100      */
101     function isContract(address account) internal view returns (bool) {
102         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
103         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
104         // for accounts without code, i.e. `keccak256('')`
105         bytes32 codehash;
106         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
107         // solhint-disable-next-line no-inline-assembly
108         assembly { codehash := extcodehash(account) }
109         return (codehash != accountHash && codehash != 0x0);
110     }
111 
112     /**
113      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
114      * `recipient`, forwarding all available gas and reverting on errors.
115      *
116      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
117      * of certain opcodes, possibly making contracts go over the 2300 gas limit
118      * imposed by `transfer`, making them unable to receive funds via
119      * `transfer`. {sendValue} removes this limitation.
120      *
121      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
122      *
123      * IMPORTANT: because control is transferred to `recipient`, care must be
124      * taken to not create reentrancy vulnerabilities. Consider using
125      * {ReentrancyGuard} or the
126      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
127      */
128     function sendValue(address payable recipient, uint256 amount) internal {
129         require(address(this).balance >= amount, "Address: insufficient balance");
130 
131         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
132         (bool success, ) = recipient.call{ value: amount }("");
133         require(success, "Address: unable to send value, recipient may have reverted");
134     }
135 
136     /**
137      * @dev Performs a Solidity function call using a low level `call`. A
138      * plain`call` is an unsafe replacement for a function call: use this
139      * function instead.
140      *
141      * If `target` reverts with a revert reason, it is bubbled up by this
142      * function (like regular Solidity function calls).
143      *
144      * Returns the raw returned data. To convert to the expected return value,
145      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
146      *
147      * Requirements:
148      *
149      * - `target` must be a contract.
150      * - calling `target` with `data` must not revert.
151      *
152      * _Available since v3.1._
153      */
154     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
155       return functionCall(target, data, "Address: low-level call failed");
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
160      * `errorMessage` as a fallback revert reason when `target` reverts.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
165         return _functionCallWithValue(target, data, 0, errorMessage);
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
170      * but also transferring `value` wei to `target`.
171      *
172      * Requirements:
173      *
174      * - the calling contract must have an ETH balance of at least `value`.
175      * - the called Solidity function must be `payable`.
176      *
177      * _Available since v3.1._
178      */
179     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
185      * with `errorMessage` as a fallback revert reason when `target` reverts.
186      *
187      * _Available since v3.1._
188      */
189     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
190         require(address(this).balance >= value, "Address: insufficient balance for call");
191         return _functionCallWithValue(target, data, value, errorMessage);
192     }
193 
194     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
195         require(isContract(target), "Address: call to non-contract");
196 
197         // solhint-disable-next-line avoid-low-level-calls
198         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
199         if (success) {
200             return returndata;
201         } else {
202             // Look for revert reason and bubble it up if present
203             if (returndata.length > 0) {
204                 // The easiest way to bubble the revert reason is using memory via assembly
205 
206                 // solhint-disable-next-line no-inline-assembly
207                 assembly {
208                     let returndata_size := mload(returndata)
209                     revert(add(32, returndata), returndata_size)
210                 }
211             } else {
212                 revert(errorMessage);
213             }
214         }
215     }
216 }
217 
218 
219 
220 /**
221  * @title Proxy
222  * @dev Gives the possibility to delegate any call to a foreign implementation.
223  */
224 abstract contract Proxy {
225     /**
226      * @dev Tells the address of the implementation where every call will be delegated.
227      * @return address of the implementation to which it will be delegated
228      */
229     function implementation() public view virtual returns (address);
230 
231     /**
232      * @dev Fallback function allowing to perform a delegatecall to the given implementation.
233      * This function will return whatever the implementation call returns
234      */
235     fallback() external payable {
236         // solhint-disable-previous-line no-complex-fallback
237         address _impl = implementation();
238         require(_impl != address(0));
239         assembly {
240             /*
241                 0x40 is the "free memory slot", meaning a pointer to next slot of empty memory. mload(0x40)
242                 loads the data in the free memory slot, so `ptr` is a pointer to the next slot of empty
243                 memory. It's needed because we're going to write the return data of delegatecall to the
244                 free memory slot.
245             */
246             let ptr := mload(0x40)
247             /*
248                 `calldatacopy` is copy calldatasize bytes from calldata
249                 First argument is the destination to which data is copied(ptr)
250                 Second argument specifies the start position of the copied data.
251                     Since calldata is sort of its own unique location in memory,
252                     0 doesn't refer to 0 in memory or 0 in storage - it just refers to the zeroth byte of calldata.
253                     That's always going to be the zeroth byte of the function selector.
254                 Third argument, calldatasize, specifies how much data will be copied.
255                     calldata is naturally calldatasize bytes long (same thing as msg.data.length)
256             */
257             calldatacopy(ptr, 0, calldatasize())
258             /*
259                 delegatecall params explained:
260                 gas: the amount of gas to provide for the call. `gas` is an Opcode that gives
261                     us the amount of gas still available to execution
262 
263                 _impl: address of the contract to delegate to
264 
265                 ptr: to pass copied data
266 
267                 calldatasize: loads the size of `bytes memory data`, same as msg.data.length
268 
269                 0, 0: These are for the `out` and `outsize` params. Because the output could be dynamic,
270                         these are set to 0, 0 so the output data will not be written to memory. The output
271                         data will be read using `returndatasize` and `returdatacopy` instead.
272 
273                 result: This will be 0 if the call fails and 1 if it succeeds
274             */
275             let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
276             /*
277 
278             */
279             /*
280                 ptr current points to the value stored at 0x40,
281                 because we assigned it like ptr := mload(0x40).
282                 Because we use 0x40 as a free memory pointer,
283                 we want to make sure that the next time we want to allocate memory,
284                 we aren't overwriting anything important.
285                 So, by adding ptr and returndatasize,
286                 we get a memory location beyond the end of the data we will be copying to ptr.
287                 We place this in at 0x40, and any reads from 0x40 will now read from free memory
288             */
289             mstore(0x40, add(ptr, returndatasize()))
290             /*
291                 `returndatacopy` is an Opcode that copies the last return data to a slot. `ptr` is the
292                     slot it will copy to, 0 means copy from the beginning of the return data, and size is
293                     the amount of data to copy.
294                 `returndatasize` is an Opcode that gives us the size of the last return data. In this case, that is the size of the data returned from delegatecall
295             */
296             returndatacopy(ptr, 0, returndatasize())
297 
298             /*
299                 if `result` is 0, revert.
300                 if `result` is 1, return `size` amount of data from `ptr`. This is the data that was
301                 copied to `ptr` from the delegatecall return data
302             */
303             switch result
304                 case 0 {
305                     revert(ptr, returndatasize())
306                 }
307                 default {
308                     return(ptr, returndatasize())
309                 }
310         }
311     }
312 }
313 
314 
315 
316 /**
317  * @title UpgradeabilityProxy
318  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
319  */
320 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
321     /**
322      * @dev This event will be emitted every time the implementation gets upgraded
323      * @param version representing the version name of the upgraded implementation
324      * @param implementation representing the address of the upgraded implementation
325      */
326     event Upgraded(uint256 version, address indexed implementation);
327 
328     /**
329      * @dev Tells the address of the current implementation
330      * @return address of the current implementation
331      */
332     function implementation() public view override(Proxy, UpgradeabilityStorage) returns (address) {
333         return UpgradeabilityStorage.implementation();
334     }
335 
336     /**
337      * @dev Upgrades the implementation address
338      * @param version representing the version name of the new implementation to be set
339      * @param implementation representing the address of the new implementation to be set
340      */
341     function _upgradeTo(uint256 version, address implementation) internal {
342         require(_implementation != implementation);
343 
344         // This additional check verifies that provided implementation is at least a contract
345         require(Address.isContract(implementation));
346 
347         // This additional check guarantees that new version will be at least greater than the privios one,
348         // so it is impossible to reuse old versions, or use the last version twice
349         require(version > _version);
350 
351         _version = version;
352         _implementation = implementation;
353         emit Upgraded(version, implementation);
354     }
355 }
356 
357 
358 
359 /**
360  * @title OwnedUpgradeabilityProxy
361  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
362  */
363 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
364     /**
365      * @dev Event to show ownership has been transferred
366      * @param previousOwner representing the address of the previous owner
367      * @param newOwner representing the address of the new owner
368      */
369     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
370 
371     /**
372      * @dev the constructor sets the original owner of the contract to the sender account.
373      */
374     constructor() {
375         setUpgradeabilityOwner(msg.sender);
376     }
377 
378     /**
379      * @dev Throws if called by any account other than the owner.
380      */
381     modifier onlyUpgradeabilityOwner() {
382         require(msg.sender == upgradeabilityOwner());
383         _;
384     }
385 
386     /**
387      * @dev Allows the current owner to transfer control of the contract to a newOwner.
388      * @param newOwner The address to transfer ownership to.
389      */
390     function transferProxyOwnership(address newOwner) external onlyUpgradeabilityOwner {
391         require(newOwner != address(0));
392         emit ProxyOwnershipTransferred(upgradeabilityOwner(), newOwner);
393         setUpgradeabilityOwner(newOwner);
394     }
395 
396     /**
397      * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
398      * @param version representing the version name of the new implementation to be set.
399      * @param implementation representing the address of the new implementation to be set.
400      */
401     function upgradeTo(uint256 version, address implementation) public onlyUpgradeabilityOwner {
402         _upgradeTo(version, implementation);
403     }
404 
405     /**
406      * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
407      * to initialize whatever is needed through a low level call.
408      * @param version representing the version name of the new implementation to be set.
409      * @param implementation representing the address of the new implementation to be set.
410      * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
411      * signature of the implementation to be called with the needed payload
412      */
413     function upgradeToAndCall(
414         uint256 version,
415         address implementation,
416         bytes calldata data
417     ) external payable onlyUpgradeabilityOwner {
418         upgradeTo(version, implementation);
419         // solhint-disable-next-line avoid-call-value
420         (bool status, ) = address(this).call{ value: msg.value }(data);
421         require(status);
422     }
423 }
424 
425 
426 /**
427  * @title EternalStorageProxy
428  * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
429  * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
430  * authorization control functionalities
431  */
432 contract EternalStorageProxy is EternalStorage, OwnedUpgradeabilityProxy {
433 
434 }