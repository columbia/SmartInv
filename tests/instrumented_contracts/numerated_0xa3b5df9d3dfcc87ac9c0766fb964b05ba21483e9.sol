1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 
6 /**
7  * @title Proxy
8  * @dev Implements delegation of calls to other contracts, with proper
9  * forwarding of return values and bubbling of failures.
10  * It defines a fallback function that delegates all calls to the address
11  * returned by the abstract _implementation() internal function.
12  */
13 abstract contract Proxy {
14   /**
15    * @dev Fallback function.
16    * Implemented entirely in `_fallback`.
17    */
18   fallback () payable external {
19     _fallback();
20   }
21   
22   receive () payable external {
23     _fallback();
24   }
25 
26   /**
27    * @return The Address of the implementation.
28    */
29   function _implementation() virtual internal view returns (address);
30 
31   /**
32    * @dev Delegates execution to an implementation contract.
33    * This is a low level function that doesn't return to its internal call site.
34    * It will return to the external caller whatever the implementation returns.
35    * @param implementation Address to delegate.
36    */
37   function _delegate(address implementation) internal {
38     assembly {
39       // Copy msg.data. We take full control of memory in this inline assembly
40       // block because it will not return to Solidity code. We overwrite the
41       // Solidity scratch pad at memory position 0.
42       calldatacopy(0, 0, calldatasize())
43 
44       // Call the implementation.
45       // out and outsize are 0 because we don't know the size yet.
46       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
47 
48       // Copy the returned data.
49       returndatacopy(0, 0, returndatasize())
50 
51       switch result
52       // delegatecall returns 0 on error.
53       case 0 { revert(0, returndatasize()) }
54       default { return(0, returndatasize()) }
55     }
56   }
57 
58   /**
59    * @dev Function that is run as the first thing in the fallback function.
60    * Can be redefined in derived contracts to add functionality.
61    * Redefinitions must call super._willFallback().
62    */
63   function _willFallback() virtual internal;
64 
65   /**
66    * @dev fallback implementation.
67    * Extracted to enable manual triggering.
68    */
69   function _fallback() internal {
70     if(OpenZeppelinUpgradesAddress.isContract(msg.sender) && msg.data.length == 0 && gasleft() <= 2300)         // for receive ETH only from other contract
71         return;
72     _willFallback();
73     _delegate(_implementation());
74   }
75 }
76 
77 
78 /**
79  * @title BaseUpgradeabilityProxy
80  * @dev This contract implements a proxy that allows to change the
81  * implementation address to which it will delegate.
82  * Such a change is called an implementation upgrade.
83  */
84 abstract contract BaseUpgradeabilityProxy is Proxy {
85   /**
86    * @dev Emitted when the implementation is upgraded.
87    * @param implementation Address of the new implementation.
88    */
89   event Upgraded(address indexed implementation);
90 
91   /**
92    * @dev Storage slot with the address of the current implementation.
93    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
94    * validated in the constructor.
95    */
96   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
97 
98   /**
99    * @dev Returns the current implementation.
100    * @return impl Address of the current implementation
101    */
102   function _implementation() override internal view returns (address impl) {
103     bytes32 slot = IMPLEMENTATION_SLOT;
104     assembly {
105       impl := sload(slot)
106     }
107   }
108 
109   /**
110    * @dev Upgrades the proxy to a new implementation.
111    * @param newImplementation Address of the new implementation.
112    */
113   function _upgradeTo(address newImplementation) internal {
114     _setImplementation(newImplementation);
115     emit Upgraded(newImplementation);
116   }
117 
118   /**
119    * @dev Sets the implementation address of the proxy.
120    * @param newImplementation Address of the new implementation.
121    */
122   function _setImplementation(address newImplementation) internal {
123     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
124 
125     bytes32 slot = IMPLEMENTATION_SLOT;
126 
127     assembly {
128       sstore(slot, newImplementation)
129     }
130   }
131 }
132 
133 
134 /**
135  * @title BaseAdminUpgradeabilityProxy
136  * @dev This contract combines an upgradeability proxy with an authorization
137  * mechanism for administrative tasks.
138  * All external functions in this contract must be guarded by the
139  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
140  * feature proposal that would enable this to be done automatically.
141  */
142 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
143   /**
144    * @dev Emitted when the administration has been transferred.
145    * @param previousAdmin Address of the previous admin.
146    * @param newAdmin Address of the new admin.
147    */
148   event AdminChanged(address previousAdmin, address newAdmin);
149 
150   /**
151    * @dev Storage slot with the admin of the contract.
152    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
153    * validated in the constructor.
154    */
155 
156   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
157 
158   /**
159    * @dev Modifier to check whether the `msg.sender` is the admin.
160    * If it is, it will run the function. Otherwise, it will delegate the call
161    * to the implementation.
162    */
163   modifier ifAdmin() {
164     if (msg.sender == _admin()) {
165       _;
166     } else {
167       _fallback();
168     }
169   }
170 
171   /**
172    * @return The address of the proxy admin.
173    */
174   function admin() external ifAdmin returns (address) {
175     return _admin();
176   }
177 
178   /**
179    * @return The address of the implementation.
180    */
181   function implementation() external ifAdmin returns (address) {
182     return _implementation();
183   }
184 
185   /**
186    * @dev Changes the admin of the proxy.
187    * Only the current admin can call this function.
188    * @param newAdmin Address to transfer proxy administration to.
189    */
190   function changeAdmin(address newAdmin) external ifAdmin {
191     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
192     emit AdminChanged(_admin(), newAdmin);
193     _setAdmin(newAdmin);
194   }
195 
196   /**
197    * @dev Upgrade the backing implementation of the proxy.
198    * Only the admin can call this function.
199    * @param newImplementation Address of the new implementation.
200    */
201   function upgradeTo(address newImplementation) external ifAdmin {
202     _upgradeTo(newImplementation);
203   }
204 
205   /**
206    * @dev Upgrade the backing implementation of the proxy and call a function
207    * on the new implementation.
208    * This is useful to initialize the proxied contract.
209    * @param newImplementation Address of the new implementation.
210    * @param data Data to send as msg.data in the low level call.
211    * It should include the signature and the parameters of the function to be called, as described in
212    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
213    */
214   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
215     _upgradeTo(newImplementation);
216     (bool success,) = newImplementation.delegatecall(data);
217     require(success);
218   }
219 
220   /**
221    * @return adm The admin slot.
222    */
223   function _admin() internal view returns (address adm) {
224     bytes32 slot = ADMIN_SLOT;
225     assembly {
226       adm := sload(slot)
227     }
228   }
229 
230   /**
231    * @dev Sets the address of the proxy admin.
232    * @param newAdmin Address of the new proxy admin.
233    */
234   function _setAdmin(address newAdmin) internal {
235     bytes32 slot = ADMIN_SLOT;
236 
237     assembly {
238       sstore(slot, newAdmin)
239     }
240   }
241 
242   /**
243    * @dev Only fall back when the sender is not the admin.
244    */
245   function _willFallback() virtual override internal {
246     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
247     //super._willFallback();
248   }
249 }
250 
251 interface IAdminUpgradeabilityProxyView {
252   function admin() external view returns (address);
253   function implementation() external view returns (address);
254 }
255 
256 
257 /**
258  * @title UpgradeabilityProxy
259  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
260  * implementation and init data.
261  */
262 abstract contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
263   /**
264    * @dev Contract constructor.
265    * @param _logic Address of the initial implementation.
266    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
267    * It should include the signature and the parameters of the function to be called, as described in
268    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
269    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
270    */
271   constructor(address _logic, bytes memory _data) public payable {
272     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
273     _setImplementation(_logic);
274     if(_data.length > 0) {
275       (bool success,) = _logic.delegatecall(_data);
276       require(success);
277     }
278   }  
279   
280   //function _willFallback() virtual override internal {
281     //super._willFallback();
282   //}
283 }
284 
285 
286 /**
287  * @title AdminUpgradeabilityProxy
288  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for 
289  * initializing the implementation, admin, and init data.
290  */
291 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
292   /**
293    * Contract constructor.
294    * @param _logic address of the initial implementation.
295    * @param _admin Address of the proxy administrator.
296    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
297    * It should include the signature and the parameters of the function to be called, as described in
298    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
299    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
300    */
301   constructor(address _admin, address _logic, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
302     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
303     _setAdmin(_admin);
304   }
305   
306   function _willFallback() override(Proxy, BaseAdminUpgradeabilityProxy) internal {
307     super._willFallback();
308   }
309 }
310 
311 
312 /**
313  * @title InitializableUpgradeabilityProxy
314  * @dev Extends BaseUpgradeabilityProxy with an initializer for initializing
315  * implementation and init data.
316  */
317 abstract contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
318   /**
319    * @dev Contract initializer.
320    * @param _logic Address of the initial implementation.
321    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
322    * It should include the signature and the parameters of the function to be called, as described in
323    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
324    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
325    */
326   function initialize(address _logic, bytes memory _data) public payable {
327     require(_implementation() == address(0));
328     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
329     _setImplementation(_logic);
330     if(_data.length > 0) {
331       (bool success,) = _logic.delegatecall(_data);
332       require(success);
333     }
334   }  
335 }
336 
337 
338 /**
339  * @title InitializableAdminUpgradeabilityProxy
340  * @dev Extends from BaseAdminUpgradeabilityProxy with an initializer for 
341  * initializing the implementation, admin, and init data.
342  */
343 contract InitializableAdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, InitializableUpgradeabilityProxy {
344   /**
345    * Contract initializer.
346    * @param _logic address of the initial implementation.
347    * @param _admin Address of the proxy administrator.
348    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
349    * It should include the signature and the parameters of the function to be called, as described in
350    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
351    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
352    */
353   function initialize(address _admin, address _logic, bytes memory _data) public payable {
354     require(_implementation() == address(0));
355     InitializableUpgradeabilityProxy.initialize(_logic, _data);
356     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
357     _setAdmin(_admin);
358   }
359 }
360 
361 
362 /**
363  * Utility library of inline functions on addresses
364  *
365  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
366  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
367  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
368  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
369  */
370 library OpenZeppelinUpgradesAddress {
371     /**
372      * Returns whether the target address is a contract
373      * @dev This function will return false if invoked during the constructor of a contract,
374      * as the code is not actually created until after the constructor finishes.
375      * @param account address of the account to check
376      * @return whether the target address is a contract
377      */
378     function isContract(address account) internal view returns (bool) {
379         uint256 size;
380         // XXX Currently there is no better way to check if there is a contract in an address
381         // than to check the size of the code at that address.
382         // See https://ethereum.stackexchange.com/a/14016/36603
383         // for more details about how this works.
384         // TODO Check this again before the Serenity release, because all addresses will be
385         // contracts then.
386         // solhint-disable-next-line no-inline-assembly
387         assembly { size := extcodesize(account) }
388         return size > 0;
389     }
390 }