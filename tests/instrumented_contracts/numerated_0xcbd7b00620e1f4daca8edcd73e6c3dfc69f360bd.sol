1 pragma solidity ^0.4.24;
2 
3 // File: contracts\interfaces\Factory_Interface.sol
4 
5 //Swap factory functions - descriptions can be found in Factory.sol
6 interface Factory_Interface {
7   function createToken(uint _supply, address _party, uint _start_date) external returns (address,address, uint);
8   function payToken(address _party, address _token_add) external;
9   function deployContract(uint _start_date) external payable returns (address);
10    function getBase() external view returns(address);
11   function getVariables() external view returns (address, uint, uint, address,uint);
12   function isWhitelisted(address _member) external view returns (bool);
13 }
14 
15 // File: contracts\libraries\SafeMath.sol
16 
17 //Slightly modified SafeMath library - includes a min function
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 
43   function min(uint a, uint b) internal pure returns (uint256) {
44     return a < b ? a : b;
45   }
46 }
47 
48 // File: contracts\libraries\DRCTLibrary.sol
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
392 // File: contracts\DRCT_Token.sol
393 
394 /**
395 *The DRCT_Token is an ERC20 compliant token representing the payout of the swap contract
396 *specified in the Factory contract.
397 *Each Factory contract is specified one DRCT Token and the token address can contain many
398 *different swap contracts that are standardized at the Factory level.
399 *The logic for the functions in this contract is housed in the DRCTLibary.sol.
400 */
401 contract DRCT_Token {
402 
403     using DRCTLibrary for DRCTLibrary.TokenStorage;
404 
405     /*Variables*/
406     DRCTLibrary.TokenStorage public drct;
407     string public constant name = "DRCT Token";
408     string public constant symbol = "DRCT";
409 
410     /*Functions*/
411     /**
412     *@dev Constructor - sets values for token name and token supply, as well as the 
413     *factory_contract, the swap.
414     *@param _factory 
415     */
416     constructor() public {
417         drct.startToken(msg.sender);
418     }
419 
420     /**
421     *@dev Token Creator - This function is called by the factory contract and creates new tokens
422     *for the user
423     *@param _supply amount of DRCT tokens created by the factory contract for this swap
424     *@param _owner address
425     *@param _swap address
426     */
427     function createToken(uint _supply, address _owner, address _swap) public{
428         drct.createToken(_supply,_owner,_swap);
429     }
430 
431     /**
432     *@dev gets the factory address
433     */
434     function getFactoryAddress() external view returns(address){
435         return drct.getFactoryAddress();
436     }
437 
438     /**
439     *@dev Called by the factory contract, and pays out to a _party
440     *@param _party being paid
441     *@param _swap address
442     */
443     function pay(address _party, address _swap) public{
444         drct.pay(_party,_swap);
445     }
446 
447     /**
448     *@dev Returns the users total balance (sum of tokens in all swaps the user has tokens in)
449     *@param _owner user address
450     *@return user total balance
451     */
452     function balanceOf(address _owner) public constant returns (uint balance) {
453        return drct.balanceOf(_owner);
454      }
455 
456     /**
457     *@dev Getter for the total_supply of tokens in the contract
458     *@return total supply
459     */
460     function totalSupply() public constant returns (uint _total_supply) {
461        return drct.totalSupply();
462     }
463 
464     /**
465     *ERC20 compliant transfer function
466     *@param _to Address to send funds to
467     *@param _amount Amount of token to send
468     *@return true for successful
469     */
470     function transfer(address _to, uint _amount) public returns (bool) {
471         return drct.transfer(_to,_amount);
472     }
473 
474     /**
475     *@dev ERC20 compliant transferFrom function
476     *@param _from address to send funds from (must be allowed, see approve function)
477     *@param _to address to send funds to
478     *@param _amount amount of token to send
479     *@return true for successful transfer
480     */
481     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
482         return drct.transferFrom(_from,_to,_amount);
483     }
484 
485     /**
486     *@dev ERC20 compliant approve function
487     *@param _spender party that msg.sender approves for transferring funds
488     *@param _amount amount of token to approve for sending
489     *@return true for successful
490     */
491     function approve(address _spender, uint _amount) public returns (bool) {
492         return drct.approve(_spender,_amount);
493     }
494 
495     /**
496     *@dev Counts addresses involved in the swap based on the length of balances array for _swap
497     *@param _swap address
498     *@return the length of the balances array for the swap
499     */
500     function addressCount(address _swap) public constant returns (uint) { 
501         return drct.addressCount(_swap); 
502     }
503 
504     /**
505     *@dev Gets the owner address and amount by specifying the swap address and index
506     *@param _ind specified index in the swap
507     *@param _swap specified swap address
508     *@return the amount to transfer associated with a particular index in a particular swap
509     *@return the owner address associated with a particular index in a particular swap
510     */
511     function getBalanceAndHolderByIndex(uint _ind, address _swap) public constant returns (uint, address) {
512         return drct.getBalanceAndHolderByIndex(_ind,_swap);
513     }
514 
515     /**
516     *@dev Gets the index by specifying the swap and owner addresses
517     *@param _owner specifed address
518     *@param _swap  specified swap address
519     *@return the index associated with the _owner address in a particular swap
520     */
521     function getIndexByAddress(address _owner, address _swap) public constant returns (uint) {
522         return drct.getIndexByAddress(_owner,_swap); 
523     }
524 
525     /**
526     *@dev Look up how much the spender or contract is allowed to spend?
527     *@param _owner address
528     *@param _spender party approved for transfering funds 
529     *@return the allowed amount _spender can spend of _owner's balance
530     */
531     function allowance(address _owner, address _spender) public constant returns (uint) {
532         return drct.allowance(_owner,_spender); 
533     }
534 }
535 
536 // File: contracts\interfaces\Deployer_Interface.sol
537 
538 //Swap Deployer functions - descriptions can be found in Deployer.sol
539 interface Deployer_Interface {
540   function newContract(address _party, address user_contract, uint _start_date) external payable returns (address);
541 }
542 
543 // File: contracts\interfaces\Membership_Interface.sol
544 
545 interface Membership_Interface {
546     function getMembershipType(address _member) external constant returns(uint);
547 }
548 
549 // File: contracts\interfaces\Wrapped_Ether_Interface.sol
550 
551 //ERC20 function interface with create token and withdraw
552 interface Wrapped_Ether_Interface {
553   function totalSupply() external constant returns (uint);
554   function balanceOf(address _owner) external constant returns (uint);
555   function transfer(address _to, uint _amount) external returns (bool);
556   function transferFrom(address _from, address _to, uint _amount) external returns (bool);
557   function approve(address _spender, uint _amount) external returns (bool);
558   function allowance(address _owner, address _spender) external constant returns (uint);
559   function withdraw(uint _value) external;
560   function createToken() external;
561 
562 }
563 
564 // File: contracts\Factory.sol
565 
566 /**
567 *The Factory contract sets the standardized variables and also deploys new contracts based on
568 *these variables for the user.  
569 */
570 contract Factory {
571     using SafeMath for uint256;
572     
573     /*Variables*/
574     //Addresses of the Factory owner and oracle. For oracle information, 
575     //check www.github.com/DecentralizedDerivatives/Oracles
576     address public owner;
577     address public oracle_address;
578     //Address of the user contract
579     address public user_contract;
580     //Address of the deployer contract
581     address internal deployer_address;
582     Deployer_Interface internal deployer;
583     address public token;
584     //A fee for creating a swap in wei.  Plan is for this to be zero, however can be raised to prevent spam
585     uint public fee;
586     //swap fee
587     uint public swapFee;
588     //Duration of swap contract in days
589     uint public duration;
590     //Multiplier of reference rate.  2x refers to a 50% move generating a 100% move in the contract payout values
591     uint public multiplier;
592     //Token_ratio refers to the number of DRCT Tokens a party will get based on the number of base tokens.  As an example, 1e15 indicates that a party will get 1000 DRCT Tokens based upon 1 ether of wrapped wei. 
593     uint public token_ratio;
594     //Array of deployed contracts
595     address[] public contracts;
596     uint[] public startDates;
597     address public memberContract;
598     uint whitelistedTypes;
599     mapping(address => uint) public created_contracts;
600     mapping(address => uint) public token_dates;
601     mapping(uint => address) public long_tokens;
602     mapping(uint => address) public short_tokens;
603     mapping(address => uint) public token_type; //1=short 2=long
604 
605     /*Events*/
606     //Emitted when a Swap is created
607     event ContractCreation(address _sender, address _created);
608 
609     /*Modifiers*/
610     modifier onlyOwner() {
611         require(msg.sender == owner);
612         _;
613     }
614 
615     /*Functions*/
616     /**
617     *@dev Sets the member type/permissions for those whitelisted and owner
618     *@param _memberTypes is the list of member types
619     */
620      constructor(uint _memberTypes) public {
621         owner = msg.sender;
622         whitelistedTypes=_memberTypes;
623     }
624 
625     /**
626     *@dev constructor function for cloned factory
627     */
628     function init(address _owner, uint _memberTypes) public{
629         require(owner == address(0));
630         owner = _owner;
631         whitelistedTypes=_memberTypes;
632     }
633 
634     /**
635     *@dev Sets the Membership contract address
636     *@param _memberContract The new membership address
637     */
638     function setMemberContract(address _memberContract) public onlyOwner() {
639         memberContract = _memberContract;
640     }
641 
642 
643     /**
644     *@dev Checks the membership type/permissions for whitelisted members
645     *@param _member address to get membership type from
646     */
647     function isWhitelisted(address _member) public view returns (bool){
648         Membership_Interface Member = Membership_Interface(memberContract);
649         return Member.getMembershipType(_member)>= whitelistedTypes;
650     }
651  
652     /**
653     *@dev Gets long and short token addresses based on specified date
654     *@param _date 
655     *@return short and long tokens' addresses
656     */
657     function getTokens(uint _date) public view returns(address, address){
658         return(long_tokens[_date],short_tokens[_date]);
659     }
660 
661     /**
662     *@dev Gets the type of Token (long and short token) for the specifed 
663     *token address
664     *@param _token address 
665     *@return token type short = 1 and long = 2
666     */
667     function getTokenType(address _token) public view returns(uint){
668         return(token_type[_token]);
669     }
670 
671     /**
672     *@dev Updates the fee amount
673     *@param _fee is the new fee amount
674     */
675     function setFee(uint _fee) public onlyOwner() {
676         fee = _fee;
677     }
678 
679     /**
680     *@dev Updates the swap fee amount
681     *@param _swapFee is the new swap fee amount
682     */
683     function setSwapFee(uint _swapFee) public onlyOwner() {
684         swapFee = _swapFee;
685     }   
686 
687     /**
688     *@dev Sets the deployer address
689     *@param _deployer is the new deployer address
690     */
691     function setDeployer(address _deployer) public onlyOwner() {
692         deployer_address = _deployer;
693         deployer = Deployer_Interface(_deployer);
694     }
695 
696     /**
697     *@dev Sets the user_contract address
698     *@param _userContract is the new userContract address
699     */
700     function setUserContract(address _userContract) public onlyOwner() {
701         user_contract = _userContract;
702     }
703 
704     /**
705     *@dev Sets token ratio, swap duration, and multiplier variables for a swap.
706     *@param _token_ratio the ratio of the tokens
707     *@param _duration the duration of the swap, in days
708     *@param _multiplier the multiplier used for the swap
709     *@param _swapFee the swap fee
710     */
711     function setVariables(uint _token_ratio, uint _duration, uint _multiplier, uint _swapFee) public onlyOwner() {
712         require(_swapFee < 10000);
713         token_ratio = _token_ratio;
714         duration = _duration;
715         multiplier = _multiplier;
716         swapFee = _swapFee;
717     }
718 
719     /**
720     *@dev Sets the address of the base tokens used for the swap
721     *@param _token The address of a token to be used  as collateral
722     */
723     function setBaseToken(address _token) public onlyOwner() {
724         token = _token;
725     }
726 
727     /**
728     *@dev Allows a user to deploy a new swap contract, if they pay the fee
729     *@param _start_date the contract start date 
730     *@pararm _user your address if calling it directly.  Allows you to create on behalf of someone
731     *@return new_contract address for he newly created swap address and calls 
732     *event 'ContractCreation'
733     */
734     function deployContract(uint _start_date,address _user) public payable returns (address) {
735         require(msg.value >= fee && isWhitelisted(_user));
736         require(_start_date % 86400 == 0);
737         address new_contract = deployer.newContract(_user, user_contract, _start_date);
738         contracts.push(new_contract);
739         created_contracts[new_contract] = _start_date;
740         emit ContractCreation(_user,new_contract);
741         return new_contract;
742     }
743 
744     /**
745     *@dev Deploys DRCT tokens for given start date
746     *@param _start_date of contract
747     */
748     function deployTokenContract(uint _start_date) public{
749         address _token;
750         require(_start_date % 86400 == 0);
751         require(long_tokens[_start_date] == address(0) && short_tokens[_start_date] == address(0));
752         _token = new DRCT_Token();
753         token_dates[_token] = _start_date;
754         long_tokens[_start_date] = _token;
755         token_type[_token]=2;
756         _token = new DRCT_Token();
757         token_type[_token]=1;
758         short_tokens[_start_date] = _token;
759         token_dates[_token] = _start_date;
760         startDates.push(_start_date);
761 
762     }
763 
764     /**
765     *@dev Deploys new tokens on a DRCT_Token contract -- called from within a swap
766     *@param _supply The number of tokens to create
767     *@param _party the address to send the tokens to
768     *@param _start_date the start date of the contract      
769     *@returns ltoken the address of the created DRCT long tokens
770     *@returns stoken the address of the created DRCT short tokens
771     *@returns token_ratio The ratio of the created DRCT token
772     */
773     function createToken(uint _supply, address _party, uint _start_date) public returns (address, address, uint) {
774         require(created_contracts[msg.sender] == _start_date);
775         address ltoken = long_tokens[_start_date];
776         address stoken = short_tokens[_start_date];
777         require(ltoken != address(0) && stoken != address(0));
778             DRCT_Token drct_interface = DRCT_Token(ltoken);
779             drct_interface.createToken(_supply.div(token_ratio), _party,msg.sender);
780             drct_interface = DRCT_Token(stoken);
781             drct_interface.createToken(_supply.div(token_ratio), _party,msg.sender);
782         return (ltoken, stoken, token_ratio);
783     }
784   
785     /**
786     *@dev Allows the owner to set a new oracle address
787     *@param _new_oracle_address 
788     */
789     function setOracleAddress(address _new_oracle_address) public onlyOwner() {
790         oracle_address = _new_oracle_address; 
791     }
792 
793     /**
794     *@dev Allows the owner to set a new owner address
795     *@param _new_owner the new owner address
796     */
797     function setOwner(address _new_owner) public onlyOwner() { 
798         owner = _new_owner; 
799     }
800 
801     /**
802     *@dev Allows the owner to pull contract creation fees
803     *@return the withdrawal fee _val and the balance where is the return function?
804     */
805     function withdrawFees() public onlyOwner(){
806         Wrapped_Ether_Interface token_interface = Wrapped_Ether_Interface(token);
807         uint _val = token_interface.balanceOf(address(this));
808         if(_val > 0){
809             token_interface.withdraw(_val);
810         }
811         owner.transfer(address(this).balance);
812      }
813 
814     /**
815     *@dev fallback function
816     */ 
817     function() public payable {
818     }
819 
820     /**
821     *@dev Returns a tuple of many private variables.
822     *The variables from this function are pass through to the TokenLibrary.getVariables function
823     *@returns oracle_adress is the address of the oracle
824     *@returns duration is the duration of the swap
825     *@returns multiplier is the multiplier for the swap
826     *@returns token is the address of token
827     *@returns _swapFee is the swap fee 
828     */
829     function getVariables() public view returns (address, uint, uint, address,uint){
830         return (oracle_address,duration, multiplier, token,swapFee);
831     }
832 
833     /**
834     *@dev Pays out to a DRCT token
835     *@param _party is the address being paid
836     *@param _token_add token to pay out
837     */
838     function payToken(address _party, address _token_add) public {
839         require(created_contracts[msg.sender] > 0);
840         DRCT_Token drct_interface = DRCT_Token(_token_add);
841         drct_interface.pay(_party, msg.sender);
842     }
843 
844     /**
845     *@dev Counts number of contacts created by this factory
846     *@return the number of contracts
847     */
848     function getCount() public constant returns(uint) {
849         return contracts.length;
850     }
851 
852     /**
853     *@dev Counts number of start dates in this factory
854     *@return the number of active start dates
855     */
856     function getDateCount() public constant returns(uint) {
857         return startDates.length;
858     }
859 }
860 
861 // File: contracts\Wrapped_Ether.sol
862 
863 /**
864 *This is the basic wrapped Ether contract. 
865 *All money deposited is transformed into ERC20 tokens at the rate of 1 wei = 1 token
866 */
867 contract Wrapped_Ether {
868 
869     using SafeMath for uint256;
870 
871     /*Variables*/
872 
873     //ERC20 fields
874     string public name = "Wrapped Ether";
875     uint public total_supply;
876     mapping(address => uint) internal balances;
877     mapping(address => mapping (address => uint)) internal allowed;
878 
879     /*Events*/
880     event Transfer(address indexed _from, address indexed _to, uint _value);
881     event Approval(address indexed _owner, address indexed _spender, uint _value);
882     event StateChanged(bool _success, string _message);
883 
884     /*Functions*/
885     /**
886     *@dev This function creates tokens equal in value to the amount sent to the contract
887     */
888     function createToken() public payable {
889         require(msg.value > 0);
890         balances[msg.sender] = balances[msg.sender].add(msg.value);
891         total_supply = total_supply.add(msg.value);
892     }
893 
894     /**
895     *@dev This function 'unwraps' an _amount of Ether in the sender's balance by transferring 
896     *Ether to them
897     *@param _value The amount of the token to unwrap
898     */
899     function withdraw(uint _value) public {
900         balances[msg.sender] = balances[msg.sender].sub(_value);
901         total_supply = total_supply.sub(_value);
902         msg.sender.transfer(_value);
903     }
904 
905     /**
906     *@param _owner is the owner address used to look up the balance
907     *@return Returns the balance associated with the passed in _owner
908     */
909     function balanceOf(address _owner) public constant returns (uint bal) { 
910         return balances[_owner]; 
911     }
912 
913     /**
914     *@dev Allows for a transfer of tokens to _to
915     *@param _to The address to send tokens to
916     *@param _amount The amount of tokens to send
917     */
918     function transfer(address _to, uint _amount) public returns (bool) {
919         if (balances[msg.sender] >= _amount
920         && _amount > 0
921         && balances[_to] + _amount > balances[_to]) {
922             balances[msg.sender] = balances[msg.sender] - _amount;
923             balances[_to] = balances[_to] + _amount;
924             emit Transfer(msg.sender, _to, _amount);
925             return true;
926         } else {
927             return false;
928         }
929     }
930 
931     /**
932     *@dev Allows an address with sufficient spending allowance to send tokens on the behalf of _from
933     *@param _from The address to send tokens from
934     *@param _to The address to send tokens to
935     *@param _amount The amount of tokens to send
936     */
937     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
938         if (balances[_from] >= _amount
939         && allowed[_from][msg.sender] >= _amount
940         && _amount > 0
941         && balances[_to] + _amount > balances[_to]) {
942             balances[_from] = balances[_from] - _amount;
943             allowed[_from][msg.sender] = allowed[_from][msg.sender] - _amount;
944             balances[_to] = balances[_to] + _amount;
945             emit Transfer(_from, _to, _amount);
946             return true;
947         } else {
948             return false;
949         }
950     }
951 
952     /**
953     *@dev This function approves a _spender an _amount of tokens to use
954     *@param _spender address
955     *@param _amount amount the spender is being approved for
956     *@return true if spender appproved successfully
957     */
958     function approve(address _spender, uint _amount) public returns (bool) {
959         allowed[msg.sender][_spender] = _amount;
960         emit Approval(msg.sender, _spender, _amount);
961         return true;
962     }
963 
964     /**
965     *@param _owner address
966     *@param _spender address
967     *@return Returns the remaining allowance of tokens granted to the _spender from the _owner
968     */
969     function allowance(address _owner, address _spender) public view returns (uint) {
970        return allowed[_owner][_spender]; }
971 
972     /**
973     *@dev Getter for the total_supply of wrapped ether
974     *@return total supply
975     */
976     function totalSupply() public constant returns (uint) {
977        return total_supply;
978     }
979 }
980 
981 // File: contracts\interfaces\TokenToTokenSwap_Interface.sol
982 
983 //Swap interface- descriptions can be found in TokenToTokenSwap.sol
984 interface TokenToTokenSwap_Interface {
985   function createSwap(uint _amount, address _senderAdd) external;
986 }
987 
988 // File: contracts\UserContract.sol
989 
990 /**
991 *The User Contract enables the entering of a deployed swap along with the wrapping of Ether.  This
992 *contract was specifically made for drct.decentralizedderivatives.org to simplify user metamask 
993 *calls
994 */
995 contract UserContract{
996 
997     using SafeMath for uint256;
998 
999     /*Variables*/
1000     TokenToTokenSwap_Interface internal swap;
1001     Wrapped_Ether internal baseToken;
1002     Factory internal factory; 
1003     address public factory_address;
1004     address internal owner;
1005     event StartContract(address _newswap, uint _amount);
1006 
1007 
1008     /*Functions*/
1009     constructor() public {
1010         owner = msg.sender;
1011     }
1012 
1013     /**
1014     *@dev Value must be sent with Initiate and enter the _amount(in wei) 
1015     *@param _startDate is the startDate of the contract you want to deploy
1016     *@param _amount is the amount of Ether on each side of the contract initially
1017     */
1018     function Initiate(uint _startDate, uint _amount) payable public{
1019         uint _fee = factory.fee();
1020         require(msg.value == _amount.mul(2) + _fee);
1021         address _swapadd = factory.deployContract.value(_fee)(_startDate,msg.sender);
1022         swap = TokenToTokenSwap_Interface(_swapadd);
1023         address token_address = factory.token();
1024         baseToken = Wrapped_Ether(token_address);
1025         baseToken.createToken.value(_amount.mul(2))();
1026         baseToken.transfer(_swapadd,_amount.mul(2));
1027         swap.createSwap(_amount, msg.sender);
1028         emit StartContract(_swapadd,_amount);
1029     }
1030 
1031 
1032     /**
1033     *@dev Set factory address 
1034     *@param _factory_address is the factory address to clone?
1035     */
1036     function setFactory(address _factory_address) public {
1037         require (msg.sender == owner);
1038         factory_address = _factory_address;
1039         factory = Factory(factory_address);
1040     }
1041 }