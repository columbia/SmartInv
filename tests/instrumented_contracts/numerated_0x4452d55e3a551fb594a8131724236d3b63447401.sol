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
72   address public owner;
73   address constant public developer = 0xEE06BdDafFA56a303718DE53A5bc347EfbE4C68f;
74   uint256 public individual_cap;
75 
76   //Variables subject to changes
77   uint256 public max_amount;  //0 means there is no limit
78   uint256 public min_amount;
79 
80   //Store the amount of ETH deposited by each account.
81   mapping (address => uint256) public balances;
82   mapping (address => uint256) public balances_bonus;
83   // Track whether the contract has bought the tokens yet.
84   bool public bought_tokens;
85   // Record ETH value of tokens currently held by contract.
86   uint256 public contract_eth_value;
87   uint256 public contract_eth_value_bonus;
88   //Set by the owner in order to allow the withdrawal of bonus tokens.
89   bool public bonus_received;
90   //The address of the contact.
91   address public sale;
92   //Token address
93   ERC20 public token;
94   //Records the fees that have to be sent
95   uint256 fees;
96   //Set by the owner. Allows people to refund totally or partially.
97   bool public allow_refunds;
98   //The reduction of the allocation in % | example : 40 -> 40% reduction
99   uint256 public percent_reduction;
100 
101   //Internal functions
102   function Moongang(uint256 max, uint256 min, uint256 cap) {
103     /*
104     Constructor
105     */
106     owner = msg.sender;
107     max_amount = SafeMath.div(SafeMath.mul(max, 100), 99);
108     min_amount = min;
109     individual_cap = cap;
110   }
111 
112   //Functions for the owner
113 
114   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
115   function buy_the_tokens() onlyOwner minAmountReached underMaxAmount {
116     //Avoids burning the funds
117     require(!bought_tokens && sale != 0x0);
118     //Record that the contract has bought the tokens.
119     bought_tokens = true;
120     //Sends the fee before so the contract_eth_value contains the correct balance
121     uint256 dev_fee = SafeMath.div(fees, FEE_DEV);
122     owner.transfer(SafeMath.sub(fees, dev_fee));
123     developer.transfer(dev_fee);
124     //Record the amount of ETH sent as the contract's current value.
125     contract_eth_value = this.balance;
126     contract_eth_value_bonus = this.balance;
127     // Transfer all the funds to the crowdsale address.
128     sale.transfer(contract_eth_value);
129   }
130 
131   function force_refund(address _to_refund) onlyOwner {
132     require(!bought_tokens);
133     uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[_to_refund], 100), 99);
134     balances[_to_refund] = 0;
135     balances_bonus[_to_refund] = 0;
136     fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
137     _to_refund.transfer(eth_to_withdraw);
138   }
139 
140   function force_partial_refund(address _to_refund) onlyOwner {
141     require(allow_refunds && percent_reduction > 0);
142     //Amount to refund is the amount minus the X% of the reduction
143     //amount_to_refund = balance*X
144     uint256 basic_amount = SafeMath.div(SafeMath.mul(balances[_to_refund], percent_reduction), 100);
145     uint256 eth_to_withdraw = basic_amount;
146     if (!bought_tokens) {
147       //We have to take in account the partial refund of the fee too if the tokens weren't bought yet
148       eth_to_withdraw = SafeMath.div(SafeMath.mul(basic_amount, 100), 99);
149       fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
150     }
151     balances[_to_refund] = SafeMath.sub(balances[_to_refund], eth_to_withdraw);
152     balances_bonus[_to_refund] = balances[_to_refund];
153     _to_refund.transfer(eth_to_withdraw);
154   }
155 
156   function set_sale_address(address _sale) onlyOwner {
157     //Avoid mistake of putting 0x0 and can't change twice the sale address
158     require(_sale != 0x0);
159     sale = _sale;
160   }
161 
162   function set_token_address(address _token) onlyOwner {
163     require(_token != 0x0);
164     token = ERC20(_token);
165   }
166 
167   function set_bonus_received(bool _boolean) onlyOwner {
168     bonus_received = _boolean;
169   }
170 
171   function set_allow_refunds(bool _boolean) onlyOwner {
172     /*
173     In case, for some reasons, the project refunds the money
174     */
175     allow_refunds = _boolean;
176   }
177 
178   function set_percent_reduction(uint256 _reduction) onlyOwner {
179     require(_reduction <= 100);
180     percent_reduction = _reduction;
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
195       max_amount = SafeMath.div(SafeMath.mul(_amount, 100), 99);
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
238     require(!bought_tokens && allow_refunds && percent_reduction == 0);
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