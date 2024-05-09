1 pragma solidity ^0.4.19;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant public returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9  
10 /**
11  * @title ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/20
13  */
14 contract ERC20 is ERC20Basic {
15   function allowance(address owner, address spender) public constant returns (uint256);
16   function transferFrom(address from, address to, uint256 value) public returns (bool);
17   function approve(address spender, uint256 value) public returns (bool);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 contract BasicToken is ERC20Basic {
22     
23   using SafeMath for uint256;
24  
25   mapping(address => uint256) balances;
26  
27   
28  
29 }
30 
31 
32 contract StandardToken is ERC20, BasicToken {
33  
34   mapping (address => mapping (address => uint256)) allowed;
35  
36   /**
37    * @dev Transfer tokens from one address to another
38    * @param _from address The address which you want to send tokens from
39    * @param _to address The address which you want to transfer to
40    * @param _value uint256 the amout of tokens to be transfered
41    */
42 
43  
44   /**
45    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
46    * @param _spender The address which will spend the funds.
47    * @param _value The amount of tokens to be spent.
48    */
49   function approve(address _spender, uint256 _value) public returns (bool) {
50  
51     // To change the approve amount you first have to reduce the addresses`
52     //  allowance to zero by calling `approve(_spender, 0)` if it is not
53     //  already 0 to mitigate the race condition described here:
54     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
56  
57     allowed[msg.sender][_spender] = _value;
58     emit Approval(msg.sender, _spender, _value);
59     return true;
60   }
61  
62   /**
63    * @dev Function to check the amount of tokens that an owner allowed to a spender.
64    * @param _owner address The address which owns the funds.
65    * @param _spender address The address which will spend the funds.
66    * @return A uint256 specifing the amount of tokens still available for the spender.
67    */
68   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
69     return allowed[_owner][_spender];
70   }
71  
72 }
73 
74 /**
75  * @title Ownable
76  * @dev The Ownable contract has an owner address, and provides basic authorization control
77  * functions, this simplifies the implementation of "user permissions".
78  */
79 contract Ownable {
80     
81   address public owner;
82 
83   /**
84    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85    * account.
86    */
87   function Ownable() public {
88     owner = msg.sender;
89   }
90  
91   /**
92    * @dev Throws if called by any account other than the owner.
93    */
94   modifier onlyOwner() {
95     require(msg.sender == owner);
96     _;
97   }
98   
99   
100 
101  
102   /**
103    * @dev Allows the current owner to transfer control of the contract to a newOwner.
104    * @param newOwner The address to transfer ownership to.
105    */
106   function  transferOwnership(address newOwner) onlyOwner public {
107     require(newOwner != address(0));      
108     owner = newOwner;
109   }
110   
111 
112  
113 }
114  
115  
116  
117  
118 
119  
120 
121 library SafeMath {
122   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123     if (a == 0) {
124       return 0;
125     }
126     uint256 c = a * b;
127     assert(c / a == b);
128     return c;
129   }
130   
131   
132    function pow(uint256 a, uint256 b) internal pure returns (uint256) {
133     if (a == 0) {
134       return 0;
135     }
136     if(b==0) return 1;
137     assert(b>=0);
138     uint256 c = a ** b;
139     assert(c>=a );
140     return c;
141   }
142 
143   function div(uint256 a, uint256 b) internal pure returns (uint256) {
144     // assert(b > 0); // Solidity automatically throws when dividing by 0
145     uint256 c = a / b;
146     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
147     return c;
148   }
149 
150   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151     assert(b <= a);
152     return a - b;
153   }
154   
155 
156 
157   function add(uint256 a, uint256 b) internal pure returns (uint256) {
158     uint256 c = a + b;
159     assert(c >= a);
160     return c;
161   }
162   
163 function compoundInterest(uint256 depo, uint256 stage2, uint256 start, uint256 current)  internal pure returns (uint256)  {
164             if(current<start || start<stage2 || current<stage2) return depo;
165 
166             uint256 ret=depo; uint256 g; uint256 d;
167             stage2=stage2/1 days;
168             start=start/1 days;
169             current=current/1 days;
170     
171 			uint256 dpercent=100;
172 			uint256 i=start;
173 			
174 			if(i-stage2>365) dpercent=200;
175 			if(i-stage2>730) dpercent=1000;			
176 			
177 			while(i<current)
178 			{
179 
180 				g=i-stage2;			
181 				if(g>265 && g<=365) 
182 				{		
183 				    d=365-g;
184 					if(d>=(current-start))  d=(current-start);
185 					ret=fracExp(ret, dpercent, d, 8);
186 				    i+=d;
187 					dpercent=200;
188 				}
189 				if(g>630 && g<=730) 
190 				{				
191 					d=730-g;	
192 					if(d>=(current-start))  d=(current-start);					
193 					ret=fracExp(ret, dpercent, d, 8);
194 					i+=d;
195 					dpercent=1000;					
196 				}
197 				else if(g>730) dpercent=1000;				
198 				else if(g>365) dpercent=200;
199 				
200 				if(i+100<current) ret=fracExp(ret, dpercent, 100, 8);
201 				else return fracExp(ret, dpercent, current-i, 8);
202 				i+=100;
203 				
204 			}
205 
206 			return ret;
207 			
208 			
209     
210     
211 	}
212 
213 
214 function fracExp(uint256 depo, uint256 percent, uint256 period, uint256 p)  internal pure returns (uint256) {
215   uint256 s = 0;
216   uint256 N = 1;
217   uint256 B = 1;
218   
219 
220   
221   for (uint256 i = 0; i < p; ++i){
222     s += depo * N / B / (percent**i);
223     N  = N * (period-i);
224     B  = B * (i+1);
225   }
226   return s;
227 }
228 
229 
230 
231 
232 
233 
234 
235 }
236 
237 
238 
239 contract MMMTokenCoin is StandardToken, Ownable {
240     using SafeMath for uint256;
241     
242     string public constant name = "Make More Money";
243     string public constant symbol = "MMM";
244     uint32 public constant decimals = 2;
245     
246 	
247 	// Dates
248 	uint256 public stage2StartTime;					// timestamp when compound interest will begin
249     uint256 globalInterestDate;             // last date when amount of tokens with interest was changed
250     uint256 globalInterestAmount;           // amount of tokens with interest
251 	mapping(address => uint256) dateOfStart;     // timestamp of last operation, from which interest calc will be started
252 	uint256 public currentDate;						// current date timestamp
253 	uint256 public debugNow=0;
254 
255 
256 
257     // Crowdsale 
258     uint256 public totalSupply=99900000000;			
259  uint256 public  softcap;
260     uint256 public  step0Rate=100000;       // rate of our tokens. 1 eth = 1000 MMM coins = 100000 tokens (seen as 1000,00 because of decimals)
261     uint256 public  currentRate=100000;   
262     uint256 public constant tokensForOwner=2000000000;   // tokens for owner won't dealt with compound interest
263     uint256 public tokensFromEther=0;
264     uint public saleStatus=0;      // 0 - sale is running, 1 - sale failed, 2 - sale successful
265     address multisig=0x8216A5958f05ad61898e3A6F97ae5118C0e4b1A6;
266     // counters of tokens for futher refund
267     mapping(address => uint256) boughtWithEther;                // tokens, bought with ether. can be refunded to ether
268     mapping(address => uint256) boughtWithOther;    			// tokens, bought with other payment systems. can be refunded to other payment systems, using site
269     mapping(address => uint256) bountyAndRefsWithEther;  		// bounty tokens, given to some people. can be converted to ether, if ico is succeed
270   
271     
272 
273 		
274 		
275     // events
276     event RefundEther(address indexed to, uint256 tokens, uint256 eth); 
277     event DateUpdated(uint256 cdate);    
278     event DebugLog(string what, uint256 param);
279     event Sale(address indexed to, uint256 amount);
280     event Step0Finished();
281     event RateSet(uint256 newRate);	
282     event Burn(address indexed who, uint256 amount);
283    // DEBUG
284 
285     bool bDbgEnabled=false;
286 	
287 	
288 	
289     function MMMTokenCoin() public   {  
290         // Crowdsale     
291         currentDate=(getNow()/1 days)*1 days;
292         stage2StartTime=getNow()+61 days;
293         
294         balances[owner]=tokensForOwner;
295         globalInterestAmount=0;
296         
297         if(bDbgEnabled) softcap=20000;
298         else  softcap=50000000;
299     }
300 	
301 	
302 	function debugSetNow(uint256 n) public
303 	{
304 	    require(bDbgEnabled);
305 		debugNow=n;
306 	}
307 	
308 	
309 	 /**
310      * @dev Returns current timestamp. In case of debugging, this function can return timestamp representing any other time
311      */
312      
313      
314 	function getNow() public view returns (uint256)
315 	{
316 	    
317 	    if(!bDbgEnabled) return now;
318 	    
319 	    if(debugNow==0) return now;
320 		else return debugNow;
321 //		return now;
322 	}
323    
324     /**
325      * @dev Sets date from which interest will be calculated for specified address
326      * @param _owner - address of balance owner
327      */
328    
329     
330     function updateDate(address _owner) private {
331         if(currentDate<stage2StartTime) dateOfStart[_owner]=stage2StartTime;
332         else dateOfStart[_owner]=currentDate;
333     }
334     
335 
336 	
337     /**
338     * @dev Gets the balance of the specified address.
339     * @param _owner The address to query the the balance of. 
340     * @return An uint25664 representing the amount owned by the passed address.
341     */
342     function balanceOf(address _owner) public constant returns (uint256 balance) 
343     { 
344         
345          return balanceWithInterest(_owner);
346     }   
347    
348 	
349     /**
350      * @dev Gets balance including interest for specified address
351    	 * @param _owner The address to query the the balance of. 
352      */
353 		
354 		
355     function balanceWithInterest(address _owner)  private constant returns (uint256 ret)
356     {
357         if( _owner==owner || saleStatus!=2) return balances[_owner]; 
358         return balances[_owner].compoundInterest(stage2StartTime, dateOfStart[_owner], currentDate);
359     }
360     
361     
362     
363     
364     
365 
366 
367     /**
368     * @dev transfer token for a specified address
369     * @param _to The address to transfer to.
370     * @param _value The amount to be transferred.
371     */
372 		 
373   function transfer(address _to, uint256 _value)  public returns (bool) {
374     if(msg.sender==owner) {
375     	// if owner sends tokens before sale finish, consider then as ether-refundable bonus
376     	// else as simple transfer
377         if(saleStatus==0) {
378             	transferFromOwner(_to, _value,1);
379             	tokensFromEther=tokensFromEther.add(_value);
380 				bountyAndRefsWithEther[_to]=bountyAndRefsWithEther[_to].add(_value);
381         	}
382         	else transferFromOwner(_to, _value,0);
383         	
384         	increaseGlobalInterestAmount(_value);
385         	return true;   
386     }
387     
388     balances[msg.sender] = balanceWithInterest(msg.sender).sub(_value);
389 
390     emit Transfer(msg.sender, _to, _value);
391     if(_to==address(this)) {
392 		// make refund if tokens sent to contract
393         uint256 left; left=processRefundEther(msg.sender, _value);
394         balances[msg.sender]=balances[msg.sender].add(left);
395     }
396     else {
397         balances[_to] = balanceWithInterest(_to).add(_value);
398         updateDate(_to);
399     }
400     
401     if(_to==owner) 
402     {
403     	// before sale finish, tokens can't be sent to owner
404         require(saleStatus!=0);
405         decreaseGlobalInterestAmount(_value);
406     }
407     
408     updateDate(msg.sender);
409     return true;
410   }
411   
412   
413   /**
414     * @dev Transfer tokens from one address to another
415     * @param _from address The address which you want to send tokens from
416     * @param _to address The address which you want to transfer to
417     * @param _value uint256 the amount of tokens to be transfered
418     */
419 	  
420   
421    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
422            require(_to!=owner);
423     uint256 _allowance = allowed[_from][msg.sender];
424 
425      allowed[_from][msg.sender] = _allowance.sub(_value);
426 
427     if(_from==owner) {
428         if(saleStatus==0) {
429             transferFromOwner(_to, _value,1);
430             tokensFromEther=tokensFromEther.add(_value);
431 			bountyAndRefsWithEther[_to]=bountyAndRefsWithEther[_to].add(_value);			
432         }
433         else transferFromOwner(_to, _value,0);
434       
435         increaseGlobalInterestAmount(_value);
436         return true;
437     }
438      
439      
440     balances[_from] = balanceWithInterest(_from).sub(_value);
441 
442      emit Transfer(_from, _to, _value);
443 
444     if(_to==address(this)) {
445 		// make refund if tokens sent to contract		   
446         uint256 left; left=processRefundEther(_from, _value);
447         balances[_from]=balances[_from].add(left);
448     }
449     else {
450         balances[_to] = balanceWithInterest(_to).add(_value);
451         updateDate(_to);
452     }
453     
454     if(_to==owner) 
455     {
456         require(saleStatus!=0);
457         decreaseGlobalInterestAmount(_value);
458     }
459 
460     updateDate(_from);
461 
462     return true;
463   }
464   
465   
466   
467     /**
468     * @dev Burns tokens
469     * @param _amount amount of tokens to burn
470     */
471 	  
472 	  
473 	  
474   function burn(uint256 _amount) public 
475   {
476 	  	require(_amount>0);
477         balances[msg.sender]=balanceOf(msg.sender).sub(_amount);
478 		decreaseGlobalInterestAmount(_amount);
479         emit Burn(msg.sender, _amount);
480   }
481    
482    //// SALE ////
483    
484     /**
485      * @dev updates rate with whic tokens are being sold
486      */
487 
488  	function setRate(uint256 r) public {
489 		require(saleStatus!=0);
490 		currentRate=r;
491 		emit RateSet(currentRate);
492 	}
493 
494     /**
495      * @dev updates current date value. For compound interest calculation
496      */
497     
498     function newDay() public   returns (bool b)
499     {
500         
501        uint256 g; uint256 newDate;
502        require(getNow()>=stage2StartTime);
503        require(getNow()>=currentDate);
504        newDate=(getNow()/1 days)*1 days;
505         if(getNow()>=stage2StartTime && saleStatus==0)
506         {
507             if(tokensForOwner.sub(balances[owner])>=softcap) saleStatus=2;
508             else saleStatus=1;
509          
510             emit Step0Finished();
511         }
512       
513 	   // check if overall compound interest of tokens will be less than total supply
514 	  
515        g=globalInterestAmount.compoundInterest(stage2StartTime, globalInterestDate, newDate);
516        if(g<=totalSupply && saleStatus==2) {
517              currentDate=(getNow()/1 days)*1 days; 
518              globalInterestAmount=g;
519              globalInterestDate=currentDate;
520              emit DateUpdated(currentDate);
521              return true;
522        }
523        else if(saleStatus==1) currentDate=(getNow()/1 days)*1 days; 
524        
525        return false;
526     }
527     
528     
529     /**
530      * @dev Sends collected ether to owner. If sale is not success, contract will hold ether for half year, and after, ether can be sent to owner
531      * @return amount of owner's ether
532      */
533      
534     function sendEtherToMultisig() public  returns(uint256 e) {
535         uint256 req;
536         require(msg.sender==owner || msg.sender==multisig);
537         require(saleStatus!=0);
538 
539         if(saleStatus==2) {
540         	// calculate ether for refunds
541         	req=tokensFromEther.mul(1 ether).div(step0Rate).div(2);
542 
543         	if(bDbgEnabled) emit DebugLog("This balance is", this.balance);
544         	if(req>=this.balance) return 0;
545     	}
546     	else if(saleStatus==1) {
547     		require(getNow()-stage2StartTime>15768000);
548     		req=0; 
549     	}
550         uint256 amount;
551         amount=this.balance.sub(req);
552         multisig.transfer(amount);
553         return amount;
554         
555     }
556     
557 	
558 
559 
560 	
561 	
562 	/**
563 		Refund functions. 
564 		If ico is success, anyone can get 0.000005 eth for 1 token,  else 00001 eth
565 		
566 	*/
567 	
568     /**
569      * @dev Refunds ether to sender if he trasnfered tokens to contract address. Calculates max possible amount of refund. If sent tokens>refund amound, tokens will be returned to sender.
570      * @param _to Address of refund receiver
571      * @param _value Tokens requested for refund
572      */
573 	
574     function processRefundEther(address _to, uint256 _value) private returns (uint256 left)
575     {
576         require(saleStatus!=0);
577         require(_value>0);
578         uint256 Ether=0; uint256 bounty=0;  uint256 total=0;
579 
580         uint256 rate2=saleStatus;
581 
582         
583         if(_value>=boughtWithEther[_to]) {Ether=Ether.add(boughtWithEther[_to]); _value=_value.sub(boughtWithEther[_to]); }
584         else {Ether=Ether.add(_value); _value=_value.sub(Ether);}
585         boughtWithEther[_to]=boughtWithEther[_to].sub(Ether);
586         
587         if(rate2==2) {        
588             if(_value>=bountyAndRefsWithEther[_to]) {bounty=bounty.add(bountyAndRefsWithEther[_to]); _value=_value.sub(bountyAndRefsWithEther[_to]); }
589             else { bounty=bounty.add(_value); _value=_value.sub(bounty); }
590             bountyAndRefsWithEther[_to]=bountyAndRefsWithEther[_to].sub(bounty);
591         }
592         total=Ether.add(bounty);
593      //   if(_value>total) _value=_value.sub(total);
594         tokensFromEther=tokensFromEther.sub(total);
595        uint256 eth=total.mul(1 ether).div(step0Rate).div(rate2);
596          _to.transfer(eth);
597         if(bDbgEnabled) emit DebugLog("Will refund ", eth);
598 
599         emit RefundEther(_to, total, eth);
600         decreaseGlobalInterestAmount(total);
601         return _value;
602     }
603     
604     
605 	
606 
607 	     /**
608      * @dev Returns info about refundable tokens- bought with ether, payment systems, and bonus tokens convertable to ether
609      */
610 	
611 	function getRefundInfo(address _to) public returns (uint256, uint256, uint256)
612 	{
613 	    return  ( boughtWithEther[_to],  boughtWithOther[_to],  bountyAndRefsWithEther[_to]);
614 	    
615 	}
616 	
617     
618     /**
619      * @dev Withdraw tokens  refunded to other payment systems.
620      * @param _to Address of refund receiver
621      */
622     
623     function refundToOtherProcess(address _to, uint256 _value) public onlyOwner returns (uint256 o) {
624         require(saleStatus!=0);
625         //uint256 maxValue=refundToOtherGet(_to);
626         uint256 maxValue=0;
627         require(_value<=maxValue);
628         
629         uint256 Other=0; uint256 bounty=0; 
630 
631 
632 
633         
634         if(_value>=boughtWithOther[_to]) {Other=Other.add(boughtWithOther[_to]); _value=_value.sub(boughtWithOther[_to]); }
635         else {Other=Other.add(_value); _value=_value.sub(Other);}
636         boughtWithOther[_to]=boughtWithOther[_to].sub(Other);
637 
638        
639         balances[_to]=balanceOf(_to).sub(Other).sub(bounty);
640         updateDate(_to);
641         decreaseGlobalInterestAmount(Other.add(bounty));
642         return _value;
643         
644         
645     }
646     
647  
648     /**
649      * @dev Converts ether to our tokens 
650      */
651 		  
652     
653     function createTokensFromEther()  private   {
654                
655         assert(msg.value >= 1 ether / 1000);
656        
657          uint256 tokens = currentRate.mul(msg.value).div(1 ether);
658 
659 
660         transferFromOwner(msg.sender, tokens,2);
661       
662        if(saleStatus==0) {
663            boughtWithEther[msg.sender]=boughtWithEther[msg.sender].add(tokens);
664             tokensFromEther=tokensFromEther.add(tokens);
665        }
666       
667     }
668 	
669 	
670     /**
671      * @dev Converts other payments system payment to  tokens. Main logic is on site
672      */
673     
674     function createTokensFromOther(address _to, uint256 howMuch, address referer) public  onlyOwner   { 
675       
676         require(_to!=address(this));
677          transferFromOwner(_to, howMuch,2);
678          if(referer!=0 && referer!=address(this) && referer!=0x0000000000000000000000000000000000000000 && howMuch.div(10)>0) {
679              transferFromOwner(referer, howMuch.div(10),1);
680 	         if(saleStatus==0) {
681 	             	tokensFromEther=tokensFromEther.add( howMuch.div(10));
682 	 				bountyAndRefsWithEther[_to]=bountyAndRefsWithEther[_to].add( howMuch.div(10));
683 	         	}
684          }
685          if(saleStatus==0) boughtWithOther[_to]= boughtWithOther[_to].add(howMuch);
686     }
687 
688 	   /**
689      * @dev Gives refs tokens through payment on site. Main logic is on site
690      * @param _to Address of  receiver
691      * @param _amount Amount of tokens		
692 	 * @param t type of transfer. 0 is transfer, 1 bonus tokens, 2 - sale
693      */
694 	
695 	function transferFromOwner(address _to, uint256 _amount, uint t) private {
696 	   require(_to!=address(this) && _to!=address(owner) );
697         balances[owner]=balances[owner].sub(_amount); 
698         balances[_to]=balanceOf(_to).add(_amount);
699         updateDate(_to);
700 
701         increaseGlobalInterestAmount(_amount);
702 	    
703 	   
704 	     if(t==2) emit Sale(_to, _amount);
705         emit Transfer(owner, _to, _amount);	     
706 	}
707 	
708 
709     function increaseGlobalInterestAmount(uint256 c) private 
710     {
711         globalInterestAmount=globalInterestAmount.add(c);
712 		
713     }
714     
715     function decreaseGlobalInterestAmount(uint256 c) private
716     {
717         if(c<globalInterestAmount) {
718             globalInterestAmount=globalInterestAmount.sub(c);
719         }
720             
721         
722     }
723     
724     function() external payable {
725         createTokensFromEther();
726     }
727 
728     
729 }