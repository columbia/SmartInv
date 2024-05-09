1 // File: contracts/lib/Proxy.sol
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @title Proxy
7  * @dev From https://github.com/OpenZeppelin/openzeppelin-sdk/tree/solc-0.6/packages/lib/contracts/upgradeability
8  * Implements delegation of calls to other contracts, with proper
9  * forwarding of return values and bubbling of failures.
10  * It defines a fallback function that delegates all calls to the address
11  * returned by the abstract _implementation() internal function.
12  */
13 abstract contract Proxy {
14     /**
15      * @dev Fallback function.
16      * Implemented entirely in `_fallback`.
17      */
18     fallback() external payable {
19         _fallback();
20     }
21 
22     /**
23      * @return The Address of the implementation.
24      */
25     function _implementation() internal virtual view returns (address);
26 
27     /**
28      * @dev Delegates execution to an implementation contract.
29      * This is a low level function that doesn't return to its internal call site.
30      * It will return to the external caller whatever the implementation returns.
31      * @param implementation Address to delegate.
32      */
33     function _delegate(address implementation) internal {
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
48                 // delegatecall returns 0 on error.
49                 case 0 {
50                     revert(0, returndatasize())
51                 }
52                 default {
53                     return(0, returndatasize())
54                 }
55         }
56     }
57 
58     /**
59      * @dev Function that is run as the first thing in the fallback function.
60      * Can be redefined in derived contracts to add functionality.
61      * Redefinitions must call super._willFallback().
62      */
63     function _willFallback() internal virtual {}
64 
65     /**
66      * @dev fallback implementation.
67      * Extracted to enable manual triggering.
68      */
69     function _fallback() internal {
70         _willFallback();
71         _delegate(_implementation());
72     }
73 }
74 
75 // File: contracts/lib/Address.sol
76 
77 pragma solidity 0.6.12;
78 
79 /**
80  * @dev Collection of functions related to the address type
81  * From https://github.com/OpenZeppelin/openzeppelin-contracts
82  */
83 library Address {
84     /**
85      * @dev Returns true if `account` is a contract.
86      *
87      * [IMPORTANT]
88      * ====
89      * It is unsafe to assume that an address for which this function returns
90      * false is an externally-owned account (EOA) and not a contract.
91      *
92      * Among others, `isContract` will return false for the following
93      * types of addresses:
94      *
95      *  - an externally-owned account
96      *  - a contract in construction
97      *  - an address where a contract will be created
98      *  - an address where a contract lived, but was destroyed
99      * ====
100      */
101     function isContract(address account) internal view returns (bool) {
102         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
103         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
104         // for accounts without code, i.e. `keccak256('')`
105         bytes32 codehash;
106         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
107         // solhint-disable-next-line no-inline-assembly
108         assembly {
109             codehash := extcodehash(account)
110         }
111         return (codehash != accountHash && codehash != 0x0);
112     }
113 
114     /**
115      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
116      * `recipient`, forwarding all available gas and reverting on errors.
117      *
118      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
119      * of certain opcodes, possibly making contracts go over the 2300 gas limit
120      * imposed by `transfer`, making them unable to receive funds via
121      * `transfer`. {sendValue} removes this limitation.
122      *
123      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
124      *
125      * IMPORTANT: because control is transferred to `recipient`, care must be
126      * taken to not create reentrancy vulnerabilities. Consider using
127      * {ReentrancyGuard} or the
128      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
129      */
130     function sendValue(address payable recipient, uint256 amount) internal {
131         require(address(this).balance >= amount, 'Address: insufficient balance');
132 
133         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
134         (bool success, ) = recipient.call{value: amount}('');
135         require(success, 'Address: unable to send value, recipient may have reverted');
136     }
137 }
138 
139 // File: contracts/lib/BaseUpgradeabilityProxy.sol
140 
141 pragma solidity 0.6.12;
142 
143 
144 
145 /**
146  * @title BaseUpgradeabilityProxy
147  * @dev From https://github.com/OpenZeppelin/openzeppelin-sdk/tree/solc-0.6/packages/lib/contracts/upgradeability
148  * This contract implements a proxy that allows to change the
149  * implementation address to which it will delegate.
150  * Such a change is called an implementation upgrade.
151  */
152 contract BaseUpgradeabilityProxy is Proxy {
153     /**
154      * @dev Emitted when the implementation is upgraded.
155      * @param implementation Address of the new implementation.
156      */
157     event Upgraded(address indexed implementation);
158 
159     /**
160      * @dev Storage slot with the address of the current implementation.
161      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
162      * validated in the constructor.
163      */
164     bytes32
165         internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
166 
167     /**
168      * @dev Returns the current implementation.
169      * @return impl Address of the current implementation
170      */
171     function _implementation() internal override view returns (address impl) {
172         bytes32 slot = IMPLEMENTATION_SLOT;
173         assembly {
174             impl := sload(slot)
175         }
176     }
177 
178     /**
179      * @dev Upgrades the proxy to a new implementation.
180      * @param newImplementation Address of the new implementation.
181      */
182     function _upgradeTo(address newImplementation) internal {
183         _setImplementation(newImplementation);
184         emit Upgraded(newImplementation);
185     }
186 
187     /**
188      * @dev Sets the implementation address of the proxy.
189      * @param newImplementation Address of the new implementation.
190      */
191     function _setImplementation(address newImplementation) internal {
192         require(
193             Address.isContract(newImplementation),
194             'Cannot set a proxy implementation to a non-contract address'
195         );
196 
197         bytes32 slot = IMPLEMENTATION_SLOT;
198 
199         assembly {
200             sstore(slot, newImplementation)
201         }
202     }
203 }
204 
205 // File: contracts/lib/UpgradeabilityProxy.sol
206 
207 pragma solidity 0.6.12;
208 
209 
210 /**
211  * @title UpgradeabilityProxy
212  * @dev From https://github.com/OpenZeppelin/openzeppelin-sdk/tree/solc-0.6/packages/lib/contracts/upgradeability
213  * Extends BaseUpgradeabilityProxy with a constructor for initializing
214  * implementation and init data.
215  */
216 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
217     /**
218      * @dev Contract constructor.
219      * @param _logic Address of the initial implementation.
220      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
221      * It should include the signature and the parameters of the function to be called, as described in
222      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
223      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
224      */
225     constructor(address _logic, bytes memory _data) public payable {
226         assert(
227             IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1)
228         );
229         _setImplementation(_logic);
230         if (_data.length > 0) {
231             (bool success, ) = _logic.delegatecall(_data);
232             require(success);
233         }
234     }
235 }
236 
237 // File: contracts/lib/BaseAdminUpgradeabilityProxy.sol
238 
239 pragma solidity 0.6.12;
240 
241 
242 /**
243  * @title BaseAdminUpgradeabilityProxy
244  * @dev From https://github.com/OpenZeppelin/openzeppelin-sdk/tree/solc-0.6/packages/lib/contracts/upgradeability 
245  * This contract combines an upgradeability proxy with an authorization
246  * mechanism for administrative tasks.
247  * All external functions in this contract must be guarded by the
248  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
249  * feature proposal that would enable this to be done automatically.
250  */
251 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
252     /**
253      * @dev Emitted when the administration has been transferred.
254      * @param previousAdmin Address of the previous admin.
255      * @param newAdmin Address of the new admin.
256      */
257     event AdminChanged(address previousAdmin, address newAdmin);
258 
259     /**
260      * @dev Storage slot with the admin of the contract.
261      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
262      * validated in the constructor.
263      */
264 
265     bytes32
266         internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
267 
268     /**
269      * @dev Modifier to check whether the `msg.sender` is the admin.
270      * If it is, it will run the function. Otherwise, it will delegate the call
271      * to the implementation.
272      */
273     modifier ifAdmin() {
274         if (msg.sender == _admin()) {
275             _;
276         } else {
277             _fallback();
278         }
279     }
280 
281     /**
282      * @return The address of the proxy admin.
283      */
284     function admin() external ifAdmin returns (address) {
285         return _admin();
286     }
287 
288     /**
289      * @return The address of the implementation.
290      */
291     function implementation() external ifAdmin returns (address) {
292         return _implementation();
293     }
294 
295     /**
296      * @dev Changes the admin of the proxy.
297      * Only the current admin can call this function.
298      * @param newAdmin Address to transfer proxy administration to.
299      */
300     function changeAdmin(address newAdmin) external ifAdmin {
301         require(newAdmin != address(0), 'Cannot change the admin of a proxy to the zero address');
302         emit AdminChanged(_admin(), newAdmin);
303         _setAdmin(newAdmin);
304     }
305 
306     /**
307      * @dev Upgrade the backing implementation of the proxy.
308      * Only the admin can call this function.
309      * @param newImplementation Address of the new implementation.
310      */
311     function upgradeTo(address newImplementation) external ifAdmin {
312         _upgradeTo(newImplementation);
313     }
314 
315     /**
316      * @dev Upgrade the backing implementation of the proxy and call a function
317      * on the new implementation.
318      * This is useful to initialize the proxied contract.
319      * @param newImplementation Address of the new implementation.
320      * @param data Data to send as msg.data in the low level call.
321      * It should include the signature and the parameters of the function to be called, as described in
322      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
323      */
324     function upgradeToAndCall(address newImplementation, bytes calldata data)
325         external
326         payable
327         ifAdmin
328     {
329         _upgradeTo(newImplementation);
330         (bool success, ) = newImplementation.delegatecall(data);
331         require(success);
332     }
333 
334     /**
335      * @return adm The admin slot.
336      */
337     function _admin() internal view returns (address adm) {
338         bytes32 slot = ADMIN_SLOT;
339         assembly {
340             adm := sload(slot)
341         }
342     }
343 
344     /**
345      * @dev Sets the address of the proxy admin.
346      * @param newAdmin Address of the new proxy admin.
347      */
348     function _setAdmin(address newAdmin) internal {
349         bytes32 slot = ADMIN_SLOT;
350 
351         assembly {
352             sstore(slot, newAdmin)
353         }
354     }
355 
356     /**
357      * @dev Only fall back when the sender is not the admin.
358      */
359     function _willFallback() internal virtual override {
360         require(msg.sender != _admin(), 'Cannot call fallback function from the proxy admin');
361         super._willFallback();
362     }
363 }
364 
365 // File: contracts/lib/InitializableUpgradeabilityProxy.sol
366 
367 pragma solidity 0.6.12;
368 
369 
370 /**
371  * @title InitializableUpgradeabilityProxy
372  * @dev From https://github.com/OpenZeppelin/openzeppelin-sdk/tree/solc-0.6/packages/lib/contracts/upgradeability
373  * Extends BaseUpgradeabilityProxy with an initializer for initializing
374  * implementation and init data.
375  */
376 contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
377     /**
378      * @dev Contract initializer.
379      * @param _logic Address of the initial implementation.
380      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
381      * It should include the signature and the parameters of the function to be called, as described in
382      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
383      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
384      */
385     function initialize(address _logic, bytes memory _data) public payable {
386         require(_implementation() == address(0));
387         assert(
388             IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1)
389         );
390         _setImplementation(_logic);
391         if (_data.length > 0) {
392             (bool success, ) = _logic.delegatecall(_data);
393             require(success);
394         }
395     }
396 }
397 
398 // File: contracts/lib/InitializableAdminUpgradeabilityProxy.sol
399 
400 pragma solidity 0.6.12;
401 
402 
403 
404 /**
405  * @title InitializableAdminUpgradeabilityProxy
406  * @dev From https://github.com/OpenZeppelin/openzeppelin-sdk/tree/solc-0.6/packages/lib/contracts/upgradeability 
407  * Extends from BaseAdminUpgradeabilityProxy with an initializer for
408  * initializing the implementation, admin, and init data.
409  */
410 contract InitializableAdminUpgradeabilityProxy is
411     BaseAdminUpgradeabilityProxy,
412     InitializableUpgradeabilityProxy
413 {
414     /**
415      * Contract initializer.
416      * @param _logic address of the initial implementation.
417      * @param _admin Address of the proxy administrator.
418      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
419      * It should include the signature and the parameters of the function to be called, as described in
420      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
421      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
422      */
423     function initialize(
424         address _logic,
425         address _admin,
426         bytes memory _data
427     ) public payable {
428         require(_implementation() == address(0));
429         InitializableUpgradeabilityProxy.initialize(_logic, _data);
430         assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
431         _setAdmin(_admin);
432     }
433 
434     /**
435      * @dev Only fall back when the sender is not the admin.
436      */
437     function _willFallback() internal override(BaseAdminUpgradeabilityProxy, Proxy) {
438         BaseAdminUpgradeabilityProxy._willFallback();
439     }
440 }