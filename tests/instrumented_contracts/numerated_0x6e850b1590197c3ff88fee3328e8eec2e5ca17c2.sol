1 // SPDX-License-Identifier: MIT
2 // File: contracts/proxy/Proxy.sol
3 
4 pragma solidity >=0.6 <0.7.0;
5 
6 /**
7  * @title Proxy
8  * @dev Implements delegation of calls to other contracts, with proper
9  * forwarding of return values and bubbling of failures.
10  * It defines a fallback function that delegates all calls to the address
11  * returned by the abstract _implementation() internal function.
12  */
13 abstract contract Proxy {
14     /**
15      * @dev Fallback function.
16      * Implemented entirely in `_fallback`.
17      */
18     fallback () payable external {
19         _fallback();
20     }
21 
22     /**
23      * @dev Receive function.
24      * Implemented entirely in `_fallback`.
25      */
26     receive () payable external {
27         _fallback();
28     }
29 
30     /**
31      * @return The Address of the implementation.
32      */
33     function _implementation() internal virtual view returns (address);
34 
35     /**
36      * @dev Delegates execution to an implementation contract.
37      * This is a low level function that doesn't return to its internal call site.
38      * It will return to the external caller whatever the implementation returns.
39      * @param implementation Address to delegate.
40      */
41     function _delegate(address implementation) internal {
42         // solhint-disable-next-line no-inline-assembly
43         assembly {
44             // Copy msg.data. We take full control of memory in this inline assembly
45             // block because it will not return to Solidity code. We overwrite the
46             // Solidity scratch pad at memory position 0.
47             calldatacopy(0, 0, calldatasize())
48 
49             // Call the implementation.
50             // out and outsize are 0 because we don't know the size yet.
51             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
52 
53             // Copy the returned data.
54             returndatacopy(0, 0, returndatasize())
55 
56             switch result
57             // delegatecall returns 0 on error.
58             case 0 { revert(0, returndatasize()) }
59             default { return(0, returndatasize()) }
60         }
61     }
62 
63     /**
64      * @dev Function that is run as the first thing in the fallback function.
65      * Can be redefined in derived contracts to add functionality.
66      * Redefinitions must call super._willFallback().
67      */
68     function _willFallback() internal virtual {
69     }
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
81 // File: contracts/proxy/UpgradeableProxy.sol
82 
83 pragma solidity >=0.6 <0.7.0;
84 
85 
86 /**
87  * @title UpgradeableProxy
88  * @dev This contract implements a proxy that allows to change the
89  * implementation address to which it will delegate.
90  * Such a change is called an implementation upgrade.
91  */
92 contract UpgradeableProxy is Proxy {
93     /**
94      * @dev Contract constructor.
95      * @param _logic Address of the initial implementation.
96      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
97      * It should include the signature and the parameters of the function to be called, as described in
98      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
99      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
100      */
101     constructor(address _logic, bytes memory _data) public payable {
102         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
103         _setImplementation(_logic);
104         if(_data.length > 0) {
105             // solhint-disable-next-line avoid-low-level-calls
106             (bool success,) = _logic.delegatecall(_data);
107             require(success);
108         }
109     }  
110 
111     /**
112      * @dev Emitted when the implementation is upgraded.
113      * @param implementation Address of the new implementation.
114      */
115     event Upgraded(address indexed implementation);
116 
117     /**
118      * @dev Storage slot with the address of the current implementation.
119      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
120      * validated in the constructor.
121      */
122     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
123 
124     /**
125      * @dev Returns the current implementation.
126      * @return impl Address of the current implementation
127      */
128     function _implementation() internal override view returns (address impl) {
129         bytes32 slot = _IMPLEMENTATION_SLOT;
130         // solhint-disable-next-line no-inline-assembly
131         assembly {
132             impl := sload(slot)
133         }
134     }
135 
136     /**
137      * @dev Upgrades the proxy to a new implementation.
138      * @param newImplementation Address of the new implementation.
139      */
140     function _upgradeTo(address newImplementation) internal {
141         _setImplementation(newImplementation);
142         emit Upgraded(newImplementation);
143     }
144 
145     /**
146      * @dev Sets the implementation address of the proxy.
147      * @param newImplementation Address of the new implementation.
148      */
149     function _setImplementation(address newImplementation) internal {
150         require(isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
151 
152         bytes32 slot = _IMPLEMENTATION_SLOT;
153 
154         // solhint-disable-next-line no-inline-assembly
155         assembly {
156             sstore(slot, newImplementation)
157         }
158     }
159 
160     /**
161      * @dev Returns true if `account` is a contract.
162      *
163      * [IMPORTANT]
164      * ====
165      * It is unsafe to assume that an address for which this function returns
166      * false is an externally-owned account (EOA) and not a contract.
167      *
168      * Among others, `isContract` will return false for the following
169      * types of addresses:
170      *
171      *  - an externally-owned account
172      *  - a contract in construction
173      *  - an address where a contract will be created
174      *  - an address where a contract lived, but was destroyed
175      * ====
176      */
177     function isContract(address account) internal view returns (bool) {
178         // This method relies in extcodesize, which returns 0 for contracts in
179         // construction, since the code is only stored at the end of the
180         // constructor execution.
181 
182         uint256 size;
183         // solhint-disable-next-line no-inline-assembly
184         assembly { size := extcodesize(account) }
185         return size > 0;
186     }
187 }
188 
189 // File: contracts/proxy/ManagedProxy.sol
190 
191 pragma solidity >=0.6 <0.7.0;
192 
193 
194 /**
195  * @title ManagedProxy
196  * @dev This contract combines an upgradeability proxy with an authorization
197  * mechanism for administrative tasks.
198  * All external functions in this contract must be guarded by the
199  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
200  * feature proposal that would enable this to be done automatically.
201  */
202 contract ManagedProxy is UpgradeableProxy {
203     /**
204      * Contract constructor.
205      * @param _logic address of the initial implementation.
206      * @param _admin Address of the proxy administrator.
207      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
208      * It should include the signature and the parameters of the function to be called, as described in
209      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
210      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
211      */
212     constructor(address _logic, address _admin, bytes memory _data) public payable UpgradeableProxy(_logic, _data) {
213         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
214         _setAdmin(_admin);
215     }
216 
217     /**
218      * @dev Emitted when the administration has been transferred.
219      * @param previousAdmin Address of the previous admin.
220      * @param newAdmin Address of the new admin.
221      */
222     event AdminChanged(address previousAdmin, address newAdmin);
223 
224     /**
225      * @dev Storage slot with the admin of the contract.
226      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
227      * validated in the constructor.
228      */
229 
230     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
231 
232     /**
233      * @dev Modifier to check whether the `msg.sender` is the admin.
234      * If it is, it will run the function. Otherwise, it will delegate the call
235      * to the implementation.
236      */
237     modifier ifAdmin() {
238         if (msg.sender == _admin()) {
239             _;
240         } else {
241             _fallback();
242         }
243     }
244 
245     /**
246      * @return The address of the proxy admin.
247      */
248     function getProxyAdmin() public view returns (address) {
249         return _admin();
250     }
251 
252     /**
253      * @return The address of the implementation.
254      */
255     function getProxyImplementation() public view returns (address) {
256         return _implementation();
257     }
258 
259     /**
260      * @dev Changes the admin of the proxy.
261      * Only the current admin can call this function.
262      * @param newAdmin Address to transfer proxy administration to.
263      */
264     function changeAdmin(address newAdmin) external ifAdmin {
265         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
266         emit AdminChanged(_admin(), newAdmin);
267         _setAdmin(newAdmin);
268     }
269 
270     /**
271      * @dev Upgrade the backing implementation of the proxy.
272      * Only the admin can call this function.
273      * @param newImplementation Address of the new implementation.
274      */
275     function upgradeTo(address newImplementation) external payable ifAdmin {
276         _upgradeTo(newImplementation);
277     }
278 
279     /**
280      * @dev Upgrade the backing implementation of the proxy and call a function
281      * on the new implementation.
282      * This is useful to initialize the proxied contract.
283      * @param newImplementation Address of the new implementation.
284      * @param data Data to send as msg.data in the low level call.
285      * It should include the signature and the parameters of the function to be called, as described in
286      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
287      */
288     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
289         _upgradeTo(newImplementation);
290         // solhint-disable-next-line avoid-low-level-calls
291         (bool success,) = newImplementation.delegatecall(data);
292         require(success);
293     }
294 
295     /**
296      * @return adm The admin slot.
297      */
298     function _admin() internal view returns (address adm) {
299         bytes32 slot = _ADMIN_SLOT;
300         // solhint-disable-next-line no-inline-assembly
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
311         bytes32 slot = _ADMIN_SLOT;
312 
313         // solhint-disable-next-line no-inline-assembly
314         assembly {
315             sstore(slot, newAdmin)
316         }
317     }
318 
319     /**
320      * @dev Only fallback when the sender is not the admin.
321      */
322     function _willFallback() internal override virtual {
323         // require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
324         super._willFallback();
325     }
326 }
327 
328 // File: contracts/YFIIC.sol
329 
330 pragma solidity >=0.6.0 <0.7.0;
331 
332 
333 /**
334  * @dev Implementation of the {IERC20} interface.
335  *
336  * This implementation is agnostic to the way tokens are created. This means
337  * that a supply mechanism has to be added in a derived contract using {_mint}.
338  * For a generic mechanism see {ERC20PresetMinterPauser}.
339  *
340  * TIP: For a detailed writeup see our guide
341  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
342  * to implement supply mechanisms].
343  *
344  * We have followed general OpenZeppelin guidelines: functions revert instead
345  * of returning `false` on failure. This behavior is nonetheless conventional
346  * and does not conflict with the expectations of ERC20 applications.
347  *
348  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
349  * This allows applications to reconstruct the allowance for all accounts just
350  * by listening to said events. Other implementations of the EIP may not emit
351  * these events, as it isn't required by the specification.
352  *
353  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
354  * functions have been added to mitigate the well-known issues around setting
355  * allowances. See {IERC20-approve}.
356  */
357 contract YFIIC is ManagedProxy {
358     constructor(
359         address logic,
360         address admin
361     )
362         public
363         payable
364         ManagedProxy(
365             logic,
366             admin,
367             abi.encodeWithSelector(0x9c020061, admin)
368         )
369     {}
370 }