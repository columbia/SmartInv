1 pragma solidity ^0.4.24;
2 
3 
4 //Swap interface- descriptions can be found in TokenToTokenSwap.sol
5 interface TokenToTokenSwap_Interface {
6   function createSwap(uint _amount, address _senderAdd) external;
7 }
8 
9 //Swap Deployer functions - descriptions can be found in Deployer.sol
10 interface Deployer_Interface {
11   function newContract(address _party, address user_contract, uint _start_date) external payable returns (address);
12 }
13 
14 
15 //Swap factory functions - descriptions can be found in Factory.sol
16 interface Factory_Interface {
17   function createToken(uint _supply, address _party, uint _start_date) external returns (address,address, uint);
18   function payToken(address _party, address _token_add) external;
19   function deployContract(uint _start_date) external payable returns (address);
20    function getBase() external view returns(address);
21   function getVariables() external view returns (address, uint, uint, address,uint);
22   function isWhitelisted(address _member) external view returns (bool);
23 }
24 
25 
26 /**
27 *The DRCTLibrary contains the reference code used in the DRCT_Token (an ERC20 compliant token
28 *representing the payout of the swap contract specified in the Factory contract).
29 */
30 library DRCTLibrary{
31 
32     using SafeMath for uint256;
33 
34     /*Structs*/
35     /**
36     *@dev Keeps track of balance amounts in the balances array
37     */
38     struct Balance {
39         address owner;
40         uint amount;
41         }
42 
43     struct TokenStorage{
44         //This is the factory contract that the token is standardized at
45         address factory_contract;
46         //Total supply of outstanding tokens in the contract
47         uint total_supply;
48         //Mapping from: swap address -> user balance struct (index for a particular user's balance can be found in swap_balances_index)
49         mapping(address => Balance[]) swap_balances;
50         //Mapping from: swap address -> user -> swap_balances index
51         mapping(address => mapping(address => uint)) swap_balances_index;
52         //Mapping from: user -> dynamic array of swap addresses (index for a particular swap can be found in user_swaps_index)
53         mapping(address => address[]) user_swaps;
54         //Mapping from: user -> swap address -> user_swaps index
55         mapping(address => mapping(address => uint)) user_swaps_index;
56         //Mapping from: user -> total balance accross all entered swaps
57         mapping(address => uint) user_total_balances;
58         //Mapping from: owner -> spender -> amount allowed
59         mapping(address => mapping(address => uint)) allowed;
60     }   
61 
62     /*Events*/
63     /**
64     *@dev events for transfer and approvals
65     */
66     event Transfer(address indexed _from, address indexed _to, uint _value);
67     event Approval(address indexed _owner, address indexed _spender, uint _value);
68     event CreateToken(address _from, uint _value);
69     
70     /*Functions*/
71     /**
72     *@dev Constructor - sets values for token name and token supply, as well as the 
73     *factory_contract, the swap.
74     *@param _factory 
75     */
76     function startToken(TokenStorage storage self,address _factory) public {
77         self.factory_contract = _factory;
78     }
79 
80     /**
81     *@dev ensures the member is whitelisted
82     *@param _member is the member address that is chekced agaist the whitelist
83     */
84     function isWhitelisted(TokenStorage storage self,address _member) internal view returns(bool){
85         Factory_Interface _factory = Factory_Interface(self.factory_contract);
86         return _factory.isWhitelisted(_member);
87     }
88 
89     /**
90     *@dev gets the factory address
91     */
92     function getFactoryAddress(TokenStorage storage self) external view returns(address){
93         return self.factory_contract;
94     }
95 
96     /**
97     *@dev Token Creator - This function is called by the factory contract and creates new tokens
98     *for the user
99     *@param _supply amount of DRCT tokens created by the factory contract for this swap
100     *@param _owner address
101     *@param _swap address
102     */
103     function createToken(TokenStorage storage self,uint _supply, address _owner, address _swap) public{
104         require(msg.sender == self.factory_contract);
105         //Update total supply of DRCT Tokens
106         self.total_supply = self.total_supply.add(_supply);
107         //Update the total balance of the owner
108         self.user_total_balances[_owner] = self.user_total_balances[_owner].add(_supply);
109         //If the user has not entered any swaps already, push a zeroed address to their user_swaps mapping to prevent default value conflicts in user_swaps_index
110         if (self.user_swaps[_owner].length == 0)
111             self.user_swaps[_owner].push(address(0x0));
112         //Add a new swap index for the owner
113         self.user_swaps_index[_owner][_swap] = self.user_swaps[_owner].length;
114         //Push a new swap address to the owner's swaps
115         self.user_swaps[_owner].push(_swap);
116         //Push a zeroed Balance struct to the swap balances mapping to prevent default value conflicts in swap_balances_index
117         self.swap_balances[_swap].push(Balance({
118             owner: 0,
119             amount: 0
120         }));
121         //Add a new owner balance index for the swap
122         self.swap_balances_index[_swap][_owner] = 1;
123         //Push the owner's balance to the swap
124         self.swap_balances[_swap].push(Balance({
125             owner: _owner,
126             amount: _supply
127         }));
128         emit CreateToken(_owner,_supply);
129     }
130 
131     /**
132     *@dev Called by the factory contract, and pays out to a _party
133     *@param _party being paid
134     *@param _swap address
135     */
136     function pay(TokenStorage storage self,address _party, address _swap) public{
137         require(msg.sender == self.factory_contract);
138         uint party_balance_index = self.swap_balances_index[_swap][_party];
139         require(party_balance_index > 0);
140         uint party_swap_balance = self.swap_balances[_swap][party_balance_index].amount;
141         //reduces the users totals balance by the amount in that swap
142         self.user_total_balances[_party] = self.user_total_balances[_party].sub(party_swap_balance);
143         //reduces the total supply by the amount of that users in that swap
144         self.total_supply = self.total_supply.sub(party_swap_balance);
145         //sets the partys balance to zero for that specific swaps party balances
146         self.swap_balances[_swap][party_balance_index].amount = 0;
147     }
148 
149     /**
150     *@dev Returns the users total balance (sum of tokens in all swaps the user has tokens in)
151     *@param _owner user address
152     *@return user total balance
153     */
154     function balanceOf(TokenStorage storage self,address _owner) public constant returns (uint balance) {
155        return self.user_total_balances[_owner]; 
156      }
157 
158     /**
159     *@dev Getter for the total_supply of tokens in the contract
160     *@return total supply
161     */
162     function totalSupply(TokenStorage storage self) public constant returns (uint _total_supply) {
163        return self.total_supply;
164     }
165 
166     /**
167     *@dev Removes the address from the swap balances for a swap, and moves the last address in the
168     *swap into their place
169     *@param _remove address of prevous owner
170     *@param _swap address used to get last addrss of the swap to replace the removed address
171     */
172     function removeFromSwapBalances(TokenStorage storage self,address _remove, address _swap) internal {
173         uint last_address_index = self.swap_balances[_swap].length.sub(1);
174         address last_address = self.swap_balances[_swap][last_address_index].owner;
175         //If the address we want to remove is the final address in the swap
176         if (last_address != _remove) {
177             uint remove_index = self.swap_balances_index[_swap][_remove];
178             //Update the swap's balance index of the last address to that of the removed address index
179             self.swap_balances_index[_swap][last_address] = remove_index;
180             //Set the swap's Balance struct at the removed index to the Balance struct of the last address
181             self.swap_balances[_swap][remove_index] = self.swap_balances[_swap][last_address_index];
182         }
183         //Remove the swap_balances index for this address
184         delete self.swap_balances_index[_swap][_remove];
185         //Finally, decrement the swap balances length
186         self.swap_balances[_swap].length = self.swap_balances[_swap].length.sub(1);
187     }
188 
189     /**
190     *@dev This is the main function to update the mappings when a transfer happens
191     *@param _from address to send funds from
192     *@param _to address to send funds to
193     *@param _amount amount of token to send
194     */
195     function transferHelper(TokenStorage storage self,address _from, address _to, uint _amount) internal {
196         //Get memory copies of the swap arrays for the sender and reciever
197         address[] memory from_swaps = self.user_swaps[_from];
198         //Iterate over sender's swaps in reverse order until enough tokens have been transferred
199         for (uint i = from_swaps.length.sub(1); i > 0; i--) {
200             //Get the index of the sender's balance for the current swap
201             uint from_swap_user_index = self.swap_balances_index[from_swaps[i]][_from];
202             Balance memory from_user_bal = self.swap_balances[from_swaps[i]][from_swap_user_index];
203             //If the current swap will be entirely depleted - we remove all references to it for the sender
204             if (_amount >= from_user_bal.amount) {
205                 _amount -= from_user_bal.amount;
206                 //If this swap is to be removed, we know it is the (current) last swap in the user's user_swaps list, so we can simply decrement the length to remove it
207                 self.user_swaps[_from].length = self.user_swaps[_from].length.sub(1);
208                 //Remove the user swap index for this swap
209                 delete self.user_swaps_index[_from][from_swaps[i]];
210                 //If the _to address already holds tokens from this swap
211                 if (self.user_swaps_index[_to][from_swaps[i]] != 0) {
212                     //Get the index of the _to balance in this swap
213                     uint to_balance_index = self.swap_balances_index[from_swaps[i]][_to];
214                     assert(to_balance_index != 0);
215                     //Add the _from tokens to _to
216                     self.swap_balances[from_swaps[i]][to_balance_index].amount = self.swap_balances[from_swaps[i]][to_balance_index].amount.add(from_user_bal.amount);
217                     //Remove the _from address from this swap's balance array
218                     removeFromSwapBalances(self,_from, from_swaps[i]);
219                 } else {
220                     //Prepare to add a new swap by assigning the swap an index for _to
221                     if (self.user_swaps[_to].length == 0){
222                         self.user_swaps[_to].push(address(0x0));
223                     }
224                 self.user_swaps_index[_to][from_swaps[i]] = self.user_swaps[_to].length;
225                 //Add the new swap to _to
226                 self.user_swaps[_to].push(from_swaps[i]);
227                 //Give the reciever the sender's balance for this swap
228                 self.swap_balances[from_swaps[i]][from_swap_user_index].owner = _to;
229                 //Give the reciever the sender's swap balance index for this swap
230                 self.swap_balances_index[from_swaps[i]][_to] = self.swap_balances_index[from_swaps[i]][_from];
231                 //Remove the swap balance index from the sending party
232                 delete self.swap_balances_index[from_swaps[i]][_from];
233             }
234             //If there is no more remaining to be removed, we break out of the loop
235             if (_amount == 0)
236                 break;
237             } else {
238                 //The amount in this swap is more than the amount we still need to transfer
239                 uint to_swap_balance_index = self.swap_balances_index[from_swaps[i]][_to];
240                 //If the _to address already holds tokens from this swap
241                 if (self.user_swaps_index[_to][from_swaps[i]] != 0) {
242                     //Because both addresses are in this swap, and neither will be removed, we simply update both swap balances
243                     self.swap_balances[from_swaps[i]][to_swap_balance_index].amount = self.swap_balances[from_swaps[i]][to_swap_balance_index].amount.add(_amount);
244                 } else {
245                     //Prepare to add a new swap by assigning the swap an index for _to
246                     if (self.user_swaps[_to].length == 0){
247                         self.user_swaps[_to].push(address(0x0));
248                     }
249                     self.user_swaps_index[_to][from_swaps[i]] = self.user_swaps[_to].length;
250                     //And push the new swap
251                     self.user_swaps[_to].push(from_swaps[i]);
252                     //_to is not in this swap, so we give this swap a new balance index for _to
253                     self.swap_balances_index[from_swaps[i]][_to] = self.swap_balances[from_swaps[i]].length;
254                     //And push a new balance for _to
255                     self.swap_balances[from_swaps[i]].push(Balance({
256                         owner: _to,
257                         amount: _amount
258                     }));
259                 }
260                 //Finally, update the _from user's swap balance
261                 self.swap_balances[from_swaps[i]][from_swap_user_index].amount = self.swap_balances[from_swaps[i]][from_swap_user_index].amount.sub(_amount);
262                 //Because we have transferred the last of the amount to the reciever, we break;
263                 break;
264             }
265         }
266     }
267 
268     /**
269     *@dev ERC20 compliant transfer function
270     *@param _to Address to send funds to
271     *@param _amount Amount of token to send
272     *@return true for successful
273     */
274     function transfer(TokenStorage storage self, address _to, uint _amount) public returns (bool) {
275         require(isWhitelisted(self,_to));
276         uint balance_owner = self.user_total_balances[msg.sender];
277         if (
278             _to == msg.sender ||
279             _to == address(0) ||
280             _amount == 0 ||
281             balance_owner < _amount
282         ) return false;
283         transferHelper(self,msg.sender, _to, _amount);
284         self.user_total_balances[msg.sender] = self.user_total_balances[msg.sender].sub(_amount);
285         self.user_total_balances[_to] = self.user_total_balances[_to].add(_amount);
286         emit Transfer(msg.sender, _to, _amount);
287         return true;
288     }
289     /**
290     *@dev ERC20 compliant transferFrom function
291     *@param _from address to send funds from (must be allowed, see approve function)
292     *@param _to address to send funds to
293     *@param _amount amount of token to send
294     *@return true for successful
295     */
296     function transferFrom(TokenStorage storage self, address _from, address _to, uint _amount) public returns (bool) {
297         require(isWhitelisted(self,_to));
298         uint balance_owner = self.user_total_balances[_from];
299         uint sender_allowed = self.allowed[_from][msg.sender];
300         if (
301             _to == _from ||
302             _to == address(0) ||
303             _amount == 0 ||
304             balance_owner < _amount ||
305             sender_allowed < _amount
306         ) return false;
307         transferHelper(self,_from, _to, _amount);
308         self.user_total_balances[_from] = self.user_total_balances[_from].sub(_amount);
309         self.user_total_balances[_to] = self.user_total_balances[_to].add(_amount);
310         self.allowed[_from][msg.sender] = self.allowed[_from][msg.sender].sub(_amount);
311         emit Transfer(_from, _to, _amount);
312         return true;
313     }
314 
315     /**
316     *@dev ERC20 compliant approve function
317     *@param _spender party that msg.sender approves for transferring funds
318     *@param _amount amount of token to approve for sending
319     *@return true for successful
320     */
321     function approve(TokenStorage storage self, address _spender, uint _amount) public returns (bool) {
322         self.allowed[msg.sender][_spender] = _amount;
323         emit Approval(msg.sender, _spender, _amount);
324         return true;
325     }
326 
327     /**
328     *@dev Counts addresses involved in the swap based on the length of balances array for _swap
329     *@param _swap address
330     *@return the length of the balances array for the swap
331     */
332     function addressCount(TokenStorage storage self, address _swap) public constant returns (uint) { 
333         return self.swap_balances[_swap].length; 
334     }
335 
336     /**
337     *@dev Gets the owner address and amount by specifying the swap address and index
338     *@param _ind specified index in the swap
339     *@param _swap specified swap address
340     *@return the owner address associated with a particular index in a particular swap
341     *@return the amount to transfer associated with a particular index in a particular swap
342     */
343     function getBalanceAndHolderByIndex(TokenStorage storage self, uint _ind, address _swap) public constant returns (uint, address) {
344         return (self.swap_balances[_swap][_ind].amount, self.swap_balances[_swap][_ind].owner);
345     }
346 
347     /**
348     *@dev Gets the index by specifying the swap and owner addresses
349     *@param _owner specifed address
350     *@param _swap  specified swap address
351     *@return the index associated with the _owner address in a particular swap
352     */
353     function getIndexByAddress(TokenStorage storage self, address _owner, address _swap) public constant returns (uint) {
354         return self.swap_balances_index[_swap][_owner]; 
355     }
356 
357     /**
358     *@dev Look up how much the spender or contract is allowed to spend?
359     *@param _owner 
360     *@param _spender party approved for transfering funds 
361     *@return the allowed amount _spender can spend of _owner's balance
362     */
363     function allowance(TokenStorage storage self, address _owner, address _spender) public constant returns (uint) {
364         return self.allowed[_owner][_spender]; 
365     }
366 }
367 
368 /**
369 *The DRCT_Token is an ERC20 compliant token representing the payout of the swap contract
370 *specified in the Factory contract.
371 *Each Factory contract is specified one DRCT Token and the token address can contain many
372 *different swap contracts that are standardized at the Factory level.
373 *The logic for the functions in this contract is housed in the DRCTLibary.sol.
374 */
375 contract DRCT_Token {
376 
377     using DRCTLibrary for DRCTLibrary.TokenStorage;
378 
379     /*Variables*/
380     DRCTLibrary.TokenStorage public drct;
381 
382     /*Functions*/
383     /**
384     *@dev Constructor - sets values for token name and token supply, as well as the 
385     *factory_contract, the swap.
386     *@param _factory 
387     */
388     constructor() public {
389         drct.startToken(msg.sender);
390     }
391 
392     /**
393     *@dev Token Creator - This function is called by the factory contract and creates new tokens
394     *for the user
395     *@param _supply amount of DRCT tokens created by the factory contract for this swap
396     *@param _owner address
397     *@param _swap address
398     */
399     function createToken(uint _supply, address _owner, address _swap) public{
400         drct.createToken(_supply,_owner,_swap);
401     }
402 
403     /**
404     *@dev gets the factory address
405     */
406     function getFactoryAddress() external view returns(address){
407         return drct.getFactoryAddress();
408     }
409 
410     /**
411     *@dev Called by the factory contract, and pays out to a _party
412     *@param _party being paid
413     *@param _swap address
414     */
415     function pay(address _party, address _swap) public{
416         drct.pay(_party,_swap);
417     }
418 
419     /**
420     *@dev Returns the users total balance (sum of tokens in all swaps the user has tokens in)
421     *@param _owner user address
422     *@return user total balance
423     */
424     function balanceOf(address _owner) public constant returns (uint balance) {
425        return drct.balanceOf(_owner);
426      }
427 
428     /**
429     *@dev Getter for the total_supply of tokens in the contract
430     *@return total supply
431     */
432     function totalSupply() public constant returns (uint _total_supply) {
433        return drct.totalSupply();
434     }
435 
436     /**
437     *ERC20 compliant transfer function
438     *@param _to Address to send funds to
439     *@param _amount Amount of token to send
440     *@return true for successful
441     */
442     function transfer(address _to, uint _amount) public returns (bool) {
443         return drct.transfer(_to,_amount);
444     }
445 
446     /**
447     *@dev ERC20 compliant transferFrom function
448     *@param _from address to send funds from (must be allowed, see approve function)
449     *@param _to address to send funds to
450     *@param _amount amount of token to send
451     *@return true for successful transfer
452     */
453     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
454         return drct.transferFrom(_from,_to,_amount);
455     }
456 
457     /**
458     *@dev ERC20 compliant approve function
459     *@param _spender party that msg.sender approves for transferring funds
460     *@param _amount amount of token to approve for sending
461     *@return true for successful
462     */
463     function approve(address _spender, uint _amount) public returns (bool) {
464         return drct.approve(_spender,_amount);
465     }
466 
467     /**
468     *@dev Counts addresses involved in the swap based on the length of balances array for _swap
469     *@param _swap address
470     *@return the length of the balances array for the swap
471     */
472     function addressCount(address _swap) public constant returns (uint) { 
473         return drct.addressCount(_swap); 
474     }
475 
476     /**
477     *@dev Gets the owner address and amount by specifying the swap address and index
478     *@param _ind specified index in the swap
479     *@param _swap specified swap address
480     *@return the amount to transfer associated with a particular index in a particular swap
481     *@return the owner address associated with a particular index in a particular swap
482     */
483     function getBalanceAndHolderByIndex(uint _ind, address _swap) public constant returns (uint, address) {
484         return drct.getBalanceAndHolderByIndex(_ind,_swap);
485     }
486 
487     /**
488     *@dev Gets the index by specifying the swap and owner addresses
489     *@param _owner specifed address
490     *@param _swap  specified swap address
491     *@return the index associated with the _owner address in a particular swap
492     */
493     function getIndexByAddress(address _owner, address _swap) public constant returns (uint) {
494         return drct.getIndexByAddress(_owner,_swap); 
495     }
496 
497     /**
498     *@dev Look up how much the spender or contract is allowed to spend?
499     *@param _owner address
500     *@param _spender party approved for transfering funds 
501     *@return the allowed amount _spender can spend of _owner's balance
502     */
503     function allowance(address _owner, address _spender) public constant returns (uint) {
504         return drct.allowance(_owner,_spender); 
505     }
506 }
507 
508 
509 
510 
511 
512 
513 //ERC20 function interface with create token and withdraw
514 interface Wrapped_Ether_Interface {
515   function totalSupply() external constant returns (uint);
516   function balanceOf(address _owner) external constant returns (uint);
517   function transfer(address _to, uint _amount) external returns (bool);
518   function transferFrom(address _from, address _to, uint _amount) external returns (bool);
519   function approve(address _spender, uint _amount) external returns (bool);
520   function allowance(address _owner, address _spender) external constant returns (uint);
521   function withdraw(uint _value) external;
522   function createToken() external;
523 
524 }
525 
526 interface Membership_Interface {
527     function getMembershipType(address _member) external constant returns(uint);
528 }
529 
530 
531 
532 /**
533 *The Factory contract sets the standardized variables and also deploys new contracts based on
534 *these variables for the user.  
535 */
536 contract Factory {
537     using SafeMath for uint256;
538     
539     /*Variables*/
540     //Addresses of the Factory owner and oracle. For oracle information, 
541     //check www.github.com/DecentralizedDerivatives/Oracles
542     address public owner;
543     address public oracle_address;
544     //Address of the user contract
545     address public user_contract;
546     //Address of the deployer contract
547     address internal deployer_address;
548     Deployer_Interface internal deployer;
549     address public token;
550     //A fee for creating a swap in wei.  Plan is for this to be zero, however can be raised to prevent spam
551     uint public fee;
552     //swap fee
553     uint public swapFee;
554     //Duration of swap contract in days
555     uint public duration;
556     //Multiplier of reference rate.  2x refers to a 50% move generating a 100% move in the contract payout values
557     uint public multiplier;
558     //Token_ratio refers to the number of DRCT Tokens a party will get based on the number of base tokens.  As an example, 1e15 indicates that a party will get 1000 DRCT Tokens based upon 1 ether of wrapped wei. 
559     uint public token_ratio;
560     //Array of deployed contracts
561     address[] public contracts;
562     uint[] public startDates;
563     address public memberContract;
564     mapping(uint => bool) whitelistedTypes;
565     mapping(address => uint) public created_contracts;
566     mapping(address => uint) public token_dates;
567     mapping(uint => address) public long_tokens;
568     mapping(uint => address) public short_tokens;
569     mapping(address => uint) public token_type; //1=short 2=long
570 
571     /*Events*/
572     //Emitted when a Swap is created
573     event ContractCreation(address _sender, address _created);
574 
575     /*Modifiers*/
576     modifier onlyOwner() {
577         require(msg.sender == owner);
578         _;
579     }
580 
581     /*Functions*/
582     /**
583     *@dev Constructor - Sets owner
584     */
585      constructor() public {
586         owner = msg.sender;
587     }
588 
589     /**
590     *@dev constructor function for cloned factory
591     */
592     function init(address _owner) public{
593         require(owner == address(0));
594         owner = _owner;
595     }
596 
597     /**
598     *@dev Sets the Membership contract address
599     *@param _memberContract The new membership address
600     */
601     function setMemberContract(address _memberContract) public onlyOwner() {
602         memberContract = _memberContract;
603     }
604 
605     /**
606     *@dev Sets the member types/permissions for those whitelisted
607     *@param _memberTypes is the list of member types
608     */
609     function setWhitelistedMemberTypes(uint[] _memberTypes) public onlyOwner(){
610         whitelistedTypes[0] = false;
611         for(uint i = 0; i<_memberTypes.length;i++){
612             whitelistedTypes[_memberTypes[i]] = true;
613         }
614     }
615 
616     /**
617     *@dev Checks the membership type/permissions for whitelisted members
618     *@param _member address to get membership type from
619     */
620     function isWhitelisted(address _member) public view returns (bool){
621         Membership_Interface Member = Membership_Interface(memberContract);
622         return whitelistedTypes[Member.getMembershipType(_member)];
623     }
624  
625     /**
626     *@dev Gets long and short token addresses based on specified date
627     *@param _date 
628     *@return short and long tokens' addresses
629     */
630     function getTokens(uint _date) public view returns(address, address){
631         return(long_tokens[_date],short_tokens[_date]);
632     }
633 
634     /**
635     *@dev Gets the type of Token (long and short token) for the specifed 
636     *token address
637     *@param _token address 
638     *@return token type short = 1 and long = 2
639     */
640     function getTokenType(address _token) public view returns(uint){
641         return(token_type[_token]);
642     }
643 
644     /**
645     *@dev Updates the fee amount
646     *@param _fee is the new fee amount
647     */
648     function setFee(uint _fee) public onlyOwner() {
649         fee = _fee;
650     }
651 
652     /**
653     *@dev Updates the swap fee amount
654     *@param _swapFee is the new swap fee amount
655     */
656     function setSwapFee(uint _swapFee) public onlyOwner() {
657         swapFee = _swapFee;
658     }   
659 
660     /**
661     *@dev Sets the deployer address
662     *@param _deployer is the new deployer address
663     */
664     function setDeployer(address _deployer) public onlyOwner() {
665         deployer_address = _deployer;
666         deployer = Deployer_Interface(_deployer);
667     }
668 
669     /**
670     *@dev Sets the user_contract address
671     *@param _userContract is the new userContract address
672     */
673     function setUserContract(address _userContract) public onlyOwner() {
674         user_contract = _userContract;
675     }
676 
677     /**
678     *@dev Sets token ratio, swap duration, and multiplier variables for a swap.
679     *@param _token_ratio the ratio of the tokens
680     *@param _duration the duration of the swap, in days
681     *@param _multiplier the multiplier used for the swap
682     *@param _swapFee the swap fee
683     */
684     function setVariables(uint _token_ratio, uint _duration, uint _multiplier, uint _swapFee) public onlyOwner() {
685         require(_swapFee < 10000);
686         token_ratio = _token_ratio;
687         duration = _duration;
688         multiplier = _multiplier;
689         swapFee = _swapFee;
690     }
691 
692     /**
693     *@dev Sets the address of the base tokens used for the swap
694     *@param _token The address of a token to be used  as collateral
695     */
696     function setBaseToken(address _token) public onlyOwner() {
697         token = _token;
698     }
699 
700     /**
701     *@dev Allows a user to deploy a new swap contract, if they pay the fee
702     *@param _start_date the contract start date 
703     *@return new_contract address for he newly created swap address and calls 
704     *event 'ContractCreation'
705     */
706     function deployContract(uint _start_date) public payable returns (address) {
707         require(msg.value >= fee && isWhitelisted(msg.sender));
708         require(_start_date % 86400 == 0);
709         address new_contract = deployer.newContract(msg.sender, user_contract, _start_date);
710         contracts.push(new_contract);
711         created_contracts[new_contract] = _start_date;
712         emit ContractCreation(msg.sender,new_contract);
713         return new_contract;
714     }
715 
716     /**
717     *@dev Deploys DRCT tokens for given start date
718     *@param _start_date of contract
719     */
720     function deployTokenContract(uint _start_date) public{
721         address _token;
722         require(_start_date % 86400 == 0);
723         require(long_tokens[_start_date] == address(0) && short_tokens[_start_date] == address(0));
724         _token = new DRCT_Token();
725         token_dates[_token] = _start_date;
726         long_tokens[_start_date] = _token;
727         token_type[_token]=2;
728         _token = new DRCT_Token();
729         token_type[_token]=1;
730         short_tokens[_start_date] = _token;
731         token_dates[_token] = _start_date;
732         startDates.push(_start_date);
733 
734     }
735 
736     /**
737     *@dev Deploys new tokens on a DRCT_Token contract -- called from within a swap
738     *@param _supply The number of tokens to create
739     *@param _party the address to send the tokens to
740     *@param _start_date the start date of the contract      
741     *@returns ltoken the address of the created DRCT long tokens
742     *@returns stoken the address of the created DRCT short tokens
743     *@returns token_ratio The ratio of the created DRCT token
744     */
745     function createToken(uint _supply, address _party, uint _start_date) public returns (address, address, uint) {
746         require(created_contracts[msg.sender] == _start_date);
747         address ltoken = long_tokens[_start_date];
748         address stoken = short_tokens[_start_date];
749         require(ltoken != address(0) && stoken != address(0));
750             DRCT_Token drct_interface = DRCT_Token(ltoken);
751             drct_interface.createToken(_supply.div(token_ratio), _party,msg.sender);
752             drct_interface = DRCT_Token(stoken);
753             drct_interface.createToken(_supply.div(token_ratio), _party,msg.sender);
754         return (ltoken, stoken, token_ratio);
755     }
756   
757     /**
758     *@dev Allows the owner to set a new oracle address
759     *@param _new_oracle_address 
760     */
761     function setOracleAddress(address _new_oracle_address) public onlyOwner() {
762         oracle_address = _new_oracle_address; 
763     }
764 
765     /**
766     *@dev Allows the owner to set a new owner address
767     *@param _new_owner the new owner address
768     */
769     function setOwner(address _new_owner) public onlyOwner() { 
770         owner = _new_owner; 
771     }
772 
773     /**
774     *@dev Allows the owner to pull contract creation fees
775     *@return the withdrawal fee _val and the balance where is the return function?
776     */
777     function withdrawFees() public onlyOwner(){
778         Wrapped_Ether_Interface token_interface = Wrapped_Ether_Interface(token);
779         uint _val = token_interface.balanceOf(address(this));
780         if(_val > 0){
781             token_interface.withdraw(_val);
782         }
783         owner.transfer(address(this).balance);
784      }
785 
786     /**
787     *@dev fallback function
788     */ 
789     function() public payable {
790     }
791 
792     /**
793     *@dev Returns a tuple of many private variables.
794     *The variables from this function are pass through to the TokenLibrary.getVariables function
795     *@returns oracle_adress is the address of the oracle
796     *@returns duration is the duration of the swap
797     *@returns multiplier is the multiplier for the swap
798     *@returns token is the address of token
799     *@returns _swapFee is the swap fee 
800     */
801     function getVariables() public view returns (address, uint, uint, address,uint){
802         return (oracle_address,duration, multiplier, token,swapFee);
803     }
804 
805     /**
806     *@dev Pays out to a DRCT token
807     *@param _party is the address being paid
808     *@param _token_add token to pay out
809     */
810     function payToken(address _party, address _token_add) public {
811         require(created_contracts[msg.sender] > 0);
812         DRCT_Token drct_interface = DRCT_Token(_token_add);
813         drct_interface.pay(_party, msg.sender);
814     }
815 
816     /**
817     *@dev Counts number of contacts created by this factory
818     *@return the number of contracts
819     */
820     function getCount() public constant returns(uint) {
821         return contracts.length;
822     }
823 
824     /**
825     *@dev Counts number of start dates in this factory
826     *@return the number of active start dates
827     */
828     function getDateCount() public constant returns(uint) {
829         return startDates.length;
830     }
831 }
832 
833 
834 /**
835 *This is the basic wrapped Ether contract. 
836 *All money deposited is transformed into ERC20 tokens at the rate of 1 wei = 1 token
837 */
838 contract Wrapped_Ether {
839 
840     using SafeMath for uint256;
841 
842     /*Variables*/
843 
844     //ERC20 fields
845     string public name = "Wrapped Ether";
846     uint public total_supply;
847     mapping(address => uint) internal balances;
848     mapping(address => mapping (address => uint)) internal allowed;
849 
850     /*Events*/
851     event Transfer(address indexed _from, address indexed _to, uint _value);
852     event Approval(address indexed _owner, address indexed _spender, uint _value);
853     event StateChanged(bool _success, string _message);
854 
855     /*Functions*/
856     /**
857     *@dev This function creates tokens equal in value to the amount sent to the contract
858     */
859     function createToken() public payable {
860         require(msg.value > 0);
861         balances[msg.sender] = balances[msg.sender].add(msg.value);
862         total_supply = total_supply.add(msg.value);
863     }
864 
865     /**
866     *@dev This function 'unwraps' an _amount of Ether in the sender's balance by transferring 
867     *Ether to them
868     *@param _value The amount of the token to unwrap
869     */
870     function withdraw(uint _value) public {
871         balances[msg.sender] = balances[msg.sender].sub(_value);
872         total_supply = total_supply.sub(_value);
873         msg.sender.transfer(_value);
874     }
875 
876     /**
877     *@param _owner is the owner address used to look up the balance
878     *@return Returns the balance associated with the passed in _owner
879     */
880     function balanceOf(address _owner) public constant returns (uint bal) { 
881         return balances[_owner]; 
882     }
883 
884     /**
885     *@dev Allows for a transfer of tokens to _to
886     *@param _to The address to send tokens to
887     *@param _amount The amount of tokens to send
888     */
889     function transfer(address _to, uint _amount) public returns (bool) {
890         if (balances[msg.sender] >= _amount
891         && _amount > 0
892         && balances[_to] + _amount > balances[_to]) {
893             balances[msg.sender] = balances[msg.sender] - _amount;
894             balances[_to] = balances[_to] + _amount;
895             emit Transfer(msg.sender, _to, _amount);
896             return true;
897         } else {
898             return false;
899         }
900     }
901 
902     /**
903     *@dev Allows an address with sufficient spending allowance to send tokens on the behalf of _from
904     *@param _from The address to send tokens from
905     *@param _to The address to send tokens to
906     *@param _amount The amount of tokens to send
907     */
908     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
909         if (balances[_from] >= _amount
910         && allowed[_from][msg.sender] >= _amount
911         && _amount > 0
912         && balances[_to] + _amount > balances[_to]) {
913             balances[_from] = balances[_from] - _amount;
914             allowed[_from][msg.sender] = allowed[_from][msg.sender] - _amount;
915             balances[_to] = balances[_to] + _amount;
916             emit Transfer(_from, _to, _amount);
917             return true;
918         } else {
919             return false;
920         }
921     }
922 
923     /**
924     *@dev This function approves a _spender an _amount of tokens to use
925     *@param _spender address
926     *@param _amount amount the spender is being approved for
927     *@return true if spender appproved successfully
928     */
929     function approve(address _spender, uint _amount) public returns (bool) {
930         allowed[msg.sender][_spender] = _amount;
931         emit Approval(msg.sender, _spender, _amount);
932         return true;
933     }
934 
935     /**
936     *@param _owner address
937     *@param _spender address
938     *@return Returns the remaining allowance of tokens granted to the _spender from the _owner
939     */
940     function allowance(address _owner, address _spender) public view returns (uint) {
941        return allowed[_owner][_spender]; }
942 
943     /**
944     *@dev Getter for the total_supply of wrapped ether
945     *@return total supply
946     */
947     function totalSupply() public constant returns (uint) {
948        return total_supply;
949     }
950 }
951 
952 
953 //Slightly modified SafeMath library - includes a min function
954 library SafeMath {
955   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
956     uint256 c = a * b;
957     assert(a == 0 || c / a == b);
958     return c;
959   }
960 
961   function div(uint256 a, uint256 b) internal pure returns (uint256) {
962     // assert(b > 0); // Solidity automatically throws when dividing by 0
963     uint256 c = a / b;
964     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
965     return c;
966   }
967 
968   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
969     assert(b <= a);
970     return a - b;
971   }
972 
973   function add(uint256 a, uint256 b) internal pure returns (uint256) {
974     uint256 c = a + b;
975     assert(c >= a);
976     return c;
977   }
978 
979   function min(uint a, uint b) internal pure returns (uint256) {
980     return a < b ? a : b;
981   }
982 }
983 
984 /**
985 *The User Contract enables the entering of a deployed swap along with the wrapping of Ether.  This
986 *contract was specifically made for drct.decentralizedderivatives.org to simplify user metamask 
987 *calls
988 */
989 contract UserContract{
990 
991     using SafeMath for uint256;
992 
993     /*Variables*/
994     TokenToTokenSwap_Interface internal swap;
995     Wrapped_Ether internal baseToken;
996     Factory internal factory; 
997     address public factory_address;
998     address internal owner;
999 
1000     /*Functions*/
1001     constructor() public {
1002         owner = msg.sender;
1003     }
1004 
1005     /**
1006     *@dev Value must be sent with Initiate and enter the _amount(in wei) 
1007     *@param _swapadd is the address of the deployed contract created from the Factory contract
1008     *@param _amount is the amount of the base tokens(short or long) in the
1009     *swap. For wrapped Ether, this is wei.
1010     */
1011     function Initiate(address _swapadd, uint _amount) payable public{
1012         require(msg.value == _amount.mul(2));
1013         swap = TokenToTokenSwap_Interface(_swapadd);
1014         address token_address = factory.token();
1015         baseToken = Wrapped_Ether(token_address);
1016         baseToken.createToken.value(_amount.mul(2))();
1017         baseToken.transfer(_swapadd,_amount.mul(2));
1018         swap.createSwap(_amount, msg.sender);
1019     }
1020 
1021     /**
1022     *@dev Set factory address 
1023     *@param _factory_address is the factory address to clone?
1024     */
1025     function setFactory(address _factory_address) public {
1026         require (msg.sender == owner);
1027         factory_address = _factory_address;
1028         factory = Factory(factory_address);
1029     }
1030 }