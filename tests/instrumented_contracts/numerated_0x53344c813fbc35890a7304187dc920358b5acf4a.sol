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
190     exchangeRate[] public exchangeRateArray;  
191 
192 	mapping (address => Member) public members; 
193     address[] public adminArray;   
194     address[] public memberArray;
195 	
196     address public deposit_address;
197     uint256 public INITIAL_SUPPLY = 21000000000000;
198     uint256 public tokenExchangeRateInWei = 300000000;
199 
200 	//不歸零
201 	uint256 public total_tokenwei = 0; 
202 	uint256 public min_pay_wei = 0;
203 
204 	// drawall 歸零
205 	uint256 public total_devidend = 0; //member
206 	uint256 public total_withdraw = 0; //member
207     uint256 public deposit_amount = 0;  //deposit
208     uint256 public withdraw_amount = 0; //deposit
209     uint256 public dividend_amount = 0; //admin   
210     
211     function Pixiu_Beta() {
212      
213         totalSupply = INITIAL_SUPPLY; 
214         adminArray.push(msg.sender);
215         admin_set_deposit(msg.sender);
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
332     function admin_set_exchange_rate(uint[] exchangeRates) onlyAdmin{
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
348 	function get_exchange_wei() constant returns(uint256){
349 
350 		uint len = exchangeRateArray.length;  
351 		uint nowTime = block.timestamp;
352         for(uint i = 0; i < len; i += 3){
353             
354 			exchangeRate memory rate = exchangeRateArray[i];
355             uint time1 = rate.time1;
356             uint time2 = rate.time2;
357             uint value = rate.value;
358 			if (nowTime>= time1 && nowTime<=time2) {
359 				tokenExchangeRateInWei = value;
360 				return value;
361 			}
362             
363         }
364 		return tokenExchangeRateInWei;
365 	}
366 	
367 	function admin_set_min_pay(uint256 _min_pay) onlyAdmin{
368 	    
369 	    require(_min_pay >= 0);
370 	    min_pay_wei = _min_pay * 10 ** 18;
371 	    
372 	}
373     
374     function get_admin_list() constant returns(address[] _adminArray){
375         
376         _adminArray = adminArray;
377         
378     }
379     
380     function admin_add(address admin) onlyAdmin adminDoesNotExist(admin){
381         
382         adminArray.push(admin);
383         
384     }
385     
386     function admin_del(address admin) onlyAdmin adminExists(admin){
387         
388         for (uint i = 0; i < adminArray.length - 1; i++)
389             if (adminArray[i] == admin) {
390                 adminArray[i] = adminArray[adminArray.length - 1];
391                 break;
392             }
393             
394         adminArray.length -= 1;
395         
396     }
397     
398     function admin_set_deposit(address addr) onlyAdmin{
399         
400         deposit_address = addr;
401         
402     }
403     
404     function admin_active_payable() onlyAdmin{
405     
406         isPayable = true;
407         
408     }
409     
410     function admin_inactive_payable() onlyAdmin{
411         
412         isPayable = false;
413         
414     }
415     
416     function admin_active_withdrawable() onlyAdmin{
417         
418         isWithdrawable = true;
419         
420     }
421     
422     function admin_inactive_withdrawable() onlyAdmin{
423         
424         isWithdrawable = false;
425         
426     }
427     
428     function admin_active_dividend(address _member) onlyAdmin memberExists(_member){
429         
430         members[_member].isDividend = true;
431         
432     }
433     
434     function admin_inactive_dividend(address _member) onlyAdmin memberExists(_member){
435         
436         members[_member].isDividend = false;
437         
438     }
439     
440     function admin_active_withdraw(address _member) onlyAdmin memberExists(_member){
441         
442         members[_member].isWithdraw = true;
443         
444     }
445     
446     function admin_inactive_withdraw(address _member) onlyAdmin memberExists(_member){
447         
448         members[_member].isWithdraw = false;
449         
450     }
451     
452     function get_total_info() constant returns(uint256 _deposit_amount, uint256 _total_devidend, uint256 _total_remain, uint256 _total_withdraw){
453 
454         _total_remain = total_devidend - total_withdraw;
455         _deposit_amount = deposit_amount;
456         _total_devidend = total_devidend;
457         _total_withdraw = total_withdraw;
458         
459     }
460     
461     function get_info(address _member) constant returns (uint256 _balance, uint256 _devidend, uint256 _remain, uint256 _withdraw){
462         
463         _devidend = members[_member].dividend;
464         _withdraw = members[_member].withdraw;
465         _remain = _devidend - _withdraw;
466         _balance = balances[_member];
467         
468     }
469     
470     function withdraw() isMember {
471         
472         uint256 _remain = members[msg.sender].dividend - members[msg.sender].withdraw;
473         require(_remain > 0);
474         require(isWithdrawable);
475         require(members[msg.sender].isWithdraw);
476         msg.sender.transfer(_remain);
477         members[msg.sender].withdraw += _remain; 
478         total_withdraw += _remain;          
479 
480     }
481 
482     function withdraw_admin(uint xEth) onlyDeposit{
483 
484         uint256 _withdraw = xEth * 10**18;
485 		require( msg.sender == deposit_address );
486 
487 		require(this.balance > _withdraw);
488 		msg.sender.transfer(_withdraw);
489 
490         withdraw_amount += _withdraw;  
491         
492     }
493     
494     function withdraw_all_admin(address _deposit) onlyAdmin {
495         
496 		require( _deposit == deposit_address ); 
497 
498 		_deposit.transfer(this.balance);
499 
500 		total_devidend = 0; //member
501 		total_withdraw = 0; //member
502 		deposit_amount = 0;  //deposit
503 		withdraw_amount = 0; //deposit
504 		dividend_amount = 0; //admin   
505         
506     }
507  
508 	function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32)     {
509 		require(_to != deposit_address);
510         require(isPayable);
511 		balances[msg.sender] = balances[msg.sender].sub(_value);
512 		balances[_to] = balances[_to].add(_value);
513 
514 		if (members[_to].isExists != true) {		
515 			members[_to].isExists = true;
516 			members[_to].isDividend = true;
517 			members[_to].isWithdraw = true; 
518 			memberArray.push(_to);		
519 		}  
520 
521 		Transfer(msg.sender, _to, _value);
522 	}
523  
524 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32)     {
525 		require(_to != deposit_address);
526 		require(_from != deposit_address);
527         require(isPayable);
528 		var _allowance = allowed[_from][msg.sender]; 
529 		require(_allowance >= _value);
530 
531 		balances[_to] = balances[_to].add(_value);
532 		balances[_from] = balances[_from].sub(_value);
533 		allowed[_from][msg.sender] = _allowance.sub(_value);
534 		
535 		if (members[_to].isExists != true) {		
536 			members[_to].isExists = true;
537 			members[_to].isDividend = true;
538 			members[_to].isWithdraw = true; 
539 			memberArray.push(_to);		
540 		}  
541 
542 		Transfer(_from, _to, _value);
543 	}
544 
545     function () payable {
546         
547         pay();
548         
549     }
550   
551     function pay() public payable returns (bool) {
552       
553         require(msg.value > min_pay_wei);
554         require(isPayable);
555         
556         if(msg.sender == deposit_address){
557              deposit_amount += msg.value;
558         }else{
559         
560     		uint256 exchangeWei = get_exchange_wei();
561     		uint256 thisTokenWei = exchangeWei * msg.value / 10**18 ;
562         
563             if (members[msg.sender].isExists != true) {
564                 
565                 members[msg.sender].isExists = true;
566                 members[msg.sender].isDividend = true;
567                 members[msg.sender].isWithdraw = true; 
568                 memberArray.push(msg.sender);
569                 
570             }  
571     		balances[msg.sender] += thisTokenWei;
572     		total_tokenwei += thisTokenWei;
573 		
574         }
575         
576         return true;
577     
578     }
579             
580     function get_this_balance() constant returns(uint256){
581       
582         return this.balance;
583       
584     }
585     
586 }