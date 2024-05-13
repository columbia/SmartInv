1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 import "forge-std/console2.sol";
5 // Local imports
6 import {BridgeTestFixture} from "./utils/BridgeTest.sol";
7 import {BridgeMessage} from "../BridgeMessage.sol";
8 import {BridgeToken} from "../BridgeToken.sol";
9 import {Encoding} from "../Encoding.sol";
10 
11 // External imports
12 import {TypeCasts} from "@nomad-xyz/contracts-core/contracts/XAppConnectionManager.sol";
13 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
14 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
15 
16 contract TokenRegistryTest is BridgeTestFixture {
17     using TypedMemView for bytes;
18     using TypedMemView for bytes29;
19     using BridgeMessage for bytes29;
20 
21     function test_getCanonicalTokenId() public {
22         (uint32 domain, bytes32 id) = tokenRegistry.getCanonicalTokenId(
23             remoteTokenLocalAddress
24         );
25         assertEq(uint256(domain), remoteDomain);
26         assertEq(id, remoteTokenRemoteAddress);
27     }
28 
29     function test_getCanonicalTokenIdNotTokenAddressReturnsZeroFuzzed(
30         address noToken
31     ) public {
32         vm.assume(noToken != remoteTokenLocalAddress);
33         (uint32 domain, bytes32 id) = tokenRegistry.getCanonicalTokenId(
34             noToken
35         );
36         assertEq(uint256(domain), 0);
37         assertEq(id, bytes32(0));
38     }
39 
40     function test_getCanonicalTokenIdFuzzed(
41         uint32 fuzzedDomain,
42         bytes32 fuzzedId
43     ) public {
44         vm.assume(fuzzedDomain != 0 && fuzzedId != bytes32(0));
45         address localAddress = createRemoteToken(fuzzedDomain, fuzzedId);
46         (uint32 domain, bytes32 id) = tokenRegistry.getCanonicalTokenId(
47             localAddress
48         );
49         assertEq(uint256(domain), fuzzedDomain);
50         assertEq(id, fuzzedId);
51     }
52 
53     function test_getRepresentationAddress() public {
54         address repr = tokenRegistry.getRepresentationAddress(
55             remoteDomain,
56             remoteTokenRemoteAddress
57         );
58         assertEq(repr, remoteTokenLocalAddress);
59     }
60 
61     function test_getRepresentationAddressWrongDetailsReturnZeroFuzzed(
62         uint32 domain,
63         bytes32 randomAddress
64     ) public {
65         vm.assume(
66             randomAddress != remoteTokenRemoteAddress || domain != remoteDomain
67         );
68         address repr = tokenRegistry.getRepresentationAddress(
69             domain,
70             randomAddress
71         );
72         assertEq(repr, address(0));
73     }
74 
75     function test_getRepresentationAddressFuzzed(
76         uint32 fuzzedDomain,
77         bytes32 fuzzedId
78     ) public {
79         vm.assume(fuzzedDomain != 0 && fuzzedId != bytes32(0));
80         address localAddress = createRemoteToken(fuzzedDomain, fuzzedId);
81         address repr = tokenRegistry.getRepresentationAddress(
82             fuzzedDomain,
83             fuzzedId
84         );
85         assertEq(repr, localAddress);
86     }
87 
88     event TokenDeployed(
89         uint32 indexed domain,
90         bytes32 indexed id,
91         address indexed representation
92     );
93 
94     function test_ensureLocalTokenDeploy() public {
95         uint32 newDomain = 13;
96         bytes32 newId = bytes32("hey yoou");
97         // It's the second contract that is been deployed by tokenRegistry
98         // It deploys a bridgeToken during setUp() of BridgeTest
99         address calculated = expectTokenDeployedEmission(newDomain, newId);
100         vm.prank(tokenRegistry.owner());
101         address deployed = tokenRegistry.ensureLocalToken(newDomain, newId);
102         assertEq(deployed, calculated);
103     }
104 
105     function test_ensureLocalTokenExisting() public {
106         vm.prank(tokenRegistry.owner());
107         address addr = tokenRegistry.ensureLocalToken(
108             remoteDomain,
109             remoteTokenRemoteAddress
110         );
111         assertEq(addr, remoteTokenLocalAddress);
112     }
113 
114     function test_ensureLocalTokenOnlyOwner() public {
115         // It's the second contract that is been deployed by tokenRegistry
116         // It deploys a bridgeToken during setUp() of BridgeTest
117         vm.expectRevert("Ownable: caller is not the owner");
118         tokenRegistry.ensureLocalToken(remoteDomain, remoteTokenRemoteAddress);
119     }
120 
121     function test_ensureLocalTokenDeployFuzzed(uint32 domain, bytes32 id)
122         public
123     {
124         vm.assume(domain != 0 && TypeCasts.bytes32ToAddress(id) != address(0));
125         vm.startPrank(tokenRegistry.owner());
126         if (domain == homeDomain) {
127             assertEq(
128                 tokenRegistry.ensureLocalToken(domain, id),
129                 TypeCasts.bytes32ToAddress(id)
130             );
131             return;
132         }
133         address calculated = expectTokenDeployedEmission(domain, id);
134         address deployed = tokenRegistry.ensureLocalToken(domain, id);
135         assertEq(deployed, calculated);
136         vm.stopPrank();
137     }
138 
139     function test_ensureLocalTokenOnlyOwnerFuzzed(address user) public {
140         // It's the second contract that is been deployed by tokenRegistry
141         // It deploys a bridgeToken during setUp() of BridgeTest
142         vm.assume(user != tokenRegistry.owner());
143         vm.expectRevert("Ownable: caller is not the owner");
144         vm.prank(user);
145         tokenRegistry.ensureLocalToken(remoteDomain, remoteTokenRemoteAddress);
146     }
147 
148     function test_enrollCustom() public {
149         uint32 newDomain = 24;
150         bytes32 newId = "yaw";
151         address customAddress = address(0xBEEF);
152         vm.startPrank(tokenRegistry.owner());
153         tokenRegistry.enrollCustom(newDomain, newId, customAddress);
154         (uint32 storedDomain, bytes32 storedId) = tokenRegistry
155             .getCanonicalTokenId(customAddress);
156         address storedAddress = tokenRegistry.getRepresentationAddress(
157             newDomain,
158             newId
159         );
160         assertEq(uint256(storedDomain), uint256(newDomain));
161         assertEq(storedId, newId);
162         assertEq(storedAddress, customAddress);
163         assertEq(
164             tokenRegistry.ensureLocalToken(newDomain, newId),
165             customAddress
166         );
167         vm.stopPrank();
168     }
169 
170     function test_enrollCustomOnlyOwner() public {
171         uint32 newDomain = 24;
172         bytes32 newId = "yaw";
173         address customAddress = address(0xBEEF);
174         vm.expectRevert("Ownable: caller is not the owner");
175         tokenRegistry.enrollCustom(newDomain, newId, customAddress);
176     }
177 
178     function test_enrollCustomFuzzed(
179         uint32 dom,
180         bytes32 id,
181         address addr
182     ) public {
183         vm.assume(dom != 0 && id != bytes32(0) && addr != address(0));
184         vm.prank(tokenRegistry.owner());
185         tokenRegistry.enrollCustom(dom, id, addr);
186         (uint32 storedDomain, bytes32 storedId) = tokenRegistry
187             .getCanonicalTokenId(addr);
188         address storedAddress = tokenRegistry.getRepresentationAddress(dom, id);
189         assertEq(uint256(storedDomain), uint256(dom));
190         assertEq(storedId, id);
191         assertEq(storedAddress, addr);
192     }
193 
194     function test_oldReprToCurrentRepr() public {
195         uint32 domain = 24;
196         bytes32 id = "yaw";
197         address oldAddress = address(0xBEEF);
198         vm.prank(tokenRegistry.owner());
199         // Enroll first local custom token of a remote asset
200         tokenRegistry.enrollCustom(domain, id, oldAddress);
201         address newAddress = address(0xBEEFBEEF);
202         vm.prank(tokenRegistry.owner());
203         // After some time, the owner wants to enroll a  new implementation of the local custom token
204         // for the same remote asset
205         tokenRegistry.enrollCustom(domain, id, newAddress);
206         // We make sure that a user can retrieve the new implementation of the remote asset, using the old
207         // implementation as a key
208         assertEq(tokenRegistry.oldReprToCurrentRepr(oldAddress), newAddress);
209     }
210 
211     function test_oldReprToCurrentReprFuzzed(
212         address oldAddress,
213         address newAddress,
214         uint32 domain,
215         bytes32 id
216     ) public {
217         vm.assume(
218             domain != 0 &&
219                 id != bytes32(0) &&
220                 oldAddress != address(0) &&
221                 newAddress != address(0)
222         );
223         vm.prank(tokenRegistry.owner());
224         tokenRegistry.enrollCustom(domain, id, oldAddress);
225         vm.prank(tokenRegistry.owner());
226         tokenRegistry.enrollCustom(domain, id, newAddress);
227         assertEq(tokenRegistry.oldReprToCurrentRepr(oldAddress), newAddress);
228     }
229 
230     function test_getTokenIdCanonical() public {
231         (uint32 domain, bytes32 id) = tokenRegistry.getTokenId(
232             address(localToken)
233         );
234         assertEq(uint256(domain), homeDomain);
235         assertEq(id, TypeCasts.addressToBytes32(address(localToken)));
236     }
237 
238     function test_getTokenIdRepr() public {
239         (uint32 domain, bytes32 id) = tokenRegistry.getTokenId(
240             address(remoteTokenLocalAddress)
241         );
242         assertEq(uint256(domain), remoteDomain);
243         assertEq(id, remoteTokenRemoteAddress);
244     }
245 
246     function test_getTokenIdRerprFuzzed(uint32 dom, bytes32 id) public {
247         // Domain can be 0?
248         vm.assume(dom != homeDomain && dom != 0);
249         vm.assume(id != remoteTokenRemoteAddress && id != bytes32(0));
250         address loc = createRemoteToken(dom, id);
251         (uint32 storedDomain, bytes32 storedId) = tokenRegistry.getTokenId(loc);
252         assertEq(uint256(storedDomain), dom);
253         assertEq(storedId, id);
254     }
255 
256     function test_getLocalAddressLocalAsset() public {
257         assertEq(
258             tokenRegistry.getLocalAddress(homeDomain, address(localToken)),
259             address(localToken)
260         );
261     }
262 
263     function test_getLocalAddressRemoteAssetRegistered() public {
264         assertEq(
265             tokenRegistry.getLocalAddress(
266                 remoteDomain,
267                 remoteTokenRemoteAddress
268             ),
269             remoteTokenLocalAddress
270         );
271     }
272 
273     function test_getLocalAddressRemoteAssetRegisteredFuzzed(
274         uint32 newRemoteDomain,
275         bytes32 newRemoteToken
276     ) public {
277         vm.assume(newRemoteDomain != homeDomain && newRemoteDomain != 0);
278         address local = createRemoteToken(newRemoteDomain, newRemoteToken);
279         assertEq(
280             tokenRegistry.getLocalAddress(newRemoteDomain, newRemoteToken),
281             local
282         );
283     }
284 
285     function test_getLocalAddressRemoteAssetUnregistered() public {
286         uint32 newRemoteDomain = 123;
287         bytes32 newRemoteToken = "lol no";
288         assertEq(
289             tokenRegistry.getLocalAddress(newRemoteDomain, newRemoteToken),
290             address(0)
291         );
292     }
293 
294     function test_getLocalAddressRemoteAssetUnregisteredFuzzed(
295         uint32 newRemoteDomain,
296         bytes32 newRemoteToken
297     ) public {
298         // we don't want to test against a known REGISTERED remote domain
299         vm.assume(newRemoteDomain != homeDomain && newRemoteDomain != 0);
300         assertEq(
301             tokenRegistry.getLocalAddress(newRemoteDomain, newRemoteToken),
302             address(0)
303         );
304     }
305 
306     function test_getLocalAddressRemoteAssetRegisteredFail() public {
307         // It will search for a remote token for domain `remoteDomain` and id `remoteTokenLocalAddress`
308         // The correct id of the existing token is `remoteTokenRemoteAddress`
309         assertEq(
310             tokenRegistry.getLocalAddress(
311                 remoteDomain,
312                 remoteTokenLocalAddress
313             ),
314             address(0)
315         );
316     }
317 
318     function test_mustHaveLocalTokenRemoteToken() public view {
319         require(
320             tokenRegistry.mustHaveLocalToken(
321                 remoteDomain,
322                 remoteTokenRemoteAddress
323             ) == IERC20(remoteTokenLocalAddress)
324         );
325     }
326 
327     function test_mustHaveLocalTokenRemoteTokenFuzzed(
328         uint32 newRemoteDomain,
329         bytes32 newRemoteToken
330     ) public {
331         vm.assume(
332             newRemoteDomain != remoteDomain &&
333                 newRemoteDomain != homeDomain &&
334                 newRemoteDomain != 0 &&
335                 newRemoteToken != bytes32(0)
336         );
337         address local = createRemoteToken(newRemoteDomain, newRemoteToken);
338         require(
339             tokenRegistry.mustHaveLocalToken(newRemoteDomain, newRemoteToken) ==
340                 IERC20(local)
341         );
342     }
343 
344     function test_mustHaveLocalTokenRemoteAssetUnregistered() public {
345         uint32 newRemoteDomain = 123;
346         bytes32 newRemoteToken = "lol no";
347         vm.expectRevert("!token");
348         tokenRegistry.mustHaveLocalToken(newRemoteDomain, newRemoteToken);
349     }
350 
351     function test_mustHaveLocalTokenRemoteAssetUnregisteredFuzzed(
352         uint32 newRemoteDomain,
353         bytes32 newRemoteToken
354     ) public {
355         vm.assume(newRemoteDomain != homeDomain && newRemoteDomain != 0);
356         vm.expectRevert("!token");
357         tokenRegistry.mustHaveLocalToken(newRemoteDomain, newRemoteToken);
358     }
359 
360     function test_isLocalOriginLocaltoken() public view {
361         assert(tokenRegistry.isLocalOrigin(address(localToken)));
362     }
363 
364     function test_isLocalOriginRemoteToken() public {
365         assertFalse(tokenRegistry.isLocalOrigin(remoteTokenLocalAddress));
366     }
367 
368     function test_isLocalOriginRemoteTokenFuzzed(
369         uint32 newRemoteDomain,
370         bytes32 newRemoteToken
371     ) public {
372         vm.assume(
373             newRemoteDomain != remoteDomain &&
374                 newRemoteDomain != homeDomain &&
375                 newRemoteDomain != 0
376         );
377         address local = createRemoteToken(newRemoteDomain, newRemoteToken);
378         assertFalse(tokenRegistry.isLocalOrigin(local));
379     }
380 
381     function test_setRepresentationToCanonical() public {
382         uint32 domain = 1;
383         bytes32 id = "id";
384         address repr = address(0xBEEF);
385         (uint32 storedDomain, bytes32 storedId) = tokenRegistry
386             .representationToCanonical(repr);
387         assertEq(uint256(storedDomain), 0);
388         assertEq(storedId, bytes32(0));
389         tokenRegistry.exposed_setRepresentationToCanonical(domain, id, repr);
390         (storedDomain, storedId) = tokenRegistry.representationToCanonical(
391             repr
392         );
393         assertEq(uint256(storedDomain), domain);
394         assertEq(storedId, id);
395     }
396 
397     function test_setRepresentationToCanonicalFuzzed(
398         uint32 domain,
399         bytes32 id,
400         address repr
401     ) public {
402         vm.assume(domain != homeDomain && domain != 0);
403         vm.assume(
404             repr != address(localToken) && repr != remoteTokenLocalAddress
405         );
406         (uint32 storedDomain, bytes32 storedId) = tokenRegistry
407             .representationToCanonical(repr);
408         assertEq(uint256(storedDomain), 0);
409         assertEq(storedId, bytes32(0));
410         tokenRegistry.exposed_setRepresentationToCanonical(domain, id, repr);
411         (storedDomain, storedId) = tokenRegistry.representationToCanonical(
412             repr
413         );
414         assertEq(uint256(storedDomain), domain);
415         assertEq(storedId, id);
416     }
417 
418     function test_setCanonicalToRepresentation() public {
419         uint32 domain = 1;
420         bytes32 id = "id";
421         address repr = address(0xBEEF);
422         bytes29 tokenId = BridgeMessage.formatTokenId(domain, id);
423         bytes32 tokenIdHash = tokenId.keccak();
424         address storedRepr = tokenRegistry.canonicalToRepresentation(
425             tokenIdHash
426         );
427         assertEq(storedRepr, address(0));
428         tokenRegistry.exposed_setCanonicalToRepresentation(domain, id, repr);
429         storedRepr = tokenRegistry.canonicalToRepresentation(tokenIdHash);
430         assertEq(storedRepr, repr);
431     }
432 
433     function test_setCanonicalToRepresentationFuzzed(
434         uint32 domain,
435         bytes32 id,
436         address repr
437     ) public {
438         vm.assume(domain != homeDomain && domain != 0 && repr != address(0));
439         vm.assume(
440             repr != address(localToken) && repr != remoteTokenLocalAddress
441         );
442         bytes29 tokenId = BridgeMessage.formatTokenId(domain, id);
443         bytes32 tokenIdHash = tokenId.keccak();
444         address storedRepr = tokenRegistry.canonicalToRepresentation(
445             tokenIdHash
446         );
447         assertEq(storedRepr, address(0));
448         tokenRegistry.exposed_setCanonicalToRepresentation(domain, id, repr);
449         storedRepr = tokenRegistry.canonicalToRepresentation(tokenIdHash);
450         assertEq(storedRepr, repr);
451     }
452 
453     function test_exposedDeployToken() public {
454         uint32 domain = 99999;
455         bytes32 id = "It's over 9000";
456         address repr = tokenRegistry.getRepresentationAddress(domain, id);
457         assertEq(repr, address(0));
458         expectTokenDeployedEmission(domain, id);
459         address tokenAddress = tokenRegistry.exposed_deployToken(domain, id);
460         BridgeToken token = BridgeToken(tokenAddress);
461         repr = tokenRegistry.getRepresentationAddress(domain, id);
462         (uint32 storedDomain, bytes32 storedId) = tokenRegistry
463             .getCanonicalTokenId(tokenAddress);
464         // test mappings
465         assertEq(repr, tokenAddress);
466         assertEq(uint256(storedDomain), domain);
467         assertEq(storedId, id);
468         // test is initialized
469         assertEq(token.owner(), address(bridgeRouter));
470         (string memory name, string memory symbol) = tokenRegistry
471             .exposed_defaultDetails(domain, id);
472         // test if default name and symbol is set
473         assertEq(token.name(), name);
474         assertEq(token.symbol(), symbol);
475     }
476 
477     function test_deployTokenFuzzed(uint32 domain, bytes32 id) public {
478         vm.assume(domain != homeDomain && domain != 0);
479         address repr = tokenRegistry.getRepresentationAddress(domain, id);
480         assertEq(repr, address(0));
481         expectTokenDeployedEmission(domain, id);
482         address tokenAddress = tokenRegistry.exposed_deployToken(domain, id);
483         BridgeToken token = BridgeToken(tokenAddress);
484         repr = tokenRegistry.getRepresentationAddress(domain, id);
485         (uint32 storedDomain, bytes32 storedId) = tokenRegistry
486             .getCanonicalTokenId(tokenAddress);
487         // test mappings
488         assertEq(repr, tokenAddress);
489         assertEq(uint256(storedDomain), domain);
490         assertEq(storedId, id);
491         // test is initialized
492         assertEq(token.owner(), address(bridgeRouter));
493         // test if default name and symbol is set
494         (string memory name, string memory symbol) = tokenRegistry
495             .exposed_defaultDetails(domain, id);
496         assertEq(token.name(), name);
497         assertEq(token.symbol(), symbol);
498     }
499 
500     function test_defaultDetails() public {
501         uint32 domain = 1;
502         bytes32 id = "test";
503         (, uint256 secondHalfId) = Encoding.encodeHex(uint256(id));
504         string memory name = string(
505             abi.encodePacked(
506                 Encoding.decimalUint32(domain), // 10
507                 ".", // 1
508                 uint32(secondHalfId) // 4
509             )
510         );
511         string memory symbol = new string(10 + 1 + 4);
512         assembly {
513             mstore(add(symbol, 0x20), mload(add(name, 0x20)))
514         }
515         (string memory storedName, string memory storedSymbol) = tokenRegistry
516             .exposed_defaultDetails(domain, id);
517         assertEq(storedName, name);
518         assertEq(storedSymbol, symbol);
519     }
520 
521     function test_defaultDetailsFuzzed(uint32 domain, bytes32 id) public {
522         vm.assume(domain != homeDomain && domain != 0);
523         (, uint256 secondHalfId) = Encoding.encodeHex(uint256(id));
524         string memory name = string(
525             abi.encodePacked(
526                 Encoding.decimalUint32(domain), // 10
527                 ".", // 1
528                 uint32(secondHalfId) // 4
529             )
530         );
531         string memory symbol = new string(10 + 1 + 4);
532         assembly {
533             mstore(add(symbol, 0x20), mload(add(name, 0x20)))
534         }
535         (string memory storedName, string memory storedSymbol) = tokenRegistry
536             .exposed_defaultDetails(domain, id);
537         assertEq(storedName, name);
538         assertEq(storedSymbol, symbol);
539     }
540 
541     function test_localDomain() public {
542         assertEq(tokenRegistry.exposed_localDomain(), uint256(homeDomain));
543     }
544 
545     // Test that renounceOwnership is a noop
546     function test_renounceOwnership() public {
547         address ownerBefore = tokenRegistry.owner();
548         vm.prank(ownerBefore);
549         tokenRegistry.renounceOwnership();
550         assertEq(tokenRegistry.owner(), ownerBefore);
551     }
552 
553     function expectTokenDeployedEmission(uint32 _domain, bytes32 _id)
554         internal
555         returns (address _calculated)
556     {
557         _calculated = computeCreateAddress(
558             address(tokenRegistry),
559             vm.getNonce(address(tokenRegistry))
560         );
561         // test event emmission
562         vm.expectEmit(true, true, true, false);
563         emit TokenDeployed(_domain, _id, _calculated);
564     }
565 }
