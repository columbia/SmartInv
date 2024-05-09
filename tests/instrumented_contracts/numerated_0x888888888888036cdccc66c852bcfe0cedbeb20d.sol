1 // File: contracts/upgradeability/Proxy.sol
2 
3 pragma solidity 0.5.0;
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
17     function () external payable {
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
41             let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
42 
43             // Copy the returned data.
44             returndatacopy(0, 0, returndatasize)
45 
46             switch result
47             // delegatecall returns 0 on error.
48             case 0 { revert(0, returndatasize) }
49             default { return(0, returndatasize) }
50         }
51     }
52 
53     /**
54      * @dev Function that is run as the first thing in the fallback function.
55      * Can be redefined in derived contracts to add functionality.
56      * Redefinitions must call super._willFallback().
57      */
58     function _willFallback() internal {
59     }
60 
61     /**
62      * @dev fallback implementation.
63      * Extracted to enable manual triggering.
64      */
65     function _fallback() internal {
66         _willFallback();
67         _delegate(_implementation());
68     }
69 }
70 
71 // File: contracts/utils/AddressUtils.sol
72 
73 pragma solidity 0.5.0;
74 
75 
76 /**
77  * Utility library of inline functions on addresses
78  */
79 library AddressUtils {
80 
81     /**
82      * Returns whether the target address is a contract
83      * @dev This function will return false if invoked during the constructor of a contract,
84      * as the code is not actually created until after the constructor finishes.
85      * @param addr address to check
86      * @return whether the target address is a contract
87      */
88     function isContract(address addr) internal view returns (bool) {
89         uint256 size;
90         // XXX Currently there is no better way to check if there is a contract in an address
91         // than to check the size of the code at that address.
92         // See https://ethereum.stackexchange.com/a/14016/36603
93         // for more details about how this works.
94         // TODO Check this again before the Serenity release, because all addresses will be
95         // contracts then.
96         // solium-disable-next-line security/no-inline-assembly
97         assembly { size := extcodesize(addr) }
98         return size > 0;
99     }
100 
101 }
102 
103 // File: contracts/upgradeability/UpgradeabilityProxy.sol
104 
105 pragma solidity 0.5.0;
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
116     /**
117      * @dev Emitted when the implementation is upgraded.
118      * @param implementation Address of the new implementation.
119      */
120     event Upgraded(address indexed implementation);
121 
122     /**
123      * @dev Storage slot with the address of the current implementation.
124      * This is the keccak-256 hash of "com.yqb.proxy.implementation", and is
125      * validated in the constructor.
126      */
127     bytes32 private constant IMPLEMENTATION_SLOT = 0x69bff8d33f8a81d44ad045cae8c2563876eaefa1bf1355c3840f96d03ef9dc26;
128 
129     /**
130      * @dev Contract constructor.
131      * @param _implementation Address of the initial implementation.
132      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
133      * It should include the signature and the parameters of the function to be called, as described in
134      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
135      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
136      */
137     constructor(address _implementation, bytes memory _data) public payable {
138         assert(IMPLEMENTATION_SLOT == keccak256("com.yqb.proxy.implementation"));
139         _setImplementation(_implementation);
140         if(_data.length > 0) {
141             (bool success, ) = _implementation.delegatecall(_data); 
142             require(success);
143         }
144     }
145 
146     /**
147      * @dev Returns the current implementation.
148      * @return Address of the current implementation
149      */
150     function _implementation() internal view returns (address impl) {
151         bytes32 slot = IMPLEMENTATION_SLOT;
152         assembly {
153             impl := sload(slot)
154         }
155     }
156 
157     /**
158      * @dev Upgrades the proxy to a new implementation.
159      * @param newImplementation Address of the new implementation.
160      */
161     function _upgradeTo(address newImplementation) internal {
162         _setImplementation(newImplementation);
163         emit Upgraded(newImplementation);
164     }
165 
166     /**
167      * @dev Sets the implementation address of the proxy.
168      * @param newImplementation Address of the new implementation.
169      */
170     function _setImplementation(address newImplementation) private {
171         require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
172 
173         bytes32 slot = IMPLEMENTATION_SLOT;
174 
175         assembly {
176             sstore(slot, newImplementation)
177         }
178     }
179 }
180 
181 // File: contracts/upgradeability/AdminUpgradeabilityProxy.sol
182 
183 pragma solidity 0.5.0;
184 
185 
186 /**
187  * @title AdminUpgradeabilityProxy
188  * @dev This contract combines an upgradeability proxy with an authorization
189  * mechanism for administrative tasks.
190  * All external functions in this contract must be guarded by the
191  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
192  * feature proposal that would enable this to be done automatically.
193  */
194 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
195    
196     /**
197      * @dev Emitted when the administration has been transferred.
198      * @param previousAdmin Address of the previous admin.
199      * @param newAdmin Address of the new admin.
200      */
201     event AdminChanged(address indexed previousAdmin, address indexed newAdmin);
202 
203     /**
204      * @dev Storage slot with the admin of the contract.
205      * This is the keccak-256 hash of "com.yqb.proxy.admin" 
206      * and "com.yqb.proxy.pendingAdmin", and validated in the constructor.
207      */
208     bytes32 private constant ADMIN_SLOT = 0x6f6d8d7f580c12385c0ffee3db0c8dd22f5ced916dd281b7afe571b5ea7bf38d;
209     bytes32 private constant PENDINGADMIN_SLOT = 0xfe6b8cc6ffc46560d1f51755d0370c701a703e339b6c269e0d18ab46fab2c530;
210 
211     /**
212      * @dev Modifier to check whether the `msg.sender` is the admin.
213      * If it is, it will run the function. Otherwise, it will delegate the call
214      * to the implementation.
215      */
216     modifier ifAdmin() {
217         if (msg.sender == _admin()) {
218             _;
219         } else {
220             _fallback();
221         }
222     }
223 
224     /**
225      * @dev Modifier to check whether the `msg.sender` is the pendingAdmin.
226      * If it is, it will run the function. Otherwise, it will delegate the call
227      * to the implementation.
228      */
229     modifier ifPendingAdmin() {
230         if (msg.sender == _pendingAdmin()) {
231             _;
232         } else {
233             _fallback();
234         }
235     }
236 
237     /**
238      * Contract constructor.
239      * @param _implementation address of the initial implementation.
240      * @param _admin Address of the proxy administrator.
241      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
242      * It should include the signature and the parameters of the function to be called, as described in
243      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
244      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
245      */
246     constructor(
247         address _implementation, 
248         address _admin, 
249         bytes memory _data
250     ) UpgradeabilityProxy(_implementation, _data) public payable {
251         require(_admin != address(0), "admin shouldn't be zero address");
252         assert(ADMIN_SLOT == keccak256("com.yqb.proxy.admin"));
253         assert(PENDINGADMIN_SLOT == keccak256("com.yqb.proxy.pendingAdmin"));
254         _setAdmin(_admin);
255     }
256 
257     /**
258      * @return The address of the proxy admin.
259      */
260     function admin() external ifAdmin returns (address) {
261         return _admin();
262     }
263 
264     /**
265      * @return The address of the proxy pendingAdmin
266      */
267     function pendingAdmin() external returns (address) {
268         if (msg.sender == _admin() || msg.sender == _pendingAdmin()) {
269             return _pendingAdmin();
270         } else {
271             _fallback();
272         }
273     }
274 
275     /**
276      * @return The address of the implementation.
277      */
278     function implementation() external ifAdmin returns (address) {
279         return _implementation();
280     }
281 
282     /**
283      * @dev Changes the admin of the proxy.
284      * Only the current admin can call this function.
285      * @param _newAdmin Address to transfer proxy administration to.
286      */
287     function changeAdmin(address _newAdmin) external ifAdmin {
288         _setPendingAdmin(_newAdmin);
289     }
290 
291     /**
292      * @dev Allows the pendingAdmin address to finalize the transfer. 
293      */
294     function claimAdmin() external ifPendingAdmin {
295         emit AdminChanged(_admin(), _pendingAdmin());
296         _setAdmin(_pendingAdmin());
297         _setPendingAdmin(address(0));
298         
299     }  
300 
301     /**
302      * @dev Upgrade the backing implementation of the proxy.
303      * Only the admin can call this function.
304      * @param newImplementation Address of the new implementation.
305      */
306     function upgradeTo(address newImplementation) external ifAdmin {
307         _upgradeTo(newImplementation);
308     }
309     
310     /**
311      * @dev Upgrade the backing implementation of the proxy and call a function
312      * on the new implementation.
313      * This is useful to initialize the proxied contract.
314      * @param _newImplementation Address of the new implementation.
315      * @param _data Data to send as msg.data in the low level call.
316      * It should include the signature and the parameters of the function to be called, as described in
317      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
318      */
319     function upgradeToAndCall(address _newImplementation, bytes calldata _data) external payable ifAdmin {
320         _upgradeTo(_newImplementation);
321         (bool success, ) = _newImplementation.delegatecall(_data); 
322         require(success);
323     }
324 
325     /**
326      * @return The admin slot.
327      */
328     function _admin() internal view returns (address adm) {
329         bytes32 slot = ADMIN_SLOT;
330         assembly {
331             adm := sload(slot)
332         }
333     }
334 
335     /**
336      * @return The pendingAdmin slot
337      */
338     function _pendingAdmin() internal view returns (address pendingAdm) {
339         bytes32 slot = PENDINGADMIN_SLOT;
340         assembly {
341             pendingAdm := sload(slot)
342         }
343     }
344 
345     /**
346      * @dev Sets the address of the proxy admin.
347      * @param _newAdmin Address of the new proxy admin.
348      */
349     function _setAdmin(address _newAdmin) internal { 
350         bytes32 slot = ADMIN_SLOT;
351         assembly {
352             sstore(slot, _newAdmin)
353         }
354     }
355 
356     /**
357      * @dev Sets the address of the proxy pendingAdmin.
358      * @param _newAdmin Address of the new proxy pendingAdmin.
359      */
360     function _setPendingAdmin(address _newAdmin) internal { 
361         bytes32 slot = PENDINGADMIN_SLOT;
362         assembly {
363             sstore(slot, _newAdmin)
364         }
365     }
366 
367     /**
368      * @dev Only fall back when the sender is not the admin.
369      */
370     function _willFallback() internal {
371         require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
372         super._willFallback();
373     }
374 
375 }