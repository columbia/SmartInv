1 pragma solidity ^0.4.18;
2 
3 /**
4  * Math operations with safety checks
5  */
6 
7 library SafeMath {
8 
9 
10     function mul(uint a, uint b) internal pure returns (uint) {
11         uint c = a * b;
12         assert(a == 0 || c / a == b);
13         return c;
14     }
15 
16     function sub(uint a, uint b) internal pure returns (uint) {
17         assert(b <= a);
18         return a - b;
19     }
20 
21     function add(uint a, uint b) internal pure returns (uint) {
22         uint c = a + b;
23         assert(c>=a && c>=b);
24         return c;
25     }
26 }
27 
28 
29 /* 
30  * Token related contracts 
31  */
32 
33 
34 /*
35  * ERC20Basic
36  * Simpler version of ERC20 interface
37  * see https://github.com/ethereum/EIPs/issues/20
38  */
39 
40 contract ERC20Basic {
41     uint public totalSupply;
42     function balanceOf(address who) public view returns (uint);
43     function transfer(address to, uint256 value) public returns (bool);
44     event Transfer(address indexed from, address indexed to, uint value);
45 }
46 
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 
53 contract ERC20 is ERC20Basic {
54     function allowance(address owner, address spender) public view returns (uint256);
55     function transferFrom(address from, address to, uint256 value) public returns (bool);
56     function approve(address spender, uint256 value) public returns (bool);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 
66 contract BasicToken is ERC20Basic {
67     using SafeMath for uint256;
68 
69     mapping(address => uint256) balances;
70 
71     /**
72      * @dev transfer token for a specified address
73      * @param _to The address to transfer to.
74      * @param _value The amount to be transferred.
75      */
76     function transfer(address _to, uint256 _value) public returns (bool) {
77         require(_to != address(0));
78         require(_value <= balances[msg.sender]);
79 
80         // SafeMath.sub will throw if there is not enough balance.
81         balances[msg.sender] = balances[msg.sender].sub(_value);
82         balances[_to] = balances[_to].add(_value);
83         Transfer(msg.sender, _to, _value);
84         return true;
85     }
86 
87     /**
88      * @dev Gets the balance of the specified address.
89      * @param _owner The address to query the the balance of.
90      * @return An uint representing the amount owned by the passed address.
91      */
92     function balanceOf(address _owner) public view returns (uint) {
93         return balances[_owner];
94     }
95 
96 }
97 
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * @dev https://github.com/ethereum/EIPs/issues/20
104  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
105  */
106 
107 contract StandardToken is ERC20, BasicToken {
108 
109     mapping (address => mapping (address => uint256)) internal allowed;
110 
111 
112     /**
113      * @dev Transfer tokens from one address to another
114      * @param _from address The address which you want to send tokens from
115      * @param _to address The address which you want to transfer to
116      * @param _value uint256 the amount of tokens to be transferred
117      */
118     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119         require(_to != address(0));
120         require(_value <= balances[_from]);
121         require(_value <= allowed[_from][msg.sender]);
122 
123         balances[_from] = balances[_from].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126         Transfer(_from, _to, _value);
127         return true;
128     }
129 
130     /**
131      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132      *
133      * Beware that changing an allowance with this method brings the risk that someone may use both the old
134      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      * @param _spender The address which will spend the funds.
138      * @param _value The amount of tokens to be spent.
139      */
140     function approve(address _spender, uint256 _value) public returns (bool) {
141         allowed[msg.sender][_spender] = _value;
142         Approval(msg.sender, _spender, _value);
143         return true;
144     }
145 
146     /**
147      * @dev Function to check the amount of tokens that an owner allowed to a spender.
148      * @param _owner address The address which owns the funds.
149      * @param _spender address The address which will spend the funds.
150      * @return A uint256 specifying the amount of tokens still available for the spender.
151      */
152     function allowance(address _owner, address _spender) public view returns (uint256) {
153         return allowed[_owner][_spender];
154     }
155 
156 }
157 
158 
159 /*
160  * Ownable
161  *
162  * Base contract with an owner.
163  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
164  */
165 
166 contract Ownable {
167     address public owner;
168     address public newOwner;
169 
170     function Ownable() public {
171         owner = msg.sender;
172     }
173 
174     modifier onlyOwner() { 
175         require(msg.sender == owner);
176         _;
177     }
178 
179     modifier onlyNewOwner() {
180         require(msg.sender == newOwner);
181         _;
182     }
183     /*
184     // This code is dangerous because an error in the newOwner 
185     // means that this contract will be ownerless 
186     function transfer(address newOwner) public onlyOwner {
187         require(newOwner != address(0)); 
188         owner = newOwner;
189     }
190    */
191 
192     function proposeNewOwner(address _newOwner) external onlyOwner {
193         require(_newOwner != address(0));
194         newOwner = _newOwner;
195     }
196 
197     function acceptOwnership() external onlyNewOwner {
198         require(newOwner != owner);
199         owner = newOwner;
200     }
201 }
202 
203 
204 /**
205  * @title Mintable token
206  * @dev Simple ERC20 Token example, with mintable token creation
207  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
208  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
209  */
210 
211 contract MintableToken is StandardToken, Ownable {
212     event Mint(address indexed to, uint256 amount);
213     event MintFinished();
214 
215     bool public mintingFinished = false;
216 
217 
218     modifier canMint() {
219         require(!mintingFinished);
220         _;
221     }
222 
223     /**
224      * @dev Function to mint tokens
225      * @param _to The address that will receive the minted tokens.
226      * @param _amount The amount of tokens to mint.
227      * @return A boolean that indicates if the operation was successful.
228      */
229     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
230         totalSupply = totalSupply.add(_amount);
231         balances[_to] = balances[_to].add(_amount);
232         Mint(_to, _amount);
233         Transfer(address(0), _to, _amount);
234         return true;
235     }
236 
237     /**
238      * @dev Function to stop minting new tokens.
239      * @return True if the operation was successful.
240      */
241     function finishMinting() public onlyOwner canMint returns (bool) {
242         mintingFinished = true;
243         MintFinished();
244         return true;
245     }
246 }
247 
248 
249 /**
250  * @title Burnable Token
251  * @dev Token that can be irreversibly burned (destroyed).
252  */
253 contract BurnableToken is BasicToken {
254 
255     event Burn(address indexed burner, uint256 value);
256 
257     /**
258      * @dev Burns a specific amount of tokens.
259      * @param _value The amount of token to be burned.
260      */
261     function burn(uint256 _value) public  {
262         require(_value <= balances[msg.sender]);
263         // no need to require value <= totalSupply, since that would imply the
264         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
265 
266         address burner = msg.sender;
267         balances[burner] = balances[burner].sub(_value);
268         totalSupply = totalSupply.sub(_value);
269         Burn(burner, _value);
270     }
271 }
272 
273 
274 /**
275  * @title Pausable
276  * @dev Base contract which allows children to implement an emergency stop mechanism.
277  */
278 
279 contract Pausable is Ownable {
280 
281 
282     event Pause();
283     event Unpause();
284 
285     bool public paused = true;
286 
287 
288     /**
289      * @dev Modifier to make a function callable only when the contract is not paused.
290      */
291     modifier whenNotPaused() {
292         require(!paused);
293         _;
294     }
295 
296     /**
297      * @dev Modifier to make a function callable only when the contract is paused.
298      */
299     modifier whenPaused() {
300         require(paused);
301         _;
302     }
303 
304     /**
305      * @dev called by the owner to pause, triggers stopped state
306      */
307     function pause() onlyOwner whenNotPaused public {
308         paused = true;
309         Pause();
310     }
311 
312     /**
313      * @dev called by the owner to unpause, returns to normal state
314      */
315     function unpause() onlyOwner whenPaused public {
316         paused = false;
317         Unpause();
318     }
319 }
320 
321 
322 
323 /* @title Pausable token
324  *
325  * @dev StandardToken modified with pausable transfers.
326  **/
327 
328 contract PausableToken is StandardToken, Pausable {
329 
330     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
331         return super.transfer(_to, _value);
332     }
333 
334     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
335         return super.transferFrom(_from, _to, _value);
336     }
337 
338     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
339         return super.approve(_spender, _value);
340     }
341 
342 }
343 
344 
345 /*
346  * Actual token contract
347  */
348 
349 contract AcjToken is BurnableToken, MintableToken, PausableToken {
350     using SafeMath for uint256;
351 
352     string public constant name = "Artist Connect Coin";
353     string public constant symbol = "ACJ";
354     uint public constant decimals = 18;
355     
356     function AcjToken() public {
357         totalSupply = 150000000 ether; 
358         balances[msg.sender] = totalSupply;
359         paused = true;
360     }
361 
362     function activate() external onlyOwner {
363         unpause();
364         finishMinting();
365     }
366 
367     // This method will be used by the crowdsale smart contract 
368     // that owns the AcjToken and will distribute 
369     // the tokens to the contributors
370     function initialTransfer(address _to, uint _value) external onlyOwner returns (bool) {
371         require(_to != address(0));
372         require(_value <= balances[msg.sender]);
373 
374         balances[msg.sender] = balances[msg.sender].sub(_value);
375         balances[_to] = balances[_to].add(_value);
376         Transfer(msg.sender, _to, _value);
377         return true;
378     }
379 
380     function burn(uint256 _amount) public onlyOwner {
381         super.burn(_amount);
382     }
383 
384 }
385 
386 
387 contract AcjCrowdsale is Ownable {
388 
389 
390     using SafeMath for uint256;
391 
392     /* Bonuses */
393 
394     // Presale bonus percentage
395     uint public constant BONUS_PRESALE = 10;            
396     // Medium bonus percentage
397     uint public constant BONUS_MID = 10;                
398     // High bonus percentage
399     uint public constant BONUS_HI = 20;                 
400     // Medium bonus threshold
401     uint public constant BONUS_MID_QTY = 150 ether;     
402     // High bonus threshold
403     uint public constant BONUS_HI_QTY = 335 ether;      
404 
405     /* Absolute dates as timestamps */
406 
407     uint public startPresale;            
408     uint public endPresale;             
409     uint public startIco;              
410     uint public endIco;               
411 
412     // 30 days refund period on fail
413     uint public constant REFUND_PERIOD = 30 days;
414 
415     /* Tokens **/
416 
417     // Indicative token balances during the crowdsale 
418     mapping(address => uint256) public tokenBalances;    
419     // Token smart contract address
420     address public token;
421     // Total tokens created
422     uint256 public tokensTotalSupply; 
423     // Tokens available for sale
424     uint256 public tokensForSale;    
425     // Tokens sold via buyTokens
426     uint256 public tokensSold;                             
427     // Tokens created during the sale
428     uint256 public tokensDistributed;                      
429     // soft cap in ETH
430     uint256 public tokensSoftCap;                          
431     // ICO flat rate subject to bonuses
432     uint256 public ethTokenRate;                             
433 
434     /* Management */
435 
436     // Allow multiple administrators
437     mapping(address => bool) public admins;                
438 
439     /* Various */
440 
441     // Total wei received 
442     uint256 public weiReceived;                            
443     // Minimum contribution in ETH
444     uint256 public weiMinContribution = 1 ether;           
445     // Contributions in wei for each address
446     mapping(address => uint256) public contributions;
447     // Refund state for each address
448     mapping(address => bool) public refunds;
449 
450     /* Wallets */
451 
452     // Company wallet that will receive the ETH
453     address public companyWallet;                           
454 
455     /* Events */
456 
457     // Yoohoo someone contributed !
458     event Contribute(address indexed _from, uint _amount); 
459     // Token <> ETH rate updated
460     event TokenRateUpdated(uint _newRate);                  
461     // ETH Refund 
462     event Refunded(address indexed _from, uint _amount);    
463 
464     /* Modifiers */ 
465 
466     modifier belowTotalSupply {
467         require(tokensDistributed < tokensTotalSupply);
468         _;
469     }
470 
471     modifier belowHardCap {
472         require(tokensDistributed < tokensForSale);
473         _;
474     }
475 
476     modifier adminOnly {
477         require(msg.sender == owner || admins[msg.sender] == true);
478         _;
479     }
480 
481     modifier crowdsaleFailed {
482         require(isFailed());
483         _;
484     }
485 
486     modifier crowdsaleSuccess {
487         require(isSuccess());
488         _;
489     }
490 
491     modifier duringSale {
492         require(now < endIco);
493         require((now > startPresale && now < endPresale) || now > startIco);
494         _;
495     }
496 
497     modifier afterSale {
498         require(now > endIco);
499         _;
500     }
501 
502     modifier aboveMinimum {
503         require(msg.value >= weiMinContribution);
504         _;
505     }
506 
507     /* Public methods */
508 
509     /* 
510      * Constructor
511      * Creating the new Token smart contract
512      * and setting its owner to the current sender
513      * 
514      */
515     function AcjCrowdsale(
516             uint _presaleStart, 
517             uint _presaleEnd, 
518             uint _icoStart, 
519             uint _icoEnd, 
520             uint256 _rate, 
521             uint256 _cap, 
522             uint256 _goal, 
523             uint256 _totalSupply,
524             address _token
525             ) public {
526 
527         require(_presaleEnd > _presaleStart);
528         require(_icoStart > _presaleEnd);
529         require(_icoEnd > _icoStart);
530 
531         require(_rate > 0); 
532         require(_cap > 0);
533         require(_goal > 0);
534         require(_totalSupply > _goal);
535 
536         startPresale = _presaleStart;
537         endPresale = _presaleEnd;
538         startIco = _icoStart;
539         endIco = _icoEnd;
540 
541         ethTokenRate = _rate;        
542         tokensSoftCap = _cap.mul(1 ether);
543         tokensForSale = _goal.mul(1 ether);
544         tokensTotalSupply = _totalSupply.mul(1 ether);
545 
546         admins[msg.sender] = true;
547         companyWallet = msg.sender;
548 
549         token = _token;
550     }
551 
552 
553     /*
554      * Fallback payable
555      */
556     function () external payable {
557 
558         buyTokens(msg.sender);
559     }
560 
561 
562     /* Crowdsale staff only */
563 
564 
565     /*
566      * Admin management
567      */
568     function addAdmin(address _adr) external onlyOwner {
569 
570         require(_adr != address(0));
571         admins[_adr] = true;
572     }
573 
574     function removeAdmin(address _adr) external onlyOwner {
575 
576         require(_adr != address(0));
577         admins[_adr] = false;
578     }
579 
580     /*
581      * Change the company wallet
582      */
583     function updateCompanyWallet(address _wallet) external adminOnly {
584 
585         companyWallet = _wallet;
586     }
587 
588     /*
589      *  Change the owner of the token
590      */
591     function proposeTokenOwner(address _newOwner) external adminOnly {
592 
593         AcjToken _token = AcjToken(token);
594         _token.proposeNewOwner(_newOwner);
595     }
596 
597     function acceptTokenOwnership() external onlyOwner {
598         
599         AcjToken _token = AcjToken(token);
600         _token.acceptOwnership();
601 
602     }
603 
604     /*
605      * Activate the token
606      */
607     function activateToken() external adminOnly crowdsaleSuccess afterSale {
608         AcjToken _token = AcjToken(token);
609         _token.activate();
610     }
611 
612     /* 
613      * Adjust the token value before the ICO
614      */
615     function adjustTokenExchangeRate(uint _rate) external adminOnly {
616 
617         require(now > endPresale && now < startIco);
618         ethTokenRate = _rate;
619         TokenRateUpdated(_rate);
620     }
621 
622     /* 
623      * Start therefund period
624      * Each contributor has to claim own  ETH 
625      */     
626     function refundContribution() external crowdsaleFailed afterSale {
627 
628         require(!refunds[msg.sender]);
629         require(contributions[msg.sender] > 0);
630 
631         uint256 _amount = contributions[msg.sender];
632         tokenBalances[msg.sender] = 0;
633         refunds[msg.sender] = true;
634         Refunded(msg.sender, contributions[msg.sender]);
635         msg.sender.transfer(_amount);
636 
637     }
638 
639     /*
640      * After the refund period, remaining tokens
641      * are transfered to the company wallet
642      * Allow withdrawal at any time if the ICO is a success.
643      */     
644     function withdrawUnclaimed() external adminOnly {
645 
646         require(now > endIco + REFUND_PERIOD || isSuccess());
647         companyWallet.transfer(this.balance);
648     }
649 
650     /*
651      * Pre-ICO and offline Investors, collaborators and team tokens
652      */
653     function reserveTokens(address _beneficiary, uint256 _tokensQty) external adminOnly belowTotalSupply {
654 
655 //        require(_beneficiary != address(0));
656         uint _distributed = tokensDistributed.add(_tokensQty);
657 
658         require(_distributed <= tokensTotalSupply);
659 
660         tokenBalances[_beneficiary] = _tokensQty.add(tokenBalances[_beneficiary]);
661         tokensDistributed = _distributed;
662 
663         AcjToken _token = AcjToken(token);
664         _token.initialTransfer(_beneficiary, _tokensQty);
665     }
666 
667 
668     /*
669      * Actually buy the tokens
670      * requires an active sale time
671      * and amount above the minimum contribution
672      * and sold tokens inferior to tokens for sale
673      */     
674     function buyTokens(address _beneficiary) public payable duringSale aboveMinimum belowHardCap {
675 
676         require(_beneficiary != address(0));
677         uint256 _weiAmount = msg.value;        
678         uint256 _tokensQty = msg.value.mul(getBonus(_weiAmount));
679         uint256 _distributed = _tokensQty.add(tokensDistributed);
680         uint256 _sold = _tokensQty.add(tokensSold);
681 
682         require(_distributed <= tokensTotalSupply);
683         require(_sold <= tokensForSale);
684 
685         contributions[_beneficiary] = _weiAmount.add(contributions[_beneficiary]);
686         tokenBalances[_beneficiary] = _tokensQty.add(tokenBalances[_beneficiary]);
687         weiReceived = weiReceived.add(_weiAmount);
688         tokensDistributed = _distributed;
689         tokensSold = _sold;
690 
691         Contribute(_beneficiary, msg.value);
692 
693         AcjToken _token = AcjToken(token);
694         _token.initialTransfer(_beneficiary, _tokensQty);
695     }
696 
697     /*
698      * Crowdsale Helpers 
699      */
700     function hasEnded() public view returns(bool) {
701 
702         return now > endIco;
703     }
704 
705     /*
706      * Checks if the crowdsale is a success
707      */
708     function isSuccess() public view returns(bool) {
709 
710         if (tokensSold >= tokensSoftCap) {
711             return true;
712         }
713         return false;
714     }
715 
716     /*
717      * Checks if the crowdsale failed
718      */
719     function isFailed() public view returns(bool) {
720 
721         if (tokensSold < tokensSoftCap && now > endIco) {
722             return true;
723         }
724         return false;
725     }
726 
727     /* 
728      * Bonus calculations
729      * Either time or ETH quantity based 
730      */
731     function getBonus(uint256 _wei) internal constant returns(uint256 ethToAcj) {
732 
733         uint256 _bonus = 0;
734 
735         // Time based bonus
736         if (endPresale > now) {
737             _bonus = _bonus.add(BONUS_PRESALE); 
738         }
739 
740         // ETH Quantity based bonus
741         if (_wei >= BONUS_HI_QTY) { 
742             _bonus = _bonus.add(BONUS_HI);
743         } else if (_wei >= BONUS_MID_QTY) {
744             _bonus = _bonus.add(BONUS_MID);
745         }
746 
747         return ethTokenRate.mul(100 + _bonus) / 100;
748     }
749 
750 }