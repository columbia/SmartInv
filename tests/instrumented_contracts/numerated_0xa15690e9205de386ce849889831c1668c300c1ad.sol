1 pragma solidity ^0.5.0;
2 
3 /**
4  * Utility library of inline functions on addresses
5  *
6  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
7  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
8  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
9  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
10  */
11 library ZOSLibAddress {
12     /**
13      * Returns whether the target address is a contract
14      * @dev This function will return false if invoked during the constructor of a contract,
15      * as the code is not actually created until after the constructor finishes.
16      * @param account address of the account to check
17      * @return whether the target address is a contract
18      */
19     function isContract(address account) internal view returns (bool) {
20         uint256 size;
21         // XXX Currently there is no better way to check if there is a contract in an address
22         // than to check the size of the code at that address.
23         // See https://ethereum.stackexchange.com/a/14016/36603
24         // for more details about how this works.
25         // TODO Check this again before the Serenity release, because all addresses will be
26         // contracts then.
27         // solhint-disable-next-line no-inline-assembly
28         assembly { size := extcodesize(account) }
29         return size > 0;
30     }
31 }
32 
33 /**
34  * @title Proxy
35  * @dev Implements delegation of calls to other contracts, with proper
36  * forwarding of return values and bubbling of failures.
37  * It defines a fallback function that delegates all calls to the address
38  * returned by the abstract _implementation() internal function.
39  */
40 contract Proxy {
41     /**
42      * @dev Fallback function.
43      * Implemented entirely in `_fallback`.
44      */
45     function () payable external {
46         _fallback();
47     }
48 
49     /**
50      * @return The Address of the implementation.
51      */
52     function _implementation() internal view returns (address);
53 
54     /**
55      * @dev Delegates execution to an implementation contract.
56      * This is a low level function that doesn't return to its internal call site.
57      * It will return to the external caller whatever the implementation returns.
58      * @param implementation Address to delegate.
59      */
60     function _delegate(address implementation) internal {
61         assembly {
62         // Copy msg.data. We take full control of memory in this inline assembly
63         // block because it will not return to Solidity code. We overwrite the
64         // Solidity scratch pad at memory position 0.
65             calldatacopy(0, 0, calldatasize)
66 
67         // Call the implementation.
68         // out and outsize are 0 because we don't know the size yet.
69             let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
70 
71         // Copy the returned data.
72             returndatacopy(0, 0, returndatasize)
73 
74             switch result
75             // delegatecall returns 0 on error.
76             case 0 { revert(0, returndatasize) }
77             default { return(0, returndatasize) }
78         }
79     }
80 
81     /**
82      * @dev Function that is run as the first thing in the fallback function.
83      * Can be redefined in derived contracts to add functionality.
84      * Redefinitions must call super._willFallback().
85      */
86     function _willFallback() internal {
87     }
88 
89     /**
90      * @dev fallback implementation.
91      * Extracted to enable manual triggering.
92      */
93     function _fallback() internal {
94         _willFallback();
95         _delegate(_implementation());
96     }
97 }
98 
99 /**
100  * @title BaseUpgradeabilityProxy
101  * @dev This contract implements a proxy that allows to change the
102  * implementation address to which it will delegate.
103  * Such a change is called an implementation upgrade.
104  */
105 contract BaseUpgradeabilityProxy is Proxy {
106     /**
107      * @dev Emitted when the implementation is upgraded.
108      * @param implementation Address of the new implementation.
109      */
110     event Upgraded(address indexed implementation);
111 
112     /**
113      * @dev Storage slot with the address of the current implementation.
114      * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
115      * validated in the constructor.
116      */
117     bytes32 internal constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
118 
119     /**
120      * @dev Returns the current implementation.
121      * @return Address of the current implementation
122      */
123     function _implementation() internal view returns (address impl) {
124         bytes32 slot = IMPLEMENTATION_SLOT;
125         assembly {
126             impl := sload(slot)
127         }
128     }
129 
130     /**
131      * @dev Upgrades the proxy to a new implementation.
132      * @param newImplementation Address of the new implementation.
133      */
134     function _upgradeTo(address newImplementation) internal {
135         _setImplementation(newImplementation);
136         emit Upgraded(newImplementation);
137     }
138 
139     /**
140      * @dev Sets the implementation address of the proxy.
141      * @param newImplementation Address of the new implementation.
142      */
143     function _setImplementation(address newImplementation) internal {
144         require(ZOSLibAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
145 
146         bytes32 slot = IMPLEMENTATION_SLOT;
147 
148         assembly {
149             sstore(slot, newImplementation)
150         }
151     }
152 }
153 
154 /**
155  * @title UpgradeabilityProxy
156  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
157  * implementation and init data.
158  */
159 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
160     /**
161      * @dev Contract constructor.
162      * @param _logic Address of the initial implementation.
163      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
164      * It should include the signature and the parameters of the function to be called, as described in
165      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
166      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
167      */
168     constructor(address _logic, bytes memory _data) public payable {
169         assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
170         _setImplementation(_logic);
171         if(_data.length > 0) {
172             (bool success,) = _logic.delegatecall(_data);
173             require(success);
174         }
175     }
176 }
177 
178 /**
179  * @title BaseAdminUpgradeabilityProxy
180  * @dev This contract combines an upgradeability proxy with an authorization
181  * mechanism for administrative tasks.
182  * All external functions in this contract must be guarded by the
183  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
184  * feature proposal that would enable this to be done automatically.
185  */
186 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
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
199     bytes32 internal constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
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
215      * @return The address of the proxy admin.
216      */
217     function admin() external ifAdmin returns (address) {
218         return _admin();
219     }
220 
221     /**
222      * @return The address of the implementation.
223      */
224     function implementation() external ifAdmin returns (address) {
225         return _implementation();
226     }
227 
228     /**
229      * @dev Changes the admin of the proxy.
230      * Only the current admin can call this function.
231      * @param newAdmin Address to transfer proxy administration to.
232      */
233     function changeAdmin(address newAdmin) external ifAdmin {
234         require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
235         emit AdminChanged(_admin(), newAdmin);
236         _setAdmin(newAdmin);
237     }
238 
239     /**
240      * @dev Upgrade the backing implementation of the proxy.
241      * Only the admin can call this function.
242      * @param newImplementation Address of the new implementation.
243      */
244     function upgradeTo(address newImplementation) external ifAdmin {
245         _upgradeTo(newImplementation);
246     }
247 
248     /**
249      * @dev Upgrade the backing implementation of the proxy and call a function
250      * on the new implementation.
251      * This is useful to initialize the proxied contract.
252      * @param newImplementation Address of the new implementation.
253      * @param data Data to send as msg.data in the low level call.
254      * It should include the signature and the parameters of the function to be called, as described in
255      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
256      */
257     function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
258         _upgradeTo(newImplementation);
259         (bool success,) = newImplementation.delegatecall(data);
260         require(success);
261     }
262 
263     /**
264      * @return The admin slot.
265      */
266     function _admin() internal view returns (address adm) {
267         bytes32 slot = ADMIN_SLOT;
268         assembly {
269             adm := sload(slot)
270         }
271     }
272 
273     /**
274      * @dev Sets the address of the proxy admin.
275      * @param newAdmin Address of the new proxy admin.
276      */
277     function _setAdmin(address newAdmin) internal {
278         bytes32 slot = ADMIN_SLOT;
279 
280         assembly {
281             sstore(slot, newAdmin)
282         }
283     }
284 
285     /**
286      * @dev Only fall back when the sender is not the admin.
287      */
288     function _willFallback() internal {
289         require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
290         super._willFallback();
291     }
292 }
293 
294 /**
295  * @title AdminUpgradeabilityProxy
296  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for
297  * initializing the implementation, admin, and init data.
298  */
299 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
300     /**
301      * Contract constructor.
302      * @param _logic address of the initial implementation.
303      * @param _admin Address of the proxy administrator.
304      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
305      * It should include the signature and the parameters of the function to be called, as described in
306      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
307      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
308      */
309     constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
310         assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
311         _setAdmin(_admin);
312     }
313 }
314 
315 contract POWTokenProxy is AdminUpgradeabilityProxy {
316     constructor(address _implementation, address _admin) public AdminUpgradeabilityProxy(_implementation, _admin, new bytes(0)) {
317     }
318 }