1 pragma solidity ^0.4.19;
2 
3 /**
4  * XC Contract Interface.
5  */
6 interface XCInterface {
7 
8     /**
9      * Set contract service status.
10      * @param status contract service status (0:closed;1:only-closed-lock;2:only-closed-unlock;3:opened;).
11      */
12     function setStatus(uint8 status) external;
13 
14     /**
15      * Get contract service status.
16      * @return contract service status.
17      */
18     function getStatus() external view returns (uint8);
19 
20     /**
21      * Get the current contract platform name.
22      * @return contract platform name.
23      */
24     function getPlatformName() external view returns (bytes32);
25 
26     /**
27      * Set the current contract administrator.
28      * @param account account of contract administrator.
29      */
30     function setAdmin(address account) external;
31 
32     /**
33      * Get the current contract administrator.
34      * @return contract administrator.
35      */
36     function getAdmin() external view returns (address);
37 
38     /**
39      * Set the Token contract address.
40      * @param account contract address.
41      */
42     function setToken(address account) external;
43 
44     /**
45      * Get the Token contract address.
46      * @return contract address.
47      */
48     function getToken() external view returns (address);
49 
50     /**
51      * Set the XCPlugin contract address.
52      * @param account contract address.
53      */
54     function setXCPlugin(address account) external;
55 
56     /**
57      * Get the XCPlugin contract address.
58      * @return contract address.
59      */
60     function getXCPlugin() external view returns (address);
61 
62     /**
63      * Transfer out of cross chain.
64      * @param toAccount account of to platform.
65      * @param value transfer amount.
66      */
67     function lock(address toAccount, uint value) external;
68 
69     /**
70      * Transfer in of cross chain.
71      * @param txid transaction id.
72      * @param fromAccount ame of to platform.
73      * @param toAccount account of to platform.
74      * @param value transfer amount.
75      */
76     function unlock(string txid, address fromAccount, address toAccount, uint value) external;
77 
78     /**
79      * Transfer the misoperation to the amount of the contract account to the specified account.
80      * @param account the specified account.
81      * @param value transfer amount.
82      */
83     function withdraw(address account, uint value) external;
84 }
85 
86 /**
87  * XC Plugin Contract Interface.
88  */
89 interface XCPluginInterface {
90 
91     /**
92      * Open the contract service status.
93      */
94     function start() external;
95 
96     /**
97      * Close the contract service status.
98      */
99     function stop() external;
100 
101     /**
102      * Get contract service status.
103      * @return contract service status.
104      */
105     function getStatus() external view returns (bool);
106 
107     /**
108      * Get the current contract platform name.
109      * @return contract platform name.
110      */
111     function getPlatformName() external view returns (bytes32);
112 
113     /**
114      * Set the current contract administrator.
115      * @param account account of contract administrator.
116      */
117     function setAdmin(address account) external;
118 
119     /**
120      * Get the current contract administrator.
121      * @return contract administrator.
122      */
123     function getAdmin() external view returns (address);
124 
125     /**
126      * Get the current token symbol.
127      * @return token symbol.
128      */
129     function getTokenSymbol() external view returns (bytes32);
130 
131     /**
132      * Add a contract trust caller.
133      * @param caller account of caller.
134      */
135     function addCaller(address caller) external;
136 
137     /**
138      * Delete a contract trust caller.
139      * @param caller account of caller.
140      */
141     function deleteCaller(address caller) external;
142 
143     /**
144      * Whether the trust caller exists.
145      * @param caller account of caller.
146      * @return whether exists.
147      */
148     function existCaller(address caller) external view returns (bool);
149 
150     /**
151      * Get all contract trusted callers.
152      * @return al lcallers.
153      */
154     function getCallers() external view returns (address[]);
155 
156     /**
157      * Get the trusted platform name.
158      * @return name a platform name.
159      */
160     function getTrustPlatform() external view returns (bytes32 name);
161 
162     /**
163      * Add the trusted platform public key information.
164      * @param publicKey a public key.
165      */
166     function addPublicKey(address publicKey) external;
167 
168     /**
169      * Delete the trusted platform public key information.
170      * @param publicKey a public key.
171      */
172     function deletePublicKey(address publicKey) external;
173 
174     /**
175      * Whether the trusted platform public key information exists.
176      * @param publicKey a public key.
177      */
178     function existPublicKey(address publicKey) external view returns (bool);
179 
180     /**
181      * Get the count of public key for the trusted platform.
182      * @return count of public key.
183      */
184     function countOfPublicKey() external view returns (uint);
185 
186     /**
187      * Get the list of public key for the trusted platform.
188      * @return list of public key.
189      */
190     function publicKeys() external view returns (address[]);
191 
192     /**
193      * Set the weight of a trusted platform.
194      * @param weight weight of platform.
195      */
196     function setWeight(uint weight) external;
197 
198     /**
199      * Get the weight of a trusted platform.
200      * @return weight of platform.
201      */
202     function getWeight() external view returns (uint);
203 
204     /**
205      * Initiate and vote on the transaction proposal.
206      * @param fromAccount name of to platform.
207      * @param toAccount account of to platform.
208      * @param value transfer amount.
209      * @param txid transaction id.
210      * @param sig transaction signature.
211      */
212     function voteProposal(address fromAccount, address toAccount, uint value, string txid, bytes sig) external;
213 
214     /**
215      * Verify that the transaction proposal is valid.
216      * @param fromAccount name of to platform.
217      * @param toAccount account of to platform.
218      * @param value transfer amount.
219      * @param txid transaction id.
220      */
221     function verifyProposal(address fromAccount, address toAccount, uint value, string txid) external view returns (bool, bool);
222 
223     /**
224      * Commit the transaction proposal.
225      * @param txid transaction id.
226      */
227     function commitProposal(string txid) external returns (bool);
228 
229     /**
230      * Get the transaction proposal information.
231      * @param txid transaction id.
232      * @return status completion status of proposal.
233      * @return fromAccount account of to platform.
234      * @return toAccount account of to platform.
235      * @return value transfer amount.
236      * @return voters notarial voters.
237      * @return weight The weight value of the completed time.
238      */
239     function getProposal(string txid) external view returns (bool status, address fromAccount, address toAccount, uint value, address[] voters, uint weight);
240 
241     /**
242      * Delete the transaction proposal information.
243      * @param txid transaction id.
244      */
245     function deleteProposal(string txid) external;
246 }
247 
248 /**
249  * @title SafeMath
250  * @dev Math operations with safety checks that throw on error
251  */
252 library SafeMath {
253 
254     /**
255     * @dev Multiplies two numbers, throws on overflow.
256     */
257     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
258         if (a == 0) {
259             return 0;
260         }
261         c = a * b;
262         assert(c / a == b);
263         return c;
264     }
265 
266     /**
267     * @dev Integer division of two numbers, truncating the quotient.
268     */
269     function div(uint256 a, uint256 b) internal pure returns (uint256) {
270         // assert(b > 0); // Solidity automatically throws when dividing by 0
271         // uint256 c = a / b;
272         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
273         return a / b;
274     }
275 
276     /**
277     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
278     */
279     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
280         assert(b <= a);
281         return a - b;
282     }
283 
284     /**
285     * @dev Adds two numbers, throws on overflow.
286     */
287     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
288         c = a + b;
289         assert(c >= a);
290         return c;
291     }
292 }
293 
294 contract Token {
295 
296     function transfer(address to, uint value) external returns (bool);
297 
298     function transferFrom(address from, address to, uint value) external returns (bool);
299 
300     function balanceOf(address owner) external view returns (uint);
301 
302     function allowance(address owner, address spender) external view returns (uint);
303 }
304 
305 contract XCPlugin is XCPluginInterface {
306 
307     /**
308      * Contract Administrator
309      * @field status Contract external service status.
310      * @field platformName Current contract platform name.
311      * @field tokenSymbol token Symbol.
312      * @field account Current contract administrator.
313      */
314     struct Admin {
315         bool status;
316         bytes32 platformName;
317         bytes32 tokenSymbol;
318         address account;
319         string version;
320     }
321 
322     /**
323      * Transaction Proposal
324      * @field status Transaction proposal status(false:pending,true:complete).
325      * @field fromAccount Account of form platform.
326      * @field toAccount Account of to platform.
327      * @field value Transfer amount.
328      * @field tokenSymbol token Symbol.
329      * @field voters Proposers.
330      * @field weight The weight value of the completed time.
331      */
332     struct Proposal {
333         bool status;
334         address fromAccount;
335         address toAccount;
336         uint value;
337         address[] voters;
338         uint weight;
339     }
340 
341     /**
342      * Trusted Platform
343      * @field status Trusted platform state(false:no trusted,true:trusted).
344      * @field weight weight of platform.
345      * @field publicKeys list of public key.
346      * @field proposals list of proposal.
347      */
348     struct Platform {
349         bool status;
350         bytes32 name;
351         uint weight;
352         address[] publicKeys;
353         mapping(string => Proposal) proposals;
354     }
355 
356     Admin private admin;
357 
358     address[] private callers;
359 
360     Platform private platform;
361 
362 
363     constructor() public {
364         init();
365     }
366 
367     /**
368      * TODO Parameters that must be set before compilation
369      * $Init admin.status
370      * $Init admin.platformName
371      * $Init admin.tokenSymbol
372      * $Init admin.account
373      * $Init admin.version
374      * $Init platform.status
375      * $Init platform.name
376      * $Init platform.weight
377      * $Init platform.publicKeys
378      */
379     function init() internal {
380         // Admin { status | platformName | tokenSymbol | account}
381         admin.status = true;
382         admin.platformName = "ETH";
383         admin.tokenSymbol = "INK";
384         admin.account = msg.sender;
385         admin.version = "1.0";
386         platform.status = true;
387         platform.name = "INK";
388         platform.weight = 3;
389         platform.publicKeys.push(0x80aa17b21c16620a4d7dd06ec1dcc44190b02ca0);
390         platform.publicKeys.push(0xd2e40bb4967b355da8d70be40c277ebcf108063c);
391         platform.publicKeys.push(0x1501e0f09498aa95cb0c2f1e3ee51223e5074720);
392     }
393 
394     function start() onlyAdmin external {
395         if (!admin.status) {
396             admin.status = true;
397         }
398     }
399 
400     function stop() onlyAdmin external {
401         if (admin.status) {
402             admin.status = false;
403         }
404     }
405 
406     function getStatus() external view returns (bool) {
407         return admin.status;
408     }
409 
410     function getPlatformName() external view returns (bytes32) {
411         return admin.platformName;
412     }
413 
414     function setAdmin(address account) onlyAdmin nonzeroAddress(account) external {
415         if (admin.account != account) {
416             admin.account = account;
417         }
418     }
419 
420     function getAdmin() external view returns (address) {
421         return admin.account;
422     }
423 
424     function getTokenSymbol() external view returns (bytes32) {
425         return admin.tokenSymbol;
426     }
427 
428     function addCaller(address caller) onlyAdmin nonzeroAddress(caller) external {
429         if (!_existCaller(caller)) {
430             callers.push(caller);
431         }
432     }
433 
434     function deleteCaller(address caller) onlyAdmin nonzeroAddress(caller) external {
435         for (uint i = 0; i < callers.length; i++) {
436             if (callers[i] == caller) {
437                 if (i != callers.length - 1 ) {
438                     callers[i] = callers[callers.length - 1];
439                 }
440                 callers.length--;
441                 return;
442             }
443         }
444     }
445 
446     function existCaller(address caller) external view returns (bool) {
447         return _existCaller(caller);
448     }
449 
450     function getCallers() external view returns (address[]) {
451         return callers;
452     }
453 
454     function getTrustPlatform() external view returns (bytes32 name){
455         return platform.name;
456     }
457 
458     function setWeight(uint weight) onlyAdmin external {
459         require(weight > 0);
460         if (platform.weight != weight) {
461             platform.weight = weight;
462         }
463     }
464 
465     function getWeight() external view returns (uint) {
466         return platform.weight;
467     }
468 
469     function addPublicKey(address publicKey) onlyAdmin nonzeroAddress(publicKey) external {
470         address[] storage publicKeys = platform.publicKeys;
471         for (uint i; i < publicKeys.length; i++) {
472             if (publicKey == publicKeys[i]) {
473                 return;
474             }
475         }
476         publicKeys.push(publicKey);
477     }
478 
479     function deletePublicKey(address publicKey) onlyAdmin nonzeroAddress(publicKey) external {
480         address[] storage publicKeys = platform.publicKeys;
481         for (uint i = 0; i < publicKeys.length; i++) {
482             if (publicKeys[i] == publicKey) {
483                 if (i != publicKeys.length - 1 ) {
484                     publicKeys[i] = publicKeys[publicKeys.length - 1];
485                 }
486                 publicKeys.length--;
487                 return;
488             }
489         }
490     }
491 
492     function existPublicKey(address publicKey) external view returns (bool) {
493         return _existPublicKey(publicKey);
494     }
495 
496     function countOfPublicKey() external view returns (uint){
497         return platform.publicKeys.length;
498     }
499 
500     function publicKeys() external view returns (address[]){
501         return platform.publicKeys;
502     }
503 
504     function voteProposal(address fromAccount, address toAccount, uint value, string txid, bytes sig) opened external {
505         bytes32 msgHash = hashMsg(platform.name, fromAccount, admin.platformName, toAccount, value, admin.tokenSymbol, txid,admin.version);
506         address publicKey = recover(msgHash, sig);
507         require(_existPublicKey(publicKey));
508         Proposal storage proposal = platform.proposals[txid];
509         if (proposal.value == 0) {
510             proposal.fromAccount = fromAccount;
511             proposal.toAccount = toAccount;
512             proposal.value = value;
513         } else {
514             require(proposal.fromAccount == fromAccount && proposal.toAccount == toAccount && proposal.value == value);
515         }
516         changeVoters(publicKey, txid);
517     }
518 
519     function verifyProposal(address fromAccount, address toAccount, uint value, string txid) external view returns (bool, bool) {
520         Proposal storage proposal = platform.proposals[txid];
521         if (proposal.status) {
522             return (true, (proposal.voters.length >= proposal.weight));
523         }
524         if (proposal.value == 0) {
525             return (false, false);
526         }
527         require(proposal.fromAccount == fromAccount && proposal.toAccount == toAccount && proposal.value == value);
528         return (false, (proposal.voters.length >= platform.weight));
529     }
530 
531     function commitProposal(string txid) external returns (bool) {
532         require((admin.status &&_existCaller(msg.sender)) || msg.sender == admin.account);
533         require(!platform.proposals[txid].status);
534         platform.proposals[txid].status = true;
535         platform.proposals[txid].weight = platform.proposals[txid].voters.length;
536         return true;
537     }
538 
539     function getProposal(string txid) external view returns (bool status, address fromAccount, address toAccount, uint value, address[] voters, uint weight){
540         fromAccount = platform.proposals[txid].fromAccount;
541         toAccount = platform.proposals[txid].toAccount;
542         value = platform.proposals[txid].value;
543         voters = platform.proposals[txid].voters;
544         status = platform.proposals[txid].status;
545         weight = platform.proposals[txid].weight;
546         return;
547     }
548 
549     function deleteProposal(string txid) onlyAdmin external {
550         delete platform.proposals[txid];
551     }
552 
553     /**
554      *   ######################
555      *  #  private function  #
556      * ######################
557      */
558 
559     function hashMsg(bytes32 fromPlatform, address fromAccount, bytes32 toPlatform, address toAccount, uint value, bytes32 tokenSymbol, string txid,string version) internal pure returns (bytes32) {
560         return sha256(bytes32ToStr(fromPlatform), ":0x", uintToStr(uint160(fromAccount), 16), ":", bytes32ToStr(toPlatform), ":0x", uintToStr(uint160(toAccount), 16), ":", uintToStr(value, 10), ":", bytes32ToStr(tokenSymbol), ":", txid, ":", version);
561     }
562 
563     function changeVoters(address publicKey, string txid) internal {
564         address[] storage voters = platform.proposals[txid].voters;
565         for (uint i = 0; i < voters.length; i++) {
566             if (voters[i] == publicKey) {
567                 return;
568             }
569         }
570         voters.push(publicKey);
571     }
572 
573     function bytes32ToStr(bytes32 b) internal pure returns (string) {
574         uint length = b.length;
575         for (uint i = 0; i < b.length; i++) {
576             if (b[b.length - 1 - i] != "") {
577                 length -= i;
578                 break;
579             }
580         }
581         bytes memory bs = new bytes(length);
582         for (uint j = 0; j < length; j++) {
583             bs[j] = b[j];
584         }
585         return string(bs);
586     }
587 
588     function uintToStr(uint value, uint base) internal pure returns (string) {
589         uint _value = value;
590         uint length = 0;
591         bytes16 tenStr = "0123456789abcdef";
592         while (true) {
593             if (_value > 0) {
594                 length ++;
595                 _value = _value / base;
596             } else {
597                 break;
598             }
599         }
600         if (base == 16) {
601             length = 40;
602         }
603         bytes memory bs = new bytes(length);
604         for (uint i = 0; i < length; i++) {
605             bs[length - 1 - i] = tenStr[value % base];
606             value = value / base;
607         }
608         return string(bs);
609     }
610 
611     function _existCaller(address caller) internal view returns (bool) {
612         for (uint i = 0; i < callers.length; i++) {
613             if (callers[i] == caller) {
614                 return true;
615             }
616         }
617         return false;
618     }
619 
620     function _existPublicKey(address publicKey) internal view returns (bool) {
621         address[] memory publicKeys = platform.publicKeys;
622         for (uint i = 0; i < publicKeys.length; i++) {
623             if (publicKeys[i] == publicKey) {
624                 return true;
625             }
626         }
627         return false;
628     }
629 
630     function recover(bytes32 hash, bytes sig) internal pure returns (address) {
631         bytes32 r;
632         bytes32 s;
633         uint8 v;
634         assembly {
635             r := mload(add(sig, 32))
636             s := mload(add(sig, 64))
637             v := byte(0, mload(add(sig, 96)))
638         }
639         if (v < 27) {
640             v += 27;
641         }
642         return ecrecover(hash, v, r, s);
643     }
644 
645     modifier onlyAdmin {
646         require(admin.account == msg.sender);
647         _;
648     }
649 
650     modifier nonzeroAddress(address account) {
651         require(account != address(0));
652         _;
653     }
654 
655     modifier opened() {
656         require(admin.status);
657         _;
658     }
659 }
660 
661 contract XC is XCInterface {
662 
663     /**
664      * Contract Administrator
665      * @field status Contract external service status.
666      * @field platformName Current contract platform name.
667      * @field account Current contract administrator.
668      */
669     struct Admin {
670         uint8 status;
671         bytes32 platformName;
672         address account;
673     }
674 
675     Admin private admin;
676 
677     uint public lockBalance;
678 
679     Token private token;
680 
681     XCPlugin private xcPlugin;
682 
683     event Lock(bytes32 toPlatform, address toAccount, bytes32 value, bytes32 tokenSymbol);
684 
685     event Unlock(string txid, bytes32 fromPlatform, address fromAccount, bytes32 value, bytes32 tokenSymbol);
686 
687     constructor() public {
688         init();
689     }
690 
691     /**
692      * TODO Parameters that must be set before compilation
693      * $Init admin.status
694      * $Init admin.platformName
695      * $Init admin.account
696      * $Init lockBalance
697      * $Init token
698      * $Init xcPlugin
699      */
700     function init() internal {
701         // Admin {status | platformName | account}
702         admin.status = 3;
703         admin.platformName = "ETH";
704         admin.account = msg.sender;
705         lockBalance = 344737963881081236;
706         token = Token(0xf4c90e18727c5c76499ea6369c856a6d61d3e92e);
707         xcPlugin = XCPlugin(0x15782cc68d841416f73e8f352f27cc1bc5e76e11);
708     }
709 
710     function setStatus(uint8 status) onlyAdmin external {
711         require(status <= 3);
712         if (admin.status != status) {
713             admin.status = status;
714         }
715     }
716 
717     function getStatus() external view returns (uint8) {
718         return admin.status;
719     }
720 
721     function getPlatformName() external view returns (bytes32) {
722         return admin.platformName;
723     }
724 
725     function setAdmin(address account) onlyAdmin nonzeroAddress(account) external {
726         if (admin.account != account) {
727             admin.account = account;
728         }
729     }
730 
731     function getAdmin() external view returns (address) {
732         return admin.account;
733     }
734 
735     function setToken(address account) onlyAdmin nonzeroAddress(account) external {
736         if (token != account) {
737             token = Token(account);
738         }
739     }
740 
741     function getToken() external view returns (address) {
742         return token;
743     }
744 
745     function setXCPlugin(address account) onlyAdmin nonzeroAddress(account) external {
746         if (xcPlugin != account) {
747             xcPlugin = XCPlugin(account);
748         }
749     }
750 
751     function getXCPlugin() external view returns (address) {
752         return xcPlugin;
753     }
754 
755     function lock(address toAccount, uint value) nonzeroAddress(toAccount) external {
756         require(admin.status == 2 || admin.status == 3);
757         require(xcPlugin.getStatus());
758         require(value > 0);
759         uint allowance = token.allowance(msg.sender, this);
760         require(allowance >= value);
761         bool success = token.transferFrom(msg.sender, this, value);
762         require(success);
763         lockBalance = SafeMath.add(lockBalance, value);
764         emit Lock(xcPlugin.getTrustPlatform(), toAccount, bytes32(value), xcPlugin.getTokenSymbol());
765     }
766 
767     function unlock(string txid, address fromAccount, address toAccount, uint value) nonzeroAddress(toAccount) external {
768         require(admin.status == 1 || admin.status == 3);
769         require(xcPlugin.getStatus());
770         require(value > 0);
771         bool complete;
772         bool verify;
773         (complete, verify) = xcPlugin.verifyProposal(fromAccount, toAccount, value, txid);
774         require(verify && !complete);
775         uint balance = token.balanceOf(this);
776         require(balance >= value);
777         require(token.transfer(toAccount, value));
778         require(xcPlugin.commitProposal(txid));
779         lockBalance = SafeMath.sub(lockBalance, value);
780         emit Unlock(txid, xcPlugin.getTrustPlatform(), fromAccount, bytes32(value), xcPlugin.getTokenSymbol());
781     }
782 
783     function withdraw(address account, uint value) onlyAdmin nonzeroAddress(account) external {
784         require(value > 0);
785         uint balance = token.balanceOf(this);
786         require(SafeMath.sub(balance, lockBalance) >= value);
787         bool success = token.transfer(account, value);
788         require(success);
789     }
790 
791     modifier onlyAdmin {
792         require(admin.account == msg.sender);
793         _;
794     }
795 
796     modifier nonzeroAddress(address account) {
797         require(account != address(0));
798         _;
799     }
800 }