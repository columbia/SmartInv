1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath {
8     function mul(uint a, uint b) constant internal returns (uint) {
9         uint c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint a, uint b) constant internal returns (uint) {
15         assert(b != 0); // Solidity automatically throws when dividing by 0
16         uint c = a / b;
17         assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint a, uint b) constant internal returns (uint) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint a, uint b) constant internal returns (uint) {
27         uint c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 
32     // Volume bonus calculation
33     function volumeBonus(uint etherValue) constant internal returns (uint) {
34 
35         if(etherValue >=  500000000000000000000) return 10; // 500 ETH +10% tokens
36         if(etherValue >=  300000000000000000000) return 7;  // 300 ETH +7% tokens
37         if(etherValue >=  100000000000000000000) return 5;  // 100 ETH +5% tokens
38         if(etherValue >=   50000000000000000000) return 3;  // 50 ETH +3% tokens
39         if(etherValue >=   20000000000000000000) return 2;  // 20 ETH +2% tokens
40         if(etherValue >=   10000000000000000000) return 1;  // 10 ETH +1% tokens
41 
42         return 0;
43     }
44 
45 }
46 
47 
48 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
49 /// @title Abstract token contract - Functions to be implemented by token contracts.
50 
51 contract AbstractToken {
52     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions
53     function totalSupply() constant returns (uint) {}
54     function balanceOf(address owner) constant returns (uint balance);
55     function transfer(address to, uint value) returns (bool success);
56     function transferFrom(address from, address to, uint value) returns (bool success);
57     function approve(address spender, uint value) returns (bool success);
58     function allowance(address owner, address spender) constant returns (uint remaining);
59 
60     event Transfer(address indexed from, address indexed to, uint value);
61     event Approval(address indexed owner, address indexed spender, uint value);
62     event Issuance(address indexed to, uint value);
63 }
64 
65 contract IcoLimits {
66     uint constant privateSaleStart = 1511136000; // 11/20/2017 @ 12:00am (UTC)
67     uint constant privateSaleEnd   = 1512086399; // 11/30/2017 @ 11:59pm (UTC)
68 
69     uint constant presaleStart     = 1512086400; // 12/01/2017 @ 12:00am (UTC)
70     uint constant presaleEnd       = 1513900799; // 12/21/2017 @ 11:59pm (UTC)
71 
72     uint constant publicSaleStart  = 1516320000; // 01/19/2018 @ 12:00am (UTC)
73     uint constant publicSaleEnd    = 1521158399; // 03/15/2018 @ 11:59pm (UTC)
74 
75     modifier afterPublicSale() {
76         require(now > publicSaleEnd);
77         _;
78     }
79 
80     uint constant privateSalePrice = 4000; // SNEK tokens per 1 ETH
81     uint constant preSalePrice     = 3000; // SNEK tokens per 1 ETH
82     uint constant publicSalePrice  = 2000; // SNEK tokens per 1 ETH
83 
84     uint constant privateSaleSupplyLimit =  600  * privateSalePrice * 1000000000000000000;
85     uint constant preSaleSupplyLimit     =  1200 * preSalePrice     * 1000000000000000000;
86     uint constant publicSaleSupplyLimit  =  5000 * publicSalePrice  * 1000000000000000000;
87 }
88 
89 contract StandardToken is AbstractToken, IcoLimits {
90     /*
91      *  Data structures
92      */
93     mapping (address => uint) balances;
94     mapping (address => bool) ownerAppended;
95     mapping (address => mapping (address => uint)) allowed;
96 
97     uint public totalSupply;
98 
99     address[] public owners;
100 
101     /*
102      *  Read and write storage functions
103      */
104     /// @dev Transfers sender's tokens to a given address. Returns success.
105     /// @param _to Address of token receiver.
106     /// @param _value Number of tokens to transfer.
107     function transfer(address _to, uint _value) afterPublicSale returns (bool success) {
108         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
109             balances[msg.sender] -= _value;
110             balances[_to] += _value;
111             if(!ownerAppended[_to]) {
112                 ownerAppended[_to] = true;
113                 owners.push(_to);
114             }
115             Transfer(msg.sender, _to, _value);
116             return true;
117         }
118         else {
119             return false;
120         }
121     }
122 
123     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
124     /// @param _from Address from where tokens are withdrawn.
125     /// @param _to Address to where tokens are sent.
126     /// @param _value Number of tokens to transfer.
127     function transferFrom(address _from, address _to, uint _value) afterPublicSale returns (bool success) {
128         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
129             balances[_to] += _value;
130             balances[_from] -= _value;
131             allowed[_from][msg.sender] -= _value;
132             if(!ownerAppended[_to]) {
133                 ownerAppended[_to] = true;
134                 owners.push(_to);
135             }
136             Transfer(_from, _to, _value);
137             return true;
138         }
139         else {
140             return false;
141         }
142     }
143 
144     /// @dev Returns number of tokens owned by given address.
145     /// @param _owner Address of token owner.
146     function balanceOf(address _owner) constant returns (uint balance) {
147         return balances[_owner];
148     }
149 
150     /// @dev Sets approved amount of tokens for spender. Returns success.
151     /// @param _spender Address of allowed account.
152     /// @param _value Number of approved tokens.
153     function approve(address _spender, uint _value) returns (bool success) {
154         allowed[msg.sender][_spender] = _value;
155         Approval(msg.sender, _spender, _value);
156         return true;
157     }
158 
159     /*
160      * Read storage functions
161      */
162     /// @dev Returns number of allowed tokens for given address.
163     /// @param _owner Address of token owner.
164     /// @param _spender Address of token spender.
165     function allowance(address _owner, address _spender) constant returns (uint remaining) {
166         return allowed[_owner][_spender];
167     }
168 
169 }
170 
171 
172 contract ExoTownToken is StandardToken, SafeMath {
173 
174     /*
175      * Token meta data
176      */
177 
178     string public constant name = "ExoTown token";
179     string public constant symbol = "SNEK";
180     uint public constant decimals = 18;
181 
182     address public icoContract = 0x0;
183 
184 
185     /*
186      * Modifiers
187      */
188 
189     modifier onlyIcoContract() {
190         // only ICO contract is allowed to proceed
191         require(msg.sender == icoContract);
192         _;
193     }
194 
195 
196     /*
197      * Contract functions
198      */
199 
200     /// @dev Contract is needed in icoContract address
201     /// @param _icoContract Address of account which will be mint tokens
202     function ExoTownToken(address _icoContract) {
203         require(_icoContract != 0x0);
204         icoContract = _icoContract;
205     }
206 
207     /// @dev Burns tokens from address. It can be applied by account with address this.icoContract
208     /// @param _from Address of account, from which will be burned tokens
209     /// @param _value Amount of tokens, that will be burned
210     function burnTokens(address _from, uint _value) onlyIcoContract {
211         require(_value > 0);
212 
213         balances[_from] = sub(balances[_from], _value);
214         totalSupply -= _value;
215     }
216 
217     /// @dev Adds tokens to address. It can be applied by account with address this.icoContract
218     /// @param _to Address of account to which the tokens will pass
219     /// @param _value Amount of tokens
220     function emitTokens(address _to, uint _value) onlyIcoContract {
221         require(totalSupply + _value >= totalSupply);
222         balances[_to] = add(balances[_to], _value);
223         totalSupply += _value;
224 
225         if(!ownerAppended[_to]) {
226             ownerAppended[_to] = true;
227             owners.push(_to);
228         }
229 
230         Transfer(0x0, _to, _value);
231 
232     }
233 
234     function getOwner(uint index) constant returns (address, uint) {
235         return (owners[index], balances[owners[index]]);
236     }
237 
238     function getOwnerCount() constant returns (uint) {
239         return owners.length;
240     }
241 
242 }
243 
244 
245 contract ExoTownIco is SafeMath, IcoLimits {
246 
247     /*
248      * ICO meta data
249      */
250     ExoTownToken public exotownToken;
251 
252     enum State {
253         Pause,
254         Running
255     }
256 
257     State public currentState = State.Pause;
258 
259     uint public privateSaleSoldTokens = 0;
260     uint public preSaleSoldTokens     = 0;
261     uint public publicSaleSoldTokens  = 0;
262 
263     uint public privateSaleEtherRaised = 0;
264     uint public preSaleEtherRaised     = 0;
265     uint public publicSaleEtherRaised  = 0;
266 
267     // Address of manager
268     address public icoManager;
269     address public founderWallet;
270 
271     // Address from which tokens could be burned
272     address public buyBack;
273 
274     // Purpose
275     address public developmentWallet;
276     address public marketingWallet;
277     address public teamWallet;
278 
279     address public bountyOwner;
280 
281     // Mediator wallet is used for tracking user payments and reducing users' fee
282     address public mediatorWallet;
283 
284     bool public sentTokensToBountyOwner = false;
285     bool public sentTokensToFounders = false;
286 
287     
288 
289     /*
290      * Modifiers
291      */
292 
293     modifier whenInitialized() {
294         // only when contract is initialized
295         require(currentState >= State.Running);
296         _;
297     }
298 
299     modifier onlyManager() {
300         // only ICO manager can do this action
301         require(msg.sender == icoManager);
302         _;
303     }
304 
305     modifier onIco() {
306         require( isPrivateSale() || isPreSale() || isPublicSale() );
307         _;
308     }
309 
310     modifier hasBountyCampaign() {
311         require(bountyOwner != 0x0);
312         _;
313     }
314 
315     function isPrivateSale() constant internal returns (bool) {
316         return now >= privateSaleStart && now <= privateSaleEnd;
317     }
318 
319     function isPreSale() constant internal returns (bool) {
320         return now >= presaleStart && now <= presaleEnd;
321     }
322 
323     function isPublicSale() constant internal returns (bool) {
324         return now >= publicSaleStart && now <= publicSaleEnd;
325     }
326 
327 
328 
329 
330 
331 
332 
333     function getPrice() constant internal returns (uint) {
334         if (isPrivateSale()) return privateSalePrice;
335         if (isPreSale()) return preSalePrice;
336         if (isPublicSale()) return publicSalePrice;
337 
338         return publicSalePrice;
339     }
340 
341     function getStageSupplyLimit() constant returns (uint) {
342         if (isPrivateSale()) return privateSaleSupplyLimit;
343         if (isPreSale()) return preSaleSupplyLimit;
344         if (isPublicSale()) return publicSaleSupplyLimit;
345 
346         return 0;
347     }
348 
349     function getStageSoldTokens() constant returns (uint) {
350         if (isPrivateSale()) return privateSaleSoldTokens;
351         if (isPreSale()) return preSaleSoldTokens;
352         if (isPublicSale()) return publicSaleSoldTokens;
353 
354         return 0;
355     }
356 
357     function addStageTokensSold(uint _amount) internal {
358         if (isPrivateSale()) privateSaleSoldTokens = add(privateSaleSoldTokens, _amount);
359         if (isPreSale())     preSaleSoldTokens = add(preSaleSoldTokens, _amount);
360         if (isPublicSale())  publicSaleSoldTokens = add(publicSaleSoldTokens, _amount);
361     }
362 
363     function addStageEtherRaised(uint _amount) internal {
364         if (isPrivateSale()) privateSaleEtherRaised = add(privateSaleEtherRaised, _amount);
365         if (isPreSale())     preSaleEtherRaised = add(preSaleEtherRaised, _amount);
366         if (isPublicSale())  publicSaleEtherRaised = add(publicSaleEtherRaised, _amount);
367     }
368 
369     function getStageEtherRaised() constant returns (uint) {
370         if (isPrivateSale()) return privateSaleEtherRaised;
371         if (isPreSale())     return preSaleEtherRaised;
372         if (isPublicSale())  return publicSaleEtherRaised;
373 
374         return 0;
375     }
376 
377     function getTokensSold() constant returns (uint) {
378         return
379             privateSaleSoldTokens +
380             preSaleSoldTokens +
381             publicSaleSoldTokens;
382     }
383 
384     function getEtherRaised() constant returns (uint) {
385         return
386             privateSaleEtherRaised +
387             preSaleEtherRaised +
388             publicSaleEtherRaised;
389     }
390 
391 
392 
393 
394 
395 
396 
397 
398 
399 
400 
401 
402 
403 
404 
405     /// @dev Constructor of ICO. Requires address of icoManager,
406     /// @param _icoManager Address of ICO manager
407     function ExoTownIco(address _icoManager) {
408         require(_icoManager != 0x0);
409 
410         exotownToken = new ExoTownToken(this);
411         icoManager = _icoManager;
412     }
413 
414     /// Initialises addresses of founder, target wallets
415     /// @param _founder Address of Founder
416     /// @param _dev Address of Development wallet
417     /// @param _pr Address of Marketing wallet
418     /// @param _team Address of Team wallet
419     /// @param _buyback Address of wallet used for burning tokens
420     /// @param _mediator Address of Mediator wallet
421 
422     function init(
423         address _founder,
424         address _dev,
425         address _pr,
426         address _team,
427         address _buyback,
428         address _mediator
429     ) onlyManager {
430         require(currentState == State.Pause);
431         require(_founder != 0x0);
432         require(_dev != 0x0);
433         require(_pr != 0x0);
434         require(_team != 0x0);
435         require(_buyback != 0x0);
436         require(_mediator != 0x0);
437 
438         founderWallet = _founder;
439         developmentWallet = _dev;
440         marketingWallet = _pr;
441         teamWallet = _team;
442         buyBack = _buyback;
443         mediatorWallet = _mediator;
444 
445         currentState = State.Running;
446 
447         exotownToken.emitTokens(icoManager, 0);
448     }
449 
450     /// @dev Sets new state
451     /// @param _newState Value of new state
452     function setState(State _newState) public onlyManager {
453         currentState = _newState;
454     }
455 
456     /// @dev Sets new manager. Only manager can do it
457     /// @param _newIcoManager Address of new ICO manager
458     function setNewManager(address _newIcoManager) onlyManager {
459         require(_newIcoManager != 0x0);
460         icoManager = _newIcoManager;
461     }
462 
463     /// @dev Sets bounty owner. Only manager can do it
464     /// @param _bountyOwner Address of Bounty owner
465     function setBountyCampaign(address _bountyOwner) onlyManager {
466         require(_bountyOwner != 0x0);
467         bountyOwner = _bountyOwner;
468     }
469 
470     /// @dev Sets new Mediator wallet. Only manager can do it
471     /// @param _mediator Address of Mediator wallet
472     function setNewMediator(address _mediator) onlyManager {
473         require(_mediator != 0x0);
474         mediatorWallet = _mediator;
475     }
476 
477 
478     /// @dev Buy quantity of tokens depending on the amount of sent ethers.
479     /// @param _buyer Address of account which will receive tokens
480     function buyTokens(address _buyer) private {
481         require(_buyer != 0x0);
482         require(msg.value > 0);
483 
484         uint tokensToEmit = msg.value * getPrice();
485         uint volumeBonusPercent = volumeBonus(msg.value);
486 
487         if (volumeBonusPercent > 0) {
488             tokensToEmit = mul(tokensToEmit, 100 + volumeBonusPercent) / 100;
489         }
490 
491         uint stageSupplyLimit = getStageSupplyLimit();
492         uint stageSoldTokens = getStageSoldTokens();
493 
494         require(add(stageSoldTokens, tokensToEmit) <= stageSupplyLimit);
495 
496         exotownToken.emitTokens(_buyer, tokensToEmit);
497 
498         // Public statistics
499         addStageTokensSold(tokensToEmit);
500         addStageEtherRaised(msg.value);
501 
502         distributeEtherByStage();
503 
504     }
505 
506     /// @dev Buy tokens to specified wallet
507     function giftToken(address _to) public payable onIco {
508         buyTokens(_to);
509     }
510 
511     /// @dev Fall back function
512     function () payable onIco {
513         buyTokens(msg.sender);
514     }
515 
516     function distributeEtherByStage() private {
517         uint _balance = this.balance;
518         uint _balance_div = _balance / 100;
519 
520         uint _devAmount = _balance_div * 65;
521         uint _prAmount = _balance_div * 25;
522 
523         uint total = _devAmount + _prAmount;
524         if (total > 0) {
525             // Top up Mediator wallet with 1% of Development amount = 0.65% of contribution amount.
526             // It will cover tracking transaction fee (if any).
527             // See White Paper for more information about payment tracking
528 
529             uint _mediatorAmount = _devAmount / 100;
530             mediatorWallet.transfer(_mediatorAmount);
531 
532             developmentWallet.transfer(_devAmount - _mediatorAmount);
533             marketingWallet.transfer(_prAmount);
534             teamWallet.transfer(_balance - _devAmount - _prAmount);
535         }
536     }
537 
538 
539     /// @dev Partial withdraw. Only manager can do it
540     function withdrawEther(uint _value) onlyManager {
541         require(_value > 0);
542         require(_value <= this.balance);
543         // send 1234 to get 1.234
544         icoManager.transfer(_value * 1000000000000000); // 10^15
545     }
546 
547     ///@dev Send tokens to bountyOwner depending on crowdsale results. Can be send only after public sale.
548     function sendTokensToBountyOwner() onlyManager whenInitialized hasBountyCampaign afterPublicSale {
549         require(!sentTokensToBountyOwner);
550 
551         //Calculate bounty tokens depending on total tokens sold
552         uint bountyTokens = getTokensSold() / 40; // 2.5%
553 
554         exotownToken.emitTokens(bountyOwner, bountyTokens);
555 
556         sentTokensToBountyOwner = true;
557     }
558 
559     /// @dev Send tokens to founders.
560     function sendTokensToFounders() onlyManager whenInitialized afterPublicSale {
561         require(!sentTokensToFounders);
562 
563         //Calculate founder reward depending on total tokens sold
564         uint founderReward = getTokensSold() / 10; // 10%
565 
566         exotownToken.emitTokens(founderWallet, founderReward);
567 
568         sentTokensToFounders = true;
569     }
570 
571     // Anyone could burn tokens by sending it to buyBack address and calling this function.
572     function burnTokens(uint _amount) afterPublicSale {
573         exotownToken.burnTokens(buyBack, _amount);
574     }
575 }