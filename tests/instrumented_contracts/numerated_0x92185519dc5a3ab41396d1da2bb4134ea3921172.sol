1 pragma solidity ^0.4.11;
2 
3 
4 /*
5  * Paste Trivial Token code at the bottom.
6  * Go to https://remix.ethereum.org
7  * Compile code and retrive bytecode of Trivial Token
8  */
9 
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
17     uint256 c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal constant returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint256 a, uint256 b) internal constant returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41 
42 /**
43  * @title ERC20Basic
44  * @dev Simpler version of ERC20 interface
45  * @dev see https://github.com/ethereum/EIPs/issues/179
46  */
47 contract ERC20Basic {
48   uint256 public totalSupply;
49   function balanceOf(address who) constant returns (uint256);
50   function transfer(address to, uint256 value) returns (bool);
51   event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 
55 /**
56  * @title ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20 is ERC20Basic {
60   function allowance(address owner, address spender) constant returns (uint256);
61   function transferFrom(address from, address to, uint256 value) returns (bool);
62   function approve(address spender, uint256 value) returns (bool);
63   event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   /**
77   * @dev transfer token for a specified address
78   * @param _to The address to transfer to.
79   * @param _value The amount to be transferred.
80   */
81   function transfer(address _to, uint256 _value) returns (bool) {
82     balances[msg.sender] = balances[msg.sender].sub(_value);
83     balances[_to] = balances[_to].add(_value);
84     Transfer(msg.sender, _to, _value);
85     return true;
86   }
87 
88   /**
89   * @dev Gets the balance of the specified address.
90   * @param _owner The address to query the the balance of.
91   * @return An uint256 representing the amount owned by the passed address.
92   */
93   function balanceOf(address _owner) constant returns (uint256 balance) {
94     return balances[_owner];
95   }
96 }
97 
98 /**
99  * @title Standard ERC20 token
100  *
101  * @dev Implementation of the basic standard token.
102  * @dev https://github.com/ethereum/EIPs/issues/20
103  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
104  */
105 contract StandardToken is ERC20, BasicToken {
106 
107   mapping (address => mapping (address => uint256)) allowed;
108 
109 
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param _from address The address which you want to send tokens from
113    * @param _to address The address which you want to transfer to
114    * @param _value uint256 the amout of tokens to be transfered
115    */
116   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
117     var _allowance = allowed[_from][msg.sender];
118 
119     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
120     // require (_value <= _allowance);
121 
122     balances[_to] = balances[_to].add(_value);
123     balances[_from] = balances[_from].sub(_value);
124     allowed[_from][msg.sender] = _allowance.sub(_value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
131    * @param _spender The address which will spend the funds.
132    * @param _value The amount of tokens to be spent.
133    */
134   function approve(address _spender, uint256 _value) returns (bool) {
135 
136     // To change the approve amount you first have to reduce the addresses`
137     //  allowance to zero by calling `approve(_spender, 0)` if it is not
138     //  already 0 to mitigate the race condition described here:
139     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
141 
142     allowed[msg.sender][_spender] = _value;
143     Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param _owner address The address which owns the funds.
150    * @param _spender address The address which will spend the funds.
151    * @return A uint256 specifing the amount of tokens still avaible for the spender.
152    */
153   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
154     return allowed[_owner][_spender];
155   }
156 }
157 
158 /**
159  * @title PullPayment
160  * @dev Base contract supporting async send for pull payments. Inherit from this
161  * contract and use asyncSend instead of send.
162  */
163 contract PullPayment {
164   using SafeMath for uint256;
165 
166   mapping(address => uint256) public payments;
167   uint256 public totalPayments;
168 
169   /**
170   * @dev Called by the payer to store the sent amount as credit to be pulled.
171   * @param dest The destination address of the funds.
172   * @param amount The amount to transfer.
173   */
174   function asyncSend(address dest, uint256 amount) internal {
175     payments[dest] = payments[dest].add(amount);
176     totalPayments = totalPayments.add(amount);
177   }
178 
179   /**
180   * @dev withdraw accumulated balance, called by payee.
181   */
182   function withdrawPayments() {
183     address payee = msg.sender;
184     uint256 payment = payments[payee];
185 
186     require(payment != 0);
187     require(this.balance >= payment);
188 
189     totalPayments = totalPayments.sub(payment);
190     payments[payee] = 0;
191 
192     assert(payee.send(payment));
193   }
194 }
195 
196 /*
197  *
198  *
199  *
200  *
201  Paste actual Trivial Token below
202  *
203  *
204  *
205  *
206  */
207 
208 contract TrivialToken is StandardToken, PullPayment {
209     //Constants
210     uint256 public minEthAmount = 0.005 ether;
211     uint256 public minBidPercentage = 10;
212     uint256 public tokensPercentageForKeyHolder = 25;
213     uint256 public cleanupDelay = 180 days;
214     uint256 public freePeriodDuration = 60 days;
215 
216     //Basic
217     string public name;
218     string public symbol;
219     uint8 public decimals = 0;
220     uint256 public totalSupply;
221 
222     //Accounts
223     address public artist;
224     address public trivial;
225 
226     //Time information
227     uint256 public icoDuration;
228     uint256 public icoEndTime;
229     uint256 public auctionDuration;
230     uint256 public auctionEndTime;
231     uint256 public freePeriodEndTime;
232 
233     //Token information
234     uint256 public tokensForArtist;
235     uint256 public tokensForTrivial;
236     uint256 public tokensForIco;
237 
238     //ICO and auction results
239     uint256 public amountRaised;
240     address public highestBidder;
241     uint256 public highestBid;
242     bytes32 public auctionWinnerMessageHash;
243     uint256 public nextContributorIndexToBeGivenTokens;
244     uint256 public tokensDistributedToContributors;
245 
246     //Events
247     event IcoStarted(uint256 icoEndTime);
248     event IcoContributed(address contributor, uint256 amountContributed, uint256 amountRaised);
249     event IcoFinished(uint256 amountRaised);
250     event IcoCancelled();
251     event AuctionStarted(uint256 auctionEndTime);
252     event HighestBidChanged(address highestBidder, uint256 highestBid);
253     event AuctionFinished(address highestBidder, uint256 highestBid);
254     event WinnerProvidedHash();
255 
256     //State
257     enum State {
258         Created, IcoStarted, IcoFinished, AuctionStarted, AuctionFinished, IcoCancelled,
259         BeforeInitOne, BeforeInitTwo
260     }
261     State public currentState;
262 
263     //Item description
264     struct DescriptionHash {
265         bytes32 descriptionHash;
266         uint256 timestamp;
267     }
268     DescriptionHash public descriptionHash;
269     DescriptionHash[] public descriptionHashHistory;
270 
271     //Token contributors and holders
272     mapping(address => uint) public contributions;
273     address[] public contributors;
274 
275     //Modififers
276     modifier onlyInState(State expectedState) { require(expectedState == currentState); _; }
277     modifier onlyInTokensTrasferingPeriod() {
278         require(currentState == State.IcoFinished || (currentState == State.AuctionStarted && now < auctionEndTime));
279         _;
280     }
281     modifier onlyBefore(uint256 _time) { require(now < _time); _; }
282     modifier onlyAfter(uint256 _time) { require(now > _time); _; }
283     modifier onlyTrivial() { require(msg.sender == trivial); _; }
284     modifier onlyArtist() { require(msg.sender == artist); _; }
285     modifier onlyAuctionWinner() {
286         require(currentState == State.AuctionFinished);
287         require(msg.sender == highestBidder);
288         _;
289     }
290 
291     function TrivialToken() {
292         currentState = State.BeforeInitOne;
293     }
294 
295     function initOne(
296         string _name,
297         string _symbol,
298         uint8 _decimals,
299         uint256 _icoDuration,
300         uint256 _auctionDuration,
301         address _artist,
302         address _trivial,
303         bytes32 _descriptionHash
304     )
305     onlyInState(State.BeforeInitOne)
306     {
307         name = _name;
308         symbol = _symbol;
309         decimals = _decimals;
310 
311         icoDuration = _icoDuration;
312         auctionDuration = _auctionDuration;
313 
314         artist = _artist;
315         trivial = _trivial;
316 
317         descriptionHash = DescriptionHash(_descriptionHash, now);
318         currentState = State.BeforeInitTwo;
319     }
320 
321     function initTwo(
322         uint256 _totalSupply,
323         uint256 _tokensForArtist,
324         uint256 _tokensForTrivial,
325         uint256 _tokensForIco,
326         uint256 _minEthAmount,
327         uint256 _minBidPercentage,
328         uint256 _tokensPercentageForKeyHolder,
329         uint256 _cleanupDelay,
330         uint256 _freePeriodDuration
331     )
332     onlyInState(State.BeforeInitTwo) {
333         require(
334             _totalSupply == SafeMath.add(
335                 _tokensForArtist,
336                 SafeMath.add(_tokensForTrivial, _tokensForIco)
337             )
338         );
339         require(_minBidPercentage < 100);
340         require(_tokensPercentageForKeyHolder < 100);
341 
342         totalSupply = _totalSupply;
343         minEthAmount = _minEthAmount;
344         minBidPercentage = _minBidPercentage;
345         tokensPercentageForKeyHolder = _tokensPercentageForKeyHolder;
346         cleanupDelay = _cleanupDelay;
347         freePeriodDuration = _freePeriodDuration;
348 
349         tokensForArtist = _tokensForArtist;
350         tokensForTrivial = _tokensForTrivial;
351         tokensForIco = _tokensForIco;
352 
353         currentState = State.Created;
354     }
355 
356     /*
357         ICO methods
358     */
359     function startIco()
360     onlyInState(State.Created)
361     onlyTrivial() {
362         icoEndTime = SafeMath.add(now, icoDuration);
363         freePeriodEndTime = SafeMath.add(icoEndTime, freePeriodDuration);
364         currentState = State.IcoStarted;
365         IcoStarted(icoEndTime);
366     }
367 
368     function contributeInIco() payable
369     onlyInState(State.IcoStarted)
370     onlyBefore(icoEndTime) {
371         require(msg.value > minEthAmount);
372 
373         if (contributions[msg.sender] == 0) {
374             contributors.push(msg.sender);
375         }
376         contributions[msg.sender] = SafeMath.add(contributions[msg.sender], msg.value);
377         amountRaised = SafeMath.add(amountRaised, msg.value);
378 
379         IcoContributed(msg.sender, msg.value, amountRaised);
380     }
381 
382     function distributeTokens(uint256 contributorsNumber)
383     onlyInState(State.IcoStarted)
384     onlyAfter(icoEndTime) {
385         for (uint256 i = 0; i < contributorsNumber && nextContributorIndexToBeGivenTokens < contributors.length; ++i) {
386             address currentContributor = contributors[nextContributorIndexToBeGivenTokens++];
387             uint256 tokensForContributor = SafeMath.div(
388                 SafeMath.mul(tokensForIco, contributions[currentContributor]),
389                 amountRaised  // amountRaised can't be 0, ICO is cancelled then
390             );
391             balances[currentContributor] = tokensForContributor;
392             tokensDistributedToContributors = SafeMath.add(tokensDistributedToContributors, tokensForContributor);
393         }
394     }
395 
396     function finishIco()
397     onlyInState(State.IcoStarted)
398     onlyAfter(icoEndTime) {
399         if (amountRaised == 0) {
400             currentState = State.IcoCancelled;
401             return;
402         }
403 
404         // all contributors must have received their tokens to finish ICO
405         require(nextContributorIndexToBeGivenTokens >= contributors.length);
406 
407         balances[artist] = SafeMath.add(balances[artist], tokensForArtist);
408         balances[trivial] = SafeMath.add(balances[trivial], tokensForTrivial);
409         uint256 leftovers = SafeMath.sub(tokensForIco, tokensDistributedToContributors);
410         balances[artist] = SafeMath.add(balances[artist], leftovers);
411 
412         if (!artist.send(this.balance)) {
413             asyncSend(artist, this.balance);
414         }
415         currentState = State.IcoFinished;
416         IcoFinished(amountRaised);
417     }
418 
419     function checkContribution(address contributor) constant returns (uint) {
420         return contributions[contributor];
421     }
422 
423     /*
424         Auction methods
425     */
426     function canStartAuction() returns (bool) {
427         bool isArtist = msg.sender == artist;
428         bool isKeyHolder = balances[msg.sender] >= SafeMath.div(
429         SafeMath.mul(totalSupply, tokensPercentageForKeyHolder), 100);
430         return isArtist || isKeyHolder;
431     }
432 
433     function startAuction()
434     onlyAfter(freePeriodEndTime)
435     onlyInState(State.IcoFinished) {
436         require(canStartAuction());
437 
438         // 100% tokens owner is the only key holder
439         if (balances[msg.sender] == totalSupply) {
440             // no auction takes place,
441             highestBidder = msg.sender;
442             currentState = State.AuctionFinished;
443             AuctionFinished(highestBidder, highestBid);
444             return;
445         }
446 
447         auctionEndTime = SafeMath.add(now, auctionDuration);
448         currentState = State.AuctionStarted;
449         AuctionStarted(auctionEndTime);
450     }
451 
452     function bidInAuction() payable
453     onlyInState(State.AuctionStarted)
454     onlyBefore(auctionEndTime) {
455         //Must be greater or equal to minimal amount
456         require(msg.value >= minEthAmount);
457         uint256 bid = calculateUserBid();
458 
459         //If there was a bid already
460         if (highestBid >= minEthAmount) {
461             //Must be greater or equal to 105% of previous bid
462             uint256 minimalOverBid = SafeMath.add(highestBid, SafeMath.div(
463                 SafeMath.mul(highestBid, minBidPercentage), 100
464             ));
465             require(bid >= minimalOverBid);
466             //Return to previous bidder his balance
467             //Value to return: current balance - current bid - paymentsInAsyncSend
468             uint256 amountToReturn = SafeMath.sub(SafeMath.sub(
469                 this.balance, msg.value
470             ), totalPayments);
471             if (!highestBidder.send(amountToReturn)) {
472                 asyncSend(highestBidder, amountToReturn);
473             }
474         }
475 
476         highestBidder = msg.sender;
477         highestBid = bid;
478         HighestBidChanged(highestBidder, highestBid);
479     }
480 
481     function calculateUserBid() private returns (uint256) {
482         uint256 bid = msg.value;
483         uint256 contribution = balanceOf(msg.sender);
484         if (contribution > 0) {
485             //Formula: (sentETH * allTokens) / (allTokens - userTokens)
486             //User sends 16ETH, has 40 of 200 tokens
487             //(16 * 200) / (200 - 40) => 3200 / 160 => 20
488             bid = SafeMath.div(
489                 SafeMath.mul(msg.value, totalSupply),
490                 SafeMath.sub(totalSupply, contribution)
491             );
492         }
493         return bid;
494     }
495 
496     function finishAuction()
497     onlyInState(State.AuctionStarted)
498     onlyAfter(auctionEndTime) {
499         require(highestBid > 0);  // auction cannot be finished until at least one person bids
500         currentState = State.AuctionFinished;
501         AuctionFinished(highestBidder, highestBid);
502     }
503 
504     function withdrawShares(address holder) public
505     onlyInState(State.AuctionFinished) {
506         uint256 availableTokens = balances[holder];
507         require(availableTokens > 0);
508         balances[holder] = 0;
509 
510         if (holder != highestBidder) {
511             holder.transfer(
512                 SafeMath.div(SafeMath.mul(highestBid, availableTokens), totalSupply)
513             );
514         }
515     }
516 
517     /*
518         General methods
519     */
520 
521     function contributorsCount() constant returns (uint256) { return contributors.length; }
522 
523     // Cancel ICO will be redesigned to prevent
524     // risk of user funds overtaken
525 
526     /*function cancelIco()
527     onlyInState(State.IcoStarted)
528     onlyTrivial() {
529         currentState = State.IcoCancelled;
530         IcoCancelled();
531     }
532 
533     function claimIcoContribution(address contributor) onlyInState(State.IcoCancelled) {
534         uint256 contribution = contributions[contributor];
535         require(contribution > 0);
536         contributions[contributor] = 0;
537         contributor.transfer(contribution);
538     }*/
539 
540     function setDescriptionHash(bytes32 _descriptionHash)
541     onlyArtist() {
542         descriptionHashHistory.push(descriptionHash);
543         descriptionHash = DescriptionHash(_descriptionHash, now);
544     }
545 
546     function setAuctionWinnerMessageHash(bytes32 _auctionWinnerMessageHash)
547     onlyAuctionWinner() {
548         auctionWinnerMessageHash = _auctionWinnerMessageHash;
549         WinnerProvidedHash();
550     }
551 
552     function killContract()
553     onlyTrivial() {
554         require(
555             (
556                 currentState == State.AuctionFinished &&
557                 now > SafeMath.add(auctionEndTime, cleanupDelay) // Delay in correct state
558             ) ||
559             currentState == State.IcoCancelled // No delay in cancelled state
560         );
561         selfdestruct(trivial);
562     }
563 
564     // helper function to avoid too many contract calls on frontend side
565     function getContractState() constant returns (
566         uint256, uint256, uint256, uint256, uint256,
567         uint256, uint256, address, uint256, State,
568         uint256, uint256, uint256
569     ) {
570         return (
571             icoEndTime, auctionDuration, auctionEndTime,
572             tokensForArtist, tokensForTrivial, tokensForIco,
573             amountRaised, highestBidder, highestBid, currentState,
574             tokensPercentageForKeyHolder, minBidPercentage,
575             freePeriodEndTime
576         );
577     }
578 
579     function transfer(address _to, uint _value)
580     onlyInTokensTrasferingPeriod() returns (bool) {
581         if (currentState == State.AuctionStarted) {
582             require(_to != highestBidder);
583             require(msg.sender != highestBidder);
584         }
585         return BasicToken.transfer(_to, _value);
586     }
587 
588     function transferFrom(address _from, address _to, uint256 _value)
589     onlyInTokensTrasferingPeriod() returns (bool) {
590         if (currentState == State.AuctionStarted) {
591             require(_to != highestBidder);
592             require(_from != highestBidder);
593         }
594         return StandardToken.transferFrom(_from, _to, _value);
595     }
596 
597     function () payable {
598         if (currentState == State.IcoStarted) {
599             contributeInIco();
600         }
601         else if (currentState == State.AuctionStarted) {
602             bidInAuction();
603         }
604         else {
605             revert();
606         }
607     }
608 }