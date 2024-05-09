1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.2;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // This method relies on extcodesize, which returns 0 for contracts in
28         // construction, since the code is only stored at the end of the
29         // constructor execution.
30 
31         uint256 size;
32         // solhint-disable-next-line no-inline-assembly
33         assembly { size := extcodesize(account) }
34         return size > 0;
35     }
36 
37 }
38 /**
39  * @title Proxy
40  * @dev Implements delegation of calls to other contracts, with proper
41  * forwarding of return values and bubbling of failures.
42  * It defines a fallback function that delegates all calls to the address
43  * returned by the abstract _implementation() internal function.
44  */
45 abstract contract Proxy {
46   /**
47    * @dev Fallback function.
48    * Implemented entirely in `_fallback`.
49    */
50   fallback () payable external {
51     _fallback();
52   }
53 
54   /**
55    * @dev Receive function.
56    * Implemented entirely in `_fallback`.
57    */
58   receive () payable external {
59     _fallback();
60   }
61 
62   /**
63    * @return The Address of the implementation.
64    */
65   function _implementation() internal virtual view returns (address);
66 
67   /**
68    * @dev Delegates execution to an implementation contract.
69    * This is a low level function that doesn't return to its internal call site.
70    * It will return to the external caller whatever the implementation returns.
71    * @param implementation Address to delegate.
72    */
73   function _delegate(address implementation) internal {
74     assembly {
75       // Copy msg.data. We take full control of memory in this inline assembly
76       // block because it will not return to Solidity code. We overwrite the
77       // Solidity scratch pad at memory position 0.
78       calldatacopy(0, 0, calldatasize())
79 
80       // Call the implementation.
81       // out and outsize are 0 because we don't know the size yet.
82       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
83 
84       // Copy the returned data.
85       returndatacopy(0, 0, returndatasize())
86 
87       switch result
88       // delegatecall returns 0 on error.
89       case 0 { revert(0, returndatasize()) }
90       default { return(0, returndatasize()) }
91     }
92   }
93 
94   /**
95    * @dev Function that is run as the first thing in the fallback function.
96    * Can be redefined in derived contracts to add functionality.
97    * Redefinitions must call super._willFallback().
98    */
99   function _willFallback() internal virtual {
100   }
101 
102   /**
103    * @dev fallback implementation.
104    * Extracted to enable manual triggering.
105    */
106   function _fallback() internal {
107     _willFallback();
108     _delegate(_implementation());
109   }
110 }
111 
112 /**
113  * @title UpgradeabilityProxy
114  * @dev This contract implements a proxy that allows to change the
115  * implementation address to which it will delegate.
116  * Such a change is called an implementation upgrade.
117  */
118 contract UpgradeabilityProxy is Proxy {
119   /**
120    * @dev Contract constructor.
121    * @param _logic Address of the initial implementation.
122    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
123    * It should include the signature and the parameters of the function to be called, as described in
124    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
125    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
126    */
127   constructor(address _logic, bytes memory _data) public payable {
128     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
129     _setImplementation(_logic);
130     if(_data.length > 0) {
131       (bool success,) = _logic.delegatecall(_data);
132       require(success);
133     }
134   }  
135 
136   /**
137    * @dev Emitted when the implementation is upgraded.
138    * @param implementation Address of the new implementation.
139    */
140   event Upgraded(address indexed implementation);
141 
142   /**
143    * @dev Storage slot with the address of the current implementation.
144    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
145    * validated in the constructor.
146    */
147   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
148 
149   /**
150    * @dev Returns the current implementation.
151    * @return impl Address of the current implementation
152    */
153   function _implementation() internal override view returns (address impl) {
154     bytes32 slot = IMPLEMENTATION_SLOT;
155     assembly {
156       impl := sload(slot)
157     }
158   }
159 
160   /**
161    * @dev Upgrades the proxy to a new implementation.
162    * @param newImplementation Address of the new implementation.
163    */
164   function _upgradeTo(address newImplementation) internal {
165     _setImplementation(newImplementation);
166     emit Upgraded(newImplementation);
167   }
168 
169   /**
170    * @dev Sets the implementation address of the proxy.
171    * @param newImplementation Address of the new implementation.
172    */
173   function _setImplementation(address newImplementation) internal {
174     require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
175 
176     bytes32 slot = IMPLEMENTATION_SLOT;
177 
178     assembly {
179       sstore(slot, newImplementation)
180     }
181   }
182 }
183 
184 /**
185  * @title AdminUpgradeabilityProxy
186  * @dev This contract combines an upgradeability proxy with an authorization
187  * mechanism for administrative tasks.
188  * All external functions in this contract must be guarded by the
189  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
190  * feature proposal that would enable this to be done automatically.
191  */
192 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
193   /**
194    * Contract constructor.
195    * @param _logic address of the initial implementation.
196    * @param _admin Address of the proxy administrator.
197    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
198    * It should include the signature and the parameters of the function to be called, as described in
199    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
200    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
201    */
202   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
203     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
204     _setAdmin(_admin);
205   }
206 
207   /**
208    * @dev Emitted when the administration has been transferred.
209    * @param previousAdmin Address of the previous admin.
210    * @param newAdmin Address of the new admin.
211    */
212   event AdminChanged(address previousAdmin, address newAdmin);
213 
214   /**
215    * @dev Storage slot with the admin of the contract.
216    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
217    * validated in the constructor.
218    */
219 
220   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
221 
222   /**
223    * @dev Modifier to check whether the `msg.sender` is the admin.
224    * If it is, it will run the function. Otherwise, it will delegate the call
225    * to the implementation.
226    */
227   modifier ifAdmin() {
228     if (msg.sender == _admin()) {
229       _;
230     } else {
231       _fallback();
232     }
233   }
234 
235   /**
236    * @return The address of the proxy admin.
237    */
238   function admin() external ifAdmin returns (address) {
239     return _admin();
240   }
241 
242   /**
243    * @return The address of the implementation.
244    */
245   function implementation() external ifAdmin returns (address) {
246     return _implementation();
247   }
248 
249   /**
250    * @dev Changes the admin of the proxy.
251    * Only the current admin can call this function.
252    * @param newAdmin Address to transfer proxy administration to.
253    */
254   function changeAdmin(address newAdmin) external ifAdmin {
255     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
256     emit AdminChanged(_admin(), newAdmin);
257     _setAdmin(newAdmin);
258   }
259 
260   /**
261    * @dev Upgrade the backing implementation of the proxy.
262    * Only the admin can call this function.
263    * @param newImplementation Address of the new implementation.
264    */
265   function upgradeTo(address newImplementation) external ifAdmin {
266     _upgradeTo(newImplementation);
267   }
268 
269   /**
270    * @dev Upgrade the backing implementation of the proxy and call a function
271    * on the new implementation.
272    * This is useful to initialize the proxied contract.
273    * @param newImplementation Address of the new implementation.
274    * @param data Data to send as msg.data in the low level call.
275    * It should include the signature and the parameters of the function to be called, as described in
276    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
277    */
278   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
279     _upgradeTo(newImplementation);
280     (bool success,) = newImplementation.delegatecall(data);
281     require(success);
282   }
283 
284   /**
285    * @return adm The admin slot.
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
309   function _willFallback() internal override virtual {
310     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
311     super._willFallback();
312   }
313 }