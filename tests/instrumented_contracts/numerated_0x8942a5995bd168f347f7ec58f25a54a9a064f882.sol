1 /*
2 'We are a gaming and entertainment network our blockChain launch product is HDX20 (http://hdx20.io)'
3 
4 HDX20 tokens can be bought & sold on our exchange and are distributed every time someone is playing a HDX20 POWERED GAME. 
5 With 4% IN and 4% OUT fee only, price of the HDX20 can only go up by design, cannot be dumped on holders and is fueled
6 by both the volume of transactions and HDX20 POWERED GAMES.
7 
8 The 4 principles of the HDX20 are :
9 
10 1) Buy it, its price will increase.
11 2) Sell it, its price will increase.
12 3) Transfer it, its price will increase.
13 4) Play our HDX20 powered games, its price will increase.
14 
15 Our Blockchain SmartContract IS the market and makes sure that the HDX20 Price never fall below its current selling price
16 thus offering an unique CONTEXT where risk is known at all time and limited to the IN and OUT fees only.
17 
18 We have designed a vault where your HDX20 value while still indexed on the Ethereum Price will appreciate automatically over time.
19 
20 This product is copyrighted. Any unauthorized copy, modification, or use without express written consent from HyperDevbox is prohibited.
21 
22 Copyright 2018 HyperDevbox
23 
24 fees distribution:
25 .1% for developer / 3% for HDX20 price appreciation during BUY and SELL
26 .1% for developer / 1% for HDX20 price appreciation during token Transfer
27 
28 */
29 
30 pragma solidity ^0.4.25;
31 
32 
33 interface HDX20Interface
34 {
35    
36     function moveAccountIn( address _customerAddress ) payable external;
37   
38 }
39 
40 contract HDX20
41 {
42      using SafeMath for uint256;
43      
44      //address of a future contract to move in, by default set to 0
45      HDX20Interface private NewHDX20Contract = HDX20Interface(0);
46      
47     /*==============================
48     =            EVENTS            =
49     ==============================*/
50     event OwnershipTransferred(
51          address indexed previousOwner,
52          address indexed nextOwner
53          );
54          
55    
56          
57          
58     event Transfer(
59         address indexed from,
60         address indexed to,
61         uint256 tokens
62     );
63     
64   
65          
66     event onBuyEvent(
67         address from,
68         uint256 tokens
69     );
70    
71      event onSellEvent(
72         address from,
73         uint256 tokens
74     );
75     
76     
77          
78     event onAccountMovedOut(
79         address indexed from,
80         address to,
81         uint256 tokens,
82         uint256 eth
83     );
84     
85     event onAccountMovedIn(
86         address indexed from,
87         address to,
88         uint256 tokens,
89         uint256 eth
90     );
91     
92     event HDXcontractChanged(
93         
94          address previous,
95          address next,
96          uint256 timeStamp
97          );
98     
99     /*==============================
100     =            MODIFIERS         =
101     ==============================*/
102     modifier onlyOwner
103     {
104         require (msg.sender == owner);
105         _;
106     }
107     
108     modifier onlyFromGameWhiteListed
109     {
110         require (gameWhiteListed[ msg.sender ] == true);
111         _;
112     }
113     
114   
115     
116     modifier onlyGameWhiteListed(address who)
117     {
118         require (gameWhiteListed[ who ] == true);
119         _;
120     }
121     
122     
123     modifier onlyTokenHolders() {
124         require(myTokens() > 0);
125         _;
126     }
127     
128   
129  
130   
131     address public owner;
132     
133      /// Contract governance.
134 
135     constructor () public
136     {
137         owner = msg.sender;
138        
139         
140         if ( address(this).balance > 0)
141         {
142             owner.transfer( address(this).balance );
143         }
144     }
145 
146   
147    
148 
149     /*==============================
150     =       TOKEN VARIABLES        =
151     ==============================*/
152 
153     string public name = "HDX20 token";
154     string public symbol = "HDX20";
155     uint8 constant public decimals = 18;
156     uint256 constant internal magnitude = 1e18;
157     
158     
159     
160     uint8 constant internal referrerFee = 50;    //that is 50% of the buyInFee fee 
161     uint8 constant internal transferFee = 2;     //50% for the community 50% for developer
162     uint8 constant internal buyInFee = 3;        
163     uint8 constant internal sellOutFee = 3;      
164     uint8 constant internal devFee = 1;          //actually since dev is receiving fees in HDX20 exclusively, he is also taxed on the buyinfee so this not 1%
165     
166     
167     mapping(address => uint256) private tokenBalanceLedger;
168   
169     
170     uint256 private tokenSupply = 0;  
171     uint256 private contractValue = 0;
172     uint256 private tokenPrice = 0.001 ether;   //starting price
173   
174   
175    /*================================
176     =       HDX20 VARIABLES         =
177     ================================*/
178     
179     mapping(address => bool)   private gameWhiteListed;
180     mapping(address => uint8)  private superReferrerRate;
181    
182     
183     /*================================
184     =       PUBLIC FUNCTIONS         =
185     ================================*/
186     
187      /**
188      * Fallback function to process ethereum 
189      */
190     function()
191         payable
192         public
193     {
194         buyToken(address(0));
195     }
196     
197     
198     
199     function changeOwner(address _nextOwner) public
200     onlyOwner
201     {
202         require (_nextOwner != owner);
203         require(_nextOwner != address(0));
204          
205         emit OwnershipTransferred(owner, _nextOwner);
206          
207         owner = _nextOwner;
208     }
209     
210     
211  
212     
213     function changeName(string _name) public
214     onlyOwner
215     {
216         name = _name;
217     }
218     
219   
220     function changeSymbol(string _symbol) public
221     onlyOwner
222     {
223         symbol = _symbol;
224     }
225  
226     
227     function addGame(address _contractAddress ) public
228     onlyOwner
229     {
230         gameWhiteListed[ _contractAddress ] = true;
231     }
232     
233     function addSuperReferrer(address _contractAddress , uint8 extra_rate) public
234     onlyOwner
235     {
236        superReferrerRate[ _contractAddress ] = extra_rate;
237     }
238     
239     function removeGame(address _contractAddress ) public
240     onlyOwner
241     {
242         gameWhiteListed[ _contractAddress ] = false;
243     }
244     
245     function changeNewHDX20Contract(address _next) public
246     onlyOwner
247     {
248         require (_next != address( NewHDX20Contract ));
249         require( _next != address(0));
250          
251         emit HDXcontractChanged(address(NewHDX20Contract), _next , now);
252          
253         NewHDX20Contract  = HDX20Interface( _next);
254     }
255     
256     function buyTokenSub( uint256 _eth , address _customerAddress ) private
257     returns(uint256)
258     {
259         
260         uint256 _nb_token = (_eth.mul( magnitude)) / tokenPrice;
261         
262         
263         tokenBalanceLedger[ _customerAddress ] =  tokenBalanceLedger[ _customerAddress ].add( _nb_token);
264         tokenSupply = tokenSupply.add(_nb_token);
265         
266         emit onBuyEvent( _customerAddress , _nb_token);
267         
268         return( _nb_token );
269      
270     }
271     
272     function buyTokenFromGame( address _customerAddress , address _referrer_address ) public payable
273     onlyFromGameWhiteListed
274     returns(uint256)
275     {
276         uint256 _eth = msg.value;
277         
278         if (_eth==0) return(0);
279         
280         
281         uint256 _devfee = (_eth.mul( devFee )) / 100;
282         
283         uint256 _fee = (_eth.mul( buyInFee )) / 100;
284         
285         if (_referrer_address != address(0) && _referrer_address != _customerAddress )
286         {
287              uint256 _ethReferrer = (_fee.mul(referrerFee + superReferrerRate[_referrer_address])) / 100;
288 
289              buyTokenSub( _ethReferrer , _referrer_address);
290              
291              //substract what is given to referrer
292              _fee = _fee.sub( _ethReferrer );
293              
294         }
295         
296         //for the developer as HDX20 token and also help to increase the price because taxed also on his own share like everybody else
297         
298         buyTokenSub( (_devfee.mul(100-buyInFee)) / 100 , owner );
299         
300         //finally buy for the buyer
301      
302         uint256 _nb_token = buyTokenSub( _eth - _fee -_devfee , _customerAddress);
303         
304         //add the value to the contract
305         contractValue = contractValue.add( _eth );
306         
307       
308         if (tokenSupply>magnitude)
309         {
310             tokenPrice = (contractValue.mul( magnitude)) / tokenSupply;
311         }
312        
313        
314         
315         return( _nb_token );
316         
317     }
318   
319   
320     function buyToken( address _referrer_address ) public payable
321     returns(uint256)
322     {
323         uint256 _eth = msg.value;
324         address _customerAddress = msg.sender;
325         
326         require( _eth>0);
327         
328         uint256 _devfee = (_eth.mul( devFee )) / 100;
329          
330         uint256 _fee = (_eth.mul( buyInFee )) / 100;
331         
332         if (_referrer_address != address(0) && _referrer_address != _customerAddress )
333         {
334              uint256 _ethReferrer = (_fee.mul(referrerFee + superReferrerRate[_referrer_address])) / 100;
335 
336              buyTokenSub( _ethReferrer , _referrer_address);
337              
338             //substract what is given to referrer
339              _fee = _fee.sub( _ethReferrer );
340              
341         }
342 
343         //for the developer as HDX20 token and also help to increase the price because taxed also on his own share like everybody else
344 
345         buyTokenSub( (_devfee.mul(100-buyInFee)) / 100 , owner );
346         
347         //finally buy for the buyer
348       
349         uint256 _nb_token = buyTokenSub( _eth - _fee -_devfee , _customerAddress);
350         
351         //add the value to the contract
352         contractValue = contractValue.add( _eth );
353         
354      
355         if (tokenSupply>magnitude)
356         {
357             tokenPrice = (contractValue.mul( magnitude)) / tokenSupply;
358         }
359        
360         
361         return( _nb_token );
362         
363     }
364     
365     function sellToken( uint256 _amount ) public
366     onlyTokenHolders
367     {
368         address _customerAddress = msg.sender;
369         
370         uint256 balance = tokenBalanceLedger[ _customerAddress ];
371         
372         require( _amount <= balance);
373         
374         uint256 _eth = (_amount.mul( tokenPrice )) / magnitude;
375         
376         uint256 _fee = (_eth.mul( sellOutFee)) / 100;
377         
378         uint256 _devfee = (_eth.mul( devFee)) / 100;
379         
380         tokenSupply = tokenSupply.sub( _amount );
381        
382      
383         balance = balance.sub( _amount );
384         
385         tokenBalanceLedger[ _customerAddress] = balance;
386         
387         //for the developer as HDX20 token and also help to increase the price because taxed also on his own share like everybody else
388         buyTokenSub(  (_devfee.mul(100-buyInFee)) / 100 , owner );
389         
390         
391         //calculate what is really leaving the contract, basically _eth - _fee -devfee
392         _eth = _eth - _fee - _devfee; 
393         
394         contractValue = contractValue.sub( _eth );
395         
396        
397         if (tokenSupply>magnitude)
398         {
399             tokenPrice = (contractValue.mul( magnitude)) / tokenSupply;
400         }
401        
402         
403          emit onSellEvent( _customerAddress , _amount);
404         
405          //finally transfer the money
406         _customerAddress.transfer( _eth );
407         
408     }
409    
410     //there is no fee using token to play HDX20 powered games 
411   
412     function payWithToken( uint256 _eth , address _player_address ) public
413     onlyFromGameWhiteListed
414     returns(uint256)
415     {
416         require( _eth>0 && _eth <= ethBalanceOfNoFee(_player_address ));
417         
418         address _game_contract = msg.sender;
419         
420         uint256 balance = tokenBalanceLedger[ _player_address ];
421         
422         uint256 _nb_token = (_eth.mul( magnitude) ) / tokenPrice;
423         
424         require( _nb_token <= balance);
425         
426         //confirm the ETH value
427         _eth = (_nb_token.mul( tokenPrice)) / magnitude;
428         
429         balance = balance.sub(_nb_token);
430         
431         tokenSupply = tokenSupply.sub( _nb_token);
432         
433         tokenBalanceLedger[ _player_address ] = balance;
434         
435         contractValue = contractValue.sub( _eth );
436         
437        
438         if (tokenSupply>magnitude)
439         {
440             tokenPrice = (contractValue.mul( magnitude)) / tokenSupply;
441         }
442        
443         
444         //send the money to the game contract   
445         _game_contract.transfer( _eth );
446       
447       
448         return( _eth );
449     }
450     
451     function moveAccountOut() public
452     onlyTokenHolders
453     {
454         address _customerAddress = msg.sender;
455         
456         require( ethBalanceOfNoFee( _customerAddress )>0 && address(NewHDX20Contract) != address(0));
457     
458         uint256 balance = tokenBalanceLedger[ _customerAddress ];
459     
460         uint256 _eth = (balance.mul( tokenPrice )) / magnitude;
461         
462        
463         tokenSupply = tokenSupply.sub( balance );
464         
465         tokenBalanceLedger[ _customerAddress ] = 0;
466         
467         contractValue = contractValue.sub( _eth );
468         
469      
470         if (tokenSupply>magnitude)
471         {
472             tokenPrice = (contractValue.mul( magnitude)) / tokenSupply;
473         }
474        
475         
476         emit onAccountMovedOut( _customerAddress , address(NewHDX20Contract), balance , _eth );
477       
478         //send the money to the new HDX20 contract which will buy on customer behalf at no fee converting eth for eth
479         //notice this could give more or less HDX20 however the eth value should be preserved
480         NewHDX20Contract.moveAccountIn.value(_eth)(_customerAddress);
481       
482     }
483     
484     function moveAccountIn(address _customerAddress) public
485     payable
486     onlyFromGameWhiteListed
487     {
488         
489         
490         uint256 _eth = msg.value;
491       
492         //buy token at no fee
493         uint256 _nb_token = buyTokenSub( _eth , _customerAddress );
494         
495         contractValue = contractValue.add( _eth );
496     
497       
498         if (tokenSupply>magnitude)
499         {
500             tokenPrice = (contractValue.mul( magnitude)) / tokenSupply;
501         }
502        
503         
504         emit onAccountMovedIn( msg.sender, _customerAddress , _nb_token , _eth );
505      
506     }
507     
508     
509     function appreciateTokenPrice() public payable
510     onlyFromGameWhiteListed
511     {
512         uint256 _eth =  msg.value;
513        
514         contractValue = contractValue.add( _eth );
515             
516         //we need a minimum of 1 HDX20 before appreciation is activated    
517         if (tokenSupply>magnitude)
518         {
519                 tokenPrice = (contractValue.mul( magnitude)) / tokenSupply;
520         }
521        
522         
523     }
524     
525   
526     
527     function transferSub(address _customerAddress, address _toAddress, uint256 _amountOfTokens)
528     private
529     returns(bool)
530     {
531        
532         require( _amountOfTokens <= tokenBalanceLedger[_customerAddress] );
533         
534         //actually a transfer of 0 token is valid in ERC20
535         if (_amountOfTokens>0)
536         {
537             
538            
539             {
540             
541                 uint256 _token_fee =  (_amountOfTokens.mul( transferFee )) / 100;
542                
543                 _token_fee /= 2;
544                
545                 
546                 //now proceed the transfer
547                 tokenBalanceLedger[ _customerAddress] = tokenBalanceLedger[ _customerAddress].sub( _amountOfTokens );
548                 tokenBalanceLedger[ _toAddress] = tokenBalanceLedger[ _toAddress].add( _amountOfTokens - (_token_fee*2) );
549               
550                 //half fee in HDX20 directly credited to developer
551                 tokenBalanceLedger[ owner ] += _token_fee;
552                 
553                 //burning the other half of token to drive the price up
554                 tokenSupply = tokenSupply.sub( _token_fee );
555               
556              
557                 if (tokenSupply>magnitude)
558                 {
559                     tokenPrice = (contractValue.mul( magnitude)) / tokenSupply;
560                 }
561                
562             }
563            
564            
565           
566         
567         }
568       
569       
570         // fire event
571         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
572         
573         // ERC20
574         return true;
575        
576     }
577     
578     function transfer(address _toAddress, uint256 _amountOfTokens)
579     public
580     returns(bool)
581     {
582         
583         return( transferSub( msg.sender ,  _toAddress, _amountOfTokens));
584        
585     }
586     
587   
588     
589     
590     /*================================
591     =  VIEW AND HELPERS FUNCTIONS    =
592     ================================*/
593     
594   
595     function totalEthereumBalance()
596         public
597         view
598         returns(uint)
599     {
600         return address(this).balance;
601     }
602     
603     function totalContractBalance()
604         public
605         view
606         returns(uint)
607     {
608         return contractValue;
609     }
610     
611   
612     function totalSupply()
613         public
614         view
615         returns(uint256)
616     {
617         return tokenSupply;
618     }
619     
620   
621     function myTokens()
622         public
623         view
624         returns(uint256)
625     {
626         address _customerAddress = msg.sender;
627         return balanceOf(_customerAddress);
628     }
629     
630    
631     function balanceOf(address _customerAddress)
632         view
633         public
634         returns(uint256)
635     {
636         return tokenBalanceLedger[_customerAddress];
637     }
638     
639     function sellingPrice( bool includeFees)
640         view
641         public
642         returns(uint256)
643     {
644         uint256 _fee = 0;
645         uint256 _devfee=0;
646         
647         if (includeFees)
648         {
649             _fee = (tokenPrice.mul( sellOutFee ) ) / 100;
650             _devfee = (tokenPrice.mul( devFee ) ) / 100;
651         }
652         
653         return( tokenPrice - _fee - _devfee );
654         
655     }
656     
657     function buyingPrice( bool includeFees)
658         view
659         public
660         returns(uint256)
661     {
662         uint256 _fee = 0;
663         uint256 _devfee=0;
664         
665         if (includeFees)
666         {
667             _fee = (tokenPrice.mul( buyInFee ) ) / 100;
668             _devfee = (tokenPrice.mul( devFee ) ) / 100;
669         }
670         
671         return( tokenPrice + _fee + _devfee );
672         
673     }
674     
675     function ethBalanceOf(address _customerAddress)
676         view
677         public
678         returns(uint256)
679     {
680         
681         uint256 _price = sellingPrice( true );
682         
683         uint256 _balance = tokenBalanceLedger[ _customerAddress];
684         
685         uint256 _value = (_balance.mul( _price )) / magnitude;
686         
687         
688         return( _value );
689     }
690     
691   
692    
693     function myEthBalanceOf()
694         public
695         view
696         returns(uint256)
697     {
698         address _customerAddress = msg.sender;
699         return ethBalanceOf(_customerAddress);
700     }
701    
702    
703     function ethBalanceOfNoFee(address _customerAddress)
704         view
705         public
706         returns(uint256)
707     {
708         
709         uint256 _price = sellingPrice( false );
710         
711         uint256 _balance = tokenBalanceLedger[ _customerAddress];
712         
713         uint256 _value = (_balance.mul( _price )) / magnitude;
714         
715         
716         return( _value );
717     }
718     
719   
720    
721     function myEthBalanceOfNoFee()
722         public
723         view
724         returns(uint256)
725     {
726         address _customerAddress = msg.sender;
727         return ethBalanceOfNoFee(_customerAddress);
728     }
729     
730     function checkGameListed(address _contract)
731         view
732         public
733         returns(bool)
734     {
735       
736       return( gameWhiteListed[ _contract]);
737     }
738     
739     function getSuperReferrerRate(address _customerAddress)
740         view
741         public
742         returns(uint8)
743     {
744       
745       return( referrerFee+superReferrerRate[ _customerAddress]);
746     }
747     
748   
749     
750 }
751 
752 
753 library SafeMath {
754     
755     /**
756     * @dev Multiplies two numbers, throws on overflow.
757     */
758     function mul(uint256 a, uint256 b) 
759         internal 
760         pure 
761         returns (uint256 c) 
762     {
763         if (a == 0) {
764             return 0;
765         }
766         c = a * b;
767         require(c / a == b);
768         return c;
769     }
770 
771     /**
772     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
773     */
774     function sub(uint256 a, uint256 b)
775         internal
776         pure
777         returns (uint256) 
778     {
779         require(b <= a);
780         return a - b;
781     }
782 
783     /**
784     * @dev Adds two numbers, throws on overflow.
785     */
786     function add(uint256 a, uint256 b)
787         internal
788         pure
789         returns (uint256 c) 
790     {
791         c = a + b;
792         require(c >= a);
793         return c;
794     }
795     
796    
797     
798   
799     
800    
801 }