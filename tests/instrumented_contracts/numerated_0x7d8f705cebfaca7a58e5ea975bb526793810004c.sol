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
12   function mul(uint256 a, uint256 b) internal returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal returns (uint256) {
22     uint256 c = a / b;
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 //-----------------------------------------------------
38 
39 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
40 contract ERC20 {
41   function transfer(address _to, uint256 _value) returns (bool success);
42   function balanceOf(address _owner) constant returns (uint256 balance);
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
59     uint256 correct_amount = SafeMath.div(SafeMath.mul(min_amount, 100), 99);
60     require(this.balance >= correct_amount);
61     _;
62   }
63 
64   modifier underMaxAmount {
65     uint256 correct_amount = SafeMath.div(SafeMath.mul(max_amount, 100), 99);
66     require(max_amount == 0 || this.balance <= correct_amount);
67     _;
68   }
69 
70   //Constants of the contract
71   uint256 constant FEE = 100;    //1% fee
72   uint256 constant FEE_DEV = SafeMath.div(20, 3); //15% on the 1% fee
73   address public owner;
74   address constant public developer = 0xEE06BdDafFA56a303718DE53A5bc347EfbE4C68f;
75   uint256 individual_cap;
76 
77   //Variables subject to changes
78   uint256 public max_amount;  //0 means there is no limit
79   uint256 public min_amount;
80 
81   //Store the amount of ETH deposited by each account.
82   mapping (address => uint256) public balances;
83   mapping (address => uint256) public balances_bonus;
84   // Track whether the contract has bought the tokens yet.
85   bool public bought_tokens = false;
86   // Record ETH value of tokens currently held by contract.
87   uint256 public contract_eth_value;
88   uint256 public contract_eth_value_bonus;
89   //Set by the owner in order to allow the withdrawal of bonus tokens.
90   bool bonus_received;
91   //The address of the contact.
92   address public sale;
93   //Token address
94   ERC20 public token;
95   //Records the fees that have to be sent
96   uint256 fees;
97   //Set by the owner. Allows people to refund totally or partially.
98   bool public allow_refunds;
99   //The reduction of the allocation in % | example : 40 -> 40% reduction
100   uint256 percent_reduction;
101   
102   //Internal functions
103   function Moongang(uint256 max, uint256 min, uint256 cap) {
104     /*
105     Constructor
106     */
107     owner = msg.sender;
108     max_amount = max;
109     min_amount = min;
110     individual_cap = cap;
111   }
112 
113   //Functions for the owner
114 
115   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
116   function buy_the_tokens() onlyOwner minAmountReached underMaxAmount {
117     require(!bought_tokens);
118     //Avoids burning the funds
119     require(sale != 0x0);
120     //Record that the contract has bought the tokens.
121     bought_tokens = true;
122     //Sends the fee before so the contract_eth_value contains the correct balance
123     uint256 dev_fee = SafeMath.div(fees, FEE_DEV);
124     owner.transfer(SafeMath.sub(fees, dev_fee));
125     developer.transfer(dev_fee);
126     //Record the amount of ETH sent as the contract's current value.
127     contract_eth_value = this.balance;
128     contract_eth_value_bonus = this.balance;
129     // Transfer all the funds to the crowdsale address.
130     sale.transfer(contract_eth_value);
131   }
132 
133   function force_refund(address _to_refund) onlyOwner {
134     uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[_to_refund], 100), 99);
135     balances[_to_refund] = 0;
136     balances_bonus[_to_refund] = 0;
137     fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
138     _to_refund.transfer(eth_to_withdraw);
139   }
140 
141   function force_partial_refund(address _to_refund) onlyOwner {
142     require(allow_refunds && percent_reduction > 0);
143     //Amount to refund is the amount minus the X% of the reduction
144     //amount_to_refund = balance*X
145     uint256 basic_amount = SafeMath.div(SafeMath.mul(balances[_to_refund], percent_reduction), 100);
146     uint256 eth_to_withdraw = basic_amount;
147     if (!bought_tokens) {
148       //We have to take in account the partial refund of the fee too if the tokens weren't bought yet
149       eth_to_withdraw = SafeMath.div(SafeMath.mul(basic_amount, 100), 99);
150       fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
151     }
152     balances[_to_refund] = SafeMath.sub(balances[_to_refund], eth_to_withdraw);
153     balances_bonus[_to_refund] = balances[_to_refund];
154     _to_refund.transfer(eth_to_withdraw);
155   }
156 
157   function set_sale_address(address _sale) onlyOwner {
158     //Avoid mistake of putting 0x0 and can't change twice the sale address
159     require(_sale != 0x0 && sale == 0x0);
160     sale = _sale;
161   }
162 
163   function set_token_address(address _token) onlyOwner {
164     require(_token != 0x0);
165     token = ERC20(_token);
166   }
167 
168   function set_bonus_received(bool _boolean) onlyOwner {
169     bonus_received = _boolean;
170   }
171 
172   function set_allow_refunds(bool _boolean) onlyOwner {
173     /*
174     In case, for some reasons, the project refunds the money
175     */
176     allow_refunds = _boolean;
177   }
178 
179   function set_percent_reduction(uint256 _reduction) onlyOwner {
180       percent_reduction = _reduction;
181   }
182 
183   function change_individual_cap(uint256 _cap) onlyOwner {
184     individual_cap = _cap;
185   }
186 
187   function change_owner(address new_owner) onlyOwner {
188     require(new_owner != 0x0);
189     owner = new_owner;
190   }
191 
192   function change_max_amount(uint256 _amount) onlyOwner {
193       //ATTENTION! The new amount should be in wei
194       //Use https://etherconverter.online/
195       max_amount = _amount;
196   }
197 
198   function change_min_amount(uint256 _amount) onlyOwner {
199       //ATTENTION! The new amount should be in wei
200       //Use https://etherconverter.online/
201       min_amount = _amount;
202   }
203 
204   //Public functions
205 
206   // Allows any user to withdraw his tokens.
207   function withdraw() {
208     // Disallow withdraw if tokens haven't been bought yet.
209     require(bought_tokens);
210     uint256 contract_token_balance = token.balanceOf(address(this));
211     // Disallow token withdrawals if there are no tokens to withdraw.
212     require(contract_token_balance != 0);
213     uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], contract_token_balance), contract_eth_value);
214     // Update the value of tokens currently held by the contract.
215     contract_eth_value = SafeMath.sub(contract_eth_value, balances[msg.sender]);
216     // Update the user's balance prior to sending to prevent recursive call.
217     balances[msg.sender] = 0;
218     // Send the funds.  Throws on failure to prevent loss of funds.
219     require(token.transfer(msg.sender, tokens_to_withdraw));
220   }
221 
222   function withdraw_bonus() {
223   /*
224     Special function to withdraw the bonus tokens after the 6 months lockup.
225     bonus_received has to be set to true.
226   */
227     require(bought_tokens && bonus_received);
228     uint256 contract_token_balance = token.balanceOf(address(this));
229     require(contract_token_balance != 0);
230     uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances_bonus[msg.sender], contract_token_balance), contract_eth_value_bonus);
231     contract_eth_value_bonus = SafeMath.sub(contract_eth_value_bonus, balances_bonus[msg.sender]);
232     balances_bonus[msg.sender] = 0;
233     require(token.transfer(msg.sender, tokens_to_withdraw));
234   }
235   
236   // Allows any user to get his eth refunded before the purchase is made.
237   function refund() {
238     require(allow_refunds && percent_reduction == 0);
239     //balance of contributor = contribution * 0.99
240     //so contribution = balance/0.99
241     uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], 100), 99);
242     // Update the user's balance prior to sending ETH to prevent recursive call.
243     balances[msg.sender] = 0;
244     //Updates the balances_bonus too
245     balances_bonus[msg.sender] = 0;
246     //Updates the fees variable by substracting the refunded fee
247     fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
248     // Return the user's funds.  Throws on failure to prevent loss of funds.
249     msg.sender.transfer(eth_to_withdraw);
250   }
251 
252   //Allows any user to get a part of his ETH refunded, in proportion
253   //to the % reduced of the allocation
254   function partial_refund() {
255     require(allow_refunds && percent_reduction > 0);
256     //Amount to refund is the amount minus the X% of the reduction
257     //amount_to_refund = balance*X
258     uint256 basic_amount = SafeMath.div(SafeMath.mul(balances[msg.sender], percent_reduction), 100);
259     uint256 eth_to_withdraw = basic_amount;
260     if (!bought_tokens) {
261       //We have to take in account the partial refund of the fee too if the tokens weren't bought yet
262       eth_to_withdraw = SafeMath.div(SafeMath.mul(basic_amount, 100), 99);
263       fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
264     }
265     balances[msg.sender] = SafeMath.sub(balances[msg.sender], eth_to_withdraw);
266     balances_bonus[msg.sender] = balances[msg.sender];
267     msg.sender.transfer(eth_to_withdraw);
268   }
269 
270   // Default function.  Called when a user sends ETH to the contract.
271   function () payable underMaxAmount {
272     require(!bought_tokens);
273     //1% fee is taken on the ETH
274     uint256 fee = SafeMath.div(msg.value, FEE);
275     fees = SafeMath.add(fees, fee);
276     //Updates both of the balances
277     balances[msg.sender] = SafeMath.add(balances[msg.sender], SafeMath.sub(msg.value, fee));
278     //Checks if the individual cap is respected
279     //If it's not, changes are reverted
280     require(individual_cap == 0 || balances[msg.sender] <= individual_cap);
281     balances_bonus[msg.sender] = balances[msg.sender];
282   }
283 }