1 // File: contracts/proxy/Proxy.sol
2 
3 pragma solidity ^0.5.8;
4 
5 /**
6  * @title Proxy
7  * @dev Implements delegation of calls to other contracts, with proper
8  * forwarding of return values and bubbling of failures.
9  * It defines a fallback function that delegates all calls to the address
10  * returned by the abstract _implementation() internal function.
11  */
12 contract Proxy {
13     /**
14      * @dev Fallback function.
15      * Implemented entirely in `_fallback`.
16      */
17     function() external payable {
18         _fallback();
19     }
20 
21     /**
22      * @return The Address of the implementation.
23      */
24     function _implementation() internal view returns (address);
25 
26     /**
27      * @dev Delegates execution to an implementation contract.
28      * This is a low level function that doesn't return to its internal call site.
29      * It will return to the external caller whatever the implementation returns.
30      * @param implementation Address to delegate.
31      */
32     function _delegate(address implementation) internal {
33         assembly {
34             // Copy msg.data. We take full control of memory in this inline assembly
35             // block because it will not return to Solidity code. We overwrite the
36             // Solidity scratch pad at memory position 0.
37             calldatacopy(0, 0, calldatasize)
38 
39             // Call the implementation.
40             // out and outsize are 0 because we don't know the size yet.
41             let result := delegatecall(
42                 gas,
43                 implementation,
44                 0,
45                 calldatasize,
46                 0,
47                 0
48             )
49 
50             // Copy the returned data.
51             returndatacopy(0, 0, returndatasize)
52 
53             switch result
54                 // delegatecall returns 0 on error.
55                 case 0 {
56                     revert(0, returndatasize)
57                 }
58                 default {
59                     return(0, returndatasize)
60                 }
61         }
62     }
63 
64     /**
65      * @dev Function that is run as the first thing in the fallback function.
66      * Can be redefined in derived contracts to add functionality.
67      * Redefinitions must call super._willFallback().
68      */
69     function _willFallback() internal {}
70 
71     /**
72      * @dev fallback implementation.
73      * Extracted to enable manual triggering.
74      */
75     function _fallback() internal {
76         _willFallback();
77         _delegate(_implementation());
78     }
79 }
80 
81 // File: contracts/utils/AddressUtils.sol
82 
83 pragma solidity ^0.5.8;
84 
85 /**
86  * Utility library of inline functions on addresses
87  */
88 library AddressUtils {
89     /**
90      * Returns whether the target address is a contract
91      * @dev This function will return false if invoked during the constructor of a contract,
92      * as the code is not actually created until after the constructor finishes.
93      * @param addr address to check
94      * @return whether the target address is a contract
95      */
96     function isContract(address addr) internal view returns (bool) {
97         uint256 size;
98         // XXX Currently there is no better way to check if there is a contract in an address
99         // than to check the size of the code at that address.
100         // See https://ethereum.stackexchange.com/a/14016/36603
101         // for more details about how this works.
102         // TODO Check this again before the Serenity release, because all addresses will be
103         // contracts then.
104         // solium-disable-next-line security/no-inline-assembly
105         assembly {
106             size := extcodesize(addr)
107         }
108         return size > 0;
109     }
110 
111 }
112 
113 // File: contracts/proxy/BaseUpgradeabilityProxy.sol
114 
115 pragma solidity ^0.5.8;
116 
117 
118 
119 /**
120  * @title BaseUpgradeabilityProxy
121  * @dev This contract implements a proxy that allows to change the
122  * implementation address to which it will delegate.
123  * Such a change is called an implementation upgrade.
124  */
125 contract BaseUpgradeabilityProxy is Proxy {
126     /**
127      * @dev Emitted when the implementation is upgraded.
128      * @param implementation Address of the new implementation.
129      */
130     event Upgraded(address indexed implementation);
131 
132     /**
133      * @dev Storage slot with the address of the current implementation.
134      * This is the keccak-256 hash of "bts.lab.eth.proxy.impl", and is
135      * validated in the constructor.
136      */
137     bytes32 internal constant IMPLEMENTATION_SLOT = 0xe99d12b39ab17aef0ca754554afa48519dcb96ca64603696637dea37e965a617;
138 
139     /**
140      * @dev Returns the current implementation.
141      * @return Address of the current implementation
142      */
143     function _implementation() internal view returns (address impl) {
144         bytes32 slot = IMPLEMENTATION_SLOT;
145         assembly {
146             impl := sload(slot)
147         }
148     }
149 
150     /**
151      * @dev Upgrades the proxy to a new implementation.
152      * @param newImplementation Address of the new implementation.
153      */
154     function _upgradeTo(address newImplementation) internal {
155         _setImplementation(newImplementation);
156         emit Upgraded(newImplementation);
157     }
158 
159     /**
160      * @dev Sets the implementation address of the proxy.
161      * @param newImplementation Address of the new implementation.
162      */
163     function _setImplementation(address newImplementation) internal {
164         require(
165             AddressUtils.isContract(newImplementation),
166             "Cannot set a proxy implementation to a non-contract address"
167         );
168 
169         bytes32 slot = IMPLEMENTATION_SLOT;
170 
171         assembly {
172             sstore(slot, newImplementation)
173         }
174     }
175 }
176 
177 // File: contracts/proxy/UpgradeabilityProxy.sol
178 
179 pragma solidity ^0.5.8;
180 
181 
182 /**
183  * @title UpgradeabilityProxy
184  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
185  * implementation and init data.
186  */
187 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
188     /**
189      * @dev Contract constructor.
190      * @param _logic Address of the initial implementation.
191      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
192      * It should include the signature and the parameters of the function to be called, as described in
193      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
194      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
195      */
196     constructor(address _logic, bytes memory _data) public payable {
197         assert(IMPLEMENTATION_SLOT == keccak256("bts.lab.eth.proxy.impl"));
198         _setImplementation(_logic);
199         if (_data.length > 0) {
200             (bool success, ) = _logic.delegatecall(_data);
201             require(success);
202         }
203     }
204 }
205 
206 // File: contracts/proxy/BaseAdminUpgradeabilityProxy.sol
207 
208 pragma solidity ^0.5.8;
209 
210 
211 /**
212  * @title BaseAdminUpgradeabilityProxy
213  * @dev This contract combines an upgradeability proxy with an authorization
214  * mechanism for administrative tasks.
215  * All external functions in this contract must be guarded by the
216  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
217  * feature proposal that would enable this to be done automatically.
218  */
219 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
220     /**
221      * @dev Emitted when the administration has been transferred.
222      * @param previousAdmin Address of the previous admin.
223      * @param newAdmin Address of the new admin.
224      */
225     event AdminChanged(address previousAdmin, address newAdmin);
226 
227     /**
228      * @dev Storage slot with the admin of the contract.
229      * This is the keccak-256 hash of "bts.lab.eth.proxy.admin", and is
230      * validated in the constructor.
231      */
232     bytes32 internal constant ADMIN_SLOT = 0xd605002b0407d620d5ea33643507867180e600a98b93d382fc50227c2095905e;
233 
234     /**
235      * @dev Modifier to check whether the `msg.sender` is the admin.
236      * If it is, it will run the function. Otherwise, it will delegate the call
237      * to the implementation.
238      */
239     modifier ifAdmin() {
240         if (msg.sender == _admin()) {
241             _;
242         } else {
243             _fallback();
244         }
245     }
246 
247     /**
248      * @return The address of the proxy admin.
249      */
250     function admin() external ifAdmin returns (address) {
251         return _admin();
252     }
253 
254     /**
255      * @return The address of the implementation.
256      */
257     function implementation() external ifAdmin returns (address) {
258         return _implementation();
259     }
260 
261     /**
262      * @dev Changes the admin of the proxy.
263      * Only the current admin can call this function.
264      * @param newAdmin Address to transfer proxy administration to.
265      */
266     function changeAdmin(address newAdmin) external ifAdmin {
267         require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
268         emit AdminChanged(_admin(), newAdmin);
269         _setAdmin(newAdmin);
270     }
271 
272     /**
273      * @dev Upgrade the backing implementation of the proxy.
274      * Only the admin can call this function.
275      * @param newImplementation Address of the new implementation.
276      */
277     function upgradeTo(address newImplementation) external ifAdmin {
278         _upgradeTo(newImplementation);
279     }
280 
281     /**
282      * @dev Upgrade the backing implementation of the proxy and call a function
283      * on the new implementation.
284      * This is useful to initialize the proxied contract.
285      * @param newImplementation Address of the new implementation.
286      * @param data Data to send as msg.data in the low level call.
287      * It should include the signature and the parameters of the function to be called, as described in
288      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
289      */
290     function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
291         _upgradeTo(newImplementation);
292         (bool success,) = newImplementation.delegatecall(data);
293         require(success);
294     }
295 
296     /**
297      * @return The admin slot.
298      */
299     function _admin() internal view returns (address adm) {
300         bytes32 slot = ADMIN_SLOT;
301         assembly {
302             adm := sload(slot)
303         }
304     }
305 
306     /**
307      * @dev Sets the address of the proxy admin.
308      * @param newAdmin Address of the new proxy admin.
309      */
310     function _setAdmin(address newAdmin) internal {
311         bytes32 slot = ADMIN_SLOT;
312 
313         assembly {
314             sstore(slot, newAdmin)
315         }
316     }
317 
318     /**
319      * @dev Only fall back when the sender is not the admin.
320      */
321     function _willFallback() internal {
322         require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
323         super._willFallback();
324     }
325 }
326 
327 // File: contracts/proxy/AdminUpgradeabilityProxy.sol
328 
329 pragma solidity ^0.5.8;
330 
331 
332 /**
333  * @title AdminUpgradeabilityProxy
334  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for
335  * initializing the implementation, admin, and init data.
336  */
337 contract AdminUpgradeabilityProxy is
338     BaseAdminUpgradeabilityProxy,
339     UpgradeabilityProxy
340 {
341     /**
342      * Contract constructor.
343      * @param _logic address of the initial implementation.
344      * @param _admin Address of the proxy administrator.
345      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
346      * It should include the signature and the parameters of the function to be called, as described in
347      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
348      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
349      */
350     constructor(address _logic, address _admin, bytes memory _data)
351         public
352         payable
353         UpgradeabilityProxy(_logic, _data)
354     {
355         assert(ADMIN_SLOT == keccak256("bts.lab.eth.proxy.admin"));
356         _setAdmin(_admin);
357     }
358 }
359 
360 // File: contracts/token-factory/TokenFactoryProxy.sol
361 
362 pragma solidity ^0.5.8;
363 
364 
365 contract TokenFactoryProxy is AdminUpgradeabilityProxy {
366     constructor(address _impl, address _admin, bytes memory _data)
367         public
368         payable
369         AdminUpgradeabilityProxy(_impl, _admin, _data)
370     {}
371 }