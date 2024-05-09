1 pragma solidity >=0.4.4;
2 
3 contract Sale {
4     uint public startTime;
5     uint public stopTime;
6     uint public target;
7     uint public raised;
8     uint public collected;
9     uint public numContributors;
10     mapping(address => uint) public balances;
11 
12     function buyTokens(address _a, uint _eth, uint _time) returns (uint); 
13     function getTokens(address holder) constant returns (uint); 
14     function getRefund(address holder) constant returns (uint); 
15     function getSoldTokens() constant returns (uint); 
16     function getOwnerEth() constant returns (uint); 
17     function tokensPerEth() constant returns (uint);
18     function isActive(uint time) constant returns (bool); 
19     function isComplete(uint time) constant returns (bool); 
20 }
21 
22 contract Constants {
23     uint DECIMALS = 8;
24 }
25 
26 contract EventDefinitions {
27     event logSaleStart(uint startTime, uint stopTime);
28     event logPurchase(address indexed purchaser, uint eth);
29     event logClaim(address indexed purchaser, uint refund, uint tokens);
30 
31     //Token standard events
32     event Transfer(address indexed from, address indexed to, uint value);
33     event Approval(address indexed owner, address indexed spender, uint value);
34 } 
35 
36 contract Testable {
37     uint fakeTime;
38     bool public testing;
39     modifier onlyTesting() {
40         if (!testing) throw;
41         _;
42     }
43     function setFakeTime(uint t) onlyTesting {
44         fakeTime = t;
45     }
46     function addMinutes(uint m) onlyTesting {
47         fakeTime = fakeTime + (m * 1 minutes);
48     }
49     function addDays(uint d) onlyTesting {
50         fakeTime = fakeTime + (d * 1 days);
51     }
52     function currTime() constant returns (uint) {
53         if (testing) {
54             return fakeTime;
55         } else {
56             return block.timestamp;
57         }
58     }
59     function weiPerEth() constant returns (uint) {
60         if (testing) {
61             return 200;
62         } else {
63             return 10**18;
64         }
65     }
66 }
67 
68 contract Owned {
69     address public owner;
70     
71     modifier onlyOwner() {
72         if (msg.sender != owner) throw;
73         _;
74     }
75 
76     address newOwner;
77 
78     function changeOwner(address _newOwner) onlyOwner {
79         newOwner = _newOwner;
80     }
81 
82     function acceptOwnership() {
83         if (msg.sender == newOwner) {
84             owner = newOwner;
85         }
86     }    
87 }
88 
89 //from Zeppelin
90 contract SafeMath {
91     function safeMul(uint a, uint b) internal returns (uint) {
92         uint c = a * b;
93         assert(a == 0 || c / a == b);
94         return c;
95     }
96 
97     function safeSub(uint a, uint b) internal returns (uint) {
98         assert(b <= a);
99         return a - b;
100     }
101 
102     function safeAdd(uint a, uint b) internal returns (uint) {
103         uint c = a + b;
104         assert(c>=a && c>=b);
105         return c;
106     }
107 
108     function assert(bool assertion) internal {
109         if (!assertion) throw;
110     }
111 }
112 
113 contract Token is SafeMath, Owned, Constants {
114     uint public totalSupply;
115 
116     address ico;
117     address controller;
118 
119     string public name;
120     uint8 public decimals; 
121     string public symbol;     
122 
123     modifier onlyControllers() {
124         if (msg.sender != ico &&
125             msg.sender != controller) throw;
126         _;
127     }
128 
129     modifier onlyPayloadSize(uint numwords) {
130         assert(msg.data.length == numwords * 32 + 4);
131         _;
132     } 
133 
134     function Token() { 
135         owner = msg.sender;
136         name = "Monolith TKN";
137         decimals = uint8(DECIMALS);
138         symbol = "TKN";
139     }
140 
141     function setICO(address _ico) onlyOwner {
142         if (ico != 0) throw;
143         ico = _ico;
144     }
145     function setController(address _controller) onlyOwner {
146         if (controller != 0) throw;
147         controller = _controller;
148     }
149     
150     event Transfer(address indexed from, address indexed to, uint value);
151     event Approval(address indexed owner, address indexed spender, uint value);
152     event Mint(address owner, uint amount);
153 
154     //only called from contracts so don't need msg.data.length check
155     function mint(address addr, uint amount) onlyControllers {
156         if (maxSupply > 0 && safeAdd(totalSupply, amount) > maxSupply) throw;
157         balanceOf[addr] = safeAdd(balanceOf[addr], amount);
158         totalSupply = safeAdd(totalSupply, amount);
159         Mint(addr, amount);
160     }
161 
162     mapping(address => uint) public balanceOf;
163     mapping (address => mapping (address => uint)) public allowance;
164 
165     function transfer(address _to, uint _value) 
166     onlyPayloadSize(2)
167     returns (bool success) {
168         if (balanceOf[msg.sender] < _value) return false;
169 
170         balanceOf[msg.sender] = balanceOf[msg.sender] - _value;
171         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
172         Transfer(msg.sender, _to, _value);
173         return true;
174     }
175 
176     function transferFrom(address _from, address _to, uint _value) 
177     onlyPayloadSize(3)
178     returns (bool success) {
179         if (balanceOf[_from] < _value) return false; 
180 
181         var allowed = allowance[_from][msg.sender];
182         if (allowed < _value) return false;
183 
184         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
185         balanceOf[_from] = safeSub(balanceOf[_from], _value);
186         allowance[_from][msg.sender] = safeSub(allowed, _value);
187         Transfer(_from, _to, _value);
188         return true;
189     }
190 
191     function approve(address _spender, uint _value) 
192     onlyPayloadSize(2)
193     returns (bool success) {
194         //require user to set to zero before resetting to nonzero
195         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) {
196             return false;
197         }
198     
199         allowance[msg.sender][_spender] = _value;
200         Approval(msg.sender, _spender, _value);
201         return true;
202     }
203 
204     function increaseApproval (address _spender, uint _addedValue) 
205     onlyPayloadSize(2)
206     returns (bool success) {
207         uint oldValue = allowance[msg.sender][_spender];
208         allowance[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
209         return true;
210     }
211 
212     function decreaseApproval (address _spender, uint _subtractedValue) 
213     onlyPayloadSize(2)
214     returns (bool success) {
215         uint oldValue = allowance[msg.sender][_spender];
216         if (_subtractedValue > oldValue) {
217             allowance[msg.sender][_spender] = 0;
218         } else {
219             allowance[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
220         }
221         return true;
222     }
223 
224     //Holds accumulated dividend tokens other than TKN
225     TokenHolder tokenholder;
226 
227     //once locked, can no longer upgrade tokenholder
228     bool lockedTokenHolder;
229 
230     function lockTokenHolder() onlyOwner {
231         lockedTokenHolder = true;
232     }
233 
234     //while unlocked, 
235     //this gives owner lots of power over held dividend tokens
236     //effectively can deny access to all accumulated tokens
237     //thus crashing TKN value
238     function setTokenHolder(address _th) onlyOwner {
239         if (lockedTokenHolder) throw;
240         tokenholder = TokenHolder(_th);
241     }
242 
243     event Burn(address burner, uint amount);
244 
245     function burn(uint _amount) returns (bool result) {
246         if (_amount > balanceOf[msg.sender]) return false;
247         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _amount);
248         totalSupply = safeSub(totalSupply, _amount);
249         result = tokenholder.burn(msg.sender, _amount);
250         if (!result) throw;
251         Burn(msg.sender, _amount);
252     }
253 
254     uint public maxSupply;
255 
256     function setMaxSupply(uint _maxSupply) {
257         if (msg.sender != controller) throw;
258         if (maxSupply > 0) throw;
259         maxSupply = _maxSupply;
260     }
261 }
262 
263 contract TokenHolder {
264     function burn(address _burner, uint _amount)
265     returns (bool result) { 
266         return false;
267     }
268 }
269 
270 
271 contract ICO is EventDefinitions, Testable, SafeMath, Owned {
272     Token public token;
273     address public controller;
274     address public payee;
275 
276     Sale[] public sales;
277     
278     //salenum => minimum wei
279     mapping (uint => uint) saleMinimumPurchases;
280 
281     //next sale number user can claim from
282     mapping (address => uint) public nextClaim;
283 
284     //net contributed ETH by each user (in case of stop/refund)
285     mapping (address => uint) refundInStop;
286 
287     modifier tokenIsSet() {
288         if (address(token) == 0) throw;
289         _;
290     }
291 
292     modifier onlyController() {
293         if (msg.sender != address(controller)) throw;
294         _;
295     }
296 
297     function ICO() { 
298         owner = msg.sender;
299         payee = msg.sender;
300         allStopper = msg.sender;
301     }
302 
303     //payee can only be changed once
304     //intent is to lock payee to a contract that holds or distributes funds
305     //in deployment, be sure to do this before changing owner!
306     //we initialize to owner to keep things simple if there's no payee contract
307     function changePayee(address newPayee) 
308     onlyOwner notAllStopped {
309         payee = newPayee;
310     }
311 
312     function setToken(address _token) onlyOwner {
313         if (address(token) != 0x0) throw;
314         token = Token(_token);
315     }
316 
317     //before adding sales, we can set this to be a test ico
318     //this lets us manipulate time and drastically lowers weiPerEth
319     function setAsTest() onlyOwner {
320         if (sales.length == 0) {
321             testing = true;
322         }
323     }
324 
325     function setController(address _controller) 
326     onlyOwner notAllStopped {
327         if (address(controller) != 0x0) throw;
328         controller = _controller; //ICOController(_controller);
329     }
330 
331     //********************************************************
332     //Sales
333     //********************************************************
334 
335     function addSale(address sale, uint minimumPurchase) 
336     onlyController notAllStopped {
337         uint salenum = sales.length;
338         sales.push(Sale(sale));
339         saleMinimumPurchases[salenum] = minimumPurchase;
340         logSaleStart(Sale(sale).startTime(), Sale(sale).stopTime());
341     }
342 
343     function addSale(address sale) onlyController {
344         addSale(sale, 0);
345     }
346 
347     function getCurrSale() constant returns (uint) {
348         if (sales.length == 0) throw; //no reason to call before startFirstSale
349         return sales.length - 1;
350     }
351 
352     function currSaleActive() constant returns (bool) {
353         return sales[getCurrSale()].isActive(currTime());
354     }
355 
356     function currSaleComplete() constant returns (bool) {
357         return sales[getCurrSale()].isComplete(currTime());
358     }
359 
360     function numSales() constant returns (uint) {
361         return sales.length;
362     }
363 
364     function numContributors(uint salenum) constant returns (uint) {
365         return sales[salenum].numContributors();
366     }
367 
368     //********************************************************
369     //ETH Purchases
370     //********************************************************
371 
372     event logPurchase(address indexed purchaser, uint value);
373 
374     function () payable {
375         deposit();
376     }
377 
378     function deposit() payable notAllStopped {
379         doDeposit(msg.sender, msg.value);
380 
381         //not in doDeposit because only for Eth:
382         uint contrib = refundInStop[msg.sender];
383         refundInStop[msg.sender] = contrib + msg.value;
384 
385         logPurchase(msg.sender, msg.value);
386     }
387 
388     //is also called by token contributions
389     function doDeposit(address _for, uint _value) private {
390         uint currSale = getCurrSale();
391         if (!currSaleActive()) throw;
392         if (_value < saleMinimumPurchases[currSale]) throw;
393 
394         uint tokensToMintNow = sales[currSale].buyTokens(_for, _value, currTime());
395 
396         if (tokensToMintNow > 0) {
397             token.mint(_for, tokensToMintNow);
398         }
399     }
400 
401     //********************************************************
402     //Token Purchases
403     //********************************************************
404 
405     //Support for purchase via other tokens
406     //We don't attempt to deal with those tokens directly
407     //We just give admin ability to tell us what deposit to credit
408     //We only allow for first sale 
409     //because first sale normally has no refunds
410     //As written, the refund would be in ETH
411 
412     event logPurchaseViaToken(
413                         address indexed purchaser, address indexed token, 
414                         uint depositedTokens, uint ethValue, 
415                         bytes32 _reference);
416 
417     event logPurchaseViaFiat(
418                         address indexed purchaser, uint ethValue, 
419                         bytes32 _reference);
420 
421     mapping (bytes32 => bool) public mintRefs;
422     mapping (address => uint) public raisedFromToken;
423     uint public raisedFromFiat;
424 
425     function depositFiat(address _for, uint _ethValue, bytes32 _reference) 
426     notAllStopped onlyOwner {
427         if (getCurrSale() > 0) throw; //only first sale allows this
428         if (mintRefs[_reference]) throw; //already minted for this reference
429         mintRefs[_reference] = true;
430         raisedFromFiat = safeAdd(raisedFromFiat, _ethValue);
431 
432         doDeposit(_for, _ethValue);
433         logPurchaseViaFiat(_for, _ethValue, _reference);
434     }
435 
436     function depositTokens(address _for, address _token, 
437                            uint _ethValue, uint _depositedTokens, 
438                            bytes32 _reference) 
439     notAllStopped onlyOwner {
440         if (getCurrSale() > 0) throw; //only first sale allows this
441         if (mintRefs[_reference]) throw; //already minted for this reference
442         mintRefs[_reference] = true;
443         raisedFromToken[_token] = safeAdd(raisedFromToken[_token], _ethValue);
444 
445         //tokens do not count toward price changes and limits
446         //we have to look up pricing, and do our own mint()
447         uint tokensPerEth = sales[0].tokensPerEth();
448         uint tkn = safeMul(_ethValue, tokensPerEth) / weiPerEth();
449         token.mint(_for, tkn);
450         
451         logPurchaseViaToken(_for, _token, _depositedTokens, _ethValue, _reference);
452     }
453 
454     //********************************************************
455     //Roundoff Protection
456     //********************************************************
457     //protect against roundoff in payouts
458     //this prevents last person getting refund from not being able to collect
459     function safebalance(uint bal) private returns (uint) {
460         if (bal > this.balance) {
461             return this.balance;
462         } else {
463             return bal;
464         }
465     }
466 
467     //It'd be nicer if last person got full amount
468     //instead of getting shorted by safebalance()
469     //topUp() allows admin to deposit excess ether to cover it
470     //and later get back any left over 
471 
472     uint public topUpAmount;
473 
474     function topUp() payable onlyOwner notAllStopped {
475         topUpAmount = safeAdd(topUpAmount, msg.value);
476     }
477 
478     function withdrawTopUp() onlyOwner notAllStopped {
479         uint amount = topUpAmount;
480         topUpAmount = 0;
481         if (!msg.sender.call.value(safebalance(amount))()) throw;
482     }
483 
484     //********************************************************
485     //Claims
486     //********************************************************
487 
488     //Claim whatever you're owed, 
489     //from whatever completed sales you haven't already claimed
490     //this covers refunds, and any tokens not minted immediately
491     //(i.e. auction tokens, not firstsale tokens)
492     function claim() notAllStopped {
493         var (tokens, refund, nc) = claimable(msg.sender, true);
494         nextClaim[msg.sender] = nc;
495         logClaim(msg.sender, refund, tokens);
496         if (tokens > 0) {
497             token.mint(msg.sender, tokens);
498         }
499         if (refund > 0) {
500             refundInStop[msg.sender] = safeSub(refundInStop[msg.sender], refund);
501             if (!msg.sender.send(safebalance(refund))) throw;
502         }
503     }
504 
505     //Allow admin to claim on behalf of user and send to any address.
506     //Scenarios:
507     //  user lost key
508     //  user sent from an exchange
509     //  user has expensive fallback function
510     //  user is unknown, funds presumed abandoned
511     //We only allow this after one year has passed.
512     function claimFor(address _from, address _to) 
513     onlyOwner notAllStopped {
514         var (tokens, refund, nc) = claimable(_from, false);
515         nextClaim[_from] = nc;
516 
517         logClaim(_from, refund, tokens);
518 
519         if (tokens > 0) {
520             token.mint(_to, tokens);
521         }
522         if (refund > 0) {
523             refundInStop[_from] = safeSub(refundInStop[_from], refund);
524             if (!_to.send(safebalance(refund))) throw;
525         }
526     }
527 
528     function claimable(address _a, bool _includeRecent) 
529     constant private tokenIsSet 
530     returns (uint tokens, uint refund, uint nc) {
531         nc = nextClaim[_a];
532 
533         while (nc < sales.length &&
534                sales[nc].isComplete(currTime()) &&
535                ( _includeRecent || 
536                  sales[nc].stopTime() + 1 years < currTime() )) 
537         {
538             refund = safeAdd(refund, sales[nc].getRefund(_a));
539             tokens = safeAdd(tokens, sales[nc].getTokens(_a));
540             nc += 1;
541         }
542     }
543 
544     function claimableTokens(address a) constant returns (uint) {
545         var (tokens, refund, nc) = claimable(a, true);
546         return tokens;
547     }
548 
549     function claimableRefund(address a) constant returns (uint) {
550         var (tokens, refund, nc) = claimable(a, true);
551         return refund;
552     }
553 
554     function claimableTokens() constant returns (uint) {
555         return claimableTokens(msg.sender);
556     }
557 
558     function claimableRefund() constant returns (uint) {
559         return claimableRefund(msg.sender);
560     }
561 
562     //********************************************************
563     //Withdraw ETH
564     //********************************************************
565 
566     mapping (uint => bool) ownerClaimed;
567 
568     function claimableOwnerEth(uint salenum) constant returns (uint) {
569         uint time = currTime();
570         if (!sales[salenum].isComplete(time)) return 0;
571         return sales[salenum].getOwnerEth();
572     }
573 
574     function claimOwnerEth(uint salenum) onlyOwner notAllStopped {
575         if (ownerClaimed[salenum]) throw;
576 
577         uint ownereth = claimableOwnerEth(salenum);
578         if (ownereth > 0) {
579             ownerClaimed[salenum] = true;
580             if ( !payee.call.value(safebalance(ownereth))() ) throw;
581         }
582     }
583 
584     //********************************************************
585     //Sweep tokens sent here
586     //********************************************************
587 
588     //Support transfer of erc20 tokens out of this contract's address
589     //Even if we don't intend for people to send them here, somebody will
590 
591     event logTokenTransfer(address token, address to, uint amount);
592 
593     function transferTokens(address _token, address _to) onlyOwner {
594         Token token = Token(_token);
595         uint balance = token.balanceOf(this);
596         token.transfer(_to, balance);
597         logTokenTransfer(_token, _to, balance);
598     }
599 
600     //********************************************************
601     //Emergency Stop
602     //********************************************************
603 
604     bool allstopped;
605     bool permastopped;
606 
607     //allow allStopper to be more secure address than owner
608     //in which case it doesn't make sense to let owner change it again
609     address allStopper;
610     function setAllStopper(address _a) onlyOwner {
611         if (allStopper != owner) return;
612         allStopper = _a;
613     }
614     modifier onlyAllStopper() {
615         if (msg.sender != allStopper) throw;
616         _;
617     }
618 
619     event logAllStop();
620     event logAllStart();
621 
622     modifier allStopped() {
623         if (!allstopped) throw;
624         _;
625     }
626 
627     modifier notAllStopped() {
628         if (allstopped) throw;
629         _;
630     }
631 
632     function allStop() onlyAllStopper {
633         allstopped = true;    
634         logAllStop();
635     }
636 
637     function allStart() onlyAllStopper {
638         if (!permastopped) {
639             allstopped = false;
640             logAllStart();
641         }
642     }
643 
644     function emergencyRefund(address _a, uint _amt) 
645     allStopped 
646     onlyAllStopper {
647         //if you start actually calling this refund, the disaster is real.
648         //Don't allow restart, so this can't be abused 
649         permastopped = true;
650 
651         uint amt = _amt;
652 
653         uint ethbal = refundInStop[_a];
654 
655         //convenient default so owner doesn't have to look up balances
656         //this is fine as long as no funds have been stolen
657         if (amt == 0) amt = ethbal; 
658 
659         //nobody can be refunded more than they contributed
660         if (amt > ethbal) amt = ethbal;
661 
662         //since everything is halted, safer to call.value
663         //so we don't have to worry about expensive fallbacks
664         if ( !_a.call.value(safebalance(amt))() ) throw;
665     }
666 
667     function raised() constant returns (uint) {
668         return sales[getCurrSale()].raised();
669     }
670 
671     function tokensPerEth() constant returns (uint) {
672         return sales[getCurrSale()].tokensPerEth();
673     }
674 }