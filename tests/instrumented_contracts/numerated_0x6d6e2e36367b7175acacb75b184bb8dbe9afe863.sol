1 pragma solidity ^0.5.0;
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
71  * @title UpgradeabilityProxy
72  * @dev This contract implements a proxy that allows to change the
73  * implementation address to which it will delegate.
74  * Such a change is called an implementation upgrade.
75  */
76 contract UpgradeabilityProxy is Proxy {
77   /**
78    * @dev Emitted when the implementation is upgraded.
79    * @param implementation Address of the new implementation.
80    */
81   event Upgraded(address implementation);
82 
83   /**
84    * @dev Storage slot with the address of the current implementation.
85    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
86    * validated in the constructor.
87    */
88   bytes32 private constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
89 
90   /**
91    * @dev Contract constructor.
92    * @param _implementation Address of the initial implementation.
93    */
94   constructor(address _implementation) public payable {
95     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
96 
97     _setImplementation(_implementation);
98   }
99 
100   function isContract(address addr) internal view returns (bool) {
101     uint256 size;
102     // solium-disable-next-line security/no-inline-assembly
103     assembly { size := extcodesize(addr) }
104     return size > 0;
105   }
106  
107   /**
108    * @dev Returns the current implementation.
109    * @return Address of the current implementation
110    */
111   function _implementation() internal view returns (address impl) {
112     bytes32 slot = IMPLEMENTATION_SLOT;
113     assembly {
114       impl := sload(slot)
115     }
116   }
117 
118   /**
119    * @dev Upgrades the proxy to a new implementation.
120    * @param newImplementation Address of the new implementation.
121    */
122   function _upgradeTo(address newImplementation) internal {
123     _setImplementation(newImplementation);
124     emit Upgraded(newImplementation);
125   }
126 
127   /**
128    * @dev Sets the implementation address of the proxy.
129    * @param newImplementation Address of the new implementation.
130    */
131   function _setImplementation(address newImplementation) private {
132     require(isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
133 
134     bytes32 slot = IMPLEMENTATION_SLOT;
135 
136     assembly {
137       sstore(slot, newImplementation)
138     }
139   }
140 }
141 
142 
143 /**
144  * @title AdminUpgradeabilityProxy
145  * @dev This contract combines an upgradeability proxy with an authorization
146  * mechanism for administrative tasks.
147  * All external functions in this contract must be guarded by the
148  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
149  * feature proposal that would enable this to be done automatically.
150  */
151 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
152   /**
153    * @dev Emitted when the administration has been transferred.
154    * @param previousAdmin Address of the previous admin.
155    * @param newAdmin Address of the new admin.
156    */
157   event AdminChanged(address previousAdmin, address newAdmin);
158 
159   /**
160    * @dev Storage slot with the admin of the contract.
161    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
162    * validated in the constructor.
163    */
164   bytes32 private constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
165 
166   /**
167    * @dev Modifier to check whether the `msg.sender` is the admin.
168    * If it is, it will run the function. Otherwise, it will delegate the call
169    * to the implementation.
170    */
171   modifier ifAdmin() {
172     if (msg.sender == _admin()) {
173       _;
174     } else {
175       _fallback();
176     }
177   }
178 
179   /**
180    * Contract constructor.
181    * It sets the `msg.sender` as the proxy administrator.
182    * @param _implementation address of the initial implementation.
183    */
184   constructor(address _implementation) UpgradeabilityProxy(_implementation) public {
185     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
186 
187     _setAdmin(msg.sender);
188   }
189 
190   /**
191    * @return The address of the proxy admin.
192    */
193   function admin() external ifAdmin returns (address) {
194     return _admin();
195   }
196 
197   /**
198    * @return The address of the implementation.
199    */
200   function implementation() external ifAdmin returns (address) {
201     return _implementation();
202   }
203 
204   /**
205    * @dev Changes the admin of the proxy.
206    * Only the current admin can call this function.
207    * @param newAdmin Address to transfer proxy administration to.
208    */
209   function changeAdmin(address newAdmin) external ifAdmin {
210     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
211     emit AdminChanged(_admin(), newAdmin);
212     _setAdmin(newAdmin);
213   }
214 
215   /**
216    * @dev Upgrade the backing implementation of the proxy.
217    * Only the admin can call this function.
218    * @param newImplementation Address of the new implementation.
219    */
220   function upgradeTo(address newImplementation) external ifAdmin {
221     _upgradeTo(newImplementation);
222   }
223 
224   /**
225    * @dev Upgrade the backing implementation of the proxy and call a function
226    * on the new implementation.
227    * This is useful to initialize the proxied contract.
228    * @param newImplementation Address of the new implementation.
229    * @param data Data to send as msg.data in the low level call.
230    * It should include the signature and the parameters of the function to be
231    * called, as described in
232    * https://solidity.readthedocs.io/en/develop/abi-spec.html#function-selector-and-argument-encoding.
233    */
234   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
235     _upgradeTo(newImplementation);
236     (bool success,) = newImplementation.delegatecall(data);
237     require(success);
238   }
239 
240   /**
241    * @return The admin slot.
242    */
243   function _admin() internal view returns (address adm) {
244     bytes32 slot = ADMIN_SLOT;
245     assembly {
246       adm := sload(slot)
247     }
248   }
249 
250   /**
251    * @dev Sets the address of the proxy admin.
252    * @param newAdmin Address of the new proxy admin.
253    */
254   function _setAdmin(address newAdmin) internal {
255     bytes32 slot = ADMIN_SLOT;
256 
257     assembly {
258       sstore(slot, newAdmin)
259     }
260   }
261 
262   /**
263    * @dev Only fall back when the sender is not the admin.
264    */
265   function _willFallback() internal {
266     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
267     super._willFallback();
268   }
269 }
270 
271 
272 contract ContractGateway is AdminUpgradeabilityProxy {
273   constructor(address _implementation) public AdminUpgradeabilityProxy(_implementation) {
274   }
275 }