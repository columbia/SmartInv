1 pragma solidity 0.4.24;
2 // File: contracts/common/UnstructuredStorage.sol
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
43 // File: contracts/acl/IACL.sol
44 /*
45  * SPDX-License-Identitifer:    MIT
46  */
47 
48 pragma solidity ^0.4.24;
49 
50 
51 interface IACL {
52     function initialize(address permissionsCreator) external;
53 
54     // TODO: this should be external
55     // See https://github.com/ethereum/solidity/issues/4832
56     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
57 }
58 // File: contracts/common/IVaultRecoverable.sol
59 /*
60  * SPDX-License-Identitifer:    MIT
61  */
62 
63 pragma solidity ^0.4.24;
64 
65 
66 interface IVaultRecoverable {
67     function transferToVault(address token) external;
68 
69     function allowRecoverability(address token) external view returns (bool);
70     function getRecoveryVault() external view returns (address);
71 }
72 // File: contracts/kernel/IKernel.sol
73 /*
74  * SPDX-License-Identitifer:    MIT
75  */
76 
77 pragma solidity ^0.4.24;
78 
79 
80 
81 
82 // This should be an interface, but interfaces can't inherit yet :(
83 contract IKernel is IVaultRecoverable {
84     event SetApp(bytes32 indexed namespace, bytes32 indexed appId, address app);
85 
86     function acl() public view returns (IACL);
87     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
88 
89     function setApp(bytes32 namespace, bytes32 appId, address app) public;
90     function getApp(bytes32 namespace, bytes32 appId) public view returns (address);
91 }
92 // File: contracts/apps/AppStorage.sol
93 /*
94  * SPDX-License-Identitifer:    MIT
95  */
96 
97 pragma solidity ^0.4.24;
98 
99 
100 
101 
102 contract AppStorage {
103     using UnstructuredStorage for bytes32;
104 
105     /* Hardcoded constants to save gas
106     bytes32 internal constant KERNEL_POSITION = keccak256("aragonOS.appStorage.kernel");
107     bytes32 internal constant APP_ID_POSITION = keccak256("aragonOS.appStorage.appId");
108     */
109     bytes32 internal constant KERNEL_POSITION = 0x4172f0f7d2289153072b0a6ca36959e0cbe2efc3afe50fc81636caa96338137b;
110     bytes32 internal constant APP_ID_POSITION = 0xd625496217aa6a3453eecb9c3489dc5a53e6c67b444329ea2b2cbc9ff547639b;
111 
112     function kernel() public view returns (IKernel) {
113         return IKernel(KERNEL_POSITION.getStorageAddress());
114     }
115 
116     function appId() public view returns (bytes32) {
117         return APP_ID_POSITION.getStorageBytes32();
118     }
119 
120     function setKernel(IKernel _kernel) internal {
121         KERNEL_POSITION.setStorageAddress(address(_kernel));
122     }
123 
124     function setAppId(bytes32 _appId) internal {
125         APP_ID_POSITION.setStorageBytes32(_appId);
126     }
127 }
128 // File: contracts/common/IsContract.sol
129 /*
130  * SPDX-License-Identitifer:    MIT
131  */
132 
133 pragma solidity ^0.4.24;
134 
135 
136 contract IsContract {
137     /*
138     * NOTE: this should NEVER be used for authentication
139     * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
140     *
141     * This is only intended to be used as a sanity check that an address is actually a contract,
142     * RATHER THAN an address not being a contract.
143     */
144     function isContract(address _target) internal view returns (bool) {
145         if (_target == address(0)) {
146             return false;
147         }
148 
149         uint256 size;
150         assembly { size := extcodesize(_target) }
151         return size > 0;
152     }
153 }
154 // File: contracts/lib/misc/ERCProxy.sol
155 /*
156  * SPDX-License-Identitifer:    MIT
157  */
158 
159 pragma solidity ^0.4.24;
160 
161 
162 contract ERCProxy {
163     uint256 internal constant FORWARDING = 1;
164     uint256 internal constant UPGRADEABLE = 2;
165 
166     function proxyType() public pure returns (uint256 proxyTypeId);
167     function implementation() public view returns (address codeAddr);
168 }
169 // File: contracts/common/DelegateProxy.sol
170 contract DelegateProxy is ERCProxy, IsContract {
171     uint256 internal constant FWD_GAS_LIMIT = 10000;
172 
173     /**
174     * @dev Performs a delegatecall and returns whatever the delegatecall returned (entire context execution will return!)
175     * @param _dst Destination address to perform the delegatecall
176     * @param _calldata Calldata for the delegatecall
177     */
178     function delegatedFwd(address _dst, bytes _calldata) internal {
179         require(isContract(_dst));
180         uint256 fwdGasLimit = FWD_GAS_LIMIT;
181 
182         assembly {
183             let result := delegatecall(sub(gas, fwdGasLimit), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
184             let size := returndatasize
185             let ptr := mload(0x40)
186             returndatacopy(ptr, 0, size)
187 
188             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
189             // if the call returned error data, forward it
190             switch result case 0 { revert(ptr, size) }
191             default { return(ptr, size) }
192         }
193     }
194 }
195 // File: contracts/common/DepositableStorage.sol
196 contract DepositableStorage {
197     using UnstructuredStorage for bytes32;
198 
199     // keccak256("aragonOS.depositableStorage.depositable")
200     bytes32 internal constant DEPOSITABLE_POSITION = 0x665fd576fbbe6f247aff98f5c94a561e3f71ec2d3c988d56f12d342396c50cea;
201 
202     function isDepositable() public view returns (bool) {
203         return DEPOSITABLE_POSITION.getStorageBool();
204     }
205 
206     function setDepositable(bool _depositable) internal {
207         DEPOSITABLE_POSITION.setStorageBool(_depositable);
208     }
209 }
210 // File: contracts/common/DepositableDelegateProxy.sol
211 contract DepositableDelegateProxy is DepositableStorage, DelegateProxy {
212     event ProxyDeposit(address sender, uint256 value);
213 
214     function () external payable {
215         // send / transfer
216         if (gasleft() < FWD_GAS_LIMIT) {
217             require(msg.value > 0 && msg.data.length == 0);
218             require(isDepositable());
219             emit ProxyDeposit(msg.sender, msg.value);
220         } else { // all calls except for send or transfer
221             address target = implementation();
222             delegatedFwd(target, msg.data);
223         }
224     }
225 }
226 // File: contracts/kernel/KernelConstants.sol
227 /*
228  * SPDX-License-Identitifer:    MIT
229  */
230 
231 pragma solidity ^0.4.24;
232 
233 
234 contract KernelAppIds {
235     /* Hardcoded constants to save gas
236     bytes32 internal constant KERNEL_CORE_APP_ID = apmNamehash("kernel");
237     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = apmNamehash("acl");
238     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = apmNamehash("vault");
239     */
240     bytes32 internal constant KERNEL_CORE_APP_ID = 0x3b4bf6bf3ad5000ecf0f989d5befde585c6860fea3e574a4fab4c49d1c177d9c;
241     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = 0xe3262375f45a6e2026b7e7b18c2b807434f2508fe1a2a3dfb493c7df8f4aad6a;
242     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = 0x7e852e0fcfce6551c13800f1e7476f982525c2b5277ba14b24339c68416336d1;
243 }
244 
245 
246 contract KernelNamespaceConstants {
247     /* Hardcoded constants to save gas
248     bytes32 internal constant KERNEL_CORE_NAMESPACE = keccak256("core");
249     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = keccak256("base");
250     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = keccak256("app");
251     */
252     bytes32 internal constant KERNEL_CORE_NAMESPACE = 0xc681a85306374a5ab27f0bbc385296a54bcd314a1948b6cf61c4ea1bc44bb9f8;
253     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = 0xf1f3eb40f5bc1ad1344716ced8b8a0431d840b5783aea1fd01786bc26f35ac0f;
254     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = 0xd6f028ca0e8edb4a8c9757ca4fdccab25fa1e0317da1188108f7d2dee14902fb;
255 }
256 // File: contracts/apps/AppProxyBase.sol
257 contract AppProxyBase is AppStorage, DepositableDelegateProxy, KernelNamespaceConstants {
258     /**
259     * @dev Initialize AppProxy
260     * @param _kernel Reference to organization kernel for the app
261     * @param _appId Identifier for app
262     * @param _initializePayload Payload for call to be made after setup to initialize
263     */
264     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public {
265         setKernel(_kernel);
266         setAppId(_appId);
267 
268         // Implicit check that kernel is actually a Kernel
269         // The EVM doesn't actually provide a way for us to make sure, but we can force a revert to
270         // occur if the kernel is set to 0x0 or a non-code address when we try to call a method on
271         // it.
272         address appCode = getAppBase(_appId);
273 
274         // If initialize payload is provided, it will be executed
275         if (_initializePayload.length > 0) {
276             require(isContract(appCode));
277             // Cannot make delegatecall as a delegateproxy.delegatedFwd as it
278             // returns ending execution context and halts contract deployment
279             require(appCode.delegatecall(_initializePayload));
280         }
281     }
282 
283     function getAppBase(bytes32 _appId) internal view returns (address) {
284         return kernel().getApp(KERNEL_APP_BASES_NAMESPACE, _appId);
285     }
286 }
287 // File: contracts/apps/AppProxyUpgradeable.sol
288 contract AppProxyUpgradeable is AppProxyBase {
289     /**
290     * @dev Initialize AppProxyUpgradeable (makes it an upgradeable Aragon app)
291     * @param _kernel Reference to organization kernel for the app
292     * @param _appId Identifier for app
293     * @param _initializePayload Payload for call to be made after setup to initialize
294     */
295     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload)
296         AppProxyBase(_kernel, _appId, _initializePayload)
297         public // solium-disable-line visibility-first
298     {
299 
300     }
301 
302     /**
303      * @dev ERC897, the address the proxy would delegate calls to
304      */
305     function implementation() public view returns (address) {
306         return getAppBase(appId());
307     }
308 
309     /**
310      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
311      */
312     function proxyType() public pure returns (uint256 proxyTypeId) {
313         return UPGRADEABLE;
314     }
315 }