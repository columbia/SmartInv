1 pragma solidity ^ 0.4 .15;
2 
3 
4 /*
5  * ERC20 interface
6  * see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9   uint public totalSupply;
10   function balanceOf(address who) constant returns (uint);
11   function allowance(address owner, address spender) constant returns (uint);
12 
13   function transfer(address to, uint value) returns (bool ok);
14   function transferFrom(address from, address to, uint value) returns (bool ok);
15   function approve(address spender, uint value) returns (bool ok);
16   event Transfer(address indexed from, address indexed to, uint value);
17   event Approval(address indexed owner, address indexed spender, uint value);
18 }
19 
20 
21 /**
22  * Math operations with safety checks
23  */
24 contract SafeMath {
25   function safeMul(uint a, uint b) internal returns (uint) {
26     uint c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function safeDiv(uint a, uint b) internal returns (uint) {
32     assert(b > 0);
33     uint c = a / b;
34     assert(a == b * c + a % b);
35     return c;
36   }
37 
38   function safeSub(uint a, uint b) internal returns (uint) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function safeAdd(uint a, uint b) internal returns (uint) {
44     uint c = a + b;
45     assert(c>=a && c>=b);
46     return c;
47   }
48 }
49 
50 
51 
52 /**
53  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
54  *
55  * Based on code by FirstBlood:
56  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
57  */
58 contract StandardToken is ERC20, SafeMath {
59 
60   mapping(address => uint) balances;
61   mapping (address => mapping (address => uint)) allowed;
62 
63   /**
64    *
65    * Fix for the ERC20 short address attack
66    *
67    * http://vessenes.com/the-erc20-short-address-attack-explained/
68    */
69   modifier onlyPayloadSize(uint size) {
70      if(msg.data.length < size + 4) revert();
71      _;
72   }
73 
74   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
75     balances[msg.sender] = safeSub(balances[msg.sender], _value);
76     balances[_to] = safeAdd(balances[_to], _value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   function transferFrom(address _from, address _to, uint _value)  returns (bool success) {
82     var _allowance = allowed[_from][msg.sender];
83 
84     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
85     // if (_value > _allowance) throw;
86 
87     balances[_to] = safeAdd(balances[_to], _value);
88     balances[_from] = safeSub(balances[_from], _value);
89     allowed[_from][msg.sender] = safeSub(_allowance, _value);
90     Transfer(_from, _to, _value);
91     return true;
92   }
93 
94   function balanceOf(address _owner) constant returns (uint balance) {
95     return balances[_owner];
96   }
97 
98   function approve(address _spender, uint _value) returns (bool success) {
99 
100     // To change the approve amount you first have to reduce the addresses`
101     //  allowance to zero by calling `approve(_spender, 0)` if it is not
102     //  already 0 to mitigate the race condition described here:
103     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
105 
106     allowed[msg.sender][_spender] = _value;
107     Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111   function allowance(address _owner, address _spender) constant returns (uint remaining) {
112     return allowed[_owner][_spender];
113   }
114 
115 }
116 
117 contract owned {
118     address owner;
119 
120     modifier onlyOwner() {
121       require(msg.sender == owner);
122       _;
123     }
124 }
125 
126 contract Fish is owned, StandardToken {
127 
128   string public constant TermsOfUse = "https://github.com/triangles-things/fish.project/blob/master/terms-of-use.md";
129 
130   /*
131    * State variables
132    */
133 
134   string public constant symbol = "FSH";
135   string public constant name = "Fish";
136   uint8 public constant decimals = 3;
137 
138   /*
139    * Constructor function
140    */
141 
142   function Fish() {
143     owner = msg.sender;
144     balances[msg.sender] = 1;                                                   // Owner can now be a referral
145     totalSupply = 1;
146     buyPrice_wie= 100000000000000;                                              // 100 szabo per one token. One unit = 1000 tokens. 1 ether = 10 units
147     sellPrice_wie = buyPrice_wie * sell_ppc / 100;
148   }
149 
150   function () payable { revert(); }
151 
152   /*
153    * SECTION: PRICE GROWTH
154    *
155    * This section is responsible for daily price increase. Once per day the buy price will be increased 
156    * through adjustPrice modifier. The price update happens before buy and sell functions are executed.
157    * Contract owner has only one way to control the growth rate here - setGrowth.
158    */
159 
160   // Growth rate is present in parts per million (ppm)
161   uint32 public dailyGrowth_ppm = 6100;                                         // default growth is 20% (0.61% per day)
162   uint public dailyGrowthUpdated_date = now;                                    // Don't update it on first day of contract
163   
164   uint32 private constant dailyGrowthMin_ppm =  6096;                           // 20% every month in price growth or 0.00610 daily
165   uint32 private constant dailyGrowthMax_ppm = 23374;                           // 100% in growth every month or 0,02337 daily
166   
167   uint32 public constant sell_ppc = 90;                                         // Sell price is 90% of buy price
168 
169   event DailyGrowthUpdate(uint _newRate_ppm);
170   event PriceAdjusted(uint _newBuyPrice_wei, uint _newSellPrice_wei);
171 
172   /*
173    * MODIFIER
174    * If last update happened more than one day ago, update the price, save the time of current price update
175    * Adjust sell price and log the event
176    */
177   modifier adjustPrice() {
178     if ( (dailyGrowthUpdated_date + 1 days) < now ) {
179       dailyGrowthUpdated_date = now;
180       buyPrice_wie = buyPrice_wie * (1000000 + dailyGrowth_ppm) / 1000000;
181       sellPrice_wie = buyPrice_wie * sell_ppc / 100;
182       PriceAdjusted(buyPrice_wie, sellPrice_wie);
183     }
184     _;
185   }
186 
187   /* 
188    * OWNER ONLY; EXTERNAL METHOD
189    * setGrowth can accept values within range from 20% to 100% of growth per month (based on 30 days per month assumption).
190    * 
191    *   Formula is:
192    *
193    *       buyPrice_eth = buyPrice_eth * (1000000 + dailyGrowthMin_ppm) / 1000000;
194    *       ^new value     ^current value  ^1.0061 (if dailyGrowth_ppm == 6100)
195    *
196    *       1.0061^30 = 1.20 (if dailyGrowth_ppm == 6100)
197    *       1.023374^30 = 2 (if dailyGrowth_ppm == 23374)
198    * 
199    *  Some other daily rates
200    *
201    *   Per month -> Value in ppm
202    *      1.3    ->  8783
203    *      1.4    -> 11278
204    *      1.5    -> 13607
205    *      1.6    -> 15790
206    *      1.7    -> 17844
207    *      1.8    -> 19786
208    */
209   function setGrowth(uint32 _newGrowth_ppm) onlyOwner external returns(bool result) {
210     if (_newGrowth_ppm >= dailyGrowthMin_ppm &&
211         _newGrowth_ppm <= dailyGrowthMax_ppm
212     ) {
213       dailyGrowth_ppm = _newGrowth_ppm;
214       DailyGrowthUpdate(_newGrowth_ppm);
215       return true;
216     } else {
217       return false;
218     }
219   }
220 
221   /* 
222    * SECTION: TRADING
223    *
224    * This section is responsible purely for trading the tokens. User can buy tokens, user can sell tokens.
225    *
226    */
227 
228   uint256 public sellPrice_wie;
229   uint256 public buyPrice_wie;
230 
231   /*
232    * EXTERNAL METHOD
233    * User can buy arbitrary amount of tokens. Before amount of tokens will be calculated, the price of tokens 
234    * has to be adjusted. This happens in adjustPrice modified before function call.
235    *
236    * Short description of this method
237    *
238    *   Calculate tokens that user is buying
239    *   Assign awards ro refereals
240    *   Add some bounty for new users who set referral before first buy
241    *   Send tokens that belong to contract or if there is non issue more and send them to user
242    *
243    * Read -> https://github.com/triangles-things/fish.project/blob/master/terms-of-use.md
244    */
245   function buy() adjustPrice payable external {
246     require(msg.value >= buyPrice_wie);
247     var amount = safeDiv(msg.value, buyPrice_wie);
248 
249     assignBountryToReferals(msg.sender, amount);                                // First assign bounty
250 
251     // Buy discount if User is a new user and has set referral
252     if ( balances[msg.sender] == 0 && referrals[msg.sender][0] != 0 ) {
253       // Check that user has to wait at least two weeks before he get break even on what he will get
254       amount = amount * (100 + landingDiscount_ppc) / 100;
255     }
256 
257     issueTo(msg.sender, amount);
258   }
259 
260   /*
261    * EXTERNAL METHOD
262    * User can sell tokens back to contract.
263    *
264    * Short description of this method
265    *
266    *   Adjust price
267    *   Calculate tokens price that user is selling 
268    *   Make all possible checks
269    *   Transfer the money
270    */
271   function sell(uint256 _amount) adjustPrice external {
272     require(_amount > 0 && balances[msg.sender] >= _amount);
273     uint moneyWorth = safeMul(_amount, sellPrice_wie);
274     require(this.balance > moneyWorth);                                         // We can't sell if we don't have enough money
275     
276     if (
277         balances[this] + _amount > balances[this] &&
278         balances[msg.sender] - _amount < balances[msg.sender]
279     ) {
280       balances[this] = safeAdd(balances[this], _amount);                        // adds the amount to owner's balance
281       balances[msg.sender] = safeSub(balances[msg.sender], _amount);            // subtracts the amount from seller's balance
282       if (!msg.sender.send(moneyWorth)) {                                       // sends ether to the seller. It's important
283         revert();                                                               // to do this last to avoid recursion attacks
284       } else {
285         Transfer(msg.sender, this, _amount);                                    // executes an event reflecting on the change
286       }        
287     } else {
288       revert();                                                                 // checks if the sender has enough to sell
289     }  
290   }
291 
292   /*
293    * PRIVATE METHOD
294    * Issue  new tokens to contract
295    */
296   function issueTo(address _beneficiary, uint256 _amount_tkns) private {
297     if (
298         balances[this] >= _amount_tkns
299     ) {
300       // All tokens are taken from balance
301       balances[this] = safeSub(balances[this], _amount_tkns);
302       balances[_beneficiary] = safeAdd(balances[_beneficiary], _amount_tkns);
303     } else {
304       // Balance will be lowered and new tokens will be issued
305       uint diff = safeSub(_amount_tkns, balances[this]);
306 
307       totalSupply = safeAdd(totalSupply, diff);
308       balances[this] = 0;
309       balances[_beneficiary] = safeAdd(balances[_beneficiary], _amount_tkns);
310     }
311     
312     Transfer(this, _beneficiary, _amount_tkns);
313   }
314   
315   /*
316    * SECTION: BOUNTIES
317    *
318    * This section describes all possible awards.
319    */
320     
321   mapping(address => address[3]) referrals;
322   mapping(address => uint256) bounties;
323 
324   uint32 public constant landingDiscount_ppc = 4;                               // Landing discount is 4%
325 
326   /*
327    * EXTERNAL METHOD 
328    * Set your referral first. You will get 4% more tokens on your first buy and trigger a
329    * reward of whoever told you about this contract. A win-win scenario.
330    */
331   function referral(address _referral) external returns(bool) {
332     if ( balances[_referral] > 0 &&                                              // Referral participated already
333          balances[msg.sender] == 0  &&                                          // Sender is a new user
334          referrals[msg.sender][0] == 0                                           // Not returning user. User can not reassign their referrals but they can assign them later on
335     ) {
336       var referral_referrals = referrals[_referral];
337       referrals[msg.sender] = [_referral, referral_referrals[0], referral_referrals[1]];
338       return true;
339     }
340     
341     return false;
342   }
343 
344   /*
345    * PRIVATE METHOD
346    * Award bounties to referrals.
347    */ 
348   function assignBountryToReferals(address _referralsOf, uint256 _amount) private {
349     var refs = referrals[_referralsOf];
350     
351     if (refs[0] != 0) {
352      issueTo(refs[0], (_amount * 4) / 100);                                     // 4% bounty to direct referral
353       if (refs[1] != 0) {
354         issueTo(refs[1], (_amount * 2) / 100);                                  // 2% bounty to referral of referral
355         if (refs[2] != 0) {
356           issueTo(refs[2], (_amount * 1) / 100);                                // 1% bounty to referral of referral of referral
357        }
358       }
359     }
360   }
361 
362   /*
363    * OWNER ONLY; EXTERNAL METHOD
364    * Santa is coming! Who ever made impact to promote the Fish and can prove it will get the bonus
365    */
366   function assignBounty(address _account, uint256 _amount) onlyOwner external returns(bool) {
367     require(_amount > 0); 
368      
369     if (balances[_account] > 0 &&                                               // Account had participated already
370         bounties[_account] + _amount <= 1000000                                 // no more than 100 token units per account
371     ) {
372       issueTo(_account, _amount);
373       return true;
374     } else {
375       return false;
376     }
377   }
378 }