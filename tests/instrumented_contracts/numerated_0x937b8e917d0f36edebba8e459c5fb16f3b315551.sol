1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly {
38             size := extcodesize(account)
39         }
40         return size > 0;
41     }
42 }
43 
44 // Part: Proxy
45 
46 /**
47  * @title Proxy
48  * @dev Implements delegation of calls to other contracts, with proper
49  * forwarding of return values and bubbling of failures.
50  * It defines a fallback function that delegates all calls to the address
51  * returned by the abstract _implementation() internal function.
52  */
53 abstract contract Proxy {
54     /**
55      * @dev Fallback function.
56      * Implemented entirely in `_fallback`.
57      */
58     fallback() external payable {
59         _fallback();
60     }
61 
62     /**
63      * @dev Receive function.
64      * Implemented entirely in `_fallback`.
65      */
66     receive() external payable {
67         _fallback();
68     }
69 
70     /**
71      * @return The Address of the implementation.
72      */
73     function _implementation() internal view virtual returns (address);
74 
75     /**
76      * @dev Delegates execution to an implementation contract.
77      * This is a low level function that doesn't return to its internal call site.
78      * It will return to the external caller whatever the implementation returns.
79      * @param implementation Address to delegate.
80      */
81     function _delegate(address implementation) internal {
82         assembly {
83             // Copy msg.data. We take full control of memory in this inline assembly
84             // block because it will not return to Solidity code. We overwrite the
85             // Solidity scratch pad at memory position 0.
86             calldatacopy(0, 0, calldatasize())
87 
88             // Call the implementation.
89             // out and outsize are 0 because we don't know the size yet.
90             let result := delegatecall(
91                 gas(),
92                 implementation,
93                 0,
94                 calldatasize(),
95                 0,
96                 0
97             )
98 
99             // Copy the returned data.
100             returndatacopy(0, 0, returndatasize())
101 
102             switch result
103                 // delegatecall returns 0 on error.
104                 case 0 {
105                     revert(0, returndatasize())
106                 }
107                 default {
108                     return(0, returndatasize())
109                 }
110         }
111     }
112 
113     /**
114      * @dev Function that is run as the first thing in the fallback function.
115      * Can be redefined in derived contracts to add functionality.
116      * Redefinitions must call super._willFallback().
117      */
118     function _willFallback() internal virtual {}
119 
120     /**
121      * @dev fallback implementation.
122      * Extracted to enable manual triggering.
123      */
124     function _fallback() internal {
125         _willFallback();
126         _delegate(_implementation());
127     }
128 }
129 
130 // Part: UpgradeabilityProxy
131 
132 /**
133  * @title UpgradeabilityProxy
134  * @dev This contract implements a proxy that allows to change the
135  * implementation address to which it will delegate.
136  * Such a change is called an implementation upgrade.
137  */
138 contract UpgradeabilityProxy is Proxy {
139     /**
140      * @dev Contract constructor.
141      * @param _logic Address of the initial implementation.
142      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
143      * It should include the signature and the parameters of the function to be called, as described in
144      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
145      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
146      */
147     constructor(address _logic, bytes memory _data) public payable {
148         assert(
149             IMPLEMENTATION_SLOT ==
150                 bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
151         );
152         _setImplementation(_logic);
153         if (_data.length > 0) {
154             (bool success, ) = _logic.delegatecall(_data);
155             require(success);
156         }
157     }
158 
159     /**
160      * @dev Emitted when the implementation is upgraded.
161      * @param implementation Address of the new implementation.
162      */
163     event Upgraded(address indexed implementation);
164 
165     /**
166      * @dev Storage slot with the address of the current implementation.
167      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
168      * validated in the constructor.
169      */
170     bytes32 internal constant IMPLEMENTATION_SLOT =
171         0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
172 
173     /**
174      * @dev Returns the current implementation.
175      * @return impl Address of the current implementation
176      */
177     function _implementation() internal view override returns (address impl) {
178         bytes32 slot = IMPLEMENTATION_SLOT;
179         assembly {
180             impl := sload(slot)
181         }
182     }
183 
184     /**
185      * @dev Upgrades the proxy to a new implementation.
186      * @param newImplementation Address of the new implementation.
187      */
188     function _upgradeTo(address newImplementation) internal {
189         _setImplementation(newImplementation);
190         emit Upgraded(newImplementation);
191     }
192 
193     /**
194      * @dev Sets the implementation address of the proxy.
195      * @param newImplementation Address of the new implementation.
196      */
197     function _setImplementation(address newImplementation) internal {
198         require(
199             Address.isContract(newImplementation),
200             "Cannot set a proxy implementation to a non-contract address"
201         );
202 
203         bytes32 slot = IMPLEMENTATION_SLOT;
204 
205         assembly {
206             sstore(slot, newImplementation)
207         }
208     }
209 }
210 
211 // File: AdminUpgradeabilityProxy.sol
212 
213 /**
214  * @title AdminUpgradeabilityProxy
215  * @dev This contract combines an upgradeability proxy with an authorization
216  * mechanism for administrative tasks.
217  * All external functions in this contract must be guarded by the
218  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
219  * feature proposal that would enable this to be done automatically.
220  */
221 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
222     /**
223      * Contract constructor.
224      * @param _logic address of the initial implementation.
225      * @param _admin Address of the proxy administrator.
226      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
227      * It should include the signature and the parameters of the function to be called, as described in
228      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
229      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
230      */
231     constructor(
232         address _logic,
233         address _admin,
234         bytes memory _data
235     ) public payable UpgradeabilityProxy(_logic, _data) {
236         assert(
237             ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1)
238         );
239         _setAdmin(_admin);
240     }
241 
242     /**
243      * @dev Emitted when the administration has been transferred.
244      * @param previousAdmin Address of the previous admin.
245      * @param newAdmin Address of the new admin.
246      */
247     event AdminChanged(address previousAdmin, address newAdmin);
248 
249     /**
250      * @dev Storage slot with the admin of the contract.
251      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
252      * validated in the constructor.
253      */
254 
255     bytes32 internal constant ADMIN_SLOT =
256         0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
257 
258     /**
259      * @dev Modifier to check whether the `msg.sender` is the admin.
260      * If it is, it will run the function. Otherwise, it will delegate the call
261      * to the implementation.
262      */
263     modifier ifAdmin() {
264         if (msg.sender == _admin()) {
265             _;
266         } else {
267             _fallback();
268         }
269     }
270 
271     /**
272      * @return The address of the proxy admin.
273      */
274     function admin() external ifAdmin returns (address) {
275         return _admin();
276     }
277 
278     /**
279      * @return The address of the implementation.
280      */
281     function implementation() external ifAdmin returns (address) {
282         return _implementation();
283     }
284 
285     /**
286      * @dev Changes the admin of the proxy.
287      * Only the current admin can call this function.
288      * @param newAdmin Address to transfer proxy administration to.
289      */
290     function changeAdmin(address newAdmin) external ifAdmin {
291         require(
292             newAdmin != address(0),
293             "Cannot change the admin of a proxy to the zero address"
294         );
295         emit AdminChanged(_admin(), newAdmin);
296         _setAdmin(newAdmin);
297     }
298 
299     /**
300      * @dev Upgrade the backing implementation of the proxy.
301      * Only the admin can call this function.
302      * @param newImplementation Address of the new implementation.
303      */
304     function upgradeTo(address newImplementation) external ifAdmin {
305         _upgradeTo(newImplementation);
306     }
307 
308     /**
309      * @dev Upgrade the backing implementation of the proxy and call a function
310      * on the new implementation.
311      * This is useful to initialize the proxied contract.
312      * @param newImplementation Address of the new implementation.
313      * @param data Data to send as msg.data in the low level call.
314      * It should include the signature and the parameters of the function to be called, as described in
315      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
316      */
317     function upgradeToAndCall(address newImplementation, bytes calldata data)
318         external
319         payable
320         ifAdmin
321     {
322         _upgradeTo(newImplementation);
323         (bool success, ) = newImplementation.delegatecall(data);
324         require(success);
325     }
326 
327     /**
328      * @return adm The admin slot.
329      */
330     function _admin() internal view returns (address adm) {
331         bytes32 slot = ADMIN_SLOT;
332         assembly {
333             adm := sload(slot)
334         }
335     }
336 
337     /**
338      * @dev Sets the address of the proxy admin.
339      * @param newAdmin Address of the new proxy admin.
340      */
341     function _setAdmin(address newAdmin) internal {
342         bytes32 slot = ADMIN_SLOT;
343 
344         assembly {
345             sstore(slot, newAdmin)
346         }
347     }
348 
349     /**
350      * @dev Only fall back when the sender is not the admin.
351      */
352     function _willFallback() internal virtual override {
353         require(
354             msg.sender != _admin(),
355             "Cannot call fallback function from the proxy admin"
356         );
357         super._willFallback();
358     }
359 }