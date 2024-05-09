1 pragma solidity ^0.4.24;
2 
3 //Swap Deployer functions - descriptions can be found in Deployer.sol
4 interface Deployer_Interface {
5   function newContract(address _party, address user_contract, uint _start_date) external payable returns (address);
6 }
7 
8 //Slightly modified SafeMath library - includes a min function
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 
34   function min(uint a, uint b) internal pure returns (uint256) {
35     return a < b ? a : b;
36   }
37 }
38 
39 //Swap factory functions - descriptions can be found in Factory.sol
40 interface Factory_Interface {
41   function createToken(uint _supply, address _party, uint _start_date) external returns (address,address, uint);
42   function payToken(address _party, address _token_add) external;
43   function deployContract(uint _start_date) external payable returns (address);
44    function getBase() external view returns(address);
45   function getVariables() external view returns (address, uint, uint, address,uint);
46   function isWhitelisted(address _member) external view returns (bool);
47 }
48 
49 
50 /**
51 *The DRCTLibrary contains the reference code used in the DRCT_Token (an ERC20 compliant token
52 *representing the payout of the swap contract specified in the Factory contract).
53 */
54 library DRCTLibrary{
55 
56     using SafeMath for uint256;
57 
58     /*Structs*/
59     /**
60     *@dev Keeps track of balance amounts in the balances array
61     */
62     struct Balance {
63         address owner;
64         uint amount;
65         }
66 
67     struct TokenStorage{
68         //This is the factory contract that the token is standardized at
69         address factory_contract;
70         //Total supply of outstanding tokens in the contract
71         uint total_supply;
72         //Mapping from: swap address -> user balance struct (index for a particular user's balance can be found in swap_balances_index)
73         mapping(address => Balance[]) swap_balances;
74         //Mapping from: swap address -> user -> swap_balances index
75         mapping(address => mapping(address => uint)) swap_balances_index;
76         //Mapping from: user -> dynamic array of swap addresses (index for a particular swap can be found in user_swaps_index)
77         mapping(address => address[]) user_swaps;
78         //Mapping from: user -> swap address -> user_swaps index
79         mapping(address => mapping(address => uint)) user_swaps_index;
80         //Mapping from: user -> total balance accross all entered swaps
81         mapping(address => uint) user_total_balances;
82         //Mapping from: owner -> spender -> amount allowed
83         mapping(address => mapping(address => uint)) allowed;
84     }   
85 
86     /*Events*/
87     /**
88     *@dev events for transfer and approvals
89     */
90     event Transfer(address indexed _from, address indexed _to, uint _value);
91     event Approval(address indexed _owner, address indexed _spender, uint _value);
92     event CreateToken(address _from, uint _value);
93     
94     /*Functions*/
95     /**
96     *@dev Constructor - sets values for token name and token supply, as well as the 
97     *factory_contract, the swap.
98     *@param _factory 
99     */
100     function startToken(TokenStorage storage self,address _factory) public {
101         self.factory_contract = _factory;
102     }
103 
104     /**
105     *@dev ensures the member is whitelisted
106     *@param _member is the member address that is chekced agaist the whitelist
107     */
108     function isWhitelisted(TokenStorage storage self,address _member) internal view returns(bool){
109         Factory_Interface _factory = Factory_Interface(self.factory_contract);
110         return _factory.isWhitelisted(_member);
111     }
112 
113     /**
114     *@dev gets the factory address
115     */
116     function getFactoryAddress(TokenStorage storage self) external view returns(address){
117         return self.factory_contract;
118     }
119 
120     /**
121     *@dev Token Creator - This function is called by the factory contract and creates new tokens
122     *for the user
123     *@param _supply amount of DRCT tokens created by the factory contract for this swap
124     *@param _owner address
125     *@param _swap address
126     */
127     function createToken(TokenStorage storage self,uint _supply, address _owner, address _swap) public{
128         require(msg.sender == self.factory_contract);
129         //Update total supply of DRCT Tokens
130         self.total_supply = self.total_supply.add(_supply);
131         //Update the total balance of the owner
132         self.user_total_balances[_owner] = self.user_total_balances[_owner].add(_supply);
133         //If the user has not entered any swaps already, push a zeroed address to their user_swaps mapping to prevent default value conflicts in user_swaps_index
134         if (self.user_swaps[_owner].length == 0)
135             self.user_swaps[_owner].push(address(0x0));
136         //Add a new swap index for the owner
137         self.user_swaps_index[_owner][_swap] = self.user_swaps[_owner].length;
138         //Push a new swap address to the owner's swaps
139         self.user_swaps[_owner].push(_swap);
140         //Push a zeroed Balance struct to the swap balances mapping to prevent default value conflicts in swap_balances_index
141         self.swap_balances[_swap].push(Balance({
142             owner: 0,
143             amount: 0
144         }));
145         //Add a new owner balance index for the swap
146         self.swap_balances_index[_swap][_owner] = 1;
147         //Push the owner's balance to the swap
148         self.swap_balances[_swap].push(Balance({
149             owner: _owner,
150             amount: _supply
151         }));
152         emit CreateToken(_owner,_supply);
153     }
154 
155     /**
156     *@dev Called by the factory contract, and pays out to a _party
157     *@param _party being paid
158     *@param _swap address
159     */
160     function pay(TokenStorage storage self,address _party, address _swap) public{
161         require(msg.sender == self.factory_contract);
162         uint party_balance_index = self.swap_balances_index[_swap][_party];
163         require(party_balance_index > 0);
164         uint party_swap_balance = self.swap_balances[_swap][party_balance_index].amount;
165         //reduces the users totals balance by the amount in that swap
166         self.user_total_balances[_party] = self.user_total_balances[_party].sub(party_swap_balance);
167         //reduces the total supply by the amount of that users in that swap
168         self.total_supply = self.total_supply.sub(party_swap_balance);
169         //sets the partys balance to zero for that specific swaps party balances
170         self.swap_balances[_swap][party_balance_index].amount = 0;
171     }
172 
173     /**
174     *@dev Returns the users total balance (sum of tokens in all swaps the user has tokens in)
175     *@param _owner user address
176     *@return user total balance
177     */
178     function balanceOf(TokenStorage storage self,address _owner) public constant returns (uint balance) {
179        return self.user_total_balances[_owner]; 
180      }
181 
182     /**
183     *@dev Getter for the total_supply of tokens in the contract
184     *@return total supply
185     */
186     function totalSupply(TokenStorage storage self) public constant returns (uint _total_supply) {
187        return self.total_supply;
188     }
189 
190     /**
191     *@dev Removes the address from the swap balances for a swap, and moves the last address in the
192     *swap into their place
193     *@param _remove address of prevous owner
194     *@param _swap address used to get last addrss of the swap to replace the removed address
195     */
196     function removeFromSwapBalances(TokenStorage storage self,address _remove, address _swap) internal {
197         uint last_address_index = self.swap_balances[_swap].length.sub(1);
198         address last_address = self.swap_balances[_swap][last_address_index].owner;
199         //If the address we want to remove is the final address in the swap
200         if (last_address != _remove) {
201             uint remove_index = self.swap_balances_index[_swap][_remove];
202             //Update the swap's balance index of the last address to that of the removed address index
203             self.swap_balances_index[_swap][last_address] = remove_index;
204             //Set the swap's Balance struct at the removed index to the Balance struct of the last address
205             self.swap_balances[_swap][remove_index] = self.swap_balances[_swap][last_address_index];
206         }
207         //Remove the swap_balances index for this address
208         delete self.swap_balances_index[_swap][_remove];
209         //Finally, decrement the swap balances length
210         self.swap_balances[_swap].length = self.swap_balances[_swap].length.sub(1);
211     }
212 
213     /**
214     *@dev This is the main function to update the mappings when a transfer happens
215     *@param _from address to send funds from
216     *@param _to address to send funds to
217     *@param _amount amount of token to send
218     */
219     function transferHelper(TokenStorage storage self,address _from, address _to, uint _amount) internal {
220         //Get memory copies of the swap arrays for the sender and reciever
221         address[] memory from_swaps = self.user_swaps[_from];
222         //Iterate over sender's swaps in reverse order until enough tokens have been transferred
223         for (uint i = from_swaps.length.sub(1); i > 0; i--) {
224             //Get the index of the sender's balance for the current swap
225             uint from_swap_user_index = self.swap_balances_index[from_swaps[i]][_from];
226             Balance memory from_user_bal = self.swap_balances[from_swaps[i]][from_swap_user_index];
227             //If the current swap will be entirely depleted - we remove all references to it for the sender
228             if (_amount >= from_user_bal.amount) {
229                 _amount -= from_user_bal.amount;
230                 //If this swap is to be removed, we know it is the (current) last swap in the user's user_swaps list, so we can simply decrement the length to remove it
231                 self.user_swaps[_from].length = self.user_swaps[_from].length.sub(1);
232                 //Remove the user swap index for this swap
233                 delete self.user_swaps_index[_from][from_swaps[i]];
234                 //If the _to address already holds tokens from this swap
235                 if (self.user_swaps_index[_to][from_swaps[i]] != 0) {
236                     //Get the index of the _to balance in this swap
237                     uint to_balance_index = self.swap_balances_index[from_swaps[i]][_to];
238                     assert(to_balance_index != 0);
239                     //Add the _from tokens to _to
240                     self.swap_balances[from_swaps[i]][to_balance_index].amount = self.swap_balances[from_swaps[i]][to_balance_index].amount.add(from_user_bal.amount);
241                     //Remove the _from address from this swap's balance array
242                     removeFromSwapBalances(self,_from, from_swaps[i]);
243                 } else {
244                     //Prepare to add a new swap by assigning the swap an index for _to
245                     if (self.user_swaps[_to].length == 0){
246                         self.user_swaps[_to].push(address(0x0));
247                     }
248                 self.user_swaps_index[_to][from_swaps[i]] = self.user_swaps[_to].length;
249                 //Add the new swap to _to
250                 self.user_swaps[_to].push(from_swaps[i]);
251                 //Give the reciever the sender's balance for this swap
252                 self.swap_balances[from_swaps[i]][from_swap_user_index].owner = _to;
253                 //Give the reciever the sender's swap balance index for this swap
254                 self.swap_balances_index[from_swaps[i]][_to] = self.swap_balances_index[from_swaps[i]][_from];
255                 //Remove the swap balance index from the sending party
256                 delete self.swap_balances_index[from_swaps[i]][_from];
257             }
258             //If there is no more remaining to be removed, we break out of the loop
259             if (_amount == 0)
260                 break;
261             } else {
262                 //The amount in this swap is more than the amount we still need to transfer
263                 uint to_swap_balance_index = self.swap_balances_index[from_swaps[i]][_to];
264                 //If the _to address already holds tokens from this swap
265                 if (self.user_swaps_index[_to][from_swaps[i]] != 0) {
266                     //Because both addresses are in this swap, and neither will be removed, we simply update both swap balances
267                     self.swap_balances[from_swaps[i]][to_swap_balance_index].amount = self.swap_balances[from_swaps[i]][to_swap_balance_index].amount.add(_amount);
268                 } else {
269                     //Prepare to add a new swap by assigning the swap an index for _to
270                     if (self.user_swaps[_to].length == 0){
271                         self.user_swaps[_to].push(address(0x0));
272                     }
273                     self.user_swaps_index[_to][from_swaps[i]] = self.user_swaps[_to].length;
274                     //And push the new swap
275                     self.user_swaps[_to].push(from_swaps[i]);
276                     //_to is not in this swap, so we give this swap a new balance index for _to
277                     self.swap_balances_index[from_swaps[i]][_to] = self.swap_balances[from_swaps[i]].length;
278                     //And push a new balance for _to
279                     self.swap_balances[from_swaps[i]].push(Balance({
280                         owner: _to,
281                         amount: _amount
282                     }));
283                 }
284                 //Finally, update the _from user's swap balance
285                 self.swap_balances[from_swaps[i]][from_swap_user_index].amount = self.swap_balances[from_swaps[i]][from_swap_user_index].amount.sub(_amount);
286                 //Because we have transferred the last of the amount to the reciever, we break;
287                 break;
288             }
289         }
290     }
291 
292     /**
293     *@dev ERC20 compliant transfer function
294     *@param _to Address to send funds to
295     *@param _amount Amount of token to send
296     *@return true for successful
297     */
298     function transfer(TokenStorage storage self, address _to, uint _amount) public returns (bool) {
299         require(isWhitelisted(self,_to));
300         uint balance_owner = self.user_total_balances[msg.sender];
301         if (
302             _to == msg.sender ||
303             _to == address(0) ||
304             _amount == 0 ||
305             balance_owner < _amount
306         ) return false;
307         transferHelper(self,msg.sender, _to, _amount);
308         self.user_total_balances[msg.sender] = self.user_total_balances[msg.sender].sub(_amount);
309         self.user_total_balances[_to] = self.user_total_balances[_to].add(_amount);
310         emit Transfer(msg.sender, _to, _amount);
311         return true;
312     }
313     /**
314     *@dev ERC20 compliant transferFrom function
315     *@param _from address to send funds from (must be allowed, see approve function)
316     *@param _to address to send funds to
317     *@param _amount amount of token to send
318     *@return true for successful
319     */
320     function transferFrom(TokenStorage storage self, address _from, address _to, uint _amount) public returns (bool) {
321         require(isWhitelisted(self,_to));
322         uint balance_owner = self.user_total_balances[_from];
323         uint sender_allowed = self.allowed[_from][msg.sender];
324         if (
325             _to == _from ||
326             _to == address(0) ||
327             _amount == 0 ||
328             balance_owner < _amount ||
329             sender_allowed < _amount
330         ) return false;
331         transferHelper(self,_from, _to, _amount);
332         self.user_total_balances[_from] = self.user_total_balances[_from].sub(_amount);
333         self.user_total_balances[_to] = self.user_total_balances[_to].add(_amount);
334         self.allowed[_from][msg.sender] = self.allowed[_from][msg.sender].sub(_amount);
335         emit Transfer(_from, _to, _amount);
336         return true;
337     }
338 
339     /**
340     *@dev ERC20 compliant approve function
341     *@param _spender party that msg.sender approves for transferring funds
342     *@param _amount amount of token to approve for sending
343     *@return true for successful
344     */
345     function approve(TokenStorage storage self, address _spender, uint _amount) public returns (bool) {
346         self.allowed[msg.sender][_spender] = _amount;
347         emit Approval(msg.sender, _spender, _amount);
348         return true;
349     }
350 
351     /**
352     *@dev Counts addresses involved in the swap based on the length of balances array for _swap
353     *@param _swap address
354     *@return the length of the balances array for the swap
355     */
356     function addressCount(TokenStorage storage self, address _swap) public constant returns (uint) { 
357         return self.swap_balances[_swap].length; 
358     }
359 
360     /**
361     *@dev Gets the owner address and amount by specifying the swap address and index
362     *@param _ind specified index in the swap
363     *@param _swap specified swap address
364     *@return the owner address associated with a particular index in a particular swap
365     *@return the amount to transfer associated with a particular index in a particular swap
366     */
367     function getBalanceAndHolderByIndex(TokenStorage storage self, uint _ind, address _swap) public constant returns (uint, address) {
368         return (self.swap_balances[_swap][_ind].amount, self.swap_balances[_swap][_ind].owner);
369     }
370 
371     /**
372     *@dev Gets the index by specifying the swap and owner addresses
373     *@param _owner specifed address
374     *@param _swap  specified swap address
375     *@return the index associated with the _owner address in a particular swap
376     */
377     function getIndexByAddress(TokenStorage storage self, address _owner, address _swap) public constant returns (uint) {
378         return self.swap_balances_index[_swap][_owner]; 
379     }
380 
381     /**
382     *@dev Look up how much the spender or contract is allowed to spend?
383     *@param _owner 
384     *@param _spender party approved for transfering funds 
385     *@return the allowed amount _spender can spend of _owner's balance
386     */
387     function allowance(TokenStorage storage self, address _owner, address _spender) public constant returns (uint) {
388         return self.allowed[_owner][_spender]; 
389     }
390 }
391 
392 /**
393 *The DRCT_Token is an ERC20 compliant token representing the payout of the swap contract
394 *specified in the Factory contract.
395 *Each Factory contract is specified one DRCT Token and the token address can contain many
396 *different swap contracts that are standardized at the Factory level.
397 *The logic for the functions in this contract is housed in the DRCTLibary.sol.
398 */
399 contract DRCT_Token {
400 
401     using DRCTLibrary for DRCTLibrary.TokenStorage;
402 
403     /*Variables*/
404     DRCTLibrary.TokenStorage public drct;
405 
406     /*Functions*/
407     /**
408     *@dev Constructor - sets values for token name and token supply, as well as the 
409     *factory_contract, the swap.
410     *@param _factory 
411     */
412     constructor() public {
413         drct.startToken(msg.sender);
414     }
415 
416     /**
417     *@dev Token Creator - This function is called by the factory contract and creates new tokens
418     *for the user
419     *@param _supply amount of DRCT tokens created by the factory contract for this swap
420     *@param _owner address
421     *@param _swap address
422     */
423     function createToken(uint _supply, address _owner, address _swap) public{
424         drct.createToken(_supply,_owner,_swap);
425     }
426 
427     /**
428     *@dev gets the factory address
429     */
430     function getFactoryAddress() external view returns(address){
431         return drct.getFactoryAddress();
432     }
433 
434     /**
435     *@dev Called by the factory contract, and pays out to a _party
436     *@param _party being paid
437     *@param _swap address
438     */
439     function pay(address _party, address _swap) public{
440         drct.pay(_party,_swap);
441     }
442 
443     /**
444     *@dev Returns the users total balance (sum of tokens in all swaps the user has tokens in)
445     *@param _owner user address
446     *@return user total balance
447     */
448     function balanceOf(address _owner) public constant returns (uint balance) {
449        return drct.balanceOf(_owner);
450      }
451 
452     /**
453     *@dev Getter for the total_supply of tokens in the contract
454     *@return total supply
455     */
456     function totalSupply() public constant returns (uint _total_supply) {
457        return drct.totalSupply();
458     }
459 
460     /**
461     *ERC20 compliant transfer function
462     *@param _to Address to send funds to
463     *@param _amount Amount of token to send
464     *@return true for successful
465     */
466     function transfer(address _to, uint _amount) public returns (bool) {
467         return drct.transfer(_to,_amount);
468     }
469 
470     /**
471     *@dev ERC20 compliant transferFrom function
472     *@param _from address to send funds from (must be allowed, see approve function)
473     *@param _to address to send funds to
474     *@param _amount amount of token to send
475     *@return true for successful transfer
476     */
477     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
478         return drct.transferFrom(_from,_to,_amount);
479     }
480 
481     /**
482     *@dev ERC20 compliant approve function
483     *@param _spender party that msg.sender approves for transferring funds
484     *@param _amount amount of token to approve for sending
485     *@return true for successful
486     */
487     function approve(address _spender, uint _amount) public returns (bool) {
488         return drct.approve(_spender,_amount);
489     }
490 
491     /**
492     *@dev Counts addresses involved in the swap based on the length of balances array for _swap
493     *@param _swap address
494     *@return the length of the balances array for the swap
495     */
496     function addressCount(address _swap) public constant returns (uint) { 
497         return drct.addressCount(_swap); 
498     }
499 
500     /**
501     *@dev Gets the owner address and amount by specifying the swap address and index
502     *@param _ind specified index in the swap
503     *@param _swap specified swap address
504     *@return the amount to transfer associated with a particular index in a particular swap
505     *@return the owner address associated with a particular index in a particular swap
506     */
507     function getBalanceAndHolderByIndex(uint _ind, address _swap) public constant returns (uint, address) {
508         return drct.getBalanceAndHolderByIndex(_ind,_swap);
509     }
510 
511     /**
512     *@dev Gets the index by specifying the swap and owner addresses
513     *@param _owner specifed address
514     *@param _swap  specified swap address
515     *@return the index associated with the _owner address in a particular swap
516     */
517     function getIndexByAddress(address _owner, address _swap) public constant returns (uint) {
518         return drct.getIndexByAddress(_owner,_swap); 
519     }
520 
521     /**
522     *@dev Look up how much the spender or contract is allowed to spend?
523     *@param _owner address
524     *@param _spender party approved for transfering funds 
525     *@return the allowed amount _spender can spend of _owner's balance
526     */
527     function allowance(address _owner, address _spender) public constant returns (uint) {
528         return drct.allowance(_owner,_spender); 
529     }
530 }
531 
532 
533 
534 
535 
536 
537 //ERC20 function interface with create token and withdraw
538 interface Wrapped_Ether_Interface {
539   function totalSupply() external constant returns (uint);
540   function balanceOf(address _owner) external constant returns (uint);
541   function transfer(address _to, uint _amount) external returns (bool);
542   function transferFrom(address _from, address _to, uint _amount) external returns (bool);
543   function approve(address _spender, uint _amount) external returns (bool);
544   function allowance(address _owner, address _spender) external constant returns (uint);
545   function withdraw(uint _value) external;
546   function createToken() external;
547 
548 }
549 
550 interface Membership_Interface {
551     function getMembershipType(address _member) external constant returns(uint);
552 }
553 
554 
555 
556 /**
557 *The Factory contract sets the standardized variables and also deploys new contracts based on
558 *these variables for the user.  
559 */
560 contract Factory {
561     using SafeMath for uint256;
562     
563     /*Variables*/
564     //Addresses of the Factory owner and oracle. For oracle information, 
565     //check www.github.com/DecentralizedDerivatives/Oracles
566     address public owner;
567     address public oracle_address;
568     //Address of the user contract
569     address public user_contract;
570     //Address of the deployer contract
571     address internal deployer_address;
572     Deployer_Interface internal deployer;
573     address public token;
574     //A fee for creating a swap in wei.  Plan is for this to be zero, however can be raised to prevent spam
575     uint public fee;
576     //swap fee
577     uint public swapFee;
578     //Duration of swap contract in days
579     uint public duration;
580     //Multiplier of reference rate.  2x refers to a 50% move generating a 100% move in the contract payout values
581     uint public multiplier;
582     //Token_ratio refers to the number of DRCT Tokens a party will get based on the number of base tokens.  As an example, 1e15 indicates that a party will get 1000 DRCT Tokens based upon 1 ether of wrapped wei. 
583     uint public token_ratio;
584     //Array of deployed contracts
585     address[] public contracts;
586     uint[] public startDates;
587     address public memberContract;
588     mapping(uint => bool) whitelistedTypes;
589     mapping(address => uint) public created_contracts;
590     mapping(address => uint) public token_dates;
591     mapping(uint => address) public long_tokens;
592     mapping(uint => address) public short_tokens;
593     mapping(address => uint) public token_type; //1=short 2=long
594 
595     /*Events*/
596     //Emitted when a Swap is created
597     event ContractCreation(address _sender, address _created);
598 
599     /*Modifiers*/
600     modifier onlyOwner() {
601         require(msg.sender == owner);
602         _;
603     }
604 
605     /*Functions*/
606     /**
607     *@dev Constructor - Sets owner
608     */
609      constructor() public {
610         owner = msg.sender;
611     }
612 
613     /**
614     *@dev constructor function for cloned factory
615     */
616     function init(address _owner) public{
617         require(owner == address(0));
618         owner = _owner;
619     }
620 
621     /**
622     *@dev Sets the Membership contract address
623     *@param _memberContract The new membership address
624     */
625     function setMemberContract(address _memberContract) public onlyOwner() {
626         memberContract = _memberContract;
627     }
628 
629     /**
630     *@dev Sets the member types/permissions for those whitelisted
631     *@param _memberTypes is the list of member types
632     */
633     function setWhitelistedMemberTypes(uint[] _memberTypes) public onlyOwner(){
634         whitelistedTypes[0] = false;
635         for(uint i = 0; i<_memberTypes.length;i++){
636             whitelistedTypes[_memberTypes[i]] = true;
637         }
638     }
639 
640     /**
641     *@dev Checks the membership type/permissions for whitelisted members
642     *@param _member address to get membership type from
643     */
644     function isWhitelisted(address _member) public view returns (bool){
645         Membership_Interface Member = Membership_Interface(memberContract);
646         return whitelistedTypes[Member.getMembershipType(_member)];
647     }
648  
649     /**
650     *@dev Gets long and short token addresses based on specified date
651     *@param _date 
652     *@return short and long tokens' addresses
653     */
654     function getTokens(uint _date) public view returns(address, address){
655         return(long_tokens[_date],short_tokens[_date]);
656     }
657 
658     /**
659     *@dev Gets the type of Token (long and short token) for the specifed 
660     *token address
661     *@param _token address 
662     *@return token type short = 1 and long = 2
663     */
664     function getTokenType(address _token) public view returns(uint){
665         return(token_type[_token]);
666     }
667 
668     /**
669     *@dev Updates the fee amount
670     *@param _fee is the new fee amount
671     */
672     function setFee(uint _fee) public onlyOwner() {
673         fee = _fee;
674     }
675 
676     /**
677     *@dev Updates the swap fee amount
678     *@param _swapFee is the new swap fee amount
679     */
680     function setSwapFee(uint _swapFee) public onlyOwner() {
681         swapFee = _swapFee;
682     }   
683 
684     /**
685     *@dev Sets the deployer address
686     *@param _deployer is the new deployer address
687     */
688     function setDeployer(address _deployer) public onlyOwner() {
689         deployer_address = _deployer;
690         deployer = Deployer_Interface(_deployer);
691     }
692 
693     /**
694     *@dev Sets the user_contract address
695     *@param _userContract is the new userContract address
696     */
697     function setUserContract(address _userContract) public onlyOwner() {
698         user_contract = _userContract;
699     }
700 
701     /**
702     *@dev Sets token ratio, swap duration, and multiplier variables for a swap.
703     *@param _token_ratio the ratio of the tokens
704     *@param _duration the duration of the swap, in days
705     *@param _multiplier the multiplier used for the swap
706     *@param _swapFee the swap fee
707     */
708     function setVariables(uint _token_ratio, uint _duration, uint _multiplier, uint _swapFee) public onlyOwner() {
709         require(_swapFee < 10000);
710         token_ratio = _token_ratio;
711         duration = _duration;
712         multiplier = _multiplier;
713         swapFee = _swapFee;
714     }
715 
716     /**
717     *@dev Sets the address of the base tokens used for the swap
718     *@param _token The address of a token to be used  as collateral
719     */
720     function setBaseToken(address _token) public onlyOwner() {
721         token = _token;
722     }
723 
724     /**
725     *@dev Allows a user to deploy a new swap contract, if they pay the fee
726     *@param _start_date the contract start date 
727     *@return new_contract address for he newly created swap address and calls 
728     *event 'ContractCreation'
729     */
730     function deployContract(uint _start_date) public payable returns (address) {
731         require(msg.value >= fee && isWhitelisted(msg.sender));
732         require(_start_date % 86400 == 0);
733         address new_contract = deployer.newContract(msg.sender, user_contract, _start_date);
734         contracts.push(new_contract);
735         created_contracts[new_contract] = _start_date;
736         emit ContractCreation(msg.sender,new_contract);
737         return new_contract;
738     }
739 
740     /**
741     *@dev Deploys DRCT tokens for given start date
742     *@param _start_date of contract
743     */
744     function deployTokenContract(uint _start_date) public{
745         address _token;
746         require(_start_date % 86400 == 0);
747         require(long_tokens[_start_date] == address(0) && short_tokens[_start_date] == address(0));
748         _token = new DRCT_Token();
749         token_dates[_token] = _start_date;
750         long_tokens[_start_date] = _token;
751         token_type[_token]=2;
752         _token = new DRCT_Token();
753         token_type[_token]=1;
754         short_tokens[_start_date] = _token;
755         token_dates[_token] = _start_date;
756         startDates.push(_start_date);
757 
758     }
759 
760     /**
761     *@dev Deploys new tokens on a DRCT_Token contract -- called from within a swap
762     *@param _supply The number of tokens to create
763     *@param _party the address to send the tokens to
764     *@param _start_date the start date of the contract      
765     *@returns ltoken the address of the created DRCT long tokens
766     *@returns stoken the address of the created DRCT short tokens
767     *@returns token_ratio The ratio of the created DRCT token
768     */
769     function createToken(uint _supply, address _party, uint _start_date) public returns (address, address, uint) {
770         require(created_contracts[msg.sender] == _start_date);
771         address ltoken = long_tokens[_start_date];
772         address stoken = short_tokens[_start_date];
773         require(ltoken != address(0) && stoken != address(0));
774             DRCT_Token drct_interface = DRCT_Token(ltoken);
775             drct_interface.createToken(_supply.div(token_ratio), _party,msg.sender);
776             drct_interface = DRCT_Token(stoken);
777             drct_interface.createToken(_supply.div(token_ratio), _party,msg.sender);
778         return (ltoken, stoken, token_ratio);
779     }
780   
781     /**
782     *@dev Allows the owner to set a new oracle address
783     *@param _new_oracle_address 
784     */
785     function setOracleAddress(address _new_oracle_address) public onlyOwner() {
786         oracle_address = _new_oracle_address; 
787     }
788 
789     /**
790     *@dev Allows the owner to set a new owner address
791     *@param _new_owner the new owner address
792     */
793     function setOwner(address _new_owner) public onlyOwner() { 
794         owner = _new_owner; 
795     }
796 
797     /**
798     *@dev Allows the owner to pull contract creation fees
799     *@return the withdrawal fee _val and the balance where is the return function?
800     */
801     function withdrawFees() public onlyOwner(){
802         Wrapped_Ether_Interface token_interface = Wrapped_Ether_Interface(token);
803         uint _val = token_interface.balanceOf(address(this));
804         if(_val > 0){
805             token_interface.withdraw(_val);
806         }
807         owner.transfer(address(this).balance);
808      }
809 
810     /**
811     *@dev fallback function
812     */ 
813     function() public payable {
814     }
815 
816     /**
817     *@dev Returns a tuple of many private variables.
818     *The variables from this function are pass through to the TokenLibrary.getVariables function
819     *@returns oracle_adress is the address of the oracle
820     *@returns duration is the duration of the swap
821     *@returns multiplier is the multiplier for the swap
822     *@returns token is the address of token
823     *@returns _swapFee is the swap fee 
824     */
825     function getVariables() public view returns (address, uint, uint, address,uint){
826         return (oracle_address,duration, multiplier, token,swapFee);
827     }
828 
829     /**
830     *@dev Pays out to a DRCT token
831     *@param _party is the address being paid
832     *@param _token_add token to pay out
833     */
834     function payToken(address _party, address _token_add) public {
835         require(created_contracts[msg.sender] > 0);
836         DRCT_Token drct_interface = DRCT_Token(_token_add);
837         drct_interface.pay(_party, msg.sender);
838     }
839 
840     /**
841     *@dev Counts number of contacts created by this factory
842     *@return the number of contracts
843     */
844     function getCount() public constant returns(uint) {
845         return contracts.length;
846     }
847 
848     /**
849     *@dev Counts number of start dates in this factory
850     *@return the number of active start dates
851     */
852     function getDateCount() public constant returns(uint) {
853         return startDates.length;
854     }
855 }
856 
857 /**
858 *This contracts helps clone factories and swaps through the Deployer.sol and MasterDeployer.sol.
859 *The address of the targeted contract to clone has to be provided.
860 */
861 contract CloneFactory {
862 
863     /*Variables*/
864     address internal owner;
865     
866     /*Events*/
867     event CloneCreated(address indexed target, address clone);
868 
869     /*Modifiers*/
870     modifier onlyOwner() {
871         require(msg.sender == owner);
872         _;
873     }
874     
875     /*Functions*/
876     constructor() public{
877         owner = msg.sender;
878     }    
879     
880     /**
881     *@dev Allows the owner to set a new owner address
882     *@param _owner the new owner address
883     */
884     function setOwner(address _owner) public onlyOwner(){
885         owner = _owner;
886     }
887 
888     /**
889     *@dev Creates factory clone
890     *@param _target is the address being cloned
891     *@return address for clone
892     */
893     function createClone(address target) internal returns (address result) {
894         bytes memory clone = hex"600034603b57603080600f833981f36000368180378080368173bebebebebebebebebebebebebebebebebebebebe5af43d82803e15602c573d90f35b3d90fd";
895         bytes20 targetBytes = bytes20(target);
896         for (uint i = 0; i < 20; i++) {
897             clone[26 + i] = targetBytes[i];
898         }
899         assembly {
900             let len := mload(clone)
901             let data := add(clone, 0x20)
902             result := create(0, data, len)
903         }
904     }
905 }
906 
907 
908 /**
909 *This contract deploys a factory contract and uses CloneFactory to clone the factory
910 *specified.
911 */
912 
913 contract MasterDeployer is CloneFactory{
914     
915     using SafeMath for uint256;
916 
917     /*Variables*/
918     address[] factory_contracts;
919     address private factory;
920     mapping(address => uint) public factory_index;
921 
922     /*Events*/
923     event NewFactory(address _factory);
924 
925     /*Functions*/
926     /**
927     *@dev Initiates the factory_contract array with address(0)
928     */
929     constructor() public {
930         factory_contracts.push(address(0));
931     }
932 
933     /**
934     *@dev Set factory address to clone
935     *@param _factory address to clone
936     */  
937     function setFactory(address _factory) public onlyOwner(){
938         factory = _factory;
939     }
940 
941     /**
942     *@dev creates a new factory by cloning the factory specified in setFactory.
943     *@return _new_fac which is the new factory address
944     */
945     function deployFactory() public onlyOwner() returns(address){
946         address _new_fac = createClone(factory);
947         factory_index[_new_fac] = factory_contracts.length;
948         factory_contracts.push(_new_fac);
949         Factory(_new_fac).init(msg.sender);
950         emit NewFactory(_new_fac);
951         return _new_fac;
952     }
953 
954     /**
955     *@dev Removes the factory specified
956     *@param _factory address to remove
957     */
958     function removeFactory(address _factory) public onlyOwner(){
959         require(_factory != address(0) && factory_index[_factory] != 0);
960         uint256 fIndex = factory_index[_factory];
961         uint256 lastFactoryIndex = factory_contracts.length.sub(1);
962         address lastFactory = factory_contracts[lastFactoryIndex];
963         factory_contracts[fIndex] = lastFactory;
964         factory_index[lastFactory] = fIndex;
965         factory_contracts.length--;
966         factory_index[_factory] = 0;
967     }
968 
969     /**
970     *@dev Counts the number of factories
971     *@returns the number of active factories
972     */
973     function getFactoryCount() public constant returns(uint){
974         return factory_contracts.length - 1;
975     }
976 
977     /**
978     *@dev Returns the factory address for the specified index
979     *@param _index for factory to look up in the factory_contracts array
980     *@return factory address for the index specified
981     */
982     function getFactorybyIndex(uint _index) public constant returns(address){
983         return factory_contracts[_index];
984     }
985 }