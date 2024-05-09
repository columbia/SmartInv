1 /**
2  *Submitted for verification at Etherscan.io on 2021-03-12
3 */
4 
5 // File: contracts/upgradeability/EternalStorage.sol
6 
7 pragma solidity 0.7.5;
8 
9 /**
10  * @title EternalStorage
11  * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
12  */
13 contract EternalStorage {
14     mapping(bytes32 => uint256) internal uintStorage;
15     mapping(bytes32 => string) internal stringStorage;
16     mapping(bytes32 => address) internal addressStorage;
17     mapping(bytes32 => bytes) internal bytesStorage;
18     mapping(bytes32 => bool) internal boolStorage;
19     mapping(bytes32 => int256) internal intStorage;
20 }
21 
22 // File: @openzeppelin/contracts/utils/Address.sol
23 
24 
25 pragma solidity ^0.7.0;
26 
27 /**
28  * @dev Collection of functions related to the address type
29  */
30 library Address {
31     /**
32      * @dev Returns true if `account` is a contract.
33      *
34      * [IMPORTANT]
35      * ====
36      * It is unsafe to assume that an address for which this function returns
37      * false is an externally-owned account (EOA) and not a contract.
38      *
39      * Among others, `isContract` will return false for the following
40      * types of addresses:
41      *
42      *  - an externally-owned account
43      *  - a contract in construction
44      *  - an address where a contract will be created
45      *  - an address where a contract lived, but was destroyed
46      * ====
47      */
48     function isContract(address account) internal view returns (bool) {
49         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
50         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
51         // for accounts without code, i.e. `keccak256('')`
52         bytes32 codehash;
53         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
54         // solhint-disable-next-line no-inline-assembly
55         assembly { codehash := extcodehash(account) }
56         return (codehash != accountHash && codehash != 0x0);
57     }
58 
59     /**
60      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
61      * `recipient`, forwarding all available gas and reverting on errors.
62      *
63      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
64      * of certain opcodes, possibly making contracts go over the 2300 gas limit
65      * imposed by `transfer`, making them unable to receive funds via
66      * `transfer`. {sendValue} removes this limitation.
67      *
68      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
69      *
70      * IMPORTANT: because control is transferred to `recipient`, care must be
71      * taken to not create reentrancy vulnerabilities. Consider using
72      * {ReentrancyGuard} or the
73      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
74      */
75     function sendValue(address payable recipient, uint256 amount) internal {
76         require(address(this).balance >= amount, "Address: insufficient balance");
77 
78         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
79         (bool success, ) = recipient.call{ value: amount }("");
80         require(success, "Address: unable to send value, recipient may have reverted");
81     }
82 
83     /**
84      * @dev Performs a Solidity function call using a low level `call`. A
85      * plain`call` is an unsafe replacement for a function call: use this
86      * function instead.
87      *
88      * If `target` reverts with a revert reason, it is bubbled up by this
89      * function (like regular Solidity function calls).
90      *
91      * Returns the raw returned data. To convert to the expected return value,
92      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
93      *
94      * Requirements:
95      *
96      * - `target` must be a contract.
97      * - calling `target` with `data` must not revert.
98      *
99      * _Available since v3.1._
100      */
101     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
102       return functionCall(target, data, "Address: low-level call failed");
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
107      * `errorMessage` as a fallback revert reason when `target` reverts.
108      *
109      * _Available since v3.1._
110      */
111     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
112         return _functionCallWithValue(target, data, 0, errorMessage);
113     }
114 
115     /**
116      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
117      * but also transferring `value` wei to `target`.
118      *
119      * Requirements:
120      *
121      * - the calling contract must have an ETH balance of at least `value`.
122      * - the called Solidity function must be `payable`.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
127         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
128     }
129 
130     /**
131      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
132      * with `errorMessage` as a fallback revert reason when `target` reverts.
133      *
134      * _Available since v3.1._
135      */
136     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
137         require(address(this).balance >= value, "Address: insufficient balance for call");
138         return _functionCallWithValue(target, data, value, errorMessage);
139     }
140 
141     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
142         require(isContract(target), "Address: call to non-contract");
143 
144         // solhint-disable-next-line avoid-low-level-calls
145         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
146         if (success) {
147             return returndata;
148         } else {
149             // Look for revert reason and bubble it up if present
150             if (returndata.length > 0) {
151                 // The easiest way to bubble the revert reason is using memory via assembly
152 
153                 // solhint-disable-next-line no-inline-assembly
154                 assembly {
155                     let returndata_size := mload(returndata)
156                     revert(add(32, returndata), returndata_size)
157                 }
158             } else {
159                 revert(errorMessage);
160             }
161         }
162     }
163 }
164 
165 // File: contracts/upgradeability/Proxy.sol
166 
167 pragma solidity 0.7.5;
168 
169 /**
170  * @title Proxy
171  * @dev Gives the possibility to delegate any call to a foreign implementation.
172  */
173 abstract contract Proxy {
174     /**
175      * @dev Tells the address of the implementation where every call will be delegated.
176      * @return address of the implementation to which it will be delegated
177      */
178     function implementation() public view virtual returns (address);
179 
180     /**
181      * @dev Fallback function allowing to perform a delegatecall to the given implementation.
182      * This function will return whatever the implementation call returns
183      */
184     fallback() external payable {
185         // solhint-disable-previous-line no-complex-fallback
186         address _impl = implementation();
187         require(_impl != address(0));
188         assembly {
189             /*
190                 0x40 is the "free memory slot", meaning a pointer to next slot of empty memory. mload(0x40)
191                 loads the data in the free memory slot, so `ptr` is a pointer to the next slot of empty
192                 memory. It's needed because we're going to write the return data of delegatecall to the
193                 free memory slot.
194             */
195             let ptr := mload(0x40)
196             /*
197                 `calldatacopy` is copy calldatasize bytes from calldata
198                 First argument is the destination to which data is copied(ptr)
199                 Second argument specifies the start position of the copied data.
200                     Since calldata is sort of its own unique location in memory,
201                     0 doesn't refer to 0 in memory or 0 in storage - it just refers to the zeroth byte of calldata.
202                     That's always going to be the zeroth byte of the function selector.
203                 Third argument, calldatasize, specifies how much data will be copied.
204                     calldata is naturally calldatasize bytes long (same thing as msg.data.length)
205             */
206             calldatacopy(ptr, 0, calldatasize())
207             /*
208                 delegatecall params explained:
209                 gas: the amount of gas to provide for the call. `gas` is an Opcode that gives
210                     us the amount of gas still available to execution
211 
212                 _impl: address of the contract to delegate to
213 
214                 ptr: to pass copied data
215 
216                 calldatasize: loads the size of `bytes memory data`, same as msg.data.length
217 
218                 0, 0: These are for the `out` and `outsize` params. Because the output could be dynamic,
219                         these are set to 0, 0 so the output data will not be written to memory. The output
220                         data will be read using `returndatasize` and `returdatacopy` instead.
221 
222                 result: This will be 0 if the call fails and 1 if it succeeds
223             */
224             let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
225             /*
226 
227             */
228             /*
229                 ptr current points to the value stored at 0x40,
230                 because we assigned it like ptr := mload(0x40).
231                 Because we use 0x40 as a free memory pointer,
232                 we want to make sure that the next time we want to allocate memory,
233                 we aren't overwriting anything important.
234                 So, by adding ptr and returndatasize,
235                 we get a memory location beyond the end of the data we will be copying to ptr.
236                 We place this in at 0x40, and any reads from 0x40 will now read from free memory
237             */
238             mstore(0x40, add(ptr, returndatasize()))
239             /*
240                 `returndatacopy` is an Opcode that copies the last return data to a slot. `ptr` is the
241                     slot it will copy to, 0 means copy from the beginning of the return data, and size is
242                     the amount of data to copy.
243                 `returndatasize` is an Opcode that gives us the size of the last return data. In this case, that is the size of the data returned from delegatecall
244             */
245             returndatacopy(ptr, 0, returndatasize())
246 
247             /*
248                 if `result` is 0, revert.
249                 if `result` is 1, return `size` amount of data from `ptr`. This is the data that was
250                 copied to `ptr` from the delegatecall return data
251             */
252             switch result
253                 case 0 {
254                     revert(ptr, returndatasize())
255                 }
256                 default {
257                     return(ptr, returndatasize())
258                 }
259         }
260     }
261 }
262 
263 // File: contracts/upgradeability/UpgradeabilityStorage.sol
264 
265 pragma solidity 0.7.5;
266 
267 /**
268  * @title UpgradeabilityStorage
269  * @dev This contract holds all the necessary state variables to support the upgrade functionality
270  */
271 contract UpgradeabilityStorage {
272     // Version name of the current implementation
273     uint256 internal _version;
274 
275     // Address of the current implementation
276     address internal _implementation;
277 
278     /**
279      * @dev Tells the version name of the current implementation
280      * @return uint256 representing the name of the current version
281      */
282     function version() external view returns (uint256) {
283         return _version;
284     }
285 
286     /**
287      * @dev Tells the address of the current implementation
288      * @return address of the current implementation
289      */
290     function implementation() public view virtual returns (address) {
291         return _implementation;
292     }
293 }
294 
295 // File: contracts/upgradeability/UpgradeabilityProxy.sol
296 
297 pragma solidity 0.7.5;
298 
299 
300 
301 
302 /**
303  * @title UpgradeabilityProxy
304  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
305  */
306 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
307     /**
308      * @dev This event will be emitted every time the implementation gets upgraded
309      * @param version representing the version name of the upgraded implementation
310      * @param implementation representing the address of the upgraded implementation
311      */
312     event Upgraded(uint256 version, address indexed implementation);
313 
314     /**
315      * @dev Tells the address of the current implementation
316      * @return address of the current implementation
317      */
318     function implementation() public view override(Proxy, UpgradeabilityStorage) returns (address) {
319         return UpgradeabilityStorage.implementation();
320     }
321 
322     /**
323      * @dev Upgrades the implementation address
324      * @param version representing the version name of the new implementation to be set
325      * @param implementation representing the address of the new implementation to be set
326      */
327     function _upgradeTo(uint256 version, address implementation) internal {
328         require(_implementation != implementation);
329 
330         // This additional check verifies that provided implementation is at least a contract
331         require(Address.isContract(implementation));
332 
333         // This additional check guarantees that new version will be at least greater than the privios one,
334         // so it is impossible to reuse old versions, or use the last version twice
335         require(version > _version);
336 
337         _version = version;
338         _implementation = implementation;
339         emit Upgraded(version, implementation);
340     }
341 }
342 
343 // File: contracts/upgradeability/UpgradeabilityOwnerStorage.sol
344 
345 pragma solidity 0.7.5;
346 
347 /**
348  * @title UpgradeabilityOwnerStorage
349  * @dev This contract keeps track of the upgradeability owner
350  */
351 contract UpgradeabilityOwnerStorage {
352     // Owner of the contract
353     address internal _upgradeabilityOwner;
354 
355     /**
356      * @dev Tells the address of the owner
357      * @return the address of the owner
358      */
359     function upgradeabilityOwner() public view returns (address) {
360         return _upgradeabilityOwner;
361     }
362 
363     /**
364      * @dev Sets the address of the owner
365      */
366     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
367         _upgradeabilityOwner = newUpgradeabilityOwner;
368     }
369 }
370 
371 // File: contracts/upgradeability/OwnedUpgradeabilityProxy.sol
372 
373 pragma solidity 0.7.5;
374 
375 
376 
377 /**
378  * @title OwnedUpgradeabilityProxy
379  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
380  */
381 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
382     /**
383      * @dev Event to show ownership has been transferred
384      * @param previousOwner representing the address of the previous owner
385      * @param newOwner representing the address of the new owner
386      */
387     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
388 
389     /**
390      * @dev the constructor sets the original owner of the contract to the sender account.
391      */
392     constructor() {
393         setUpgradeabilityOwner(msg.sender);
394     }
395 
396     /**
397      * @dev Throws if called by any account other than the owner.
398      */
399     modifier onlyUpgradeabilityOwner() {
400         require(msg.sender == upgradeabilityOwner());
401         _;
402     }
403 
404     /**
405      * @dev Allows the current owner to transfer control of the contract to a newOwner.
406      * @param newOwner The address to transfer ownership to.
407      */
408     function transferProxyOwnership(address newOwner) external onlyUpgradeabilityOwner {
409         require(newOwner != address(0));
410         emit ProxyOwnershipTransferred(upgradeabilityOwner(), newOwner);
411         setUpgradeabilityOwner(newOwner);
412     }
413 
414     /**
415      * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
416      * @param version representing the version name of the new implementation to be set.
417      * @param implementation representing the address of the new implementation to be set.
418      */
419     function upgradeTo(uint256 version, address implementation) public onlyUpgradeabilityOwner {
420         _upgradeTo(version, implementation);
421     }
422 
423     /**
424      * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
425      * to initialize whatever is needed through a low level call.
426      * @param version representing the version name of the new implementation to be set.
427      * @param implementation representing the address of the new implementation to be set.
428      * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
429      * signature of the implementation to be called with the needed payload
430      */
431     function upgradeToAndCall(
432         uint256 version,
433         address implementation,
434         bytes calldata data
435     ) external payable onlyUpgradeabilityOwner {
436         upgradeTo(version, implementation);
437         // solhint-disable-next-line avoid-call-value
438         (bool status, ) = address(this).call{ value: msg.value }(data);
439         require(status);
440     }
441 }
442 
443 // File: contracts/upgradeability/EternalStorageProxy.sol
444 
445 pragma solidity 0.7.5;
446 
447 
448 
449 /**
450  * @title EternalStorageProxy
451  * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
452  * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
453  * authorization control functionalities
454  */
455 // solhint-disable-next-line no-empty-blocks
456 contract EternalStorageProxy is EternalStorage, OwnedUpgradeabilityProxy {
457 
458 }