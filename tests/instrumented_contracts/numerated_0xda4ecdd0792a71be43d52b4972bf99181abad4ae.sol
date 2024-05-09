1 pragma solidity ^0.4.24;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract SafeMath {
21   function safeMul(uint a, uint b) internal pure returns (uint) {
22     uint c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function safeDiv(uint a, uint b) internal pure returns (uint) {
28     assert(b > 0);
29     uint c = a / b;
30     assert(a == b * c + a % b);
31     return c;
32   }
33 
34   function safeSub(uint a, uint b) internal pure returns (uint) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function safeAdd(uint a, uint b) internal pure returns (uint) {
40     uint c = a + b;
41     assert(c>=a && c>=b);
42     return c;
43   }
44 
45   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
46     return a >= b ? a : b;
47   }
48 
49   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
50     return a < b ? a : b;
51   }
52 
53   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
54     return a >= b ? a : b;
55   }
56 
57   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
58     return a < b ? a : b;
59   }
60 
61   function toWei(uint256 a) internal pure returns (uint256){
62     assert(a>0);
63     return a * 10 ** 18;
64   }
65 }
66 
67 interface tokenRecipient { 
68     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
69 }
70 
71 contract TokenERC20 is SafeMath{
72 
73     // Token information
74     // Public variables of the token
75     string public name;
76     string public symbol;
77     uint8 public decimals;
78     uint256 public totalSupply;
79 
80 
81     // This creates an array with all balances
82     mapping (address => uint256) public balanceOf;
83     mapping (address => mapping (address => uint256)) public allowance;
84 
85     // This generates a public event on the blockchain that will notify clients
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     // This notifies clients about the amount burnt
89     event Burn(address indexed from, uint256 value);
90 
91     /**
92      * Constrctor function
93      *
94      * Initializes contract with initial supply tokens to the creator of the contract
95      */
96     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
97         name = _name;
98         symbol = _symbol;
99         decimals = _decimals;
100         totalSupply = _totalSupply * 10 ** uint256(decimals);
101     }
102 
103     /**
104      * Internal transfer, only can be called by this contract
105      */
106     function _transfer(address _from, address _to, uint _value) internal {
107         // Prevent transfer to 0x0 address. Use burn() instead
108         require(_to != 0x0);
109         // Check if the sender has enough
110         require(balanceOf[_from] >= _value);
111         // Check for overflows
112         require(safeAdd(balanceOf[_to], _value) > balanceOf[_to]);
113         // Save this for an assertion in the future
114         uint previousBalances = safeAdd(balanceOf[_from],balanceOf[_to]);
115         // Subtract from the sender
116         balanceOf[_from] = safeSub(balanceOf[_from], _value);
117         // Add the same to the recipient
118         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
119         emit Transfer(_from, _to, _value);
120         // Asserts are used to use static analysis to find bugs in your code. They should never fail
121         assert(safeAdd(balanceOf[_from],balanceOf[_to]) == previousBalances);
122     }
123 
124     /**
125      * Transfer tokens
126      *
127      * Send `_value` tokens to `_to` from your account
128      *
129      * @param _to The address of the recipient
130      * @param _value the amount to send
131      */
132     function transfer(address _to, uint256 _value) public {
133         _transfer(msg.sender, _to, _value);
134     }
135 
136     /**
137      * Transfer tokens from other address
138      *
139      * Send `_value` tokens to `_to` in behalf of `_from`
140      *
141      * @param _from The address of the sender
142      * @param _to The address of the recipient
143      * @param _value the amount to send
144      */
145     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
146         require(_value <= allowance[_from][msg.sender]);     // Check allowance
147         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender],_value);
148         _transfer(_from, _to, _value);
149         return true;
150     }
151       
152     /**
153      * Set allowance for other address
154      *
155      * Allows `_spender` to spend no more than `_value` tokens in your behalf
156      *
157      * @param _spender The address authorized to spend
158      * @param _value the max amount they can spend
159      */
160     function approve(address _spender, uint256 _value) public
161         returns (bool success) {
162         allowance[msg.sender][_spender] = _value;
163         return true;
164     }
165 
166     /**
167      * Set allowance for other address and notify
168      *
169      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
170      *
171      * @param _spender The address authorized to spend
172      * @param _value the max amount they can spend
173      * @param _extraData some extra information to send to the approved contract
174      */
175     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
176         public
177         returns (bool success) {
178         tokenRecipient spender = tokenRecipient(_spender);
179         if (approve(_spender, _value)) {
180             spender.receiveApproval(msg.sender, _value, this, _extraData);
181             return true;
182         }
183     }
184 
185     /**
186      * Destroy tokens
187      *
188      * Remove `_value` tokens from the system irreversibly
189      *
190      * @param _value the amount of money to burn
191      */
192     function burn(uint256 _value) public returns (bool success) {
193         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
194         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);            // Subtract from the sender
195         totalSupply = safeSub(totalSupply,_value);                      // Updates totalSupply
196         emit Burn(msg.sender, _value);
197         return true;
198     }
199 
200     /**
201      * Destroy tokens from other account
202      *
203      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
204      *
205      * @param _from the address of the sender
206      * @param _value the amount of money to burn
207      */
208     function burnFrom(address _from, uint256 _value) public returns (bool success) {
209         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
210         require(_value <= allowance[_from][msg.sender]);    // Check allowance
211         balanceOf[_from] = safeSub(balanceOf[_from], _value);                         // Subtract from the targeted balance
212         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);             // Subtract from the sender's allowance
213         totalSupply = safeSub(totalSupply,_value);                              // Update totalSupply
214         emit Burn(_from, _value);
215         return true;
216     }
217 }
218 
219 /******************************************/
220 /*          GAMEREWARD TOKEN              */
221 /******************************************/
222 
223 contract GameRewardToken is owned, TokenERC20 {
224 
225     // State machine
226     enum State{PrivateFunding, PreFunding, Funding, Success, Failure}
227 
228 
229     mapping (address => bool) public frozenAccount;
230     mapping (address => address) public applications;
231     mapping (address => uint256) public bounties;
232     mapping (address => uint256) public bonus;
233     mapping (address => address) public referrals;
234     mapping (address => uint256) public investors;
235     mapping (address => uint256) public funders;
236 
237     /* This generates a public event on the blockchain that will notify clients */
238     event FrozenFunds(address indexed target, bool frozen);
239     event FundTransfer(address indexed to, uint256 eth , uint256 value, uint block);
240     event SetApplication(address indexed target, address indexed parent);
241     event Fee(address indexed from, address indexed collector, uint256 fee);
242     event FreeDistribution(address indexed to, uint256 value, uint block);
243     event Refund(address indexed to, uint256 value, uint block);
244     event BonusTransfer(address indexed to, uint256 value, uint block);
245     event BountyTransfer(address indexed to, uint256 value, uint block);
246     event SetReferral(address indexed target, address indexed broker);
247     event ChangeCampaign(uint256 fundingStartBlock, uint256 fundingEndBlock);
248     event AddBounty(address indexed bountyHunter, uint256 value);
249     event ReferralBonus(address indexed investor, address indexed broker, uint256 value);
250 
251      // Crowdsale information
252     bool public finalizedCrowdfunding = false;
253 
254     uint256 public fundingStartBlock = 0; // crowdsale start block
255     uint256 public fundingEndBlock = 0;   // crowdsale end block
256     uint256 public constant lockedTokens =                250000000*10**18; //25% tokens to Vault and locked for 6 months - 250 millions
257     uint256 public bonusAndBountyTokens =                  50000000*10**18; //5% tokens for referral bonus and bounty - 50 millions
258     uint256 public constant devsTokens =                  100000000*10**18; //10% tokens for team - 100 millions
259     uint256 public constant hundredPercent =                           100;
260     uint256 public constant tokensPerEther =                         20000; //GRD:ETH exchange rate - 20.000 GRD per ETH
261     uint256 public constant tokenCreationMax =            600000000*10**18; //ICO hard target - 600 millions
262     uint256 public constant tokenCreationMin =             60000000*10**18; //ICO soft target - 60 millions
263 
264     uint256 public constant tokenPrivateMax =             100000000*10**18; //Private-sale must stop when 100 millions tokens sold
265 
266     uint256 public constant minContributionAmount =             0.1*10**18; //Investor must buy atleast 0.1ETH in open-sale
267     uint256 public constant maxContributionAmount =             100*10**18; //Max 100 ETH in open-sale and pre-sale
268 
269     uint256 public constant minPrivateContribution =              5*10**18; //Investor must buy atleast 5ETH in private-sale
270     uint256 public constant minPreContribution =                  1*10**18; //Investor must buy atleast 1ETH in pre-sale
271 
272     uint256 public constant minAmountToGetBonus =                 1*10**18; //Investor must buy atleast 1ETH to receive referral bonus
273     uint256 public constant referralBonus =                              5; //5% for referral bonus
274     uint256 public constant privateBonus =                              40; //40% bonus in private-sale
275     uint256 public constant preBonus =                                  20; //20% bonus in pre-sale;
276 
277     uint256 public tokensSold;
278     uint256 public collectedETH;
279 
280     uint256 public constant numBlocksLocked = 1110857;  //180 days locked vault tokens
281     bool public releasedBountyTokens = false; //bounty release status
282     uint256 public unlockedAtBlockNumber;
283 
284     address public lockedTokenHolder;
285     address public releaseTokenHolder;
286     address public devsHolder;
287 
288 
289     constructor(address _lockedTokenHolder,
290                 address _releaseTokenHolder,
291                 address _devsAddress
292     ) TokenERC20("GameReward", // Name
293                  "GRD",        // Symbol 
294                   18,          // Decimals
295                   1000000000   // Total Supply 1 Billion
296                   ) public {
297         
298         require (_lockedTokenHolder != 0x0);
299         require (_releaseTokenHolder != 0x0);
300         require (_devsAddress != 0x0);
301         lockedTokenHolder = _lockedTokenHolder;
302         releaseTokenHolder = _releaseTokenHolder;
303         devsHolder = _devsAddress;
304     }
305 
306     /* Internal transfer, only can be called by this contract */
307     function _transfer(address _from, address _to, uint _value) internal {
308         require (getState() == State.Success);
309         require (_to != 0x0);                                      // Prevent transfer to 0x0 address. Use burn() instead
310         require (balanceOf[_from] >= _value);                      // Prevent transfer to 0x0 address. Use burn() instead
311         require (safeAdd(balanceOf[_to],_value) > balanceOf[_to]); // Check for overflows
312         require (!frozenAccount[_from]);                           // Check if sender is frozen
313         require (!frozenAccount[_to]);                             // Check if recipient is frozen
314         require (_from != lockedTokenHolder);
315         balanceOf[_from] = safeSub(balanceOf[_from],_value);       // Subtract from the sender
316         balanceOf[_to] = safeAdd(balanceOf[_to],_value);           // Add the same to the recipient
317         emit Transfer(_from, _to, _value);
318         if(applications[_to] != 0x0){                              // If this address from an application
319             balanceOf[_to] = safeSub(balanceOf[_to],_value);       // Forward tokens to application address 
320             balanceOf[applications[_to]] =safeAdd(balanceOf[applications[_to]],_value);    
321             emit Transfer(_to, applications[_to], _value);
322         }
323     }
324 
325     ///@notice change token's name and symbol
326     function updateNameAndSymbol(string _newname, string _newsymbol) onlyOwner public{
327       name = _newname;
328       symbol = _newsymbol;
329     }
330 
331     ///@notice Application withdraw, only can be called by owner
332     ///@param _from address of the sender
333     ///@param _to address of the receiver
334     ///@param _value the amount to send
335     ///@param _fee the amount of transaction fee
336     ///@param _collector address of collector to receive fee
337     function withdraw(address _from, address _to, uint _value, uint _fee, address _collector) onlyOwner public {
338         require (getState() == State.Success);
339         require (applications[_from]!=0x0);                             // Check if sender from an application
340         address app = applications[_from];
341         require (_collector != 0x0);
342         require (_to != 0x0);                                           // Prevent transfer to 0x0 address. Use burn() instead
343         require (balanceOf[app] >= safeAdd(_value, _fee));              // Prevent transfer to 0x0 address. Use burn() instead
344         require (safeAdd(balanceOf[_to], _value)> balanceOf[_to]);      // Check for overflows
345         require (!frozenAccount[app]);                                  // Check if sender is frozen
346         require (!frozenAccount[_to]);                                  // Check if recipient is frozen
347         require (_from != lockedTokenHolder);
348         balanceOf[app] = safeSub(balanceOf[app],safeAdd(_value, _fee)); // Subtract from the Application
349         balanceOf[_to] = safeAdd(balanceOf[_to],_value);                // Add value to the target
350         balanceOf[_collector] = safeAdd(balanceOf[_collector], _fee);   // Add fee to fee collector
351         emit Fee(app,_collector,_fee);
352         emit Transfer(app, _collector, _fee);
353         emit Transfer(app, _to, _value);
354     }
355     
356     ///@notice map an address to its application address
357     ///@param _target Address to set parent
358     ///@param _parent Address of parent
359     function setApplication(address _target, address _parent) onlyOwner public {
360         require (getState() == State.Success);
361         require(_parent!=0x0);
362         applications[_target]=_parent;
363         uint256 currentBalance=balanceOf[_target];
364         emit SetApplication(_target,_parent);
365         if(currentBalance>0x0){
366             balanceOf[_target] = safeDiv(balanceOf[_target],currentBalance);
367             balanceOf[_parent] = safeAdd(balanceOf[_parent],currentBalance);
368             emit Transfer(_target,_parent,currentBalance);
369         }
370     }
371 
372     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
373     /// @param _target Address to be frozen
374     /// @param _freeze either to freeze it or not
375     function freezeAccount(address _target, bool _freeze) onlyOwner public {
376         frozenAccount[_target] = _freeze;
377         emit FrozenFunds(_target, _freeze);
378     }
379 
380 
381 
382     //Crowdsale Functions
383 
384     /// @notice get early bonus for Investor
385     function _getEarlyBonus() internal view returns(uint){
386         if(getState()==State.PrivateFunding) return privateBonus;  
387         else if(getState()==State.PreFunding) return preBonus; 
388         else return 0;
389     }
390 
391     /// @notice set start and end block for funding
392     /// @param _fundingStartBlock start funding
393     /// @param _fundingEndBlock  end funding
394     function setCampaign(uint256 _fundingStartBlock, uint256 _fundingEndBlock) onlyOwner public{
395         if(block.number < _fundingStartBlock){
396             fundingStartBlock = _fundingStartBlock;
397         }
398         if(_fundingEndBlock > fundingStartBlock && _fundingEndBlock > block.number){
399             fundingEndBlock = _fundingEndBlock;
400         }
401         emit ChangeCampaign(_fundingStartBlock,_fundingEndBlock);
402     }
403 
404     function releaseBountyTokens() onlyOwner public{
405       require(!releasedBountyTokens);
406       require(getState()==State.Success);
407       releasedBountyTokens = true;
408     }
409 
410 
411     /// @notice set Broker for Investor
412     /// @param _target address of Investor
413     /// @param _broker address of Broker
414     function setReferral(address _target, address _broker, uint256 _amount) onlyOwner public {
415         require (_target != 0x0);
416         require (_broker != 0x0);
417         referrals[_target] = _broker;
418         emit SetReferral(_target, _broker);
419         if(_amount>0x0){
420             uint256 brokerBonus = safeDiv(safeMul(_amount,referralBonus),hundredPercent);
421             bonus[_broker] = safeAdd(bonus[_broker],brokerBonus);
422             emit ReferralBonus(_target,_broker,brokerBonus);
423         }
424     }
425 
426     /// @notice set token for bounty hunter to release when ICO success
427     function addBounty(address _hunter, uint256 _amount) onlyOwner public{
428         require(_hunter!=0x0);
429         require(toWei(_amount)<=safeSub(bonusAndBountyTokens,toWei(_amount)));
430         bounties[_hunter] = safeAdd(bounties[_hunter],toWei(_amount));
431         bonusAndBountyTokens = safeSub(bonusAndBountyTokens,toWei(_amount));
432         emit AddBounty(_hunter, toWei(_amount));
433     }
434 
435     /// @notice Create tokens when funding is active. This fallback function require 90.000 gas or more
436     /// @dev Required state: Funding
437     /// @dev State transition: -> Funding Success (only if cap reached)
438     function() payable public{
439         // Abort if not in Funding Active state.
440         // Do not allow creating 0 or more than the cap tokens.
441         require (getState() != State.Success);
442         require (getState() != State.Failure);
443         require (msg.value != 0);
444 
445         if(getState()==State.PrivateFunding){
446             require(msg.value>=minPrivateContribution);
447         }else if(getState()==State.PreFunding){
448             require(msg.value>=minPreContribution && msg.value < maxContributionAmount);
449         }else if(getState()==State.Funding){
450             require(msg.value>=minContributionAmount && msg.value < maxContributionAmount);
451         }
452 
453         // multiply by exchange rate to get newly created token amount
454         uint256 createdTokens = safeMul(msg.value, tokensPerEther);
455         uint256 brokerBonus = 0;
456         uint256 earlyBonus = safeDiv(safeMul(createdTokens,_getEarlyBonus()),hundredPercent);
457 
458         createdTokens = safeAdd(createdTokens,earlyBonus);
459 
460         // don't go over the limit!
461         if(getState()==State.PrivateFunding){
462             require(safeAdd(tokensSold,createdTokens) <= tokenPrivateMax);
463         }else{
464             require (safeAdd(tokensSold,createdTokens) <= tokenCreationMax);
465         }
466 
467         // we are creating tokens, so increase the tokenSold
468         tokensSold = safeAdd(tokensSold, createdTokens);
469         collectedETH = safeAdd(collectedETH,msg.value);
470         
471         // add bonus if has referral
472         if(referrals[msg.sender]!= 0x0){
473             brokerBonus = safeDiv(safeMul(createdTokens,referralBonus),hundredPercent);
474             bonus[referrals[msg.sender]] = safeAdd(bonus[referrals[msg.sender]],brokerBonus);
475             emit ReferralBonus(msg.sender,referrals[msg.sender],brokerBonus);
476         }
477 
478         // Save funder info for refund and free distribution
479         funders[msg.sender] = safeAdd(funders[msg.sender],msg.value);
480         investors[msg.sender] = safeAdd(investors[msg.sender],createdTokens);
481 
482         // Assign new tokens to the sender
483         balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], createdTokens);
484         // Log token creation event
485         emit FundTransfer(msg.sender,msg.value, createdTokens, block.number);
486         emit Transfer(0, msg.sender, createdTokens);
487     }
488 
489     /// @notice send bonus token to broker
490     function requestBonus() external{
491       require(getState()==State.Success);
492       uint256 bonusAmount = bonus[msg.sender];
493       assert(bonusAmount>0);
494       require(bonusAmount<=safeSub(bonusAndBountyTokens,bonusAmount));
495       balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender],bonusAmount);
496       bonus[msg.sender] = 0;
497       bonusAndBountyTokens = safeSub(bonusAndBountyTokens,bonusAmount);
498       emit BonusTransfer(msg.sender,bonusAmount,block.number);
499       emit Transfer(0,msg.sender,bonusAmount);
500     }
501 
502     /// @notice send lockedTokens to devs address
503     /// require State == Success
504     /// require tokens unlocked
505     function releaseLockedToken() external {
506         require (getState() == State.Success);
507         require (balanceOf[lockedTokenHolder] > 0x0);
508         require (block.number >= unlockedAtBlockNumber);
509         balanceOf[devsHolder] = safeAdd(balanceOf[devsHolder],balanceOf[lockedTokenHolder]);
510         emit Transfer(lockedTokenHolder,devsHolder,balanceOf[lockedTokenHolder]);
511         balanceOf[lockedTokenHolder] = 0;
512     }
513     
514     /// @notice request to receive bounty tokens
515     /// @dev require State == Succes
516     function requestBounty() external{
517         require(releasedBountyTokens); //locked bounty hunter's token for 7 days after end of campaign
518         require(getState()==State.Success);
519         assert (bounties[msg.sender]>0);
520         balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender],bounties[msg.sender]);
521         emit BountyTransfer(msg.sender,bounties[msg.sender],block.number);
522         emit Transfer(0,msg.sender,bounties[msg.sender]);
523         bounties[msg.sender] = 0;
524     }
525 
526     /// @notice Finalize crowdfunding
527     /// @dev If cap was reached or crowdfunding has ended then:
528     /// create GRD for the Vault and developer,
529     /// transfer ETH to the devs address.
530     /// @dev Required state: Success
531     function finalizeCrowdfunding() external {
532         // Abort if not in Funding Success state.
533         require (getState() == State.Success); // don't finalize unless we won
534         require (!finalizedCrowdfunding); // can't finalize twice (so sneaky!)
535 
536         // prevent more creation of tokens
537         finalizedCrowdfunding = true;
538         // Endowment: 25% of total goes to vault, timelocked for 6 months
539         balanceOf[lockedTokenHolder] = safeAdd(balanceOf[lockedTokenHolder], lockedTokens);
540 
541         // Transfer lockedTokens to lockedTokenHolder address
542         unlockedAtBlockNumber = block.number + numBlocksLocked;
543         emit Transfer(0, lockedTokenHolder, lockedTokens);
544 
545         // Endowment: 10% of total goes to devs
546         balanceOf[devsHolder] = safeAdd(balanceOf[devsHolder], devsTokens);
547         emit Transfer(0, devsHolder, devsTokens);
548 
549         // Transfer ETH to the devs address.
550         devsHolder.transfer(address(this).balance);
551     }
552 
553     /// @notice send @param _unSoldTokens to all Investor base on their share
554     function requestFreeDistribution() external{
555       require(getState()==State.Success);
556       assert(investors[msg.sender]>0);
557       uint256 unSoldTokens = safeSub(tokenCreationMax,tokensSold);
558       require(unSoldTokens>0);
559       uint256 freeTokens = safeDiv(safeMul(unSoldTokens,investors[msg.sender]),tokensSold);
560       balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender],freeTokens);
561       investors[msg.sender] = 0;
562       emit FreeDistribution(msg.sender,freeTokens,block.number);
563       emit Transfer(0,msg.sender, freeTokens);
564 
565     }
566 
567     /// @notice Get back the ether sent during the funding in case the funding
568     /// has not reached the soft cap.
569     /// @dev Required state: Failure
570     function requestRefund() external {
571         // Abort if not in Funding Failure state.
572         assert (getState() == State.Failure);
573         assert (funders[msg.sender]>0);
574         msg.sender.transfer(funders[msg.sender]);  
575         emit Refund( msg.sender, funders[msg.sender],block.number);
576         funders[msg.sender]=0;
577     }
578 
579     /// @notice This manages the crowdfunding state machine
580     /// We make it a function and do not assign the result to a variable
581     /// So there is no chance of the variable being stale
582     function getState() public constant returns (State){
583       // once we reach success, lock in the state
584       if (finalizedCrowdfunding) return State.Success;
585       if(fundingStartBlock ==0 && fundingEndBlock==0) return State.PrivateFunding;
586       else if (block.number < fundingStartBlock) return State.PreFunding;
587       else if (block.number <= fundingEndBlock && tokensSold < tokenCreationMax) return State.Funding;
588       else if (tokensSold >= tokenCreationMin) return State.Success;
589       else return State.Failure;
590     }
591 }