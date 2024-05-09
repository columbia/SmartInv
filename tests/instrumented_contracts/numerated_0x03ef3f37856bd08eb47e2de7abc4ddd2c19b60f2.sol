1 pragma solidity ^0.5.4;
2 
3 /**
4  * @title Proxy
5  * @dev Implements delegation of calls to other contracts, with proper
6  * forwarding of return values and bubbling of failures.
7  * It defines a fallback function that delegates all calls to the address
8  * returned by the abstract _implementation() internal function.
9  */
10 contract Proxy {
11   /**
12    * @dev Fallback function.
13    * Implemented entirely in `_fallback`.
14    */
15   function () payable external {
16     _fallback();
17   }
18 
19   /**
20    * @return The Address of the implementation.
21    */
22   function _implementation() internal view returns (address);
23 
24   /**
25    * @dev Delegates execution to an implementation contract.
26    * This is a low level function that doesn't return to its internal call site.
27    * It will return to the external caller whatever the implementation returns.
28    * @param implementation Address to delegate.
29    */
30   function _delegate(address implementation) internal {
31     assembly {
32       // Copy msg.data. We take full control of memory in this inline assembly
33       // block because it will not return to Solidity code. We overwrite the
34       // Solidity scratch pad at memory position 0.
35       calldatacopy(0, 0, calldatasize)
36 
37       // Call the implementation.
38       // out and outsize are 0 because we don't know the size yet.
39       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
40 
41       // Copy the returned data.
42       returndatacopy(0, 0, returndatasize)
43 
44       switch result
45       // delegatecall returns 0 on error.
46       case 0 { revert(0, returndatasize) }
47       default { return(0, returndatasize) }
48     }
49   }
50 
51   /**
52    * @dev Function that is run as the first thing in the fallback function.
53    * Can be redefined in derived contracts to add functionality.
54    * Redefinitions must call super._willFallback().
55    */
56   function _willFallback() internal {
57   }
58 
59   /**
60    * @dev fallback implementation.
61    * Extracted to enable manual triggering.
62    */
63   function _fallback() internal {
64     _willFallback();
65     _delegate(_implementation());
66   }
67 }
68 
69 /**
70  * Utility library of inline functions on addresses
71  *
72  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
73  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
74  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
75  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
76  */
77 library OpenZeppelinUpgradesAddress {
78     /**
79      * Returns whether the target address is a contract
80      * @dev This function will return false if invoked during the constructor of a contract,
81      * as the code is not actually created until after the constructor finishes.
82      * @param account address of the account to check
83      * @return whether the target address is a contract
84      */
85     function isContract(address account) internal view returns (bool) {
86         uint256 size;
87         // XXX Currently there is no better way to check if there is a contract in an address
88         // than to check the size of the code at that address.
89         // See https://ethereum.stackexchange.com/a/14016/36603
90         // for more details about how this works.
91         // TODO Check this again before the Serenity release, because all addresses will be
92         // contracts then.
93         // solhint-disable-next-line no-inline-assembly
94         assembly { size := extcodesize(account) }
95         return size > 0;
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
106   /**
107    * @dev Emitted when the implementation is upgraded.
108    * @param implementation Address of the new implementation.
109    */
110   event Upgraded(address indexed implementation);
111 
112   /**
113    * @dev Storage slot with the address of the current implementation.
114    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
115    * validated in the constructor.
116    */
117   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
118 
119   /**
120    * @dev Returns the current implementation.
121    * @return Address of the current implementation
122    */
123   function _implementation() internal view returns (address impl) {
124     bytes32 slot = IMPLEMENTATION_SLOT;
125     assembly {
126       impl := sload(slot)
127     }
128   }
129 
130   /**
131    * @dev Upgrades the proxy to a new implementation.
132    * @param newImplementation Address of the new implementation.
133    */
134   function _upgradeTo(address newImplementation) internal {
135     _setImplementation(newImplementation);
136     emit Upgraded(newImplementation);
137   }
138 
139   /**
140    * @dev Sets the implementation address of the proxy.
141    * @param newImplementation Address of the new implementation.
142    */
143   function _setImplementation(address newImplementation) internal {
144     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
145 
146     bytes32 slot = IMPLEMENTATION_SLOT;
147 
148     assembly {
149       sstore(slot, newImplementation)
150     }
151   }
152 }
153 
154 /**
155  * @title UpgradeabilityProxy
156  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
157  * implementation and init data.
158  */
159 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
160   /**
161    * @dev Contract constructor.
162    * @param _logic Address of the initial implementation.
163    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
164    * It should include the signature and the parameters of the function to be called, as described in
165    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
166    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
167    */
168   constructor(address _logic, bytes memory _data) public payable {
169     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
170     _setImplementation(_logic);
171     if(_data.length > 0) {
172       (bool success,) = _logic.delegatecall(_data);
173       require(success);
174     }
175   }  
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
187   /**
188    * @dev Emitted when the administration has been transferred.
189    * @param previousAdmin Address of the previous admin.
190    * @param newAdmin Address of the new admin.
191    */
192   event AdminChanged(address previousAdmin, address newAdmin);
193 
194   /**
195    * @dev Issued when the new administrator accepts ownership.
196    * @param newAdmin Address of the new admin.
197    */
198   event AdminUpdated(address newAdmin);
199 
200   /**
201    * @dev Storage slot with the admin of the contract.
202    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
203    * validated in the constructor.
204    */
205 
206   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
207 
208   /**
209    * @dev Storage slot with the pending admin of the contract.
210    * This is the keccak-256 hash of "eip1967.proxy.pending.admin" subtracted by 1, and is
211    * validated in the constructor.
212    */
213 
214   bytes32 private constant PENDING_ADMIN_SLOT = 0x4df6442ced3c3fc3ed8f4e91c7cf63e720e8c3c9fbe8f614f5441bb4d1916bde;
215 
216   /**
217    * @dev Modifier to check whether the `msg.sender` is the admin.
218    * If it is, it will run the function. Otherwise, it will delegate the call
219    * to the implementation.
220    */
221   modifier ifAdmin() {
222     if (msg.sender == _admin()) {
223       _;
224     }/* else {
225       _fallback();
226     }*/
227   }
228 
229   /**
230    * @return The address of the proxy admin.
231    */
232   function admin() external view ifAdmin returns (address) {
233     return _admin();
234   }
235 
236   /**
237    * @return The address of the proxy pending admin.
238    */
239   function pendingAdmin() external view ifAdmin returns (address) {
240     return _pendingAdmin();
241   }
242 
243   /**
244    * @return The address of the implementation.
245    */
246   function implementation() external view ifAdmin returns (address) {
247     return _implementation();
248   }
249 
250   /**
251    * @dev Changes the admin of the proxy.
252    * Only the current admin can call this function.
253    * @param newAdmin Address to transfer proxy administration to.
254    */
255   function changeAdmin(address newAdmin) external ifAdmin {
256     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
257     require(newAdmin != _admin(), "The current and new admin cannot be the same .");
258     require(newAdmin != _pendingAdmin(), "Cannot set the newAdmin of a proxy to the same address .");
259     _setPendingAdmin(newAdmin);
260     emit AdminChanged(_admin(), newAdmin);
261   }
262 
263   function updateAdmin() external {
264     address newAdmin = _pendingAdmin();
265     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
266     require(msg.sender == newAdmin, "msg.sender and newAdmin must be the same .");
267     _setAdmin(newAdmin);
268     _setPendingAdmin(address(0));
269     emit AdminUpdated(newAdmin);
270   }
271 
272   /**
273    * @dev Upgrade the backing implementation of the proxy.
274    * Only the admin can call this function.
275    * @param newImplementation Address of the new implementation.
276    */
277   function upgradeTo(address newImplementation) external ifAdmin {
278     _upgradeTo(newImplementation);
279   }
280 
281   /**
282    * @dev Upgrade the backing implementation of the proxy and call a function
283    * on the new implementation.
284    * This is useful to initialize the proxied contract.
285    * @param newImplementation Address of the new implementation.
286    * @param data Data to send as msg.data in the low level call.
287    * It should include the signature and the parameters of the function to be called, as described in
288    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
289    */
290   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
291     _upgradeTo(newImplementation);
292     (bool success,) = newImplementation.delegatecall(data);
293     require(success);
294   }
295 
296   /**
297    * @return The admin slot.
298    */
299   function _admin() internal view returns (address adm) {
300     bytes32 slot = ADMIN_SLOT;
301     assembly {
302       adm := sload(slot)
303     }
304   }
305 
306   /**
307    * @return The pendingAdmin slot.
308    */
309   function _pendingAdmin() internal view returns (address pendingAdm) {
310     bytes32 slot = PENDING_ADMIN_SLOT;
311     assembly {
312       pendingAdm := sload(slot)
313     }
314   }
315 
316   /**
317    * @dev Sets the address of the proxy admin.
318    * @param newAdmin Address of the new proxy admin.
319    */
320   function _setAdmin(address newAdmin) internal {
321     bytes32 slot = ADMIN_SLOT;
322 
323     assembly {
324       sstore(slot, newAdmin)
325     }
326   }
327 
328   /**
329    * @dev Sets the address of the proxy pending admin.
330    * @param pendingAdm Address of the proxy pending admin.
331    */
332   function _setPendingAdmin(address pendingAdm) internal {
333     bytes32 slot = PENDING_ADMIN_SLOT;
334 
335     assembly {
336       sstore(slot, pendingAdm)
337     }
338   }
339 
340   /**
341    * @dev Only fall back when the sender is not the admin.
342    */
343   function _willFallback() internal {
344     // require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
345     super._willFallback();
346   }
347 }
348 
349 /**
350  * @title AdminUpgradeabilityProxy
351  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for 
352  * initializing the implementation, admin, and init data.
353  */
354 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
355   /**
356    * Contract constructor.
357    * @param _logic address of the initial implementation.
358    * @param _admin Address of the proxy administrator.
359    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
360    * It should include the signature and the parameters of the function to be called, as described in
361    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
362    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
363    */
364   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
365     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
366     _setAdmin(_admin);
367   }
368 }
369 
370 contract XSwapProxy is AdminUpgradeabilityProxy {
371     constructor(address _implementation, bytes memory _data) public AdminUpgradeabilityProxy(_implementation, msg.sender, _data) {
372     }
373 }