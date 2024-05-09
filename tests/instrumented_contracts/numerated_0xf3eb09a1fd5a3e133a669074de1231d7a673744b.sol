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
66     uint constant privateSaleStart = 1511676000; // 11/26/2017 @ 06:00am (UTC)
67     uint constant privateSaleEnd   = 1512172799; // 12/01/2017 @ 11:59pm (UTC)
68 
69     uint constant presaleStart     = 1512172800; // 12/02/2017 @ 12:00am (UTC)
70     uint constant presaleEnd       = 1513987199; // 12/22/2017 @ 11:59pm (UTC)
71 
72     uint constant publicSaleStart  = 1516320000; // 01/19/2018 @ 12:00am (UTC)
73     uint constant publicSaleEnd    = 1521158399; // 03/15/2018 @ 11:59pm (UTC)
74 
75     uint constant foundersTokensUnlock = 1558310400; // 05/20/2019 @ 12:00am (UTC)
76 
77     modifier afterPublicSale() {
78         require(now > publicSaleEnd);
79         _;
80     }
81 
82     uint constant privateSalePrice = 4000; // SNEK tokens per 1 ETH
83     uint constant preSalePrice     = 3000; // SNEK tokens per 1 ETH
84     uint constant publicSalePrice  = 2000; // SNEK tokens per 1 ETH
85 
86     uint constant privateSaleSupplyLimit =  600  * privateSalePrice * 1000000000000000000;
87     uint constant preSaleSupplyLimit     =  1200 * preSalePrice     * 1000000000000000000;
88     uint constant publicSaleSupplyLimit  =  5000 * publicSalePrice  * 1000000000000000000;
89 }
90 
91 contract StandardToken is AbstractToken, IcoLimits {
92     /*
93      *  Data structures
94      */
95     mapping (address => uint) balances;
96     mapping (address => bool) ownerAppended;
97     mapping (address => mapping (address => uint)) allowed;
98 
99     uint public totalSupply;
100 
101     address[] public owners;
102 
103     /*
104      *  Read and write storage functions
105      */
106     /// @dev Transfers sender's tokens to a given address. Returns success.
107     /// @param _to Address of token receiver.
108     /// @param _value Number of tokens to transfer.
109     function transfer(address _to, uint _value) afterPublicSale returns (bool success) {
110         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
111             balances[msg.sender] -= _value;
112             balances[_to] += _value;
113             if(!ownerAppended[_to]) {
114                 ownerAppended[_to] = true;
115                 owners.push(_to);
116             }
117             Transfer(msg.sender, _to, _value);
118             return true;
119         }
120         else {
121             return false;
122         }
123     }
124 
125     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
126     /// @param _from Address from where tokens are withdrawn.
127     /// @param _to Address to where tokens are sent.
128     /// @param _value Number of tokens to transfer.
129     function transferFrom(address _from, address _to, uint _value) afterPublicSale returns (bool success) {
130         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
131             balances[_to] += _value;
132             balances[_from] -= _value;
133             allowed[_from][msg.sender] -= _value;
134             if(!ownerAppended[_to]) {
135                 ownerAppended[_to] = true;
136                 owners.push(_to);
137             }
138             Transfer(_from, _to, _value);
139             return true;
140         }
141         else {
142             return false;
143         }
144     }
145 
146     /// @dev Returns number of tokens owned by given address.
147     /// @param _owner Address of token owner.
148     function balanceOf(address _owner) constant returns (uint balance) {
149         return balances[_owner];
150     }
151 
152     /// @dev Sets approved amount of tokens for spender. Returns success.
153     /// @param _spender Address of allowed account.
154     /// @param _value Number of approved tokens.
155     function approve(address _spender, uint _value) returns (bool success) {
156         allowed[msg.sender][_spender] = _value;
157         Approval(msg.sender, _spender, _value);
158         return true;
159     }
160 
161     /*
162      * Read storage functions
163      */
164     /// @dev Returns number of allowed tokens for given address.
165     /// @param _owner Address of token owner.
166     /// @param _spender Address of token spender.
167     function allowance(address _owner, address _spender) constant returns (uint remaining) {
168         return allowed[_owner][_spender];
169     }
170 
171 }
172 
173 
174 contract ExoTownToken is StandardToken, SafeMath {
175 
176     /*
177      * Token meta data
178      */
179 
180     string public constant name = "ExoTown token";
181     string public constant symbol = "SNEK";
182     uint public constant decimals = 18;
183 
184     address public icoContract = 0x0;
185 
186 
187     /*
188      * Modifiers
189      */
190 
191     modifier onlyIcoContract() {
192         // only ICO contract is allowed to proceed
193         require(msg.sender == icoContract);
194         _;
195     }
196 
197 
198     /*
199      * Contract functions
200      */
201 
202     /// @dev Contract is needed in icoContract address
203     /// @param _icoContract Address of account which will be mint tokens
204     function ExoTownToken(address _icoContract) {
205         require(_icoContract != 0x0);
206         icoContract = _icoContract;
207     }
208 
209     /// @dev Burns tokens from address. It can be applied by account with address this.icoContract
210     /// @param _from Address of account, from which will be burned tokens
211     /// @param _value Amount of tokens, that will be burned
212     function burnTokens(address _from, uint _value) onlyIcoContract {
213         require(_value > 0);
214 
215         balances[_from] = sub(balances[_from], _value);
216         totalSupply -= _value;
217     }
218 
219     /// @dev Adds tokens to address. It can be applied by account with address this.icoContract
220     /// @param _to Address of account to which the tokens will pass
221     /// @param _value Amount of tokens
222     function emitTokens(address _to, uint _value) onlyIcoContract {
223         require(totalSupply + _value >= totalSupply);
224         balances[_to] = add(balances[_to], _value);
225         totalSupply += _value;
226 
227         if(!ownerAppended[_to]) {
228             ownerAppended[_to] = true;
229             owners.push(_to);
230         }
231 
232         Transfer(0x0, _to, _value);
233 
234     }
235 
236     function getOwner(uint index) constant returns (address, uint) {
237         return (owners[index], balances[owners[index]]);
238     }
239 
240     function getOwnerCount() constant returns (uint) {
241         return owners.length;
242     }
243 
244 }
245 
246 
247 contract ExoTownIco is SafeMath, IcoLimits {
248 
249     /*
250      * ICO meta data
251      */
252     ExoTownToken public exotownToken;
253 
254     enum State {
255         Pause,
256         Running
257     }
258 
259     State public currentState = State.Pause;
260 
261     uint public privateSaleSoldTokens = 0;
262     uint public preSaleSoldTokens     = 0;
263     uint public publicSaleSoldTokens  = 0;
264 
265     uint public privateSaleEtherRaised = 0;
266     uint public preSaleEtherRaised     = 0;
267     uint public publicSaleEtherRaised  = 0;
268 
269     // Address of manager
270     address public icoManager;
271     address public founderWallet;
272 
273     // Address from which tokens could be burned
274     address public buyBack;
275 
276     // Purpose
277     address public developmentWallet;
278     address public marketingWallet;
279     address public teamWallet;
280 
281     address public bountyOwner;
282 
283     // Mediator wallet is used for tracking user payments and reducing users' fee
284     address public mediatorWallet;
285 
286     bool public sentTokensToBountyOwner = false;
287     bool public sentTokensToFounders = false;
288 
289     
290 
291     /*
292      * Modifiers
293      */
294 
295     modifier whenInitialized() {
296         // only when contract is initialized
297         require(currentState >= State.Running);
298         _;
299     }
300 
301     modifier onlyManager() {
302         // only ICO manager can do this action
303         require(msg.sender == icoManager);
304         _;
305     }
306 
307     modifier onIco() {
308         require( isPrivateSale() || isPreSale() || isPublicSale() );
309         _;
310     }
311 
312     modifier hasBountyCampaign() {
313         require(bountyOwner != 0x0);
314         _;
315     }
316 
317     function isPrivateSale() constant internal returns (bool) {
318         return now >= privateSaleStart && now <= privateSaleEnd;
319     }
320 
321     function isPreSale() constant internal returns (bool) {
322         return now >= presaleStart && now <= presaleEnd;
323     }
324 
325     function isPublicSale() constant internal returns (bool) {
326         return now >= publicSaleStart && now <= publicSaleEnd;
327     }
328 
329 
330 
331 
332 
333 
334 
335     function getPrice() constant internal returns (uint) {
336         if (isPrivateSale()) return privateSalePrice;
337         if (isPreSale()) return preSalePrice;
338         if (isPublicSale()) return publicSalePrice;
339 
340         return publicSalePrice;
341     }
342 
343     function getStageSupplyLimit() constant returns (uint) {
344         if (isPrivateSale()) return privateSaleSupplyLimit;
345         if (isPreSale()) return preSaleSupplyLimit;
346         if (isPublicSale()) return publicSaleSupplyLimit;
347 
348         return 0;
349     }
350 
351     function getStageSoldTokens() constant returns (uint) {
352         if (isPrivateSale()) return privateSaleSoldTokens;
353         if (isPreSale()) return preSaleSoldTokens;
354         if (isPublicSale()) return publicSaleSoldTokens;
355 
356         return 0;
357     }
358 
359     function addStageTokensSold(uint _amount) internal {
360         if (isPrivateSale()) privateSaleSoldTokens = add(privateSaleSoldTokens, _amount);
361         if (isPreSale())     preSaleSoldTokens = add(preSaleSoldTokens, _amount);
362         if (isPublicSale())  publicSaleSoldTokens = add(publicSaleSoldTokens, _amount);
363     }
364 
365     function addStageEtherRaised(uint _amount) internal {
366         if (isPrivateSale()) privateSaleEtherRaised = add(privateSaleEtherRaised, _amount);
367         if (isPreSale())     preSaleEtherRaised = add(preSaleEtherRaised, _amount);
368         if (isPublicSale())  publicSaleEtherRaised = add(publicSaleEtherRaised, _amount);
369     }
370 
371     function getStageEtherRaised() constant returns (uint) {
372         if (isPrivateSale()) return privateSaleEtherRaised;
373         if (isPreSale())     return preSaleEtherRaised;
374         if (isPublicSale())  return publicSaleEtherRaised;
375 
376         return 0;
377     }
378 
379     function getTokensSold() constant returns (uint) {
380         return
381             privateSaleSoldTokens +
382             preSaleSoldTokens +
383             publicSaleSoldTokens;
384     }
385 
386     function getEtherRaised() constant returns (uint) {
387         return
388             privateSaleEtherRaised +
389             preSaleEtherRaised +
390             publicSaleEtherRaised;
391     }
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
405 
406 
407     /// @dev Constructor of ICO. Requires address of icoManager,
408     /// @param _icoManager Address of ICO manager
409     function ExoTownIco(address _icoManager) {
410         require(_icoManager != 0x0);
411 
412         exotownToken = new ExoTownToken(this);
413         icoManager = _icoManager;
414     }
415 
416     /// Initialises addresses of founder, target wallets
417     /// @param _founder Address of Founder
418     /// @param _dev Address of Development wallet
419     /// @param _pr Address of Marketing wallet
420     /// @param _team Address of Team wallet
421     /// @param _buyback Address of wallet used for burning tokens
422     /// @param _mediator Address of Mediator wallet
423 
424     function init(
425         address _founder,
426         address _dev,
427         address _pr,
428         address _team,
429         address _buyback,
430         address _mediator
431     ) onlyManager {
432         require(currentState == State.Pause);
433         require(_founder != 0x0);
434         require(_dev != 0x0);
435         require(_pr != 0x0);
436         require(_team != 0x0);
437         require(_buyback != 0x0);
438         require(_mediator != 0x0);
439 
440         founderWallet = _founder;
441         developmentWallet = _dev;
442         marketingWallet = _pr;
443         teamWallet = _team;
444         buyBack = _buyback;
445         mediatorWallet = _mediator;
446 
447         currentState = State.Running;
448 
449         exotownToken.emitTokens(icoManager, 0);
450     }
451 
452     /// @dev Sets new state
453     /// @param _newState Value of new state
454     function setState(State _newState) public onlyManager {
455         currentState = _newState;
456     }
457 
458     /// @dev Sets new manager. Only manager can do it
459     /// @param _newIcoManager Address of new ICO manager
460     function setNewManager(address _newIcoManager) onlyManager {
461         require(_newIcoManager != 0x0);
462         icoManager = _newIcoManager;
463     }
464 
465     /// @dev Sets bounty owner. Only manager can do it
466     /// @param _bountyOwner Address of Bounty owner
467     function setBountyCampaign(address _bountyOwner) onlyManager {
468         require(_bountyOwner != 0x0);
469         bountyOwner = _bountyOwner;
470     }
471 
472     /// @dev Sets new Mediator wallet. Only manager can do it
473     /// @param _mediator Address of Mediator wallet
474     function setNewMediator(address _mediator) onlyManager {
475         require(_mediator != 0x0);
476         mediatorWallet = _mediator;
477     }
478 
479 
480     /// @dev Buy quantity of tokens depending on the amount of sent ethers.
481     /// @param _buyer Address of account which will receive tokens
482     function buyTokens(address _buyer) private {
483         require(_buyer != 0x0);
484         require(msg.value > 0);
485 
486         uint tokensToEmit = msg.value * getPrice();
487         uint volumeBonusPercent = volumeBonus(msg.value);
488 
489         if (volumeBonusPercent > 0) {
490             tokensToEmit = mul(tokensToEmit, 100 + volumeBonusPercent) / 100;
491         }
492 
493         uint stageSupplyLimit = getStageSupplyLimit();
494         uint stageSoldTokens = getStageSoldTokens();
495 
496         require(add(stageSoldTokens, tokensToEmit) <= stageSupplyLimit);
497 
498         exotownToken.emitTokens(_buyer, tokensToEmit);
499 
500         // Public statistics
501         addStageTokensSold(tokensToEmit);
502         addStageEtherRaised(msg.value);
503 
504         distributeEtherByStage();
505 
506     }
507 
508     /// @dev Buy tokens to specified wallet
509     function giftToken(address _to) public payable onIco {
510         buyTokens(_to);
511     }
512 
513     /// @dev Fall back function
514     function () payable onIco {
515         buyTokens(msg.sender);
516     }
517 
518     function distributeEtherByStage() private {
519         uint _balance = this.balance;
520         uint _balance_div = _balance / 100;
521 
522         uint _devAmount = _balance_div * 65;
523         uint _prAmount = _balance_div * 25;
524 
525         uint total = _devAmount + _prAmount;
526         if (total > 0) {
527             // Top up Mediator wallet with 1% of Development amount = 0.65% of contribution amount.
528             // It will cover tracking transaction fee (if any).
529 
530             uint _mediatorAmount = _devAmount / 100;
531             mediatorWallet.transfer(_mediatorAmount);
532 
533             developmentWallet.transfer(_devAmount - _mediatorAmount);
534             marketingWallet.transfer(_prAmount);
535             teamWallet.transfer(_balance - _devAmount - _prAmount);
536         }
537     }
538 
539 
540     /// @dev Partial withdraw. Only manager can do it
541     function withdrawEther(uint _value) onlyManager {
542         require(_value > 0);
543         require(_value * 1000000000000000 <= this.balance);
544         // send 1234 to get 1.234
545         icoManager.transfer(_value * 1000000000000000); // 10^15
546     }
547 
548     ///@dev Send tokens to bountyOwner depending on crowdsale results. Can be sent only after public sale.
549     function sendTokensToBountyOwner() onlyManager whenInitialized hasBountyCampaign afterPublicSale {
550         require(!sentTokensToBountyOwner);
551 
552         //Calculate bounty tokens depending on total tokens sold
553         uint bountyTokens = getTokensSold() / 40; // 2.5%
554 
555         exotownToken.emitTokens(bountyOwner, bountyTokens);
556 
557         sentTokensToBountyOwner = true;
558     }
559 
560     /// @dev Send tokens to founders. Can be sent only after May 20th, 2019.
561     function sendTokensToFounders() onlyManager whenInitialized afterPublicSale {
562         require(!sentTokensToFounders);
563         require(now >= foundersTokensUnlock);
564 
565         //Calculate founder reward depending on total tokens sold
566         uint founderReward = getTokensSold() / 10; // 10%
567 
568         exotownToken.emitTokens(founderWallet, founderReward);
569 
570         sentTokensToFounders = true;
571     }
572 
573     // Anyone could burn tokens by sending it to buyBack address and calling this function.
574     function burnTokens(uint _amount) afterPublicSale {
575         exotownToken.burnTokens(buyBack, _amount);
576     }
577 }