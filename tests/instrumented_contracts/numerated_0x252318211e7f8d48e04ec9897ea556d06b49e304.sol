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
236         if (campaigns[campaign.bidId].owner == 0x0) {
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
260 
261 contract AdvertisementFinance {
262 
263     mapping (address => uint256) balanceDevelopers;
264     mapping (address => bool) developerExists;
265     
266     address[] developers;
267     address owner;
268     address advertisementContract;
269     address advStorageContract;
270     AppCoins appc;
271 
272     modifier onlyOwner() { 
273         require(owner == msg.sender); 
274         _; 
275     }
276 
277     modifier onlyAds() { 
278         require(advertisementContract == msg.sender); 
279         _; 
280     }
281 
282     modifier onlyOwnerOrAds() { 
283         require(msg.sender == owner || msg.sender == advertisementContract); 
284         _; 
285     }	
286 
287     function AdvertisementFinance (address _addrAppc) 
288         public {
289         owner = msg.sender;
290         appc = AppCoins(_addrAppc);
291         advStorageContract = 0x0;
292     }
293 
294     function setAdsStorageAddress (address _addrStorage) external onlyOwnerOrAds {
295         reset();
296         advStorageContract = _addrStorage;
297     }
298 
299     function setAdsContractAddress (address _addrAdvert) external onlyOwner {
300         // Verify if the new Ads contract is using the same storage as before 
301         if (advertisementContract != 0x0){
302             Advertisement adsContract = Advertisement(advertisementContract);
303             address adsStorage = adsContract.getAdvertisementStorageAddress();
304             require (adsStorage == advStorageContract);
305         }
306         
307         //Update contract
308         advertisementContract = _addrAdvert;
309     }
310     
311 
312     function increaseBalance(address _developer, uint256 _value) 
313         public onlyAds{
314 
315         if(developerExists[_developer] == false){
316             developers.push(_developer);
317             developerExists[_developer] = true;
318         }
319 
320         balanceDevelopers[_developer] += _value;
321     }
322 
323     function pay(address _developer, address _destination, uint256 _value) 
324         public onlyAds{
325 
326         appc.transfer( _destination, _value);
327         balanceDevelopers[_developer] -= _value;
328     }
329 
330     function withdraw(address _developer, uint256 _value) public onlyOwnerOrAds {
331 
332         require(balanceDevelopers[_developer] >= _value);
333         
334         appc.transfer(_developer, _value);
335         balanceDevelopers[_developer] -= _value;    
336     }
337 
338     function reset() public onlyOwnerOrAds {
339         for(uint i = 0; i < developers.length; i++){
340             withdraw(developers[i],balanceDevelopers[developers[i]]);
341         }
342     }
343     
344 
345 }	
346 
347 contract ERC20Interface {
348     function name() public view returns(bytes32);
349     function symbol() public view returns(bytes32);
350     function balanceOf (address _owner) public view returns(uint256 balance);
351     function transfer(address _to, uint256 _value) public returns (bool success);
352     function transferFrom(address _from, address _to, uint256 _value) public returns (uint);
353     event Transfer(address indexed _from, address indexed _to, uint256 _value);
354 }
355 
356 
357 contract AppCoins is ERC20Interface{
358     // Public variables of the token
359     address public owner;
360     bytes32 private token_name;
361     bytes32 private token_symbol;
362     uint8 public decimals = 18;
363     // 18 decimals is the strongly suggested default, avoid changing it
364     uint256 public totalSupply;
365 
366     // This creates an array with all balances
367     mapping (address => uint256) public balances;
368     mapping (address => mapping (address => uint256)) public allowance;
369 
370     // This generates a public event on the blockchain that will notify clients
371     event Transfer(address indexed from, address indexed to, uint256 value);
372 
373     // This notifies clients about the amount burnt
374     event Burn(address indexed from, uint256 value);
375 
376     /**
377      * Constrctor function
378      *
379      * Initializes contract with initial supply tokens to the creator of the contract
380      */
381     function AppCoins() public {
382         owner = msg.sender;
383         token_name = "AppCoins";
384         token_symbol = "APPC";
385         uint256 _totalSupply = 1000000;
386         totalSupply = _totalSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
387         balances[owner] = totalSupply;                // Give the creator all initial tokens
388     }
389 
390     function name() public view returns(bytes32) {
391         return token_name;
392     }
393 
394     function symbol() public view returns(bytes32) {
395         return token_symbol;
396     }
397 
398     function balanceOf (address _owner) public view returns(uint256 balance) {
399         return balances[_owner];
400     }
401 
402     /**
403      * Internal transfer, only can be called by this contract
404      */
405     function _transfer(address _from, address _to, uint _value) internal returns (bool) {
406         // Prevent transfer to 0x0 address. Use burn() instead
407         require(_to != 0x0);
408         // Check if the sender has enough
409         require(balances[_from] >= _value);
410         // Check for overflows
411         require(balances[_to] + _value > balances[_to]);
412         // Save this for an assertion in the future
413         uint previousBalances = balances[_from] + balances[_to];
414         // Subtract from the sender
415         balances[_from] -= _value;
416         // Add the same to the recipient
417         balances[_to] += _value;
418         emit Transfer(_from, _to, _value);
419         // Asserts are used to use static analysis to find bugs in your code. They should never fail
420         assert(balances[_from] + balances[_to] == previousBalances);
421     }
422 
423     // /**
424     //  * Transfer tokens
425     //  *
426     //  * Send `_value` tokens to `_to` from your account
427     //  *
428     //  * @param _to The address of the recipient
429     //  * @param _value the amount to send
430     //  */
431     // function transfer(address _to, uint256 _value) public {
432     //     _transfer(msg.sender, _to, _value);
433     // }
434     function transfer (address _to, uint256 _amount) public returns (bool success) {
435         if( balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
436 
437             balances[msg.sender] -= _amount;
438             balances[_to] += _amount;
439             emit Transfer(msg.sender, _to, _amount);
440             return true;
441         } else {
442             return false;
443         }
444     }
445 
446     /**
447      * Transfer tokens from other address
448      *
449      * Send `_value` tokens to `_to` on behalf of `_from`
450      *
451      * @param _from The address of the sender
452      * @param _to The address of the recipient
453      * @param _value the amount to send
454      */
455     function transferFrom(address _from, address _to, uint256 _value) public returns (uint) {
456         require(_value <= allowance[_from][msg.sender]);     // Check allowance
457         allowance[_from][msg.sender] -= _value;
458         _transfer(_from, _to, _value);
459         return allowance[_from][msg.sender];
460     }
461 
462     /**
463      * Set allowance for other address
464      *
465      * Allows `_spender` to spend no more than `_value` tokens on your behalf
466      *
467      * @param _spender The address authorized to spend
468      * @param _value the max amount they can spend
469      */
470     function approve(address _spender, uint256 _value) public
471         returns (bool success) {
472         allowance[msg.sender][_spender] = _value;
473         return true;
474     }
475 
476     /**
477      * Destroy tokens
478      *
479      * Remove `_value` tokens from the system irreversibly
480      *
481      * @param _value the amount of money to burn
482      */
483     function burn(uint256 _value) public returns (bool success) {
484         require(balances[msg.sender] >= _value);   // Check if the sender has enough
485         balances[msg.sender] -= _value;            // Subtract from the sender
486         totalSupply -= _value;                      // Updates totalSupply
487         emit Burn(msg.sender, _value);
488         return true;
489     }
490 
491     /**
492      * Destroy tokens from other account
493      *
494      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
495      *
496      * @param _from the address of the sender
497      * @param _value the amount of money to burn
498      */
499     function burnFrom(address _from, uint256 _value) public returns (bool success) {
500         require(balances[_from] >= _value);                // Check if the targeted balance is enough
501         require(_value <= allowance[_from][msg.sender]);    // Check allowance
502         balances[_from] -= _value;                         // Subtract from the targeted balance
503         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
504         totalSupply -= _value;                              // Update totalSupply
505         emit Burn(_from, _value);
506         return true;
507     }
508 }
509 
510 
511 /**
512  * The Advertisement contract collects campaigns registered by developers
513  * and executes payments to users using campaign registered applications
514  * after proof of Attention.
515  */
516 contract Advertisement {
517 
518     struct ValidationRules {
519         bool vercode;
520         bool ipValidation;
521         bool country;
522         uint constipDailyConversions;
523         uint walletDailyConversions;
524     }
525 
526     uint constant expectedPoALength = 12;
527 
528     ValidationRules public rules;
529     bytes32[] bidIdList;
530     AppCoins appc;
531     AdvertisementStorage advertisementStorage;
532     AdvertisementFinance advertisementFinance;
533     address public owner;
534     mapping (address => mapping (bytes32 => bool)) userAttributions;
535 
536     modifier onlyOwner() {
537         require(msg.sender == owner);
538         _;
539     }
540 
541 
542     event PoARegistered(bytes32 bidId, string packageName,uint64[] timestampList,uint64[] nonceList,string walletName, bytes2 countryCode);
543     event Error(string func, string message);
544     event CampaignInformation
545         (
546             bytes32 bidId,
547             address  owner,
548             string ipValidator,
549             string packageName,
550             uint[3] countries,
551             uint[] vercodes
552     );
553 
554     /**
555     * Constructor function
556     *
557     * Initializes contract with default validation rules
558     */
559     function Advertisement (address _addrAppc, address _addrAdverStorage, address _addrAdverFinance) public {
560         rules = ValidationRules(false, true, true, 2, 1);
561         owner = msg.sender;
562         appc = AppCoins(_addrAppc);
563         advertisementStorage = AdvertisementStorage(_addrAdverStorage);
564         advertisementFinance = AdvertisementFinance(_addrAdverFinance);
565     }
566 
567     struct Map {
568         mapping (address => uint256) balance;
569         address[] devs;
570     }
571 
572     function upgradeFinance (address addrAdverFinance) public onlyOwner {
573         AdvertisementFinance newAdvFinance = AdvertisementFinance(addrAdverFinance);
574         Map storage devBalance;    
575 
576         for(uint i = 0; i < bidIdList.length; i++) {
577             address dev = advertisementStorage.getCampaignOwnerById(bidIdList[i]);
578             
579             if(devBalance.balance[dev] == 0){
580                 devBalance.devs.push(dev);
581             }
582             
583             devBalance.balance[dev] += advertisementStorage.getCampaignBudgetById(bidIdList[i]);
584         }        
585 
586         for(i = 0; i < devBalance.devs.length; i++) {
587             advertisementFinance.pay(devBalance.devs[i],address(newAdvFinance),devBalance.balance[devBalance.devs[i]]);
588             newAdvFinance.increaseBalance(devBalance.devs[i],devBalance.balance[devBalance.devs[i]]);
589         }
590 
591         uint256 oldBalance = appc.balances(address(advertisementFinance));
592 
593         require(oldBalance == 0);
594 
595         advertisementFinance = newAdvFinance;
596     }
597 
598     /**
599     * Upgrade storage function
600     *
601     * Upgrades AdvertisementStorage contract addres with no need to redeploy
602     * Advertisement contract however every campaign in the old contract will
603     * be canceled
604     */
605 
606     function upgradeStorage (address addrAdverStorage) public onlyOwner {
607         for(uint i = 0; i < bidIdList.length; i++) {
608             cancelCampaign(bidIdList[i]);
609         }
610         delete bidIdList;
611         advertisementFinance.reset();
612         advertisementFinance.setAdsStorageAddress(addrAdverStorage);
613         advertisementStorage = AdvertisementStorage(addrAdverStorage);
614     }
615 
616     /**
617     * Get AdvertisementStorageAddress
618     *
619     * Is required to upgrade Advertisement contract address on
620     * Advertisement Finance contract
621     */
622 
623     function getAdvertisementStorageAddress() public view returns(address _contract) {
624         require (msg.sender == address(advertisementFinance));
625 
626         return address(advertisementStorage);
627     }
628 
629 
630     /**
631     * Creates a campaign for a certain package name with
632     * a defined price and budget
633     */
634 
635     function createCampaign (
636         string packageName,
637         uint[3] countries,
638         uint[] vercodes,
639         uint price,
640         uint budget,
641         uint startDate,
642         uint endDate)
643         external {
644 
645         require(budget >= price);
646         require(endDate >= startDate);
647 
648         CampaignLibrary.Campaign memory newCampaign;
649 
650         newCampaign.price = price;
651         newCampaign.startDate = startDate;
652         newCampaign.endDate = endDate;
653 
654         //Transfers the budget to contract address
655         if(appc.allowance(msg.sender, address(this)) < budget){
656             emit Error("createCampaign","Not enough allowance");
657             return;
658         }
659 
660         appc.transferFrom(msg.sender, address(advertisementFinance), budget);
661 
662         advertisementFinance.increaseBalance(msg.sender,budget);
663 
664         newCampaign.budget = budget;
665         newCampaign.owner = msg.sender;
666         newCampaign.valid = true;
667         newCampaign.bidId = uintToBytes(bidIdList.length);
668         addCampaign(newCampaign);
669 
670         emit CampaignInformation(
671             newCampaign.bidId,
672             newCampaign.owner,
673             "", // ipValidator field
674             packageName,
675             countries,
676             vercodes);
677     }
678 
679     function addCampaign(CampaignLibrary.Campaign campaign) internal {
680 
681 		//Add to bidIdList
682         bidIdList.push(campaign.bidId);
683 
684 		//Add to campaign map
685         advertisementStorage.setCampaign(
686             campaign.bidId,
687             campaign.price,
688             campaign.budget,
689             campaign.startDate,
690             campaign.endDate,
691             campaign.valid,
692             campaign.owner
693         );
694 
695     }
696 
697     function registerPoA (
698         string packageName, bytes32 bidId,
699         uint64[] timestampList, uint64[] nonces,
700         address appstore, address oem,
701         string walletName, bytes2 countryCode) external {
702 
703         if(!isCampaignValid(bidId)){
704             emit Error(
705                 "registerPoA","Registering a Proof of attention to a invalid campaign");
706             return;
707         }
708 
709         if(timestampList.length != expectedPoALength){
710             emit Error("registerPoA","Proof-of-attention should have exactly 12 proofs");
711             return;
712         }
713 
714         if(timestampList.length != nonces.length){
715             emit Error(
716                 "registerPoA","Nounce list and timestamp list must have same length");
717             return;
718         }
719         //Expect ordered array arranged in ascending order
720         for (uint i = 0; i < timestampList.length - 1; i++) {
721             uint timestampDiff = (timestampList[i+1]-timestampList[i]);
722             if((timestampDiff / 1000) != 10){
723                 emit Error(
724                     "registerPoA","Timestamps should be spaced exactly 10 secounds");
725                 return;
726             }
727         }
728 
729         /* if(!areNoncesValid(bytes(packageName), timestampList, nonces)){
730             emit Error(
731                 "registerPoA","Incorrect nounces for submited proof of attention");
732             return;
733         } */
734 
735         if(userAttributions[msg.sender][bidId]){
736             emit Error(
737                 "registerPoA","User already registered a proof of attention for this campaign");
738             return;
739         }
740         //atribute
741         userAttributions[msg.sender][bidId] = true;
742 
743         payFromCampaign(bidId, appstore, oem);
744 
745         emit PoARegistered(bidId, packageName, timestampList, nonces, walletName, countryCode);
746     }
747 
748     function cancelCampaign (bytes32 bidId) public {
749         address campaignOwner = getOwnerOfCampaign(bidId);
750 
751 		// Only contract owner or campaign owner can cancel a campaign
752         require(owner == msg.sender || campaignOwner == msg.sender);
753         uint budget = getBudgetOfCampaign(bidId);
754 
755         advertisementFinance.withdraw(campaignOwner, budget);
756 
757         advertisementStorage.setCampaignBudgetById(bidId, 0);
758         advertisementStorage.setCampaignValidById(bidId, false);
759     }
760 
761     function getCampaignValidity(bytes32 bidId) public view returns(bool){
762         return advertisementStorage.getCampaignValidById(bidId);
763     }
764 
765     function getPriceOfCampaign (bytes32 bidId) public view returns(uint) {
766         return advertisementStorage.getCampaignPriceById(bidId);
767     }
768 
769     function getStartDateOfCampaign (bytes32 bidId) public view returns(uint) {
770         return advertisementStorage.getCampaignStartDateById(bidId);
771     }
772 
773     function getEndDateOfCampaign (bytes32 bidId) public view returns(uint) {
774         return advertisementStorage.getCampaignEndDateById(bidId);
775     }
776 
777     function getBudgetOfCampaign (bytes32 bidId) public view returns(uint) {
778         return advertisementStorage.getCampaignBudgetById(bidId);
779     }
780 
781     function getOwnerOfCampaign (bytes32 bidId) public view returns(address) {
782         return advertisementStorage.getCampaignOwnerById(bidId);
783     }
784 
785     function getBidIdList() public view returns(bytes32[]) {
786         return bidIdList;
787     }
788 
789     function isCampaignValid(bytes32 bidId) public view returns(bool) {
790         uint startDate = advertisementStorage.getCampaignStartDateById(bidId);
791         uint endDate = advertisementStorage.getCampaignEndDateById(bidId);
792         bool valid = advertisementStorage.getCampaignValidById(bidId);
793 
794         uint nowInMilliseconds = now * 1000;
795         return valid && startDate < nowInMilliseconds && endDate > nowInMilliseconds;
796     }
797 
798     function payFromCampaign (bytes32 bidId, address appstore, address oem) internal {
799         uint devShare = 85;
800         uint appstoreShare = 10;
801         uint oemShare = 5;
802 
803         //Search bid price
804         uint price = advertisementStorage.getCampaignPriceById(bidId);
805         uint budget = advertisementStorage.getCampaignBudgetById(bidId);
806         address campaignOwner = advertisementStorage.getCampaignOwnerById(bidId);
807 
808         require(budget > 0);
809         require(budget >= price);
810 
811         //transfer to user, appstore and oem
812         advertisementFinance.pay(campaignOwner,msg.sender,division(price * devShare, 100));
813         advertisementFinance.pay(campaignOwner,appstore,division(price * appstoreShare, 100));
814         advertisementFinance.pay(campaignOwner,oem,division(price * oemShare, 100));
815 
816         //subtract from campaign
817         uint newBudget = budget - price;
818 
819         advertisementStorage.setCampaignBudgetById(bidId, newBudget);
820 
821 
822         if (newBudget < price) {
823             advertisementStorage.setCampaignValidById(bidId, false);
824         }
825     }
826 
827     function areNoncesValid (bytes packageName,uint64[] timestampList, uint64[] nonces) internal returns(bool) {
828 
829         for(uint i = 0; i < nonces.length; i++){
830             bytes8 timestamp = bytes8(timestampList[i]);
831             bytes8 nonce = bytes8(nonces[i]);
832             bytes memory byteList = new bytes(packageName.length + timestamp.length);
833 
834             for(uint j = 0; j < packageName.length;j++){
835                 byteList[j] = packageName[j];
836             }
837 
838             for(j = 0; j < timestamp.length; j++ ){
839                 byteList[j + packageName.length] = timestamp[j];
840             }
841 
842             bytes32 result = sha256(byteList);
843 
844             bytes memory noncePlusHash = new bytes(result.length + nonce.length);
845 
846             for(j = 0; j < nonce.length; j++){
847                 noncePlusHash[j] = nonce[j];
848             }
849 
850             for(j = 0; j < result.length; j++){
851                 noncePlusHash[j + nonce.length] = result[j];
852             }
853 
854             result = sha256(noncePlusHash);
855 
856             bytes2[1] memory leadingBytes = [bytes2(0)];
857             bytes2 comp = 0x0000;
858 
859             assembly{
860             	mstore(leadingBytes,result)
861             }
862 
863             if(comp != leadingBytes[0]){
864                 return false;
865             }
866 
867         }
868         return true;
869     }
870 
871 
872     function division(uint numerator, uint denominator) public view returns (uint) {
873         uint _quotient = numerator / denominator;
874         return _quotient;
875     }
876 
877     function uintToBytes (uint256 i) public view returns(bytes32 b) {
878         b = bytes32(i);
879     }
880 
881 }