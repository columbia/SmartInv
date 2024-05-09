1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control 
58  * functions, this simplifies the implementation of "user permissions". 
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   /** 
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   function Ownable() {
69     owner = msg.sender;
70   }
71 
72 
73   /**
74    * @dev Throws if called by any account other than the owner. 
75    */
76   modifier onlyOwner() {
77     if (msg.sender != owner) {
78       throw;
79     }
80     _;
81   }
82 
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param newOwner The address to transfer ownership to. 
87    */
88   function transferOwnership(address newOwner) onlyOwner {
89     if (newOwner != address(0)) {
90       owner = newOwner;
91     }
92   }
93 
94 }
95 
96 contract TeamAllocation is Ownable {
97   using SafeMath for uint;
98   //uint public constant lockedTeamAllocationTokens = 16000000;
99   uint public unlockedAt;
100   PillarToken plr;
101   mapping (address => uint) allocations;
102   uint tokensCreated = 0;
103   uint constant public lockedTeamAllocationTokens = 16000000e18;
104   //address of the team storage vault
105   address public teamStorageVault = 0x3f5D90D5Cc0652AAa40519114D007Bf119Afe1Cf;
106 
107   function TeamAllocation() {
108     plr = PillarToken(msg.sender);
109     // Locked time of approximately 9 months before team members are able to redeeem tokens.
110     uint nineMonths = 9 * 30 days;
111     unlockedAt = now.add(nineMonths);
112     //2% tokens from the Marketing bucket which are locked for 9 months
113     allocations[teamStorageVault] = lockedTeamAllocationTokens;
114   }
115 
116   function getTotalAllocation() returns (uint){
117       return lockedTeamAllocationTokens;
118   }
119 
120   function unlock() external payable {
121     if (now < unlockedAt) throw;
122 
123     if (tokensCreated == 0) {
124       tokensCreated = plr.balanceOf(this);
125     }
126     //transfer the locked tokens to the teamStorageAddress
127     plr.transfer(teamStorageVault, tokensCreated);
128   }
129 }
130 
131 contract UnsoldAllocation is Ownable {
132   using SafeMath for uint;
133   uint unlockedAt;
134   uint allocatedTokens;
135   PillarToken plr;
136   mapping (address => uint) allocations;
137 
138   uint tokensCreated = 0;
139 
140   /*
141     Split among team members
142     Tokens reserved for Team: 1,000,000
143     Tokens reserved for 20|30 projects: 1,000,000
144     Tokens reserved for future sale: 1,000,000
145   */
146 
147   function UnsoldAllocation(uint _lockTime, address _owner, uint _tokens) {
148     if(_lockTime == 0) throw;
149 
150     if(_owner == address(0)) throw;
151 
152     plr = PillarToken(msg.sender);
153     uint lockTime = _lockTime * 1 years;
154     unlockedAt = now.add(lockTime);
155     allocatedTokens = _tokens;
156     allocations[_owner] = _tokens;
157   }
158 
159   function getTotalAllocation()returns(uint){
160       return allocatedTokens;
161   }
162 
163   function unlock() external payable {
164     if (now < unlockedAt) throw;
165 
166     if (tokensCreated == 0) {
167       tokensCreated = plr.balanceOf(this);
168     }
169 
170     var allocation = allocations[msg.sender];
171     allocations[msg.sender] = 0;
172     var toTransfer = (tokensCreated.mul(allocation)).div(allocatedTokens);
173     plr.transfer(msg.sender, toTransfer);
174   }
175 }
176 
177 /**
178  * @title Pausable
179  * @dev Base contract which allows children to implement an emergency stop mechanism.
180  */
181 contract Pausable is Ownable {
182   event Pause();
183   event Unpause();
184 
185   bool public paused = false;
186 
187 
188   /**
189    * @dev modifier to allow actions only when the contract IS paused
190    */
191   modifier whenNotPaused() {
192     if (paused) throw;
193     _;
194   }
195 
196   /**
197    * @dev modifier to allow actions only when the contract IS NOT paused
198    */
199   modifier whenPaused {
200     if (!paused) throw;
201     _;
202   }
203 
204   /**
205    * @dev called by the owner to pause, triggers stopped state
206    */
207   function pause() onlyOwner whenNotPaused returns (bool) {
208     paused = true;
209     Pause();
210     return true;
211   }
212 
213   /**
214    * @dev called by the owner to unpause, returns to normal state
215    */
216   function unpause() onlyOwner whenPaused returns (bool) {
217     paused = false;
218     Unpause();
219     return true;
220   }
221 }
222 
223 
224 /**
225  * @title ERC20Basic
226  * @dev Simpler version of ERC20 interface
227  * @dev see https://github.com/ethereum/EIPs/issues/20
228  */
229 contract ERC20Basic {
230   uint public totalSupply;
231   function balanceOf(address who) constant returns (uint);
232   function transfer(address to, uint value);
233   event Transfer(address indexed from, address indexed to, uint value);
234 }
235 
236 /**
237  * @title Basic token
238  * @dev Basic version of StandardToken, with no allowances. 
239  */
240 contract BasicToken is ERC20Basic {
241   using SafeMath for uint;
242 
243   mapping(address => uint) balances;
244 
245   /**
246    * @dev Fix for the ERC20 short address attack.
247    */
248   modifier onlyPayloadSize(uint size) {
249      if(msg.data.length < size + 4) {
250        throw;
251      }
252      _;
253   }
254 
255   /**
256   * @dev transfer token for a specified address
257   * @param _to The address to transfer to.
258   * @param _value The amount to be transferred.
259   */
260   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
261     balances[msg.sender] = balances[msg.sender].sub(_value);
262     balances[_to] = balances[_to].add(_value);
263     Transfer(msg.sender, _to, _value);
264   }
265 
266   /**
267   * @dev Gets the balance of the specified address.
268   * @param _owner The address to query the the balance of. 
269   * @return An uint representing the amount owned by the passed address.
270   */
271   function balanceOf(address _owner) constant returns (uint balance) {
272     return balances[_owner];
273   }
274 
275 }
276 
277 /**
278  * @title ERC20 interface
279  * @dev see https://github.com/ethereum/EIPs/issues/20
280  */
281 contract ERC20 is ERC20Basic {
282   function allowance(address owner, address spender) constant returns (uint);
283   function transferFrom(address from, address to, uint value);
284   function approve(address spender, uint value);
285   event Approval(address indexed owner, address indexed spender, uint value);
286 }
287 
288 /**
289  * @title Standard ERC20 token
290  *
291  * @dev Implemantation of the basic standart token.
292  * @dev https://github.com/ethereum/EIPs/issues/20
293  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
294  */
295 contract StandardToken is BasicToken, ERC20 {
296 
297   mapping (address => mapping (address => uint)) allowed;
298 
299 
300   /**
301    * @dev Transfer tokens from one address to another
302    * @param _from address The address which you want to send tokens from
303    * @param _to address The address which you want to transfer to
304    * @param _value uint the amout of tokens to be transfered
305    */
306   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
307     var _allowance = allowed[_from][msg.sender];
308 
309     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
310     // if (_value > _allowance) throw;
311 
312     balances[_to] = balances[_to].add(_value);
313     balances[_from] = balances[_from].sub(_value);
314     allowed[_from][msg.sender] = _allowance.sub(_value);
315     Transfer(_from, _to, _value);
316   }
317 
318   /**
319    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
320    * @param _spender The address which will spend the funds.
321    * @param _value The amount of tokens to be spent.
322    */
323   function approve(address _spender, uint _value) {
324 
325     // To change the approve amount you first have to reduce the addresses`
326     //  allowance to zero by calling `approve(_spender, 0)` if it is not
327     //  already 0 to mitigate the race condition described here:
328     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
329     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
330 
331     allowed[msg.sender][_spender] = _value;
332     Approval(msg.sender, _spender, _value);
333   }
334 
335   /**
336    * @dev Function to check the amount of tokens than an owner allowed to a spender.
337    * @param _owner address The address which owns the funds.
338    * @param _spender address The address which will spend the funds.
339    * @return A uint specifing the amount of tokens still avaible for the spender.
340    */
341   function allowance(address _owner, address _spender) constant returns (uint remaining) {
342     return allowed[_owner][_spender];
343   }
344 
345 }
346 
347 /// @title PillarToken - Crowdfunding code for the Pillar Project
348 /// @author Parthasarathy Ramanujam, Gustavo Guimaraes, Ronak Thacker
349 contract PillarToken is StandardToken, Ownable {
350 
351     using SafeMath for uint;
352     string public constant name = "PILLAR";
353     string public constant symbol = "PLR";
354     uint public constant decimals = 18;
355 
356     TeamAllocation public teamAllocation;
357     UnsoldAllocation public unsoldTokens;
358     UnsoldAllocation public twentyThirtyAllocation;
359     UnsoldAllocation public futureSaleAllocation;
360 
361     uint constant public minTokensForSale  = 32000000e18;
362 
363     uint constant public maxPresaleTokens             =  48000000e18;
364     uint constant public totalAvailableForSale        = 528000000e18;
365     uint constant public futureTokens                 = 120000000e18;
366     uint constant public twentyThirtyTokens           =  80000000e18;
367     uint constant public lockedTeamAllocationTokens   =  16000000e18;
368     uint constant public unlockedTeamAllocationTokens =   8000000e18;
369 
370     address public unlockedTeamStorageVault = 0x4162Ad6EEc341e438eAbe85f52a941B078210819;
371     address public twentyThirtyVault = 0xe72bA5c6F63Ddd395DF9582800E2821cE5a05D75;
372     address public futureSaleVault = 0xf0231160Bd1a2a2D25aed2F11B8360EbF56F6153;
373     address unsoldVault;
374 
375     //Storage years
376     uint constant coldStorageYears = 10;
377     uint constant futureStorageYears = 3;
378 
379     uint totalPresale = 0;
380 
381     // Funding amount in ether
382     uint public constant tokenPrice  = 0.0005 ether;
383 
384     // Multisigwallet where the proceeds will be stored.
385     address public pillarTokenFactory;
386 
387     uint fundingStartBlock;
388     uint fundingStopBlock;
389 
390     // flags whether ICO is afoot.
391     bool fundingMode;
392 
393     //total used tokens
394     uint totalUsedTokens;
395 
396     event Refund(address indexed _from,uint256 _value);
397     event Migrate(address indexed _from, address indexed _to, uint256 _value);
398     event MoneyAddedForRefund(address _from, uint256 _value,uint256 _total);
399 
400     modifier isNotFundable() {
401         if (fundingMode) throw;
402         _;
403     }
404 
405     modifier isFundable() {
406         if (!fundingMode) throw;
407         _;
408     }
409 
410     //@notice  Constructor of PillarToken
411     //@param `_pillarTokenFactory` - multisigwallet address to store proceeds.
412     //@param `_icedWallet` - Multisigwallet address to which unsold tokens are assigned
413     function PillarToken(address _pillarTokenFactory, address _icedWallet) {
414       if(_pillarTokenFactory == address(0)) throw;
415       if(_icedWallet == address(0)) throw;
416 
417       pillarTokenFactory = _pillarTokenFactory;
418       totalUsedTokens = 0;
419       totalSupply = 800000000e18;
420       unsoldVault = _icedWallet;
421 
422       //allot 8 million of the 24 million marketing tokens to an address
423       balances[unlockedTeamStorageVault] = unlockedTeamAllocationTokens;
424 
425       //allocate tokens for 2030 wallet locked in for 3 years
426       futureSaleAllocation = new UnsoldAllocation(futureStorageYears,futureSaleVault,futureTokens);
427       balances[address(futureSaleAllocation)] = futureTokens;
428 
429       //allocate tokens for future wallet locked in for 3 years
430       twentyThirtyAllocation = new UnsoldAllocation(futureStorageYears,twentyThirtyVault,twentyThirtyTokens);
431       balances[address(twentyThirtyAllocation)] = twentyThirtyTokens;
432 
433       fundingMode = false;
434     }
435 
436     //@notice Fallback function that accepts the ether and allocates tokens to
437     //the msg.sender corresponding to msg.value
438     function() payable isFundable external {
439       purchase();
440     }
441 
442     //@notice function that accepts the ether and allocates tokens to
443     //the msg.sender corresponding to msg.value
444     function purchase() payable isFundable {
445       if(block.number < fundingStartBlock) throw;
446       if(block.number > fundingStopBlock) throw;
447       if(totalUsedTokens >= totalAvailableForSale) throw;
448 
449       if (msg.value < tokenPrice) throw;
450 
451       uint numTokens = msg.value.div(tokenPrice);
452       if(numTokens < 1) throw;
453       //transfer money to PillarTokenFactory MultisigWallet
454       pillarTokenFactory.transfer(msg.value);
455 
456       uint tokens = numTokens.mul(1e18);
457       totalUsedTokens = totalUsedTokens.add(tokens);
458       if (totalUsedTokens > totalAvailableForSale) throw;
459 
460       balances[msg.sender] = balances[msg.sender].add(tokens);
461 
462       //fire the event notifying the transfer of tokens
463       Transfer(0, msg.sender, tokens);
464     }
465 
466     //@notice Function reports the number of tokens available for sale
467     function numberOfTokensLeft() constant returns (uint256) {
468       uint tokensAvailableForSale = totalAvailableForSale.sub(totalUsedTokens);
469       return tokensAvailableForSale;
470     }
471 
472     //@notice Finalize the ICO, send team allocation tokens
473     //@notice send any remaining balance to the MultisigWallet
474     //@notice unsold tokens will be sent to icedwallet
475     function finalize() isFundable onlyOwner external {
476       if (block.number <= fundingStopBlock) throw;
477 
478       if (totalUsedTokens < minTokensForSale) throw;
479 
480       if(unsoldVault == address(0)) throw;
481 
482       // switch funding mode off
483       fundingMode = false;
484 
485       //Allot team tokens to a smart contract which will frozen for 9 months
486       teamAllocation = new TeamAllocation();
487       balances[address(teamAllocation)] = lockedTeamAllocationTokens;
488 
489       //allocate unsold tokens to iced storage
490       uint totalUnSold = numberOfTokensLeft();
491       if(totalUnSold > 0) {
492         unsoldTokens = new UnsoldAllocation(coldStorageYears,unsoldVault,totalUnSold);
493         balances[address(unsoldTokens)] = totalUnSold;
494       }
495 
496       //transfer any balance available to Pillar Multisig Wallet
497       pillarTokenFactory.transfer(this.balance);
498     }
499 
500     //@notice Function that can be called by purchasers to refund
501     //@notice Used only in case the ICO isn't successful.
502     function refund() isFundable external {
503       if(block.number <= fundingStopBlock) throw;
504       if(totalUsedTokens >= minTokensForSale) throw;
505 
506       uint plrValue = balances[msg.sender];
507       if(plrValue == 0) throw;
508 
509       balances[msg.sender] = 0;
510 
511       uint ethValue = plrValue.mul(tokenPrice).div(1e18);
512       msg.sender.transfer(ethValue);
513       Refund(msg.sender, ethValue);
514     }
515 
516     //@notice Function used for funding in case of refund.
517     //@notice Can be called only by the Owner
518     function allocateForRefund() external payable onlyOwner returns (uint){
519       //does nothing just accepts and stores the ether
520       MoneyAddedForRefund(msg.sender,msg.value,this.balance);
521       return this.balance;
522     }
523 
524     //@notice Function to allocate tokens to an user.
525     //@param `_to` the address of an user
526     //@param `_tokens` number of tokens to be allocated.
527     //@notice Can be called only when funding is not active and only by the owner
528     function allocateTokens(address _to,uint _tokens) isNotFundable onlyOwner external {
529       uint numOfTokens = _tokens.mul(1e18);
530       totalPresale = totalPresale.add(numOfTokens);
531 
532       if(totalPresale > maxPresaleTokens) throw;
533 
534       balances[_to] = balances[_to].add(numOfTokens);
535     }
536 
537     //@notice Function to unPause the contract.
538     //@notice Can be called only when funding is active and only by the owner
539     function unPauseTokenSale() onlyOwner isNotFundable external returns (bool){
540       fundingMode = true;
541       return fundingMode;
542     }
543 
544     //@notice Function to pause the contract.
545     //@notice Can be called only when funding is active and only by the owner
546     function pauseTokenSale() onlyOwner isFundable external returns (bool){
547       fundingMode = false;
548       return !fundingMode;
549     }
550 
551     //@notice Function to start the contract.
552     //@param `_fundingStartBlock` - block from when ICO commences
553     //@param `_fundingStopBlock` - block from when ICO ends.
554     //@notice Can be called only when funding is not active and only by the owner
555     function startTokenSale(uint _fundingStartBlock, uint _fundingStopBlock) onlyOwner isNotFundable external returns (bool){
556       if(_fundingStopBlock <= _fundingStartBlock) throw;
557 
558       fundingStartBlock = _fundingStartBlock;
559       fundingStopBlock = _fundingStopBlock;
560       fundingMode = true;
561       return fundingMode;
562     }
563 
564     //@notice Function to get the current funding status.
565     function fundingStatus() external constant returns (bool){
566       return fundingMode;
567     }
568 }