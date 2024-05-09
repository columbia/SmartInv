1 // File: contracts/common/UnstructuredStorage.sol
2 
3 /*
4  * SPDX-License-Identitifer:    MIT
5  */
6 
7 pragma solidity ^0.4.24;
8 
9 
10 library UnstructuredStorage {
11     function getStorageBool(bytes32 position) internal view returns (bool data) {
12         assembly { data := sload(position) }
13     }
14 
15     function getStorageAddress(bytes32 position) internal view returns (address data) {
16         assembly { data := sload(position) }
17     }
18 
19     function getStorageBytes32(bytes32 position) internal view returns (bytes32 data) {
20         assembly { data := sload(position) }
21     }
22 
23     function getStorageUint256(bytes32 position) internal view returns (uint256 data) {
24         assembly { data := sload(position) }
25     }
26 
27     function setStorageBool(bytes32 position, bool data) internal {
28         assembly { sstore(position, data) }
29     }
30 
31     function setStorageAddress(bytes32 position, address data) internal {
32         assembly { sstore(position, data) }
33     }
34 
35     function setStorageBytes32(bytes32 position, bytes32 data) internal {
36         assembly { sstore(position, data) }
37     }
38 
39     function setStorageUint256(bytes32 position, uint256 data) internal {
40         assembly { sstore(position, data) }
41     }
42 }
43 
44 // File: contracts/acl/IACL.sol
45 
46 /*
47  * SPDX-License-Identitifer:    MIT
48  */
49 
50 pragma solidity ^0.4.24;
51 
52 
53 interface IACL {
54     function initialize(address permissionsCreator) external;
55 
56     // TODO: this should be external
57     // See https://github.com/ethereum/solidity/issues/4832
58     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
59 }
60 
61 // File: contracts/common/IVaultRecoverable.sol
62 
63 /*
64  * SPDX-License-Identitifer:    MIT
65  */
66 
67 pragma solidity ^0.4.24;
68 
69 
70 interface IVaultRecoverable {
71     event RecoverToVault(address indexed vault, address indexed token, uint256 amount);
72 
73     function transferToVault(address token) external;
74 
75     function allowRecoverability(address token) external view returns (bool);
76     function getRecoveryVault() external view returns (address);
77 }
78 
79 // File: contracts/kernel/IKernel.sol
80 
81 /*
82  * SPDX-License-Identitifer:    MIT
83  */
84 
85 pragma solidity ^0.4.24;
86 
87 
88 
89 
90 interface IKernelEvents {
91     event SetApp(bytes32 indexed namespace, bytes32 indexed appId, address app);
92 }
93 
94 
95 // This should be an interface, but interfaces can't inherit yet :(
96 contract IKernel is IKernelEvents, IVaultRecoverable {
97     function acl() public view returns (IACL);
98     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
99 
100     function setApp(bytes32 namespace, bytes32 appId, address app) public;
101     function getApp(bytes32 namespace, bytes32 appId) public view returns (address);
102 }
103 
104 // File: contracts/apps/AppStorage.sol
105 
106 /*
107  * SPDX-License-Identitifer:    MIT
108  */
109 
110 pragma solidity ^0.4.24;
111 
112 
113 
114 
115 contract AppStorage {
116     using UnstructuredStorage for bytes32;
117 
118     /* Hardcoded constants to save gas
119     bytes32 internal constant KERNEL_POSITION = keccak256("aragonOS.appStorage.kernel");
120     bytes32 internal constant APP_ID_POSITION = keccak256("aragonOS.appStorage.appId");
121     */
122     bytes32 internal constant KERNEL_POSITION = 0x4172f0f7d2289153072b0a6ca36959e0cbe2efc3afe50fc81636caa96338137b;
123     bytes32 internal constant APP_ID_POSITION = 0xd625496217aa6a3453eecb9c3489dc5a53e6c67b444329ea2b2cbc9ff547639b;
124 
125     function kernel() public view returns (IKernel) {
126         return IKernel(KERNEL_POSITION.getStorageAddress());
127     }
128 
129     function appId() public view returns (bytes32) {
130         return APP_ID_POSITION.getStorageBytes32();
131     }
132 
133     function setKernel(IKernel _kernel) internal {
134         KERNEL_POSITION.setStorageAddress(address(_kernel));
135     }
136 
137     function setAppId(bytes32 _appId) internal {
138         APP_ID_POSITION.setStorageBytes32(_appId);
139     }
140 }
141 
142 // File: contracts/common/IsContract.sol
143 
144 /*
145  * SPDX-License-Identitifer:    MIT
146  */
147 
148 pragma solidity ^0.4.24;
149 
150 
151 contract IsContract {
152     /*
153     * NOTE: this should NEVER be used for authentication
154     * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
155     *
156     * This is only intended to be used as a sanity check that an address is actually a contract,
157     * RATHER THAN an address not being a contract.
158     */
159     function isContract(address _target) internal view returns (bool) {
160         if (_target == address(0)) {
161             return false;
162         }
163 
164         uint256 size;
165         assembly { size := extcodesize(_target) }
166         return size > 0;
167     }
168 }
169 
170 // File: contracts/lib/misc/ERCProxy.sol
171 
172 /*
173  * SPDX-License-Identitifer:    MIT
174  */
175 
176 pragma solidity ^0.4.24;
177 
178 
179 contract ERCProxy {
180     uint256 internal constant FORWARDING = 1;
181     uint256 internal constant UPGRADEABLE = 2;
182 
183     function proxyType() public pure returns (uint256 proxyTypeId);
184     function implementation() public view returns (address codeAddr);
185 }
186 
187 // File: contracts/common/DelegateProxy.sol
188 
189 pragma solidity 0.4.24;
190 
191 
192 
193 
194 contract DelegateProxy is ERCProxy, IsContract {
195     uint256 internal constant FWD_GAS_LIMIT = 10000;
196 
197     /**
198     * @dev Performs a delegatecall and returns whatever the delegatecall returned (entire context execution will return!)
199     * @param _dst Destination address to perform the delegatecall
200     * @param _calldata Calldata for the delegatecall
201     */
202     function delegatedFwd(address _dst, bytes _calldata) internal {
203         require(isContract(_dst));
204         uint256 fwdGasLimit = FWD_GAS_LIMIT;
205 
206         assembly {
207             let result := delegatecall(sub(gas, fwdGasLimit), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
208             let size := returndatasize
209             let ptr := mload(0x40)
210             returndatacopy(ptr, 0, size)
211 
212             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
213             // if the call returned error data, forward it
214             switch result case 0 { revert(ptr, size) }
215             default { return(ptr, size) }
216         }
217     }
218 }
219 
220 // File: contracts/common/DepositableStorage.sol
221 
222 pragma solidity 0.4.24;
223 
224 
225 
226 contract DepositableStorage {
227     using UnstructuredStorage for bytes32;
228 
229     // keccak256("aragonOS.depositableStorage.depositable")
230     bytes32 internal constant DEPOSITABLE_POSITION = 0x665fd576fbbe6f247aff98f5c94a561e3f71ec2d3c988d56f12d342396c50cea;
231 
232     function isDepositable() public view returns (bool) {
233         return DEPOSITABLE_POSITION.getStorageBool();
234     }
235 
236     function setDepositable(bool _depositable) internal {
237         DEPOSITABLE_POSITION.setStorageBool(_depositable);
238     }
239 }
240 
241 // File: contracts/common/DepositableDelegateProxy.sol
242 
243 pragma solidity 0.4.24;
244 
245 
246 
247 
248 contract DepositableDelegateProxy is DepositableStorage, DelegateProxy {
249     event ProxyDeposit(address sender, uint256 value);
250 
251     function () external payable {
252         uint256 forwardGasThreshold = FWD_GAS_LIMIT;
253         bytes32 isDepositablePosition = DEPOSITABLE_POSITION;
254 
255         // Optimized assembly implementation to prevent EIP-1884 from breaking deposits, reference code in Solidity:
256         // https://github.com/aragon/aragonOS/blob/v4.2.1/contracts/common/DepositableDelegateProxy.sol#L10-L20
257         assembly {
258             // Continue only if the gas left is lower than the threshold for forwarding to the implementation code,
259             // otherwise continue outside of the assembly block.
260             if lt(gas, forwardGasThreshold) {
261                 // Only accept the deposit and emit an event if all of the following are true:
262                 // the proxy accepts deposits (isDepositable), msg.data.length == 0, and msg.value > 0
263                 if and(and(sload(isDepositablePosition), iszero(calldatasize)), gt(callvalue, 0)) {
264                     // Equivalent Solidity code for emitting the event:
265                     // emit ProxyDeposit(msg.sender, msg.value);
266 
267                     let logData := mload(0x40) // free memory pointer
268                     mstore(logData, caller) // add 'msg.sender' to the log data (first event param)
269                     mstore(add(logData, 0x20), callvalue) // add 'msg.value' to the log data (second event param)
270 
271                     // Emit an event with one topic to identify the event: keccak256('ProxyDeposit(address,uint256)') = 0x15ee...dee1
272                     log1(logData, 0x40, 0x15eeaa57c7bd188c1388020bcadc2c436ec60d647d36ef5b9eb3c742217ddee1)
273 
274                     stop() // Stop. Exits execution context
275                 }
276 
277                 // If any of above checks failed, revert the execution (if ETH was sent, it is returned to the sender)
278                 revert(0, 0)
279             }
280         }
281 
282         address target = implementation();
283         delegatedFwd(target, msg.data);
284     }
285 }
286 
287 // File: contracts/kernel/KernelConstants.sol
288 
289 /*
290  * SPDX-License-Identitifer:    MIT
291  */
292 
293 pragma solidity ^0.4.24;
294 
295 
296 contract KernelAppIds {
297     /* Hardcoded constants to save gas
298     bytes32 internal constant KERNEL_CORE_APP_ID = apmNamehash("kernel");
299     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = apmNamehash("acl");
300     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = apmNamehash("vault");
301     */
302     bytes32 internal constant KERNEL_CORE_APP_ID = 0x3b4bf6bf3ad5000ecf0f989d5befde585c6860fea3e574a4fab4c49d1c177d9c;
303     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = 0xe3262375f45a6e2026b7e7b18c2b807434f2508fe1a2a3dfb493c7df8f4aad6a;
304     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = 0x7e852e0fcfce6551c13800f1e7476f982525c2b5277ba14b24339c68416336d1;
305 }
306 
307 
308 contract KernelNamespaceConstants {
309     /* Hardcoded constants to save gas
310     bytes32 internal constant KERNEL_CORE_NAMESPACE = keccak256("core");
311     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = keccak256("base");
312     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = keccak256("app");
313     */
314     bytes32 internal constant KERNEL_CORE_NAMESPACE = 0xc681a85306374a5ab27f0bbc385296a54bcd314a1948b6cf61c4ea1bc44bb9f8;
315     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = 0xf1f3eb40f5bc1ad1344716ced8b8a0431d840b5783aea1fd01786bc26f35ac0f;
316     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = 0xd6f028ca0e8edb4a8c9757ca4fdccab25fa1e0317da1188108f7d2dee14902fb;
317 }
318 
319 // File: contracts/apps/AppProxyBase.sol
320 
321 pragma solidity 0.4.24;
322 
323 
324 
325 
326 
327 
328 contract AppProxyBase is AppStorage, DepositableDelegateProxy, KernelNamespaceConstants {
329     /**
330     * @dev Initialize AppProxy
331     * @param _kernel Reference to organization kernel for the app
332     * @param _appId Identifier for app
333     * @param _initializePayload Payload for call to be made after setup to initialize
334     */
335     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public {
336         setKernel(_kernel);
337         setAppId(_appId);
338 
339         // Implicit check that kernel is actually a Kernel
340         // The EVM doesn't actually provide a way for us to make sure, but we can force a revert to
341         // occur if the kernel is set to 0x0 or a non-code address when we try to call a method on
342         // it.
343         address appCode = getAppBase(_appId);
344 
345         // If initialize payload is provided, it will be executed
346         if (_initializePayload.length > 0) {
347             require(isContract(appCode));
348             // Cannot make delegatecall as a delegateproxy.delegatedFwd as it
349             // returns ending execution context and halts contract deployment
350             require(appCode.delegatecall(_initializePayload));
351         }
352     }
353 
354     function getAppBase(bytes32 _appId) internal view returns (address) {
355         return kernel().getApp(KERNEL_APP_BASES_NAMESPACE, _appId);
356     }
357 }
358 
359 // File: contracts/apps/AppProxyUpgradeable.sol
360 
361 pragma solidity 0.4.24;
362 
363 
364 
365 contract AppProxyUpgradeable is AppProxyBase {
366     /**
367     * @dev Initialize AppProxyUpgradeable (makes it an upgradeable Aragon app)
368     * @param _kernel Reference to organization kernel for the app
369     * @param _appId Identifier for app
370     * @param _initializePayload Payload for call to be made after setup to initialize
371     */
372     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload)
373         AppProxyBase(_kernel, _appId, _initializePayload)
374         public // solium-disable-line visibility-first
375     {
376         // solium-disable-previous-line no-empty-blocks
377     }
378 
379     /**
380      * @dev ERC897, the address the proxy would delegate calls to
381      */
382     function implementation() public view returns (address) {
383         return getAppBase(appId());
384     }
385 
386     /**
387      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
388      */
389     function proxyType() public pure returns (uint256 proxyTypeId) {
390         return UPGRADEABLE;
391     }
392 }