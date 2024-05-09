1 pragma solidity ^0.4.11;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 
11 contract BasicToken is ERC20Basic {
12   using SafeMath for uint256;
13 
14   mapping(address => uint256) balances;
15 
16   function transfer(address _to, uint256 _value) returns (bool) {
17     balances[msg.sender] = balances[msg.sender].sub(_value);
18     balances[_to] = balances[_to].add(_value);
19     Transfer(msg.sender, _to, _value);
20     return true;
21   }
22 
23   function balanceOf(address _owner) constant returns (uint256 balance) {
24     return balances[_owner];
25   }
26 
27 }
28 
29 contract ERC223TokenInterface {
30     function name() constant returns (string _name);
31     function symbol() constant returns (string _symbol);
32     function decimals() constant returns (uint8 _decimals);
33     function totalSupply() constant returns (uint256 _totalSupply);
34 
35     function transfer(address to, uint value, bytes data) returns (bool);
36     event Transfer(address indexed from, address indexed to, uint value, bytes data);
37 }
38 
39 contract ERC223ReceiverInterface {
40     function tokenFallback(address from, uint value, bytes data);
41 }
42 
43 contract ERC223Token is BasicToken, ERC223TokenInterface {
44     string public name;
45     string public symbol;
46     uint8 public decimals;
47     uint256 public totalSupply;
48 
49     function name() constant returns (string _name) {
50         return name;
51     }
52     function symbol() constant returns (string _symbol) {
53         return symbol;
54     }
55     function decimals() constant returns (uint8 _decimals) {
56         return decimals;
57     }
58     function totalSupply() constant returns (uint256 _totalSupply) {
59         return totalSupply;
60     }
61 
62     modifier onlyPayloadSize(uint size) {
63         require(msg.data.length >= size + 4);
64         _;
65     }
66 
67     function transfer(address to, uint value, bytes data) onlyPayloadSize(2 * 32) returns (bool) {
68         balances[msg.sender] = SafeMath.sub(balances[msg.sender], value);
69         balances[to] = SafeMath.add(balances[to], value);
70         if (isContract(to)){
71             ERC223ReceiverInterface receiver = ERC223ReceiverInterface(to);
72             receiver.tokenFallback(msg.sender, value, data);
73         }
74         //ERC223 event
75         Transfer(msg.sender, to, value, data);
76         return true;
77     }
78 
79     function transfer(address to, uint value) returns (bool) {
80         bytes memory empty;
81         transfer(to, value, empty);
82         //ERC20 legacy event
83         Transfer(msg.sender, to, value);
84         return true;
85     }
86 
87     function isContract(address _address) private returns (bool isContract) {
88         uint length;
89         _address = _address; //Silence compiler warning
90         assembly { length := extcodesize(_address) }
91         return length > 0;
92     }
93 }
94 
95 contract PullPayment {
96   using SafeMath for uint256;
97 
98   mapping(address => uint256) public payments;
99   uint256 public totalPayments;
100 
101   function asyncSend(address dest, uint256 amount) internal {
102     payments[dest] = payments[dest].add(amount);
103     totalPayments = totalPayments.add(amount);
104   }
105 
106 
107   function withdrawPayments() {
108     address payee = msg.sender;
109     uint256 payment = payments[payee];
110 
111     require(payment != 0);
112     require(this.balance >= payment);
113 
114     totalPayments = totalPayments.sub(payment);
115     payments[payee] = 0;
116 
117     assert(payee.send(payment));
118   }
119 }
120 
121 library SafeMath {
122   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
123     uint256 c = a * b;
124     assert(a == 0 || c / a == b);
125     return c;
126   }
127 
128   function div(uint256 a, uint256 b) internal constant returns (uint256) {
129     // assert(b > 0); // Solidity automatically throws when dividing by 0
130     uint256 c = a / b;
131     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132     return c;
133   }
134 
135   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
136     assert(b <= a);
137     return a - b;
138   }
139 
140   function add(uint256 a, uint256 b) internal constant returns (uint256) {
141     uint256 c = a + b;
142     assert(c >= a);
143     return c;
144   }
145 }
146 
147 
148 contract TrivialToken is ERC223Token, PullPayment {
149 
150     //Constants
151     uint8 constant DECIMALS = 0;
152     uint256 constant MIN_ETH_AMOUNT = 0.005 ether;
153     uint256 constant MIN_BID_PERCENTAGE = 10;
154     uint256 constant TOTAL_SUPPLY = 1000000;
155     uint256 constant TOKENS_PERCENTAGE_FOR_KEY_HOLDER = 25;
156     uint256 constant CLEANUP_DELAY = 180 days;
157 
158     //Accounts
159     address public artist;
160     address public trivial;
161 
162     //Time information
163     uint256 public icoEndTime;
164     uint256 public auctionDuration;
165     uint256 public auctionEndTime;
166 
167     //Token information
168     uint256 public tokensForArtist;
169     uint256 public tokensForTrivial;
170     uint256 public tokensForIco;
171 
172     //ICO and auction results
173     uint256 public amountRaised;
174     address public highestBidder;
175     uint256 public highestBid;
176     bytes32 public auctionWinnerMessageHash;
177     uint256 public nextContributorIndexToBeGivenTokens;
178     uint256 public tokensDistributedToContributors;
179 
180     //Events
181     event IcoStarted(uint256 icoEndTime);
182     event IcoContributed(address contributor, uint256 amountContributed, uint256 amountRaised);
183     event IcoFinished(uint256 amountRaised);
184     event IcoCancelled();
185     event AuctionStarted(uint256 auctionEndTime);
186     event HighestBidChanged(address highestBidder, uint256 highestBid);
187     event AuctionFinished(address highestBidder, uint256 highestBid);
188     event WinnerProvidedHash();
189 
190     //State
191     enum State { Created, IcoStarted, IcoFinished, AuctionStarted, AuctionFinished, IcoCancelled }
192     State public currentState;
193 
194     //Token contributors and holders
195     mapping(address => uint) public contributions;
196     address[] public contributors;
197 
198     //Modififers
199     modifier onlyInState(State expectedState) { require(expectedState == currentState); _; }
200     modifier onlyBefore(uint256 _time) { require(now < _time); _; }
201     modifier onlyAfter(uint256 _time) { require(now > _time); _; }
202     modifier onlyTrivial() { require(msg.sender == trivial); _; }
203     modifier onlyKeyHolders() { require(balances[msg.sender] >= SafeMath.div(
204         SafeMath.mul(tokensForIco, TOKENS_PERCENTAGE_FOR_KEY_HOLDER), 100)); _;
205     }
206     modifier onlyAuctionWinner() {
207         require(currentState == State.AuctionFinished);
208         require(msg.sender == highestBidder);
209         _;
210     }
211 
212     function TrivialToken(
213         string _name, string _symbol,
214         uint256 _icoEndTime, uint256 _auctionDuration,
215         address _artist, address _trivial,
216         uint256 _tokensForArtist,
217         uint256 _tokensForTrivial,
218         uint256 _tokensForIco
219     ) {
220         require(now < _icoEndTime);
221         require(
222             TOTAL_SUPPLY == SafeMath.add(
223                 _tokensForArtist,
224                 SafeMath.add(_tokensForTrivial, _tokensForIco)
225             )
226         );
227         require(MIN_BID_PERCENTAGE < 100);
228         require(TOKENS_PERCENTAGE_FOR_KEY_HOLDER < 100);
229 
230         name = _name;
231         symbol = _symbol;
232         decimals = DECIMALS;
233 
234         icoEndTime = _icoEndTime;
235         auctionDuration = _auctionDuration;
236         artist = _artist;
237         trivial = _trivial;
238 
239         tokensForArtist = _tokensForArtist;
240         tokensForTrivial = _tokensForTrivial;
241         tokensForIco = _tokensForIco;
242 
243         currentState = State.Created;
244     }
245 
246     /*
247         ICO methods
248     */
249     function startIco()
250     onlyInState(State.Created)
251     onlyTrivial() {
252         currentState = State.IcoStarted;
253         IcoStarted(icoEndTime);
254     }
255 
256     function contributeInIco() payable
257     onlyInState(State.IcoStarted)
258     onlyBefore(icoEndTime) {
259         require(msg.value > MIN_ETH_AMOUNT);
260 
261         if (contributions[msg.sender] == 0) {
262             contributors.push(msg.sender);
263         }
264         contributions[msg.sender] = SafeMath.add(contributions[msg.sender], msg.value);
265         amountRaised = SafeMath.add(amountRaised, msg.value);
266 
267         IcoContributed(msg.sender, msg.value, amountRaised);
268     }
269 
270     function distributeTokens(uint256 contributorsNumber)
271     onlyInState(State.IcoStarted)
272     onlyAfter(icoEndTime) {
273         for (uint256 i = 0; i < contributorsNumber && nextContributorIndexToBeGivenTokens < contributors.length; ++i) {
274             address currentContributor = contributors[nextContributorIndexToBeGivenTokens++];
275             uint256 tokensForContributor = SafeMath.div(
276                 SafeMath.mul(tokensForIco, contributions[currentContributor]),
277                 amountRaised  // amountRaised can't be 0, ICO is cancelled then
278             );
279             balances[currentContributor] = tokensForContributor;
280             tokensDistributedToContributors = SafeMath.add(tokensDistributedToContributors, tokensForContributor);
281         }
282     }
283 
284     function finishIco()
285     onlyInState(State.IcoStarted)
286     onlyAfter(icoEndTime) {
287         if (amountRaised == 0) {
288             currentState = State.IcoCancelled;
289             return;
290         }
291 
292         // all contributors must have received their tokens to finish ICO
293         require(nextContributorIndexToBeGivenTokens >= contributors.length);
294 
295         balances[artist] = SafeMath.add(balances[artist], tokensForArtist);
296         balances[trivial] = SafeMath.add(balances[trivial], tokensForTrivial);
297         uint256 leftovers = SafeMath.sub(tokensForIco, tokensDistributedToContributors);
298         balances[artist] = SafeMath.add(balances[artist], leftovers);
299 
300         if (!artist.send(this.balance)) {
301             asyncSend(artist, this.balance);
302         }
303         currentState = State.IcoFinished;
304         IcoFinished(amountRaised);
305     }
306 
307     function checkContribution(address contributor) constant returns (uint) {
308         return contributions[contributor];
309     }
310 
311     /*
312         Auction methods
313     */
314     function startAuction()
315     onlyInState(State.IcoFinished)
316     onlyKeyHolders() {
317         // 100% tokens owner is the only key holder
318         if (balances[msg.sender] == TOTAL_SUPPLY) {
319             // no auction takes place,
320             highestBidder = msg.sender;
321             currentState = State.AuctionFinished;
322             AuctionFinished(highestBidder, highestBid);
323             return;
324         }
325 
326         auctionEndTime = SafeMath.add(now, auctionDuration);
327         currentState = State.AuctionStarted;
328         AuctionStarted(auctionEndTime);
329     }
330 
331     function bidInAuction() payable
332     onlyInState(State.AuctionStarted)
333     onlyBefore(auctionEndTime) {
334         //Must be greater or equal to minimal amount
335         require(msg.value >= MIN_ETH_AMOUNT);
336         uint256 bid = calculateUserBid();
337 
338         //If there was a bid already
339         if (highestBid >= MIN_ETH_AMOUNT) {
340             //Must be greater or equal to 105% of previous bid
341             uint256 minimalOverBid = SafeMath.add(highestBid, SafeMath.div(
342                 SafeMath.mul(highestBid, MIN_BID_PERCENTAGE), 100
343             ));
344             require(bid >= minimalOverBid);
345             //Return to previous bidder his balance
346             //Value to return: current balance - current bid - paymentsInAsyncSend
347             uint256 amountToReturn = SafeMath.sub(SafeMath.sub(
348                 this.balance, msg.value
349             ), totalPayments);
350             if (!highestBidder.send(amountToReturn)) {
351                 asyncSend(highestBidder, amountToReturn);
352             }
353         }
354 
355         highestBidder = msg.sender;
356         highestBid = bid;
357         HighestBidChanged(highestBidder, highestBid);
358     }
359 
360     function calculateUserBid() private returns (uint256) {
361         uint256 bid = msg.value;
362         uint256 contribution = balanceOf(msg.sender);
363         if (contribution > 0) {
364             //Formula: (sentETH * allTokens) / (allTokens - userTokens)
365             //User sends 16ETH, has 40 of 200 tokens
366             //(16 * 200) / (200 - 40) => 3200 / 160 => 20
367             bid = SafeMath.div(
368                 SafeMath.mul(msg.value, TOTAL_SUPPLY),
369                 SafeMath.sub(TOTAL_SUPPLY, contribution)
370             );
371         }
372         return bid;
373     }
374 
375     function finishAuction()
376     onlyInState(State.AuctionStarted)
377     onlyAfter(auctionEndTime) {
378         require(highestBid > 0);  // auction cannot be finished until at least one person bids
379         currentState = State.AuctionFinished;
380         AuctionFinished(highestBidder, highestBid);
381     }
382 
383     function withdrawShares(address holder) public
384     onlyInState(State.AuctionFinished) {
385         uint256 availableTokens = balances[holder];
386         require(availableTokens > 0);
387         balances[holder] = 0;
388 
389         if (holder != highestBidder) {
390             holder.transfer(
391                 SafeMath.div(SafeMath.mul(highestBid, availableTokens), TOTAL_SUPPLY)
392             );
393         }
394     }
395 
396     function isKeyHolder(address person) constant returns (bool) {
397         return balances[person] >= SafeMath.div(tokensForIco, TOKENS_PERCENTAGE_FOR_KEY_HOLDER); }
398 
399     /*
400         General methods
401     */
402 
403     // Cancel ICO will be redesigned to prevent
404     // risk of user funds overtaken
405 
406     /*function cancelIco()
407     onlyInState(State.IcoStarted)
408     onlyTrivial() {
409         currentState = State.IcoCancelled;
410         IcoCancelled();
411     }
412 
413     function claimIcoContribution(address contributor) onlyInState(State.IcoCancelled) {
414         uint256 contribution = contributions[contributor];
415         require(contribution > 0);
416         contributions[contributor] = 0;
417         contributor.transfer(contribution);
418     }*/
419 
420     function setAuctionWinnerMessageHash(bytes32 _auctionWinnerMessageHash)
421     onlyAuctionWinner() {
422         auctionWinnerMessageHash = _auctionWinnerMessageHash;
423         WinnerProvidedHash();
424     }
425 
426     function killContract()
427     onlyTrivial() {
428         require(
429             (
430                 currentState == State.AuctionFinished &&
431                 now > SafeMath.add(auctionEndTime, CLEANUP_DELAY) // Delay in correct state
432             ) ||
433             currentState == State.IcoCancelled // No delay in cancelled state
434         );
435         selfdestruct(trivial);
436     }
437 
438     // helper function to avoid too many contract calls on frontend side
439     function getContractState() constant returns (
440         uint256, uint256, uint256, uint256, uint256,
441         uint256, uint256, address, uint256, State,
442         uint256, uint256
443     ) {
444         return (
445             icoEndTime, auctionDuration, auctionEndTime,
446             tokensForArtist, tokensForTrivial, tokensForIco,
447             amountRaised, highestBidder, highestBid, currentState,
448             TOKENS_PERCENTAGE_FOR_KEY_HOLDER, MIN_BID_PERCENTAGE
449         );
450     }
451 
452     function transfer(address _to, uint _value, bytes _data) onlyInState(State.IcoFinished) returns (bool) {
453         return ERC223Token.transfer(_to, _value, _data);
454     }
455 
456     function transfer(address _to, uint _value) returns (bool) {
457         // onlyInState(IcoFinished) check is contained in a call below
458         bytes memory empty;
459         return transfer(_to, _value, empty);
460     }
461 
462     function () payable {
463         revert();
464     }
465 }