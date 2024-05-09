1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.23;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 // File: contracts/upgradeability/Proxy.sol
66 
67 pragma solidity ^0.4.24;
68 
69 /**
70  * @title Proxy
71  * @dev Implements delegation of calls to other contracts, with proper
72  * forwarding of return values and bubbling of failures.
73  * It defines a fallback function that delegates all calls to the address
74  * returned by the abstract _implementation() internal function.
75  */
76 contract Proxy {
77   /**
78    * @dev Fallback function.
79    * Implemented entirely in `_fallback`.
80    */
81   function () payable external {
82     _fallback();
83   }
84 
85   /**
86    * @return The Address of the implementation.
87    */
88   function _implementation() internal view returns (address);
89 
90   /**
91    * @dev Delegates execution to an implementation contract.
92    * This is a low level function that doesn't return to its internal call site.
93    * It will return to the external caller whatever the implementation returns.
94    * @param implementation Address to delegate.
95    */
96   function _delegate(address implementation) internal {
97     assembly {
98       // Copy msg.data. We take full control of memory in this inline assembly
99       // block because it will not return to Solidity code. We overwrite the
100       // Solidity scratch pad at memory position 0.
101       calldatacopy(0, 0, calldatasize)
102 
103       // Call the implementation.
104       // out and outsize are 0 because we don't know the size yet.
105       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
106 
107       // Copy the returned data.
108       returndatacopy(0, 0, returndatasize)
109 
110       switch result
111       // delegatecall returns 0 on error.
112       case 0 { revert(0, returndatasize) }
113       default { return(0, returndatasize) }
114     }
115   }
116 
117   /**
118    * @dev Function that is run as the first thing in the fallback function.
119    * Can be redefined in derived contracts to add functionality.
120    * Redefinitions must call super._willFallback().
121    */
122   function _willFallback() internal {
123   }
124 
125   /**
126    * @dev fallback implementation.
127    * Extracted to enable manual triggering.
128    */
129   function _fallback() internal {
130     _willFallback();
131     _delegate(_implementation());
132   }
133 }
134 
135 // File: openzeppelin-solidity/contracts/AddressUtils.sol
136 
137 pragma solidity ^0.4.23;
138 
139 
140 /**
141  * Utility library of inline functions on addresses
142  */
143 library AddressUtils {
144 
145   /**
146    * Returns whether the target address is a contract
147    * @dev This function will return false if invoked during the constructor of a contract,
148    *  as the code is not actually created until after the constructor finishes.
149    * @param addr address to check
150    * @return whether the target address is a contract
151    */
152   function isContract(address addr) internal view returns (bool) {
153     uint256 size;
154     // XXX Currently there is no better way to check if there is a contract in an address
155     // than to check the size of the code at that address.
156     // See https://ethereum.stackexchange.com/a/14016/36603
157     // for more details about how this works.
158     // TODO Check this again before the Serenity release, because all addresses will be
159     // contracts then.
160     // solium-disable-next-line security/no-inline-assembly
161     assembly { size := extcodesize(addr) }
162     return size > 0;
163   }
164 
165 }
166 
167 // File: contracts/upgradeability/UpgradeabilityProxy.sol
168 
169 pragma solidity ^0.4.24;
170 
171 
172 
173 /**
174  * @title UpgradeabilityProxy
175  * @dev This contract implements a proxy that allows to change the
176  * implementation address to which it will delegate.
177  * Such a change is called an implementation upgrade.
178  */
179 contract UpgradeabilityProxy is Proxy {
180   /**
181    * @dev Emitted when the implementation is upgraded.
182    * @param implementation Address of the new implementation.
183    */
184   event Upgraded(address indexed implementation);
185 
186   /**
187    * @dev Storage slot with the address of the current implementation.
188    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
189    * validated in the constructor.
190    */
191   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
192 
193   /**
194    * @dev Contract constructor.
195    * @param _implementation Address of the initial implementation.
196    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
197    * It should include the signature and the parameters of the function to be called, as described in
198    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
199    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
200    */
201   constructor(address _implementation, bytes _data) public payable {
202     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
203     _setImplementation(_implementation);
204     if(_data.length > 0) {
205       require(_implementation.delegatecall(_data));
206     }
207   }
208 
209   /**
210    * @dev Returns the current implementation.
211    * @return Address of the current implementation
212    */
213   function _implementation() internal view returns (address impl) {
214     bytes32 slot = IMPLEMENTATION_SLOT;
215     assembly {
216       impl := sload(slot)
217     }
218   }
219 
220   /**
221    * @dev Upgrades the proxy to a new implementation.
222    * @param newImplementation Address of the new implementation.
223    */
224   function _upgradeTo(address newImplementation) internal {
225     _setImplementation(newImplementation);
226     emit Upgraded(newImplementation);
227   }
228 
229   /**
230    * @dev Sets the implementation address of the proxy.
231    * @param newImplementation Address of the new implementation.
232    */
233   function _setImplementation(address newImplementation) private {
234     require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
235 
236     bytes32 slot = IMPLEMENTATION_SLOT;
237 
238     assembly {
239       sstore(slot, newImplementation)
240     }
241   }
242 }
243 
244 // File: contracts/upgradeability/AdminUpgradeabilityProxy.sol
245 
246 pragma solidity ^0.4.24;
247 
248 
249 /**
250  * @title AdminUpgradeabilityProxy
251  * @dev This contract combines an upgradeability proxy with an authorization
252  * mechanism for administrative tasks.
253  * All external functions in this contract must be guarded by the
254  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
255  * feature proposal that would enable this to be done automatically.
256  */
257 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
258   /**
259    * @dev Emitted when the administration has been transferred.
260    * @param previousAdmin Address of the previous admin.
261    * @param newAdmin Address of the new admin.
262    */
263   event AdminChanged(address previousAdmin, address newAdmin);
264 
265   /**
266    * @dev Storage slot with the admin of the contract.
267    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
268    * validated in the constructor.
269    */
270   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
271 
272   /**
273    * @dev Modifier to check whether the `msg.sender` is the admin.
274    * If it is, it will run the function. Otherwise, it will delegate the call
275    * to the implementation.
276    */
277   modifier ifAdmin() {
278     if (msg.sender == _admin()) {
279       _;
280     } else {
281       _fallback();
282     }
283   }
284 
285   /**
286    * Contract constructor.
287    * @param _implementation address of the initial implementation.
288    * @param _admin Address of the proxy administrator.
289    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
290    * It should include the signature and the parameters of the function to be called, as described in
291    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
292    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
293    */
294   constructor(address _implementation, address _admin, bytes _data) UpgradeabilityProxy(_implementation, _data) public payable {
295     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
296 
297     _setAdmin(_admin);
298   }
299 
300   /**
301    * @return The address of the proxy admin.
302    */
303   function admin() external view ifAdmin returns (address) {
304     return _admin();
305   }
306 
307   /**
308    * @return The address of the implementation.
309    */
310   function implementation() external view ifAdmin returns (address) {
311     return _implementation();
312   }
313 
314   /**
315    * @dev Changes the admin of the proxy.
316    * Only the current admin can call this function.
317    * @param newAdmin Address to transfer proxy administration to.
318    */
319   function changeAdmin(address newAdmin) external ifAdmin {
320     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
321     emit AdminChanged(_admin(), newAdmin);
322     _setAdmin(newAdmin);
323   }
324 
325   /**
326    * @dev Upgrade the backing implementation of the proxy.
327    * Only the admin can call this function.
328    * @param newImplementation Address of the new implementation.
329    */
330   function upgradeTo(address newImplementation) external ifAdmin {
331     _upgradeTo(newImplementation);
332   }
333 
334   /**
335    * @dev Upgrade the backing implementation of the proxy and call a function
336    * on the new implementation.
337    * This is useful to initialize the proxied contract.
338    * @param newImplementation Address of the new implementation.
339    * @param data Data to send as msg.data in the low level call.
340    * It should include the signature and the parameters of the function to be called, as described in
341    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
342    */
343   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
344     _upgradeTo(newImplementation);
345     require(newImplementation.delegatecall(data));
346   }
347 
348   /**
349    * @return The admin slot.
350    */
351   function _admin() internal view returns (address adm) {
352     bytes32 slot = ADMIN_SLOT;
353     assembly {
354       adm := sload(slot)
355     }
356   }
357 
358   /**
359    * @dev Sets the address of the proxy admin.
360    * @param newAdmin Address of the new proxy admin.
361    */
362   function _setAdmin(address newAdmin) internal {
363     bytes32 slot = ADMIN_SLOT;
364 
365     assembly {
366       sstore(slot, newAdmin)
367     }
368   }
369 
370   /**
371    * @dev Only fall back when the sender is not the admin.
372    */
373   function _willFallback() internal {
374     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
375     super._willFallback();
376   }
377 }
378 
379 // File: contracts/upgradeability/ProxyAdmin.sol
380 
381 pragma solidity ^0.4.24;
382 
383 
384 
385 /**
386  * @title ProxyAdmin
387  * @dev This contract is the admin of a proxy, and is in charge
388  * of upgrading it as well as transferring it to another admin.
389  */
390 contract ProxyAdmin is Ownable {
391   /**
392    * @dev Returns the current implementation of a proxy.
393    * This is needed because only the proxy admin can query it.
394    * @return The address of the current implementation of the proxy.
395    */
396   function getProxyImplementation(AdminUpgradeabilityProxy proxy) public view returns (address) {
397     return proxy.implementation();
398   }
399 
400   /**
401    * @dev Returns the admin of a proxy. Only the admin can query it.
402    * @return The address of the current admin of the proxy.
403    */
404   function getProxyAdmin(AdminUpgradeabilityProxy proxy) public view returns (address) {
405     return proxy.admin();
406   }
407 
408   /**
409    * @dev Changes the admin of a proxy.
410    * @param proxy Proxy to change admin.
411    * @param newAdmin Address to transfer proxy administration to.
412    */
413   function changeProxyAdmin(AdminUpgradeabilityProxy proxy, address newAdmin) public onlyOwner {
414     proxy.changeAdmin(newAdmin);
415   }
416 
417   /**
418    * @dev Upgrades a proxy to the newest implementation of a contract.
419    * @param proxy Proxy to be upgraded.
420    * @param implementation the address of the Implementation.
421    */
422   function upgrade(AdminUpgradeabilityProxy proxy, address implementation) public onlyOwner {
423     proxy.upgradeTo(implementation);
424   }
425 
426   /**
427    * @dev Upgrades a proxy to the newest implementation of a contract and forwards a function call to it.
428    * This is useful to initialize the proxied contract.
429    * @param proxy Proxy to be upgraded.
430    * @param implementation Address of the Implementation.
431    * @param data Data to send as msg.data in the low level call.
432    * It should include the signature and the parameters of the function to be called, as described in
433    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
434    */
435   function upgradeAndCall(AdminUpgradeabilityProxy proxy, address implementation, bytes data) payable public onlyOwner {
436     proxy.upgradeToAndCall.value(msg.value)(implementation, data);
437   }
438 }