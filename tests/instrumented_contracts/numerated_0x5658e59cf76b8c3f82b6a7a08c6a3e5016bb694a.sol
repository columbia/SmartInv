1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 contract ERC20Basic {
47     function totalSupply() public view returns (uint256);
48     function balanceOf(address who) public view returns (uint256);
49     function transfer(address to, uint256 value) public returns (bool);
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 
54 contract ERC20 is ERC20Basic {
55     function allowance(address owner, address spender) public view returns (uint256);
56     function transferFrom(address from, address to, uint256 value) public returns (bool);
57     function approve(address spender, uint256 value) public returns (bool);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 /// @title Intel contract
63 
64 /// @notice Intel, A contract for creating, rewarding and distributing Intels
65 contract Intel{
66     
67     using SafeMath for uint256;
68     
69     //Struct to main the state of an Intel
70     struct IntelState {
71         address intelProvider;
72         uint depositAmount;
73         uint desiredReward;
74   
75         // total balance of Pareto tokens given for this intel including the intel provider’s deposit
76         uint balance;
77 
78        //unique identifier 
79         uint intelID;
80 
81         // timestamp for when rewards can be collected
82         uint rewardAfter;
83 
84         // flag indicating whether the rewards have been collected
85         bool rewarded;
86         
87         // stores how many Pareto tokens were given for this intel in case you want to enforce a max amount per contributor
88         address[] contributionsList;
89         mapping(address => uint) contributions;
90     }
91 
92     // mapping for all of the Intels
93     mapping(uint => IntelState) intelDB; 
94 
95     // mapping of Intels by a single provider
96     mapping(address => IntelState[]) public intelsByProvider;
97     
98     // mapping for the storage of deposit amounts by addresses
99     mapping(address => uint) public balances;
100 
101     // mapping for storage of addresses who have at least deposited once
102     mapping(address => bool) public registered; 
103 
104     // list of addresses who have had made deposited to the smart contract
105     address[] public participants;
106 
107     // total Pareto token balance inside the Intel contract
108     uint public totalParetoBalance; 
109 
110     uint[] intelIndexes;
111     
112     // total count of Intels
113     uint public intelCount; 
114     
115     // Storage variable to hold the address of the owner of the intel contract
116     address public owner;    
117     
118     // Storage variable of type ERC20 to hold Pareto Token
119     ERC20 public token;  
120 
121     // Address of the Pareto Token
122     address public paretoAddress;
123 
124     
125     constructor(address _owner, address _token) public {
126         // owner is a Pareto wallet which should be able to perform admin functions
127         owner = _owner; 
128         token = ERC20(_token);
129         paretoAddress = _token;
130     }
131     
132 
133     // modifier to check to see if  the sender of transaction is the owner
134     modifier onlyOwner(){
135         require(msg.sender == owner, "Sender of this transaction can be only the owner");
136         _;
137     }
138 
139 
140     function changeOwner(address _newOwner) public onlyOwner{
141         require(_newOwner != address(0x0), "New owner address is not valid");
142         owner = _newOwner;
143     }
144     
145 
146     event Reward( address sender, uint intelIndex, uint rewardAmount);
147     event NewIntel(address intelProvider, uint depositAmount, uint desiredReward, uint intelID, uint ttl);
148     event RewardDistributed(uint intelIndex, uint provider_amount, address provider, address distributor, uint distributor_amount);
149     event LogProxy(address destination, address account, uint amount, uint gasLimit);
150     event Deposited(address from, address to, uint amount);
151     
152     function makeDeposit(address _address, uint _amount) public {
153         require(_address != address(0x0), "Address is invalid");
154         require(_amount > 0, "Deposit amount needs to be greater than 0");
155 
156         // Transfer token from the  depositing address to the Intel smart contract
157         token.transferFrom(_address, address(this), _amount);
158 
159         // Increases the balance for the depositing address in the balances map 
160         balances[_address] = balances[_address].add(_amount); 
161 
162         // We check to see  if the user who is making the deposit is already registered
163         // If they are not registered, then we add their address to the participants array, and update 
164         // the registered map address => true
165         if(!registered[_address]) {     
166             participants.push(_address);
167             registered[_address] = true;
168         }
169 
170         // Add the deposited amount to the total Pareto Balance to keep track of total deposited pareto inside the smart contract
171         totalParetoBalance = totalParetoBalance.add(_amount);  
172         
173 		// Fire the deposited event with the from address, to address, and amount
174         emit Deposited(_address, address(this), _amount);
175     }
176     
177     /// @notice this function creates an Intel
178     /// @dev Uses 'now' for timestamps. balance[address(this)] is for allocating tokens to the Intel contract for when we subtract tokens from user’s address in case of creation or rewarding of Intels. we actually should add tokens to somewhere when we subtract them from user’s balance and the smart contract’s address is being used for that.
179     /// @param intelProvider is the address of the creator\provider of the Intel
180     /// @param depositAmount is the amount of Pareto tokens staked by the provider
181     /// @param desiredReward is the amount of Pareto tokens desired by the provider as the reward
182     /// @param intelID is the ID of Intel which is mapped against an Intel in IntelDB as well as the database external to Ethereum
183     /// @param ttl is the time in EPOCH format until the Intel remains active and accepts rewards
184     /// requires 210769 gas in Rinkeby Network
185     function create(address intelProvider, uint depositAmount, uint desiredReward, uint intelID, uint ttl) public {
186 
187         require(intelID > 0, "Intel's ID should be greater than 0.");
188         require(address(intelProvider) != address(0x0), "Intel Provider's address provided is invalid.");
189         require(depositAmount > 0, "Amount should be greater than 0.");
190         require(desiredReward > 0, "Desired reward should be greater than 0.");
191         require(ttl > now, "Expiration date for Intel should be greater than now.");
192                 
193         IntelState storage intel = intelDB[intelID];
194         require(intel.depositAmount == 0, "Intel with the provided ID already exists");
195 
196         // First, check if the user already has deposited enough Paretos into this smart contract to satisfy the stake amount required to create the Intel
197         if(depositAmount <= balances[intelProvider]) {                      
198 
199             // The user has deposited enough Pareto into this contract to create the Intel. Deduct the amount from the user's balance
200             balances[intelProvider] = balances[intelProvider].sub(depositAmount);   
201 
202             // In the balances map for the address of this contract, we will maintain the amount of Pareto token used to create intel.
203             balances[address(this)] = balances[address(this)].add(depositAmount);   
204 
205         } else {
206             //The user does NOT have an adequate balance to cover the creation of the intel. We will transfer the depositAmount from the user's address to the intel contract.
207             token.transferFrom(intelProvider, address(this), depositAmount);  
208 
209             // In the balances map for the address of this contract, we will maintain the amount of Pareto token used to create intel. 
210             balances[address(this)] = balances[address(this)].add(depositAmount); 
211    
212             // Add depositAmount to the total Pareto Balance to keep track of total deposited pareto inside the smart contract
213             totalParetoBalance = totalParetoBalance.add(depositAmount);   
214         }
215 
216         //For the new intel, create a contributionsList
217         address[] memory contributionsList;
218 
219         //Create the new IntelState Struct
220         IntelState memory newIntel = IntelState(intelProvider, depositAmount, desiredReward, depositAmount, intelID, ttl, false, contributionsList);
221 
222         //Add the IntelState to the intelDB indexed by IntelID
223         intelDB[intelID] = newIntel;
224 
225         //Populate the intelsByProvider map
226         intelsByProvider[intelProvider].push(newIntel);
227 
228         //maintain a separate array of IntelIDs.
229         intelIndexes.push(intelID);
230 
231         //Increment the intel count
232         intelCount++;
233      
234         //Trigger a NewIntel event   
235         emit NewIntel(intelProvider, depositAmount, desiredReward, intelID, ttl);
236     }
237     
238 
239     
240     /// @notice this function sends rewards to the Intel
241     /// @dev Uses 'now' for timestamps. balance[address(this)] is for allocating tokens to the Intel contract for when we subtract tokens from user’s address in case of creation or rewarding of Intels. we actually should add tokens to somewhere when we subtract them from user’s balance and the smart contract’s address is being used for that.
242     /// @param intelIndex is the ID of the Intel to send the rewards to
243     /// @param rewardAmount is the amount of Pareto tokens the rewarder wants to reward to the Intel
244     /// @return returns true in case of successful completion
245     /// requires 72283 gas on Rinkeby Network
246     function sendReward(uint intelIndex, uint rewardAmount) public returns(bool success){
247 
248         //Ensure we have a valid intelIndex
249         require(intelIndex > 0, "Intel's ID should be greater than 0.");
250 
251 		//Ensure that the rewardAmount is greater than 0.
252         require(rewardAmount > 0, "Reward amount should be greater than 0.");
253 
254         IntelState storage intel = intelDB[intelIndex];
255 
256         // make sure that Intel exists 
257         require(intel.intelProvider != address(0x0), "Intel for the provided ID does not exist.");
258         
259         //Ensure that the person who is performing the reward is not the IntelProvider
260         require(msg.sender != intel.intelProvider, "msg.sender should not be the current Intel's provider."); 
261         
262         //You cannot reward intel if the timestamp of the reward transaction is greater than rewardAfter variable of the Intel.
263         require(intel.rewardAfter > now, "Intel is expired");  
264 
265         // You cannot reward intel if the intel’s rewards have already been distributed
266         require(!intel.rewarded, "Intel is already rewarded"); 
267      
268         // Check if the user who is sending the reward already has rewardAmount worth of tokens deposited in their balance
269         if(rewardAmount <= balances[msg.sender]) {      
270             //The user who is sending reward has enough deposited tokens to make the transaction. Hence, decrease the 
271             //the user's token amount from balances map by rewardAmount
272             balances[msg.sender] = balances[msg.sender].sub(rewardAmount);  
273             
274             //In the balance map for this contract address, we keep track of the total amount transacted.  This looks funny. Are we going to be double counting?
275             balances[address(this)] = balances[address(this)].add(rewardAmount); 
276         } else {
277 
278             //The user who is sending reward does NOT have  enough deposited tokens to make the transaction. Hence, transfer token from caller to Intel Contract
279             token.transferFrom(msg.sender, address(this), rewardAmount); 
280 
281             // add token amount in balances worth rewardAmount for this smart contract. This looks fishy. What are we tracking here
282             balances[address(this)] = balances[address(this)].add(rewardAmount);
283 
284             // add amount to total to keep track of total deposited pareto inside the smart contract
285             totalParetoBalance = totalParetoBalance.add(rewardAmount);   
286         }
287 
288         //On the intel contract, increment the balance by the rewardAmount.
289         intel.balance = intel.balance.add(rewardAmount);
290 
291         //On the intel contract, add the address of the person who is sending the reward, if they don't already exist
292         if(intel.contributions[msg.sender] == 0){
293             intel.contributionsList.push(msg.sender);
294         }
295         
296         //On the intel contract, increase the contributions map with this sender address by the amount rewarded 
297         intel.contributions[msg.sender] = intel.contributions[msg.sender].add(rewardAmount);
298         
299 
300         //Fire the reward event
301         emit Reward(msg.sender, intelIndex, rewardAmount);
302 
303 
304         return true;
305     }
306     
307 
308     
309     /// @notice this function distributes rewards to the Intel provider
310     /// @dev Uses 'now' for timestamps. Uses balances[address(this)] to subtract the tokens from the smart contract in balances mapping.
311     /// @param intelIndex is the ID of the Intel to distribute tokens to
312     /// @return returns true in case of successful completion
313     /// requires 91837 gas on Rinkeby Network
314     function distributeReward(uint intelIndex) public returns(bool success){
315 
316         require(intelIndex > 0, "Intel's ID should be greater than 0.");
317         
318 
319         IntelState storage intel = intelDB[intelIndex];
320         
321         require(!intel.rewarded, "Intel is already rewarded.");
322         require(now >= intel.rewardAfter, "Intel needs to be expired for distribution.");
323         
324 
325         intel.rewarded = true;
326         uint distributed_amount = 0;
327 
328         distributed_amount = intel.balance;
329         
330         balances[address(this)] = balances[address(this)].sub(distributed_amount);  // subtract distributed_amount worth of tokens from balances for the Intel smart contract
331         intel.balance = 0;
332 
333         uint fee = distributed_amount.div(10);    // calculate 10% as the fee for distribution
334         distributed_amount = distributed_amount.sub(fee);   // calculate final distribution amount
335 
336         token.transfer(msg.sender, fee/2);  // transfer 5% fee to the distributor
337         balances[owner] = balances[owner].add(fee/2);  // update balances with 5% worth of distribution amount for the owner
338         token.transfer(intel.intelProvider, distributed_amount); // transfer the 90% token to the intel provider
339         totalParetoBalance = totalParetoBalance.sub(distributed_amount.add(fee/2)); // update balances with subtraction of 95% of distributing tokens from the Intel contract
340        
341 
342         emit RewardDistributed(intelIndex, distributed_amount, intel.intelProvider, msg.sender, fee);
343 
344 
345         return true;
346 
347     }
348     
349     function getParetoBalance(address _address) public view returns(uint) {
350         return balances[_address];
351     }
352 
353     function distributeFeeRewards(address[] _participants, uint _amount) public onlyOwner {
354         uint totalCirculatingAmount = totalParetoBalance - balances[address(this)] - balances[owner];
355 
356         for( uint i = 0; i < _participants.length; i++) {
357             if(balances[_participants[i]] > 0) {
358                 uint amountToAdd = _amount.mul(balances[_participants[i]]).div(totalCirculatingAmount);
359                 balances[_participants[i]] = balances[_participants[i]].add(amountToAdd);
360                 balances[owner] = balances[owner].sub(amountToAdd);
361             }
362         }
363     }
364 
365     function getParticipants() public view returns(address[] memory _participants) {
366         _participants = new address[](participants.length);
367         
368         for(uint i = 0; i < participants.length; i++) {
369             _participants[i] = participants[i];
370         }
371         return;
372     }
373 
374     /// @notice this function sets the address of Pareto Token
375     /// @dev only owner can call it
376     /// @param _token is the Pareto token address
377     /// requires 63767 gas on Rinkeby Network
378     function setParetoToken(address _token) public onlyOwner{
379 
380         token = ERC20(_token);
381         paretoAddress = _token;
382 
383     }
384     
385 
386     
387     /// @notice this function sends back the mistakenly sent non-Pareto ERC20 tokens
388     /// @dev only owner can call it
389     /// @param destination is the contract address where the tokens were received from mistakenly
390     /// @param account is the external account's address which sent the wrong tokens
391     /// @param amount is the amount of tokens sent
392     /// @param gasLimit is the amount of gas to be sent along with external contract's transfer call
393     /// requires 27431 gas on Rinkeby Network
394     function proxy(address destination, address account, uint amount, uint gasLimit) public onlyOwner{
395 
396         require(destination != paretoAddress, "Pareto Token cannot be assigned as destination.");    // check that the destination is not the Pareto token contract
397 
398         // make the call to transfer function of the 'destination' contract
399         // if(!address(destination).call.gas(gasLimit)(bytes4(keccak256("transfer(address,uint256)")),account, amount)){
400         //     revert();
401         // }
402 
403 
404         // ERC20(destination).transfer(account,amount);
405 
406 
407         bytes4  sig = bytes4(keccak256("transfer(address,uint256)"));
408 
409         assembly {
410             let x := mload(0x40) //Find empty storage location using "free memory pointer"
411         mstore(x,sig) //Place signature at beginning of empty storage 
412         mstore(add(x,0x04),account)
413         mstore(add(x,0x24),amount)
414 
415         let success := call(      //This is the critical change (Pop the top stack value)
416                             gasLimit, //5k gas
417                             destination, //To addr
418                             0,    //No value
419                             x,    //Inputs are stored at location x
420                             0x44, //Inputs are 68 bytes long
421                             x,    //Store output over input (saves space)
422                             0x0) //Outputs are 32 bytes long
423 
424         // Check return value and jump to bad destination if zero
425 		jumpi(0x02,iszero(success))
426 
427         }
428         emit LogProxy(destination, account, amount, gasLimit);
429     }
430 
431     
432     /// @notice It's a fallback function supposed to return sent Ethers by reverting the transaction
433     function() external{
434         revert();
435     }
436 
437     
438     /// @notice this function provide the Intel based on its index
439     /// @dev it's a constant function which can be called
440     /// @param intelIndex is the ID of Intel that is to be returned from intelDB
441     function getIntel(uint intelIndex) public view returns(address intelProvider, uint depositAmount, uint desiredReward, uint balance, uint intelID, uint rewardAfter, bool rewarded) {
442         
443         IntelState storage intel = intelDB[intelIndex];
444         intelProvider = intel.intelProvider;
445         depositAmount = intel.depositAmount;
446         desiredReward = intel.desiredReward;
447         balance = intel.balance;
448         rewardAfter = intel.rewardAfter;
449         intelID = intel.intelID;
450         rewarded = intel.rewarded;
451 
452     }
453 
454     function getAllIntel() public view returns (uint[] intelID, address[] intelProvider, uint[] depositAmount, uint[] desiredReward, uint[] balance, uint[] rewardAfter, bool[] rewarded){
455         
456         uint length = intelIndexes.length;
457         intelID = new uint[](length);
458         intelProvider = new address[](length);
459         depositAmount = new uint[](length);
460         desiredReward = new uint[](length);
461         balance = new uint[](length);
462         rewardAfter = new uint[](length);
463         rewarded = new bool[](length);
464 
465         for(uint i = 0; i < intelIndexes.length; i++){
466             intelID[i] = intelDB[intelIndexes[i]].intelID;
467             intelProvider[i] = intelDB[intelIndexes[i]].intelProvider;
468             depositAmount[i] = intelDB[intelIndexes[i]].depositAmount;
469             desiredReward[i] = intelDB[intelIndexes[i]].desiredReward;
470             balance[i] = intelDB[intelIndexes[i]].balance;
471             rewardAfter[i] = intelDB[intelIndexes[i]].rewardAfter;
472             rewarded[i] = intelDB[intelIndexes[i]].rewarded;
473         }
474     }
475 
476 
477     function getIntelsByProvider(address _provider) public view returns (uint[] intelID, address[] intelProvider, uint[] depositAmount, uint[] desiredReward, uint[] balance, uint[] rewardAfter, bool[] rewarded){
478         
479         uint length = intelsByProvider[_provider].length;
480 
481         intelID = new uint[](length);
482         intelProvider = new address[](length);
483         depositAmount = new uint[](length);
484         desiredReward = new uint[](length);
485         balance = new uint[](length);
486         rewardAfter = new uint[](length);
487         rewarded = new bool[](length);
488 
489         IntelState[] memory intels = intelsByProvider[_provider];
490 
491         for(uint i = 0; i < length; i++){
492             intelID[i] = intels[i].intelID;
493             intelProvider[i] = intels[i].intelProvider;
494             depositAmount[i] = intels[i].depositAmount;
495             desiredReward[i] = intels[i].desiredReward;
496             balance[i] = intels[i].balance;
497             rewardAfter[i] = intels[i].rewardAfter;
498             rewarded[i] = intels[i].rewarded;
499         }
500     }
501 
502     function contributionsByIntel(uint intelIndex) public view returns(address[] memory addresses, uint[] memory amounts){
503         IntelState storage intel = intelDB[intelIndex];
504                 
505         uint length = intel.contributionsList.length;
506 
507         addresses = new address[](length);
508         amounts = new uint[](length);
509 
510         for(uint i = 0; i < length; i++){
511             addresses[i] = intel.contributionsList[i]; 
512             amounts[i] = intel.contributions[intel.contributionsList[i]];       
513         }
514 
515     }
516 
517 }