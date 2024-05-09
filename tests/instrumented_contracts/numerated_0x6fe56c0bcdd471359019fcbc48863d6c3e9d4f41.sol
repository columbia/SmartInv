1 // File: contracts/upgradeability/Proxy.sol
2 
3 pragma solidity ^0.4.24;
4 
5 /**
6  * @title Proxy
7  * @dev Implements delegation of calls to other contracts, with proper
8  * forwarding of return values and bubbling of failures.
9  * It defines a fallback function that delegates all calls to the address
10  * returned by the abstract _implementation() internal function.
11  */
12 contract Proxy {
13   /**
14    * @dev Fallback function.
15    * Implemented entirely in `_fallback`.
16    */
17   function () payable external {
18     _fallback();
19   }
20 
21   /**
22    * @return The Address of the implementation.
23    */
24   function _implementation() internal view returns (address);
25 
26   /**
27    * @dev Delegates execution to an implementation contract.
28    * This is a low level function that doesn't return to its internal call site.
29    * It will return to the external caller whatever the implementation returns.
30    * @param implementation Address to delegate.
31    */
32   function _delegate(address implementation) internal {
33     assembly {
34       // Copy msg.data. We take full control of memory in this inline assembly
35       // block because it will not return to Solidity code. We overwrite the
36       // Solidity scratch pad at memory position 0.
37       calldatacopy(0, 0, calldatasize)
38 
39       // Call the implementation.
40       // out and outsize are 0 because we don't know the size yet.
41       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
42 
43       // Copy the returned data.
44       returndatacopy(0, 0, returndatasize)
45 
46       switch result
47       // delegatecall returns 0 on error.
48       case 0 { revert(0, returndatasize) }
49       default { return(0, returndatasize) }
50     }
51   }
52 
53   /**
54    * @dev Function that is run as the first thing in the fallback function.
55    * Can be redefined in derived contracts to add functionality.
56    * Redefinitions must call super._willFallback().
57    */
58   function _willFallback() internal {
59   }
60 
61   /**
62    * @dev fallback implementation.
63    * Extracted to enable manual triggering.
64    */
65   function _fallback() internal {
66     _willFallback();
67     _delegate(_implementation());
68   }
69 }
70 
71 // File: openzeppelin-solidity/contracts/AddressUtils.sol
72 
73 pragma solidity ^0.4.23;
74 
75 
76 /**
77  * Utility library of inline functions on addresses
78  */
79 library AddressUtils {
80 
81   /**
82    * Returns whether the target address is a contract
83    * @dev This function will return false if invoked during the constructor of a contract,
84    *  as the code is not actually created until after the constructor finishes.
85    * @param addr address to check
86    * @return whether the target address is a contract
87    */
88   function isContract(address addr) internal view returns (bool) {
89     uint256 size;
90     // XXX Currently there is no better way to check if there is a contract in an address
91     // than to check the size of the code at that address.
92     // See https://ethereum.stackexchange.com/a/14016/36603
93     // for more details about how this works.
94     // TODO Check this again before the Serenity release, because all addresses will be
95     // contracts then.
96     // solium-disable-next-line security/no-inline-assembly
97     assembly { size := extcodesize(addr) }
98     return size > 0;
99   }
100 
101 }
102 
103 // File: contracts/upgradeability/UpgradeabilityProxy.sol
104 
105 pragma solidity ^0.4.24;
106 
107 
108 
109 /**
110  * @title UpgradeabilityProxy
111  * @dev This contract implements a proxy that allows to change the
112  * implementation address to which it will delegate.
113  * Such a change is called an implementation upgrade.
114  */
115 contract UpgradeabilityProxy is Proxy {
116   /**
117    * @dev Emitted when the implementation is upgraded.
118    * @param implementation Address of the new implementation.
119    */
120   event Upgraded(address indexed implementation);
121 
122   /**
123    * @dev Storage slot with the address of the current implementation.
124    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
125    * validated in the constructor.
126    */
127   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
128 
129   /**
130    * @dev Contract constructor.
131    * @param _implementation Address of the initial implementation.
132    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
133    * It should include the signature and the parameters of the function to be called, as described in
134    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
135    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
136    */
137   constructor(address _implementation, bytes _data) public payable {
138     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
139     _setImplementation(_implementation);
140     if(_data.length > 0) {
141       require(_implementation.delegatecall(_data));
142     }
143   }
144 
145   /**
146    * @dev Returns the current implementation.
147    * @return Address of the current implementation
148    */
149   function _implementation() internal view returns (address impl) {
150     bytes32 slot = IMPLEMENTATION_SLOT;
151     assembly {
152       impl := sload(slot)
153     }
154   }
155 
156   /**
157    * @dev Upgrades the proxy to a new implementation.
158    * @param newImplementation Address of the new implementation.
159    */
160   function _upgradeTo(address newImplementation) internal {
161     _setImplementation(newImplementation);
162     emit Upgraded(newImplementation);
163   }
164 
165   /**
166    * @dev Sets the implementation address of the proxy.
167    * @param newImplementation Address of the new implementation.
168    */
169   function _setImplementation(address newImplementation) private {
170     require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
171 
172     bytes32 slot = IMPLEMENTATION_SLOT;
173 
174     assembly {
175       sstore(slot, newImplementation)
176     }
177   }
178 }
179 
180 // File: contracts/upgradeability/AdminUpgradeabilityProxy.sol
181 
182 pragma solidity ^0.4.24;
183 
184 
185 /**
186  * @title AdminUpgradeabilityProxy
187  * @dev This contract combines an upgradeability proxy with an authorization
188  * mechanism for administrative tasks.
189  * All external functions in this contract must be guarded by the
190  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
191  * feature proposal that would enable this to be done automatically.
192  */
193 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
194   /**
195    * @dev Emitted when the administration has been transferred.
196    * @param previousAdmin Address of the previous admin.
197    * @param newAdmin Address of the new admin.
198    */
199   event AdminChanged(address previousAdmin, address newAdmin);
200 
201   /**
202    * @dev Storage slot with the admin of the contract.
203    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
204    * validated in the constructor.
205    */
206   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
207 
208   /**
209    * @dev Modifier to check whether the `msg.sender` is the admin.
210    * If it is, it will run the function. Otherwise, it will delegate the call
211    * to the implementation.
212    */
213   modifier ifAdmin() {
214     if (msg.sender == _admin()) {
215       _;
216     } else {
217       _fallback();
218     }
219   }
220 
221   /**
222    * Contract constructor.
223    * @param _implementation address of the initial implementation.
224    * @param _admin Address of the proxy administrator.
225    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
226    * It should include the signature and the parameters of the function to be called, as described in
227    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
228    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
229    */
230   constructor(address _implementation, address _admin, bytes _data) UpgradeabilityProxy(_implementation, _data) public payable {
231     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
232 
233     _setAdmin(_admin);
234   }
235 
236   /**
237    * @return The address of the proxy admin.
238    */
239   function admin() external view ifAdmin returns (address) {
240     return _admin();
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
257     emit AdminChanged(_admin(), newAdmin);
258     _setAdmin(newAdmin);
259   }
260 
261   /**
262    * @dev Upgrade the backing implementation of the proxy.
263    * Only the admin can call this function.
264    * @param newImplementation Address of the new implementation.
265    */
266   function upgradeTo(address newImplementation) external ifAdmin {
267     _upgradeTo(newImplementation);
268   }
269 
270   /**
271    * @dev Upgrade the backing implementation of the proxy and call a function
272    * on the new implementation.
273    * This is useful to initialize the proxied contract.
274    * @param newImplementation Address of the new implementation.
275    * @param data Data to send as msg.data in the low level call.
276    * It should include the signature and the parameters of the function to be called, as described in
277    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
278    */
279   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
280     _upgradeTo(newImplementation);
281     require(newImplementation.delegatecall(data));
282   }
283 
284   /**
285    * @return The admin slot.
286    */
287   function _admin() internal view returns (address adm) {
288     bytes32 slot = ADMIN_SLOT;
289     assembly {
290       adm := sload(slot)
291     }
292   }
293 
294   /**
295    * @dev Sets the address of the proxy admin.
296    * @param newAdmin Address of the new proxy admin.
297    */
298   function _setAdmin(address newAdmin) internal {
299     bytes32 slot = ADMIN_SLOT;
300 
301     assembly {
302       sstore(slot, newAdmin)
303     }
304   }
305 
306   /**
307    * @dev Only fall back when the sender is not the admin.
308    */
309   function _willFallback() internal {
310     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
311     super._willFallback();
312   }
313 }