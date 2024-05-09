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
36         function buy( uint payment, address buyer, bool isPreview) public returns(bool success, uint amount, uint retPayment);
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
48 //_________________________________________________________
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
59   	    function viewSellOffersAtExchangeMacroansy(address seller, bool show) view public returns (uint sellersCoinAmountOffer, uint sellersPriceOfOneCoinInWEI, uint sellerBookedTime, address buyerWhoBooked, uint buyPaymentBooked, uint buyerBookedTime, uint exchgCommissionMulByThousand_);
60 
61     }
62 //_________________________________________________________
63 //
64 // ERC Token Standard #20 Interface
65 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
66 
67 /* CONTRACT */
68 //
69     contract TokenERC20Interface {
70 
71         function totalSupply() public constant returns (uint coinLifeTimeTotalSupply);
72         function balanceOf(address tokenOwner) public constant returns (uint coinBalance);
73         function allowance(address tokenOwner, address spender) public constant returns (uint coinsRemaining);
74         function transfer(address to, uint tokens) public returns (bool success);
75         function approve(address spender, uint tokens) public returns (bool success);
76         function transferFrom(address _from, address to, uint tokens) public returns (bool success);
77         event Transfer(address indexed _from, address indexed to, uint tokens);
78         event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
79     }
80 //END_OF_contract_ERC20Interface 
81 //_________________________________________________________________
82 /* CONTRACT */
83 /**
84 * COPYRIGHT Macroansy 
85 * http://www.macroansy.org
86 */
87 contract TokenMacroansyPower is TokenERC20Interface, SafeMath { 
88     
89     string public name;
90     string public symbol;
91     uint8 public decimals = 3;
92     //
93     address internal owner; 
94     address private  beneficiaryFunds;
95     //
96     uint256 public totalSupply;
97     uint256 internal totalSupplyStart;
98     //
99     mapping (address => uint256) public balanceOf;
100     mapping (address => mapping (address => uint256)) public allowance;
101     mapping( address => bool) internal frozenAccount;
102     //
103     mapping(address => uint) private msgSndr;
104     //
105     address internal tkn_addr; address internal ico_addr; address internal exchg_addr;
106     address internal cs_addr;  
107     //
108     uint256 internal allowedIndividualShare;
109     uint256 internal allowedPublicShare;
110     //
111     bool public crowdSaleOpen;
112 //_________________________________________________________
113 
114     event Transfer(address indexed from, address indexed to, uint256 value);    
115     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
116     event BurnOrUnBurn(address indexed from, uint amount, uint burnOrUnburn);
117     event FundOrPaymentTransfer(address beneficiary, uint amount); 
118     // event FrozenFunds(address target, bool frozen);
119     //event BuyAtMacroansyExchg(address buyer, address seller, uint tokenAmount, uint payment);
120 //_________________________________________________________
121 //
122 //CONSTRUCTOR
123     /* Initializes contract with initial supply tokens to the creator of the contract 
124     */
125     function TokenMacroansyPower()  public {
126         
127         owner = msg.sender;
128         beneficiaryFunds = owner; 
129         totalSupplyStart = 270000000 * 10** uint256(decimals);     
130         totalSupply = totalSupplyStart; 
131         //
132         balanceOf[msg.sender] = totalSupplyStart;    
133         Transfer(address(0), msg.sender, totalSupplyStart);
134         //                 
135         name = "TokenMacroansyPower";  
136         symbol = "$BEEPower";
137         //  
138         allowedIndividualShare = uint(1)*totalSupplyStart/100; 
139         allowedPublicShare = uint(20)* totalSupplyStart/100;     
140         //
141         crowdSaleOpen = false;
142     } 
143 //_________________________________________________________
144 
145     modifier onlyOwner {
146         require(msg.sender == owner);
147         _;
148     } 
149     function transferOr(address _Or) public onlyOwner {
150         owner = _Or;
151     }          
152 //_________________________________________________________
153    /**
154      * @notice Show the `totalSupply` for this Token contract
155      */
156     function totalSupply() constant public returns (uint coinLifeTimeTotalSupply) {
157         return totalSupply ;   
158     }  
159 //_________________________________________________________
160    /**
161      * @notice Show the `tokenOwner` balances for this contract
162      * @param tokenOwner the token owners address
163      */
164     function balanceOf(address tokenOwner) constant public  returns (uint coinBalance) {
165         return balanceOf[tokenOwner];
166     } 
167 //_________________________________________________________
168    /**
169      * @notice Show the allowance given by `tokenOwner` to the `spender`
170      * @param tokenOwner the token owner address allocating allowance
171      * @param spender the allowance spenders address
172      */
173     function allowance(address tokenOwner, address spender) constant public returns (uint coinsRemaining) {
174         return allowance[tokenOwner][spender];
175     }
176 //_________________________________________________________
177 //
178     function setContrAddrAndCrwSale(bool setAddress,  address icoAddr, address exchAddr, address csAddr, bool setCrowdSale, bool crowdSaleOpen_ ) public onlyOwner returns(bool success){
179 
180        if(setAddress == true){
181        		ico_addr = icoAddr; exchg_addr = exchAddr; cs_addr = csAddr;       		
182        }
183        //
184        if( setCrowdSale == true )crowdSaleOpen = crowdSaleOpen_;
185        
186        return true;   
187     }          
188     //
189     function _getIcoAddr() internal  returns(address ico_ma_addr){  return(ico_addr); } 
190     function _getExchgAddr() internal returns(address exchg_ma_addr){ return(exchg_addr); } 
191     function _getCsAddr() internal returns(address cs_ma_addr){ return(cs_addr); } 
192 //_________________________________________________________
193 //
194     /* Internal transfer, only can be called by this contract */
195     //
196     function _transfer(address _from, address _to, uint _value) internal  {
197         require (_to != 0x0);                                       
198         require(!frozenAccount[_from]);                             
199         require(!frozenAccount[_to]);                               
200         uint valtmp = _value;
201         uint _valueA = valtmp;
202         valtmp = 0;                       
203         require (balanceOf[_from] >= _valueA);                       
204         require (balanceOf[_to] + _valueA > balanceOf[_to]);                   
205         uint previousBalances = balanceOf[_from] + balanceOf[_to];                               
206         balanceOf[_from] = safeSub(balanceOf[_from], _valueA);                                  
207         balanceOf[_to] = safeAdd(balanceOf[_to], _valueA); 
208         Transfer(_from, _to, _valueA);
209         _valueA = 0;
210         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);       
211     }
212 //________________________________________________________
213     /**
214      * Transfer tokens
215      */
216      function transfer(address _to, uint256 _value) public returns(bool success) {
217 
218         //check sender and receiver allw limits in accordance with ico contract
219         if(msg.sender != owner){
220 	        bool sucsSlrLmt = _chkSellerLmts( msg.sender, _value);    
221 	        bool sucsByrLmt = _chkBuyerLmts( _to, _value);
222 	        require(sucsSlrLmt == true && sucsByrLmt == true);
223         }
224         //
225         uint valtmp = _value;    
226         uint _valueTemp = valtmp; 
227         valtmp = 0;                 
228         _transfer(msg.sender, _to, _valueTemp);
229         _valueTemp = 0;
230         return true;      
231     }  
232 //_________________________________________________________
233     /**
234      * Transfer tokens from other address
235      */
236     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
237         
238         uint valtmp = _value;
239         uint _valueA = valtmp;
240         valtmp = 0;
241         require(_valueA <= allowance[_from][msg.sender]);     
242         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _valueA);
243         _transfer(_from, _to, _valueA);
244         _valueA = 0;
245         return true;
246     }
247 //_________________________________________________________
248     /**
249      * Set allowance for other address
250      */
251     function approve(address _spender, uint256 _value) public returns (bool success) {
252         
253         //check sender and receiver allw limits in accordance with ico contract
254         if(msg.sender != owner){
255 	        bool sucsSlrLmt = _chkSellerLmts( msg.sender, _value);          
256 	        bool sucsByrLmt = _chkBuyerLmts( _spender, _value);
257 	        require(sucsSlrLmt == true && sucsByrLmt == true);
258         }
259         //
260         uint valtmp = _value;
261         uint _valueA = valtmp;
262         valtmp = 0;         
263         allowance[msg.sender][_spender] = _valueA;
264         Approval(msg.sender, _spender, _valueA);
265          _valueA =0;
266         return true;
267     }
268 //_________________________________________________________
269     /**
270      * Set allowance for other address and notify
271      */
272     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
273         
274         tokenRecipient spender = tokenRecipient(_spender);
275         uint valtmp = _value;
276         uint _valueA = valtmp;
277         valtmp = 0;         
278         if (approve(_spender, _valueA)) {           
279             spender.receiveApproval(msg.sender, _valueA, this, _extraData);            
280         }
281         _valueA = 0; 
282         return true;
283     }
284 //_________________________________________________________
285 //
286     function freezeAccount(address target, bool freeze) onlyOwner public returns(bool success) {
287         frozenAccount[target] = freeze;      
288         //FrozenFunds(target, freeze);
289         return true;
290     }
291 //________________________________________________________
292 //
293     function _safeTransferTkn( address _from, address _to, uint amount) internal returns(bool sucsTrTk){
294           
295           uint tkA = amount;
296           uint tkAtemp = tkA;
297           tkA = 0;
298                    _transfer(_from, _to, tkAtemp); 
299           tkAtemp = 0;
300           return true;
301     }      
302 //_________________________________________________________
303 //
304     function _safeTransferPaymnt( address paymentBenfcry, uint payment) internal returns(bool sucsTrPaymnt){
305               
306           uint pA = payment; 
307           uint paymentTemp = pA;
308           pA = 0;
309                   paymentBenfcry.transfer(paymentTemp); 
310           FundOrPaymentTransfer(paymentBenfcry, paymentTemp);                       
311           paymentTemp = 0; 
312           
313           return true;
314     }
315 //_________________________________________________________
316 //
317     function _safePaymentActionAtIco( uint payment, address paymentBenfcry, uint paytype) internal returns(bool success){
318               
319     // payment req to ico
320           uint Pm = payment;
321           uint PmTemp = Pm;
322           Pm = 0;  
323           ICO ico = ICO(_getIcoAddr());       
324           // paytype 1 for redeempayment and 2 for sell payment
325           bool pymActSucs = ico.paymentAction( PmTemp, paymentBenfcry, paytype);
326           require(pymActSucs ==  true);
327           PmTemp = 0;
328           
329           return true;
330     }
331 //_____________________________________________________________
332 //
333 
334 	function buyCoinsCrowdSale(address buyer, uint payment, address crowdSaleContr) public returns(bool success, uint retPayment) { 
335 		
336 		require(crowdSaleOpen == true && crowdSaleContr == _getCsAddr());
337 
338 		success = false;
339 		(success , retPayment) = _buyCoins( buyer, payment);
340 		require(success == true);
341 		return (success, retPayment);
342 	}
343 //_____________________________________________________________
344 //
345     function _buyCoins(address buyer, uint payment) internal returns(bool success, uint retPayment) { 
346 
347         msgSndr[buyer] = payment;
348 
349         ICO ico = ICO(_getIcoAddr() );
350 
351         require(  payment > 0 );
352         
353         bool icosuccess;  uint tknsBuyAppr;  
354         (icosuccess, tknsBuyAppr, retPayment ) = ico.buy( payment, buyer, false);         
355         require( icosuccess == true );
356         
357         if(crowdSaleOpen == false) {
358         // return payment to buyer 
359 	        if( retPayment > 0 ) {
360 	                
361 	          bool sucsTrPaymnt;
362 	          sucsTrPaymnt = _safeTransferPaymnt( buyer, retPayment );
363 	          require(sucsTrPaymnt == true );
364 	        }
365         }
366         // tkn transfer
367         bool sucsTrTk =  _safeTransferTkn( owner, buyer, tknsBuyAppr);
368         require(sucsTrTk == true);
369 
370         msgSndr[buyer] = 0;
371 
372         return (true, retPayment);
373     }   
374 //_____________________________________________________________
375   
376     function redeemOrSellCoinsToICO(uint enter1forRedeemOR2forSell, uint256 amountOfCoinPartsToRedeemOrSell) public returns (bool success ) {
377 
378     require(crowdSaleOpen == false);
379 
380     uint amount = amountOfCoinPartsToRedeemOrSell;
381 
382     msgSndr[msg.sender] = amount;  
383       bool isPreview = false;
384 
385       ICO ico = ICO(_getIcoAddr());
386 
387       // redeem exe at ico
388         bool icosuccess ; uint redeemOrSellPaymentValue;
389       
390 	      if(enter1forRedeemOR2forSell == 1){
391 
392 	      	(icosuccess , redeemOrSellPaymentValue) = ico.redeemCoin( amount, msg.sender, isPreview);
393 	      }
394 	      if(enter1forRedeemOR2forSell == 2){
395 
396 	      	(icosuccess , redeemOrSellPaymentValue) = ico.sell( amount, msg.sender, isPreview);
397 	      }	      
398 
399       require( icosuccess == true);  
400 
401         require( _getIcoAddr().balance >= safeAdd( ico.getMinBal() , redeemOrSellPaymentValue) );
402 
403       bool sucsTrTk = false; bool pymActSucs = false;
404       if(isPreview == false) {
405 
406         // transfer tkns
407         sucsTrTk =  _safeTransferTkn( msg.sender, owner, amount);
408         require(sucsTrTk == true);        
409 
410         // payment req to ico  1 for redeempayment and 2 for sell payment         
411       msgSndr[msg.sender] = redeemOrSellPaymentValue;
412         pymActSucs = _safePaymentActionAtIco( redeemOrSellPaymentValue, msg.sender, enter1forRedeemOR2forSell);
413         require(pymActSucs ==  true);
414       } 
415      
416     msgSndr[msg.sender] = 0;  
417 
418       return (true);        
419     } 
420 //________________________________________________________
421 
422     function _chkSellerLmts( address seller, uint amountOfCoinsSellerCanSell) internal returns(bool success){   
423 
424       uint amountTkns = amountOfCoinsSellerCanSell; 
425       success = false;
426       ICO ico = ICO( _getIcoAddr() );
427       uint seriesCapFactor = ico.getSCF();
428       
429 	      if( amountTkns <= balanceOf[seller]  &&  balanceOf[seller] <=  safeDiv(allowedIndividualShare*seriesCapFactor,10**18) ){
430 	        success = true;
431 	      }
432 
433       return success;
434     }
435     // bool sucsSlrLmt = _chkSellerLmts( address seller, uint amountTkns);
436 //_________________________________________________________    
437 //
438     function _chkBuyerLmts( address buyer, uint amountOfCoinsBuyerCanBuy)  internal  returns(bool success){
439 
440     	uint amountTkns = amountOfCoinsBuyerCanBuy;
441         success = false;
442         ICO ico = ICO( _getIcoAddr() );
443         uint seriesCapFactor = ico.getSCF();
444 
445 	        if( amountTkns <= safeSub( safeDiv(allowedIndividualShare*seriesCapFactor,10**18), balanceOf[buyer] )) {
446 	          success = true;
447 	        } 
448 
449         return success;        
450     }
451 //_________________________________________________________
452 //
453     function _chkBuyerLmtsAndFinl( address buyer, uint amountTkns, uint priceOfr) internal returns(bool success){
454        
455        success = false;
456 
457       // buyer limits
458        bool sucs1 = false; 
459        sucs1 = _chkBuyerLmts( buyer, amountTkns);
460 
461       // buyer funds
462        ICO ico = ICO( _getIcoAddr() );
463        bool sucs2 = false;
464        if( buyer.balance >=  safeAdd( safeMul(amountTkns , priceOfr) , ico.getMinBal() )  )  sucs2 = true;
465        if( sucs1 == true && sucs2 == true)  success = true;   
466 
467        return success;
468     }
469 //_________________________________________________________
470 //
471      function _slrByrLmtChk( address seller, uint amountTkns, uint priceOfr, address buyer) internal returns(bool success){
472      
473       // seller limits check
474         bool successSlrl; 
475         (successSlrl) = _chkSellerLmts( seller, amountTkns); 
476 
477       // buyer limits check
478         bool successByrlAFinl;
479         (successByrlAFinl) = _chkBuyerLmtsAndFinl( buyer, amountTkns, priceOfr);
480         
481         require( successSlrl == true && successByrlAFinl == true);
482 
483         return true;
484     }
485 //___________________________________________________________
486 
487     function () public payable {
488        
489         if(msg.sender != owner){
490 
491             require(crowdSaleOpen == false);
492             bool success = false;
493             uint retPayment;
494 			(success , retPayment) = _buyCoins( msg.sender, msg.value);
495 			require(success == true);    
496         }
497     }
498 //_________________________________________________________
499 
500 		    function burn( uint256 value, bool unburn) onlyOwner public returns( bool success ) { 
501 
502 		    	require(crowdSaleOpen == false);
503 
504 		        msgSndr[msg.sender] = value;
505 		         ICO ico = ICO( _getIcoAddr() );
506 		            if( unburn == false) {
507 
508 		                balanceOf[owner] = safeSub( balanceOf[owner] , value);
509 		                totalSupply = safeSub( totalSupply, value);
510 		                BurnOrUnBurn(owner, value, 1);
511 
512 		            }
513 		            if( unburn == true) {
514 
515 		                balanceOf[owner] = safeAdd( balanceOf[owner] , value);
516 		                totalSupply = safeAdd( totalSupply , value);
517 		                BurnOrUnBurn(owner, value, 2);
518 
519 		            }
520 		        
521 		        bool icosuccess = ico.burn( value, unburn, totalSupplyStart, balanceOf[owner] );
522 		        require( icosuccess == true);             
523 		        
524 		        return true;   
525 	                    
526            }
527 //_________________________________________________________
528 
529     function withdrawFund(uint withdrawAmount) onlyOwner public returns(bool success) {
530       
531         success = _withdraw(withdrawAmount);          
532         return success;      
533     }   
534 //_________________________________________________________
535 
536     function _withdraw(uint _withdrawAmount) internal returns(bool success) {
537 
538         bool sucsTrPaymnt = _safeTransferPaymnt( beneficiaryFunds, _withdrawAmount); 
539         require(sucsTrPaymnt == true);         
540         return true;     
541     }
542 //_________________________________________________________
543 
544     function receiveICOcoins( uint256 amountOfCoinsToReceive, uint ShrID )  public returns (bool success){ 
545 
546       require(crowdSaleOpen == false);
547 
548       msgSndr[msg.sender] = amountOfCoinsToReceive;
549         ICO ico = ICO( _getIcoAddr() );
550         bool  icosuccess;  
551         icosuccess = ico.recvShrICO(msg.sender, amountOfCoinsToReceive, ShrID ); 
552         require (icosuccess == true);
553 
554         bool sucsTrTk;
555         sucsTrTk =  _safeTransferTkn( owner, msg.sender, amountOfCoinsToReceive);
556         require(sucsTrTk == true);
557 
558       msgSndr[msg.sender] = 0;
559 
560         return  true;
561     }
562 //___________________________________________________________________
563 
564       function sellBkgAtExchg( uint sellerCoinPartsForSale, uint sellerPricePerCoinPartInWEI) public returns(bool success){
565         
566         require(crowdSaleOpen == false);
567 
568         uint amntTkns = sellerCoinPartsForSale;
569         uint tknPrice = sellerPricePerCoinPartInWEI;
570       
571         // seller limits
572         bool successSlrl;
573         (successSlrl) = _chkSellerLmts( msg.sender, amntTkns); 
574         require(successSlrl == true);
575 
576       msgSndr[msg.sender] = amntTkns;  
577 
578       // bkg registration at exchange
579 
580         Exchg em = Exchg(_getExchgAddr());
581 
582         bool  emsuccess; 
583         (emsuccess) = em.sell_Exchg_Reg( amntTkns, tknPrice, msg.sender );
584         require(emsuccess == true );
585             
586       msgSndr[msg.sender] = 0;
587 
588         return true;         
589     }
590 //_________________________________________________________ 
591 //     
592       function buyBkgAtExchg( address seller, uint sellerCoinPartsForSale, uint sellerPricePerCoinPartInWEI, uint myProposedPaymentInWEI) public returns(bool success){ 
593 
594         require(crowdSaleOpen == false);
595 
596         uint amountTkns = sellerCoinPartsForSale;
597         uint priceOfr = sellerPricePerCoinPartInWEI;
598         uint payment = myProposedPaymentInWEI;   
599 
600 		// calc tokens that can be bought         
601         uint tknsBuyAppr = 0;    
602         if( amountTkns > 2 &&  payment >=  (2 * priceOfr) &&  payment <= (amountTkns * priceOfr) ) {
603 
604         	tknsBuyAppr = safeDiv( payment , priceOfr );
605         }
606         require(tknsBuyAppr > 0);
607 
608       msgSndr[msg.sender] = amountTkns;
609 
610         // seller buyer limits check
611         bool sucsLmt = _slrByrLmtChk( seller, amountTkns, priceOfr, msg.sender);
612         require(sucsLmt == true);
613 
614         // booking at exchange
615      
616         Exchg em = Exchg(_getExchgAddr()); 
617 
618         bool emBkgsuccess;
619         (emBkgsuccess)= em.buy_Exchg_booking( seller, amountTkns, priceOfr, msg.sender, payment);
620             require( emBkgsuccess == true );
621 
622       msgSndr[msg.sender] = 0;  
623 
624         return true;        
625     }
626 //________________________________________________________
627 
628     function buyCoinsAtExchg( address seller, uint sellerCoinPartsForSale, uint sellerPricePerCoinPartInWEI) payable public returns(bool success) {
629         
630         require(crowdSaleOpen == false);
631 
632         uint amountTkns = sellerCoinPartsForSale;
633         uint priceOfr = sellerPricePerCoinPartInWEI;	  
634 		
635 		// calc tokens that can be bought         
636         uint tknsBuyAppr = 0;  // this var as used as the indicator to update buyerbkg and seller update for ok or no txn.
637 
638         if( amountTkns > 2 &&  msg.value >=  (2 * priceOfr) &&  msg.value <= (amountTkns * priceOfr) ) {
639 
640         	tknsBuyAppr = safeDiv( msg.value , priceOfr );
641         }
642         // calc return payment to buyer
643         uint retPayment = 0;
644         if(  msg.value > 0 ){
645             retPayment = safeSub( msg.value , tknsBuyAppr * priceOfr);
646         }
647 
648       msgSndr[msg.sender] = amountTkns;               
649         
650         // check buyer booking at exchange
651         Exchg em = Exchg(_getExchgAddr()); 
652 
653         bool sucsBkgChk = false;
654         if(tknsBuyAppr > 0){
655 	        sucsBkgChk = em.buy_Exchg_BkgChk(seller, amountTkns, priceOfr, msg.sender, msg.value); 
656         }
657         if(sucsBkgChk == false) tknsBuyAppr = 0;
658         //
659 
660 			msgSndr[msg.sender] = tknsBuyAppr;  
661  
662         	bool emUpdateSuccess;
663        		(emUpdateSuccess) = em.updateSeller(seller, tknsBuyAppr, msg.sender, msg.value); 
664         	require( emUpdateSuccess == true );
665         
666         //
667         if(sucsBkgChk == true && tknsBuyAppr > 0){
668       
669 	       // token transfer in this token contract
670 
671 	        bool sucsTrTkn = _safeTransferTkn( seller, msg.sender, tknsBuyAppr);
672 	        require(sucsTrTkn == true);
673 
674 	        // payment to seller        
675 	        bool sucsTrPaymnt;
676 	        sucsTrPaymnt = _safeTransferPaymnt( seller,  safeSub( msg.value , safeDiv(msg.value*em.getExchgComisnMulByThousand(),1000) ) );
677 	        require(sucsTrPaymnt == true );        
678         }
679     	// return payment to buyer 
680         if( retPayment > 0 ) {
681                 
682           bool sucsTrRetPaymnt;
683           sucsTrRetPaymnt = _safeTransferPaymnt( msg.sender, retPayment );
684           require(sucsTrRetPaymnt == true );
685         }         
686       msgSndr[msg.sender] = 0; 
687         
688         return true;
689     } 
690 //_______________________________________________________
691 //  called by other contracts
692     function sendMsgSndr(address caller, address origin) public returns(bool success, uint value){
693         
694         (success, value) = _sendMsgSndr(caller, origin);        
695          return(success, value);  
696     }
697 //_______________________________________________________
698 //
699     function _sendMsgSndr(address caller,  address origin) internal returns(bool success, uint value){ 
700        
701         require( caller == _getIcoAddr() || caller == _getExchgAddr() || caller == _getCsAddr() ); 
702           //require(origin == tx.origin);          
703         return(true, msgSndr[origin]);  
704     }
705 //_________________________________________________________
706 //
707     function viewSellOffersAtExchangeMacroansy(address seller, bool show) view public returns (uint sellersCoinAmountOffer, uint sellersPriceOfOneCoinInWEI, uint sellerBookedTime, address buyerWhoBooked, uint buyPaymentBooked, uint buyerBookedTime){
708 
709       if(show == true){
710 
711         Exchg em = Exchg(_getExchgAddr()); 
712        
713         ( sellersCoinAmountOffer,  sellersPriceOfOneCoinInWEI,  sellerBookedTime,  buyerWhoBooked,  buyPaymentBooked,  buyerBookedTime, ) = em.viewSellOffersAtExchangeMacroansy( seller, show) ; 
714 
715         return ( sellersCoinAmountOffer,  sellersPriceOfOneCoinInWEI,  sellerBookedTime,  buyerWhoBooked,  buyPaymentBooked,  buyerBookedTime);
716       }
717     }
718 //_________________________________________________________
719 //
720 		function viewCoinSupplyAndFunding(bool show) public view returns(uint totalSupplyOfCoinsInSeriesNow, uint coinsAvailableForSale, uint icoFunding){
721 
722 		    if(show == true){
723 		      ICO ico = ICO( _getIcoAddr() );
724 
725 		      ( totalSupplyOfCoinsInSeriesNow, coinsAvailableForSale, icoFunding) = ico.getAvlShares(show);
726 
727 		      return( totalSupplyOfCoinsInSeriesNow, coinsAvailableForSale, icoFunding);
728 		    }
729 		}
730 //_________________________________________________________
731 //
732 /*    			
733 			bool private isEndOk;
734 				function endOfRewards(bool isEndNow) public onlyOwner {
735 
736 						isEndOk == isEndNow;
737 				}
738 				function endOfRewardsConfirmed(bool isEndNow) public onlyOwner{
739 
740 					if(isEndOk == true && isEndNow == true) selfdestruct(owner);
741 				}
742 */			
743 //_______________________________________________________
744 }
745 // END_OF_CONTRACT