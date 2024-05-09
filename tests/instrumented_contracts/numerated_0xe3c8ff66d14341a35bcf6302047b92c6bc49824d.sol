1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 
36 
37 contract ERC20 {
38 
39     uint256 public totalSupply;
40 
41     function balanceOf(address _owner) public view returns (uint256 balance);
42 
43     function transfer(address _to, uint256 _value) public returns (bool success);
44 
45     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
46 
47     function approve(address _spender, uint256 _value) public returns (bool success);
48 
49     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
50 
51     event Transfer(address indexed _from, address indexed _to, uint256 _value);
52 
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 }
55 
56 
57 contract MultiOwnable {
58 
59     mapping (address => bool) public isOwner;
60     address[] public ownerHistory;
61 
62     event OwnerAddedEvent(address indexed _newOwner);
63     event OwnerRemovedEvent(address indexed _oldOwner);
64 
65     constructor() {
66         // Add default owner
67         address owner = msg.sender;
68         ownerHistory.push(owner);
69         isOwner[owner] = true;
70     }
71 
72     modifier onlyOwner() {
73         require(isOwner[msg.sender]);
74         _;
75     }
76 
77     function ownerHistoryCount() public view returns (uint) {
78         return ownerHistory.length;
79     }
80 
81     /** Add extra owner. */
82     function addOwner(address owner) onlyOwner public {
83         require(owner != address(0));
84         require(!isOwner[owner]);
85         ownerHistory.push(owner);
86         isOwner[owner] = true;
87         emit OwnerAddedEvent(owner);
88     }
89 
90     /** Remove extra owner. */
91     function removeOwner(address owner) onlyOwner public {
92         require(isOwner[owner]);
93         isOwner[owner] = false;
94         emit OwnerRemovedEvent(owner);
95     }
96 }
97 
98 
99 
100 
101 
102 
103 
104 
105 
106 contract Pausable is MultiOwnable {
107 
108     bool public paused;
109 
110     modifier ifNotPaused {
111         require(!paused);
112         _;
113     }
114 
115     modifier ifPaused {
116         require(paused);
117         _;
118     }
119 
120     // Called by the owner on emergency, triggers paused state
121     function pause() external onlyOwner ifNotPaused {
122         paused = true;
123     }
124 
125     // Called by the owner on end of emergency, returns to normal state
126     function resume() external onlyOwner ifPaused {
127         paused = false;
128     }
129 }
130 
131 
132 
133 
134 
135 
136 
137 
138 contract StandardToken is ERC20 {
139 
140     using SafeMath for uint;
141 
142     mapping(address => uint256) balances;
143 
144     mapping(address => mapping(address => uint256)) allowed;
145 
146     function balanceOf(address _owner) public view returns (uint256 balance) {
147         return balances[_owner];
148     }
149 
150     function transfer(address _to, uint256 _value) public returns (bool) {
151         require(_to != address(0));
152 
153         balances[msg.sender] = balances[msg.sender].sub(_value);
154         balances[_to] = balances[_to].add(_value);
155         emit Transfer(msg.sender, _to, _value);
156         return true;
157     }
158 
159     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
160     /// @param _from Address from where tokens are withdrawn.
161     /// @param _to Address to where tokens are sent.
162     /// @param _value Number of tokens to transfer.
163     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
164         require(_to != address(0));
165 
166         balances[_from] = balances[_from].sub(_value);
167         balances[_to] = balances[_to].add(_value);
168         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169         emit Transfer(_from, _to, _value);
170         return true;
171     }
172 
173     /// @dev Sets approved amount of tokens for spender. Returns success.
174     /// @param _spender Address of allowed account.
175     /// @param _value Number of approved tokens.
176     function approve(address _spender, uint256 _value) public returns (bool) {
177         allowed[msg.sender][_spender] = _value;
178         emit Approval(msg.sender, _spender, _value);
179         return true;
180     }
181 
182     /// @dev Returns number of allowed tokens for given address.
183     /// @param _owner Address of token owner.
184     /// @param _spender Address of token spender.
185     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
186         return allowed[_owner][_spender];
187     }
188 }
189 
190 
191 
192 contract CommonToken is StandardToken, MultiOwnable {
193 
194     string public constant name   = 'TMSY';
195     string public constant symbol = 'TMSY';
196     uint8 public constant decimals = 18;
197 
198     uint256 public saleLimit;   // 85% of tokens for sale.
199     uint256 public teamTokens;  // 7% of tokens goes to the team and will be locked for 1 year.
200     uint256 public partnersTokens;
201     uint256 public advisorsTokens;
202     uint256 public reservaTokens;
203 
204     // 7% of team tokens will be locked at this address for 1 year.
205     address public teamWallet; // Team address.
206     address public partnersWallet; // bountry address.
207     address public advisorsWallet; // Team address.
208     address public reservaWallet;
209 
210     uint public unlockTeamTokensTime = now + 365 days;
211 
212     // The main account that holds all tokens at the beginning and during tokensale.
213     address public seller; // Seller address (main holder of tokens)
214 
215     uint256 public tokensSold; // (e18) Number of tokens sold through all tiers or tokensales.
216     uint256 public totalSales; // Total number of sales (including external sales) made through all tiers or tokensales.
217 
218     // Lock the transfer functions during tokensales to prevent price speculations.
219     bool public locked = true;
220     mapping (address => bool) public walletsNotLocked;
221 
222     event SellEvent(address indexed _seller, address indexed _buyer, uint256 _value);
223     event ChangeSellerEvent(address indexed _oldSeller, address indexed _newSeller);
224     event Burn(address indexed _burner, uint256 _value);
225     event Unlock();
226 
227     constructor (
228         address _seller,
229         address _teamWallet,
230         address _partnersWallet,
231         address _advisorsWallet,
232         address _reservaWallet
233     ) MultiOwnable() public {
234 
235         totalSupply    = 600000000 ether;
236         saleLimit      = 390000000 ether;
237         teamTokens     = 120000000 ether;
238         partnersTokens =  30000000 ether;
239         reservaTokens  =  30000000 ether;
240         advisorsTokens =  30000000 ether;
241 
242         seller         = _seller;
243         teamWallet     = _teamWallet;
244         partnersWallet = _partnersWallet;
245         advisorsWallet = _advisorsWallet;
246         reservaWallet  = _reservaWallet;
247 
248         uint sellerTokens = totalSupply - teamTokens - partnersTokens - advisorsTokens - reservaTokens;
249         balances[seller] = sellerTokens;
250         emit Transfer(0x0, seller, sellerTokens);
251 
252         balances[teamWallet] = teamTokens;
253         emit Transfer(0x0, teamWallet, teamTokens);
254 
255         balances[partnersWallet] = partnersTokens;
256         emit Transfer(0x0, partnersWallet, partnersTokens);
257 
258         balances[reservaWallet] = reservaTokens;
259         emit Transfer(0x0, reservaWallet, reservaTokens);
260 
261         balances[advisorsWallet] = advisorsTokens;
262         emit Transfer(0x0, advisorsWallet, advisorsTokens);
263     }
264 
265     modifier ifUnlocked(address _from, address _to) {
266         //TODO: lockup excepto para direcciones concretas... pago de servicio, conversion fase 2
267         //TODO: Hacer funcion que añada direcciones de excepcion
268         //TODO: Para el team hacer las exceptions
269         require(walletsNotLocked[_to]);
270 
271         require(!locked);
272 
273         // If requested a transfer from the team wallet:
274         // TODO: fecha cada 6 meses 25% de desbloqueo
275         /*if (_from == teamWallet) {
276             require(now >= unlockTeamTokensTime);
277         }*/
278         // Advisors: 25% cada 3 meses
279 
280         // Reserva: 25% cada 6 meses
281 
282         // Partners: El bloqueo de todos... no pueden hacer nada
283 
284         _;
285     }
286 
287     /** Can be called once by super owner. */
288     function unlock() onlyOwner public {
289         require(locked);
290         locked = false;
291         emit Unlock();
292     }
293 
294     function walletLocked(address _wallet) onlyOwner public {
295       walletsNotLocked[_wallet] = false;
296     }
297 
298     function walletNotLocked(address _wallet) onlyOwner public {
299       walletsNotLocked[_wallet] = true;
300     }
301 
302     /**
303      * An address can become a new seller only in case it has no tokens.
304      * This is required to prevent stealing of tokens  from newSeller via
305      * 2 calls of this function.
306      */
307     function changeSeller(address newSeller) onlyOwner public returns (bool) {
308         require(newSeller != address(0));
309         require(seller != newSeller);
310 
311         // To prevent stealing of tokens from newSeller via 2 calls of changeSeller:
312         require(balances[newSeller] == 0);
313 
314         address oldSeller = seller;
315         uint256 unsoldTokens = balances[oldSeller];
316         balances[oldSeller] = 0;
317         balances[newSeller] = unsoldTokens;
318         emit Transfer(oldSeller, newSeller, unsoldTokens);
319 
320         seller = newSeller;
321         emit ChangeSellerEvent(oldSeller, newSeller);
322         return true;
323     }
324 
325     /**
326      * User-friendly alternative to sell() function.
327      */
328     function sellNoDecimals(address _to, uint256 _value) public returns (bool) {
329         return sell(_to, _value * 1e18);
330     }
331 
332     function sell(address _to, uint256 _value)  public returns (bool) {
333         // Check that we are not out of limit and still can sell tokens:
334         // Cambiar a hardcap en usd
335         //require(tokensSold.add(_value) <= saleLimit);
336         require(msg.sender == seller, "User not authorized");
337 
338         require(_to != address(0), "Not address authorized");
339         require(_value > 0, "Value is 0");
340 
341         require(_value <= balances[seller]);
342 
343         balances[seller] = balances[seller].sub(_value);
344         balances[_to] = balances[_to].add(_value);
345 
346         emit Transfer(seller, _to, _value);
347 
348         totalSales++;
349         tokensSold = tokensSold.add(_value);
350         emit SellEvent(seller, _to, _value);
351         return true;
352     }
353 
354     /**
355      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
356      */
357     function transfer(address _to, uint256 _value) ifUnlocked(msg.sender, _to) public returns (bool) {
358         return super.transfer(_to, _value);
359     }
360 
361     /**
362      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
363      */
364     function transferFrom(address _from, address _to, uint256 _value) ifUnlocked(_from, _to) public returns (bool) {
365         return super.transferFrom(_from, _to, _value);
366     }
367 
368     function burn(uint256 _value) public returns (bool) {
369         require(_value > 0, "Value is zero");
370 
371         balances[msg.sender] = balances[msg.sender].sub(_value);
372         totalSupply = totalSupply.sub(_value);
373         emit Transfer(msg.sender, 0x0, _value);
374         emit Burn(msg.sender, _value);
375         return true;
376     }
377 }
378 
379 
380 
381 contract CommonTokensale is MultiOwnable, Pausable {
382 
383     using SafeMath for uint;
384 
385     address public beneficiary;
386     uint public refundDeadlineTime;
387 
388     // Balances of beneficiaries:
389     uint public balance;
390     uint public balanceComision;
391     uint public balanceComisionHold;
392     uint public balanceComisionDone;
393 
394     // Token contract reference.
395     CommonToken public token;
396 
397     uint public minPaymentUSD = 250;
398 
399     uint public minCapWei;
400     uint public maxCapWei;
401 
402     uint public minCapUSD;
403     uint public maxCapUSD;
404 
405     uint public startTime;
406     uint public endTime;
407 
408     // Stats for current tokensale:
409 
410     uint public totalTokensSold;  // Total amount of tokens sold during this tokensale.
411     uint public totalWeiReceived; // Total amount of wei received during this tokensale.
412     uint public totalUSDReceived; // Total amount of wei received during this tokensale.
413 
414     // This mapping stores info on how many ETH (wei) have been sent to this tokensale from specific address.
415     mapping (address => uint256) public buyerToSentWei;
416     mapping (address => uint256) public sponsorToComisionDone;
417     mapping (address => uint256) public sponsorToComision;
418     mapping (address => uint256) public sponsorToComisionHold;
419     mapping (address => uint256) public sponsorToComisionFromInversor;
420     mapping (address => bool) public kicInversor;
421     mapping (address => bool) public validateKYC;
422     mapping (address => bool) public comisionInTokens;
423 
424     address[] public sponsorToComisionList;
425 
426     // TODO: realizar opcion de que el inversor quiera cobrar en ETH o TMSY
427 
428     event ReceiveEthEvent(address indexed _buyer, uint256 _amountWei);
429     event NewInverstEvent(address indexed _child, address indexed _sponsor);
430     event ComisionEvent(address indexed _sponsor, address indexed _child, uint256 _value, uint256 _comision);
431     event ComisionPayEvent(address indexed _sponsor, uint256 _value, uint256 _comision);
432     event ComisionInversorInTokensEvent(address indexed _sponsor, bool status);
433     event ChangeEndTimeEvent(address _sender, uint endTime, uint _date);
434     event verifyKycEvent(address _sender, uint _date, bool _status);
435     event payComisionSponsorTMSY(address _sponsor, uint _date, uint _value);
436     event payComisionSponsorETH(address _sponsor, uint _date, uint _value);
437     event withdrawEvent(address _sender, address _to, uint value, uint _date);
438     event conversionToUSDEvent(uint _value, uint rateUsd, uint usds);
439     event newRatioEvent(uint _value, uint date);
440     event conversionETHToTMSYEvent(address _buyer, uint value, uint tokensE18SinBono, uint tokensE18Bono);
441     event createContractEvent(address _token, address _beneficiary, uint _startTime, uint _endTime);
442     // ratio USD-ETH
443     uint public rateUSDETH;
444 
445     bool public isSoftCapComplete = false;
446 
447     // Array para almacenar los inversores
448     mapping(address => bool) public inversors;
449     address[] public inversorsList;
450 
451     // Array para almacenar los sponsors para hacer reparto de comisiones
452     mapping(address => address) public inversorToSponsor;
453 
454     constructor (
455         address _token,
456         address _beneficiary,
457         uint _startTime,
458         uint _endTime
459     ) MultiOwnable() public {
460 
461         require(_token != address(0));
462         token = CommonToken(_token);
463 
464         emit createContractEvent(_token, _beneficiary, _startTime, _endTime);
465 
466         beneficiary = _beneficiary;
467 
468         startTime = now;
469         endTime   = 1544313600;
470 
471 
472         minCapUSD = 400000;
473         maxCapUSD = 4000000;
474     }
475 
476     function setRatio(uint _rate) onlyOwner public returns (bool) {
477       rateUSDETH = _rate;
478       emit newRatioEvent(rateUSDETH, now);
479       return true;
480     }
481 
482     //TODO: validateKYC
483     //En el momento que validan el KYC se les entregan los tokens
484 
485     function burn(uint _value) onlyOwner public returns (bool) {
486       return token.burn(_value);
487     }
488 
489     function newInversor(address _newInversor, address _sponsor) onlyOwner public returns (bool) {
490       inversors[_newInversor] = true;
491       inversorsList.push(_newInversor);
492       inversorToSponsor[_newInversor] = _sponsor;
493       emit NewInverstEvent(_newInversor,_sponsor);
494       return inversors[_newInversor];
495     }
496     function setComisionInvesorInTokens(address _inversor, bool _inTokens) onlyOwner public returns (bool) {
497       comisionInTokens[_inversor] = _inTokens;
498       emit ComisionInversorInTokensEvent(_inversor, _inTokens);
499       return true;
500     }
501     function setComisionInTokens() public returns (bool) {
502       comisionInTokens[msg.sender] = true;
503       emit ComisionInversorInTokensEvent(msg.sender, true);
504       return true;
505     }
506     function setComisionInETH() public returns (bool) {
507       comisionInTokens[msg.sender] = false;
508       emit ComisionInversorInTokensEvent(msg.sender, false);
509 
510       return true;
511     }
512     function inversorIsKyc(address who) public returns (bool) {
513       return validateKYC[who];
514     }
515     function unVerifyKyc(address _inversor) onlyOwner public returns (bool) {
516       require(!isSoftCapComplete);
517 
518       validateKYC[_inversor] = false;
519 
520       address sponsor = inversorToSponsor[_inversor];
521       uint balanceHold = sponsorToComisionFromInversor[_inversor];
522 
523       //Actualizamos contadores globales
524       balanceComision = balanceComision.sub(balanceHold);
525       balanceComisionHold = balanceComisionHold.add(balanceHold);
526 
527       //Actualizamos contadores del sponsor
528       sponsorToComision[sponsor] = sponsorToComision[sponsor].sub(balanceHold);
529       sponsorToComisionHold[sponsor] = sponsorToComisionHold[sponsor].add(balanceHold);
530 
531       //Actualizamos contador comision por inversor
532     //  sponsorToComisionFromInversor[_inversor] = sponsorToComisionFromInversor[_inversor].sub(balanceHold);
533       emit verifyKycEvent(_inversor, now, false);
534     }
535     function verifyKyc(address _inversor) onlyOwner public returns (bool) {
536       validateKYC[_inversor] = true;
537 
538       address sponsor = inversorToSponsor[_inversor];
539       uint balanceHold = sponsorToComisionFromInversor[_inversor];
540 
541       //Actualizamos contadores globales
542       balanceComision = balanceComision.add(balanceHold);
543       balanceComisionHold = balanceComisionHold.sub(balanceHold);
544 
545       //Actualizamos contadores del sponsor
546       sponsorToComision[sponsor] = sponsorToComision[sponsor].add(balanceHold);
547       sponsorToComisionHold[sponsor] = sponsorToComisionHold[sponsor].sub(balanceHold);
548 
549       //Actualizamos contador comision por inversor
550       //sponsorToComisionFromInversor[_inversor] = sponsorToComisionFromInversor[_inversor].sub(balanceHold);
551       emit verifyKycEvent(_inversor, now, true);
552       //Enviamos comisiones en caso de tener
553       /*uint256 value = sponsorToComision[_inversor];
554       sponsorToComision[_inversor] = sponsorToComision[_inversor].sub(value);
555       _inversor.transfer(value);*/
556       return true;
557     }
558     function buyerToSentWeiOf(address who) public view returns (uint256) {
559       return buyerToSentWei[who];
560     }
561     function balanceOf(address who) public view returns (uint256) {
562       return token.balanceOf(who);
563     }
564     function balanceOfComision(address who)  public view returns (uint256) {
565       return sponsorToComision[who];
566     }
567     function balanceOfComisionHold(address who)  public view returns (uint256) {
568       return sponsorToComisionHold[who];
569     }
570     function balanceOfComisionDone(address who)  public view returns (uint256) {
571       return sponsorToComisionDone[who];
572     }
573 
574     function isInversor(address who) public view returns (bool) {
575       return inversors[who];
576     }
577     function payComisionSponsor(address _inversor) private {
578       //comprobamos que el inversor quiera cobrar en tokens...
579       //si es así le pagamos directo y añadimos los tokens a su cuenta
580       if(comisionInTokens[_inversor]) {
581         uint256 val = 0;
582         uint256 valueHold = sponsorToComisionHold[_inversor];
583         uint256 valueReady = sponsorToComision[_inversor];
584 
585         val = valueReady.add(valueHold);
586         //comprobamos que tenga comisiones a cobrar
587         if(val > 0) {
588           require(balanceComision >= valueReady);
589           require(balanceComisionHold >= valueHold);
590           uint256 comisionTokens = weiToTokens(val);
591 
592           sponsorToComision[_inversor] = 0;
593           sponsorToComisionHold[_inversor] = 0;
594 
595           balanceComision = balanceComision.sub(valueReady);
596           balanceComisionDone = balanceComisionDone.add(val);
597           balanceComisionHold = balanceComisionHold.sub(valueHold);
598 
599           balance = balance.add(val);
600 
601           token.sell(_inversor, comisionTokens);
602           emit payComisionSponsorTMSY(_inversor, now, val); //TYPO TMSY
603         }
604       } else {
605         uint256 value = sponsorToComision[_inversor];
606 
607         //comprobamos que tenga comisiones a cobrar
608         if(value > 0) {
609           require(balanceComision >= value);
610 
611           //Si lo quiere en ETH
612           //comprobamos que hayamos alcanzado el softCap
613           assert(isSoftCapComplete);
614 
615           //Comprobamos que el KYC esté validado
616           assert(validateKYC[_inversor]);
617 
618           sponsorToComision[_inversor] = sponsorToComision[_inversor].sub(value);
619           balanceComision = balanceComision.sub(value);
620           balanceComisionDone = balanceComisionDone.add(value);
621 
622           _inversor.transfer(value);
623           emit payComisionSponsorETH(_inversor, now, value); //TYPO TMSY
624 
625         }
626 
627       }
628     }
629     function payComision() public {
630       address _inversor = msg.sender;
631       payComisionSponsor(_inversor);
632     }
633     //Enviamos las comisiones que se han congelado o por no tener kyc o por ser en softcap
634     /*function sendHoldComisions() onlyOwner public returns (bool) {
635       //repartimos todas las comisiones congeladas hasta ahora
636       uint arrayLength = sponsorToComisionList.length;
637       for (uint i=0; i<arrayLength; i++) {
638         // do something
639         address sponsor = sponsorToComisionList[i];
640 
641         if(validateKYC[sponsor]) {
642           uint256 value = sponsorToComision[sponsor];
643           sponsorToComision[sponsor] = sponsorToComision[sponsor].sub(value);
644           sponsor.transfer(value);
645         }
646       }
647       return true;
648     }*/
649     function isSoftCapCompleted() public view returns (bool) {
650       return isSoftCapComplete;
651     }
652     function softCapCompleted() public {
653       uint totalBalanceUSD = weiToUSD(balance.div(1e18));
654       if(totalBalanceUSD >= minCapUSD) isSoftCapComplete = true;
655     }
656 
657     function balanceComisionOf(address who) public view returns (uint256) {
658       return sponsorToComision[who];
659     }
660     function getNow() public returns (uint) {
661       return now;
662     }
663     /** The fallback function corresponds to a donation in ETH. */
664     function() public payable {
665         //sellTokensForEth(msg.sender, msg.value);
666 
667         uint256 _amountWei = msg.value;
668         address _buyer = msg.sender;
669         uint valueUSD = weiToUSD(_amountWei);
670 
671         require(now <= endTime, 'endtime');
672         require(inversors[_buyer] != false, 'No invest');
673         require(valueUSD >= minPaymentUSD, 'Min in USD not allowed');
674         //require(totalUSDReceived.add(valueUSD) <= maxCapUSD);
675         emit ReceiveEthEvent(_buyer, _amountWei);
676 
677         uint tokensE18SinBono = weiToTokens(msg.value);
678         uint tokensE18Bono = weiToTokensBono(msg.value);
679         emit conversionETHToTMSYEvent(_buyer, msg.value, tokensE18SinBono, tokensE18Bono);
680 
681         uint tokensE18 = tokensE18SinBono.add(tokensE18Bono);
682 
683         //Ejecutamos la transferencia de tokens y paramos si ha fallado
684         require(token.sell(_buyer, tokensE18SinBono), "Falla la venta");
685         if(tokensE18Bono > 0)
686           assert(token.sell(_buyer, tokensE18Bono));
687 
688         //repartimos al sponsor su parte 10%
689         uint256 _amountSponsor = (_amountWei * 10) / 100;
690         uint256 _amountBeneficiary = (_amountWei * 90) / 100;
691 
692         totalTokensSold = totalTokensSold.add(tokensE18);
693         totalWeiReceived = totalWeiReceived.add(_amountWei);
694         buyerToSentWei[_buyer] = buyerToSentWei[_buyer].add(_amountWei);
695 
696         //por cada compra miramos cual es la cantidad actual de USD... si hemos llegado al softcap lo activamos
697         if(!isSoftCapComplete) {
698           uint256 totalBalanceUSD = weiToUSD(balance);
699           if(totalBalanceUSD >= minCapUSD) {
700             softCapCompleted();
701           }
702         }
703         address sponsor = inversorToSponsor[_buyer];
704         sponsorToComisionList.push(sponsor);
705 
706         if(validateKYC[_buyer]) {
707           //Añadimos el saldo al sponsor
708           balanceComision = balanceComision.add(_amountSponsor);
709           sponsorToComision[sponsor] = sponsorToComision[sponsor].add(_amountSponsor);
710 
711         } else {
712           //Añadimos el saldo al sponsor
713           balanceComisionHold = balanceComisionHold.add(_amountSponsor);
714           sponsorToComisionHold[sponsor] = sponsorToComisionHold[sponsor].add(_amountSponsor);
715           sponsorToComisionFromInversor[_buyer] = sponsorToComisionFromInversor[_buyer].add(_amountSponsor);
716         }
717 
718 
719         payComisionSponsor(sponsor);
720 
721 
722         balance = balance.add(_amountBeneficiary);
723     }
724 
725     function weiToUSD(uint _amountWei) public view returns (uint256) {
726       uint256 ethers = _amountWei;
727 
728       uint256 valueUSD = rateUSDETH.mul(_amountWei);
729 
730       emit conversionToUSDEvent(_amountWei, rateUSDETH, valueUSD.div(1e18));
731       return valueUSD.div(1e18);
732     }
733 
734     function weiToTokensBono(uint _amountWei) public view returns (uint256) {
735       uint bono = 0;
736 
737       uint256 valueUSD = weiToUSD(_amountWei);
738 
739       // Calculamos bono
740       //Tablas de bonos
741       if(valueUSD >= uint(500 * 10**18))   bono = 10;
742       if(valueUSD >= uint(1000 * 10**18))   bono = 20;
743       if(valueUSD >= uint(2500 * 10**18))   bono = 30;
744       if(valueUSD >= uint(5000 * 10**18))   bono = 40;
745       if(valueUSD >= uint(10000 * 10**18))   bono = 50;
746 
747 
748       uint256 bonoUsd = valueUSD.mul(bono).div(100);
749       uint256 tokens = bonoUsd.mul(tokensPerUSD());
750 
751       return tokens;
752     }
753     /** Calc how much tokens you can buy at current time. */
754     function weiToTokens(uint _amountWei) public view returns (uint256) {
755 
756         uint256 valueUSD = weiToUSD(_amountWei);
757 
758         uint256 tokens = valueUSD.mul(tokensPerUSD());
759 
760         return tokens;
761     }
762 
763     function tokensPerUSD() public pure returns (uint256) {
764         return 65; // Default token price with no bonuses.
765     }
766 
767     function canWithdraw() public view returns (bool);
768 
769     function withdraw(address _to, uint value) public returns (uint) {
770         require(canWithdraw(), 'No es posible retirar');
771         require(msg.sender == beneficiary, 'Sólo puede solicitar el beneficiario los fondos');
772         require(balance > 0, 'Sin fondos');
773         require(balance >= value, 'No hay suficientes fondos');
774         require(_to.call.value(value).gas(1)(), 'No se que es');
775 
776         balance = balance.sub(value);
777         emit withdrawEvent(msg.sender, _to, value,now);
778         return balance;
779     }
780 
781     //Manage timelimit. For exception
782     function changeEndTime(uint _date) onlyOwner public returns (bool) {
783      // require(endTime < _date);
784       endTime = _date;
785       refundDeadlineTime = endTime + 3 * 30 days;
786       emit ChangeEndTimeEvent(msg.sender,endTime,_date);
787       return true;
788     }
789 }
790 
791 
792 contract Presale is CommonTokensale {
793 
794     // In case min (soft) cap is not reached, token buyers will be able to
795     // refund their contributions during 3 months after presale is finished.
796 
797     // Total amount of wei refunded if min (soft) cap is not reached.
798     uint public totalWeiRefunded;
799 
800     event RefundEthEvent(address indexed _buyer, uint256 _amountWei);
801 
802     constructor(
803         address _token,
804         address _beneficiary,
805         uint _startTime,
806         uint _endTime
807     ) CommonTokensale(
808         _token,
809         _beneficiary,
810         _startTime,
811         _endTime
812     ) public {
813       refundDeadlineTime = _endTime + 3 * 30 days;
814     }
815 
816     /**
817      * During presale it will be possible to withdraw only in two cases:
818      * min cap reached OR refund period expired.
819      */
820     function canWithdraw() public view returns (bool) {
821         return isSoftCapComplete;
822     }
823 
824     /**
825      * It will be possible to refund only if min (soft) cap is not reached and
826      * refund requested during 3 months after presale finished.
827      */
828     function canRefund() public view returns (bool) {
829         return !isSoftCapComplete && endTime < now && now <= refundDeadlineTime;
830     }
831 
832     function refund() public {
833         require(canRefund());
834 
835         address buyer = msg.sender;
836         uint amount = buyerToSentWei[buyer];
837         require(amount > 0);
838 
839         // Redistribute left balance between three beneficiaries.
840         uint newBal = balance.sub(amount);
841         balance = newBal;
842 
843         emit RefundEthEvent(buyer, amount);
844         buyerToSentWei[buyer] = 0;
845         totalWeiRefunded = totalWeiRefunded.add(amount);
846         buyer.transfer(amount);
847     }
848 }