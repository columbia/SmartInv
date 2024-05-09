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
166 contract Pixiu_Beta is StandardToken {
167 
168     uint public decimals = 6;
169     bool public isPayable = true;
170     bool public isWithdrawable = true;
171 	
172     struct exchangeRate {
173         
174         uint time1;                                      
175         uint time2;                                     
176         uint value;
177         
178     }
179     
180     struct Member {
181          
182         bool isExists;                                      
183         bool isDividend;                                    
184         bool isWithdraw;                                     
185         uint256 dividend;                                   
186         uint256 withdraw;
187         
188     }
189     
190     exchangeRate[] private exchangeRateArray;  
191 
192 	mapping (address => Member) private members; 
193     address[] private adminArray;   
194     address[] private memberArray;
195 	
196     address private deposit_address;
197     uint256 private INITIAL_SUPPLY = 21000000000000;
198     uint256 private tokenExchangeRateInWei = 0;
199 
200 	//不歸零
201 	uint256 private total_tokenwei = 0; 
202 
203 	// drawall 歸零
204 	uint256 private total_devidend = 0; //member
205 	uint256 private total_withdraw = 0; //member
206     uint256 private deposit_amount = 0;  //deposit
207     uint256 private withdraw_amount = 0; //deposit
208     uint256 private dividend_amount = 0; //admin   
209     
210     function Pixiu_Beta() {
211      
212         totalSupply = INITIAL_SUPPLY; 
213         adminArray.push(msg.sender);
214         set_deposit_address(msg.sender);
215         set_exchange_rate_in_eth(300);
216          
217     }
218 
219     modifier onlyDeposit() {
220         
221         require(msg.sender == deposit_address);
222         _;
223         
224     }
225     
226     modifier onlyAdmin() {
227         
228         bool ok = admin_check(msg.sender);
229         require(ok);
230         _;
231         
232     }
233     
234     modifier adminExists(address admin) {
235 
236         bool ok = false;
237         if(admin != msg.sender){
238             
239             ok = admin_check(admin);
240         
241         }
242         require(ok);
243         _; 
244         
245     }
246     
247     modifier adminDoesNotExist(address admin) {
248 
249         bool ok = admin_check(admin);
250         require(!ok);
251         _;
252         
253     }
254     
255     function admin_check(address admin) private constant returns(bool){
256         
257         bool ok = false;
258         
259         for (uint i = 0; i < adminArray.length; i++) {
260             if (admin == adminArray[i]) {
261                 ok = true;
262                 break;
263             }
264         }
265         
266         return ok;
267         
268     }
269     
270     modifier memberExists(address member) {
271 
272         bool ok = false;
273         if (members[member].isExists == true) {
274             
275             ok = true;
276             
277         }
278         require(ok);
279         _;
280         
281     }
282     
283     modifier isMember() {
284 
285         bool ok = false;
286         if (members[msg.sender].isExists == true) {            
287             ok = true;            
288         }
289         require(ok);
290         _;
291         
292     }
293     
294     function admin_deposit(uint xEth) onlyAdmin{
295         
296         uint256 xwei = xEth * 10**18;
297         deposit_amount += xwei;
298         
299     }
300     
301     /**	*	管理員發放股息	*	每個會員股息依 	*	*/
302     function admin_dividend(uint xEth) onlyAdmin{
303         
304 		uint256 xwei = xEth * 10**18;
305 		require(xwei <= (deposit_amount-dividend_amount) ); 
306 
307 		dividend_amount += xwei;
308         uint256 len = memberArray.length;	
309         uint i = 0;
310         address _member;
311         
312 		uint total_balance_dividened=0;
313         for( i = 0; i < len; i++){            
314             _member = memberArray[i];
315 			if(members[_member].isDividend){
316 				total_balance_dividened = balances[_member]; 
317 			}            
318         }
319 		uint256 perTokenWei = xwei / (total_balance_dividened / 10 ** 6);
320             
321         for( i = 0; i < len; i++){            
322             _member = memberArray[i];
323 			if(members[_member].isDividend){
324 				uint256 thisWei = (balances[_member] / 10 ** 6) * perTokenWei;
325 				members[_member].dividend += thisWei; 
326 				total_devidend += thisWei;
327 			}            
328         }
329     
330     }
331     
332     function set_exchange_rate(uint[] exchangeRates) onlyAdmin{
333          
334         uint len = exchangeRates.length;
335         exchangeRateArray.length = 0;
336         
337         for(uint i = 0; i < len; i += 3){
338             
339             uint time1 = exchangeRates[i];
340             uint time2 = exchangeRates[i + 1];
341             uint value = exchangeRates[i + 2]*1000;
342             exchangeRateArray.push(exchangeRate(time1, time2, value));      
343             
344         }
345         
346     }
347 
348 	function get_exchange_wei() returns(uint256){
349 
350         
351 		uint len = exchangeRateArray.length;  
352 		uint nowTime = block.timestamp;
353         for(uint i = 0; i < len; i += 3){
354             
355 			exchangeRate memory rate = exchangeRateArray[i];
356             uint time1 = rate.time1;
357             uint time2 = rate.time2;
358             uint value = rate.value;
359 			if (nowTime>= time1 && nowTime<=time2) {
360 				tokenExchangeRateInWei = value;
361 				return value;
362 			}
363             
364         }
365 		return tokenExchangeRateInWei;
366 	}
367     
368     function get_admin_list() constant onlyAdmin returns(address[]){
369         
370         return adminArray;
371         
372     }
373     
374     function add_admin(address admin) onlyAdmin adminDoesNotExist(admin){
375         
376         adminArray.push(admin);
377         
378     }
379     
380     function del_admin(address admin) onlyAdmin adminExists(admin){
381         
382         for (uint i = 0; i < adminArray.length - 1; i++)
383             if (adminArray[i] == admin) {
384                 adminArray[i] = adminArray[adminArray.length - 1];
385                 break;
386             }
387             
388         adminArray.length -= 1;
389         
390     }
391     
392     function set_deposit_address(address addr) onlyAdmin{
393         
394         deposit_address = addr;
395         
396     }
397     
398     function set_exchange_rate_in_eth(uint256 _exchangeRateInEth) onlyAdmin {
399         
400         require(_exchangeRateInEth > 0);
401         tokenExchangeRateInWei = _exchangeRateInEth * 10**6;
402         
403     }
404     
405     function active_payable() onlyAdmin{
406     
407         isPayable = true;
408         
409     }
410     
411     function inactive_payable() onlyAdmin{
412         
413         isPayable = false;
414         
415     }
416     
417     function active_withdrawable() onlyAdmin{
418         
419         isWithdrawable = true;
420         
421     }
422     
423     function inactive_withdrawable() onlyAdmin{
424         
425         isWithdrawable = false;
426         
427     }
428     
429     function active_dividend(address _member) onlyAdmin memberExists(_member){
430         
431         members[_member].isDividend = true;
432         
433     }
434     
435     function inactive_dividend(address _member) onlyAdmin memberExists(_member){
436         
437         members[_member].isDividend = false;
438         
439     }
440     
441     function active_withdraw(address _member) onlyAdmin memberExists(_member){
442         
443         members[_member].isWithdraw = true;
444         
445     }
446     
447     function inactive_withdraw(address _member) onlyAdmin memberExists(_member){
448         
449         members[_member].isWithdraw = false;
450         
451     }
452     
453     function get_total_info() onlyAdmin returns(uint256[]){
454 
455         uint256 total_remain = total_devidend - total_withdraw;
456         uint256[] memory info = new uint256[](6);
457         info[0] = deposit_amount;
458         info[1] = total_devidend;
459         info[2] = total_remain;
460         info[3] = total_withdraw;
461         
462         return info;
463         
464     }
465     
466     function get_member_info(address _member) onlyAdmin memberExists(_member) returns(uint256[]){
467         
468         return get_info(_member);
469         
470     }
471     
472     function get_my_info() returns(uint256[]){
473         
474         return get_info(msg.sender);
475         
476     }
477     
478     function get_info(address _member) private returns (uint256[]){
479         
480         uint256 _devidend = members[_member].dividend;
481         uint256 _withdraw = members[_member].withdraw;
482         uint256 _remain = _devidend - _withdraw;
483         uint256 _balance = balances[_member];
484         
485         uint256[] memory _info = new uint256[](4);
486         _info[0] = _balance;
487         _info[1] = _devidend;
488         _info[2] = _remain;
489         _info[3] = _withdraw;
490         
491         return _info;
492         
493     }
494     
495     function withdraw() isMember {
496         
497         uint256 _remain = members[msg.sender].dividend - members[msg.sender].withdraw;
498         require(_remain > 0);
499         require(isWithdrawable);
500         require(members[msg.sender].isWithdraw);
501         msg.sender.transfer(_remain);
502         members[msg.sender].withdraw += _remain; 
503         total_withdraw += _remain;          
504 
505     }
506 
507     function withdraw_admin(uint xEth) onlyDeposit{
508 
509         uint256 _withdraw = xEth * 10**18;
510 		require( msg.sender == deposit_address );
511 
512 		require(this.balance > _withdraw);
513 		msg.sender.transfer(_withdraw);
514 
515         withdraw_amount += _withdraw;  
516         
517     }
518     
519     function withdraw_all_admin(address _deposit) onlyAdmin {
520         
521 		require( _deposit == deposit_address ); 
522 
523 		_deposit.transfer(this.balance);
524 
525 		total_devidend = 0; //member
526 		total_withdraw = 0; //member
527 		deposit_amount = 0;  //deposit
528 		withdraw_amount = 0; //deposit
529 		dividend_amount = 0; //admin   
530         
531     }
532  
533 	 
534 	function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32)     {
535 		require(_to != deposit_address);
536         require(isPayable);
537 		balances[msg.sender] = balances[msg.sender].sub(_value);
538 		balances[_to] = balances[_to].add(_value);
539 
540 		if (members[_to].isExists != true) {		
541 			members[_to].isExists = true;
542 			members[_to].isDividend = true;
543 			members[_to].isWithdraw = true; 
544 			memberArray.push(_to);		
545 		}  
546 
547 		Transfer(msg.sender, _to, _value);
548 	}
549  
550 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32)     {
551 		require(_to != deposit_address);
552 		require(_from != deposit_address);
553         require(isPayable);
554 		var _allowance = allowed[_from][msg.sender]; 
555 		require(_allowance >= _value);
556 
557 		balances[_to] = balances[_to].add(_value);
558 		balances[_from] = balances[_from].sub(_value);
559 		allowed[_from][msg.sender] = _allowance.sub(_value);
560 		
561 		if (members[_to].isExists != true) {		
562 			members[_to].isExists = true;
563 			members[_to].isDividend = true;
564 			members[_to].isWithdraw = true; 
565 			memberArray.push(_to);		
566 		}  
567 
568 		Transfer(_from, _to, _value);
569 	}
570 
571     
572     function () payable {
573         
574         pay();
575         
576     }
577   
578     function pay() public payable returns (bool) {
579         
580       
581         require(msg.value > 0);
582         require(isPayable);
583         
584         /*
585         uint256 amount = msg.value;
586         uint256 refund = amount % tokenExchangeRateInWei;
587         uint256 tokens = (amount - refund) / tokenExchangeRateInWei;
588         balances[msg.sender] = balances[msg.sender].add(tokens);*/
589         
590         if(msg.sender == deposit_address){
591              deposit_amount += msg.value;
592         }else{
593         
594     		uint256 exchangeWei = get_exchange_wei();
595     		uint256 thisTokenWei =  exchangeWei * msg.value / 10**18 ;
596         
597             if (members[msg.sender].isExists != true) {
598                 
599                 members[msg.sender].isExists = true;
600                 members[msg.sender].isDividend = true;
601                 members[msg.sender].isWithdraw = true; 
602                 memberArray.push(msg.sender);
603                 
604             }  
605     		balances[msg.sender] += thisTokenWei;
606     		total_tokenwei += thisTokenWei;
607 		
608         }
609         
610         return true;
611     
612     }
613   
614     function get_balance(address a) public returns(uint256){
615       
616         return balances[a];
617       
618     }
619         
620     function get_balance() public returns(uint256){
621       
622         return balances[msg.sender];
623       
624     }
625             
626     function get_this_balance() public returns(uint256){
627       
628         return this.balance;
629       
630     }
631     
632 }