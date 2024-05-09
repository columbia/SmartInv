1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply = 90000000 * 10**18;
41   function balanceOf(address who) public constant returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public constant returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances.
61  */
62 contract BasicToken is ERC20Basic {
63   using SafeMath for uint256;
64 
65   mapping(address => uint256) balances;
66 
67   /**
68   * @dev transfer token for a specified address
69   * @param _to The address to transfer to.
70   * @param _value The amount to be transferred.
71   */
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0));
74 
75     // SafeMath.sub will throw if there is not enough balance.
76  balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public constant returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * @dev https://github.com/ethereum/EIPs/issues/20
99  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  */
101 contract StandardToken is ERC20, BasicToken {
102 
103   mapping (address => mapping (address => uint256)) allowed;
104 
105 
106   /**
107    * @dev Transfer tokens from one address to another
108    * @param _from address The address which you want to send tokens from
109    * @param _to address The address which you want to transfer to
110    * @param _value uint256 the amount of tokens to be transferred
111    */
112   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114 
115     uint256 _allowance = allowed[_from][msg.sender];
116 
117     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
118     // require (_value <= _allowance);
119 
120     balances[_from] = balances[_from].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     allowed[_from][msg.sender] = _allowance.sub(_value);
123     Transfer(_from, _to, _value);
124     return true;
125   }
126 
127   /**
128    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
129    *
130    * Beware that changing an allowance with this method brings the risk that someone may use both the old
131    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
132    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
133    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134    * @param _spender The address which will spend the funds.
135    * @param _value The amount of tokens to be spent.
136    */
137   function approve(address _spender, uint256 _value) public returns (bool) {
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifying the amount of tokens still available for the spender.
148    */
149   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
150     return allowed[_owner][_spender];
151   }
152 
153   /**
154    * approve should be called when allowed[_spender] == 0. To increment
155    * allowed value is better to use this function to avoid 2 calls (and wait until
156    * the first transaction is mined)
157    * From MonolithDAO Token.sol
158    */
159   function increaseApproval (address _spender, uint _addedValue)
160     returns (bool success) {
161     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
162     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166   function decreaseApproval (address _spender, uint _subtractedValue)
167     returns (bool success) {
168     uint oldValue = allowed[msg.sender][_spender];
169     if (_subtractedValue > oldValue) {
170       allowed[msg.sender][_spender] = 0;
171     } else {
172       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
173     }
174     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 
178 }
179 
180 /**
181  * @title Ownable
182  * @dev The Ownable contract has an owner address, and provides basic authorization control
183  * functions, this simplifies the implementation of "user permissions".
184  */
185 contract Ownable {
186 
187   address public owner;
188 
189   /**
190    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
191    * account.
192    */
193   function Ownable() {
194     owner = msg.sender;
195   }
196 
197   /**
198    * @dev Throws if called by any account other than the owner.
199    */
200   modifier onlyOwner() {
201     require(msg.sender == owner);
202     _;
203   }
204 
205   /**
206    * @dev Allows the current owner to transfer control of the contract to a newOwner.
207    * @param newOwner The address to transfer ownership to.
208    */
209   function transferOwnership(address newOwner) onlyOwner {
210     require(newOwner != address(0));
211     owner = newOwner;
212   }
213 }
214 
215 /*
216  * ChargCoinContract
217  *
218  * Simple ERC20 Token example, with crowdsale token creation
219  */
220 contract ChargCoinContract is StandardToken, Ownable {
221     
222   string public standard = "Charg Coin";
223   string public name = "Charg Coin";
224   string public symbol = "CHARG";
225   uint public decimals = 18;
226   address public multisig = 0x0fA3d47B2F9C01396108D81aa63e4F20d4cd7994;
227   
228   // 1 ETH = 500 CHARG tokens (1 CHARG = 0.59 USD)
229   uint PRICE = 500;
230   
231   struct ContributorData {
232     uint contributionAmount;
233     uint tokensIssued;
234   }
235 
236   function ChargCoinContract() {
237     balances[msg.sender] = totalSupply;
238   }
239 
240   mapping(address => ContributorData) public contributorList;
241   uint nextContributorIndex;
242   mapping(uint => address) contributorIndexes;
243   
244   state public crowdsaleState = state.pendingStart;
245   enum state { pendingStart, crowdsale, crowdsaleEnded }
246   
247   event CrowdsaleStarted(uint blockNumber);
248   event CrowdsaleEnded(uint blockNumber);
249   event ErrorSendingETH(address to, uint amount);
250   event MinCapReached(uint blockNumber);
251   event MaxCapReached(uint blockNumber);
252   
253   uint public constant BEGIN_TIME = 1506406004;
254   
255   uint public constant END_TIME = 1510790400;
256 
257   uint public minCap = 1 ether;
258   uint public maxCap = 70200 ether;
259   uint public ethRaised = 0;
260   uint public tokenTotalSupply = 90000000 * 10**decimals;
261   
262   uint crowdsaleTokenCap =            35100000 * 10**decimals; // 39%
263   uint foundersAndTeamTokens =        9000000 * 10**decimals; // 10%
264   uint slushFundTokens =    45900000 * 10**decimals; // 51%
265   
266   bool foundersAndTeamTokensClaimed = false;
267   bool slushFundTokensClaimed = false;
268 
269   uint nextContributorToClaim;
270   mapping(address => bool) hasClaimedEthWhenFail;
271 
272   function() payable {
273   require(msg.value != 0);
274   require(crowdsaleState != state.crowdsaleEnded);// Check if crowdsale has ended
275   
276   bool stateChanged = checkCrowdsaleState();      // Check blocks and calibrate crowdsale state
277   
278   if(crowdsaleState == state.crowdsale) {
279       createTokens(msg.sender);             // Process transaction and issue tokens
280     } else {
281       refundTransaction(stateChanged);              // Set state and return funds or throw
282     }
283   }
284   
285   //
286   // Check crowdsale state and calibrate it
287   //
288   function checkCrowdsaleState() internal returns (bool) {
289     if (ethRaised >= maxCap && crowdsaleState != state.crowdsaleEnded) { // Check if max cap is reached
290       crowdsaleState = state.crowdsaleEnded;
291       CrowdsaleEnded(block.number); // Raise event
292       return true;
293     }
294     
295     if(now >= END_TIME) {   
296       crowdsaleState = state.crowdsaleEnded;
297       CrowdsaleEnded(block.number); // Raise event
298       return true;
299     }
300 
301     if(now >= BEGIN_TIME && now < END_TIME) {        // Check if we are in crowdsale state
302       if (crowdsaleState != state.crowdsale) {                                                   // Check if state needs to be changed
303         crowdsaleState = state.crowdsale;                                                       // Set new state
304         CrowdsaleStarted(block.number);                                                         // Raise event
305         return true;
306       }
307     }
308     
309     return false;
310   }
311   
312   //
313   // Decide if throw or only return ether
314   //
315   function refundTransaction(bool _stateChanged) internal {
316     if (_stateChanged) {
317       msg.sender.transfer(msg.value);
318     } else {
319       revert();
320     }
321   }
322   
323   function createTokens(address _contributor) payable {
324   
325     uint _amount = msg.value;
326   
327     uint contributionAmount = _amount;
328     uint returnAmount = 0;
329     
330     if (_amount > (maxCap - ethRaised)) {                                          // Check if max contribution is lower than _amount sent
331       contributionAmount = maxCap - ethRaised;                                     // Set that user contibutes his maximum alowed contribution
332       returnAmount = _amount - contributionAmount;                                 // Calculate how much he must get back
333     }
334 
335     if (ethRaised + contributionAmount > minCap && minCap > ethRaised) {
336       MinCapReached(block.number);
337     }
338 
339     if (ethRaised + contributionAmount == maxCap && ethRaised < maxCap) {
340       MaxCapReached(block.number);
341     }
342 
343     if (contributorList[_contributor].contributionAmount == 0){
344         contributorIndexes[nextContributorIndex] = _contributor;
345         nextContributorIndex += 1;
346     }
347   
348     contributorList[_contributor].contributionAmount += contributionAmount;
349     ethRaised += contributionAmount;                                              // Add to eth raised
350 
351     uint256 tokenAmount = calculateEthToChargcoin(contributionAmount);      // Calculate how much tokens must contributor get
352     if (tokenAmount > 0) {
353       transferToContributor(_contributor, tokenAmount);
354       contributorList[_contributor].tokensIssued += tokenAmount;                  // log token issuance
355     }
356 
357     if (!multisig.send(msg.value)) {
358         revert();
359     }
360   }
361 
362 
363     function transferToContributor(address _to, uint256 _value)  {
364     balances[owner] = balances[owner].sub(_value);
365     balances[_to] = balances[_to].add(_value);
366   }
367   
368   function calculateEthToChargcoin(uint _eth) constant returns(uint256) {
369   
370     uint tokens = _eth.mul(getPrice());
371     uint percentage = 0;
372     
373     if (ethRaised > 0)
374     {
375         percentage = ethRaised * 100 / maxCap;
376     }
377     
378     return tokens + getStageBonus(percentage, tokens) + getAmountBonus(_eth, tokens);
379   }
380 
381   function getStageBonus(uint percentage, uint tokens) constant returns (uint) {
382     uint stageBonus = 0;
383       
384     if (percentage <= 10) stageBonus = tokens * 60 / 100; // Stage 1
385     else if (percentage <= 50) stageBonus = tokens * 30 / 100;
386     else if (percentage <= 70) stageBonus = tokens * 20 / 100;
387     else if (percentage <= 90) stageBonus = tokens * 15 / 100;
388     else if (percentage <= 100) stageBonus = tokens * 10 / 100;
389 
390     return stageBonus;
391   }
392 
393   function getAmountBonus(uint _eth, uint tokens) constant returns (uint) {
394     uint amountBonus = 0;  
395       
396     if (_eth >= 3000 ether) amountBonus = tokens * 13 / 100;
397     else if (_eth >= 2000 ether) amountBonus = tokens * 12 / 100;
398     else if (_eth >= 1500 ether) amountBonus = tokens * 11 / 100;
399     else if (_eth >= 1000 ether) amountBonus = tokens * 10 / 100;
400     else if (_eth >= 750 ether) amountBonus = tokens * 9 / 100;
401     else if (_eth >= 500 ether) amountBonus = tokens * 8 / 100;
402     else if (_eth >= 300 ether) amountBonus = tokens * 75 / 1000;
403     else if (_eth >= 200 ether) amountBonus = tokens * 7 / 100;
404     else if (_eth >= 150 ether) amountBonus = tokens * 6 / 100;
405     else if (_eth >= 100 ether) amountBonus = tokens * 55 / 1000;
406     else if (_eth >= 75 ether) amountBonus = tokens * 5 / 100;
407     else if (_eth >= 50 ether) amountBonus = tokens * 45 / 1000;
408     else if (_eth >= 30 ether) amountBonus = tokens * 4 / 100;
409     else if (_eth >= 20 ether) amountBonus = tokens * 35 / 1000;
410     else if (_eth >= 15 ether) amountBonus = tokens * 3 / 100;
411     else if (_eth >= 10 ether) amountBonus = tokens * 25 / 1000;
412     else if (_eth >= 7 ether) amountBonus = tokens * 2 / 100;
413     else if (_eth >= 5 ether) amountBonus = tokens * 15 / 1000;
414     else if (_eth >= 3 ether) amountBonus = tokens * 1 / 100;
415     else if (_eth >= 2 ether) amountBonus = tokens * 5 / 1000;
416     
417     return amountBonus;
418   }
419   
420   // replace this with any other price function
421   function getPrice() constant returns (uint result) {
422     return PRICE;
423   }
424   
425   //
426   // Owner can batch return contributors contributions(eth)
427   //
428   function batchReturnEthIfFailed(uint _numberOfReturns) onlyOwner {
429     require(crowdsaleState != state.crowdsaleEnded);                // Check if crowdsale has ended
430     require(ethRaised < minCap);                // Check if crowdsale has failed
431     address currentParticipantAddress;
432     uint contribution;
433     for (uint cnt = 0; cnt < _numberOfReturns; cnt++){
434       currentParticipantAddress = contributorIndexes[nextContributorToClaim];         // Get next unclaimed participant
435       if (currentParticipantAddress == 0x0) return;                                   // Check if all the participants were compensated
436       if (!hasClaimedEthWhenFail[currentParticipantAddress]) {                        // Check if participant has already claimed
437         contribution = contributorList[currentParticipantAddress].contributionAmount; // Get contribution of participant
438         hasClaimedEthWhenFail[currentParticipantAddress] = true;                      // Set that he has claimed
439         balances[currentParticipantAddress] = 0;
440         if (!currentParticipantAddress.send(contribution)){                           // Refund eth
441           ErrorSendingETH(currentParticipantAddress, contribution);                   // If there is an issue raise event for manual recovery
442         }
443       }
444       nextContributorToClaim += 1;                                                    // Repeat
445     }
446   }
447   
448     //
449   // Owner can set multisig address for crowdsale
450   //
451   function setMultisigAddress(address _newAddress) onlyOwner {
452     multisig = _newAddress;
453   }
454   
455 }