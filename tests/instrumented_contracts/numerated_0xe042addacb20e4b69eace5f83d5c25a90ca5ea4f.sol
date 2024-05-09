1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6 <0.7.0;
4 
5 /**
6  * @title Proxy
7  * @dev Implements delegation of calls to other contracts, with proper
8  * forwarding of return values and bubbling of failures.
9  * It defines a fallback function that delegates all calls to the address
10  * returned by the abstract _implementation() internal function.
11  */
12 abstract contract Proxy {
13     /**
14      * @dev Fallback function.
15      * Implemented entirely in `_fallback`.
16      */
17     fallback () payable external {
18         _fallback();
19     }
20 
21     /**
22      * @dev Receive function.
23      * Implemented entirely in `_fallback`.
24      */
25     receive () payable external {
26         _fallback();
27     }
28 
29     /**
30      * @return The Address of the implementation.
31      */
32     function _implementation() internal virtual view returns (address);
33 
34     /**
35      * @dev Delegates execution to an implementation contract.
36      * This is a low level function that doesn't return to its internal call site.
37      * It will return to the external caller whatever the implementation returns.
38      * @param implementation Address to delegate.
39      */
40     function _delegate(address implementation) internal {
41         // solhint-disable-next-line no-inline-assembly
42         assembly {
43             // Copy msg.data. We take full control of memory in this inline assembly
44             // block because it will not return to Solidity code. We overwrite the
45             // Solidity scratch pad at memory position 0.
46             calldatacopy(0, 0, calldatasize())
47 
48             // Call the implementation.
49             // out and outsize are 0 because we don't know the size yet.
50             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
51 
52             // Copy the returned data.
53             returndatacopy(0, 0, returndatasize())
54 
55             switch result
56             // delegatecall returns 0 on error.
57             case 0 { revert(0, returndatasize()) }
58             default { return(0, returndatasize()) }
59         }
60     }
61 
62     /**
63      * @dev Function that is run as the first thing in the fallback function.
64      * Can be redefined in derived contracts to add functionality.
65      * Redefinitions must call super._willFallback().
66      */
67     function _willFallback() internal virtual {
68     }
69 
70     /**
71      * @dev fallback implementation.
72      * Extracted to enable manual triggering.
73      */
74     function _fallback() internal {
75         _willFallback();
76         _delegate(_implementation());
77     }
78 }
79 
80 
81 pragma solidity >=0.6 <0.7.0;
82 
83 
84 /**
85  * @title UpgradeableProxy
86  * @dev This contract implements a proxy that allows to change the
87  * implementation address to which it will delegate.
88  * Such a change is called an implementation upgrade.
89  */
90 contract UpgradeableProxy is Proxy {
91     /**
92      * @dev Contract constructor.
93      * @param _logic Address of the initial implementation.
94      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
95      * It should include the signature and the parameters of the function to be called, as described in
96      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
97      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
98      */
99     constructor(address _logic, bytes memory _data) public payable {
100         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
101         _setImplementation(_logic);
102         if(_data.length > 0) {
103             // solhint-disable-next-line avoid-low-level-calls
104             (bool success,) = _logic.delegatecall(_data);
105             require(success);
106         }
107     }  
108 
109     /**
110      * @dev Emitted when the implementation is upgraded.
111      * @param implementation Address of the new implementation.
112      */
113     event Upgraded(address indexed implementation);
114 
115     /**
116      * @dev Storage slot with the address of the current implementation.
117      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
118      * validated in the constructor.
119      */
120     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
121 
122     /**
123      * @dev Returns the current implementation.
124      * @return impl Address of the current implementation
125      */
126     function _implementation() internal override view returns (address impl) {
127         bytes32 slot = _IMPLEMENTATION_SLOT;
128         // solhint-disable-next-line no-inline-assembly
129         assembly {
130             impl := sload(slot)
131         }
132     }
133 
134     /**
135      * @dev Upgrades the proxy to a new implementation.
136      * @param newImplementation Address of the new implementation.
137      */
138     function _upgradeTo(address newImplementation) internal {
139         _setImplementation(newImplementation);
140         emit Upgraded(newImplementation);
141     }
142 
143     /**
144      * @dev Sets the implementation address of the proxy.
145      * @param newImplementation Address of the new implementation.
146      */
147     function _setImplementation(address newImplementation) internal {
148         require(isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
149 
150         bytes32 slot = _IMPLEMENTATION_SLOT;
151 
152         // solhint-disable-next-line no-inline-assembly
153         assembly {
154             sstore(slot, newImplementation)
155         }
156     }
157 
158     /**
159      * @dev Returns true if `account` is a contract.
160      *
161      * [IMPORTANT]
162      * ====
163      * It is unsafe to assume that an address for which this function returns
164      * false is an externally-owned account (EOA) and not a contract.
165      *
166      * Among others, `isContract` will return false for the following
167      * types of addresses:
168      *
169      *  - an externally-owned account
170      *  - a contract in construction
171      *  - an address where a contract will be created
172      *  - an address where a contract lived, but was destroyed
173      * ====
174      */
175     function isContract(address account) internal view returns (bool) {
176         // This method relies in extcodesize, which returns 0 for contracts in
177         // construction, since the code is only stored at the end of the
178         // constructor execution.
179 
180         uint256 size;
181         // solhint-disable-next-line no-inline-assembly
182         assembly { size := extcodesize(account) }
183         return size > 0;
184     }
185 }
186 
187 
188 pragma solidity >=0.6 <0.7.0;
189 
190 
191 /**
192  * @title ManagedProxy
193  * @dev This contract combines an upgradeability proxy with an authorization
194  * mechanism for administrative tasks.
195  * All external functions in this contract must be guarded by the
196  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
197  * feature proposal that would enable this to be done automatically.
198  */
199 contract ManagedProxy is UpgradeableProxy {
200     /**
201      * Contract constructor.
202      * @param _logic address of the initial implementation.
203      * @param _admin Address of the proxy administrator.
204      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
205      * It should include the signature and the parameters of the function to be called, as described in
206      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
207      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
208      */
209     constructor(address _logic, address _admin, bytes memory _data) public payable UpgradeableProxy(_logic, _data) {
210         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
211         _setAdmin(_admin);
212     }
213 
214     /**
215      * @dev Emitted when the administration has been transferred.
216      * @param previousAdmin Address of the previous admin.
217      * @param newAdmin Address of the new admin.
218      */
219     event AdminChanged(address previousAdmin, address newAdmin);
220 
221     /**
222      * @dev Storage slot with the admin of the contract.
223      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
224      * validated in the constructor.
225      */
226 
227     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
228 
229     /**
230      * @dev Modifier to check whether the `msg.sender` is the admin.
231      * If it is, it will run the function. Otherwise, it will delegate the call
232      * to the implementation.
233      */
234     modifier ifAdmin() {
235         if (msg.sender == _admin()) {
236             _;
237         } else {
238             _fallback();
239         }
240     }
241 
242     /**
243      * @return The address of the proxy admin.
244      */
245     function getProxyAdmin() public view returns (address) {
246         return _admin();
247     }
248 
249     /**
250      * @return The address of the implementation.
251      */
252     function getProxyImplementation() public view returns (address) {
253         return _implementation();
254     }
255 
256     /**
257      * @dev Changes the admin of the proxy.
258      * Only the current admin can call this function.
259      * @param newAdmin Address to transfer proxy administration to.
260      */
261     function changeAdmin(address newAdmin) external ifAdmin {
262         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
263         emit AdminChanged(_admin(), newAdmin);
264         _setAdmin(newAdmin);
265     }
266 
267     /**
268      * @dev Upgrade the backing implementation of the proxy.
269      * Only the admin can call this function.
270      * @param newImplementation Address of the new implementation.
271      */
272     function upgradeTo(address newImplementation) external payable ifAdmin {
273         _upgradeTo(newImplementation);
274     }
275 
276     /**
277      * @dev Upgrade the backing implementation of the proxy and call a function
278      * on the new implementation.
279      * This is useful to initialize the proxied contract.
280      * @param newImplementation Address of the new implementation.
281      * @param data Data to send as msg.data in the low level call.
282      * It should include the signature and the parameters of the function to be called, as described in
283      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
284      */
285     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
286         _upgradeTo(newImplementation);
287         // solhint-disable-next-line avoid-low-level-calls
288         (bool success,) = newImplementation.delegatecall(data);
289         require(success);
290     }
291 
292     /**
293      * @return adm The admin slot.
294      */
295     function _admin() internal view returns (address adm) {
296         bytes32 slot = _ADMIN_SLOT;
297         // solhint-disable-next-line no-inline-assembly
298         assembly {
299             adm := sload(slot)
300         }
301     }
302 
303     /**
304      * @dev Sets the address of the proxy admin.
305      * @param newAdmin Address of the new proxy admin.
306      */
307     function _setAdmin(address newAdmin) internal {
308         bytes32 slot = _ADMIN_SLOT;
309 
310         // solhint-disable-next-line no-inline-assembly
311         assembly {
312             sstore(slot, newAdmin)
313         }
314     }
315 
316     /**
317      * @dev Only fallback when the sender is not the admin.
318      */
319     function _willFallback() internal override virtual {
320         // require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
321         super._willFallback();
322     }
323 }
324 
325 pragma solidity >=0.6.0 <0.7.0;
326 
327 
328 /**
329  * @dev Implementation of the {IERC20} interface.
330  *
331  * This implementation is agnostic to the way tokens are created. This means
332  * that a supply mechanism has to be added in a derived contract using {_mint}.
333  * For a generic mechanism see {ERC20PresetMinterPauser}.
334  *
335  * TIP: For a detailed writeup see our guide
336  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
337  * to implement supply mechanisms].
338  *
339  * We have followed general OpenZeppelin guidelines: functions revert instead
340  * of returning `false` on failure. This behavior is nonetheless conventional
341  * and does not conflict with the expectations of ERC20 applications.
342  *
343  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
344  * This allows applications to reconstruct the allowance for all accounts just
345  * by listening to said events. Other implementations of the EIP may not emit
346  * these events, as it isn't required by the specification.
347  *
348  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
349  * functions have been added to mitigate the well-known issues around setting
350  * allowances. See {IERC20-approve}.
351  */
352 contract UDS is ManagedProxy {
353     constructor(address logic, address admin)
354         public
355         payable
356         ManagedProxy(logic, admin, abi.encodeWithSelector(0x9c020061, admin))
357     {}
358 }