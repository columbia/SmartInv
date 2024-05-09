1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) constant returns (uint256);
42   function transfer(address to, uint256 value) returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) constant returns (uint256);
52   function transferFrom(address from, address to, uint256 value) returns (bool);
53   function approve(address spender, uint256 value) returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances. 
60  */
61 contract BasicToken is ERC20Basic {
62   using SafeMath for uint256;
63 
64   mapping(address => uint256) balances;
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) returns (bool) {
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of. 
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) constant returns (uint256 balance) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * @dev https://github.com/ethereum/EIPs/issues/20
94  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract StandardToken is ERC20, BasicToken {
97 
98   mapping (address => mapping (address => uint256)) allowed;
99 
100 
101   /**
102    * @dev Transfer tokens from one address to another
103    * @param _from address The address which you want to send tokens from
104    * @param _to address The address which you want to transfer to
105    * @param _value uint256 the amout of tokens to be transfered
106    */
107   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
108     var _allowance = allowed[_from][msg.sender];
109 
110     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
111     // require (_value <= _allowance);
112 
113     balances[_to] = balances[_to].add(_value);
114     balances[_from] = balances[_from].sub(_value);
115     allowed[_from][msg.sender] = _allowance.sub(_value);
116     Transfer(_from, _to, _value);
117     return true;
118   }
119 
120   /**
121    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
122    * @param _spender The address which will spend the funds.
123    * @param _value The amount of tokens to be spent.
124    */
125   function approve(address _spender, uint256 _value) returns (bool) {
126 
127     // To change the approve amount you first have to reduce the addresses`
128     //  allowance to zero by calling `approve(_spender, 0)` if it is not
129     //  already 0 to mitigate the race condition described here:
130     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
132 
133     allowed[msg.sender][_spender] = _value;
134     Approval(msg.sender, _spender, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifing the amount of tokens still avaible for the spender.
143    */
144   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
145     return allowed[_owner][_spender];
146   }
147 
148 }
149 
150 /**
151  * @title PullPayment
152  * @dev Base contract supporting async send for pull payments. Inherit from this
153  * contract and use asyncSend instead of send.
154  */
155 contract PullPayment {
156   using SafeMath for uint256;
157 
158   mapping(address => uint256) public payments;
159   uint256 public totalPayments;
160 
161   /**
162   * @dev Called by the payer to store the sent amount as credit to be pulled.
163   * @param dest The destination address of the funds.
164   * @param amount The amount to transfer.
165   */
166   function asyncSend(address dest, uint256 amount) internal {
167     payments[dest] = payments[dest].add(amount);
168     totalPayments = totalPayments.add(amount);
169   }
170 
171   /**
172   * @dev withdraw accumulated balance, called by payee.
173   */
174   function withdrawPayments() {
175     address payee = msg.sender;
176     uint256 payment = payments[payee];
177 
178     require(payment != 0);
179     require(this.balance >= payment);
180 
181     totalPayments = totalPayments.sub(payment);
182     payments[payee] = 0;
183 
184     assert(payee.send(payment));
185   }
186 }
187 
188 contract TrivialToken is StandardToken, PullPayment {
189     //Constants
190     uint8 constant DECIMALS = 0;
191     uint256 constant MIN_ETH_AMOUNT = 0.005 ether;
192     uint256 constant MIN_BID_PERCENTAGE = 10;
193     uint256 constant TOTAL_SUPPLY = 1000000;
194     uint256 constant TOKENS_PERCENTAGE_FOR_KEY_HOLDER = 25;
195     uint256 constant CLEANUP_DELAY = 180 days;
196     uint256 constant FREE_PERIOD_DURATION = 60 days;
197 
198     //Basic
199     string public name;
200     string public symbol;
201     uint8 public decimals;
202     uint256 public totalSupply;
203 
204     //Accounts
205     address public artist;
206     address public trivial;
207 
208     //Time information
209     uint256 public icoDuration;
210     uint256 public icoEndTime;
211     uint256 public auctionDuration;
212     uint256 public auctionEndTime;
213     uint256 public freePeriodEndTime;
214 
215     //Token information
216     uint256 public tokensForArtist;
217     uint256 public tokensForTrivial;
218     uint256 public tokensForIco;
219 
220     //ICO and auction results
221     uint256 public amountRaised;
222     address public highestBidder;
223     uint256 public highestBid;
224     bytes32 public auctionWinnerMessageHash;
225     uint256 public nextContributorIndexToBeGivenTokens;
226     uint256 public tokensDistributedToContributors;
227 
228     //Events
229     event IcoStarted(uint256 icoEndTime);
230     event IcoContributed(address contributor, uint256 amountContributed, uint256 amountRaised);
231     event IcoFinished(uint256 amountRaised);
232     event IcoCancelled();
233     event AuctionStarted(uint256 auctionEndTime);
234     event HighestBidChanged(address highestBidder, uint256 highestBid);
235     event AuctionFinished(address highestBidder, uint256 highestBid);
236     event WinnerProvidedHash();
237 
238     //State
239     enum State { Created, IcoStarted, IcoFinished, AuctionStarted, AuctionFinished, IcoCancelled }
240     State public currentState;
241 
242     //Item description
243     struct DescriptionHash {
244         bytes32 descriptionHash;
245         uint256 timestamp;
246     }
247     DescriptionHash public descriptionHash;
248     DescriptionHash[] public descriptionHashHistory;
249 
250     //Token contributors and holders
251     mapping(address => uint) public contributions;
252     address[] public contributors;
253 
254     //Modififers
255     modifier onlyInState(State expectedState) { require(expectedState == currentState); _; }
256     modifier onlyBefore(uint256 _time) { require(now < _time); _; }
257     modifier onlyAfter(uint256 _time) { require(now > _time); _; }
258     modifier onlyTrivial() { require(msg.sender == trivial); _; }
259     modifier onlyArtist() { require(msg.sender == artist); _; }
260     modifier onlyAuctionWinner() {
261         require(currentState == State.AuctionFinished);
262         require(msg.sender == highestBidder);
263         _;
264     }
265 
266     function TrivialToken(
267         string _name, string _symbol,
268         uint256 _icoDuration, uint256 _auctionDuration,
269         address _artist, address _trivial,
270         uint256 _tokensForArtist,
271         uint256 _tokensForTrivial,
272         uint256 _tokensForIco,
273         bytes32 _descriptionHash
274     ) {
275         /*require(
276             TOTAL_SUPPLY == SafeMath.add(
277                 _tokensForArtist,
278                 SafeMath.add(_tokensForTrivial, _tokensForIco)
279             )
280         );*/
281         require(MIN_BID_PERCENTAGE < 100);
282         require(TOKENS_PERCENTAGE_FOR_KEY_HOLDER < 100);
283 
284         name = _name;
285         symbol = _symbol;
286         decimals = DECIMALS;
287 
288         icoDuration = _icoDuration;
289         auctionDuration = _auctionDuration;
290         artist = _artist;
291         trivial = _trivial;
292 
293         tokensForArtist = _tokensForArtist;
294         tokensForTrivial = _tokensForTrivial;
295         tokensForIco = _tokensForIco;
296 
297         descriptionHash = DescriptionHash(_descriptionHash, now);
298         currentState = State.Created;
299     }
300 
301     /*
302         ICO methods
303     */
304     function startIco()
305     onlyInState(State.Created)
306     onlyTrivial() {
307         icoEndTime = SafeMath.add(now, icoDuration);
308         freePeriodEndTime = SafeMath.add(icoEndTime, FREE_PERIOD_DURATION);
309         currentState = State.IcoStarted;
310         IcoStarted(icoEndTime);
311     }
312 
313     function contributeInIco() payable
314     onlyInState(State.IcoStarted)
315     onlyBefore(icoEndTime) {
316         require(msg.value > MIN_ETH_AMOUNT);
317 
318         if (contributions[msg.sender] == 0) {
319             contributors.push(msg.sender);
320         }
321         contributions[msg.sender] = SafeMath.add(contributions[msg.sender], msg.value);
322         amountRaised = SafeMath.add(amountRaised, msg.value);
323 
324         IcoContributed(msg.sender, msg.value, amountRaised);
325     }
326 
327     function distributeTokens(uint256 contributorsNumber)
328     onlyInState(State.IcoStarted)
329     onlyAfter(icoEndTime) {
330         for (uint256 i = 0; i < contributorsNumber && nextContributorIndexToBeGivenTokens < contributors.length; ++i) {
331             address currentContributor = contributors[nextContributorIndexToBeGivenTokens++];
332             uint256 tokensForContributor = SafeMath.div(
333                 SafeMath.mul(tokensForIco, contributions[currentContributor]),
334                 amountRaised  // amountRaised can't be 0, ICO is cancelled then
335             );
336             balances[currentContributor] = tokensForContributor;
337             tokensDistributedToContributors = SafeMath.add(tokensDistributedToContributors, tokensForContributor);
338         }
339     }
340 
341     function finishIco()
342     onlyInState(State.IcoStarted)
343     onlyAfter(icoEndTime) {
344         if (amountRaised == 0) {
345             currentState = State.IcoCancelled;
346             return;
347         }
348 
349         // all contributors must have received their tokens to finish ICO
350         require(nextContributorIndexToBeGivenTokens >= contributors.length);
351 
352         balances[artist] = SafeMath.add(balances[artist], tokensForArtist);
353         balances[trivial] = SafeMath.add(balances[trivial], tokensForTrivial);
354         uint256 leftovers = SafeMath.sub(tokensForIco, tokensDistributedToContributors);
355         balances[artist] = SafeMath.add(balances[artist], leftovers);
356 
357         if (!artist.send(this.balance)) {
358             asyncSend(artist, this.balance);
359         }
360         currentState = State.IcoFinished;
361         IcoFinished(amountRaised);
362     }
363 
364     function checkContribution(address contributor) constant returns (uint) {
365         return contributions[contributor];
366     }
367 
368     /*
369         Auction methods
370     */
371     function canStartAuction() returns (bool) {
372         bool isArtist = msg.sender == artist;
373         bool isKeyHolder = balances[msg.sender] >= SafeMath.div(
374         SafeMath.mul(TOTAL_SUPPLY, TOKENS_PERCENTAGE_FOR_KEY_HOLDER), 100);
375         return isArtist || isKeyHolder;
376     }
377 
378     function startAuction()
379     onlyAfter(freePeriodEndTime)
380     onlyInState(State.IcoFinished) {
381         require(canStartAuction());
382 
383         // 100% tokens owner is the only key holder
384         if (balances[msg.sender] == TOTAL_SUPPLY) {
385             // no auction takes place,
386             highestBidder = msg.sender;
387             currentState = State.AuctionFinished;
388             AuctionFinished(highestBidder, highestBid);
389             return;
390         }
391 
392         auctionEndTime = SafeMath.add(now, auctionDuration);
393         currentState = State.AuctionStarted;
394         AuctionStarted(auctionEndTime);
395     }
396 
397     function bidInAuction() payable
398     onlyInState(State.AuctionStarted)
399     onlyBefore(auctionEndTime) {
400         //Must be greater or equal to minimal amount
401         require(msg.value >= MIN_ETH_AMOUNT);
402         uint256 bid = calculateUserBid();
403 
404         //If there was a bid already
405         if (highestBid >= MIN_ETH_AMOUNT) {
406             //Must be greater or equal to 105% of previous bid
407             uint256 minimalOverBid = SafeMath.add(highestBid, SafeMath.div(
408                 SafeMath.mul(highestBid, MIN_BID_PERCENTAGE), 100
409             ));
410             require(bid >= minimalOverBid);
411             //Return to previous bidder his balance
412             //Value to return: current balance - current bid - paymentsInAsyncSend
413             uint256 amountToReturn = SafeMath.sub(SafeMath.sub(
414                 this.balance, msg.value
415             ), totalPayments);
416             if (!highestBidder.send(amountToReturn)) {
417                 asyncSend(highestBidder, amountToReturn);
418             }
419         }
420 
421         highestBidder = msg.sender;
422         highestBid = bid;
423         HighestBidChanged(highestBidder, highestBid);
424     }
425 
426     function calculateUserBid() private returns (uint256) {
427         uint256 bid = msg.value;
428         uint256 contribution = balanceOf(msg.sender);
429         if (contribution > 0) {
430             //Formula: (sentETH * allTokens) / (allTokens - userTokens)
431             //User sends 16ETH, has 40 of 200 tokens
432             //(16 * 200) / (200 - 40) => 3200 / 160 => 20
433             bid = SafeMath.div(
434                 SafeMath.mul(msg.value, TOTAL_SUPPLY),
435                 SafeMath.sub(TOTAL_SUPPLY, contribution)
436             );
437         }
438         return bid;
439     }
440 
441     function finishAuction()
442     onlyInState(State.AuctionStarted)
443     onlyAfter(auctionEndTime) {
444         require(highestBid > 0);  // auction cannot be finished until at least one person bids
445         currentState = State.AuctionFinished;
446         AuctionFinished(highestBidder, highestBid);
447     }
448 
449     function withdrawShares(address holder) public
450     onlyInState(State.AuctionFinished) {
451         uint256 availableTokens = balances[holder];
452         require(availableTokens > 0);
453         balances[holder] = 0;
454 
455         if (holder != highestBidder) {
456             holder.transfer(
457                 SafeMath.div(SafeMath.mul(highestBid, availableTokens), TOTAL_SUPPLY)
458             );
459         }
460     }
461 
462     function isKeyHolder(address person) constant returns (bool) {
463         return balances[person] >= SafeMath.div(tokensForIco, TOKENS_PERCENTAGE_FOR_KEY_HOLDER); }
464 
465     /*
466         General methods
467     */
468 
469     function contributorsCount() constant returns (uint256) { return contributors.length; }
470 
471     // Cancel ICO will be redesigned to prevent
472     // risk of user funds overtaken
473 
474     /*function cancelIco()
475     onlyInState(State.IcoStarted)
476     onlyTrivial() {
477         currentState = State.IcoCancelled;
478         IcoCancelled();
479     }
480 
481     function claimIcoContribution(address contributor) onlyInState(State.IcoCancelled) {
482         uint256 contribution = contributions[contributor];
483         require(contribution > 0);
484         contributions[contributor] = 0;
485         contributor.transfer(contribution);
486     }*/
487 
488     function setDescriptionHash(bytes32 _descriptionHash)
489     onlyArtist() {
490         descriptionHashHistory.push(descriptionHash);
491         descriptionHash = DescriptionHash(_descriptionHash, now);
492     }
493 
494     function setAuctionWinnerMessageHash(bytes32 _auctionWinnerMessageHash)
495     onlyAuctionWinner() {
496         auctionWinnerMessageHash = _auctionWinnerMessageHash;
497         WinnerProvidedHash();
498     }
499 
500     function killContract()
501     onlyTrivial() {
502         require(
503             (
504                 currentState == State.AuctionFinished &&
505                 now > SafeMath.add(auctionEndTime, CLEANUP_DELAY) // Delay in correct state
506             ) ||
507             currentState == State.IcoCancelled // No delay in cancelled state
508         );
509         selfdestruct(trivial);
510     }
511 
512     // helper function to avoid too many contract calls on frontend side
513     function getContractState() constant returns (
514         uint256, uint256, uint256, uint256, uint256,
515         uint256, uint256, address, uint256, State,
516         uint256, uint256, uint256
517     ) {
518         return (
519             icoEndTime, auctionDuration, auctionEndTime,
520             tokensForArtist, tokensForTrivial, tokensForIco,
521             amountRaised, highestBidder, highestBid, currentState,
522             TOKENS_PERCENTAGE_FOR_KEY_HOLDER, MIN_BID_PERCENTAGE,
523             freePeriodEndTime
524         );
525     }
526 
527     function transfer(address _to, uint _value)
528     onlyInState(State.IcoFinished) returns (bool) {
529         return BasicToken.transfer(_to, _value);
530     }
531 
532     function transferFrom(address _from, address _to, uint256 _value)
533     onlyInState(State.IcoFinished) returns (bool) {
534         return StandardToken.transferFrom(_from, _to, _value);
535     }
536 
537     function () payable {
538         if (currentState == State.IcoStarted) {
539             contributeInIco();
540         }
541         else if (currentState == State.AuctionStarted) {
542             bidInAuction();
543         }
544         else {
545             revert();
546         }
547     }
548 }