1 pragma solidity ^0.5.0;
2 
3 
4 library SafeMath {
5 
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a * b;
8         assert(a == 0 || c / a == b);
9         return c;
10     }
11 
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a / b;
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 
28 }
29 
30 contract Ownable {
31 
32     using SafeMath for *;
33     uint ethWei = 1 ether;
34 
35     address public owner;
36     address public manager;
37     address public ownerWallet;
38 
39     constructor() public {
40         owner = msg.sender;
41         manager = msg.sender;
42         ownerWallet = 0xC28a057CA181e6fa84bbC22F5f0372B3B13A500f;
43     }
44 
45     modifier onlyOwner() {
46         require(msg.sender == owner, "only for owner");
47         _;
48     }
49 
50     modifier onlyOwnerOrManager() {
51         require((msg.sender == owner)||(msg.sender == manager), "only for owner or manager");
52         _;
53     }
54 
55     function transferOwnership(address newOwner) public onlyOwner {
56         owner = newOwner;
57     }
58 
59     function setManager(address _manager) public onlyOwnerOrManager {
60         manager = _manager;
61     }
62 }
63 
64 contract SRulesUtils {
65 
66     uint256 ethWei = 1 ether;
67 
68     function strCompare(string memory _str, string memory str) internal pure returns (bool) {
69         
70         if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) {
71             return true;
72         }
73         return false;
74     }
75 
76     function divider(uint numerator, uint denominator, uint precision) internal pure returns(uint) {
77         return numerator*(uint(10)**uint(precision))/denominator;
78     }
79 }
80 
81 contract SRules is SRulesUtils,Ownable {
82 
83     event reEntryEvent(uint _clientID,address indexed _client,address _referrer, uint256 _amount, uint256 _time,uint _portfolioId);
84     event rebateReport(uint[] clientReport,uint[] rebateBonusReport,uint[] bvReport, uint prevRebatePercent);
85     event goldmineReport(uint[] fromClient,uint[] clientAry,uint[] fromLvl,uint[] bonusPercentAry,uint[] bvAmtAry,uint[] payAmtAry);
86     event rankingReport(uint[] clientAry, uint[] fromClient, uint[] bonusPercentAry);
87     event updateReentryEvent(address indexed _client, uint256 _amount, uint256 _time,uint _portfolioId);
88     event payoutReport(uint wallet, address[] addrAry,uint256[] payoutArray);
89     struct Client {
90         bool isExist;
91         uint id;
92         address addr;
93         uint referrerID;
94         string status;
95         uint256 createdOn;
96         string inviteCode;
97     }
98 
99     mapping (address => Client) public clients;
100     mapping (uint => address) private clientList;
101     uint private currClientID = 10000;
102     uint private ownerID = 0;
103 
104     mapping(string => address) private codeMapping;
105 
106     struct TreeSponsor {
107         uint clientID;
108         uint uplineID;
109         uint level;
110     }
111     mapping (uint => TreeSponsor) public treeSponsors;
112     mapping (uint => uint[] ) public sponsorDownlines;
113 
114     struct Portfolio {
115         uint id;
116         uint clientID;
117         uint256 amount;
118         uint256 bonusValue;
119         uint256 withdrawAmt;
120         // uint referenceNo;
121         // uint trnxHash;
122         string status;
123         uint256 createdOn;
124         uint256 updatedOn;
125     }
126     mapping (uint => Portfolio) public portfolios;
127     mapping (uint => uint[]) private clientPortfolios;
128     mapping (uint => uint256) public clientBV;
129     mapping (uint => uint256) public cacheClientBV;
130     mapping (uint => uint256) public rebate2Client;
131 
132     uint private clientBonusCount = 0;
133     uint private portfolioID = 0;
134     uint256 private minReentryValue = 1 * ethWei;
135     uint256 private maxReentryValue = 500 * ethWei;
136 
137 
138     struct WalletDetail {
139         uint percentage;
140         address payable toWallet;
141     }
142     mapping (uint => WalletDetail) public walletDetails;
143     uint private walletDetailsCount = 0;
144     mapping (uint => uint256) public poolBalance;
145     address payable defaultGasAddr = 0x0B6593C16CecC4407FE9f4727ceE367327EF4779;
146 
147     struct WithdrawalDetail {
148         uint minDay;
149         uint charges;
150     }
151     mapping (uint => WithdrawalDetail) public withdrawalDetails;
152 
153     struct RebateSetting{
154         uint max;
155         uint min;
156         uint percent;
157     }
158     mapping (uint => RebateSetting) public rebateSettings;
159     uint private rebateSettingsCount = 0;
160     uint public rebateDisplay = 0.33 * 100;
161 
162     uint private prevRebatePercent = 0;
163     uint public defaultRebatePercent = 0.33 * 100;
164     uint public defaultRebateDays = 21;
165     uint public rebateDays = 1;
166     uint public lowestRebateFlag = 0;
167 
168     mapping (uint => uint) public clientGoldmine;
169     mapping (uint => uint) public goldmineSettingsPer;
170     mapping (uint => uint) public goldmineDownlineSet;
171 
172     uint private maxGoldmineLevel = 50;
173 
174     uint256 public totalSales = 0;
175     uint256 public totalPayout = 0;
176 
177     uint256 public cacheTotalSales = 0;
178     uint256 public cacheTotalPayout = 0;
179 
180     modifier isHuman() {
181         require(msg.sender == tx.origin, "sorry humans only - FOR REAL THIS TIME");
182         _;
183     }
184 
185     function() external payable {
186     }
187 
188     constructor() public {
189 
190         /*prize*/
191         walletDetailsCount++;
192         walletDetails[walletDetailsCount] = WalletDetail({
193             percentage : 70 * 100,
194             toWallet : address(0)
195         });
196         
197         /*airDrop*/
198         walletDetailsCount++;
199         walletDetails[walletDetailsCount] = WalletDetail({
200             percentage : 2 * 100,
201             toWallet : address(0)
202         });
203         
204         /*recycle*/
205         walletDetailsCount++;
206         walletDetails[walletDetailsCount] = WalletDetail({
207             percentage : 5 * 100,
208             toWallet : address(0)
209         });
210         
211         /*gas*/
212         walletDetailsCount++;
213         walletDetails[walletDetailsCount] = WalletDetail({
214             percentage : 1 * 100,
215             toWallet : defaultGasAddr
216         });
217         
218         /*develop*/
219         walletDetailsCount++;
220         walletDetails[walletDetailsCount] = WalletDetail({
221             percentage : 3.5 * 100,
222             toWallet : 0x40568dfb53726E3341dE75E04310C570B183D614
223         });
224         
225         /*eco*/
226         walletDetailsCount++;
227         walletDetails[walletDetailsCount] = WalletDetail({
228             percentage : 15 * 100,
229             toWallet : 0x5076E5a092FDB2d456787bfa870390a72Ae51BF9
230         });
231 
232         /*market*/
233         walletDetailsCount++;
234         walletDetails[walletDetailsCount] = WalletDetail({
235             percentage : 3.5 * 100,
236             toWallet : 0x05649CDE4c22f77b73Df306CA7057951c3cC0e21
237         });
238 
239         /*withdrawal rate*/
240         //below 30days
241         withdrawalDetails[1] = WithdrawalDetail({
242             minDay : 0,
243             charges : 5 * 100
244         });
245 
246         //more 30days
247         withdrawalDetails[2] = WithdrawalDetail({
248             minDay : 30,
249             charges : 1 * 100
250         });
251 
252 
253         rebateSettingsCount++;
254         rebateSettings[rebateSettingsCount] = RebateSetting({
255             max : 69.99 * 100,
256             min : 61.34 * 100,
257             percent : 0.1 * 100
258             });
259 
260         rebateSettingsCount++;
261         rebateSettings[rebateSettingsCount] = RebateSetting({
262             max : 61.33 * 100,
263             min : 59.23 * 100,
264             percent : 0.2 * 100
265             });
266 
267         rebateSettingsCount++;
268         rebateSettings[rebateSettingsCount] = RebateSetting({
269             max : 59.22 * 100,
270             min : 57.11 * 100,
271             percent : 0.3 * 100
272             });
273 
274         rebateSettingsCount++;
275         rebateSettings[rebateSettingsCount] = RebateSetting({
276             max : 57.1 * 100,
277             min : 55 * 100,
278             percent : 0.4 * 100
279             });
280 
281         rebateSettingsCount++;
282         rebateSettings[rebateSettingsCount] = RebateSetting({
283             max : 54.99 * 100,
284             min : 52.88 * 100,
285             percent : 0.5 * 100
286             });
287 
288         rebateSettingsCount++;
289         rebateSettings[rebateSettingsCount] = RebateSetting({
290             max : 52.87 * 100,
291             min : 50.77 * 100,
292             percent : 0.6 * 100
293             });
294 
295         rebateSettingsCount++;
296         rebateSettings[rebateSettingsCount] = RebateSetting({
297             max : 50.76 * 100,
298             min : 48.65 * 100,
299             percent : 0.7 * 100
300             });
301 
302         rebateSettingsCount++;
303         rebateSettings[rebateSettingsCount] = RebateSetting({
304             max : 48.64 * 100,
305             min : 46.54 * 100,
306             percent : 0.8 * 100
307             });
308 
309         rebateSettingsCount++;
310         rebateSettings[rebateSettingsCount] = RebateSetting({
311             max : 46.53 * 100,
312             min : 44.42 * 100,
313             percent : 0.9 * 100
314             });
315 
316         rebateSettingsCount++;
317         rebateSettings[rebateSettingsCount] = RebateSetting({
318             max : 44.41 * 100,
319             min : 42.31 * 100,
320             percent : 1.0 * 100
321             });
322 
323         rebateSettingsCount++;
324         rebateSettings[rebateSettingsCount] = RebateSetting({
325             max : 42.3 * 100,
326             min : 40.19 * 100,
327             percent : 1.1 * 100
328             });
329 
330         rebateSettingsCount++;
331         rebateSettings[rebateSettingsCount] = RebateSetting({
332             max : 40.18 * 100,
333             min : 38.08 * 100,
334             percent : 1.2 * 100
335             });
336 
337         rebateSettingsCount++;
338         rebateSettings[rebateSettingsCount] = RebateSetting({
339             max : 38.07 * 100,
340             min : 35.96 * 100,
341             percent : 1.3 * 100
342             });
343 
344         rebateSettingsCount++;
345         rebateSettings[rebateSettingsCount] = RebateSetting({
346             max : 35.95 * 100,
347             min : 33.85 * 100,
348             percent : 1.4 * 100
349             });
350 
351         rebateSettingsCount++;
352         rebateSettings[rebateSettingsCount] = RebateSetting({
353             max : 33.84 * 100,
354             min : 31.73 * 100,
355             percent : 1.5 * 100
356             });
357 
358         rebateSettingsCount++;
359         rebateSettings[rebateSettingsCount] = RebateSetting({
360             max : 31.72 * 100,
361             min : 29.62 * 100,
362             percent : 1.6 * 100
363             });
364 
365         rebateSettingsCount++;
366         rebateSettings[rebateSettingsCount] = RebateSetting({
367             max : 29.61 * 100,
368             min : 27.5 * 100,
369             percent : 1.7 * 100
370             });
371 
372         rebateSettingsCount++;
373         rebateSettings[rebateSettingsCount] = RebateSetting({
374             max : 27.49 * 100,
375             min : 25.39 * 100,
376             percent : 1.8 * 100
377             });
378 
379         rebateSettingsCount++;
380         rebateSettings[rebateSettingsCount] = RebateSetting({
381             max : 25.38 * 100,
382             min : 23.27 * 100,
383             percent : 1.9 * 100
384             });
385 
386         rebateSettingsCount++;
387         rebateSettings[rebateSettingsCount] = RebateSetting({
388             max : 23.26 * 100,
389             min : 21.16 * 100,
390             percent : 2.0 * 100
391             });
392 
393         rebateSettingsCount++;
394         rebateSettings[rebateSettingsCount] = RebateSetting({
395             max : 21.15 * 100,
396             min : 19.04 * 100,
397             percent : 2.1 * 100
398             });
399 
400         rebateSettingsCount++;
401         rebateSettings[rebateSettingsCount] = RebateSetting({
402             max : 19.03 * 100,
403             min : 16.93 * 100,
404             percent : 2.2 * 100
405             });
406 
407         rebateSettingsCount++;
408         rebateSettings[rebateSettingsCount] = RebateSetting({
409             max : 16.92 * 100,
410             min : 14.81 * 100,
411             percent : 2.3 * 100
412             });
413 
414         rebateSettingsCount++;
415         rebateSettings[rebateSettingsCount] = RebateSetting({
416             max : 14.8 * 100,
417             min : 12.7 * 100,
418             percent : 2.4 * 100
419             });
420 
421         rebateSettingsCount++;
422         rebateSettings[rebateSettingsCount] = RebateSetting({
423             max : 12.69 * 100,
424             min : 10.58 * 100,
425             percent : 2.5 * 100
426             });
427 
428         rebateSettingsCount++;
429         rebateSettings[rebateSettingsCount] = RebateSetting({
430             max : 10.57 * 100,
431             min : 5.3 * 100,
432             percent : 2.6 * 100
433             });
434 
435         rebateSettingsCount++;
436         rebateSettings[rebateSettingsCount] = RebateSetting({
437             max : 5.29 * 100,
438             min : 0 * 100,
439             percent : 2.7 * 100
440             });
441 
442         goldmineSettingsPer[0] = 0;
443         goldmineDownlineSet[0] = 0;
444         goldmineSettingsPer[1] = 100 * 100;
445         goldmineDownlineSet[1] = 1;
446         goldmineSettingsPer[2] = 50 * 100;
447         goldmineDownlineSet[2] = 2;
448         goldmineSettingsPer[3] = 5 * 100;
449         goldmineDownlineSet[3] = 3;
450 
451 
452         Client memory client;
453         currClientID++;
454 
455         client = Client({
456             isExist : true,
457             id : currClientID,
458             addr : ownerWallet,
459             referrerID : 0,
460             status : "Active",
461             createdOn : now,
462             inviteCode : ""
463             // downlines : new address[](0)
464         });
465         clients[ownerWallet] = client;
466         clientList[currClientID] = ownerWallet;
467         ownerID = currClientID;
468         TreeSponsor memory sponsor;
469         sponsor = TreeSponsor({
470             clientID : currClientID,
471             uplineID : 0,
472             level : 0
473         });
474         treeSponsors[currClientID] = sponsor;
475 
476         for(uint i = 1; i <= walletDetailsCount;i++){
477             if(walletDetails[i].toWallet == address(0)){
478                 poolBalance[i] = 0;
479             }
480         }
481 
482         poolBalance[4] = 0;
483     }
484 
485     function regMember(address _refAddr) private{
486         require(!clients[msg.sender].isExist, 'User exist');
487         require(clients[_refAddr].isExist, 'Invalid upline address');
488         require(strCompare(clients[_refAddr].status,"Active"), 'Invalid upline address');
489 
490         uint sponsorID = clients[_refAddr].id;
491 
492         Client memory client;
493         currClientID++;
494 
495         client = Client({
496             isExist : true,
497             id : currClientID,
498             addr : msg.sender,
499             referrerID : sponsorID,
500             status : "Pending",
501             createdOn : now,
502             inviteCode : ""
503         });
504         
505         clients[msg.sender] = client;
506         clientList[currClientID] = msg.sender;
507 
508         //insert tree
509         TreeSponsor memory sponsor;
510         sponsor = TreeSponsor({
511             clientID : currClientID,
512             uplineID : sponsorID,
513             level : treeSponsors[sponsorID].level +1
514         });
515         treeSponsors[currClientID] = sponsor;
516         sponsorDownlines[sponsorID].push(currClientID);
517         clientBV[currClientID] = 0;
518     }
519 
520     function reEntry() public payable isHuman{
521         reEntry('');
522     }
523 
524     function reEntry (string memory _inviteCode) public payable isHuman{
525         require(msg.value >= minReentryValue, "The amount is less than minimum reentry amount");
526         address refAddr;
527         if(clients[msg.sender].isExist == false){
528             require(!strCompare(_inviteCode, ""), "invalid invite code");
529             require(getInviteCode(_inviteCode), "Invite code not exist");
530             refAddr = codeMapping[_inviteCode];
531             require(refAddr != msg.sender, "Invite Code can't be self");
532             regMember(refAddr);
533         }
534         
535         uint clientID = clients[msg.sender].id;
536         require((msg.value + clientBV[clientID]) <= maxReentryValue, "The amount is more than maximum reentry amount");
537         Portfolio memory portfolio;
538 
539         portfolioID ++;
540 
541         portfolio = Portfolio({
542             id : portfolioID,
543             clientID : clientID,
544             amount : msg.value,
545             bonusValue : msg.value,
546             withdrawAmt : 0,
547             status : "Pending",
548             createdOn : now,
549             updatedOn : now
550             });
551 
552         portfolios[portfolioID] = portfolio;
553         clientPortfolios[clientID].push(portfolioID);
554         
555         emit reEntryEvent(clientID, msg.sender, refAddr, msg.value, now,portfolioID);
556     }
557 
558     function updateReentryStatus(address _client, uint256 _amount, uint _portfolio,string calldata _inviteCode) external payable onlyOwnerOrManager{
559 
560         require(clients[_client].isExist, 'Invalid Member');
561         uint clientID = clients[_client].id;
562 
563         require(strCompare(portfolios[_portfolio].status,"Pending"), 'Portfolio is not in pending status');
564         require(portfolios[_portfolio].amount == _amount , 'The amount is not match with portfolio amount');
565         require(portfolios[_portfolio].clientID == clientID, 'The portfolio is not belong to this member');
566         
567         if(strCompare(clients[_client].status,"Pending") == true){
568             clients[_client].status = "Active";
569             clients[_client].inviteCode = _inviteCode;
570             
571             codeMapping[_inviteCode] = _client;
572         }
573 
574         portfolios[_portfolio].status = "Active";
575         portfolios[_portfolio].updatedOn = now;
576 
577         clientBV[clientID] = clientBV[clientID].add(_amount);
578         distSales(_amount);
579 
580         totalSales = totalSales.add(_amount);
581         // percentageDisplay();
582 
583         emit updateReentryEvent(_client, _amount, now,portfolioID);
584     }
585 
586     function distSales (uint256 _amount) private {
587         for(uint i = 1; i <= walletDetailsCount;i++){
588             uint256 transferAmount = 0;
589             transferAmount = _amount.mul(walletDetails[i].percentage).div(10000);
590             if(transferAmount > 0){
591                 if(walletDetails[i].toWallet == address(0)){
592                     poolBalance[i] = poolBalance[i].add(transferAmount);
593                 }else if(walletDetails[i].toWallet == defaultGasAddr){
594                     walletDetails[i].toWallet.transfer(transferAmount);
595 
596                     poolBalance[i] = defaultGasAddr.balance;
597 
598                 }else{
599                     walletDetails[i].toWallet.transfer(transferAmount);
600                 }
601             }
602         }
603     }
604     
605     
606 
607     function percentageDisplay() private {
608         uint bonusPercent = 0;
609 
610         if(rebateDays <= defaultRebateDays){
611         // for 21 days
612             bonusPercent = defaultRebatePercent;
613         }else{
614             uint overall = divider(totalPayout,cacheTotalSales, 4);
615             uint count = 1;
616             while(count <= rebateSettingsCount){
617                 if(overall >= rebateSettings[count].min){
618                     bonusPercent = rebateSettings[count].percent;
619                     break;
620                 }
621 
622                 count++;
623             }
624         }
625         rebateDisplay = bonusPercent;
626     }
627 
628     /*function checkContractBalance() public view returns (uint){
629         return address(this).balance;
630     }*/
631 
632     function getTodayBonus() external onlyOwnerOrManager returns (string memory) {
633 
634         cacheTotalSales = totalSales;
635         cacheTotalPayout = totalPayout;
636 
637         uint bonusPercent = 0;
638         // if(rebateDays <= defaultRebateDays){
639         //     // for 21 days
640         //     bonusPercent = defaultRebatePercent;
641         // }else{
642         //     uint overall = divider(calcPayout,calcSales, 4);
643         //     uint count = 1;
644         //     while(count <= rebateSettingsCount){
645         //         if(overall >= rebateSettings[count].min){
646         //             bonusPercent = rebateSettings[count].percent;
647         //             break;
648         //         }
649 
650         //         count++;
651         //     }
652         // }
653         bonusPercent = rebateDisplay;
654 
655         rebateDays++;
656 
657         if(bonusPercent == rebateSettings[1].percent){
658             lowestRebateFlag ++;
659         }else{
660             lowestRebateFlag = 0;
661         }
662         prevRebatePercent = bonusPercent;
663 
664 
665         return("successful");
666     }
667 
668     function clientCache (uint start, uint end, uint[] calldata clientIDAry, uint[] calldata bonusValueAry) external onlyOwnerOrManager returns (string memory) {
669         clientBonusCount = 0;
670         uint i = 0;
671         uint bonusValue = 0;
672         for(uint clientID = start; clientID <= end;clientID++){
673             if(clientIDAry[i] == clientID){
674                 bonusValue = bonusValueAry[i];
675                 i++;
676             }else{
677                 bonusValue = 0;
678             }
679 
680             cacheClientBV[clientID] = bonusValue;
681             rebate2Client[clientID] = 0;
682             clientBonusCount++;
683         }
684 
685         return("successful");
686     }
687 
688     function rebate (uint start, uint end) external onlyOwnerOrManager{
689         require(clientBonusCount > 0, 'No bonus to count');
690 
691         uint[] memory rebateBonusReport= new uint[](100);
692         uint[] memory bvReport= new uint[](100);
693         uint[] memory clientReport = new uint[](100);
694 
695         uint j = 0;
696         for(uint i = start; i <= end;i++){
697 
698             uint bvAmt = 0;
699             uint payAmt = 0;
700 
701             bvAmt = cacheClientBV[i];
702             if(bvAmt < minReentryValue) continue;
703 
704             payAmt = bvAmt.mul(prevRebatePercent).div(10000);
705             if(payAmt > 0){
706                 rebate2Client[i] = payAmt;
707 
708                 clientReport[j] = i;
709                 bvReport[j] = bvAmt;
710                 rebateBonusReport[j] = payAmt;
711                 j++;
712             }
713         }
714         
715         emit rebateReport(clientReport,rebateBonusReport,bvReport,prevRebatePercent);
716     }
717 
718     function getGoldmineRank(uint start, uint end) external onlyOwnerOrManager returns (string memory){
719 
720         for(uint i = start; i <= end;i++){
721             uint downlineCounts = 0;
722 
723             for(uint j = 0; j < sponsorDownlines[i].length;j++){
724                 if(cacheClientBV[sponsorDownlines[i][j]] >= minReentryValue){
725                     downlineCounts += 1;
726                 }
727             }
728             // downlineCounts = sponsorDownlines[i].length;
729             if(downlineCounts > 3 ){
730                 downlineCounts = 3;
731             }
732 
733             if(cacheClientBV[i] >= maxReentryValue){
734                 downlineCounts = 3;
735             }else if(cacheClientBV[i] < minReentryValue){
736                 downlineCounts = 0;
737             }
738 
739             clientGoldmine[i] = goldmineDownlineSet[downlineCounts];
740         }
741         return ("successful");
742     }
743 
744 
745 
746     function goldmine(uint start, uint end) external onlyOwnerOrManager{
747 
748         uint[] memory fromClient = new uint[](250);
749         uint[] memory clientAry = new uint[](250);
750         uint[] memory bvAmtAry = new uint[](250);
751         uint[] memory payAmtAry = new uint[](250);
752         uint[] memory bonusPercentAry = new uint[](250);
753         uint[] memory fromLvl = new uint[](250);
754 
755         uint k = 0;
756 
757         for(uint clientID = start ; clientID <= end;clientID++){
758 
759             if(rebate2Client[clientID] <= 0 ) continue;
760 
761             uint targetID = clientID;
762             uint lvl = 1;
763 
764             while(lvl <= maxGoldmineLevel){
765                 uint payAmt = 0;
766                 uint bonusPercent = 0;
767                 uint frmLvl = lvl;
768                 uint uplineID = treeSponsors[targetID].uplineID;
769                 if(uplineID == 10001){
770                     break;
771                 }
772                 
773                 targetID = uplineID;
774 
775                 if(lvl <= clientGoldmine[uplineID]){
776                     bonusPercent = goldmineSettingsPer[lvl];
777                 }else if(lvl > 3 && clientGoldmine[uplineID] == 3){
778                     uint perLvl = 3;
779                     bonusPercent = goldmineSettingsPer[perLvl];
780                 }else{
781                     bonusPercent = 0;
782                 }
783                 
784                 lvl++;
785 
786                 if(bonusPercent <= 0){
787                     continue;
788                 }
789                 
790                 payAmt = rebate2Client[clientID].mul(bonusPercent).div(10000);
791 
792                 if(payAmt > 0 ){
793                     fromClient[k] = clientID;
794                     clientAry[k] = targetID;
795                     fromLvl[k] = frmLvl;
796                     bonusPercentAry[k] = bonusPercent;
797                     bvAmtAry[k] = rebate2Client[clientID];
798                     payAmtAry[k] = payAmt;
799                     k++;
800                 }
801             }
802         }
803 
804         emit goldmineReport(fromClient,clientAry,fromLvl,bonusPercentAry,bvAmtAry,payAmtAry);
805     }
806 
807     function payPoolAmount(uint _wallet, address[] calldata _addrAry, uint[] calldata _amountAry) external payable onlyOwnerOrManager {
808         //for prize pool,airDrop,recycle
809         require (_wallet > 0,"Invalid Wallet");
810         require (poolBalance[_wallet] > 0,"Insufficent Pool Balance");
811         require (_amountAry.length > 0,"Empty Amount");
812 
813         uint256[] memory payoutArray = new uint256[](_addrAry.length);
814 
815         for(uint i = 0; i < _addrAry.length; i++){
816             payoutArray[i] = 0;
817 
818             if(!strCompare(clients[_addrAry[i]].status, "Active")){
819                 continue;
820             }
821 
822             uint payAmt = _amountAry[i];
823 
824             if(poolBalance[_wallet] < _amountAry[i]){
825                 payAmt = poolBalance[_wallet];
826             }
827 
828             if (poolBalance[_wallet] >= payAmt){
829                 address payable userAddr = address(uint160(_addrAry[i]));
830                 poolBalance[_wallet] = poolBalance[_wallet].sub(payAmt);
831                 
832                 if(_wallet == 1){
833                     totalPayout = totalPayout.add(payAmt);
834                     cacheTotalPayout = cacheTotalPayout.add(payAmt);
835                 }
836                 
837                 userAddr.transfer(payAmt);
838                 payoutArray[i] = payAmt;
839             }
840         }
841 
842         percentageDisplay();
843 
844         emit payoutReport(_wallet,_addrAry,payoutArray);
845     }
846 
847     function withdrawal(uint portfolio) public payable isHuman{
848 
849         require (clients[msg.sender].isExist,"Invalid Member");
850         require (strCompare(portfolios[portfolio].status, "Active"),"This portfolio is not active portfolio.");
851         uint clientID = clients[msg.sender].id;
852         require (portfolios[portfolio].clientID == clientID,"Invalid Portfolio");
853         
854         uint256 portAmt = portfolios[portfolio].bonusValue;
855         uint chargesPercent = 0;
856         if(now - portfolios[portfolio].updatedOn <= 30 days){
857             chargesPercent = withdrawalDetails[1].charges;
858         }else{
859             chargesPercent = withdrawalDetails[2].charges;
860         }
861 
862         uint256 adminCharges = portAmt.mul(chargesPercent).div(10000);
863 
864         uint256 withdrawalAmount = portAmt.sub(adminCharges);
865 
866         require (clientBV[clientID] >= withdrawalAmount,"Withdrawal Amount is bigger than BV Amount.");
867         require (clientBV[clientID] >= portAmt,"Portfolio Amount is bigger than BV Amount.");
868         
869         if(withdrawalAmount > poolBalance[1]){
870             withdrawalAmount = poolBalance[1];
871         }
872 
873         require (poolBalance[1] >= withdrawalAmount,"Insufficent Pool Balance. Cannot Withdrawal.");
874 
875         // if (poolBalance[1] >= portAmt && poolBalance[1] + portAmt >= poolBalance[1] && poolBalance[1] - portAmt <= poolBalance[1]){
876             portfolios[portfolio].status = "Terminated";
877             portfolios[portfolio].withdrawAmt = withdrawalAmount;
878 
879             portfolios[portfolio].updatedOn = now;
880 
881             clientBV[clientID] = clientBV[clientID].sub(portAmt);
882             poolBalance[1] = poolBalance[1].sub(withdrawalAmount);
883             
884             totalPayout = totalPayout.add(withdrawalAmount);
885             // percentageDisplay();
886 
887             msg.sender.transfer(withdrawalAmount);
888         // }
889     }
890 
891     function airDrop(address[] calldata _topFund,address[] calldata _topSponsor) external view returns (uint256,uint256){
892         uint topFundLength = _topFund.length;
893         uint topSponsorLength = _topSponsor.length;
894 
895         //airDrop 
896         uint256 bonusAmount = poolBalance[2].div(2);
897 
898         //for top fund
899         uint256 bonusTopFund = bonusAmount.div(topFundLength);
900         uint256 bonusTopSponsor = bonusAmount.div(topSponsorLength);
901 
902         return (bonusTopFund,bonusTopSponsor);
903     }
904 
905     function ranking(uint[] calldata _clientIDAry, uint[] calldata _uplinesAry, uint[] calldata _rankAry, uint[] calldata _uplineNum) external{
906         //override
907         uint[] memory clientAry = new uint[](50);
908         uint[] memory fromClient = new uint[](50);
909         uint[] memory bonusPercentAry = new uint[](50);
910 
911         uint j = 0;
912 
913         for(uint client = 0; client < _clientIDAry.length; client++){
914             uint downlinePercentage = 0;
915             
916             for(uint uplines = j; uplines < _uplineNum[client]; uplines++){
917                 uint curPercentage = _rankAry[uplines];
918                 if(curPercentage < downlinePercentage) {
919                     curPercentage = downlinePercentage;
920                 }
921     
922                 fromClient[j] = _clientIDAry[client];
923                 clientAry[j] = _uplinesAry[uplines];
924                 bonusPercentAry[j] = curPercentage.sub(downlinePercentage);
925     
926                 downlinePercentage = curPercentage;
927                 j++;
928             }
929         }
930         emit rankingReport(clientAry, fromClient, bonusPercentAry);
931     }
932 
933     function checkReset() public view returns (string memory) {
934         if(lowestRebateFlag >= 5){
935             return "Reset";
936         }else if(poolBalance[1] <= 0){
937             return "Reset";
938         }
939         return "Nothing happen";
940     }
941     
942     function reset() external payable onlyOwnerOrManager{
943         string memory resettable=checkReset();
944         require(strCompare(resettable,"Reset"), 'Cannot Reset'); 
945         
946         rebateDays = 1;
947         prevRebatePercent = defaultRebatePercent;
948         rebateDisplay = defaultRebatePercent;
949         totalSales = 0;
950         totalPayout = 0;
951         cacheTotalSales = 0;
952         cacheTotalPayout = 0;
953 
954         for(uint clientID = 10002; clientID <= currClientID;clientID++){
955             clientBV[clientID] = 0;
956         }
957 
958         for(uint portfolioId = 1; portfolioId <= portfolioID; portfolioId++){
959             if(!strCompare(portfolios[portfolioId].status,"Active")){
960                 continue;
961             }
962             portfolios[portfolioId].status = "Flushed";
963             portfolios[portfolioId].updatedOn = now;
964         }
965 
966         if(poolBalance[1] > 0){
967             //prize got money transfer to eco[6]
968             walletDetails[6].toWallet.transfer(poolBalance[1]);
969             poolBalance[1] = poolBalance[1].sub(poolBalance[1]);
970         }
971 
972         if(poolBalance[2] > 0){
973             //airdrop got money transfer to eco[6]
974             walletDetails[6].toWallet.transfer(poolBalance[2]);
975             poolBalance[2] = poolBalance[2].sub(poolBalance[2]);
976         }
977     }
978 
979     function payRecyclePool(uint[] calldata _addrAry, uint[] calldata _percentAry) external payable onlyOwnerOrManager{
980         if(poolBalance[3] > 0){
981 
982             uint256 poolAmt = poolBalance[3];
983             //send to last 10 accounts that have invest
984             for(uint i = 0; i < _addrAry.length; i++){
985                 address payable userAddr = address(uint160(_addrAry[i]));
986                 if(_percentAry[i] > 0){
987                     uint payAmt = poolAmt.mul(_percentAry[i]).div(10000);
988                     if(poolBalance[3] >= payAmt){
989                         userAddr.transfer(payAmt);
990                         poolBalance[3] = poolBalance[3].sub(payAmt);
991                     }
992                 }
993             }  
994         }
995     }
996 
997     function getInviteCode(string memory _inviteCode) public view returns (bool) {
998         address addr = codeMapping[_inviteCode];
999         return uint(addr) != 0;
1000     }
1001 
1002     function updateInviteCode (address _clientAddress, string calldata _inviteCode) external onlyOwnerOrManager{
1003         require(clients[_clientAddress].isExist, 'Invalid member');
1004         clients[_clientAddress].inviteCode = _inviteCode;
1005         codeMapping[_inviteCode] = _clientAddress;
1006     }
1007 
1008     function clearPool (uint _wallet, uint _toWallet) external payable onlyOwnerOrManager{
1009         require (_wallet > 0,"Invalid Wallet");
1010         require (_toWallet > 0,"Invalid To Wallet");
1011         require (poolBalance[_wallet] > 0,"Insufficent Pool Balance");        
1012         if(poolBalance[_wallet] > 0){
1013             walletDetails[_toWallet].toWallet.transfer(poolBalance[_wallet]);
1014             poolBalance[_wallet] = poolBalance[_wallet].sub(poolBalance[_wallet]);
1015         }
1016     }
1017 
1018     function updateWallet(uint _wallet, address payable _updateAddress) external onlyOwnerOrManager{
1019         require (_wallet > 3,"Invalid Wallet");
1020         require (walletDetails[_wallet].toWallet != address(0),"Invalid Wallet");
1021         require (_updateAddress != address(0),"Invalid Wallet Address");
1022 
1023         walletDetails[_wallet].toWallet = _updateAddress;
1024     }
1025 }