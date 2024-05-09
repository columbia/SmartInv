1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 
8 library SafeMath {
9 
10 
11     function mul(uint a, uint b) internal pure returns (uint) {
12         uint c = a * b;
13         assert(a == 0 || c / a == b);
14         return c;
15     }
16 
17     function sub(uint a, uint b) internal pure returns (uint) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint a, uint b) internal pure returns (uint) {
23         uint c = a + b;
24         assert(c>=a && c>=b);
25         return c;
26     }
27 }
28 
29 
30 /* 
31  * Token related contracts 
32  */
33 
34 
35 /*
36  * ERC20Basic
37  * Simpler version of ERC20 interface
38  * see https://github.com/ethereum/EIPs/issues/20
39  */
40 
41 contract ERC20Basic {
42     uint public totalSupply;
43     function balanceOf(address who) public view returns (uint);
44     function transfer(address to, uint256 value) public returns (bool);
45     event Transfer(address indexed from, address indexed to, uint value);
46 }
47 
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 
54 contract ERC20 is ERC20Basic {
55     function allowance(address owner, address spender) public view returns (uint256);
56     function transferFrom(address from, address to, uint256 value) public returns (bool);
57     function approve(address spender, uint256 value) public returns (bool);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 
67 contract BasicToken is ERC20Basic {
68     using SafeMath for uint256;
69 
70     mapping(address => uint256) balances;
71 
72     /**
73      * @dev transfer token for a specified address
74      * @param _to The address to transfer to.
75      * @param _value The amount to be transferred.
76      */
77     function transfer(address _to, uint256 _value) public returns (bool) {
78         require(_to != address(0));
79         require(_value <= balances[msg.sender]);
80 
81         // SafeMath.sub will throw if there is not enough balance.
82         balances[msg.sender] = balances[msg.sender].sub(_value);
83         balances[_to] = balances[_to].add(_value);
84         Transfer(msg.sender, _to, _value);
85         return true;
86     }
87 
88     /**
89      * @dev Gets the balance of the specified address.
90      * @param _owner The address to query the the balance of.
91      * @return An uint representing the amount owned by the passed address.
92      */
93     function balanceOf(address _owner) public view returns (uint) {
94         return balances[_owner];
95     }
96 
97 }
98 
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 
108 contract StandardToken is ERC20, BasicToken {
109 
110     mapping (address => mapping (address => uint256)) internal allowed;
111 
112 
113     /**
114      * @dev Transfer tokens from one address to another
115      * @param _from address The address which you want to send tokens from
116      * @param _to address The address which you want to transfer to
117      * @param _value uint256 the amount of tokens to be transferred
118      */
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120         require(_to != address(0));
121         require(_value <= balances[_from]);
122         require(_value <= allowed[_from][msg.sender]);
123 
124         balances[_from] = balances[_from].sub(_value);
125         balances[_to] = balances[_to].add(_value);
126         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127         Transfer(_from, _to, _value);
128         return true;
129     }
130 
131     /**
132      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133      *
134      * Beware that changing an allowance with this method brings the risk that someone may use both the old
135      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138      * @param _spender The address which will spend the funds.
139      * @param _value The amount of tokens to be spent.
140      */
141     function approve(address _spender, uint256 _value) public returns (bool) {
142         allowed[msg.sender][_spender] = _value;
143         Approval(msg.sender, _spender, _value);
144         return true;
145     }
146 
147     /**
148      * @dev Function to check the amount of tokens that an owner allowed to a spender.
149      * @param _owner address The address which owns the funds.
150      * @param _spender address The address which will spend the funds.
151      * @return A uint256 specifying the amount of tokens still available for the spender.
152      */
153     function allowance(address _owner, address _spender) public view returns (uint256) {
154         return allowed[_owner][_spender];
155     }
156 
157 }
158 
159 
160 /*
161  * Ownable
162  *
163  * Base contract with an owner.
164  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
165  */
166 
167 contract Ownable {
168     address public owner;
169     address public newOwner;
170 
171     function Ownable() public {
172         owner = msg.sender;
173     }
174 
175     modifier onlyOwner() { 
176         require(msg.sender == owner);
177         _;
178     }
179 
180     modifier onlyNewOwner() {
181         require(msg.sender == newOwner);
182         _;
183     }
184     /*
185     // This code is dangerous because an error in the newOwner 
186     // means that this contract will be ownerless 
187     function transfer(address newOwner) public onlyOwner {
188         require(newOwner != address(0)); 
189         owner = newOwner;
190     }
191    */
192 
193     function proposeNewOwner(address _newOwner) external onlyOwner {
194         require(_newOwner != address(0));
195         newOwner = _newOwner;
196     }
197 
198     function acceptOwnership() external onlyNewOwner {
199         require(newOwner != owner);
200         owner = newOwner;
201     }
202 }
203 
204 
205 /**
206  * @title Mintable token
207  * @dev Simple ERC20 Token example, with mintable token creation
208  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
209  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
210  */
211 
212 contract MintableToken is StandardToken, Ownable {
213     event Mint(address indexed to, uint256 amount);
214     event MintFinished();
215 
216     bool public mintingFinished = false;
217 
218 
219     modifier canMint() {
220         require(!mintingFinished);
221         _;
222     }
223 
224     /**
225      * @dev Function to mint tokens
226      * @param _to The address that will receive the minted tokens.
227      * @param _amount The amount of tokens to mint.
228      * @return A boolean that indicates if the operation was successful.
229      */
230     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
231         totalSupply = totalSupply.add(_amount);
232         balances[_to] = balances[_to].add(_amount);
233         Mint(_to, _amount);
234         Transfer(address(0), _to, _amount);
235         return true;
236     }
237 
238     /**
239      * @dev Function to stop minting new tokens.
240      * @return True if the operation was successful.
241      */
242     function finishMinting() public onlyOwner canMint returns (bool) {
243         mintingFinished = true;
244         MintFinished();
245         return true;
246     }
247 }
248 
249 
250 /**
251  * @title Burnable Token
252  * @dev Token that can be irreversibly burned (destroyed).
253  */
254 contract BurnableToken is BasicToken {
255 
256     event Burn(address indexed burner, uint256 value);
257 
258     /**
259      * @dev Burns a specific amount of tokens.
260      * @param _value The amount of token to be burned.
261      */
262     function burn(uint256 _value) public  {
263         require(_value <= balances[msg.sender]);
264         // no need to require value <= totalSupply, since that would imply the
265         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
266 
267         address burner = msg.sender;
268         balances[burner] = balances[burner].sub(_value);
269         totalSupply = totalSupply.sub(_value);
270         Burn(burner, _value);
271     }
272 }
273 
274 
275 /**
276  * @title Pausable
277  * @dev Base contract which allows children to implement an emergency stop mechanism.
278  */
279 
280 contract Pausable is Ownable {
281 
282 
283     event Pause();
284     event Unpause();
285 
286     bool public paused = true;
287 
288 
289     /**
290      * @dev Modifier to make a function callable only when the contract is not paused.
291      */
292     modifier whenNotPaused() {
293         require(!paused);
294         _;
295     }
296 
297     /**
298      * @dev Modifier to make a function callable only when the contract is paused.
299      */
300     modifier whenPaused() {
301         require(paused);
302         _;
303     }
304 
305     /**
306      * @dev called by the owner to pause, triggers stopped state
307      */
308     function pause() onlyOwner whenNotPaused public {
309         paused = true;
310         Pause();
311     }
312 
313     /**
314      * @dev called by the owner to unpause, returns to normal state
315      */
316     function unpause() onlyOwner whenPaused public {
317         paused = false;
318         Unpause();
319     }
320 }
321 
322 
323 
324 /* @title Pausable token
325  *
326  * @dev StandardToken modified with pausable transfers.
327  **/
328 
329 contract PausableToken is StandardToken, Pausable {
330 
331     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
332         return super.transfer(_to, _value);
333     }
334 
335     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
336         return super.transferFrom(_from, _to, _value);
337     }
338 
339     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
340         return super.approve(_spender, _value);
341     }
342 
343 }
344 
345 
346 /*
347  * Actual token contract
348  */
349 
350 contract AcjToken is BurnableToken, MintableToken, PausableToken {
351     using SafeMath for uint256;
352 
353     string public constant name = "Artist Connect Coin";
354     string public constant symbol = "ACJ";
355     uint public constant decimals = 18;
356     
357     function AcjToken() public {
358         totalSupply = 150000000 ether; 
359         balances[msg.sender] = totalSupply;
360         paused = true;
361     }
362 
363     function activate() external onlyOwner {
364         unpause();
365         finishMinting();
366     }
367 
368     // This method will be used by the crowdsale smart contract 
369     // that owns the AcjToken and will distribute 
370     // the tokens to the contributors
371     function initialTransfer(address _to, uint _value) external onlyOwner returns (bool) {
372         require(_to != address(0));
373         require(_value <= balances[msg.sender]);
374 
375         balances[msg.sender] = balances[msg.sender].sub(_value);
376         balances[_to] = balances[_to].add(_value);
377         Transfer(msg.sender, _to, _value);
378         return true;
379     }
380 
381     function burn(uint256 _amount) public onlyOwner {
382         super.burn(_amount);
383     }
384 
385 }
386 
387  
388 
389 
390 contract AcjCrowdsale is Ownable {
391 
392     using SafeMath for uint256;
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
404     // Absolute dates as timestamps
405     uint public startPresale;            
406     uint public endPresale;             
407     uint public startIco;              
408     uint public endIco;               
409     // 30 days refund period on fail
410     uint public constant REFUND_PERIOD = 30 days;
411     // Indicative token balances during the crowdsale 
412     mapping(address => uint256) public tokenBalances;    
413     // Token smart contract address
414     address public token;
415     // Total tokens created
416     uint256 public constant TOKENS_TOTAL_SUPPLY = 150000000 ether; 
417     // Tokens available for sale
418     uint256 public constant TOKENS_FOR_SALE = 75000000 ether;    
419     // soft cap in Tokens
420     uint256 public constant TOKENS_SOFT_CAP = 500000 ether;       
421     // Tokens sold via buyTokens
422     uint256 public tokensSold;                             
423     // Tokens created during the sale
424     uint256 public tokensDistributed;                                         
425     // ICO flat rate subject to bonuses
426     uint256 public ethTokenRate;                                 
427     // Allow multiple administrators
428     mapping(address => bool) public admins;                    
429     // Total wei received 
430     uint256 public weiReceived;                            
431     // Minimum contribution in ETH
432     uint256 public constant MIN_CONTRIBUTION = 100 finney;           
433     // Contributions in wei for each address
434     mapping(address => uint256) public contributions;
435     // Refund state for each address
436     mapping(address => bool) public refunds;
437     // Company wallet that will receive the ETH
438     address public companyWallet;     
439 
440     // Yoohoo someone contributed !
441     event Contribute(address indexed _from, uint _amount); 
442     // Token <> ETH rate updated
443     event TokenRateUpdated(uint _newRate);                  
444     // ETH Refund 
445     event Refunded(address indexed _from, uint _amount);    
446     
447     modifier belowTotalSupply {
448         require(tokensDistributed < TOKENS_TOTAL_SUPPLY);
449         _;
450     }
451 
452     modifier belowHardCap {
453         require(tokensDistributed < TOKENS_FOR_SALE);
454         _;
455     }
456 
457     modifier adminOnly {
458         require(msg.sender == owner || admins[msg.sender] == true);
459         _;
460     }
461 
462     modifier crowdsaleFailed {
463         require(isFailed());
464         _;
465     }
466 
467     modifier crowdsaleSuccess {
468         require(isSuccess());
469         _;
470     }
471 
472     modifier duringSale {
473         require(now < endIco);
474         require((now > startPresale && now < endPresale) || now > startIco);
475         _;
476     }
477 
478     modifier afterSale {
479         require(now > endIco);
480         _;
481     }
482 
483     modifier aboveMinimum {
484         require(msg.value >= MIN_CONTRIBUTION);
485         _;
486     }
487 
488     /* 
489      * Constructor
490      * Creating the new Token smart contract
491      * and setting its owner to the current sender
492      * 
493      */
494     function AcjCrowdsale(
495         uint _presaleStart,
496         uint _presaleEnd,
497         uint _icoStart,
498         uint _icoEnd,
499         uint256 _rate,
500         address _token
501     ) public 
502     {
503         require(_presaleEnd > _presaleStart);
504         require(_icoStart > _presaleEnd);
505         require(_icoEnd > _icoStart);
506         require(_rate > 0); 
507 
508         startPresale = _presaleStart;
509         endPresale = _presaleEnd;
510         startIco = _icoStart;
511         endIco = _icoEnd;
512         ethTokenRate = _rate;
513         
514         admins[msg.sender] = true;
515         companyWallet = msg.sender;
516 
517         token = _token;
518     }
519 
520     /*
521      * Fallback payable
522      */
523     function () external payable {
524         buyTokens(msg.sender);
525     }
526 
527     /* Crowdsale staff only */
528     /*
529      * Admin management
530      */
531     function addAdmin(address _adr) external onlyOwner {
532         require(_adr != address(0));
533         admins[_adr] = true;
534     }
535 
536     function removeAdmin(address _adr) external onlyOwner {
537         require(_adr != address(0));
538         admins[_adr] = false;
539     }
540 
541     /*
542      * Change the company wallet
543      */
544     function updateCompanyWallet(address _wallet) external adminOnly {
545         companyWallet = _wallet;
546     }
547 
548     /*
549      *  Change the owner of the token
550      */
551     function proposeTokenOwner(address _newOwner) external adminOnly {
552         AcjToken _token = AcjToken(token);
553         _token.proposeNewOwner(_newOwner);
554     }
555 
556     function acceptTokenOwnership() external onlyOwner {    
557         AcjToken _token = AcjToken(token);
558         _token.acceptOwnership();
559     }
560 
561     /*
562      * Activate the token
563      */
564     function activateToken() external adminOnly crowdsaleSuccess afterSale {
565         AcjToken _token = AcjToken(token);
566         _token.activate();
567     }
568 
569     /* 
570      * Adjust the token value before the ICO
571      */
572     function adjustTokenExchangeRate(uint _rate) external adminOnly {
573         require(now > endPresale && now < startIco);
574         ethTokenRate = _rate;
575         TokenRateUpdated(_rate);
576     }
577 
578     /* 
579      * Start therefund period
580      * Each contributor has to claim own  ETH 
581      */     
582     function refundContribution() external crowdsaleFailed afterSale {
583         require(!refunds[msg.sender]);
584         require(contributions[msg.sender] > 0);
585 
586         uint256 _amount = contributions[msg.sender];
587         tokenBalances[msg.sender] = 0;
588         refunds[msg.sender] = true;
589         Refunded(msg.sender, contributions[msg.sender]);
590         msg.sender.transfer(_amount);
591     }
592 
593     /*
594      * After the refund period, remaining tokens
595      * are transfered to the company wallet
596      * Allow withdrawal at any time if the ICO is a success.
597      */     
598     function withdrawUnclaimed() external adminOnly {
599         require(now > endIco + REFUND_PERIOD || isSuccess());
600         companyWallet.transfer(this.balance);
601     }
602 
603     /*
604      * Pre-ICO and offline Investors, collaborators and team tokens
605      */
606     function reserveTokens(address _beneficiary, uint256 _tokensQty) external adminOnly belowTotalSupply {
607         require(_beneficiary != address(0));
608         uint _distributed = tokensDistributed.add(_tokensQty);
609 
610         require(_distributed <= TOKENS_TOTAL_SUPPLY);
611 
612         tokenBalances[_beneficiary] = _tokensQty.add(tokenBalances[_beneficiary]);
613         tokensDistributed = _distributed;
614 
615         AcjToken _token = AcjToken(token);
616         _token.initialTransfer(_beneficiary, _tokensQty);
617     }
618 
619     /*
620      * Actually buy the tokens
621      * requires an active sale time
622      * and amount above the minimum contribution
623      * and sold tokens inferior to tokens for sale
624      */     
625     function buyTokens(address _beneficiary) public payable duringSale aboveMinimum belowHardCap {
626         require(_beneficiary != address(0));
627         uint256 _weiAmount = msg.value;        
628         uint256 _tokensQty = msg.value.mul(getBonus(_weiAmount));
629         uint256 _distributed = _tokensQty.add(tokensDistributed);
630         uint256 _sold = _tokensQty.add(tokensSold);
631 
632         require(_distributed <= TOKENS_TOTAL_SUPPLY);
633         require(_sold <= TOKENS_FOR_SALE);
634 
635         contributions[_beneficiary] = _weiAmount.add(contributions[_beneficiary]);
636         tokenBalances[_beneficiary] = _tokensQty.add(tokenBalances[_beneficiary]);
637         weiReceived = weiReceived.add(_weiAmount);
638         tokensDistributed = _distributed;
639         tokensSold = _sold;
640 
641         Contribute(_beneficiary, msg.value);
642 
643         AcjToken _token = AcjToken(token);
644         _token.initialTransfer(_beneficiary, _tokensQty);
645     }
646 
647     /*
648      * Crowdsale Helpers 
649      */
650     function hasEnded() public view returns(bool) {
651         return now > endIco;
652     }
653 
654     /*
655      * Checks if the crowdsale is a success
656      */
657     function isSuccess() public view returns(bool) {
658         if (tokensDistributed >= TOKENS_SOFT_CAP) {
659             return true;
660         }
661         return false;
662     }
663 
664     /*
665      * Checks if the crowdsale failed
666      */
667     function isFailed() public view returns(bool) {
668         if (tokensDistributed < TOKENS_SOFT_CAP && now > endIco) {
669             return true;
670         }
671         return false;
672     }
673 
674     /* 
675      * Bonus calculations
676      * Either time or ETH quantity based 
677      */
678     function getBonus(uint256 _wei) internal constant returns(uint256 ethToAcj) {
679         uint256 _bonus = 0;
680 
681         // Time based bonus
682         if (endPresale > now) {
683             _bonus = _bonus.add(BONUS_PRESALE); 
684         }
685 
686         // ETH Quantity based bonus
687         if (_wei >= BONUS_HI_QTY) { 
688             _bonus = _bonus.add(BONUS_HI);
689         } else if (_wei >= BONUS_MID_QTY) {
690             _bonus = _bonus.add(BONUS_MID);
691         }
692 
693         return ethTokenRate.mul(100 + _bonus) / 100;
694     }
695 
696 }