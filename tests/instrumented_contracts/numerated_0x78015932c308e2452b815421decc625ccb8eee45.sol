1 // File: contracts/acl/IACL.sol
2 
3 /*
4  * SPDX-License-Identitifer:    MIT
5  */
6 
7 pragma solidity ^0.4.24;
8 
9 
10 interface IACL {
11     function initialize(address permissionsCreator) external;
12 
13     // TODO: this should be external
14     // See https://github.com/ethereum/solidity/issues/4832
15     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
16 }
17 
18 // File: contracts/common/IVaultRecoverable.sol
19 
20 /*
21  * SPDX-License-Identitifer:    MIT
22  */
23 
24 pragma solidity ^0.4.24;
25 
26 
27 interface IVaultRecoverable {
28     event RecoverToVault(address indexed vault, address indexed token, uint256 amount);
29 
30     function transferToVault(address token) external;
31 
32     function allowRecoverability(address token) external view returns (bool);
33     function getRecoveryVault() external view returns (address);
34 }
35 
36 // File: contracts/kernel/IKernel.sol
37 
38 /*
39  * SPDX-License-Identitifer:    MIT
40  */
41 
42 pragma solidity ^0.4.24;
43 
44 
45 
46 
47 interface IKernelEvents {
48     event SetApp(bytes32 indexed namespace, bytes32 indexed appId, address app);
49 }
50 
51 
52 // This should be an interface, but interfaces can't inherit yet :(
53 contract IKernel is IKernelEvents, IVaultRecoverable {
54     function acl() public view returns (IACL);
55     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
56 
57     function setApp(bytes32 namespace, bytes32 appId, address app) public;
58     function getApp(bytes32 namespace, bytes32 appId) public view returns (address);
59 }
60 
61 // File: contracts/kernel/KernelConstants.sol
62 
63 /*
64  * SPDX-License-Identitifer:    MIT
65  */
66 
67 pragma solidity ^0.4.24;
68 
69 
70 contract KernelAppIds {
71     /* Hardcoded constants to save gas
72     bytes32 internal constant KERNEL_CORE_APP_ID = apmNamehash("kernel");
73     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = apmNamehash("acl");
74     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = apmNamehash("vault");
75     */
76     bytes32 internal constant KERNEL_CORE_APP_ID = 0x3b4bf6bf3ad5000ecf0f989d5befde585c6860fea3e574a4fab4c49d1c177d9c;
77     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = 0xe3262375f45a6e2026b7e7b18c2b807434f2508fe1a2a3dfb493c7df8f4aad6a;
78     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = 0x7e852e0fcfce6551c13800f1e7476f982525c2b5277ba14b24339c68416336d1;
79 }
80 
81 
82 contract KernelNamespaceConstants {
83     /* Hardcoded constants to save gas
84     bytes32 internal constant KERNEL_CORE_NAMESPACE = keccak256("core");
85     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = keccak256("base");
86     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = keccak256("app");
87     */
88     bytes32 internal constant KERNEL_CORE_NAMESPACE = 0xc681a85306374a5ab27f0bbc385296a54bcd314a1948b6cf61c4ea1bc44bb9f8;
89     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = 0xf1f3eb40f5bc1ad1344716ced8b8a0431d840b5783aea1fd01786bc26f35ac0f;
90     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = 0xd6f028ca0e8edb4a8c9757ca4fdccab25fa1e0317da1188108f7d2dee14902fb;
91 }
92 
93 // File: contracts/kernel/KernelStorage.sol
94 
95 pragma solidity 0.4.24;
96 
97 
98 contract KernelStorage {
99     // namespace => app id => address
100     mapping (bytes32 => mapping (bytes32 => address)) public apps;
101     bytes32 public recoveryVaultAppId;
102 }
103 
104 // File: contracts/common/IsContract.sol
105 
106 /*
107  * SPDX-License-Identitifer:    MIT
108  */
109 
110 pragma solidity ^0.4.24;
111 
112 
113 contract IsContract {
114     /*
115     * NOTE: this should NEVER be used for authentication
116     * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
117     *
118     * This is only intended to be used as a sanity check that an address is actually a contract,
119     * RATHER THAN an address not being a contract.
120     */
121     function isContract(address _target) internal view returns (bool) {
122         if (_target == address(0)) {
123             return false;
124         }
125 
126         uint256 size;
127         assembly { size := extcodesize(_target) }
128         return size > 0;
129     }
130 }
131 
132 // File: contracts/lib/misc/ERCProxy.sol
133 
134 /*
135  * SPDX-License-Identitifer:    MIT
136  */
137 
138 pragma solidity ^0.4.24;
139 
140 
141 contract ERCProxy {
142     uint256 internal constant FORWARDING = 1;
143     uint256 internal constant UPGRADEABLE = 2;
144 
145     function proxyType() public pure returns (uint256 proxyTypeId);
146     function implementation() public view returns (address codeAddr);
147 }
148 
149 // File: contracts/common/DelegateProxy.sol
150 
151 pragma solidity 0.4.24;
152 
153 
154 
155 
156 contract DelegateProxy is ERCProxy, IsContract {
157     uint256 internal constant FWD_GAS_LIMIT = 10000;
158 
159     /**
160     * @dev Performs a delegatecall and returns whatever the delegatecall returned (entire context execution will return!)
161     * @param _dst Destination address to perform the delegatecall
162     * @param _calldata Calldata for the delegatecall
163     */
164     function delegatedFwd(address _dst, bytes _calldata) internal {
165         require(isContract(_dst));
166         uint256 fwdGasLimit = FWD_GAS_LIMIT;
167 
168         assembly {
169             let result := delegatecall(sub(gas, fwdGasLimit), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
170             let size := returndatasize
171             let ptr := mload(0x40)
172             returndatacopy(ptr, 0, size)
173 
174             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
175             // if the call returned error data, forward it
176             switch result case 0 { revert(ptr, size) }
177             default { return(ptr, size) }
178         }
179     }
180 }
181 
182 // File: contracts/common/UnstructuredStorage.sol
183 
184 /*
185  * SPDX-License-Identitifer:    MIT
186  */
187 
188 pragma solidity ^0.4.24;
189 
190 
191 library UnstructuredStorage {
192     function getStorageBool(bytes32 position) internal view returns (bool data) {
193         assembly { data := sload(position) }
194     }
195 
196     function getStorageAddress(bytes32 position) internal view returns (address data) {
197         assembly { data := sload(position) }
198     }
199 
200     function getStorageBytes32(bytes32 position) internal view returns (bytes32 data) {
201         assembly { data := sload(position) }
202     }
203 
204     function getStorageUint256(bytes32 position) internal view returns (uint256 data) {
205         assembly { data := sload(position) }
206     }
207 
208     function setStorageBool(bytes32 position, bool data) internal {
209         assembly { sstore(position, data) }
210     }
211 
212     function setStorageAddress(bytes32 position, address data) internal {
213         assembly { sstore(position, data) }
214     }
215 
216     function setStorageBytes32(bytes32 position, bytes32 data) internal {
217         assembly { sstore(position, data) }
218     }
219 
220     function setStorageUint256(bytes32 position, uint256 data) internal {
221         assembly { sstore(position, data) }
222     }
223 }
224 
225 // File: contracts/common/DepositableStorage.sol
226 
227 pragma solidity 0.4.24;
228 
229 
230 
231 contract DepositableStorage {
232     using UnstructuredStorage for bytes32;
233 
234     // keccak256("aragonOS.depositableStorage.depositable")
235     bytes32 internal constant DEPOSITABLE_POSITION = 0x665fd576fbbe6f247aff98f5c94a561e3f71ec2d3c988d56f12d342396c50cea;
236 
237     function isDepositable() public view returns (bool) {
238         return DEPOSITABLE_POSITION.getStorageBool();
239     }
240 
241     function setDepositable(bool _depositable) internal {
242         DEPOSITABLE_POSITION.setStorageBool(_depositable);
243     }
244 }
245 
246 // File: contracts/common/DepositableDelegateProxy.sol
247 
248 pragma solidity 0.4.24;
249 
250 
251 
252 
253 contract DepositableDelegateProxy is DepositableStorage, DelegateProxy {
254     event ProxyDeposit(address sender, uint256 value);
255 
256     function () external payable {
257         // send / transfer
258         if (gasleft() < FWD_GAS_LIMIT) {
259             require(msg.value > 0 && msg.data.length == 0);
260             require(isDepositable());
261             emit ProxyDeposit(msg.sender, msg.value);
262         } else { // all calls except for send or transfer
263             address target = implementation();
264             delegatedFwd(target, msg.data);
265         }
266     }
267 }
268 
269 // File: contracts/kernel/KernelProxy.sol
270 
271 pragma solidity 0.4.24;
272 
273 
274 
275 
276 
277 
278 
279 contract KernelProxy is IKernelEvents, KernelStorage, KernelAppIds, KernelNamespaceConstants, IsContract, DepositableDelegateProxy {
280     /**
281     * @dev KernelProxy is a proxy contract to a kernel implementation. The implementation
282     *      can update the reference, which effectively upgrades the contract
283     * @param _kernelImpl Address of the contract used as implementation for kernel
284     */
285     constructor(IKernel _kernelImpl) public {
286         require(isContract(address(_kernelImpl)));
287         apps[KERNEL_CORE_NAMESPACE][KERNEL_CORE_APP_ID] = _kernelImpl;
288 
289         // Note that emitting this event is important for verifying that a KernelProxy instance
290         // was never upgraded to a malicious Kernel logic contract over its lifespan.
291         // This starts the "chain of trust", that can be followed through later SetApp() events
292         // emitted during kernel upgrades.
293         emit SetApp(KERNEL_CORE_NAMESPACE, KERNEL_CORE_APP_ID, _kernelImpl);
294     }
295 
296     /**
297      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
298      */
299     function proxyType() public pure returns (uint256 proxyTypeId) {
300         return UPGRADEABLE;
301     }
302 
303     /**
304     * @dev ERC897, the address the proxy would delegate calls to
305     */
306     function implementation() public view returns (address) {
307         return apps[KERNEL_CORE_NAMESPACE][KERNEL_CORE_APP_ID];
308     }
309 }