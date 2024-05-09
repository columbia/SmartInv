1 pragma solidity 0.5.16;
2 
3 
4 /**
5  * @title Proxy
6  * @dev Implements delegation of calls to other contracts, with proper
7  * forwarding of return values and bubbling of failures.
8  * It defines a fallback function that delegates all calls to the address
9  * returned by the abstract _implementation() internal function.
10  */
11 contract Proxy {
12   /**
13    * @dev Fallback function.
14    * Implemented entirely in `_fallback`.
15    */
16   function () payable external {
17     _fallback();
18   }
19 
20   /**
21    * @return The Address of the implementation.
22    */
23   function _implementation() internal view returns (address);
24 
25   /**
26    * @dev Delegates execution to an implementation contract.
27    * This is a low level function that doesn't return to its internal call site.
28    * It will return to the external caller whatever the implementation returns.
29    * @param implementation Address to delegate.
30    */
31   function _delegate(address implementation) internal {
32     assembly {
33       // Copy msg.data. We take full control of memory in this inline assembly
34       // block because it will not return to Solidity code. We overwrite the
35       // Solidity scratch pad at memory position 0.
36       calldatacopy(0, 0, calldatasize)
37 
38       // Call the implementation.
39       // out and outsize are 0 because we don't know the size yet.
40       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
41 
42       // Copy the returned data.
43       returndatacopy(0, 0, returndatasize)
44 
45       switch result
46       // delegatecall returns 0 on error.
47       case 0 { revert(0, returndatasize) }
48       default { return(0, returndatasize) }
49     }
50   }
51 
52   /**
53    * @dev Function that is run as the first thing in the fallback function.
54    * Can be redefined in derived contracts to add functionality.
55    * Redefinitions must call super._willFallback().
56    */
57   function _willFallback() internal {
58   }
59 
60   /**
61    * @dev fallback implementation.
62    * Extracted to enable manual triggering.
63    */
64   function _fallback() internal {
65     _willFallback();
66     _delegate(_implementation());
67   }
68 }
69 
70 /**
71  * Utility library of inline functions on addresses
72  *
73  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
74  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
75  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
76  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
77  */
78 library OpenZeppelinUpgradesAddress {
79     /**
80      * Returns whether the target address is a contract
81      * @dev This function will return false if invoked during the constructor of a contract,
82      * as the code is not actually created until after the constructor finishes.
83      * @param account address of the account to check
84      * @return whether the target address is a contract
85      */
86     function isContract(address account) internal view returns (bool) {
87         uint256 size;
88         // XXX Currently there is no better way to check if there is a contract in an address
89         // than to check the size of the code at that address.
90         // See https://ethereum.stackexchange.com/a/14016/36603
91         // for more details about how this works.
92         // TODO Check this again before the Serenity release, because all addresses will be
93         // contracts then.
94         // solhint-disable-next-line no-inline-assembly
95         assembly { size := extcodesize(account) }
96         return size > 0;
97     }
98 }
99 
100 /**
101  * @title BaseUpgradeabilityProxy
102  * @dev This contract implements a proxy that allows to change the
103  * implementation address to which it will delegate.
104  * Such a change is called an implementation upgrade.
105  */
106 contract BaseUpgradeabilityProxy is Proxy {
107   /**
108    * @dev Emitted when the implementation is upgraded.
109    * @param implementation Address of the new implementation.
110    */
111   event Upgraded(address indexed implementation);
112 
113   /**
114    * @dev Storage slot with the address of the current implementation.
115    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
116    * validated in the constructor.
117    */
118   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
119 
120   /**
121    * @dev Returns the current implementation.
122    * @return Address of the current implementation
123    */
124   function _implementation() internal view returns (address impl) {
125     bytes32 slot = IMPLEMENTATION_SLOT;
126     assembly {
127       impl := sload(slot)
128     }
129   }
130 
131   /**
132    * @dev Upgrades the proxy to a new implementation.
133    * @param newImplementation Address of the new implementation.
134    */
135   function _upgradeTo(address newImplementation) internal {
136     _setImplementation(newImplementation);
137     emit Upgraded(newImplementation);
138   }
139 
140   /**
141    * @dev Sets the implementation address of the proxy.
142    * @param newImplementation Address of the new implementation.
143    */
144   function _setImplementation(address newImplementation) internal {
145     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
146 
147     bytes32 slot = IMPLEMENTATION_SLOT;
148 
149     assembly {
150       sstore(slot, newImplementation)
151     }
152   }
153 }
154 
155 /**
156  * @title UpgradeabilityProxy
157  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
158  * implementation and init data.
159  */
160 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
161   /**
162    * @dev Contract constructor.
163    * @param _logic Address of the initial implementation.
164    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
165    * It should include the signature and the parameters of the function to be called, as described in
166    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
167    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
168    */
169   constructor(address _logic, bytes memory _data) public payable {
170     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
171     _setImplementation(_logic);
172     if(_data.length > 0) {
173       (bool success,) = _logic.delegatecall(_data);
174       require(success);
175     }
176   }  
177 }
178 
179 /**
180  * @title BaseAdminUpgradeabilityProxy
181  * @dev This contract combines an upgradeability proxy with an authorization
182  * mechanism for administrative tasks.
183  * All external functions in this contract must be guarded by the
184  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
185  * feature proposal that would enable this to be done automatically.
186  */
187 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
188   /**
189    * @dev Emitted when the administration has been transferred.
190    * @param previousAdmin Address of the previous admin.
191    * @param newAdmin Address of the new admin.
192    */
193   event AdminChanged(address previousAdmin, address newAdmin);
194 
195   /**
196    * @dev Storage slot with the admin of the contract.
197    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
198    * validated in the constructor.
199    */
200 
201   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
202 
203   /**
204    * @dev Modifier to check whether the `msg.sender` is the admin.
205    * If it is, it will run the function. Otherwise, it will delegate the call
206    * to the implementation.
207    */
208   modifier ifAdmin() {
209     if (msg.sender == _admin()) {
210       _;
211     } else {
212       _fallback();
213     }
214   }
215 
216   /**
217    * @return The address of the proxy admin.
218    */
219   function admin() external ifAdmin returns (address) {
220     return _admin();
221   }
222 
223   /**
224    * @return The address of the implementation.
225    */
226   function implementation() external ifAdmin returns (address) {
227     return _implementation();
228   }
229 
230   /**
231    * @dev Changes the admin of the proxy.
232    * Only the current admin can call this function.
233    * @param newAdmin Address to transfer proxy administration to.
234    */
235   function changeAdmin(address newAdmin) external ifAdmin {
236     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
237     emit AdminChanged(_admin(), newAdmin);
238     _setAdmin(newAdmin);
239   }
240 
241   /**
242    * @dev Upgrade the backing implementation of the proxy.
243    * Only the admin can call this function.
244    * @param newImplementation Address of the new implementation.
245    */
246   function upgradeTo(address newImplementation) external ifAdmin {
247     _upgradeTo(newImplementation);
248   }
249 
250   /**
251    * @dev Upgrade the backing implementation of the proxy and call a function
252    * on the new implementation.
253    * This is useful to initialize the proxied contract.
254    * @param newImplementation Address of the new implementation.
255    * @param data Data to send as msg.data in the low level call.
256    * It should include the signature and the parameters of the function to be called, as described in
257    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
258    */
259   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
260     _upgradeTo(newImplementation);
261     (bool success,) = newImplementation.delegatecall(data);
262     require(success);
263   }
264 
265   /**
266    * @return The admin slot.
267    */
268   function _admin() internal view returns (address adm) {
269     bytes32 slot = ADMIN_SLOT;
270     assembly {
271       adm := sload(slot)
272     }
273   }
274 
275   /**
276    * @dev Sets the address of the proxy admin.
277    * @param newAdmin Address of the new proxy admin.
278    */
279   function _setAdmin(address newAdmin) internal {
280     bytes32 slot = ADMIN_SLOT;
281 
282     assembly {
283       sstore(slot, newAdmin)
284     }
285   }
286 
287   /**
288    * @dev Only fall back when the sender is not the admin.
289    */
290   function _willFallback() internal {
291     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
292     super._willFallback();
293   }
294 }
295 
296 /**
297  * @title InitializableUpgradeabilityProxy
298  * @dev Extends BaseUpgradeabilityProxy with an initializer for initializing
299  * implementation and init data.
300  */
301 contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
302   /**
303    * @dev Contract initializer.
304    * @param _logic Address of the initial implementation.
305    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
306    * It should include the signature and the parameters of the function to be called, as described in
307    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
308    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
309    */
310   function initialize(address _logic, bytes memory _data) public payable {
311     require(_implementation() == address(0));
312     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
313     _setImplementation(_logic);
314     if(_data.length > 0) {
315       (bool success,) = _logic.delegatecall(_data);
316       require(success);
317     }
318   }  
319 }
320 
321 contract InitializableAdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, InitializableUpgradeabilityProxy {
322   /**
323    * Contract initializer.
324    * @param _logic address of the initial implementation.
325    * @param _admin Address of the proxy administrator.
326    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
327    * It should include the signature and the parameters of the function to be called, as described in
328    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
329    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
330    */
331   function initialize(address _logic, address _admin, bytes memory _data) public payable {
332     require(_implementation() == address(0));
333     InitializableUpgradeabilityProxy.initialize(_logic, _data);
334     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
335     _setAdmin(_admin);
336   }
337 }
338 
339 /**
340  * @notice MassetProxy delegates calls to a Masset implementation
341  * @dev     Extending on OpenZeppelin's InitializableAdminUpgradabilityProxy
342  * means that the proxy is upgradable through a ProxyAdmin. MassetProxy upgrades
343  * are implemented by a DelayedProxyAdmin, which enforces a 1 week opt-out period.
344  * All upgrades are governed through the current mStable governance.
345  */
346 contract MassetProxy is InitializableAdminUpgradeabilityProxy {
347 }