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
153 contract DNNToken is StandardToken {
154 
155     using SafeMath for uint256;
156 
157     ////////////////////////////////////////////////////////////
158     // Used to indicate which allocation we issue tokens from //
159     ////////////////////////////////////////////////////////////
160     enum DNNSupplyAllocations {
161         EarlyBackerSupplyAllocation,
162         PRETDESupplyAllocation,
163         TDESupplyAllocation,
164         BountySupplyAllocation,
165         WriterAccountSupplyAllocation,
166         AdvisorySupplyAllocation,
167         PlatformSupplyAllocation
168     }
169 
170     /////////////////////////////////////////////////////////////////////
171     // Smart-Contract with permission to allocate tokens from supplies //
172     /////////////////////////////////////////////////////////////////////
173     address public allocatorAddress;
174     address public crowdfundContract;
175 
176     /////////////////////
177     // Token Meta Data //
178     /////////////////////
179     string constant public name = "DNN";
180     string constant public symbol = "DNN";
181     uint8 constant public decimals = 18; // 1 DNN = 1 * 10^18 atto-DNN
182 
183     /////////////////////////////////////////
184     // Addresses of the co-founders of DNN //
185     /////////////////////////////////////////
186     address public cofounderA;
187     address public cofounderB;
188 
189     /////////////////////////
190     // Address of Platform //
191     /////////////////////////
192     address public platform;
193 
194     /////////////////////////////////////////////
195     // Token Distributions (% of total supply) //
196     /////////////////////////////////////////////
197     uint256 public earlyBackerSupply; // 10%
198     uint256 public PRETDESupply; // 10%
199     uint256 public TDESupply; // 40%
200     uint256 public bountySupply; // 1%
201     uint256 public writerAccountSupply; // 4%
202     uint256 public advisorySupply; // 14%
203     uint256 public cofoundersSupply; // 10%
204     uint256 public platformSupply; // 11%
205 
206     uint256 public earlyBackerSupplyRemaining; // 10%
207     uint256 public PRETDESupplyRemaining; // 10%
208     uint256 public TDESupplyRemaining; // 40%
209     uint256 public bountySupplyRemaining; // 1%
210     uint256 public writerAccountSupplyRemaining; // 4%
211     uint256 public advisorySupplyRemaining; // 14%
212     uint256 public cofoundersSupplyRemaining; // 10%
213     uint256 public platformSupplyRemaining; // 11%
214 
215     ////////////////////////////////////////////////////////////////////////////////////
216     // Amount of CoFounder Supply that has been distributed based on vesting schedule //
217     ////////////////////////////////////////////////////////////////////////////////////
218     uint256 public cofoundersSupplyVestingTranches = 10;
219     uint256 public cofoundersSupplyVestingTranchesIssued = 0;
220     uint256 public cofoundersSupplyVestingStartDate; // Epoch
221     uint256 public cofoundersSupplyDistributed = 0;  // # of atto-DNN distributed to founders
222 
223     //////////////////////////////////////////////
224     // Prevents tokens from being transferrable //
225     //////////////////////////////////////////////
226     bool public tokensLocked = true;
227 
228     /////////////////////////////////////////////////////////////////////////////
229     // Event triggered when tokens are transferred from one address to another //
230     /////////////////////////////////////////////////////////////////////////////
231     event Transfer(address indexed from, address indexed to, uint256 value);
232 
233     ////////////////////////////////////////////////////////////
234     // Checks if tokens can be issued to founder at this time //
235     ////////////////////////////////////////////////////////////
236     modifier CofoundersTokensVested()
237     {
238         // Make sure that a starting vesting date has been set and 4 weeks have passed since vesting date
239         require (cofoundersSupplyVestingStartDate != 0 && (now-cofoundersSupplyVestingStartDate) >= 4 weeks);
240 
241         // Get current tranche based on the amount of time that has passed since vesting start date
242         uint256 currentTranche = now.sub(cofoundersSupplyVestingStartDate) / 4 weeks;
243 
244         // Amount of tranches that have been issued so far
245         uint256 issuedTranches = cofoundersSupplyVestingTranchesIssued;
246 
247         // Amount of tranches that cofounders are entitled to
248         uint256 maxTranches = cofoundersSupplyVestingTranches;
249 
250         // Make sure that we still have unvested tokens and that
251         // the tokens for the current tranche have not been issued.
252         require (issuedTranches != maxTranches && currentTranche > issuedTranches);
253 
254         _;
255     }
256 
257     ///////////////////////////////////
258     // Checks if tokens are unlocked //
259     ///////////////////////////////////
260     modifier TokensUnlocked()
261     {
262         require (tokensLocked == false);
263         _;
264     }
265 
266     /////////////////////////////////
267     // Checks if tokens are locked //
268     /////////////////////////////////
269     modifier TokensLocked()
270     {
271        require (tokensLocked == true);
272        _;
273     }
274 
275     ////////////////////////////////////////////////////
276     // Checks if CoFounders are performing the action //
277     ////////////////////////////////////////////////////
278     modifier onlyCofounders()
279     {
280         require (msg.sender == cofounderA || msg.sender == cofounderB);
281         _;
282     }
283 
284     ////////////////////////////////////////////////////
285     // Checks if CoFounder A is performing the action //
286     ////////////////////////////////////////////////////
287     modifier onlyCofounderA()
288     {
289         require (msg.sender == cofounderA);
290         _;
291     }
292 
293     ////////////////////////////////////////////////////
294     // Checks if CoFounder B is performing the action //
295     ////////////////////////////////////////////////////
296     modifier onlyCofounderB()
297     {
298         require (msg.sender == cofounderB);
299         _;
300     }
301 
302     /////////////////////////////////////////////////////////////////////
303     // Checks to see if we are allowed to change the allocator address //
304     /////////////////////////////////////////////////////////////////////
305     modifier CanSetAllocator()
306     {
307        require (allocatorAddress == address(0x0) || tokensLocked == false);
308        _;
309     }
310 
311     //////////////////////////////////////////////////////////////////////
312     // Checks to see if we are allowed to change the crowdfund contract //
313     //////////////////////////////////////////////////////////////////////
314     modifier CanSetCrowdfundContract()
315     {
316        require (crowdfundContract == address(0x0));
317        _;
318     }
319 
320     //////////////////////////////////////////////////
321     // Checks if Allocator is performing the action //
322     //////////////////////////////////////////////////
323     modifier onlyAllocator()
324     {
325         require (msg.sender == allocatorAddress && tokensLocked == false);
326         _;
327     }
328 
329     ///////////////////////////////////////////////////////////
330     // Checks if Crowdfund Contract is performing the action //
331     ///////////////////////////////////////////////////////////
332     modifier onlyCrowdfundContract()
333     {
334         require (msg.sender == crowdfundContract);
335         _;
336     }
337 
338     ///////////////////////////////////////////////////////////////////////////////////
339     // Checks if Crowdfund Contract, Platform, or Allocator is performing the action //
340     ///////////////////////////////////////////////////////////////////////////////////
341     modifier onlyAllocatorOrCrowdfundContractOrPlatform()
342     {
343         require (msg.sender == allocatorAddress || msg.sender == crowdfundContract || msg.sender == platform);
344         _;
345     }
346 
347     ///////////////////////////////////////////////////////////////////////
348     //  @des Function to change address that is manage platform holding  //
349     //  @param newAddress Address of new issuance contract.              //
350     ///////////////////////////////////////////////////////////////////////
351     function changePlatform(address newAddress)
352         onlyCofounders
353     {
354         platform = newAddress;
355     }
356 
357     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
358     //  @des Function to change address that is allowed to do token issuance. Crowdfund contract can only be set once.   //
359     //  @param newAddress Address of new issuance contract.                                                              //
360     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
361     function changeCrowdfundContract(address newAddress)
362         onlyCofounders
363         CanSetCrowdfundContract
364     {
365         crowdfundContract = newAddress;
366     }
367 
368     /////////////////////////////////////////////////////////////////////////////////////////////////////////////
369     //  @des Function to change address that is allowed to do token issuance. Allocator can only be set once.  //
370     //  @param newAddress Address of new issuance contract.                                                    //
371     /////////////////////////////////////////////////////////////////////////////////////////////////////////////
372     function changeAllocator(address newAddress)
373         onlyCofounders
374         CanSetAllocator
375     {
376         allocatorAddress = newAddress;
377     }
378 
379     ///////////////////////////////////////////////////////
380     //  @des Function to change founder A address.       //
381     //  @param newAddress Address of new founder A.      //
382     ///////////////////////////////////////////////////////
383     function changeCofounderA(address newAddress)
384         onlyCofounderA
385     {
386         cofounderA = newAddress;
387     }
388 
389     //////////////////////////////////////////////////////
390     //  @des Function to change founder B address.      //
391     //  @param newAddress Address of new founder B.     //
392     //////////////////////////////////////////////////////
393     function changeCofounderB(address newAddress)
394         onlyCofounderB
395     {
396         cofounderB = newAddress;
397     }
398 
399 
400     //////////////////////////////////////////////////////////////
401     // Transfers tokens from senders address to another address //
402     //////////////////////////////////////////////////////////////
403     function transfer(address _to, uint256 _value)
404       TokensUnlocked
405       returns (bool)
406     {
407           Transfer(msg.sender, _to, _value);
408           return BasicToken.transfer(_to, _value);
409     }
410 
411     //////////////////////////////////////////////////////////
412     // Transfers tokens from one address to another address //
413     //////////////////////////////////////////////////////////
414     function transferFrom(address _from, address _to, uint256 _value)
415       TokensUnlocked
416       returns (bool)
417     {
418           Transfer(_from, _to, _value);
419           return StandardToken.transferFrom(_from, _to, _value);
420     }
421 
422 
423     ///////////////////////////////////////////////////////////////////////////////////////////////
424     //  @des Cofounders issue tokens to themsleves if within vesting period. Returns success.    //
425     //  @param beneficiary Address of receiver.                                                  //
426     //  @param tokenCount Number of tokens to issue.                                             //
427     ///////////////////////////////////////////////////////////////////////////////////////////////
428     function issueCofoundersTokensIfPossible()
429         onlyCofounders
430         CofoundersTokensVested
431         returns (bool)
432     {
433         // Compute total amount of vested tokens to issue
434         uint256 tokenCount = cofoundersSupply.div(cofoundersSupplyVestingTranches);
435 
436         // Make sure that there are cofounder tokens left
437         if (tokenCount > cofoundersSupplyRemaining) {
438            return false;
439         }
440 
441         // Decrease cofounders supply
442         cofoundersSupplyRemaining = cofoundersSupplyRemaining.sub(tokenCount);
443 
444         // Update how many tokens have been distributed to cofounders
445         cofoundersSupplyDistributed = cofoundersSupplyDistributed.add(tokenCount);
446 
447         // Split tokens between both founders
448         balances[cofounderA] = balances[cofounderA].add(tokenCount.div(2));
449         balances[cofounderB] = balances[cofounderB].add(tokenCount.div(2));
450 
451         // Update that a tranche has been issued
452         cofoundersSupplyVestingTranchesIssued += 1;
453 
454         return true;
455     }
456 
457 
458     //////////////////
459     // Issue tokens //
460     //////////////////
461     function issueTokens(address beneficiary, uint256 tokenCount, DNNSupplyAllocations allocationType)
462       onlyAllocatorOrCrowdfundContractOrPlatform
463       returns (bool)
464     {
465         // We'll use the following to determine whether the allocator, platform,
466         // or the crowdfunding contract can allocate specified supply
467         bool canAllocatorPerform = msg.sender == allocatorAddress && tokensLocked == false;
468         bool canCrowdfundContractPerform = msg.sender == crowdfundContract;
469         bool canPlatformPerform = msg.sender == platform && tokensLocked == false;
470 
471         // Early Backers
472         if (canAllocatorPerform && allocationType == DNNSupplyAllocations.EarlyBackerSupplyAllocation && tokenCount <= earlyBackerSupplyRemaining) {
473             earlyBackerSupplyRemaining = earlyBackerSupplyRemaining.sub(tokenCount);
474         }
475 
476         // PRE-TDE
477         else if (canCrowdfundContractPerform && msg.sender == crowdfundContract && allocationType == DNNSupplyAllocations.PRETDESupplyAllocation) {
478 
479               // Check to see if we have enough tokens to satisfy this purchase
480               // using just the pre-tde.
481               if (PRETDESupplyRemaining >= tokenCount) {
482 
483                     // Decrease pre-tde supply
484                     PRETDESupplyRemaining = PRETDESupplyRemaining.sub(tokenCount);
485               }
486 
487               // Check to see if we can satisfy this using pre-tde and tde supply combined
488               else if (PRETDESupplyRemaining+TDESupplyRemaining >= tokenCount) {
489 
490                     // Decrease tde supply
491                     TDESupplyRemaining = TDESupplyRemaining.sub(tokenCount-PRETDESupplyRemaining);
492 
493                     // Decrease pre-tde supply by its' remaining tokens
494                     PRETDESupplyRemaining = 0;
495               }
496 
497               // Otherwise, we can't satisfy this sale because we don't have enough tokens.
498               else {
499                   return false;
500               }
501         }
502 
503         // TDE
504         else if (canCrowdfundContractPerform && allocationType == DNNSupplyAllocations.TDESupplyAllocation && tokenCount <= TDESupplyRemaining) {
505             TDESupplyRemaining = TDESupplyRemaining.sub(tokenCount);
506         }
507 
508         // Bounty
509         else if (canAllocatorPerform && allocationType == DNNSupplyAllocations.BountySupplyAllocation && tokenCount <= bountySupplyRemaining) {
510             bountySupplyRemaining = bountySupplyRemaining.sub(tokenCount);
511         }
512 
513         // Writer Accounts
514         else if (canAllocatorPerform && allocationType == DNNSupplyAllocations.WriterAccountSupplyAllocation && tokenCount <= writerAccountSupplyRemaining) {
515             writerAccountSupplyRemaining = writerAccountSupplyRemaining.sub(tokenCount);
516         }
517 
518         // Advisory
519         else if (canAllocatorPerform && allocationType == DNNSupplyAllocations.AdvisorySupplyAllocation && tokenCount <= advisorySupplyRemaining) {
520             advisorySupplyRemaining = advisorySupplyRemaining.sub(tokenCount);
521         }
522 
523         // Platform (Also makes sure that the beneficiary is the platform address specified in this contract)
524         else if (canPlatformPerform && allocationType == DNNSupplyAllocations.PlatformSupplyAllocation && tokenCount <= platformSupplyRemaining) {
525             platformSupplyRemaining = platformSupplyRemaining.sub(tokenCount);
526         }
527 
528         else {
529             return false;
530         }
531 
532         // Credit tokens to the address specified
533         balances[beneficiary] = balances[beneficiary].add(tokenCount);
534 
535         return true;
536     }
537 
538     /////////////////////////////////////////////////
539     // Transfer Unsold tokens from TDE to Platform //
540     /////////////////////////////////////////////////
541     function sendUnsoldTDETokensToPlatform()
542       external
543       onlyCrowdfundContract
544     {
545         // Make sure we have tokens to send from TDE
546         if (TDESupplyRemaining > 0) {
547 
548             // Add remaining tde tokens to platform remaining tokens
549             platformSupplyRemaining = platformSupplyRemaining.add(TDESupplyRemaining);
550 
551             // Clear remaining tde token count
552             TDESupplyRemaining = 0;
553         }
554     }
555 
556     /////////////////////////////////////////////////////
557     // Transfer Unsold tokens from pre-TDE to Platform //
558     /////////////////////////////////////////////////////
559     function sendUnsoldPRETDETokensToTDE()
560       external
561       onlyCrowdfundContract
562     {
563           // Make sure we have tokens to send from pre-TDE
564           if (PRETDESupplyRemaining > 0) {
565 
566               // Add remaining pre-tde tokens to tde remaining tokens
567               TDESupplyRemaining = TDESupplyRemaining.add(PRETDESupplyRemaining);
568 
569               // Clear remaining pre-tde token count
570               PRETDESupplyRemaining = 0;
571         }
572     }
573 
574     ////////////////////////////////////////////////////////////////
575     // @des Allows tokens to be transferrable. Returns lock state //
576     ////////////////////////////////////////////////////////////////
577     function unlockTokens()
578         external
579         onlyCrowdfundContract
580     {
581         // Make sure tokens are currently locked before proceeding to unlock them
582         require(tokensLocked == true);
583 
584         tokensLocked = false;
585     }
586 
587     ///////////////////////////////////////////////////////////////////////
588     //  @des Contract constructor function sets initial token balances.  //
589     ///////////////////////////////////////////////////////////////////////
590     function DNNToken(address founderA, address founderB, address platformAddress, uint256 vestingStartDate)
591     {
592           // Set cofounder addresses
593           cofounderA = founderA;
594           cofounderB = founderB;
595 
596           // Sets platform address
597           platform = platformAddress;
598 
599           // Set total supply - 1 Billion DNN Tokens = (1,000,000,000 * 10^18) atto-DNN
600           // 1 DNN = 10^18 atto-DNN
601           totalSupply = uint256(1000000000).mul(uint256(10)**decimals);
602 
603           // Set Token Distributions (% of total supply)
604           earlyBackerSupply = totalSupply.mul(10).div(100); // 10%
605           PRETDESupply = totalSupply.mul(10).div(100); // 10%
606           TDESupply = totalSupply.mul(40).div(100); // 40%
607           bountySupply = totalSupply.mul(1).div(100); // 1%
608           writerAccountSupply = totalSupply.mul(4).div(100); // 4%
609           advisorySupply = totalSupply.mul(14).div(100); // 14%
610           cofoundersSupply = totalSupply.mul(10).div(100); // 10%
611           platformSupply = totalSupply.mul(11).div(100); // 11%
612 
613           // Set each remaining token count equal to its' respective supply
614           earlyBackerSupplyRemaining = earlyBackerSupply;
615           PRETDESupplyRemaining = PRETDESupply;
616           TDESupplyRemaining = TDESupply;
617           bountySupplyRemaining = bountySupply;
618           writerAccountSupplyRemaining = writerAccountSupply;
619           advisorySupplyRemaining = advisorySupply;
620           cofoundersSupplyRemaining = cofoundersSupply;
621           platformSupplyRemaining = platformSupply;
622 
623           // Sets cofounder vesting start date (Ensures that it is a date in the future, otherwise it will default to now)
624           cofoundersSupplyVestingStartDate = vestingStartDate >= now ? vestingStartDate : now;
625     }
626 }