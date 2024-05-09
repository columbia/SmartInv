1 pragma solidity ^0.4.13;
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
198     uint256 public tokenExchangeRateInWei = 300*10**6;
199 	
200 	/*
201     *虛擬帳號   共20碼
202     *1-4 固定 0xFFFFFFFF 
203     *5-8 繳費期限
204     *9-11 流水號 商家代碼 0x000000-0xFFFFFF
205     *12-15 商家自訂 4碼=8位 0-F
206     *16-18 金額
207     *19 :0x30 +4bit候補零
208     * 當 BYTE19 = 00  12-18 為商家自訂
209     *20 檢查碼 
210     */
211     mapping (address => uint) public shopStoreId; 
212     mapping (uint => address) public shopStoreAddress; 
213     uint256 public shopStorePrice = 1*10**6;
214     uint256 public shopStoreNextId = 0;
215     address public Apply_Store_Id_Fee;
216 	uint256 public total_tokenwei = 0; 
217 	uint256 public min_pay_wei = 0;
218 	uint256 public total_devidend = 0; 
219 	uint256 public total_withdraw = 0; 
220     uint256 public withdraw_amount = 0; 
221     uint256 public dividend_amount = 0; 
222     
223     event Paydata(address indexed payer, uint256 value, bytes data, uint256 thisTokenWei);
224     
225     function Pixiu() {
226         totalSupply = 21000000000000; 
227         adminArray.push(msg.sender);
228         admin_set_Apply_Store_Id_Fee(msg.sender);
229          
230     }
231     
232     function get_orderAddress(address _address,uint _expire_day,uint _userdata,uint _pixiu, uint _wei) constant returns (address){
233         
234         uint256 storeid = shopStoreId[_address];
235         uint160 result = uint152(0xffffffff<<120) + uint120((_expire_day * 86400 + now)<<88) + uint88(storeid<<64); 
236         uint _zero = 0;
237         uint256 _amount2 = _pixiu * 10 ** 6 + _wei;
238         uint256 _amount = _amount2;
239         while(_amount2 % 10 == 0){
240             
241             _amount2 /= 10;
242             _zero++;
243             
244         }
245         
246         _userdata = _userdata<<24;
247         _userdata += _amount;
248         
249         result += uint64(_userdata<<8);
250         result += uint8(0x30+_zero);
251         uint8 crc = uint8(sha256(uint152(result) ));
252         return address((result << 8) + crc);
253     }
254     
255     function isLeading4FF(address _sender ) private  returns(bool){
256         uint32 ff4= uint32(uint256(_sender) >> 128);
257         return (ff4 == 0xffffffff);
258     }
259     
260     modifier onlyAdmin() {
261         
262         bool ok = admin_check(msg.sender);
263         require(ok);
264         _;
265         
266     }
267     
268     modifier adminExists(address admin) {
269 
270         bool ok = false;
271         if(admin != msg.sender){
272             
273             ok = admin_check(admin);
274         
275         }
276         require(ok);
277         _; 
278         
279     }
280     
281     modifier adminDoesNotExist(address admin) {
282 
283         bool ok = admin_check(admin);
284         require(!ok);
285         _;
286         
287     }
288     
289     function admin_check(address admin) private constant returns(bool){
290         
291         bool ok = false;
292         
293         for (uint i = 0; i < adminArray.length; i++) {
294             if (admin == adminArray[i]) {
295                 ok = true;
296                 break;
297             }
298         }
299         
300         return ok;
301         
302     }
303     
304     modifier memberExists(address member) {
305 
306         bool ok = false;
307         if (members[member].isExists == true) {
308             
309             ok = true;
310             
311         }
312         require(ok);
313         _;
314         
315     }
316     
317     modifier isMember() {
318 
319         bool ok = false;
320         if (members[msg.sender].isExists == true) {            
321             ok = true;            
322         }
323         require(ok);
324         _;
325         
326     }
327     
328     function admin_dividend(int _Eth, int _Wei) onlyAdmin {
329         
330         int xWei = _Eth * 10 ** 18 + _Wei;
331 		bool is_add = true;
332 
333         if(xWei > 0){
334             
335             dividend_amount += uint256(xWei);
336             
337         }else{
338             
339             xWei *= -1;
340             is_add = false;
341             dividend_amount -= uint256(xWei * -1);
342             
343         } 
344         
345         uint256 len = memberArray.length;	
346         uint i = 0;
347         address _member;
348         
349 		uint total_balance_dividened=0;
350         for( i = 0; i < len; i++){            
351             _member = memberArray[i];
352 			if(members[_member].isDividend){
353 				total_balance_dividened += balances[_member]; 
354 			}            
355         }
356             
357         for( i = 0; i < len; i++){            
358             _member = memberArray[i];
359 			if(members[_member].isDividend){
360 				uint256 thisWei = balances[_member] * uint256(xWei) / total_balance_dividened;
361 				if(is_add){
362 				    members[_member].dividend += thisWei; 
363 				    total_devidend += thisWei;
364 				}else{
365 				    members[_member].dividend -= thisWei; 
366 				    total_devidend -= thisWei;
367 				}
368 			}            
369         }
370     
371     }
372     
373     function admin_set_exchange_rate(uint[] exchangeRates) onlyAdmin{
374          
375         uint len = exchangeRates.length;
376         exchangeRateArray.length = 0;
377         
378         for(uint i = 0; i < len; i += 3){
379             
380             uint time1 = exchangeRates[i];
381             uint time2 = exchangeRates[i + 1];
382             uint value = exchangeRates[i + 2]*1000;
383             exchangeRateArray.push(exchangeRate(time1, time2, value));      
384             
385         }
386         
387     }
388     
389     function admin_set_Apply_Store_Id_Fee(address _address) onlyAdmin{
390         
391         Apply_Store_Id_Fee = _address;
392         
393     }
394     
395     function admin_set_ExchangeRateInWei(uint256 exchangeRates) onlyAdmin{
396         
397         tokenExchangeRateInWei = exchangeRates;
398         
399     }
400 
401 	function get_exchange_wei() constant returns(uint256){
402 
403 		uint len = exchangeRateArray.length;  
404 		uint nowTime = block.timestamp;
405         for(uint i = 0; i < len; i += 3){
406             
407 			exchangeRate memory rate = exchangeRateArray[i];
408             uint time1 = rate.time1;
409             uint time2 = rate.time2;
410             uint value = rate.value;
411 			if (nowTime>= time1 && nowTime<=time2) {
412 				tokenExchangeRateInWei = value;
413 				return value;
414 			}
415             
416         }
417 		return tokenExchangeRateInWei;
418 	}
419 	
420 	function admin_set_min_pay(uint256 _min_pay) onlyAdmin{
421 	    
422 	    require(_min_pay >= 0);
423 	    min_pay_wei = _min_pay;
424 	    
425 	}
426     
427     function get_admin_list() constant returns(address[] _adminArray){
428         
429         _adminArray = adminArray;
430         
431     }
432     
433     function admin_add(address admin) onlyAdmin adminDoesNotExist(admin){
434         
435         adminArray.push(admin);
436         
437     }
438     
439     function admin_del(address admin) onlyAdmin adminExists(admin){
440         
441         for (uint i = 0; i < adminArray.length - 1; i++)
442             if (adminArray[i] == admin) {
443                 adminArray[i] = adminArray[adminArray.length - 1];
444                 break;
445             }
446             
447         adminArray.length -= 1;
448         
449     }
450     
451     function admin_set_shopStorePrice(uint256 _shopStorePrice) onlyAdmin{
452         
453         shopStorePrice = _shopStorePrice;
454         
455     }
456     
457     function admin_set_isRequireData(bool _requireData) onlyAdmin{
458     
459         isRequireData = _requireData;
460         
461     }
462     
463     function admin_set_payable(bool _payable) onlyAdmin{
464     
465         isPayable = _payable;
466         
467     }
468     
469     function admin_set_withdrawable(bool _withdrawable) onlyAdmin{
470         
471         isWithdrawable = _withdrawable;
472         
473     }
474     
475     function admin_set_dividend(address _member, bool _dividend) onlyAdmin memberExists(_member){
476         
477         members[_member].isDividend = _dividend;
478         
479     }
480     
481     function admin_set_withdraw(address _member, bool _withdraw) onlyAdmin memberExists(_member){
482         
483         members[_member].isWithdraw = _withdraw;
484         
485     }
486     
487     function get_total_info() constant returns(uint256 _total_devidend, uint256 _total_remain, uint256 _total_withdraw){
488 
489         _total_remain = total_devidend - total_withdraw;
490         _total_devidend = total_devidend;
491         _total_withdraw = total_withdraw;
492         
493     }
494     
495     function get_info(address _member) constant returns (uint256 _balance, uint256 _devidend, uint256 _remain, uint256 _withdraw){
496         
497         _devidend = members[_member].dividend;
498         _withdraw = members[_member].withdraw;
499         _remain = _devidend - _withdraw;
500         _balance = balances[_member];
501         
502     }
503     
504     function withdraw() isMember {
505         
506         uint256 _remain = members[msg.sender].dividend - members[msg.sender].withdraw;
507         require(_remain > 0);
508         require(isWithdrawable);
509         require(members[msg.sender].isWithdraw);
510         msg.sender.transfer(_remain);
511         members[msg.sender].withdraw += _remain; 
512         total_withdraw += _remain;          
513 
514     }
515 
516     function admin_withdraw(uint xWei){
517 
518         uint256 _withdraw = xWei;
519 		require( msg.sender == Apply_Store_Id_Fee );
520 
521 		require(this.balance > _withdraw);
522 		msg.sender.transfer(_withdraw);
523 
524         withdraw_amount += _withdraw;  
525         
526     }
527     
528     function admin_withdraw_all(address _ApplyStoreIdFee) onlyAdmin {
529         
530 		require( _ApplyStoreIdFee == Apply_Store_Id_Fee ); 
531 
532 		_ApplyStoreIdFee.transfer(this.balance);
533 
534 		total_devidend = 0; //member
535 		total_withdraw = 0; //member
536 		withdraw_amount = 0; //deposit
537 		dividend_amount = 0; //admin   
538         
539     }
540     
541     function admin_transfer(address _to, uint256 _value) onlyAdmin onlyPayloadSize(2 * 32)     {
542         
543         require(_to != Apply_Store_Id_Fee);
544         require(total_tokenwei <= totalSupply - _value);
545         balances[_to] = balances[_to].add(_value);
546         
547         total_tokenwei += _value;
548     
549         if (members[_to].isExists != true) {  
550             members[_to].isExists = true;
551             members[_to].isDividend = true;
552             members[_to].isWithdraw = true; 
553             memberArray.push(_to);  
554         }
555         
556     }
557  
558 	function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32)     {
559 	    
560 		require(_to != msg.sender);
561         require(isPayable);
562 		balances[msg.sender] = balances[msg.sender].sub(_value);
563 		
564 		if(_to == Apply_Store_Id_Fee){
565 		    
566 		    require(_value == shopStorePrice);
567 		    shopStoreNextId++;
568 		    shopStoreId[msg.sender] = shopStoreNextId;
569 		    shopStoreAddress[shopStoreNextId] = msg.sender;
570 		
571 		} else { 
572 		    
573 		    if(isLeading4FF(_to)){
574 		    
575     		    uint256 to256 = uint256(_to);
576                 uint32 expire = uint32(to256>>96);
577                 uint32 storeid = uint24(to256>>72);
578                 uint8 byte19_1 = uint8(uint8(to256>>8)>>4);
579                 uint8 byte19_2 = uint8(uint8(to256>>8)<<4);
580                 byte19_2 = byte19_2>>4;
581                 uint24 byte1618 = uint24(to256>>16);
582                 
583                 require(uint32(now)<expire || expire==0);
584                 
585                 require(uint8(sha256(uint152(to256>>8)))==uint8(to256));
586                 
587                 _to = shopStoreAddress[uint(storeid)];
588                 require(uint(_to)>0);
589     
590                 if(byte19_1 == 3){
591                 
592                     for(int i = 0; i < byte19_2; i++){
593                         byte1618 *= 10;
594                     }
595                     
596                     require(byte1618 == _value);
597                 
598                 }
599     		
600     		}
601 		    
602     		balances[_to] = balances[_to].add(_value);
603     		if (members[_to].isExists != true) {		
604     			members[_to].isExists = true;
605     			members[_to].isDividend = true;
606     			members[_to].isWithdraw = true; 
607     			memberArray.push(_to);		
608     		}  
609 
610         }
611 
612 		Transfer(msg.sender, _to, _value);
613 	}
614 	
615 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32)     {
616 		require(_to != Apply_Store_Id_Fee);
617 		require(_from != Apply_Store_Id_Fee);
618         require(isPayable);
619 		var _allowance = allowed[_from][msg.sender]; 
620 		require(_allowance >= _value);
621 
622 		balances[_to] = balances[_to].add(_value);
623 		balances[_from] = balances[_from].sub(_value);
624 		allowed[_from][msg.sender] = _allowance.sub(_value);
625 		
626 		if (members[_to].isExists != true) {		
627 			members[_to].isExists = true;
628 			members[_to].isDividend = true;
629 			members[_to].isWithdraw = true; 
630 			memberArray.push(_to);		
631 		}  
632 
633 		Transfer(_from, _to, _value);
634 	}
635 
636     function () payable {
637         
638         pay();
639         
640     }
641   
642     function pay() public payable  returns (bool) {
643         
644         require(!isLeading4FF(msg.sender));
645         require(msg.value > min_pay_wei);
646         require(isPayable);
647         
648         if(msg.sender == Apply_Store_Id_Fee){
649 
650         }else{
651             
652             if(isRequireData){
653                 require(uint32(msg.data[0]) == uint32(0xFFFFFFFF));   
654             }
655         
656     		uint256 exchangeWei = get_exchange_wei();
657     		uint256 thisTokenWei = exchangeWei * msg.value / 10**18 ;
658     		
659     		require(total_tokenwei <= totalSupply - thisTokenWei);
660         
661             if (members[msg.sender].isExists != true) {
662                 
663                 members[msg.sender].isExists = true;
664                 members[msg.sender].isDividend = true;
665                 members[msg.sender].isWithdraw = true; 
666                 memberArray.push(msg.sender);
667                 
668             }  
669     		balances[msg.sender] += thisTokenWei;
670     		total_tokenwei += thisTokenWei;
671     		
672     		Paydata(msg.sender, msg.value, msg.data, thisTokenWei);
673     		Transfer(this, msg.sender, thisTokenWei);
674 		
675         }
676         
677         return true;
678     
679     }
680             
681     function get_this_balance() constant returns(uint256){
682       
683         return this.balance;
684       
685     }
686     
687 }