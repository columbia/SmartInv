1 /**
2  *Submitted for verification at Etherscan.io on 2019-12-05
3 */
4 
5 /*
6 
7   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
8 
9   Licensed under the Apache License, Version 2.0 (the "License");
10   you may not use this file except in compliance with the License.
11   You may obtain a copy of the License at
12 
13   http://www.apache.org/licenses/LICENSE-2.0
14 
15   Unless required by applicable law or agreed to in writing, software
16   distributed under the License is distributed on an "AS IS" BASIS,
17   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
18   See the License for the specific language governing permissions and
19   limitations under the License.
20 */
21 pragma solidity ^0.5.11;
22 
23 
24 /// @title ReentrancyGuard
25 /// @author Brecht Devos - <brecht@loopring.org>
26 /// @dev Exposes a modifier that guards a function against reentrancy
27 ///      Changing the value of the same storage value multiple times in a transaction
28 ///      is cheap (starting from Istanbul) so there is no need to minimize
29 ///      the number of times the value is changed
30 contract ReentrancyGuard
31 {
32     //The default value must be 0 in order to work behind a proxy.
33     uint private _guardValue;
34 
35     // Use this modifier on a function to prevent reentrancy
36     modifier nonReentrant()
37     {
38         // Check if the guard value has its original value
39         require(_guardValue == 0, "REENTRANCY");
40 
41         // Set the value to something else
42         _guardValue = 1;
43 
44         // Function body
45         _;
46 
47         // Set the value back
48         _guardValue = 0;
49     }
50 }
51 /*
52 
53   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
54 
55   Licensed under the Apache License, Version 2.0 (the "License");
56   you may not use this file except in compliance with the License.
57   You may obtain a copy of the License at
58 
59   http://www.apache.org/licenses/LICENSE-2.0
60 
61   Unless required by applicable law or agreed to in writing, software
62   distributed under the License is distributed on an "AS IS" BASIS,
63   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
64   See the License for the specific language governing permissions and
65   limitations under the License.
66 */
67 
68 
69 /*
70 
71   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
72 
73   Licensed under the Apache License, Version 2.0 (the "License");
74   you may not use this file except in compliance with the License.
75   You may obtain a copy of the License at
76 
77   http://www.apache.org/licenses/LICENSE-2.0
78 
79   Unless required by applicable law or agreed to in writing, software
80   distributed under the License is distributed on an "AS IS" BASIS,
81   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
82   See the License for the specific language governing permissions and
83   limitations under the License.
84 */
85 
86 
87 
88 /// @title Ownable
89 /// @author Brecht Devos - <brecht@loopring.org>
90 /// @dev The Ownable contract has an owner address, and provides basic
91 ///      authorization control functions, this simplifies the implementation of
92 ///      "user permissions".
93 contract Ownable
94 {
95     address public owner;
96 
97     event OwnershipTransferred(
98         address indexed previousOwner,
99         address indexed newOwner
100     );
101 
102     /// @dev The Ownable constructor sets the original `owner` of the contract
103     ///      to the sender.
104     constructor()
105         public
106     {
107         owner = msg.sender;
108     }
109 
110     /// @dev Throws if called by any account other than the owner.
111     modifier onlyOwner()
112     {
113         require(msg.sender == owner, "UNAUTHORIZED");
114         _;
115     }
116 
117     /// @dev Allows the current owner to transfer control of the contract to a
118     ///      new owner.
119     /// @param newOwner The address to transfer ownership to.
120     function transferOwnership(
121         address newOwner
122         )
123         public
124         onlyOwner
125     {
126         require(newOwner != address(0), "ZERO_ADDRESS");
127         emit OwnershipTransferred(owner, newOwner);
128         owner = newOwner;
129     }
130 
131     function renounceOwnership()
132         public
133         onlyOwner
134     {
135         emit OwnershipTransferred(owner, address(0));
136         owner = address(0);
137     }
138 }
139 
140 
141 
142 /// @title Claimable
143 /// @author Brecht Devos - <brecht@loopring.org>
144 /// @dev Extension for the Ownable contract, where the ownership needs
145 ///      to be claimed. This allows the new owner to accept the transfer.
146 contract Claimable is Ownable
147 {
148     address public pendingOwner;
149 
150     /// @dev Modifier throws if called by any account other than the pendingOwner.
151     modifier onlyPendingOwner() {
152         require(msg.sender == pendingOwner, "UNAUTHORIZED");
153         _;
154     }
155 
156     /// @dev Allows the current owner to set the pendingOwner address.
157     /// @param newOwner The address to transfer ownership to.
158     function transferOwnership(
159         address newOwner
160         )
161         public
162         onlyOwner
163     {
164         require(newOwner != address(0) && newOwner != owner, "INVALID_ADDRESS");
165         pendingOwner = newOwner;
166     }
167 
168     /// @dev Allows the pendingOwner address to finalize the transfer.
169     function claimOwnership()
170         public
171         onlyPendingOwner
172     {
173         emit OwnershipTransferred(owner, pendingOwner);
174         owner = pendingOwner;
175         pendingOwner = address(0);
176     }
177 }
178 /*
179 
180   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
181 
182   Licensed under the Apache License, Version 2.0 (the "License");
183   you may not use this file except in compliance with the License.
184   You may obtain a copy of the License at
185 
186   http://www.apache.org/licenses/LICENSE-2.0
187 
188   Unless required by applicable law or agreed to in writing, software
189   distributed under the License is distributed on an "AS IS" BASIS,
190   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
191   See the License for the specific language governing permissions and
192   limitations under the License.
193 */
194 
195 
196 
197 
198 
199 
200 /// @title IUniversalRegistry
201 /// @dev This contract manages all registered ILoopring versions and all Loopring
202 ///      based exchanges.
203 ///
204 /// @author Daniel Wang  - <daniel@loopring.org>
205 contract IUniversalRegistry is Claimable, ReentrancyGuard
206 {
207     enum ForgeMode {
208         AUTO_UPGRADABLE,
209         MANUAL_UPGRADABLE,
210         PROXIED,
211         NATIVE
212     }
213 
214     /// === Events ===
215 
216     event ProtocolRegistered (
217         address indexed protocol,
218         address indexed implementationManager,
219         string          version
220     );
221 
222     event ProtocolEnabled (
223         address indexed protocol
224     );
225 
226     event ProtocolDisabled (
227         address indexed protocol
228     );
229 
230     event DefaultProtocolChanged (
231         address indexed oldDefault,
232         address indexed newDefault
233     );
234 
235     event ExchangeForged (
236         address indexed protocol,
237         address indexed implementation,
238         address indexed exchangeAddress,
239         address         owner,
240         ForgeMode       forgeMode,
241         bool            onchainDataAvailability,
242         uint            exchangeId,
243         uint            amountLRCBurned
244     );
245 
246     /// === Data ===
247 
248     address   public lrcAddress;
249     address[] public exchanges;
250     address[] public protocols;
251 
252     // IProtocol.version => IProtocol address
253     mapping (string => address) public versionMap;
254 
255     /// === Functions ===
256 
257     /// @dev Registers a new protocol.
258     /// @param protocol The address of the new protocol.
259     /// @param implementation The new protocol's default implementation.
260     /// @return implManager A new implementation manager to manage the protocol's implementations.
261     function registerProtocol(
262         address protocol,
263         address implementation
264         )
265         external
266         returns (address implManager);
267 
268     /// @dev Sets the default protocol.
269     /// @param protocol The new default protocol.
270     function setDefaultProtocol(
271         address protocol
272         )
273         external;
274 
275     /// @dev Enables a protocol.
276     /// @param protocol The address of the protocol.
277     function enableProtocol(
278         address protocol
279         )
280         external;
281 
282     /// @dev Disables a protocol.
283     /// @param protocol The address of the protocol.
284     function disableProtocol(
285         address protocol
286         )
287         external;
288 
289     /// @dev Creates a new exchange using a specific protocol with msg.sender
290     ///      as owner and operator.
291     /// @param forgeMode The forge mode.
292     /// @param onchainDataAvailability IF the on-chain DA is on
293     /// @param protocol The protocol address, use 0x0 for default.
294     /// @param implementation The implementation to use, use 0x0 for default.
295     /// @return exchangeAddress The new exchange's address
296     /// @return exchangeId The new exchange's ID.
297     function forgeExchange(
298         ForgeMode forgeMode,
299         bool      onchainDataAvailability,
300         address   protocol,
301         address   implementation
302         )
303         external
304         returns (
305             address exchangeAddress,
306             uint    exchangeId
307         );
308 
309     /// @dev Returns information regarding the default protocol.
310     /// @return protocol The address of the default protocol.
311     /// @return implManager The address of the default protocol's implementation manager.
312     /// @return defaultImpl The default protocol's default implementation address.
313     /// @return defaultImplVersion The version of the default implementation.
314     function defaultProtocol()
315         public
316         view
317         returns (
318             address protocol,
319             address versionmanager,
320             address defaultImpl,
321             string  memory protocolVersion,
322             string  memory defaultImplVersion
323         );
324 
325     /// @dev Checks if a protocol has been registered.
326     /// @param protocol The address of the protocol.
327     /// @return registered True if the prococol is registered.
328     function isProtocolRegistered(
329         address protocol
330         )
331         public
332         view
333         returns (bool registered);
334 
335     /// @dev Checks if a protocol has been enabled.
336     /// @param protocol The address of the protocol.
337     /// @return enabled True if the prococol is registered and enabled.
338     function isProtocolEnabled(
339         address protocol
340         )
341         public
342         view
343         returns (bool enabled);
344 
345     /// @dev Checks if the addres is a registered Loopring exchange.
346     /// @return registered True if the address is a registered exchange.
347     function isExchangeRegistered(
348         address exchange
349         )
350         public
351         view
352         returns (bool registered);
353 
354     /// @dev Checks if the given protocol and implementation are both registered and enabled.
355     /// @param protocol The address of the protocol.
356     /// @param implementation The address of the implementation.
357     /// @return enabled True if both the protocol and the implementation are registered and enabled.
358     function isProtocolAndImplementationEnabled(
359         address protocol,
360         address implementation
361         )
362         public
363         view
364         returns (bool enabled);
365 
366     /// @dev Returns the protocol associated with an exchange.
367     /// @param exchangeAddress The address of the exchange.
368     /// @return protocol The protocol address.
369     /// @return implementation The protocol's implementation.
370     /// @return enabled Whether the protocol is enabled.
371     function getExchangeProtocol(
372         address exchangeAddress
373         )
374         public
375         view
376         returns (
377             address protocol,
378             address implementation
379         );
380 }/*
381 
382   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
383 
384   Licensed under the Apache License, Version 2.0 (the "License");
385   you may not use this file except in compliance with the License.
386   You may obtain a copy of the License at
387 
388   http://www.apache.org/licenses/LICENSE-2.0
389 
390   Unless required by applicable law or agreed to in writing, software
391   distributed under the License is distributed on an "AS IS" BASIS,
392   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
393   See the License for the specific language governing permissions and
394   limitations under the License.
395 */
396 
397 
398 
399 
400 
401 
402 /// @title IImplementationManager
403 /// @dev This contract manages implementation versions for a specific ILoopring
404 ///      contract. The ILoopring contract can be considered as the "major" version
405 ///      of a Loopring protocol and each IExchange implementation can be considered
406 ///      as a "minor" version. Multiple IExchange contracts can use the same
407 ///      ILoopring contracts.
408 ///
409 /// @author Daniel Wang  - <daniel@loopring.org>
410 contract IImplementationManager is Claimable, ReentrancyGuard
411 {
412     /// === Events ===
413 
414     event DefaultChanged (
415         address indexed oldDefault,
416         address indexed newDefault
417     );
418 
419     event Registered (
420         address indexed implementation,
421         string          version
422     );
423 
424     event Enabled (
425         address indexed implementation
426     );
427 
428     event Disabled (
429         address indexed implementation
430     );
431 
432     /// === Data ===
433 
434     address   public protocol;
435     address   public defaultImpl;
436     address[] public implementations;
437 
438     // version strings => IExchange addresses
439     mapping (string => address) public versionMap;
440 
441     /// === Functions ===
442 
443     /// @dev Registers a new implementation.
444     /// @param implementation The implemenation to add.
445     function register(
446         address implementation
447         )
448         external;
449 
450     /// @dev Sets the default implemenation.
451     /// @param implementation The new default implementation.
452     function setDefault(
453         address implementation
454         )
455         external;
456 
457     /// @dev Enables an implemenation.
458     /// @param implementation The implementation to be enabled.
459     function enable(
460         address implementation
461         )
462         external;
463 
464     /// @dev Disables an implemenation.
465     /// @param implementation The implementation to be disabled.
466     function disable(
467         address implementation
468         )
469         external;
470 
471     /// @dev Returns version information.
472     /// @return protocolVersion The protocol's version.
473     /// @return defaultImplVersion The default implementation's version.
474     function version()
475         public
476         view
477         returns (
478             string  memory protocolVersion,
479             string  memory defaultImplVersion
480         );
481 
482     /// @dev Returns the latest implemenation added.
483     /// @param implementation The latest implemenation added.
484     function latest()
485         public
486         view
487         returns (address implementation);
488 
489     /// @dev Returns if an implementation has been registered.
490     /// @param registered True if the implementation is registered.
491     function isRegistered(
492         address implementation
493         )
494         public
495         view
496         returns (bool registered);
497 
498     /// @dev Returns if an implementation has been registered and enabled.
499     /// @param enabled True if the implementation is registered and enabled.
500     function isEnabled(
501         address implementation
502         )
503         public
504         view
505         returns (bool enabled);
506 }/*
507 
508   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
509 
510   Licensed under the Apache License, Version 2.0 (the "License");
511   you may not use this file except in compliance with the License.
512   You may obtain a copy of the License at
513 
514   http://www.apache.org/licenses/LICENSE-2.0
515 
516   Unless required by applicable law or agreed to in writing, software
517   distributed under the License is distributed on an "AS IS" BASIS,
518   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
519   See the License for the specific language governing permissions and
520   limitations under the License.
521 */
522 
523 
524 /*
525 
526   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
527 
528   Licensed under the Apache License, Version 2.0 (the "License");
529   you may not use this file except in compliance with the License.
530   You may obtain a copy of the License at
531 
532   http://www.apache.org/licenses/LICENSE-2.0
533 
534   Unless required by applicable law or agreed to in writing, software
535   distributed under the License is distributed on an "AS IS" BASIS,
536   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
537   See the License for the specific language governing permissions and
538   limitations under the License.
539 */
540 
541 
542 // This code is taken from https://github.com/OpenZeppelin/openzeppelin-labs
543 // with minor modifications.
544 
545 
546 
547 
548 /**
549  * @title Proxy
550  * @dev Gives the possibility to delegate any call to a foreign implementation.
551  */
552 contract Proxy {
553   /**
554   * @dev Tells the address of the implementation where every call will be delegated.
555   * @return address of the implementation to which it will be delegated
556   */
557   function implementation() public view returns (address);
558 
559   /**
560   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
561   * This function will return whatever the implementation call returns
562   */
563   function () payable external {
564     address _impl = implementation();
565     require(_impl != address(0));
566 
567     assembly {
568       let ptr := mload(0x40)
569       calldatacopy(ptr, 0, calldatasize)
570       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
571       let size := returndatasize
572       returndatacopy(ptr, 0, size)
573 
574       switch result
575       case 0 { revert(ptr, size) }
576       default { return(ptr, size) }
577     }
578   }
579 }
580 
581 
582 
583 
584 
585 /// @title IExchangeProxy
586 /// @author Daniel Wang  - <daniel@loopring.org>
587 contract IExchangeProxy is Proxy
588 {
589     bytes32 private constant registryPosition = keccak256(
590         "org.loopring.protocol.v3.registry"
591     );
592 
593     constructor(address _registry)
594         public
595     {
596         setRegistry(_registry);
597     }
598 
599     /// @dev Returns the exchange's registry address.
600     function registry()
601         public
602         view
603         returns (address registryAddress)
604     {
605         bytes32 position = registryPosition;
606         assembly { registryAddress := sload(position) }
607     }
608 
609     /// @dev Returns the exchange's protocol address.
610     function protocol()
611         public
612         view
613         returns (address protocolAddress)
614     {
615         IUniversalRegistry r = IUniversalRegistry(registry());
616         (protocolAddress, ) = r.getExchangeProtocol(address(this));
617     }
618 
619     function setRegistry(address _registry)
620         private
621     {
622         require(_registry != address(0), "ZERO_ADDRESS");
623         bytes32 position = registryPosition;
624         assembly { sstore(position, _registry) }
625     }
626 }
627 
628 
629 
630 
631 /// @title AutoUpgradabilityProxy
632 /// @dev This proxy is designed to support automatic upgradability.
633 /// @author Daniel Wang  - <daniel@loopring.org>
634 contract AutoUpgradabilityProxy is IExchangeProxy
635 {
636     constructor(address _registry) public IExchangeProxy(_registry) {}
637 
638     function implementation()
639         public
640         view
641         returns (address)
642     {
643         IUniversalRegistry r = IUniversalRegistry(registry());
644         (, address managerAddr) = r.getExchangeProtocol(address(this));
645         return IImplementationManager(managerAddr).defaultImpl();
646     }
647 }