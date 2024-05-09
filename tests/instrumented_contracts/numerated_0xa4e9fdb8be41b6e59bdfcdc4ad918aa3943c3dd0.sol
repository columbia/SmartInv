1 // File: @openzeppelin/upgrades/contracts/upgradeability/Proxy.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Proxy
7  * @dev Implements delegation of calls to other contracts, with proper
8  * forwarding of return values and bubbling of failures.
9  * It defines a fallback function that delegates all calls to the address
10  * returned by the abstract _implementation() internal function.
11  */
12 contract Proxy {
13     /**
14      * @dev Fallback function.
15      * Implemented entirely in _fallback.
16      */
17     function() external payable {
18         _fallback();
19     }
20 
21     /**
22      * @return The Address of the implementation.
23      */
24     function _implementation() internal view returns (address);
25 
26     /**
27      * @dev Delegates execution to an implementation contract.
28      * This is a low level function that doesn't return to its internal call site.
29      * It will return to the external caller whatever the implementation returns.
30      * @param implementation Address to delegate.
31      */
32     function _delegate(address implementation) internal {
33         assembly {
34             // Copy msg.data. We take full control of memory in this inline assembly
35             // block because it will not return to Solidity code. We overwrite the
36             // Solidity scratch pad at memory position 0.
37             calldatacopy(0, 0, calldatasize)
38 
39             // Call the implementation.
40             // out and outsize are 0 because we don't know the size yet.
41             let result := delegatecall(
42                 gas,
43                 implementation,
44                 0,
45                 calldatasize,
46                 0,
47                 0
48             )
49 
50             // Copy the returned data.
51             returndatacopy(0, 0, returndatasize)
52 
53             switch result
54                 // delegatecall returns 0 on error.
55                 case 0 {
56                     revert(0, returndatasize)
57                 }
58                 default {
59                     return(0, returndatasize)
60                 }
61         }
62     }
63 
64     /**
65      * @dev Function that is run as the first thing in the fallback function.
66      * Can be redefined in derived contracts to add functionality.
67      * Redefinitions must call super._willFallback().
68      */
69     function _willFallback() internal {}
70 
71     /**
72      * @dev fallback implementation.
73      * Extracted to enable manual triggering.
74      */
75     function _fallback() internal {
76         _willFallback();
77         _delegate(_implementation());
78     }
79 }
80 
81 // File: @openzeppelin/upgrades/contracts/utils/Address.sol
82 
83 pragma solidity ^0.5.0;
84 
85 /**
86  * Utility library of inline functions on addresses
87  *
88  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
89  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
90  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
91  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
92  */
93 library OpenZeppelinUpgradesAddress {
94     /**
95      * Returns whether the target address is a contract
96      * @dev This function will return false if invoked during the constructor of a contract,
97      * as the code is not actually created until after the constructor finishes.
98      * @param account address of the account to check
99      * @return whether the target address is a contract
100      */
101     function isContract(address account) internal view returns (bool) {
102         uint256 size;
103         // XXX Currently there is no better way to check if there is a contract in an address
104         // than to check the size of the code at that address.
105         // See https://ethereum.stackexchange.com/a/14016/36603
106         // for more details about how this works.
107         // TODO Check this again before the Serenity release, because all addresses will be
108         // contracts then.
109         // solhint-disable-next-line no-inline-assembly
110         assembly {
111             size := extcodesize(account)
112         }
113         return size > 0;
114     }
115 }
116 
117 // File: @openzeppelin/upgrades/contracts/upgradeability/BaseUpgradeabilityProxy.sol
118 
119 pragma solidity ^0.5.0;
120 
121 /**
122  * @title BaseUpgradeabilityProxy
123  * @dev This contract implements a proxy that allows to change the
124  * implementation address to which it will delegate.
125  * Such a change is called an implementation upgrade.
126  */
127 contract BaseUpgradeabilityProxy is Proxy {
128     /**
129      * @dev Emitted when the implementation is upgraded.
130      * @param implementation Address of the new implementation.
131      */
132     event Upgraded(address indexed implementation);
133 
134     /**
135      * @dev Storage slot with the address of the current implementation.
136      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
137      * validated in the constructor.
138      */
139     bytes32
140         internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
141 
142     /**
143      * @dev Returns the current implementation.
144      * @return Address of the current implementation
145      */
146     function _implementation() internal view returns (address impl) {
147         bytes32 slot = IMPLEMENTATION_SLOT;
148         assembly {
149             impl := sload(slot)
150         }
151     }
152 
153     /**
154      * @dev Upgrades the proxy to a new implementation.
155      * @param newImplementation Address of the new implementation.
156      */
157     function _upgradeTo(address newImplementation) internal {
158         _setImplementation(newImplementation);
159         emit Upgraded(newImplementation);
160     }
161 
162     /**
163      * @dev Sets the implementation address of the proxy.
164      * @param newImplementation Address of the new implementation.
165      */
166     function _setImplementation(address newImplementation) internal {
167         require(
168             OpenZeppelinUpgradesAddress.isContract(newImplementation),
169             "Cannot set a proxy implementation to a non-contract address"
170         );
171 
172         bytes32 slot = IMPLEMENTATION_SLOT;
173 
174         assembly {
175             sstore(slot, newImplementation)
176         }
177     }
178 }
179 
180 // File: @openzeppelin/upgrades/contracts/upgradeability/UpgradeabilityProxy.sol
181 
182 pragma solidity ^0.5.0;
183 
184 /**
185  * @title UpgradeabilityProxy
186  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
187  * implementation and init data.
188  */
189 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
190     /**
191      * @dev Contract constructor.
192      * @param _logic Address of the initial implementation.
193      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
194      * It should include the signature and the parameters of the function to be called, as described in
195      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
196      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
197      */
198     constructor(address _logic, bytes memory _data) public payable {
199         assert(
200             IMPLEMENTATION_SLOT ==
201                 bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
202         );
203         _setImplementation(_logic);
204         if (_data.length > 0) {
205             (bool success, ) = _logic.delegatecall(_data);
206             require(success);
207         }
208     }
209 }
210 
211 // File: @openzeppelin/upgrades/contracts/upgradeability/BaseAdminUpgradeabilityProxy.sol
212 
213 pragma solidity ^0.5.0;
214 
215 /**
216  * @title BaseAdminUpgradeabilityProxy
217  * @dev This contract combines an upgradeability proxy with an authorization
218  * mechanism for administrative tasks.
219  * All external functions in this contract must be guarded by the
220  * ifAdmin modifier. See ethereum/solidity#3864 for a Solidity
221  * feature proposal that would enable this to be done automatically.
222  */
223 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
224     /**
225      * @dev Emitted when the administration has been transferred.
226      * @param previousAdmin Address of the previous admin.
227      * @param newAdmin Address of the new admin.
228      */
229     event AdminChanged(address previousAdmin, address newAdmin);
230 
231     /**
232      * @dev Storage slot with the admin of the contract.
233      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
234      * validated in the constructor.
235      */
236 
237     bytes32
238         internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
239 
240     /**
241      * @dev Modifier to check whether the msg.sender is the admin.
242      * If it is, it will run the function. Otherwise, it will delegate the call
243      * to the implementation.
244      */
245     modifier ifAdmin() {
246         if (msg.sender == _admin()) {
247             _;
248         } else {
249             _fallback();
250         }
251     }
252 
253     /**
254      * @return The address of the proxy admin.
255      */
256     function admin() external ifAdmin returns (address) {
257         return _admin();
258     }
259 
260     /**
261      * @return The address of the implementation.
262      */
263     function implementation() external ifAdmin returns (address) {
264         return _implementation();
265     }
266 
267     /**
268      * @dev Changes the admin of the proxy.
269      * Only the current admin can call this function.
270      * @param newAdmin Address to transfer proxy administration to.
271      */
272     function changeAdmin(address newAdmin) external ifAdmin {
273         require(
274             newAdmin != address(0),
275             "Cannot change the admin of a proxy to the zero address"
276         );
277         emit AdminChanged(_admin(), newAdmin);
278         _setAdmin(newAdmin);
279     }
280 
281     /**
282      * @dev Upgrade the backing implementation of the proxy.
283      * Only the admin can call this function.
284      * @param newImplementation Address of the new implementation.
285      */
286     function upgradeTo(address newImplementation) external ifAdmin {
287         _upgradeTo(newImplementation);
288     }
289 
290     /**
291      * @dev Upgrade the backing implementation of the proxy and call a function
292      * on the new implementation.
293      * This is useful to initialize the proxied contract.
294      * @param newImplementation Address of the new implementation.
295      * @param data Data to send as msg.data in the low level call.
296      * It should include the signature and the parameters of the function to be called, as described in
297      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
298      */
299     function upgradeToAndCall(address newImplementation, bytes calldata data)
300         external
301         payable
302         ifAdmin
303     {
304         _upgradeTo(newImplementation);
305         (bool success, ) = newImplementation.delegatecall(data);
306         require(success);
307     }
308 
309     /**
310      * @return The admin slot.
311      */
312     function _admin() internal view returns (address adm) {
313         bytes32 slot = ADMIN_SLOT;
314         assembly {
315             adm := sload(slot)
316         }
317     }
318 
319     /**
320      * @dev Sets the address of the proxy admin.
321      * @param newAdmin Address of the new proxy admin.
322      */
323     function _setAdmin(address newAdmin) internal {
324         bytes32 slot = ADMIN_SLOT;
325 
326         assembly {
327             sstore(slot, newAdmin)
328         }
329     }
330 
331     /**
332      * @dev Only fall back when the sender is not the admin.
333      */
334     function _willFallback() internal {
335         require(
336             msg.sender != _admin(),
337             "Cannot call fallback function from the proxy admin"
338         );
339         super._willFallback();
340     }
341 }
342 
343 // File: @openzeppelin/upgrades/contracts/upgradeability/InitializableUpgradeabilityProxy.sol
344 
345 pragma solidity ^0.5.0;
346 
347 /**
348  * @title InitializableUpgradeabilityProxy
349  * @dev Extends BaseUpgradeabilityProxy with an initializer for initializing
350  * implementation and init data.
351  */
352 contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
353     /**
354      * @dev Contract initializer.
355      * @param _logic Address of the initial implementation.
356      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
357      * It should include the signature and the parameters of the function to be called, as described in
358      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
359      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
360      */
361     function initialize(address _logic, bytes memory _data) public payable {
362         require(_implementation() == address(0));
363         assert(
364             IMPLEMENTATION_SLOT ==
365                 bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
366         );
367         _setImplementation(_logic);
368         if (_data.length > 0) {
369             (bool success, ) = _logic.delegatecall(_data);
370             require(success);
371         }
372     }
373 }
374 
375 // File: @openzeppelin/upgrades/contracts/upgradeability/InitializableAdminUpgradeabilityProxy.sol
376 
377 pragma solidity ^0.5.0;
378 
379 /**
380  * @title InitializableAdminUpgradeabilityProxy
381  * @dev Extends from BaseAdminUpgradeabilityProxy with an initializer for
382  * initializing the implementation, admin, and init data.
383  */
384 contract InitializableAdminUpgradeabilityProxy is
385     BaseAdminUpgradeabilityProxy,
386     InitializableUpgradeabilityProxy
387 {
388     /**
389      * Contract initializer.
390      * @param _logic address of the initial implementation.
391      * @param _admin Address of the proxy administrator.
392      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
393      * It should include the signature and the parameters of the function to be called, as described in
394      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
395      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
396      */
397     function initialize(
398         address _logic,
399         address _admin,
400         bytes memory _data
401     ) public payable {
402         require(_implementation() == address(0));
403         InitializableUpgradeabilityProxy.initialize(_logic, _data);
404         assert(
405             ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1)
406         );
407         _setAdmin(_admin);
408     }
409 }
410 
411 // File: contracts/VoteTokenProxy.sol
412 
413 pragma solidity ^0.5.0;
414 
415 contract NFT is InitializableAdminUpgradeabilityProxy {}