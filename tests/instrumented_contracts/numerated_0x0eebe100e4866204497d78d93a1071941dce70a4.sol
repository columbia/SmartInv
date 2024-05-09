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
13 
14 contract AppCoins is ERC20Interface{
15     // Public variables of the token
16     address public owner;
17     bytes32 private token_name;
18     bytes32 private token_symbol;
19     uint8 public decimals = 18;
20     // 18 decimals is the strongly suggested default, avoid changing it
21     uint256 public totalSupply;
22 
23     // This creates an array with all balances
24     mapping (address => uint256) public balances;
25     mapping (address => mapping (address => uint256)) public allowance;
26 
27     // This generates a public event on the blockchain that will notify clients
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 
30     // This notifies clients about the amount burnt
31     event Burn(address indexed from, uint256 value);
32 
33     /**
34      * Constrctor function
35      *
36      * Initializes contract with initial supply tokens to the creator of the contract
37      */
38     function AppCoins() public {
39         owner = msg.sender;
40         token_name = "AppCoins";
41         token_symbol = "APPC";
42         uint256 _totalSupply = 1000000;
43         totalSupply = _totalSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
44         balances[owner] = totalSupply;                // Give the creator all initial tokens
45     }
46 
47     function name() public view returns(bytes32) {
48         return token_name;
49     }
50 
51     function symbol() public view returns(bytes32) {
52         return token_symbol;
53     }
54 
55     function balanceOf (address _owner) public view returns(uint256 balance) {
56         return balances[_owner];
57     }
58 
59     /**
60      * Internal transfer, only can be called by this contract
61      */
62     function _transfer(address _from, address _to, uint _value) internal returns (bool) {
63         // Prevent transfer to 0x0 address. Use burn() instead
64         require(_to != 0x0);
65         // Check if the sender has enough
66         require(balances[_from] >= _value);
67         // Check for overflows
68         require(balances[_to] + _value > balances[_to]);
69         // Save this for an assertion in the future
70         uint previousBalances = balances[_from] + balances[_to];
71         // Subtract from the sender
72         balances[_from] -= _value;
73         // Add the same to the recipient
74         balances[_to] += _value;
75         emit Transfer(_from, _to, _value);
76         // Asserts are used to use static analysis to find bugs in your code. They should never fail
77         assert(balances[_from] + balances[_to] == previousBalances);
78     }
79 
80     // /**
81     //  * Transfer tokens
82     //  *
83     //  * Send `_value` tokens to `_to` from your account
84     //  *
85     //  * @param _to The address of the recipient
86     //  * @param _value the amount to send
87     //  */
88     // function transfer(address _to, uint256 _value) public {
89     //     _transfer(msg.sender, _to, _value);
90     // }
91     function transfer (address _to, uint256 _amount) public returns (bool success) {
92         if( balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
93 
94             balances[msg.sender] -= _amount;
95             balances[_to] += _amount;
96             emit Transfer(msg.sender, _to, _amount);
97             return true;
98         } else {
99             return false;
100         }
101     }
102 
103     /**
104      * Transfer tokens from other address
105      *
106      * Send `_value` tokens to `_to` on behalf of `_from`
107      *
108      * @param _from The address of the sender
109      * @param _to The address of the recipient
110      * @param _value the amount to send
111      */
112     function transferFrom(address _from, address _to, uint256 _value) public returns (uint) {
113         require(_value <= allowance[_from][msg.sender]);     // Check allowance
114         allowance[_from][msg.sender] -= _value;
115         _transfer(_from, _to, _value);
116         return allowance[_from][msg.sender];
117     }
118 
119     /**
120      * Set allowance for other address
121      *
122      * Allows `_spender` to spend no more than `_value` tokens on your behalf
123      *
124      * @param _spender The address authorized to spend
125      * @param _value the max amount they can spend
126      */
127     function approve(address _spender, uint256 _value) public
128         returns (bool success) {
129         allowance[msg.sender][_spender] = _value;
130         return true;
131     }
132 
133     /**
134      * Destroy tokens
135      *
136      * Remove `_value` tokens from the system irreversibly
137      *
138      * @param _value the amount of money to burn
139      */
140     function burn(uint256 _value) public returns (bool success) {
141         require(balances[msg.sender] >= _value);   // Check if the sender has enough
142         balances[msg.sender] -= _value;            // Subtract from the sender
143         totalSupply -= _value;                      // Updates totalSupply
144         emit Burn(msg.sender, _value);
145         return true;
146     }
147 
148     /**
149      * Destroy tokens from other account
150      *
151      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
152      *
153      * @param _from the address of the sender
154      * @param _value the amount of money to burn
155      */
156     function burnFrom(address _from, uint256 _value) public returns (bool success) {
157         require(balances[_from] >= _value);                // Check if the targeted balance is enough
158         require(_value <= allowance[_from][msg.sender]);    // Check allowance
159         balances[_from] -= _value;                         // Subtract from the targeted balance
160         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
161         totalSupply -= _value;                              // Update totalSupply
162         emit Burn(_from, _value);
163         return true;
164     }
165 }
166 library CampaignLibrary {
167 
168     struct Campaign {
169         bytes32 bidId;
170         uint price;
171         uint budget;
172         uint startDate;
173         uint endDate;
174         bool valid;
175         address  owner;
176     }
177 
178 
179     /**
180     @notice Set campaign id 
181     @param _bidId Id of the campaign
182      */
183     function setBidId(Campaign storage _campaign, bytes32 _bidId) internal {
184         _campaign.bidId = _bidId;
185     }
186 
187     /**
188     @notice Get campaign id
189     @return {'_bidId' : 'Id of the campaign'}
190      */
191     function getBidId(Campaign storage _campaign) internal view returns(bytes32 _bidId){
192         return _campaign.bidId;
193     }
194    
195     /**
196     @notice Set campaing price per proof of attention
197     @param _price Price of the campaign
198      */
199     function setPrice(Campaign storage _campaign, uint _price) internal {
200         _campaign.price = _price;
201     }
202 
203     /**
204     @notice Get campaign price per proof of attention
205     @return {'_price' : 'Price of the campaign'}
206      */
207     function getPrice(Campaign storage _campaign) internal view returns(uint _price){
208         return _campaign.price;
209     }
210 
211     /**
212     @notice Set campaign total budget 
213     @param _budget Total budget of the campaign
214      */
215     function setBudget(Campaign storage _campaign, uint _budget) internal {
216         _campaign.budget = _budget;
217     }
218 
219     /**
220     @notice Get campaign total budget
221     @return {'_budget' : 'Total budget of the campaign'}
222      */
223     function getBudget(Campaign storage _campaign) internal view returns(uint _budget){
224         return _campaign.budget;
225     }
226 
227     /**
228     @notice Set campaign start date 
229     @param _startDate Start date of the campaign (in milisecounds)
230      */
231     function setStartDate(Campaign storage _campaign, uint _startDate) internal{
232         _campaign.startDate = _startDate;
233     }
234 
235     /**
236     @notice Get campaign start date 
237     @return {'_startDate' : 'Start date of the campaign (in milisecounds)'}
238      */
239     function getStartDate(Campaign storage _campaign) internal view returns(uint _startDate){
240         return _campaign.startDate;
241     }
242  
243     /**
244     @notice Set campaign end date 
245     @param _endDate End date of the campaign (in milisecounds)
246      */
247     function setEndDate(Campaign storage _campaign, uint _endDate) internal {
248         _campaign.endDate = _endDate;
249     }
250 
251     /**
252     @notice Get campaign end date 
253     @return {'_endDate' : 'End date of the campaign (in milisecounds)'}
254      */
255     function getEndDate(Campaign storage _campaign) internal view returns(uint _endDate){
256         return _campaign.endDate;
257     }
258 
259     /**
260     @notice Set campaign validity 
261     @param _valid Validity of the campaign
262      */
263     function setValidity(Campaign storage _campaign, bool _valid) internal {
264         _campaign.valid = _valid;
265     }
266 
267     /**
268     @notice Get campaign validity 
269     @return {'_valid' : 'Boolean stating campaign validity'}
270      */
271     function getValidity(Campaign storage _campaign) internal view returns(bool _valid){
272         return _campaign.valid;
273     }
274 
275     /**
276     @notice Set campaign owner 
277     @param _owner Owner of the campaign
278      */
279     function setOwner(Campaign storage _campaign, address _owner) internal {
280         _campaign.owner = _owner;
281     }
282 
283     /**
284     @notice Get campaign owner 
285     @return {'_owner' : 'Address of the owner of the campaign'}
286      */
287     function getOwner(Campaign storage _campaign) internal view returns(address _owner){
288         return _campaign.owner;
289     }
290 
291     /**
292     @notice Converts country index list into 3 uints
293       
294         Expects a list of country indexes such that the 2 digit country code is converted to an 
295         index. Countries are expected to be indexed so a "AA" country code is mapped to index 0 and 
296         "ZZ" country is mapped to index 675.
297     @param countries List of country indexes
298     @return {
299         "countries1" : "First third of the byte array converted in a 256 bytes uint",
300         "countries2" : "Second third of the byte array converted in a 256 bytes uint",
301         "countries3" : "Third third of the byte array converted in a 256 bytes uint"
302     }
303     */
304     function convertCountryIndexToBytes(uint[] countries) public pure
305         returns (uint countries1,uint countries2,uint countries3){
306         countries1 = 0;
307         countries2 = 0;
308         countries3 = 0;
309         for(uint i = 0; i < countries.length; i++){
310             uint index = countries[i];
311 
312             if(index<256){
313                 countries1 = countries1 | uint(1) << index;
314             } else if (index<512) {
315                 countries2 = countries2 | uint(1) << (index - 256);
316             } else {
317                 countries3 = countries3 | uint(1) << (index - 512);
318             }
319         }
320 
321         return (countries1,countries2,countries3);
322     }    
323 }
324 
325 
326 
327 interface StorageUser {
328     function getStorageAddress() external view returns(address _storage);
329 }
330 
331 interface ErrorThrower {
332     event Error(string func, string message);
333 }
334 
335 library Roles {
336   struct Role {
337     mapping (address => bool) bearer;
338   }
339 
340   function add(Role storage _role, address _addr)
341     internal
342   {
343     _role.bearer[_addr] = true;
344   }
345 
346   function remove(Role storage _role, address _addr)
347     internal
348   {
349     _role.bearer[_addr] = false;
350   }
351 
352 
353   function check(Role storage _role, address _addr)
354     internal
355     view
356   {
357     require(has(_role, _addr));
358   }
359 
360   function has(Role storage _role, address _addr)
361     internal
362     view
363     returns (bool)
364   {
365     return _role.bearer[_addr];
366   }
367 }
368 
369 contract RBAC {
370   using Roles for Roles.Role;
371 
372   mapping (string => Roles.Role) private roles;
373 
374   event RoleAdded(address indexed operator, string role);
375   event RoleRemoved(address indexed operator, string role);
376 
377 
378   function checkRole(address _operator, string _role)
379     public
380     view
381   {
382     roles[_role].check(_operator);
383   }
384 
385   function hasRole(address _operator, string _role)
386     public
387     view
388     returns (bool)
389   {
390     return roles[_role].has(_operator);
391   }
392 
393   function addRole(address _operator, string _role)
394     internal
395   {
396     roles[_role].add(_operator);
397     emit RoleAdded(_operator, _role);
398   }
399 
400   function removeRole(address _operator, string _role)
401     internal
402   {
403     roles[_role].remove(_operator);
404     emit RoleRemoved(_operator, _role);
405   }
406 
407   modifier onlyRole(string _role)
408   {
409     checkRole(msg.sender, _role);
410     _;
411   }
412 
413 
414 }
415 
416 
417 contract Ownable is ErrorThrower {
418     address public owner;
419     
420     event OwnershipRenounced(address indexed previousOwner);
421     event OwnershipTransferred(
422         address indexed previousOwner,
423         address indexed newOwner
424     );
425 
426 
427     /**
428     *  The Ownable constructor sets the original `owner` of the contract to the sender
429     * account.
430     */
431     constructor() public {
432         owner = msg.sender;
433     }
434 
435     modifier onlyOwner(string _funcName) {
436         if(msg.sender != owner){
437             emit Error(_funcName,"Operation can only be performed by contract owner");
438             return;
439         }
440         _;
441     }
442 
443     /**
444     *  Allows the current owner to relinquish control of the contract.
445     * @notice Renouncing to ownership will leave the contract without an owner.
446     * It will not be possible to call the functions with the `onlyOwner`
447     * modifier anymore.
448     */
449     function renounceOwnership() public onlyOwner("renounceOwnership") {
450         emit OwnershipRenounced(owner);
451         owner = address(0);
452     }
453 
454     /**
455     *  Allows the current owner to transfer control of the contract to a newOwner.
456     * @param _newOwner The address to transfer ownership to.
457     */
458     function transferOwnership(address _newOwner) public onlyOwner("transferOwnership") {
459         _transferOwnership(_newOwner);
460     }
461 
462     /**
463     *  Transfers control of the contract to a newOwner.
464     * @param _newOwner The address to transfer ownership to.
465     */
466     function _transferOwnership(address _newOwner) internal {
467         if(_newOwner == address(0)){
468             emit Error("transferOwnership","New owner's address needs to be different than 0x0");
469             return;
470         }
471 
472         emit OwnershipTransferred(owner, _newOwner);
473         owner = _newOwner;
474     }
475 }
476 
477 contract SingleAllowance is Ownable {
478 
479     address allowedAddress;
480 
481     modifier onlyAllowed() {
482         require(allowedAddress == msg.sender);
483         _;
484     }
485 
486     modifier onlyOwnerOrAllowed() {
487         require(owner == msg.sender || allowedAddress == msg.sender);
488         _;
489     }
490 
491     function setAllowedAddress(address _addr) public onlyOwner("setAllowedAddress"){
492         allowedAddress = _addr;
493     }
494 }
495 
496 
497 contract Whitelist is Ownable, RBAC {
498     string public constant ROLE_WHITELISTED = "whitelist";
499 
500     /**
501     *  Throws Error event if operator is not whitelisted.
502     * @param _operator address
503     */
504     modifier onlyIfWhitelisted(string _funcname, address _operator) {
505         if(!hasRole(_operator, ROLE_WHITELISTED)){
506             emit Error(_funcname, "Operation can only be performed by Whitelisted Addresses");
507             return;
508         }
509         _;
510     }
511 
512     /**
513     *  add an address to the whitelist
514     * @param _operator address
515     * @return true if the address was added to the whitelist, false if the address was already in the whitelist
516     */
517     function addAddressToWhitelist(address _operator)
518         public
519         onlyOwner("addAddressToWhitelist")
520     {
521         addRole(_operator, ROLE_WHITELISTED);
522     }
523 
524     /**
525     *  getter to determine if address is in whitelist
526     */
527     function whitelist(address _operator)
528         public
529         view
530         returns (bool)
531     {
532         return hasRole(_operator, ROLE_WHITELISTED);
533     }
534 
535     /**
536     *  add addresses to the whitelist
537     * @param _operators addresses
538     * @return true if at least one address was added to the whitelist,
539     * false if all addresses were already in the whitelist
540     */
541     function addAddressesToWhitelist(address[] _operators)
542         public
543         onlyOwner("addAddressesToWhitelist")
544     {
545         for (uint256 i = 0; i < _operators.length; i++) {
546             addAddressToWhitelist(_operators[i]);
547         }
548     }
549 
550     /**
551     *  remove an address from the whitelist
552     * @param _operator address
553     * @return true if the address was removed from the whitelist,
554     * false if the address wasn't in the whitelist in the first place
555     */
556     function removeAddressFromWhitelist(address _operator)
557         public
558         onlyOwner("removeAddressFromWhitelist")
559     {
560         removeRole(_operator, ROLE_WHITELISTED);
561     }
562 
563     /**
564     *  remove addresses from the whitelist
565     * @param _operators addresses
566     * @return true if at least one address was removed from the whitelist,
567     * false if all addresses weren't in the whitelist in the first place
568     */
569     function removeAddressesFromWhitelist(address[] _operators)
570         public
571         onlyOwner("removeAddressesFromWhitelist")
572     {
573         for (uint256 i = 0; i < _operators.length; i++) {
574             removeAddressFromWhitelist(_operators[i]);
575         }
576     }
577 
578 }
579 
580 contract BaseAdvertisementStorage is Whitelist {
581     using CampaignLibrary for CampaignLibrary.Campaign;
582 
583     mapping (bytes32 => CampaignLibrary.Campaign) campaigns;
584 
585     bytes32 lastBidId = 0x0;
586 
587     modifier onlyIfCampaignExists(string _funcName, bytes32 _bidId) {
588         if(campaigns[_bidId].owner == 0x0){
589             emit Error(_funcName,"Campaign does not exist");
590             return;
591         }
592         _;
593     }
594     
595     event CampaignCreated
596         (
597             bytes32 bidId,
598             uint price,
599             uint budget,
600             uint startDate,
601             uint endDate,
602             bool valid,
603             address owner
604     );
605 
606     event CampaignUpdated
607         (
608             bytes32 bidId,
609             uint price,
610             uint budget,
611             uint startDate,
612             uint endDate,
613             bool valid,
614             address  owner
615     );
616 
617     /**
618     @notice Get a Campaign information
619      
620         Based on a camapaign Id (bidId), returns all stored information for that campaign.
621     @param campaignId Id of the campaign
622     @return {
623         "bidId" : "Id of the campaign",
624         "price" : "Value to pay for each proof-of-attention",
625         "budget" : "Total value avaliable to be spent on the campaign",
626         "startDate" : "Start date of the campaign (in miliseconds)",
627         "endDate" : "End date of the campaign (in miliseconds)"
628         "valid" : "Boolean informing if the campaign is valid",
629         "campOwner" : "Address of the campaing's owner"
630     }
631     */
632     function _getCampaign(bytes32 campaignId)
633         internal
634         returns (CampaignLibrary.Campaign storage _campaign) {
635 
636 
637         return campaigns[campaignId];
638     }
639 
640 
641     /**
642     @notice Add or update a campaign information
643     
644         Based on a campaign Id (bidId), a campaign can be created (if non existent) or updated.
645         This function can only be called by the set of allowed addresses registered earlier.
646         An event will be emited during this function's execution, a CampaignCreated event if the 
647         campaign does not exist yet or a CampaignUpdated if the campaign id is already registered.
648 
649     @param bidId Id of the campaign
650     @param price Value to pay for each proof-of-attention
651     @param budget Total value avaliable to be spent on the campaign
652     @param startDate Start date of the campaign (in miliseconds)
653     @param endDate End date of the campaign (in miliseconds)
654     @param valid Boolean informing if the campaign is valid
655     @param owner Address of the campaing's owner
656     */
657     function _setCampaign (
658         bytes32 bidId,
659         uint price,
660         uint budget,
661         uint startDate,
662         uint endDate,
663         bool valid,
664         address owner
665     )
666     public
667     onlyIfWhitelisted("setCampaign",msg.sender) {
668 
669         CampaignLibrary.Campaign storage campaign = campaigns[bidId];
670         campaign.setBidId(bidId);
671         campaign.setPrice(price);
672         campaign.setBudget(budget);
673         campaign.setStartDate(startDate);
674         campaign.setEndDate(endDate);
675         campaign.setValidity(valid);
676 
677         bool newCampaign = (campaigns[bidId].getOwner() == 0x0);
678 
679         campaign.setOwner(owner);
680 
681 
682 
683         if(newCampaign){
684             emitCampaignCreated(campaign);
685             setLastBidId(bidId);
686         } else {
687             emitCampaignUpdated(campaign);
688         }
689     }
690 
691     /**
692     @notice Constructor function
693     
694         Initializes contract and updates allowed addresses to interact with contract functions.
695     */
696     constructor() public {
697         addAddressToWhitelist(msg.sender);
698     }
699 
700       /**
701     @notice Get the price of a campaign
702     
703         Based on the Campaign id, return the value paid for each proof of attention registered.
704     @param bidId Campaign id to which the query refers
705     @return { "price" : "Reward (in wei) for each proof of attention registered"} 
706     */
707     function getCampaignPriceById(bytes32 bidId)
708         public
709         view
710         returns (uint price) {
711         return campaigns[bidId].getPrice();
712     }
713 
714     /** 
715     @notice Set a new price for a campaign
716     
717         Based on the Campaign id, updates the value paid for each proof of attention registered.
718         This function can only be executed by allowed addresses and emits a CampaingUpdate event.
719     @param bidId Campaing id to which the update refers
720     @param price New price for each proof of attention
721     */
722     function setCampaignPriceById(bytes32 bidId, uint price)
723         public
724         onlyIfWhitelisted("setCampaignPriceById",msg.sender) 
725         onlyIfCampaignExists("setCampaignPriceById",bidId)      
726         {
727         campaigns[bidId].setPrice(price);
728         emitCampaignUpdated(campaigns[bidId]);
729     }
730 
731     /**
732     @notice Get the budget avaliable of a campaign
733     
734         Based on the Campaign id, return the total value avaliable to pay for proofs of attention.
735     @param bidId Campaign id to which the query refers
736     @return { "budget" : "Total value (in wei) spendable in proof of attention rewards"} 
737     */
738     function getCampaignBudgetById(bytes32 bidId)
739         public
740         view
741         returns (uint budget) {
742         return campaigns[bidId].getBudget();
743     }
744 
745     /**
746     @notice Set a new campaign budget
747     
748         Based on the Campaign id, updates the total value avaliable for proof of attention 
749         registrations. This function can only be executed by allowed addresses and emits a 
750         CampaignUpdated event. This function does not transfer any funds as this contract only works
751         as a data repository, every logic needed will be processed in the Advertisement contract.
752     @param bidId Campaign id to which the query refers
753     @param newBudget New value for the total budget of the campaign
754     */
755     function setCampaignBudgetById(bytes32 bidId, uint newBudget)
756         public
757         onlyIfCampaignExists("setCampaignBudgetById",bidId)
758         onlyIfWhitelisted("setCampaignBudgetById",msg.sender)
759         {
760         campaigns[bidId].setBudget(newBudget);
761         emitCampaignUpdated(campaigns[bidId]);
762     }
763 
764     /** 
765     @notice Get the start date of a campaign
766     
767         Based on the Campaign id, return the value (in miliseconds) corresponding to the start Date
768         of the campaign.
769     @param bidId Campaign id to which the query refers
770     @return { "startDate" : "Start date (in miliseconds) of the campaign"} 
771     */
772     function getCampaignStartDateById(bytes32 bidId)
773         public
774         view
775         returns (uint startDate) {
776         return campaigns[bidId].getStartDate();
777     }
778 
779     /**
780     @notice Set a new start date for a campaign
781     
782         Based of the Campaign id, updates the start date of a campaign. This function can only be 
783         executed by allowed addresses and emits a CampaignUpdated event.
784     @param bidId Campaign id to which the query refers
785     @param newStartDate New value (in miliseconds) for the start date of the campaign
786     */
787     function setCampaignStartDateById(bytes32 bidId, uint newStartDate)
788         public
789         onlyIfCampaignExists("setCampaignStartDateById",bidId)
790         onlyIfWhitelisted("setCampaignStartDateById",msg.sender)
791         {
792         campaigns[bidId].setStartDate(newStartDate);
793         emitCampaignUpdated(campaigns[bidId]);
794     }
795     
796     /** 
797     @notice Get the end date of a campaign
798     
799         Based on the Campaign id, return the value (in miliseconds) corresponding to the end Date
800         of the campaign.
801     @param bidId Campaign id to which the query refers
802     @return { "endDate" : "End date (in miliseconds) of the campaign"} 
803     */
804     function getCampaignEndDateById(bytes32 bidId)
805         public
806         view
807         returns (uint endDate) {
808         return campaigns[bidId].getEndDate();
809     }
810 
811     /**
812     @notice Set a new end date for a campaign
813     
814         Based of the Campaign id, updates the end date of a campaign. This function can only be 
815         executed by allowed addresses and emits a CampaignUpdated event.
816     @param bidId Campaign id to which the query refers
817     @param newEndDate New value (in miliseconds) for the end date of the campaign
818     */
819     function setCampaignEndDateById(bytes32 bidId, uint newEndDate)
820         public
821         onlyIfCampaignExists("setCampaignEndDateById",bidId)
822         onlyIfWhitelisted("setCampaignEndDateById",msg.sender)
823         {
824         campaigns[bidId].setEndDate(newEndDate);
825         emitCampaignUpdated(campaigns[bidId]);
826     }
827     /** 
828     @notice Get information regarding validity of a campaign.
829     
830         Based on the Campaign id, return a boolean which represents a valid campaign if it has 
831         the value of True else has the value of False.
832     @param bidId Campaign id to which the query refers
833     @return { "valid" : "Validity of the campaign"} 
834     */
835     function getCampaignValidById(bytes32 bidId)
836         public
837         view
838         returns (bool valid) {
839         return campaigns[bidId].getValidity();
840     }
841 
842     /**
843     @notice Set a new campaign validity state.
844     
845         Updates the validity of a campaign based on a campaign Id. This function can only be 
846         executed by allowed addresses and emits a CampaignUpdated event.
847     @param bidId Campaign id to which the query refers
848     @param isValid New value for the campaign validity
849     */
850     function setCampaignValidById(bytes32 bidId, bool isValid)
851         public
852         onlyIfCampaignExists("setCampaignValidById",bidId)
853         onlyIfWhitelisted("setCampaignValidById",msg.sender)
854         {
855         campaigns[bidId].setValidity(isValid);
856         emitCampaignUpdated(campaigns[bidId]);
857     }
858 
859     /**
860     @notice Get the owner of a campaign 
861      
862         Based on the Campaign id, return the address of the campaign owner.
863     @param bidId Campaign id to which the query refers
864     @return { "campOwner" : "Address of the campaign owner" } 
865     */
866     function getCampaignOwnerById(bytes32 bidId)
867         public
868         view
869         returns (address campOwner) {
870         return campaigns[bidId].getOwner();
871     }
872 
873     /**
874     @notice Set a new campaign owner 
875     
876         Based on the Campaign id, update the owner of the refered campaign. This function can only 
877         be executed by allowed addresses and emits a CampaignUpdated event.
878     @param bidId Campaign id to which the query refers
879     @param newOwner New address to be the owner of the campaign
880     */
881     function setCampaignOwnerById(bytes32 bidId, address newOwner)
882         public
883         onlyIfCampaignExists("setCampaignOwnerById",bidId)
884         onlyIfWhitelisted("setCampaignOwnerById",msg.sender)
885         {
886         campaigns[bidId].setOwner(newOwner);
887         emitCampaignUpdated(campaigns[bidId]);
888     }
889 
890     /**
891     @notice Function to emit campaign updates
892     
893         It emits a CampaignUpdated event with the new campaign information. 
894     */
895     function emitCampaignUpdated(CampaignLibrary.Campaign storage campaign) private {
896         emit CampaignUpdated(
897             campaign.getBidId(),
898             campaign.getPrice(),
899             campaign.getBudget(),
900             campaign.getStartDate(),
901             campaign.getEndDate(),
902             campaign.getValidity(),
903             campaign.getOwner()
904         );
905     }
906 
907     /**
908     @notice Function to emit campaign creations
909     
910         It emits a CampaignCreated event with the new campaign created. 
911     */
912     function emitCampaignCreated(CampaignLibrary.Campaign storage campaign) private {
913         emit CampaignCreated(
914             campaign.getBidId(),
915             campaign.getPrice(),
916             campaign.getBudget(),
917             campaign.getStartDate(),
918             campaign.getEndDate(),
919             campaign.getValidity(),
920             campaign.getOwner()
921         );
922     }
923 
924     /**
925     @notice Internal function to set most recent bidId
926     
927         This value is stored to avoid conflicts between
928         Advertisement contract upgrades.
929     @param _newBidId Newer bidId
930      */
931     function setLastBidId(bytes32 _newBidId) internal {    
932         lastBidId = _newBidId;
933     }
934 
935     /**
936     @notice Returns the greatest BidId ever registered to the contract
937     @return { '_lastBidId' : 'Greatest bidId registered to the contract'}
938      */
939     function getLastBidId() 
940         external 
941         returns (bytes32 _lastBidId){
942         
943         return lastBidId;
944     }
945 }
946 
947 contract ExtendedAdvertisementStorage is BaseAdvertisementStorage {
948 
949     mapping (bytes32 => string) campaignEndPoints;
950 
951     event ExtendedCampaignEndPointCreated(
952         bytes32 bidId,
953         string endPoint
954     );
955 
956     event ExtendedCampaignEndPointUpdated(
957         bytes32 bidId,
958         string endPoint
959     );
960 
961     /**
962     @notice Get a Campaign information
963      
964         Based on a camapaign Id (bidId), returns all stored information for that campaign.
965     @param _campaignId Id of the campaign
966     @return {
967         "_bidId" : "Id of the campaign",
968         "_price" : "Value to pay for each proof-of-attention",
969         "_budget" : "Total value avaliable to be spent on the campaign",
970         "_startDate" : "Start date of the campaign (in miliseconds)",
971         "_endDate" : "End date of the campaign (in miliseconds)"
972         "_valid" : "Boolean informing if the campaign is valid",
973         "_campOwner" : "Address of the campaing's owner",
974     }
975     */
976     function getCampaign(bytes32 _campaignId)
977         public
978         view
979         returns (
980             bytes32 _bidId,
981             uint _price,
982             uint _budget,
983             uint _startDate,
984             uint _endDate,
985             bool _valid,
986             address _campOwner
987         ) {
988 
989         CampaignLibrary.Campaign storage campaign = _getCampaign(_campaignId);
990 
991         return (
992             campaign.getBidId(),
993             campaign.getPrice(),
994             campaign.getBudget(),
995             campaign.getStartDate(),
996             campaign.getEndDate(),
997             campaign.getValidity(),
998             campaign.getOwner()
999         );
1000     }
1001 
1002     /**
1003     @notice Add or update a campaign information
1004     
1005         Based on a campaign Id (bidId), a campaign can be created (if non existent) or updated.
1006         This function can only be called by the set of allowed addresses registered earlier.
1007         An event will be emited during this function's execution, a CampaignCreated and a 
1008         ExtendedCampaignEndPointCreated event if the campaign does not exist yet or a 
1009         CampaignUpdated and a ExtendedCampaignEndPointUpdated event if the campaign id is already 
1010         registered.
1011 
1012     @param _bidId Id of the campaign
1013     @param _price Value to pay for each proof-of-attention
1014     @param _budget Total value avaliable to be spent on the campaign
1015     @param _startDate Start date of the campaign (in miliseconds)
1016     @param _endDate End date of the campaign (in miliseconds)
1017     @param _valid Boolean informing if the campaign is valid
1018     @param _owner Address of the campaing's owner
1019     @param _endPoint URL of the signing serivce
1020     */
1021     function setCampaign (
1022         bytes32 _bidId,
1023         uint _price,
1024         uint _budget,
1025         uint _startDate,
1026         uint _endDate,
1027         bool _valid,
1028         address _owner,
1029         string _endPoint
1030     )
1031     public
1032     onlyIfWhitelisted("setCampaign",msg.sender) {
1033         
1034         bool newCampaign = (getCampaignOwnerById(_bidId) == 0x0);
1035         _setCampaign(_bidId, _price, _budget, _startDate, _endDate, _valid, _owner);
1036         
1037         campaignEndPoints[_bidId] = _endPoint;
1038 
1039         if(newCampaign){
1040             emit ExtendedCampaignEndPointCreated(_bidId,_endPoint);
1041         } else {
1042             emit ExtendedCampaignEndPointUpdated(_bidId,_endPoint);
1043         }
1044     }
1045 
1046     /**
1047     @notice Get campaign signing web service endpoint
1048     
1049         Get the end point to which the user should submit the proof of attention to be signed
1050     @param _bidId Id of the campaign
1051     @return { "_endPoint": "URL for the signing web service"}
1052     */
1053 
1054     function getCampaignEndPointById(bytes32 _bidId) public returns (string _endPoint){
1055         return campaignEndPoints[_bidId];
1056     }
1057 
1058     /**
1059     @notice Set campaign signing web service endpoint
1060     
1061         Sets the webservice's endpoint to which the user should submit the proof of attention
1062     @param _bidId Id of the campaign
1063     @param _endPoint URL for the signing web service
1064     */
1065     function setCampaignEndPointById(bytes32 _bidId, string _endPoint) 
1066         public 
1067         onlyIfCampaignExists("setCampaignEndPointById",_bidId)
1068         onlyIfWhitelisted("setCampaignEndPointById",msg.sender) 
1069         {
1070         campaignEndPoints[_bidId] = _endPoint;
1071         emit ExtendedCampaignEndPointUpdated(_bidId,_endPoint);
1072     }
1073 
1074 }
1075 
1076 
1077 contract BaseAdvertisement is StorageUser,Ownable {
1078     
1079     AppCoins appc;
1080     BaseFinance advertisementFinance;
1081     BaseAdvertisementStorage advertisementStorage;
1082 
1083     mapping( bytes32 => mapping(address => uint256)) userAttributions;
1084 
1085     bytes32[] bidIdList;
1086     bytes32 lastBidId = 0x0;
1087 
1088 
1089     /**
1090     @notice Constructor function
1091     
1092         Initializes contract with default validation rules
1093     @param _addrAppc Address of the AppCoins (ERC-20) contract
1094     @param _addrAdverStorage Address of the Advertisement Storage contract to be used
1095     @param _addrAdverFinance Address of the Advertisement Finance contract to be used
1096     */
1097     constructor(address _addrAppc, address _addrAdverStorage, address _addrAdverFinance) public {
1098         appc = AppCoins(_addrAppc);
1099 
1100         advertisementStorage = BaseAdvertisementStorage(_addrAdverStorage);
1101         advertisementFinance = BaseFinance(_addrAdverFinance);
1102         lastBidId = advertisementStorage.getLastBidId();
1103     }
1104 
1105 
1106     /**
1107     @notice Upgrade finance contract used by this contract
1108     
1109         This function is part of the upgrade mechanism avaliable to the advertisement contracts.
1110         Using this function it is possible to update to a new Advertisement Finance contract without
1111         the need to cancel avaliable campaigns.
1112         Upgrade finance function can only be called by the Advertisement contract owner.
1113     @param addrAdverFinance Address of the new Advertisement Finance contract
1114     */
1115     function upgradeFinance (address addrAdverFinance) public onlyOwner("upgradeFinance") {
1116         BaseFinance newAdvFinance = BaseFinance(addrAdverFinance);
1117 
1118         address[] memory devList = advertisementFinance.getUserList();
1119         
1120         for(uint i = 0; i < devList.length; i++){
1121             uint balance = advertisementFinance.getUserBalance(devList[i]);
1122             newAdvFinance.increaseBalance(devList[i],balance);
1123         }
1124         
1125         uint256 initBalance = appc.balanceOf(address(advertisementFinance));
1126         advertisementFinance.transferAllFunds(address(newAdvFinance));
1127         uint256 oldBalance = appc.balanceOf(address(advertisementFinance));
1128         uint256 newBalance = appc.balanceOf(address(newAdvFinance));
1129         
1130         require(initBalance == newBalance);
1131         require(oldBalance == 0);
1132         advertisementFinance = newAdvFinance;
1133     }
1134 
1135     /**
1136     @notice Upgrade storage contract used by this contract
1137     
1138         Upgrades Advertisement Storage contract addres with no need to redeploy
1139         Advertisement contract. However every campaign in the old contract will
1140         be canceled.
1141         This function can only be called by the Advertisement contract owner.
1142     @param addrAdverStorage Address of the new Advertisement Storage contract
1143     */
1144 
1145     function upgradeStorage (address addrAdverStorage) public onlyOwner("upgradeStorage") {
1146         for(uint i = 0; i < bidIdList.length; i++) {
1147             cancelCampaign(bidIdList[i]);
1148         }
1149         delete bidIdList;
1150 
1151         lastBidId = advertisementStorage.getLastBidId();
1152         advertisementFinance.setAdsStorageAddress(addrAdverStorage);
1153         advertisementStorage = BaseAdvertisementStorage(addrAdverStorage);
1154     }
1155 
1156 
1157     /**
1158     @notice Get Advertisement Storage Address used by this contract
1159     
1160         This function is required to upgrade Advertisement contract address on Advertisement
1161         Finance contract. This function can only be called by the Advertisement Finance
1162         contract registered in this contract.
1163     @return {
1164         "storageContract" : "Address of the Advertisement Storage contract used by this contract"
1165         }
1166     */
1167 
1168     function getStorageAddress() public view returns(address storageContract) {
1169         require (msg.sender == address(advertisementFinance));
1170 
1171         return address(advertisementStorage);
1172     }
1173 
1174 
1175     /**
1176     @notice Creates a campaign 
1177      
1178         Method to create a campaign of user aquisition for a certain application.
1179         This method will emit a Campaign Information event with every information 
1180         provided in the arguments of this method.
1181     @param packageName Package name of the appication subject to the user aquisition campaign
1182     @param countries Encoded list of 3 integers intended to include every 
1183     county where this campaign will be avaliable.
1184     For more detain on this encoding refer to wiki documentation.
1185     @param vercodes List of version codes to which the user aquisition campaign is applied.
1186     @param price Value (in wei) the campaign owner pays for each proof-of-attention.
1187     @param budget Total budget (in wei) the campaign owner will deposit 
1188     to pay for the proof-of-attention.
1189     @param startDate Date (in miliseconds) on which the campaign will start to be 
1190     avaliable to users.
1191     @param endDate Date (in miliseconds) on which the campaign will no longer be avaliable to users.
1192     */
1193 
1194     function _generateCampaign (
1195         string packageName,
1196         uint[3] countries,
1197         uint[] vercodes,
1198         uint price,
1199         uint budget,
1200         uint startDate,
1201         uint endDate)
1202         internal returns (CampaignLibrary.Campaign memory) {
1203 
1204         require(budget >= price);
1205         require(endDate >= startDate);
1206 
1207 
1208         //Transfers the budget to contract address
1209         if(appc.allowance(msg.sender, address(this)) >= budget){
1210             appc.transferFrom(msg.sender, address(advertisementFinance), budget);
1211 
1212             advertisementFinance.increaseBalance(msg.sender,budget);
1213 
1214             uint newBidId = bytesToUint(lastBidId);
1215             lastBidId = uintToBytes(++newBidId);
1216             
1217 
1218             CampaignLibrary.Campaign memory newCampaign;
1219             newCampaign.price = price;
1220             newCampaign.startDate = startDate;
1221             newCampaign.endDate = endDate;
1222             newCampaign.budget = budget;
1223             newCampaign.owner = msg.sender;
1224             newCampaign.valid = true;
1225             newCampaign.bidId = lastBidId;
1226         } else {
1227             emit Error("createCampaign","Not enough allowance");
1228         }
1229         
1230         return newCampaign;
1231     }
1232 
1233     function _getStorage() internal returns (BaseAdvertisementStorage) {
1234         return advertisementStorage;
1235     }
1236 
1237     function _getFinance() internal returns (BaseFinance) {
1238         return advertisementFinance;
1239     }
1240 
1241     function _setUserAttribution(bytes32 _bidId,address _user,uint256 _attributions) internal{
1242         userAttributions[_bidId][_user] = _attributions;
1243     }
1244 
1245 
1246     function getUserAttribution(bytes32 _bidId,address _user) internal returns (uint256) {
1247         return userAttributions[_bidId][_user];
1248     }
1249 
1250     /**
1251     @notice Cancel a campaign and give the remaining budget to the campaign owner
1252     
1253         When a campaing owner wants to cancel a campaign, the campaign owner needs
1254         to call this function. This function can only be called either by the campaign owner or by
1255         the Advertisement contract owner. This function results in campaign cancelation and
1256         retreival of the remaining budget to the respective campaign owner.
1257     @param bidId Campaign id to which the cancelation referes to
1258      */
1259     function cancelCampaign (bytes32 bidId) public {
1260         address campaignOwner = getOwnerOfCampaign(bidId);
1261 
1262 		// Only contract owner or campaign owner can cancel a campaign
1263         require(owner == msg.sender || campaignOwner == msg.sender);
1264         uint budget = getBudgetOfCampaign(bidId);
1265 
1266         advertisementFinance.withdraw(campaignOwner, budget);
1267 
1268         advertisementStorage.setCampaignBudgetById(bidId, 0);
1269         advertisementStorage.setCampaignValidById(bidId, false);
1270     }
1271 
1272      /**
1273     @notice Get a campaign validity state
1274     @param bidId Campaign id to which the query refers
1275     @return { "state" : "Validity of the campaign"}
1276     */
1277     function getCampaignValidity(bytes32 bidId) public view returns(bool state){
1278         return advertisementStorage.getCampaignValidById(bidId);
1279     }
1280 
1281     /**
1282     @notice Get the price of a campaign
1283     
1284         Based on the Campaign id return the value paid for each proof of attention registered.
1285     @param bidId Campaign id to which the query refers
1286     @return { "price" : "Reward (in wei) for each proof of attention registered"}
1287     */
1288     function getPriceOfCampaign (bytes32 bidId) public view returns(uint price) {
1289         return advertisementStorage.getCampaignPriceById(bidId);
1290     }
1291 
1292     /**
1293     @notice Get the start date of a campaign
1294     
1295         Based on the Campaign id return the value (in miliseconds) corresponding to the start Date
1296         of the campaign.
1297     @param bidId Campaign id to which the query refers
1298     @return { "startDate" : "Start date (in miliseconds) of the campaign"}
1299     */
1300     function getStartDateOfCampaign (bytes32 bidId) public view returns(uint startDate) {
1301         return advertisementStorage.getCampaignStartDateById(bidId);
1302     }
1303 
1304     /**
1305     @notice Get the end date of a campaign
1306     
1307         Based on the Campaign id return the value (in miliseconds) corresponding to the end Date
1308         of the campaign.
1309     @param bidId Campaign id to which the query refers
1310     @return { "endDate" : "End date (in miliseconds) of the campaign"}
1311     */
1312     function getEndDateOfCampaign (bytes32 bidId) public view returns(uint endDate) {
1313         return advertisementStorage.getCampaignEndDateById(bidId);
1314     }
1315 
1316     /**
1317     @notice Get the budget avaliable of a campaign
1318     
1319         Based on the Campaign id return the total value avaliable to pay for proofs of attention.
1320     @param bidId Campaign id to which the query refers
1321     @return { "budget" : "Total value (in wei) spendable in proof of attention rewards"}
1322     */
1323     function getBudgetOfCampaign (bytes32 bidId) public view returns(uint budget) {
1324         return advertisementStorage.getCampaignBudgetById(bidId);
1325     }
1326 
1327 
1328     /**
1329     @notice Get the owner of a campaign
1330     
1331         Based on the Campaign id return the address of the campaign owner
1332     @param bidId Campaign id to which the query refers
1333     @return { "campaignOwner" : "Address of the campaign owner" }
1334     */
1335     function getOwnerOfCampaign (bytes32 bidId) public view returns(address campaignOwner) {
1336         return advertisementStorage.getCampaignOwnerById(bidId);
1337     }
1338 
1339     /**
1340     @notice Get the list of Campaign BidIds registered in the contract
1341     
1342         Returns the list of BidIds of the campaigns ever registered in the contract
1343     @return { "bidIds" : "List of BidIds registered in the contract" }
1344     */
1345     function getBidIdList() public view returns(bytes32[] bidIds) {
1346         return bidIdList;
1347     }
1348 
1349     function _getBidIdList() internal returns(bytes32[] storage bidIds){
1350         return bidIdList;
1351     }
1352 
1353     /**
1354     @notice Check if a certain campaign is still valid
1355     
1356         Returns a boolean representing the validity of the campaign
1357         Has value of True if the campaign is still valid else has value of False
1358     @param bidId Campaign id to which the query refers
1359     @return { "valid" : "validity of the campaign" }
1360     */
1361     function isCampaignValid(bytes32 bidId) public view returns(bool valid) {
1362         uint startDate = advertisementStorage.getCampaignStartDateById(bidId);
1363         uint endDate = advertisementStorage.getCampaignEndDateById(bidId);
1364         bool validity = advertisementStorage.getCampaignValidById(bidId);
1365 
1366         uint nowInMilliseconds = now * 1000;
1367         return validity && startDate < nowInMilliseconds && endDate > nowInMilliseconds;
1368     }
1369 
1370      /**
1371     @notice Returns the division of two numbers
1372     
1373         Function used for division operations inside the smartcontract
1374     @param numerator Numerator part of the division
1375     @param denominator Denominator part of the division
1376     @return { "result" : "Result of the division"}
1377     */
1378     function division(uint numerator, uint denominator) public view returns (uint result) {
1379         uint _quotient = numerator / denominator;
1380         return _quotient;
1381     }
1382 
1383     /**
1384     @notice Converts a uint256 type variable to a byte32 type variable
1385     
1386         Mostly used internaly
1387     @param i number to be converted
1388     @return { "b" : "Input number converted to bytes"}
1389     */
1390     function uintToBytes (uint256 i) public view returns(bytes32 b) {
1391         b = bytes32(i);
1392     }
1393 
1394     function bytesToUint(bytes32 b) public view returns (uint) 
1395     {
1396         return uint(b) & 0xfff;
1397     }
1398 
1399 }
1400 
1401 contract Signature {
1402 
1403     /**
1404     @notice splitSignature
1405     
1406         Based on a signature Sig (bytes32), returns the r, s, v
1407     @param sig Signature
1408     @return {
1409         "uint8" : "recover Id",
1410         "bytes32" : "Output of the ECDSA signature",
1411         "bytes32" : "Output of the ECDSA signature",
1412     }
1413     */
1414     function splitSignature(bytes sig)
1415         internal
1416         pure
1417         returns (uint8, bytes32, bytes32)
1418         {
1419         require(sig.length == 65);
1420 
1421         bytes32 r;
1422         bytes32 s;
1423         uint8 v;
1424 
1425         assembly {
1426             // first 32 bytes, after the length prefix
1427             r := mload(add(sig, 32))
1428             // second 32 bytes
1429             s := mload(add(sig, 64))
1430             // final byte (first byte of the next 32 bytes)
1431             v := byte(0, mload(add(sig, 96)))
1432         }
1433 
1434         return (v, r, s);
1435     }
1436 
1437     /**
1438     @notice recoverSigner
1439     
1440         Based on a message and signature returns the address
1441     @param message Message
1442     @param sig Signature
1443     @return {
1444         "address" : "Address of the private key that signed",
1445     }
1446     */
1447     function recoverSigner(bytes32 message, bytes sig)
1448         public
1449         pure
1450         returns (address)
1451         {
1452         uint8 v;
1453         bytes32 r;
1454         bytes32 s;
1455 
1456         (v, r, s) = splitSignature(sig);
1457 
1458         return ecrecover(message, v, r, s);
1459     }
1460 }
1461 
1462 
1463 contract BaseFinance is SingleAllowance {
1464 
1465     mapping (address => uint256) balanceUsers;
1466     mapping (address => bool) userExists;
1467 
1468     address[] users;
1469 
1470     address advStorageContract;
1471 
1472     AppCoins appc;
1473 
1474     /**
1475     @notice Constructor function
1476      
1477         Initializes contract with the AppCoins contract address
1478     @param _addrAppc Address of the AppCoins (ERC-20) contract
1479     */
1480     constructor (address _addrAppc) 
1481         public {
1482         appc = AppCoins(_addrAppc);
1483         advStorageContract = 0x0;
1484     }
1485 
1486 
1487     /**
1488     @notice Sets the Storage contract address used by the allowed contract
1489     
1490         The Storage contract address is mostly used as part of a failsafe mechanism to
1491         ensure contract upgrades are executed using the same Storage 
1492         contract. This function returns every value of AppCoins stored in this contract to their 
1493         owners. This function can only be called by the 
1494         Finance contract owner or by the allowed contract registered earlier in 
1495         this contract.
1496     @param _addrStorage Address of the new Storage contract
1497     */
1498     function setAdsStorageAddress (address _addrStorage) external onlyOwnerOrAllowed {
1499         reset();
1500         advStorageContract = _addrStorage;
1501     }
1502 
1503         /**
1504     @notice Sets the Advertisement contract address to allow calls from Advertisement contract
1505     
1506         This function is used for upgrading the Advertisement contract without need to redeploy 
1507         Advertisement Finance and Advertisement Storage contracts. The function can only be called 
1508         by this contract's owner. During the update of the Advertisement contract address, the 
1509         contract for Advertisement Storage used by the new Advertisement contract is checked. 
1510         This function reverts if the new Advertisement contract does not use the same Advertisement 
1511         Storage contract earlier registered in this Advertisement Finance contract.
1512     @param _addr Address of the newly allowed contract 
1513     */
1514     function setAllowedAddress (address _addr) public onlyOwner("setAllowedAddress") {
1515         // Verify if the new Ads contract is using the same storage as before 
1516         if (allowedAddress != 0x0){
1517             StorageUser storageUser = StorageUser(_addr);
1518             address storageContract = storageUser.getStorageAddress();
1519             require (storageContract == advStorageContract);
1520         }
1521         
1522         //Update contract
1523         super.setAllowedAddress(_addr);
1524     }
1525 
1526     /**
1527     @notice Increases balance of a user
1528     
1529         This function can only be called by the registered Advertisement contract and increases the 
1530         balance of a specific user on this contract. This function does not transfer funds, 
1531         this step need to be done earlier by the Advertisement contract. This function can only be 
1532         called by the registered Advertisement contract.
1533     @param _user Address of the user who will receive a balance increase
1534     @param _value Value of coins to increase the user's balance
1535     */
1536     function increaseBalance(address _user, uint256 _value) 
1537         public onlyAllowed{
1538 
1539         if(userExists[_user] == false){
1540             users.push(_user);
1541             userExists[_user] = true;
1542         }
1543 
1544         balanceUsers[_user] += _value;
1545     }
1546 
1547      /**
1548     @notice Transfers coins from a certain user to a destination address
1549     
1550         Used to release a certain value of coins from a certain user to a destination address.
1551         This function updates the user's balance in the contract. It can only be called by the 
1552         Advertisement contract registered.
1553     @param _user Address of the user from which the value will be subtracted
1554     @param _destination Address receiving the value transfered
1555     @param _value Value to be transfered in AppCoins
1556     */
1557     function pay(address _user, address _destination, uint256 _value) public onlyAllowed;
1558 
1559     /**
1560     @notice Withdraws a certain value from a user's balance back to the user's account
1561     
1562         Can be called from the Advertisement contract registered or by this contract's owner.
1563     @param _user Address of the user
1564     @param _value Value to be transfered in AppCoins
1565     */
1566     function withdraw(address _user, uint256 _value) public onlyOwnerOrAllowed;
1567 
1568 
1569     /**
1570     @notice Resets this contract and returns every amount deposited to each user registered
1571     
1572         This function is used in case a contract reset is needed or the contract needs to be 
1573         deactivated. Thus returns every fund deposited to it's respective owner.
1574     */
1575     function reset() public onlyOwnerOrAllowed {
1576         for(uint i = 0; i < users.length; i++){
1577             withdraw(users[i],balanceUsers[users[i]]);
1578         }
1579     }
1580     /**
1581     @notice Transfers all funds of the contract to a single address
1582     
1583         This function is used for finance contract upgrades in order to be more cost efficient.
1584     @param _destination Address receiving the funds
1585      */
1586     function transferAllFunds(address _destination) public onlyAllowed {
1587         uint256 balance = appc.balanceOf(address(this));
1588         appc.transfer(_destination,balance);
1589     }
1590 
1591       /**
1592     @notice Get balance of coins stored in the contract by a specific user
1593     
1594         This function can only be called by the Advertisement contract
1595     @param _user Developer's address
1596     @return { '_balance' : 'Balance of coins deposited in the contract by the address' }
1597     */
1598     function getUserBalance(address _user) public view onlyAllowed returns(uint256 _balance){
1599         return balanceUsers[_user];
1600     }
1601 
1602     /**
1603     @notice Get list of users with coins stored in the contract 
1604     
1605         This function can only be called by the Advertisement contract        
1606     @return { '_userList' : ' List of users registered in the contract'}
1607     */
1608     function getUserList() public view onlyAllowed returns(address[] _userList){
1609         return users;
1610     }
1611 }
1612 
1613 contract ExtendedFinance is BaseFinance {
1614 
1615     mapping ( address => uint256 ) rewardedBalance;
1616 
1617     constructor(address _appc) public BaseFinance(_appc){
1618 
1619     }
1620 
1621 
1622     function pay(address _user, address _destination, uint256 _value)
1623         public onlyAllowed{
1624 
1625         require(balanceUsers[_user] >= _value);
1626 
1627         balanceUsers[_user] -= _value;
1628         rewardedBalance[_destination] += _value;
1629     }
1630 
1631 
1632     function withdraw(address _user, uint256 _value) public onlyOwnerOrAllowed {
1633 
1634         require(balanceUsers[_user] >= _value);
1635 
1636         balanceUsers[_user] -= _value;
1637         appc.transfer(_user, _value);
1638 
1639     }
1640 
1641     /**
1642     @notice Withdraws user's rewards
1643     
1644         Function to transfer a certain user's rewards to his address 
1645     @param _user Address who's rewards will be withdrawn
1646     @param _value Value of the withdraws which will be transfered to the user 
1647     */
1648     function withdrawRewards(address _user, uint256 _value) public onlyOwnerOrAllowed {
1649         require(rewardedBalance[_user] >= _value);
1650 
1651         rewardedBalance[_user] -= _value;
1652         appc.transfer(_user, _value);
1653     }
1654     /**
1655     @notice Get user's rewards balance
1656     
1657         Function returning a user's rewards balance not yet withdrawn
1658     @param _user Address of the user
1659     @return { "_balance" : "Rewards balance of the user" }
1660     */
1661     function getRewardsBalance(address _user) public onlyOwnerOrAllowed returns (uint256 _balance) {
1662         return rewardedBalance[_user];
1663     }
1664 
1665 }
1666 
1667 
1668 contract ExtendedAdvertisement is BaseAdvertisement, Whitelist {
1669 
1670     event BulkPoARegistered(bytes32 bidId, bytes32 rootHash, bytes signedrootHash, uint256 newPoAs, uint256 convertedPoAs);
1671     event CampaignInformation
1672         (
1673             bytes32 bidId,
1674             address  owner,
1675             string ipValidator,
1676             string packageName,
1677             uint[3] countries,
1678             uint[] vercodes,
1679             string endpoint
1680     );
1681 
1682     constructor(address _addrAppc, address _addrAdverStorage, address _addrAdverFinance) public
1683         BaseAdvertisement(_addrAppc,_addrAdverStorage,_addrAdverFinance) {
1684         addAddressToWhitelist(msg.sender);
1685     }
1686 
1687 
1688     /**
1689     @notice Creates an extebded campaign
1690     */
1691     function createCampaign (
1692         string packageName,
1693         uint[3] countries,
1694         uint[] vercodes,
1695         uint price,
1696         uint budget,
1697         uint startDate,
1698         uint endDate,
1699         string endPoint)
1700         external
1701         {
1702 
1703         CampaignLibrary.Campaign memory newCampaign = _generateCampaign(packageName, countries, vercodes, price, budget, startDate, endDate);
1704 
1705         if(newCampaign.owner == 0x0){
1706             // campaign was not generated correctly (revert)
1707             return;
1708         }
1709 
1710         _getBidIdList().push(newCampaign.bidId);
1711 
1712         ExtendedAdvertisementStorage(address(_getStorage())).setCampaign(
1713             newCampaign.bidId,
1714             newCampaign.price,
1715             newCampaign.budget,
1716             newCampaign.startDate,
1717             newCampaign.endDate,
1718             newCampaign.valid,
1719             newCampaign.owner,
1720             endPoint);
1721 
1722         emit CampaignInformation(
1723             newCampaign.bidId,
1724             newCampaign.owner,
1725             "", // ipValidator field
1726             packageName,
1727             countries,
1728             vercodes,
1729             endPoint);
1730     }
1731 
1732     /**
1733     @notice Function to submit in bulk PoAs
1734     @param bidId Campaign id for which the Proof of attention root hash refferes to
1735     @param rootHash Root hash of all submitted proof of attention to a given campaign
1736     @param signedRootHash Root hash signed by the signing service of the campaign
1737     @param newHashes Number of new proof of attention hashes since last submission
1738     */
1739     function bulkRegisterPoA(bytes32 bidId, bytes32 rootHash, bytes signedRootHash, uint256 newHashes)
1740         public
1741         onlyIfWhitelisted("createCampaign",msg.sender)
1742         {
1743 
1744         /* address addressSig = recoverSigner(rootHash, signedRootHash); */
1745 
1746         /* if (msg.sender != addressSig) {
1747             emit Error("bulkRegisterPoA","Invalid signature");
1748             return;
1749         } */
1750 
1751         uint price = _getStorage().getCampaignPriceById(bidId);
1752         uint budget = _getStorage().getCampaignBudgetById(bidId);
1753         address owner = _getStorage().getCampaignOwnerById(bidId);
1754         uint maxConversions = division(budget,price);
1755         uint effectiveConversions;
1756         uint totalPay;
1757         uint newBudget;
1758 
1759         if (maxConversions >= newHashes){
1760             effectiveConversions = newHashes;
1761         } else {
1762             effectiveConversions = maxConversions;
1763         }
1764 
1765         totalPay = price*effectiveConversions;
1766         newBudget = budget - totalPay;
1767 
1768         _getFinance().pay(owner,msg.sender,totalPay);
1769         _getStorage().setCampaignBudgetById(bidId,newBudget);
1770 
1771         if(newBudget < price){
1772             _getStorage().setCampaignValidById(bidId,false);
1773         }
1774 
1775         emit BulkPoARegistered(bidId,rootHash,signedRootHash,newHashes,effectiveConversions);
1776     }
1777 
1778     /**
1779     @notice Function to withdraw PoA convertions
1780     */
1781 
1782     function withdraw()
1783         public
1784         onlyIfWhitelisted("withdraw",msg.sender)
1785         {
1786         uint256 balance = ExtendedFinance(address(_getFinance())).getRewardsBalance(msg.sender);
1787         ExtendedFinance(address(_getFinance())).withdrawRewards(msg.sender,balance);
1788     }
1789     /**
1790     @notice Get user's balance of funds obtainded by rewards
1791     @param _user Address from which the balance refers to
1792     @return { "_balance" : "" } */
1793     function getRewardsBalance(address _user) public view returns (uint256 _balance) {
1794         return ExtendedFinance(address(_getFinance())).getRewardsBalance(_user);
1795     }
1796 
1797     /**
1798     @notice Returns the signing Endpoint of a camapign
1799     @param bidId Campaign id to which the Endpoint is associated
1800     @return { "url" : "Validation and signature endpoint"}
1801     */
1802 
1803     function getEndPointOfCampaign (bytes32 bidId) public view returns (string url){
1804         return ExtendedAdvertisementStorage(address(_getStorage())).getCampaignEndPointById(bidId);
1805     }
1806 }