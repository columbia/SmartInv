1 pragma solidity ^0.8.12;
2 
3 //SPDX-License-Identifier: MIT
4 
5 /**
6  * @title Proxy
7  * @dev Implements delegation of calls to other contracts, with proper
8  * forwarding of return values and bubbling of failures.
9  * It defines a fallback function that delegates all calls to the address
10  * returned by the abstract _implementation() internal function.
11  */
12 abstract contract Proxy {
13     /**
14      * @dev Fallback function.
15      * Implemented entirely in `_fallback`.
16      */
17     fallback() external payable {
18         _fallback();
19     }
20 
21     receive() external payable {
22         _fallback();
23     }
24 
25     /**
26      * @return The Address of the implementation.
27      */
28     function _implementation() internal view virtual returns (address);
29 
30     /**
31      * @dev Delegates execution to an implementation contract.
32      * This is a low level function that doesn't return to its internal call site.
33      * It will return to the external caller whatever the implementation returns.
34      * @param implementation Address to delegate.
35      */
36     function _delegate(address implementation) internal {
37         assembly {
38             // Copy msg.data. We take full control of memory in this inline assembly
39             // block because it will not return to Solidity code. We overwrite the
40             // Solidity scratch pad at memory position 0.
41             calldatacopy(0, 0, calldatasize())
42 
43             // Call the implementation.
44             // out and outsize are 0 because we don't know the size yet.
45             let result := delegatecall(
46                 gas(),
47                 implementation,
48                 0,
49                 calldatasize(),
50                 0,
51                 0
52             )
53             // Copy the returned data.
54             let retSz := returndatasize()
55             returndatacopy(0, 0, retSz)
56 
57             switch result
58             // delegatecall returns 0 on error.
59             case 0 {
60                 revert(0, retSz)
61             }
62             default {
63                 return(0, retSz)
64             }
65         }
66     }
67 
68     /**
69      * @dev Function that is run as the first thing in the fallback function.
70      * Can be redefined in derived contracts to add functionality.
71      * Redefinitions must call super._beforeFallback().
72      */
73     function _beforeFallback() internal virtual {}
74 
75     /**
76      * @dev fallback implementation.
77      * Extracted to enable manual triggering.
78      */
79     function _fallback() internal {
80         _beforeFallback();
81         _delegate(_implementation());
82     }
83 }
84 
85 /**
86  * Utility library of inline functions on addresses
87  *
88  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
89  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
90  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
91  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
92  */
93 library ZOSLibAddress {
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
117 /**
118  * @title BaseUpgradeabilityProxy
119  * @dev This contract implements a proxy that allows to change the
120  * implementation address to which it will delegate.
121  * Such a change is called an implementation upgrade.
122  */
123 contract BaseUpgradeabilityProxy is Proxy {
124     /**
125      * @dev Emitted when the implementation is upgraded.
126      * @param implementation Address of the new implementation.
127      */
128     event Upgraded(address indexed implementation);
129 
130     /**
131      * @dev Storage slot with the address of the current implementation.
132      * This is the keccak-256 hash of "eip1967.proxy.implementation", and is
133      * validated in the constructor.
134      */
135     bytes32 internal constant IMPLEMENTATION_SLOT =
136         0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
137 
138     /**
139      * @dev Returns the current implementation.
140      * @return impl Address of the current implementation
141      */
142     function _implementation() internal view override returns (address impl) {
143         bytes32 slot = IMPLEMENTATION_SLOT;
144         assembly {
145             impl := sload(slot)
146         }
147     }
148 
149     /**
150      * @dev Upgrades the proxy to a new implementation.
151      * @param newImplementation Address of the new implementation.
152      */
153     function _upgradeTo(address newImplementation) internal {
154         _setImplementation(newImplementation);
155         emit Upgraded(newImplementation);
156     }
157 
158     /**
159      * @dev Sets the implementation address of the proxy.
160      * @param newImplementation Address of the new implementation.
161      */
162     function _setImplementation(address newImplementation) internal {
163         require(
164             ZOSLibAddress.isContract(newImplementation),
165             "Cannot set a proxy implementation to a non-contract address"
166         );
167 
168         bytes32 slot = IMPLEMENTATION_SLOT;
169 
170         assembly {
171             sstore(slot, newImplementation)
172         }
173     }
174 }
175 
176 
177 /**
178  * @title BaseAdminUpgradeabilityProxy
179  * @dev This contract combines an upgradeability proxy with an authorization
180  * mechanism for administrative tasks.
181  * All external functions in this contract must be guarded by the
182  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
183  * feature proposal that would enable this to be done automatically.
184  */
185 contract TransparentUpgradeableProxy is BaseUpgradeabilityProxy {
186     //ERC-1967 bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1)
187     bytes32 internal constant ADMIN_SLOT =
188         0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
189 
190     /**
191      * @dev Contract constructor.
192      * @param logic Address of the initial implementation.
193      * @param newAdmin Admin of the proxy contract
194      * @param data Data to send as msg.data to the implementation to initialize the proxied contract.
195      * It should include the signature and the parameters of the function to be called, as described in
196      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
197      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
198      */
199     constructor(address logic, address newAdmin, bytes memory data) payable {
200         assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
201         assert(ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
202         _setAdmin(newAdmin);
203         _setImplementation(logic);
204         if (data.length > 0) {
205             (bool success, ) = logic.delegatecall(data);
206             require(success);
207         }
208     }
209 
210     /**
211      * @dev Emitted when the administration has been transferred.
212      * @param previousAdmin Address of the previous admin.
213      * @param newAdmin Address of the new admin.
214      */
215     event AdminChanged(address previousAdmin, address newAdmin);
216 
217     /**
218      * @dev Modifier to check whether the `msg.sender` is the admin.
219      * If it is, it will run the function. Otherwise, it will delegate the call
220      * to the implementation.
221      */
222     modifier ifAdmin() {
223         if (msg.sender == _admin()) {
224             _;
225         } else {
226             _fallback();
227         }
228     }
229 
230     /**
231      * @return The address of the proxy admin.
232      */
233     // function admin() external ifAdmin returns (address) { TODO
234     function admin() external view returns (address) {
235         return _admin();
236     }
237 
238     /**
239      * @return The address of the implementation.
240      */
241     // function implementation() external ifAdmin returns (address) { TODO
242     function implementation() external view returns (address) {
243         return _implementation();
244     }
245 
246     /**
247      * @dev Changes the admin of the proxy.
248      * Only the current admin can call this function.
249      * @param newAdmin Address to transfer proxy administration to.
250      */
251     function changeAdmin(address newAdmin) external ifAdmin {
252         require(
253             newAdmin != address(0),
254             "Cannot change the admin of a proxy to the zero address"
255         );
256         emit AdminChanged(_admin(), newAdmin);
257         _setAdmin(newAdmin);
258     }
259 
260     /**
261      * @dev Upgrade the backing implementation of the proxy.
262      * Only the admin can call this function.
263      * @param newImplementation Address of the new implementation.
264      */
265     function upgradeTo(address newImplementation) external ifAdmin {
266         _upgradeTo(newImplementation);
267     }
268 
269     /**
270      * @dev Upgrade the backing implementation of the proxy and call a function
271      * on the new implementation.
272      * This is useful to initialize the proxied contract.
273      * @param newImplementation Address of the new implementation.
274      * @param data Data to send as msg.data in the low level call.
275      * It should include the signature and the parameters of the function to be called, as described in
276      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
277      */
278     function upgradeToAndCall(address newImplementation, bytes calldata data)
279         external
280         payable
281         ifAdmin
282     {
283         _upgradeTo(newImplementation);
284         (bool success, ) = newImplementation.delegatecall(data);
285         require(success);
286     }
287 
288     /**
289      * @return adm The admin slot.
290      */
291     function _admin() internal view returns (address adm) {
292         bytes32 slot = ADMIN_SLOT;
293         assembly {
294             adm := sload(slot)
295         }
296     }
297 
298     /**
299      * @dev Sets the address of the proxy admin.
300      * @param newAdmin Address of the new proxy admin.
301      */
302     function _setAdmin(address newAdmin) internal {
303         bytes32 slot = ADMIN_SLOT;
304 
305         assembly {
306             sstore(slot, newAdmin)
307         }
308     }
309 
310     /**
311      * @dev Only fall back when the sender is not the admin.
312      */
313     function _beforeFallback() internal override {
314         require(
315             msg.sender != _admin(),
316             "Cannot call fallback function from the proxy admin"
317         );
318         super._beforeFallback();
319     }
320 }
321 
322 contract TransparentUpgradeableProxyImplementation is TransparentUpgradeableProxy {
323     
324     constructor(address logic, address admin, bytes memory data) TransparentUpgradeableProxy(logic, admin, data) {
325 
326     }
327 }