1 pragma solidity ^0.6.0;
2 
3 
4 // This file has been flattened from
5 // https://github.com/OpenZeppelin/openzeppelin-sdk/blob/solc-0.6/packages/lib/contracts/upgradeability/AdminUpgradeabilityProxy.sol
6 // Due to the lack of 0.6.0 version
7 // File: @openzeppelin/upgrades/contracts/upgradeability/Proxy.sol
8 // dHEDGE DAO - https://dhedge.org
9 //
10 // MIT License
11 // ===========
12 //
13 // Copyright (c) 2020 dHEDGE DAO
14 //
15 // Permission is hereby granted, free of charge, to any person obtaining a copy
16 // of this software and associated documentation files (the "Software"), to deal
17 // in the Software without restriction, including without limitation the rights
18 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
19 // copies of the Software, and to permit persons to whom the Software is
20 // furnished to do so, subject to the following conditions:
21 //
22 // The above copyright notice and this permission notice shall be included in all
23 // copies or substantial portions of the Software.
24 //
25 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
26 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
27 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
28 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
29 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
30 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
31 //
32 /**
33  * @title Proxy
34  * @dev Implements delegation of calls to other contracts, with proper
35  * forwarding of return values and bubbling of failures.
36  * It defines a fallback function that delegates all calls to the address
37  * returned by the abstract _implementation() internal function.
38  */
39 abstract contract Proxy {
40     /**
41      * @dev Fallback function.
42      * Implemented entirely in `_fallback`.
43      */
44     fallback() external payable {
45         _fallback();
46     }
47 
48     receive() external payable {
49         _fallback();
50     }
51 
52     /**
53      * @return The Address of the implementation.
54      */
55     function _implementation() internal virtual view returns (address);
56 
57     /**
58      * @dev Delegates execution to an implementation contract.
59      * This is a low level function that doesn't return to its internal call site.
60      * It will return to the external caller whatever the implementation returns.
61      * @param implementation Address to delegate.
62      */
63     function _delegate(address implementation) internal {
64         assembly {
65             // Copy msg.data. We take full control of memory in this inline assembly
66             // block because it will not return to Solidity code. We overwrite the
67             // Solidity scratch pad at memory position 0.
68             calldatacopy(0, 0, calldatasize())
69 
70             // Call the implementation.
71             // out and outsize are 0 because we don't know the size yet.
72             let result := delegatecall(
73                 gas(),
74                 implementation,
75                 0,
76                 calldatasize(),
77                 0,
78                 0
79             )
80 
81             // Copy the returned data.
82             returndatacopy(0, 0, returndatasize())
83 
84             switch result
85                 // delegatecall returns 0 on error.
86                 case 0 {
87                     revert(0, returndatasize())
88                 }
89                 default {
90                     return(0, returndatasize())
91                 }
92         }
93     }
94 
95     /**
96      * @dev Function that is run as the first thing in the fallback function.
97      * Can be redefined in derived contracts to add functionality.
98      * Redefinitions must call super._willFallback().
99      */
100     function _willFallback() internal virtual {}
101 
102     /**
103      * @dev fallback implementation.
104      * Extracted to enable manual triggering.
105      */
106     function _fallback() internal {
107         _willFallback();
108         _delegate(_implementation());
109     }
110 }
111 
112 // File: @openzeppelin/upgrades/contracts/utils/Address.sol
113 /**
114  * Utility library of inline functions on addresses
115  *
116  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
117  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
118  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
119  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
120  */
121 library OpenZeppelinUpgradesAddress {
122     /**
123      * Returns whether the target address is a contract
124      * @dev This function will return false if invoked during the constructor of a contract,
125      * as the code is not actually created until after the constructor finishes.
126      * @param account address of the account to check
127      * @return whether the target address is a contract
128      */
129     function isContract(address account) internal view returns (bool) {
130         uint256 size;
131         // XXX Currently there is no better way to check if there is a contract in an address
132         // than to check the size of the code at that address.
133         // See https://ethereum.stackexchange.com/a/14016/36603
134         // for more details about how this works.
135         // TODO Check this again before the Serenity release, because all addresses will be
136         // contracts then.
137         // solhint-disable-next-line no-inline-assembly
138         assembly {
139             size := extcodesize(account)
140         }
141         return size > 0;
142     }
143 }
144 
145 // File: @openzeppelin/upgrades/contracts/upgradeability/BaseUpgradeabilityProxy.sol
146 /**
147  * @title BaseUpgradeabilityProxy
148  * @dev This contract implements a proxy that allows to change the
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
193             OpenZeppelinUpgradesAddress.isContract(newImplementation),
194             "Cannot set a proxy implementation to a non-contract address"
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
205 // File: @openzeppelin/upgrades/contracts/upgradeability/UpgradeabilityProxy.sol
206 /**
207  * @title UpgradeabilityProxy
208  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
209  * implementation and init data.
210  */
211 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
212     /**
213      * @dev Contract constructor.
214      * @param _logic Address of the initial implementation.
215      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
216      * It should include the signature and the parameters of the function to be called, as described in
217      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
218      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
219      */
220     constructor(address _logic, bytes memory _data) public payable {
221         assert(
222             IMPLEMENTATION_SLOT ==
223                 bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
224         );
225         _setImplementation(_logic);
226         if (_data.length > 0) {
227             (bool success, ) = _logic.delegatecall(_data);
228             require(success);
229         }
230     }
231 }
232 
233 // File: @openzeppelin/upgrades/contracts/upgradeability/BaseAdminUpgradeabilityProxy.sol
234 /**
235  * @title BaseAdminUpgradeabilityProxy
236  * @dev This contract combines an upgradeability proxy with an authorization
237  * mechanism for administrative tasks.
238  * All external functions in this contract must be guarded by the
239  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
240  * feature proposal that would enable this to be done automatically.
241  */
242 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
243     /**
244      * @dev Emitted when the administration has been transferred.
245      * @param previousAdmin Address of the previous admin.
246      * @param newAdmin Address of the new admin.
247      */
248     event AdminChanged(address previousAdmin, address newAdmin);
249 
250     /**
251      * @dev Storage slot with the admin of the contract.
252      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
253      * validated in the constructor.
254      */
255 
256     bytes32
257         internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
258 
259     /**
260      * @dev Modifier to check whether the `msg.sender` is the admin.
261      * If it is, it will run the function. Otherwise, it will delegate the call
262      * to the implementation.
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
273      * @return The address of the proxy admin.
274      */
275     function admin() external ifAdmin returns (address) {
276         return _admin();
277     }
278 
279     /**
280      * @return The address of the implementation.
281      */
282     function implementation() external ifAdmin returns (address) {
283         return _implementation();
284     }
285 
286     /**
287      * @dev Changes the admin of the proxy.
288      * Only the current admin can call this function.
289      * @param newAdmin Address to transfer proxy administration to.
290      */
291     function changeAdmin(address newAdmin) external ifAdmin {
292         require(
293             newAdmin != address(0),
294             "Cannot change the admin of a proxy to the zero address"
295         );
296         emit AdminChanged(_admin(), newAdmin);
297         _setAdmin(newAdmin);
298     }
299 
300     /**
301      * @dev Upgrade the backing implementation of the proxy.
302      * Only the admin can call this function.
303      * @param newImplementation Address of the new implementation.
304      */
305     function upgradeTo(address newImplementation) external ifAdmin {
306         _upgradeTo(newImplementation);
307     }
308 
309     /**
310      * @dev Upgrade the backing implementation of the proxy and call a function
311      * on the new implementation.
312      * This is useful to initialize the proxied contract.
313      * @param newImplementation Address of the new implementation.
314      * @param data Data to send as msg.data in the low level call.
315      * It should include the signature and the parameters of the function to be called, as described in
316      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
317      */
318     function upgradeToAndCall(address newImplementation, bytes calldata data)
319         external
320         payable
321         ifAdmin
322     {
323         _upgradeTo(newImplementation);
324         (bool success, ) = newImplementation.delegatecall(data);
325         require(success);
326     }
327 
328     /**
329      * @return adm The admin slot.
330      */
331     function _admin() internal view returns (address adm) {
332         bytes32 slot = ADMIN_SLOT;
333         assembly {
334             adm := sload(slot)
335         }
336     }
337 
338     /**
339      * @dev Sets the address of the proxy admin.
340      * @param newAdmin Address of the new proxy admin.
341      */
342     function _setAdmin(address newAdmin) internal {
343         bytes32 slot = ADMIN_SLOT;
344 
345         assembly {
346             sstore(slot, newAdmin)
347         }
348     }
349 
350     /**
351      * @dev Only fall back when the sender is not the admin.
352      */
353     function _willFallback() internal virtual override {
354         require(
355             msg.sender != _admin(),
356             "Cannot call fallback function from the proxy admin"
357         );
358         super._willFallback();
359     }
360 }
361 
362 // File: @openzeppelin/upgrades/contracts/upgradeability/AdminUpgradeabilityProxy.sol
363 /**
364  * @title AdminUpgradeabilityProxy
365  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for
366  * initializing the implementation, admin, and init data.
367  */
368 contract AdminUpgradeabilityProxy is
369     BaseAdminUpgradeabilityProxy,
370     UpgradeabilityProxy
371 {
372     /**
373      * Contract constructor.
374      * @param _logic address of the initial implementation.
375      * @param _admin Address of the proxy administrator.
376      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
377      * It should include the signature and the parameters of the function to be called, as described in
378      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
379      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
380      */
381     constructor(
382         address _logic,
383         address _admin,
384         bytes memory _data
385     ) public payable UpgradeabilityProxy(_logic, _data) {
386         assert(
387             ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1)
388         );
389         _setAdmin(_admin);
390     }
391 
392     function _willFallback()
393         internal
394         override(BaseAdminUpgradeabilityProxy, Proxy)
395     {
396         super._willFallback();
397     }
398 }
399 
400 // dHEDGE DAO - https://dhedge.org
401 //
402 // MIT License
403 // ===========
404 //
405 // Copyright (c) 2020 dHEDGE DAO
406 //
407 // Permission is hereby granted, free of charge, to any person obtaining a copy
408 // of this software and associated documentation files (the "Software"), to deal
409 // in the Software without restriction, including without limitation the rights
410 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
411 // copies of the Software, and to permit persons to whom the Software is
412 // furnished to do so, subject to the following conditions:
413 //
414 // The above copyright notice and this permission notice shall be included in all
415 // copies or substantial portions of the Software.
416 //
417 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
418 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
419 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
420 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
421 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
422 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
423 //
424 // ---------------------------------------------------------------------
425 // dHedge DAO Token Proxy
426 //
427 // Notes          : This contract is a proxy to the dHedge DAO Token.
428 //                  It allows upgradeability using CALLDELEGATE pattern (code courtesy of https://openzeppelin.org/).
429 //                  This address should be accessed with the ABI of the current token delegate contract.
430 //
431 // ---------------------------------------------------------------------
432 contract DHedgeTokenProxy is AdminUpgradeabilityProxy {
433     constructor(address _implementation, bytes memory _data)
434         public
435         payable
436         AdminUpgradeabilityProxy(_implementation, msg.sender, _data)
437     {}
438 }