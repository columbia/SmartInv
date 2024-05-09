1 pragma solidity >=0.4.24 <0.6.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  *
8  * Source: https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.0.0/contracts/ownership/Ownable.sol
9  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
10  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
11  * build/artifacts folder) as well as the vanilla Ownable implementation from an openzeppelin version.
12  */
13 contract ZOSLibOwnable {
14   address private _owner;
15 
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() internal {
26     _owner = msg.sender;
27     emit OwnershipTransferred(address(0), _owner);
28   }
29 
30   /**
31    * @return the address of the owner.
32    */
33   function owner() public view returns(address) {
34     return _owner;
35   }
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(isOwner());
42     _;
43   }
44 
45   /**
46    * @return true if `msg.sender` is the owner of the contract.
47    */
48   function isOwner() public view returns(bool) {
49     return msg.sender == _owner;
50   }
51 
52   /**
53    * @dev Allows the current owner to relinquish control of the contract.
54    * @notice Renouncing to ownership will leave the contract without an owner.
55    * It will not be possible to call the functions with the `onlyOwner`
56    * modifier anymore.
57    */
58   function renounceOwnership() public onlyOwner {
59     emit OwnershipTransferred(_owner, address(0));
60     _owner = address(0);
61   }
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) public onlyOwner {
68     _transferOwnership(newOwner);
69   }
70 
71   /**
72    * @dev Transfers control of the contract to a newOwner.
73    * @param newOwner The address to transfer ownership to.
74    */
75   function _transferOwnership(address newOwner) internal {
76     require(newOwner != address(0));
77     emit OwnershipTransferred(_owner, newOwner);
78     _owner = newOwner;
79   }
80 }
81 
82 /**
83  * @title Proxy
84  * @dev Implements delegation of calls to other contracts, with proper
85  * forwarding of return values and bubbling of failures.
86  * It defines a fallback function that delegates all calls to the address
87  * returned by the abstract _implementation() internal function.
88  */
89 contract Proxy {
90   /**
91    * @dev Fallback function.
92    * Implemented entirely in `_fallback`.
93    */
94   function () payable external {
95     _fallback();
96   }
97 
98   /**
99    * @return The Address of the implementation.
100    */
101   function _implementation() internal view returns (address);
102 
103   /**
104    * @dev Delegates execution to an implementation contract.
105    * This is a low level function that doesn't return to its internal call site.
106    * It will return to the external caller whatever the implementation returns.
107    * @param implementation Address to delegate.
108    */
109   function _delegate(address implementation) internal {
110     assembly {
111       // Copy msg.data. We take full control of memory in this inline assembly
112       // block because it will not return to Solidity code. We overwrite the
113       // Solidity scratch pad at memory position 0.
114       calldatacopy(0, 0, calldatasize)
115 
116       // Call the implementation.
117       // out and outsize are 0 because we don't know the size yet.
118       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
119 
120       // Copy the returned data.
121       returndatacopy(0, 0, returndatasize)
122 
123       switch result
124       // delegatecall returns 0 on error.
125       case 0 { revert(0, returndatasize) }
126       default { return(0, returndatasize) }
127     }
128   }
129 
130   /**
131    * @dev Function that is run as the first thing in the fallback function.
132    * Can be redefined in derived contracts to add functionality.
133    * Redefinitions must call super._willFallback().
134    */
135   function _willFallback() internal {
136   }
137 
138   /**
139    * @dev fallback implementation.
140    * Extracted to enable manual triggering.
141    */
142   function _fallback() internal {
143     _willFallback();
144     _delegate(_implementation());
145   }
146 }
147 
148 
149 /**
150  * Utility library of inline functions on addresses
151  *
152  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.0.0/contracts/utils/Address.sol
153  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
154  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
155  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
156  */
157 library ZOSLibAddress {
158 
159   /**
160    * Returns whether the target address is a contract
161    * @dev This function will return false if invoked during the constructor of a contract,
162    * as the code is not actually created until after the constructor finishes.
163    * @param account address of the account to check
164    * @return whether the target address is a contract
165    */
166   function isContract(address account) internal view returns (bool) {
167     uint256 size;
168     // XXX Currently there is no better way to check if there is a contract in an address
169     // than to check the size of the code at that address.
170     // See https://ethereum.stackexchange.com/a/14016/36603
171     // for more details about how this works.
172     // TODO Check this again before the Serenity release, because all addresses will be
173     // contracts then.
174     // solium-disable-next-line security/no-inline-assembly
175     assembly { size := extcodesize(account) }
176     return size > 0;
177   }
178 
179 }
180 
181 
182 /**
183  * @title UpgradeabilityProxy
184  * @dev This contract implements a proxy that allows to change the
185  * implementation address to which it will delegate.
186  * Such a change is called an implementation upgrade.
187  */
188 contract UpgradeabilityProxy is Proxy {
189   /**
190    * @dev Emitted when the implementation is upgraded.
191    * @param implementation Address of the new implementation.
192    */
193   event Upgraded(address indexed implementation);
194 
195   /**
196    * @dev Storage slot with the address of the current implementation.
197    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
198    * validated in the constructor.
199    */
200   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
201 
202   /**
203    * @dev Contract constructor.
204    * @param _implementation Address of the initial implementation.
205    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
206    * It should include the signature and the parameters of the function to be called, as described in
207    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
208    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
209    */
210   constructor(address _implementation, bytes memory _data) public payable {
211     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
212     _setImplementation(_implementation);
213     if(_data.length > 0) {
214       (bool ok,) = _implementation.delegatecall(_data);
215       require(ok);
216     }
217   }
218 
219   /**
220    * @dev Returns the current implementation.
221    * @return Address of the current implementation
222    */
223   function _implementation() internal view returns (address impl) {
224     bytes32 slot = IMPLEMENTATION_SLOT;
225     assembly {
226       impl := sload(slot)
227     }
228   }
229 
230   /**
231    * @dev Upgrades the proxy to a new implementation.
232    * @param newImplementation Address of the new implementation.
233    */
234   function _upgradeTo(address newImplementation) internal {
235     _setImplementation(newImplementation);
236     emit Upgraded(newImplementation);
237   }
238 
239   /**
240    * @dev Sets the implementation address of the proxy.
241    * @param newImplementation Address of the new implementation.
242    */
243   function _setImplementation(address newImplementation) private {
244     require(ZOSLibAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
245 
246     bytes32 slot = IMPLEMENTATION_SLOT;
247 
248     assembly {
249       sstore(slot, newImplementation)
250     }
251   }
252 }
253 
254 
255 /**
256  * @title AdminUpgradeabilityProxy
257  * @dev This contract combines an upgradeability proxy with an authorization
258  * mechanism for administrative tasks.
259  * All external functions in this contract must be guarded by the
260  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
261  * feature proposal that would enable this to be done automatically.
262  */
263 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
264   /**
265    * @dev Emitted when the administration has been transferred.
266    * @param previousAdmin Address of the previous admin.
267    * @param newAdmin Address of the new admin.
268    */
269   event AdminChanged(address previousAdmin, address newAdmin);
270 
271   /**
272    * @dev Storage slot with the admin of the contract.
273    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
274    * validated in the constructor.
275    */
276   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
277 
278   /**
279    * @dev Modifier to check whether the `msg.sender` is the admin.
280    * If it is, it will run the function. Otherwise, it will delegate the call
281    * to the implementation.
282    */
283   modifier ifAdmin() {
284     if (msg.sender == _admin()) {
285       _;
286     } else {
287       _fallback();
288     }
289   }
290 
291   /**
292    * Contract constructor.
293    * @param _implementation address of the initial implementation.
294    * @param _admin Address of the proxy administrator.
295    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
296    * It should include the signature and the parameters of the function to be called, as described in
297    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
298    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
299    */
300   constructor(address _implementation, address _admin, bytes memory _data) UpgradeabilityProxy(_implementation, _data) public payable {
301     require(
302       address(this) == address(0x9DCe896DdC20BA883600176678cbEe2B8BA188A9),
303       "incorrect deployment address - check submitting account & nonce."
304     );
305     
306     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
307 
308     _setAdmin(_admin);
309   }
310 
311   /**
312    * @return The address of the proxy admin.
313    */
314   function admin() external ifAdmin returns (address) {
315     return _admin();
316   }
317 
318   /**
319    * @return The address of the implementation.
320    */
321   function implementation() external ifAdmin returns (address) {
322     return _implementation();
323   }
324 
325   /**
326    * @dev Changes the admin of the proxy.
327    * Only the current admin can call this function.
328    * @param newAdmin Address to transfer proxy administration to.
329    */
330   function changeAdmin(address newAdmin) external ifAdmin {
331     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
332     emit AdminChanged(_admin(), newAdmin);
333     _setAdmin(newAdmin);
334   }
335 
336   /**
337    * @dev Upgrade the backing implementation of the proxy.
338    * Only the admin can call this function.
339    * @param newImplementation Address of the new implementation.
340    */
341   function upgradeTo(address newImplementation) external ifAdmin {
342     _upgradeTo(newImplementation);
343   }
344 
345   /**
346    * @dev Upgrade the backing implementation of the proxy and call a function
347    * on the new implementation.
348    * This is useful to initialize the proxied contract.
349    * @param newImplementation Address of the new implementation.
350    * @param data Data to send as msg.data in the low level call.
351    * It should include the signature and the parameters of the function to be called, as described in
352    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
353    */
354   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
355     _upgradeTo(newImplementation);    
356     (bool ok,) = newImplementation.delegatecall(data);
357     require(ok);
358   }
359 
360   /**
361    * @return The admin slot.
362    */
363   function _admin() internal view returns (address adm) {
364     bytes32 slot = ADMIN_SLOT;
365     assembly {
366       adm := sload(slot)
367     }
368   }
369 
370   /**
371    * @dev Sets the address of the proxy admin.
372    * @param newAdmin Address of the new proxy admin.
373    */
374   function _setAdmin(address newAdmin) internal {
375     bytes32 slot = ADMIN_SLOT;
376 
377     assembly {
378       sstore(slot, newAdmin)
379     }
380   }
381 
382   /**
383    * @dev Only fall back when the sender is not the admin.
384    */
385   function _willFallback() internal {
386     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
387     super._willFallback();
388   }
389 }
390 
391 
392 
393 /**
394  * @title ProxyAdmin
395  * @dev This contract is the admin of a proxy, and is in charge
396  * of upgrading it as well as transferring it to another admin.
397  */
398 contract ProxyAdmin is ZOSLibOwnable {
399   /**
400    * @notice constructor function, used to enforce contract address.
401    */
402   constructor() public ZOSLibOwnable() {
403     require(
404       address(this) == address(0x047EbD5F7431c005c9D3a59CE0675ac998417e9d),
405       "incorrect deployment address - check submitting account & nonce."
406     );
407   }
408 
409   /**
410    * @dev Returns the current implementation of a proxy.
411    * This is needed because only the proxy admin can query it.
412    * @return The address of the current implementation of the proxy.
413    */
414   function getProxyImplementation(AdminUpgradeabilityProxy proxy) public returns (address) {
415     return proxy.implementation();
416   }
417 
418   /**
419    * @dev Returns the admin of a proxy. Only the admin can query it.
420    * @return The address of the current admin of the proxy.
421    */
422   function getProxyAdmin(AdminUpgradeabilityProxy proxy) public returns (address) {
423     return proxy.admin();
424   }
425 
426   /**
427    * @dev Changes the admin of a proxy.
428    * @param proxy Proxy to change admin.
429    * @param newAdmin Address to transfer proxy administration to.
430    */
431   function changeProxyAdmin(AdminUpgradeabilityProxy proxy, address newAdmin) public onlyOwner {
432     proxy.changeAdmin(newAdmin);
433   }
434 
435   /**
436    * @dev Upgrades a proxy to the newest implementation of a contract.
437    * @param proxy Proxy to be upgraded.
438    * @param implementation the address of the Implementation.
439    */
440   function upgrade(AdminUpgradeabilityProxy proxy, address implementation) public onlyOwner {
441     proxy.upgradeTo(implementation);
442   }
443 
444   /**
445    * @dev Upgrades a proxy to the newest implementation of a contract and forwards a function call to it.
446    * This is useful to initialize the proxied contract.
447    * @param proxy Proxy to be upgraded.
448    * @param implementation Address of the Implementation.
449    * @param data Data to send as msg.data in the low level call.
450    * It should include the signature and the parameters of the function to be called, as described in
451    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
452    */
453   function upgradeAndCall(AdminUpgradeabilityProxy proxy, address implementation, bytes memory data) payable public onlyOwner {
454     proxy.upgradeToAndCall.value(msg.value)(implementation, data);
455   }
456 }