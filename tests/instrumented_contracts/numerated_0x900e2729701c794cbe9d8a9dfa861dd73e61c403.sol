1 pragma solidity ^0.4.24;
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
71  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.0.0/contracts/utils/Address.sol
72  */
73 library Address {
74 
75   /**
76    * Returns whether the target address is a contract
77    * @dev This function will return false if invoked during the constructor of a contract,
78    * as the code is not actually created until after the constructor finishes.
79    * @param account address of the account to check
80    * @return whether the target address is a contract
81    */
82   function isContract(address account) internal view returns (bool) {
83     uint256 size;
84     // XXX Currently there is no better way to check if there is a contract in an address
85     // than to check the size of the code at that address.
86     // See https://ethereum.stackexchange.com/a/14016/36603
87     // for more details about how this works.
88     // TODO Check this again before the Serenity release, because all addresses will be
89     // contracts then.
90     // solium-disable-next-line security/no-inline-assembly
91     assembly { size := extcodesize(account) }
92     return size > 0;
93   }
94 
95 }
96 
97 /**
98  * @title UpgradeabilityProxy
99  * @dev This contract implements a proxy that allows to change the
100  * implementation address to which it will delegate.
101  * Such a change is called an implementation upgrade.
102  */
103 contract UpgradeabilityProxy is Proxy {
104   /**
105    * @dev Emitted when the implementation is upgraded.
106    * @param implementation Address of the new implementation.
107    */
108   event Upgraded(address indexed implementation);
109 
110   /**
111    * @dev Storage slot with the address of the current implementation.
112    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
113    * validated in the constructor.
114    */
115   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
116 
117   /**
118    * @dev Contract constructor.
119    * @param _implementation Address of the initial implementation.
120    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
121    * It should include the signature and the parameters of the function to be called, as described in
122    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
123    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
124    */
125   constructor(address _implementation, bytes _data) public payable {
126     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
127     _setImplementation(_implementation);
128     if(_data.length > 0) {
129       require(_implementation.delegatecall(_data));
130     }
131   }
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
157   function _setImplementation(address newImplementation) private {
158     require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
159 
160     bytes32 slot = IMPLEMENTATION_SLOT;
161 
162     assembly {
163       sstore(slot, newImplementation)
164     }
165   }
166 }
167 
168 /**
169  * @title AdminUpgradeabilityProxy
170  * @dev This contract combines an upgradeability proxy with an authorization
171  * mechanism for administrative tasks.
172  * All external functions in this contract must be guarded by the
173  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
174  * feature proposal that would enable this to be done automatically.
175  */
176 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
177   /**
178    * @dev Emitted when the administration has been transferred.
179    * @param previousAdmin Address of the previous admin.
180    * @param newAdmin Address of the new admin.
181    */
182   event AdminChanged(address previousAdmin, address newAdmin);
183 
184   /**
185    * @dev Storage slot with the admin of the contract.
186    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
187    * validated in the constructor.
188    */
189   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
190 
191   /**
192    * @dev Modifier to check whether the `msg.sender` is the admin.
193    * If it is, it will run the function. Otherwise, it will delegate the call
194    * to the implementation.
195    */
196   modifier ifAdmin() {
197     if (msg.sender == _admin()) {
198       _;
199     } else {
200       _fallback();
201     }
202   }
203 
204   /**
205    * Contract constructor.
206    * @param _implementation address of the initial implementation.
207    * @param _admin Address of the proxy administrator.
208    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
209    * It should include the signature and the parameters of the function to be called, as described in
210    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
211    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
212    */
213   constructor(address _implementation, address _admin, bytes _data) UpgradeabilityProxy(_implementation, _data) public payable {
214     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
215 
216     _setAdmin(_admin);
217   }
218 
219   /**
220    * @return The address of the proxy admin.
221    */
222   function admin() external view ifAdmin returns (address) {
223     return _admin();
224   }
225 
226   /**
227    * @return The address of the implementation.
228    */
229   function implementation() external view ifAdmin returns (address) {
230     return _implementation();
231   }
232 
233   /**
234    * @dev Changes the admin of the proxy.
235    * Only the current admin can call this function.
236    * @param newAdmin Address to transfer proxy administration to.
237    */
238   function changeAdmin(address newAdmin) external ifAdmin {
239     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
240     emit AdminChanged(_admin(), newAdmin);
241     _setAdmin(newAdmin);
242   }
243 
244   /**
245    * @dev Upgrade the backing implementation of the proxy.
246    * Only the admin can call this function.
247    * @param newImplementation Address of the new implementation.
248    */
249   function upgradeTo(address newImplementation) external ifAdmin {
250     _upgradeTo(newImplementation);
251   }
252 
253   /**
254    * @dev Upgrade the backing implementation of the proxy and call a function
255    * on the new implementation.
256    * This is useful to initialize the proxied contract.
257    * @param newImplementation Address of the new implementation.
258    * @param data Data to send as msg.data in the low level call.
259    * It should include the signature and the parameters of the function to be called, as described in
260    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
261    */
262   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
263     _upgradeTo(newImplementation);
264     require(newImplementation.delegatecall(data));
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