1 pragma solidity ^0.4.24;
2 
3 pragma solidity ^0.4.24;
4 
5 pragma solidity ^0.4.24;
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
73 /**
74  * @title UpgradeabilityProxy
75  * @dev This contract implements a proxy that allows to change the
76  * implementation address to which it will delegate.
77  * Such a change is called an implementation upgrade.
78  */
79 contract UpgradeabilityProxy is Proxy {
80   /**
81    * @dev Emitted when the implementation is upgraded.
82    * @param implementation Address of the new implementation.
83    */
84   event Upgraded(address indexed implementation);
85 
86   /**
87    * @dev Storage slot with the address of the current implementation.
88    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
89    * validated in the constructor.
90    */
91   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
92 
93   /**
94    * @dev Contract constructor.
95    * @param _implementation Address of the initial implementation.
96    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
97    * It should include the signature and the parameters of the function to be called, as described in
98    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
99    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
100    */
101   constructor(address _implementation, bytes _data) public payable {
102     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
103     _setImplementation(_implementation);
104     if(_data.length > 0) {
105       require(_implementation.delegatecall(_data));
106     }
107   }
108 
109   /**
110    * @dev Returns the current implementation.
111    * @return Address of the current implementation
112    */
113   function _implementation() internal view returns (address impl) {
114     bytes32 slot = IMPLEMENTATION_SLOT;
115     assembly {
116       impl := sload(slot)
117     }
118   }
119 
120   /**
121    * @dev Upgrades the proxy to a new implementation.
122    * @param newImplementation Address of the new implementation.
123    */
124   function _upgradeTo(address newImplementation) internal {
125     _setImplementation(newImplementation);
126     emit Upgraded(newImplementation);
127   }
128 
129   /**
130    * @dev Sets the implementation address of the proxy.
131    * @param newImplementation Address of the new implementation.
132    */
133   function _setImplementation(address newImplementation) private {
134     bytes32 slot = IMPLEMENTATION_SLOT;
135 
136     assembly {
137       sstore(slot, newImplementation)
138     }
139   }
140 }
141 
142 /**
143  * @title AdminUpgradeabilityProxy
144  * @dev This contract combines an upgradeability proxy with an authorization
145  * mechanism for administrative tasks.
146  * All external functions in this contract must be guarded by the
147  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
148  * feature proposal that would enable this to be done automatically.
149  */
150 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
151   /**
152    * @dev Emitted when the administration has been transferred.
153    * @param previousAdmin Address of the previous admin.
154    * @param newAdmin Address of the new admin.
155    */
156   event AdminChanged(address previousAdmin, address newAdmin);
157 
158   /**
159    * @dev Storage slot with the admin of the contract.
160    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
161    * validated in the constructor.
162    */
163   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
164 
165   /**
166    * @dev Modifier to check whether the `msg.sender` is the admin.
167    * If it is, it will run the function. Otherwise, it will delegate the call
168    * to the implementation.
169    */
170   modifier ifAdmin() {
171     if (msg.sender == _admin()) {
172       _;
173     } else {
174       _fallback();
175     }
176   }
177 
178   /**
179    * Contract constructor.
180    * @param _implementation address of the initial implementation.
181    * @param _admin Address of the proxy administrator.
182    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
183    * It should include the signature and the parameters of the function to be called, as described in
184    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
185    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
186    */
187   constructor(address _implementation, address _admin, bytes _data) UpgradeabilityProxy(_implementation, _data) public payable {
188     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
189 
190     _setAdmin(_admin);
191   }
192 
193   /**
194    * @return The address of the proxy admin.
195    */
196   function admin() external view ifAdmin returns (address) {
197     return _admin();
198   }
199 
200   /**
201    * @return The address of the implementation.
202    */
203   function implementation() external view ifAdmin returns (address) {
204     return _implementation();
205   }
206 
207   /**
208    * @dev Changes the admin of the proxy.
209    * Only the current admin can call this function.
210    * @param newAdmin Address to transfer proxy administration to.
211    */
212   function changeAdmin(address newAdmin) external ifAdmin {
213     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
214     emit AdminChanged(_admin(), newAdmin);
215     _setAdmin(newAdmin);
216   }
217 
218   /**
219    * @dev Upgrade the backing implementation of the proxy.
220    * Only the admin can call this function.
221    * @param newImplementation Address of the new implementation.
222    */
223   function upgradeTo(address newImplementation) external ifAdmin {
224     _upgradeTo(newImplementation);
225   }
226 
227   /**
228    * @dev Upgrade the backing implementation of the proxy and call a function
229    * on the new implementation.
230    * This is useful to initialize the proxied contract.
231    * @param newImplementation Address of the new implementation.
232    * @param data Data to send as msg.data in the low level call.
233    * It should include the signature and the parameters of the function to be called, as described in
234    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
235    */
236   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
237     _upgradeTo(newImplementation);
238     require(newImplementation.delegatecall(data));
239   }
240 
241   /**
242    * @return The admin slot.
243    */
244   function _admin() internal view returns (address adm) {
245     bytes32 slot = ADMIN_SLOT;
246     assembly {
247       adm := sload(slot)
248     }
249   }
250 
251   /**
252    * @dev Sets the address of the proxy admin.
253    * @param newAdmin Address of the new proxy admin.
254    */
255   function _setAdmin(address newAdmin) internal {
256     bytes32 slot = ADMIN_SLOT;
257 
258     assembly {
259       sstore(slot, newAdmin)
260     }
261   }
262 
263   /**
264    * @dev Only fall back when the sender is not the admin.
265    */
266   function _willFallback() internal {
267     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
268     super._willFallback();
269   }
270 }