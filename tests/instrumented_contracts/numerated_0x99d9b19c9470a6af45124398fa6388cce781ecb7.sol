1 pragma solidity 0.5.7;
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
69 
70 
71 /**
72  * Utility library of inline functions on addresses
73  *
74  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
75  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
76  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
77  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
78  */
79 library ZOSLibAddress {
80     /**
81      * Returns whether the target address is a contract
82      * @dev This function will return false if invoked during the constructor of a contract,
83      * as the code is not actually created until after the constructor finishes.
84      * @param account address of the account to check
85      * @return whether the target address is a contract
86      */
87     function isContract(address account) internal view returns (bool) {
88         uint256 size;
89         // XXX Currently there is no better way to check if there is a contract in an address
90         // than to check the size of the code at that address.
91         // See https://ethereum.stackexchange.com/a/14016/36603
92         // for more details about how this works.
93         // TODO Check this again before the Serenity release, because all addresses will be
94         // contracts then.
95         // solhint-disable-next-line no-inline-assembly
96         assembly { size := extcodesize(account) }
97         return size > 0;
98     }
99 }
100 
101 /**
102  * @title BaseUpgradeabilityProxy
103  * @dev This contract implements a proxy that allows to change the
104  * implementation address to which it will delegate.
105  * Such a change is called an implementation upgrade.
106  */
107 contract BaseUpgradeabilityProxy is Proxy {
108   /**
109    * @dev Emitted when the implementation is upgraded.
110    * @param implementation Address of the new implementation.
111    */
112   event Upgraded(address indexed implementation);
113 
114   /**
115    * @dev Storage slot with the address of the current implementation.
116    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
117    * validated in the constructor.
118    */
119   bytes32 internal constant IMPLEMENTATION_SLOT = 0x6373548c81aec7af8a152e649030793ecf1835415f396e2eafb522eedc3c06e9;
120 
121   /**
122    * @dev Returns the current implementation.
123    * @return Address of the current implementation
124    */
125   function _implementation() internal view returns (address impl) {
126     bytes32 slot = IMPLEMENTATION_SLOT;
127     assembly {
128       impl := sload(slot)
129     }
130   }
131 
132   /**
133    * @dev Upgrades the proxy to a new implementation.
134    * @param newImplementation Address of the new implementation.
135    */
136   function _upgradeTo(address newImplementation) internal {
137     _setImplementation(newImplementation);
138     emit Upgraded(newImplementation);
139   }
140 
141   /**
142    * @dev Sets the implementation address of the proxy.
143    * @param newImplementation Address of the new implementation.
144    */
145   function _setImplementation(address newImplementation) internal {
146     require(ZOSLibAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
147 
148     bytes32 slot = IMPLEMENTATION_SLOT;
149 
150     assembly {
151       sstore(slot, newImplementation)
152     }
153   }
154 }
155 
156 
157 /**
158  * @title UpgradeabilityProxy
159  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
160  * implementation and init data.
161  */
162 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
163   /**
164    * @dev Contract constructor.
165    * @param _logic Address of the initial implementation.
166    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
167    * It should include the signature and the parameters of the function to be called, as described in
168    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
169    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
170    */
171   constructor(address _logic, bytes memory _data) public payable {
172     assert(IMPLEMENTATION_SLOT == keccak256("org.loopring.proxy.implementation"));
173     _setImplementation(_logic);
174     /* if(_data.length > 0) { */
175     /*   (bool success,) = _logic.delegatecall(_data); */
176     /*   require(success); */
177     /* } */
178   }
179 }
180 
181 
182 /**
183  * @title BaseAdminUpgradeabilityProxy
184  * @dev This contract combines an upgradeability proxy with an authorization
185  * mechanism for administrative tasks.
186  * All external functions in this contract must be guarded by the
187  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
188  * feature proposal that would enable this to be done automatically.
189  */
190 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
191   /**
192    * @dev Emitted when the administration has been transferred.
193    * @param previousAdmin Address of the previous admin.
194    * @param newAdmin Address of the new admin.
195    */
196   event AdminChanged(address previousAdmin, address newAdmin);
197 
198   /**
199    * @dev Storage slot with the admin of the contract.
200    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
201    * validated in the constructor.
202    */
203   bytes32 internal constant ADMIN_SLOT = 0x0cbe1756fc073c7e8f4075e2df79a804181fe791bbb6ceadc4d3e357017a748f;
204 
205   /**
206    * @dev Modifier to check whether the `msg.sender` is the admin.
207    * If it is, it will run the function. Otherwise, it will delegate the call
208    * to the implementation.
209    */
210   modifier ifAdmin() {
211     if (msg.sender == _admin()) {
212       _;
213     } else {
214       _fallback();
215     }
216   }
217 
218   /**
219    * @return The address of the proxy admin.
220    */
221   function admin() external ifAdmin returns (address) {
222     return _admin();
223   }
224 
225   /**
226    * @return The address of the implementation.
227    */
228   function implementation() external ifAdmin returns (address) {
229     return _implementation();
230   }
231 
232   /**
233    * @dev Changes the admin of the proxy.
234    * Only the current admin can call this function.
235    * @param newAdmin Address to transfer proxy administration to.
236    */
237   function changeAdmin(address newAdmin) external ifAdmin {
238     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
239     emit AdminChanged(_admin(), newAdmin);
240     _setAdmin(newAdmin);
241   }
242 
243   /**
244    * @dev Upgrade the backing implementation of the proxy.
245    * Only the admin can call this function.
246    * @param newImplementation Address of the new implementation.
247    */
248   function upgradeTo(address newImplementation) external ifAdmin {
249     _upgradeTo(newImplementation);
250   }
251 
252   /**
253    * @dev Upgrade the backing implementation of the proxy and call a function
254    * on the new implementation.
255    * This is useful to initialize the proxied contract.
256    * @param newImplementation Address of the new implementation.
257    * @param data Data to send as msg.data in the low level call.
258    * It should include the signature and the parameters of the function to be called, as described in
259    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
260    */
261   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
262     _upgradeTo(newImplementation);
263     (bool success,) = newImplementation.delegatecall(data);
264     require(success);
265   }
266 
267   /**
268    * @return The admin slot.
269    */
270   function _admin() internal view returns (address adm) {
271     bytes32 slot = ADMIN_SLOT;
272     assembly {
273       adm := sload(slot)
274     }
275   }
276 
277   /**
278    * @dev Sets the address of the proxy admin.
279    * @param newAdmin Address of the new proxy admin.
280    */
281   function _setAdmin(address newAdmin) internal {
282     bytes32 slot = ADMIN_SLOT;
283 
284     assembly {
285       sstore(slot, newAdmin)
286     }
287   }
288 
289   /**
290    * @dev Only fall back when the sender is not the admin.
291    */
292   function _willFallback() internal {
293     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
294     super._willFallback();
295   }
296 }
297 
298 
299 /**
300  * @title AdminUpgradeabilityProxy
301  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for
302  * initializing the implementation, admin, and init data.
303  */
304 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
305   /**
306    * Contract constructor.
307    * @param _logic address of the initial implementation.
308    * @param _admin Address of the proxy administrator.
309    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
310    * It should include the signature and the parameters of the function to be called, as described in
311    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
312    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
313    */
314   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
315     assert(ADMIN_SLOT == keccak256("org.loopring.proxy.admin"));
316     _setAdmin(_admin);
317   }
318 }
319 
320 contract LoopringAdminUpgradeabilityProxy is AdminUpgradeabilityProxy {
321     constructor(address _implementation, address _admin) public
322         AdminUpgradeabilityProxy(_implementation, _admin, bytes("")) {
323     }
324 }