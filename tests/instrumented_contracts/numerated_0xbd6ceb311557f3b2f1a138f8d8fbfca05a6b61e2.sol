1 pragma solidity ^0.4.21;
2 
3 
4 library CampaignLibrary {
5 
6     struct Campaign {
7         bytes32 bidId;
8         uint price;
9         uint budget;
10         uint startDate;
11         uint endDate;
12         bool valid;
13         address  owner;
14     }
15 
16     function convertCountryIndexToBytes(uint[] countries) internal returns (uint,uint,uint){
17         uint countries1 = 0;
18         uint countries2 = 0;
19         uint countries3 = 0;
20         for(uint i = 0; i < countries.length; i++){
21             uint index = countries[i];
22 
23             if(index<256){
24                 countries1 = countries1 | uint(1) << index;
25             } else if (index<512) {
26                 countries2 = countries2 | uint(1) << (index - 256);
27             } else {
28                 countries3 = countries3 | uint(1) << (index - 512);
29             }
30         }
31 
32         return (countries1,countries2,countries3);
33     }
34 
35     
36 }
37 
38 
39 contract AdvertisementStorage {
40 
41     mapping (bytes32 => CampaignLibrary.Campaign) campaigns;
42     mapping (address => bool) allowedAddresses;
43     address public owner;
44 
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     modifier onlyAllowedAddress() {
51         require(allowedAddresses[msg.sender]);
52         _;
53     }
54 
55     event CampaignCreated
56         (
57             bytes32 bidId,
58             uint price,
59             uint budget,
60             uint startDate,
61             uint endDate,
62             bool valid,
63             address owner
64     );
65 
66     event CampaignUpdated
67         (
68             bytes32 bidId,
69             uint price,
70             uint budget,
71             uint startDate,
72             uint endDate,
73             bool valid,
74             address  owner
75     );
76 
77     function AdvertisementStorage() public {
78         owner = msg.sender;
79         allowedAddresses[msg.sender] = true;
80     }
81 
82     function setAllowedAddresses(address newAddress, bool isAllowed) public onlyOwner {
83         allowedAddresses[newAddress] = isAllowed;
84     }
85 
86 
87     function getCampaign(bytes32 campaignId)
88         public
89         view
90         returns (
91             bytes32,
92             uint,
93             uint,
94             uint,
95             uint,
96             bool,
97             address
98         ) {
99 
100         CampaignLibrary.Campaign storage campaign = campaigns[campaignId];
101 
102         return (
103             campaign.bidId,
104             campaign.price,
105             campaign.budget,
106             campaign.startDate,
107             campaign.endDate,
108             campaign.valid,
109             campaign.owner
110         );
111     }
112 
113 
114     function setCampaign (
115         bytes32 bidId,
116         uint price,
117         uint budget,
118         uint startDate,
119         uint endDate,
120         bool valid,
121         address owner
122     )
123     public
124     onlyAllowedAddress {
125 
126         CampaignLibrary.Campaign memory campaign = campaigns[campaign.bidId];
127 
128         campaign = CampaignLibrary.Campaign({
129             bidId: bidId,
130             price: price,
131             budget: budget,
132             startDate: startDate,
133             endDate: endDate,
134             valid: valid,
135             owner: owner
136         });
137 
138         emitEvent(campaign);
139 
140         campaigns[campaign.bidId] = campaign;
141         
142     }
143 
144     function getCampaignPriceById(bytes32 bidId)
145         public
146         view
147         returns (uint) {
148         return campaigns[bidId].price;
149     }
150 
151     function setCampaignPriceById(bytes32 bidId, uint price)
152         public
153         onlyAllowedAddress
154         {
155         campaigns[bidId].price = price;
156         emitEvent(campaigns[bidId]);
157     }
158 
159     function getCampaignBudgetById(bytes32 bidId)
160         public
161         view
162         returns (uint) {
163         return campaigns[bidId].budget;
164     }
165 
166     function setCampaignBudgetById(bytes32 bidId, uint newBudget)
167         public
168         onlyAllowedAddress
169         {
170         campaigns[bidId].budget = newBudget;
171         emitEvent(campaigns[bidId]);
172     }
173 
174     function getCampaignStartDateById(bytes32 bidId)
175         public
176         view
177         returns (uint) {
178         return campaigns[bidId].startDate;
179     }
180 
181     function setCampaignStartDateById(bytes32 bidId, uint newStartDate)
182         public
183         onlyAllowedAddress
184         {
185         campaigns[bidId].startDate = newStartDate;
186         emitEvent(campaigns[bidId]);
187     }
188 
189     function getCampaignEndDateById(bytes32 bidId)
190         public
191         view
192         returns (uint) {
193         return campaigns[bidId].endDate;
194     }
195 
196     function setCampaignEndDateById(bytes32 bidId, uint newEndDate)
197         public
198         onlyAllowedAddress
199         {
200         campaigns[bidId].endDate = newEndDate;
201         emitEvent(campaigns[bidId]);
202     }
203 
204     function getCampaignValidById(bytes32 bidId)
205         public
206         view
207         returns (bool) {
208         return campaigns[bidId].valid;
209     }
210 
211     function setCampaignValidById(bytes32 bidId, bool isValid)
212         public
213         onlyAllowedAddress
214         {
215         campaigns[bidId].valid = isValid;
216         emitEvent(campaigns[bidId]);
217     }
218 
219     function getCampaignOwnerById(bytes32 bidId)
220         public
221         view
222         returns (address) {
223         return campaigns[bidId].owner;
224     }
225 
226     function setCampaignOwnerById(bytes32 bidId, address newOwner)
227         public
228         onlyAllowedAddress
229         {
230         campaigns[bidId].owner = newOwner;
231         emitEvent(campaigns[bidId]);
232     }
233 
234     function emitEvent(CampaignLibrary.Campaign campaign) private {
235 
236         if (campaigns[campaign.bidId].bidId == 0x0) {
237             emit CampaignCreated(
238                 campaign.bidId,
239                 campaign.price,
240                 campaign.budget,
241                 campaign.startDate,
242                 campaign.endDate,
243                 campaign.valid,
244                 campaign.owner
245             );
246         } else {
247             emit CampaignUpdated(
248                 campaign.bidId,
249                 campaign.price,
250                 campaign.budget,
251                 campaign.startDate,
252                 campaign.endDate,
253                 campaign.valid,
254                 campaign.owner
255             );
256         }
257     }
258 }
259 
260 contract AdvertisementFinance {
261 
262     mapping (address => uint256) balanceDevelopers;
263     mapping (address => bool) developerExists;
264     
265     address[] developers;
266     address owner;
267     address advertisementContract;
268     address advStorageContract;
269     AppCoins appc;
270 
271     modifier onlyOwner() { 
272         require(owner == msg.sender); 
273         _; 
274     }
275 
276     modifier onlyAds() { 
277         require(advertisementContract == msg.sender); 
278         _; 
279     }
280 
281     modifier onlyOwnerOrAds() { 
282         require(msg.sender == owner || msg.sender == advertisementContract); 
283         _; 
284     }	
285 
286     function AdvertisementFinance (address _addrAppc) 
287         public {
288         owner = msg.sender;
289         appc = AppCoins(_addrAppc);
290         advStorageContract = 0x0;
291     }
292 
293     function setAdsStorageAddress (address _addrStorage) external onlyOwnerOrAds {
294         reset();
295         advStorageContract = _addrStorage;
296     }
297 
298     function setAdsContractAddress (address _addrAdvert) external onlyOwner {
299         // Verify if the new Ads contract is using the same storage as before 
300         if (advertisementContract != 0x0){
301             Advertisement adsContract = Advertisement(advertisementContract);
302             address adsStorage = adsContract.getAdvertisementStorageAddress();
303             require (adsStorage == advStorageContract);
304         }
305         
306         //Update contract
307         advertisementContract = _addrAdvert;
308     }
309     
310 
311     function increaseBalance(address _developer, uint256 _value) 
312         public onlyAds{
313 
314         if(developerExists[_developer] == false){
315             developers.push(_developer);
316             developerExists[_developer] = true;
317         }
318 
319         balanceDevelopers[_developer] += _value;
320     }
321 
322     function pay(address _developer, address _destination, uint256 _value) 
323         public onlyAds{
324 
325         appc.transfer( _destination, _value);
326         balanceDevelopers[_developer] -= _value;
327     }
328 
329     function withdraw(address _developer, uint256 _value) public onlyOwnerOrAds {
330 
331         require(balanceDevelopers[_developer] >= _value);
332         
333         appc.transfer(_developer, _value);
334         balanceDevelopers[_developer] -= _value;    
335     }
336 
337     function reset() public onlyOwnerOrAds {
338         for(uint i = 0; i < developers.length; i++){
339             withdraw(developers[i],balanceDevelopers[developers[i]]);
340         }
341     }
342     
343 
344 }	
345 
346 contract ERC20Interface {
347     function name() public view returns(bytes32);
348     function symbol() public view returns(bytes32);
349     function balanceOf (address _owner) public view returns(uint256 balance);
350     function transfer(address _to, uint256 _value) public returns (bool success);
351     function transferFrom(address _from, address _to, uint256 _value) public returns (uint);
352     event Transfer(address indexed _from, address indexed _to, uint256 _value);
353 }
354 
355 
356 contract AppCoins is ERC20Interface{
357     // Public variables of the token
358     address public owner;
359     bytes32 private token_name;
360     bytes32 private token_symbol;
361     uint8 public decimals = 18;
362     // 18 decimals is the strongly suggested default, avoid changing it
363     uint256 public totalSupply;
364 
365     // This creates an array with all balances
366     mapping (address => uint256) public balances;
367     mapping (address => mapping (address => uint256)) public allowance;
368 
369     // This generates a public event on the blockchain that will notify clients
370     event Transfer(address indexed from, address indexed to, uint256 value);
371 
372     // This notifies clients about the amount burnt
373     event Burn(address indexed from, uint256 value);
374 
375     /**
376      * Constrctor function
377      *
378      * Initializes contract with initial supply tokens to the creator of the contract
379      */
380     function AppCoins() public {
381         owner = msg.sender;
382         token_name = "AppCoins";
383         token_symbol = "APPC";
384         uint256 _totalSupply = 1000000;
385         totalSupply = _totalSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
386         balances[owner] = totalSupply;                // Give the creator all initial tokens
387     }
388 
389     function name() public view returns(bytes32) {
390         return token_name;
391     }
392 
393     function symbol() public view returns(bytes32) {
394         return token_symbol;
395     }
396 
397     function balanceOf (address _owner) public view returns(uint256 balance) {
398         return balances[_owner];
399     }
400 
401     /**
402      * Internal transfer, only can be called by this contract
403      */
404     function _transfer(address _from, address _to, uint _value) internal returns (bool) {
405         // Prevent transfer to 0x0 address. Use burn() instead
406         require(_to != 0x0);
407         // Check if the sender has enough
408         require(balances[_from] >= _value);
409         // Check for overflows
410         require(balances[_to] + _value > balances[_to]);
411         // Save this for an assertion in the future
412         uint previousBalances = balances[_from] + balances[_to];
413         // Subtract from the sender
414         balances[_from] -= _value;
415         // Add the same to the recipient
416         balances[_to] += _value;
417         emit Transfer(_from, _to, _value);
418         // Asserts are used to use static analysis to find bugs in your code. They should never fail
419         assert(balances[_from] + balances[_to] == previousBalances);
420     }
421 
422     // /**
423     //  * Transfer tokens
424     //  *
425     //  * Send `_value` tokens to `_to` from your account
426     //  *
427     //  * @param _to The address of the recipient
428     //  * @param _value the amount to send
429     //  */
430     // function transfer(address _to, uint256 _value) public {
431     //     _transfer(msg.sender, _to, _value);
432     // }
433     function transfer (address _to, uint256 _amount) public returns (bool success) {
434         if( balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
435 
436             balances[msg.sender] -= _amount;
437             balances[_to] += _amount;
438             emit Transfer(msg.sender, _to, _amount);
439             return true;
440         } else {
441             return false;
442         }
443     }
444 
445     /**
446      * Transfer tokens from other address
447      *
448      * Send `_value` tokens to `_to` on behalf of `_from`
449      *
450      * @param _from The address of the sender
451      * @param _to The address of the recipient
452      * @param _value the amount to send
453      */
454     function transferFrom(address _from, address _to, uint256 _value) public returns (uint) {
455         require(_value <= allowance[_from][msg.sender]);     // Check allowance
456         allowance[_from][msg.sender] -= _value;
457         _transfer(_from, _to, _value);
458         return allowance[_from][msg.sender];
459     }
460 
461     /**
462      * Set allowance for other address
463      *
464      * Allows `_spender` to spend no more than `_value` tokens on your behalf
465      *
466      * @param _spender The address authorized to spend
467      * @param _value the max amount they can spend
468      */
469     function approve(address _spender, uint256 _value) public
470         returns (bool success) {
471         allowance[msg.sender][_spender] = _value;
472         return true;
473     }
474 
475     /**
476      * Destroy tokens
477      *
478      * Remove `_value` tokens from the system irreversibly
479      *
480      * @param _value the amount of money to burn
481      */
482     function burn(uint256 _value) public returns (bool success) {
483         require(balances[msg.sender] >= _value);   // Check if the sender has enough
484         balances[msg.sender] -= _value;            // Subtract from the sender
485         totalSupply -= _value;                      // Updates totalSupply
486         emit Burn(msg.sender, _value);
487         return true;
488     }
489 
490     /**
491      * Destroy tokens from other account
492      *
493      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
494      *
495      * @param _from the address of the sender
496      * @param _value the amount of money to burn
497      */
498     function burnFrom(address _from, uint256 _value) public returns (bool success) {
499         require(balances[_from] >= _value);                // Check if the targeted balance is enough
500         require(_value <= allowance[_from][msg.sender]);    // Check allowance
501         balances[_from] -= _value;                         // Subtract from the targeted balance
502         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
503         totalSupply -= _value;                              // Update totalSupply
504         emit Burn(_from, _value);
505         return true;
506     }
507 }
508 
509 
510 /**
511  * The Advertisement contract collects campaigns registered by developers
512  * and executes payments to users using campaign registered applications
513  * after proof of Attention.
514  */
515 contract Advertisement {
516 
517     struct ValidationRules {
518         bool vercode;
519         bool ipValidation;
520         bool country;
521         uint constipDailyConversions;
522         uint walletDailyConversions;
523     }
524 
525     uint constant expectedPoALength = 12;
526 
527     ValidationRules public rules;
528     bytes32[] bidIdList;
529     AppCoins appc;
530     AdvertisementStorage advertisementStorage;
531     AdvertisementFinance advertisementFinance;
532     address public owner;
533     mapping (address => mapping (bytes32 => bool)) userAttributions;
534 
535     modifier onlyOwner() {
536         require(msg.sender == owner);
537         _;
538     }
539 
540 
541     event PoARegistered(bytes32 bidId, string packageName,uint64[] timestampList,uint64[] nonceList,string walletName, bytes2 countryCode);
542     event Error(string func, string message);
543     event CampaignInformation
544         (
545             bytes32 bidId,
546             address  owner,
547             string ipValidator,
548             string packageName,
549             uint[3] countries,
550             uint[] vercodes
551     );
552 
553     /**
554     * Constructor function
555     *
556     * Initializes contract with default validation rules
557     */
558     function Advertisement (address _addrAppc, address _addrAdverStorage, address _addrAdverFinance) public {
559         rules = ValidationRules(false, true, true, 2, 1);
560         owner = msg.sender;
561         appc = AppCoins(_addrAppc);
562         advertisementStorage = AdvertisementStorage(_addrAdverStorage);
563         advertisementFinance = AdvertisementFinance(_addrAdverFinance);
564     }
565 
566     struct Map {
567         mapping (address => uint256) balance;
568         address[] devs;
569     }
570 
571     function upgradeFinance (address addrAdverFinance) public onlyOwner {
572         AdvertisementFinance newAdvFinance = AdvertisementFinance(addrAdverFinance);
573         Map storage devBalance;    
574 
575         for(uint i = 0; i < bidIdList.length; i++) {
576             address dev = advertisementStorage.getCampaignOwnerById(bidIdList[i]);
577             
578             if(devBalance.balance[dev] == 0){
579                 devBalance.devs.push(dev);
580             }
581             
582             devBalance.balance[dev] += advertisementStorage.getCampaignBudgetById(bidIdList[i]);
583         }        
584 
585         for(i = 0; i < devBalance.devs.length; i++) {
586             advertisementFinance.pay(devBalance.devs[i],address(newAdvFinance),devBalance.balance[devBalance.devs[i]]);
587             newAdvFinance.increaseBalance(devBalance.devs[i],devBalance.balance[devBalance.devs[i]]);
588         }
589 
590         uint256 oldBalance = appc.balances(address(advertisementFinance));
591 
592         require(oldBalance == 0);
593 
594         advertisementFinance = newAdvFinance;
595     }
596 
597     /**
598     * Upgrade storage function
599     *
600     * Upgrades AdvertisementStorage contract addres with no need to redeploy
601     * Advertisement contract however every campaign in the old contract will
602     * be canceled
603     */
604 
605     function upgradeStorage (address addrAdverStorage) public onlyOwner {
606         for(uint i = 0; i < bidIdList.length; i++) {
607             cancelCampaign(bidIdList[i]);
608         }
609         delete bidIdList;
610         advertisementFinance.reset();
611         advertisementFinance.setAdsStorageAddress(addrAdverStorage);
612         advertisementStorage = AdvertisementStorage(addrAdverStorage);
613     }
614 
615     /**
616     * Get AdvertisementStorageAddress
617     *
618     * Is required to upgrade Advertisement contract address on
619     * Advertisement Finance contract
620     */
621 
622     function getAdvertisementStorageAddress() public view returns(address _contract) {
623         require (msg.sender == address(advertisementFinance));
624 
625         return address(advertisementStorage);
626     }
627 
628 
629     /**
630     * Creates a campaign for a certain package name with
631     * a defined price and budget
632     */
633 
634     function createCampaign (
635         string packageName,
636         uint[3] countries,
637         uint[] vercodes,
638         uint price,
639         uint budget,
640         uint startDate,
641         uint endDate)
642         external {
643 
644         require(budget >= price);
645         require(endDate >= startDate);
646 
647         CampaignLibrary.Campaign memory newCampaign;
648 
649         newCampaign.price = price;
650         newCampaign.startDate = startDate;
651         newCampaign.endDate = endDate;
652 
653         //Transfers the budget to contract address
654         if(appc.allowance(msg.sender, address(this)) < budget){
655             emit Error("createCampaign","Not enough allowance");
656             return;
657         }
658 
659         appc.transferFrom(msg.sender, address(advertisementFinance), budget);
660 
661         advertisementFinance.increaseBalance(msg.sender,budget);
662 
663         newCampaign.budget = budget;
664         newCampaign.owner = msg.sender;
665         newCampaign.valid = true;
666         newCampaign.bidId = uintToBytes(bidIdList.length);
667         addCampaign(newCampaign);
668 
669         emit CampaignInformation(
670             newCampaign.bidId,
671             newCampaign.owner,
672             "", // ipValidator field
673             packageName,
674             countries,
675             vercodes);
676     }
677 
678     function addCampaign(CampaignLibrary.Campaign campaign) internal {
679 
680 		//Add to bidIdList
681         bidIdList.push(campaign.bidId);
682 
683 		//Add to campaign map
684         advertisementStorage.setCampaign(
685             campaign.bidId,
686             campaign.price,
687             campaign.budget,
688             campaign.startDate,
689             campaign.endDate,
690             campaign.valid,
691             campaign.owner
692         );
693 
694     }
695 
696     function registerPoA (
697         string packageName, bytes32 bidId,
698         uint64[] timestampList, uint64[] nonces,
699         address appstore, address oem,
700         string walletName, bytes2 countryCode) external {
701 
702         if(!isCampaignValid(bidId)){
703             emit Error(
704                 "registerPoA","Registering a Proof of attention to a invalid campaign");
705             return;
706         }
707 
708         if(timestampList.length != expectedPoALength){
709             emit Error("registerPoA","Proof-of-attention should have exactly 12 proofs");
710             return;
711         }
712 
713         if(timestampList.length != nonces.length){
714             emit Error(
715                 "registerPoA","Nounce list and timestamp list must have same length");
716             return;
717         }
718         //Expect ordered array arranged in ascending order
719         for (uint i = 0; i < timestampList.length - 1; i++) {
720             uint timestampDiff = (timestampList[i+1]-timestampList[i]);
721             if((timestampDiff / 1000) != 10){
722                 emit Error(
723                     "registerPoA","Timestamps should be spaced exactly 10 secounds");
724                 return;
725             }
726         }
727 
728         /* if(!areNoncesValid(bytes(packageName), timestampList, nonces)){
729             emit Error(
730                 "registerPoA","Incorrect nounces for submited proof of attention");
731             return;
732         } */
733 
734         if(userAttributions[msg.sender][bidId]){
735             emit Error(
736                 "registerPoA","User already registered a proof of attention for this campaign");
737             return;
738         }
739         //atribute
740         userAttributions[msg.sender][bidId] = true;
741 
742         payFromCampaign(bidId, appstore, oem);
743 
744         emit PoARegistered(bidId, packageName, timestampList, nonces, walletName, countryCode);
745     }
746 
747     function cancelCampaign (bytes32 bidId) public {
748         address campaignOwner = getOwnerOfCampaign(bidId);
749 
750 		// Only contract owner or campaign owner can cancel a campaign
751         require(owner == msg.sender || campaignOwner == msg.sender);
752         uint budget = getBudgetOfCampaign(bidId);
753 
754         advertisementFinance.withdraw(campaignOwner, budget);
755 
756         advertisementStorage.setCampaignBudgetById(bidId, 0);
757         advertisementStorage.setCampaignValidById(bidId, false);
758     }
759 
760     function getCampaignValidity(bytes32 bidId) public view returns(bool){
761         return advertisementStorage.getCampaignValidById(bidId);
762     }
763 
764     function getPriceOfCampaign (bytes32 bidId) public view returns(uint) {
765         return advertisementStorage.getCampaignPriceById(bidId);
766     }
767 
768     function getStartDateOfCampaign (bytes32 bidId) public view returns(uint) {
769         return advertisementStorage.getCampaignStartDateById(bidId);
770     }
771 
772     function getEndDateOfCampaign (bytes32 bidId) public view returns(uint) {
773         return advertisementStorage.getCampaignEndDateById(bidId);
774     }
775 
776     function getBudgetOfCampaign (bytes32 bidId) public view returns(uint) {
777         return advertisementStorage.getCampaignBudgetById(bidId);
778     }
779 
780     function getOwnerOfCampaign (bytes32 bidId) public view returns(address) {
781         return advertisementStorage.getCampaignOwnerById(bidId);
782     }
783 
784     function getBidIdList() public view returns(bytes32[]) {
785         return bidIdList;
786     }
787 
788     function isCampaignValid(bytes32 bidId) public view returns(bool) {
789         uint startDate = advertisementStorage.getCampaignStartDateById(bidId);
790         uint endDate = advertisementStorage.getCampaignEndDateById(bidId);
791         bool valid = advertisementStorage.getCampaignValidById(bidId);
792 
793         uint nowInMilliseconds = now * 1000;
794         return valid && startDate < nowInMilliseconds && endDate > nowInMilliseconds;
795     }
796 
797     function payFromCampaign (bytes32 bidId, address appstore, address oem) internal {
798         uint devShare = 85;
799         uint appstoreShare = 10;
800         uint oemShare = 5;
801 
802         //Search bid price
803         uint price = advertisementStorage.getCampaignPriceById(bidId);
804         uint budget = advertisementStorage.getCampaignBudgetById(bidId);
805         address campaignOwner = advertisementStorage.getCampaignOwnerById(bidId);
806 
807         require(budget > 0);
808         require(budget >= price);
809 
810         //transfer to user, appstore and oem
811         advertisementFinance.pay(campaignOwner,msg.sender,division(price * devShare, 100));
812         advertisementFinance.pay(campaignOwner,appstore,division(price * appstoreShare, 100));
813         advertisementFinance.pay(campaignOwner,oem,division(price * oemShare, 100));
814 
815         //subtract from campaign
816         uint newBudget = budget - price;
817 
818         advertisementStorage.setCampaignBudgetById(bidId, newBudget);
819 
820 
821         if (newBudget < price) {
822             advertisementStorage.setCampaignValidById(bidId, false);
823         }
824     }
825 
826     function areNoncesValid (bytes packageName,uint64[] timestampList, uint64[] nonces) internal returns(bool) {
827 
828         for(uint i = 0; i < nonces.length; i++){
829             bytes8 timestamp = bytes8(timestampList[i]);
830             bytes8 nonce = bytes8(nonces[i]);
831             bytes memory byteList = new bytes(packageName.length + timestamp.length);
832 
833             for(uint j = 0; j < packageName.length;j++){
834                 byteList[j] = packageName[j];
835             }
836 
837             for(j = 0; j < timestamp.length; j++ ){
838                 byteList[j + packageName.length] = timestamp[j];
839             }
840 
841             bytes32 result = sha256(byteList);
842 
843             bytes memory noncePlusHash = new bytes(result.length + nonce.length);
844 
845             for(j = 0; j < nonce.length; j++){
846                 noncePlusHash[j] = nonce[j];
847             }
848 
849             for(j = 0; j < result.length; j++){
850                 noncePlusHash[j + nonce.length] = result[j];
851             }
852 
853             result = sha256(noncePlusHash);
854 
855             bytes2[1] memory leadingBytes = [bytes2(0)];
856             bytes2 comp = 0x0000;
857 
858             assembly{
859             	mstore(leadingBytes,result)
860             }
861 
862             if(comp != leadingBytes[0]){
863                 return false;
864             }
865 
866         }
867         return true;
868     }
869 
870 
871     function division(uint numerator, uint denominator) public view returns (uint) {
872         uint _quotient = numerator / denominator;
873         return _quotient;
874     }
875 
876     function uintToBytes (uint256 i) public view returns(bytes32 b) {
877         b = bytes32(i);
878     }
879 
880 }