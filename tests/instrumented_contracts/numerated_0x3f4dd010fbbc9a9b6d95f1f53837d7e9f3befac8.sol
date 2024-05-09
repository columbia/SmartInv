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
206     *12-16 商家自訂 4碼=8位 0-F
207     *17-18 金額
208     *19 :0x20 +4bit候補零
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
239     function get_orderAddress(address _address,uint _expire_day,uint _userdata,uint _amount ,uint _zero) constant returns (uint256){
240         uint256 storeid = shopStoreId[_address];
241         uint160 result = uint152(0xffffffff<<120) + uint120((_expire_day * 86400 + now)<<88) + uint88(storeid<<64); 
242         
243             _userdata = _userdata<<16;
244             _userdata += _amount;
245         
246         result += uint64(_userdata<<8);
247         result += uint8(0x20+_zero);
248         uint8 crc = uint8(sha256(uint152(result) ));
249         return (result << 8) + crc;
250     }
251     
252     function isLeading4FF(address _sender ) private  returns(bool){
253         uint32 ff4= uint32(uint256(_sender) >> 128);
254         return (ff4 == 0xffffffff);
255     }
256 
257     modifier onlyDeposit() {
258         
259         require(msg.sender == deposit_address);
260         _;
261         
262     }
263     
264     modifier onlyAdmin() {
265         
266         bool ok = admin_check(msg.sender);
267         require(ok);
268         _;
269         
270     }
271     
272     modifier adminExists(address admin) {
273 
274         bool ok = false;
275         if(admin != msg.sender){
276             
277             ok = admin_check(admin);
278         
279         }
280         require(ok);
281         _; 
282         
283     }
284     
285     modifier adminDoesNotExist(address admin) {
286 
287         bool ok = admin_check(admin);
288         require(!ok);
289         _;
290         
291     }
292     
293     function admin_check(address admin) private constant returns(bool){
294         
295         bool ok = false;
296         
297         for (uint i = 0; i < adminArray.length; i++) {
298             if (admin == adminArray[i]) {
299                 ok = true;
300                 break;
301             }
302         }
303         
304         return ok;
305         
306     }
307     
308     modifier memberExists(address member) {
309 
310         bool ok = false;
311         if (members[member].isExists == true) {
312             
313             ok = true;
314             
315         }
316         require(ok);
317         _;
318         
319     }
320     
321     modifier isMember() {
322 
323         bool ok = false;
324         if (members[msg.sender].isExists == true) {            
325             ok = true;            
326         }
327         require(ok);
328         _;
329         
330     }
331     
332     function admin_deposit(uint xEth) onlyAdmin{
333         
334         uint256 xwei = xEth * 10**18;
335         deposit_amount += xwei;
336         
337     }
338     
339     /**	*	管理員發放股息	*	每個會員股息依 	*	*/
340     function admin_dividend(uint xEth) onlyAdmin{
341         
342 		uint256 xwei = xEth * 10**18;
343 		require(xwei <= (deposit_amount-dividend_amount) ); 
344 
345 		dividend_amount += xwei;
346         uint256 len = memberArray.length;	
347         uint i = 0;
348         address _member;
349         
350 		uint total_balance_dividened=0;
351         for( i = 0; i < len; i++){            
352             _member = memberArray[i];
353 			if(members[_member].isDividend){
354 				total_balance_dividened = balances[_member]; 
355 			}            
356         }
357 		uint256 perTokenWei = xwei / (total_balance_dividened / 10 ** 6);
358             
359         for( i = 0; i < len; i++){            
360             _member = memberArray[i];
361 			if(members[_member].isDividend){
362 				uint256 thisWei = (balances[_member] / 10 ** 6) * perTokenWei;
363 				members[_member].dividend += thisWei; 
364 				total_devidend += thisWei;
365 			}            
366         }
367     
368     }
369     
370     function admin_set_exchange_rate(uint[] exchangeRates) onlyAdmin{
371          
372         uint len = exchangeRates.length;
373         exchangeRateArray.length = 0;
374         
375         for(uint i = 0; i < len; i += 3){
376             
377             uint time1 = exchangeRates[i];
378             uint time2 = exchangeRates[i + 1];
379             uint value = exchangeRates[i + 2]*1000;
380             exchangeRateArray.push(exchangeRate(time1, time2, value));      
381             
382         }
383         
384     }
385     
386     
387     
388     function admin_set_shopStoreRegister(address _address) onlyAdmin{
389         
390         shopStoreRegister = _address;
391         
392     }
393     
394     function admin_set_exchange_rate(uint256 exchangeRates) onlyAdmin{
395         
396         tokenExchangeRateInWei = exchangeRates;
397         
398     }
399 
400 	function get_exchange_wei() constant returns(uint256){
401 
402 		uint len = exchangeRateArray.length;  
403 		uint nowTime = block.timestamp;
404         for(uint i = 0; i < len; i += 3){
405             
406 			exchangeRate memory rate = exchangeRateArray[i];
407             uint time1 = rate.time1;
408             uint time2 = rate.time2;
409             uint value = rate.value;
410 			if (nowTime>= time1 && nowTime<=time2) {
411 				tokenExchangeRateInWei = value;
412 				return value;
413 			}
414             
415         }
416 		return tokenExchangeRateInWei;
417 	}
418 	
419 	function admin_set_min_pay(uint256 _min_pay) onlyAdmin{
420 	    
421 	    require(_min_pay >= 0);
422 	    min_pay_wei = _min_pay * 10 ** 18;
423 	    
424 	}
425     
426     function get_admin_list() constant returns(address[] _adminArray){
427         
428         _adminArray = adminArray;
429         
430     }
431     
432     function admin_add(address admin) onlyAdmin adminDoesNotExist(admin){
433         
434         adminArray.push(admin);
435         
436     }
437     
438     function admin_del(address admin) onlyAdmin adminExists(admin){
439         
440         for (uint i = 0; i < adminArray.length - 1; i++)
441             if (adminArray[i] == admin) {
442                 adminArray[i] = adminArray[adminArray.length - 1];
443                 break;
444             }
445             
446         adminArray.length -= 1;
447         
448     }
449     
450     function admin_set_deposit(address addr) onlyAdmin{
451         
452         deposit_address = addr;
453         
454     }
455     
456     function admin_set_shopStorePrice(uint256 _shopStorePrice) onlyAdmin{
457         
458         shopStorePrice = _shopStorePrice;
459         
460     }
461     
462     function admin_set_isRequireData(bool _requireData) onlyAdmin{
463     
464         isRequireData = _requireData;
465         
466     }
467     
468     function admin_active_payable() onlyAdmin{
469     
470         isPayable = true;
471         
472     }
473     
474     function admin_inactive_payable() onlyAdmin{
475         
476         isPayable = false;
477         
478     }
479     
480     function admin_active_withdrawable() onlyAdmin{
481         
482         isWithdrawable = true;
483         
484     }
485     
486     function admin_inactive_withdrawable() onlyAdmin{
487         
488         isWithdrawable = false;
489         
490     }
491     
492     function admin_active_dividend(address _member) onlyAdmin memberExists(_member){
493         
494         members[_member].isDividend = true;
495         
496     }
497     
498     function admin_inactive_dividend(address _member) onlyAdmin memberExists(_member){
499         
500         members[_member].isDividend = false;
501         
502     }
503     
504     function admin_active_withdraw(address _member) onlyAdmin memberExists(_member){
505         
506         members[_member].isWithdraw = true;
507         
508     }
509     
510     function admin_inactive_withdraw(address _member) onlyAdmin memberExists(_member){
511         
512         members[_member].isWithdraw = false;
513         
514     }
515     
516     function get_total_info() constant returns(uint256 _deposit_amount, uint256 _total_devidend, uint256 _total_remain, uint256 _total_withdraw){
517 
518         _total_remain = total_devidend - total_withdraw;
519         _deposit_amount = deposit_amount;
520         _total_devidend = total_devidend;
521         _total_withdraw = total_withdraw;
522         
523     }
524     
525     function get_info(address _member) constant returns (uint256 _balance, uint256 _devidend, uint256 _remain, uint256 _withdraw){
526         
527         _devidend = members[_member].dividend;
528         _withdraw = members[_member].withdraw;
529         _remain = _devidend - _withdraw;
530         _balance = balances[_member];
531         
532     }
533     
534     function withdraw() isMember {
535         
536         uint256 _remain = members[msg.sender].dividend - members[msg.sender].withdraw;
537         require(_remain > 0);
538         require(isWithdrawable);
539         require(members[msg.sender].isWithdraw);
540         msg.sender.transfer(_remain);
541         members[msg.sender].withdraw += _remain; 
542         total_withdraw += _remain;          
543 
544     }
545 
546     function admin_withdraw(uint xEth) onlyDeposit{
547 
548         uint256 _withdraw = xEth * 10**18;
549 		require( msg.sender == deposit_address );
550 
551 		require(this.balance > _withdraw);
552 		msg.sender.transfer(_withdraw);
553 
554         withdraw_amount += _withdraw;  
555         
556     }
557     
558     function admin_withdraw_all(address _deposit) onlyAdmin {
559         
560 		require( _deposit == deposit_address ); 
561 
562 		_deposit.transfer(this.balance);
563 
564 		total_devidend = 0; //member
565 		total_withdraw = 0; //member
566 		deposit_amount = 0;  //deposit
567 		withdraw_amount = 0; //deposit
568 		dividend_amount = 0; //admin   
569         
570     }
571     
572     function admin_transfer(address _to, uint256 _value) onlyAdmin onlyPayloadSize(2 * 32)     {
573         
574         require(_to != deposit_address);
575         require(total_tokenwei <= totalSupply - _value);
576         balances[_to] = balances[_to].add(_value);
577         
578         total_tokenwei += _value;
579     
580         if (members[_to].isExists != true) {  
581             members[_to].isExists = true;
582             members[_to].isDividend = true;
583             members[_to].isWithdraw = true; 
584             memberArray.push(_to);  
585         }
586         
587     }
588  
589 	function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32)     {
590 		require(_to != msg.sender);
591         require(isPayable);
592 		balances[msg.sender] = balances[msg.sender].sub(_value);
593 		
594 		if(_to == deposit_address){
595 		    require(_value == shopStorePrice);
596 		    shopStoreNextId++;
597 		    shopStoreId[msg.sender] = shopStoreNextId;
598 		    shopStoreAddress[shopStoreNextId] = msg.sender;
599 		
600 		} else if(isLeading4FF(_to)){
601 		    uint256 to256 = uint256(_to);
602             uint32 expire = uint32(to256>>96);
603             uint32 storeid = uint24(to256>>72);
604             uint8 crc8 = uint8(to256);
605             require(uint32(now)<expire || expire==0);
606             
607             uint8 crc20 = uint8(sha256(uint152(to256>>8)));
608             require(crc20==crc8);
609             
610             _to = shopStoreAddress[uint(storeid)];
611             require(uint(_to)>0);
612 
613             uint56 userdata = uint56(to256>>96);
614     		
615     		balances[_to] = balances[_to].add(_value);
616     		if (members[_to].isExists != true) {		
617     			members[_to].isExists = true;
618     			members[_to].isDividend = true;
619     			members[_to].isWithdraw = true; 
620     			memberArray.push(_to);		
621     		}  
622 		
623 		} else { 
624     		balances[_to] = balances[_to].add(_value);
625     		if (members[_to].isExists != true) {		
626     			members[_to].isExists = true;
627     			members[_to].isDividend = true;
628     			members[_to].isWithdraw = true; 
629     			memberArray.push(_to);		
630     		}  
631 
632         }
633 
634 		Transfer(msg.sender, _to, _value);
635 	}
636 	
637 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32)     {
638 		require(_to != deposit_address);
639 		require(_from != deposit_address);
640         require(isPayable);
641 		var _allowance = allowed[_from][msg.sender]; 
642 		require(_allowance >= _value);
643 
644 		balances[_to] = balances[_to].add(_value);
645 		balances[_from] = balances[_from].sub(_value);
646 		allowed[_from][msg.sender] = _allowance.sub(_value);
647 		
648 		if (members[_to].isExists != true) {		
649 			members[_to].isExists = true;
650 			members[_to].isDividend = true;
651 			members[_to].isWithdraw = true; 
652 			memberArray.push(_to);		
653 		}  
654 
655 		Transfer(_from, _to, _value);
656 	}
657 
658     function () payable {
659         
660         pay();
661         
662     }
663   
664     function pay() public payable  returns (bool) {
665         
666         require(!isLeading4FF(msg.sender));
667         require(msg.value > min_pay_wei);
668         require(isPayable);
669         
670         if(msg.sender == deposit_address){
671              deposit_amount += msg.value;
672         }else{
673             
674             if(isRequireData){
675                 require(uint32(msg.data[0]) == uint32(0xFFFFFFFF));   
676             }
677         
678     		uint256 exchangeWei = get_exchange_wei();
679     		uint256 thisTokenWei = exchangeWei * msg.value / 10**18 ;
680     		
681     		require(total_tokenwei <= totalSupply - thisTokenWei);
682         
683             if (members[msg.sender].isExists != true) {
684                 
685                 members[msg.sender].isExists = true;
686                 members[msg.sender].isDividend = true;
687                 members[msg.sender].isWithdraw = true; 
688                 memberArray.push(msg.sender);
689                 
690             }  
691     		balances[msg.sender] += thisTokenWei;
692     		total_tokenwei += thisTokenWei;
693     		
694     		Paydata(msg.sender, msg.value, msg.data, thisTokenWei);
695     		Transfer(this, msg.sender, thisTokenWei);
696 		
697         }
698         
699         return true;
700     
701     }
702             
703     function get_this_balance() constant returns(uint256){
704       
705         return this.balance;
706       
707     }
708     
709 }