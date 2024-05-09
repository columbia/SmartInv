1 /**
2  *Submitted for verification at Etherscan.io on 2018-10-22
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 // File: contracts/upgradeability/Proxy.sol
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
75 // File: openzeppelin-solidity/contracts/AddressUtils.sol
76 
77 /**
78  * Utility library of inline functions on addresses
79  */
80 library AddressUtils {
81 
82   /**
83    * Returns whether the target address is a contract
84    * @dev This function will return false if invoked during the constructor of a contract,
85    *  as the code is not actually created until after the constructor finishes.
86    * @param addr address to check
87    * @return whether the target address is a contract
88    */
89   function isContract(address addr) internal view returns (bool) {
90     uint256 size;
91     // XXX Currently there is no better way to check if there is a contract in an address
92     // than to check the size of the code at that address.
93     // See https://ethereum.stackexchange.com/a/14016/36603
94     // for more details about how this works.
95     // TODO Check this again before the Serenity release, because all addresses will be
96     // contracts then.
97     // solium-disable-next-line security/no-inline-assembly
98     assembly { size := extcodesize(addr) }
99     return size > 0;
100   }
101 
102 }
103 
104 // File: contracts/upgradeability/UpgradeabilityProxy.sol
105 
106 /**
107  * @title UpgradeabilityProxy
108  * @dev This contract implements a proxy that allows to change the
109  * implementation address to which it will delegate.
110  * Such a change is called an implementation upgrade.
111  */
112 contract UpgradeabilityProxy is Proxy {
113   /**
114    * @dev Emitted when the implementation is upgraded.
115    * @param implementation Address of the new implementation.
116    */
117   event Upgraded(address indexed implementation);
118 
119   /**
120    * @dev Storage slot with the address of the current implementation.
121    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
122    * validated in the constructor.
123    */
124   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
125 
126   /**
127    * @dev Contract constructor.
128    * @param _implementation Address of the initial implementation.
129    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
130    * It should include the signature and the parameters of the function to be called, as described in
131    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
132    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
133    */
134   constructor(address _implementation, bytes _data) public payable {
135     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
136     _setImplementation(_implementation);
137     if(_data.length > 0) {
138       require(_implementation.delegatecall(_data));
139     }
140   }
141 
142   /**
143    * @dev Returns the current implementation.
144    * @return Address of the current implementation
145    */
146   function _implementation() internal view returns (address impl) {
147     bytes32 slot = IMPLEMENTATION_SLOT;
148     assembly {
149       impl := sload(slot)
150     }
151   }
152 
153   /**
154    * @dev Upgrades the proxy to a new implementation.
155    * @param newImplementation Address of the new implementation.
156    */
157   function _upgradeTo(address newImplementation) internal {
158     _setImplementation(newImplementation);
159     emit Upgraded(newImplementation);
160   }
161 
162   /**
163    * @dev Sets the implementation address of the proxy.
164    * @param newImplementation Address of the new implementation.
165    */
166   function _setImplementation(address newImplementation) private {
167     require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
168 
169     bytes32 slot = IMPLEMENTATION_SLOT;
170 
171     assembly {
172       sstore(slot, newImplementation)
173     }
174   }
175 }
176 
177 // File: contracts/upgradeability/AdminUpgradeabilityProxy.sol
178 
179 /**
180  * @title AdminUpgradeabilityProxy
181  * @dev This contract combines an upgradeability proxy with an authorization
182  * mechanism for administrative tasks.
183  * All external functions in this contract must be guarded by the
184  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
185  * feature proposal that would enable this to be done automatically.
186  */
187 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
188   /**
189    * @dev Emitted when the administration has been transferred.
190    * @param previousAdmin Address of the previous admin.
191    * @param newAdmin Address of the new admin.
192    */
193   event AdminChanged(address previousAdmin, address newAdmin);
194 
195   /**
196    * @dev Storage slot with the admin of the contract.
197    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
198    * validated in the constructor.
199    */
200   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
201 
202   /**
203    * @dev Modifier to check whether the `msg.sender` is the admin.
204    * If it is, it will run the function. Otherwise, it will delegate the call
205    * to the implementation.
206    */
207   modifier ifAdmin() {
208     if (msg.sender == _admin()) {
209       _;
210     } else {
211       _fallback();
212     }
213   }
214 
215   /**
216    * Contract constructor.
217    * It sets the `msg.sender` as the proxy administrator.
218    * @param _implementation address of the initial implementation.
219    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
220    * It should include the signature and the parameters of the function to be called, as described in
221    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
222    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
223    */
224   constructor(address _implementation, bytes _data) UpgradeabilityProxy(_implementation, _data) public payable {
225     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
226 
227     _setAdmin(msg.sender);
228   }
229 
230   /**
231    * @return The address of the proxy admin.
232    */
233   function admin() external view ifAdmin returns (address) {
234     return _admin();
235   }
236 
237   /**
238    * @return The address of the implementation.
239    */
240   function implementation() external view ifAdmin returns (address) {
241     return _implementation();
242   }
243 
244   /**
245    * @dev Changes the admin of the proxy.
246    * Only the current admin can call this function.
247    * @param newAdmin Address to transfer proxy administration to.
248    */
249   function changeAdmin(address newAdmin) external ifAdmin {
250     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
251     emit AdminChanged(_admin(), newAdmin);
252     _setAdmin(newAdmin);
253   }
254 
255   /**
256    * @dev Upgrade the backing implementation of the proxy.
257    * Only the admin can call this function.
258    * @param newImplementation Address of the new implementation.
259    */
260   function upgradeTo(address newImplementation) external ifAdmin {
261     _upgradeTo(newImplementation);
262   }
263 
264   /**
265    * @dev Upgrade the backing implementation of the proxy and call a function
266    * on the new implementation.
267    * This is useful to initialize the proxied contract.
268    * @param newImplementation Address of the new implementation.
269    * @param data Data to send as msg.data in the low level call.
270    * It should include the signature and the parameters of the function to be called, as described in
271    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
272    */
273   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
274     _upgradeTo(newImplementation);
275     require(newImplementation.delegatecall(data));
276   }
277 
278   /**
279    * @return The admin slot.
280    */
281   function _admin() internal view returns (address adm) {
282     bytes32 slot = ADMIN_SLOT;
283     assembly {
284       adm := sload(slot)
285     }
286   }
287 
288   /**
289    * @dev Sets the address of the proxy admin.
290    * @param newAdmin Address of the new proxy admin.
291    */
292   function _setAdmin(address newAdmin) internal {
293     bytes32 slot = ADMIN_SLOT;
294 
295     assembly {
296       sstore(slot, newAdmin)
297     }
298   }
299 
300   /**
301    * @dev Only fall back when the sender is not the admin.
302    */
303   function _willFallback() internal {
304     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
305     super._willFallback();
306   }
307 }