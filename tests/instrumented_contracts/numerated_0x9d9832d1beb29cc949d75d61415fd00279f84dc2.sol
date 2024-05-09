1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC20Basic {
30   uint256 public totalSupply;
31   function balanceOf(address who) constant returns (uint256);
32   function transfer(address to, uint256 value) returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract BasicToken is ERC20Basic {
37   using SafeMath for uint256;
38 
39   mapping(address => uint256) balances;
40 
41   /**
42   * @dev transfer token for a specified address
43   * @param _to The address to transfer to.
44   * @param _value The amount to be transferred.
45   */
46   function transfer(address _to, uint256 _value) returns (bool) {
47     require(_to != address(0));
48 
49     // SafeMath.sub will throw if there is not enough balance.
50     balances[msg.sender] = balances[msg.sender].sub(_value);
51     balances[_to] = balances[_to].add(_value);
52     Transfer(msg.sender, _to, _value);
53     return true;
54   }
55 
56   /**
57   * @dev Gets the balance of the specified address.
58   * @param _owner The address to query the the balance of.
59   * @return An uint256 representing the amount owned by the passed address.
60   */
61   function balanceOf(address _owner) constant returns (uint256 balance) {
62     return balances[_owner];
63   }
64 }
65 
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) constant returns (uint256);
68   function transferFrom(address from, address to, uint256 value) returns (bool);
69   function approve(address spender, uint256 value) returns (bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 contract StandardToken is ERC20, BasicToken {
74 
75   mapping (address => mapping (address => uint256)) allowed;
76 
77 
78   /**
79    * @dev Transfer tokens from one address to another
80    * @param _from address The address which you want to send tokens from
81    * @param _to address The address which you want to transfer to
82    * @param _value uint256 the amount of tokens to be transferred
83    */
84   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
85     require(_to != address(0));
86 
87     var _allowance = allowed[_from][msg.sender];
88 
89     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
90     // require (_value <= _allowance);
91 
92     balances[_from] = balances[_from].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     allowed[_from][msg.sender] = _allowance.sub(_value);
95     Transfer(_from, _to, _value);
96     return true;
97   }
98 
99   /**
100    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
101    * @param _spender The address which will spend the funds.
102    * @param _value The amount of tokens to be spent.
103    */
104   function approve(address _spender, uint256 _value) returns (bool) {
105 
106     // To change the approve amount you first have to reduce the addresses`
107     //  allowance to zero by calling `approve(_spender, 0)` if it is not
108     //  already 0 to mitigate the race condition described here:
109     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
110     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
111 
112     allowed[msg.sender][_spender] = _value;
113     Approval(msg.sender, _spender, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Function to check the amount of tokens that an owner allowed to a spender.
119    * @param _owner address The address which owns the funds.
120    * @param _spender address The address which will spend the funds.
121    * @return A uint256 specifying the amount of tokens still available for the spender.
122    */
123   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
124     return allowed[_owner][_spender];
125   }
126 
127   /**
128    * approve should be called when allowed[_spender] == 0. To increment
129    * allowed value is better to use this function to avoid 2 calls (and wait until
130    * the first transaction is mined)
131    * From MonolithDAO Token.sol
132    */
133   function increaseApproval (address _spender, uint _addedValue)
134     returns (bool success) {
135     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
136     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137     return true;
138   }
139 
140   function decreaseApproval (address _spender, uint _subtractedValue)
141     returns (bool success) {
142     uint oldValue = allowed[msg.sender][_spender];
143     if (_subtractedValue > oldValue) {
144       allowed[msg.sender][_spender] = 0;
145     } else {
146       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
147     }
148     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 }
152 
153 /// @title Token contract - Implements Standard Token Interface with DNN features.
154 /// @author Dondrey Taylor - <dondrey@dnn.media>
155 contract DNNToken is StandardToken {
156 
157     using SafeMath for uint256;
158 
159     ////////////////////////////////////////////////////////////
160     // Used to indicate which allocation we issue tokens from //
161     ////////////////////////////////////////////////////////////
162     enum DNNSupplyAllocations {
163         EarlyBackerSupplyAllocation,
164         PRETDESupplyAllocation,
165         TDESupplyAllocation,
166         BountySupplyAllocation,
167         WriterAccountSupplyAllocation,
168         AdvisorySupplyAllocation,
169         PlatformSupplyAllocation
170     }
171 
172     /////////////////////////////////////////////////////////////////////
173     // Smart-Contract with permission to allocate tokens from supplies //
174     /////////////////////////////////////////////////////////////////////
175     address public allocatorAddress;
176     address public crowdfundContract;
177 
178     /////////////////////
179     // Token Meta Data //
180     /////////////////////
181     string constant public name = "DNN";
182     string constant public symbol = "DNN";
183     uint8 constant public decimals = 18; // 1 DNN = 1 * 10^18 atto-DNN
184 
185     /////////////////////////////////////////
186     // Addresses of the co-founders of DNN //
187     /////////////////////////////////////////
188     address public cofounderA;
189     address public cofounderB;
190 
191     /////////////////////////
192     // Address of Platform //
193     /////////////////////////
194     address public platform;
195 
196     /////////////////////////////////////////////
197     // Token Distributions (% of total supply) //
198     /////////////////////////////////////////////
199     uint256 public earlyBackerSupply; // 10%
200     uint256 public PRETDESupply; // 10%
201     uint256 public TDESupply; // 40%
202     uint256 public bountySupply; // 1%
203     uint256 public writerAccountSupply; // 4%
204     uint256 public advisorySupply; // 14%
205     uint256 public cofoundersSupply; // 10%
206     uint256 public platformSupply; // 11%
207 
208     uint256 public earlyBackerSupplyRemaining; // 10%
209     uint256 public PRETDESupplyRemaining; // 10%
210     uint256 public TDESupplyRemaining; // 40%
211     uint256 public bountySupplyRemaining; // 1%
212     uint256 public writerAccountSupplyRemaining; // 4%
213     uint256 public advisorySupplyRemaining; // 14%
214     uint256 public cofoundersSupplyRemaining; // 10%
215     uint256 public platformSupplyRemaining; // 11%
216 
217     ////////////////////////////////////////////////////////////////////////////////////
218     // Amount of CoFounder Supply that has been distributed based on vesting schedule //
219     ////////////////////////////////////////////////////////////////////////////////////
220     uint256 public cofoundersSupplyVestingTranches = 10;
221     uint256 public cofoundersSupplyVestingTranchesIssued = 0;
222     uint256 public cofoundersSupplyVestingStartDate; // Epoch
223     uint256 public cofoundersSupplyDistributed = 0;  // # of atto-DNN distributed to founders
224 
225     //////////////////////////////////////////////
226     // Prevents tokens from being transferrable //
227     //////////////////////////////////////////////
228     bool public tokensLocked = true;
229 
230     /////////////////////////////////////////////////////////////////////////////
231     // Event triggered when tokens are transferred from one address to another //
232     /////////////////////////////////////////////////////////////////////////////
233     event Transfer(address indexed from, address indexed to, uint256 value);
234 
235     ////////////////////////////////////////////////////////////
236     // Checks if tokens can be issued to founder at this time //
237     ////////////////////////////////////////////////////////////
238     modifier CofoundersTokensVested()
239     {
240         // Make sure that a starting vesting date has been set and 4 weeks have passed since vesting date
241         require (cofoundersSupplyVestingStartDate != 0 && (now-cofoundersSupplyVestingStartDate) >= 4 weeks);
242 
243         // Get current tranche based on the amount of time that has passed since vesting start date
244         uint256 currentTranche = now.sub(cofoundersSupplyVestingStartDate) / 4 weeks;
245 
246         // Amount of tranches that have been issued so far
247         uint256 issuedTranches = cofoundersSupplyVestingTranchesIssued;
248 
249         // Amount of tranches that cofounders are entitled to
250         uint256 maxTranches = cofoundersSupplyVestingTranches;
251 
252         // Make sure that we still have unvested tokens and that
253         // the tokens for the current tranche have not been issued.
254         require (issuedTranches != maxTranches && currentTranche > issuedTranches);
255 
256         _;
257     }
258 
259     ///////////////////////////////////
260     // Checks if tokens are unlocked //
261     ///////////////////////////////////
262     modifier TokensUnlocked()
263     {
264         require (tokensLocked == false);
265         _;
266     }
267 
268     /////////////////////////////////
269     // Checks if tokens are locked //
270     /////////////////////////////////
271     modifier TokensLocked()
272     {
273        require (tokensLocked == true);
274        _;
275     }
276 
277     ////////////////////////////////////////////////////
278     // Checks if CoFounders are performing the action //
279     ////////////////////////////////////////////////////
280     modifier onlyCofounders()
281     {
282         require (msg.sender == cofounderA || msg.sender == cofounderB);
283         _;
284     }
285 
286     ////////////////////////////////////////////////////
287     // Checks if CoFounder A is performing the action //
288     ////////////////////////////////////////////////////
289     modifier onlyCofounderA()
290     {
291         require (msg.sender == cofounderA);
292         _;
293     }
294 
295     ////////////////////////////////////////////////////
296     // Checks if CoFounder B is performing the action //
297     ////////////////////////////////////////////////////
298     modifier onlyCofounderB()
299     {
300         require (msg.sender == cofounderB);
301         _;
302     }
303 
304     //////////////////////////////////////////////////
305     // Checks if Allocator is performing the action //
306     //////////////////////////////////////////////////
307     modifier onlyAllocator()
308     {
309         require (msg.sender == allocatorAddress);
310         _;
311     }
312 
313     ///////////////////////////////////////////////////////////
314     // Checks if Crowdfund Contract is performing the action //
315     ///////////////////////////////////////////////////////////
316     modifier onlyCrowdfundContract()
317     {
318         require (msg.sender == crowdfundContract);
319         _;
320     }
321 
322     ///////////////////////////////////////////////////////////////////////////////////
323     // Checks if Crowdfund Contract, Platform, or Allocator is performing the action //
324     ///////////////////////////////////////////////////////////////////////////////////
325     modifier onlyAllocatorOrCrowdfundContractOrPlatform()
326     {
327         require (msg.sender == allocatorAddress || msg.sender == crowdfundContract || msg.sender == platform);
328         _;
329     }
330 
331     ///////////////////////////////////////////////////////////////////////
332     //  @des Function to change address that is manage platform holding  //
333     //  @param newAddress Address of new issuance contract.              //
334     ///////////////////////////////////////////////////////////////////////
335     function changePlatform(address newAddress)
336         onlyCofounders
337     {
338         platform = newAddress;
339     }
340 
341     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
342     //  @des Function to change address that is allowed to do token issuance. Crowdfund contract can only be set once.   //
343     //  @param newAddress Address of new issuance contract.                                                              //
344     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
345     function changeCrowdfundContract(address newAddress)
346         onlyCofounders
347     {
348         crowdfundContract = newAddress;
349     }
350 
351     /////////////////////////////////////////////////////////////////////////////////////////////////////////////
352     //  @des Function to change address that is allowed to do token issuance. Allocator can only be set once.  //
353     //  @param newAddress Address of new issuance contract.                                                    //
354     /////////////////////////////////////////////////////////////////////////////////////////////////////////////
355     function changeAllocator(address newAddress)
356         onlyCofounders
357     {
358         allocatorAddress = newAddress;
359     }
360 
361     ///////////////////////////////////////////////////////
362     //  @des Function to change founder A address.       //
363     //  @param newAddress Address of new founder A.      //
364     ///////////////////////////////////////////////////////
365     function changeCofounderA(address newAddress)
366         onlyCofounderA
367     {
368         cofounderA = newAddress;
369     }
370 
371     //////////////////////////////////////////////////////
372     //  @des Function to change founder B address.      //
373     //  @param newAddress Address of new founder B.     //
374     //////////////////////////////////////////////////////
375     function changeCofounderB(address newAddress)
376         onlyCofounderB
377     {
378         cofounderB = newAddress;
379     }
380 
381 
382     //////////////////////////////////////////////////////////////
383     // Transfers tokens from senders address to another address //
384     //////////////////////////////////////////////////////////////
385     function transfer(address _to, uint256 _value)
386       TokensUnlocked
387       returns (bool)
388     {
389           Transfer(msg.sender, _to, _value);
390           return BasicToken.transfer(_to, _value);
391     }
392 
393     //////////////////////////////////////////////////////////
394     // Transfers tokens from one address to another address //
395     //////////////////////////////////////////////////////////
396     function transferFrom(address _from, address _to, uint256 _value)
397       TokensUnlocked
398       returns (bool)
399     {
400           Transfer(_from, _to, _value);
401           return StandardToken.transferFrom(_from, _to, _value);
402     }
403 
404 
405     ///////////////////////////////////////////////////////////////////////////////////////////////
406     //  @des Cofounders issue tokens to themsleves if within vesting period. Returns success.    //
407     //  @param beneficiary Address of receiver.                                                  //
408     //  @param tokenCount Number of tokens to issue.                                             //
409     ///////////////////////////////////////////////////////////////////////////////////////////////
410     function issueCofoundersTokensIfPossible()
411         onlyCofounders
412         CofoundersTokensVested
413         returns (bool)
414     {
415         // Compute total amount of vested tokens to issue
416         uint256 tokenCount = cofoundersSupply.div(cofoundersSupplyVestingTranches);
417 
418         // Make sure that there are cofounder tokens left
419         if (tokenCount > cofoundersSupplyRemaining) {
420            return false;
421         }
422 
423         // Decrease cofounders supply
424         cofoundersSupplyRemaining = cofoundersSupplyRemaining.sub(tokenCount);
425 
426         // Update how many tokens have been distributed to cofounders
427         cofoundersSupplyDistributed = cofoundersSupplyDistributed.add(tokenCount);
428 
429         // Split tokens between both founders
430         balances[cofounderA] = balances[cofounderA].add(tokenCount.div(2));
431         balances[cofounderB] = balances[cofounderB].add(tokenCount.div(2));
432 
433         // Update that a tranche has been issued
434         cofoundersSupplyVestingTranchesIssued += 1;
435 
436         return true;
437     }
438 
439 
440     //////////////////
441     // Issue tokens //
442     //////////////////
443     function issueTokens(address beneficiary, uint256 tokenCount, DNNSupplyAllocations allocationType)
444       onlyAllocatorOrCrowdfundContractOrPlatform
445       returns (bool)
446     {
447         // We'll use the following to determine whether the allocator, platform,
448         // or the crowdfunding contract can allocate specified supply
449         bool canAllocatorPerform = msg.sender == allocatorAddress;
450         bool canCrowdfundContractPerform = msg.sender == crowdfundContract;
451         bool canPlatformPerform = msg.sender == platform;
452 
453         // Early Backers
454         if (canAllocatorPerform && allocationType == DNNSupplyAllocations.EarlyBackerSupplyAllocation && tokenCount <= earlyBackerSupplyRemaining) {
455             earlyBackerSupplyRemaining = earlyBackerSupplyRemaining.sub(tokenCount);
456         }
457 
458         // PRE-TDE
459         else if (canCrowdfundContractPerform && msg.sender == crowdfundContract && allocationType == DNNSupplyAllocations.PRETDESupplyAllocation) {
460 
461               // Check to see if we have enough tokens to satisfy this purchase
462               // using just the pre-tde.
463               if (PRETDESupplyRemaining >= tokenCount) {
464 
465                     // Decrease pre-tde supply
466                     PRETDESupplyRemaining = PRETDESupplyRemaining.sub(tokenCount);
467               }
468 
469               // Check to see if we can satisfy this using pre-tde and tde supply combined
470               else if (PRETDESupplyRemaining+TDESupplyRemaining >= tokenCount) {
471 
472                     // Decrease tde supply
473                     TDESupplyRemaining = TDESupplyRemaining.sub(tokenCount-PRETDESupplyRemaining);
474 
475                     // Decrease pre-tde supply by its' remaining tokens
476                     PRETDESupplyRemaining = 0;
477               }
478 
479               // Otherwise, we can't satisfy this sale because we don't have enough tokens.
480               else {
481                   return false;
482               }
483         }
484 
485         // TDE
486         else if (canCrowdfundContractPerform && allocationType == DNNSupplyAllocations.TDESupplyAllocation && tokenCount <= TDESupplyRemaining) {
487             TDESupplyRemaining = TDESupplyRemaining.sub(tokenCount);
488         }
489 
490         // Bounty
491         else if (canAllocatorPerform && allocationType == DNNSupplyAllocations.BountySupplyAllocation && tokenCount <= bountySupplyRemaining) {
492             bountySupplyRemaining = bountySupplyRemaining.sub(tokenCount);
493         }
494 
495         // Writer Accounts
496         else if (canAllocatorPerform && allocationType == DNNSupplyAllocations.WriterAccountSupplyAllocation && tokenCount <= writerAccountSupplyRemaining) {
497             writerAccountSupplyRemaining = writerAccountSupplyRemaining.sub(tokenCount);
498         }
499 
500         // Advisory
501         else if (canAllocatorPerform && allocationType == DNNSupplyAllocations.AdvisorySupplyAllocation && tokenCount <= advisorySupplyRemaining) {
502             advisorySupplyRemaining = advisorySupplyRemaining.sub(tokenCount);
503         }
504 
505         // Platform (Also makes sure that the beneficiary is the platform address specified in this contract)
506         else if (canPlatformPerform && allocationType == DNNSupplyAllocations.PlatformSupplyAllocation && tokenCount <= platformSupplyRemaining) {
507             platformSupplyRemaining = platformSupplyRemaining.sub(tokenCount);
508         }
509 
510         else {
511             return false;
512         }
513 
514         // Transfer tokens
515         Transfer(address(this), beneficiary, tokenCount);
516 
517         // Credit tokens to the address specified
518         balances[beneficiary] = balances[beneficiary].add(tokenCount);
519 
520         return true;
521     }
522 
523     /////////////////////////////////////////////////
524     // Transfer Unsold tokens from TDE to Platform //
525     /////////////////////////////////////////////////
526     function sendUnsoldTDETokensToPlatform()
527       external
528       onlyCrowdfundContract
529     {
530         // Make sure we have tokens to send from TDE
531         if (TDESupplyRemaining > 0) {
532 
533             // Add remaining tde tokens to platform remaining tokens
534             platformSupplyRemaining = platformSupplyRemaining.add(TDESupplyRemaining);
535 
536             // Clear remaining tde token count
537             TDESupplyRemaining = 0;
538         }
539     }
540 
541     /////////////////////////////////////////////////////
542     // Transfer Unsold tokens from pre-TDE to Platform //
543     /////////////////////////////////////////////////////
544     function sendUnsoldPRETDETokensToTDE()
545       external
546       onlyCrowdfundContract
547     {
548           // Make sure we have tokens to send from pre-TDE
549           if (PRETDESupplyRemaining > 0) {
550 
551               // Add remaining pre-tde tokens to tde remaining tokens
552               TDESupplyRemaining = TDESupplyRemaining.add(PRETDESupplyRemaining);
553 
554               // Clear remaining pre-tde token count
555               PRETDESupplyRemaining = 0;
556         }
557     }
558 
559     ////////////////////////////////////////////////////////////////
560     // @des Allows tokens to be transferrable. Returns lock state //
561     ////////////////////////////////////////////////////////////////
562     function unlockTokens()
563         external
564         onlyCrowdfundContract
565     {
566         // Make sure tokens are currently locked before proceeding to unlock them
567         require(tokensLocked == true);
568 
569         tokensLocked = false;
570     }
571 
572     ///////////////////////////////////////////////////////////////////////
573     //  @des Contract constructor function sets initial token balances.  //
574     ///////////////////////////////////////////////////////////////////////
575     function DNNToken()
576     {
577           // Start date
578           uint256 vestingStartDate = 1526072145;
579 
580           // Set cofounder addresses
581           cofounderA = 0x3Cf26a9FE33C219dB87c2e50572e50803eFb2981;
582           cofounderB = 0x9FFE2aD5D76954C7C25be0cEE30795279c4Cab9f;
583 
584           // Sets platform address
585           platform = address(this);
586 
587           // Set total supply - 1 Billion DNN Tokens = (1,000,000,000 * 10^18) atto-DNN
588           // 1 DNN = 10^18 atto-DNN
589           totalSupply = uint256(1000000000).mul(uint256(10)**decimals);
590 
591           // Set Token Distributions (% of total supply)
592           earlyBackerSupply = totalSupply.mul(10).div(100); // 10%
593           PRETDESupply = totalSupply.mul(10).div(100); // 10%
594           TDESupply = totalSupply.mul(40).div(100); // 40%
595           bountySupply = totalSupply.mul(1).div(100); // 1%
596           writerAccountSupply = totalSupply.mul(4).div(100); // 4%
597           advisorySupply = totalSupply.mul(14).div(100); // 14%
598           cofoundersSupply = totalSupply.mul(10).div(100); // 10%
599           platformSupply = totalSupply.mul(11).div(100); // 11%
600 
601           // Set each remaining token count equal to its' respective supply
602           earlyBackerSupplyRemaining = earlyBackerSupply;
603           PRETDESupplyRemaining = PRETDESupply;
604           TDESupplyRemaining = TDESupply;
605           bountySupplyRemaining = bountySupply;
606           writerAccountSupplyRemaining = writerAccountSupply;
607           advisorySupplyRemaining = advisorySupply;
608           cofoundersSupplyRemaining = cofoundersSupply;
609           platformSupplyRemaining = platformSupply;
610 
611           // Sets cofounder vesting start date (Ensures that it is a date in the future, otherwise it will default to now)
612           cofoundersSupplyVestingStartDate = vestingStartDate >= now ? vestingStartDate : now;
613     }
614 }