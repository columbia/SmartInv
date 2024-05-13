1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 pragma abicoder v2;
4 
5 import {UpgradeBeaconProxy} from "@nomad-xyz/contracts-core/contracts/upgrade/UpgradeBeaconProxy.sol";
6 import {UpgradeBeacon} from "@nomad-xyz/contracts-core/contracts/upgrade/UpgradeBeacon.sol";
7 import {UpgradeBeaconController} from "@nomad-xyz/contracts-core/contracts/upgrade/UpgradeBeaconController.sol";
8 import {UpdaterManager} from "@nomad-xyz/contracts-core/contracts/UpdaterManager.sol";
9 import {XAppConnectionManager} from "@nomad-xyz/contracts-core/contracts/XAppConnectionManager.sol";
10 import {Home} from "@nomad-xyz/contracts-core/contracts/Home.sol";
11 import {Replica} from "@nomad-xyz/contracts-core/contracts/Replica.sol";
12 import {GovernanceRouter} from "@nomad-xyz/contracts-core/contracts/governance/GovernanceRouter.sol";
13 import {BridgeRouter} from "@nomad-xyz/contracts-bridge/contracts/BridgeRouter.sol";
14 import {TokenRegistry} from "@nomad-xyz/contracts-bridge/contracts/TokenRegistry.sol";
15 import {ETHHelper} from "@nomad-xyz/contracts-bridge/contracts/ETHHelper.sol";
16 import {AllowListNFTRecoveryAccountant} from "@nomad-xyz/contracts-bridge/contracts/accountants/NFTAccountant.sol";
17 import {INomadProtocol} from "./test/utils/INomadProtocol.sol";
18 
19 import "forge-std/Vm.sol";
20 import "forge-std/Test.sol";
21 
22 abstract contract Config is INomadProtocol {
23     Vm private constant vm =
24         Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
25 
26     string internal inputPath;
27     string internal outputPath;
28     string internal config;
29 
30     modifier onlyInitialized() {
31         require(isInitialized(), "not initialized");
32         _;
33     }
34 
35     function __Config_initialize(string memory _fileName) internal {
36         require(!isInitialized(), "already init");
37         inputPath = string(abi.encodePacked("./actions/", _fileName));
38         _readConfig(inputPath);
39         // copy input config to output path
40         // NOTE: will overwrite any existing contents of output file
41         outputPath = string(abi.encodePacked("./actions/output-", _fileName));
42         vm.writeFile(outputPath, config);
43     }
44 
45     function reloadConfig() internal {
46         _readConfig(outputPath);
47     }
48 
49     function _readConfig(string memory _path) private {
50         config = vm.readFile(_path);
51         require(
52             bytes(config).length != 0,
53             string(abi.encodePacked("empty config ", _path))
54         );
55     }
56 
57     function isInitialized() public view returns (bool) {
58         return bytes(config).length != 0;
59     }
60 
61     function domainError(string memory message, string memory domain)
62         private
63         pure
64         returns (string memory)
65     {
66         return string(abi.encodePacked(message, domain));
67     }
68 
69     function corePath(string memory domain)
70         private
71         pure
72         returns (string memory)
73     {
74         return string(abi.encodePacked(".core.", domain));
75     }
76 
77     function coreAttributePath(string memory domain, string memory key)
78         internal
79         pure
80         returns (string memory)
81     {
82         return string(abi.encodePacked(corePath(domain), ".", key));
83     }
84 
85     function loadCoreAttribute(string memory domain, string memory key)
86         private
87         view
88         returns (bytes memory)
89     {
90         return vm.parseJson(config, coreAttributePath(domain, key));
91     }
92 
93     function getCoreDeployHeight(string memory domain)
94         public
95         view
96         onlyInitialized
97         returns (uint256)
98     {
99         return abi.decode(loadCoreAttribute(domain, "deployHeight"), (uint256));
100     }
101 
102     function governanceRouterUpgrade(string memory domain)
103         public
104         view
105         override
106         onlyInitialized
107         returns (Upgrade memory)
108     {
109         return
110             abi.decode(
111                 loadCoreAttribute(domain, "governanceRouter"),
112                 (Upgrade)
113             );
114     }
115 
116     function getGovernanceRouter(string memory domain)
117         public
118         view
119         override
120         onlyInitialized
121         returns (GovernanceRouter)
122     {
123         return GovernanceRouter(address(governanceRouterUpgrade(domain).proxy));
124     }
125 
126     function homeUpgrade(string memory domain)
127         public
128         view
129         override
130         onlyInitialized
131         returns (Upgrade memory)
132     {
133         return abi.decode(loadCoreAttribute(domain, "home"), (Upgrade));
134     }
135 
136     function getHome(string memory domain)
137         public
138         view
139         override
140         onlyInitialized
141         returns (Home)
142     {
143         return Home(address(homeUpgrade(domain).proxy));
144     }
145 
146     function getHomeImpl(string memory domain)
147         public
148         view
149         onlyInitialized
150         returns (Home)
151     {
152         return Home(address(homeUpgrade(domain).implementation));
153     }
154 
155     function getUpdaterManager(string memory domain)
156         public
157         view
158         override
159         onlyInitialized
160         returns (UpdaterManager)
161     {
162         return
163             abi.decode(
164                 loadCoreAttribute(domain, "updaterManager"),
165                 (UpdaterManager)
166             );
167     }
168 
169     function getUpgradeBeaconController(string memory domain)
170         public
171         view
172         override
173         returns (UpgradeBeaconController)
174     {
175         return
176             abi.decode(
177                 loadCoreAttribute(domain, "upgradeBeaconController"),
178                 (UpgradeBeaconController)
179             );
180     }
181 
182     function getXAppConnectionManager(string memory domain)
183         public
184         view
185         override
186         returns (XAppConnectionManager)
187     {
188         return
189             abi.decode(
190                 loadCoreAttribute(domain, "xAppConnectionManager"),
191                 (XAppConnectionManager)
192             );
193     }
194 
195     function replicaOfPath(string memory local, string memory remote)
196         internal
197         pure
198         returns (string memory)
199     {
200         return string(abi.encodePacked(corePath(local), ".replicas.", remote));
201     }
202 
203     function replicaOfUpgrade(string memory local, string memory remote)
204         public
205         view
206         override
207         returns (Upgrade memory)
208     {
209         return
210             abi.decode(
211                 vm.parseJson(config, replicaOfPath(local, remote)),
212                 (Upgrade)
213             );
214     }
215 
216     function getReplicaOf(string memory local, string memory remote)
217         public
218         view
219         override
220         returns (Replica)
221     {
222         return Replica(address(replicaOfUpgrade(local, remote).proxy));
223     }
224 
225     function getNetworks() public view override returns (string[] memory) {
226         return abi.decode(vm.parseJson(config, ".networks"), (string[]));
227     }
228 
229     function getRpcs(string memory domain)
230         public
231         view
232         returns (string[] memory)
233     {
234         string memory key = string(abi.encodePacked(".rpcs.", domain));
235         return abi.decode(vm.parseJson(config, key), (string[]));
236     }
237 
238     function getGovernor() public view override returns (address) {
239         return
240             abi.decode(
241                 vm.parseJson(config, ".protocol.governor.id"),
242                 (address)
243             );
244     }
245 
246     function getGovernorDomain() public view override returns (uint32) {
247         return
248             abi.decode(
249                 vm.parseJson(config, ".protocol.governor.domain"),
250                 (uint32)
251             );
252     }
253 
254     function bridgePath(string memory domain)
255         private
256         pure
257         returns (string memory)
258     {
259         return string(abi.encodePacked(".bridge.", domain));
260     }
261 
262     function bridgeAttributePath(string memory domain, string memory key)
263         internal
264         pure
265         returns (string memory)
266     {
267         return string(abi.encodePacked(bridgePath(domain), ".", key));
268     }
269 
270     function loadBridgeAttribute(string memory domain, string memory key)
271         private
272         view
273         returns (bytes memory)
274     {
275         return vm.parseJson(config, bridgeAttributePath(domain, key));
276     }
277 
278     function getBridgeDeployHeight(string memory domain)
279         public
280         view
281         onlyInitialized
282         returns (uint256)
283     {
284         return
285             abi.decode(loadBridgeAttribute(domain, "deployHeight"), (uint256));
286     }
287 
288     function bridgeRouterUpgrade(string memory domain)
289         public
290         view
291         override
292         onlyInitialized
293         returns (Upgrade memory)
294     {
295         return
296             abi.decode(loadBridgeAttribute(domain, "bridgeRouter"), (Upgrade));
297     }
298 
299     function getBridgeRouter(string memory domain)
300         public
301         view
302         override
303         onlyInitialized
304         returns (BridgeRouter)
305     {
306         return BridgeRouter(address(bridgeRouterUpgrade(domain).proxy));
307     }
308 
309     function bridgeTokenUpgrade(string memory domain)
310         public
311         view
312         override
313         onlyInitialized
314         returns (Upgrade memory)
315     {
316         return
317             abi.decode(loadBridgeAttribute(domain, "bridgeToken"), (Upgrade));
318     }
319 
320     function tokenRegistryUpgrade(string memory domain)
321         public
322         view
323         override
324         onlyInitialized
325         returns (Upgrade memory)
326     {
327         return
328             abi.decode(loadBridgeAttribute(domain, "tokenRegistry"), (Upgrade));
329     }
330 
331     function getTokenRegistry(string memory domain)
332         public
333         view
334         override
335         onlyInitialized
336         returns (TokenRegistry)
337     {
338         return TokenRegistry(address(tokenRegistryUpgrade(domain).proxy));
339     }
340 
341     function accountantUpgrade(string memory domain)
342         public
343         view
344         override
345         onlyInitialized
346         returns (Upgrade memory _acctUpgrade)
347     {
348         bytes memory raw = loadBridgeAttribute(domain, "accountant");
349         // if accountant exists, decode & return
350         if (raw.length != 0) {
351             _acctUpgrade = abi.decode(raw, (Upgrade));
352         }
353         // if accountant doesn't exist, an empty upgrade setup will be returned
354         // user can check if setup == address(0) to check if accountant is present
355     }
356 
357     function getAccountant(string memory domain)
358         public
359         view
360         override
361         onlyInitialized
362         returns (AllowListNFTRecoveryAccountant)
363     {
364         return
365             AllowListNFTRecoveryAccountant(
366                 address(accountantUpgrade(domain).proxy)
367             );
368     }
369 
370     function getEthHelper(string memory domain)
371         public
372         view
373         override
374         returns (ETHHelper)
375     {
376         bytes memory raw = loadCoreAttribute(domain, "ethHelper");
377         require(raw.length != 0, domainError("no ethHelper for ", domain));
378         return abi.decode(raw, (ETHHelper));
379     }
380 
381     function protocolPath(string memory domain)
382         private
383         pure
384         returns (string memory)
385     {
386         return string(abi.encodePacked(".protocol.networks.", domain));
387     }
388 
389     function protocolConfigPath(string memory domain)
390         private
391         pure
392         returns (string memory)
393     {
394         return string(abi.encodePacked(protocolPath(domain), ".configuration"));
395     }
396 
397     function bridgeConfigPath(string memory domain)
398         private
399         pure
400         returns (string memory)
401     {
402         return
403             string(
404                 abi.encodePacked(protocolPath(domain), ".bridgeConfiguration")
405             );
406     }
407 
408     function protocolAttributePath(string memory domain, string memory key)
409         internal
410         pure
411         returns (string memory)
412     {
413         return string(abi.encodePacked(protocolPath(domain), ".", key));
414     }
415 
416     function loadProtocolAttribute(string memory domain, string memory key)
417         internal
418         view
419         returns (bytes memory)
420     {
421         return vm.parseJson(config, protocolAttributePath(domain, key));
422     }
423 
424     function protocolConfigAttributePath(
425         string memory domain,
426         string memory key
427     ) internal pure returns (string memory) {
428         return string(abi.encodePacked(protocolConfigPath(domain), ".", key));
429     }
430 
431     function loadProtocolConfigAttribute(
432         string memory domain,
433         string memory key
434     ) internal view returns (bytes memory) {
435         return vm.parseJson(config, protocolConfigAttributePath(domain, key));
436     }
437 
438     function accountantConfigAttributePath(
439         string memory domain,
440         string memory key
441     ) private pure returns (string memory) {
442         return
443             string(
444                 abi.encodePacked(bridgeConfigPath(domain), ".accountant.", key)
445             );
446     }
447 
448     function loadAccountantConfigAttribute(
449         string memory domain,
450         string memory key
451     ) private view returns (bytes memory) {
452         return vm.parseJson(config, accountantConfigAttributePath(domain, key));
453     }
454 
455     function getConnections(string memory domain)
456         public
457         view
458         override
459         onlyInitialized
460         returns (string[] memory)
461     {
462         return
463             abi.decode(
464                 loadProtocolAttribute(domain, "connections"),
465                 (string[])
466             );
467     }
468 
469     function getDomainName(uint32 _domainNumber)
470         public
471         view
472         returns (string memory)
473     {
474         string[] memory networks = getNetworks();
475         for (uint256 i; i < networks.length; i++) {
476             if (getDomainNumber(networks[i]) == _domainNumber) {
477                 return networks[i];
478             }
479         }
480         revert("domain name not found");
481     }
482 
483     function getDomainNumber(string memory domain)
484         public
485         view
486         onlyInitialized
487         returns (uint32)
488     {
489         return abi.decode(loadProtocolAttribute(domain, "domain"), (uint32));
490     }
491 
492     function getUpdater(string memory domain)
493         public
494         view
495         override
496         onlyInitialized
497         returns (address)
498     {
499         return
500             abi.decode(
501                 loadProtocolConfigAttribute(domain, "updater"),
502                 (address)
503             );
504     }
505 
506     function getRecoveryManager(string memory domain)
507         public
508         view
509         override
510         onlyInitialized
511         returns (address)
512     {
513         return
514             abi.decode(
515                 loadProtocolConfigAttribute(
516                     domain,
517                     "governance.recoveryManager"
518                 ),
519                 (address)
520             );
521     }
522 
523     function getWatchers(string memory domain)
524         public
525         view
526         override
527         onlyInitialized
528         returns (address[] memory)
529     {
530         return
531             abi.decode(
532                 loadProtocolConfigAttribute(domain, "watchers"),
533                 (address[])
534             );
535     }
536 
537     function getRecoveryTimelock(string memory domain)
538         public
539         view
540         override
541         onlyInitialized
542         returns (uint256)
543     {
544         return
545             abi.decode(
546                 loadProtocolConfigAttribute(
547                     domain,
548                     "governance.recoveryTimelock"
549                 ),
550                 (uint256)
551             );
552     }
553 
554     function getOptimisticSeconds(string memory domain)
555         public
556         view
557         override
558         onlyInitialized
559         returns (uint256)
560     {
561         return
562             abi.decode(
563                 loadProtocolConfigAttribute(domain, "optimisticSeconds"),
564                 (uint256)
565             );
566     }
567 
568     function getFundsRecipient(string memory domain)
569         public
570         view
571         override
572         onlyInitialized
573         returns (address)
574     {
575         return
576             abi.decode(
577                 loadAccountantConfigAttribute(domain, "fundsRecipient"),
578                 (address)
579             );
580     }
581 
582     function getAccountantOwner(string memory domain)
583         public
584         view
585         override
586         onlyInitialized
587         returns (address)
588     {
589         return
590             abi.decode(
591                 loadAccountantConfigAttribute(domain, "owner"),
592                 (address)
593             );
594     }
595 }
596 
597 contract TestJson is Test, Config {
598     function setUp() public {
599         // solhint-disable-next-line quotes
600         config = '{ "networks": ["avalanche", "ethereum"], "protocol": { "networks": { "avalanche": { "bridgeConfiguration": { "accountant": { "owner": "0x0000011111222223333344444555557777799999" }}, "configuration": { "updater": "0x5067c8a9cBf708f885195aA318F8d7A3f2f5D112"}, "domain": 1635148152}}, "governor": {"domain": 6648936, "id": "0x93277b8f5939975b9e6694d5fd2837143afbf68a"}}, "core": {"ethereum": {"deployHeight": 1234, "governanceRouter": {"proxy":"0x569D80f7FC17316B4C83f072b92EF37B72819DE0","implementation":"0x569D80f7FC17316B4C83f072b92EF37B72819DE0","beacon":"0x569D80f7FC17316B4C83f072b92EF37B72819DE0"}, "ethHelper": "0x999d80F7FC17316b4c83f072b92EF37b72718De0"}}}';
601     }
602 
603     function test_Json() public {
604         assertEq(
605             address(getEthHelper("ethereum")),
606             0x999d80F7FC17316b4c83f072b92EF37b72718De0
607         );
608         vm.expectRevert("no ethHelper for randomDomain");
609         getEthHelper("randomDomain");
610         assertEq(
611             getUpdater("avalanche"),
612             0x5067c8a9cBf708f885195aA318F8d7A3f2f5D112
613         );
614         assertEq(getDomainName(1635148152), "avalanche");
615         assertEq(getNetworks()[0], "avalanche");
616         assertEq(
617             getFundsRecipient("avalanche"),
618             0x0000011111222223333344444555557777799999
619         );
620         assertEq(getGovernor(), 0x93277b8f5939975b9E6694d5Fd2837143afBf68A);
621         assertEq(getCoreDeployHeight("ethereum"), 1234);
622         assertEq(
623             address(getGovernanceRouter("ethereum")),
624             0x569D80f7FC17316B4C83f072b92EF37B72819DE0
625         );
626     }
627 }
