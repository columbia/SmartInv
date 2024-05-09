1 // Author : shift
2 
3 pragma solidity ^0.4.18;
4 
5 //--------- OpenZeppelin's Safe Math
6 //Source : https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a / b;
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 //-----------------------------------------------------
38 
39 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
40 contract ERC20 {
41   function transfer(address _to, uint256 _value) public returns (bool success);
42   function balanceOf(address _owner) public constant returns (uint256 balance);
43 }
44 
45 /*
46   This contract stores twice every key value in order to be able to redistribute funds
47   when the bonus tokens are received (which is typically X months after the initial buy).
48 */
49 
50 contract Moongang {
51 
52   modifier onlyOwner {
53     require(msg.sender == owner);
54     _;
55   }
56 
57   modifier minAmountReached {
58     //In reality, the correct amount is the amount + 1%
59     require(this.balance >= SafeMath.div(SafeMath.mul(min_amount, 100), 99));
60     _;
61   }
62 
63   modifier underMaxAmount {
64     require(max_amount == 0 || this.balance <= max_amount);
65     _;
66   }
67 
68   //Constants of the contract
69   uint256 constant FEE = 100;    //1% fee
70   //SafeMath.div(20, 3) = 6
71   uint256 constant FEE_DEV = 6; //15% on the 1% fee
72   uint256 constant FEE_AUDIT = 12; //7.5% on the 1% fee
73   address public owner;
74   address constant public developer = 0xEE06BdDafFA56a303718DE53A5bc347EfbE4C68f;
75   address constant public auditor = 0x63F7547Ac277ea0B52A0B060Be6af8C5904953aa;
76   uint256 public individual_cap;
77 
78   //Variables subject to changes
79   uint256 public max_amount;  //0 means there is no limit
80   uint256 public min_amount;
81 
82   //Store the amount of ETH deposited by each account.
83   mapping (address => uint256) public balances;
84   mapping (address => uint256) public balances_bonus;
85   //whitelist
86   mapping (address => bool) public whitelist;
87   // Track whether the contract has bought the tokens yet.
88   bool public bought_tokens;
89   // Record ETH value of tokens currently held by contract.
90   uint256 public contract_eth_value;
91   uint256 public contract_eth_value_bonus;
92   //Set by the owner in order to allow the withdrawal of bonus tokens.
93   bool public bonus_received;
94   //The address of the contact.
95   address public sale;
96   //Token address
97   ERC20 public token;
98   //Records the fees that have to be sent
99   uint256 fees;
100   //Set by the owner. Allows people to refund totally or partially.
101   bool public allow_refunds;
102   //The reduction of the allocation in % | example : 40 -> 40% reduction
103   uint256 public percent_reduction;
104   //flag controlled by owner to enable/disable whitelists
105   bool public whitelist_enabled;
106 
107   //Internal functions
108   function Moongang(uint256 max, uint256 min, uint256 cap) {
109     /*
110     Constructor
111     */
112     owner = msg.sender;
113     max_amount = SafeMath.div(SafeMath.mul(max, 100), 99);
114     min_amount = min;
115     individual_cap = cap;
116     //enable whitelist by default
117     whitelist_enabled = true;
118   }
119 
120   //Functions for the owner
121 
122   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
123   function buy_the_tokens() onlyOwner minAmountReached underMaxAmount {
124     //Avoids burning the funds
125     require(!bought_tokens && sale != 0x0);
126     //Record that the contract has bought the tokens.
127     bought_tokens = true;
128     //Sends the fee before so the contract_eth_value contains the correct balance
129     uint256 dev_fee = SafeMath.div(fees, FEE_DEV);
130     uint256 audit_fee = SafeMath.div(fees, FEE_AUDIT);
131     owner.transfer(SafeMath.sub(SafeMath.sub(fees, dev_fee), audit_fee));
132     developer.transfer(dev_fee);
133     auditor.transfer(audit_fee);
134     //Record the amount of ETH sent as the contract's current value.
135     contract_eth_value = this.balance;
136     contract_eth_value_bonus = this.balance;
137     // Transfer all the funds to the crowdsale address.
138     sale.transfer(contract_eth_value);
139   }
140 
141   function force_refund(address _to_refund) onlyOwner {
142     require(!bought_tokens);
143     uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[_to_refund], 100), 99);
144     balances[_to_refund] = 0;
145     balances_bonus[_to_refund] = 0;
146     fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
147     _to_refund.transfer(eth_to_withdraw);
148   }
149 
150   function force_partial_refund(address _to_refund) onlyOwner {
151     require(percent_reduction > 0);
152     //Amount to refund is the amount minus the X% of the reduction
153     //amount_to_refund = balance*X
154     uint256 basic_amount = SafeMath.div(SafeMath.mul(balances[_to_refund], percent_reduction), 100);
155     uint256 eth_to_withdraw = basic_amount;
156     if (!bought_tokens) {
157       //We have to take in account the partial refund of the fee too if the tokens weren't bought yet
158       eth_to_withdraw = SafeMath.div(SafeMath.mul(basic_amount, 100), 99);
159       fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
160     }
161     balances[_to_refund] = SafeMath.sub(balances[_to_refund], eth_to_withdraw);
162     balances_bonus[_to_refund] = balances[_to_refund];
163     _to_refund.transfer(eth_to_withdraw);
164   }
165 
166   function whitelist_addys(address[] _addys) onlyOwner {
167     for (uint256 i = 0; i < _addys.length; i++) {
168       whitelist[_addys[i]] = true;
169     }
170   }
171 
172   function blacklist_addys(address[] _addys) onlyOwner {
173     for (uint256 i = 0; i < _addys.length; i++) {
174       whitelist[_addys[i]] = false;
175     }
176   }
177 
178   function set_sale_address(address _sale) onlyOwner {
179     //Avoid mistake of putting 0x0 and can't change twice the sale address
180     require(_sale != 0x0);
181     sale = _sale;
182   }
183 
184   function set_token_address(address _token) onlyOwner {
185     require(_token != 0x0);
186     token = ERC20(_token);
187   }
188 
189   function set_bonus_received(bool _boolean) onlyOwner {
190     bonus_received = _boolean;
191   }
192 
193   function set_allow_refunds(bool _boolean) onlyOwner {
194     /*
195     In case, for some reasons, the project refunds the money
196     */
197     allow_refunds = _boolean;
198   }
199 
200   function set_percent_reduction(uint256 _reduction) onlyOwner {
201     require(_reduction <= 100);
202     percent_reduction = _reduction;
203   }
204 
205   function set_whitelist_enabled(bool _boolean) onlyOwner {
206     whitelist_enabled = _boolean;
207   }
208 
209   function change_individual_cap(uint256 _cap) onlyOwner {
210     individual_cap = _cap;
211   }
212 
213   function change_owner(address new_owner) onlyOwner {
214     require(new_owner != 0x0);
215     owner = new_owner;
216   }
217 
218   function change_max_amount(uint256 _amount) onlyOwner {
219       //ATTENTION! The new amount should be in wei
220       //Use https://etherconverter.online/
221       max_amount = SafeMath.div(SafeMath.mul(_amount, 100), 99);
222   }
223 
224   function change_min_amount(uint256 _amount) onlyOwner {
225       //ATTENTION! The new amount should be in wei
226       //Use https://etherconverter.online/
227       min_amount = _amount;
228   }
229 
230   //Public functions
231 
232   // Allows any user to withdraw his tokens.
233   function withdraw() {
234     // Disallow withdraw if tokens haven't been bought yet.
235     require(bought_tokens);
236     uint256 contract_token_balance = token.balanceOf(address(this));
237     // Disallow token withdrawals if there are no tokens to withdraw.
238     require(contract_token_balance != 0);
239     uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], contract_token_balance), contract_eth_value);
240     // Update the value of tokens currently held by the contract.
241     contract_eth_value = SafeMath.sub(contract_eth_value, balances[msg.sender]);
242     // Update the user's balance prior to sending to prevent recursive call.
243     balances[msg.sender] = 0;
244     // Send the funds.  Throws on failure to prevent loss of funds.
245     require(token.transfer(msg.sender, tokens_to_withdraw));
246   }
247 
248   function withdraw_bonus() {
249   /*
250     Special function to withdraw the bonus tokens after the 6 months lockup.
251     bonus_received has to be set to true.
252   */
253     require(bought_tokens && bonus_received);
254     uint256 contract_token_balance = token.balanceOf(address(this));
255     require(contract_token_balance != 0);
256     uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances_bonus[msg.sender], contract_token_balance), contract_eth_value_bonus);
257     contract_eth_value_bonus = SafeMath.sub(contract_eth_value_bonus, balances_bonus[msg.sender]);
258     balances_bonus[msg.sender] = 0;
259     require(token.transfer(msg.sender, tokens_to_withdraw));
260   }
261 
262   // Allows any user to get his eth refunded before the purchase is made.
263   function refund() {
264     require(!bought_tokens && allow_refunds && percent_reduction == 0);
265     //balance of contributor = contribution * 0.99
266     //so contribution = balance/0.99
267     uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], 100), 99);
268     // Update the user's balance prior to sending ETH to prevent recursive call.
269     balances[msg.sender] = 0;
270     //Updates the balances_bonus too
271     balances_bonus[msg.sender] = 0;
272     //Updates the fees variable by substracting the refunded fee
273     fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
274     // Return the user's funds.  Throws on failure to prevent loss of funds.
275     msg.sender.transfer(eth_to_withdraw);
276   }
277 
278   //Allows any user to get a part of his ETH refunded, in proportion
279   //to the % reduced of the allocation
280   function partial_refund() {
281     require(allow_refunds && percent_reduction > 0);
282     //Amount to refund is the amount minus the X% of the reduction
283     //amount_to_refund = balance*X
284     uint256 basic_amount = SafeMath.div(SafeMath.mul(balances[msg.sender], percent_reduction), 100);
285     uint256 eth_to_withdraw = basic_amount;
286     if (!bought_tokens) {
287       //We have to take in account the partial refund of the fee too if the tokens weren't bought yet
288       eth_to_withdraw = SafeMath.div(SafeMath.mul(basic_amount, 100), 99);
289       fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
290     }
291     balances[msg.sender] = SafeMath.sub(balances[msg.sender], eth_to_withdraw);
292     balances_bonus[msg.sender] = balances[msg.sender];
293     msg.sender.transfer(eth_to_withdraw);
294   }
295 
296   // Default function.  Called when a user sends ETH to the contract.
297   function () payable underMaxAmount {
298     require(!bought_tokens);
299     if (whitelist_enabled) {
300       require(whitelist[msg.sender]);
301     }
302     //1% fee is taken on the ETH
303     uint256 fee = SafeMath.div(msg.value, FEE);
304     fees = SafeMath.add(fees, fee);
305     //Updates both of the balances
306     balances[msg.sender] = SafeMath.add(balances[msg.sender], SafeMath.sub(msg.value, fee));
307     //Checks if the individual cap is respected
308     //If it's not, changes are reverted
309     require(individual_cap == 0 || balances[msg.sender] <= individual_cap);
310     balances_bonus[msg.sender] = balances[msg.sender];
311   }
312 }