1 pragma solidity ^0.4.23;
2 
3 
4 contract ERC20Basic {
5     function totalSupply() public view returns (uint256);
6     function balanceOf(address who) public view returns (uint256);
7     function transfer(address to, uint256 value) public returns (bool);
8     event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic {
12     function allowance(address owner, address spender)
13         public view returns (uint256);
14 
15     function transferFrom(address from, address to, uint256 value)
16         public returns (bool);
17 
18     function approve(address spender, uint256 value) public returns (bool);
19     event Approval(
20     address indexed owner,
21     address indexed spender,
22     uint256 value
23     );
24 }
25 
26 
27 
28 library SafeMath {
29 
30     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
31         if (a == 0) {
32             return 0;
33         }
34         c = a * b;
35         assert(c / a == b);
36         return c;
37     }
38 
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40         return a / b;
41     }
42 
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         assert(b <= a);
45         return a - b;
46     }
47 
48     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49         c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 
56 
57 contract BasicToken is ERC20Basic {
58     using SafeMath for uint256;
59 
60     mapping(address => uint256) balances;
61 
62     uint256 totalSupply_;
63 
64     function totalSupply() public view returns (uint256) {
65         return totalSupply_;
66     }
67 
68     function transfer(address _to, uint256 _value) public returns (bool) {
69         require(_to != address(0));
70         require(_value <= balances[msg.sender]);
71 
72         balances[msg.sender] = balances[msg.sender].sub(_value);
73         balances[_to] = balances[_to].add(_value);
74         emit Transfer(msg.sender, _to, _value);
75         return true;
76     }
77   
78     function balanceOf(address _owner) public view returns (uint256) {
79         return balances[_owner];
80     }
81 
82 }
83 
84 contract BurnableToken is BasicToken {
85 
86     event Burn(address indexed burner, uint256 value);
87 
88   /**
89    * @dev Burns a specific amount of tokens.
90    * @param _value The amount of token to be burned.
91    */
92     function burn(uint256 _value) public {
93         _burn(msg.sender, _value);
94     }
95 
96     function _burn(address _who, uint256 _value) internal {
97         require(_value <= balances[_who]);
98 
99         balances[_who] = balances[_who].sub(_value);
100         totalSupply_ = totalSupply_.sub(_value);
101         emit Burn(_who, _value);
102         emit Transfer(_who, address(0), _value);
103     }
104 }
105 
106 contract StandardToken is ERC20, BasicToken {
107 
108     mapping (address => mapping (address => uint256)) internal allowed;
109 
110     function transferFrom(
111         address _from,
112         address _to,
113         uint256 _value
114     )
115         public
116         returns (bool)
117     {
118         require(_to != address(0));
119         require(_value <= balances[_from]);
120         require(_value <= allowed[_from][msg.sender]);
121 
122         balances[_from] = balances[_from].sub(_value);
123         balances[_to] = balances[_to].add(_value);
124         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125         emit Transfer(_from, _to, _value);
126         return true;
127     }
128 
129 
130     function approve(address _spender, uint256 _value) public returns (bool) {
131         allowed[msg.sender][_spender] = _value;
132         emit Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 
136 
137     function allowance(
138         address _owner,
139         address _spender
140     )
141     public
142     view
143     returns (uint256)
144     {
145         return allowed[_owner][_spender];
146     }
147 
148 
149     function increaseApproval(
150         address _spender,
151         uint _addedValue
152     )
153     public
154     returns (bool)
155     {
156         allowed[msg.sender][_spender] = (
157         allowed[msg.sender][_spender].add(_addedValue));
158         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159         return true;
160     }
161 
162 
163     function decreaseApproval(
164         address _spender,
165         uint _subtractedValue
166     )
167         public
168         returns (bool)
169     {
170         uint oldValue = allowed[msg.sender][_spender];
171         if (_subtractedValue > oldValue) {
172             allowed[msg.sender][_spender] = 0;
173         } else {
174             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
175         }
176         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177         return true;
178     }
179 
180 }
181 
182 
183 contract NRXtoken is StandardToken, BurnableToken {
184     string public constant name = "Neironix";
185     string public constant symbol = "NRX";
186     uint32 public constant decimals = 18;
187     uint256 public INITIAL_SUPPLY = 140000000 * 1 ether;
188     address public CrowdsaleAddress;
189     bool public lockTransfers = false;
190 
191     event AcceptToken(address indexed from, uint256 value);
192 
193     constructor(address _CrowdsaleAddress) public {
194         CrowdsaleAddress = _CrowdsaleAddress;
195         totalSupply_ = INITIAL_SUPPLY;
196         balances[msg.sender] = INITIAL_SUPPLY;      
197     }
198   
199     modifier onlyOwner() {
200         // only Crowdsale contract
201         require(msg.sender == CrowdsaleAddress);
202         _;
203     }
204 
205      // Override
206     function transfer(address _to, uint256 _value) public returns(bool){
207         if (msg.sender != CrowdsaleAddress){
208             require(!lockTransfers, "Transfers are prohibited in Crowdsale period");
209         }
210         return super.transfer(_to,_value);
211     }
212 
213      // Override
214     function transferFrom(address _from, address _to, uint256 _value) public returns(bool){
215         if (msg.sender != CrowdsaleAddress){
216             require(!lockTransfers, "Transfers are prohibited in Crowdsale period");
217         }
218         return super.transferFrom(_from,_to,_value);
219     }
220 
221     /**
222      * @dev function accept tokens from users as a payment for servises and burn their
223      * @dev can run only from crowdsale contract
224     */
225     function acceptTokens(address _from, uint256 _value) public onlyOwner returns (bool){
226         require (balances[_from] >= _value);
227         balances[_from] = balances[_from].sub(_value);
228         totalSupply_ = totalSupply_.sub(_value);
229         emit AcceptToken(_from, _value);
230         return true;
231     }
232 
233     /**
234      * @dev function transfer tokens from special address to users
235      * @dev can run only from crowdsale contract
236     */
237     function transferTokensFromSpecialAddress(address _from, address _to, uint256 _value) public onlyOwner returns (bool){
238         require (balances[_from] >= _value);
239         balances[_from] = balances[_from].sub(_value);
240         balances[_to] = balances[_to].add(_value);
241         emit Transfer(_from, _to, _value);
242         return true;
243     }
244 
245 
246     function lockTransfer(bool _lock) public onlyOwner {
247         lockTransfers = _lock;
248     }
249 
250 
251 
252     function() external payable {
253         revert("The token contract don`t receive ether");
254     }  
255 }
256 
257 
258 contract Ownable {
259     address public owner;
260     address candidate;
261 
262     constructor() public {
263         owner = msg.sender;
264     }
265 
266     modifier onlyOwner() {
267         require(msg.sender == owner);
268         _;
269     }
270 
271 
272     function transferOwnership(address newOwner) public onlyOwner {
273         require(newOwner != address(0));
274         candidate = newOwner;
275     }
276 
277     function confirmOwnership() public {
278         require(candidate == msg.sender);
279         owner = candidate;
280         delete candidate;
281     }
282 
283 }
284 
285 contract ProjectFundAddress {
286     //Address where stored project fund tokens- 7%
287     function() external payable {
288         // The contract don`t receive ether
289         revert();
290     } 
291 }
292 
293 
294 contract TeamAddress {
295     //Address where stored command tokens- 10%
296     //Withdraw tokens allowed only after 0.5 year
297     function() external payable {
298         // The contract don`t receive ether
299         revert();
300     } 
301 }
302 
303 contract PartnersAddress {
304     //Address where stored partners tokens- 10%
305     //Withdraw tokens allowed only after 0.5 year
306     function() external payable {
307         // The contract don`t receive ether
308         revert();
309     } 
310 }
311 
312 contract AdvisorsAddress {
313     //Address where stored advisors tokens- 3,5%
314     //Withdraw tokens allowed only after 0.5 year
315     function() external payable {
316         // The contract don`t receive ether
317         revert();
318     } 
319 }
320 
321 contract BountyAddress {
322     //Address where stored bounty tokens- 3%
323     function() external payable {
324         // The contract don`t receive ether
325         revert();
326     } 
327 }
328 
329 /**
330  * @title Crowdsale contract and burnable token ERC20
331  */
332 contract Crowdsale is Ownable {
333     using SafeMath for uint; 
334     event LogStateSwitch(State newState);
335     event Withdraw(address indexed from, address indexed to, uint256 amount);
336 
337     address myAddress = this;
338 
339     uint64 crowdSaleStartTime = 0;
340     uint64 crowdSaleEndTime = 0;
341 
342     uint public  tokenRate = 942;  //tokens for 1 ether
343 
344     address public marketingProfitAddress = 0x0;
345     address public neironixProfitAddress = 0x0;
346     address public lawSupportProfitAddress = 0x0;
347     address public hostingProfitAddress = 0x0;
348     address public teamProfitAddress = 0x0;
349     address public contractorsProfitAddress = 0x0;
350     address public saasApiProfitAddress = 0x0;
351 
352     
353     NRXtoken public token = new NRXtoken(myAddress);
354 
355     /**
356     * @dev New address for hold tokens
357     */
358     ProjectFundAddress public holdAddress1 = new ProjectFundAddress();
359     TeamAddress public holdAddress2 = new TeamAddress();
360     PartnersAddress public holdAddress3 = new PartnersAddress();
361     AdvisorsAddress public holdAddress4 = new AdvisorsAddress();
362     BountyAddress public holdAddress5 = new BountyAddress();
363 
364     /**
365      * @dev Create state of contract 
366      */
367     enum State { 
368         Init,    
369         CrowdSale,
370         WorkTime
371     }
372         
373     State public currentState = State.Init;
374 
375     modifier onlyInState(State state){ 
376         require(state==currentState); 
377         _; 
378     }
379 
380     constructor() public {
381         uint256 TotalTokens = token.INITIAL_SUPPLY().div(1 ether);
382         // distribute tokens
383         //Transer tokens to project fund address.  (7%)
384         _transferTokens(address(holdAddress1), TotalTokens.mul(7).div(100));
385         // Transer tokens to team address.  (10%)
386         _transferTokens(address(holdAddress2), TotalTokens.div(10));
387         // Transer tokens to partners address. (10%)
388         _transferTokens(address(holdAddress3), TotalTokens.div(10));
389         // Transer tokens to advisors address. (3.5%)
390         _transferTokens(address(holdAddress4), TotalTokens.mul(35).div(1000));
391         // Transer tokens to bounty address. (3%)
392         _transferTokens(address(holdAddress5), TotalTokens.mul(3).div(100));
393         
394         /**
395          * @dev Create periods
396          * TokenSale between 01/09/2018 and 30/11/2018
397          * Unix timestamp 01/09/2018 - 1535760000
398         */
399 
400 
401         crowdSaleStartTime = 1535760000;
402         crowdSaleEndTime = crowdSaleStartTime + 91 days;
403         
404         
405     }
406     
407     function setRate(uint _newRate) public onlyOwner {
408         /**
409          * @dev Enter the amount of tokens per 1 ether
410          */
411         tokenRate = _newRate;
412     }
413 
414     function setMarketingProfitAddress(address _addr) public onlyOwner onlyInState(State.Init){
415         require (_addr != address(0));
416         marketingProfitAddress = _addr;
417     }
418     
419     function setNeironixProfitAddress(address _addr) public onlyOwner onlyInState(State.Init){
420         require (_addr != address(0));
421         neironixProfitAddress = _addr;
422     }
423 
424     function setLawSupportProfitAddress(address _addr) public onlyOwner onlyInState(State.Init){
425         require (_addr != address(0));
426         lawSupportProfitAddress = _addr;
427     }
428  
429     function setHostingProfitAddress(address _addr) public onlyOwner onlyInState(State.Init){
430         require (_addr != address(0));
431         hostingProfitAddress = _addr;
432     }
433  
434     function setTeamProfitAddress(address _addr) public onlyOwner onlyInState(State.Init){
435         require (_addr != address(0));
436         teamProfitAddress = _addr;
437     }
438     
439     function setContractorsProfitAddress(address _addr) public onlyOwner onlyInState(State.Init){
440         require (_addr != address(0));
441         contractorsProfitAddress = _addr;
442     }
443 
444     function setSaasApiProfitAddress(address _addr) public onlyOwner onlyInState(State.Init){
445         require (_addr != address(0));
446         saasApiProfitAddress = _addr;
447     }
448     
449     function acceptTokensFromUsers(address _investor, uint256 _value) public onlyOwner{
450         token.acceptTokens(_investor, _value); 
451     }
452 
453     function transferTokensFromProjectFundAddress(address _investor, uint256 _value) public onlyOwner returns(bool){
454         /**
455          * @dev the function transfer tokens from ProjectFundAddress  to investor
456          * not hold
457          * the sum is entered in whole tokens (1 = 1 token)
458          */
459 
460         uint256 value = _value;
461         require (value >= 1);
462         value = value.mul(1 ether);
463         token.transferTokensFromSpecialAddress(address(holdAddress1), _investor, value); 
464         return true;
465     } 
466 
467     function transferTokensFromTeamAddress(address _investor, uint256 _value) public onlyOwner returns(bool){
468         /**
469          * @dev the function tranfer tokens from TeamAddress to investor
470          * only after 182 days
471          * the sum is entered in whole tokens (1 = 1 token)
472          */
473         uint256 value = _value;
474         require (value >= 1);
475         value = value.mul(1 ether);
476         require (now >= crowdSaleEndTime + 182 days, "only after 182 days");
477         token.transferTokensFromSpecialAddress(address(holdAddress2), _investor, value); 
478         return true;
479     } 
480     
481     function transferTokensFromPartnersAddress(address _investor, uint256 _value) public onlyOwner returns(bool){
482         /**
483          * @dev the function transfer tokens from PartnersAddress to investor
484          * only after 182 days
485          * the sum is entered in whole tokens (1 = 1 token)
486          */
487         uint256 value = _value;
488         require (value >= 1);
489         value = value.mul(1 ether);
490         require (now >= crowdSaleEndTime + 91 days, "only after 91 days");
491         token.transferTokensFromSpecialAddress(address(holdAddress3), _investor, value); 
492         return true;
493     } 
494     
495     function transferTokensFromAdvisorsAddress(address _investor, uint256 _value) public onlyOwner returns(bool){
496         /**
497          * @dev the function transfer tokens from AdvisorsAddress to investor
498          * only after 182 days
499          * the sum is entered in whole tokens (1 = 1 token)
500          */
501         uint256 value = _value;
502         require (value >= 1);
503         value = value.mul(1 ether);
504         require (now >= crowdSaleEndTime + 91 days, "only after 91 days");
505         token.transferTokensFromSpecialAddress(address(holdAddress4), _investor, value); 
506         return true;
507     }     
508     
509     function transferTokensFromBountyAddress(address _investor, uint256 _value) public onlyOwner returns(bool){
510         /**
511          * @dev the function transfer tokens from BountyAddress to investor
512          * not hold
513          * the sum is entered in whole tokens (1 = 1 token)
514          */
515         uint256 value = _value;
516         require (value >= 1);
517         value = value.mul(1 ether);
518         token.transferTokensFromSpecialAddress(address(holdAddress5), _investor, value); 
519         return true;
520     }     
521 
522 
523     function _transferTokens(address _newInvestor, uint256 _value) internal {
524         require (_newInvestor != address(0));
525         require (_value >= 1);
526         uint256 value = _value;
527         value = value.mul(1 ether);
528         token.transfer(_newInvestor, value);
529     }  
530 
531     function transferTokens(address _newInvestor, uint256 _value) public onlyOwner {
532         /**
533          * @dev the function transfer tokens to new investor
534          * the sum is entered in whole tokens (1 = 1 token)
535          */
536         _transferTokens(_newInvestor, _value);
537     }
538     
539     function setState(State _state) internal {
540         currentState = _state;
541         emit LogStateSwitch(_state);
542     }
543 
544     function startSale() public onlyOwner onlyInState(State.Init) {
545         require(uint64(now) > crowdSaleStartTime, "Sale time is not coming.");
546         require(neironixProfitAddress != address(0));
547         setState(State.CrowdSale);
548         token.lockTransfer(true);
549     }
550 
551 
552     function finishCrowdSale() public onlyOwner onlyInState(State.CrowdSale) {
553         /**
554          * @dev the function is burn all unsolded tokens and unblock external token transfer
555          */
556         require (now > crowdSaleEndTime, "CrowdSale stage is not over");
557         setState(State.WorkTime);
558         token.lockTransfer(false);
559         // burn all unsolded tokens
560         token.burn(token.balanceOf(myAddress));
561     }
562 
563 
564     function blockExternalTransfer() public onlyOwner onlyInState (State.WorkTime){
565         /**
566          * @dev Blocking all external token transfer
567          */
568         require (token.lockTransfers() == false);
569         token.lockTransfer(true);
570     }
571 
572     function unBlockExternalTransfer() public onlyOwner onlyInState (State.WorkTime){
573         /**
574          * @dev Unblocking all external token transfer
575          */
576         require (token.lockTransfers() == true);
577         token.lockTransfer(false);
578     }
579 
580 
581     function setBonus () public view returns(uint256) {
582         /**
583          * @dev calculation bonus
584          */
585         uint256 actualBonus = 0;
586         if ((uint64(now) >= crowdSaleStartTime) && (uint64(now) < crowdSaleStartTime + 30 days)){
587             actualBonus = 35;
588         }
589         if ((uint64(now) >= crowdSaleStartTime + 30 days) && (uint64(now) < crowdSaleStartTime + 61 days)){
590             actualBonus = 15;
591         }
592         if ((uint64(now) >= crowdSaleStartTime + 61 days) && (uint64(now) < crowdSaleStartTime + 91 days)){
593             actualBonus = 5;
594         }
595         return actualBonus;
596     }
597 
598     function _withdrawProfit () internal {
599         /**
600          * @dev Distributing profit
601          * the function start automatically every time when contract receive a payable transaction
602          */
603         
604         uint256 marketingProfit = myAddress.balance.mul(30).div(100);   // 30%
605         uint256 lawSupportProfit = myAddress.balance.div(20);           // 5%
606         uint256 hostingProfit = myAddress.balance.div(20);              // 5%
607         uint256 teamProfit = myAddress.balance.div(10);                 // 10%
608         uint256 contractorsProfit = myAddress.balance.div(20);          // 5%
609         uint256 saasApiProfit = myAddress.balance.div(20);              // 5%
610         //uint256 neironixProfit =  myAddress.balance.mul(40).div(100); // 40% but not use. Just transfer all rest
611 
612 
613         if (marketingProfitAddress != address(0)) {
614             marketingProfitAddress.transfer(marketingProfit);
615             emit Withdraw(msg.sender, marketingProfitAddress, marketingProfit);
616         }
617         
618         if (lawSupportProfitAddress != address(0)) {
619             lawSupportProfitAddress.transfer(lawSupportProfit);
620             emit Withdraw(msg.sender, lawSupportProfitAddress, lawSupportProfit);
621         }
622 
623         if (hostingProfitAddress != address(0)) {
624             hostingProfitAddress.transfer(hostingProfit);
625             emit Withdraw(msg.sender, hostingProfitAddress, hostingProfit);
626         }
627 
628         if (teamProfitAddress != address(0)) {
629             teamProfitAddress.transfer(teamProfit);
630             emit Withdraw(msg.sender, teamProfitAddress, teamProfit);
631         }
632 
633         if (contractorsProfitAddress != address(0)) {
634             contractorsProfitAddress.transfer(contractorsProfit);
635             emit Withdraw(msg.sender, contractorsProfitAddress, contractorsProfit);
636         }
637 
638         if (saasApiProfitAddress != address(0)) {
639             saasApiProfitAddress.transfer(saasApiProfit);
640             emit Withdraw(msg.sender, saasApiProfitAddress, saasApiProfit);
641         }
642 
643         require(neironixProfitAddress != address(0));
644         uint myBalance = myAddress.balance;
645         neironixProfitAddress.transfer(myBalance);
646         emit Withdraw(msg.sender, neironixProfitAddress, myBalance);
647 
648     }
649  
650     function _saleTokens() internal returns(bool) {
651         require(uint64(now) > crowdSaleStartTime, "Sale stage is not yet, Contract is init, do not accept ether."); 
652          
653         if (currentState == State.Init) {
654             require(neironixProfitAddress != address(0),"At least one of profit addresses must be entered");
655             setState(State.CrowdSale);
656         }
657         
658         /**
659          * @dev calculation length of periods, pauses, auto set next stage
660          */
661         if (uint64(now) > crowdSaleEndTime){
662             require (false, "CrowdSale stage is passed - contract do not accept ether");
663         }
664         
665         uint tokens = tokenRate.mul(msg.value);
666         
667         if (currentState == State.CrowdSale) {
668             require (msg.value <= 250 ether, "Maximum 250 ether for transaction all CrowdSale period");
669             require (msg.value >= 0.1 ether, "Minimum 0,1 ether for transaction all CrowdSale period");
670         }
671         
672         tokens = tokens.add(tokens.mul(setBonus()).div(100));
673         token.transfer(msg.sender, tokens);
674         return true;
675     }
676 
677 
678     function() external payable {
679         if (_saleTokens()) {
680             _withdrawProfit();
681         }
682     }    
683 
684 }