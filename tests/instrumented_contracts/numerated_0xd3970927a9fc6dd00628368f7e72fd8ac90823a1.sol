1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         if (a == 0) {
10             return 0;
11         }
12         c = a * b;
13         require(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // require(b > 0); // Solidity automatically throws when dividing by 0
22         // uint256 c = a / b;
23         // require(a == b * c + a % b); // There is no case in which this doesn't hold
24         return a / b;
25     }
26 
27     /**
28     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39         c = a + b;
40         require(c >= a);
41         return c;
42     }
43 }
44 
45 contract ERC20 {
46 
47     uint256 public totalSupply;
48 
49     mapping(address => uint256) public balanceOf;
50 
51     mapping(address => mapping(address => uint256)) public allowance;
52 
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 
57     function transfer(address _to, uint256 _value) public returns (bool success) {
58 
59         _transfer(msg.sender, _to, _value);
60 
61         return true;
62     }
63 
64     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
65 
66         require(allowance[_from][msg.sender] >= _value);
67 
68         allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value);
69 
70         _transfer(_from, _to, _value);
71 
72         return true;
73     }
74 
75     function approve(address _spender, uint256 _value) public returns (bool success) {
76 
77         allowance[msg.sender][_spender] = _value;
78 
79         emit Approval(msg.sender, _spender, _value);
80 
81         return true;
82     }
83 
84     /**
85      *   ######################
86      *  #  private function  #
87      * ######################
88      */
89 
90     function _transfer(address _from, address _to, uint _value) internal {
91 
92         require(balanceOf[_from] >= _value);
93 
94         require(SafeMath.add(balanceOf[_to], _value) >= balanceOf[_to]);
95 
96         balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);
97 
98         balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);
99 
100         emit Transfer(_from, _to, _value);
101     }
102 }
103 
104 contract Token is ERC20 {
105 
106     uint8 public constant decimals = 9;
107 
108     uint256 public constant initialSupply = 10 * (10 ** 8) * (10 ** uint256(decimals));
109 
110     string public constant name = 'INK Coin';
111 
112     string public constant symbol = 'INK';
113 
114 
115     function() public {
116 
117         revert();
118     }
119 
120     function Token() public {
121 
122         balanceOf[msg.sender] = initialSupply;
123 
124         totalSupply = initialSupply;
125     }
126 
127     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
128 
129         if (approve(_spender, _value)) {
130 
131             if (!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
132 
133                 revert();
134             }
135 
136             return true;
137         }
138     }
139 
140 }
141 
142 interface XCInterface {
143 
144     /**
145      * Set contract service status.
146      * @param status contract service status (0:closed;1:only-closed-lock;2:only-closed-unlock;3:opened;).
147      */
148     function setStatus(uint8 status) external;
149 
150     /**
151      * Get contract service status.
152      * @return contract service status.
153      */
154     function getStatus() external view returns (uint8);
155 
156     /**
157      * Get the current contract platform name.
158      * @return contract platform name.
159      */
160     function getPlatformName() external view returns (bytes32);
161 
162     /**
163      * Set the current contract administrator.
164      * @param account account of contract administrator.
165      */
166     function setAdmin(address account) external;
167 
168     /**
169      * Get the current contract administrator.
170      * @return contract administrator.
171      */
172     function getAdmin() external view returns (address);
173 
174     /**
175      * Set the Token contract address.
176      * @param account contract address.
177      */
178     function setToken(address account) external;
179 
180     /**
181      * Get the Token contract address.
182      * @return contract address.
183      */
184     function getToken() external view returns (address);
185 
186     /**
187      * Set the XCPlugin contract address.
188      * @param account contract address.
189      */
190     function setXCPlugin(address account) external;
191 
192     /**
193      * Get the XCPlugin contract address.
194      * @return contract address.
195      */
196     function getXCPlugin() external view returns (address);
197 
198     /**
199      * Set the comparison symbol in the contract.
200      * @param symbol comparison symbol ({"-=" : ">" , "+=" : ">=" }).
201      */
202     function setCompare(bytes2 symbol) external;
203 
204     /**
205      * Get the comparison symbol in the contract.
206      * @return comparison symbol.
207      */
208     function getCompare() external view returns (bytes2);
209 
210     /**
211      * Transfer out of cross chain.
212      * @param toPlatform name of to platform.
213      * @param toAccount account of to platform.
214      * @param value transfer amount.
215      */
216     function lock(bytes32 toPlatform, address toAccount, uint value) external payable;
217 
218     /**
219      * Transfer in of cross chain.
220      * @param txid transaction id.
221      * @param fromPlatform name of form platform.
222      * @param fromAccount ame of to platform.
223      * @param toAccount account of to platform.
224      * @param value transfer amount.
225      */
226     function unlock(string txid, bytes32 fromPlatform, address fromAccount, address toAccount, uint value) external payable;
227 
228     /**
229      * Transfer the misoperation to the amount of the contract account to the specified account.
230      * @param account the specified account.
231      * @param value transfer amount.
232      */
233     function withdraw(address account, uint value) external payable;
234 
235     /**
236      * Transfer the money(qtum/eth) from the contract account.
237      * @param account the specified account.
238      * @param value transfer amount.
239      */
240     function transfer(address account, uint value) external payable;
241 
242     /**
243      * Deposit money(eth) into a contract.
244      */
245     function deposit() external payable;
246 }
247 
248 contract XC is XCInterface {
249 
250     /**
251      * Contract Administrator
252      * @field status Contract external service status.
253      * @field platformName Current contract platform name.
254      * @field account Current contract administrator.
255      */
256     struct Admin {
257 
258         uint8 status;
259 
260         bytes32 platformName;
261 
262         bytes32 tokenSymbol;
263 
264         bytes2 compareSymbol;
265 
266         address account;
267     }
268 
269     Admin private admin;
270 
271     uint public lockBalance;
272 
273     Token private token;
274 
275     XCPlugin private xcPlugin;
276 
277     event Lock(bytes32 toPlatform, address toAccount, bytes32 value, bytes32 tokenSymbol);
278 
279     event Unlock(string txid, bytes32 fromPlatform, address fromAccount, bytes32 value, bytes32 tokenSymbol);
280 
281     event Deposit(address from, bytes32 value);
282 
283     function XC() public payable {
284 
285         init();
286     }
287 
288     function init() internal {
289 
290         // Admin {status | platformName | tokenSymbol | compareSymbol | account}
291         admin.status = 3;
292 
293         admin.platformName = "ETH";
294 
295         admin.tokenSymbol = "INK";
296 
297         admin.compareSymbol = "+=";
298 
299         admin.account = msg.sender;
300 
301         //totalSupply = 10 * (10 ** 8) * (10 ** 9);
302         lockBalance = 10 * (10 ** 8) * (10 ** 9);
303 
304         token = Token(0xc15d8f30fa3137eee6be111c2933f1624972f45c);
305 
306         xcPlugin = XCPlugin(0x55c87c2e26f66fd3642645c3f25c9e81a75ec0f4);
307     }
308 
309     function setStatus(uint8 status) external {
310 
311         require(admin.account == msg.sender);
312 
313         require(status == 0 || status == 1 || status == 2 || status == 3);
314 
315         if (admin.status != status) {
316 
317             admin.status = status;
318         }
319     }
320 
321     function getStatus() external view returns (uint8) {
322 
323         return admin.status;
324     }
325 
326     function getPlatformName() external view returns (bytes32) {
327 
328         return admin.platformName;
329     }
330 
331     function setAdmin(address account) external {
332 
333         require(account != address(0));
334 
335         require(admin.account == msg.sender);
336 
337         if (admin.account != account) {
338 
339             admin.account = account;
340         }
341     }
342 
343     function getAdmin() external view returns (address) {
344 
345         return admin.account;
346     }
347 
348     function setToken(address account) external {
349 
350         require(admin.account == msg.sender);
351 
352         if (token != account) {
353 
354             token = Token(account);
355         }
356     }
357 
358     function getToken() external view returns (address) {
359 
360         return token;
361     }
362 
363     function setXCPlugin(address account) external {
364 
365         require(admin.account == msg.sender);
366 
367         if (xcPlugin != account) {
368 
369             xcPlugin = XCPlugin(account);
370         }
371     }
372 
373     function getXCPlugin() external view returns (address) {
374 
375         return xcPlugin;
376     }
377 
378     function setCompare(bytes2 symbol) external {
379 
380         require(admin.account == msg.sender);
381 
382         require(symbol == "+=" || symbol == "-=");
383 
384         if (admin.compareSymbol != symbol) {
385 
386             admin.compareSymbol = symbol;
387         }
388     }
389 
390     function getCompare() external view returns (bytes2){
391 
392         require(admin.account == msg.sender);
393 
394         return admin.compareSymbol;
395     }
396 
397     function lock(bytes32 toPlatform, address toAccount, uint value) external payable {
398 
399         require(admin.status == 2 || admin.status == 3);
400 
401         require(xcPlugin.getStatus());
402 
403         require(xcPlugin.existPlatform(toPlatform));
404 
405         require(toAccount != address(0));
406 
407         // require(token.totalSupply >= value && value > 0);
408         require(value > 0);
409 
410         //get user approve the contract quota
411         uint allowance = token.allowance(msg.sender, this);
412 
413         require(toCompare(allowance, value));
414 
415         //do transferFrom
416         bool success = token.transferFrom(msg.sender, this, value);
417 
418         require(success);
419 
420         //record the amount of local platform turn out
421         lockBalance = SafeMath.add(lockBalance, value);
422         // require(token.totalSupply >= lockBalance);
423 
424         //trigger Lock
425         emit Lock(toPlatform, toAccount, bytes32(value), admin.tokenSymbol);
426     }
427 
428     function unlock(string txid, bytes32 fromPlatform, address fromAccount, address toAccount, uint value) external payable {
429 
430         require(admin.status == 1 || admin.status == 3);
431 
432         require(xcPlugin.getStatus());
433 
434         require(xcPlugin.existPlatform(fromPlatform));
435 
436         require(toAccount != address(0));
437 
438         // require(token.totalSupply >= value && value > 0);
439         require(value > 0);
440 
441         //verify args by function xcPlugin.verify
442         bool complete;
443 
444         bool verify;
445 
446         (complete, verify) = xcPlugin.verifyProposal(fromPlatform, fromAccount, toAccount, value, admin.tokenSymbol, txid);
447 
448         require(verify && !complete);
449 
450         //get contracts balance
451         uint balance = token.balanceOf(this);
452 
453         //validate the balance of contract were less than amount
454         require(toCompare(balance, value));
455 
456         require(token.transfer(toAccount, value));
457 
458         require(xcPlugin.commitProposal(fromPlatform, txid));
459 
460         lockBalance = SafeMath.sub(lockBalance, value);
461 
462         emit Unlock(txid, fromPlatform, fromAccount, bytes32(value), admin.tokenSymbol);
463     }
464 
465     function withdraw(address account, uint value) external payable {
466 
467         require(admin.account == msg.sender);
468 
469         require(account != address(0));
470 
471         // require(token.totalSupply >= value && value > 0);
472         require(value > 0);
473 
474         uint balance = token.balanceOf(this);
475 
476         require(toCompare(SafeMath.sub(balance, lockBalance), value));
477 
478         bool success = token.transfer(account, value);
479 
480         require(success);
481     }
482 
483     function transfer(address account, uint value) external payable {
484 
485         require(admin.account == msg.sender);
486 
487         require(account != address(0));
488 
489         require(value > 0 && value >= address(this).balance);
490 
491         this.transfer(account, value);
492     }
493 
494     function deposit() external payable {
495 
496         emit Deposit(msg.sender, bytes32(msg.value));
497     }
498 
499     /**
500      *   ######################
501      *  #  private function  #
502      * ######################
503      */
504 
505     function toCompare(uint f, uint s) internal view returns (bool) {
506 
507         if (admin.compareSymbol == "-=") {
508 
509             return f > s;
510         } else if (admin.compareSymbol == "+=") {
511 
512             return f >= s;
513         } else {
514 
515             return false;
516         }
517     }
518 }
519 
520 interface XCPluginInterface {
521 
522     /**
523      * Open the contract service status.
524      */
525     function start() external;
526 
527     /**
528      * Close the contract service status.
529      */
530     function stop() external;
531 
532     /**
533      * Get contract service status.
534      * @return contract service status.
535      */
536     function getStatus() external view returns (bool);
537 
538     /**
539      * Get the current contract platform name.
540      * @return contract platform name.
541      */
542     function getPlatformName() external view returns (bytes32);
543 
544     /**
545      * Set the current contract administrator.
546      * @param account account of contract administrator.
547      */
548     function setAdmin(address account) external;
549 
550     /**
551      * Get the current contract administrator.
552      * @return contract administrator.
553      */
554     function getAdmin() external view returns (address);
555 
556     /**
557      * Add a contract trust caller.
558      * @param caller account of caller.
559      */
560     function addCaller(address caller) external;
561 
562     /**
563      * Delete a contract trust caller.
564      * @param caller account of caller.
565      */
566     function deleteCaller(address caller) external;
567 
568     /**
569      * Whether the trust caller exists.
570      * @param caller account of caller.
571      * @return whether exists.
572      */
573     function existCaller(address caller) external view returns (bool);
574 
575     /**
576      * Get all contract trusted callers.
577      * @return al lcallers.
578      */
579     function getCallers() external view returns (address[]);
580 
581     /**
582      * Add a trusted platform name.
583      * @param name a platform name.
584      */
585     function addPlatform(bytes32 name) external;
586 
587     /**
588      * Delete a trusted platform name.
589      * @param name a platform name.
590      */
591     function deletePlatform(bytes32 name) external;
592 
593     /**
594      * Whether the trusted platform information exists.
595      * @param name a platform name.
596      * @return whether exists.
597      */
598     function existPlatform(bytes32 name) external view returns (bool);
599 
600     /**
601      * Add the trusted platform public key information.
602      * @param platformName a platform name.
603      * @param publicKey a public key.
604      */
605     function addPublicKey(bytes32 platformName, address publicKey) external;
606 
607     /**
608      * Delete the trusted platform public key information.
609      * @param platformName a platform name.
610      * @param publicKey a public key.
611      */
612     function deletePublicKey(bytes32 platformName, address publicKey) external;
613 
614     /**
615      * Whether the trusted platform public key information exists.
616      * @param platformName a platform name.
617      * @param publicKey a public key.
618      */
619     function existPublicKey(bytes32 platformName, address publicKey) external view returns (bool);
620 
621     /**
622      * Get the count of public key for the trusted platform.
623      * @param platformName a platform name.
624      * @return count of public key.
625      */
626     function countOfPublicKey(bytes32 platformName) external view returns (uint);
627 
628     /**
629      * Get the list of public key for the trusted platform.
630      * @param platformName a platform name.
631      * @return list of public key.
632      */
633     function publicKeys(bytes32 platformName) external view returns (address[]);
634 
635     /**
636      * Set the weight of a trusted platform.
637      * @param platformName a platform name.
638      * @param weight weight of platform.
639      */
640     function setWeight(bytes32 platformName, uint weight) external;
641 
642     /**
643      * Get the weight of a trusted platform.
644      * @param platformName a platform name.
645      * @return weight of platform.
646      */
647     function getWeight(bytes32 platformName) external view returns (uint);
648 
649     /**
650      * Initiate and vote on the transaction proposal.
651      * @param fromPlatform name of form platform.
652      * @param fromAccount name of to platform.
653      * @param toAccount account of to platform.
654      * @param value transfer amount.
655      * @param tokenSymbol token Symbol.
656      * @param txid transaction id.
657      * @param sig transaction signature.
658      */
659     function voteProposal(bytes32 fromPlatform, address fromAccount, address toAccount, uint value, bytes32 tokenSymbol, string txid, bytes sig) external;
660 
661     /**
662      * Verify that the transaction proposal is valid.
663      * @param fromPlatform name of form platform.
664      * @param fromAccount name of to platform.
665      * @param toAccount account of to platform.
666      * @param value transfer amount.
667      * @param tokenSymbol token Symbol.
668      * @param txid transaction id.
669      */
670     function verifyProposal(bytes32 fromPlatform, address fromAccount, address toAccount, uint value, bytes32 tokenSymbol, string txid) external view returns (bool, bool);
671 
672     /**
673      * Commit the transaction proposal.
674      * @param platformName a platform name.
675      * @param txid transaction id.
676      */
677     function commitProposal(bytes32 platformName, string txid) external returns (bool);
678 
679     /**
680      * Get the transaction proposal information.
681      * @param platformName a platform name.
682      * @param txid transaction id.
683      * @return status completion status of proposal.
684      * @return fromAccount account of to platform.
685      * @return toAccount account of to platform.
686      * @return value transfer amount.
687      * @return voters notarial voters.
688      * @return weight The weight value of the completed time.
689      */
690     function getProposal(bytes32 platformName, string txid) external view returns (bool status, address fromAccount, address toAccount, uint value, address[] voters, uint weight);
691 
692     /**
693      * Delete the transaction proposal information.
694      * @param platformName a platform name.
695      * @param txid transaction id.
696      */
697     function deleteProposal(bytes32 platformName, string txid) external;
698 
699     /**
700      * Transfer the money(qtum/eth) from the contract account.
701      * @param account the specified account.
702      * @param value transfer amount.
703      */
704     function transfer(address account, uint value) external payable;
705 }
706 
707 contract XCPlugin is XCPluginInterface {
708 
709     /**
710      * Contract Administrator
711      * @field status Contract external service status.
712      * @field platformName Current contract platform name.
713      * @field tokenSymbol token Symbol.
714      * @field account Current contract administrator.
715      */
716     struct Admin {
717 
718         bool status;
719 
720         bytes32 platformName;
721 
722         bytes32 tokenSymbol;
723 
724         address account;
725     }
726 
727     /**
728      * Transaction Proposal
729      * @field status Transaction proposal status(false:pending,true:complete).
730      * @field fromAccount Account of form platform.
731      * @field toAccount Account of to platform.
732      * @field value Transfer amount.
733      * @field tokenSymbol token Symbol.
734      * @field voters Proposers.
735      * @field weight The weight value of the completed time.
736      */
737     struct Proposal {
738 
739         bool status;
740 
741         address fromAccount;
742 
743         address toAccount;
744 
745         uint value;
746 
747         bytes32 tokenSymbol;
748 
749         address[] voters;
750 
751         uint weight;
752     }
753 
754     /**
755      * Trusted Platform
756      * @field status Trusted platform state(false:no trusted,true:trusted).
757      * @field weight weight of platform.
758      * @field publicKeys list of public key.
759      * @field proposals list of proposal.
760      */
761     struct Platform {
762 
763         bool status;
764 
765         uint weight;
766 
767         address[] publicKeys;
768 
769         mapping(string => Proposal) proposals;
770     }
771 
772     Admin private admin;
773 
774     address[] private callers;
775 
776     mapping(bytes32 => Platform) private platforms;
777 
778     function XCPlugin() public {
779 
780         init();
781     }
782 
783     function init() internal {
784         // Admin { status | platformName | tokenSymbol | account}
785         admin.status = true;
786 
787         admin.platformName = "ETH";
788 
789         admin.tokenSymbol = "INK";
790 
791         admin.account = msg.sender;
792 
793         bytes32 platformName = "INK";
794 
795         platforms[platformName].status = true;
796 
797         platforms[platformName].weight = 1;
798 
799         platforms[platformName].publicKeys.push(0x4230a12f5b0693dd88bb35c79d7e56a68614b199);
800 
801         platforms[platformName].publicKeys.push(0x07caf88941eafcaaa3370657fccc261acb75dfba);
802     }
803 
804     function start() external {
805 
806         require(admin.account == msg.sender);
807 
808         if (!admin.status) {
809 
810             admin.status = true;
811         }
812     }
813 
814     function stop() external {
815 
816         require(admin.account == msg.sender);
817 
818         if (admin.status) {
819 
820             admin.status = false;
821         }
822     }
823 
824     function getStatus() external view returns (bool) {
825 
826         return admin.status;
827     }
828 
829     function getPlatformName() external view returns (bytes32) {
830 
831         return admin.platformName;
832     }
833 
834     function setAdmin(address account) external {
835 
836         require(account != address(0));
837 
838         require(admin.account == msg.sender);
839 
840         if (admin.account != account) {
841 
842             admin.account = account;
843         }
844     }
845 
846     function getAdmin() external view returns (address) {
847 
848         return admin.account;
849     }
850 
851     function addCaller(address caller) external {
852 
853         require(admin.account == msg.sender);
854 
855         if (!_existCaller(caller)) {
856 
857             callers.push(caller);
858         }
859     }
860 
861     function deleteCaller(address caller) external {
862 
863         require(admin.account == msg.sender);
864 
865         if (_existCaller(caller)) {
866 
867             bool exist;
868 
869             for (uint i = 0; i <= callers.length; i++) {
870 
871                 if (exist) {
872 
873                     if (i == callers.length) {
874 
875                         delete callers[i - 1];
876 
877                         callers.length--;
878                     } else {
879 
880                         callers[i - 1] = callers[i];
881                     }
882                 } else if (callers[i] == caller) {
883 
884                     exist = true;
885                 }
886             }
887 
888         }
889     }
890 
891     function existCaller(address caller) external view returns (bool) {
892 
893         return _existCaller(caller);
894     }
895 
896     function getCallers() external view returns (address[]) {
897 
898         require(admin.account == msg.sender);
899 
900         return callers;
901     }
902 
903     function addPlatform(bytes32 name) external {
904 
905         require(admin.account == msg.sender);
906 
907         require(name != "");
908 
909         require(name != admin.platformName);
910 
911         if (!_existPlatform(name)) {
912 
913             platforms[name].status = true;
914 
915             if (platforms[name].weight == 0) {
916 
917                 platforms[name].weight = 1;
918             }
919         }
920     }
921 
922     function deletePlatform(bytes32 name) external {
923 
924         require(admin.account == msg.sender);
925 
926         require(name != admin.platformName);
927 
928         if (_existPlatform(name)) {
929 
930             platforms[name].status = false;
931         }
932     }
933 
934     function existPlatform(bytes32 name) external view returns (bool){
935 
936         return _existPlatform(name);
937     }
938 
939     function setWeight(bytes32 platformName, uint weight) external {
940 
941         require(admin.account == msg.sender);
942 
943         require(_existPlatform(platformName));
944 
945         require(weight > 0);
946 
947         if (platforms[platformName].weight != weight) {
948 
949             platforms[platformName].weight = weight;
950         }
951     }
952 
953     function getWeight(bytes32 platformName) external view returns (uint) {
954 
955         require(admin.account == msg.sender);
956 
957         require(_existPlatform(platformName));
958 
959         return platforms[platformName].weight;
960     }
961 
962     function addPublicKey(bytes32 platformName, address publicKey) external {
963 
964         require(admin.account == msg.sender);
965 
966         require(_existPlatform(platformName));
967 
968         require(publicKey != address(0));
969 
970         address[] storage listOfPublicKey = platforms[platformName].publicKeys;
971 
972         for (uint i; i < listOfPublicKey.length; i++) {
973 
974             if (publicKey == listOfPublicKey[i]) {
975 
976                 return;
977             }
978         }
979 
980         listOfPublicKey.push(publicKey);
981     }
982 
983     function deletePublicKey(bytes32 platformName, address publickey) external {
984 
985         require(admin.account == msg.sender);
986 
987         require(_existPlatform(platformName));
988 
989         address[] storage listOfPublicKey = platforms[platformName].publicKeys;
990 
991         bool exist;
992 
993         for (uint i = 0; i <= listOfPublicKey.length; i++) {
994 
995             if (exist) {
996                 if (i == listOfPublicKey.length) {
997 
998                     delete listOfPublicKey[i - 1];
999 
1000                     listOfPublicKey.length--;
1001                 } else {
1002 
1003                     listOfPublicKey[i - 1] = listOfPublicKey[i];
1004                 }
1005             } else if (listOfPublicKey[i] == publickey) {
1006 
1007                 exist = true;
1008             }
1009         }
1010     }
1011 
1012     function existPublicKey(bytes32 platformName, address publicKey) external view returns (bool) {
1013 
1014         require(admin.account == msg.sender);
1015 
1016         return _existPublicKey(platformName, publicKey);
1017     }
1018 
1019     function countOfPublicKey(bytes32 platformName) external view returns (uint){
1020 
1021         require(admin.account == msg.sender);
1022 
1023         require(_existPlatform(platformName));
1024 
1025         return platforms[platformName].publicKeys.length;
1026     }
1027 
1028     function publicKeys(bytes32 platformName) external view returns (address[]){
1029 
1030         require(admin.account == msg.sender);
1031 
1032         require(_existPlatform(platformName));
1033 
1034         return platforms[platformName].publicKeys;
1035     }
1036 
1037     function voteProposal(bytes32 fromPlatform, address fromAccount, address toAccount, uint value, bytes32 tokenSymbol, string txid, bytes sig) external {
1038 
1039         require(admin.status);
1040 
1041         require(_existPlatform(fromPlatform));
1042 
1043         bytes32 msgHash = hashMsg(fromPlatform, fromAccount, admin.platformName, toAccount, value, tokenSymbol, txid);
1044 
1045         // address publicKey = ecrecover(msgHash, v, r, s);
1046         address publicKey = recover(msgHash, sig);
1047 
1048         require(_existPublicKey(fromPlatform, publicKey));
1049 
1050         Proposal storage proposal = platforms[fromPlatform].proposals[txid];
1051 
1052         if (proposal.value == 0) {
1053 
1054             proposal.fromAccount = fromAccount;
1055 
1056             proposal.toAccount = toAccount;
1057 
1058             proposal.value = value;
1059 
1060             proposal.tokenSymbol = tokenSymbol;
1061         } else {
1062 
1063             require(proposal.fromAccount == fromAccount && proposal.toAccount == toAccount && proposal.value == value && proposal.tokenSymbol == tokenSymbol);
1064         }
1065 
1066         changeVoters(fromPlatform, publicKey, txid);
1067     }
1068 
1069     function verifyProposal(bytes32 fromPlatform, address fromAccount, address toAccount, uint value, bytes32 tokenSymbol, string txid) external view returns (bool, bool) {
1070 
1071         require(admin.status);
1072 
1073         require(_existPlatform(fromPlatform));
1074 
1075         Proposal storage proposal = platforms[fromPlatform].proposals[txid];
1076 
1077         if (proposal.status) {
1078 
1079             return (true, (proposal.voters.length >= proposal.weight));
1080         }
1081 
1082         if (proposal.value == 0) {
1083 
1084             return (false, false);
1085         }
1086 
1087         require(proposal.fromAccount == fromAccount && proposal.toAccount == toAccount && proposal.value == value && proposal.tokenSymbol == tokenSymbol);
1088 
1089         return (false, (proposal.voters.length >= platforms[fromPlatform].weight));
1090     }
1091 
1092     function commitProposal(bytes32 platformName, string txid) external returns (bool) {
1093 
1094         require(admin.status);
1095 
1096         require(_existCaller(msg.sender) || msg.sender == admin.account);
1097 
1098         require(_existPlatform(platformName));
1099 
1100         require(!platforms[platformName].proposals[txid].status);
1101 
1102         platforms[platformName].proposals[txid].status = true;
1103 
1104         platforms[platformName].proposals[txid].weight = platforms[platformName].proposals[txid].voters.length;
1105 
1106         return true;
1107     }
1108 
1109     function getProposal(bytes32 platformName, string txid) external view returns (bool status, address fromAccount, address toAccount, uint value, address[] voters, uint weight){
1110 
1111         require(admin.status);
1112 
1113         require(_existPlatform(platformName));
1114 
1115         fromAccount = platforms[platformName].proposals[txid].fromAccount;
1116 
1117         toAccount = platforms[platformName].proposals[txid].toAccount;
1118 
1119         value = platforms[platformName].proposals[txid].value;
1120 
1121         voters = platforms[platformName].proposals[txid].voters;
1122 
1123         status = platforms[platformName].proposals[txid].status;
1124 
1125         weight = platforms[platformName].proposals[txid].weight;
1126 
1127         return;
1128     }
1129 
1130     function deleteProposal(bytes32 platformName, string txid) external {
1131 
1132         require(msg.sender == admin.account);
1133 
1134         require(_existPlatform(platformName));
1135 
1136         delete platforms[platformName].proposals[txid];
1137     }
1138 
1139     function transfer(address account, uint value) external payable {
1140 
1141         require(admin.account == msg.sender);
1142 
1143         require(account != address(0));
1144 
1145         require(value > 0 && value >= address(this).balance);
1146 
1147         this.transfer(account, value);
1148     }
1149 
1150     /**
1151      *   ######################
1152      *  #  private function  #
1153      * ######################
1154      */
1155 
1156     function hashMsg(bytes32 fromPlatform, address fromAccount, bytes32 toPlatform, address toAccount, uint value, bytes32 tokenSymbol, string txid) internal pure returns (bytes32) {
1157 
1158         return sha256(bytes32ToStr(fromPlatform), ":0x", uintToStr(uint160(fromAccount), 16), ":", bytes32ToStr(toPlatform), ":0x", uintToStr(uint160(toAccount), 16), ":", uintToStr(value, 10), ":", bytes32ToStr(tokenSymbol), ":", txid);
1159     }
1160 
1161     function changeVoters(bytes32 platformName, address publicKey, string txid) internal {
1162 
1163         address[] storage voters = platforms[platformName].proposals[txid].voters;
1164 
1165         bool change = true;
1166 
1167         for (uint i = 0; i < voters.length; i++) {
1168 
1169             if (voters[i] == publicKey) {
1170 
1171                 change = false;
1172             }
1173         }
1174 
1175         if (change) {
1176 
1177             voters.push(publicKey);
1178         }
1179     }
1180 
1181     function bytes32ToStr(bytes32 b) internal pure returns (string) {
1182 
1183         uint length = b.length;
1184 
1185         for (uint i = 0; i < b.length; i++) {
1186 
1187             if (b[b.length - 1 - i] == "") {
1188 
1189                 length -= 1;
1190             } else {
1191 
1192                 break;
1193             }
1194         }
1195 
1196         bytes memory bs = new bytes(length);
1197 
1198         for (uint j = 0; j < length; j++) {
1199 
1200             bs[j] = b[j];
1201         }
1202 
1203         return string(bs);
1204     }
1205 
1206     function uintToStr(uint value, uint base) internal pure returns (string) {
1207 
1208         uint _value = value;
1209 
1210         uint length = 0;
1211 
1212         bytes16 tenStr = "0123456789abcdef";
1213 
1214         while (true) {
1215 
1216             if (_value > 0) {
1217 
1218                 length ++;
1219 
1220                 _value = _value / base;
1221             } else {
1222 
1223                 break;
1224             }
1225         }
1226 
1227         if (base == 16) {
1228             length = 40;
1229         }
1230 
1231         bytes memory bs = new bytes(length);
1232 
1233         for (uint i = 0; i < length; i++) {
1234 
1235             bs[length - 1 - i] = tenStr[value % base];
1236 
1237             value = value / base;
1238         }
1239 
1240         return string(bs);
1241     }
1242 
1243     function _existCaller(address caller) internal view returns (bool) {
1244 
1245         for (uint i = 0; i < callers.length; i++) {
1246 
1247             if (callers[i] == caller) {
1248 
1249                 return true;
1250             }
1251         }
1252 
1253         return false;
1254     }
1255 
1256     function _existPlatform(bytes32 name) internal view returns (bool){
1257 
1258         return platforms[name].status;
1259     }
1260 
1261     function _existPublicKey(bytes32 platformName, address publicKey) internal view returns (bool) {
1262 
1263 
1264         address[] memory listOfPublicKey = platforms[platformName].publicKeys;
1265 
1266         for (uint i = 0; i < listOfPublicKey.length; i++) {
1267 
1268             if (listOfPublicKey[i] == publicKey) {
1269 
1270                 return true;
1271             }
1272         }
1273 
1274         return false;
1275     }
1276 
1277     function recover(bytes32 hash, bytes sig) internal pure returns (address) {
1278 
1279         bytes32 r;
1280 
1281         bytes32 s;
1282 
1283         uint8 v;
1284 
1285         assembly {
1286 
1287             r := mload(add(sig, 32))
1288 
1289             s := mload(add(sig, 64))
1290 
1291             v := byte(0, mload(add(sig, 96)))
1292         }
1293 
1294         if (v < 27) {
1295 
1296             v += 27;
1297         }
1298 
1299         return ecrecover(hash, v, r, s);
1300     }
1301 }