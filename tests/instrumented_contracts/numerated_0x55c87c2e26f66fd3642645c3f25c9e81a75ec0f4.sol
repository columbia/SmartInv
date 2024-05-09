1 pragma solidity ^0.4.13;
2 
3 interface XCPluginInterface {
4 
5     /**
6      * Open the contract service status.
7      */
8     function start() external;
9 
10     /**
11      * Close the contract service status.
12      */
13     function stop() external;
14 
15     /**
16      * Get contract service status.
17      * @return contract service status.
18      */
19     function getStatus() external view returns (bool);
20 
21     /**
22      * Get the current contract platform name.
23      * @return contract platform name.
24      */
25     function getPlatformName() external view returns (bytes32);
26 
27     /**
28      * Set the current contract administrator.
29      * @param account account of contract administrator.
30      */
31     function setAdmin(address account) external;
32 
33     /**
34      * Get the current contract administrator.
35      * @return contract administrator.
36      */
37     function getAdmin() external view returns (address);
38 
39     /**
40      * Add a contract trust caller.
41      * @param caller account of caller.
42      */
43     function addCaller(address caller) external;
44 
45     /**
46      * Delete a contract trust caller.
47      * @param caller account of caller.
48      */
49     function deleteCaller(address caller) external;
50 
51     /**
52      * Whether the trust caller exists.
53      * @param caller account of caller.
54      * @return whether exists.
55      */
56     function existCaller(address caller) external view returns (bool);
57 
58     /**
59      * Get all contract trusted callers.
60      * @return al lcallers.
61      */
62     function getCallers() external view returns (address[]);
63 
64     /**
65      * Add a trusted platform name.
66      * @param name a platform name.
67      */
68     function addPlatform(bytes32 name) external;
69 
70     /**
71      * Delete a trusted platform name.
72      * @param name a platform name.
73      */
74     function deletePlatform(bytes32 name) external;
75 
76     /**
77      * Whether the trusted platform information exists.
78      * @param name a platform name.
79      * @return whether exists.
80      */
81     function existPlatform(bytes32 name) external view returns (bool);
82 
83     /**
84      * Add the trusted platform public key information.
85      * @param platformName a platform name.
86      * @param publicKey a public key.
87      */
88     function addPublicKey(bytes32 platformName, address publicKey) external;
89 
90     /**
91      * Delete the trusted platform public key information.
92      * @param platformName a platform name.
93      * @param publicKey a public key.
94      */
95     function deletePublicKey(bytes32 platformName, address publicKey) external;
96 
97     /**
98      * Whether the trusted platform public key information exists.
99      * @param platformName a platform name.
100      * @param publicKey a public key.
101      */
102     function existPublicKey(bytes32 platformName, address publicKey) external view returns (bool);
103 
104     /**
105      * Get the count of public key for the trusted platform.
106      * @param platformName a platform name.
107      * @return count of public key.
108      */
109     function countOfPublicKey(bytes32 platformName) external view returns (uint);
110 
111     /**
112      * Get the list of public key for the trusted platform.
113      * @param platformName a platform name.
114      * @return list of public key.
115      */
116     function publicKeys(bytes32 platformName) external view returns (address[]);
117 
118     /**
119      * Set the weight of a trusted platform.
120      * @param platformName a platform name.
121      * @param weight weight of platform.
122      */
123     function setWeight(bytes32 platformName, uint weight) external;
124 
125     /**
126      * Get the weight of a trusted platform.
127      * @param platformName a platform name.
128      * @return weight of platform.
129      */
130     function getWeight(bytes32 platformName) external view returns (uint);
131 
132     /**
133      * Initiate and vote on the transaction proposal.
134      * @param fromPlatform name of form platform.
135      * @param fromAccount name of to platform.
136      * @param toAccount account of to platform.
137      * @param value transfer amount.
138      * @param tokenSymbol token Symbol.
139      * @param txid transaction id.
140      * @param sig transaction signature.
141      */
142     function voteProposal(bytes32 fromPlatform, address fromAccount, address toAccount, uint value, bytes32 tokenSymbol, string txid, bytes sig) external;
143 
144     /**
145      * Verify that the transaction proposal is valid.
146      * @param fromPlatform name of form platform.
147      * @param fromAccount name of to platform.
148      * @param toAccount account of to platform.
149      * @param value transfer amount.
150      * @param tokenSymbol token Symbol.
151      * @param txid transaction id.
152      */
153     function verifyProposal(bytes32 fromPlatform, address fromAccount, address toAccount, uint value, bytes32 tokenSymbol, string txid) external view returns (bool, bool);
154 
155     /**
156      * Commit the transaction proposal.
157      * @param platformName a platform name.
158      * @param txid transaction id.
159      */
160     function commitProposal(bytes32 platformName, string txid) external returns (bool);
161 
162     /**
163      * Get the transaction proposal information.
164      * @param platformName a platform name.
165      * @param txid transaction id.
166      * @return status completion status of proposal.
167      * @return fromAccount account of to platform.
168      * @return toAccount account of to platform.
169      * @return value transfer amount.
170      * @return voters notarial voters.
171      * @return weight The weight value of the completed time.
172      */
173     function getProposal(bytes32 platformName, string txid) external view returns (bool status, address fromAccount, address toAccount, uint value, address[] voters, uint weight);
174 
175     /**
176      * Delete the transaction proposal information.
177      * @param platformName a platform name.
178      * @param txid transaction id.
179      */
180     function deleteProposal(bytes32 platformName, string txid) external;
181 
182     /**
183      * Transfer the money(qtum/eth) from the contract account.
184      * @param account the specified account.
185      * @param value transfer amount.
186      */
187     function transfer(address account, uint value) external payable;
188 }
189 
190 contract XCPlugin is XCPluginInterface {
191 
192     /**
193      * Contract Administrator
194      * @field status Contract external service status.
195      * @field platformName Current contract platform name.
196      * @field tokenSymbol token Symbol.
197      * @field account Current contract administrator.
198      */
199     struct Admin {
200 
201         bool status;
202 
203         bytes32 platformName;
204 
205         bytes32 tokenSymbol;
206 
207         address account;
208     }
209 
210     /**
211      * Transaction Proposal
212      * @field status Transaction proposal status(false:pending,true:complete).
213      * @field fromAccount Account of form platform.
214      * @field toAccount Account of to platform.
215      * @field value Transfer amount.
216      * @field tokenSymbol token Symbol.
217      * @field voters Proposers.
218      * @field weight The weight value of the completed time.
219      */
220     struct Proposal {
221 
222         bool status;
223 
224         address fromAccount;
225 
226         address toAccount;
227 
228         uint value;
229 
230         bytes32 tokenSymbol;
231 
232         address[] voters;
233 
234         uint weight;
235     }
236 
237     /**
238      * Trusted Platform
239      * @field status Trusted platform state(false:no trusted,true:trusted).
240      * @field weight weight of platform.
241      * @field publicKeys list of public key.
242      * @field proposals list of proposal.
243      */
244     struct Platform {
245 
246         bool status;
247 
248         uint weight;
249 
250         address[] publicKeys;
251 
252         mapping(string => Proposal) proposals;
253     }
254 
255     Admin private admin;
256 
257     address[] private callers;
258 
259     mapping(bytes32 => Platform) private platforms;
260 
261     function XCPlugin() public {
262 
263         init();
264     }
265 
266     function init() internal {
267         // Admin { status | platformName | tokenSymbol | account}
268         admin.status = true;
269 
270         admin.platformName = "ETH";
271 
272         admin.tokenSymbol = "INK";
273 
274         admin.account = msg.sender;
275 
276         bytes32 platformName = "INK";
277 
278         platforms[platformName].status = true;
279 
280         platforms[platformName].weight = 1;
281 
282         platforms[platformName].publicKeys.push(0x4230a12f5b0693dd88bb35c79d7e56a68614b199);
283 
284         platforms[platformName].publicKeys.push(0x07caf88941eafcaaa3370657fccc261acb75dfba);
285     }
286 
287     function start() external {
288 
289         require(admin.account == msg.sender);
290 
291         if (!admin.status) {
292 
293             admin.status = true;
294         }
295     }
296 
297     function stop() external {
298 
299         require(admin.account == msg.sender);
300 
301         if (admin.status) {
302 
303             admin.status = false;
304         }
305     }
306 
307     function getStatus() external view returns (bool) {
308 
309         return admin.status;
310     }
311 
312     function getPlatformName() external view returns (bytes32) {
313 
314         return admin.platformName;
315     }
316 
317     function setAdmin(address account) external {
318 
319         require(account != address(0));
320 
321         require(admin.account == msg.sender);
322 
323         if (admin.account != account) {
324 
325             admin.account = account;
326         }
327     }
328 
329     function getAdmin() external view returns (address) {
330 
331         return admin.account;
332     }
333 
334     function addCaller(address caller) external {
335 
336         require(admin.account == msg.sender);
337 
338         if (!_existCaller(caller)) {
339 
340             callers.push(caller);
341         }
342     }
343 
344     function deleteCaller(address caller) external {
345 
346         require(admin.account == msg.sender);
347 
348         if (_existCaller(caller)) {
349 
350             bool exist;
351 
352             for (uint i = 0; i <= callers.length; i++) {
353 
354                 if (exist) {
355 
356                     if (i == callers.length) {
357 
358                         delete callers[i - 1];
359 
360                         callers.length--;
361                     } else {
362 
363                         callers[i - 1] = callers[i];
364                     }
365                 } else if (callers[i] == caller) {
366 
367                     exist = true;
368                 }
369             }
370 
371         }
372     }
373 
374     function existCaller(address caller) external view returns (bool) {
375 
376         return _existCaller(caller);
377     }
378 
379     function getCallers() external view returns (address[]) {
380 
381         require(admin.account == msg.sender);
382 
383         return callers;
384     }
385 
386     function addPlatform(bytes32 name) external {
387 
388         require(admin.account == msg.sender);
389 
390         require(name != "");
391 
392         require(name != admin.platformName);
393 
394         if (!_existPlatform(name)) {
395 
396             platforms[name].status = true;
397 
398             if (platforms[name].weight == 0) {
399 
400                 platforms[name].weight = 1;
401             }
402         }
403     }
404 
405     function deletePlatform(bytes32 name) external {
406 
407         require(admin.account == msg.sender);
408 
409         require(name != admin.platformName);
410 
411         if (_existPlatform(name)) {
412 
413             platforms[name].status = false;
414         }
415     }
416 
417     function existPlatform(bytes32 name) external view returns (bool){
418 
419         return _existPlatform(name);
420     }
421 
422     function setWeight(bytes32 platformName, uint weight) external {
423 
424         require(admin.account == msg.sender);
425 
426         require(_existPlatform(platformName));
427 
428         require(weight > 0);
429 
430         if (platforms[platformName].weight != weight) {
431 
432             platforms[platformName].weight = weight;
433         }
434     }
435 
436     function getWeight(bytes32 platformName) external view returns (uint) {
437 
438         require(admin.account == msg.sender);
439 
440         require(_existPlatform(platformName));
441 
442         return platforms[platformName].weight;
443     }
444 
445     function addPublicKey(bytes32 platformName, address publicKey) external {
446 
447         require(admin.account == msg.sender);
448 
449         require(_existPlatform(platformName));
450 
451         require(publicKey != address(0));
452 
453         address[] storage listOfPublicKey = platforms[platformName].publicKeys;
454 
455         for (uint i; i < listOfPublicKey.length; i++) {
456 
457             if (publicKey == listOfPublicKey[i]) {
458 
459                 return;
460             }
461         }
462 
463         listOfPublicKey.push(publicKey);
464     }
465 
466     function deletePublicKey(bytes32 platformName, address publickey) external {
467 
468         require(admin.account == msg.sender);
469 
470         require(_existPlatform(platformName));
471 
472         address[] storage listOfPublicKey = platforms[platformName].publicKeys;
473 
474         bool exist;
475 
476         for (uint i = 0; i <= listOfPublicKey.length; i++) {
477 
478             if (exist) {
479                 if (i == listOfPublicKey.length) {
480 
481                     delete listOfPublicKey[i - 1];
482 
483                     listOfPublicKey.length--;
484                 } else {
485 
486                     listOfPublicKey[i - 1] = listOfPublicKey[i];
487                 }
488             } else if (listOfPublicKey[i] == publickey) {
489 
490                 exist = true;
491             }
492         }
493     }
494 
495     function existPublicKey(bytes32 platformName, address publicKey) external view returns (bool) {
496 
497         require(admin.account == msg.sender);
498 
499         return _existPublicKey(platformName, publicKey);
500     }
501 
502     function countOfPublicKey(bytes32 platformName) external view returns (uint){
503 
504         require(admin.account == msg.sender);
505 
506         require(_existPlatform(platformName));
507 
508         return platforms[platformName].publicKeys.length;
509     }
510 
511     function publicKeys(bytes32 platformName) external view returns (address[]){
512 
513         require(admin.account == msg.sender);
514 
515         require(_existPlatform(platformName));
516 
517         return platforms[platformName].publicKeys;
518     }
519 
520     function voteProposal(bytes32 fromPlatform, address fromAccount, address toAccount, uint value, bytes32 tokenSymbol, string txid, bytes sig) external {
521 
522         require(admin.status);
523 
524         require(_existPlatform(fromPlatform));
525 
526         bytes32 msgHash = hashMsg(fromPlatform, fromAccount, admin.platformName, toAccount, value, tokenSymbol, txid);
527 
528         // address publicKey = ecrecover(msgHash, v, r, s);
529         address publicKey = recover(msgHash, sig);
530 
531         require(_existPublicKey(fromPlatform, publicKey));
532 
533         Proposal storage proposal = platforms[fromPlatform].proposals[txid];
534 
535         if (proposal.value == 0) {
536 
537             proposal.fromAccount = fromAccount;
538 
539             proposal.toAccount = toAccount;
540 
541             proposal.value = value;
542 
543             proposal.tokenSymbol = tokenSymbol;
544         } else {
545 
546             require(proposal.fromAccount == fromAccount && proposal.toAccount == toAccount && proposal.value == value && proposal.tokenSymbol == tokenSymbol);
547         }
548 
549         changeVoters(fromPlatform, publicKey, txid);
550     }
551 
552     function verifyProposal(bytes32 fromPlatform, address fromAccount, address toAccount, uint value, bytes32 tokenSymbol, string txid) external view returns (bool, bool) {
553 
554         require(admin.status);
555 
556         require(_existPlatform(fromPlatform));
557 
558         Proposal storage proposal = platforms[fromPlatform].proposals[txid];
559 
560         if (proposal.status) {
561 
562             return (true, (proposal.voters.length >= proposal.weight));
563         }
564 
565         if (proposal.value == 0) {
566 
567             return (false, false);
568         }
569 
570         require(proposal.fromAccount == fromAccount && proposal.toAccount == toAccount && proposal.value == value && proposal.tokenSymbol == tokenSymbol);
571 
572         return (false, (proposal.voters.length >= platforms[fromPlatform].weight));
573     }
574 
575     function commitProposal(bytes32 platformName, string txid) external returns (bool) {
576 
577         require(admin.status);
578 
579         require(_existCaller(msg.sender) || msg.sender == admin.account);
580 
581         require(_existPlatform(platformName));
582 
583         require(!platforms[platformName].proposals[txid].status);
584 
585         platforms[platformName].proposals[txid].status = true;
586 
587         platforms[platformName].proposals[txid].weight = platforms[platformName].proposals[txid].voters.length;
588 
589         return true;
590     }
591 
592     function getProposal(bytes32 platformName, string txid) external view returns (bool status, address fromAccount, address toAccount, uint value, address[] voters, uint weight){
593 
594         require(admin.status);
595 
596         require(_existPlatform(platformName));
597 
598         fromAccount = platforms[platformName].proposals[txid].fromAccount;
599 
600         toAccount = platforms[platformName].proposals[txid].toAccount;
601 
602         value = platforms[platformName].proposals[txid].value;
603 
604         voters = platforms[platformName].proposals[txid].voters;
605 
606         status = platforms[platformName].proposals[txid].status;
607 
608         weight = platforms[platformName].proposals[txid].weight;
609 
610         return;
611     }
612 
613     function deleteProposal(bytes32 platformName, string txid) external {
614 
615         require(msg.sender == admin.account);
616 
617         require(_existPlatform(platformName));
618 
619         delete platforms[platformName].proposals[txid];
620     }
621 
622     function transfer(address account, uint value) external payable {
623 
624         require(admin.account == msg.sender);
625 
626         require(account != address(0));
627 
628         require(value > 0 && value >= address(this).balance);
629 
630         this.transfer(account, value);
631     }
632 
633     /**
634      *   ######################
635      *  #  private function  #
636      * ######################
637      */
638 
639     function hashMsg(bytes32 fromPlatform, address fromAccount, bytes32 toPlatform, address toAccount, uint value, bytes32 tokenSymbol, string txid) internal pure returns (bytes32) {
640 
641         return sha256(bytes32ToStr(fromPlatform), ":0x", uintToStr(uint160(fromAccount), 16), ":", bytes32ToStr(toPlatform), ":0x", uintToStr(uint160(toAccount), 16), ":", uintToStr(value, 10), ":", bytes32ToStr(tokenSymbol), ":", txid);
642     }
643 
644     function changeVoters(bytes32 platformName, address publicKey, string txid) internal {
645 
646         address[] storage voters = platforms[platformName].proposals[txid].voters;
647 
648         bool change = true;
649 
650         for (uint i = 0; i < voters.length; i++) {
651 
652             if (voters[i] == publicKey) {
653 
654                 change = false;
655             }
656         }
657 
658         if (change) {
659 
660             voters.push(publicKey);
661         }
662     }
663 
664     function bytes32ToStr(bytes32 b) internal pure returns (string) {
665 
666         uint length = b.length;
667 
668         for (uint i = 0; i < b.length; i++) {
669 
670             if (b[b.length - 1 - i] == "") {
671 
672                 length -= 1;
673             } else {
674 
675                 break;
676             }
677         }
678 
679         bytes memory bs = new bytes(length);
680 
681         for (uint j = 0; j < length; j++) {
682 
683             bs[j] = b[j];
684         }
685 
686         return string(bs);
687     }
688 
689     function uintToStr(uint value, uint base) internal pure returns (string) {
690 
691         uint _value = value;
692 
693         uint length = 0;
694 
695         bytes16 tenStr = "0123456789abcdef";
696 
697         while (true) {
698 
699             if (_value > 0) {
700 
701                 length ++;
702 
703                 _value = _value / base;
704             } else {
705 
706                 break;
707             }
708         }
709 
710         if (base == 16) {
711             length = 40;
712         }
713 
714         bytes memory bs = new bytes(length);
715 
716         for (uint i = 0; i < length; i++) {
717 
718             bs[length - 1 - i] = tenStr[value % base];
719 
720             value = value / base;
721         }
722 
723         return string(bs);
724     }
725 
726     function _existCaller(address caller) internal view returns (bool) {
727 
728         for (uint i = 0; i < callers.length; i++) {
729 
730             if (callers[i] == caller) {
731 
732                 return true;
733             }
734         }
735 
736         return false;
737     }
738 
739     function _existPlatform(bytes32 name) internal view returns (bool){
740 
741         return platforms[name].status;
742     }
743 
744     function _existPublicKey(bytes32 platformName, address publicKey) internal view returns (bool) {
745 
746 
747         address[] memory listOfPublicKey = platforms[platformName].publicKeys;
748 
749         for (uint i = 0; i < listOfPublicKey.length; i++) {
750 
751             if (listOfPublicKey[i] == publicKey) {
752 
753                 return true;
754             }
755         }
756 
757         return false;
758     }
759 
760     function recover(bytes32 hash, bytes sig) internal pure returns (address) {
761 
762         bytes32 r;
763 
764         bytes32 s;
765 
766         uint8 v;
767 
768         assembly {
769 
770             r := mload(add(sig, 32))
771 
772             s := mload(add(sig, 64))
773 
774             v := byte(0, mload(add(sig, 96)))
775         }
776 
777         if (v < 27) {
778 
779             v += 27;
780         }
781 
782         return ecrecover(hash, v, r, s);
783     }
784 }