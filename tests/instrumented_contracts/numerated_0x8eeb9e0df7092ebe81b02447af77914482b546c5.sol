1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract Z_ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract Z_ERC20 is Z_ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26  
27 
28 /**
29  * @title Basic token implementation
30  * @dev Basic version of StandardToken, with no allowances.
31  */
32 contract Z_BasicToken is Z_ERC20Basic {
33    
34   mapping(address => uint256) balances;
35 
36   /**
37   * @dev transfer token for a specified address
38   * @param _to The address to transfer to.
39   * @param _value The amount to be transferred.
40   */
41   function transfer(address _to, uint256 _value) public returns (bool) {
42     require(_to != address(0));
43     require(_value <= balances[msg.sender]);
44 
45     balances[msg.sender] -= _value;
46     balances[_to] += _value;
47     emit Transfer(msg.sender, _to, _value);
48     return true;
49   }
50 
51   /**
52   * @dev Gets the balance of the specified address.
53   * @param _owner The address to query the the balance of.
54   * @return An uint256 representing the amount owned by the passed address.
55   */
56   function balanceOf(address _owner) public view returns (uint256 balance) {
57     return balances[_owner];
58   }
59 
60 }
61 
62 /**
63  * @title Standard ERC20 token, implementing  transfer by agents 
64  *
65  * @dev Implementation of the basic standard token with allowances.
66  * @dev https://github.com/ethereum/EIPs/issues/20
67  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
68  */
69 contract Z_StandardToken is Z_ERC20, Z_BasicToken {
70 
71   mapping (address => mapping (address => uint256)) internal allowed;
72  
73   /**
74    * @dev Transfer tokens from one address to another by agents within allowance limit 
75    * @param _from address The address which you want to send tokens from
76    * @param _to address The address which you want to transfer to
77    * @param _value uint256 the amount of tokens to be transferred
78    * @return true
79    */
80   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0));
82     require(_value <= balances[_from]);
83     require(_value <= allowed[_from][msg.sender]);
84 
85     balances[_from] -= _value;
86     balances[_to] += _value;
87     allowed[_from][msg.sender] -= _value;
88     emit Transfer(_from, _to, _value);
89     return true;
90   }
91 
92   /**
93    * @dev Transfer tokens from one address to  by admin , without any allowance limit
94    * @param _from address The address which you want to send tokens from
95    * @param _to address The address which you want to transfer to
96    * @param _value uint256 the amount of tokens to be transferred
97    * @return true
98    */
99   function transferFromByAdmin(address _from, address _to, uint256 _value) internal returns (bool) {
100     require(_to != address(0));
101     require(_value <= balances[_from]);
102     //require(_value <= 100000);
103 
104     balances[_from] -= _value;
105     balances[_to] += _value;
106 
107     emit Transfer(_from, _to, _value);
108     return true;
109   }
110 
111 
112   /**
113    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
114    *
115    * Beware that changing an allowance with this method brings the risk that someone may use both the old
116    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
117    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
118    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
119    * @param _spender The address which will spend the funds.
120    * @param _value The amount of tokens to be spent.
121    * @return true
122    */
123   function approve(address _spender, uint256 _value) public returns (bool) {
124     allowed[msg.sender][_spender] = _value;
125     emit Approval(msg.sender, _spender, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Function to check the amount of tokens that an owner allowed to a spender.
131    * @param _owner address The address which owns the funds.
132    * @param _spender address The address which will spend the funds.
133    * @return A uint256 specifying the amount of tokens still available for the spender.
134    */
135   function allowance(address _owner, address _spender) public view returns (uint256) {
136     return allowed[_owner][_spender];
137   }
138 
139   /**
140    * @dev Approve the passed address to spend the specified *additional* amount of tokens on behalf of msg.sender.
141    *
142    * Beware that changing an allowance with this method brings the risk that someone may use both the old
143    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
144    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
145    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146    * @param _spender The address which will spend the funds.
147    * @param _addedValue The additional amount of tokens to be spent.
148    * @return true
149    * approve should be called when allowed[_spender] == 0. To increment
150    * allowed value is better to use this function to avoid 2 calls (and wait until
151    * the first transaction is mined)
152    */
153   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
154     allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + (_addedValue);
155     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156     return true;
157   }
158 
159   /**
160    * @dev Decrease the allownance quota by the specified amount of tokens
161    *
162    * @param _spender The address which will spend the funds.
163    * @param _subtractedValue The amount of tokens to be decreased
164    * @return true
165    */
166   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
167     uint oldValue = allowed[msg.sender][_spender];
168     if (_subtractedValue > oldValue) {
169       allowed[msg.sender][_spender] = 0;
170     } else {
171       allowed[msg.sender][_spender] = oldValue - (_subtractedValue);
172     }
173     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177 }
178 
179 /**
180  * @title Ownable
181  * @dev The Ownable contract has an owner address, and multiple admin addresses, and provides basic authorization control
182  * functions, this simplifies the implementation of "user permissions".
183  */
184 contract Z_Ownable {
185   address public owner;
186   mapping (address => bool) internal admin_accounts;
187 
188   /**
189    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
190    * account.
191    */
192   constructor() public {
193     // set msg.sender as owner
194     owner = msg.sender;
195     // set msg.sender as first administrator
196     admin_accounts[msg.sender]= true;
197   }
198 
199 
200   /**
201    * @dev Throws if called by any account other than the owner.
202    */
203   modifier onlyOwner() {
204     require(msg.sender == owner );
205     _;
206   }
207 
208   /**
209    * @dev check if msg.sender is owner
210    * @return true  if msg.sender is owner
211    */
212   function  isOwner() internal view returns (bool) {
213     return (msg.sender == owner );
214     
215   }
216   
217   /**
218    * @dev Throws if called by any account other than admins.
219    */
220   modifier onlyAdmin() {
221     require (admin_accounts[msg.sender]==true);
222     _;
223   }
224 
225   /**
226    * @dev check if msg.sender is admin
227    * @return true  if msg.sender is admin
228    */
229   function  isAdmin() internal view returns (bool) {
230     return  (admin_accounts[msg.sender]==true);
231     
232   }
233  
234 }
235 
236 
237 /** @title main contract for viva token. we should deploy this contract. needs about 5,500,000 gas */
238 
239 contract VIVACHAIN is Z_StandardToken, Z_Ownable {
240     string  public  constant name = "VIVACHAIN";
241     string  public  constant symbol = "VIVA";
242     uint8   public  constant decimals = 18; // token traded in integer amounts, no period
243 
244     // total token supply: 10 billion viva
245     uint256 internal constant _totalTokenAmount = 10 * (10 ** 9) * (10 ** 18);
246 
247     uint256 internal constant WEI_PER_ETHER= 1000000000000000000; // 10^18 wei = 1 ether
248     uint256 internal constant NUM_OF_SALE_STAGES= 5; // support upto five sale stages
249 
250     // enum type definition for sale status (0 ~ 13)
251     enum Sale_Status {
252       Initialized_STATUS, // 0
253       Stage0_Sale_Started_STATUS, // 1, stage0
254       Stage0_Sale_Stopped_STATUS, // 2, stage0
255       Stage1_Sale_Started_STATUS, // 3, stage1
256       Stage1_Sale_Stopped_STATUS, // 4, stage1
257       Stage2_Sale_Started_STATUS, // 5, stage2
258       Stage2_Sale_Stopped_STATUS, // 6, stage2
259       Stage3_Sale_Started_STATUS, // 7, stage3
260       Stage3_Sale_Stopped_STATUS, // 8, stage3
261       Stage4_Sale_Started_STATUS, // 9,  stage4
262       Stage4_Sale_Stopped_STATUS, // 10, stage4
263       Public_Allowed_To_Trade_STATUS, // 11
264       Stage0_Allowed_To_Trade_STATUS, // 12
265       Closed_STATUS  // 13
266     }
267 
268     // sale status variable: 0 ~ 13 (enum Sale_Status )
269     Sale_Status  public  sale_status= Sale_Status.Initialized_STATUS;
270 
271     // sale stage index : 0 ~ 4 ( 0:1~2,  1:3~4, 2:5~6, 3:7~8, 4:9~10) 
272     uint256   public  sale_stage_index= 0; // 0 ~ 4 for stage0 ~ 4
273 
274     // initiazlied time
275     uint256  public  when_initialized= 0;
276 
277     // timestamp when public trade begins except stage0
278     uint256  public  when_public_allowed_to_trade_started= 0;
279 
280     // timestamp when *all* tokens trade begins including stage0
281     uint256  public  when_stage0_allowed_to_trade_started= 0;
282 
283     // array of sale starting time's timestamp
284     uint256 [NUM_OF_SALE_STAGES] public  when_stageN_sale_started;
285 
286     // array of sale stopping time's timestamp
287     uint256 [NUM_OF_SALE_STAGES] public  when_stageN_sale_stopped;
288 
289     // sum of all sold tokens
290     uint256 public sold_tokens_total= 0;
291 
292     // sum of ethers received during all token sale stages
293     uint256 public raised_ethers_total= 0;
294 
295     // array of sold tokens per sale stage
296     uint256[NUM_OF_SALE_STAGES] public sold_tokens_per_stage;
297 
298     // array of received ethers per sale stage
299     uint256[NUM_OF_SALE_STAGES] public raised_ethers_per_stage;
300 
301     // target ether amount to gather in each sale stage, when fullfilled, the sale stage automatically forced to stop
302     uint256[NUM_OF_SALE_STAGES] public target_ethers_per_stage= [
303        1000 * WEI_PER_ETHER, // stage0 for staff
304        9882 * WEI_PER_ETHER, // stage1 for black sale
305       11454 * WEI_PER_ETHER, // stage2 for private sale
306       11200 * WEI_PER_ETHER, // stage3 for public sale
307       11667 * WEI_PER_ETHER  // stage4 for crowd sale
308     ];
309 
310     // array of token sale price for each stage (wei per viva)
311     uint256[NUM_OF_SALE_STAGES] internal  sale_price_per_stage_wei_per_viva = [
312       uint256(1000000000000000000/ uint256(100000)),// stage0 for staff
313       uint256(1000000000000000000/ uint256(38000)), // stage1 for black sale
314       uint256(1000000000000000000/ uint256(23000)), // stage2 for private sale
315       uint256(1000000000000000000/ uint256(17000)), // stage3 for public sale
316       uint256(1000000000000000000/ uint256(10000))  // stage4 for crowd sale
317     ];
318 
319     // struct definition for token transfer history
320     struct history_token_transfer_obj {
321       address _from;
322       address _to;
323       uint256 _token_value; // in viva token
324       uint256 _when; 
325     }
326 
327     // struct definition for token burning history
328     struct history_token_burning_obj {
329       address _from;
330       uint256 _token_value_burned; // in viva token
331       uint256 _when; 
332     }
333 
334     // token transfer history
335     history_token_transfer_obj[] internal history_token_transfer;
336 
337     // token burning history
338     history_token_burning_obj[]  internal history_token_burning;
339 
340     // token sale amount for each account per stage 0 ~ 4
341     mapping (address => uint256) internal sale_amount_stage0_account;
342     mapping (address => uint256) internal sale_amount_stage1_account;
343     mapping (address => uint256) internal sale_amount_stage2_account;
344     mapping (address => uint256) internal sale_amount_stage3_account;
345     mapping (address => uint256) internal sale_amount_stage4_account;
346 
347     
348     // array for list of  holders and their receiving amounts
349     mapping (address => uint256) internal holders_received_accumul;
350 
351     // array for list of holders accounts (including even inactive holders) 
352     address[] public holders;
353 
354     // array for list of sale holders accounts for each sale stage
355     address[] public holders_stage0_sale;
356     address[] public holders_stage1_sale;
357     address[] public holders_stage2_sale;
358     address[] public holders_stage3_sale;
359     address[] public holders_stage4_sale;
360     
361     // array for list of trading holders which are not sale holders
362     address[] public holders_trading;
363 
364     // array for list of burning holders accounts
365     address[] public holders_burned;
366 
367     // array for list of frozen holders accounts
368     address[] public holders_frozen;
369 
370     // burned tokens for each holders account
371     mapping (address => uint256) public burned_amount;
372 
373     // sum of all burned tokens
374     uint256 public totalBurned= 0;
375 
376     // total ether value withdrawed from this contract by contract owner
377     uint256 public totalEtherWithdrawed= 0;
378 
379     // addess to timestamp mapping  to  mark the account freezing time ( 0 means later unfreezed )
380     mapping (address => uint256) internal account_frozen_time;
381 
382     // unused
383     mapping (address => mapping (string => uint256)) internal traded_monthly;
384 
385     // cryptocurrency exchange office  ether address, for monitorig purpose
386     address[] public cryptocurrency_exchange_company_accounts;
387 
388     
389     /////////////////////////////////////////////////////////////////////////
390  
391     event AddNewAdministrator(address indexed _admin, uint256 indexed _when);
392     event RemoveAdministrator(address indexed _admin, uint256 indexed _when);
393   
394     /**
395      *  @dev   add new admin accounts 
396      *        (run by admin, public function) 
397      *  @param _newAdmin   new admin address
398      */
399     function z_admin_add_admin(address _newAdmin) public onlyOwner {
400       require(_newAdmin != address(0));
401       admin_accounts[_newAdmin]=true;
402     
403       emit AddNewAdministrator(_newAdmin, block.timestamp);
404     }
405   
406     /**
407      *  @dev   remove old admin accounts
408      *        (run by admin, public function) 
409      *  @param _oldAdmin   old admin address
410      */
411     function z_admin_remove_admin(address _oldAdmin) public onlyOwner {
412       require(_oldAdmin != address(0));
413       require(admin_accounts[_oldAdmin]==true);
414       admin_accounts[_oldAdmin]=false;
415     
416       emit RemoveAdministrator(_oldAdmin, block.timestamp);
417     }
418   
419     event AddNewExchangeAccount(address indexed _exchange_account, uint256 indexed _when);
420 
421     /**
422      *  @dev   add new exchange office accounts
423      *        (run by admin, public function) 
424      *  @param _exchange_account   new exchange address
425      */
426     function z_admin_add_exchange(address _exchange_account) public onlyAdmin {
427       require(_exchange_account != address(0));
428       cryptocurrency_exchange_company_accounts.push(_exchange_account);
429     
430       emit AddNewExchangeAccount(_exchange_account, block.timestamp);
431     }
432  
433     event SaleTokenPriceSet(uint256 _stage_index, uint256 _wei_per_viva_value, uint256 indexed _when);
434 
435     /**
436      * @dev  set new token sale price for current sale stage
437      *       (run buy admin, public function)
438      * return  _how_many_wei_per_viva   new token sale price (wei per viva)
439      */
440     function z_admin_set_sale_price(uint256 _how_many_wei_per_viva) public
441         onlyAdmin 
442     {
443         if(_how_many_wei_per_viva == 0) revert();
444         if(sale_stage_index >= 5) revert();
445         sale_price_per_stage_wei_per_viva[sale_stage_index] = _how_many_wei_per_viva;
446         emit SaleTokenPriceSet(sale_stage_index, _how_many_wei_per_viva, block.timestamp);
447     }
448 
449     /**
450      * @dev  return current or last token sale price
451      *       (public view function)
452      * return  _sale_price   get current token sale price (wei per viva)
453      * return  _current_sale_stage_index   get current sale stage index ( 0 ~ 4)
454      */
455     function CurrentSalePrice() public view returns (uint256 _sale_price, uint256 _current_sale_stage_index)  {
456         if(sale_stage_index >= 5) revert();
457         _current_sale_stage_index= sale_stage_index;
458         _sale_price= sale_price_per_stage_wei_per_viva[sale_stage_index];
459     }
460 
461 
462     event InitializedStage(uint256 indexed _when);
463     event StartStage0TokenSale(uint256 indexed _when);
464     event StartStage1TokenSale(uint256 indexed _when);
465     event StartStage2TokenSale(uint256 indexed _when);
466     event StartStage3TokenSale(uint256 indexed _when);
467     event StartStage4TokenSale(uint256 indexed _when);
468 
469     /**
470      * @dev  start _new_sale_stage_index sale stage
471      *    (run by admin )
472      */
473     function start_StageN_Sale(uint256 _new_sale_stage_index) internal
474     {
475         if(sale_status==Sale_Status.Initialized_STATUS || sale_stage_index+1<= _new_sale_stage_index)
476            sale_stage_index= _new_sale_stage_index;
477         else
478            revert();
479         sale_status= Sale_Status(1 + sale_stage_index * 2); // 0=>1, 1=>3, 2=>5, 3=>7, 4=>9
480         when_stageN_sale_started[sale_stage_index]= block.timestamp;
481         if(sale_stage_index==0) emit StartStage0TokenSale(block.timestamp); 
482         if(sale_stage_index==1) emit StartStage1TokenSale(block.timestamp); 
483         if(sale_stage_index==2) emit StartStage2TokenSale(block.timestamp); 
484         if(sale_stage_index==3) emit StartStage3TokenSale(block.timestamp); 
485         if(sale_stage_index==4) emit StartStage4TokenSale(block.timestamp); 
486     }
487 
488 
489 
490     event StopStage0TokenSale(uint256 indexed _when);
491     event StopStage1TokenSale(uint256 indexed _when);
492     event StopStage2TokenSale(uint256 indexed _when);
493     event StopStage3TokenSale(uint256 indexed _when);
494     event StopStage4TokenSale(uint256 indexed _when);
495 
496     /**
497      * @dev  stop this [_old_sale_stage_index] sale stage
498      *     (run by admin )
499      */
500     function stop_StageN_Sale(uint256 _old_sale_stage_index) internal 
501     {
502         if(sale_stage_index != _old_sale_stage_index)
503            revert();
504         sale_status= Sale_Status(2 + sale_stage_index * 2); // 0=>2, 1=>4, 2=>6, 3=>8, 4=>10
505         when_stageN_sale_stopped[sale_stage_index]= block.timestamp;
506         if(sale_stage_index==0) emit StopStage0TokenSale(block.timestamp); 
507         if(sale_stage_index==1) emit StopStage1TokenSale(block.timestamp); 
508         if(sale_stage_index==2) emit StopStage2TokenSale(block.timestamp); 
509         if(sale_stage_index==3) emit StopStage3TokenSale(block.timestamp); 
510         if(sale_stage_index==4) emit StopStage4TokenSale(block.timestamp); 
511     }
512 
513 
514 
515     event StartTradePublicSaleTokens(uint256 indexed _when);
516 
517     /**
518      *  @dev  allow stage1~4 token trading 
519      *      (run by admin )
520      */
521     function start_Public_Trade() internal
522         onlyAdmin
523     {
524         // if current sale stage had not been stopped, first stop current active sale stage 
525         Sale_Status new_sale_status= Sale_Status(2 + sale_stage_index * 2);
526         if(new_sale_status > sale_status)
527           stop_StageN_Sale(sale_stage_index);
528 
529         sale_status= Sale_Status.Public_Allowed_To_Trade_STATUS;
530         when_public_allowed_to_trade_started= block.timestamp;
531         emit StartTradePublicSaleTokens(block.timestamp); 
532     }
533 
534     event StartTradeStage0SaleTokens(uint256 indexed _when);
535 
536     /**
537      *  @dev  allow stage0 token trading
538      *        (run by admin )
539      */
540     function start_Stage0_Trade() internal
541         onlyAdmin
542     {
543         if(sale_status!= Sale_Status.Public_Allowed_To_Trade_STATUS) revert();
544         
545         // allowed 1 year later after stage1 tokens trading is enabled
546 
547         uint32 stage0_locked_year= 1;
548  
549         bool is_debug= false; // change to false if this contract source  is release version 
550         if(is_debug==false && block.timestamp <  stage0_locked_year*365*24*60*60
551             + when_public_allowed_to_trade_started  )  
552 	      revert();
553         if(is_debug==true  && block.timestamp <  stage0_locked_year*10*60
554             + when_public_allowed_to_trade_started  )  
555 	      revert();
556 	      
557         sale_status= Sale_Status.Stage0_Allowed_To_Trade_STATUS;
558         when_stage0_allowed_to_trade_started= block.timestamp;
559         emit StartTradeStage0SaleTokens(block.timestamp); 
560     }
561 
562 
563 
564 
565     event CreateTokenContract(uint256 indexed _when);
566 
567     /**
568      *  @dev  token contract constructor(), initialized tokens supply and sale status variables
569      *         (run by owner when contract deploy)
570      */
571     constructor() public
572     {
573         totalSupply = _totalTokenAmount;
574         balances[msg.sender] = _totalTokenAmount;
575 
576         sale_status= Sale_Status.Initialized_STATUS;
577         sale_stage_index= 0;
578 
579         when_initialized= block.timestamp;
580 
581         holders.push(msg.sender); 
582         holders_received_accumul[msg.sender] += _totalTokenAmount;
583 
584         emit Transfer(address(0x0), msg.sender, _totalTokenAmount);
585         emit InitializedStage(block.timestamp);
586         emit CreateTokenContract(block.timestamp); 
587     }
588 
589 
590 
591 
592     /**
593      * @dev check if specified token transfer request is valid 
594      *           ( internal modifier function).
595      *           revert  if transfer should be NOT allowed, otherwise do nothing
596      * @param _from   source account from whom tokens should be transferred
597      * @param _to   destination account to whom tokens should be transferred
598      * @param _value   number of tokens to be transferred
599      */
600     modifier validTransaction( address _from, address _to, uint256 _value)
601     {
602         require(_to != address(0x0));
603         require(_to != _from);
604         require(_value > 0);
605         if(isAdmin()==false)  {
606 	    // if _from is frozen account, disallow this request
607 	    if(account_frozen_time[_from] > 0) revert();
608 	    if(_value == 0 ) revert();
609 
610             // if token trading is not enabled yet, disallow this request
611             if(sale_status < Sale_Status.Public_Allowed_To_Trade_STATUS) revert();
612 
613             // if stage0 token trading is not enabled yet, disallow this request
614             if( sale_amount_stage0_account[_from] > 0 ) {
615                 if(sale_status < Sale_Status.Stage0_Allowed_To_Trade_STATUS)  
616                     revert();
617             }  else {
618             }
619   	 }
620         _;
621     }
622 
623 
624     event TransferToken(address indexed _from_whom,address indexed _to_whom,
625          uint _token_value, uint256 indexed _when);
626     event TransferTokenFrom(address indexed _from_whom,address indexed _to_whom, address _agent,
627 	 uint _token_value, uint256 indexed _when);
628     event TransferTokenFromByAdmin(address indexed _from_whom,address indexed _to_whom, address _admin, 
629  	 uint _token_value, uint256 indexed _when);
630 
631     /**
632      * @dev transfer specified amount of tokens from my account to _to account 
633      *     (run by self, public function)
634      * @param _to   destination account to whom tokens should be transferred
635      * @param _value   number of tokens to be transferred
636      * @return _success   report if transfer was successful, on failure revert()
637      */
638     function transfer(address _to, uint _value) public 
639         validTransaction(msg.sender, _to,  _value)
640     returns (bool _success) 
641     {
642         _success= super.transfer(_to, _value);
643         if(_success==false) revert();
644 
645   	emit TransferToken(msg.sender,_to,_value,block.timestamp);
646 
647 	// check if new trading holder
648         if(holders_received_accumul[_to]==0x0) {
649 	   // new holder comes
650            holders.push(_to); 
651            holders_trading.push(_to);
652 	   emit NewHolderTrading(_to, block.timestamp);
653         }
654         holders_received_accumul[_to] += _value;
655 
656 	// leave a transfer history entry
657         history_token_transfer.push( history_token_transfer_obj( {
658 	       _from: msg.sender,
659 	       _to: _to,
660 	       _token_value: _value,
661 	       _when: block.timestamp
662         } ) );
663     }
664 
665     /**
666      * @dev transfer specified amount of tokens from _from account to _to account
667      *     (run by agent, public function)
668      * @param _from   client account who approved transaction performed by this sender as agent
669      * @param _to   destination account to whom tokens should be transferred
670      * @param _value   number of tokens to be transferred
671      * @return _success   report if transfer was successful, on failure revert()
672      */
673     function transferFrom(address _from, address _to, uint _value) public 
674         validTransaction(_from, _to, _value)
675     returns (bool _success) 
676     {
677         if(isAdmin()==true) {
678             // admins can transfer tokens of **ANY** accounts
679             emit TransferTokenFromByAdmin(_from,_to,msg.sender,_value,block.timestamp);
680             _success= super.transferFromByAdmin(_from,_to, _value);
681         }
682         else {
683             // approved agents can transfer tokens of their clients (clients shoukd 'approve()' agents first)
684             emit TransferTokenFrom(_from,_to,msg.sender,_value,block.timestamp);
685             _success= super.transferFrom(_from, _to, _value);
686         }
687 
688         if(_success==false) revert();
689         
690 	// check if new trading holder
691         if(holders_received_accumul[_to]==0x0) {
692 	   // new holder comes
693            holders.push(_to); 
694            holders_trading.push(_to); 
695 	   emit NewHolderTrading(_to, block.timestamp);
696         }
697         holders_received_accumul[_to] += _value;
698 
699 	// leave a transfer history entry
700         history_token_transfer.push( history_token_transfer_obj( {
701 	       _from: _from,
702 	       _to: _to,
703 	       _token_value: _value,
704 	       _when: block.timestamp
705         } ) );
706 
707     }
708 
709     
710     event IssueTokenSale(address indexed _buyer, uint _ether_value, uint _token_value,
711            uint _exchange_rate_viva_per_wei, uint256 indexed _when);
712 
713     /**
714      * @dev  fallback function for incoming ether, receive ethers and give tokens back
715      */
716     function () public payable {
717         buy();
718     }
719 
720     event NewHolderTrading(address indexed _new_comer, uint256 indexed _when);
721     event NewHolderSale(address indexed _new_comer, uint256 indexed _when);
722     
723     /**
724      *  @dev   buy viva tokens by sending some ethers  to this contract address
725      *       (payable public function )
726      */
727     function buy() public payable {
728         if(sale_status < Sale_Status.Stage0_Sale_Started_STATUS) 
729            revert();
730         
731         if(sale_status > Sale_Status.Stage4_Sale_Stopped_STATUS) 
732            revert();
733         
734         if((uint256(sale_status)%2)!=1)  revert(); // not in started sale status
735         if(isAdmin()==true)  revert(); // admins are not allowed to buy tokens
736 	  
737         uint256 tokens;
738         
739         uint256 wei_per_viva= sale_price_per_stage_wei_per_viva[sale_stage_index];
740 
741         // if sent ether value is less than exch_rate, revert
742         if (msg.value <  wei_per_viva) revert();
743 
744         // calculate num of bought tokens based on sent ether value (in wei)
745 	tokens = uint256( msg.value /  wei_per_viva );
746       
747         if (tokens + sold_tokens_total > totalSupply) revert();
748 
749         // update token sale statistics  per stage
750 	if(sale_stage_index==0) sale_amount_stage0_account[msg.sender] += tokens; else	
751 	if(sale_stage_index==1) sale_amount_stage1_account[msg.sender] += tokens; else	
752 	if(sale_stage_index==2) sale_amount_stage2_account[msg.sender] += tokens; else	
753 	if(sale_stage_index==3) sale_amount_stage3_account[msg.sender] += tokens; else	
754 	if(sale_stage_index==4) sale_amount_stage4_account[msg.sender] += tokens;	
755 	sold_tokens_per_stage[sale_stage_index] += tokens;
756         sold_tokens_total += tokens;
757 
758         // update ether statistics
759 	raised_ethers_per_stage[sale_stage_index] +=  msg.value;
760         raised_ethers_total +=  msg.value;
761 
762         super.transferFromByAdmin(owner, msg.sender, tokens);
763 
764 	// check if this holder is new
765         if(holders_received_accumul[msg.sender]==0x0) {
766 	   // new holder comes
767            holders.push(msg.sender); 
768 	   if(sale_stage_index==0) holders_stage0_sale.push(msg.sender); else 
769 	   if(sale_stage_index==1) holders_stage1_sale.push(msg.sender); else 
770 	   if(sale_stage_index==2) holders_stage2_sale.push(msg.sender); else 
771 	   if(sale_stage_index==3) holders_stage3_sale.push(msg.sender); else 
772 	   if(sale_stage_index==4) holders_stage4_sale.push(msg.sender); 
773 	   emit NewHolderSale(msg.sender, block.timestamp);
774         }
775         holders_received_accumul[msg.sender] += tokens;
776 
777         emit IssueTokenSale(msg.sender, msg.value, tokens, wei_per_viva, block.timestamp);
778         
779         // if target ether is reached, stop this sale stage 
780 	if( target_ethers_per_stage[sale_stage_index] <= raised_ethers_per_stage[sale_stage_index])
781     	    stop_StageN_Sale(sale_stage_index);
782     }
783 
784 
785     event FreezeAccount(address indexed _account_to_freeze, uint256 indexed _when);
786     event UnfreezeAccount(address indexed _account_to_unfreeze, uint256 indexed _when);
787     
788     /**
789      * @dev freeze a holder account, prohibit further token transfer 
790      *     (run by ADMIN, public function)
791      * @param _account_to_freeze   account to freeze
792      */
793     function z_admin_freeze(address _account_to_freeze) public onlyAdmin   {
794         account_frozen_time[_account_to_freeze]= block.timestamp;
795         holders_frozen.push(_account_to_freeze);
796         emit FreezeAccount(_account_to_freeze,block.timestamp); 
797     }
798 
799     /**
800      * @dev unfreeze a holder account 
801      *     (run by ADMIN, public function)
802      * @param _account_to_unfreeze   account to unfreeze (previously frozen)
803      */
804     function z_admin_unfreeze(address _account_to_unfreeze) public onlyAdmin   {
805         account_frozen_time[_account_to_unfreeze]= 0; // reset time to zero
806         emit UnfreezeAccount(_account_to_unfreeze,block.timestamp); 
807     }
808 
809 
810 
811 
812     event CloseTokenContract(uint256 indexed _when);
813 
814     /**
815      * @dev close this contract after burning all tokens 
816      *     (run by ADMIN, public function )
817      */
818     function closeContract() onlyAdmin internal {
819 	if(sale_status < Sale_Status.Stage0_Allowed_To_Trade_STATUS)  revert();
820 	if(totalSupply > 0)  revert();
821     	address ScAddress = this;
822         emit CloseTokenContract(block.timestamp); 
823         emit WithdrawEther(owner,ScAddress.balance,block.timestamp); 
824 	selfdestruct(owner);
825     } 
826 
827 
828 
829     /**
830      * @dev retrieve contract's ether balance info 
831      *     (public view function)
832      * @return _current_ether_balane   current contract ethereum balance ( in wei unit)
833      * @return _ethers_withdrawn   withdrawen ethers in wei
834      * @return _ethers_raised_total   total ethers gathered from token sale
835      */
836     function ContractEtherBalance() public view
837     returns (
838       uint256 _current_ether_balance,
839       uint256 _ethers_withdrawn,
840       uint256 _ethers_raised_total 
841      ) {
842 	_current_ether_balance= address(this).balance;
843 	_ethers_withdrawn= totalEtherWithdrawed;
844 	_ethers_raised_total= raised_ethers_total;
845     } 
846 
847     event WithdrawEther(address indexed _addr, uint256 _value, uint256 indexed _when);
848 
849     /**
850      * @dev transfer this contract ether balance to owner's account 
851      *    ( public function )
852      * @param _withdraw_wei_value   amount to widthdraw ( in wei unit)
853      */
854     function z_admin_withdraw_ether(uint256 _withdraw_wei_value) onlyAdmin public {
855     	address ScAddress = this;
856     	if(_withdraw_wei_value > ScAddress.balance) revert();
857     	//if(owner.call.value(_withdraw_wei_value).gas(5000)()==false) revert();
858     	if(owner.send(_withdraw_wei_value)==false) revert();
859         totalEtherWithdrawed += _withdraw_wei_value;
860         emit WithdrawEther(owner,_withdraw_wei_value,block.timestamp); 
861     } 
862 
863 
864     /**
865      * @dev return  list of active holders accounts and their balances 
866      *     ( public view function )
867      * @param _max_num_of_items_to_display   Max Number of latest accounts items to display ( 0 means 1 )
868      * @return  _num_of_active_holders   number of latest holders accounts
869      * @return  _active_holders   array of active( balance > 0) holders
870      * @return  _token_balances   array of token balances 
871      */
872     function list_active_holders_and_balances(uint _max_num_of_items_to_display) public view 
873       returns (uint _num_of_active_holders,address[] _active_holders,uint[] _token_balances){
874       uint len = holders.length;
875       _num_of_active_holders = 0;
876       if(_max_num_of_items_to_display==0) _max_num_of_items_to_display=1;
877       for (uint i = len-1 ; i >= 0 ; i--) {
878          if( balances[ holders[i] ] != 0x0) _num_of_active_holders++;
879          if(_max_num_of_items_to_display == _num_of_active_holders) break;
880       }
881       _active_holders = new address[](_num_of_active_holders);
882       _token_balances = new uint[](_num_of_active_holders);
883       uint num=0;
884       for (uint j = len-1 ; j >= 0 && _num_of_active_holders > num ; j--) {
885          address addr = holders[j];
886          if( balances[ addr ] == 0x0) continue; // assure balance > 0
887          _active_holders[num] = addr;
888          _token_balances[num] = balances[addr];
889          num++;
890       }
891     }
892 
893 
894     /**
895      * @dev return  list of latest #N transfer history
896      *      ( public view function )
897      * @param _max_num_of_items_to_display   Max Number of latest history items to display ( 0 means 1 )
898      * @return  _num   number of latest transfer history items
899      * @return  _senders   array of senders
900      * @return  _receivers   array of receivers
901      * @return  _tokens   array of tokens transferred
902      * @return  _whens   array of transfer times
903      */
904     function list_history_of_token_transfer(uint _max_num_of_items_to_display) public view 
905       returns (uint _num,address[] _senders,address[] _receivers,uint[] _tokens,uint[] _whens){
906       uint len = history_token_transfer.length;
907       uint n= len;
908       if(_max_num_of_items_to_display == 0) _max_num_of_items_to_display= 1;
909       if(_max_num_of_items_to_display <  n) n= _max_num_of_items_to_display;
910       _senders = new address[](n);
911       _receivers = new address[](n);
912       _tokens = new uint[](n);
913       _whens = new uint[](n);
914       _num=0;
915       for (uint j = len-1 ; j >= 0 && n > _num ; j--) {
916          history_token_transfer_obj storage obj= history_token_transfer[j];
917          _senders[_num]= obj._from;
918          _receivers[_num]= obj._to;
919          _tokens[_num]=  obj._token_value;
920          _whens[_num]=   obj._when;
921          _num++;
922       }
923     }
924 
925     /**
926      * @dev return  list of latest address-filtered #N transfer history 
927      *     ( public view function )
928      * @param _addr   address as filter for transfer history (default 0x0)
929      * @return  _num   number of latest transfer history items
930      * @return  _senders   array of senders
931      * @return  _receivers   array of receivers
932      * @return  _tokens   array of tokens transferred
933      * @return  _whens   array of transfer times
934      */
935     function list_history_of_token_transfer_filtered_by_addr(address _addr) public view 
936       returns (uint _num,address[] _senders,address[] _receivers,uint[] _tokens,uint[] _whens){
937       uint len = history_token_transfer.length;
938       uint _max_num_of_items_to_display= 0;
939       history_token_transfer_obj storage obj= history_token_transfer[0];
940       uint j;
941       for (j = len-1 ; j >= 0 ; j--) {
942          obj= history_token_transfer[j];
943          if(obj._from== _addr || obj._to== _addr) _max_num_of_items_to_display++;
944       }
945       if(_max_num_of_items_to_display == 0) _max_num_of_items_to_display= 1;
946       _senders = new address[](_max_num_of_items_to_display);
947       _receivers = new address[](_max_num_of_items_to_display);
948       _tokens = new uint[](_max_num_of_items_to_display);
949       _whens = new uint[](_max_num_of_items_to_display);
950       _num=0;
951       for (j = len-1 ; j >= 0 && _max_num_of_items_to_display > _num ; j--) {
952          obj= history_token_transfer[j];
953          if(obj._from!= _addr && obj._to!= _addr) continue;
954          _senders[_num]= obj._from;
955          _receivers[_num]= obj._to;
956          _tokens[_num]=  obj._token_value;
957          _whens[_num]=   obj._when;
958          _num++;
959       }
960     }
961 
962     /**
963      * @dev return frozen accounts and their balances 
964      *     ( public view function )
965      * @param _max_num_of_items_to_display   Max Number of items to display ( 0 means 1 )
966      * @return  _num   number of currently frozen accounts
967      * @return  _frozen_holders   array of frozen accounts
968      * @return  _whens   array of frozen times
969      */
970     function list_frozen_accounts(uint _max_num_of_items_to_display) public view
971       returns (uint _num,address[] _frozen_holders,uint[] _whens){
972       uint len = holders_frozen.length;
973       uint num_of_frozen_holders = 0;
974       if(_max_num_of_items_to_display==0) _max_num_of_items_to_display=1;
975       for (uint i = len-1 ; i >= 0 ; i--) {
976          // assure currently in frozen state
977          if( account_frozen_time[ holders_frozen[i] ] > 0x0) num_of_frozen_holders++;
978          if(_max_num_of_items_to_display == num_of_frozen_holders) break;
979       }
980       _frozen_holders = new address[](num_of_frozen_holders);
981       _whens = new uint[](num_of_frozen_holders);
982       _num=0;
983       for (uint j = len-1 ; j >= 0 && num_of_frozen_holders > _num ; j--) {
984          address addr= holders_frozen[j];
985          uint256 when= account_frozen_time[ addr ];
986          if( when == 0x0) continue; // assure if frozen true
987          _frozen_holders[_num]= addr;
988          _whens[_num]= when;
989          _num++;
990       }
991     }
992 
993 
994     /**
995      * @dev Admin menu: Token Sale Status management
996      *      (run by admin, public function)
997      * @param _next_status  next status index (1 ~ 13). refer to enum Sale_Status 
998      */
999     function z_admin_next_status(Sale_Status _next_status) onlyAdmin public {
1000       if(_next_status== Sale_Status.Stage0_Sale_Started_STATUS) { start_StageN_Sale(0); return;} // 1
1001       if(_next_status== Sale_Status.Stage0_Sale_Stopped_STATUS) { stop_StageN_Sale(0); return;} // 2
1002       if(_next_status== Sale_Status.Stage1_Sale_Started_STATUS) { start_StageN_Sale(1); return;} // 3
1003       if(_next_status== Sale_Status.Stage1_Sale_Stopped_STATUS) { stop_StageN_Sale(1); return;} // 4
1004       if(_next_status== Sale_Status.Stage2_Sale_Started_STATUS) { start_StageN_Sale(2); return;} // 5
1005       if(_next_status== Sale_Status.Stage2_Sale_Stopped_STATUS) { stop_StageN_Sale(2); return;} // 6
1006       if(_next_status== Sale_Status.Stage3_Sale_Started_STATUS) { start_StageN_Sale(3); return;} // 7
1007       if(_next_status== Sale_Status.Stage3_Sale_Stopped_STATUS) { stop_StageN_Sale(3); return;} // 8
1008       if(_next_status== Sale_Status.Stage4_Sale_Started_STATUS) { start_StageN_Sale(4); return;} // 9
1009       if(_next_status== Sale_Status.Stage4_Sale_Stopped_STATUS) { stop_StageN_Sale(4); return;} // 10
1010       if(_next_status== Sale_Status.Public_Allowed_To_Trade_STATUS) { start_Public_Trade(); return;} //11
1011       if(_next_status== Sale_Status.Stage0_Allowed_To_Trade_STATUS) { start_Stage0_Trade(); return;} //12
1012       if(_next_status== Sale_Status.Closed_STATUS) { closeContract(); return;} //13
1013       revert();
1014     } 
1015 
1016 }