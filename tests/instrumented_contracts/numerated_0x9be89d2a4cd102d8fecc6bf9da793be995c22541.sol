1 // File: contracts/ethereum/AdminUpgradeabilityProxy.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2019-09-09
5 */
6 
7 // File: contracts/zeppelin/Proxy.sol
8 
9 pragma solidity 0.4.24;
10 
11 /**
12  * @title Proxy
13  * @dev Implements delegation of calls to other contracts, with proper
14  * forwarding of return values and bubbling of failures.
15  * It defines a fallback function that delegates all calls to the address
16  * returned by the abstract _implementation() internal function.
17  */
18 contract Proxy {
19     /**
20      * @dev Fallback function.
21      * Implemented entirely in `_fallback`.
22      */
23     function () payable external {
24         _fallback();
25     }
26 
27     /**
28      * @return The Address of the implementation.
29      */
30     function _implementation() internal view returns (address);
31 
32     /**
33      * @dev Delegates execution to an implementation contract.
34      * This is a low level function that doesn't return to its internal call site.
35      * It will return to the external caller whatever the implementation returns.
36      * @param implementation Address to delegate.
37      */
38     function _delegate(address implementation) internal {
39         assembly {
40         // Copy msg.data. We take full control of memory in this inline assembly
41         // block because it will not return to Solidity code. We overwrite the
42         // Solidity scratch pad at memory position 0.
43             calldatacopy(0, 0, calldatasize)
44 
45         // Call the implementation.
46         // out and outsize are 0 because we don't know the size yet.
47             let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
48 
49         // Copy the returned data.
50             returndatacopy(0, 0, returndatasize)
51 
52             switch result
53             // delegatecall returns 0 on error.
54             case 0 { revert(0, returndatasize) }
55             default { return(0, returndatasize) }
56         }
57     }
58 
59     /**
60      * @dev Function that is run as the first thing in the fallback function.
61      * Can be redefined in derived contracts to add functionality.
62      * Redefinitions must call super._willFallback().
63      */
64     function _willFallback() internal {
65     }
66 
67     /**
68      * @dev fallback implementation.
69      * Extracted to enable manual triggering.
70      */
71     function _fallback() internal {
72         _willFallback();
73         _delegate(_implementation());
74     }
75 }
76 
77 // File: contracts/zeppelin/AddressUtils.sol
78 
79 pragma solidity 0.4.24;
80 
81 
82 /**
83  * Utility library of inline functions on addresses
84  */
85 library AddressUtils {
86 
87     /**
88      * Returns whether the target address is a contract
89      * @dev This function will return false if invoked during the constructor of a contract,
90      * as the code is not actually created until after the constructor finishes.
91      * @param addr address to check
92      * @return whether the target address is a contract
93      */
94     function isContract(address addr) internal view returns (bool) {
95         uint256 size;
96         // XXX Currently there is no better way to check if there is a contract in an address
97         // than to check the size of the code at that address.
98         // See https://ethereum.stackexchange.com/a/14016/36603
99         // for more details about how this works.
100         // TODO Check this again before the Serenity release, because all addresses will be
101         // contracts then.
102         // solium-disable-next-line security/no-inline-assembly
103         assembly { size := extcodesize(addr) }
104         return size > 0;
105     }
106 
107 }
108 
109 // File: contracts/zeppelin/UpgradeabilityProxy.sol
110 
111 pragma solidity 0.4.24;
112 
113 
114 
115 /**
116  * @title UpgradeabilityProxy
117  * @dev This contract implements a proxy that allows to change the
118  * implementation address to which it will delegate.
119  * Such a change is called an implementation upgrade.
120  */
121 contract UpgradeabilityProxy is Proxy {
122     /**
123      * @dev Emitted when the implementation is upgraded.
124      * @param implementation Address of the new implementation.
125      */
126     event Upgraded(address implementation);
127 
128     /**
129      * @dev Storage slot with the address of the current implementation.
130      * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
131      * validated in the constructor.
132      */
133     bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
134 
135     /**
136      * @dev Contract constructor.
137      * @param _implementation Address of the initial implementation.
138      */
139     constructor(address _implementation) public {
140         assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
141 
142         _setImplementation(_implementation);
143     }
144 
145     /**
146      * @dev Returns the current implementation.
147      * @return Address of the current implementation
148      */
149     function _implementation() internal view returns (address impl) {
150         bytes32 slot = IMPLEMENTATION_SLOT;
151         assembly {
152             impl := sload(slot)
153         }
154     }
155 
156     /**
157      * @dev Upgrades the proxy to a new implementation.
158      * @param newImplementation Address of the new implementation.
159      */
160     function _upgradeTo(address newImplementation) internal {
161         _setImplementation(newImplementation);
162         emit Upgraded(newImplementation);
163     }
164 
165     /**
166      * @dev Sets the implementation address of the proxy.
167      * @param newImplementation Address of the new implementation.
168      */
169     function _setImplementation(address newImplementation) private {
170         require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
171 
172         bytes32 slot = IMPLEMENTATION_SLOT;
173 
174         assembly {
175             sstore(slot, newImplementation)
176         }
177     }
178 }
179 
180 // File: contracts/zeppelin/AdminUpgradeabilityProxy.sol
181 
182 pragma solidity 0.4.24;
183 
184 
185 /**
186  * @title AdminUpgradeabilityProxy
187  * @dev This contract combines an upgradeability proxy with an authorization
188  * mechanism for administrative tasks.
189  * All external functions in this contract must be guarded by the
190  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
191  * feature proposal that would enable this to be done automatically.
192  */
193 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
194     /**
195      * @dev Emitted when the administration has been transferred.
196      * @param previousAdmin Address of the previous admin.
197      * @param newAdmin Address of the new admin.
198      */
199     event AdminChanged(address previousAdmin, address newAdmin);
200 
201     /**
202      * @dev Storage slot with the admin of the contract.
203      * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
204      * validated in the constructor.
205      */
206     bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
207 
208     /**
209      * @dev Modifier to check whether the `msg.sender` is the admin.
210      * If it is, it will run the function. Otherwise, it will delegate the call
211      * to the implementation.
212      */
213     modifier ifAdmin() {
214         if (msg.sender == _admin()) {
215             _;
216         } else {
217             _fallback();
218         }
219     }
220 
221     /**
222      * Contract constructor.
223      * It sets the `msg.sender` as the proxy administrator.
224      * @param _implementation address of the initial implementation.
225      */
226     constructor(address _implementation) UpgradeabilityProxy(_implementation) public {
227         assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
228 
229         _setAdmin(msg.sender);
230     }
231 
232     /**
233      * @return The address of the proxy admin.
234      */
235     function admin() external view ifAdmin returns (address) {
236         return _admin();
237     }
238 
239     /**
240      * @return The address of the implementation.
241      */
242     function implementation() external view ifAdmin returns (address) {
243         return _implementation();
244     }
245 
246     /**
247      * @dev Changes the admin of the proxy.
248      * Only the current admin can call this function.
249      * @param newAdmin Address to transfer proxy administration to.
250      */
251     function changeAdmin(address newAdmin) external ifAdmin {
252         require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
253         emit AdminChanged(_admin(), newAdmin);
254         _setAdmin(newAdmin);
255     }
256 
257     /**
258      * @dev Upgrade the backing implementation of the proxy.
259      * Only the admin can call this function.
260      * @param newImplementation Address of the new implementation.
261      */
262     function upgradeTo(address newImplementation) external ifAdmin {
263         _upgradeTo(newImplementation);
264     }
265 
266     /**
267      * @dev Upgrade the backing implementation of the proxy and call a function
268      * on the new implementation.
269      * This is useful to initialize the proxied contract.
270      * @param newImplementation Address of the new implementation.
271      * @param data Data to send as msg.data in the low level call.
272      * It should include the signature and the parameters of the function to be
273      * called, as described in
274      * https://solidity.readthedocs.io/en/develop/abi-spec.html#function-selector-and-argument-encoding.
275      */
276     function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
277         _upgradeTo(newImplementation);
278         require(address(this).call.value(msg.value)(data));
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