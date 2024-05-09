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
237 /** @title main contract for NOW token. we should deploy this contract. needs about 5,500,000 gas */
238 
239 contract NOWToken is Z_StandardToken, Z_Ownable {
240     string  public  constant name = "NOW";
241     string  public  constant symbol = "NOW";
242     uint8   public  constant decimals = 18; // token traded in integer amounts, no period
243 
244     // total token supply: 3 billion NOW
245     uint256 internal constant _totalTokenAmount = 3 * (10 ** 9) * (10 ** 18);
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
310     // array of token sale price for each stage (wei per now)
311     uint256[NUM_OF_SALE_STAGES] internal  sale_price_per_stage_wei_per_now = [
312       uint256(1000000000000000000/ uint256(100000)),// stage0 for staff
313       uint256(1000000000000000000/ uint256(38000)), // stage1 for black sale
314       uint256(1000000000000000000/ uint256(23000)), // stage2 for private sale
315       uint256(1000000000000000000/ uint256(17000)), // stage3 for public sale
316       uint256(1000000000000000000/ uint256(10000))  // stage4 for crowd sale
317     ];
318 
319     // struct definition for token sale history
320     struct history_token_sale_obj {
321       address _buyer;
322       uint256 _ether_value; // in wei
323       uint256 _token_value; // in now token
324       uint256 _when; 
325     }
326 
327     // struct definition for token transfer history
328     struct history_token_transfer_obj {
329       address _from;
330       address _to;
331       uint256 _token_value; // in now token
332       uint256 _when; 
333     }
334 
335     // struct definition for token burning history
336     struct history_token_burning_obj {
337       address _from;
338       uint256 _token_value_burned; // in now token
339       uint256 _when; 
340     }
341 
342     // token sale history for stage 0 ~ 4
343     history_token_sale_obj[]  internal history_token_sale_stage0;
344     history_token_sale_obj[]  internal history_token_sale_stage1;
345     history_token_sale_obj[]  internal history_token_sale_stage2;
346     history_token_sale_obj[]  internal history_token_sale_stage3;
347     history_token_sale_obj[]  internal history_token_sale_stage4;
348 
349     // token transfer history
350     history_token_transfer_obj[] internal history_token_transfer;
351 
352     // token burning history
353     history_token_burning_obj[]  internal history_token_burning;
354 
355     // token sale amount for each account per stage 0 ~ 4
356     mapping (address => uint256) internal sale_amount_stage0_account;
357     mapping (address => uint256) internal sale_amount_stage1_account;
358     mapping (address => uint256) internal sale_amount_stage2_account;
359     mapping (address => uint256) internal sale_amount_stage3_account;
360     mapping (address => uint256) internal sale_amount_stage4_account;
361 
362     
363     // array for list of  holders and their receiving amounts
364     mapping (address => uint256) internal holders_received_accumul;
365 
366     // array for list of holders accounts (including even inactive holders) 
367     address[] public holders;
368 
369     // array for list of sale holders accounts for each sale stage
370     address[] public holders_stage0_sale;
371     address[] public holders_stage1_sale;
372     address[] public holders_stage2_sale;
373     address[] public holders_stage3_sale;
374     address[] public holders_stage4_sale;
375     
376     // array for list of trading holders which are not sale holders
377     address[] public holders_trading;
378 
379     // array for list of burning holders accounts
380     address[] public holders_burned;
381 
382     // array for list of frozen holders accounts
383     address[] public holders_frozen;
384 
385     // burned tokens for each holders account
386     mapping (address => uint256) public burned_amount;
387 
388     // sum of all burned tokens
389     uint256 public totalBurned= 0;
390 
391     // total ether value withdrawed from this contract by contract owner
392     uint256 public totalEtherWithdrawed= 0;
393 
394     // addess to timestamp mapping  to  mark the account freezing time ( 0 means later unfreezed )
395     mapping (address => uint256) internal account_frozen_time;
396 
397     // unused
398     mapping (address => mapping (string => uint256)) internal traded_monthly;
399 
400     // cryptocurrency exchange office  ether address, for monitorig purpose
401     address[] public cryptocurrency_exchange_company_accounts;
402 
403     
404     /////////////////////////////////////////////////////////////////////////
405  
406     event AddNewAdministrator(address indexed _admin, uint256 indexed _when);
407     event RemoveAdministrator(address indexed _admin, uint256 indexed _when);
408   
409     /**
410      *  @dev   add new admin accounts 
411      *        (run by admin, public function) 
412      *  @param _newAdmin   new admin address
413      */
414     function z_admin_add_admin(address _newAdmin) public onlyOwner {
415       require(_newAdmin != address(0));
416       admin_accounts[_newAdmin]=true;
417     
418       emit AddNewAdministrator(_newAdmin, block.timestamp);
419     }
420   
421     /**
422      *  @dev   remove old admin accounts
423      *        (run by admin, public function) 
424      *  @param _oldAdmin   old admin address
425      */
426     function z_admin_remove_admin(address _oldAdmin) public onlyOwner {
427       require(_oldAdmin != address(0));
428       require(admin_accounts[_oldAdmin]==true);
429       admin_accounts[_oldAdmin]=false;
430     
431       emit RemoveAdministrator(_oldAdmin, block.timestamp);
432     }
433 
434 
435   
436     event AddNewExchangeAccount(address indexed _exchange_account, uint256 indexed _when);
437 
438     /**
439      *  @dev   add new exchange office accounts
440      *        (run by admin, public function) 
441      *  @param _exchange_account   new exchange address
442      */
443     function z_admin_add_exchange(address _exchange_account) public onlyAdmin {
444       require(_exchange_account != address(0));
445       cryptocurrency_exchange_company_accounts.push(_exchange_account);
446     
447       emit AddNewExchangeAccount(_exchange_account, block.timestamp);
448     }
449  
450 
451  
452     event SaleTokenPriceSet(uint256 _stage_index, uint256 _wei_per_now_value, uint256 indexed _when);
453 
454     /**
455      * @dev  set new token sale price for current sale stage
456      *       (run buy admin, public function)
457      * return  _how_many_wei_per_now   new token sale price (wei per now)
458      */
459     function z_admin_set_sale_price(uint256 _how_many_wei_per_now) public
460         onlyAdmin 
461     {
462         if(_how_many_wei_per_now == 0) revert();
463         if(sale_stage_index >= 5) revert();
464         sale_price_per_stage_wei_per_now[sale_stage_index] = _how_many_wei_per_now;
465         emit SaleTokenPriceSet(sale_stage_index, _how_many_wei_per_now, block.timestamp);
466     }
467 
468     /**
469      * @dev  return current or last token sale price
470      *       (public view function)
471      * return  _sale_price   get current token sale price (wei per now)
472      * return  _current_sale_stage_index   get current sale stage index ( 0 ~ 4)
473      */
474     function CurrentSalePrice() public view returns (uint256 _sale_price, uint256 _current_sale_stage_index)  {
475         if(sale_stage_index >= 5) revert();
476         _current_sale_stage_index= sale_stage_index;
477         _sale_price= sale_price_per_stage_wei_per_now[sale_stage_index];
478     }
479 
480 
481 
482 
483     event InitializedStage(uint256 indexed _when);
484     event StartStage0TokenSale(uint256 indexed _when);
485     event StartStage1TokenSale(uint256 indexed _when);
486     event StartStage2TokenSale(uint256 indexed _when);
487     event StartStage3TokenSale(uint256 indexed _when);
488     event StartStage4TokenSale(uint256 indexed _when);
489 
490     /**
491      * @dev  start _new_sale_stage_index sale stage
492      *    (run by admin )
493      */
494     function start_StageN_Sale(uint256 _new_sale_stage_index) internal
495     {
496         if(sale_status==Sale_Status.Initialized_STATUS || sale_stage_index+1<= _new_sale_stage_index)
497            sale_stage_index= _new_sale_stage_index;
498         else
499            revert();
500         sale_status= Sale_Status(1 + sale_stage_index * 2); // 0=>1, 1=>3, 2=>5, 3=>7, 4=>9
501         when_stageN_sale_started[sale_stage_index]= block.timestamp;
502         if(sale_stage_index==0) emit StartStage0TokenSale(block.timestamp); 
503         if(sale_stage_index==1) emit StartStage1TokenSale(block.timestamp); 
504         if(sale_stage_index==2) emit StartStage2TokenSale(block.timestamp); 
505         if(sale_stage_index==3) emit StartStage3TokenSale(block.timestamp); 
506         if(sale_stage_index==4) emit StartStage4TokenSale(block.timestamp); 
507     }
508 
509 
510 
511     event StopStage0TokenSale(uint256 indexed _when);
512     event StopStage1TokenSale(uint256 indexed _when);
513     event StopStage2TokenSale(uint256 indexed _when);
514     event StopStage3TokenSale(uint256 indexed _when);
515     event StopStage4TokenSale(uint256 indexed _when);
516 
517     /**
518      * @dev  stop this [_old_sale_stage_index] sale stage
519      *     (run by admin )
520      */
521     function stop_StageN_Sale(uint256 _old_sale_stage_index) internal 
522     {
523         if(sale_stage_index != _old_sale_stage_index)
524            revert();
525         sale_status= Sale_Status(2 + sale_stage_index * 2); // 0=>2, 1=>4, 2=>6, 3=>8, 4=>10
526         when_stageN_sale_stopped[sale_stage_index]= block.timestamp;
527         if(sale_stage_index==0) emit StopStage0TokenSale(block.timestamp); 
528         if(sale_stage_index==1) emit StopStage1TokenSale(block.timestamp); 
529         if(sale_stage_index==2) emit StopStage2TokenSale(block.timestamp); 
530         if(sale_stage_index==3) emit StopStage3TokenSale(block.timestamp); 
531         if(sale_stage_index==4) emit StopStage4TokenSale(block.timestamp); 
532     }
533 
534 
535 
536     event StartTradePublicSaleTokens(uint256 indexed _when);
537 
538     /**
539      *  @dev  allow stage1~4 token trading 
540      *      (run by admin )
541      */
542     function start_Public_Trade() internal
543         onlyAdmin
544     {
545         // if current sale stage had not been stopped, first stop current active sale stage 
546         Sale_Status new_sale_status= Sale_Status(2 + sale_stage_index * 2);
547         if(new_sale_status > sale_status)
548           stop_StageN_Sale(sale_stage_index);
549 
550         sale_status= Sale_Status.Public_Allowed_To_Trade_STATUS;
551         when_public_allowed_to_trade_started= block.timestamp;
552         emit StartTradePublicSaleTokens(block.timestamp); 
553     }
554 
555     event StartTradeStage0SaleTokens(uint256 indexed _when);
556 
557     /**
558      *  @dev  allow stage0 token trading
559      *        (run by admin )
560      */
561     function start_Stage0_Trade() internal
562         onlyAdmin
563     {
564         if(sale_status!= Sale_Status.Public_Allowed_To_Trade_STATUS) revert();
565         
566         // allowed 1 year later after stage1 tokens trading is enabled
567 
568         uint32 stage0_locked_year= 1;
569  
570         bool is_debug= false; // change to false if this contract source  is release version 
571         if(is_debug==false && block.timestamp <  stage0_locked_year*365*24*60*60
572             + when_public_allowed_to_trade_started  )  
573 	      revert();
574         if(is_debug==true  && block.timestamp <  stage0_locked_year*10*60
575             + when_public_allowed_to_trade_started  )  
576 	      revert();
577 	      
578         sale_status= Sale_Status.Stage0_Allowed_To_Trade_STATUS;
579         when_stage0_allowed_to_trade_started= block.timestamp;
580         emit StartTradeStage0SaleTokens(block.timestamp); 
581     }
582 
583 
584 
585 
586     event CreateTokenContract(uint256 indexed _when);
587 
588     /**
589      *  @dev  token contract constructor(), initialized tokens supply and sale status variables
590      *         (run by owner when contract deploy)
591      */
592     constructor() public
593     {
594         totalSupply = _totalTokenAmount;
595         balances[msg.sender] = _totalTokenAmount;
596 
597         sale_status= Sale_Status.Initialized_STATUS;
598         sale_stage_index= 0;
599 
600         when_initialized= block.timestamp;
601 
602         holders.push(msg.sender); 
603         holders_received_accumul[msg.sender] += _totalTokenAmount;
604 
605         emit Transfer(address(0x0), msg.sender, _totalTokenAmount);
606         emit InitializedStage(block.timestamp);
607         emit CreateTokenContract(block.timestamp); 
608     }
609 
610 
611 
612 
613     /**
614      * @dev check if specified token transfer request is valid 
615      *           ( internal modifier function).
616      *           revert  if transfer should be NOT allowed, otherwise do nothing
617      * @param _from   source account from whom tokens should be transferred
618      * @param _to   destination account to whom tokens should be transferred
619      * @param _value   number of tokens to be transferred
620      */
621     modifier validTransaction( address _from, address _to, uint256 _value)
622     {
623         require(_to != address(0x0));
624         require(_to != _from);
625         require(_value > 0);
626         if(isAdmin()==false)  {
627 	    // if _from is frozen account, disallow this request
628 	    if(account_frozen_time[_from] > 0) revert();
629 	    if(_value == 0 ) revert();
630 
631             // if token trading is not enabled yet, disallow this request
632             if(sale_status < Sale_Status.Public_Allowed_To_Trade_STATUS) revert();
633 
634             // if stage0 token trading is not enabled yet, disallow this request
635             if( sale_amount_stage0_account[_from] > 0 ) {
636                 if(sale_status < Sale_Status.Stage0_Allowed_To_Trade_STATUS)  
637                     revert();
638             }  else {
639             }
640   	 }
641         _;
642     }
643 
644 
645     event TransferToken(address indexed _from_whom,address indexed _to_whom,
646          uint _token_value, uint256 indexed _when);
647     event TransferTokenFrom(address indexed _from_whom,address indexed _to_whom, address _agent,
648 	 uint _token_value, uint256 indexed _when);
649     event TransferTokenFromByAdmin(address indexed _from_whom,address indexed _to_whom, address _admin, 
650  	 uint _token_value, uint256 indexed _when);
651 
652     /**
653      * @dev transfer specified amount of tokens from my account to _to account 
654      *     (run by self, public function)
655      * @param _to   destination account to whom tokens should be transferred
656      * @param _value   number of tokens to be transferred
657      * @return _success   report if transfer was successful, on failure revert()
658      */
659     function transfer(address _to, uint _value) public 
660         validTransaction(msg.sender, _to,  _value)
661     returns (bool _success) 
662     {
663         _success= super.transfer(_to, _value);
664         if(_success==false) revert();
665 
666   	emit TransferToken(msg.sender,_to,_value,block.timestamp);
667 
668 	// check if new trading holder
669         if(holders_received_accumul[_to]==0x0) {
670 	   // new holder comes
671            holders.push(_to); 
672            holders_trading.push(_to);
673 	   emit NewHolderTrading(_to, block.timestamp);
674         }
675         holders_received_accumul[_to] += _value;
676 
677 	// leave a transfer history entry
678         history_token_transfer.push( history_token_transfer_obj( {
679 	       _from: msg.sender,
680 	       _to: _to,
681 	       _token_value: _value,
682 	       _when: block.timestamp
683         } ) );
684     }
685 
686     /**
687      * @dev transfer specified amount of tokens from _from account to _to account
688      *     (run by agent, public function)
689      * @param _from   client account who approved transaction performed by this sender as agent
690      * @param _to   destination account to whom tokens should be transferred
691      * @param _value   number of tokens to be transferred
692      * @return _success   report if transfer was successful, on failure revert()
693      */
694     function transferFrom(address _from, address _to, uint _value) public 
695         validTransaction(_from, _to, _value)
696     returns (bool _success) 
697     {
698         if(isAdmin()==true) {
699             // admins can transfer tokens of **ANY** accounts
700             emit TransferTokenFromByAdmin(_from,_to,msg.sender,_value,block.timestamp);
701             _success= super.transferFromByAdmin(_from,_to, _value);
702         }
703         else {
704             // approved agents can transfer tokens of their clients (clients shoukd 'approve()' agents first)
705             emit TransferTokenFrom(_from,_to,msg.sender,_value,block.timestamp);
706             _success= super.transferFrom(_from, _to, _value);
707         }
708 
709         if(_success==false) revert();
710         
711 	// check if new trading holder
712         if(holders_received_accumul[_to]==0x0) {
713 	   // new holder comes
714            holders.push(_to); 
715            holders_trading.push(_to); 
716 	   emit NewHolderTrading(_to, block.timestamp);
717         }
718         holders_received_accumul[_to] += _value;
719 
720 	// leave a transfer history entry
721         history_token_transfer.push( history_token_transfer_obj( {
722 	       _from: _from,
723 	       _to: _to,
724 	       _token_value: _value,
725 	       _when: block.timestamp
726         } ) );
727 
728     }
729 
730 
731 
732 
733     
734     event IssueTokenSale(address indexed _buyer, uint _ether_value, uint _token_value,
735            uint _exchange_rate_now_per_wei, uint256 indexed _when);
736 
737     /**
738      * @dev  fallback function for incoming ether, receive ethers and give tokens back
739      */
740     function () public payable {
741         buy();
742     }
743 
744     event NewHolderTrading(address indexed _new_comer, uint256 indexed _when);
745     event NewHolderSale(address indexed _new_comer, uint256 indexed _when);
746     
747     /**
748      *  @dev   buy now tokens by sending some ethers  to this contract address
749      *       (payable public function )
750      */
751     function buy() public payable {
752         if(sale_status < Sale_Status.Stage0_Sale_Started_STATUS) 
753            revert();
754         
755         if(sale_status > Sale_Status.Stage4_Sale_Stopped_STATUS) 
756            revert();
757         
758         if((uint256(sale_status)%2)!=1)  revert(); // not in started sale status
759         if(isAdmin()==true)  revert(); // admins are not allowed to buy tokens
760 	  
761         uint256 tokens;
762         
763         uint256 wei_per_now= sale_price_per_stage_wei_per_now[sale_stage_index];
764 
765         // if sent ether value is less than exch_rate, revert
766         if (msg.value <  wei_per_now) revert();
767 
768         // calculate num of bought tokens based on sent ether value (in wei)
769 	tokens = uint256( msg.value /  wei_per_now );
770       
771         if (tokens + sold_tokens_total > totalSupply) revert();
772 
773         // update token sale statistics  per stage
774 	if(sale_stage_index==0) sale_amount_stage0_account[msg.sender] += tokens; else	
775 	if(sale_stage_index==1) sale_amount_stage1_account[msg.sender] += tokens; else	
776 	if(sale_stage_index==2) sale_amount_stage2_account[msg.sender] += tokens; else	
777 	if(sale_stage_index==3) sale_amount_stage3_account[msg.sender] += tokens; else	
778 	if(sale_stage_index==4) sale_amount_stage4_account[msg.sender] += tokens;	
779 	sold_tokens_per_stage[sale_stage_index] += tokens;
780         sold_tokens_total += tokens;
781 
782         // update ether statistics
783 	raised_ethers_per_stage[sale_stage_index] +=  msg.value;
784         raised_ethers_total +=  msg.value;
785 
786         super.transferFromByAdmin(owner, msg.sender, tokens);
787 
788 	// check if this holder is new
789         if(holders_received_accumul[msg.sender]==0x0) {
790 	   // new holder comes
791            holders.push(msg.sender); 
792 	   if(sale_stage_index==0) holders_stage0_sale.push(msg.sender); else 
793 	   if(sale_stage_index==1) holders_stage1_sale.push(msg.sender); else 
794 	   if(sale_stage_index==2) holders_stage2_sale.push(msg.sender); else 
795 	   if(sale_stage_index==3) holders_stage3_sale.push(msg.sender); else 
796 	   if(sale_stage_index==4) holders_stage4_sale.push(msg.sender); 
797 	   emit NewHolderSale(msg.sender, block.timestamp);
798         }
799         holders_received_accumul[msg.sender] += tokens;
800     
801         // leave a token sale history entry
802         history_token_sale_obj memory history = history_token_sale_obj( {
803 	       _buyer: msg.sender,
804 	       _ether_value: msg.value,
805 	       _token_value: tokens,
806 	       _when: block.timestamp
807         } );
808         if(sale_stage_index==0) history_token_sale_stage0.push( history ); else
809         if(sale_stage_index==1) history_token_sale_stage1.push( history ); else
810         if(sale_stage_index==2) history_token_sale_stage2.push( history ); else
811         if(sale_stage_index==3) history_token_sale_stage3.push( history ); else
812         if(sale_stage_index==4) history_token_sale_stage4.push( history );
813 
814         emit IssueTokenSale(msg.sender, msg.value, tokens, wei_per_now, block.timestamp);
815         
816         // if target ether is reached, stop this sale stage 
817 	if( target_ethers_per_stage[sale_stage_index] <= raised_ethers_per_stage[sale_stage_index])
818     	    stop_StageN_Sale(sale_stage_index);
819     }
820 
821 
822     event FreezeAccount(address indexed _account_to_freeze, uint256 indexed _when);
823     event UnfreezeAccount(address indexed _account_to_unfreeze, uint256 indexed _when);
824     
825     /**
826      * @dev freeze a holder account, prohibit further token transfer 
827      *     (run by ADMIN, public function)
828      * @param _account_to_freeze   account to freeze
829      */
830     function z_admin_freeze(address _account_to_freeze) public onlyAdmin   {
831         account_frozen_time[_account_to_freeze]= block.timestamp;
832         holders_frozen.push(_account_to_freeze);
833         emit FreezeAccount(_account_to_freeze,block.timestamp); 
834     }
835 
836     /**
837      * @dev unfreeze a holder account 
838      *     (run by ADMIN, public function)
839      * @param _account_to_unfreeze   account to unfreeze (previously frozen)
840      */
841     function z_admin_unfreeze(address _account_to_unfreeze) public onlyAdmin   {
842         account_frozen_time[_account_to_unfreeze]= 0; // reset time to zero
843         emit UnfreezeAccount(_account_to_unfreeze,block.timestamp); 
844     }
845 
846 
847 
848 
849     event CloseTokenContract(uint256 indexed _when);
850 
851     /**
852      * @dev close this contract after burning all tokens 
853      *     (run by ADMIN, public function )
854      */
855     function closeContract() onlyAdmin internal {
856 	if(sale_status < Sale_Status.Stage0_Allowed_To_Trade_STATUS)  revert();
857 	if(totalSupply > 0)  revert();
858     	address ScAddress = this;
859         emit CloseTokenContract(block.timestamp); 
860         emit WithdrawEther(owner,ScAddress.balance,block.timestamp); 
861 	selfdestruct(owner);
862     } 
863 
864 
865 
866     /**
867      * @dev retrieve contract's ether balance info 
868      *     (public view function)
869      * @return _current_ether_balane   current contract ethereum balance ( in wei unit)
870      * @return _ethers_withdrawn   withdrawen ethers in wei
871      * @return _ethers_raised_total   total ethers gathered from token sale
872      */
873     function ContractEtherBalance() public view
874     returns (
875       uint256 _current_ether_balance,
876       uint256 _ethers_withdrawn,
877       uint256 _ethers_raised_total 
878      ) {
879 	_current_ether_balance= address(this).balance;
880 	_ethers_withdrawn= totalEtherWithdrawed;
881 	_ethers_raised_total= raised_ethers_total;
882     } 
883 
884     event WithdrawEther(address indexed _addr, uint256 _value, uint256 indexed _when);
885 
886     /**
887      * @dev transfer this contract ether balance to owner's account 
888      *    ( public function )
889      * @param _withdraw_wei_value   amount to widthdraw ( in wei unit)
890      */
891     function z_admin_withdraw_ether(uint256 _withdraw_wei_value) onlyAdmin public {
892     	address ScAddress = this;
893     	if(_withdraw_wei_value > ScAddress.balance) revert();
894     	//if(owner.call.value(_withdraw_wei_value).gas(5000)()==false) revert();
895     	if(owner.send(_withdraw_wei_value)==false) revert();
896         totalEtherWithdrawed += _withdraw_wei_value;
897         emit WithdrawEther(owner,_withdraw_wei_value,block.timestamp); 
898     } 
899 
900 
901 
902 
903     /**
904      * @dev return  list of active holders accounts and their balances 
905      *     ( public view function )
906      * @param _max_num_of_items_to_display   Max Number of latest accounts items to display ( 0 means 1 )
907      * @return  _num_of_active_holders   number of latest holders accounts
908      * @return  _active_holders   array of active( balance > 0) holders
909      * @return  _token_balances   array of token balances 
910      */
911     function list_active_holders_and_balances(uint _max_num_of_items_to_display) public view 
912       returns (uint _num_of_active_holders,address[] _active_holders,uint[] _token_balances){
913       uint len = holders.length;
914       _num_of_active_holders = 0;
915       if(_max_num_of_items_to_display==0) _max_num_of_items_to_display=1;
916       for (uint i = len-1 ; i >= 0 ; i--) {
917          if( balances[ holders[i] ] != 0x0) _num_of_active_holders++;
918          if(_max_num_of_items_to_display == _num_of_active_holders) break;
919       }
920       _active_holders = new address[](_num_of_active_holders);
921       _token_balances = new uint[](_num_of_active_holders);
922       uint num=0;
923       for (uint j = len-1 ; j >= 0 && _num_of_active_holders > num ; j--) {
924          address addr = holders[j];
925          if( balances[ addr ] == 0x0) continue; // assure balance > 0
926          _active_holders[num] = addr;
927          _token_balances[num] = balances[addr];
928          num++;
929       }
930     }
931 
932     /**
933      * @dev return  list of recent stage0 token sale history
934      *      ( public view function )
935      * @param _max_num_of_items_to_display   Max Number of latest history items to display ( 0 means 1 )
936      * @return  _num   number of latest token sale history items
937      * @return  _sale_holders   array of holders
938      * @return  _ethers   array of ethers paid
939      * @return  _tokens   array of tokens bought
940      * @return  _whens   array of sale times
941      */
942     function list_history_of_stage0_sale(uint _max_num_of_items_to_display) public view 
943       returns (uint _num,address[] _sale_holders,uint[] _ethers,uint[] _tokens,uint[] _whens){
944       uint len = history_token_sale_stage0.length;
945       uint n= len; 
946       if(_max_num_of_items_to_display == 0) _max_num_of_items_to_display= 1;
947       if(_max_num_of_items_to_display <  n) n= _max_num_of_items_to_display;
948       _sale_holders = new address[](n);
949       _ethers = new uint[](n);
950       _tokens = new uint[](n);
951       _whens = new uint[](n);
952       _num=0;
953       for (uint j = len-1 ; j >= 0 && n > _num ; j--) {
954          history_token_sale_obj storage obj= history_token_sale_stage0[j];
955          _sale_holders[_num]= obj._buyer;
956          _ethers[_num]=  obj._ether_value;
957          _tokens[_num]=  obj._token_value;
958          _whens[_num]=   obj._when;
959          _num++;
960       }
961     }
962 
963 
964     /**
965      * @dev return  list of recent stage1 token sale history 
966      *     ( public view function )
967      * @param _max_num_of_items_to_display   Max Number of latest history items to display ( 0 means 1 )
968      * @return  _num   number of latest token sale history items
969      * @return  _sale_holders   array of holders
970      * @return  _ethers   array of ethers paid
971      * @return  _tokens   array of tokens bought
972      * @return  _whens   array of sale times
973      */
974     function list_history_of_stage1_sale(uint _max_num_of_items_to_display) public view 
975       returns (uint _num,address[] _sale_holders,uint[] _ethers,uint[] _tokens,uint[] _whens){
976       uint len = history_token_sale_stage1.length;
977       uint n= len; 
978       if(_max_num_of_items_to_display == 0) _max_num_of_items_to_display= 1;
979       if(_max_num_of_items_to_display <  n) n= _max_num_of_items_to_display;
980       _sale_holders = new address[](n);
981       _ethers = new uint[](n);
982       _tokens = new uint[](n);
983       _whens = new uint[](n);
984       _num=0;
985       for (uint j = len-1 ; j >= 0 && n > _num ; j--) {
986          history_token_sale_obj storage obj= history_token_sale_stage1[j];
987          _sale_holders[_num]= obj._buyer;
988          _ethers[_num]=  obj._ether_value;
989          _tokens[_num]=  obj._token_value;
990          _whens[_num]=   obj._when;
991          _num++;
992       }
993     }
994 
995 
996     /**
997      * @dev return  list of recent stage2 token sale history 
998      *     ( public view function )
999      * @param _max_num_of_items_to_display   Max Number of latest history items to display ( 0 means 1 )
1000      * @return  _num   number of latest token sale history items
1001      * @return  _sale_holders   array of holders
1002      * @return  _ethers   array of ethers paid
1003      * @return  _tokens   array of tokens bought
1004      * @return  _whens   array of sale times
1005      */
1006     function list_history_of_stage2_sale(uint _max_num_of_items_to_display) public view 
1007       returns (uint _num,address[] _sale_holders,uint[] _ethers,uint[] _tokens,uint[] _whens){
1008       uint len = history_token_sale_stage2.length;
1009       uint n= len; 
1010       if(_max_num_of_items_to_display == 0) _max_num_of_items_to_display= 1;
1011       if(_max_num_of_items_to_display <  n) n= _max_num_of_items_to_display;
1012       _sale_holders = new address[](n);
1013       _ethers = new uint[](n);
1014       _tokens = new uint[](n);
1015       _whens = new uint[](n);
1016       _num=0;
1017       for (uint j = len-1 ; j >= 0 && n > _num ; j--) {
1018          history_token_sale_obj storage obj= history_token_sale_stage2[j];
1019          _sale_holders[_num]= obj._buyer;
1020          _ethers[_num]=  obj._ether_value;
1021          _tokens[_num]=  obj._token_value;
1022          _whens[_num]=   obj._when;
1023          _num++;
1024       }
1025     }
1026 
1027 
1028     /**
1029      * @dev return  list of recent stage3 token sale history 
1030      *     ( public view function )
1031      * @param _max_num_of_items_to_display   Max Number of latest history items to display ( 0 means 1 )
1032      * @return  _num   number of latest token sale history items
1033      * @return  _sale_holders   array of holders
1034      * @return  _ethers   array of ethers paid
1035      * @return  _tokens   array of tokens bought
1036      * @return  _whens   array of sale times
1037      */
1038     function list_history_of_stage3_sale(uint _max_num_of_items_to_display) public view 
1039       returns (uint _num,address[] _sale_holders,uint[] _ethers,uint[] _tokens,uint[] _whens){
1040       uint len = history_token_sale_stage3.length;
1041       uint n= len; 
1042       if(_max_num_of_items_to_display == 0) _max_num_of_items_to_display= 1;
1043       if(_max_num_of_items_to_display <  n) n= _max_num_of_items_to_display;
1044       _sale_holders = new address[](n);
1045       _ethers = new uint[](n);
1046       _tokens = new uint[](n);
1047       _whens = new uint[](n);
1048       _num=0;
1049       for (uint j = len-1 ; j >= 0 && n > _num ; j--) {
1050          history_token_sale_obj storage obj= history_token_sale_stage3[j];
1051          _sale_holders[_num]= obj._buyer;
1052          _ethers[_num]=  obj._ether_value;
1053          _tokens[_num]=  obj._token_value;
1054          _whens[_num]=   obj._when;
1055          _num++;
1056       }
1057     }
1058 
1059 
1060     /**
1061      * @dev return  list of recent stage4 token sale history
1062      *      ( public view function )
1063      * @param _max_num_of_items_to_display   Max Number of latest history items to display ( 0 means 1 )
1064      * @return  _num   number of latest token sale history items
1065      * @return  _sale_holders   array of holders
1066      * @return  _ethers   array of ethers paid
1067      * @return  _tokens   array of tokens bought
1068      * @return  _whens   array of sale times
1069      */
1070     function list_history_of_stage4_sale(uint _max_num_of_items_to_display) public view 
1071       returns (uint _num,address[] _sale_holders,uint[] _ethers,uint[] _tokens,uint[] _whens){
1072       uint len = history_token_sale_stage4.length;
1073       uint n= len; 
1074       if(_max_num_of_items_to_display == 0) _max_num_of_items_to_display= 1;
1075       if(_max_num_of_items_to_display <  n) n= _max_num_of_items_to_display;
1076       _sale_holders = new address[](n);
1077       _ethers = new uint[](n);
1078       _tokens = new uint[](n);
1079       _whens = new uint[](n);
1080       _num=0;
1081       for (uint j = len-1 ; j >= 0 && n > _num ; j--) {
1082          history_token_sale_obj storage obj= history_token_sale_stage4[j];
1083          _sale_holders[_num]= obj._buyer;
1084          _ethers[_num]=  obj._ether_value;
1085          _tokens[_num]=  obj._token_value;
1086          _whens[_num]=   obj._when;
1087          _num++;
1088       }
1089     }
1090 
1091 
1092     /**
1093      * @dev return  list of latest #N transfer history
1094      *      ( public view function )
1095      * @param _max_num_of_items_to_display   Max Number of latest history items to display ( 0 means 1 )
1096      * @return  _num   number of latest transfer history items
1097      * @return  _senders   array of senders
1098      * @return  _receivers   array of receivers
1099      * @return  _tokens   array of tokens transferred
1100      * @return  _whens   array of transfer times
1101      */
1102     function list_history_of_token_transfer(uint _max_num_of_items_to_display) public view 
1103       returns (uint _num,address[] _senders,address[] _receivers,uint[] _tokens,uint[] _whens){
1104       uint len = history_token_transfer.length;
1105       uint n= len;
1106       if(_max_num_of_items_to_display == 0) _max_num_of_items_to_display= 1;
1107       if(_max_num_of_items_to_display <  n) n= _max_num_of_items_to_display;
1108       _senders = new address[](n);
1109       _receivers = new address[](n);
1110       _tokens = new uint[](n);
1111       _whens = new uint[](n);
1112       _num=0;
1113       for (uint j = len-1 ; j >= 0 && n > _num ; j--) {
1114          history_token_transfer_obj storage obj= history_token_transfer[j];
1115          _senders[_num]= obj._from;
1116          _receivers[_num]= obj._to;
1117          _tokens[_num]=  obj._token_value;
1118          _whens[_num]=   obj._when;
1119          _num++;
1120       }
1121     }
1122 
1123     /**
1124      * @dev return  list of latest address-filtered #N transfer history 
1125      *     ( public view function )
1126      * @param _addr   address as filter for transfer history (default 0x0)
1127      * @return  _num   number of latest transfer history items
1128      * @return  _senders   array of senders
1129      * @return  _receivers   array of receivers
1130      * @return  _tokens   array of tokens transferred
1131      * @return  _whens   array of transfer times
1132      */
1133     function list_history_of_token_transfer_filtered_by_addr(address _addr) public view 
1134       returns (uint _num,address[] _senders,address[] _receivers,uint[] _tokens,uint[] _whens){
1135       uint len = history_token_transfer.length;
1136       uint _max_num_of_items_to_display= 0;
1137       history_token_transfer_obj storage obj= history_token_transfer[0];
1138       uint j;
1139       for (j = len-1 ; j >= 0 ; j--) {
1140          obj= history_token_transfer[j];
1141          if(obj._from== _addr || obj._to== _addr) _max_num_of_items_to_display++;
1142       }
1143       if(_max_num_of_items_to_display == 0) _max_num_of_items_to_display= 1;
1144       _senders = new address[](_max_num_of_items_to_display);
1145       _receivers = new address[](_max_num_of_items_to_display);
1146       _tokens = new uint[](_max_num_of_items_to_display);
1147       _whens = new uint[](_max_num_of_items_to_display);
1148       _num=0;
1149       for (j = len-1 ; j >= 0 && _max_num_of_items_to_display > _num ; j--) {
1150          obj= history_token_transfer[j];
1151          if(obj._from!= _addr && obj._to!= _addr) continue;
1152          _senders[_num]= obj._from;
1153          _receivers[_num]= obj._to;
1154          _tokens[_num]=  obj._token_value;
1155          _whens[_num]=   obj._when;
1156          _num++;
1157       }
1158     }
1159 
1160     /**
1161      * @dev return frozen accounts and their balances 
1162      *     ( public view function )
1163      * @param _max_num_of_items_to_display   Max Number of items to display ( 0 means 1 )
1164      * @return  _num   number of currently frozen accounts
1165      * @return  _frozen_holders   array of frozen accounts
1166      * @return  _whens   array of frozen times
1167      */
1168     function list_frozen_accounts(uint _max_num_of_items_to_display) public view
1169       returns (uint _num,address[] _frozen_holders,uint[] _whens){
1170       uint len = holders_frozen.length;
1171       uint num_of_frozen_holders = 0;
1172       if(_max_num_of_items_to_display==0) _max_num_of_items_to_display=1;
1173       for (uint i = len-1 ; i >= 0 ; i--) {
1174          // assure currently in frozen state
1175          if( account_frozen_time[ holders_frozen[i] ] > 0x0) num_of_frozen_holders++;
1176          if(_max_num_of_items_to_display == num_of_frozen_holders) break;
1177       }
1178       _frozen_holders = new address[](num_of_frozen_holders);
1179       _whens = new uint[](num_of_frozen_holders);
1180       _num=0;
1181       for (uint j = len-1 ; j >= 0 && num_of_frozen_holders > _num ; j--) {
1182          address addr= holders_frozen[j];
1183          uint256 when= account_frozen_time[ addr ];
1184          if( when == 0x0) continue; // assure if frozen true
1185          _frozen_holders[_num]= addr;
1186          _whens[_num]= when;
1187          _num++;
1188       }
1189     }
1190 
1191     /**
1192      * @dev Token sale sumilation for current sale stage 
1193      *     ( public view function )
1194      * @param _ether_or_wei_value  input ethereum value (in wei or ether unit)
1195      * @return _num_of_tokens  number of tokens that can be bought with the input value
1196      * @return _exch_rate  current sale stage exchange rate (wei per now)
1197      * @return _current_sale_stage_index  current sale stage index
1198      */
1199     function simulate_token_sale(uint _ether_or_wei_value) public view 
1200 	returns (uint256 _num_of_tokens, uint256 _exch_rate, uint256 _current_sale_stage_index) {
1201 	if(sale_stage_index >=5 ) return (0,0,0);
1202 	_exch_rate= sale_price_per_stage_wei_per_now[sale_stage_index];
1203         _current_sale_stage_index= sale_stage_index;
1204         // determine whether the input value is in ether unit or in wei unit
1205 	if(_ether_or_wei_value>=1000000) 
1206 	   _num_of_tokens= uint256( _ether_or_wei_value /  _exch_rate ); // guess it is in wei
1207         else
1208 	   _num_of_tokens= uint256( _ether_or_wei_value * WEI_PER_ETHER / _exch_rate ); // guess it is in ether
1209     }
1210 
1211 
1212     /**
1213      * @dev Admin menu: Token Sale Status management
1214      *      (run by admin, public function)
1215      * @param _next_status  next status index (1 ~ 13). refer to enum Sale_Status 
1216      */
1217     function z_admin_next_status(Sale_Status _next_status) onlyAdmin public {
1218       if(_next_status== Sale_Status.Stage0_Sale_Started_STATUS) { start_StageN_Sale(0); return;} // 1
1219       if(_next_status== Sale_Status.Stage0_Sale_Stopped_STATUS) { stop_StageN_Sale(0); return;} // 2
1220       if(_next_status== Sale_Status.Stage1_Sale_Started_STATUS) { start_StageN_Sale(1); return;} // 3
1221       if(_next_status== Sale_Status.Stage1_Sale_Stopped_STATUS) { stop_StageN_Sale(1); return;} // 4
1222       if(_next_status== Sale_Status.Stage2_Sale_Started_STATUS) { start_StageN_Sale(2); return;} // 5
1223       if(_next_status== Sale_Status.Stage2_Sale_Stopped_STATUS) { stop_StageN_Sale(2); return;} // 6
1224       if(_next_status== Sale_Status.Stage3_Sale_Started_STATUS) { start_StageN_Sale(3); return;} // 7
1225       if(_next_status== Sale_Status.Stage3_Sale_Stopped_STATUS) { stop_StageN_Sale(3); return;} // 8
1226       if(_next_status== Sale_Status.Stage4_Sale_Started_STATUS) { start_StageN_Sale(4); return;} // 9
1227       if(_next_status== Sale_Status.Stage4_Sale_Stopped_STATUS) { stop_StageN_Sale(4); return;} // 10
1228       if(_next_status== Sale_Status.Public_Allowed_To_Trade_STATUS) { start_Public_Trade(); return;} //11
1229       if(_next_status== Sale_Status.Stage0_Allowed_To_Trade_STATUS) { start_Stage0_Trade(); return;} //12
1230       if(_next_status== Sale_Status.Closed_STATUS) { closeContract(); return;} //13
1231       revert();
1232     } 
1233 
1234 }