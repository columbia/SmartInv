1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17     function Ownable() public {
18         owner = msg.sender;
19     }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33     function transferOwnership(address newOwner) public onlyOwner returns (bool) {
34         require(newOwner != address(0));
35         require(newOwner != address(this));
36         require(newOwner != owner);  
37         OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39         return true;
40     }
41 
42 }
43 
44 /**
45  * @title ERC20Basic
46  * @dev Simpler version of ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/179
48  */
49 contract ERC20Basic {
50     uint256 public totalSupply;
51     function balanceOf(address who) public constant returns (uint256);
52     function transfer(address to, uint256 value) public returns (bool);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 /**
57  * @title ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/20
59  */
60 contract ERC20 is ERC20Basic {
61     function allowance(address owner, address spender) public constant returns (uint256);
62     function transferFrom(address from, address to, uint256 value) public returns (bool);
63     function approve(address spender, uint256 value) public returns (bool);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 /**
68  * @title SafeMath
69  * @dev Math operations with safety checks that throw on error
70  */
71 library SafeMath {
72     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a * b;
74         assert(a == 0 || c / a == b);
75         return c;
76     }
77     function div(uint256 a, uint256 b) internal pure returns (uint256) {
78     // assert(b > 0); // Solidity automatically throws when dividing by 0
79         uint256 c = a / b;
80     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81         return c;
82     }
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         assert(b <= a);
85         return a - b;
86     }
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         assert(c >= a);
90         return c;
91     }
92 }
93 
94 /**
95  * @title Basic token
96  * @dev Basic version of StandardToken, with no allowances.
97  */
98 contract BasicToken is ERC20Basic {
99     using SafeMath for uint256;
100 
101     mapping(address => uint256) balances;
102 
103   /**
104   * @dev transfer token for a specified address
105   * @param _to The address to transfer to.
106     * @param _value The amount to be transferred.
107       */
108     function transfer(address _to, uint256 _value) public returns (bool){
109         balances[msg.sender] = balances[msg.sender].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         Transfer(msg.sender, _to, _value);
112         return true;
113     }
114 
115   /**
116   * @dev Gets the balance of the specified address.
117   * @param _owner The address to query the the balance of.
118     * @return An uint256 representing the amount owned by the passed address.
119     */
120     function balanceOf(address _owner) public constant returns (uint256 balance) {
121         return balances[_owner];
122     }
123 }
124 
125 // ************************ new Standard  ERC20 token with increase and decraese approval ***********************
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * @dev https://github.com/ethereum/EIPs/issues/20
131  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135     mapping (address => mapping (address => uint256)) internal allowed;
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145         require(_to != address(0));
146         require(_value <= balances[_from]);
147         require(_value <= allowed[_from][msg.sender]);
148 
149         balances[_from] = balances[_from].sub(_value);
150         balances[_to] = balances[_to].add(_value);
151         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152         Transfer(_from, _to, _value);
153         return true;
154     }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    *
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166     function approve(address _spender, uint256 _value) public returns (bool) {
167         allowed[msg.sender][_spender] = _value;
168         Approval(msg.sender, _spender, _value);
169         return true;
170     }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifying the amount of tokens still available for the spender.
177    */
178     function allowance(address _owner, address _spender) public view returns (uint256) {
179         return allowed[_owner][_spender];
180     }
181 
182   /**
183    * @dev Increase the amount of tokens that an owner allowed to a spender.
184    *
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param _spender The address which will spend the funds.
190    * @param _addedValue The amount of tokens to increase the allowance by.
191    */
192     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
193         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195         return true;
196     }
197 
198   /**
199    * @dev Decrease the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To decrement
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _subtractedValue The amount of tokens to decrease the allowance by.
207    */
208     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
209         uint oldValue = allowed[msg.sender][_spender];
210         if (_subtractedValue > oldValue) {
211             allowed[msg.sender][_spender] = 0;
212     } else {
213             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216         return true;
217     }
218 
219 }
220 //  *************************************************************************************************************
221 
222 /**
223  * @title Mintable token
224  * @dev Simple ERC20 Token example, with mintable token creation
225  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
226  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
227  */
228 contract MintableToken is StandardToken, Ownable {
229 
230     event Mint(address indexed to, uint256 amount);
231     event MintFinished();
232 
233     bool public mintingFinished = false;
234 
235     modifier canMint() {
236         require(!mintingFinished);
237         _;
238     }
239 
240   /**
241   * @dev Function to mint tokens
242   * @param _to The address that will recieve the minted tokens.
243     * @param _amount The amount of tokens to mint.
244     * @return A boolean that indicates if the operation was successful.
245    */
246     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
247         totalSupply = totalSupply.add(_amount);
248         balances[_to] = balances[_to].add(_amount);
249         Transfer(0X0, _to, _amount);
250         return true;
251     }
252 
253   /**
254   * @dev Function to stop minting new tokens.
255   * @return True if the operation was successful.
256    */
257     function finishMinting() onlyOwner public returns (bool) {
258         mintingFinished = true;
259         MintFinished();
260         return true;
261     }
262 }
263 
264 contract MooToken is MintableToken {
265   // Coin Properties
266     string public name = "MOO token";
267     string public symbol = "XMOO";
268     uint256 public decimals = 18;
269 
270     event EmergencyERC20DrainWasCalled(address tokenaddress, uint256 _amount);
271 
272   // Special propeties
273     bool public tradingStarted = false;
274 
275   /**
276   * @dev modifier that throws if trading has not started yet
277    */
278     modifier hasStartedTrading() {
279         require(tradingStarted);
280         _;
281     }
282 
283   /**
284   * @dev Allows the owner to enable the trading. This can not be undone
285   */
286     function startTrading() public onlyOwner returns(bool) {
287         require(!tradingStarted);
288         tradingStarted = true;
289         return true;
290     }
291 
292   /**
293   * @dev Allows anyone to transfer the MOO tokens once trading has started
294   * @param _to the recipient address of the tokens.
295   * @param _value number of tokens to be transfered.
296    */
297     function transfer(address _to, uint _value) hasStartedTrading public returns (bool) {
298         return super.transfer(_to, _value);
299     }
300 
301   /**
302   * @dev Allows anyone to transfer the MOO tokens once trading has started
303   * @param _from address The address which you want to send tokens from
304   * @param _to address The address which you want to transfer to
305   * @param _value uint the amout of tokens to be transfered
306    */
307     function transferFrom(address _from, address _to, uint _value) hasStartedTrading public returns (bool) {
308         return super.transferFrom(_from, _to, _value);
309     }
310 
311     function emergencyERC20Drain( ERC20 oddToken, uint amount ) public onlyOwner returns(bool){
312         oddToken.transfer(owner, amount);
313         EmergencyERC20DrainWasCalled(oddToken, amount);
314         return true;
315     }
316 
317     function isOwner(address _owner) public view returns(bool){
318         if (owner == _owner) {
319             return true;    
320     } else {
321             return false;    
322     } 
323     }
324 }
325 
326 
327 contract MooTokenSale is Ownable {
328     using SafeMath for uint256;
329 
330   // The token being sold
331     MooToken public token;
332     uint256 public decimals;
333     uint256 public oneCoin;
334 
335   // start and end block where investments are allowed 
336     uint256 public PRESALE_STARTTIMESTAMP;
337     uint256 public PRESALE_ENDTIMESTAMP;
338 
339   // start and end block where investments are allowed 
340     uint256 public PUBLICSALE_STARTTIMESTAMP;
341     uint256 public PUBLICSALE_ENDTIMESTAMP;
342 
343   // address where funds are collected
344     address public multiSig;
345 
346     function setWallet(address _newWallet) public onlyOwner returns (bool) {
347         multiSig = _newWallet;
348         WalletUpdated(_newWallet);
349         return true;
350     } 
351 
352     uint256 rate; // how many token units a buyer gets per wei
353     uint256 public minContribution = 0.0001 ether;  // minimum contributio to participate in tokensale
354     uint256 public maxContribution = 1000 ether;
355     uint256 public tokensOfTeamAndAdvisors;
356 
357   // amount of raised money in wei
358     uint256 public weiRaised;
359 
360   // amount of raised tokens
361     uint256 public tokenRaised;
362 
363   // maximum amount of tokens being created
364     uint256 public maxTokens;
365 
366   // maximum amount of tokens for sale
367     uint256 public tokensForSale;  
368   // maximum amount of tokens for presale
369   // uint256 public tokensForPreSale; 
370 
371   // number of participants in presale
372     uint256 public numberOfContributors = 0;
373 
374   //  for whitelist
375     address public cs;
376   //  for whitelist AND placement
377     address public Admin;
378 
379   //  for rate
380     uint public basicRate;
381 
382   // for maximum token what one contributor can buy
383     uint public maxTokenCap;
384   // for suspension
385     bool public suspended;
386  
387 
388     mapping (address => bool) public authorised; // just to annoy the heck out of americans
389     mapping (address => uint) adminCallMintToTeamCount; // count to admin only once can call MintToTeamAndAdvisors
390 
391     event TokenPurchase(address indexed purchaser, uint256 amount, uint256 _tokens);
392     event TokenPlaced(address indexed beneficiary, uint256 _tokens);
393     event SaleClosed();
394     event TradingStarted();
395     event Closed();
396     event AdminUpdated(address newAdminAddress);
397     event CsUpdated(address newCSAddress);
398     event EmergencyERC20DrainWasCalled(address tokenaddress, uint256 _amount);
399     event AuthoriseStatusUpdated(address accounts, bool status);
400     event SaleResumed();
401     event SaleSuspended();
402     event WalletUpdated(address newwallet);
403    
404 
405     function MooTokenSale() public {
406         PRESALE_STARTTIMESTAMP = 1516896000;
407         // 1516896000 converts to Friday January 26, 2018 00:00:00 (am) in time zone Asia/Singapore (+08)
408         PRESALE_ENDTIMESTAMP = 1522209600;
409         //1522209600 converts to Wednesday March 28, 2018 12:00:00 (pm) in time zone Asia/Singapore (+08)
410         PUBLICSALE_STARTTIMESTAMP = 1522382400;
411         //  1522382400 converts to Friday March 30, 2018 12:00:00 (pm) in time zone Asia/Singapore (+08)
412         PUBLICSALE_ENDTIMESTAMP = 1525060800; 
413         // 1525060800 converts to Monday April 30, 2018 12:00:00 (pm) in time zone Asia/Singapore (+08)
414       
415         multiSig = 0x90420B8aef42F856a0AFB4FFBfaA57405FB190f3;
416    
417         token = new MooToken();
418         decimals = token.decimals();
419         oneCoin = 10 ** decimals;
420         maxTokens = 500 * (10**6) * oneCoin;
421         tokensForSale = 200260050 * oneCoin; // 200 260 050
422         basicRate = 1800;
423         rate = basicRate;
424         tokensOfTeamAndAdvisors = 99739950 * oneCoin;  // it was missing the onecoin , 99 739 950
425         maxTokenCap = basicRate * maxContribution * 11/10;
426         suspended = false;
427     }
428 
429 
430     function currentTime() public constant returns (uint256) {
431         return now;
432     }
433 
434     /**
435     * @dev Calculates the rate with bonus in the publis sale
436     */
437     function getCurrentRate() public view returns (uint256) {
438     
439         if (currentTime() <= PRESALE_ENDTIMESTAMP) {
440             return basicRate * 5/4;
441         }
442 
443         if (tokenRaised <= 10000000 * oneCoin) {
444             return basicRate * 11/10;
445     } else if (tokenRaised <= 20000000 * oneCoin) {
446         return basicRate * 1075/1000;
447     } else if (tokenRaised <= 30000000 * oneCoin) {
448         return basicRate * 105/100;
449     } else {
450         return basicRate ;
451     }
452     }
453 
454 
455   // @return true if crowdsale event has ended
456     function hasEnded() public constant returns (bool) {
457         if (currentTime() > PUBLICSALE_ENDTIMESTAMP)
458             return true; // if  the time is over
459         if (tokenRaised >= tokensForSale)
460             return true; // if we reach the tokensForSale 
461         return false;
462     }
463 
464 // Allows admin to suspend the sale.
465     function suspend() external onlyAdmin returns(bool) {
466         if (suspended == true) {
467             return false;
468         }
469         suspended = true;
470         SaleSuspended();
471         return true;
472     }
473 
474 
475 // Allows admin to resume the sale.
476     function resume() external onlyAdmin returns(bool) {
477         if (suspended == false) {
478             return false;
479         }
480         suspended = false;
481         SaleResumed();
482         return true;
483     }
484 
485   
486   // @dev throws if person sending is not contract Admin or cs role
487     modifier onlyCSorAdmin() {
488         require((msg.sender == Admin) || (msg.sender==cs));
489         _;
490     }
491     modifier onlyAdmin() {
492         require(msg.sender == Admin);
493         _;
494     }
495 
496   /**
497   * @dev throws if person sending is not authorised or sends nothing or we are out of time
498   */
499     modifier onlyAuthorised() {
500         require (authorised[msg.sender]);
501         require ((currentTime() >= PRESALE_STARTTIMESTAMP && currentTime() <= PRESALE_ENDTIMESTAMP ) || (currentTime() >= PUBLICSALE_STARTTIMESTAMP && currentTime() <= PUBLICSALE_ENDTIMESTAMP ));
502         require (!(hasEnded()));
503         require (multiSig != 0x0);
504         require (msg.value > 1 finney);
505         require(!suspended);
506         require(tokensForSale > tokenRaised); // check we are not over the number of tokensForSale
507         _;
508     }
509 
510   /**
511   * @dev authorise an account to participate
512   */
513     function authoriseAccount(address whom) onlyCSorAdmin public returns(bool) {
514         require(whom != address(0));
515         require(whom != address(this));
516         authorised[whom] = true;
517         AuthoriseStatusUpdated(whom, true);
518         return true;
519     }
520 
521   /**
522   * @dev authorise a lot of accounts in one go
523   */
524     function authoriseManyAccounts(address[] many) onlyCSorAdmin public returns(bool) {
525         require(many.length > 0);  
526         for (uint256 i = 0; i < many.length; i++) {
527             require(many[i] != address(0));
528             require(many[i] != address(this));  
529             authorised[many[i]] = true;
530             AuthoriseStatusUpdated(many[i], true);
531         }
532         return true;            
533     }
534 
535   /**
536   * @dev ban an account from participation (default)
537   */
538     function blockAccount(address whom) onlyCSorAdmin public returns(bool){
539         require(whom != address(0));
540         require(whom != address(this));
541         authorised[whom] = false;
542         AuthoriseStatusUpdated(whom, false);
543         return true;
544     }
545 
546   /**
547   * @dev set a new CS representative
548   */
549     function setCS(address newCS) onlyOwner public returns (bool){
550         require(newCS != address(0));
551         require(newCS != address(this));
552         require(newCS != owner);  
553         cs = newCS;
554         CsUpdated(newCS);
555         return true;
556     }
557 
558   /**
559   * @dev set a new Admin representative
560   */
561     function setAdmin(address newAdmin) onlyOwner public returns (bool) {
562         require(newAdmin != address(0));
563         require(newAdmin != address(this));
564         require(newAdmin != owner);  
565         Admin = newAdmin;
566         AdminUpdated(newAdmin);
567         return true;
568     }
569 
570   /**
571   * @dev set a new Rate BE CAREFULL: when we calculate the bonus better if we have'nt remainder 
572   */
573     function setBasicRate(uint newRate) onlyAdmin public returns (bool){
574         require(0 < newRate && newRate < 5000);
575         basicRate = newRate;
576         return true;
577     }
578 
579     function setMaxTokenCap(uint _newMaxTokenCap) onlyAdmin public returns (bool){
580         require(0 < _newMaxTokenCap && _newMaxTokenCap < tokensForSale);
581         maxTokenCap = _newMaxTokenCap;
582         return true;
583     }
584   
585     function isOwner(address _owner) public view returns(bool){
586         if (owner == _owner) {
587             return true;    
588     } else {
589             return false;    
590     } 
591     }
592   
593     function isAdmin(address _admin) public view returns(bool){
594         if (Admin == _admin) {
595             return true;    
596     } else {
597             return false;    
598     } 
599     }
600 
601     function isCS(address _cs) public view returns(bool){
602         if (cs == _cs) {
603             return true;    
604     } else {
605             return false;    
606     } 
607     }
608 
609 /**
610   * @dev  only Admin can send tokens manually
611   */
612     function placeTokens(address beneficiary, uint256 _tokens) onlyAdmin public returns(bool){
613 
614     // *************************************************************************************************************  
615         require(tokenRaised.add(_tokens) <= tokensForSale); // we dont want to overmint ********************************
616     // *************************************************************************************************************
617 
618         require(_tokens != 0);
619         require(!hasEnded());
620         if (token.balanceOf(beneficiary) == 0) {
621             numberOfContributors++;
622         }
623         tokenRaised = tokenRaised.add(_tokens); // so we can go slightly over
624         token.mint(beneficiary, _tokens);
625         TokenPlaced(beneficiary, _tokens);
626         return true;
627     }
628 
629   // low level token purchase function
630     function buyTokens(address beneficiary, uint256 amount) onlyAuthorised internal returns (bool){
631       
632         rate = getCurrentRate();
633       // check we are in pre sale , bonus 25%
634         if (currentTime() <= PRESALE_ENDTIMESTAMP) {
635             minContribution = 50 ether;
636             maxContribution = 1000 ether;
637     // we are in publicsale bonus depends on the sold out tokens. we set the rate in the setTier
638     } else {
639             minContribution = 0.2 ether;
640             maxContribution = 20 ether;
641         }
642 
643     //check minimum and maximum amount
644         require(msg.value >= minContribution);
645         require(msg.value <= maxContribution);
646     
647     // Calculate token amount to be purchased    
648         uint256 tokens = amount.mul(rate);
649    
650    
651     // *************************************************************************************************************
652         require(tokenRaised.add(tokens) <= tokensForSale); //if dont want to overmint ******************************
653     // *************************************************************************************************************
654         require(token.balanceOf(beneficiary) + tokens <= maxTokenCap); // limit of tokens what a buyer can buy *****
655     //  ************************************************************************************************************
656 
657 
658     // update state
659         weiRaised = weiRaised.add(amount);
660         if (token.balanceOf(beneficiary) == 0) {
661             numberOfContributors++;
662         }
663         tokenRaised = tokenRaised.add(tokens); // so we can go slightly over
664         token.mint(beneficiary, tokens);
665         TokenPurchase(beneficiary, amount, tokens);
666         multiSig.transfer(this.balance); // better in case any other ether ends up here
667         return true;
668     }
669 
670   // transfer ownership of the token to the owner of the presale contract
671     function finishSale() public onlyOwner {
672         require(hasEnded());
673     // assign the rest of the 300 M tokens to the reserve
674         uint unassigned;    
675         if(tokensForSale > tokenRaised) {
676             unassigned = tokensForSale.sub(tokenRaised);
677             tokenRaised = tokenRaised.add(unassigned);
678             token.mint(multiSig,unassigned);
679             TokenPlaced(multiSig,unassigned);
680     }
681         SaleClosed();
682         token.startTrading(); 
683         TradingStarted();
684     // from now everyone can trade the tokens  and the owner of the tokencontract stay the salecontract
685     }
686  
687 /**
688 *****************************************************************************************
689 *****************************************************************************************
690 *    SPECIAL PART START
691 *****************************************************************************************
692 *****************************************************************************************
693   * @dev only Admin can mint once the given amount in the given time
694   * tokensOfTeamAndAdvisors was given by consumer
695   * multiSig was given by consumer
696 *****************************************************************************************
697 *****************************************************************************************
698  */
699     function mintToTeamAndAdvisors() public onlyAdmin {
700         require(hasEnded());
701         require(adminCallMintToTeamCount[msg.sender] == 0); // count to admin only once can call MintToTeamAndAdvisors
702         require(1535644800 <= currentTime() && currentTime() <= 1535731200);  // Admin have 24h to call this function
703       //1535644800 converts to Friday August 31, 2018 00:00:00 (am) in time zone Asia/Singapore (+08)
704       //1535731200 converts to Saturday September 01, 2018 00:00:00 (am) in time zone Asia/Singapore (+08)
705         adminCallMintToTeamCount[msg.sender]++; 
706         tokenRaised = tokenRaised.add(tokensOfTeamAndAdvisors);
707         token.mint(multiSig,tokensOfTeamAndAdvisors);
708         TokenPlaced(multiSig, tokensOfTeamAndAdvisors);
709     }
710  /**
711 *****************************************************************************************
712 *****************************************************************************************
713   * @dev only Admin can mint from "SaleClosed" to "Closed" 
714   * _tokens given by client (limit if we reach the maxTokens)
715   * multiSig was given by client
716 *****************************************************************************************
717 *****************************************************************************************
718  */ 
719     function afterSaleMinting(uint _tokens) public onlyAdmin {
720         require(hasEnded());
721         uint limit = maxTokens.sub(tokensOfTeamAndAdvisors); 
722      // we dont want to mint the reserved tokens for Team and Advisors
723         require(tokenRaised.add(_tokens) <= limit);  
724         tokenRaised = tokenRaised.add(_tokens);
725         token.mint(multiSig,_tokens);
726         TokenPlaced(multiSig, _tokens);
727     }  
728 /**
729 *****************************************************************************************
730 *****************************************************************************************
731   * @dev only Owner can call after the sale
732   * unassigned , all missing tokens will be minted
733   * multiSig was given by client
734   * finish minting and transfer ownership of token
735 *****************************************************************************************
736 *****************************************************************************************
737  */
738     function close() public onlyOwner {
739         require(1535731200 <= currentTime());  // only after the Aug31
740         uint unassigned;
741         if( maxTokens > tokenRaised) {
742             unassigned = maxTokens.sub(tokenRaised);
743             tokenRaised = tokenRaised.add(unassigned);
744             token.mint(multiSig,unassigned);
745             TokenPlaced(multiSig,unassigned);
746             multiSig.transfer(this.balance); // just in case if we have ether in the contarct
747         }
748         token.finishMinting();
749         token.transferOwnership(owner);
750         Closed();
751     }
752 /**
753 *****************************************************************************************
754 *****************************************************************************************
755   * END OF THE SPECIAL PART
756 *****************************************************************************************
757 *****************************************************************************************
758  */
759 
760 
761   // fallback function can be used to buy tokens
762     function () public payable {
763         buyTokens(msg.sender, msg.value);
764     }
765 
766   // emergency if the contarct get ERC20 tokens
767     function emergencyERC20Drain( ERC20 oddToken, uint amount ) public onlyCSorAdmin returns(bool){
768         oddToken.transfer(owner, amount);
769         EmergencyERC20DrainWasCalled(oddToken, amount);
770         return true;
771     }
772 
773 }