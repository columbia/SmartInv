1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 pragma solidity ^0.6.12;
4 
5 
6 
7 interface IWSProxy {
8     function initialize(address _implementation, address _admin, bytes calldata _data) external;
9     function upgradeTo(address _proxy) external;
10     function upgradeToAndCall(address _proxy, bytes calldata data) external payable;
11     function changeAdmin(address newAdmin) external;
12     function admin() external returns (address);
13     function implementation() external returns (address);
14 }
15 
16 /**
17  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
18  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
19  * be specified by overriding the virtual {_implementation} function.
20  * 
21  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
22  * different contract through the {_delegate} function.
23  * 
24  * The success and return data of the delegated call will be returned back to the caller of the proxy.
25  */
26 abstract contract Proxy {
27     /**
28      * @dev Delegates the current call to `implementation`.
29      * 
30      * This function does not return to its internall call site, it will return directly to the external caller.
31      */
32     function _delegate(address implementation) internal {
33         // solhint-disable-next-line no-inline-assembly
34         assembly {
35             // Copy msg.data. We take full control of memory in this inline assembly
36             // block because it will not return to Solidity code. We overwrite the
37             // Solidity scratch pad at memory position 0.
38             calldatacopy(0, 0, calldatasize())
39 
40             // Call the implementation.
41             // out and outsize are 0 because we don't know the size yet.
42             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
43 
44             // Copy the returned data.
45             returndatacopy(0, 0, returndatasize())
46 
47             switch result
48             // delegatecall returns 0 on error.
49             case 0 { revert(0, returndatasize()) }
50             default { return(0, returndatasize()) }
51         }
52     }
53 
54     /**
55      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
56      * and {_fallback} should delegate.
57      */
58     function _implementation() internal virtual view returns (address);
59 
60     /**
61      * @dev Delegates the current call to the address returned by `_implementation()`.
62      * 
63      * This function does not return to its internall call site, it will return directly to the external caller.
64      */
65     function _fallback() internal {
66         _delegate(_implementation());
67     }
68 
69     /**
70      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
71      * function in the contract matches the call data.
72      */
73     fallback () payable external {
74         _delegate(_implementation());
75     }
76 
77     /**
78      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
79      * is empty.
80      */
81     receive () payable external {
82         _delegate(_implementation());
83     }
84 }
85 
86 /**
87  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
88  * implementation address that can be changed. This address is stored in storage in the location specified by
89  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
90  * implementation behind the proxy.
91  * 
92  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
93  * {TransparentUpgradeableProxy}.
94  */
95 contract UpgradeableProxy is Proxy {
96     /**
97      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
98      * 
99      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
100      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
101      */
102     constructor() public payable {
103         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
104     }
105 
106     /**
107      * @dev Emitted when the implementation is upgraded.
108      */
109     event Upgraded(address indexed implementation);
110 
111     /**
112      * @dev Storage slot with the address of the current implementation.
113      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
114      * validated in the constructor.
115      */
116     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
117 
118     /**
119      * @dev Returns the current implementation address.
120      */
121     function _implementation() internal override view returns (address impl) {
122         bytes32 slot = _IMPLEMENTATION_SLOT;
123         // solhint-disable-next-line no-inline-assembly
124         assembly {
125             impl := sload(slot)
126         }
127     }
128 
129     /**
130      * @dev Upgrades the proxy to a new implementation.
131      * 
132      * Emits an {Upgraded} event.
133      */
134     function _upgradeTo(address newImplementation) virtual internal {
135         _setImplementation(newImplementation);
136         emit Upgraded(newImplementation);
137     }
138 
139     /**
140      * @dev Stores a new address in the EIP1967 implementation slot.
141      */
142     function _setImplementation(address newImplementation) private {
143         address implementation = _implementation();
144         require(implementation != newImplementation, "WSProxy: Attemps update proxy with the same implementation");
145 
146         bytes32 slot = _IMPLEMENTATION_SLOT;
147 
148         // solhint-disable-next-line no-inline-assembly
149         assembly {
150             sstore(slot, newImplementation)
151         }
152     }
153 }
154 
155 /**
156  * @dev This contract implements a proxy that is upgradeable by an admin.
157  * 
158  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
159  * clashing], which can potentially be used in an attack, this contract uses the
160  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
161  * things that go hand in hand:
162  * 
163  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
164  * that call matches one of the admin functions exposed by the proxy itself.
165  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
166  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
167  * "admin cannot fallback to proxy target".
168  * 
169  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
170  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
171  * to sudden errors when trying to call a function from the proxy implementation.
172  * 
173  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
174  * you should think of the `ProxyAdmin` instance as the real administrative inerface of your proxy.
175  */
176 contract TransparentUpgradeableProxy is UpgradeableProxy, IWSProxy {
177     /**
178      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
179      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
180      */
181     constructor() public payable UpgradeableProxy() {
182         require(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1), "Wrong admin slot");
183         _setAdmin(msg.sender);
184     }
185 
186     /**
187      * @dev Emitted when the admin account has changed.
188      */
189     event AdminChanged(address previousAdmin, address newAdmin);
190 
191     /**
192      * @dev Storage slot with the admin of the contract.
193      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
194      * validated in the constructor.
195      */
196     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
197 
198     /**
199      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
200      */
201     modifier ifAdmin() {
202         if (msg.sender == _admin()) {
203             _;
204         } else {
205             _fallback();
206         }
207     }
208 
209     /**
210      * @dev Returns the current admin.
211      * 
212      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
213      * 
214      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
215      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
216      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
217      */
218     function admin() external override ifAdmin returns (address) {
219         return _admin();
220     }
221 
222     function initialize(address _newImplementation, address _admin, bytes calldata _data) external override ifAdmin {
223         _upgradeTo(_newImplementation);
224         _setAdmin(_admin);
225         if(_data.length > 0) {
226             // solhint-disable-next-line avoid-low-level-calls
227             (bool success,) = _implementation().delegatecall(_data);
228             require(success);
229         }
230     }
231 
232     /**
233      * @dev Returns the current implementation.
234      * 
235      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
236      * 
237      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
238      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
239      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
240      */
241     function implementation() external override ifAdmin returns (address) {
242         return _implementation();
243     }
244 
245     /**
246      * @dev Changes the admin of the proxy.
247      * 
248      * Emits an {AdminChanged} event.
249      * 
250      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
251      */
252     function changeAdmin(address newAdmin) external override ifAdmin {
253         require(newAdmin != _admin(), "WSProxy: new admin is the same admin.");
254         emit AdminChanged(_admin(), newAdmin);
255         _setAdmin(newAdmin);
256     }
257 
258     /**
259      * @dev Upgrade the implementation of the proxy.
260      * 
261      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
262      */
263     function upgradeTo(address newImplementation) external override ifAdmin {
264         _upgradeTo(newImplementation);
265     }
266 
267     /**
268      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
269      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
270      * proxied contract.
271      * 
272      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
273      */
274     function upgradeToAndCall(address newImplementation, bytes calldata data) external override payable ifAdmin {
275         _upgradeTo(newImplementation);
276         // solhint-disable-next-line avoid-low-level-calls
277         (bool success,) = newImplementation.delegatecall(data);
278         require(success);
279     }
280 
281     /**
282      * @dev Returns the current admin.
283      */
284     function _admin() internal view returns (address adm) {
285         bytes32 slot = _ADMIN_SLOT;
286         // solhint-disable-next-line no-inline-assembly
287         assembly {
288             adm := sload(slot)
289         }
290     }
291 
292     /**
293      * @dev Stores a new address in the EIP1967 admin slot.
294      */
295     function _setAdmin(address newAdmin) private {
296         bytes32 slot = _ADMIN_SLOT;
297         require(newAdmin != address(0), "WSProxy: Can't set admin to zero address.");
298 
299         // solhint-disable-next-line no-inline-assembly
300         assembly {
301             sstore(slot, newAdmin)
302         }
303     }
304 }
305 
306 contract WSProxyRouter is TransparentUpgradeableProxy {
307     constructor() public payable TransparentUpgradeableProxy() {
308     }
309 }