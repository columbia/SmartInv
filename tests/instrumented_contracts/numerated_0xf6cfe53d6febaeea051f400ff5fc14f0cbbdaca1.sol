1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert() on error
7  */
8 library SafeMath {
9   function mul(uint a, uint b) internal returns (uint) {
10     uint c = a * b;
11     asserts(a == 0 || c / a == b);
12     return c;
13   }
14   function safeSub(uint a, uint b) internal returns (uint) {
15     asserts(b <= a);
16     return a - b;
17   }
18   function div(uint a, uint b) internal returns (uint) {
19     asserts(b > 0);
20     uint c = a / b;
21     asserts(a == b * c + a % b);
22     return c;
23   }
24   function sub(uint a, uint b) internal returns (uint) {
25     asserts(b <= a);
26     return a - b;
27   }
28   function add(uint a, uint b) internal returns (uint) {
29     uint c = a + b;
30     asserts(c >= a);
31     return c;
32   }
33   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a >= b ? a : b;
35   }
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
43     return a < b ? a : b;
44   }
45   function asserts(bool assertion) internal {
46     if (!assertion) {
47       revert();
48     }
49   }
50 }
51 
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61   function Ownable() {
62     owner = msg.sender;
63   }
64 
65   modifier onlyOwner {
66     if (msg.sender != owner) revert();
67     _;
68   }
69 }
70 
71 
72 /**
73  * @title Pausable
74  * @dev Base contract which allows children to implement an emergency stop mechanism.
75  */
76 contract Pausable is Ownable {
77   bool public stopped;
78   modifier stopInEmergency {
79     if (stopped) {
80       revert();
81     }
82     _;
83   }
84 
85   modifier onlyInEmergency {
86     if (!stopped) {
87       revert();
88     }
89     _;
90   }
91 
92   // called by the owner on emergency, triggers stopped state
93   function emergencyStop() external onlyOwner {
94     stopped = true;
95   }
96 
97   // called by the owner on end of emergency, returns to normal state
98   function release() external onlyOwner onlyInEmergency {
99     stopped = false;
100   }
101 }
102 
103 /**
104  * ERC 20 token
105  *
106  * https://github.com/ethereum/EIPs/issues/20
107  */
108 contract Token {
109   /// @return total amount of tokens
110   function totalSupply() constant returns (uint256 supply) {}
111 
112   /// @param _owner The address from which the balance will be retrieved
113   /// @return The balance
114   function balanceOf(address _owner) constant returns (uint256 balance) {}
115 
116   /// @notice send `_value` token to `_to` from `msg.sender`
117   /// @param _to The address of the recipient
118   /// @param _value The amount of token to be transferred
119   /// @return Whether the transfer was successful or not
120   function transfer(address _to, uint256 _value) returns (bool success) {}
121 
122   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
123   /// @param _from The address of the sender
124   /// @param _to The address of the recipient
125   /// @param _value The amount of token to be transferred
126   /// @return Whether the transfer was successful or not
127   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
128 
129   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
130   /// @param _spender The address of the account able to transfer the tokens
131   /// @param _value The amount of wei to be approved for transfer
132   /// @return Whether the approval was successful or not
133   function approve(address _spender, uint256 _value) returns (bool success) {}
134 
135   /// @param _owner The address of the account owning tokens
136   /// @param _spender The address of the account able to transfer the tokens
137   /// @return Amount of remaining tokens allowed to spent
138   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
139 
140   event Transfer(address indexed _from, address indexed _to, uint256 _value);
141   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
142 }
143 
144 /**
145  * ERC 20 token
146  *
147  * https://github.com/ethereum/EIPs/issues/20
148  */
149 contract StandardToken is Token {
150   /**
151    * Reviewed:
152    * - Interger overflow = OK, checked
153    */
154   function transfer(address _to, uint256 _value) returns (bool success) {
155     //Default assumes totalSupply can't be over max (2^256 - 1).
156     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
157     //Replace the if with this one instead.
158     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
159     //if (balances[msg.sender] >= _value && _value > 0) {
160       balances[msg.sender] -= _value;
161       balances[_to] += _value;
162       Transfer(msg.sender, _to, _value);
163       return true;
164     } else {
165       return false;
166     }
167   }
168 
169   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
170     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
171       balances[_to] += _value;
172       balances[_from] -= _value;
173       allowed[_from][msg.sender] -= _value;
174       Transfer(_from, _to, _value);
175       return true;
176     } else {
177       return false;
178     }
179   }
180 
181   function balanceOf(address _owner) constant returns (uint256 balance) {
182     return balances[_owner];
183   }
184 
185   function approve(address _spender, uint256 _value) returns (bool success) {
186     allowed[msg.sender][_spender] = _value;
187     Approval(msg.sender, _spender, _value);
188     return true;
189   }
190 
191   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
192     return allowed[_owner][_spender];
193   }
194 
195   mapping(address => uint256) balances;
196 
197   mapping (address => mapping (address => uint256)) allowed;
198 
199   uint256 public totalSupply;
200 }
201 
202 
203 contract DigipulseFirstRoundToken is StandardToken {
204   using SafeMath for uint;
205 }
206 
207 contract DigipulseToken is StandardToken, Pausable {
208   using SafeMath for uint;
209 
210   // Digipulse Token setup
211   string public           name                    = "DigiPulse Token";
212   string public           symbol                  = "DGPT";
213   uint8 public            decimals                = 18;
214   string public           version                 = 'v0.0.3';
215   address public          owner                   = msg.sender;
216   uint freezeTransferForOwnerTime;
217 
218   // Token information
219   address public DGPTokenOldContract = 0x9AcA6aBFe63A5ae0Dc6258cefB65207eC990Aa4D;
220   DigipulseFirstRoundToken public coin;
221 
222 
223   // Token details
224 
225   // ICO details
226   bool public             finalizedCrowdfunding   = false;
227   uint public constant    MIN_CAP                 = 500   * 1e18;
228   uint public constant    MAX_CAP                 = 41850 * 1e18; // + 1600 OBR + 1200 PRE
229   uint public             TierAmount              = 8300  * 1e18;
230   uint public constant    TOKENS_PER_ETH          = 250;
231   uint public constant    MIN_INVEST_ETHER        = 500 finney;
232   uint public             startTime;
233   uint public             endTime;
234   uint public             etherReceived;
235   uint public             coinSentToEther;
236   bool public             isFinalized;
237 
238   // Original Backers round
239   bool public             isOBR;
240   uint public             raisedOBR;
241   uint public             MAX_OBR_CAP             = 1600  * 1e18;
242   uint public             OBR_Duration;
243 
244   // Enums
245   enum TierState{Completed, Tier01, Tier02, Tier03, Tier04, Tier05, Overspend, Failure, OBR}
246 
247   // Modifiers
248   modifier minCapNotReached() {
249     require (now < endTime && etherReceived <= MIN_CAP);
250     _;
251   }
252 
253   // Mappings
254   mapping(address => Backer) public backers;
255   struct Backer {
256     uint weiReceived;
257     uint coinSent;
258   }
259 
260   // Events
261   event LogReceivedETH(address addr, uint value);
262   event LogCoinsEmited(address indexed from, uint amount);
263 
264 
265   // Bounties, Presale, Company tokens
266   address public          presaleWallet           = 0x83D0Aa2292efD8475DF241fBA42fe137dA008d79;
267   address public          companyWallet           = 0x5C967dE68FC54365872203D49B51cDc79a61Ca85;
268   address public          bountyWallet            = 0x49fe3E535906d10e55E2e4AD47ff6cB092Abc692;
269 
270   // Allocated 10% for the team members
271   address public          teamWallet_1            = 0x91D9B09a4157e02783D5D19f7DfC66a759bDc1E4;
272   address public          teamWallet_2            = 0x56298A4e0f60Ab4A323EDB0b285A9421F8e6E276;
273   address public          teamWallet_3            = 0x09e9e24b3e6bA1E714FB86B04602a7Aa62D587FD;
274   address public          teamWallet_4            = 0x2F4283D0362A3AaEe359aC55F2aC7a4615f97c46;
275 
276 
277 
278   mapping(address => uint256) public payments;
279   uint256 public totalPayments;
280 
281 
282   function asyncSend(address dest, uint256 amount) internal {
283     payments[dest] = payments[dest].add(amount);
284     totalPayments = totalPayments.add(amount);
285   }
286 
287 
288   function withdrawPayments() onlyOwner {
289     // Can only be called if the ICO is successfull
290     require (isFinalized);
291     require (etherReceived != 0);
292 
293     owner.transfer(this.balance);
294   }
295 
296 
297   // Init contract
298   function DigipulseToken() {
299     coin = DigipulseFirstRoundToken(DGPTokenOldContract);
300     isOBR = true;
301     isFinalized = false;
302     start();
303 
304     // Allocate tokens
305     balances[presaleWallet]         = 600000 * 1e18;                // 600.000 for presale (closed already)
306     Transfer(0x0, presaleWallet, 600000 * 1e18);
307 
308     balances[teamWallet_1]          = 20483871 * 1e16;              // 1% for team member 1
309     Transfer(0x0, teamWallet_1, 20483871 * 1e16);
310 
311     balances[teamWallet_2]          = 901290324 * 1e15;             // 4.4% for team member 2
312     Transfer(0x0, teamWallet_2, 901290324 * 1e15);
313 
314     balances[teamWallet_3]          = 901290324 * 1e15;             // 4.4% for team member 3
315     Transfer(0x0, teamWallet_3, 901290324 * 1e15);
316 
317     balances[teamWallet_4]          = 40967724 * 1e15;              // 0.2% for team member 4
318     Transfer(0x0, teamWallet_4, 40967724 * 1e15);
319 
320     balances[companyWallet]          = 512096775 * 1e16;            // Company shares
321     Transfer(0x0, companyWallet, 512096775 * 1e16);
322 
323     balances[bountyWallet]          = 61451613 * 1e16;              // Bounty shares
324     Transfer(0x0, bountyWallet, 61451613 * 1e16);
325 
326     balances[this]                  = 12100000 * 1e18;              // Tokens to be issued during the crowdsale
327     Transfer(0x0, this, 12100000 * 1e18);
328 
329     totalSupply = 20483871 * 1e18;
330   }
331 
332 
333   function start() onlyOwner {
334     if (startTime != 0) revert();
335     startTime    =  1506610800 ;  //28/09/2017 03:00 PM UTC
336     endTime      =  1509494400 ;  //01/11/2017 00:00 PM UTC
337     OBR_Duration =  startTime + 72 hours;
338   }
339 
340 
341   function toWei(uint _amount) constant returns (uint256 result){
342     // Set to finney for ease of testing on ropsten: 1e15 (or smaller) || Ether for main net 1e18
343     result = _amount.mul(1e18);
344     return result;
345   }
346 
347 
348   function isOriginalRoundContributor() constant returns (bool _state){
349     uint balance = coin.balanceOf(msg.sender);
350     if (balance > 0) return true;
351   }
352 
353 
354   function() payable {
355     if (isOBR) {
356       buyDigipulseOriginalBackersRound(msg.sender);
357     } else {
358       buyDigipulseTokens(msg.sender);
359     }
360   }
361 
362 
363   function buyDigipulseOriginalBackersRound(address beneficiary) internal  {
364     // User must have old tokens
365     require (isOBR);
366     require(msg.value > 0);
367     require(msg.value > MIN_INVEST_ETHER);
368     require(isOriginalRoundContributor());
369 
370     uint ethRaised          = raisedOBR;
371     uint userContribution   = msg.value;
372     uint shouldBecome       = ethRaised.add(userContribution);
373     uint excess             = 0;
374     Backer storage backer   = backers[beneficiary];
375 
376     // Define excess and amount to include
377     if (shouldBecome > MAX_OBR_CAP) {
378       userContribution = MAX_OBR_CAP - ethRaised;
379       excess = msg.value - userContribution;
380     }
381 
382     uint tierBonus   = getBonusPercentage( userContribution );
383     balances[beneficiary] += tierBonus;
384     balances[this]      -= tierBonus;
385     raisedOBR = raisedOBR.add(userContribution);
386     backer.coinSent = backer.coinSent.add(tierBonus);
387     backer.weiReceived = backer.weiReceived.add(userContribution);
388 
389     if (raisedOBR >= MAX_OBR_CAP) {
390       isOBR = false;
391     }
392 
393     Transfer(this, beneficiary, tierBonus);
394     LogCoinsEmited(beneficiary, tierBonus);
395     LogReceivedETH(beneficiary, userContribution);
396 
397     // Send excess back
398     if (excess > 0) {
399       assert(msg.sender.send(excess));
400     }
401   }
402 
403 
404   function buyDigipulseTokens(address beneficiary) internal {
405     require (!finalizedCrowdfunding);
406     require (now > OBR_Duration);
407     require (msg.value > MIN_INVEST_ETHER);
408 
409     uint CurrentTierMax = getCurrentTier().mul(TierAmount);
410 
411     // Account for last tier with extra 350 ETH
412     if (getCurrentTier() == 5) {
413       CurrentTierMax = CurrentTierMax.add(350 * 1e18);
414     }
415     uint userContribution = msg.value;
416     uint shouldBecome = etherReceived.add(userContribution);
417     uint tierBonus = 0;
418     uint excess = 0;
419     uint excess_bonus = 0;
420 
421     Backer storage backer = backers[beneficiary];
422 
423     // Define excess over tier and amount to include
424     if (shouldBecome > CurrentTierMax) {
425       userContribution = CurrentTierMax - etherReceived;
426       excess = msg.value - userContribution;
427     }
428 
429     tierBonus = getBonusPercentage( userContribution );
430     balances[beneficiary] += tierBonus;
431     balances[this] -= tierBonus;
432     etherReceived = etherReceived.add(userContribution);
433     backer.coinSent = backer.coinSent.add(tierBonus);
434     backer.weiReceived = backer.weiReceived.add(userContribution);
435     Transfer(this, beneficiary, tierBonus);
436 
437     // Tap into next tier with appropriate bonuses
438     if (excess > 0 && etherReceived < MAX_CAP) {
439       excess_bonus = getBonusPercentage( excess );
440       balances[beneficiary] += excess_bonus;
441       balances[this] -= excess_bonus;
442       etherReceived = etherReceived.add(excess);
443       backer.coinSent = backer.coinSent.add(excess_bonus);
444       backer.weiReceived = backer.weiReceived.add(excess);
445       Transfer(this, beneficiary, excess_bonus);
446     }
447 
448     LogCoinsEmited(beneficiary, tierBonus.add(excess_bonus));
449     LogReceivedETH(beneficiary, userContribution.add(excess));
450 
451     if(etherReceived >= MAX_CAP) {
452       finalizedCrowdfunding = true;
453     }
454 
455     // Send excess back
456     if (excess > 0 && etherReceived == MAX_CAP) {
457       assert(msg.sender.send(excess));
458     }
459   }
460 
461 
462   function getCurrentTier() returns (uint Tier) {
463     uint ethRaised = etherReceived;
464 
465     if (isOBR) return uint(TierState.OBR);
466 
467     if (ethRaised >= 0 && ethRaised < toWei(8300)) return uint(TierState.Tier01);
468     else if (ethRaised >= toWei(8300) && ethRaised < toWei(16600)) return uint(TierState.Tier02);
469     else if (ethRaised >= toWei(16600) && ethRaised < toWei(24900)) return uint(TierState.Tier03);
470     else if (ethRaised >= toWei(24900) && ethRaised < toWei(33200)) return uint(TierState.Tier04);
471     else if (ethRaised >= toWei(33200) && ethRaised <= toWei(MAX_CAP)) return uint(TierState.Tier05); // last tier has 8650
472     else if (ethRaised > toWei(MAX_CAP)) {
473       finalizedCrowdfunding = true;
474       return uint(TierState.Overspend);
475     }
476     else return uint(TierState.Failure);
477   }
478 
479 
480   function getBonusPercentage(uint contribution) returns (uint _amount) {
481     uint tier = getCurrentTier();
482 
483     uint bonus =
484         tier == 1 ? 20 :
485         tier == 2 ? 15 :
486         tier == 3 ? 10 :
487         tier == 4 ? 5 :
488         tier == 5 ? 0 :
489         tier == 8 ? 50 :
490                     0;
491 
492     return contribution.mul(TOKENS_PER_ETH).mul(bonus + 100).div(100);
493   }
494 
495 
496   function refund(uint _value) minCapNotReached public {
497 
498     if (_value != backers[msg.sender].coinSent) revert(); // compare value from backer balance
499 
500     uint ETHToSend = backers[msg.sender].weiReceived;
501     backers[msg.sender].weiReceived=0;
502 
503     if (ETHToSend > 0) {
504       asyncSend(msg.sender, ETHToSend); // pull payment to get refund in ETH
505     }
506   }
507 
508 
509   function finalize() onlyOwner public {
510     require (now >= endTime);
511     require (etherReceived >= MIN_CAP);
512 
513     finalizedCrowdfunding = true;
514     isFinalized = true;
515     freezeTransferForOwnerTime = now + 182 days;
516   }
517 
518 
519   function transfer(address _to, uint256 _value) returns (bool success) {
520     require(isFinalized);
521 
522     if (msg.sender == owner) {
523       require(now > freezeTransferForOwnerTime);
524     }
525 
526     return super.transfer(_to, _value);
527   }
528 
529 
530   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
531     require(isFinalized);
532 
533     if (msg.sender == owner) {
534       require(now > freezeTransferForOwnerTime);
535     }
536 
537     return super.transferFrom(_from, _to, _value);
538   }
539 }