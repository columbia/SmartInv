1 pragma solidity ^0.4.9;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47 }
48 
49 /**
50 	 * @title ERC20Basic
51 	 * @dev Simpler version of ERC20 interface
52 	 * @dev see https://github.com/ethereum/EIPs/issues/20
53 	 */
54 contract ERC20Basic {
55 	  uint256 public totalSupply;
56 	  function balanceOf(address who) constant returns (uint256);
57 	  function transfer(address to, uint256 value);
58 	  event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) constant returns (uint256);
67   function transferFrom(address from, address to, uint256 value);
68   function approve(address spender, uint256 value);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   /**
78    * @dev Fix for the ERC20 short address attack.
79    */
80   modifier onlyPayloadSize(uint256 size) {
81      require(!(msg.data.length < size + 4));
82      _;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of. 
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) constant returns (uint256 balance) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 /**
108  * @title Standard ERC20 token
109  *
110  * @dev Implemantation of the basic standart token.
111  * @dev https://github.com/ethereum/EIPs/issues/20
112  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
113  */
114 contract StandardToken is BasicToken, ERC20 {
115 
116   mapping (address => mapping (address => uint256)) allowed;
117 
118 
119   /**
120    * @dev Transfer tokens from one address to another
121    * @param _from address The address which you want to send tokens from
122    * @param _to address The address which you want to transfer to
123    * @param _value uint256 the amout of tokens to be transfered
124    */
125   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {
126     var _allowance = allowed[_from][msg.sender];
127 
128     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
129     // if (_value > _allowance) throw;
130 
131     balances[_to] = balances[_to].add(_value);
132     balances[_from] = balances[_from].sub(_value);
133     allowed[_from][msg.sender] = _allowance.sub(_value);
134     Transfer(_from, _to, _value);
135   }
136 
137   /**
138    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
139    * @param _spender The address which will spend the funds.
140    * @param _value The amount of tokens to be spent.
141    */
142   function approve(address _spender, uint256 _value) {
143 
144     // To change the approve amount you first have to reduce the addresses`
145     //  allowance to zero by calling `approve(_spender, 0)` if it is not
146     //  already 0 to mitigate the race condition described here:
147     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148     require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)) );
149 
150     allowed[msg.sender][_spender] = _value;
151     Approval(msg.sender, _spender, _value);
152   }
153 
154   /**
155    * @dev Function to check the amount of tokens than an owner allowed to a spender.
156    * @param _owner address The address which owns the funds.
157    * @param _spender address The address which will spend the funds.
158    * @return A uint256 specifing the amount of tokens still avaible for the spender.
159    */
160   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
161     return allowed[_owner][_spender];
162   }
163 
164 }
165 
166 contract Pixiu is StandardToken {
167 
168     uint public decimals = 6;
169     bool public isPayable = true;
170     bool public isWithdrawable = true;
171     bool public isRequireData = false;
172 	
173     struct exchangeRate {
174         
175         uint time1;                                      
176         uint time2;                                     
177         uint value;
178         
179     }
180     
181     struct Member {
182          
183         bool isExists;                                      
184         bool isDividend;                                    
185         bool isWithdraw;                                     
186         uint256 dividend;                                   
187         uint256 withdraw;
188         
189     }
190     
191     exchangeRate[] public exchangeRateArray;  
192 
193 	mapping (address => Member) public members; 
194     address[] public adminArray;   
195     address[] public memberArray;
196     
197 	 
198     address public deposit_address;
199     uint256 public tokenExchangeRateInWei = 300*10**6;
200 	
201 	/*
202     *虛擬帳號   共20碼
203     *1-4 固定 0xFFFFFFFF 
204     *5-8 繳費期限
205     *9-11 流水號 商家代碼 0x000000-0xFFFFFF
206     *12-15 商家自訂 4碼=8位 0-F
207     *16-18 金額
208     *19 :0x30 +4bit候補零
209     * 當 BYTE19 = 00  12-18 為商家自訂
210     *20 檢查碼 
211     */
212     mapping (address => uint) public shopStoreId; 
213     mapping (uint => address) public shopStoreAddress; 
214     uint256 public shopStorePrice = 1*10**6;
215     uint256 public shopStoreNextId = 0;
216     address public shopStoreRegister;
217 
218 	//不歸零
219 	
220 	uint256 public total_tokenwei = 0; 
221 	uint256 public min_pay_wei = 0;
222 	// admin_withdraw_all 歸零
223 	uint256 public total_devidend = 0; //member
224 	uint256 public total_withdraw = 0; //member
225     uint256 public deposit_amount = 0;  //deposit
226     uint256 public withdraw_amount = 0; //deposit
227     uint256 public dividend_amount = 0; //admin   
228     
229     event Paydata(address indexed payer, uint256 value, bytes data, uint256 thisTokenWei);
230     
231     function Pixiu() {
232         totalSupply = 21000000000000; 
233         adminArray.push(msg.sender);
234         admin_set_deposit(msg.sender);
235         admin_set_shopStoreRegister(msg.sender);
236          
237     }
238     
239     function get_orderAddress(address _address,uint _expire_day,uint _userdata,uint _amount) constant returns (address){
240         
241         uint256 storeid = shopStoreId[_address];
242         uint160 result = uint152(0xffffffff<<120) + uint120((_expire_day * 86400 + now)<<88) + uint88(storeid<<64); 
243         uint _zero = 0;
244         uint256 _amount2 = _amount * 10 ** 6;
245         while(_amount2 % 10 == 0){
246             
247             _amount2 /= 10;
248             _zero++;
249             
250         }
251         
252         _userdata = _userdata<<16;
253         _userdata += _amount;
254         
255         result += uint64(_userdata<<8);
256         result += uint8(0x30+_zero);
257         uint8 crc = uint8(sha256(uint152(result) ));
258         return address((result << 8) + crc);
259     }
260     
261     function isLeading4FF(address _sender ) private  returns(bool){
262         uint32 ff4= uint32(uint256(_sender) >> 128);
263         return (ff4 == 0xffffffff);
264     }
265 
266     modifier onlyDeposit() {
267         
268         require(msg.sender == deposit_address);
269         _;
270         
271     }
272     
273     modifier onlyAdmin() {
274         
275         bool ok = admin_check(msg.sender);
276         require(ok);
277         _;
278         
279     }
280     
281     modifier adminExists(address admin) {
282 
283         bool ok = false;
284         if(admin != msg.sender){
285             
286             ok = admin_check(admin);
287         
288         }
289         require(ok);
290         _; 
291         
292     }
293     
294     modifier adminDoesNotExist(address admin) {
295 
296         bool ok = admin_check(admin);
297         require(!ok);
298         _;
299         
300     }
301     
302     function admin_check(address admin) private constant returns(bool){
303         
304         bool ok = false;
305         
306         for (uint i = 0; i < adminArray.length; i++) {
307             if (admin == adminArray[i]) {
308                 ok = true;
309                 break;
310             }
311         }
312         
313         return ok;
314         
315     }
316     
317     modifier memberExists(address member) {
318 
319         bool ok = false;
320         if (members[member].isExists == true) {
321             
322             ok = true;
323             
324         }
325         require(ok);
326         _;
327         
328     }
329     
330     modifier isMember() {
331 
332         bool ok = false;
333         if (members[msg.sender].isExists == true) {            
334             ok = true;            
335         }
336         require(ok);
337         _;
338         
339     }
340     
341     function admin_deposit(int _Eth, int _Wei) onlyAdmin{
342         
343         int xWei = _Eth * 10 ** 18 + _Wei;
344         if(xWei > 0){
345             
346             deposit_amount += uint256(xWei);
347             
348         }else{
349             
350             deposit_amount -= uint256(xWei * -1);
351             
352         } 
353         
354         
355     }
356     
357     /**	*	管理員發放股息	*	每個會員股息依 	*	*/
358     function admin_dividend(int _Eth, int _Wei) onlyAdmin {
359         
360         int xWei = _Eth * 10 ** 18 + _Wei;
361 		bool is_add = true;
362 
363         if(xWei > 0){
364             
365             require(uint256(xWei) <= (deposit_amount-dividend_amount) ); 
366             dividend_amount += uint256(xWei);
367             
368         }else{
369             
370             xWei *= -1;
371             is_add = false;
372             require(uint256(xWei) <= deposit_amount); 
373             dividend_amount -= uint256(xWei * -1);
374             
375         } 
376         
377         uint256 len = memberArray.length;	
378         uint i = 0;
379         address _member;
380         
381 		uint total_balance_dividened=0;
382         for( i = 0; i < len; i++){            
383             _member = memberArray[i];
384 			if(members[_member].isDividend){
385 				total_balance_dividened += balances[_member]; 
386 			}            
387         }
388             
389         for( i = 0; i < len; i++){            
390             _member = memberArray[i];
391 			if(members[_member].isDividend){
392 				uint256 thisWei = balances[_member] * uint256(xWei) / total_balance_dividened;
393 				if(is_add){
394 				    members[_member].dividend += thisWei; 
395 				    total_devidend += thisWei;
396 				}else{
397 				    members[_member].dividend -= thisWei; 
398 				    total_devidend -= thisWei;
399 				}
400 			}            
401         }
402     
403     }
404     
405     function admin_set_exchange_rate(uint[] exchangeRates) onlyAdmin{
406          
407         uint len = exchangeRates.length;
408         exchangeRateArray.length = 0;
409         
410         for(uint i = 0; i < len; i += 3){
411             
412             uint time1 = exchangeRates[i];
413             uint time2 = exchangeRates[i + 1];
414             uint value = exchangeRates[i + 2]*1000;
415             exchangeRateArray.push(exchangeRate(time1, time2, value));      
416             
417         }
418         
419     }
420     
421     function admin_set_shopStoreRegister(address _address) onlyAdmin{
422         
423         shopStoreRegister = _address;
424         
425     }
426     
427     function admin_set_ExchangeRateInWei(uint256 exchangeRates) onlyAdmin{
428         
429         tokenExchangeRateInWei = exchangeRates;
430         
431     }
432 
433 	function get_exchange_wei() constant returns(uint256){
434 
435 		uint len = exchangeRateArray.length;  
436 		uint nowTime = block.timestamp;
437         for(uint i = 0; i < len; i += 3){
438             
439 			exchangeRate memory rate = exchangeRateArray[i];
440             uint time1 = rate.time1;
441             uint time2 = rate.time2;
442             uint value = rate.value;
443 			if (nowTime>= time1 && nowTime<=time2) {
444 				tokenExchangeRateInWei = value;
445 				return value;
446 			}
447             
448         }
449 		return tokenExchangeRateInWei;
450 	}
451 	
452 	function admin_set_min_pay(uint256 _min_pay) onlyAdmin{
453 	    
454 	    require(_min_pay >= 0);
455 	    min_pay_wei = _min_pay;
456 	    
457 	}
458     
459     function get_admin_list() constant returns(address[] _adminArray){
460         
461         _adminArray = adminArray;
462         
463     }
464     
465     function admin_add(address admin) onlyAdmin adminDoesNotExist(admin){
466         
467         adminArray.push(admin);
468         
469     }
470     
471     function admin_del(address admin) onlyAdmin adminExists(admin){
472         
473         for (uint i = 0; i < adminArray.length - 1; i++)
474             if (adminArray[i] == admin) {
475                 adminArray[i] = adminArray[adminArray.length - 1];
476                 break;
477             }
478             
479         adminArray.length -= 1;
480         
481     }
482     
483     function admin_set_deposit(address addr) onlyAdmin{
484         
485         deposit_address = addr;
486         
487     }
488     
489     function admin_set_shopStorePrice(uint256 _shopStorePrice) onlyAdmin{
490         
491         shopStorePrice = _shopStorePrice;
492         
493     }
494     
495     function admin_set_isRequireData(bool _requireData) onlyAdmin{
496     
497         isRequireData = _requireData;
498         
499     }
500     
501     function admin_set_payable(bool _payable) onlyAdmin{
502     
503         isPayable = _payable;
504         
505     }
506     
507     function admin_set_withdrawable(bool _withdrawable) onlyAdmin{
508         
509         isWithdrawable = _withdrawable;
510         
511     }
512     
513     function admin_set_dividend(address _member, bool _dividend) onlyAdmin memberExists(_member){
514         
515         members[_member].isDividend = _dividend;
516         
517     }
518     
519     function admin_set_withdraw(address _member, bool _withdraw) onlyAdmin memberExists(_member){
520         
521         members[_member].isWithdraw = _withdraw;
522         
523     }
524     
525     function get_total_info() constant returns(uint256 _deposit_amount, uint256 _total_devidend, uint256 _total_remain, uint256 _total_withdraw){
526 
527         _total_remain = total_devidend - total_withdraw;
528         _deposit_amount = deposit_amount;
529         _total_devidend = total_devidend;
530         _total_withdraw = total_withdraw;
531         
532     }
533     
534     function get_info(address _member) constant returns (uint256 _balance, uint256 _devidend, uint256 _remain, uint256 _withdraw){
535         
536         _devidend = members[_member].dividend;
537         _withdraw = members[_member].withdraw;
538         _remain = _devidend - _withdraw;
539         _balance = balances[_member];
540         
541     }
542     
543     function withdraw() isMember {
544         
545         uint256 _remain = members[msg.sender].dividend - members[msg.sender].withdraw;
546         require(_remain > 0);
547         require(isWithdrawable);
548         require(members[msg.sender].isWithdraw);
549         msg.sender.transfer(_remain);
550         members[msg.sender].withdraw += _remain; 
551         total_withdraw += _remain;          
552 
553     }
554 
555     function admin_withdraw(uint xWei) onlyDeposit{
556 
557         uint256 _withdraw = xWei;
558 		require( msg.sender == deposit_address );
559 
560 		require(this.balance > _withdraw);
561 		msg.sender.transfer(_withdraw);
562 
563         withdraw_amount += _withdraw;  
564         
565     }
566     
567     function admin_withdraw_all(address _deposit) onlyAdmin {
568         
569 		require( _deposit == deposit_address ); 
570 
571 		_deposit.transfer(this.balance);
572 
573 		total_devidend = 0; //member
574 		total_withdraw = 0; //member
575 		deposit_amount = 0;  //deposit
576 		withdraw_amount = 0; //deposit
577 		dividend_amount = 0; //admin   
578         
579     }
580     
581     function admin_transfer(address _to, uint256 _value) onlyAdmin onlyPayloadSize(2 * 32)     {
582         
583         require(_to != deposit_address);
584         require(total_tokenwei <= totalSupply - _value);
585         balances[_to] = balances[_to].add(_value);
586         
587         total_tokenwei += _value;
588     
589         if (members[_to].isExists != true) {  
590             members[_to].isExists = true;
591             members[_to].isDividend = true;
592             members[_to].isWithdraw = true; 
593             memberArray.push(_to);  
594         }
595         
596     }
597  
598 	function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32)     {
599 	    
600 		require(_to != msg.sender);
601         require(isPayable);
602 		balances[msg.sender] = balances[msg.sender].sub(_value);
603 		
604 		if(_to == deposit_address){
605 		    
606 		    require(_value == shopStorePrice);
607 		    shopStoreNextId++;
608 		    shopStoreId[msg.sender] = shopStoreNextId;
609 		    shopStoreAddress[shopStoreNextId] = msg.sender;
610 		
611 		} else { 
612 		    
613 		    if(isLeading4FF(_to)){
614 		    
615     		    uint256 to256 = uint256(_to);
616                 uint32 expire = uint32(to256>>96);
617                 uint32 storeid = uint24(to256>>72);
618                 //uint8 crc8 = uint8(to256);
619                 //uint8 byte19 = uint8(to256>>8);
620                 uint8 byte19_1 = uint8(uint8(to256>>8)>>4);
621                 uint8 byte19_2 = uint8(uint8(to256>>8)<<4);
622                 byte19_2 = byte19_2>>4;
623                 uint56 byte1218 = uint56(to256>>16);
624                 uint32 byte1215 = uint32(to256>>40);
625                 uint24 byte1618 = uint24(to256>>16);
626                 
627                 require(uint32(now)<expire || expire==0);
628                 
629                 //uint8 crc20 = uint8(sha256(uint152(to256>>8)));
630                 require(uint8(sha256(uint152(to256>>8)))==uint8(to256));
631                 
632                 _to = shopStoreAddress[uint(storeid)];
633                 require(uint(_to)>0);
634     
635                 if(byte19_1 == 3){
636                 
637                     for(int i = 0; i < byte19_2; i++){
638                         byte1618 *= 10;
639                     }
640                     
641                     require(byte1618 == _value);
642                 
643                 }
644     		
645     		}
646 		    
647     		balances[_to] = balances[_to].add(_value);
648     		if (members[_to].isExists != true) {		
649     			members[_to].isExists = true;
650     			members[_to].isDividend = true;
651     			members[_to].isWithdraw = true; 
652     			memberArray.push(_to);		
653     		}  
654 
655         }
656 
657 		Transfer(msg.sender, _to, _value);
658 	}
659 	
660 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32)     {
661 		require(_to != deposit_address);
662 		require(_from != deposit_address);
663         require(isPayable);
664 		var _allowance = allowed[_from][msg.sender]; 
665 		require(_allowance >= _value);
666 
667 		balances[_to] = balances[_to].add(_value);
668 		balances[_from] = balances[_from].sub(_value);
669 		allowed[_from][msg.sender] = _allowance.sub(_value);
670 		
671 		if (members[_to].isExists != true) {		
672 			members[_to].isExists = true;
673 			members[_to].isDividend = true;
674 			members[_to].isWithdraw = true; 
675 			memberArray.push(_to);		
676 		}  
677 
678 		Transfer(_from, _to, _value);
679 	}
680 
681     function () payable {
682         
683         pay();
684         
685     }
686   
687     function pay() public payable  returns (bool) {
688         
689         require(!isLeading4FF(msg.sender));
690         require(msg.value > min_pay_wei);
691         require(isPayable);
692         
693         if(msg.sender == deposit_address){
694              deposit_amount += msg.value;
695         }else{
696             
697             if(isRequireData){
698                 require(uint32(msg.data[0]) == uint32(0xFFFFFFFF));   
699             }
700         
701     		uint256 exchangeWei = get_exchange_wei();
702     		uint256 thisTokenWei = exchangeWei * msg.value / 10**18 ;
703     		
704     		require(total_tokenwei <= totalSupply - thisTokenWei);
705         
706             if (members[msg.sender].isExists != true) {
707                 
708                 members[msg.sender].isExists = true;
709                 members[msg.sender].isDividend = true;
710                 members[msg.sender].isWithdraw = true; 
711                 memberArray.push(msg.sender);
712                 
713             }  
714     		balances[msg.sender] += thisTokenWei;
715     		total_tokenwei += thisTokenWei;
716     		
717     		Paydata(msg.sender, msg.value, msg.data, thisTokenWei);
718     		Transfer(this, msg.sender, thisTokenWei);
719 		
720         }
721         
722         return true;
723     
724     }
725             
726     function get_this_balance() constant returns(uint256){
727       
728         return this.balance;
729       
730     }
731     
732 }