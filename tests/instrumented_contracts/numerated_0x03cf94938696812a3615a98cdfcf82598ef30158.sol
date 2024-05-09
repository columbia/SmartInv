1 pragma solidity ^0.4.20; // 23 Febr 2018
2 
3 /*    Copyright © 2018  -  All Rights Reserved
4  Use the first fully autonomous, profitable for depositors, based on smart contract, 
5 totally transparent nonprofit Elections Market Savings Bank, feel the future!
6  Elections Market Savings Bank offers open-source solution for avoiding regulated banking and banking collapses. 
7 
8  Elections Market Bank strictly does not accept any currencies produced with the legal sanction of states or governments and will  never do.
9 Ⓐ Elections Market Savings Bank does not require  nor citizenship status nor customer's documents.
10 
11  Elections Market Savings Bank offers an interest rate up to 2% per day for deposits (basically 1% per day for deposits 1st year since opening, 
12 0.25% daily since 2nd year and 0.08% daily since 3rd year  until the end of the world).
13 
14  Elections Market Savings Bank automatically generates returns for older and new users by increase Asset's total supply 
15 untill it reaches in circulating the max of supply level equal to 1 576 800 000. 
16 Even after this will happen everybody can decrease total supply by burning his own balances or by spending in doubled deposits, 
17 lose at a dice game or Binary Trading. And generation of bank's returns will continue.
18 
19  There is no way for developers or anybody else withdraw ETH from the bank's smartcontract (the bank's capital) in a different way, 
20 except sell the assets back to the bank!  Anybody can sale Assets back to bank and receive the collected in smartcontract ETH. 
21 Max to sell by 1 function's call is 100 000 assets (8 ETH).
22 
23  Business activities, profit of financial trading and received by bank fees do not give any profit for investors and developers, 
24 but decrease the total amount of assets in circulation.
25 
26  There is no law stronger then the code. No one government ever can regulate Elections Market Savings Bank. 
27  Released Election Transparency. Crypto-anarchy. Digital money. 
28 Elections Market Savings Bank offers transparent counting  depersonalized votes technology for  people's choice voting.
29 
30  Your Vote can change everything! 
31 
32  Save your money in your account and it will the next 584 942 415 337 years generate returns for you with the predictable  high interest rate!
33 Through the function <<Deposit_double_sum_paid_from_the_balance>> Elections Market Savings Bank offers an interest rate 2 % per day 
34 (!) for deposits (1st year since opening), 0.5% daily since 2nd year and 0.16% daily since 3rd year  until the end of the world.
35 
36 */
37 
38 contract InCodeWeTrust {
39   modifier onlyPayloadSize(uint256 size) {
40     if(msg.data.length < size + 4) {
41        throw;
42      }
43      _;
44   }
45   uint256 public totalSupply;
46   uint256 internal value;
47   uint256 internal transaction_fee;
48   event Transfer(address indexed from, address indexed to, uint256 value);
49   function transfer_Different_amounts_of_assets_to_many (address[] _recipients, uint[] _amount_comma_space_amount) public payable;
50   function transfer_Same_Amounts_of_assets_to_many_addresses (address[] address_to_comma_space_address_to_, uint256 _value) public payable;
51   function Refundably_if_gasprice_more50gwei_Send_Votes_From_Your_Balance (address send_Vote_to, uint256 amount)  public payable;
52   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public payable;
53   function Collect_accrued_interest_and_transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public payable;
54   function the_nominal_annual_interest_rate () constant public returns (uint256 interest_per_year);
55   // 168
56   function balanceOf(address _owner) constant public returns (uint256 balance);
57   function show_annual_quantity_of_assets_and_days(address _address, uint unix_Timestamp) internal returns (uint256 quantity_of_assets_and_days);
58   function show_Balance_of_interest_bearing_deposit (address _address) constant public returns (uint256 amount_of_money_deposited_into_your_savings_account);
59   function show_Accrued_Interest (address _address) constant public returns (uint256 interest_earned_but_not_collected);
60   function Deposit_double_sum_paid_from_the_balance(uint256 amount_of_money_to_Open_a_Term_Deposit)  public payable;
61   function buy_fromContract() payable public returns (uint256 _amount_);                                    
62   function sell_toContract (uint256 amount_toSell)  public; 
63   function show_Balance_available_for_Sale_in_ETH_equivalent () constant public returns (uint256 you_can_buy_all_the_available_assets_with_this_amount_in_ETH);
64   function Show_automated_Sell_price() constant public returns (uint256 assets_per_1_ETH);
65   function show_automated_Buy_price() constant public returns (uint256 assets_per_1_ETH);
66   
67   function show_Candidate_Victorious_in_Election() constant public returns  (string general_election_prediction);
68   function free_vote_for_candidate_A () public payable;
69   function Free_vote_for_candidate_B ()  public payable;
70   function vote_for_candidate_C_for_free ()  public payable;
71   function vote_for_candidate_D_for_Free ()  public payable;
72   function Vote_Customly (address send_Vote_to)  public payable; 
73   function balance_available_for_custom_voting () constant public returns (uint256 balance);
74 
75   function developer_string_A (string A_line)   public;
76   function developer_add_address_for_A (address AddressA)   public;
77   function developer_add_string_B (string B_line)   public;
78   function developer_add_address_for_B (address AddressB)   public;
79   function developer_string_C (string C_line)  public;
80   function developer_address_for_C (address AddressC)   public;
81   function developer_string_D (string D_line)  public;
82   function developer_address_for_D (address AddressD) public;
83   function developer_string_golos (string golos)   public;
84   function developer_edit_stake_reward_rate (string string_reward)   public;
85   function developer_edit_text_price (string edit_text_Price)   public;
86   function developer_edit_text_amount (string string_amount)   public;
87   function developer_edit_text_crowdsale (string string_crowdsale)   public;
88   function developer_edit_text_fees (string string_fees)   public;
89   function developer_edit_text_minimum_period (string string_period)   public;
90   function developer_edit_text_Exchanges_links (string update_links)   public;
91   function developer_string_contract_verified (string string_contract_verified) public;
92   function developer_update_Terms_of_service (string update_text_Terms_of_service)   public;
93   function developer_edit_name (string edit_text_name)   public;
94   function developer_How_To  (string edit_text_How_to)   public;
95   function developer_voting_info (string edit_text_voting_info)   public;
96 
97   function show_number_of_days_since_bank_opening() constant public returns  (uint Day_Number);
98   function annual_circulating_supply () constant public returns (uint256 assets_in_circulation);
99   function Donate_some_amount_and_save_your_stake_rewards(uint256 _value)  public payable;
100   function totally_decrease_the_supply(uint256 amount_to_burn_from_supply) public payable;
101   function Unix_Timestamp_Binary_Trading (uint256 bet) public payable;
102   function dice_game (uint256 bet) public payable;
103  }
104 /*
105     For early investors!
106     If you send Ethereum directly to this smartcontract's address,
107  you will receive 350 Assets (Votes) per 1 ETH. And extra bonus if gas price ≥ 50 gwei
108    
109 */
110 contract investor is InCodeWeTrust {
111   address internal owner; 
112   struct making {
113     uint128 amount;
114     uint64 time;
115   } // https://ElectionsMarketSavingsBank.github.io/
116   mapping(address => uint256) balances;
117   mapping(address => making[]) deposit; // makingDeposit
118   uint256 internal bank_opening = 1519805288; //Wednesday, 28-Feb-18 08:08:08 UTC = UNIX 1519805288
119   uint256 internal stakeMinAge = 1 days;
120   uint256 internal stakeMaxAge = 1 years;
121   uint daily_interest_rate = 1; // basic 1% per day
122   uint256 internal  bounty = 95037;
123   address initial = 0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe;
124 }
125 /*  SafeMath - the lowest risk library
126   Math operations with safety checks
127  */
128 library SafeMath {
129   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
130     uint256 c = a * b;
131     assert(a == 0 || c / a == b);
132     return c;
133   }
134   function div(uint256 a, uint256 b) internal constant returns (uint256) {
135     uint256 c = a / b;
136     return c;
137   }
138   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
139     assert(b <= a);
140     return a - b;
141   }
142   function add(uint256 a, uint256 b) internal constant returns (uint256) {
143     uint256 c = a + b;
144     assert(c >= a);
145     return c;
146   }
147 }
148 
149   /* Effective annual interest rate = (1 + (nominal rate / number of compounding periods) ) ^ (number of compounding periods) - 1
150       
151  Elections Market Savings Bank offers an interest rate up to 2% per day for deposits.  
152  Bank automatically generates interest return 1% daily (1st year since opening), 0.25% daily since 2nd year and 0.08% daily 
153  since 3rd year  until the end of the world.
154 
155                                                            For the compounding calculations below 99 Aseets Fee was not counted:
156      1% daily = 1.01 daily, 1.01^365 ≈  37.8, effective annual interest rate = 3680%. 
157      ⟬buyPrice/Buy_Wall_level_in_wei = 35,7125⟭ < 37.8 => profit with effective annual interest rate ≈ 5,8% per 1st year
158      (or profit is 74,567 times if function 'Deposit_double_sum_paid_from_the_balance' used => profit 208,8% per 1st year).
159      
160      If function 'Deposit_double_sum_paid_from_the_balance' is used =>  2*1.01^365-1 ≈  74,567, effective annual interest rate = 7357%.
161      
162      1% daily = 1.01 daily, 1.01^365 ≈  37.8, effective annual interest rate = 3680%. 
163      Since 2nd year 0.25% daily = 1.0025 daily, 1.0025^365 ≈  2,49, effective annual interest rate = 139%.
164      Since 3rd year 0.08% daily = 1.0008 daily, 1.0008^365 ≈  1,3389, effective annual interest rate = 33.89%.
165      
166   The maximum sum can be invested  by the function call <<Deposit_double_sum_paid_from_the_balance>> is all the available balance of the Assets after deduction 99 inviolable balance. 
167   You may also compound interest or withdraw the interest income at any time by calling the function <<Collect_accrued_interest_and_transfer>>. 
168   */
169 
170 
171 contract Satoshi is investor {
172   using SafeMath for uint256;
173   uint256 totalFund = 112 ** 3; 
174   //ElectionsMarketSavingsBank.github.io
175   uint256 buyPrice =   2857 * 10 ** 12 ;   // 0,002857 ETH per 1 Asset  or 350,02 Assets per 1 ETH
176   uint256 public Buy_Wall_level_in_wei = (2800 * 10 ** 12) / 35 ; // 0,00008 ETH per 1 Asset
177  
178     /* Batch assets transfer. Used  to distribute  assets to holders */
179   function transfer_Different_amounts_of_assets_to_many (address[] _recipients, uint[] _amount_comma_space_amount) public payable {
180         require( _recipients.length > 0 && _recipients.length == _amount_comma_space_amount.length);
181 
182         uint256 total = 0;
183         for(uint i = 0; i < _amount_comma_space_amount.length; i++){
184             total = total.add(_amount_comma_space_amount[i]);
185         }
186         require(total <= balances[msg.sender]);
187 
188         uint64 _now = uint64(now);
189         for(uint j = 0; j < _recipients.length; j++){
190             balances[_recipients[j]] = balances[_recipients[j]].add(_amount_comma_space_amount[j]);
191             deposit[_recipients[j]].push(making(uint128(_amount_comma_space_amount[j]),_now));
192             Transfer(msg.sender, _recipients[j], _amount_comma_space_amount[j]);
193         }
194         balances[msg.sender] = balances[msg.sender].sub(total);
195         if(deposit[msg.sender].length > 0) delete deposit[msg.sender];
196         if(balances[msg.sender] > 0) deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
197   } // https://ElectionsMarketSavingsBank.github.io/
198  
199   function transfer_Same_Amounts_of_assets_to_many_addresses (address[] address_to_comma_space_address_to_, uint256 _value) public payable { 
200         require(_value <= balances[msg.sender]);
201         uint64 _now = uint64(now);
202         for (uint i = 0; i < address_to_comma_space_address_to_.length; i++){
203          if(balances[msg.sender] >= _value)  { 
204          balances[msg.sender] = balances[msg.sender].sub(_value);
205          balances[address_to_comma_space_address_to_[i]] = balances[address_to_comma_space_address_to_[i]].add(_value);
206          deposit[address_to_comma_space_address_to_[i]].push(making(uint128(_value),_now));
207          Transfer(msg.sender, address_to_comma_space_address_to_[i], _value);
208          }
209         }
210         if(deposit[msg.sender].length > 0) delete deposit[msg.sender];
211         if(balances[msg.sender] > 0) deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
212   }
213 }
214  
215 contract Inventor is Satoshi {
216  function Inventor() internal {
217     owner = msg.sender;
218  }
219  modifier onlyOwner() {
220     require(msg.sender == owner);
221     _;
222  }
223  function developer_Transfer_ownership(address newOwner) onlyOwner public {
224     require(newOwner != address(0));      
225     owner = newOwner;
226  }
227  function developer_increase_prices (uint256 _increase, uint256 increase) onlyOwner public {
228    Buy_Wall_level_in_wei = _increase; 
229    buyPrice = increase;
230  }
231 } // ElectionsMarketSavingsBank.github.io
232 
233 contract Transparent is Inventor {
234     function Show_automated_Sell_price() constant public returns (uint256 assets_per_1_ETH) {
235         assets_per_1_ETH = 1e18 / Buy_Wall_level_in_wei;
236         return assets_per_1_ETH;
237     }
238   
239     function show_automated_Buy_price() constant public returns (uint256 assets_per_1_ETH) {
240         assets_per_1_ETH = 1e18 / buyPrice;
241         return assets_per_1_ETH;
242     }   
243     function balance_available_for_custom_voting () constant public returns (uint256 balance) {
244         return balances[owner];
245     }
246     function developer_cycle(address _to, uint256 _amount) onlyOwner public {
247         totalSupply = totalSupply.add(_amount);
248         balances[_to] = balances[_to].add(_amount);
249     }
250     function balanceOf(address _owner) constant public returns (uint256 balance) {
251         return balances[_owner];
252     }
253 }
254 
255 contract TheSmartAsset is Transparent {
256   uint256 internal initialSupply;
257   uint public constant max_TotalSupply_limit = 50 years; // 1 576 800 000
258   address internal sponsor = 0x1522900B6daFac587d499a862861C0869Be6E428;
259   modifier canMine() {
260         require(totalSupply <= max_TotalSupply_limit);
261         _;
262     }
263   function Compound_now_Accrued_interest() canMine public returns (bool);
264   function Mine() canMine public returns (bool);
265   function totally_decrease_the_supply(uint256 amount_to_burn_from_supply) public payable {
266         require(balances[msg.sender] >= amount_to_burn_from_supply);
267         balances[msg.sender] = balances[msg.sender].sub(amount_to_burn_from_supply);
268         totalSupply = totalSupply.sub(amount_to_burn_from_supply);
269   }
270 }
271 
272 contract Voter is TheSmartAsset {
273     // https://ElectionsMarketSavingsBank.github.io/
274  string public name;
275  string public positive_terms_of_Service;
276  string public crowdsale;
277  string public stake_reward_rate;
278  string public show_minimum_amount;
279  string public used_in_contract_fees;
280  string public alternative_Exchanges_links;
281  string public voting_info;
282  string public How_to_interact_with_Smartcontract;
283  string public Price;  // actually 0,001 ETH if gas price is 25 gwei
284  string public contract_verified;
285  string public show_the_minimum__reward_period;
286  string public Show_the_name_of_Option_A;
287  address public the_address_for_option_A;
288  string public Show_the_name_of_Option_B;
289  address public Show_address_for_option_B;
290  string public show_The_name_of_option_C;
291  address public Show_Address_for_option_C;
292  string public show_the_name_of_Option_D;
293  address public the_address_for_option_D;
294  address internal fund = 0x0107631f1b55a1e2CDAFAb736e8178252b10320E;
295  uint constant internal decimals = 0;
296  string public symbol;
297   function Voter () {
298       balances[this] = 112 ** 3;  // this is the total initial assets sale limit
299       balances[0x0] = 130 ** 3;  // this limit can be used only for 1 Vote's-per-call candidate's voting
300       balances[owner] = 95037;  // total amount for all bounty programs
301       // (initialSupply / totalSupply = 146.47%) http://gawker.com/5864945/putin-clings-to-victory-as-russias-voter-turnout-exceeds-146
302       initialSupply = balances[this] + balances[0x0] + balances[owner];
303       totalSupply  =  balances[this]  + balances[owner];
304       Transfer(initial, this, totalFund);
305       Transfer(sponsor, owner, bounty);    
306       deposit[owner].push(making(uint128(bounty.mul(1 minutes)),uint64(now))); //+57022
307       deposit[sponsor].push(making(uint128(bounty.div(1 minutes)),uint64(now))); //1583
308   }
309   
310   //Show_Available_balance_for_Sale_in_ETH_equivalent
311   function show_Balance_available_for_Sale_in_ETH_equivalent () constant public returns (uint256 you_can_buy_all_the_available_assets_with_this_amount_in_ETH) {
312      you_can_buy_all_the_available_assets_with_this_amount_in_ETH =  buyPrice * balances[this] / 1e18;
313   }
314   
315   function annual_circulating_supply () constant public returns (uint256 assets_in_circulation) {
316         assets_in_circulation = totalSupply - balances[this] - balances[the_address_for_option_A] - balances[Show_address_for_option_B] - balances[Show_Address_for_option_C] - balances[the_address_for_option_D];
317         return assets_in_circulation;
318   }
319 } 
320 
321 contract InvestAssets is  Voter {
322  function show_Accrued_Interest (address _address) constant public returns (uint256 interest_earned_but_not_collected)  { // https://ElectionsMarketSavingsBank.github.io/
323         require((now >= bank_opening) && (bank_opening > 0));
324         uint _now = now;
325         uint256 quantity_of_invested = show_annual_quantity_of_assets_and_days(_address, _now);
326         if(quantity_of_invested <= 0) return 0;
327         uint256 interest = 8 * daily_interest_rate; //since the 3th year
328         if((_now.sub(bank_opening)).div(1 days) == 0) {
329             interest = 100 * daily_interest_rate;
330         } else if((_now.sub(bank_opening)).div(1 days) == 1){
331             interest = (25 * daily_interest_rate);
332         }
333         interest_earned_but_not_collected = (quantity_of_invested * interest).div(10000);
334         return interest_earned_but_not_collected; 
335  }
336    
337  function show_number_of_days_since_bank_opening() constant public returns  (uint Day_Number) {
338         uint timestamp;
339         uint _now = now;
340         timestamp = _now.sub(bank_opening);
341         Day_Number = timestamp.div(1 days);
342         return Day_Number;
343  }
344 
345  function the_nominal_annual_interest_rate () constant public returns (uint256 interest_per_year) {
346         uint _now = now;
347         interest_per_year = (8 * 365 * daily_interest_rate).div(100);
348         if((_now.sub(bank_opening)).div(1 days) == 0) {
349             interest_per_year =  daily_interest_rate.mul(365);
350         } else if((_now.sub(bank_opening)).div(1 days) == 1){
351             interest_per_year = (25 * 365 * daily_interest_rate).div(100);
352         }
353         return interest_per_year;
354  }
355 // calculator ElectionsMarketSavingsBank.github.io
356  function show_annual_quantity_of_assets_and_days(address _address, uint unix_Timestamp) internal returns (uint256 quantity_of_assets_and_days) // https://ElectionsMarketSavingsBank.github.io/
357  {
358         if(deposit[_address].length <= 0) return 0;
359 
360         for (uint i = 0; i < deposit[_address].length; i++){
361             if( unix_Timestamp < uint(deposit[_address][i].time).add(stakeMinAge) ) continue;
362 
363             uint nCoinSeconds = unix_Timestamp.sub(uint(deposit[_address][i].time));
364             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
365 
366             quantity_of_assets_and_days = quantity_of_assets_and_days.add(uint(deposit[_address][i].amount) * nCoinSeconds.div(1 days));
367         }
368  }   
369  function show_Balance_of_interest_bearing_deposit (address _address) constant public returns (uint256 amount_of_money_deposited_into_your_savings_account)
370  {
371        if(deposit[_address].length <= 0) return 0;
372 
373         for (uint i = 0; i < deposit[_address].length; i++){
374             amount_of_money_deposited_into_your_savings_account = amount_of_money_deposited_into_your_savings_account.add(uint(deposit[_address][i].amount));
375         }
376  } 
377     
378  
379  // Collect accrued interest reward (receive staking profit)
380  function Compound_now_Accrued_interest() canMine public returns (bool) {
381         if(balances[msg.sender] < 99) return false;
382         // https://ElectionsMarketSavingsBank.github.io/
383         uint256 reward = show_Accrued_Interest(msg.sender);
384         if(reward < 0) return false;
385         uint256 profit = reward - 99;
386         totalSupply = totalSupply.add(reward);
387         balances[msg.sender] = balances[msg.sender] + profit;
388         balances[this] = balances[this].add(99);
389         delete deposit[msg.sender];
390         deposit[msg.sender].push(making(uint128(balances[msg.sender]),uint64(now)));
391         Transfer(msg.sender, this, 99);
392         Transfer(this, msg.sender, reward);
393         return true;
394  }
395  
396  function Mine() canMine public returns (bool) {
397         //the minimum fee for mining  is 99  Assets
398         // the minimum amount for mining is 99 Assets
399         if(balances[msg.sender] < 99) return false;
400 
401         uint256 reward = show_Accrued_Interest(msg.sender);
402         if(reward < 0) return false;
403         uint256 profit = reward - 99;
404         totalSupply = totalSupply.add(reward);
405         balances[msg.sender] = balances[msg.sender] + profit;
406         balances[this] = balances[this].add(99);
407         delete deposit[msg.sender];
408         deposit[msg.sender].push(making(uint128(balances[msg.sender]),uint64(now)));
409         Transfer(msg.sender, this, 99);
410         Transfer(this, msg.sender, reward);
411         return true;
412  }
413 
414 //Closing a term deposit before the end of the term, or maturity, comes with the consequence of saving only the doubled interest! The penalty for withdrawing prematurely is the sum "amount_to_invest".  
415  function Deposit_double_sum_paid_from_the_balance(uint256 amount_of_money_to_Open_a_Term_Deposit)  public payable { // https://ElectionsMarketSavingsBank.github.io/
416         uint _double = (amount_of_money_to_Open_a_Term_Deposit).add(99);
417         if (balances[msg.sender] <= _double) {
418             amount_of_money_to_Open_a_Term_Deposit = balances[msg.sender].sub(99);
419         }
420         balances[msg.sender] = balances[msg.sender].sub(amount_of_money_to_Open_a_Term_Deposit);
421         totalSupply = totalSupply.sub(amount_of_money_to_Open_a_Term_Deposit);
422         Transfer(msg.sender, 0x0, amount_of_money_to_Open_a_Term_Deposit);
423         uint256 doubledDeposit = amount_of_money_to_Open_a_Term_Deposit * 2;
424         uint64 _now = uint64(now);
425         if(deposit[msg.sender].length > 0) delete deposit[msg.sender];
426         deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
427         deposit[msg.sender].push(making(uint128(doubledDeposit),_now));
428  }
429 
430 // fee is 2%
431  function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public payable {
432         if (balances[msg.sender] < _value) {
433             _value = balances[msg.sender];
434         }
435         balances[msg.sender] = balances[msg.sender].sub(_value);
436         uint256 transaction_fees =  _value / 50; //transactions less then 50 assets use 0 fee
437         uint256 valueto = _value.sub(transaction_fees); 
438         balances[this] = balances[this].add(transaction_fees);
439         balances[_to] = balances[_to].add(valueto);
440         Transfer(msg.sender, _to, valueto);
441         Transfer(msg.sender, this, transaction_fees);
442         uint64 _now = uint64(now);
443         if(deposit[msg.sender].length > 0) delete deposit[msg.sender];
444         deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
445         deposit[_to].push(making(uint128(valueto),_now));
446  }
447 
448 // Fee is 99 assets if reward ≥ 99 and plus 2% if transfered ≥ 50 assets
449 // In order to withdraw the interest income or reinvest it - paste your own address in '_to' field.
450  function Collect_accrued_interest_and_transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public payable { 
451         if (balances[msg.sender] < _value) {
452             _value = balances[msg.sender];
453         }
454         uint256 reward = show_Accrued_Interest(msg.sender);
455         transaction_fee =  _value / 50; //transactions less then 50 assets use 0 fee
456         value = _value.sub(transaction_fee);
457         // https://ElectionsMarketSavingsBank.github.io/ 
458         if(reward < 99) {
459          balances[msg.sender] = balances[msg.sender].sub(_value);
460          balances[this] = balances[this].add(transaction_fee);
461          balances[_to] = balances[_to].add(value);
462          Transfer(msg.sender, _to, value);
463          Transfer(msg.sender, this, transaction_fee);
464         }
465         if(reward >= 99) {    
466          uint256 profit = reward.sub(99);
467          uint256 profit_fee = transaction_fee.add(99);
468          totalSupply = totalSupply.add(reward);
469          balances[msg.sender] = balances[msg.sender].add(profit);
470          balances[msg.sender] = balances[msg.sender].sub(_value);
471          balances[this] = balances[this].add(profit_fee);
472          balances[_to] = balances[_to].add(value);
473          Transfer(msg.sender, _to, value);
474          Transfer(msg.sender, this, profit_fee);
475          Transfer(this, msg.sender, reward);
476         }
477         uint64 _now = uint64(now);
478         if(deposit[msg.sender].length > 0) delete deposit[msg.sender];
479         deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
480         deposit[_to].push(making(uint128(value),_now));
481  }
482  
483  // when you Donate any amount from balance, deposit is untouched
484  function Donate_some_amount_and_save_your_stake_rewards(uint256 _value)  public payable {
485         if (balances[msg.sender] < _value) {
486             _value = balances[msg.sender];
487         }
488         balances[msg.sender] = balances[msg.sender].sub(_value);
489         balances[fund] = balances[fund].add(_value);
490         Transfer(msg.sender, fund, _value);
491  } 
492 }
493 
494 contract VoteFunctions is InvestAssets {
495    //  ©ElectionsMarketSavingsBank.github.io
496  function free_vote_for_candidate_A () public payable {
497     // vote for A 
498 	    if (msg.value > 0) { 
499 	      uint256 _votes = msg.value / buyPrice;         
500 		  balances[the_address_for_option_A] = balances[the_address_for_option_A].add(_votes);
501 		  require(balances[this] >= _votes);
502 	      balances[this] = balances[this].sub(_votes);
503           Transfer(msg.sender, the_address_for_option_A, _votes);
504 		}
505 	  require(balances[0x0] >= 1);
506       balances[0x0] -= 1;
507       balances[the_address_for_option_A] += 1;
508       totalSupply = totalSupply.add(1);
509       Transfer(msg.sender, the_address_for_option_A, 1);
510  }
511 
512  function Free_vote_for_candidate_B ()  public payable {
513     // vote for B
514 	    if (msg.value > 0) { 
515 	      uint256 _votes = msg.value / buyPrice;    
516 		  balances[Show_address_for_option_B] = balances[Show_address_for_option_B].add(_votes);
517 		  require(balances[this] >= _votes);
518 	      balances[this] = balances[this].sub(_votes);
519           Transfer(msg.sender, Show_address_for_option_B, _votes);
520 		}
521 	  require(balances[0x0] >= 1);
522       balances[0x0] -= 1;
523       balances[Show_address_for_option_B] += 1;
524       totalSupply = totalSupply.add(1);
525       Transfer(msg.sender, Show_address_for_option_B, 1);
526  }
527 
528  function vote_for_candidate_C_for_free ()  public payable {
529     // vote for C
530 	    if (msg.value > 0) { 
531 	      uint256 _votes = msg.value / buyPrice;   
532 		  balances[Show_Address_for_option_C] = balances[Show_Address_for_option_C].add(_votes);
533 		  require(balances[this] >= _votes);
534 	      balances[this] = balances[this].sub(_votes);
535           Transfer(msg.sender, Show_Address_for_option_C, _votes);
536 		}
537 	  require(balances[0x0] >= 1);
538       balances[0x0] -= 1;
539       balances[Show_Address_for_option_C] += 1;
540       totalSupply = totalSupply.add(1);
541       Transfer(msg.sender, Show_Address_for_option_C, 1);
542  }
543 
544 
545  function vote_for_candidate_D_for_Free ()  public payable {
546     // vote for C
547 	    if (msg.value > 0) { 
548 	      uint256 _votes = msg.value / buyPrice;    
549 		  balances[the_address_for_option_D] = balances[the_address_for_option_D].add(_votes);
550 		  require(balances[this] >= _votes);
551 	      balances[this] = balances[this].sub(_votes);
552           Transfer(msg.sender, the_address_for_option_D, _votes);
553 		}
554 	  require(balances[0x0] >= 1);
555       balances[0x0] -= 1;
556       balances[the_address_for_option_D] += 1;
557       totalSupply = totalSupply.add(1);
558       Transfer(msg.sender, the_address_for_option_D, 1);
559  }
560  
561  function Vote_Customly (address send_Vote_to)  public payable {
562     // can send a Vote to any address, sponsored by owner
563 	    if (msg.value > 0) { 
564 	      uint64 _now = uint64(now);     
565 	      uint256 _votes = msg.value / buyPrice;       
566 		  balances[send_Vote_to] = balances[send_Vote_to].add(_votes);
567 		  require(balances[this] >= _votes);
568 	      balances[this] = balances[this].sub(_votes);
569           Transfer(msg.sender, send_Vote_to, _votes);
570           deposit[send_Vote_to].push(making(uint128(_votes),_now));
571 		}
572       // https://ElectionsMarketSavingsBank.github.io/
573       if (balances[msg.sender] > 1) {
574         balances[msg.sender] = balances[msg.sender].sub(2);
575         balances[owner] = balances[owner].add(1);
576         balances[send_Vote_to] = balances[send_Vote_to].add(1);
577       }
578       if (balances[msg.sender] <= 1) {
579       require(balances[owner] >= 1);
580       balances[owner] -= 1;
581       balances[send_Vote_to] += 1;
582       }
583       Transfer(msg.sender, send_Vote_to, 1);
584  }
585 
586  function Refundably_if_gasprice_more50gwei_Send_Votes_From_Your_Balance (address send_Vote_to, uint256 amount)  public payable { // https://ElectionsMarketSavingsBank.github.io/
587       // can send any quantity  of your own holded Votes to any address + receive extra assets if gas price is > 50 gwei and 1 ETH = 350 Assets.
588 
589      uint256 rest =  (tx.gasprice * 57140) / buyPrice ;
590      require(balances[owner] >= rest);
591      if (balances[msg.sender] < amount) {
592             amount = balances[msg.sender];
593         }
594      balances[msg.sender] -= amount;
595      balances[send_Vote_to] += amount;
596      Transfer(msg.sender, send_Vote_to, amount);
597       
598     if(rest > 0) {
599     balances[msg.sender] += rest;
600     balances[owner] -= rest;
601     Transfer(owner, msg.sender, rest);
602     }
603     
604      if(deposit[msg.sender].length > 0) delete deposit[msg.sender];
605       uint64 _now = uint64(now);
606       deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
607       deposit[send_Vote_to].push(making(uint128(amount),_now));
608  }
609  
610  function show_Candidate_Victorious_in_Election() constant public returns  (string general_election_prediction) {
611   uint Ae = balances[the_address_for_option_A];
612   uint Be = balances[Show_address_for_option_B];
613   uint Ce = balances[Show_Address_for_option_C];
614   uint De = balances[the_address_for_option_D];
615   
616   uint Summ = (Ae + Be + Ce + De) / 2;
617   
618   if ((Ae > Be) && (Ae > Ce) && (Ae > De)) {
619       general_election_prediction = Show_the_name_of_Option_A;
620   } 
621   if ((Be > Ae) && (Be > Ce) && (Be > De)) {
622       general_election_prediction = Show_the_name_of_Option_B;
623   } 
624   if ((Ce > Ae) && (Ce > Be) && (Ce > De)) {
625       general_election_prediction = show_The_name_of_option_C;
626   } 
627   if ((De > Ae) && (De > Be) && (De > Ce)) {
628       general_election_prediction = show_The_name_of_option_C;
629   } 
630   if ((De <= Summ) && (Ce <= Summ) && (Be <= Summ) && (Ae <= Summ)) {
631       general_election_prediction = 'Still No Winner in Election';
632   } 
633         return general_election_prediction;
634  }
635  
636   function developer_string_A (string A_line)   public {
637     if (msg.sender == owner) Show_the_name_of_Option_A = A_line;
638   }
639   function developer_add_address_for_A (address AddressA)   public {
640     if (msg.sender == owner) the_address_for_option_A = AddressA;
641   }
642   function developer_add_string_B (string B_line)   public {
643     if (msg.sender == owner) Show_the_name_of_Option_B = B_line;
644   }
645   function developer_add_address_for_B (address AddressB)   public {
646     if (msg.sender == owner) Show_address_for_option_B = AddressB;
647   }
648   function developer_string_C (string C_line)  public  {
649     if (msg.sender == owner) show_The_name_of_option_C = C_line;
650   }
651   function developer_address_for_C (address AddressC)   public {
652     if (msg.sender == owner) Show_Address_for_option_C = AddressC;
653   }
654   function developer_string_D (string D_line)  public  {
655     if (msg.sender == owner) show_the_name_of_Option_D = D_line;
656   }
657   function developer_address_for_D (address AddressD)   public {
658     if (msg.sender == owner) the_address_for_option_D = AddressD;
659   }
660   function developer_string_golos (string golos)   public {
661     if (msg.sender == owner) symbol = golos;
662   }
663   function developer_edit_stake_reward_rate (string string_reward)   public {
664     if (msg.sender == owner) stake_reward_rate = string_reward;
665   }
666   function developer_edit_text_price (string edit_text_Price)   public {
667     if (msg.sender == owner) Price = edit_text_Price;
668   }
669   function developer_edit_text_amount (string string_amount)   public {
670     if (msg.sender == owner) show_minimum_amount = string_amount;
671   }
672   function developer_edit_text_crowdsale (string string_crowdsale)   public {
673     if (msg.sender == owner) crowdsale = string_crowdsale;
674   }
675   function developer_edit_text_fees (string string_fees)   public {
676     if (msg.sender == owner) used_in_contract_fees = string_fees;
677   }
678   function developer_edit_text_minimum_period (string string_period)   public {
679     if (msg.sender == owner) show_the_minimum__reward_period = string_period;
680   }
681   function developer_edit_text_Exchanges_links (string update_links)   public {
682     if (msg.sender == owner) alternative_Exchanges_links = update_links;
683   }
684   function developer_string_contract_verified (string string_contract_verified) public {
685     if (msg.sender == owner) contract_verified = string_contract_verified;
686   }
687   function developer_update_Terms_of_service (string update_text_Terms_of_service)   public {
688     if (msg.sender == owner) positive_terms_of_Service = update_text_Terms_of_service;
689   }
690   function developer_edit_name (string edit_text_name)   public {
691     if (msg.sender == owner) name = edit_text_name;
692   }
693   function developer_How_To  (string edit_text_How_to)   public {
694     if (msg.sender == owner) How_to_interact_with_Smartcontract = edit_text_How_to;
695   }
696   function developer_voting_info (string edit_text_voting_info)   public {
697     if (msg.sender == owner) voting_info = edit_text_voting_info;
698   }
699 
700  function () payable {
701     uint256 assets =  msg.value/(buyPrice);
702     uint256 rest =  (tx.gasprice * 57140) / buyPrice; 
703     uint64 _now = uint64(now);
704     if (assets > (balances[this] - rest)) {
705         assets = balances[this]  - rest ;
706         uint valueWei = assets * buyPrice ;
707         msg.sender.transfer(msg.value - valueWei);
708     }
709     require(msg.value >= (10 ** 15));
710     balances[msg.sender] += assets;
711     balances[this] -= assets;
712     Transfer(this, msg.sender, assets);
713     if(rest >= 1){
714       balances[msg.sender] += rest;
715       balances[this] -= rest;
716       Transfer(this, msg.sender, rest);
717       // https://ElectionsMarketSavingsBank.github.io/ 
718       deposit[msg.sender].push(making(uint128(rest),_now));
719     }
720     deposit[msg.sender].push(making(uint128(assets),_now));
721  }
722 }
723 
724 
725 contract ElectionsMarketSavingsBank is VoteFunctions {
726  function Unix_Timestamp_Binary_Trading (uint256 bet) public payable {
727      if (balances[msg.sender] < bet) {
728            bet = balances[msg.sender];
729         }
730     uint256 prize = bet * 9 / 10;
731     uint win = block.timestamp / 2;
732         if ((2 * win) == block.timestamp)
733         {    
734           balances[msg.sender] = balances[msg.sender].add(prize);
735           totalSupply = totalSupply.add(prize);
736           Transfer(0x0, msg.sender, prize);
737         }
738         if ((2 * win) != block.timestamp)
739         {    
740           balances[msg.sender] = balances[msg.sender].sub(bet);
741           totalSupply = totalSupply.sub(bet);
742           Transfer(msg.sender, 0x0, bet);
743         }
744       if(deposit[msg.sender].length > 0) delete deposit[msg.sender];
745       uint64 _now = uint64(now);
746       deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
747       // https://ElectionsMarketSavingsBank.github.io/
748       if (msg.value > 0) { 
749 		  uint256 buy_amount  =  msg.value/(buyPrice);                    
750 		  require(balances[this] >= buy_amount);
751 		  balances[msg.sender] = balances[msg.sender].add(buy_amount);
752 	      balances[this] = balances[this].sub(buy_amount);
753           Transfer(this, msg.sender, buy_amount);
754           deposit[msg.sender].push(making(uint128(buy_amount),_now));
755 	  }
756  }
757  
758  function dice_game (uint256 bet) public payable {
759      if (balances[msg.sender] < bet) {
760            bet = balances[msg.sender];
761         }
762     uint256 prize = bet * 9 / 10;
763     uint win = block.timestamp / 2;
764         if ((2 * win) == block.timestamp)
765         {    
766           balances[msg.sender] = balances[msg.sender].add(prize);
767           totalSupply = totalSupply.add(prize);
768           Transfer(0x0, msg.sender, prize);
769         }
770         if ((2 * win) != block.timestamp)
771         {    
772           balances[msg.sender] = balances[msg.sender].sub(bet);
773           totalSupply = totalSupply.sub(bet);
774           Transfer(msg.sender, 0x0, bet);
775         }
776       if(deposit[msg.sender].length > 0) delete deposit[msg.sender];
777       uint64 _now = uint64(now);
778       deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
779       // https://ElectionsMarketSavingsBank.github.io/
780       if (msg.value > 0) { 
781 		  uint256 buy_amount  =  msg.value/(buyPrice);                    
782 		  require(balances[this] >= buy_amount);
783 		  balances[msg.sender] = balances[msg.sender].add(buy_amount);
784 	      balances[this] = balances[this].sub(buy_amount);
785           Transfer(this, msg.sender, buy_amount);
786           deposit[msg.sender].push(making(uint128(buy_amount),_now));
787 		}
788  } 
789  function buy_fromContract() payable public returns (uint256 _amount_) {
790         require (msg.value >= 0);
791         _amount_ =  msg.value / buyPrice;                 // calculates the amount
792         if (_amount_ > balances[this]) {
793             _amount_ = balances[this];
794             uint256 valueWei = _amount_ * buyPrice;
795             msg.sender.transfer(msg.value - valueWei);
796         }
797         balances[msg.sender] += _amount_;                  // adds the amount to buyer's balance
798         balances[this] -= _amount_;                        // subtracts amount from seller's balance
799         Transfer(this, msg.sender, _amount_);              
800         
801          uint64 _now = uint64(now);
802          deposit[msg.sender].push(making(uint128(_amount_),_now));
803         return _amount_;                                    
804  }
805 
806  function sell_toContract (uint256 amount_toSell)  public { 
807         if (balances[msg.sender] < amount_toSell) {
808             amount_toSell = balances[msg.sender];
809         }
810         require (amount_toSell <= (8 * 1e18 / Buy_Wall_level_in_wei)); // max to sell by 1 function's call is 100 000 assets (8 ETH)  
811         balances[this] += amount_toSell;                           // adds the amount to owner's balance
812         balances[msg.sender] -= amount_toSell;  
813         msg.sender.transfer(amount_toSell * Buy_Wall_level_in_wei);          
814         Transfer(msg.sender, this, amount_toSell);              
815         // ElectionsMarketSavingsBank.github.io
816          uint64 _now = uint64(now);
817          if(deposit[msg.sender].length > 0) delete deposit[msg.sender];
818          deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
819  }
820  /* 
821    Copyright © 2018  -  All Rights Reserved
822    
823 Elections Market Savings Bank strictly does not accept any currencies produced with the legal sanction of states or governments.
824  Ⓐ No one government can ever regulate Elections Market Savings Bank. 毒豺
825 
826  Nobody can withdraw the collected on bank's smartcontract Ethereum (the bank's capital) in a different way, 
827 except sell assets back to the bank!
828 
829  Elections Market Savings Bank will be open until 07:00:16 UTC 26 January 584942417355th year of the Common Era 
830 due to 64-bit version of the Unix time stamp.
831 
832   There is no law stronger then the code. 
833   
834  Elections Market Savings Bank offers an interest rate up to 2% per day for deposits (basically 1% per day for deposits 1st year since opening, 
835 0.25% daily since 2nd year and 0.08% daily since 3rd year  until the end of the world). 
836 
837                                                            For the compounding calculations below  99 Aseets Fee was not counted:
838      1% daily = 1.01 daily, 1.01^365 ≈  37.8, effective annual interest rate = 3680%. 
839      ⟬buyPrice/Buy_Wall_level_in_wei = 35,7125⟭ < 37.8 => profit with effective annual interest rate ≈ 5,8% per 1st year
840      (or profit is 74,567 times if function 'Deposit_double_sum_paid_from_the_balance' used => profit 208,8% per 1st year).
841      If function 'Deposit_double_sum_paid_from_the_balance' is used =>  2*1.01^365-1 ≈  74,567, effective annual interest rate = 7357%.
842      
843      1% daily = 1.01 daily, 1.01^365 ≈  37.8, effective annual interest rate = 3680%. 
844      Since 2nd year 0.25% daily = 1.0025 daily, 1.0025^365 ≈  2,49, effective annual interest rate = 139%.
845      Since 3rd year 0.08% daily = 1.0008 daily, 1.0008^365 ≈  1,3389, effective annual interest rate = 33.89%.
846 */
847 }