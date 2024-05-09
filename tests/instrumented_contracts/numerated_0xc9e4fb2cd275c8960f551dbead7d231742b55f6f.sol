1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity >=0.5.16 <0.7.0;
5 
6 /**
7  * @title Proxy
8  *
9  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
10  * different contract through the {_delegate} function.
11  * 
12  * The success and return data of the delegated call will be returned back to the caller of the proxy.
13  */
14 abstract contract Proxy {
15     /**
16      * @dev Delegates the current call to `implementation`.
17      * 
18      * This function does not return to its internall call site, it will return directly to the external caller.
19      */
20     function _delegate(address implementation) internal {
21         // solhint-disable-next-line no-inline-assembly
22         assembly {
23             // Copy msg.data. We take full control of memory in this inline assembly
24             // block because it will not return to Solidity code. We overwrite the
25             // Solidity scratch pad at memory position 0.
26             calldatacopy(0, 0, calldatasize())
27 
28             // Call the implementation.
29             // out and outsize are 0 because we don't know the size yet.
30             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
31 
32             // Copy the returned data.
33             returndatacopy(0, 0, returndatasize())
34 
35             switch result
36             // delegatecall returns 0 on error.
37             case 0 { revert(0, returndatasize()) }
38             default { return(0, returndatasize()) }
39         }
40     }
41 
42     /**
43      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
44      * and {_fallback} should delegate.
45      */
46     function _implementation() internal virtual view returns (address);
47 
48     /**
49      * @dev Delegates the current call to the address returned by `_implementation()`.
50      * 
51      * This function does not return to its internall call site, it will return directly to the external caller.
52      */
53     function _fallback() internal {
54         _beforeFallback();
55         _delegate(_implementation());
56     }
57 
58     /**
59      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
60      * function in the contract matches the call data.
61      */
62     fallback () payable external {
63         _fallback();
64     }
65 
66     /**
67      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
68      * is empty.
69      */
70     receive () payable external {
71         _fallback();
72     }
73 
74     /**
75      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
76      * call, or as part of the Solidity `fallback` or `receive` functions.
77      * 
78      * If overriden should call `super._beforeFallback()`.
79      */
80     function _beforeFallback() internal virtual {
81     }
82 }
83 
84 
85 pragma solidity >=0.5.16 <0.7.0;
86 
87 /**
88  * Utility library of inline functions on addresses
89  */
90 library AddressUtils {
91     /**
92      * Returns whether the target address is a contract
93      * @dev This function will return false if invoked during the constructor of a contract,
94      * as the code is not actually created until after the constructor finishes.
95      * @param addr address to check
96      * @return whether the target address is a contract
97      */
98     function isContract(address addr) internal view returns (bool) {
99         uint256 size;
100         // XXX Currently there is no better way to check if there is a contract in an address
101         // than to check the size of the code at that address.
102         // See https://ethereum.stackexchange.com/a/14016/36603
103         // for more details about how this works.
104         // TODO Check this again before the Serenity release, because all addresses will be
105         // contracts then.
106         // solium-disable-next-line security/no-inline-assembly
107         assembly {
108             size := extcodesize(addr)
109         }
110         return size > 0;
111     }
112 
113 }
114 
115 
116 pragma solidity >=0.5.16 <0.7.0;
117 
118 
119 
120 /**
121  * @title UpgradeableProxyV1
122  *
123  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
124  * implementation address that can be changed. This address is stored in storage in the location specified by
125  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
126  * implementation behind the proxy.
127  *
128  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
129  * {TransparentUpgradeableProxy}.
130  */
131 abstract contract UpgradeableProxyV1 is Proxy {
132     /**
133      * @dev Initializes the upgradeable proxy with an initial implementation specified by `logic`.
134      *
135      * If `_data` is nonempty, it's used as data in a delegate call to `logic`. This will typically be an encoded
136      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
137      */
138     constructor(address logic, bytes memory data) public payable {
139         if (logic == address(0x0)) {
140             return;
141         }
142         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
143         _setImplementation(logic);
144         if (data.length > 0) {
145             // solhint-disable-next-line avoid-low-level-calls
146             (bool success, ) = logic.delegatecall(data);
147             require(success, "Call impl with data failed");
148         }
149     }
150 
151     function _initProxyImpl(
152         address logic,
153         bytes memory data
154     ) internal virtual {
155         require(_implementation() == address(0x0), "Impl had been set");
156         _setImplementation(logic);
157         if (data.length > 0) {
158             // solhint-disable-next-line avoid-low-level-calls
159             (bool success, ) = logic.delegatecall(data);
160             require(success, "Call impl with data failed");
161         }
162     }
163 
164     /**
165      * @dev Emitted when the implementation is upgraded.
166      */
167     event Upgraded(address indexed implementation);
168 
169     /**
170      * @dev Storage slot with the address of the current implementation.
171      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
172      * validated in the constructor.
173      */
174     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
175 
176     /**
177      * @dev Returns the current implementation.
178      * @return impl Address of the current implementation
179      */
180     function _implementation() internal virtual override view returns (address impl) {
181         bytes32 slot = _IMPLEMENTATION_SLOT;
182         // solhint-disable-next-line no-inline-assembly
183         assembly {
184             impl := sload(slot)
185         }
186     }
187 
188     /**
189      * @dev Upgrades the proxy to a new implementation.
190      *
191      * Emits an {Upgraded} event.
192      */
193     function _upgradeTo(address newImplementation) internal {
194         _setImplementation(newImplementation);
195         emit Upgraded(newImplementation);
196     }
197 
198     /**
199      * @dev Stores a new address in the EIP1967 implementation slot.
200      */
201     function _setImplementation(address newImplementation) private {
202         require(AddressUtils.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
203 
204         bytes32 slot = _IMPLEMENTATION_SLOT;
205 
206         // solhint-disable-next-line no-inline-assembly
207         assembly {
208             sstore(slot, newImplementation)
209         }
210     }
211 }
212 
213 
214 pragma solidity >=0.5.16 <0.7.0;
215 
216 
217 /**
218  * @title ManagedProxyV2
219  *
220  * @dev This contract implements a proxy that is upgradeable by an admin.
221  * initializing the implementation, admin, and init data.
222  */
223 contract ManagedProxyV2 is UpgradeableProxyV1 {
224     /**
225      * @dev Initializes an upgradeable proxy managed by `admin`, backed by the implementation at `logic`, and
226      * optionally initialized with `data` as explained in {UpgradeableProxy-constructor}.
227      */
228     constructor(
229         address logic,
230         address admin,
231         bytes memory data
232     ) public payable UpgradeableProxyV1(logic, data) {
233         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
234         if (admin != address(0x0)) {
235             _setAdmin(admin);
236         }
237     }
238 
239     function _initManagedProxy(
240         address logic,
241         address admin,
242         bytes memory data
243     ) internal {
244         require(_admin() == address(0x0), "Admin had been set");
245         _initProxyImpl(logic, data);
246         _setAdmin(admin);
247     }
248 
249     /**
250      * @dev Emitted when the admin account has changed.
251      */
252     event AdminChanged(address previousAdmin, address newAdmin);
253 
254     /**
255      * @dev Storage slot with the admin of the contract.
256      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
257      * validated in the constructor.
258      */
259     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
260 
261     /**
262      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
263      */
264     modifier ifAdmin() {
265         if (msg.sender == _admin()) {
266             _;
267         } else {
268             _fallback();
269         }
270     }
271 
272     /**
273      * @dev Returns the current admin.
274      *
275      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
276      *
277      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
278      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
279      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
280      */
281     function admin() external ifAdmin returns (address) {
282         return _admin();
283     }
284 
285     /**
286      * @dev Returns the current implementation.
287      *
288      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
289      *
290      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
291      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
292      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
293      */
294     function implementation() external ifAdmin returns (address) {
295         return _implementation();
296     }
297 
298     /**
299      * @dev Changes the admin of the proxy.
300      *
301      * Emits an {AdminChanged} event.
302      *
303      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
304      */
305     function changeAdmin(address newAdmin) external ifAdmin {
306         require(newAdmin != address(0), "ManagedProxy: new admin is the zero address");
307         emit AdminChanged(_admin(), newAdmin);
308         _setAdmin(newAdmin);
309     }
310 
311     /**
312      * @dev Upgrade the implementation of the proxy.
313      *
314      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
315      */
316     function upgradeTo(address newImplementation) external ifAdmin {
317         _upgradeTo(newImplementation);
318     }
319 
320     /**
321      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
322      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
323      * proxied contract.
324      *
325      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
326      */
327     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
328         _upgradeTo(newImplementation);
329         // solhint-disable-next-line avoid-low-level-calls
330         (bool success, ) = newImplementation.delegatecall(data);
331         require(success);
332     }
333 
334     /**
335      * @dev Returns the current admin.
336      */
337     function _admin() internal view returns (address adm) {
338         bytes32 slot = _ADMIN_SLOT;
339         // solhint-disable-next-line no-inline-assembly
340         assembly {
341             adm := sload(slot)
342         }
343     }
344 
345     /**
346      * @dev Stores a new address in the EIP1967 admin slot.
347      */
348     function _setAdmin(address newAdmin) private {
349         bytes32 slot = _ADMIN_SLOT;
350 
351         // solhint-disable-next-line no-inline-assembly
352         assembly {
353             sstore(slot, newAdmin)
354         }
355     }
356 }
357 
358 pragma solidity >=0.5.16 <0.7.0;
359 
360 contract TokenChildProxyV2 is ManagedProxyV2 {
361     constructor() public payable ManagedProxyV2(address(0x0), msg.sender, "") {}
362 
363     function _initProxyOfProxy(
364         address impl,
365         address admin,
366         bytes memory data
367     ) public {
368         _initManagedProxy(impl, admin, data);
369     }
370 }