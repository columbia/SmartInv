1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-09
3 */
4 
5 // File: @openzeppelin/upgrades/contracts/upgradeability/Proxy.sol
6 
7 pragma solidity ^0.5.0;
8 
9 /**
10  * @title Proxy
11  * @dev Implements delegation of calls to other contracts, with proper
12  * forwarding of return values and bubbling of failures.
13  * It defines a fallback function that delegates all calls to the address
14  * returned by the abstract _implementation() internal function.
15  */
16 contract Proxy {
17   /**
18    * @dev Fallback function.
19    * Implemented entirely in `_fallback`.
20    */
21   function () payable external {
22     _fallback();
23   }
24 
25   /**
26    * @return The Address of the implementation.
27    */
28   function _implementation() internal view returns (address);
29 
30   /**
31    * @dev Delegates execution to an implementation contract.
32    * This is a low level function that doesn't return to its internal call site.
33    * It will return to the external caller whatever the implementation returns.
34    * @param implementation Address to delegate.
35    */
36   function _delegate(address implementation) internal {
37     assembly {
38       // Copy msg.data. We take full control of memory in this inline assembly
39       // block because it will not return to Solidity code. We overwrite the
40       // Solidity scratch pad at memory position 0.
41       calldatacopy(0, 0, calldatasize)
42 
43       // Call the implementation.
44       // out and outsize are 0 because we don't know the size yet.
45       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
46 
47       // Copy the returned data.
48       returndatacopy(0, 0, returndatasize)
49 
50       switch result
51       // delegatecall returns 0 on error.
52       case 0 { revert(0, returndatasize) }
53       default { return(0, returndatasize) }
54     }
55   }
56 
57   /**
58    * @dev Function that is run as the first thing in the fallback function.
59    * Can be redefined in derived contracts to add functionality.
60    * Redefinitions must call super._willFallback().
61    */
62   function _willFallback() internal {
63   }
64 
65   /**
66    * @dev fallback implementation.
67    * Extracted to enable manual triggering.
68    */
69   function _fallback() internal {
70     _willFallback();
71     _delegate(_implementation());
72   }
73 }
74 
75 // File: @openzeppelin/upgrades/contracts/utils/Address.sol
76 
77 pragma solidity ^0.5.0;
78 
79 /**
80  * Utility library of inline functions on addresses
81  *
82  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
83  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
84  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
85  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
86  */
87 library OpenZeppelinUpgradesAddress {
88     /**
89      * Returns whether the target address is a contract
90      * @dev This function will return false if invoked during the constructor of a contract,
91      * as the code is not actually created until after the constructor finishes.
92      * @param account address of the account to check
93      * @return whether the target address is a contract
94      */
95     function isContract(address account) internal view returns (bool) {
96         uint256 size;
97         // XXX Currently there is no better way to check if there is a contract in an address
98         // than to check the size of the code at that address.
99         // See https://ethereum.stackexchange.com/a/14016/36603
100         // for more details about how this works.
101         // TODO Check this again before the Serenity release, because all addresses will be
102         // contracts then.
103         // solhint-disable-next-line no-inline-assembly
104         assembly { size := extcodesize(account) }
105         return size > 0;
106     }
107 }
108 
109 // File: @openzeppelin/upgrades/contracts/upgradeability/BaseUpgradeabilityProxy.sol
110 
111 pragma solidity ^0.5.0;
112 
113 
114 
115 /**
116  * @title BaseUpgradeabilityProxy
117  * @dev This contract implements a proxy that allows to change the
118  * implementation address to which it will delegate.
119  * Such a change is called an implementation upgrade.
120  */
121 contract BaseUpgradeabilityProxy is Proxy {
122   /**
123    * @dev Emitted when the implementation is upgraded.
124    * @param implementation Address of the new implementation.
125    */
126   event Upgraded(address indexed implementation);
127 
128   /**
129    * @dev Storage slot with the address of the current implementation.
130    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
131    * validated in the constructor.
132    */
133   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
134 
135   /**
136    * @dev Returns the current implementation.
137    * @return Address of the current implementation
138    */
139   function _implementation() internal view returns (address impl) {
140     bytes32 slot = IMPLEMENTATION_SLOT;
141     assembly {
142       impl := sload(slot)
143     }
144   }
145 
146   /**
147    * @dev Upgrades the proxy to a new implementation.
148    * @param newImplementation Address of the new implementation.
149    */
150   function _upgradeTo(address newImplementation) internal {
151     _setImplementation(newImplementation);
152     emit Upgraded(newImplementation);
153   }
154 
155   /**
156    * @dev Sets the implementation address of the proxy.
157    * @param newImplementation Address of the new implementation.
158    */
159   function _setImplementation(address newImplementation) internal {
160     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
161 
162     bytes32 slot = IMPLEMENTATION_SLOT;
163 
164     assembly {
165       sstore(slot, newImplementation)
166     }
167   }
168 }
169 
170 // File: @openzeppelin/upgrades/contracts/upgradeability/UpgradeabilityProxy.sol
171 
172 pragma solidity ^0.5.0;
173 
174 
175 /**
176  * @title UpgradeabilityProxy
177  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
178  * implementation and init data.
179  */
180 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
181   /**
182    * @dev Contract constructor.
183    * @param _logic Address of the initial implementation.
184    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
185    * It should include the signature and the parameters of the function to be called, as described in
186    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
187    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
188    */
189   constructor(address _logic, bytes memory _data) public payable {
190     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
191     _setImplementation(_logic);
192     if(_data.length > 0) {
193       (bool success,) = _logic.delegatecall(_data);
194       require(success);
195     }
196   }  
197 }
198 
199 // File: @openzeppelin/upgrades/contracts/upgradeability/BaseAdminUpgradeabilityProxy.sol
200 
201 pragma solidity ^0.5.0;
202 
203 
204 /**
205  * @title BaseAdminUpgradeabilityProxy
206  * @dev This contract combines an upgradeability proxy with an authorization
207  * mechanism for administrative tasks.
208  * All external functions in this contract must be guarded by the
209  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
210  * feature proposal that would enable this to be done automatically.
211  */
212 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
213   /**
214    * @dev Emitted when the administration has been transferred.
215    * @param previousAdmin Address of the previous admin.
216    * @param newAdmin Address of the new admin.
217    */
218   event AdminChanged(address previousAdmin, address newAdmin);
219 
220   /**
221    * @dev Storage slot with the admin of the contract.
222    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
223    * validated in the constructor.
224    */
225 
226   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
227 
228   /**
229    * @dev Modifier to check whether the `msg.sender` is the admin.
230    * If it is, it will run the function. Otherwise, it will delegate the call
231    * to the implementation.
232    */
233   modifier ifAdmin() {
234     if (msg.sender == _admin()) {
235       _;
236     } else {
237       _fallback();
238     }
239   }
240 
241   /**
242    * @return The address of the proxy admin.
243    */
244   function admin() external ifAdmin returns (address) {
245     return _admin();
246   }
247 
248   /**
249    * @return The address of the implementation.
250    */
251   function implementation() external ifAdmin returns (address) {
252     return _implementation();
253   }
254 
255   /**
256    * @dev Changes the admin of the proxy.
257    * Only the current admin can call this function.
258    * @param newAdmin Address to transfer proxy administration to.
259    */
260   function changeAdmin(address newAdmin) external ifAdmin {
261     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
262     emit AdminChanged(_admin(), newAdmin);
263     _setAdmin(newAdmin);
264   }
265 
266   /**
267    * @dev Upgrade the backing implementation of the proxy.
268    * Only the admin can call this function.
269    * @param newImplementation Address of the new implementation.
270    */
271   function upgradeTo(address newImplementation) external ifAdmin {
272     _upgradeTo(newImplementation);
273   }
274 
275   /**
276    * @dev Upgrade the backing implementation of the proxy and call a function
277    * on the new implementation.
278    * This is useful to initialize the proxied contract.
279    * @param newImplementation Address of the new implementation.
280    * @param data Data to send as msg.data in the low level call.
281    * It should include the signature and the parameters of the function to be called, as described in
282    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
283    */
284   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
285     _upgradeTo(newImplementation);
286     (bool success,) = newImplementation.delegatecall(data);
287     require(success);
288   }
289 
290   /**
291    * @return The admin slot.
292    */
293   function _admin() internal view returns (address adm) {
294     bytes32 slot = ADMIN_SLOT;
295     assembly {
296       adm := sload(slot)
297     }
298   }
299 
300   /**
301    * @dev Sets the address of the proxy admin.
302    * @param newAdmin Address of the new proxy admin.
303    */
304   function _setAdmin(address newAdmin) internal {
305     bytes32 slot = ADMIN_SLOT;
306 
307     assembly {
308       sstore(slot, newAdmin)
309     }
310   }
311 
312   /**
313    * @dev Only fall back when the sender is not the admin.
314    */
315   function _willFallback() internal {
316     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
317     super._willFallback();
318   }
319 }
320 
321 // File: @openzeppelin/upgrades/contracts/upgradeability/AdminUpgradeabilityProxy.sol
322 
323 pragma solidity ^0.5.0;
324 
325 
326 /**
327  * @title AdminUpgradeabilityProxy
328  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for 
329  * initializing the implementation, admin, and init data.
330  */
331 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
332   /**
333    * Contract constructor.
334    * @param _logic address of the initial implementation.
335    * @param _admin Address of the proxy administrator.
336    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
337    * It should include the signature and the parameters of the function to be called, as described in
338    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
339    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
340    */
341   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
342     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
343     _setAdmin(_admin);
344   }
345 }