1 pragma solidity 0.4.24;
2 // File: contracts/acl/IACL.sol
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
17 // File: contracts/common/IVaultRecoverable.sol
18 /*
19  * SPDX-License-Identitifer:    MIT
20  */
21 
22 pragma solidity ^0.4.24;
23 
24 
25 interface IVaultRecoverable {
26     function transferToVault(address token) external;
27 
28     function allowRecoverability(address token) external view returns (bool);
29     function getRecoveryVault() external view returns (address);
30 }
31 // File: contracts/kernel/IKernel.sol
32 /*
33  * SPDX-License-Identitifer:    MIT
34  */
35 
36 pragma solidity ^0.4.24;
37 
38 
39 
40 
41 // This should be an interface, but interfaces can't inherit yet :(
42 contract IKernel is IVaultRecoverable {
43     event SetApp(bytes32 indexed namespace, bytes32 indexed appId, address app);
44 
45     function acl() public view returns (IACL);
46     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
47 
48     function setApp(bytes32 namespace, bytes32 appId, address app) public;
49     function getApp(bytes32 namespace, bytes32 appId) public view returns (address);
50 }
51 // File: contracts/kernel/KernelConstants.sol
52 /*
53  * SPDX-License-Identitifer:    MIT
54  */
55 
56 pragma solidity ^0.4.24;
57 
58 
59 contract KernelAppIds {
60     /* Hardcoded constants to save gas
61     bytes32 internal constant KERNEL_CORE_APP_ID = apmNamehash("kernel");
62     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = apmNamehash("acl");
63     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = apmNamehash("vault");
64     */
65     bytes32 internal constant KERNEL_CORE_APP_ID = 0x3b4bf6bf3ad5000ecf0f989d5befde585c6860fea3e574a4fab4c49d1c177d9c;
66     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = 0xe3262375f45a6e2026b7e7b18c2b807434f2508fe1a2a3dfb493c7df8f4aad6a;
67     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = 0x7e852e0fcfce6551c13800f1e7476f982525c2b5277ba14b24339c68416336d1;
68 }
69 
70 
71 contract KernelNamespaceConstants {
72     /* Hardcoded constants to save gas
73     bytes32 internal constant KERNEL_CORE_NAMESPACE = keccak256("core");
74     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = keccak256("base");
75     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = keccak256("app");
76     */
77     bytes32 internal constant KERNEL_CORE_NAMESPACE = 0xc681a85306374a5ab27f0bbc385296a54bcd314a1948b6cf61c4ea1bc44bb9f8;
78     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = 0xf1f3eb40f5bc1ad1344716ced8b8a0431d840b5783aea1fd01786bc26f35ac0f;
79     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = 0xd6f028ca0e8edb4a8c9757ca4fdccab25fa1e0317da1188108f7d2dee14902fb;
80 }
81 // File: contracts/kernel/KernelStorage.sol
82 contract KernelStorage {
83     // namespace => app id => address
84     mapping (bytes32 => mapping (bytes32 => address)) public apps;
85     bytes32 public recoveryVaultAppId;
86 }
87 // File: contracts/common/IsContract.sol
88 /*
89  * SPDX-License-Identitifer:    MIT
90  */
91 
92 pragma solidity ^0.4.24;
93 
94 
95 contract IsContract {
96     /*
97     * NOTE: this should NEVER be used for authentication
98     * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
99     *
100     * This is only intended to be used as a sanity check that an address is actually a contract,
101     * RATHER THAN an address not being a contract.
102     */
103     function isContract(address _target) internal view returns (bool) {
104         if (_target == address(0)) {
105             return false;
106         }
107 
108         uint256 size;
109         assembly { size := extcodesize(_target) }
110         return size > 0;
111     }
112 }
113 // File: contracts/lib/misc/ERCProxy.sol
114 /*
115  * SPDX-License-Identitifer:    MIT
116  */
117 
118 pragma solidity ^0.4.24;
119 
120 
121 contract ERCProxy {
122     uint256 internal constant FORWARDING = 1;
123     uint256 internal constant UPGRADEABLE = 2;
124 
125     function proxyType() public pure returns (uint256 proxyTypeId);
126     function implementation() public view returns (address codeAddr);
127 }
128 // File: contracts/common/DelegateProxy.sol
129 contract DelegateProxy is ERCProxy, IsContract {
130     uint256 internal constant FWD_GAS_LIMIT = 10000;
131 
132     /**
133     * @dev Performs a delegatecall and returns whatever the delegatecall returned (entire context execution will return!)
134     * @param _dst Destination address to perform the delegatecall
135     * @param _calldata Calldata for the delegatecall
136     */
137     function delegatedFwd(address _dst, bytes _calldata) internal {
138         require(isContract(_dst));
139         uint256 fwdGasLimit = FWD_GAS_LIMIT;
140 
141         assembly {
142             let result := delegatecall(sub(gas, fwdGasLimit), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
143             let size := returndatasize
144             let ptr := mload(0x40)
145             returndatacopy(ptr, 0, size)
146 
147             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
148             // if the call returned error data, forward it
149             switch result case 0 { revert(ptr, size) }
150             default { return(ptr, size) }
151         }
152     }
153 }
154 // File: contracts/common/UnstructuredStorage.sol
155 /*
156  * SPDX-License-Identitifer:    MIT
157  */
158 
159 pragma solidity ^0.4.24;
160 
161 
162 library UnstructuredStorage {
163     function getStorageBool(bytes32 position) internal view returns (bool data) {
164         assembly { data := sload(position) }
165     }
166 
167     function getStorageAddress(bytes32 position) internal view returns (address data) {
168         assembly { data := sload(position) }
169     }
170 
171     function getStorageBytes32(bytes32 position) internal view returns (bytes32 data) {
172         assembly { data := sload(position) }
173     }
174 
175     function getStorageUint256(bytes32 position) internal view returns (uint256 data) {
176         assembly { data := sload(position) }
177     }
178 
179     function setStorageBool(bytes32 position, bool data) internal {
180         assembly { sstore(position, data) }
181     }
182 
183     function setStorageAddress(bytes32 position, address data) internal {
184         assembly { sstore(position, data) }
185     }
186 
187     function setStorageBytes32(bytes32 position, bytes32 data) internal {
188         assembly { sstore(position, data) }
189     }
190 
191     function setStorageUint256(bytes32 position, uint256 data) internal {
192         assembly { sstore(position, data) }
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
226 // File: contracts/kernel/KernelProxy.sol
227 contract KernelProxy is KernelStorage, KernelAppIds, KernelNamespaceConstants, IsContract, DepositableDelegateProxy {
228     /**
229     * @dev KernelProxy is a proxy contract to a kernel implementation. The implementation
230     *      can update the reference, which effectively upgrades the contract
231     * @param _kernelImpl Address of the contract used as implementation for kernel
232     */
233     constructor(IKernel _kernelImpl) public {
234         require(isContract(address(_kernelImpl)));
235         apps[KERNEL_CORE_NAMESPACE][KERNEL_CORE_APP_ID] = _kernelImpl;
236     }
237 
238     /**
239      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
240      */
241     function proxyType() public pure returns (uint256 proxyTypeId) {
242         return UPGRADEABLE;
243     }
244 
245     /**
246     * @dev ERC897, the address the proxy would delegate calls to
247     */
248     function implementation() public view returns (address) {
249         return apps[KERNEL_CORE_NAMESPACE][KERNEL_CORE_APP_ID];
250     }
251 }