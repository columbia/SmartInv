1 pragma solidity ^0.6.12;
2 
3 /**
4  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
5  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
6  * be specified by overriding the virtual {_implementation} function.
7  * 
8  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
9  * different contract through the {_delegate} function.
10  * 
11  * The success and return data of the delegated call will be returned back to the caller of the proxy.
12  */
13 abstract contract Proxy {
14     /**
15      * @dev Delegates the current call to `implementation`.
16      * 
17      * This function does not return to its internall call site, it will return directly to the external caller.
18      */
19     function _delegate(address implementation) internal {
20         // solhint-disable-next-line no-inline-assembly
21         assembly {
22             // Copy msg.data. We take full control of memory in this inline assembly
23             // block because it will not return to Solidity code. We overwrite the
24             // Solidity scratch pad at memory position 0.
25             calldatacopy(0, 0, calldatasize())
26 
27             // Call the implementation.
28             // out and outsize are 0 because we don't know the size yet.
29             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
30 
31             // Copy the returned data.
32             returndatacopy(0, 0, returndatasize())
33 
34             switch result
35             // delegatecall returns 0 on error.
36             case 0 { revert(0, returndatasize()) }
37             default { return(0, returndatasize()) }
38         }
39     }
40 
41     /**
42      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
43      * and {_fallback} should delegate.
44      */
45     function _implementation() internal virtual view returns (address);
46 
47     /**
48      * @dev Delegates the current call to the address returned by `_implementation()`.
49      * 
50      * This function does not return to its internall call site, it will return directly to the external caller.
51      */
52     function _fallback() internal {
53         _delegate(_implementation());
54     }
55 
56     /**
57      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
58      * function in the contract matches the call data.
59      */
60     fallback () payable external {
61         _delegate(_implementation());
62     }
63 
64     /**
65      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
66      * is empty.
67      */
68     receive () payable external {
69         _delegate(_implementation());
70     }
71 }
72 
73 /**
74  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
75  * implementation address that can be changed. This address is stored in storage in the location specified by
76  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
77  * implementation behind the proxy.
78  * 
79  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
80  * {TransparentUpgradeableProxy}.
81  */
82 contract UpgradeableProxy is Proxy {
83     /**
84      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
85      * 
86      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
87      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
88      */
89     constructor() public payable {
90         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
91     }
92 
93     /**
94      * @dev Emitted when the implementation is upgraded.
95      */
96     event Upgraded(address indexed implementation);
97 
98     /**
99      * @dev Storage slot with the address of the current implementation.
100      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
101      * validated in the constructor.
102      */
103     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
104 
105     /**
106      * @dev Returns the current implementation address.
107      */
108     function _implementation() internal override view returns (address impl) {
109         bytes32 slot = _IMPLEMENTATION_SLOT;
110         // solhint-disable-next-line no-inline-assembly
111         assembly {
112             impl := sload(slot)
113         }
114     }
115 
116     /**
117      * @dev Upgrades the proxy to a new implementation.
118      * 
119      * Emits an {Upgraded} event.
120      */
121     function _upgradeTo(address newImplementation) virtual internal {
122         _setImplementation(newImplementation);
123         emit Upgraded(newImplementation);
124     }
125 
126     /**
127      * @dev Stores a new address in the EIP1967 implementation slot.
128      */
129     function _setImplementation(address newImplementation) private {
130         address implementation = _implementation();
131         require(implementation != newImplementation, "Proxy: Attemps update proxy with the same implementation");
132 
133         bytes32 slot = _IMPLEMENTATION_SLOT;
134 
135         // solhint-disable-next-line no-inline-assembly
136         assembly {
137             sstore(slot, newImplementation)
138         }
139     }
140 }
141 
142 /**
143  * @dev This contract implements a proxy that is upgradeable by an admin.
144  * 
145  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
146  * clashing], which can potentially be used in an attack, this contract uses the
147  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
148  * things that go hand in hand:
149  * 
150  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
151  * that call matches one of the admin functions exposed by the proxy itself.
152  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
153  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
154  * "admin cannot fallback to proxy target".
155  * 
156  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
157  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
158  * to sudden errors when trying to call a function from the proxy implementation.
159  * 
160  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
161  * you should think of the `ProxyAdmin` instance as the real administrative inerface of your proxy.
162  */
163 contract TransparentUpgradeableProxy is UpgradeableProxy {
164     /**
165      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
166      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
167      */
168     constructor(address admin, address implementation) public payable UpgradeableProxy() {
169         require(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1), "Wrong admin slot");
170         _setAdmin(admin);
171         _upgradeTo(implementation);
172     }
173 
174     /**
175      * @dev Emitted when the admin account has changed.
176      */
177     event AdminChanged(address previousAdmin, address newAdmin);
178 
179     /**
180      * @dev Storage slot with the admin of the contract.
181      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
182      * validated in the constructor.
183      */
184     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
185 
186     /**
187      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
188      */
189     modifier ifAdmin() {
190         if (msg.sender == _admin()) {
191             _;
192         } else {
193             _fallback();
194         }
195     }
196 
197     /**
198      * @dev Returns the current admin.
199      * 
200      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
201      * 
202      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
203      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
204      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
205      */
206     function admin() external ifAdmin returns (address) {
207         return _admin();
208     }
209 
210     /**
211      * @dev Returns the current implementation.
212      * 
213      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
214      * 
215      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
216      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
217      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
218      */
219     function implementation() external ifAdmin returns (address) {
220         return _implementation();
221     }
222 
223     /**
224      * @dev Changes the admin of the proxy.
225      * 
226      * Emits an {AdminChanged} event.
227      * 
228      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
229      */
230     function changeAdmin(address newAdmin) external ifAdmin {
231         require(newAdmin != _admin(), "Proxy: new admin is the same admin.");
232         emit AdminChanged(_admin(), newAdmin);
233         _setAdmin(newAdmin);
234     }
235 
236     /**
237      * @dev Upgrade the implementation of the proxy.
238      * 
239      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
240      */
241     function upgradeTo(address newImplementation) external ifAdmin {
242         _upgradeTo(newImplementation);
243     }
244 
245     /**
246      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
247      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
248      * proxied contract.
249      * 
250      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
251      */
252     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
253         _upgradeTo(newImplementation);
254         // solhint-disable-next-line avoid-low-level-calls
255         (bool success,) = newImplementation.delegatecall(data);
256         require(success);
257     }
258 
259     /**
260      * @dev Returns the current admin.
261      */
262     function _admin() internal view returns (address adm) {
263         bytes32 slot = _ADMIN_SLOT;
264         // solhint-disable-next-line no-inline-assembly
265         assembly {
266             adm := sload(slot)
267         }
268     }
269 
270     /**
271      * @dev Stores a new address in the EIP1967 admin slot.
272      */
273     function _setAdmin(address newAdmin) private {
274         bytes32 slot = _ADMIN_SLOT;
275         require(newAdmin != address(0), "Proxy: Can't set admin to zero address.");
276 
277         // solhint-disable-next-line no-inline-assembly
278         assembly {
279             sstore(slot, newAdmin)
280         }
281     }
282 }