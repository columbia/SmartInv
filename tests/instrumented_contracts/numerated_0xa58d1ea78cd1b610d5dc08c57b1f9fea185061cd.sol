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
407 
408     /*Functions*/
409     /**
410     *@dev Constructor - sets values for token name and token supply, as well as the 
411     *factory_contract, the swap.
412     *@param _factory 
413     */
414     constructor() public {
415         drct.startToken(msg.sender);
416     }
417 
418     /**
419     *@dev Token Creator - This function is called by the factory contract and creates new tokens
420     *for the user
421     *@param _supply amount of DRCT tokens created by the factory contract for this swap
422     *@param _owner address
423     *@param _swap address
424     */
425     function createToken(uint _supply, address _owner, address _swap) public{
426         drct.createToken(_supply,_owner,_swap);
427     }
428 
429     /**
430     *@dev gets the factory address
431     */
432     function getFactoryAddress() external view returns(address){
433         return drct.getFactoryAddress();
434     }
435 
436     /**
437     *@dev Called by the factory contract, and pays out to a _party
438     *@param _party being paid
439     *@param _swap address
440     */
441     function pay(address _party, address _swap) public{
442         drct.pay(_party,_swap);
443     }
444 
445     /**
446     *@dev Returns the users total balance (sum of tokens in all swaps the user has tokens in)
447     *@param _owner user address
448     *@return user total balance
449     */
450     function balanceOf(address _owner) public constant returns (uint balance) {
451        return drct.balanceOf(_owner);
452      }
453 
454     /**
455     *@dev Getter for the total_supply of tokens in the contract
456     *@return total supply
457     */
458     function totalSupply() public constant returns (uint _total_supply) {
459        return drct.totalSupply();
460     }
461 
462     /**
463     *ERC20 compliant transfer function
464     *@param _to Address to send funds to
465     *@param _amount Amount of token to send
466     *@return true for successful
467     */
468     function transfer(address _to, uint _amount) public returns (bool) {
469         return drct.transfer(_to,_amount);
470     }
471 
472     /**
473     *@dev ERC20 compliant transferFrom function
474     *@param _from address to send funds from (must be allowed, see approve function)
475     *@param _to address to send funds to
476     *@param _amount amount of token to send
477     *@return true for successful transfer
478     */
479     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
480         return drct.transferFrom(_from,_to,_amount);
481     }
482 
483     /**
484     *@dev ERC20 compliant approve function
485     *@param _spender party that msg.sender approves for transferring funds
486     *@param _amount amount of token to approve for sending
487     *@return true for successful
488     */
489     function approve(address _spender, uint _amount) public returns (bool) {
490         return drct.approve(_spender,_amount);
491     }
492 
493     /**
494     *@dev Counts addresses involved in the swap based on the length of balances array for _swap
495     *@param _swap address
496     *@return the length of the balances array for the swap
497     */
498     function addressCount(address _swap) public constant returns (uint) { 
499         return drct.addressCount(_swap); 
500     }
501 
502     /**
503     *@dev Gets the owner address and amount by specifying the swap address and index
504     *@param _ind specified index in the swap
505     *@param _swap specified swap address
506     *@return the amount to transfer associated with a particular index in a particular swap
507     *@return the owner address associated with a particular index in a particular swap
508     */
509     function getBalanceAndHolderByIndex(uint _ind, address _swap) public constant returns (uint, address) {
510         return drct.getBalanceAndHolderByIndex(_ind,_swap);
511     }
512 
513     /**
514     *@dev Gets the index by specifying the swap and owner addresses
515     *@param _owner specifed address
516     *@param _swap  specified swap address
517     *@return the index associated with the _owner address in a particular swap
518     */
519     function getIndexByAddress(address _owner, address _swap) public constant returns (uint) {
520         return drct.getIndexByAddress(_owner,_swap); 
521     }
522 
523     /**
524     *@dev Look up how much the spender or contract is allowed to spend?
525     *@param _owner address
526     *@param _spender party approved for transfering funds 
527     *@return the allowed amount _spender can spend of _owner's balance
528     */
529     function allowance(address _owner, address _spender) public constant returns (uint) {
530         return drct.allowance(_owner,_spender); 
531     }
532 }
533 
534 // File: contracts\interfaces\Deployer_Interface.sol
535 
536 //Swap Deployer functions - descriptions can be found in Deployer.sol
537 interface Deployer_Interface {
538   function newContract(address _party, address user_contract, uint _start_date) external payable returns (address);
539 }
540 
541 // File: contracts\interfaces\Membership_Interface.sol
542 
543 interface Membership_Interface {
544     function getMembershipType(address _member) external constant returns(uint);
545 }
546 
547 // File: contracts\interfaces\Wrapped_Ether_Interface.sol
548 
549 //ERC20 function interface with create token and withdraw
550 interface Wrapped_Ether_Interface {
551   function totalSupply() external constant returns (uint);
552   function balanceOf(address _owner) external constant returns (uint);
553   function transfer(address _to, uint _amount) external returns (bool);
554   function transferFrom(address _from, address _to, uint _amount) external returns (bool);
555   function approve(address _spender, uint _amount) external returns (bool);
556   function allowance(address _owner, address _spender) external constant returns (uint);
557   function withdraw(uint _value) external;
558   function createToken() external;
559 
560 }
561 
562 // File: contracts\Factory.sol
563 
564 /**
565 *The Factory contract sets the standardized variables and also deploys new contracts based on
566 *these variables for the user.  
567 */
568 contract Factory {
569     using SafeMath for uint256;
570     
571     /*Variables*/
572     //Addresses of the Factory owner and oracle. For oracle information, 
573     //check www.github.com/DecentralizedDerivatives/Oracles
574     address public owner;
575     address public oracle_address;
576     //Address of the user contract
577     address public user_contract;
578     //Address of the deployer contract
579     address internal deployer_address;
580     Deployer_Interface internal deployer;
581     address public token;
582     //A fee for creating a swap in wei.  Plan is for this to be zero, however can be raised to prevent spam
583     uint public fee;
584     //swap fee
585     uint public swapFee;
586     //Duration of swap contract in days
587     uint public duration;
588     //Multiplier of reference rate.  2x refers to a 50% move generating a 100% move in the contract payout values
589     uint public multiplier;
590     //Token_ratio refers to the number of DRCT Tokens a party will get based on the number of base tokens.  As an example, 1e15 indicates that a party will get 1000 DRCT Tokens based upon 1 ether of wrapped wei. 
591     uint public token_ratio;
592     //Array of deployed contracts
593     address[] public contracts;
594     uint[] public startDates;
595     address public memberContract;
596     uint whitelistedTypes;
597     mapping(address => uint) public created_contracts;
598     mapping(address => uint) public token_dates;
599     mapping(uint => address) public long_tokens;
600     mapping(uint => address) public short_tokens;
601     mapping(address => uint) public token_type; //1=short 2=long
602 
603     /*Events*/
604     //Emitted when a Swap is created
605     event ContractCreation(address _sender, address _created);
606 
607     /*Modifiers*/
608     modifier onlyOwner() {
609         require(msg.sender == owner);
610         _;
611     }
612 
613     /*Functions*/
614     /**
615     *@dev Sets the member type/permissions for those whitelisted and owner
616     *@param _memberTypes is the list of member types
617     */
618      constructor(uint _memberTypes) public {
619         owner = msg.sender;
620         whitelistedTypes=_memberTypes;
621     }
622 
623     /**
624     *@dev constructor function for cloned factory
625     */
626     function init(address _owner, uint _memberTypes) public{
627         require(owner == address(0));
628         owner = _owner;
629         whitelistedTypes=_memberTypes;
630     }
631 
632     /**
633     *@dev Sets the Membership contract address
634     *@param _memberContract The new membership address
635     */
636     function setMemberContract(address _memberContract) public onlyOwner() {
637         memberContract = _memberContract;
638     }
639 
640 
641     /**
642     *@dev Checks the membership type/permissions for whitelisted members
643     *@param _member address to get membership type from
644     */
645     function isWhitelisted(address _member) public view returns (bool){
646         Membership_Interface Member = Membership_Interface(memberContract);
647         return Member.getMembershipType(_member)>= whitelistedTypes;
648     }
649  
650     /**
651     *@dev Gets long and short token addresses based on specified date
652     *@param _date 
653     *@return short and long tokens' addresses
654     */
655     function getTokens(uint _date) public view returns(address, address){
656         return(long_tokens[_date],short_tokens[_date]);
657     }
658 
659     /**
660     *@dev Gets the type of Token (long and short token) for the specifed 
661     *token address
662     *@param _token address 
663     *@return token type short = 1 and long = 2
664     */
665     function getTokenType(address _token) public view returns(uint){
666         return(token_type[_token]);
667     }
668 
669     /**
670     *@dev Updates the fee amount
671     *@param _fee is the new fee amount
672     */
673     function setFee(uint _fee) public onlyOwner() {
674         fee = _fee;
675     }
676 
677     /**
678     *@dev Updates the swap fee amount
679     *@param _swapFee is the new swap fee amount
680     */
681     function setSwapFee(uint _swapFee) public onlyOwner() {
682         swapFee = _swapFee;
683     }   
684 
685     /**
686     *@dev Sets the deployer address
687     *@param _deployer is the new deployer address
688     */
689     function setDeployer(address _deployer) public onlyOwner() {
690         deployer_address = _deployer;
691         deployer = Deployer_Interface(_deployer);
692     }
693 
694     /**
695     *@dev Sets the user_contract address
696     *@param _userContract is the new userContract address
697     */
698     function setUserContract(address _userContract) public onlyOwner() {
699         user_contract = _userContract;
700     }
701 
702     /**
703     *@dev Sets token ratio, swap duration, and multiplier variables for a swap.
704     *@param _token_ratio the ratio of the tokens
705     *@param _duration the duration of the swap, in days
706     *@param _multiplier the multiplier used for the swap
707     *@param _swapFee the swap fee
708     */
709     function setVariables(uint _token_ratio, uint _duration, uint _multiplier, uint _swapFee) public onlyOwner() {
710         require(_swapFee < 10000);
711         token_ratio = _token_ratio;
712         duration = _duration;
713         multiplier = _multiplier;
714         swapFee = _swapFee;
715     }
716 
717     /**
718     *@dev Sets the address of the base tokens used for the swap
719     *@param _token The address of a token to be used  as collateral
720     */
721     function setBaseToken(address _token) public onlyOwner() {
722         token = _token;
723     }
724 
725     /**
726     *@dev Allows a user to deploy a new swap contract, if they pay the fee
727     *@param _start_date the contract start date 
728     *@return new_contract address for he newly created swap address and calls 
729     *event 'ContractCreation'
730     */
731     function deployContract(uint _start_date) public payable returns (address) {
732         require(msg.value >= fee && isWhitelisted(msg.sender));
733         require(_start_date % 86400 == 0);
734         address new_contract = deployer.newContract(msg.sender, user_contract, _start_date);
735         contracts.push(new_contract);
736         created_contracts[new_contract] = _start_date;
737         emit ContractCreation(msg.sender,new_contract);
738         return new_contract;
739     }
740 
741     /**
742     *@dev Deploys DRCT tokens for given start date
743     *@param _start_date of contract
744     */
745     function deployTokenContract(uint _start_date) public{
746         address _token;
747         require(_start_date % 86400 == 0);
748         require(long_tokens[_start_date] == address(0) && short_tokens[_start_date] == address(0));
749         _token = new DRCT_Token();
750         token_dates[_token] = _start_date;
751         long_tokens[_start_date] = _token;
752         token_type[_token]=2;
753         _token = new DRCT_Token();
754         token_type[_token]=1;
755         short_tokens[_start_date] = _token;
756         token_dates[_token] = _start_date;
757         startDates.push(_start_date);
758 
759     }
760 
761     /**
762     *@dev Deploys new tokens on a DRCT_Token contract -- called from within a swap
763     *@param _supply The number of tokens to create
764     *@param _party the address to send the tokens to
765     *@param _start_date the start date of the contract      
766     *@returns ltoken the address of the created DRCT long tokens
767     *@returns stoken the address of the created DRCT short tokens
768     *@returns token_ratio The ratio of the created DRCT token
769     */
770     function createToken(uint _supply, address _party, uint _start_date) public returns (address, address, uint) {
771         require(created_contracts[msg.sender] == _start_date);
772         address ltoken = long_tokens[_start_date];
773         address stoken = short_tokens[_start_date];
774         require(ltoken != address(0) && stoken != address(0));
775             DRCT_Token drct_interface = DRCT_Token(ltoken);
776             drct_interface.createToken(_supply.div(token_ratio), _party,msg.sender);
777             drct_interface = DRCT_Token(stoken);
778             drct_interface.createToken(_supply.div(token_ratio), _party,msg.sender);
779         return (ltoken, stoken, token_ratio);
780     }
781   
782     /**
783     *@dev Allows the owner to set a new oracle address
784     *@param _new_oracle_address 
785     */
786     function setOracleAddress(address _new_oracle_address) public onlyOwner() {
787         oracle_address = _new_oracle_address; 
788     }
789 
790     /**
791     *@dev Allows the owner to set a new owner address
792     *@param _new_owner the new owner address
793     */
794     function setOwner(address _new_owner) public onlyOwner() { 
795         owner = _new_owner; 
796     }
797 
798     /**
799     *@dev Allows the owner to pull contract creation fees
800     *@return the withdrawal fee _val and the balance where is the return function?
801     */
802     function withdrawFees() public onlyOwner(){
803         Wrapped_Ether_Interface token_interface = Wrapped_Ether_Interface(token);
804         uint _val = token_interface.balanceOf(address(this));
805         if(_val > 0){
806             token_interface.withdraw(_val);
807         }
808         owner.transfer(address(this).balance);
809      }
810 
811     /**
812     *@dev fallback function
813     */ 
814     function() public payable {
815     }
816 
817     /**
818     *@dev Returns a tuple of many private variables.
819     *The variables from this function are pass through to the TokenLibrary.getVariables function
820     *@returns oracle_adress is the address of the oracle
821     *@returns duration is the duration of the swap
822     *@returns multiplier is the multiplier for the swap
823     *@returns token is the address of token
824     *@returns _swapFee is the swap fee 
825     */
826     function getVariables() public view returns (address, uint, uint, address,uint){
827         return (oracle_address,duration, multiplier, token,swapFee);
828     }
829 
830     /**
831     *@dev Pays out to a DRCT token
832     *@param _party is the address being paid
833     *@param _token_add token to pay out
834     */
835     function payToken(address _party, address _token_add) public {
836         require(created_contracts[msg.sender] > 0);
837         DRCT_Token drct_interface = DRCT_Token(_token_add);
838         drct_interface.pay(_party, msg.sender);
839     }
840 
841     /**
842     *@dev Counts number of contacts created by this factory
843     *@return the number of contracts
844     */
845     function getCount() public constant returns(uint) {
846         return contracts.length;
847     }
848 
849     /**
850     *@dev Counts number of start dates in this factory
851     *@return the number of active start dates
852     */
853     function getDateCount() public constant returns(uint) {
854         return startDates.length;
855     }
856 }