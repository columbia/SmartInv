1 // File: contracts/AdminUpgradeabilityProxy.sol
2 
3 // File: contracts/upgradeability/Proxy.sol
4 
5 pragma solidity ^0.5.0;
6 
7 /**
8  * @title Proxy
9  * @dev Implements delegation of calls to other contracts, with proper
10  * forwarding of return values and bubbling of failures.
11  * It defines a fallback function that delegates all calls to the address
12  * returned by the abstract _implementation() internal function.
13  */
14 contract Proxy {
15   /**
16    * @dev Fallback function.
17    * Implemented entirely in `_fallback`.
18    */
19   function () payable external {
20     _fallback();
21   }
22 
23   /**
24    * @return The Address of the implementation.
25    */
26   function _implementation() internal view returns (address);
27 
28   /**
29    * @dev Delegates execution to an implementation contract.
30    * This is a low level function that doesn't return to its internal call site.
31    * It will return to the external caller whatever the implementation returns.
32    * @param implementation Address to delegate.
33    */
34   function _delegate(address implementation) internal {
35     assembly {
36       // Copy msg.data. We take full control of memory in this inline assembly
37       // block because it will not return to Solidity code. We overwrite the
38       // Solidity scratch pad at memory position 0.
39       calldatacopy(0, 0, calldatasize)
40 
41       // Call the implementation.
42       // out and outsize are 0 because we don't know the size yet.
43       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
44 
45       // Copy the returned data.
46       returndatacopy(0, 0, returndatasize)
47 
48       switch result
49       // delegatecall returns 0 on error.
50       case 0 { revert(0, returndatasize) }
51       default { return(0, returndatasize) }
52     }
53   }
54 
55   /**
56    * @dev Function that is run as the first thing in the fallback function.
57    * Can be redefined in derived contracts to add functionality.
58    * Redefinitions must call super._willFallback().
59    */
60   function _willFallback() internal {
61   }
62 
63   /**
64    * @dev fallback implementation.
65    * Extracted to enable manual triggering.
66    */
67   function _fallback() internal {
68     _willFallback();
69     _delegate(_implementation());
70   }
71 }
72 
73 // File: contracts/utils/Address.sol
74 
75 pragma solidity ^0.5.0;
76 
77 /**
78  * Utility library of inline functions on addresses
79  *
80  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
81  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
82  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
83  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
84  */
85 library ZOSLibAddress {
86     /**
87      * Returns whether the target address is a contract
88      * @dev This function will return false if invoked during the constructor of a contract,
89      * as the code is not actually created until after the constructor finishes.
90      * @param account address of the account to check
91      * @return whether the target address is a contract
92      */
93     function isContract(address account) internal view returns (bool) {
94         uint256 size;
95         // XXX Currently there is no better way to check if there is a contract in an address
96         // than to check the size of the code at that address.
97         // See https://ethereum.stackexchange.com/a/14016/36603
98         // for more details about how this works.
99         // TODO Check this again before the Serenity release, because all addresses will be
100         // contracts then.
101         // solhint-disable-next-line no-inline-assembly
102         assembly { size := extcodesize(account) }
103         return size > 0;
104     }
105 }
106 
107 // File: contracts/upgradeability/BaseUpgradeabilityProxy.sol
108 
109 pragma solidity ^0.5.0;
110 
111 
112 
113 /**
114  * @title BaseUpgradeabilityProxy
115  * @dev This contract implements a proxy that allows to change the
116  * implementation address to which it will delegate.
117  * Such a change is called an implementation upgrade.
118  */
119 contract BaseUpgradeabilityProxy is Proxy {
120   /**
121    * @dev Emitted when the implementation is upgraded.
122    * @param implementation Address of the new implementation.
123    */
124   event Upgraded(address indexed implementation);
125 
126   /**
127    * @dev Storage slot with the address of the current implementation.
128    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
129    * validated in the constructor.
130    */
131   bytes32 internal constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
132 
133   /**
134    * @dev Returns the current implementation.
135    * @return Address of the current implementation
136    */
137   function _implementation() internal view returns (address impl) {
138     bytes32 slot = IMPLEMENTATION_SLOT;
139     assembly {
140       impl := sload(slot)
141     }
142   }
143 
144   /**
145    * @dev Upgrades the proxy to a new implementation.
146    * @param newImplementation Address of the new implementation.
147    */
148   function _upgradeTo(address newImplementation) internal {
149     _setImplementation(newImplementation);
150     emit Upgraded(newImplementation);
151   }
152 
153   /**
154    * @dev Sets the implementation address of the proxy.
155    * @param newImplementation Address of the new implementation.
156    */
157   function _setImplementation(address newImplementation) internal {
158     require(ZOSLibAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
159 
160     bytes32 slot = IMPLEMENTATION_SLOT;
161 
162     assembly {
163       sstore(slot, newImplementation)
164     }
165   }
166 }
167 
168 // File: contracts/upgradeability/UpgradeabilityProxy.sol
169 
170 pragma solidity ^0.5.0;
171 
172 
173 /**
174  * @title UpgradeabilityProxy
175  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
176  * implementation and init data.
177  */
178 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
179   /**
180    * @dev Contract constructor.
181    * @param _logic Address of the initial implementation.
182    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
183    * It should include the signature and the parameters of the function to be called, as described in
184    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
185    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
186    */
187   constructor(address _logic, bytes memory _data) public payable {
188     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
189     _setImplementation(_logic);
190     if(_data.length > 0) {
191       (bool success,) = _logic.delegatecall(_data);
192       require(success);
193     }
194   }  
195 }
196 
197 // File: contracts/upgradeability/BaseAdminUpgradeabilityProxy.sol
198 
199 pragma solidity ^0.5.0;
200 
201 
202 /**
203  * @title BaseAdminUpgradeabilityProxy
204  * @dev This contract combines an upgradeability proxy with an authorization
205  * mechanism for administrative tasks.
206  * All external functions in this contract must be guarded by the
207  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
208  * feature proposal that would enable this to be done automatically.
209  */
210 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
211   /**
212    * @dev Emitted when the administration has been transferred.
213    * @param previousAdmin Address of the previous admin.
214    * @param newAdmin Address of the new admin.
215    */
216   event AdminChanged(address previousAdmin, address newAdmin);
217 
218   /**
219    * @dev Storage slot with the admin of the contract.
220    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
221    * validated in the constructor.
222    */
223   bytes32 internal constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
224 
225   /**
226    * @dev Modifier to check whether the `msg.sender` is the admin.
227    * If it is, it will run the function. Otherwise, it will delegate the call
228    * to the implementation.
229    */
230   modifier ifAdmin() {
231     if (msg.sender == _admin()) {
232       _;
233     } else {
234       _fallback();
235     }
236   }
237 
238   /**
239    * @return The address of the proxy admin.
240    */
241   function admin() external ifAdmin returns (address) {
242     return _admin();
243   }
244 
245   /**
246    * @return The address of the implementation.
247    */
248   function implementation() external ifAdmin returns (address) {
249     return _implementation();
250   }
251 
252   /**
253    * @dev Changes the admin of the proxy.
254    * Only the current admin can call this function.
255    * @param newAdmin Address to transfer proxy administration to.
256    */
257   function changeAdmin(address newAdmin) external ifAdmin {
258     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
259     emit AdminChanged(_admin(), newAdmin);
260     _setAdmin(newAdmin);
261   }
262 
263   /**
264    * @dev Upgrade the backing implementation of the proxy.
265    * Only the admin can call this function.
266    * @param newImplementation Address of the new implementation.
267    */
268   function upgradeTo(address newImplementation) external ifAdmin {
269     _upgradeTo(newImplementation);
270   }
271 
272   /**
273    * @dev Upgrade the backing implementation of the proxy and call a function
274    * on the new implementation.
275    * This is useful to initialize the proxied contract.
276    * @param newImplementation Address of the new implementation.
277    * @param data Data to send as msg.data in the low level call.
278    * It should include the signature and the parameters of the function to be called, as described in
279    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
280    */
281   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
282     _upgradeTo(newImplementation);
283     (bool success,) = newImplementation.delegatecall(data);
284     require(success);
285   }
286 
287   /**
288    * @return The admin slot.
289    */
290   function _admin() internal view returns (address adm) {
291     bytes32 slot = ADMIN_SLOT;
292     assembly {
293       adm := sload(slot)
294     }
295   }
296 
297   /**
298    * @dev Sets the address of the proxy admin.
299    * @param newAdmin Address of the new proxy admin.
300    */
301   function _setAdmin(address newAdmin) internal {
302     bytes32 slot = ADMIN_SLOT;
303 
304     assembly {
305       sstore(slot, newAdmin)
306     }
307   }
308 
309   /**
310    * @dev Only fall back when the sender is not the admin.
311    */
312   function _willFallback() internal {
313     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
314     super._willFallback();
315   }
316 }
317 
318 // File: contracts/upgradeability/AdminUpgradeabilityProxy.sol
319 
320 pragma solidity ^0.5.0;
321 
322 
323 /**
324  * @title AdminUpgradeabilityProxy
325  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for 
326  * initializing the implementation, admin, and init data.
327  */
328 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
329   /**
330    * Contract constructor.
331    * @param _logic address of the initial implementation.
332    * @param _admin Address of the proxy administrator.
333    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
334    * It should include the signature and the parameters of the function to be called, as described in
335    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
336    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
337    */
338   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
339     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
340     _setAdmin(_admin);
341   }
342 }