1 pragma solidity ^0.4.24;
2 
3 // File: contracts\CloneFactory.sol
4 
5 /**
6 *This contracts helps clone factories and swaps through the Deployer.sol and MasterDeployer.sol.
7 *The address of the targeted contract to clone has to be provided.
8 */
9 contract CloneFactory {
10 
11     /*Variables*/
12     address internal owner;
13     
14     /*Events*/
15     event CloneCreated(address indexed target, address clone);
16 
17     /*Modifiers*/
18     modifier onlyOwner() {
19         require(msg.sender == owner);
20         _;
21     }
22     
23     /*Functions*/
24     constructor() public{
25         owner = msg.sender;
26     }    
27     
28     /**
29     *@dev Allows the owner to set a new owner address
30     *@param _owner the new owner address
31     */
32     function setOwner(address _owner) public onlyOwner(){
33         owner = _owner;
34     }
35 
36     /**
37     *@dev Creates factory clone
38     *@param _target is the address being cloned
39     *@return address for clone
40     */
41     function createClone(address target) internal returns (address result) {
42         bytes memory clone = hex"600034603b57603080600f833981f36000368180378080368173bebebebebebebebebebebebebebebebebebebebe5af43d82803e15602c573d90f35b3d90fd";
43         bytes20 targetBytes = bytes20(target);
44         for (uint i = 0; i < 20; i++) {
45             clone[26 + i] = targetBytes[i];
46         }
47         assembly {
48             let len := mload(clone)
49             let data := add(clone, 0x20)
50             result := create(0, data, len)
51         }
52     }
53 }
54 
55 // File: contracts\interfaces\Factory_Interface.sol
56 
57 //Swap factory functions - descriptions can be found in Factory.sol
58 interface Factory_Interface {
59   function createToken(uint _supply, address _party, uint _start_date) external returns (address,address, uint);
60   function payToken(address _party, address _token_add) external;
61   function deployContract(uint _start_date) external payable returns (address);
62    function getBase() external view returns(address);
63   function getVariables() external view returns (address, uint, uint, address,uint);
64   function isWhitelisted(address _member) external view returns (bool);
65 }
66 
67 // File: contracts\libraries\SafeMath.sol
68 
69 //Slightly modified SafeMath library - includes a min function
70 library SafeMath {
71   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72     uint256 c = a * b;
73     assert(a == 0 || c / a == b);
74     return c;
75   }
76 
77   function div(uint256 a, uint256 b) internal pure returns (uint256) {
78     // assert(b > 0); // Solidity automatically throws when dividing by 0
79     uint256 c = a / b;
80     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81     return c;
82   }
83 
84   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85     assert(b <= a);
86     return a - b;
87   }
88 
89   function add(uint256 a, uint256 b) internal pure returns (uint256) {
90     uint256 c = a + b;
91     assert(c >= a);
92     return c;
93   }
94 
95   function min(uint a, uint b) internal pure returns (uint256) {
96     return a < b ? a : b;
97   }
98 }
99 
100 // File: contracts\libraries\DRCTLibrary.sol
101 
102 /**
103 *The DRCTLibrary contains the reference code used in the DRCT_Token (an ERC20 compliant token
104 *representing the payout of the swap contract specified in the Factory contract).
105 */
106 library DRCTLibrary{
107 
108     using SafeMath for uint256;
109 
110     /*Structs*/
111     /**
112     *@dev Keeps track of balance amounts in the balances array
113     */
114     struct Balance {
115         address owner;
116         uint amount;
117         }
118 
119     struct TokenStorage{
120         //This is the factory contract that the token is standardized at
121         address factory_contract;
122         //Total supply of outstanding tokens in the contract
123         uint total_supply;
124         //Mapping from: swap address -> user balance struct (index for a particular user's balance can be found in swap_balances_index)
125         mapping(address => Balance[]) swap_balances;
126         //Mapping from: swap address -> user -> swap_balances index
127         mapping(address => mapping(address => uint)) swap_balances_index;
128         //Mapping from: user -> dynamic array of swap addresses (index for a particular swap can be found in user_swaps_index)
129         mapping(address => address[]) user_swaps;
130         //Mapping from: user -> swap address -> user_swaps index
131         mapping(address => mapping(address => uint)) user_swaps_index;
132         //Mapping from: user -> total balance accross all entered swaps
133         mapping(address => uint) user_total_balances;
134         //Mapping from: owner -> spender -> amount allowed
135         mapping(address => mapping(address => uint)) allowed;
136     }   
137 
138     /*Events*/
139     /**
140     *@dev events for transfer and approvals
141     */
142     event Transfer(address indexed _from, address indexed _to, uint _value);
143     event Approval(address indexed _owner, address indexed _spender, uint _value);
144     event CreateToken(address _from, uint _value);
145     
146     /*Functions*/
147     /**
148     *@dev Constructor - sets values for token name and token supply, as well as the 
149     *factory_contract, the swap.
150     *@param _factory 
151     */
152     function startToken(TokenStorage storage self,address _factory) public {
153         self.factory_contract = _factory;
154     }
155 
156     /**
157     *@dev ensures the member is whitelisted
158     *@param _member is the member address that is chekced agaist the whitelist
159     */
160     function isWhitelisted(TokenStorage storage self,address _member) internal view returns(bool){
161         Factory_Interface _factory = Factory_Interface(self.factory_contract);
162         return _factory.isWhitelisted(_member);
163     }
164 
165     /**
166     *@dev gets the factory address
167     */
168     function getFactoryAddress(TokenStorage storage self) external view returns(address){
169         return self.factory_contract;
170     }
171 
172     /**
173     *@dev Token Creator - This function is called by the factory contract and creates new tokens
174     *for the user
175     *@param _supply amount of DRCT tokens created by the factory contract for this swap
176     *@param _owner address
177     *@param _swap address
178     */
179     function createToken(TokenStorage storage self,uint _supply, address _owner, address _swap) public{
180         require(msg.sender == self.factory_contract);
181         //Update total supply of DRCT Tokens
182         self.total_supply = self.total_supply.add(_supply);
183         //Update the total balance of the owner
184         self.user_total_balances[_owner] = self.user_total_balances[_owner].add(_supply);
185         //If the user has not entered any swaps already, push a zeroed address to their user_swaps mapping to prevent default value conflicts in user_swaps_index
186         if (self.user_swaps[_owner].length == 0)
187             self.user_swaps[_owner].push(address(0x0));
188         //Add a new swap index for the owner
189         self.user_swaps_index[_owner][_swap] = self.user_swaps[_owner].length;
190         //Push a new swap address to the owner's swaps
191         self.user_swaps[_owner].push(_swap);
192         //Push a zeroed Balance struct to the swap balances mapping to prevent default value conflicts in swap_balances_index
193         self.swap_balances[_swap].push(Balance({
194             owner: 0,
195             amount: 0
196         }));
197         //Add a new owner balance index for the swap
198         self.swap_balances_index[_swap][_owner] = 1;
199         //Push the owner's balance to the swap
200         self.swap_balances[_swap].push(Balance({
201             owner: _owner,
202             amount: _supply
203         }));
204         emit CreateToken(_owner,_supply);
205     }
206 
207     /**
208     *@dev Called by the factory contract, and pays out to a _party
209     *@param _party being paid
210     *@param _swap address
211     */
212     function pay(TokenStorage storage self,address _party, address _swap) public{
213         require(msg.sender == self.factory_contract);
214         uint party_balance_index = self.swap_balances_index[_swap][_party];
215         require(party_balance_index > 0);
216         uint party_swap_balance = self.swap_balances[_swap][party_balance_index].amount;
217         //reduces the users totals balance by the amount in that swap
218         self.user_total_balances[_party] = self.user_total_balances[_party].sub(party_swap_balance);
219         //reduces the total supply by the amount of that users in that swap
220         self.total_supply = self.total_supply.sub(party_swap_balance);
221         //sets the partys balance to zero for that specific swaps party balances
222         self.swap_balances[_swap][party_balance_index].amount = 0;
223     }
224 
225     /**
226     *@dev Returns the users total balance (sum of tokens in all swaps the user has tokens in)
227     *@param _owner user address
228     *@return user total balance
229     */
230     function balanceOf(TokenStorage storage self,address _owner) public constant returns (uint balance) {
231        return self.user_total_balances[_owner]; 
232      }
233 
234     /**
235     *@dev Getter for the total_supply of tokens in the contract
236     *@return total supply
237     */
238     function totalSupply(TokenStorage storage self) public constant returns (uint _total_supply) {
239        return self.total_supply;
240     }
241 
242     /**
243     *@dev Removes the address from the swap balances for a swap, and moves the last address in the
244     *swap into their place
245     *@param _remove address of prevous owner
246     *@param _swap address used to get last addrss of the swap to replace the removed address
247     */
248     function removeFromSwapBalances(TokenStorage storage self,address _remove, address _swap) internal {
249         uint last_address_index = self.swap_balances[_swap].length.sub(1);
250         address last_address = self.swap_balances[_swap][last_address_index].owner;
251         //If the address we want to remove is the final address in the swap
252         if (last_address != _remove) {
253             uint remove_index = self.swap_balances_index[_swap][_remove];
254             //Update the swap's balance index of the last address to that of the removed address index
255             self.swap_balances_index[_swap][last_address] = remove_index;
256             //Set the swap's Balance struct at the removed index to the Balance struct of the last address
257             self.swap_balances[_swap][remove_index] = self.swap_balances[_swap][last_address_index];
258         }
259         //Remove the swap_balances index for this address
260         delete self.swap_balances_index[_swap][_remove];
261         //Finally, decrement the swap balances length
262         self.swap_balances[_swap].length = self.swap_balances[_swap].length.sub(1);
263     }
264 
265     /**
266     *@dev This is the main function to update the mappings when a transfer happens
267     *@param _from address to send funds from
268     *@param _to address to send funds to
269     *@param _amount amount of token to send
270     */
271     function transferHelper(TokenStorage storage self,address _from, address _to, uint _amount) internal {
272         //Get memory copies of the swap arrays for the sender and reciever
273         address[] memory from_swaps = self.user_swaps[_from];
274         //Iterate over sender's swaps in reverse order until enough tokens have been transferred
275         for (uint i = from_swaps.length.sub(1); i > 0; i--) {
276             //Get the index of the sender's balance for the current swap
277             uint from_swap_user_index = self.swap_balances_index[from_swaps[i]][_from];
278             Balance memory from_user_bal = self.swap_balances[from_swaps[i]][from_swap_user_index];
279             //If the current swap will be entirely depleted - we remove all references to it for the sender
280             if (_amount >= from_user_bal.amount) {
281                 _amount -= from_user_bal.amount;
282                 //If this swap is to be removed, we know it is the (current) last swap in the user's user_swaps list, so we can simply decrement the length to remove it
283                 self.user_swaps[_from].length = self.user_swaps[_from].length.sub(1);
284                 //Remove the user swap index for this swap
285                 delete self.user_swaps_index[_from][from_swaps[i]];
286                 //If the _to address already holds tokens from this swap
287                 if (self.user_swaps_index[_to][from_swaps[i]] != 0) {
288                     //Get the index of the _to balance in this swap
289                     uint to_balance_index = self.swap_balances_index[from_swaps[i]][_to];
290                     assert(to_balance_index != 0);
291                     //Add the _from tokens to _to
292                     self.swap_balances[from_swaps[i]][to_balance_index].amount = self.swap_balances[from_swaps[i]][to_balance_index].amount.add(from_user_bal.amount);
293                     //Remove the _from address from this swap's balance array
294                     removeFromSwapBalances(self,_from, from_swaps[i]);
295                 } else {
296                     //Prepare to add a new swap by assigning the swap an index for _to
297                     if (self.user_swaps[_to].length == 0){
298                         self.user_swaps[_to].push(address(0x0));
299                     }
300                 self.user_swaps_index[_to][from_swaps[i]] = self.user_swaps[_to].length;
301                 //Add the new swap to _to
302                 self.user_swaps[_to].push(from_swaps[i]);
303                 //Give the reciever the sender's balance for this swap
304                 self.swap_balances[from_swaps[i]][from_swap_user_index].owner = _to;
305                 //Give the reciever the sender's swap balance index for this swap
306                 self.swap_balances_index[from_swaps[i]][_to] = self.swap_balances_index[from_swaps[i]][_from];
307                 //Remove the swap balance index from the sending party
308                 delete self.swap_balances_index[from_swaps[i]][_from];
309             }
310             //If there is no more remaining to be removed, we break out of the loop
311             if (_amount == 0)
312                 break;
313             } else {
314                 //The amount in this swap is more than the amount we still need to transfer
315                 uint to_swap_balance_index = self.swap_balances_index[from_swaps[i]][_to];
316                 //If the _to address already holds tokens from this swap
317                 if (self.user_swaps_index[_to][from_swaps[i]] != 0) {
318                     //Because both addresses are in this swap, and neither will be removed, we simply update both swap balances
319                     self.swap_balances[from_swaps[i]][to_swap_balance_index].amount = self.swap_balances[from_swaps[i]][to_swap_balance_index].amount.add(_amount);
320                 } else {
321                     //Prepare to add a new swap by assigning the swap an index for _to
322                     if (self.user_swaps[_to].length == 0){
323                         self.user_swaps[_to].push(address(0x0));
324                     }
325                     self.user_swaps_index[_to][from_swaps[i]] = self.user_swaps[_to].length;
326                     //And push the new swap
327                     self.user_swaps[_to].push(from_swaps[i]);
328                     //_to is not in this swap, so we give this swap a new balance index for _to
329                     self.swap_balances_index[from_swaps[i]][_to] = self.swap_balances[from_swaps[i]].length;
330                     //And push a new balance for _to
331                     self.swap_balances[from_swaps[i]].push(Balance({
332                         owner: _to,
333                         amount: _amount
334                     }));
335                 }
336                 //Finally, update the _from user's swap balance
337                 self.swap_balances[from_swaps[i]][from_swap_user_index].amount = self.swap_balances[from_swaps[i]][from_swap_user_index].amount.sub(_amount);
338                 //Because we have transferred the last of the amount to the reciever, we break;
339                 break;
340             }
341         }
342     }
343 
344     /**
345     *@dev ERC20 compliant transfer function
346     *@param _to Address to send funds to
347     *@param _amount Amount of token to send
348     *@return true for successful
349     */
350     function transfer(TokenStorage storage self, address _to, uint _amount) public returns (bool) {
351         require(isWhitelisted(self,_to));
352         uint balance_owner = self.user_total_balances[msg.sender];
353         if (
354             _to == msg.sender ||
355             _to == address(0) ||
356             _amount == 0 ||
357             balance_owner < _amount
358         ) return false;
359         transferHelper(self,msg.sender, _to, _amount);
360         self.user_total_balances[msg.sender] = self.user_total_balances[msg.sender].sub(_amount);
361         self.user_total_balances[_to] = self.user_total_balances[_to].add(_amount);
362         emit Transfer(msg.sender, _to, _amount);
363         return true;
364     }
365     /**
366     *@dev ERC20 compliant transferFrom function
367     *@param _from address to send funds from (must be allowed, see approve function)
368     *@param _to address to send funds to
369     *@param _amount amount of token to send
370     *@return true for successful
371     */
372     function transferFrom(TokenStorage storage self, address _from, address _to, uint _amount) public returns (bool) {
373         require(isWhitelisted(self,_to));
374         uint balance_owner = self.user_total_balances[_from];
375         uint sender_allowed = self.allowed[_from][msg.sender];
376         if (
377             _to == _from ||
378             _to == address(0) ||
379             _amount == 0 ||
380             balance_owner < _amount ||
381             sender_allowed < _amount
382         ) return false;
383         transferHelper(self,_from, _to, _amount);
384         self.user_total_balances[_from] = self.user_total_balances[_from].sub(_amount);
385         self.user_total_balances[_to] = self.user_total_balances[_to].add(_amount);
386         self.allowed[_from][msg.sender] = self.allowed[_from][msg.sender].sub(_amount);
387         emit Transfer(_from, _to, _amount);
388         return true;
389     }
390 
391     /**
392     *@dev ERC20 compliant approve function
393     *@param _spender party that msg.sender approves for transferring funds
394     *@param _amount amount of token to approve for sending
395     *@return true for successful
396     */
397     function approve(TokenStorage storage self, address _spender, uint _amount) public returns (bool) {
398         self.allowed[msg.sender][_spender] = _amount;
399         emit Approval(msg.sender, _spender, _amount);
400         return true;
401     }
402 
403     /**
404     *@dev Counts addresses involved in the swap based on the length of balances array for _swap
405     *@param _swap address
406     *@return the length of the balances array for the swap
407     */
408     function addressCount(TokenStorage storage self, address _swap) public constant returns (uint) { 
409         return self.swap_balances[_swap].length; 
410     }
411 
412     /**
413     *@dev Gets the owner address and amount by specifying the swap address and index
414     *@param _ind specified index in the swap
415     *@param _swap specified swap address
416     *@return the owner address associated with a particular index in a particular swap
417     *@return the amount to transfer associated with a particular index in a particular swap
418     */
419     function getBalanceAndHolderByIndex(TokenStorage storage self, uint _ind, address _swap) public constant returns (uint, address) {
420         return (self.swap_balances[_swap][_ind].amount, self.swap_balances[_swap][_ind].owner);
421     }
422 
423     /**
424     *@dev Gets the index by specifying the swap and owner addresses
425     *@param _owner specifed address
426     *@param _swap  specified swap address
427     *@return the index associated with the _owner address in a particular swap
428     */
429     function getIndexByAddress(TokenStorage storage self, address _owner, address _swap) public constant returns (uint) {
430         return self.swap_balances_index[_swap][_owner]; 
431     }
432 
433     /**
434     *@dev Look up how much the spender or contract is allowed to spend?
435     *@param _owner 
436     *@param _spender party approved for transfering funds 
437     *@return the allowed amount _spender can spend of _owner's balance
438     */
439     function allowance(TokenStorage storage self, address _owner, address _spender) public constant returns (uint) {
440         return self.allowed[_owner][_spender]; 
441     }
442 }
443 
444 // File: contracts\DRCT_Token.sol
445 
446 /**
447 *The DRCT_Token is an ERC20 compliant token representing the payout of the swap contract
448 *specified in the Factory contract.
449 *Each Factory contract is specified one DRCT Token and the token address can contain many
450 *different swap contracts that are standardized at the Factory level.
451 *The logic for the functions in this contract is housed in the DRCTLibary.sol.
452 */
453 contract DRCT_Token {
454 
455     using DRCTLibrary for DRCTLibrary.TokenStorage;
456 
457     /*Variables*/
458     DRCTLibrary.TokenStorage public drct;
459 
460     /*Functions*/
461     /**
462     *@dev Constructor - sets values for token name and token supply, as well as the 
463     *factory_contract, the swap.
464     *@param _factory 
465     */
466     constructor() public {
467         drct.startToken(msg.sender);
468     }
469 
470     /**
471     *@dev Token Creator - This function is called by the factory contract and creates new tokens
472     *for the user
473     *@param _supply amount of DRCT tokens created by the factory contract for this swap
474     *@param _owner address
475     *@param _swap address
476     */
477     function createToken(uint _supply, address _owner, address _swap) public{
478         drct.createToken(_supply,_owner,_swap);
479     }
480 
481     /**
482     *@dev gets the factory address
483     */
484     function getFactoryAddress() external view returns(address){
485         return drct.getFactoryAddress();
486     }
487 
488     /**
489     *@dev Called by the factory contract, and pays out to a _party
490     *@param _party being paid
491     *@param _swap address
492     */
493     function pay(address _party, address _swap) public{
494         drct.pay(_party,_swap);
495     }
496 
497     /**
498     *@dev Returns the users total balance (sum of tokens in all swaps the user has tokens in)
499     *@param _owner user address
500     *@return user total balance
501     */
502     function balanceOf(address _owner) public constant returns (uint balance) {
503        return drct.balanceOf(_owner);
504      }
505 
506     /**
507     *@dev Getter for the total_supply of tokens in the contract
508     *@return total supply
509     */
510     function totalSupply() public constant returns (uint _total_supply) {
511        return drct.totalSupply();
512     }
513 
514     /**
515     *ERC20 compliant transfer function
516     *@param _to Address to send funds to
517     *@param _amount Amount of token to send
518     *@return true for successful
519     */
520     function transfer(address _to, uint _amount) public returns (bool) {
521         return drct.transfer(_to,_amount);
522     }
523 
524     /**
525     *@dev ERC20 compliant transferFrom function
526     *@param _from address to send funds from (must be allowed, see approve function)
527     *@param _to address to send funds to
528     *@param _amount amount of token to send
529     *@return true for successful transfer
530     */
531     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
532         return drct.transferFrom(_from,_to,_amount);
533     }
534 
535     /**
536     *@dev ERC20 compliant approve function
537     *@param _spender party that msg.sender approves for transferring funds
538     *@param _amount amount of token to approve for sending
539     *@return true for successful
540     */
541     function approve(address _spender, uint _amount) public returns (bool) {
542         return drct.approve(_spender,_amount);
543     }
544 
545     /**
546     *@dev Counts addresses involved in the swap based on the length of balances array for _swap
547     *@param _swap address
548     *@return the length of the balances array for the swap
549     */
550     function addressCount(address _swap) public constant returns (uint) { 
551         return drct.addressCount(_swap); 
552     }
553 
554     /**
555     *@dev Gets the owner address and amount by specifying the swap address and index
556     *@param _ind specified index in the swap
557     *@param _swap specified swap address
558     *@return the amount to transfer associated with a particular index in a particular swap
559     *@return the owner address associated with a particular index in a particular swap
560     */
561     function getBalanceAndHolderByIndex(uint _ind, address _swap) public constant returns (uint, address) {
562         return drct.getBalanceAndHolderByIndex(_ind,_swap);
563     }
564 
565     /**
566     *@dev Gets the index by specifying the swap and owner addresses
567     *@param _owner specifed address
568     *@param _swap  specified swap address
569     *@return the index associated with the _owner address in a particular swap
570     */
571     function getIndexByAddress(address _owner, address _swap) public constant returns (uint) {
572         return drct.getIndexByAddress(_owner,_swap); 
573     }
574 
575     /**
576     *@dev Look up how much the spender or contract is allowed to spend?
577     *@param _owner address
578     *@param _spender party approved for transfering funds 
579     *@return the allowed amount _spender can spend of _owner's balance
580     */
581     function allowance(address _owner, address _spender) public constant returns (uint) {
582         return drct.allowance(_owner,_spender); 
583     }
584 }
585 
586 // File: contracts\interfaces\Deployer_Interface.sol
587 
588 //Swap Deployer functions - descriptions can be found in Deployer.sol
589 interface Deployer_Interface {
590   function newContract(address _party, address user_contract, uint _start_date) external payable returns (address);
591 }
592 
593 // File: contracts\interfaces\Membership_Interface.sol
594 
595 interface Membership_Interface {
596     function getMembershipType(address _member) external constant returns(uint);
597 }
598 
599 // File: contracts\interfaces\Wrapped_Ether_Interface.sol
600 
601 //ERC20 function interface with create token and withdraw
602 interface Wrapped_Ether_Interface {
603   function totalSupply() external constant returns (uint);
604   function balanceOf(address _owner) external constant returns (uint);
605   function transfer(address _to, uint _amount) external returns (bool);
606   function transferFrom(address _from, address _to, uint _amount) external returns (bool);
607   function approve(address _spender, uint _amount) external returns (bool);
608   function allowance(address _owner, address _spender) external constant returns (uint);
609   function withdraw(uint _value) external;
610   function createToken() external;
611 
612 }
613 
614 // File: contracts\Factory.sol
615 
616 /**
617 *The Factory contract sets the standardized variables and also deploys new contracts based on
618 *these variables for the user.  
619 */
620 contract Factory {
621     using SafeMath for uint256;
622     
623     /*Variables*/
624     //Addresses of the Factory owner and oracle. For oracle information, 
625     //check www.github.com/DecentralizedDerivatives/Oracles
626     address public owner;
627     address public oracle_address;
628     //Address of the user contract
629     address public user_contract;
630     //Address of the deployer contract
631     address internal deployer_address;
632     Deployer_Interface internal deployer;
633     address public token;
634     //A fee for creating a swap in wei.  Plan is for this to be zero, however can be raised to prevent spam
635     uint public fee;
636     //swap fee
637     uint public swapFee;
638     //Duration of swap contract in days
639     uint public duration;
640     //Multiplier of reference rate.  2x refers to a 50% move generating a 100% move in the contract payout values
641     uint public multiplier;
642     //Token_ratio refers to the number of DRCT Tokens a party will get based on the number of base tokens.  As an example, 1e15 indicates that a party will get 1000 DRCT Tokens based upon 1 ether of wrapped wei. 
643     uint public token_ratio;
644     //Array of deployed contracts
645     address[] public contracts;
646     uint[] public startDates;
647     address public memberContract;
648     uint whitelistedTypes;
649     mapping(address => uint) public created_contracts;
650     mapping(address => uint) public token_dates;
651     mapping(uint => address) public long_tokens;
652     mapping(uint => address) public short_tokens;
653     mapping(address => uint) public token_type; //1=short 2=long
654 
655     /*Events*/
656     //Emitted when a Swap is created
657     event ContractCreation(address _sender, address _created);
658 
659     /*Modifiers*/
660     modifier onlyOwner() {
661         require(msg.sender == owner);
662         _;
663     }
664 
665     /*Functions*/
666     /**
667     *@dev Sets the member type/permissions for those whitelisted and owner
668     *@param _memberTypes is the list of member types
669     */
670      constructor(uint _memberTypes) public {
671         owner = msg.sender;
672         whitelistedTypes=_memberTypes;
673     }
674 
675     /**
676     *@dev constructor function for cloned factory
677     */
678     function init(address _owner, uint _memberTypes) public{
679         require(owner == address(0));
680         owner = _owner;
681         whitelistedTypes=_memberTypes;
682     }
683 
684     /**
685     *@dev Sets the Membership contract address
686     *@param _memberContract The new membership address
687     */
688     function setMemberContract(address _memberContract) public onlyOwner() {
689         memberContract = _memberContract;
690     }
691 
692 
693     /**
694     *@dev Checks the membership type/permissions for whitelisted members
695     *@param _member address to get membership type from
696     */
697     function isWhitelisted(address _member) public view returns (bool){
698         Membership_Interface Member = Membership_Interface(memberContract);
699         return Member.getMembershipType(_member)>= whitelistedTypes;
700     }
701  
702     /**
703     *@dev Gets long and short token addresses based on specified date
704     *@param _date 
705     *@return short and long tokens' addresses
706     */
707     function getTokens(uint _date) public view returns(address, address){
708         return(long_tokens[_date],short_tokens[_date]);
709     }
710 
711     /**
712     *@dev Gets the type of Token (long and short token) for the specifed 
713     *token address
714     *@param _token address 
715     *@return token type short = 1 and long = 2
716     */
717     function getTokenType(address _token) public view returns(uint){
718         return(token_type[_token]);
719     }
720 
721     /**
722     *@dev Updates the fee amount
723     *@param _fee is the new fee amount
724     */
725     function setFee(uint _fee) public onlyOwner() {
726         fee = _fee;
727     }
728 
729     /**
730     *@dev Updates the swap fee amount
731     *@param _swapFee is the new swap fee amount
732     */
733     function setSwapFee(uint _swapFee) public onlyOwner() {
734         swapFee = _swapFee;
735     }   
736 
737     /**
738     *@dev Sets the deployer address
739     *@param _deployer is the new deployer address
740     */
741     function setDeployer(address _deployer) public onlyOwner() {
742         deployer_address = _deployer;
743         deployer = Deployer_Interface(_deployer);
744     }
745 
746     /**
747     *@dev Sets the user_contract address
748     *@param _userContract is the new userContract address
749     */
750     function setUserContract(address _userContract) public onlyOwner() {
751         user_contract = _userContract;
752     }
753 
754     /**
755     *@dev Sets token ratio, swap duration, and multiplier variables for a swap.
756     *@param _token_ratio the ratio of the tokens
757     *@param _duration the duration of the swap, in days
758     *@param _multiplier the multiplier used for the swap
759     *@param _swapFee the swap fee
760     */
761     function setVariables(uint _token_ratio, uint _duration, uint _multiplier, uint _swapFee) public onlyOwner() {
762         require(_swapFee < 10000);
763         token_ratio = _token_ratio;
764         duration = _duration;
765         multiplier = _multiplier;
766         swapFee = _swapFee;
767     }
768 
769     /**
770     *@dev Sets the address of the base tokens used for the swap
771     *@param _token The address of a token to be used  as collateral
772     */
773     function setBaseToken(address _token) public onlyOwner() {
774         token = _token;
775     }
776 
777     /**
778     *@dev Allows a user to deploy a new swap contract, if they pay the fee
779     *@param _start_date the contract start date 
780     *@return new_contract address for he newly created swap address and calls 
781     *event 'ContractCreation'
782     */
783     function deployContract(uint _start_date) public payable returns (address) {
784         require(msg.value >= fee && isWhitelisted(msg.sender));
785         require(_start_date % 86400 == 0);
786         address new_contract = deployer.newContract(msg.sender, user_contract, _start_date);
787         contracts.push(new_contract);
788         created_contracts[new_contract] = _start_date;
789         emit ContractCreation(msg.sender,new_contract);
790         return new_contract;
791     }
792 
793     /**
794     *@dev Deploys DRCT tokens for given start date
795     *@param _start_date of contract
796     */
797     function deployTokenContract(uint _start_date) public{
798         address _token;
799         require(_start_date % 86400 == 0);
800         require(long_tokens[_start_date] == address(0) && short_tokens[_start_date] == address(0));
801         _token = new DRCT_Token();
802         token_dates[_token] = _start_date;
803         long_tokens[_start_date] = _token;
804         token_type[_token]=2;
805         _token = new DRCT_Token();
806         token_type[_token]=1;
807         short_tokens[_start_date] = _token;
808         token_dates[_token] = _start_date;
809         startDates.push(_start_date);
810 
811     }
812 
813     /**
814     *@dev Deploys new tokens on a DRCT_Token contract -- called from within a swap
815     *@param _supply The number of tokens to create
816     *@param _party the address to send the tokens to
817     *@param _start_date the start date of the contract      
818     *@returns ltoken the address of the created DRCT long tokens
819     *@returns stoken the address of the created DRCT short tokens
820     *@returns token_ratio The ratio of the created DRCT token
821     */
822     function createToken(uint _supply, address _party, uint _start_date) public returns (address, address, uint) {
823         require(created_contracts[msg.sender] == _start_date);
824         address ltoken = long_tokens[_start_date];
825         address stoken = short_tokens[_start_date];
826         require(ltoken != address(0) && stoken != address(0));
827             DRCT_Token drct_interface = DRCT_Token(ltoken);
828             drct_interface.createToken(_supply.div(token_ratio), _party,msg.sender);
829             drct_interface = DRCT_Token(stoken);
830             drct_interface.createToken(_supply.div(token_ratio), _party,msg.sender);
831         return (ltoken, stoken, token_ratio);
832     }
833   
834     /**
835     *@dev Allows the owner to set a new oracle address
836     *@param _new_oracle_address 
837     */
838     function setOracleAddress(address _new_oracle_address) public onlyOwner() {
839         oracle_address = _new_oracle_address; 
840     }
841 
842     /**
843     *@dev Allows the owner to set a new owner address
844     *@param _new_owner the new owner address
845     */
846     function setOwner(address _new_owner) public onlyOwner() { 
847         owner = _new_owner; 
848     }
849 
850     /**
851     *@dev Allows the owner to pull contract creation fees
852     *@return the withdrawal fee _val and the balance where is the return function?
853     */
854     function withdrawFees() public onlyOwner(){
855         Wrapped_Ether_Interface token_interface = Wrapped_Ether_Interface(token);
856         uint _val = token_interface.balanceOf(address(this));
857         if(_val > 0){
858             token_interface.withdraw(_val);
859         }
860         owner.transfer(address(this).balance);
861      }
862 
863     /**
864     *@dev fallback function
865     */ 
866     function() public payable {
867     }
868 
869     /**
870     *@dev Returns a tuple of many private variables.
871     *The variables from this function are pass through to the TokenLibrary.getVariables function
872     *@returns oracle_adress is the address of the oracle
873     *@returns duration is the duration of the swap
874     *@returns multiplier is the multiplier for the swap
875     *@returns token is the address of token
876     *@returns _swapFee is the swap fee 
877     */
878     function getVariables() public view returns (address, uint, uint, address,uint){
879         return (oracle_address,duration, multiplier, token,swapFee);
880     }
881 
882     /**
883     *@dev Pays out to a DRCT token
884     *@param _party is the address being paid
885     *@param _token_add token to pay out
886     */
887     function payToken(address _party, address _token_add) public {
888         require(created_contracts[msg.sender] > 0);
889         DRCT_Token drct_interface = DRCT_Token(_token_add);
890         drct_interface.pay(_party, msg.sender);
891     }
892 
893     /**
894     *@dev Counts number of contacts created by this factory
895     *@return the number of contracts
896     */
897     function getCount() public constant returns(uint) {
898         return contracts.length;
899     }
900 
901     /**
902     *@dev Counts number of start dates in this factory
903     *@return the number of active start dates
904     */
905     function getDateCount() public constant returns(uint) {
906         return startDates.length;
907     }
908 }
909 
910 // File: contracts\MasterDeployer.sol
911 
912 /**
913 *This contract deploys a factory contract and uses CloneFactory to clone the factory
914 *specified.
915 */
916 
917 contract MasterDeployer is CloneFactory{
918     
919     using SafeMath for uint256;
920 
921     /*Variables*/
922 	address[] factory_contracts;
923 	address private factory;
924 	mapping(address => uint) public factory_index;
925 
926     /*Events*/
927 	event NewFactory(address _factory);
928 
929     /*Functions*/
930     /**
931     *@dev Initiates the factory_contract array with address(0)
932     */
933 	constructor() public {
934 		factory_contracts.push(address(0));
935 	}
936 
937     /**
938     *@dev Set factory address to clone
939     *@param _factory address to clone
940     */	
941 	function setFactory(address _factory) public onlyOwner(){
942 		factory = _factory;
943 	}
944 
945     /**
946     *@dev creates a new factory by cloning the factory specified in setFactory.
947     *@return _new_fac which is the new factory address
948     */
949 	function deployFactory(uint _memberTypes) public onlyOwner() returns(address){
950 		address _new_fac = createClone(factory);
951 		factory_index[_new_fac] = factory_contracts.length;
952 		factory_contracts.push(_new_fac);
953 		Factory(_new_fac).init(msg.sender,_memberTypes);
954 		emit NewFactory(_new_fac);
955 		return _new_fac;
956 	}
957 
958     /**
959     *@dev Removes the factory specified
960     *@param _factory address to remove
961     */
962 	function removeFactory(address _factory) public onlyOwner(){
963 		require(_factory != address(0) && factory_index[_factory] != 0);
964 		uint256 fIndex = factory_index[_factory];
965         uint256 lastFactoryIndex = factory_contracts.length.sub(1);
966         address lastFactory = factory_contracts[lastFactoryIndex];
967         factory_contracts[fIndex] = lastFactory;
968         factory_index[lastFactory] = fIndex;
969         factory_contracts.length--;
970         factory_index[_factory] = 0;
971 	}
972 
973     /**
974     *@dev Counts the number of factories
975     *@returns the number of active factories
976     */
977 	function getFactoryCount() public constant returns(uint){
978 		return factory_contracts.length - 1;
979 	}
980 
981     /**
982     *@dev Returns the factory address for the specified index
983     *@param _index for factory to look up in the factory_contracts array
984     *@return factory address for the index specified
985     */
986 	function getFactorybyIndex(uint _index) public constant returns(address){
987 		return factory_contracts[_index];
988 	}
989 }