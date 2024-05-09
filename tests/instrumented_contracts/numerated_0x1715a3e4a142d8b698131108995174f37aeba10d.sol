1 // File: contracts/upgradeability/EternalStorage.sol
2 
3 pragma solidity 0.7.5;
4 
5 /**
6  * @title EternalStorage
7  * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
8  */
9 contract EternalStorage {
10     mapping(bytes32 => uint256) internal uintStorage;
11     mapping(bytes32 => string) internal stringStorage;
12     mapping(bytes32 => address) internal addressStorage;
13     mapping(bytes32 => bytes) internal bytesStorage;
14     mapping(bytes32 => bool) internal boolStorage;
15     mapping(bytes32 => int256) internal intStorage;
16 }
17 
18 // File: @openzeppelin/contracts/utils/Address.sol
19 
20 
21 pragma solidity ^0.7.0;
22 
23 /**
24  * @dev Collection of functions related to the address type
25  */
26 library Address {
27     /**
28      * @dev Returns true if `account` is a contract.
29      *
30      * [IMPORTANT]
31      * ====
32      * It is unsafe to assume that an address for which this function returns
33      * false is an externally-owned account (EOA) and not a contract.
34      *
35      * Among others, `isContract` will return false for the following
36      * types of addresses:
37      *
38      *  - an externally-owned account
39      *  - a contract in construction
40      *  - an address where a contract will be created
41      *  - an address where a contract lived, but was destroyed
42      * ====
43      */
44     function isContract(address account) internal view returns (bool) {
45         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
46         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
47         // for accounts without code, i.e. `keccak256('')`
48         bytes32 codehash;
49         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
50         // solhint-disable-next-line no-inline-assembly
51         assembly { codehash := extcodehash(account) }
52         return (codehash != accountHash && codehash != 0x0);
53     }
54 
55     /**
56      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
57      * `recipient`, forwarding all available gas and reverting on errors.
58      *
59      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
60      * of certain opcodes, possibly making contracts go over the 2300 gas limit
61      * imposed by `transfer`, making them unable to receive funds via
62      * `transfer`. {sendValue} removes this limitation.
63      *
64      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
65      *
66      * IMPORTANT: because control is transferred to `recipient`, care must be
67      * taken to not create reentrancy vulnerabilities. Consider using
68      * {ReentrancyGuard} or the
69      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
70      */
71     function sendValue(address payable recipient, uint256 amount) internal {
72         require(address(this).balance >= amount, "Address: insufficient balance");
73 
74         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
75         (bool success, ) = recipient.call{ value: amount }("");
76         require(success, "Address: unable to send value, recipient may have reverted");
77     }
78 
79     /**
80      * @dev Performs a Solidity function call using a low level `call`. A
81      * plain`call` is an unsafe replacement for a function call: use this
82      * function instead.
83      *
84      * If `target` reverts with a revert reason, it is bubbled up by this
85      * function (like regular Solidity function calls).
86      *
87      * Returns the raw returned data. To convert to the expected return value,
88      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
89      *
90      * Requirements:
91      *
92      * - `target` must be a contract.
93      * - calling `target` with `data` must not revert.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
98       return functionCall(target, data, "Address: low-level call failed");
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
103      * `errorMessage` as a fallback revert reason when `target` reverts.
104      *
105      * _Available since v3.1._
106      */
107     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
108         return _functionCallWithValue(target, data, 0, errorMessage);
109     }
110 
111     /**
112      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
113      * but also transferring `value` wei to `target`.
114      *
115      * Requirements:
116      *
117      * - the calling contract must have an ETH balance of at least `value`.
118      * - the called Solidity function must be `payable`.
119      *
120      * _Available since v3.1._
121      */
122     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
128      * with `errorMessage` as a fallback revert reason when `target` reverts.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
133         require(address(this).balance >= value, "Address: insufficient balance for call");
134         return _functionCallWithValue(target, data, value, errorMessage);
135     }
136 
137     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
138         require(isContract(target), "Address: call to non-contract");
139 
140         // solhint-disable-next-line avoid-low-level-calls
141         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
142         if (success) {
143             return returndata;
144         } else {
145             // Look for revert reason and bubble it up if present
146             if (returndata.length > 0) {
147                 // The easiest way to bubble the revert reason is using memory via assembly
148 
149                 // solhint-disable-next-line no-inline-assembly
150                 assembly {
151                     let returndata_size := mload(returndata)
152                     revert(add(32, returndata), returndata_size)
153                 }
154             } else {
155                 revert(errorMessage);
156             }
157         }
158     }
159 }
160 
161 // File: contracts/upgradeability/Proxy.sol
162 
163 pragma solidity 0.7.5;
164 
165 /**
166  * @title Proxy
167  * @dev Gives the possibility to delegate any call to a foreign implementation.
168  */
169 abstract contract Proxy {
170     /**
171      * @dev Tells the address of the implementation where every call will be delegated.
172      * @return address of the implementation to which it will be delegated
173      */
174     function implementation() public view virtual returns (address);
175 
176     /**
177      * @dev Fallback function allowing to perform a delegatecall to the given implementation.
178      * This function will return whatever the implementation call returns
179      */
180     fallback() external payable {
181         // solhint-disable-previous-line no-complex-fallback
182         address _impl = implementation();
183         require(_impl != address(0));
184         assembly {
185             /*
186                 0x40 is the "free memory slot", meaning a pointer to next slot of empty memory. mload(0x40)
187                 loads the data in the free memory slot, so `ptr` is a pointer to the next slot of empty
188                 memory. It's needed because we're going to write the return data of delegatecall to the
189                 free memory slot.
190             */
191             let ptr := mload(0x40)
192             /*
193                 `calldatacopy` is copy calldatasize bytes from calldata
194                 First argument is the destination to which data is copied(ptr)
195                 Second argument specifies the start position of the copied data.
196                     Since calldata is sort of its own unique location in memory,
197                     0 doesn't refer to 0 in memory or 0 in storage - it just refers to the zeroth byte of calldata.
198                     That's always going to be the zeroth byte of the function selector.
199                 Third argument, calldatasize, specifies how much data will be copied.
200                     calldata is naturally calldatasize bytes long (same thing as msg.data.length)
201             */
202             calldatacopy(ptr, 0, calldatasize())
203             /*
204                 delegatecall params explained:
205                 gas: the amount of gas to provide for the call. `gas` is an Opcode that gives
206                     us the amount of gas still available to execution
207 
208                 _impl: address of the contract to delegate to
209 
210                 ptr: to pass copied data
211 
212                 calldatasize: loads the size of `bytes memory data`, same as msg.data.length
213 
214                 0, 0: These are for the `out` and `outsize` params. Because the output could be dynamic,
215                         these are set to 0, 0 so the output data will not be written to memory. The output
216                         data will be read using `returndatasize` and `returdatacopy` instead.
217 
218                 result: This will be 0 if the call fails and 1 if it succeeds
219             */
220             let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
221             /*
222 
223             */
224             /*
225                 ptr current points to the value stored at 0x40,
226                 because we assigned it like ptr := mload(0x40).
227                 Because we use 0x40 as a free memory pointer,
228                 we want to make sure that the next time we want to allocate memory,
229                 we aren't overwriting anything important.
230                 So, by adding ptr and returndatasize,
231                 we get a memory location beyond the end of the data we will be copying to ptr.
232                 We place this in at 0x40, and any reads from 0x40 will now read from free memory
233             */
234             mstore(0x40, add(ptr, returndatasize()))
235             /*
236                 `returndatacopy` is an Opcode that copies the last return data to a slot. `ptr` is the
237                     slot it will copy to, 0 means copy from the beginning of the return data, and size is
238                     the amount of data to copy.
239                 `returndatasize` is an Opcode that gives us the size of the last return data. In this case, that is the size of the data returned from delegatecall
240             */
241             returndatacopy(ptr, 0, returndatasize())
242 
243             /*
244                 if `result` is 0, revert.
245                 if `result` is 1, return `size` amount of data from `ptr`. This is the data that was
246                 copied to `ptr` from the delegatecall return data
247             */
248             switch result
249                 case 0 {
250                     revert(ptr, returndatasize())
251                 }
252                 default {
253                     return(ptr, returndatasize())
254                 }
255         }
256     }
257 }
258 
259 // File: contracts/upgradeability/UpgradeabilityStorage.sol
260 
261 pragma solidity 0.7.5;
262 
263 /**
264  * @title UpgradeabilityStorage
265  * @dev This contract holds all the necessary state variables to support the upgrade functionality
266  */
267 contract UpgradeabilityStorage {
268     // Version name of the current implementation
269     uint256 internal _version;
270 
271     // Address of the current implementation
272     address internal _implementation;
273 
274     /**
275      * @dev Tells the version name of the current implementation
276      * @return uint256 representing the name of the current version
277      */
278     function version() external view returns (uint256) {
279         return _version;
280     }
281 
282     /**
283      * @dev Tells the address of the current implementation
284      * @return address of the current implementation
285      */
286     function implementation() public view virtual returns (address) {
287         return _implementation;
288     }
289 }
290 
291 // File: contracts/upgradeability/UpgradeabilityProxy.sol
292 
293 pragma solidity 0.7.5;
294 
295 
296 
297 
298 /**
299  * @title UpgradeabilityProxy
300  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
301  */
302 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
303     /**
304      * @dev This event will be emitted every time the implementation gets upgraded
305      * @param version representing the version name of the upgraded implementation
306      * @param implementation representing the address of the upgraded implementation
307      */
308     event Upgraded(uint256 version, address indexed implementation);
309 
310     /**
311      * @dev Tells the address of the current implementation
312      * @return address of the current implementation
313      */
314     function implementation() public view override(Proxy, UpgradeabilityStorage) returns (address) {
315         return UpgradeabilityStorage.implementation();
316     }
317 
318     /**
319      * @dev Upgrades the implementation address
320      * @param version representing the version name of the new implementation to be set
321      * @param implementation representing the address of the new implementation to be set
322      */
323     function _upgradeTo(uint256 version, address implementation) internal {
324         require(_implementation != implementation);
325 
326         // This additional check verifies that provided implementation is at least a contract
327         require(Address.isContract(implementation));
328 
329         // This additional check guarantees that new version will be at least greater than the previous one,
330         // so it is impossible to reuse old versions, or use the last version twice
331         require(version > _version);
332 
333         _version = version;
334         _implementation = implementation;
335         emit Upgraded(version, implementation);
336     }
337 }
338 
339 // File: contracts/upgradeability/UpgradeabilityOwnerStorage.sol
340 
341 pragma solidity 0.7.5;
342 
343 /**
344  * @title UpgradeabilityOwnerStorage
345  * @dev This contract keeps track of the upgradeability owner
346  */
347 contract UpgradeabilityOwnerStorage {
348     // Owner of the contract
349     address internal _upgradeabilityOwner;
350 
351     /**
352      * @dev Tells the address of the owner
353      * @return the address of the owner
354      */
355     function upgradeabilityOwner() public view returns (address) {
356         return _upgradeabilityOwner;
357     }
358 
359     /**
360      * @dev Sets the address of the owner
361      */
362     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
363         _upgradeabilityOwner = newUpgradeabilityOwner;
364     }
365 }
366 
367 // File: contracts/upgradeability/OwnedUpgradeabilityProxy.sol
368 
369 pragma solidity 0.7.5;
370 
371 
372 
373 /**
374  * @title OwnedUpgradeabilityProxy
375  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
376  */
377 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
378     /**
379      * @dev Event to show ownership has been transferred
380      * @param previousOwner representing the address of the previous owner
381      * @param newOwner representing the address of the new owner
382      */
383     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
384 
385     /**
386      * @dev the constructor sets the original owner of the contract to the sender account.
387      */
388     constructor() {
389         setUpgradeabilityOwner(msg.sender);
390     }
391 
392     /**
393      * @dev Throws if called by any account other than the owner.
394      */
395     modifier onlyUpgradeabilityOwner() {
396         require(msg.sender == upgradeabilityOwner());
397         _;
398     }
399 
400     /**
401      * @dev Allows the current owner to transfer control of the contract to a newOwner.
402      * @param newOwner The address to transfer ownership to.
403      */
404     function transferProxyOwnership(address newOwner) external onlyUpgradeabilityOwner {
405         require(newOwner != address(0));
406         emit ProxyOwnershipTransferred(upgradeabilityOwner(), newOwner);
407         setUpgradeabilityOwner(newOwner);
408     }
409 
410     /**
411      * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
412      * @param version representing the version name of the new implementation to be set.
413      * @param implementation representing the address of the new implementation to be set.
414      */
415     function upgradeTo(uint256 version, address implementation) public onlyUpgradeabilityOwner {
416         _upgradeTo(version, implementation);
417     }
418 
419     /**
420      * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
421      * to initialize whatever is needed through a low level call.
422      * @param version representing the version name of the new implementation to be set.
423      * @param implementation representing the address of the new implementation to be set.
424      * @param data represents the msg.data to be sent in the low level call. This parameter may include the function
425      * signature of the implementation to be called with the needed payload
426      */
427     function upgradeToAndCall(
428         uint256 version,
429         address implementation,
430         bytes calldata data
431     ) external payable onlyUpgradeabilityOwner {
432         upgradeTo(version, implementation);
433         // solhint-disable-next-line avoid-call-value
434         (bool status, ) = address(this).call{ value: msg.value }(data);
435         require(status);
436     }
437 }
438 
439 // File: contracts/upgradeability/EternalStorageProxy.sol
440 
441 pragma solidity 0.7.5;
442 
443 
444 
445 /**
446  * @title EternalStorageProxy
447  * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
448  * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
449  * authorization control functionalities
450  */
451 contract EternalStorageProxy is EternalStorage, OwnedUpgradeabilityProxy {
452 
453 }
