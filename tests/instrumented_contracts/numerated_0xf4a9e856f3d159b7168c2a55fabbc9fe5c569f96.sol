1 pragma solidity 0.4.24;
2 
3 interface StorageUser {
4     function getStorageAddress() external view returns(address _storage);
5 }
6 
7 interface ErrorThrower {
8     event Error(string func, string message);
9 }
10 
11 /**
12  * @title Roles
13  * @author Francisco Giordano (@frangio)
14  *   Library for managing addresses assigned to a Role.
15  * See RBAC.sol for example usage.
16  */
17 library Roles {
18   struct Role {
19     mapping (address => bool) bearer;
20   }
21 
22   /**
23    *   give an address access to this role
24    */
25   function add(Role storage _role, address _addr)
26     internal
27   {
28     _role.bearer[_addr] = true;
29   }
30 
31   /**
32    *   remove an address' access to this role
33    */
34   function remove(Role storage _role, address _addr)
35     internal
36   {
37     _role.bearer[_addr] = false;
38   }
39 
40   /**
41    *   check if an address has this role
42    * // reverts
43    */
44   function check(Role storage _role, address _addr)
45     internal
46     view
47   {
48     require(has(_role, _addr));
49   }
50 
51   /**
52    *   check if an address has this role
53    * @return bool
54    */
55   function has(Role storage _role, address _addr)
56     internal
57     view
58     returns (bool)
59   {
60     return _role.bearer[_addr];
61   }
62 }
63 
64 
65 /**
66  * @title RBAC (Role-Based Access Control)
67  * @author Matt Condon (@Shrugs)
68  *   Stores and provides setters and getters for roles and addresses.
69  * Supports unlimited numbers of roles and addresses.
70  * See //contracts/mocks/RBACMock.sol for an example of usage.
71  * This RBAC method uses strings to key roles. It may be beneficial
72  * for you to write your own implementation of this interface using Enums or similar.
73  */
74 contract RBAC {
75   using Roles for Roles.Role;
76 
77   mapping (string => Roles.Role) private roles;
78 
79   event RoleAdded(address indexed operator, string role);
80   event RoleRemoved(address indexed operator, string role);
81 
82   /**
83    *   reverts if addr does not have role
84    * @param _operator address
85    * @param _role the name of the role
86    * // reverts
87    */
88   function checkRole(address _operator, string _role)
89     public
90     view
91   {
92     roles[_role].check(_operator);
93   }
94 
95   /**
96    *   determine if addr has role
97    * @param _operator address
98    * @param _role the name of the role
99    * @return bool
100    */
101   function hasRole(address _operator, string _role)
102     public
103     view
104     returns (bool)
105   {
106     return roles[_role].has(_operator);
107   }
108 
109   /**
110    *   add a role to an address
111    * @param _operator address
112    * @param _role the name of the role
113    */
114   function addRole(address _operator, string _role)
115     internal
116   {
117     roles[_role].add(_operator);
118     emit RoleAdded(_operator, _role);
119   }
120 
121   /**
122    *   remove a role from an address
123    * @param _operator address
124    * @param _role the name of the role
125    */
126   function removeRole(address _operator, string _role)
127     internal
128   {
129     roles[_role].remove(_operator);
130     emit RoleRemoved(_operator, _role);
131   }
132 
133   /**
134    *   modifier to scope access to a single role (uses msg.sender as addr)
135    * @param _role the name of the role
136    * // reverts
137    */
138   modifier onlyRole(string _role)
139   {
140     checkRole(msg.sender, _role);
141     _;
142   }
143 
144   /**
145    *   modifier to scope access to a set of roles (uses msg.sender as addr)
146    * @param _roles the names of the roles to scope access to
147    * // reverts
148    *
149    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
150    *  see: https://github.com/ethereum/solidity/issues/2467
151    */
152   // modifier onlyRoles(string[] _roles) {
153   //     bool hasAnyRole = false;
154   //     for (uint8 i = 0; i < _roles.length; i++) {
155   //         if (hasRole(msg.sender, _roles[i])) {
156   //             hasAnyRole = true;
157   //             break;
158   //         }
159   //     }
160 
161   //     require(hasAnyRole);
162 
163   //     _;
164   // }
165 }
166 
167 
168 /**
169  * @title SafeMath
170  *   Math operations with safety checks that throw on error
171  */
172 library SafeMath {
173 
174   /**
175   *   Multiplies two numbers, throws on overflow.
176   */
177   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
178     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
179     // benefit is lost if 'b' is also tested.
180     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
181     if (_a == 0) {
182       return 0;
183     }
184 
185     c = _a * _b;
186     assert(c / _a == _b);
187     return c;
188   }
189 
190   /**
191   *   Integer division of two numbers, truncating the quotient.
192   */
193   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
194     // assert(_b > 0); // Solidity automatically throws when dividing by 0
195     // uint256 c = _a / _b;
196     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
197     return _a / _b;
198   }
199 
200   /**
201   *   Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
202   */
203   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
204     assert(_b <= _a);
205     return _a - _b;
206   }
207 
208   /**
209   *   Adds two numbers, throws on overflow.
210   */
211   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
212     c = _a + _b;
213     assert(c >= _a);
214     return c;
215   }
216 }
217 
218 library ExtendedCampaignLibrary {
219     struct ExtendedInfo{
220         bytes32 bidId;
221         string endpoint;
222     }
223 
224     /**
225     @notice Set extended campaign id
226     @param _bidId Id of the campaign
227      */
228     function setBidId(ExtendedInfo storage _extendedInfo, bytes32 _bidId) internal {
229         _extendedInfo.bidId = _bidId;
230     }
231     
232     /**
233     @notice Get extended campaign id
234     @return {'_bidId' : 'Id of the campaign'}
235     */
236     function getBidId(ExtendedInfo storage _extendedInfo) internal view returns(bytes32 _bidId){
237         return _extendedInfo.bidId;
238     }
239 
240 
241     /**
242     @notice Set URL of the signing serivce
243     @param _endpoint URL of the signing serivce
244     */
245     function setEndpoint(ExtendedInfo storage _extendedInfo, string  _endpoint) internal {
246         _extendedInfo.endpoint = _endpoint;
247     }
248 
249     /**
250     @notice Get URL of the signing service
251     @return {'_endpoint' : 'URL of the signing serivce'} 
252     */
253     function getEndpoint(ExtendedInfo storage _extendedInfo) internal view returns (string _endpoint) {
254         return _extendedInfo.endpoint;
255     }
256 }
257 
258 library CampaignLibrary {
259 
260     struct Campaign {
261         bytes32 bidId;
262         uint price;
263         uint budget;
264         uint startDate;
265         uint endDate;
266         bool valid;
267         address  owner;
268     }
269 
270 
271     /**
272     @notice Set campaign id 
273     @param _bidId Id of the campaign
274      */
275     function setBidId(Campaign storage _campaign, bytes32 _bidId) internal {
276         _campaign.bidId = _bidId;
277     }
278 
279     /**
280     @notice Get campaign id
281     @return {'_bidId' : 'Id of the campaign'}
282      */
283     function getBidId(Campaign storage _campaign) internal view returns(bytes32 _bidId){
284         return _campaign.bidId;
285     }
286    
287     /**
288     @notice Set campaing price per proof of attention
289     @param _price Price of the campaign
290      */
291     function setPrice(Campaign storage _campaign, uint _price) internal {
292         _campaign.price = _price;
293     }
294 
295     /**
296     @notice Get campaign price per proof of attention
297     @return {'_price' : 'Price of the campaign'}
298      */
299     function getPrice(Campaign storage _campaign) internal view returns(uint _price){
300         return _campaign.price;
301     }
302 
303     /**
304     @notice Set campaign total budget 
305     @param _budget Total budget of the campaign
306      */
307     function setBudget(Campaign storage _campaign, uint _budget) internal {
308         _campaign.budget = _budget;
309     }
310 
311     /**
312     @notice Get campaign total budget
313     @return {'_budget' : 'Total budget of the campaign'}
314      */
315     function getBudget(Campaign storage _campaign) internal view returns(uint _budget){
316         return _campaign.budget;
317     }
318 
319     /**
320     @notice Set campaign start date 
321     @param _startDate Start date of the campaign (in milisecounds)
322      */
323     function setStartDate(Campaign storage _campaign, uint _startDate) internal{
324         _campaign.startDate = _startDate;
325     }
326 
327     /**
328     @notice Get campaign start date 
329     @return {'_startDate' : 'Start date of the campaign (in milisecounds)'}
330      */
331     function getStartDate(Campaign storage _campaign) internal view returns(uint _startDate){
332         return _campaign.startDate;
333     }
334  
335     /**
336     @notice Set campaign end date 
337     @param _endDate End date of the campaign (in milisecounds)
338      */
339     function setEndDate(Campaign storage _campaign, uint _endDate) internal {
340         _campaign.endDate = _endDate;
341     }
342 
343     /**
344     @notice Get campaign end date 
345     @return {'_endDate' : 'End date of the campaign (in milisecounds)'}
346      */
347     function getEndDate(Campaign storage _campaign) internal view returns(uint _endDate){
348         return _campaign.endDate;
349     }
350 
351     /**
352     @notice Set campaign validity 
353     @param _valid Validity of the campaign
354      */
355     function setValidity(Campaign storage _campaign, bool _valid) internal {
356         _campaign.valid = _valid;
357     }
358 
359     /**
360     @notice Get campaign validity 
361     @return {'_valid' : 'Boolean stating campaign validity'}
362      */
363     function getValidity(Campaign storage _campaign) internal view returns(bool _valid){
364         return _campaign.valid;
365     }
366 
367     /**
368     @notice Set campaign owner 
369     @param _owner Owner of the campaign
370      */
371     function setOwner(Campaign storage _campaign, address _owner) internal {
372         _campaign.owner = _owner;
373     }
374 
375     /**
376     @notice Get campaign owner 
377     @return {'_owner' : 'Address of the owner of the campaign'}
378      */
379     function getOwner(Campaign storage _campaign) internal view returns(address _owner){
380         return _campaign.owner;
381     }
382 
383     /**
384     @notice Converts country index list into 3 uints
385        
386         Expects a list of country indexes such that the 2 digit country code is converted to an 
387         index. Countries are expected to be indexed so a "AA" country code is mapped to index 0 and 
388         "ZZ" country is mapped to index 675.
389     @param countries List of country indexes
390     @return {
391         "countries1" : "First third of the byte array converted in a 256 bytes uint",
392         "countries2" : "Second third of the byte array converted in a 256 bytes uint",
393         "countries3" : "Third third of the byte array converted in a 256 bytes uint"
394     }
395     */
396     function convertCountryIndexToBytes(uint[] countries) public pure
397         returns (uint countries1,uint countries2,uint countries3){
398         countries1 = 0;
399         countries2 = 0;
400         countries3 = 0;
401         for(uint i = 0; i < countries.length; i++){
402             uint index = countries[i];
403 
404             if(index<256){
405                 countries1 = countries1 | uint(1) << index;
406             } else if (index<512) {
407                 countries2 = countries2 | uint(1) << (index - 256);
408             } else {
409                 countries3 = countries3 | uint(1) << (index - 512);
410             }
411         }
412 
413         return (countries1,countries2,countries3);
414     }    
415 }
416 
417 
418 // AppCoins contract with share splitting among different wallets
419 // Not fully ERC20 compliant due to tests purposes
420 
421 
422 contract ERC20Interface {
423     function name() public view returns(bytes32);
424     function symbol() public view returns(bytes32);
425     function balanceOf (address _owner) public view returns(uint256 balance);
426     function transfer(address _to, uint256 _value) public returns (bool success);
427     function transferFrom(address _from, address _to, uint256 _value) public returns (uint);
428     event Transfer(address indexed _from, address indexed _to, uint256 _value);
429 }
430 
431 contract AppCoins is ERC20Interface{
432     // Public variables of the token
433     address public owner;
434     bytes32 private token_name;
435     bytes32 private token_symbol;
436     uint8 public decimals = 18;
437     // 18 decimals is the strongly suggested default, avoid changing it
438     uint256 public totalSupply;
439 
440     // This creates an array with all balances
441     mapping (address => uint256) public balances;
442     mapping (address => mapping (address => uint256)) public allowance;
443 
444     // This generates a public event on the blockchain that will notify clients
445     event Transfer(address indexed from, address indexed to, uint256 value);
446 
447     // This notifies clients about the amount burnt
448     event Burn(address indexed from, uint256 value);
449 
450     /**
451      * Constrctor function
452      *
453      * Initializes contract with initial supply tokens to the creator of the contract
454      */
455     function AppCoins() public {
456         owner = msg.sender;
457         token_name = "AppCoins";
458         token_symbol = "APPC";
459         uint256 _totalSupply = 1000000;
460         totalSupply = _totalSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
461         balances[owner] = totalSupply;                // Give the creator all initial tokens
462     }
463 
464     function name() public view returns(bytes32) {
465         return token_name;
466     }
467 
468     function symbol() public view returns(bytes32) {
469         return token_symbol;
470     }
471 
472     function balanceOf (address _owner) public view returns(uint256 balance) {
473         return balances[_owner];
474     }
475 
476     /**
477      * Internal transfer, only can be called by this contract
478      */
479     function _transfer(address _from, address _to, uint _value) internal returns (bool) {
480         // Prevent transfer to 0x0 address. Use burn() instead
481         require(_to != 0x0);
482         // Check if the sender has enough
483         require(balances[_from] >= _value);
484         // Check for overflows
485         require(balances[_to] + _value > balances[_to]);
486         // Save this for an assertion in the future
487         uint previousBalances = balances[_from] + balances[_to];
488         // Subtract from the sender
489         balances[_from] -= _value;
490         // Add the same to the recipient
491         balances[_to] += _value;
492         emit Transfer(_from, _to, _value);
493         // Asserts are used to use static analysis to find bugs in your code. They should never fail
494         assert(balances[_from] + balances[_to] == previousBalances);
495     }
496 
497     // /**
498     //  * Transfer tokens
499     //  *
500     //  * Send `_value` tokens to `_to` from your account
501     //  *
502     //  * @param _to The address of the recipient
503     //  * @param _value the amount to send
504     //  */
505     // function transfer(address _to, uint256 _value) public {
506     //     _transfer(msg.sender, _to, _value);
507     // }
508     function transfer (address _to, uint256 _amount) public returns (bool success) {
509         if( balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
510 
511             balances[msg.sender] -= _amount;
512             balances[_to] += _amount;
513             emit Transfer(msg.sender, _to, _amount);
514             return true;
515         } else {
516             return false;
517         }
518     }
519 
520     /**
521      * Transfer tokens from other address
522      *
523      * Send `_value` tokens to `_to` on behalf of `_from`
524      *
525      * @param _from The address of the sender
526      * @param _to The address of the recipient
527      * @param _value the amount to send
528      */
529     function transferFrom(address _from, address _to, uint256 _value) public returns (uint) {
530         require(_value <= allowance[_from][msg.sender]);     // Check allowance
531         allowance[_from][msg.sender] -= _value;
532         _transfer(_from, _to, _value);
533         return allowance[_from][msg.sender];
534     }
535 
536     /**
537      * Set allowance for other address
538      *
539      * Allows `_spender` to spend no more than `_value` tokens on your behalf
540      *
541      * @param _spender The address authorized to spend
542      * @param _value the max amount they can spend
543      */
544     function approve(address _spender, uint256 _value) public
545         returns (bool success) {
546         allowance[msg.sender][_spender] = _value;
547         return true;
548     }
549 
550     /**
551      * Destroy tokens
552      *
553      * Remove `_value` tokens from the system irreversibly
554      *
555      * @param _value the amount of money to burn
556      */
557     function burn(uint256 _value) public returns (bool success) {
558         require(balances[msg.sender] >= _value);   // Check if the sender has enough
559         balances[msg.sender] -= _value;            // Subtract from the sender
560         totalSupply -= _value;                      // Updates totalSupply
561         emit Burn(msg.sender, _value);
562         return true;
563     }
564 
565     /**
566      * Destroy tokens from other account
567      *
568      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
569      *
570      * @param _from the address of the sender
571      * @param _value the amount of money to burn
572      */
573     function burnFrom(address _from, uint256 _value) public returns (bool success) {
574         require(balances[_from] >= _value);                // Check if the targeted balance is enough
575         require(_value <= allowance[_from][msg.sender]);    // Check allowance
576         balances[_from] -= _value;                         // Subtract from the targeted balance
577         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
578         totalSupply -= _value;                              // Update totalSupply
579         emit Burn(_from, _value);
580         return true;
581     }
582 }
583 
584 
585 /**
586  * @title Ownable
587  *   The Ownable contract has an owner address, and provides basic authorization control
588  * functions, this simplifies the implementation of "user permissions".
589  */
590 contract Ownable is ErrorThrower {
591     address public owner;
592     
593     event OwnershipRenounced(address indexed previousOwner);
594     event OwnershipTransferred(
595         address indexed previousOwner,
596         address indexed newOwner
597     );
598 
599 
600     /**
601     *   The Ownable constructor sets the original `owner` of the contract to the sender
602     * account.
603     */
604     constructor() public {
605         owner = msg.sender;
606     }
607 
608     /**
609     *   Throws if called by any account other than the owner.
610     */
611     modifier onlyOwner(string _funcName) {
612         if(msg.sender != owner){
613             emit Error(_funcName,"Operation can only be performed by contract owner");
614             return;
615         }
616         _;
617     }
618 
619     /**
620     *   Allows the current owner to relinquish control of the contract.
621     * @notice Renouncing to ownership will leave the contract without an owner.
622     * It will not be possible to call the functions with the `onlyOwner`
623     * modifier anymore.
624     */
625     function renounceOwnership() public onlyOwner("renounceOwnership") {
626         emit OwnershipRenounced(owner);
627         owner = address(0);
628     }
629 
630     /**
631     *   Allows the current owner to transfer control of the contract to a newOwner.
632     * @param _newOwner The address to transfer ownership to.
633     */
634     function transferOwnership(address _newOwner) public onlyOwner("transferOwnership") {
635         _transferOwnership(_newOwner);
636     }
637 
638     /**
639     *   Transfers control of the contract to a newOwner.
640     * @param _newOwner The address to transfer ownership to.
641     */
642     function _transferOwnership(address _newOwner) internal {
643         if(_newOwner == address(0)){
644             emit Error("transferOwnership","New owner's address needs to be different than 0x0");
645             return;
646         }
647 
648         emit OwnershipTransferred(owner, _newOwner);
649         owner = _newOwner;
650     }
651 }
652 
653 /**
654 *  @title Whitelist
655 *    The Whitelist contract is based on OpenZeppelin's Whitelist contract.
656 *       Has a whitelist of addresses and provides basic authorization control functions.
657 *       This simplifies the implementation of "user permissions". The main change from 
658 *       Whitelist's original contract (version 1.12.0) is the use of Error event instead of a revert.
659  */
660 
661 contract Whitelist is Ownable, RBAC {
662     string public constant ROLE_WHITELISTED = "whitelist";
663 
664     /**
665     *   Throws Error event if operator is not whitelisted.
666     * @param _operator address
667     */
668     modifier onlyIfWhitelisted(string _funcname, address _operator) {
669         if(!hasRole(_operator, ROLE_WHITELISTED)){
670             emit Error(_funcname, "Operation can only be performed by Whitelisted Addresses");
671             return;
672         }
673         _;
674     }
675 
676     /**
677     *   add an address to the whitelist
678     * @param _operator address
679     * @return true if the address was added to the whitelist, false if the address was already in the whitelist
680     */
681     function addAddressToWhitelist(address _operator)
682         public
683         onlyOwner("addAddressToWhitelist")
684     {
685         addRole(_operator, ROLE_WHITELISTED);
686     }
687 
688     /**
689     *   getter to determine if address is in whitelist
690     */
691     function whitelist(address _operator)
692         public
693         view
694         returns (bool)
695     {
696         return hasRole(_operator, ROLE_WHITELISTED);
697     }
698 
699     /**
700     *   add addresses to the whitelist
701     * @param _operators addresses
702     * @return true if at least one address was added to the whitelist,
703     * false if all addresses were already in the whitelist
704     */
705     function addAddressesToWhitelist(address[] _operators)
706         public
707         onlyOwner("addAddressesToWhitelist")
708     {
709         for (uint256 i = 0; i < _operators.length; i++) {
710             addAddressToWhitelist(_operators[i]);
711         }
712     }
713 
714     /**
715     *   remove an address from the whitelist
716     * @param _operator address
717     * @return true if the address was removed from the whitelist,
718     * false if the address wasn't in the whitelist in the first place
719     */
720     function removeAddressFromWhitelist(address _operator)
721         public
722         onlyOwner("removeAddressFromWhitelist")
723     {
724         removeRole(_operator, ROLE_WHITELISTED);
725     }
726 
727     /**
728     *   remove addresses from the whitelist
729     * @param _operators addresses
730     * @return true if at least one address was removed from the whitelist,
731     * false if all addresses weren't in the whitelist in the first place
732     */
733     function removeAddressesFromWhitelist(address[] _operators)
734         public
735         onlyOwner("removeAddressesFromWhitelist")
736     {
737         for (uint256 i = 0; i < _operators.length; i++) {
738             removeAddressFromWhitelist(_operators[i]);
739         }
740     }
741 
742 }
743 
744 contract BaseAdvertisementStorage is Whitelist {
745     using CampaignLibrary for CampaignLibrary.Campaign;
746 
747     mapping (bytes32 => CampaignLibrary.Campaign) public campaigns;
748 
749     bytes32 public lastBidId = 0x0;
750 
751     modifier onlyIfCampaignExists(string _funcName, bytes32 _bidId) {
752         if(campaigns[_bidId].owner == 0x0){
753             emit Error(_funcName,"Campaign does not exist");
754             return;
755         }
756         _;
757     }
758     
759     event CampaignCreated
760         (
761             bytes32 bidId,
762             uint price,
763             uint budget,
764             uint startDate,
765             uint endDate,
766             bool valid,
767             address owner
768     );
769 
770     event CampaignUpdated
771         (
772             bytes32 bidId,
773             uint price,
774             uint budget,
775             uint startDate,
776             uint endDate,
777             bool valid,
778             address  owner
779     );
780 
781     /**
782     @notice Get a Campaign information
783       
784         Based on a camapaign Id (bidId), returns all stored information for that campaign.
785     @param campaignId Id of the campaign
786     @return {
787         "bidId" : "Id of the campaign",
788         "price" : "Value to pay for each proof-of-attention",
789         "budget" : "Total value avaliable to be spent on the campaign",
790         "startDate" : "Start date of the campaign (in miliseconds)",
791         "endDate" : "End date of the campaign (in miliseconds)"
792         "valid" : "Boolean informing if the campaign is valid",
793         "campOwner" : "Address of the campaing's owner"
794     }
795     */
796     function _getCampaign(bytes32 campaignId)
797         internal
798         returns (CampaignLibrary.Campaign storage _campaign) {
799 
800 
801         return campaigns[campaignId];
802     }
803 
804 
805     /**
806     @notice Add or update a campaign information
807      
808         Based on a campaign Id (bidId), a campaign can be created (if non existent) or updated.
809         This function can only be called by the set of allowed addresses registered earlier.
810         An event will be emited during this function's execution, a CampaignCreated event if the 
811         campaign does not exist yet or a CampaignUpdated if the campaign id is already registered.
812 
813     @param bidId Id of the campaign
814     @param price Value to pay for each proof-of-attention
815     @param budget Total value avaliable to be spent on the campaign
816     @param startDate Start date of the campaign (in miliseconds)
817     @param endDate End date of the campaign (in miliseconds)
818     @param valid Boolean informing if the campaign is valid
819     @param owner Address of the campaing's owner
820     */
821     function _setCampaign (
822         bytes32 bidId,
823         uint price,
824         uint budget,
825         uint startDate,
826         uint endDate,
827         bool valid,
828         address owner
829     )
830     public
831     onlyIfWhitelisted("setCampaign",msg.sender) {
832 
833         CampaignLibrary.Campaign storage campaign = campaigns[bidId];
834         campaign.setBidId(bidId);
835         campaign.setPrice(price);
836         campaign.setBudget(budget);
837         campaign.setStartDate(startDate);
838         campaign.setEndDate(endDate);
839         campaign.setValidity(valid);
840 
841         bool newCampaign = (campaigns[bidId].getOwner() == 0x0);
842 
843         campaign.setOwner(owner);
844 
845 
846 
847         if(newCampaign){
848             emitCampaignCreated(campaign);
849             setLastBidId(bidId);
850         } else {
851             emitCampaignUpdated(campaign);
852         }
853     }
854 
855     /**
856     @notice Constructor function
857      
858         Initializes contract and updates allowed addresses to interact with contract functions.
859     */
860     constructor() public {
861         addAddressToWhitelist(msg.sender);
862     }
863 
864       /**
865     @notice Get the price of a campaign
866      
867         Based on the Campaign id, return the value paid for each proof of attention registered.
868     @param bidId Campaign id to which the query refers
869     @return { "price" : "Reward (in wei) for each proof of attention registered"} 
870     */
871     function getCampaignPriceById(bytes32 bidId)
872         public
873         view
874         returns (uint price) {
875         return campaigns[bidId].getPrice();
876     }
877 
878     /** 
879     @notice Set a new price for a campaign
880      
881         Based on the Campaign id, updates the value paid for each proof of attention registered.
882         This function can only be executed by allowed addresses and emits a CampaingUpdate event.
883     @param bidId Campaing id to which the update refers
884     @param price New price for each proof of attention
885     */
886     function setCampaignPriceById(bytes32 bidId, uint price)
887         public
888         onlyIfWhitelisted("setCampaignPriceById",msg.sender) 
889         onlyIfCampaignExists("setCampaignPriceById",bidId)      
890         {
891         campaigns[bidId].setPrice(price);
892         emitCampaignUpdated(campaigns[bidId]);
893     }
894 
895     /**
896     @notice Get the budget avaliable of a campaign
897      
898         Based on the Campaign id, return the total value avaliable to pay for proofs of attention.
899     @param bidId Campaign id to which the query refers
900     @return { "budget" : "Total value (in wei) spendable in proof of attention rewards"} 
901     */
902     function getCampaignBudgetById(bytes32 bidId)
903         public
904         view
905         returns (uint budget) {
906         return campaigns[bidId].getBudget();
907     }
908 
909     /**
910     @notice Set a new campaign budget
911      
912         Based on the Campaign id, updates the total value avaliable for proof of attention 
913         registrations. This function can only be executed by allowed addresses and emits a 
914         CampaignUpdated event. This function does not transfer any funds as this contract only works
915         as a data repository, every logic needed will be processed in the Advertisement contract.
916     @param bidId Campaign id to which the query refers
917     @param newBudget New value for the total budget of the campaign
918     */
919     function setCampaignBudgetById(bytes32 bidId, uint newBudget)
920         public
921         onlyIfCampaignExists("setCampaignBudgetById",bidId)
922         onlyIfWhitelisted("setCampaignBudgetById",msg.sender)
923         {
924         campaigns[bidId].setBudget(newBudget);
925         emitCampaignUpdated(campaigns[bidId]);
926     }
927 
928     /** 
929     @notice Get the start date of a campaign
930      
931         Based on the Campaign id, return the value (in miliseconds) corresponding to the start Date
932         of the campaign.
933     @param bidId Campaign id to which the query refers
934     @return { "startDate" : "Start date (in miliseconds) of the campaign"} 
935     */
936     function getCampaignStartDateById(bytes32 bidId)
937         public
938         view
939         returns (uint startDate) {
940         return campaigns[bidId].getStartDate();
941     }
942 
943     /**
944     @notice Set a new start date for a campaign
945      
946         Based of the Campaign id, updates the start date of a campaign. This function can only be 
947         executed by allowed addresses and emits a CampaignUpdated event.
948     @param bidId Campaign id to which the query refers
949     @param newStartDate New value (in miliseconds) for the start date of the campaign
950     */
951     function setCampaignStartDateById(bytes32 bidId, uint newStartDate)
952         public
953         onlyIfCampaignExists("setCampaignStartDateById",bidId)
954         onlyIfWhitelisted("setCampaignStartDateById",msg.sender)
955         {
956         campaigns[bidId].setStartDate(newStartDate);
957         emitCampaignUpdated(campaigns[bidId]);
958     }
959     
960     /** 
961     @notice Get the end date of a campaign
962      
963         Based on the Campaign id, return the value (in miliseconds) corresponding to the end Date
964         of the campaign.
965     @param bidId Campaign id to which the query refers
966     @return { "endDate" : "End date (in miliseconds) of the campaign"} 
967     */
968     function getCampaignEndDateById(bytes32 bidId)
969         public
970         view
971         returns (uint endDate) {
972         return campaigns[bidId].getEndDate();
973     }
974 
975     /**
976     @notice Set a new end date for a campaign
977      
978         Based of the Campaign id, updates the end date of a campaign. This function can only be 
979         executed by allowed addresses and emits a CampaignUpdated event.
980     @param bidId Campaign id to which the query refers
981     @param newEndDate New value (in miliseconds) for the end date of the campaign
982     */
983     function setCampaignEndDateById(bytes32 bidId, uint newEndDate)
984         public
985         onlyIfCampaignExists("setCampaignEndDateById",bidId)
986         onlyIfWhitelisted("setCampaignEndDateById",msg.sender)
987         {
988         campaigns[bidId].setEndDate(newEndDate);
989         emitCampaignUpdated(campaigns[bidId]);
990     }
991     /** 
992     @notice Get information regarding validity of a campaign.
993      
994         Based on the Campaign id, return a boolean which represents a valid campaign if it has 
995         the value of True else has the value of False.
996     @param bidId Campaign id to which the query refers
997     @return { "valid" : "Validity of the campaign"} 
998     */
999     function getCampaignValidById(bytes32 bidId)
1000         public
1001         view
1002         returns (bool valid) {
1003         return campaigns[bidId].getValidity();
1004     }
1005 
1006     /**
1007     @notice Set a new campaign validity state.
1008      
1009         Updates the validity of a campaign based on a campaign Id. This function can only be 
1010         executed by allowed addresses and emits a CampaignUpdated event.
1011     @param bidId Campaign id to which the query refers
1012     @param isValid New value for the campaign validity
1013     */
1014     function setCampaignValidById(bytes32 bidId, bool isValid)
1015         public
1016         onlyIfCampaignExists("setCampaignValidById",bidId)
1017         onlyIfWhitelisted("setCampaignValidById",msg.sender)
1018         {
1019         campaigns[bidId].setValidity(isValid);
1020         emitCampaignUpdated(campaigns[bidId]);
1021     }
1022 
1023     /**
1024     @notice Get the owner of a campaign 
1025       
1026         Based on the Campaign id, return the address of the campaign owner.
1027     @param bidId Campaign id to which the query refers
1028     @return { "campOwner" : "Address of the campaign owner" } 
1029     */
1030     function getCampaignOwnerById(bytes32 bidId)
1031         public
1032         view
1033         returns (address campOwner) {
1034         return campaigns[bidId].getOwner();
1035     }
1036 
1037     /**
1038     @notice Set a new campaign owner 
1039      
1040         Based on the Campaign id, update the owner of the refered campaign. This function can only 
1041         be executed by allowed addresses and emits a CampaignUpdated event.
1042     @param bidId Campaign id to which the query refers
1043     @param newOwner New address to be the owner of the campaign
1044     */
1045     function setCampaignOwnerById(bytes32 bidId, address newOwner)
1046         public
1047         onlyIfCampaignExists("setCampaignOwnerById",bidId)
1048         onlyIfWhitelisted("setCampaignOwnerById",msg.sender)
1049         {
1050         campaigns[bidId].setOwner(newOwner);
1051         emitCampaignUpdated(campaigns[bidId]);
1052     }
1053 
1054     /**
1055     @notice Function to emit campaign updates
1056      
1057         It emits a CampaignUpdated event with the new campaign information. 
1058     */
1059     function emitCampaignUpdated(CampaignLibrary.Campaign storage campaign) private {
1060         emit CampaignUpdated(
1061             campaign.getBidId(),
1062             campaign.getPrice(),
1063             campaign.getBudget(),
1064             campaign.getStartDate(),
1065             campaign.getEndDate(),
1066             campaign.getValidity(),
1067             campaign.getOwner()
1068         );
1069     }
1070 
1071     /**
1072     @notice Function to emit campaign creations
1073      
1074         It emits a CampaignCreated event with the new campaign created. 
1075     */
1076     function emitCampaignCreated(CampaignLibrary.Campaign storage campaign) private {
1077         emit CampaignCreated(
1078             campaign.getBidId(),
1079             campaign.getPrice(),
1080             campaign.getBudget(),
1081             campaign.getStartDate(),
1082             campaign.getEndDate(),
1083             campaign.getValidity(),
1084             campaign.getOwner()
1085         );
1086     }
1087 
1088     /**
1089     @notice Internal function to set most recent bidId
1090      
1091         This value is stored to avoid conflicts between
1092         Advertisement contract upgrades.
1093     @param _newBidId Newer bidId
1094      */
1095     function setLastBidId(bytes32 _newBidId) internal {    
1096         lastBidId = _newBidId;
1097     }
1098 
1099     /**
1100     @notice Returns the greatest BidId ever registered to the contract
1101     @return { '_lastBidId' : 'Greatest bidId registered to the contract'}
1102      */
1103     function getLastBidId() 
1104         external 
1105         returns (bytes32 _lastBidId){
1106         
1107         return lastBidId;
1108     }
1109 }
1110 
1111 
1112 contract ExtendedAdvertisementStorage is BaseAdvertisementStorage {
1113     using ExtendedCampaignLibrary for ExtendedCampaignLibrary.ExtendedInfo;
1114 
1115     mapping (bytes32 => ExtendedCampaignLibrary.ExtendedInfo) public extendedCampaignInfo;
1116     
1117     event ExtendedCampaignCreated(
1118         bytes32 bidId,
1119         string endPoint
1120     );
1121 
1122     event ExtendedCampaignUpdated(
1123         bytes32 bidId,
1124         string endPoint
1125     );
1126 
1127     /**
1128     @notice Get a Campaign information
1129       
1130         Based on a camapaign Id (bidId), returns all stored information for that campaign.
1131     @param _campaignId Id of the campaign
1132     @return {
1133         "_bidId" : "Id of the campaign",
1134         "_price" : "Value to pay for each proof-of-attention",
1135         "_budget" : "Total value avaliable to be spent on the campaign",
1136         "_startDate" : "Start date of the campaign (in miliseconds)",
1137         "_endDate" : "End date of the campaign (in miliseconds)"
1138         "_valid" : "Boolean informing if the campaign is valid",
1139         "_campOwner" : "Address of the campaing's owner",
1140     }
1141     */
1142     function getCampaign(bytes32 _campaignId)
1143         public
1144         view
1145         returns (
1146             bytes32 _bidId,
1147             uint _price,
1148             uint _budget,
1149             uint _startDate,
1150             uint _endDate,
1151             bool _valid,
1152             address _campOwner
1153         ) {
1154 
1155         CampaignLibrary.Campaign storage campaign = _getCampaign(_campaignId);
1156 
1157         return (
1158             campaign.getBidId(),
1159             campaign.getPrice(),
1160             campaign.getBudget(),
1161             campaign.getStartDate(),
1162             campaign.getEndDate(),
1163             campaign.getValidity(),
1164             campaign.getOwner()
1165         );
1166     }
1167 
1168     /**
1169     @notice Add or update a campaign information
1170      
1171         Based on a campaign Id (bidId), a campaign can be created (if non existent) or updated.
1172         This function can only be called by the set of allowed addresses registered earlier.
1173         An event will be emited during this function's execution, a CampaignCreated and a 
1174         ExtendedCampaignEndPointCreated event if the campaign does not exist yet or a 
1175         CampaignUpdated and a ExtendedCampaignEndPointUpdated event if the campaign id is already 
1176         registered.
1177 
1178     @param _bidId Id of the campaign
1179     @param _price Value to pay for each proof-of-attention
1180     @param _budget Total value avaliable to be spent on the campaign
1181     @param _startDate Start date of the campaign (in miliseconds)
1182     @param _endDate End date of the campaign (in miliseconds)
1183     @param _valid Boolean informing if the campaign is valid
1184     @param _owner Address of the campaing's owner
1185     @param _endPoint URL of the signing serivce
1186     */
1187     function setCampaign (
1188         bytes32 _bidId,
1189         uint _price,
1190         uint _budget,
1191         uint _startDate,
1192         uint _endDate,
1193         bool _valid,
1194         address _owner,
1195         string _endPoint
1196     )
1197     public
1198     onlyIfWhitelisted("setCampaign",msg.sender) {
1199         
1200         bool newCampaign = (getCampaignOwnerById(_bidId) == 0x0);
1201         _setCampaign(_bidId, _price, _budget, _startDate, _endDate, _valid, _owner);
1202         
1203         ExtendedCampaignLibrary.ExtendedInfo storage extendedInfo = extendedCampaignInfo[_bidId];
1204         extendedInfo.setBidId(_bidId);
1205         extendedInfo.setEndpoint(_endPoint);
1206 
1207         extendedCampaignInfo[_bidId] = extendedInfo;
1208 
1209         if(newCampaign){
1210             emit ExtendedCampaignCreated(_bidId,_endPoint);
1211         } else {
1212             emit ExtendedCampaignUpdated(_bidId,_endPoint);
1213         }
1214     }
1215 
1216     /**
1217     @notice Get campaign signing web service endpoint
1218      
1219         Get the end point to which the user should submit the proof of attention to be signed
1220     @param _bidId Id of the campaign
1221     @return { "_endPoint": "URL for the signing web service"}
1222     */
1223 
1224     function getCampaignEndPointById(bytes32 _bidId) 
1225         public returns (string _endPoint){
1226         return extendedCampaignInfo[_bidId].getEndpoint();
1227     }
1228 
1229     /**
1230     @notice Set campaign signing web service endpoint
1231      
1232         Sets the webservice's endpoint to which the user should submit the proof of attention
1233     @param _bidId Id of the campaign
1234     @param _endPoint URL for the signing web service
1235     */
1236     function setCampaignEndPointById(bytes32 _bidId, string _endPoint) 
1237         public 
1238         onlyIfCampaignExists("setCampaignEndPointById",_bidId)
1239         onlyIfWhitelisted("setCampaignEndPointById",msg.sender) 
1240         {
1241         extendedCampaignInfo[_bidId].setEndpoint(_endPoint);
1242         emit ExtendedCampaignUpdated(_bidId, _endPoint);
1243     }
1244 
1245 }
1246 
1247 contract SingleAllowance is Ownable {
1248 
1249     address public allowedAddress;
1250 
1251     modifier onlyAllowed() {
1252         require(allowedAddress == msg.sender);
1253         _;
1254     }
1255 
1256     modifier onlyOwnerOrAllowed() {
1257         require(owner == msg.sender || allowedAddress == msg.sender);
1258         _;
1259     }
1260 
1261     function setAllowedAddress(address _addr) public onlyOwner("setAllowedAddress"){
1262         allowedAddress = _addr;
1263     }
1264 }
1265 
1266 contract BaseFinance is SingleAllowance {
1267 
1268     mapping (address => uint256) public balanceUsers;
1269     mapping (address => bool) public userExists;
1270 
1271     address[] public users;
1272 
1273     address public advStorageContract;
1274 
1275     AppCoins public appc;
1276 
1277     /**
1278     @notice Constructor function
1279       
1280         Initializes contract with the AppCoins contract address
1281     @param _addrAppc Address of the AppCoins (ERC-20) contract
1282     */
1283     constructor (address _addrAppc) 
1284         public {
1285         appc = AppCoins(_addrAppc);
1286         advStorageContract = 0x0;
1287     }
1288 
1289 
1290     /**
1291     @notice Sets the Storage contract address used by the allowed contract
1292      
1293         The Storage contract address is mostly used as part of a failsafe mechanism to
1294         ensure contract upgrades are executed using the same Storage 
1295         contract. This function returns every value of AppCoins stored in this contract to their 
1296         owners. This function can only be called by the 
1297         Finance contract owner or by the allowed contract registered earlier in 
1298         this contract.
1299     @param _addrStorage Address of the new Storage contract
1300     */
1301     function setAdsStorageAddress (address _addrStorage) external onlyOwnerOrAllowed {
1302         reset();
1303         advStorageContract = _addrStorage;
1304     }
1305 
1306         /**
1307     @notice Sets the Advertisement contract address to allow calls from Advertisement contract
1308      
1309         This function is used for upgrading the Advertisement contract without need to redeploy 
1310         Advertisement Finance and Advertisement Storage contracts. The function can only be called 
1311         by this contract's owner. During the update of the Advertisement contract address, the 
1312         contract for Advertisement Storage used by the new Advertisement contract is checked. 
1313         This function reverts if the new Advertisement contract does not use the same Advertisement 
1314         Storage contract earlier registered in this Advertisement Finance contract.
1315     @param _addr Address of the newly allowed contract 
1316     */
1317     function setAllowedAddress (address _addr) public onlyOwner("setAllowedAddress") {
1318         // Verify if the new Ads contract is using the same storage as before 
1319         if (allowedAddress != 0x0){
1320             StorageUser storageUser = StorageUser(_addr);
1321             address storageContract = storageUser.getStorageAddress();
1322             require (storageContract == advStorageContract);
1323         }
1324         
1325         //Update contract
1326         super.setAllowedAddress(_addr);
1327     }
1328 
1329     /**
1330     @notice Increases balance of a user
1331      
1332         This function can only be called by the registered Advertisement contract and increases the 
1333         balance of a specific user on this contract. This function does not transfer funds, 
1334         this step need to be done earlier by the Advertisement contract. This function can only be 
1335         called by the registered Advertisement contract.
1336     @param _user Address of the user who will receive a balance increase
1337     @param _value Value of coins to increase the user's balance
1338     */
1339     function increaseBalance(address _user, uint256 _value) 
1340         public onlyAllowed{
1341 
1342         if(userExists[_user] == false){
1343             users.push(_user);
1344             userExists[_user] = true;
1345         }
1346 
1347         balanceUsers[_user] = SafeMath.add(balanceUsers[_user], _value);
1348     }
1349 
1350      /**
1351     @notice Transfers coins from a certain user to a destination address
1352      
1353         Used to release a certain value of coins from a certain user to a destination address.
1354         This function updates the user's balance in the contract. It can only be called by the 
1355         Advertisement contract registered.
1356     @param _user Address of the user from which the value will be subtracted
1357     @param _destination Address receiving the value transfered
1358     @param _value Value to be transfered in AppCoins
1359     */
1360     function pay(address _user, address _destination, uint256 _value) public onlyAllowed;
1361 
1362     /**
1363     @notice Withdraws a certain value from a user's balance back to the user's account
1364      
1365         Can be called from the Advertisement contract registered or by this contract's owner.
1366     @param _user Address of the user
1367     @param _value Value to be transfered in AppCoins
1368     */
1369     function withdraw(address _user, uint256 _value) public onlyOwnerOrAllowed;
1370 
1371 
1372     /**
1373     @notice Resets this contract and returns every amount deposited to each user registered
1374      
1375         This function is used in case a contract reset is needed or the contract needs to be 
1376         deactivated. Thus returns every fund deposited to it's respective owner.
1377     */
1378     function reset() public onlyOwnerOrAllowed {
1379         for(uint i = 0; i < users.length; i++){
1380             withdraw(users[i],balanceUsers[users[i]]);
1381         }
1382     }
1383     /**
1384     @notice Transfers all funds of the contract to a single address
1385      
1386         This function is used for finance contract upgrades in order to be more cost efficient.
1387     @param _destination Address receiving the funds
1388      */
1389     function transferAllFunds(address _destination) public onlyAllowed {
1390         uint256 balance = appc.balanceOf(address(this));
1391         appc.transfer(_destination,balance);
1392     }
1393 
1394       /**
1395     @notice Get balance of coins stored in the contract by a specific user
1396      
1397         This function can only be called by the Advertisement contract
1398     @param _user Developer's address
1399     @return { '_balance' : 'Balance of coins deposited in the contract by the address' }
1400     */
1401     function getUserBalance(address _user) public view onlyAllowed returns(uint256 _balance){
1402         return balanceUsers[_user];
1403     }
1404 
1405     /**
1406     @notice Get list of users with coins stored in the contract 
1407      
1408         This function can only be called by the Advertisement contract        
1409     @return { '_userList' : ' List of users registered in the contract'}
1410     */
1411     function getUserList() public view onlyAllowed returns(address[] _userList){
1412         return users;
1413     }
1414 }
1415 
1416 /**
1417 @title Advertisement Finance contract
1418 @author App Store Foundation
1419   The Advertisement Finance contract works as part of the user aquisition flow of the
1420 Advertisemnt contract. This contract is responsible for storing all the amount of AppCoins destined
1421 to user aquisition campaigns.
1422 */
1423 contract ExtendedFinance is BaseFinance {
1424 
1425     mapping ( address => uint256 ) public rewardedBalance;
1426 
1427     constructor(address _appc) public BaseFinance(_appc){
1428 
1429     }
1430 
1431 
1432     function pay(address _user, address _destination, uint256 _value)
1433         public onlyAllowed{
1434 
1435         require(balanceUsers[_user] >= _value);
1436 
1437         balanceUsers[_user] = SafeMath.sub(balanceUsers[_user], _value);
1438         rewardedBalance[_destination] = SafeMath.add(rewardedBalance[_destination],_value);
1439     }
1440 
1441 
1442     function withdraw(address _user, uint256 _value) public onlyOwnerOrAllowed {
1443 
1444         require(balanceUsers[_user] >= _value);
1445 
1446         balanceUsers[_user] = SafeMath.sub(balanceUsers[_user], _value);
1447         appc.transfer(_user, _value);
1448 
1449     }
1450 
1451     /**
1452     @notice Withdraws user's rewards
1453      
1454         Function to transfer a certain user's rewards to his address 
1455     @param _user Address who's rewards will be withdrawn
1456     @param _value Value of the withdraws which will be transfered to the user 
1457     */
1458     function withdrawRewards(address _user, uint256 _value) public onlyOwnerOrAllowed {
1459         require(rewardedBalance[_user] >= _value);
1460 
1461         rewardedBalance[_user] = SafeMath.sub(rewardedBalance[_user],_value);
1462         appc.transfer(_user, _value);
1463     }
1464     /**
1465     @notice Get user's rewards balance
1466      
1467         Function returning a user's rewards balance not yet withdrawn
1468     @param _user Address of the user
1469     @return { "_balance" : "Rewards balance of the user" }
1470     */
1471     function getRewardsBalance(address _user) public onlyOwnerOrAllowed returns (uint256 _balance) {
1472         return rewardedBalance[_user];
1473     }
1474 
1475 }
1476 
1477 /**
1478 @title Base Advertisement contract
1479 @author App Store Foundation
1480   Abstract contract for user aquisition campaign contracts.
1481  */
1482 contract BaseAdvertisement is StorageUser,Ownable {
1483     
1484     AppCoins public appc;
1485     BaseFinance public advertisementFinance;
1486     BaseAdvertisementStorage public advertisementStorage;
1487 
1488     mapping( bytes32 => mapping(address => uint256)) public userAttributions;
1489 
1490     bytes32[] public bidIdList;
1491     bytes32 public lastBidId = 0x0;
1492 
1493 
1494     /**
1495     @notice Constructor function
1496      
1497         Initializes contract with default validation rules
1498     @param _addrAppc Address of the AppCoins (ERC-20) contract
1499     @param _addrAdverStorage Address of the Advertisement Storage contract to be used
1500     @param _addrAdverFinance Address of the Advertisement Finance contract to be used
1501     */
1502     constructor(address _addrAppc, address _addrAdverStorage, address _addrAdverFinance) public {
1503         appc = AppCoins(_addrAppc);
1504 
1505         advertisementStorage = BaseAdvertisementStorage(_addrAdverStorage);
1506         advertisementFinance = BaseFinance(_addrAdverFinance);
1507         lastBidId = advertisementStorage.getLastBidId();
1508     }
1509 
1510 
1511 
1512     /**
1513     @notice Import existing bidIds
1514      
1515         Method to import existing BidId list from an existing BaseAdvertisement contract
1516         Be careful, this function does not chcek for duplicates.
1517     @param _addrAdvert Address of the existing Advertisement contract from which the bidIds
1518      will be imported  
1519     */
1520 
1521     function importBidIds(address _addrAdvert) public onlyOwner("importBidIds") {
1522 
1523         bytes32[] memory _bidIdsToImport = BaseAdvertisement(_addrAdvert).getBidIdList();
1524         bytes32 _lastStorageBidId = advertisementStorage.getLastBidId();
1525 
1526         for (uint i = 0; i < _bidIdsToImport.length; i++) {
1527             bidIdList.push(_bidIdsToImport[i]);
1528         }
1529         
1530         if(lastBidId < _lastStorageBidId) {
1531             lastBidId = _lastStorageBidId;
1532         }
1533     }
1534 
1535     /**
1536     @notice Upgrade finance contract used by this contract
1537      
1538         This function is part of the upgrade mechanism avaliable to the advertisement contracts.
1539         Using this function it is possible to update to a new Advertisement Finance contract without
1540         the need to cancel avaliable campaigns.
1541         Upgrade finance function can only be called by the Advertisement contract owner.
1542     @param addrAdverFinance Address of the new Advertisement Finance contract
1543     */
1544     function upgradeFinance (address addrAdverFinance) public onlyOwner("upgradeFinance") {
1545         BaseFinance newAdvFinance = BaseFinance(addrAdverFinance);
1546 
1547         address[] memory devList = advertisementFinance.getUserList();
1548         
1549         for(uint i = 0; i < devList.length; i++){
1550             uint balance = advertisementFinance.getUserBalance(devList[i]);
1551             newAdvFinance.increaseBalance(devList[i],balance);
1552         }
1553         
1554         uint256 initBalance = appc.balanceOf(address(advertisementFinance));
1555         advertisementFinance.transferAllFunds(address(newAdvFinance));
1556         uint256 oldBalance = appc.balanceOf(address(advertisementFinance));
1557         uint256 newBalance = appc.balanceOf(address(newAdvFinance));
1558         
1559         require(initBalance == newBalance);
1560         require(oldBalance == 0);
1561         advertisementFinance = newAdvFinance;
1562     }
1563 
1564     /**
1565     @notice Upgrade storage contract used by this contract
1566      
1567         Upgrades Advertisement Storage contract addres with no need to redeploy
1568         Advertisement contract. However every campaign in the old contract will
1569         be canceled.
1570         This function can only be called by the Advertisement contract owner.
1571     @param addrAdverStorage Address of the new Advertisement Storage contract
1572     */
1573 
1574     function upgradeStorage (address addrAdverStorage) public onlyOwner("upgradeStorage") {
1575         for(uint i = 0; i < bidIdList.length; i++) {
1576             cancelCampaign(bidIdList[i]);
1577         }
1578         delete bidIdList;
1579 
1580         lastBidId = advertisementStorage.getLastBidId();
1581         advertisementFinance.setAdsStorageAddress(addrAdverStorage);
1582         advertisementStorage = BaseAdvertisementStorage(addrAdverStorage);
1583     }
1584 
1585     /**
1586     @notice Get Advertisement Storage Address used by this contract
1587      
1588         This function is required to upgrade Advertisement contract address on Advertisement
1589         Finance contract.
1590     @return {
1591         "_storage" : "Address of the Advertisement Storage contract used by this contract"
1592         }
1593     */
1594 
1595     function getStorageAddress() external view returns(address _storage) {
1596 
1597         return advertisementStorage;
1598     }
1599 
1600 
1601     /**
1602     @notice Creates a campaign 
1603       
1604         Method to create a campaign of user aquisition for a certain application.
1605         This method will emit a Campaign Information event with every information 
1606         provided in the arguments of this method.
1607     @param packageName Package name of the appication subject to the user aquisition campaign
1608     @param countries Encoded list of 3 integers intended to include every 
1609     county where this campaign will be avaliable.
1610     For more detain on this encoding refer to wiki documentation.
1611     @param vercodes List of version codes to which the user aquisition campaign is applied.
1612     @param price Value (in wei) the campaign owner pays for each proof-of-attention.
1613     @param budget Total budget (in wei) the campaign owner will deposit 
1614     to pay for the proof-of-attention.
1615     @param startDate Date (in miliseconds) on which the campaign will start to be 
1616     avaliable to users.
1617     @param endDate Date (in miliseconds) on which the campaign will no longer be avaliable to users.
1618     */
1619 
1620     function _generateCampaign (
1621         string packageName,
1622         uint[3] countries,
1623         uint[] vercodes,
1624         uint price,
1625         uint budget,
1626         uint startDate,
1627         uint endDate)
1628         internal returns (CampaignLibrary.Campaign memory) {
1629 
1630         require(budget >= price);
1631         require(endDate >= startDate);
1632 
1633 
1634         //Transfers the budget to contract address
1635         if(appc.allowance(msg.sender, address(this)) >= budget){
1636             appc.transferFrom(msg.sender, address(advertisementFinance), budget);
1637 
1638             advertisementFinance.increaseBalance(msg.sender,budget);
1639 
1640             uint newBidId = bytesToUint(lastBidId);
1641             lastBidId = uintToBytes(++newBidId);
1642             
1643 
1644             CampaignLibrary.Campaign memory newCampaign;
1645             newCampaign.price = price;
1646             newCampaign.startDate = startDate;
1647             newCampaign.endDate = endDate;
1648             newCampaign.budget = budget;
1649             newCampaign.owner = msg.sender;
1650             newCampaign.valid = true;
1651             newCampaign.bidId = lastBidId;
1652         } else {
1653             emit Error("createCampaign","Not enough allowance");
1654         }
1655         
1656         return newCampaign;
1657     }
1658 
1659     function _getStorage() internal returns (BaseAdvertisementStorage) {
1660         return advertisementStorage;
1661     }
1662 
1663     function _getFinance() internal returns (BaseFinance) {
1664         return advertisementFinance;
1665     }
1666 
1667     function _setUserAttribution(bytes32 _bidId,address _user,uint256 _attributions) internal{
1668         userAttributions[_bidId][_user] = _attributions;
1669     }
1670 
1671 
1672     function getUserAttribution(bytes32 _bidId,address _user) internal returns (uint256) {
1673         return userAttributions[_bidId][_user];
1674     }
1675 
1676     /**
1677     @notice Cancel a campaign and give the remaining budget to the campaign owner
1678      
1679         When a campaing owner wants to cancel a campaign, the campaign owner needs
1680         to call this function. This function can only be called either by the campaign owner or by
1681         the Advertisement contract owner. This function results in campaign cancelation and
1682         retreival of the remaining budget to the respective campaign owner.
1683     @param bidId Campaign id to which the cancelation referes to
1684      */
1685     function cancelCampaign (bytes32 bidId) public {
1686         address campaignOwner = getOwnerOfCampaign(bidId);
1687 
1688 		// Only contract owner or campaign owner can cancel a campaign
1689         require(owner == msg.sender || campaignOwner == msg.sender);
1690         uint budget = getBudgetOfCampaign(bidId);
1691 
1692         advertisementFinance.withdraw(campaignOwner, budget);
1693 
1694         advertisementStorage.setCampaignBudgetById(bidId, 0);
1695         advertisementStorage.setCampaignValidById(bidId, false);
1696     }
1697 
1698      /**
1699     @notice Get a campaign validity state
1700     @param bidId Campaign id to which the query refers
1701     @return { "state" : "Validity of the campaign"}
1702     */
1703     function getCampaignValidity(bytes32 bidId) public view returns(bool state){
1704         return advertisementStorage.getCampaignValidById(bidId);
1705     }
1706 
1707     /**
1708     @notice Get the price of a campaign
1709      
1710         Based on the Campaign id return the value paid for each proof of attention registered.
1711     @param bidId Campaign id to which the query refers
1712     @return { "price" : "Reward (in wei) for each proof of attention registered"}
1713     */
1714     function getPriceOfCampaign (bytes32 bidId) public view returns(uint price) {
1715         return advertisementStorage.getCampaignPriceById(bidId);
1716     }
1717 
1718     /**
1719     @notice Get the start date of a campaign
1720      
1721         Based on the Campaign id return the value (in miliseconds) corresponding to the start Date
1722         of the campaign.
1723     @param bidId Campaign id to which the query refers
1724     @return { "startDate" : "Start date (in miliseconds) of the campaign"}
1725     */
1726     function getStartDateOfCampaign (bytes32 bidId) public view returns(uint startDate) {
1727         return advertisementStorage.getCampaignStartDateById(bidId);
1728     }
1729 
1730     /**
1731     @notice Get the end date of a campaign
1732      
1733         Based on the Campaign id return the value (in miliseconds) corresponding to the end Date
1734         of the campaign.
1735     @param bidId Campaign id to which the query refers
1736     @return { "endDate" : "End date (in miliseconds) of the campaign"}
1737     */
1738     function getEndDateOfCampaign (bytes32 bidId) public view returns(uint endDate) {
1739         return advertisementStorage.getCampaignEndDateById(bidId);
1740     }
1741 
1742     /**
1743     @notice Get the budget avaliable of a campaign
1744      
1745         Based on the Campaign id return the total value avaliable to pay for proofs of attention.
1746     @param bidId Campaign id to which the query refers
1747     @return { "budget" : "Total value (in wei) spendable in proof of attention rewards"}
1748     */
1749     function getBudgetOfCampaign (bytes32 bidId) public view returns(uint budget) {
1750         return advertisementStorage.getCampaignBudgetById(bidId);
1751     }
1752 
1753 
1754     /**
1755     @notice Get the owner of a campaign
1756      
1757         Based on the Campaign id return the address of the campaign owner
1758     @param bidId Campaign id to which the query refers
1759     @return { "campaignOwner" : "Address of the campaign owner" }
1760     */
1761     function getOwnerOfCampaign (bytes32 bidId) public view returns(address campaignOwner) {
1762         return advertisementStorage.getCampaignOwnerById(bidId);
1763     }
1764 
1765     /**
1766     @notice Get the list of Campaign BidIds registered in the contract
1767      
1768         Returns the list of BidIds of the campaigns ever registered in the contract
1769     @return { "bidIds" : "List of BidIds registered in the contract" }
1770     */
1771     function getBidIdList() public view returns(bytes32[] bidIds) {
1772         return bidIdList;
1773     }
1774 
1775     function _getBidIdList() internal returns(bytes32[] storage bidIds){
1776         return bidIdList;
1777     }
1778 
1779     /**
1780     @notice Check if a certain campaign is still valid
1781      
1782         Returns a boolean representing the validity of the campaign
1783         Has value of True if the campaign is still valid else has value of False
1784     @param bidId Campaign id to which the query refers
1785     @return { "valid" : "validity of the campaign" }
1786     */
1787     function isCampaignValid(bytes32 bidId) public view returns(bool valid) {
1788         uint startDate = advertisementStorage.getCampaignStartDateById(bidId);
1789         uint endDate = advertisementStorage.getCampaignEndDateById(bidId);
1790         bool validity = advertisementStorage.getCampaignValidById(bidId);
1791 
1792         uint nowInMilliseconds = now * 1000;
1793         return validity && startDate < nowInMilliseconds && endDate > nowInMilliseconds;
1794     }
1795 
1796     /**
1797     @notice Converts a uint256 type variable to a byte32 type variable
1798      
1799         Mostly used internaly
1800     @param i number to be converted
1801     @return { "b" : "Input number converted to bytes"}
1802     */
1803     function uintToBytes (uint256 i) public view returns(bytes32 b) {
1804         b = bytes32(i);
1805     }
1806 
1807     function bytesToUint(bytes32 b) public view returns (uint) 
1808     {
1809         return uint(b) & 0xfff;
1810     }
1811 
1812 }
1813 
1814 contract ExtendedAdvertisement is BaseAdvertisement, Whitelist {
1815 
1816     event BulkPoARegistered(bytes32 _bidId, bytes _rootHash, bytes _signature, uint256 _newHashes, uint256 _effectiveConversions);
1817     event SinglePoARegistered(bytes32 _bidId, bytes _timestampAndHash, bytes _signature);
1818     event CampaignInformation
1819         (
1820             bytes32 bidId,
1821             address  owner,
1822             string ipValidator,
1823             string packageName,
1824             uint[3] countries,
1825             uint[] vercodes
1826     );
1827     event ExtendedCampaignInfo
1828         (
1829             bytes32 bidId,
1830             string endPoint
1831     );
1832 
1833     constructor(address _addrAppc, address _addrAdverStorage, address _addrAdverFinance) public
1834         BaseAdvertisement(_addrAppc,_addrAdverStorage,_addrAdverFinance) {
1835         addAddressToWhitelist(msg.sender);
1836     }
1837 
1838 
1839     /**
1840     @notice Creates an extebded campaign
1841      
1842         Method to create an extended campaign of user aquisition for a certain application.
1843         This method will emit a Campaign Information event with every information
1844         provided in the arguments of this method.
1845     @param packageName Package name of the appication subject to the user aquisition campaign
1846     @param countries Encoded list of 3 integers intended to include every
1847     county where this campaign will be avaliable.
1848     For more detain on this encoding refer to wiki documentation.
1849     @param vercodes List of version codes to which the user aquisition campaign is applied.
1850     @param price Value (in wei) the campaign owner pays for each proof-of-attention.
1851     @param budget Total budget (in wei) the campaign owner will deposit
1852     to pay for the proof-of-attention.
1853     @param startDate Date (in miliseconds) on which the campaign will start to be
1854     avaliable to users.
1855     @param endDate Date (in miliseconds) on which the campaign will no longer be avaliable to users.
1856     @param endPoint URL of the signing serivce
1857     */
1858     function createCampaign (
1859         string packageName,
1860         uint[3] countries,
1861         uint[] vercodes,
1862         uint price,
1863         uint budget,
1864         uint startDate,
1865         uint endDate,
1866         string endPoint)
1867         external
1868         {
1869 
1870         CampaignLibrary.Campaign memory newCampaign = _generateCampaign(packageName, countries, vercodes, price, budget, startDate, endDate);
1871 
1872         if(newCampaign.owner == 0x0){
1873             // campaign was not generated correctly (revert)
1874             return;
1875         }
1876 
1877         _getBidIdList().push(newCampaign.bidId);
1878 
1879         ExtendedAdvertisementStorage(address(_getStorage())).setCampaign(
1880             newCampaign.bidId,
1881             newCampaign.price,
1882             newCampaign.budget,
1883             newCampaign.startDate,
1884             newCampaign.endDate,
1885             newCampaign.valid,
1886             newCampaign.owner,
1887             endPoint);
1888 
1889         emit CampaignInformation(
1890             newCampaign.bidId,
1891             newCampaign.owner,
1892             "", // ipValidator field
1893             packageName,
1894             countries,
1895             vercodes);
1896 
1897         emit ExtendedCampaignInfo(newCampaign.bidId, endPoint);
1898     }
1899 
1900     /**
1901     @notice Function to submit in bulk PoAs
1902      
1903         This function can only be called by whitelisted addresses and provides a cost efficient
1904         method to submit a batch of validates PoAs at once. This function emits a PoaRegistered
1905         event containing the campaign id, root hash, signed root hash, number of new hashes since
1906         the last submission and the effective number of conversions.
1907 
1908     @param _bidId Campaign id for which the Proof of attention root hash refferes to
1909     @param _rootHash Root hash of all submitted proof of attention to a given campaign
1910     @param _signature Root hash signed by the signing service of the campaign
1911     @param _newHashes Number of new proof of attention hashes since last submission
1912     */
1913     function bulkRegisterPoA(bytes32 _bidId, bytes _rootHash, bytes _signature, uint256 _newHashes)
1914         public
1915         onlyIfWhitelisted("createCampaign", msg.sender)
1916         {
1917 
1918         uint price = _getStorage().getCampaignPriceById(_bidId);
1919         uint budget = _getStorage().getCampaignBudgetById(_bidId);
1920         address owner = _getStorage().getCampaignOwnerById(_bidId);
1921         uint maxConversions = SafeMath.div(budget,price);
1922         uint effectiveConversions;
1923         uint totalPay;
1924         uint newBudget;
1925 
1926         if (maxConversions >= _newHashes){
1927             effectiveConversions = _newHashes;
1928         } else {
1929             effectiveConversions = maxConversions;
1930         }
1931 
1932         totalPay = SafeMath.mul(price,effectiveConversions);
1933         
1934         newBudget = SafeMath.sub(budget,totalPay);
1935 
1936         _getFinance().pay(owner, msg.sender, totalPay);
1937         _getStorage().setCampaignBudgetById(_bidId, newBudget);
1938 
1939         if(newBudget < price){
1940             _getStorage().setCampaignValidById(_bidId, false);
1941         }
1942 
1943         emit BulkPoARegistered(_bidId, _rootHash, _signature, _newHashes, effectiveConversions);
1944     }
1945 
1946     /**
1947     @notice Function to withdraw PoA convertions
1948      
1949         This function is restricted to addresses allowed to submit bulk PoAs and enable those
1950         addresses to withdraw funds previously collected by bulk PoA submissions
1951     */
1952 
1953     function withdraw()
1954         public
1955         onlyIfWhitelisted("withdraw",msg.sender)
1956         {
1957         uint256 balance = ExtendedFinance(address(_getFinance())).getRewardsBalance(msg.sender);
1958         ExtendedFinance(address(_getFinance())).withdrawRewards(msg.sender,balance);
1959     }
1960     /**
1961     @notice Get user's balance of funds obtainded by rewards
1962      
1963         Anyone can call this function and get the rewards balance of a certain user.
1964     @param _user Address from which the balance refers to
1965     @return { "_balance" : "" } */
1966     function getRewardsBalance(address _user) public view returns (uint256 _balance) {
1967         return ExtendedFinance(address(_getFinance())).getRewardsBalance(_user);
1968     }
1969 
1970     /**
1971     @notice Returns the signing Endpoint of a camapign
1972      
1973         Function returning the Webservice URL responsible for validating and signing a PoA
1974     @param bidId Campaign id to which the Endpoint is associated
1975     @return { "url" : "Validation and signature endpoint"}
1976     */
1977 
1978     function getEndPointOfCampaign (bytes32 bidId) public view returns (string url){
1979         return ExtendedAdvertisementStorage(address(_getStorage())).getCampaignEndPointById(bidId);
1980     }
1981 }