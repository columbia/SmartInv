1 pragma solidity ^0.4.24;
2 
3 
4 contract ERC20Interface {
5     function name() public view returns(bytes32);
6     function symbol() public view returns(bytes32);
7     function balanceOf (address _owner) public view returns(uint256 balance);
8     function transfer(address _to, uint256 _value) public returns (bool success);
9     function transferFrom(address _from, address _to, uint256 _value) public returns (uint);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11 }
12 
13 library ExtendedCampaignLibrary {
14     struct ExtendedInfo{
15         bytes32 bidId;
16         address rewardManager;
17         string endpoint;
18     }
19 
20     /**
21     @notice Set extended campaign id
22     @param _bidId Id of the campaign
23      */
24     function setBidId(ExtendedInfo storage _extendedInfo, bytes32 _bidId) internal {
25         _extendedInfo.bidId = _bidId;
26     }
27     
28     /**
29     @notice Get extended campaign id
30     @return {'_bidId' : 'Id of the campaign'}
31     */
32     function getBidId(ExtendedInfo storage _extendedInfo) internal view returns(bytes32 _bidId){
33         return _extendedInfo.bidId;
34     }
35 
36     /**
37     @notice Set reward manager address 
38     @param _rewardManager Address of the reward manager
39     */
40     function setRewardManager(ExtendedInfo storage _extendedInfo,  address _rewardManager) internal {
41         _extendedInfo.rewardManager = _rewardManager;
42     }
43 
44     /**
45     @notice Get reward manager address
46     @return {'_rewardManager' : 'Address of the reward manager'} 
47     */
48     function getRewardManager(ExtendedInfo storage _extendedInfo) internal view returns(address _rewardManager) {
49         return _extendedInfo.rewardManager;
50     }
51 
52     /**
53     @notice Set URL of the signing serivce
54     @param _endpoint URL of the signing serivce
55     */
56     function setEndpoint(ExtendedInfo storage _extendedInfo, string  _endpoint) internal {
57         _extendedInfo.endpoint = _endpoint;
58     }
59 
60     /**
61     @notice Get URL of the signing service
62     @return {'_endpoint' : 'URL of the signing serivce'} 
63     */
64     function getEndpoint(ExtendedInfo storage _extendedInfo) internal view returns (string _endpoint) {
65         return _extendedInfo.endpoint;
66     }
67 }
68 
69 
70 contract AppCoins is ERC20Interface{
71     // Public variables of the token
72     address public owner;
73     bytes32 private token_name;
74     bytes32 private token_symbol;
75     uint8 public decimals = 18;
76     // 18 decimals is the strongly suggested default, avoid changing it
77     uint256 public totalSupply;
78 
79     // This creates an array with all balances
80     mapping (address => uint256) public balances;
81     mapping (address => mapping (address => uint256)) public allowance;
82 
83     // This generates a public event on the blockchain that will notify clients
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     // This notifies clients about the amount burnt
87     event Burn(address indexed from, uint256 value);
88 
89     /**
90      * Constrctor function
91      *
92      * Initializes contract with initial supply tokens to the creator of the contract
93      */
94     function AppCoins() public {
95         owner = msg.sender;
96         token_name = "AppCoins";
97         token_symbol = "APPC";
98         uint256 _totalSupply = 1000000;
99         totalSupply = _totalSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
100         balances[owner] = totalSupply;                // Give the creator all initial tokens
101     }
102 
103     function name() public view returns(bytes32) {
104         return token_name;
105     }
106 
107     function symbol() public view returns(bytes32) {
108         return token_symbol;
109     }
110 
111     function balanceOf (address _owner) public view returns(uint256 balance) {
112         return balances[_owner];
113     }
114 
115     /**
116      * Internal transfer, only can be called by this contract
117      */
118     function _transfer(address _from, address _to, uint _value) internal returns (bool) {
119         // Prevent transfer to 0x0 address. Use burn() instead
120         require(_to != 0x0);
121         // Check if the sender has enough
122         require(balances[_from] >= _value);
123         // Check for overflows
124         require(balances[_to] + _value > balances[_to]);
125         // Save this for an assertion in the future
126         uint previousBalances = balances[_from] + balances[_to];
127         // Subtract from the sender
128         balances[_from] -= _value;
129         // Add the same to the recipient
130         balances[_to] += _value;
131         emit Transfer(_from, _to, _value);
132         // Asserts are used to use static analysis to find bugs in your code. They should never fail
133         assert(balances[_from] + balances[_to] == previousBalances);
134     }
135 
136     // /**
137     //  * Transfer tokens
138     //  *
139     //  * Send `_value` tokens to `_to` from your account
140     //  *
141     //  * @param _to The address of the recipient
142     //  * @param _value the amount to send
143     //  */
144     // function transfer(address _to, uint256 _value) public {
145     //     _transfer(msg.sender, _to, _value);
146     // }
147     function transfer (address _to, uint256 _amount) public returns (bool success) {
148         if( balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
149 
150             balances[msg.sender] -= _amount;
151             balances[_to] += _amount;
152             emit Transfer(msg.sender, _to, _amount);
153             return true;
154         } else {
155             return false;
156         }
157     }
158 
159     /**
160      * Transfer tokens from other address
161      *
162      * Send `_value` tokens to `_to` on behalf of `_from`
163      *
164      * @param _from The address of the sender
165      * @param _to The address of the recipient
166      * @param _value the amount to send
167      */
168     function transferFrom(address _from, address _to, uint256 _value) public returns (uint) {
169         require(_value <= allowance[_from][msg.sender]);     // Check allowance
170         allowance[_from][msg.sender] -= _value;
171         _transfer(_from, _to, _value);
172         return allowance[_from][msg.sender];
173     }
174 
175     /**
176      * Set allowance for other address
177      *
178      * Allows `_spender` to spend no more than `_value` tokens on your behalf
179      *
180      * @param _spender The address authorized to spend
181      * @param _value the max amount they can spend
182      */
183     function approve(address _spender, uint256 _value) public
184         returns (bool success) {
185         allowance[msg.sender][_spender] = _value;
186         return true;
187     }
188 
189     /**
190      * Destroy tokens
191      *
192      * Remove `_value` tokens from the system irreversibly
193      *
194      * @param _value the amount of money to burn
195      */
196     function burn(uint256 _value) public returns (bool success) {
197         require(balances[msg.sender] >= _value);   // Check if the sender has enough
198         balances[msg.sender] -= _value;            // Subtract from the sender
199         totalSupply -= _value;                      // Updates totalSupply
200         emit Burn(msg.sender, _value);
201         return true;
202     }
203 
204     /**
205      * Destroy tokens from other account
206      *
207      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
208      *
209      * @param _from the address of the sender
210      * @param _value the amount of money to burn
211      */
212     function burnFrom(address _from, uint256 _value) public returns (bool success) {
213         require(balances[_from] >= _value);                // Check if the targeted balance is enough
214         require(_value <= allowance[_from][msg.sender]);    // Check allowance
215         balances[_from] -= _value;                         // Subtract from the targeted balance
216         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
217         totalSupply -= _value;                              // Update totalSupply
218         emit Burn(_from, _value);
219         return true;
220     }
221 }
222 library CampaignLibrary {
223 
224     struct Campaign {
225         bytes32 bidId;
226         uint price;
227         uint budget;
228         uint startDate;
229         uint endDate;
230         bool valid;
231         address  owner;
232     }
233 
234 
235     /**
236     @notice Set campaign id 
237     @param _bidId Id of the campaign
238      */
239     function setBidId(Campaign storage _campaign, bytes32 _bidId) internal {
240         _campaign.bidId = _bidId;
241     }
242 
243     /**
244     @notice Get campaign id
245     @return {'_bidId' : 'Id of the campaign'}
246      */
247     function getBidId(Campaign storage _campaign) internal view returns(bytes32 _bidId){
248         return _campaign.bidId;
249     }
250    
251     /**
252     @notice Set campaing price per proof of attention
253     @param _price Price of the campaign
254      */
255     function setPrice(Campaign storage _campaign, uint _price) internal {
256         _campaign.price = _price;
257     }
258 
259     /**
260     @notice Get campaign price per proof of attention
261     @return {'_price' : 'Price of the campaign'}
262      */
263     function getPrice(Campaign storage _campaign) internal view returns(uint _price){
264         return _campaign.price;
265     }
266 
267     /**
268     @notice Set campaign total budget 
269     @param _budget Total budget of the campaign
270      */
271     function setBudget(Campaign storage _campaign, uint _budget) internal {
272         _campaign.budget = _budget;
273     }
274 
275     /**
276     @notice Get campaign total budget
277     @return {'_budget' : 'Total budget of the campaign'}
278      */
279     function getBudget(Campaign storage _campaign) internal view returns(uint _budget){
280         return _campaign.budget;
281     }
282 
283     /**
284     @notice Set campaign start date 
285     @param _startDate Start date of the campaign (in milisecounds)
286      */
287     function setStartDate(Campaign storage _campaign, uint _startDate) internal{
288         _campaign.startDate = _startDate;
289     }
290 
291     /**
292     @notice Get campaign start date 
293     @return {'_startDate' : 'Start date of the campaign (in milisecounds)'}
294      */
295     function getStartDate(Campaign storage _campaign) internal view returns(uint _startDate){
296         return _campaign.startDate;
297     }
298  
299     /**
300     @notice Set campaign end date 
301     @param _endDate End date of the campaign (in milisecounds)
302      */
303     function setEndDate(Campaign storage _campaign, uint _endDate) internal {
304         _campaign.endDate = _endDate;
305     }
306 
307     /**
308     @notice Get campaign end date 
309     @return {'_endDate' : 'End date of the campaign (in milisecounds)'}
310      */
311     function getEndDate(Campaign storage _campaign) internal view returns(uint _endDate){
312         return _campaign.endDate;
313     }
314 
315     /**
316     @notice Set campaign validity 
317     @param _valid Validity of the campaign
318      */
319     function setValidity(Campaign storage _campaign, bool _valid) internal {
320         _campaign.valid = _valid;
321     }
322 
323     /**
324     @notice Get campaign validity 
325     @return {'_valid' : 'Boolean stating campaign validity'}
326      */
327     function getValidity(Campaign storage _campaign) internal view returns(bool _valid){
328         return _campaign.valid;
329     }
330 
331     /**
332     @notice Set campaign owner 
333     @param _owner Owner of the campaign
334      */
335     function setOwner(Campaign storage _campaign, address _owner) internal {
336         _campaign.owner = _owner;
337     }
338 
339     /**
340     @notice Get campaign owner 
341     @return {'_owner' : 'Address of the owner of the campaign'}
342      */
343     function getOwner(Campaign storage _campaign) internal view returns(address _owner){
344         return _campaign.owner;
345     }
346 
347     /**
348     @notice Converts country index list into 3 uints
349       
350         Expects a list of country indexes such that the 2 digit country code is converted to an 
351         index. Countries are expected to be indexed so a "AA" country code is mapped to index 0 and 
352         "ZZ" country is mapped to index 675.
353     @param countries List of country indexes
354     @return {
355         "countries1" : "First third of the byte array converted in a 256 bytes uint",
356         "countries2" : "Second third of the byte array converted in a 256 bytes uint",
357         "countries3" : "Third third of the byte array converted in a 256 bytes uint"
358     }
359     */
360     function convertCountryIndexToBytes(uint[] countries) public pure
361         returns (uint countries1,uint countries2,uint countries3){
362         countries1 = 0;
363         countries2 = 0;
364         countries3 = 0;
365         for(uint i = 0; i < countries.length; i++){
366             uint index = countries[i];
367 
368             if(index<256){
369                 countries1 = countries1 | uint(1) << index;
370             } else if (index<512) {
371                 countries2 = countries2 | uint(1) << (index - 256);
372             } else {
373                 countries3 = countries3 | uint(1) << (index - 512);
374             }
375         }
376 
377         return (countries1,countries2,countries3);
378     }    
379 }
380 
381 
382 
383 interface StorageUser {
384     function getStorageAddress() external view returns(address _storage);
385 }
386 
387 interface ErrorThrower {
388     event Error(string func, string message);
389 }
390 
391 library Roles {
392   struct Role {
393     mapping (address => bool) bearer;
394   }
395 
396   function add(Role storage _role, address _addr)
397     internal
398   {
399     _role.bearer[_addr] = true;
400   }
401 
402   function remove(Role storage _role, address _addr)
403     internal
404   {
405     _role.bearer[_addr] = false;
406   }
407 
408 
409   function check(Role storage _role, address _addr)
410     internal
411     view
412   {
413     require(has(_role, _addr));
414   }
415 
416   function has(Role storage _role, address _addr)
417     internal
418     view
419     returns (bool)
420   {
421     return _role.bearer[_addr];
422   }
423 }
424 
425 contract RBAC {
426   using Roles for Roles.Role;
427 
428   mapping (string => Roles.Role) private roles;
429 
430   event RoleAdded(address indexed operator, string role);
431   event RoleRemoved(address indexed operator, string role);
432 
433 
434   function checkRole(address _operator, string _role)
435     public
436     view
437   {
438     roles[_role].check(_operator);
439   }
440 
441   function hasRole(address _operator, string _role)
442     public
443     view
444     returns (bool)
445   {
446     return roles[_role].has(_operator);
447   }
448 
449   function addRole(address _operator, string _role)
450     internal
451   {
452     roles[_role].add(_operator);
453     emit RoleAdded(_operator, _role);
454   }
455 
456   function removeRole(address _operator, string _role)
457     internal
458   {
459     roles[_role].remove(_operator);
460     emit RoleRemoved(_operator, _role);
461   }
462 
463   modifier onlyRole(string _role)
464   {
465     checkRole(msg.sender, _role);
466     _;
467   }
468 
469 
470 }
471 
472 
473 contract Ownable is ErrorThrower {
474     address public owner;
475     
476     event OwnershipRenounced(address indexed previousOwner);
477     event OwnershipTransferred(
478         address indexed previousOwner,
479         address indexed newOwner
480     );
481 
482 
483     /**
484     *  The Ownable constructor sets the original `owner` of the contract to the sender
485     * account.
486     */
487     constructor() public {
488         owner = msg.sender;
489     }
490 
491     modifier onlyOwner(string _funcName) {
492         if(msg.sender != owner){
493             emit Error(_funcName,"Operation can only be performed by contract owner");
494             return;
495         }
496         _;
497     }
498 
499     /**
500     *  Allows the current owner to relinquish control of the contract.
501     * @notice Renouncing to ownership will leave the contract without an owner.
502     * It will not be possible to call the functions with the `onlyOwner`
503     * modifier anymore.
504     */
505     function renounceOwnership() public onlyOwner("renounceOwnership") {
506         emit OwnershipRenounced(owner);
507         owner = address(0);
508     }
509 
510     /**
511     *  Allows the current owner to transfer control of the contract to a newOwner.
512     * @param _newOwner The address to transfer ownership to.
513     */
514     function transferOwnership(address _newOwner) public onlyOwner("transferOwnership") {
515         _transferOwnership(_newOwner);
516     }
517 
518     /**
519     *  Transfers control of the contract to a newOwner.
520     * @param _newOwner The address to transfer ownership to.
521     */
522     function _transferOwnership(address _newOwner) internal {
523         if(_newOwner == address(0)){
524             emit Error("transferOwnership","New owner's address needs to be different than 0x0");
525             return;
526         }
527 
528         emit OwnershipTransferred(owner, _newOwner);
529         owner = _newOwner;
530     }
531 }
532 
533 contract SingleAllowance is Ownable {
534 
535     address allowedAddress;
536 
537     modifier onlyAllowed() {
538         require(allowedAddress == msg.sender);
539         _;
540     }
541 
542     modifier onlyOwnerOrAllowed() {
543         require(owner == msg.sender || allowedAddress == msg.sender);
544         _;
545     }
546 
547     function setAllowedAddress(address _addr) public onlyOwner("setAllowedAddress"){
548         allowedAddress = _addr;
549     }
550 }
551 
552 
553 contract Whitelist is Ownable, RBAC {
554     string public constant ROLE_WHITELISTED = "whitelist";
555 
556     /**
557     *  Throws Error event if operator is not whitelisted.
558     * @param _operator address
559     */
560     modifier onlyIfWhitelisted(string _funcname, address _operator) {
561         if(!hasRole(_operator, ROLE_WHITELISTED)){
562             emit Error(_funcname, "Operation can only be performed by Whitelisted Addresses");
563             return;
564         }
565         _;
566     }
567 
568     /**
569     *  add an address to the whitelist
570     * @param _operator address
571     * @return true if the address was added to the whitelist, false if the address was already in the whitelist
572     */
573     function addAddressToWhitelist(address _operator)
574         public
575         onlyOwner("addAddressToWhitelist")
576     {
577         addRole(_operator, ROLE_WHITELISTED);
578     }
579 
580     /**
581     *  getter to determine if address is in whitelist
582     */
583     function whitelist(address _operator)
584         public
585         view
586         returns (bool)
587     {
588         return hasRole(_operator, ROLE_WHITELISTED);
589     }
590 
591     /**
592     *  add addresses to the whitelist
593     * @param _operators addresses
594     * @return true if at least one address was added to the whitelist,
595     * false if all addresses were already in the whitelist
596     */
597     function addAddressesToWhitelist(address[] _operators)
598         public
599         onlyOwner("addAddressesToWhitelist")
600     {
601         for (uint256 i = 0; i < _operators.length; i++) {
602             addAddressToWhitelist(_operators[i]);
603         }
604     }
605 
606     /**
607     *  remove an address from the whitelist
608     * @param _operator address
609     * @return true if the address was removed from the whitelist,
610     * false if the address wasn't in the whitelist in the first place
611     */
612     function removeAddressFromWhitelist(address _operator)
613         public
614         onlyOwner("removeAddressFromWhitelist")
615     {
616         removeRole(_operator, ROLE_WHITELISTED);
617     }
618 
619     /**
620     *  remove addresses from the whitelist
621     * @param _operators addresses
622     * @return true if at least one address was removed from the whitelist,
623     * false if all addresses weren't in the whitelist in the first place
624     */
625     function removeAddressesFromWhitelist(address[] _operators)
626         public
627         onlyOwner("removeAddressesFromWhitelist")
628     {
629         for (uint256 i = 0; i < _operators.length; i++) {
630             removeAddressFromWhitelist(_operators[i]);
631         }
632     }
633 
634 }
635 
636 contract BaseAdvertisementStorage is Whitelist {
637     using CampaignLibrary for CampaignLibrary.Campaign;
638 
639     mapping (bytes32 => CampaignLibrary.Campaign) campaigns;
640 
641     bytes32 lastBidId = 0x0;
642 
643     modifier onlyIfCampaignExists(string _funcName, bytes32 _bidId) {
644         if(campaigns[_bidId].owner == 0x0){
645             emit Error(_funcName,"Campaign does not exist");
646             return;
647         }
648         _;
649     }
650     
651     event CampaignCreated
652         (
653             bytes32 bidId,
654             uint price,
655             uint budget,
656             uint startDate,
657             uint endDate,
658             bool valid,
659             address owner
660     );
661 
662     event CampaignUpdated
663         (
664             bytes32 bidId,
665             uint price,
666             uint budget,
667             uint startDate,
668             uint endDate,
669             bool valid,
670             address  owner
671     );
672 
673     /**
674     @notice Get a Campaign information
675      
676         Based on a camapaign Id (bidId), returns all stored information for that campaign.
677     @param campaignId Id of the campaign
678     @return {
679         "bidId" : "Id of the campaign",
680         "price" : "Value to pay for each proof-of-attention",
681         "budget" : "Total value avaliable to be spent on the campaign",
682         "startDate" : "Start date of the campaign (in miliseconds)",
683         "endDate" : "End date of the campaign (in miliseconds)"
684         "valid" : "Boolean informing if the campaign is valid",
685         "campOwner" : "Address of the campaing's owner"
686     }
687     */
688     function _getCampaign(bytes32 campaignId)
689         internal
690         returns (CampaignLibrary.Campaign storage _campaign) {
691 
692 
693         return campaigns[campaignId];
694     }
695 
696 
697     /**
698     @notice Add or update a campaign information
699     
700         Based on a campaign Id (bidId), a campaign can be created (if non existent) or updated.
701         This function can only be called by the set of allowed addresses registered earlier.
702         An event will be emited during this function's execution, a CampaignCreated event if the 
703         campaign does not exist yet or a CampaignUpdated if the campaign id is already registered.
704 
705     @param bidId Id of the campaign
706     @param price Value to pay for each proof-of-attention
707     @param budget Total value avaliable to be spent on the campaign
708     @param startDate Start date of the campaign (in miliseconds)
709     @param endDate End date of the campaign (in miliseconds)
710     @param valid Boolean informing if the campaign is valid
711     @param owner Address of the campaing's owner
712     */
713     function _setCampaign (
714         bytes32 bidId,
715         uint price,
716         uint budget,
717         uint startDate,
718         uint endDate,
719         bool valid,
720         address owner
721     )
722     public
723     onlyIfWhitelisted("setCampaign",msg.sender) {
724 
725         CampaignLibrary.Campaign storage campaign = campaigns[bidId];
726         campaign.setBidId(bidId);
727         campaign.setPrice(price);
728         campaign.setBudget(budget);
729         campaign.setStartDate(startDate);
730         campaign.setEndDate(endDate);
731         campaign.setValidity(valid);
732 
733         bool newCampaign = (campaigns[bidId].getOwner() == 0x0);
734 
735         campaign.setOwner(owner);
736 
737 
738 
739         if(newCampaign){
740             emitCampaignCreated(campaign);
741             setLastBidId(bidId);
742         } else {
743             emitCampaignUpdated(campaign);
744         }
745     }
746 
747     /**
748     @notice Constructor function
749     
750         Initializes contract and updates allowed addresses to interact with contract functions.
751     */
752     constructor() public {
753         addAddressToWhitelist(msg.sender);
754     }
755 
756       /**
757     @notice Get the price of a campaign
758     
759         Based on the Campaign id, return the value paid for each proof of attention registered.
760     @param bidId Campaign id to which the query refers
761     @return { "price" : "Reward (in wei) for each proof of attention registered"} 
762     */
763     function getCampaignPriceById(bytes32 bidId)
764         public
765         view
766         returns (uint price) {
767         return campaigns[bidId].getPrice();
768     }
769 
770     /** 
771     @notice Set a new price for a campaign
772     
773         Based on the Campaign id, updates the value paid for each proof of attention registered.
774         This function can only be executed by allowed addresses and emits a CampaingUpdate event.
775     @param bidId Campaing id to which the update refers
776     @param price New price for each proof of attention
777     */
778     function setCampaignPriceById(bytes32 bidId, uint price)
779         public
780         onlyIfWhitelisted("setCampaignPriceById",msg.sender) 
781         onlyIfCampaignExists("setCampaignPriceById",bidId)      
782         {
783         campaigns[bidId].setPrice(price);
784         emitCampaignUpdated(campaigns[bidId]);
785     }
786 
787     /**
788     @notice Get the budget avaliable of a campaign
789     
790         Based on the Campaign id, return the total value avaliable to pay for proofs of attention.
791     @param bidId Campaign id to which the query refers
792     @return { "budget" : "Total value (in wei) spendable in proof of attention rewards"} 
793     */
794     function getCampaignBudgetById(bytes32 bidId)
795         public
796         view
797         returns (uint budget) {
798         return campaigns[bidId].getBudget();
799     }
800 
801     /**
802     @notice Set a new campaign budget
803     
804         Based on the Campaign id, updates the total value avaliable for proof of attention 
805         registrations. This function can only be executed by allowed addresses and emits a 
806         CampaignUpdated event. This function does not transfer any funds as this contract only works
807         as a data repository, every logic needed will be processed in the Advertisement contract.
808     @param bidId Campaign id to which the query refers
809     @param newBudget New value for the total budget of the campaign
810     */
811     function setCampaignBudgetById(bytes32 bidId, uint newBudget)
812         public
813         onlyIfCampaignExists("setCampaignBudgetById",bidId)
814         onlyIfWhitelisted("setCampaignBudgetById",msg.sender)
815         {
816         campaigns[bidId].setBudget(newBudget);
817         emitCampaignUpdated(campaigns[bidId]);
818     }
819 
820     /** 
821     @notice Get the start date of a campaign
822     
823         Based on the Campaign id, return the value (in miliseconds) corresponding to the start Date
824         of the campaign.
825     @param bidId Campaign id to which the query refers
826     @return { "startDate" : "Start date (in miliseconds) of the campaign"} 
827     */
828     function getCampaignStartDateById(bytes32 bidId)
829         public
830         view
831         returns (uint startDate) {
832         return campaigns[bidId].getStartDate();
833     }
834 
835     /**
836     @notice Set a new start date for a campaign
837     
838         Based of the Campaign id, updates the start date of a campaign. This function can only be 
839         executed by allowed addresses and emits a CampaignUpdated event.
840     @param bidId Campaign id to which the query refers
841     @param newStartDate New value (in miliseconds) for the start date of the campaign
842     */
843     function setCampaignStartDateById(bytes32 bidId, uint newStartDate)
844         public
845         onlyIfCampaignExists("setCampaignStartDateById",bidId)
846         onlyIfWhitelisted("setCampaignStartDateById",msg.sender)
847         {
848         campaigns[bidId].setStartDate(newStartDate);
849         emitCampaignUpdated(campaigns[bidId]);
850     }
851     
852     /** 
853     @notice Get the end date of a campaign
854     
855         Based on the Campaign id, return the value (in miliseconds) corresponding to the end Date
856         of the campaign.
857     @param bidId Campaign id to which the query refers
858     @return { "endDate" : "End date (in miliseconds) of the campaign"} 
859     */
860     function getCampaignEndDateById(bytes32 bidId)
861         public
862         view
863         returns (uint endDate) {
864         return campaigns[bidId].getEndDate();
865     }
866 
867     /**
868     @notice Set a new end date for a campaign
869     
870         Based of the Campaign id, updates the end date of a campaign. This function can only be 
871         executed by allowed addresses and emits a CampaignUpdated event.
872     @param bidId Campaign id to which the query refers
873     @param newEndDate New value (in miliseconds) for the end date of the campaign
874     */
875     function setCampaignEndDateById(bytes32 bidId, uint newEndDate)
876         public
877         onlyIfCampaignExists("setCampaignEndDateById",bidId)
878         onlyIfWhitelisted("setCampaignEndDateById",msg.sender)
879         {
880         campaigns[bidId].setEndDate(newEndDate);
881         emitCampaignUpdated(campaigns[bidId]);
882     }
883     /** 
884     @notice Get information regarding validity of a campaign.
885     
886         Based on the Campaign id, return a boolean which represents a valid campaign if it has 
887         the value of True else has the value of False.
888     @param bidId Campaign id to which the query refers
889     @return { "valid" : "Validity of the campaign"} 
890     */
891     function getCampaignValidById(bytes32 bidId)
892         public
893         view
894         returns (bool valid) {
895         return campaigns[bidId].getValidity();
896     }
897 
898     /**
899     @notice Set a new campaign validity state.
900     
901         Updates the validity of a campaign based on a campaign Id. This function can only be 
902         executed by allowed addresses and emits a CampaignUpdated event.
903     @param bidId Campaign id to which the query refers
904     @param isValid New value for the campaign validity
905     */
906     function setCampaignValidById(bytes32 bidId, bool isValid)
907         public
908         onlyIfCampaignExists("setCampaignValidById",bidId)
909         onlyIfWhitelisted("setCampaignValidById",msg.sender)
910         {
911         campaigns[bidId].setValidity(isValid);
912         emitCampaignUpdated(campaigns[bidId]);
913     }
914 
915     /**
916     @notice Get the owner of a campaign 
917      
918         Based on the Campaign id, return the address of the campaign owner.
919     @param bidId Campaign id to which the query refers
920     @return { "campOwner" : "Address of the campaign owner" } 
921     */
922     function getCampaignOwnerById(bytes32 bidId)
923         public
924         view
925         returns (address campOwner) {
926         return campaigns[bidId].getOwner();
927     }
928 
929     /**
930     @notice Set a new campaign owner 
931     
932         Based on the Campaign id, update the owner of the refered campaign. This function can only 
933         be executed by allowed addresses and emits a CampaignUpdated event.
934     @param bidId Campaign id to which the query refers
935     @param newOwner New address to be the owner of the campaign
936     */
937     function setCampaignOwnerById(bytes32 bidId, address newOwner)
938         public
939         onlyIfCampaignExists("setCampaignOwnerById",bidId)
940         onlyIfWhitelisted("setCampaignOwnerById",msg.sender)
941         {
942         campaigns[bidId].setOwner(newOwner);
943         emitCampaignUpdated(campaigns[bidId]);
944     }
945 
946     /**
947     @notice Function to emit campaign updates
948     
949         It emits a CampaignUpdated event with the new campaign information. 
950     */
951     function emitCampaignUpdated(CampaignLibrary.Campaign storage campaign) private {
952         emit CampaignUpdated(
953             campaign.getBidId(),
954             campaign.getPrice(),
955             campaign.getBudget(),
956             campaign.getStartDate(),
957             campaign.getEndDate(),
958             campaign.getValidity(),
959             campaign.getOwner()
960         );
961     }
962 
963     /**
964     @notice Function to emit campaign creations
965     
966         It emits a CampaignCreated event with the new campaign created. 
967     */
968     function emitCampaignCreated(CampaignLibrary.Campaign storage campaign) private {
969         emit CampaignCreated(
970             campaign.getBidId(),
971             campaign.getPrice(),
972             campaign.getBudget(),
973             campaign.getStartDate(),
974             campaign.getEndDate(),
975             campaign.getValidity(),
976             campaign.getOwner()
977         );
978     }
979 
980     /**
981     @notice Internal function to set most recent bidId
982     
983         This value is stored to avoid conflicts between
984         Advertisement contract upgrades.
985     @param _newBidId Newer bidId
986      */
987     function setLastBidId(bytes32 _newBidId) internal {    
988         lastBidId = _newBidId;
989     }
990 
991     /**
992     @notice Returns the greatest BidId ever registered to the contract
993     @return { '_lastBidId' : 'Greatest bidId registered to the contract'}
994      */
995     function getLastBidId() 
996         external 
997         returns (bytes32 _lastBidId){
998         
999         return lastBidId;
1000     }
1001 }
1002 
1003 contract ExtendedAdvertisementStorage is BaseAdvertisementStorage {
1004     using ExtendedCampaignLibrary for ExtendedCampaignLibrary.ExtendedInfo;
1005 
1006     mapping (bytes32 => ExtendedCampaignLibrary.ExtendedInfo) public extendedCampaignInfo;
1007     
1008     event ExtendedCampaignCreated(
1009         bytes32 bidId,
1010         address rewardManager,
1011         string endPoint
1012     );
1013 
1014     event ExtendedCampaignUpdated(
1015         bytes32 bidId,
1016         address rewardManager,
1017         string endPoint
1018     );
1019 
1020     /**
1021     @notice Get a Campaign information
1022     @param _campaignId Id of the campaign
1023     @return {
1024         "_bidId" : "Id of the campaign",
1025         "_price" : "Value to pay for each proof-of-attention",
1026         "_budget" : "Total value avaliable to be spent on the campaign",
1027         "_startDate" : "Start date of the campaign (in miliseconds)",
1028         "_endDate" : "End date of the campaign (in miliseconds)"
1029         "_valid" : "Boolean informing if the campaign is valid",
1030         "_campOwner" : "Address of the campaing's owner",
1031     }
1032     */
1033     function getCampaign(bytes32 _campaignId)
1034         public
1035         view
1036         returns (
1037             bytes32 _bidId,
1038             uint _price,
1039             uint _budget,
1040             uint _startDate,
1041             uint _endDate,
1042             bool _valid,
1043             address _campOwner
1044         ) {
1045 
1046         CampaignLibrary.Campaign storage campaign = _getCampaign(_campaignId);
1047 
1048         return (
1049             campaign.getBidId(),
1050             campaign.getPrice(),
1051             campaign.getBudget(),
1052             campaign.getStartDate(),
1053             campaign.getEndDate(),
1054             campaign.getValidity(),
1055             campaign.getOwner()
1056         );
1057     }
1058 
1059     /**
1060     @notice Add or update a campaign information
1061 
1062     @param _bidId Id of the campaign
1063     @param _price Value to pay for each proof-of-attention
1064     @param _budget Total value avaliable to be spent on the campaign
1065     @param _startDate Start date of the campaign (in miliseconds)
1066     @param _endDate End date of the campaign (in miliseconds)
1067     @param _valid Boolean informing if the campaign is valid
1068     @param _owner Address of the campaing's owner
1069     @param _rewardManager Address of the entity entitled to manage the rewards (single PoA)
1070     @param _endPoint URL of the signing serivce
1071     */
1072     function setCampaign (
1073         bytes32 _bidId,
1074         uint _price,
1075         uint _budget,
1076         uint _startDate,
1077         uint _endDate,
1078         bool _valid,
1079         address _owner,
1080         address _rewardManager,
1081         string _endPoint
1082     )
1083     public
1084     onlyIfWhitelisted("setCampaign",msg.sender) {
1085         
1086         bool newCampaign = (getCampaignOwnerById(_bidId) == 0x0);
1087         _setCampaign(_bidId, _price, _budget, _startDate, _endDate, _valid, _owner);
1088         
1089         ExtendedCampaignLibrary.ExtendedInfo storage extendedInfo = extendedCampaignInfo[_bidId];
1090         extendedInfo.setBidId(_bidId);
1091         extendedInfo.setRewardManager(_rewardManager);
1092         extendedInfo.setEndpoint(_endPoint);
1093 
1094         extendedCampaignInfo[_bidId] = extendedInfo;
1095 
1096         if(newCampaign){
1097             emit ExtendedCampaignCreated(_bidId,_rewardManager,_endPoint);
1098         } else {
1099             emit ExtendedCampaignUpdated(_bidId,_rewardManager,_endPoint);
1100         }
1101     }
1102 
1103     /**
1104     @notice Get campaign signing web service endpoint
1105     @param _bidId Id of the campaign
1106     @return { "_endPoint": "URL for the signing web service"}
1107     */
1108 
1109     function getCampaignEndPointById(bytes32 _bidId) 
1110         public returns (string _endPoint){
1111         return extendedCampaignInfo[_bidId].getEndpoint();
1112     }
1113 
1114     /**
1115     @notice Set campaign signing web service endpoint
1116     @param _bidId Id of the campaign
1117     @param _endPoint URL for the signing web service
1118     */
1119     function setCampaignEndPointById(bytes32 _bidId, string _endPoint) 
1120         public 
1121         onlyIfCampaignExists("setCampaignEndPointById",_bidId)
1122         onlyIfWhitelisted("setCampaignEndPointById",msg.sender) 
1123         {
1124         extendedCampaignInfo[_bidId].setEndpoint(_endPoint);
1125         address _rewardManager = extendedCampaignInfo[_bidId].getRewardManager();
1126         emit ExtendedCampaignUpdated(_bidId,_rewardManager,_endPoint);
1127     }
1128 
1129     /**
1130     @notice Set reward manager address
1131     @param _bidId Id of the campaign
1132     @param _rewardManager address of the reward manager
1133     */
1134     function setRewardManagerById(bytes32 _bidId, address _rewardManager)
1135         public
1136         onlyIfCampaignExists("setRewardManagerById",_bidId)
1137         onlyIfWhitelisted("setRewardManagerById",msg.sender)
1138         {
1139         extendedCampaignInfo[_bidId].setRewardManager(_rewardManager);
1140     }
1141 
1142     /**
1143     @notice Get reward manager address
1144     @param _bidId Id of the campaign
1145     @return { "_rewardManager" : "address of the reward manager"} 
1146     */
1147     function getRewardManagerById(bytes32 _bidId) 
1148         public 
1149         returns (address _rewardManager){
1150         return extendedCampaignInfo[_bidId].getRewardManager();
1151     }
1152 
1153 }
1154 
1155 
1156 contract BaseAdvertisement is StorageUser,Ownable {
1157     
1158     AppCoins public appc;
1159     BaseFinance public advertisementFinance;
1160     BaseAdvertisementStorage public advertisementStorage;
1161 
1162     mapping( bytes32 => mapping(address => uint256)) public userAttributions;
1163 
1164     bytes32[] public bidIdList;
1165     bytes32 public lastBidId = 0x0;
1166 
1167 
1168     /**
1169     @notice Constructor function
1170         Initializes contract with default validation rules
1171     @param _addrAppc Address of the AppCoins (ERC-20) contract
1172     @param _addrAdverStorage Address of the Advertisement Storage contract to be used
1173     @param _addrAdverFinance Address of the Advertisement Finance contract to be used
1174     */
1175     constructor(address _addrAppc, address _addrAdverStorage, address _addrAdverFinance) public {
1176         appc = AppCoins(_addrAppc);
1177 
1178         advertisementStorage = BaseAdvertisementStorage(_addrAdverStorage);
1179         advertisementFinance = BaseFinance(_addrAdverFinance);
1180         lastBidId = advertisementStorage.getLastBidId();
1181     }
1182 
1183 
1184 
1185     /**
1186     @notice Import existing bidIds
1187         Method to import existing BidId list from an existing BaseAdvertisement contract
1188         Be careful, this function does not chcek for duplicates.
1189     @param _addrAdvert Address of the existing Advertisement contract from which the bidIds
1190      will be imported  
1191     */
1192 
1193     function importBidIds(address _addrAdvert) public onlyOwner("importBidIds") {
1194 
1195         bytes32[] memory _bidIdsToImport = BaseAdvertisement(_addrAdvert).getBidIdList();
1196         bytes32 _lastStorageBidId = advertisementStorage.getLastBidId();
1197 
1198         for (uint i = 0; i < _bidIdsToImport.length; i++) {
1199             bidIdList.push(_bidIdsToImport[i]);
1200         }
1201         
1202         if(lastBidId < _lastStorageBidId) {
1203             lastBidId = _lastStorageBidId;
1204         }
1205     }
1206 
1207     /**
1208     @notice Upgrade finance contract used by this contract
1209         This function is part of the upgrade mechanism avaliable to the advertisement contracts.
1210         Using this function it is possible to update to a new Advertisement Finance contract without
1211         the need to cancel avaliable campaigns.
1212         Upgrade finance function can only be called by the Advertisement contract owner.
1213     @param addrAdverFinance Address of the new Advertisement Finance contract
1214     */
1215     function upgradeFinance (address addrAdverFinance) public onlyOwner("upgradeFinance") {
1216         BaseFinance newAdvFinance = BaseFinance(addrAdverFinance);
1217 
1218         address[] memory devList = advertisementFinance.getUserList();
1219         
1220         for(uint i = 0; i < devList.length; i++){
1221             uint balance = advertisementFinance.getUserBalance(devList[i]);
1222             newAdvFinance.increaseBalance(devList[i],balance);
1223         }
1224         
1225         uint256 initBalance = appc.balanceOf(address(advertisementFinance));
1226         advertisementFinance.transferAllFunds(address(newAdvFinance));
1227         uint256 oldBalance = appc.balanceOf(address(advertisementFinance));
1228         uint256 newBalance = appc.balanceOf(address(newAdvFinance));
1229         
1230         require(initBalance == newBalance);
1231         require(oldBalance == 0);
1232         advertisementFinance = newAdvFinance;
1233     }
1234 
1235     /**
1236     @notice Upgrade storage contract used by this contract
1237         Upgrades Advertisement Storage contract addres with no need to redeploy
1238         Advertisement contract. However every campaign in the old contract will
1239         be canceled.
1240         This function can only be called by the Advertisement contract owner.
1241     @param addrAdverStorage Address of the new Advertisement Storage contract
1242     */
1243 
1244     function upgradeStorage (address addrAdverStorage) public onlyOwner("upgradeStorage") {
1245         for(uint i = 0; i < bidIdList.length; i++) {
1246             cancelCampaign(bidIdList[i]);
1247         }
1248         delete bidIdList;
1249 
1250         lastBidId = advertisementStorage.getLastBidId();
1251         advertisementFinance.setAdsStorageAddress(addrAdverStorage);
1252         advertisementStorage = BaseAdvertisementStorage(addrAdverStorage);
1253     }
1254 
1255 
1256     /**
1257     @notice Get Advertisement Storage Address used by this contract
1258         This function is required to upgrade Advertisement contract address on Advertisement
1259         Finance contract. This function can only be called by the Advertisement Finance
1260         contract registered in this contract.
1261     @return {
1262         "storageContract" : "Address of the Advertisement Storage contract used by this contract"
1263         }
1264     */
1265 
1266     function getStorageAddress() public view returns(address storageContract) {
1267         require (msg.sender == address(advertisementFinance));
1268 
1269         return address(advertisementStorage);
1270     }
1271 
1272 
1273     /**
1274     @notice Creates a campaign 
1275         Method to create a campaign of user aquisition for a certain application.
1276         This method will emit a Campaign Information event with every information 
1277         provided in the arguments of this method.
1278     @param packageName Package name of the appication subject to the user aquisition campaign
1279     @param countries Encoded list of 3 integers intended to include every 
1280     county where this campaign will be avaliable.
1281     For more detain on this encoding refer to wiki documentation.
1282     @param vercodes List of version codes to which the user aquisition campaign is applied.
1283     @param price Value (in wei) the campaign owner pays for each proof-of-attention.
1284     @param budget Total budget (in wei) the campaign owner will deposit 
1285     to pay for the proof-of-attention.
1286     @param startDate Date (in miliseconds) on which the campaign will start to be 
1287     avaliable to users.
1288     @param endDate Date (in miliseconds) on which the campaign will no longer be avaliable to users.
1289     */
1290 
1291     function _generateCampaign (
1292         string packageName,
1293         uint[3] countries,
1294         uint[] vercodes,
1295         uint price,
1296         uint budget,
1297         uint startDate,
1298         uint endDate)
1299         internal returns (CampaignLibrary.Campaign memory) {
1300 
1301         require(budget >= price);
1302         require(endDate >= startDate);
1303 
1304 
1305         //Transfers the budget to contract address
1306         if(appc.allowance(msg.sender, address(this)) >= budget){
1307             appc.transferFrom(msg.sender, address(advertisementFinance), budget);
1308 
1309             advertisementFinance.increaseBalance(msg.sender,budget);
1310 
1311             uint newBidId = bytesToUint(lastBidId);
1312             lastBidId = uintToBytes(++newBidId);
1313             
1314 
1315             CampaignLibrary.Campaign memory newCampaign;
1316             newCampaign.price = price;
1317             newCampaign.startDate = startDate;
1318             newCampaign.endDate = endDate;
1319             newCampaign.budget = budget;
1320             newCampaign.owner = msg.sender;
1321             newCampaign.valid = true;
1322             newCampaign.bidId = lastBidId;
1323         } else {
1324             emit Error("createCampaign","Not enough allowance");
1325         }
1326         
1327         return newCampaign;
1328     }
1329 
1330     function _getStorage() internal returns (BaseAdvertisementStorage) {
1331         return advertisementStorage;
1332     }
1333 
1334     function _getFinance() internal returns (BaseFinance) {
1335         return advertisementFinance;
1336     }
1337 
1338     function _setUserAttribution(bytes32 _bidId,address _user,uint256 _attributions) internal{
1339         userAttributions[_bidId][_user] = _attributions;
1340     }
1341 
1342 
1343     function getUserAttribution(bytes32 _bidId,address _user) internal returns (uint256) {
1344         return userAttributions[_bidId][_user];
1345     }
1346 
1347     /**
1348     @notice Cancel a campaign and give the remaining budget to the campaign owner
1349         When a campaing owner wants to cancel a campaign, the campaign owner needs
1350         to call this function. This function can only be called either by the campaign owner or by
1351         the Advertisement contract owner. This function results in campaign cancelation and
1352         retreival of the remaining budget to the respective campaign owner.
1353     @param bidId Campaign id to which the cancelation referes to
1354      */
1355     function cancelCampaign (bytes32 bidId) public {
1356         address campaignOwner = getOwnerOfCampaign(bidId);
1357 
1358 		// Only contract owner or campaign owner can cancel a campaign
1359         require(owner == msg.sender || campaignOwner == msg.sender);
1360         uint budget = getBudgetOfCampaign(bidId);
1361 
1362         advertisementFinance.withdraw(campaignOwner, budget);
1363 
1364         advertisementStorage.setCampaignBudgetById(bidId, 0);
1365         advertisementStorage.setCampaignValidById(bidId, false);
1366     }
1367 
1368      /**
1369     @notice Get a campaign validity state
1370     @param bidId Campaign id to which the query refers
1371     @return { "state" : "Validity of the campaign"}
1372     */
1373     function getCampaignValidity(bytes32 bidId) public view returns(bool state){
1374         return advertisementStorage.getCampaignValidById(bidId);
1375     }
1376 
1377     /**
1378     @notice Get the price of a campaign
1379         Based on the Campaign id return the value paid for each proof of attention registered.
1380     @param bidId Campaign id to which the query refers
1381     @return { "price" : "Reward (in wei) for each proof of attention registered"}
1382     */
1383     function getPriceOfCampaign (bytes32 bidId) public view returns(uint price) {
1384         return advertisementStorage.getCampaignPriceById(bidId);
1385     }
1386 
1387     /**
1388     @notice Get the start date of a campaign
1389         Based on the Campaign id return the value (in miliseconds) corresponding to the start Date
1390         of the campaign.
1391     @param bidId Campaign id to which the query refers
1392     @return { "startDate" : "Start date (in miliseconds) of the campaign"}
1393     */
1394     function getStartDateOfCampaign (bytes32 bidId) public view returns(uint startDate) {
1395         return advertisementStorage.getCampaignStartDateById(bidId);
1396     }
1397 
1398     /**
1399     @notice Get the end date of a campaign
1400         Based on the Campaign id return the value (in miliseconds) corresponding to the end Date
1401         of the campaign.
1402     @param bidId Campaign id to which the query refers
1403     @return { "endDate" : "End date (in miliseconds) of the campaign"}
1404     */
1405     function getEndDateOfCampaign (bytes32 bidId) public view returns(uint endDate) {
1406         return advertisementStorage.getCampaignEndDateById(bidId);
1407     }
1408 
1409     /**
1410     @notice Get the budget avaliable of a campaign
1411         Based on the Campaign id return the total value avaliable to pay for proofs of attention.
1412     @param bidId Campaign id to which the query refers
1413     @return { "budget" : "Total value (in wei) spendable in proof of attention rewards"}
1414     */
1415     function getBudgetOfCampaign (bytes32 bidId) public view returns(uint budget) {
1416         return advertisementStorage.getCampaignBudgetById(bidId);
1417     }
1418 
1419 
1420     /**
1421     @notice Get the owner of a campaign
1422         Based on the Campaign id return the address of the campaign owner
1423     @param bidId Campaign id to which the query refers
1424     @return { "campaignOwner" : "Address of the campaign owner" }
1425     */
1426     function getOwnerOfCampaign (bytes32 bidId) public view returns(address campaignOwner) {
1427         return advertisementStorage.getCampaignOwnerById(bidId);
1428     }
1429 
1430     /**
1431     @notice Get the list of Campaign BidIds registered in the contract
1432         Returns the list of BidIds of the campaigns ever registered in the contract
1433     @return { "bidIds" : "List of BidIds registered in the contract" }
1434     */
1435     function getBidIdList() public view returns(bytes32[] bidIds) {
1436         return bidIdList;
1437     }
1438 
1439     function _getBidIdList() internal returns(bytes32[] storage bidIds){
1440         return bidIdList;
1441     }
1442 
1443     /**
1444     @notice Check if a certain campaign is still valid
1445         Returns a boolean representing the validity of the campaign
1446         Has value of True if the campaign is still valid else has value of False
1447     @param bidId Campaign id to which the query refers
1448     @return { "valid" : "validity of the campaign" }
1449     */
1450     function isCampaignValid(bytes32 bidId) public view returns(bool valid) {
1451         uint startDate = advertisementStorage.getCampaignStartDateById(bidId);
1452         uint endDate = advertisementStorage.getCampaignEndDateById(bidId);
1453         bool validity = advertisementStorage.getCampaignValidById(bidId);
1454 
1455         uint nowInMilliseconds = now * 1000;
1456         return validity && startDate < nowInMilliseconds && endDate > nowInMilliseconds;
1457     }
1458 
1459     /**
1460     @notice Converts a uint256 type variable to a byte32 type variable
1461         Mostly used internaly
1462     @param i number to be converted
1463     @return { "b" : "Input number converted to bytes"}
1464     */
1465     function uintToBytes (uint256 i) public view returns(bytes32 b) {
1466         b = bytes32(i);
1467     }
1468 
1469     function bytesToUint(bytes32 b) public view returns (uint) 
1470     {
1471         return uint(b) & 0xfff;
1472     }
1473 
1474 }
1475 
1476 
1477 contract Signature {
1478 
1479     /**
1480     @notice splitSignature
1481     
1482         Based on a signature Sig (bytes32), returns the r, s, v
1483     @param sig Signature
1484     @return {
1485         "uint8" : "recover Id",
1486         "bytes32" : "Output of the ECDSA signature",
1487         "bytes32" : "Output of the ECDSA signature",
1488     }
1489     */
1490     function splitSignature(bytes sig)
1491         internal
1492         pure
1493         returns (uint8, bytes32, bytes32)
1494         {
1495         require(sig.length == 65);
1496 
1497         bytes32 r;
1498         bytes32 s;
1499         uint8 v;
1500 
1501         assembly {
1502             // first 32 bytes, after the length prefix
1503             r := mload(add(sig, 32))
1504             // second 32 bytes
1505             s := mload(add(sig, 64))
1506             // final byte (first byte of the next 32 bytes)
1507             v := byte(0, mload(add(sig, 96)))
1508         }
1509 
1510         return (v, r, s);
1511     }
1512 
1513     /**
1514     @notice recoverSigner
1515     
1516         Based on a message and signature returns the address
1517     @param message Message
1518     @param sig Signature
1519     @return {
1520         "address" : "Address of the private key that signed",
1521     }
1522     */
1523     function recoverSigner(bytes32 message, bytes sig)
1524         public
1525         pure
1526         returns (address)
1527         {
1528         uint8 v;
1529         bytes32 r;
1530         bytes32 s;
1531 
1532         (v, r, s) = splitSignature(sig);
1533 
1534         return ecrecover(message, v, r, s);
1535     }
1536 }
1537 
1538 
1539 contract BaseFinance is SingleAllowance {
1540 
1541     mapping (address => uint256) balanceUsers;
1542     mapping (address => bool) userExists;
1543 
1544     address[] users;
1545 
1546     address advStorageContract;
1547 
1548     AppCoins appc;
1549 
1550     /**
1551     @notice Constructor function
1552      
1553         Initializes contract with the AppCoins contract address
1554     @param _addrAppc Address of the AppCoins (ERC-20) contract
1555     */
1556     constructor (address _addrAppc) 
1557         public {
1558         appc = AppCoins(_addrAppc);
1559         advStorageContract = 0x0;
1560     }
1561 
1562 
1563     /**
1564     @notice Sets the Storage contract address used by the allowed contract
1565     
1566         The Storage contract address is mostly used as part of a failsafe mechanism to
1567         ensure contract upgrades are executed using the same Storage 
1568         contract. This function returns every value of AppCoins stored in this contract to their 
1569         owners. This function can only be called by the 
1570         Finance contract owner or by the allowed contract registered earlier in 
1571         this contract.
1572     @param _addrStorage Address of the new Storage contract
1573     */
1574     function setAdsStorageAddress (address _addrStorage) external onlyOwnerOrAllowed {
1575         reset();
1576         advStorageContract = _addrStorage;
1577     }
1578 
1579         /**
1580     @notice Sets the Advertisement contract address to allow calls from Advertisement contract
1581     
1582         This function is used for upgrading the Advertisement contract without need to redeploy 
1583         Advertisement Finance and Advertisement Storage contracts. The function can only be called 
1584         by this contract's owner. During the update of the Advertisement contract address, the 
1585         contract for Advertisement Storage used by the new Advertisement contract is checked. 
1586         This function reverts if the new Advertisement contract does not use the same Advertisement 
1587         Storage contract earlier registered in this Advertisement Finance contract.
1588     @param _addr Address of the newly allowed contract 
1589     */
1590     function setAllowedAddress (address _addr) public onlyOwner("setAllowedAddress") {
1591         // Verify if the new Ads contract is using the same storage as before 
1592         if (allowedAddress != 0x0){
1593             StorageUser storageUser = StorageUser(_addr);
1594             address storageContract = storageUser.getStorageAddress();
1595             require (storageContract == advStorageContract);
1596         }
1597         
1598         //Update contract
1599         super.setAllowedAddress(_addr);
1600     }
1601 
1602     /**
1603     @notice Increases balance of a user
1604     
1605         This function can only be called by the registered Advertisement contract and increases the 
1606         balance of a specific user on this contract. This function does not transfer funds, 
1607         this step need to be done earlier by the Advertisement contract. This function can only be 
1608         called by the registered Advertisement contract.
1609     @param _user Address of the user who will receive a balance increase
1610     @param _value Value of coins to increase the user's balance
1611     */
1612     function increaseBalance(address _user, uint256 _value) 
1613         public onlyAllowed{
1614 
1615         if(userExists[_user] == false){
1616             users.push(_user);
1617             userExists[_user] = true;
1618         }
1619 
1620         balanceUsers[_user] += _value;
1621     }
1622 
1623      /**
1624     @notice Transfers coins from a certain user to a destination address
1625     
1626         Used to release a certain value of coins from a certain user to a destination address.
1627         This function updates the user's balance in the contract. It can only be called by the 
1628         Advertisement contract registered.
1629     @param _user Address of the user from which the value will be subtracted
1630     @param _destination Address receiving the value transfered
1631     @param _value Value to be transfered in AppCoins
1632     */
1633     function pay(address _user, address _destination, uint256 _value) public onlyAllowed;
1634 
1635     /**
1636     @notice Withdraws a certain value from a user's balance back to the user's account
1637     
1638         Can be called from the Advertisement contract registered or by this contract's owner.
1639     @param _user Address of the user
1640     @param _value Value to be transfered in AppCoins
1641     */
1642     function withdraw(address _user, uint256 _value) public onlyOwnerOrAllowed;
1643 
1644 
1645     /**
1646     @notice Resets this contract and returns every amount deposited to each user registered
1647     
1648         This function is used in case a contract reset is needed or the contract needs to be 
1649         deactivated. Thus returns every fund deposited to it's respective owner.
1650     */
1651     function reset() public onlyOwnerOrAllowed {
1652         for(uint i = 0; i < users.length; i++){
1653             withdraw(users[i],balanceUsers[users[i]]);
1654         }
1655     }
1656     /**
1657     @notice Transfers all funds of the contract to a single address
1658     
1659         This function is used for finance contract upgrades in order to be more cost efficient.
1660     @param _destination Address receiving the funds
1661      */
1662     function transferAllFunds(address _destination) public onlyAllowed {
1663         uint256 balance = appc.balanceOf(address(this));
1664         appc.transfer(_destination,balance);
1665     }
1666 
1667       /**
1668     @notice Get balance of coins stored in the contract by a specific user
1669     
1670         This function can only be called by the Advertisement contract
1671     @param _user Developer's address
1672     @return { '_balance' : 'Balance of coins deposited in the contract by the address' }
1673     */
1674     function getUserBalance(address _user) public view onlyAllowed returns(uint256 _balance){
1675         return balanceUsers[_user];
1676     }
1677 
1678     /**
1679     @notice Get list of users with coins stored in the contract 
1680     
1681         This function can only be called by the Advertisement contract        
1682     @return { '_userList' : ' List of users registered in the contract'}
1683     */
1684     function getUserList() public view onlyAllowed returns(address[] _userList){
1685         return users;
1686     }
1687 }
1688 
1689 contract ExtendedFinance is BaseFinance {
1690 
1691     mapping ( address => uint256 ) rewardedBalance;
1692 
1693     constructor(address _appc) public BaseFinance(_appc){
1694 
1695     }
1696 
1697 
1698     function pay(address _user, address _destination, uint256 _value)
1699         public onlyAllowed{
1700 
1701         require(balanceUsers[_user] >= _value);
1702 
1703         balanceUsers[_user] -= _value;
1704         rewardedBalance[_destination] += _value;
1705     }
1706 
1707 
1708     function withdraw(address _user, uint256 _value) public onlyOwnerOrAllowed {
1709 
1710         require(balanceUsers[_user] >= _value);
1711 
1712         balanceUsers[_user] -= _value;
1713         appc.transfer(_user, _value);
1714 
1715     }
1716 
1717     /**
1718     @notice Withdraws user's rewards
1719     
1720         Function to transfer a certain user's rewards to his address 
1721     @param _user Address who's rewards will be withdrawn
1722     @param _value Value of the withdraws which will be transfered to the user 
1723     */
1724     function withdrawRewards(address _user, uint256 _value) public onlyOwnerOrAllowed {
1725         require(rewardedBalance[_user] >= _value);
1726 
1727         rewardedBalance[_user] -= _value;
1728         appc.transfer(_user, _value);
1729     }
1730     /**
1731     @notice Get user's rewards balance
1732     
1733         Function returning a user's rewards balance not yet withdrawn
1734     @param _user Address of the user
1735     @return { "_balance" : "Rewards balance of the user" }
1736     */
1737     function getRewardsBalance(address _user) public onlyOwnerOrAllowed returns (uint256 _balance) {
1738         return rewardedBalance[_user];
1739     }
1740 
1741 }
1742 
1743 
1744 library SafeMath {
1745 
1746   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
1747     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1748     // benefit is lost if 'b' is also tested.
1749     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1750     if (_a == 0) {
1751       return 0;
1752     }
1753 
1754     c = _a * _b;
1755     assert(c / _a == _b);
1756     return c;
1757   }
1758 
1759   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
1760     // assert(_b > 0); // Solidity automatically throws when dividing by 0
1761     // uint256 c = _a / _b;
1762     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
1763     return _a / _b;
1764   }
1765 
1766 
1767   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
1768     assert(_b <= _a);
1769     return _a - _b;
1770   }
1771 
1772   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
1773     c = _a + _b;
1774     assert(c >= _a);
1775     return c;
1776   }
1777 }
1778 
1779 
1780 contract ExtendedAdvertisement is BaseAdvertisement, Whitelist {
1781 
1782     event BulkPoARegistered(bytes32 _bidId, bytes _rootHash, bytes _signature, uint256 _newHashes, uint256 _effectiveConversions);
1783     event SinglePoARegistered(bytes32 _bidId, bytes _timestampAndHash, bytes _signature);
1784     event CampaignInformation
1785         (
1786             bytes32 bidId,
1787             address  owner,
1788             string ipValidator,
1789             string packageName,
1790             uint[3] countries,
1791             uint[] vercodes
1792     );
1793     event ExtendedCampaignInfo
1794         (
1795             bytes32 bidId,
1796             address rewardManager,
1797             string endPoint
1798     );
1799 
1800     constructor(address _addrAppc, address _addrAdverStorage, address _addrAdverFinance) public
1801         BaseAdvertisement(_addrAppc,_addrAdverStorage,_addrAdverFinance) {
1802         addAddressToWhitelist(msg.sender);
1803     }
1804 
1805 
1806     function createCampaign (
1807         string packageName,
1808         uint[3] countries,
1809         uint[] vercodes,
1810         uint price,
1811         uint budget,
1812         uint startDate,
1813         uint endDate,
1814         address rewardManager,
1815         string endPoint)
1816         external
1817         {
1818 
1819         CampaignLibrary.Campaign memory newCampaign = _generateCampaign(packageName, countries, vercodes, price, budget, startDate, endDate);
1820 
1821         if(newCampaign.owner == 0x0){
1822             // campaign was not generated correctly (revert)
1823             return;
1824         }
1825 
1826         _getBidIdList().push(newCampaign.bidId);
1827 
1828         ExtendedAdvertisementStorage(address(_getStorage())).setCampaign(
1829             newCampaign.bidId,
1830             newCampaign.price,
1831             newCampaign.budget,
1832             newCampaign.startDate,
1833             newCampaign.endDate,
1834             newCampaign.valid,
1835             newCampaign.owner,
1836             rewardManager,
1837             endPoint);
1838 
1839         emit CampaignInformation(
1840             newCampaign.bidId,
1841             newCampaign.owner,
1842             "", // ipValidator field
1843             packageName,
1844             countries,
1845             vercodes);
1846 
1847         emit ExtendedCampaignInfo(newCampaign.bidId, rewardManager, endPoint);
1848     }
1849 
1850     function bulkRegisterPoA(bytes32 _bidId, bytes _rootHash, bytes _signature, uint256 _newHashes)
1851         public
1852         onlyIfWhitelisted("createCampaign", msg.sender)
1853         {
1854 
1855         uint price = _getStorage().getCampaignPriceById(_bidId);
1856         uint budget = _getStorage().getCampaignBudgetById(_bidId);
1857         address owner = _getStorage().getCampaignOwnerById(_bidId);
1858         uint maxConversions = SafeMath.div(budget,price);
1859         uint effectiveConversions;
1860         uint totalPay;
1861         uint newBudget;
1862 
1863         if (maxConversions >= _newHashes){
1864             effectiveConversions = _newHashes;
1865         } else {
1866             effectiveConversions = maxConversions;
1867         }
1868 
1869         totalPay = SafeMath.mul(price,effectiveConversions);
1870         
1871         newBudget = SafeMath.sub(budget,totalPay);
1872 
1873         _getFinance().pay(owner, msg.sender, totalPay);
1874         _getStorage().setCampaignBudgetById(_bidId, newBudget);
1875 
1876         if(newBudget < price){
1877             _getStorage().setCampaignValidById(_bidId, false);
1878         }
1879 
1880         emit BulkPoARegistered(_bidId, _rootHash, _signature, _newHashes, effectiveConversions);
1881     }
1882 
1883 
1884     function withdraw()
1885         public
1886         onlyIfWhitelisted("withdraw",msg.sender)
1887         {
1888         uint256 balance = ExtendedFinance(address(_getFinance())).getRewardsBalance(msg.sender);
1889         ExtendedFinance(address(_getFinance())).withdrawRewards(msg.sender,balance);
1890     }
1891 
1892     function getRewardsBalance(address _user) public view returns (uint256 _balance) {
1893         return ExtendedFinance(address(_getFinance())).getRewardsBalance(_user);
1894     }
1895 
1896 
1897     function getEndPointOfCampaign (bytes32 bidId) public view returns (string url){
1898         return ExtendedAdvertisementStorage(address(_getStorage())).getCampaignEndPointById(bidId);
1899     }
1900 }