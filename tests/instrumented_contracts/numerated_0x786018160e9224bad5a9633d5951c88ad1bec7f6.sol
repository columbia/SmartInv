1 // File: contracts/zeppelin/Proxy.sol
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
15      * Implemented entirely in `_fallback`.
16      */
17     function () external payable {
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
34         // Copy msg.data. We take full control of memory in this inline assembly
35         // block because it will not return to Solidity code. We overwrite the
36         // Solidity scratch pad at memory position 0.
37             calldatacopy(0, 0, calldatasize)
38 
39         // Call the implementation.
40         // out and outsize are 0 because we don't know the size yet.
41             let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
42 
43         // Copy the returned data.
44             returndatacopy(0, 0, returndatasize)
45 
46             switch result
47             // delegatecall returns 0 on error.
48             case 0 { revert(0, returndatasize) }
49             default { return(0, returndatasize) }
50         }
51     }
52 
53     /**
54      * @dev Function that is run as the first thing in the fallback function.
55      * Can be redefined in derived contracts to add functionality.
56      * Redefinitions must call super._willFallback().
57      */
58     function _willFallback() internal {
59     }
60 
61     /**
62      * @dev fallback implementation.
63      * Extracted to enable manual triggering.
64      */
65     function _fallback() internal {
66         _willFallback();
67         _delegate(_implementation());
68     }
69 }
70 
71 // File: contracts/zeppelin/AddressUtils.sol
72 
73 pragma solidity ^0.5.0;
74 
75 /**
76  * Utility library of inline functions on addresses
77  */
78 library AddressUtils {
79 
80     /**
81      * Returns whether the target address is a contract
82      * @dev This function will return false if invoked during the constructor of a contract,
83      * as the code is not actually created until after the constructor finishes.
84      * @param addr address to check
85      * @return whether the target address is a contract
86      */
87     function isContract(address addr) internal view returns (bool) {
88         uint256 size;
89         // XXX Currently there is no better way to check if there is a contract in an address
90         // than to check the size of the code at that address.
91         // See https://ethereum.stackexchange.com/a/14016/36603
92         // for more details about how this works.
93         // TODO Check this again before the Serenity release, because all addresses will be
94         // contracts then.
95         // solium-disable-next-line security/no-inline-assembly
96         assembly { size := extcodesize(addr) }
97         return size > 0;
98     }
99 
100 }
101 
102 // File: contracts/zeppelin/UpgradeabilityProxy.sol
103 
104 pragma solidity ^0.5.0;
105 
106 
107 
108 /**
109  * @title UpgradeabilityProxy
110  * @dev This contract implements a proxy that allows to change the
111  * implementation address to which it will delegate.
112  * Such a change is called an implementation upgrade.
113  */
114 contract UpgradeabilityProxy is Proxy {
115     /**
116      * @dev Emitted when the implementation is upgraded.
117      * @param implementation Address of the new implementation.
118      */
119     event Upgraded(address implementation);
120 
121     /**
122      * @dev Storage slot with the address of the current implementation.
123      * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
124      * validated in the constructor.
125      */
126     bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
127 
128     /**
129      * @dev Contract constructor.
130      * @param _implementation Address of the initial implementation.
131      */
132     constructor(address _implementation) public {
133         assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
134 
135         _setImplementation(_implementation);
136     }
137 
138     /**
139      * @dev Returns the current implementation.
140      * @return Address of the current implementation
141      */
142     function _implementation() internal view returns (address impl) {
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
162     function _setImplementation(address newImplementation) private {
163         require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
164 
165         bytes32 slot = IMPLEMENTATION_SLOT;
166 
167         assembly {
168             sstore(slot, newImplementation)
169         }
170     }
171 }
172 
173 // File: contracts/zeppelin/AdminUpgradeabilityProxy.sol
174 
175 pragma solidity ^0.5.0;
176 
177 
178 /**
179  * @title AdminUpgradeabilityProxy
180  * @dev This contract combines an upgradeability proxy with an authorization
181  * mechanism for administrative tasks.
182  * All external functions in this contract must be guarded by the
183  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
184  * feature proposal that would enable this to be done automatically.
185  */
186 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
187     /**
188      * @dev Emitted when the administration has been transferred.
189      * @param previousAdmin Address of the previous admin.
190      * @param newAdmin Address of the new admin.
191      */
192     event AdminChanged(address previousAdmin, address newAdmin);
193 
194     /**
195      * @dev Storage slot with the admin of the contract.
196      * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
197      * validated in the constructor.
198      */
199     bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
200 
201     /**
202      * @dev Modifier to check whether the `msg.sender` is the admin.
203      * If it is, it will run the function. Otherwise, it will delegate the call
204      * to the implementation.
205      */
206     modifier ifAdmin() {
207         if (msg.sender == _admin()) {
208             _;
209         } else {
210             _fallback();
211         }
212     }
213 
214     /**
215      * Contract constructor.
216      * It sets the `msg.sender` as the proxy administrator.
217      * @param _implementation address of the initial implementation.
218      */
219     constructor(address _implementation) UpgradeabilityProxy(_implementation) public {
220         assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
221 
222         _setAdmin(msg.sender);
223     }
224 
225     /**
226      * @return The address of the proxy admin.
227      */
228     function admin() external view returns (address) {
229         if (msg.sender == _admin()) {
230             return _admin();
231         }
232         return address(0);
233     }
234 
235     /**
236      * @return The address of the implementation.
237      */
238     function implementation() external view returns (address) {
239         if (msg.sender == _admin()) {
240             return _implementation();
241         }
242         return address(0);
243     }
244 
245     /**
246      * @dev Changes the admin of the proxy.
247      * Only the current admin can call this function.
248      * @param newAdmin Address to transfer proxy administration to.
249      */
250     function changeAdmin(address newAdmin) external ifAdmin {
251         require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
252         emit AdminChanged(_admin(), newAdmin);
253         _setAdmin(newAdmin);
254     }
255 
256     /**
257      * @dev Upgrade the backing implementation of the proxy.
258      * Only the admin can call this function.
259      * @param newImplementation Address of the new implementation.
260      */
261     function upgradeTo(address newImplementation) external ifAdmin {
262         _upgradeTo(newImplementation);
263     }
264 
265     /**
266      * @dev Upgrade the backing implementation of the proxy and call a function
267      * on the new implementation.
268      * This is useful to initialize the proxied contract.
269      * @param newImplementation Address of the new implementation.
270      * @param data Data to send as msg.data in the low level call.
271      * It should include the signature and the parameters of the function to be
272      * called, as described in
273      * https://solidity.readthedocs.io/en/develop/abi-spec.html#function-selector-and-argument-encoding.
274      */
275     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
276         _upgradeTo(newImplementation);
277         (bool success,) = newImplementation.delegatecall(data);
278         require(success);
279     }
280 
281     /**
282      * @return The admin slot.
283      */
284     function _admin() internal view returns (address adm) {
285         bytes32 slot = ADMIN_SLOT;
286         assembly {
287             adm := sload(slot)
288         }
289     }
290 
291     /**
292      * @dev Sets the address of the proxy admin.
293      * @param newAdmin Address of the new proxy admin.
294      */
295     function _setAdmin(address newAdmin) internal {
296         bytes32 slot = ADMIN_SLOT;
297 
298         assembly {
299             sstore(slot, newAdmin)
300         }
301     }
302 
303     /**
304      * @dev Only fall back when the sender is not the admin.
305      */
306     function _willFallback() internal {
307         require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
308         super._willFallback();
309     }
310 }