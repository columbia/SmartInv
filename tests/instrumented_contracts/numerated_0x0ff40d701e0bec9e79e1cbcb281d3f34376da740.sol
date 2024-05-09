1 pragma solidity ^0.4.19;
2 //
3 /* CONTRACT */
4 
5 contract SafeMath {
6     function safeAdd(uint a, uint b) internal pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function safeSub(uint a, uint b) internal pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function safeMul(uint a, uint b) internal pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function safeDiv(uint a, uint b) internal pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
22 }
23 // END_OF_contract_SafeMath
24 //_________________________________________________________
25 //
26 /* INTERFACES */
27 //
28 interface tokenRecipient {
29 	
30 	function receiveApproval(address _from, uint256 _tokenAmountApproved, address tokenMacroansy, bytes _extraData) public returns(bool success); 
31 }   
32 //________________________________________________________
33 //
34     interface ICO {
35 
36         function buy( uint payment, address buyer, bool isPreview) public returns(bool success, uint amount);
37         function redeemCoin(uint256 amount, address redeemer, bool isPreview) public returns (bool success, uint redeemPayment);
38         function sell(uint256 amount, address seller, bool isPreview) public returns (bool success, uint sellPayment );
39         function paymentAction(uint paymentValue, address beneficiary, uint paytype) public returns(bool success);
40 
41         function recvShrICO( address _spender, uint256 _value, uint ShrID)  public returns (bool success);
42         function burn( uint256 value, bool unburn, uint totalSupplyStart, uint balOfOwner)  public returns( bool success);
43 
44         function getSCF() public returns(uint seriesCapFactorMulByTenPowerEighteen);
45         function getMinBal() public returns(uint minBalForAccnts_ );
46         function getAvlShares(bool show) public  returns(uint totalSupplyOfCoinsInSeriesNow, uint coinsAvailableForSale, uint icoFunding);
47     }
48 //_______________________________________________________ 
49 //
50     interface Exchg{
51         
52         function sell_Exchg_Reg( uint amntTkns, uint tknPrice, address seller) public returns(bool success);
53         function buy_Exchg_booking( address seller, uint amntTkns, uint tknPrice, address buyer, uint payment ) public returns(bool success);
54         function buy_Exchg_BkgChk( address seller, uint amntTkns, uint tknPrice, address buyer, uint payment) public returns(bool success);
55         function updateSeller( address seller, uint tknsApr, address buyer, uint payment) public returns(bool success);  
56 
57         function getExchgComisnMulByThousand() public returns(uint exchgCommissionMulByThousand_);  
58 
59         function viewSellOffersAtExchangeMacroansy(address seller, bool show) view public returns (uint sellersCoinAmountOffer, uint sellersPriceOfOneCoinInWEI, uint sellerBookedTime, address buyerWhoBooked, uint buyPaymentBooked, uint buyerBookedTime, uint exchgCommissionMulByThousand_);
60     }
61 //_________________________________________________________
62 
63 // ERC Token Standard #20 Interface
64 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
65 
66 /* CONTRACT */
67 //
68     contract TokenERC20Interface {
69 
70         function totalSupply() public constant returns (uint coinLifeTimeTotalSupply);
71         function balanceOf(address tokenOwner) public constant returns (uint coinBalance);
72         function allowance(address tokenOwner, address spender) public constant returns (uint coinsRemaining);
73         function transfer(address to, uint tokens) public returns (bool success);
74         function approve(address spender, uint tokens) public returns (bool success);
75         function transferFrom(address _from, address to, uint tokens) public returns (bool success);
76         event Transfer(address indexed _from, address indexed to, uint tokens);
77         event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
78     }
79 //END_OF_contract_ERC20Interface 
80 //_________________________________________________________________
81 /* CONTRACT */
82 /**
83 * COPYRIGHT Macroansy 
84 * http://www.macroansy.org
85 */
86 contract TokenMacroansy is TokenERC20Interface, SafeMath { 
87     
88     string public name;
89     string public symbol;
90     uint8 public decimals = 18;
91     //
92     address internal owner; 
93     address private  beneficiaryFunds;
94     //
95     uint256 public totalSupply;
96     uint256 internal totalSupplyStart;
97     //
98     mapping (address => uint256) public balanceOf;
99     mapping (address => mapping (address => uint256)) public allowance;
100     mapping( address => bool) internal frozenAccount;
101     //
102     mapping(address => uint) private msgSndr;
103     //
104     address tkn_addr; address ico_addr; address exchg_addr;
105     //
106     uint256 internal allowedIndividualShare;
107     uint256 internal allowedPublicShare;
108 //
109     //uint256 internal allowedFounderShare;
110     //uint256 internal allowedPOOLShare;
111     //uint256 internal allowedVCShare;
112     //uint256 internal allowedColdReserve;
113 //_________________________________________________________
114 
115     event Transfer(address indexed from, address indexed to, uint256 value);    
116     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
117     event Burn(address indexed from, uint amount);
118     event UnBurn(address indexed from, uint amount);
119     event FundOrPaymentTransfer(address beneficiary, uint amount); 
120     event FrozenFunds(address target, bool frozen);
121     event BuyAtMacroansyExchg(address buyer, address seller, uint tokenAmount, uint payment);
122 //_________________________________________________________
123 //
124 //CONSTRUCTOR
125     /* Initializes contract with initial supply tokens to the creator of the contract 
126     */
127     function TokenMacroansy()  public {
128         
129         owner = msg.sender;
130         beneficiaryFunds = owner;
131         //totalSupplyStart = initialSupply * 10** uint256(decimals);  
132         totalSupplyStart = 3999 * 10** uint256(decimals);     
133         totalSupply = totalSupplyStart; 
134         //
135         balanceOf[msg.sender] = totalSupplyStart;    
136         Transfer(address(0), msg.sender, totalSupplyStart);
137         //                 
138         name = "TokenMacroansy";  
139         symbol = "$BEE";
140         //  
141         allowedIndividualShare = uint(1)*totalSupplyStart/100; 
142         allowedPublicShare = uint(20)* totalSupplyStart/100;     
143         //
144         //allowedFounderShare = uint(20)*totalSupplyStart/100; 
145         //allowedPOOLShare = uint(9)* totalSupplyStart/100; 
146         //allowedColdReserve = uint(41)* totalSupplyStart/100;
147         //allowedVCShare =  uint(10)* totalSupplyStart/100;  
148     } 
149 //_________________________________________________________
150 
151     modifier onlyOwner {
152         require(msg.sender == owner);
153         _;
154     } 
155     function wadmin_transferOr(address _Or) public onlyOwner {
156         owner = _Or;
157     }          
158 //_________________________________________________________
159    /**
160      * @notice Show the `totalSupply` for this Token contract
161      */
162     function totalSupply() constant public returns (uint coinLifeTimeTotalSupply) {
163         return totalSupply ;   
164     }  
165 //_________________________________________________________
166    /**
167      * @notice Show the `tokenOwner` balances for this contract
168      * @param tokenOwner the token owners address
169      */
170     function balanceOf(address tokenOwner) constant public  returns (uint coinBalance) {
171         return balanceOf[tokenOwner];
172     } 
173 //_________________________________________________________
174    /**
175      * @notice Show the allowance given by `tokenOwner` to the `spender`
176      * @param tokenOwner the token owner address allocating allowance
177      * @param spender the allowance spenders address
178      */
179     function allowance(address tokenOwner, address spender) constant public returns (uint coinsRemaining) {
180         return allowance[tokenOwner][spender];
181     }
182 //_________________________________________________________
183 //
184     function wadmin_setContrAddr(address icoAddr, address exchAddr ) public onlyOwner returns(bool success){
185        tkn_addr = this; ico_addr = icoAddr; exchg_addr = exchAddr;
186        return true;
187     }          
188     //
189     function _getTknAddr() internal  returns(address tkn_ma_addr){  return(tkn_addr); }
190     function _getIcoAddr() internal  returns(address ico_ma_addr){  return(ico_addr); } 
191     function _getExchgAddr() internal returns(address exchg_ma_addr){ return(exchg_addr); } 
192     // _getTknAddr(); _getIcoAddr(); _getExchgAddr();  
193     //  address tkn_addr; address ico_addr; address exchg_addr;
194 //_________________________________________________________
195 //
196     /* Internal transfer, only can be called by this contract */
197     //
198     function _transfer(address _from, address _to, uint _value) internal  {
199         require (_to != 0x0);                                       
200         require(!frozenAccount[_from]);                             
201         require(!frozenAccount[_to]);                               
202         uint valtmp = _value;
203         uint _valueA = valtmp;
204         valtmp = 0;                       
205         require (balanceOf[_from] >= _valueA);                       
206         require (balanceOf[_to] + _valueA > balanceOf[_to]);                   
207         uint previousBalances = balanceOf[_from] + balanceOf[_to];                               
208         balanceOf[_from] = safeSub(balanceOf[_from], _valueA);                                  
209         balanceOf[_to] = safeAdd(balanceOf[_to], _valueA); 
210         Transfer(_from, _to, _valueA);
211         _valueA = 0;
212         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);       
213     }
214 //________________________________________________________
215     /**
216      * Transfer tokens
217      *
218      * @notice Allows to Send Coins to other accounts
219      * @param _to The address of the recipient of coins
220      * @param _value The amount of coins to send
221      */
222      function transfer(address _to, uint256 _value) public returns(bool success) {
223 
224         //check sender and receiver allw limits in accordance with ico contract
225         bool sucsSlrLmt = _chkSellerLmts( msg.sender, _value);
226         bool sucsByrLmt = _chkBuyerLmts( _to, _value);
227         require(sucsSlrLmt == true && sucsByrLmt == true);
228         //
229         uint valtmp = _value;    
230         uint _valueTemp = valtmp; 
231         valtmp = 0;                 
232         _transfer(msg.sender, _to, _valueTemp);
233         _valueTemp = 0;
234         return true;      
235     }  
236 //_________________________________________________________
237     /**
238      * Transfer tokens from other address
239      *
240      * @notice sender can set an allowance for another contract, 
241      * @notice and the other contract interface function receiveApproval 
242      * @notice can call this funtion for token as payment and add further coding for service.
243      * @notice please also refer to function approveAndCall
244      * @notice Send `_value` tokens to `_to` on behalf of `_from`
245      * @param _from The address of the sender
246      * @param _to The address of the recipient of coins
247      * @param _value The amount coins to send
248      */
249     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
250         
251         uint valtmp = _value;
252         uint _valueA = valtmp;
253         valtmp = 0;
254         require(_valueA <= allowance[_from][msg.sender]);     
255         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _valueA);
256         _transfer(_from, _to, _valueA);
257         _valueA = 0;
258         return true;
259     }
260 //_________________________________________________________
261     /**
262      * Set allowance for other address
263      *
264      * @notice Allows `_spender` to spend no more than `_value` coins from your account
265      * @param _spender The address authorized to spend
266      * @param _value The max amount of coins allocated to spender
267      */
268     function approve(address _spender, uint256 _value) public returns (bool success) {
269         
270         //check sender and receiver allw limits in accordance with ico contract
271         bool sucsSlrLmt = _chkSellerLmts( msg.sender, _value);
272         bool sucsByrLmt = _chkBuyerLmts( _spender, _value);
273         require(sucsSlrLmt == true && sucsByrLmt == true);
274         //
275         uint valtmp = _value;
276         uint _valueA = valtmp;
277         valtmp = 0;         
278         allowance[msg.sender][_spender] = _valueA;
279         Approval(msg.sender, _spender, _valueA);
280          _valueA =0;
281         return true;
282     }
283 //_________________________________________________________
284     /**
285      * Set allowance for other address and notify
286      *
287      * Allows `_spender` to spend no more than `_value` coins in from your account
288      *
289      * @param _spender The address authorized to spend
290      * @param _value the max amount of coins the spender can spend
291      * @param _extraData some extra information to send to the spender contracts
292      */
293     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
294         
295         tokenRecipient spender = tokenRecipient(_spender);
296         uint valtmp = _value;
297         uint _valueA = valtmp;
298         valtmp = 0;         
299         if (approve(_spender, _valueA)) {           
300             spender.receiveApproval(msg.sender, _valueA, this, _extraData);            
301         }
302         _valueA = 0; 
303         return true;
304     }
305 //_________________________________________________________
306 //
307     /**
308     * @notice `freeze` Prevent | Allow` `target` from sending & receiving tokens
309     * @param target Address to be frozen
310     * @param freeze either to freeze it or not
311     */
312     function wadmin_freezeAccount(address target, bool freeze) onlyOwner public returns(bool success) {
313         frozenAccount[target] = freeze;      
314         FrozenFunds(target, freeze);
315         return true;
316     }
317 //________________________________________________________
318 //
319     function _safeTransferTkn( address _from, address _to, uint amount) internal returns(bool sucsTrTk){
320           
321           uint tkA = amount;
322           uint tkAtemp = tkA;
323           tkA = 0;
324                    _transfer(_from, _to, tkAtemp); 
325           tkAtemp = 0;
326           return true;
327     }      
328 //_________________________________________________________
329 //
330     function _safeTransferPaymnt( address paymentBenfcry, uint payment) internal returns(bool sucsTrPaymnt){
331               
332           uint pA = payment; 
333           uint paymentTemp = pA;
334           pA = 0;
335                   paymentBenfcry.transfer(paymentTemp); 
336           FundOrPaymentTransfer(paymentBenfcry, paymentTemp);                       
337           paymentTemp = 0; 
338           
339           return true;
340     }
341 //_________________________________________________________
342 //
343     function _safePaymentActionAtIco( uint payment, address paymentBenfcry, uint paytype) internal returns(bool success){
344               
345     // payment req to ico
346           uint Pm = payment;
347           uint PmTemp = Pm;
348           Pm = 0;  
349           ICO ico = ICO(_getIcoAddr());       
350           // paytype 1 for redeempayment and 2 for sell payment
351           bool pymActSucs = ico.paymentAction( PmTemp, paymentBenfcry, paytype);
352           require(pymActSucs ==  true);
353           PmTemp = 0;
354           
355           return true;
356     }
357 
358 //_________________________________________________________
359     /* @notice Allows to Buy ICO tokens directly from this contract by sending ether
360     */
361     function buyCoinsAtICO() payable public returns(bool success) { 
362 
363         msgSndr[msg.sender] = msg.value;
364 
365         ICO ico = ICO(_getIcoAddr() );
366 
367         require(  msg.value > 0 );
368         
369         // buy exe at ico
370         bool icosuccess;  uint tknsBuyAppr;        
371         (icosuccess, tknsBuyAppr) = ico.buy( msg.value, msg.sender, false);        
372                 require( icosuccess == true );
373         
374         // tkn transfer
375         bool sucsTrTk =  _safeTransferTkn( owner, msg.sender, tknsBuyAppr);
376         require(sucsTrTk == true);
377 
378         msgSndr[msg.sender] = 0;
379 
380         return (true) ;
381     }     
382 //_____________________________________________________________
383 //
384     /* @notice Allows anyone to preview a Buy of ICO tokens before an actual buy
385     */
386 
387     function buyCoinsPreview(uint myProposedPaymentInWEI) public view returns(bool success, uint tokensYouCanBuy, uint yourSafeMinBalReqdInWEI) { 
388         
389         uint payment = myProposedPaymentInWEI;
390        
391         msgSndr[msg.sender] = payment;  
392         success = false;
393         
394         ICO ico = ICO(_getIcoAddr() );
395 
396         tokensYouCanBuy = 0;
397         bool icosuccess;            
398         (icosuccess, tokensYouCanBuy) = ico.buy( payment, msg.sender, true);        
399 
400         msgSndr[msg.sender] = 0;
401 
402         return ( icosuccess, tokensYouCanBuy, ico.getMinBal()) ;
403     }
404 //_____________________________________________________________
405      /**
406      *  @notice Allows Token owners to Redeem Tokens to this Contract for its value promised
407      */
408     function redeemCoinsToICO( uint256 amountOfCoinsToRedeem) public returns (bool success ) {
409 
410     uint amount = amountOfCoinsToRedeem;
411 
412     msgSndr[msg.sender] = amount;  
413       bool isPreview = false;
414 
415       ICO ico = ICO(_getIcoAddr());
416 
417       // redeem exe at ico
418       bool icosuccess ; uint redeemPaymentValue;
419       (icosuccess , redeemPaymentValue) = ico.redeemCoin( amount, msg.sender, isPreview);
420       require( icosuccess == true);  
421 
422       require( _getIcoAddr().balance >= safeAdd( ico.getMinBal() , redeemPaymentValue) );
423 
424       bool sucsTrTk = false; bool pymActSucs = false;
425       if(isPreview == false) {
426 
427         // transfer tkns
428         sucsTrTk =  _safeTransferTkn( msg.sender, owner, amount);
429         require(sucsTrTk == true);        
430 
431         // payment req to ico  1 for redeempayment and 2 for sell payment         
432       msgSndr[msg.sender] = redeemPaymentValue;
433         pymActSucs = _safePaymentActionAtIco( redeemPaymentValue, msg.sender, 1);
434         require(pymActSucs ==  true);
435       } 
436 
437     msgSndr[msg.sender] = 0;  
438 
439       return (true);        
440     } 
441 //_________________________________________________________
442     /**
443      *  @notice Allows Token owners to Sell Tokens directly to this Contract
444      *
445      */    
446      function sellCoinsToICO( uint256 amountOfCoinsToSell ) public returns (bool success ) {
447 
448       uint amount = amountOfCoinsToSell;
449 
450       msgSndr[msg.sender] = amount;  
451         bool isPreview = false;
452 
453         ICO ico = ICO(_getIcoAddr() );
454 
455         // sell exe at ico
456         bool icosuccess; uint sellPaymentValue; 
457         ( icosuccess ,  sellPaymentValue) = ico.sell( amount, msg.sender, isPreview);
458         require( icosuccess == true );
459 
460         require( _getIcoAddr().balance >= safeAdd(ico.getMinBal() , sellPaymentValue) );
461 
462         bool sucsTrTk = false; bool pymActSucs = false;
463         if(isPreview == false){
464 
465           // token transfer
466           sucsTrTk =  _safeTransferTkn( msg.sender, owner,  amount);
467           require(sucsTrTk == true);
468 
469           // payment request to ico  1 for redeempayment and 2 for sell payment
470         msgSndr[msg.sender] = sellPaymentValue;
471           pymActSucs = _safePaymentActionAtIco( sellPaymentValue, msg.sender, 2);
472           require(pymActSucs ==  true);
473         }
474 
475       msgSndr[msg.sender] = 0;
476 
477         return ( true);                
478     }
479 //________________________________________________________
480     /**
481     * @notice a sellers allowed limits in holding ico tokens is checked
482     */
483     //
484     function _chkSellerLmts( address seller, uint amountOfCoinsSellerCanSell) internal returns(bool success){   
485 
486       uint amountTkns = amountOfCoinsSellerCanSell; 
487       success = false;
488       ICO ico = ICO( _getIcoAddr() );
489       uint seriesCapFactor = ico.getSCF();
490 
491       if( amountTkns <= balanceOf[seller]  &&  balanceOf[seller] <=  safeDiv(allowedIndividualShare*seriesCapFactor,10**18) ){
492         success = true;
493       }
494       return success;
495     }
496     // bool sucsSlrLmt = _chkSellerLmts( address seller, uint amountTkns);
497 //_________________________________________________________    
498 //
499     /**
500     * @notice a buyers allowed limits in holding ico tokens is checked 
501     */
502     function _chkBuyerLmts( address buyer, uint amountOfCoinsBuyerCanBuy)  internal  returns(bool success){
503 
504     	uint amountTkns = amountOfCoinsBuyerCanBuy;
505         success = false;
506         ICO ico = ICO( _getIcoAddr() );
507         uint seriesCapFactor = ico.getSCF();
508 
509         if( amountTkns <= safeSub( safeDiv(allowedIndividualShare*seriesCapFactor,10**18), balanceOf[buyer] )) {
510           success = true;
511         } 
512         return success;        
513     }
514 //_________________________________________________________
515 //
516     /**
517     * @notice a buyers allowed limits in holding ico tokens along with financial capacity to buy is checked
518     */
519     function _chkBuyerLmtsAndFinl( address buyer, uint amountTkns, uint priceOfr) internal returns(bool success){
520        
521        success = false;
522 
523       // buyer limits
524        bool sucs1 = false; 
525        sucs1 = _chkBuyerLmts( buyer, amountTkns);
526 
527       // buyer funds
528        ICO ico = ICO( _getIcoAddr() );
529        bool sucs2 = false;
530        if( buyer.balance >=  safeAdd( safeMul(amountTkns , priceOfr) , ico.getMinBal() )  )  sucs2 = true;
531        if( sucs1 == true && sucs2 == true)  success = true;   
532 
533        return success;
534     }
535 //_________________________________________________________
536 //
537      function _slrByrLmtChk( address seller, uint amountTkns, uint priceOfr, address buyer) internal returns(bool success){
538      
539       // seller limits check
540         bool successSlrl; 
541         (successSlrl) = _chkSellerLmts( seller, amountTkns); 
542 
543       // buyer limits check
544         bool successByrlAFinl;
545         (successByrlAFinl) = _chkBuyerLmtsAndFinl( buyer, amountTkns, priceOfr);
546         
547         require( successSlrl == true && successByrlAFinl == true);
548 
549         return true;
550     }
551 //___________________________________________________________________
552     /**
553     * @notice allows a seller to formally register his sell offer at ExchangeMacroansy
554     */
555       function sellBkgAtExchg( uint amountOfCoinsOffer, uint priceOfOneCoinInWEI) public returns(bool success){
556 
557         uint amntTkns = amountOfCoinsOffer ;
558         uint tknPrice = priceOfOneCoinInWEI;
559       
560         // seller limits
561         bool successSlrl;
562         (successSlrl) = _chkSellerLmts( msg.sender, amntTkns); 
563         require(successSlrl == true);
564 
565       msgSndr[msg.sender] = amntTkns;  
566 
567       // bkg registration at exchange
568 
569         Exchg em = Exchg(_getExchgAddr());
570 
571         bool  emsuccess; 
572         (emsuccess) = em.sell_Exchg_Reg( amntTkns, tknPrice, msg.sender );
573         require(emsuccess == true );
574             
575       msgSndr[msg.sender] = 0;
576 
577         return true;         
578     }
579 //_________________________________________________________ 
580 //    
581     /**
582     * @notice function for booking and locking for a buy with respect to a sale offer registered
583     * @notice after booking then proceed for payment using func buyCoinsAtExchg 
584     * @notice payment booking value and actual payment value should be exact
585     */  
586       function buyBkgAtExchg( address seller, uint sellersCoinAmountOffer, uint sellersPriceOfOneCoinInWEI, uint myProposedPaymentInWEI) public returns(bool success){ 
587         
588         uint amountTkns = sellersCoinAmountOffer;
589         uint priceOfr = sellersPriceOfOneCoinInWEI;
590         uint payment = myProposedPaymentInWEI;         
591     
592       msgSndr[msg.sender] = amountTkns;
593 
594         // seller buyer limits check
595         bool sucsLmt = _slrByrLmtChk( seller, amountTkns, priceOfr, msg.sender);
596         require(sucsLmt == true);
597 
598         // booking at exchange
599      
600         Exchg em = Exchg(_getExchgAddr()); 
601 
602         bool emBkgsuccess;
603         (emBkgsuccess)= em.buy_Exchg_booking( seller, amountTkns, priceOfr, msg.sender, payment);
604             require( emBkgsuccess == true );
605 
606       msgSndr[msg.sender] = 0;  
607 
608         return true;        
609     }
610 //________________________________________________________
611 
612     /**
613     * @notice for buyingCoins at ExchangeMacroansy 
614     * @notice please first book the buy through function_buy_Exchg_booking
615     */
616    // function buyCoinsAtExchg( address seller, uint amountTkns, uint priceOfr) payable public returns(bool success) {
617 
618     function buyCoinsAtExchg( address seller, uint sellersCoinAmountOffer, uint sellersPriceOfOneCoinInWEI) payable public returns(bool success) {
619        
620         uint amountTkns = sellersCoinAmountOffer;
621         uint priceOfr = sellersPriceOfOneCoinInWEI;	       
622         require( msg.value > 0 && msg.value <= safeMul(amountTkns, priceOfr ) );
623 
624       msgSndr[msg.sender] = amountTkns;
625 
626         // calc tokens that can be bought  
627   
628         uint tknsBuyAppr = safeDiv(msg.value , priceOfr);
629 
630         // check buyer booking at exchange
631   
632         Exchg em = Exchg(_getExchgAddr()); 
633         
634         bool sucsBkgChk = em.buy_Exchg_BkgChk(seller, amountTkns, priceOfr, msg.sender, msg.value); 
635         require(sucsBkgChk == true);
636 
637        // update seller reg and buyer booking at exchange
638 
639       msgSndr[msg.sender] = tknsBuyAppr;  
640  
641         bool emUpdateSuccess;
642         (emUpdateSuccess) = em.updateSeller(seller, tknsBuyAppr, msg.sender, msg.value); 
643         require( emUpdateSuccess == true );
644         
645        // token transfer in this token contract
646 
647         bool sucsTrTkn = _safeTransferTkn( seller, msg.sender, tknsBuyAppr);
648         require(sucsTrTkn == true);
649 
650         // payment to seller        
651         bool sucsTrPaymnt;
652         sucsTrPaymnt = _safeTransferPaymnt( seller,  safeSub( msg.value , safeDiv(msg.value*em.getExchgComisnMulByThousand(),1000) ) );
653         require(sucsTrPaymnt == true );
654        //  
655         BuyAtMacroansyExchg(msg.sender, seller, tknsBuyAppr, msg.value); //event
656 
657       msgSndr[msg.sender] = 0; 
658         
659         return true;
660     } 
661 //___________________________________________________________
662 
663    /**
664      * @notice Fall Back Function, not to receive ether directly and/or accidentally
665      *
666      */
667     function () public payable {
668         if(msg.sender != owner) revert();
669     }
670 //_________________________________________________________
671 
672     /*
673     * @notice Burning tokens ie removing tokens from the formal total supply
674     */
675     function wadmin_burn( uint256 value, bool unburn) onlyOwner public returns( bool success ) { 
676 
677         msgSndr[msg.sender] = value;
678          ICO ico = ICO( _getIcoAddr() );
679             if( unburn == false) {
680 
681                 balanceOf[owner] = safeSub( balanceOf[owner] , value);
682                 totalSupply = safeSub( totalSupply, value);
683                 Burn(owner, value);
684 
685             }
686             if( unburn == true) {
687 
688                 balanceOf[owner] = safeAdd( balanceOf[owner] , value);
689                 totalSupply = safeAdd( totalSupply , value);
690                 UnBurn(owner, value);
691 
692             }
693         
694         bool icosuccess = ico.burn( value, unburn, totalSupplyStart, balanceOf[owner] );
695         require( icosuccess == true);             
696         
697         return true;                     
698     }
699 //_________________________________________________________
700     /*
701     * @notice Withdraw Payments to beneficiary 
702     * @param withdrawAmount the amount withdrawn in wei
703     */
704     function wadmin_withdrawFund(uint withdrawAmount) onlyOwner public returns(bool success) {
705       
706         success = _withdraw(withdrawAmount);          
707         return success;      
708     }   
709 //_________________________________________________________
710      /*internal function can called by this contract only
711      */
712     function _withdraw(uint _withdrawAmount) internal returns(bool success) {
713 
714         bool sucsTrPaymnt = _safeTransferPaymnt( beneficiaryFunds, _withdrawAmount); 
715         require(sucsTrPaymnt == true);         
716         return true;     
717     }
718 //_________________________________________________________
719     /**
720      *  @notice Allows to receive coins from Contract Share approved by contract
721      *  @notice to receive the share, it has to be already approved by the contract
722      *  @notice the share Id will be provided by contract while payments are made through other channels like paypal
723      *  @param amountOfCoinsToReceive the allocated allowance of coins to be transferred to you   
724      *  @param  ShrID  1 is FounderShare, 2 is POOLShare, 3 is ColdReserveShare, 4 is VCShare, 5 is PublicShare, 6 is RdmSellPool
725      */ 
726     function receiveICOcoins( uint256 amountOfCoinsToReceive, uint ShrID )  public returns (bool success){ 
727 
728       msgSndr[msg.sender] = amountOfCoinsToReceive;
729         ICO ico = ICO( _getIcoAddr() );
730         bool  icosuccess;  
731         icosuccess = ico.recvShrICO(msg.sender, amountOfCoinsToReceive, ShrID ); 
732         require (icosuccess == true);
733 
734         bool sucsTrTk;
735         sucsTrTk =  _safeTransferTkn( owner, msg.sender, amountOfCoinsToReceive);
736         require(sucsTrTk == true);
737 
738       msgSndr[msg.sender] = 0;
739 
740         return  true;
741     }
742 //_______________________________________________________
743 //  called by other contracts
744     function sendMsgSndr(address caller, address origin) public returns(bool success, uint value){
745         
746         (success, value) = _sendMsgSndr(caller, origin);        
747          return(success, value);  
748     }
749 //_______________________________________________________
750 //
751     function _sendMsgSndr(address caller,  address origin) internal returns(bool success, uint value){ 
752        
753         require(caller == _getIcoAddr() || caller == _getExchgAddr()); 
754           //require(origin == tx.origin);          
755         return(true, msgSndr[origin]);  
756     }
757 //_______________________________________________________
758 //
759     function a_viewSellOffersAtExchangeMacroansy(address seller, bool show) view public returns (uint sellersCoinAmountOffer, uint sellersPriceOfOneCoinInWEI, uint sellerBookedTime, address buyerWhoBooked, uint buyPaymentBooked, uint buyerBookedTime, uint exchgCommissionMulByThousand_){
760 
761       if(show == true){
762 
763           Exchg em = Exchg(_getExchgAddr()); 
764          
765         ( sellersCoinAmountOffer,  sellersPriceOfOneCoinInWEI,  sellerBookedTime,  buyerWhoBooked,  buyPaymentBooked,  buyerBookedTime, exchgCommissionMulByThousand_) = em.viewSellOffersAtExchangeMacroansy( seller, show) ; 
766 
767         return ( sellersCoinAmountOffer,  sellersPriceOfOneCoinInWEI,  sellerBookedTime,  buyerWhoBooked,  buyPaymentBooked,  buyerBookedTime, exchgCommissionMulByThousand_);
768       }
769     }
770 //_________________________________________________________
771 //
772 	function a_viewCoinSupplyAndFunding(bool show) public view returns(uint totalSupplyOfCoinsInSeriesNow, uint coinsAvailableForSale, uint icoFunding){
773 
774 	    if(show == true){
775 	      ICO ico = ICO( _getIcoAddr() );
776 
777 	      ( totalSupplyOfCoinsInSeriesNow, coinsAvailableForSale, icoFunding) = ico.getAvlShares(show);
778 
779 	      return( totalSupplyOfCoinsInSeriesNow, coinsAvailableForSale, icoFunding);
780 	    }
781 	}
782 //_______________________________________________________
783 //
784 			/*
785 			bool private isEndOk;
786 				function endOfRewards(bool isEndNow) public onlyOwner {
787 
788 						isEndOk == isEndNow;
789 				}
790 				function endOfRewardsConfirmed(bool isEndNow) public onlyOwner{
791 
792 					if(isEndOk == true && isEndNow == true) selfdestruct(owner);
793 				}
794 			*/
795 //_______________________________________________________
796 }
797 // END_OF_CONTRACT