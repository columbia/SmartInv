1 pragma solidity >=0.4.24 <0.6.0;
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
70 /**
71  * Utility library of inline functions on addresses
72  *
73  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.0.0/contracts/utils/Address.sol
74  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
75  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
76  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
77  */
78 library ZOSLibAddress {
79 
80   /**
81    * Returns whether the target address is a contract
82    * @dev This function will return false if invoked during the constructor of a contract,
83    * as the code is not actually created until after the constructor finishes.
84    * @param account address of the account to check
85    * @return whether the target address is a contract
86    */
87   function isContract(address account) internal view returns (bool) {
88     uint256 size;
89     // XXX Currently there is no better way to check if there is a contract in an address
90     // than to check the size of the code at that address.
91     // See https://ethereum.stackexchange.com/a/14016/36603
92     // for more details about how this works.
93     // TODO Check this again before the Serenity release, because all addresses will be
94     // contracts then.
95     // solium-disable-next-line security/no-inline-assembly
96     assembly { size := extcodesize(account) }
97     return size > 0;
98   }
99 
100 }
101 
102 
103 /**
104  * @title UpgradeabilityProxy
105  * @dev This contract implements a proxy that allows to change the
106  * implementation address to which it will delegate.
107  * Such a change is called an implementation upgrade.
108  */
109 contract UpgradeabilityProxy is Proxy {
110   /**
111    * @dev Emitted when the implementation is upgraded.
112    * @param implementation Address of the new implementation.
113    */
114   event Upgraded(address indexed implementation);
115 
116   /**
117    * @dev Storage slot with the address of the current implementation.
118    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
119    * validated in the constructor.
120    */
121   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
122 
123   /**
124    * @dev Contract constructor.
125    * @param _implementation Address of the initial implementation.
126    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
127    * It should include the signature and the parameters of the function to be called, as described in
128    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
129    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
130    */
131   constructor(address _implementation, bytes memory _data) public payable {
132     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
133     _setImplementation(_implementation);
134     if(_data.length > 0) {
135       (bool ok,) = _implementation.delegatecall(_data);
136       require(ok);
137     }
138   }
139 
140   /**
141    * @dev Returns the current implementation.
142    * @return Address of the current implementation
143    */
144   function _implementation() internal view returns (address impl) {
145     bytes32 slot = IMPLEMENTATION_SLOT;
146     assembly {
147       impl := sload(slot)
148     }
149   }
150 
151   /**
152    * @dev Upgrades the proxy to a new implementation.
153    * @param newImplementation Address of the new implementation.
154    */
155   function _upgradeTo(address newImplementation) internal {
156     _setImplementation(newImplementation);
157     emit Upgraded(newImplementation);
158   }
159 
160   /**
161    * @dev Sets the implementation address of the proxy.
162    * @param newImplementation Address of the new implementation.
163    */
164   function _setImplementation(address newImplementation) private {
165     require(ZOSLibAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
166 
167     bytes32 slot = IMPLEMENTATION_SLOT;
168 
169     assembly {
170       sstore(slot, newImplementation)
171     }
172   }
173 }
174 
175 
176 /**
177  * @title AdminUpgradeabilityProxy
178  * @dev This contract combines an upgradeability proxy with an authorization
179  * mechanism for administrative tasks.
180  * All external functions in this contract must be guarded by the
181  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
182  * feature proposal that would enable this to be done automatically.
183  */
184 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
185   /**
186    * @dev Emitted when the administration has been transferred.
187    * @param previousAdmin Address of the previous admin.
188    * @param newAdmin Address of the new admin.
189    */
190   event AdminChanged(address previousAdmin, address newAdmin);
191 
192   /**
193    * @dev Storage slot with the admin of the contract.
194    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
195    * validated in the constructor.
196    */
197   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
198 
199   /**
200    * @dev Modifier to check whether the `msg.sender` is the admin.
201    * If it is, it will run the function. Otherwise, it will delegate the call
202    * to the implementation.
203    */
204   modifier ifAdmin() {
205     if (msg.sender == _admin()) {
206       _;
207     } else {
208       _fallback();
209     }
210   }
211 
212   /**
213    * Contract constructor.
214    * @param _implementation address of the initial implementation.
215    * @param _admin Address of the proxy administrator.
216    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
217    * It should include the signature and the parameters of the function to be called, as described in
218    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
219    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
220    */
221   constructor(address _implementation, address _admin, bytes memory _data) UpgradeabilityProxy(_implementation, _data) public payable {
222     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
223 
224     _setAdmin(_admin);
225   }
226 
227   /**
228    * @return The address of the proxy admin.
229    */
230   function admin() external ifAdmin returns (address) {
231     return _admin();
232   }
233 
234   /**
235    * @return The address of the implementation.
236    */
237   function implementation() external ifAdmin returns (address) {
238     return _implementation();
239   }
240 
241   /**
242    * @dev Changes the admin of the proxy.
243    * Only the current admin can call this function.
244    * @param newAdmin Address to transfer proxy administration to.
245    */
246   function changeAdmin(address newAdmin) external ifAdmin {
247     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
248     emit AdminChanged(_admin(), newAdmin);
249     _setAdmin(newAdmin);
250   }
251 
252   /**
253    * @dev Upgrade the backing implementation of the proxy.
254    * Only the admin can call this function.
255    * @param newImplementation Address of the new implementation.
256    */
257   function upgradeTo(address newImplementation) external ifAdmin {
258     _upgradeTo(newImplementation);
259   }
260 
261   /**
262    * @dev Upgrade the backing implementation of the proxy and call a function
263    * on the new implementation.
264    * This is useful to initialize the proxied contract.
265    * @param newImplementation Address of the new implementation.
266    * @param data Data to send as msg.data in the low level call.
267    * It should include the signature and the parameters of the function to be called, as described in
268    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
269    */
270   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
271     _upgradeTo(newImplementation);
272     (bool ok,) = newImplementation.delegatecall(data);
273     require(ok);
274   }
275 
276   /**
277    * @return The admin slot.
278    */
279   function _admin() internal view returns (address adm) {
280     bytes32 slot = ADMIN_SLOT;
281     assembly {
282       adm := sload(slot)
283     }
284   }
285 
286   /**
287    * @dev Sets the address of the proxy admin.
288    * @param newAdmin Address of the new proxy admin.
289    */
290   function _setAdmin(address newAdmin) internal {
291     bytes32 slot = ADMIN_SLOT;
292 
293     assembly {
294       sstore(slot, newAdmin)
295     }
296   }
297 
298   /**
299    * @dev Only fall back when the sender is not the admin.
300    */
301   function _willFallback() internal {
302     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
303     super._willFallback();
304   }
305 }
