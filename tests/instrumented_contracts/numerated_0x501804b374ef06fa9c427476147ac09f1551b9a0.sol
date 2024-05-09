1 /*
2  * Origin Protocol
3  * https://originprotocol.com
4  *
5  * Released under the MIT license
6  * https://github.com/OriginProtocol/origin-dollar
7  *
8  * Copyright 2020 Origin Protocol, Inc
9  *
10  * Permission is hereby granted, free of charge, to any person obtaining a copy
11  * of this software and associated documentation files (the "Software"), to deal
12  * in the Software without restriction, including without limitation the rights
13  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
14  * copies of the Software, and to permit persons to whom the Software is
15  * furnished to do so, subject to the following conditions:
16  *
17  * The above copyright notice and this permission notice shall be included in
18  * all copies or substantial portions of the Software.
19  *
20  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
21  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
22  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
23  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
24  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
25  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
26  * SOFTWARE.
27  */
28 // File: contracts/governance/Governable.sol
29 
30 pragma solidity 0.5.11;
31 
32 /**
33  * @title OUSD Governable Contract
34  * @dev Copy of the openzeppelin Ownable.sol contract with nomenclature change
35  *      from owner to governor and renounce methods removed. Does not use
36  *      Context.sol like Ownable.sol does for simplification.
37  * @author Origin Protocol Inc
38  */
39 contract Governable {
40     // Storage position of the owner and pendingOwner of the contract
41     // keccak256("OUSD.governor");
42     bytes32
43         private constant governorPosition = 0x7bea13895fa79d2831e0a9e28edede30099005a50d652d8957cf8a607ee6ca4a;
44 
45     // keccak256("OUSD.pending.governor");
46     bytes32
47         private constant pendingGovernorPosition = 0x44c4d30b2eaad5130ad70c3ba6972730566f3e6359ab83e800d905c61b1c51db;
48 
49     // keccak256("OUSD.reentry.status");
50     bytes32
51         private constant reentryStatusPosition = 0x53bf423e48ed90e97d02ab0ebab13b2a235a6bfbe9c321847d5c175333ac4535;
52 
53     // See OpenZeppelin ReentrancyGuard implementation
54     uint256 constant _NOT_ENTERED = 1;
55     uint256 constant _ENTERED = 2;
56 
57     event PendingGovernorshipTransfer(
58         address indexed previousGovernor,
59         address indexed newGovernor
60     );
61 
62     event GovernorshipTransferred(
63         address indexed previousGovernor,
64         address indexed newGovernor
65     );
66 
67     /**
68      * @dev Initializes the contract setting the deployer as the initial Governor.
69      */
70     constructor() internal {
71         _setGovernor(msg.sender);
72         emit GovernorshipTransferred(address(0), _governor());
73     }
74 
75     /**
76      * @dev Returns the address of the current Governor.
77      */
78     function governor() public view returns (address) {
79         return _governor();
80     }
81 
82     /**
83      * @dev Returns the address of the current Governor.
84      */
85     function _governor() internal view returns (address governorOut) {
86         bytes32 position = governorPosition;
87         assembly {
88             governorOut := sload(position)
89         }
90     }
91 
92     /**
93      * @dev Returns the address of the pending Governor.
94      */
95     function _pendingGovernor()
96         internal
97         view
98         returns (address pendingGovernor)
99     {
100         bytes32 position = pendingGovernorPosition;
101         assembly {
102             pendingGovernor := sload(position)
103         }
104     }
105 
106     /**
107      * @dev Throws if called by any account other than the Governor.
108      */
109     modifier onlyGovernor() {
110         require(isGovernor(), "Caller is not the Governor");
111         _;
112     }
113 
114     /**
115      * @dev Returns true if the caller is the current Governor.
116      */
117     function isGovernor() public view returns (bool) {
118         return msg.sender == _governor();
119     }
120 
121     function _setGovernor(address newGovernor) internal {
122         bytes32 position = governorPosition;
123         assembly {
124             sstore(position, newGovernor)
125         }
126     }
127 
128     /**
129      * @dev Prevents a contract from calling itself, directly or indirectly.
130      * Calling a `nonReentrant` function from another `nonReentrant`
131      * function is not supported. It is possible to prevent this from happening
132      * by making the `nonReentrant` function external, and make it call a
133      * `private` function that does the actual work.
134      */
135     modifier nonReentrant() {
136         bytes32 position = reentryStatusPosition;
137         uint256 _reentry_status;
138         assembly {
139             _reentry_status := sload(position)
140         }
141 
142         // On the first call to nonReentrant, _notEntered will be true
143         require(_reentry_status != _ENTERED, "Reentrant call");
144 
145         // Any calls to nonReentrant after this point will fail
146         assembly {
147             sstore(position, _ENTERED)
148         }
149 
150         _;
151 
152         // By storing the original value once again, a refund is triggered (see
153         // https://eips.ethereum.org/EIPS/eip-2200)
154         assembly {
155             sstore(position, _NOT_ENTERED)
156         }
157     }
158 
159     function _setPendingGovernor(address newGovernor) internal {
160         bytes32 position = pendingGovernorPosition;
161         assembly {
162             sstore(position, newGovernor)
163         }
164     }
165 
166     /**
167      * @dev Transfers Governance of the contract to a new account (`newGovernor`).
168      * Can only be called by the current Governor. Must be claimed for this to complete
169      * @param _newGovernor Address of the new Governor
170      */
171     function transferGovernance(address _newGovernor) external onlyGovernor {
172         _setPendingGovernor(_newGovernor);
173         emit PendingGovernorshipTransfer(_governor(), _newGovernor);
174     }
175 
176     /**
177      * @dev Claim Governance of the contract to a new account (`newGovernor`).
178      * Can only be called by the new Governor.
179      */
180     function claimGovernance() external {
181         require(
182             msg.sender == _pendingGovernor(),
183             "Only the pending Governor can complete the claim"
184         );
185         _changeGovernor(msg.sender);
186     }
187 
188     /**
189      * @dev Change Governance of the contract to a new account (`newGovernor`).
190      * @param _newGovernor Address of the new Governor
191      */
192     function _changeGovernor(address _newGovernor) internal {
193         require(_newGovernor != address(0), "New Governor is address(0)");
194         emit GovernorshipTransferred(_governor(), _newGovernor);
195         _setGovernor(_newGovernor);
196     }
197 }
198 
199 // File: @openzeppelin/upgrades/contracts/upgradeability/Proxy.sol
200 
201 pragma solidity ^0.5.0;
202 
203 /**
204  * @title Proxy
205  * @dev Implements delegation of calls to other contracts, with proper
206  * forwarding of return values and bubbling of failures.
207  * It defines a fallback function that delegates all calls to the address
208  * returned by the abstract _implementation() internal function.
209  */
210 contract Proxy {
211   /**
212    * @dev Fallback function.
213    * Implemented entirely in `_fallback`.
214    */
215   function () payable external {
216     _fallback();
217   }
218 
219   /**
220    * @return The Address of the implementation.
221    */
222   function _implementation() internal view returns (address);
223 
224   /**
225    * @dev Delegates execution to an implementation contract.
226    * This is a low level function that doesn't return to its internal call site.
227    * It will return to the external caller whatever the implementation returns.
228    * @param implementation Address to delegate.
229    */
230   function _delegate(address implementation) internal {
231     assembly {
232       // Copy msg.data. We take full control of memory in this inline assembly
233       // block because it will not return to Solidity code. We overwrite the
234       // Solidity scratch pad at memory position 0.
235       calldatacopy(0, 0, calldatasize)
236 
237       // Call the implementation.
238       // out and outsize are 0 because we don't know the size yet.
239       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
240 
241       // Copy the returned data.
242       returndatacopy(0, 0, returndatasize)
243 
244       switch result
245       // delegatecall returns 0 on error.
246       case 0 { revert(0, returndatasize) }
247       default { return(0, returndatasize) }
248     }
249   }
250 
251   /**
252    * @dev Function that is run as the first thing in the fallback function.
253    * Can be redefined in derived contracts to add functionality.
254    * Redefinitions must call super._willFallback().
255    */
256   function _willFallback() internal {
257   }
258 
259   /**
260    * @dev fallback implementation.
261    * Extracted to enable manual triggering.
262    */
263   function _fallback() internal {
264     _willFallback();
265     _delegate(_implementation());
266   }
267 }
268 
269 // File: @openzeppelin/upgrades/contracts/utils/Address.sol
270 
271 pragma solidity ^0.5.0;
272 
273 /**
274  * Utility library of inline functions on addresses
275  *
276  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
277  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
278  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
279  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
280  */
281 library OpenZeppelinUpgradesAddress {
282     /**
283      * Returns whether the target address is a contract
284      * @dev This function will return false if invoked during the constructor of a contract,
285      * as the code is not actually created until after the constructor finishes.
286      * @param account address of the account to check
287      * @return whether the target address is a contract
288      */
289     function isContract(address account) internal view returns (bool) {
290         uint256 size;
291         // XXX Currently there is no better way to check if there is a contract in an address
292         // than to check the size of the code at that address.
293         // See https://ethereum.stackexchange.com/a/14016/36603
294         // for more details about how this works.
295         // TODO Check this again before the Serenity release, because all addresses will be
296         // contracts then.
297         // solhint-disable-next-line no-inline-assembly
298         assembly { size := extcodesize(account) }
299         return size > 0;
300     }
301 }
302 
303 // File: @openzeppelin/upgrades/contracts/upgradeability/BaseUpgradeabilityProxy.sol
304 
305 pragma solidity ^0.5.0;
306 
307 
308 /**
309  * @title BaseUpgradeabilityProxy
310  * @dev This contract implements a proxy that allows to change the
311  * implementation address to which it will delegate.
312  * Such a change is called an implementation upgrade.
313  */
314 contract BaseUpgradeabilityProxy is Proxy {
315   /**
316    * @dev Emitted when the implementation is upgraded.
317    * @param implementation Address of the new implementation.
318    */
319   event Upgraded(address indexed implementation);
320 
321   /**
322    * @dev Storage slot with the address of the current implementation.
323    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
324    * validated in the constructor.
325    */
326   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
327 
328   /**
329    * @dev Returns the current implementation.
330    * @return Address of the current implementation
331    */
332   function _implementation() internal view returns (address impl) {
333     bytes32 slot = IMPLEMENTATION_SLOT;
334     assembly {
335       impl := sload(slot)
336     }
337   }
338 
339   /**
340    * @dev Upgrades the proxy to a new implementation.
341    * @param newImplementation Address of the new implementation.
342    */
343   function _upgradeTo(address newImplementation) internal {
344     _setImplementation(newImplementation);
345     emit Upgraded(newImplementation);
346   }
347 
348   /**
349    * @dev Sets the implementation address of the proxy.
350    * @param newImplementation Address of the new implementation.
351    */
352   function _setImplementation(address newImplementation) internal {
353     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
354 
355     bytes32 slot = IMPLEMENTATION_SLOT;
356 
357     assembly {
358       sstore(slot, newImplementation)
359     }
360   }
361 }
362 
363 // File: contracts/proxies/InitializeGovernedUpgradeabilityProxy.sol
364 
365 pragma solidity 0.5.11;
366 
367 
368 /**
369  * @title BaseGovernedUpgradeabilityProxy
370  * @dev This contract combines an upgradeability proxy with our governor system
371  * @author Origin Protocol Inc
372  */
373 contract InitializeGovernedUpgradeabilityProxy is
374     Governable,
375     BaseUpgradeabilityProxy
376 {
377     /**
378      * @dev Contract initializer with Governor enforcement
379      * @param _logic Address of the initial implementation.
380      * @param _initGovernor Address of the initial Governor.
381      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
382      * It should include the signature and the parameters of the function to be called, as described in
383      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
384      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
385      */
386     function initialize(
387         address _logic,
388         address _initGovernor,
389         bytes memory _data
390     ) public payable onlyGovernor {
391         require(_implementation() == address(0));
392         assert(
393             IMPLEMENTATION_SLOT ==
394                 bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
395         );
396         _changeGovernor(_initGovernor);
397         _setImplementation(_logic);
398         if (_data.length > 0) {
399             (bool success, ) = _logic.delegatecall(_data);
400             require(success);
401         }
402     }
403 
404     /**
405      * @return The address of the proxy admin/it's also the governor.
406      */
407     function admin() external view returns (address) {
408         return _governor();
409     }
410 
411     /**
412      * @return The address of the implementation.
413      */
414     function implementation() external view returns (address) {
415         return _implementation();
416     }
417 
418     /**
419      * @dev Upgrade the backing implementation of the proxy.
420      * Only the admin can call this function.
421      * @param newImplementation Address of the new implementation.
422      */
423     function upgradeTo(address newImplementation) external onlyGovernor {
424         _upgradeTo(newImplementation);
425     }
426 
427     /**
428      * @dev Upgrade the backing implementation of the proxy and call a function
429      * on the new implementation.
430      * This is useful to initialize the proxied contract.
431      * @param newImplementation Address of the new implementation.
432      * @param data Data to send as msg.data in the low level call.
433      * It should include the signature and the parameters of the function to be called, as described in
434      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
435      */
436     function upgradeToAndCall(address newImplementation, bytes calldata data)
437         external
438         payable
439         onlyGovernor
440     {
441         _upgradeTo(newImplementation);
442         (bool success, ) = newImplementation.delegatecall(data);
443         require(success);
444     }
445 }
