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
70   uint256 constant FEE_DEV = SafeMath.div(20, 3); //15% on the 1% fee
71   address public owner;
72   address constant public developer = 0xEE06BdDafFA56a303718DE53A5bc347EfbE4C68f;
73   uint256 public individual_cap;
74 
75   //Variables subject to changes
76   uint256 public max_amount;  //0 means there is no limit
77   uint256 public min_amount;
78 
79   //Store the amount of ETH deposited by each account.
80   mapping (address => uint256) public balances;
81   mapping (address => uint256) public balances_bonus;
82   // Track whether the contract has bought the tokens yet.
83   bool public bought_tokens;
84   // Record ETH value of tokens currently held by contract.
85   uint256 public contract_eth_value;
86   uint256 public contract_eth_value_bonus;
87   //Set by the owner in order to allow the withdrawal of bonus tokens.
88   bool public bonus_received;
89   //The address of the contact.
90   address public sale;
91   //Token address
92   ERC20 public token;
93   //Records the fees that have to be sent
94   uint256 fees;
95   //Set by the owner. Allows people to refund totally or partially.
96   bool public allow_refunds;
97   //The reduction of the allocation in % | example : 40 -> 40% reduction
98   uint256 public percent_reduction;
99 
100   //Internal functions
101   function Moongang(uint256 max, uint256 min, uint256 cap) {
102     /*
103     Constructor
104     */
105     owner = msg.sender;
106     max_amount = SafeMath.div(SafeMath.mul(max, 100), 99);
107     min_amount = min;
108     individual_cap = cap;
109   }
110 
111   //Functions for the owner
112 
113   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
114   function buy_the_tokens() onlyOwner minAmountReached underMaxAmount {
115     //Avoids burning the funds
116     require(!bought_tokens && sale != 0x0);
117     //Record that the contract has bought the tokens.
118     bought_tokens = true;
119     //Sends the fee before so the contract_eth_value contains the correct balance
120     uint256 dev_fee = SafeMath.div(fees, FEE_DEV);
121     owner.transfer(SafeMath.sub(fees, dev_fee));
122     developer.transfer(dev_fee);
123     //Record the amount of ETH sent as the contract's current value.
124     contract_eth_value = this.balance;
125     contract_eth_value_bonus = this.balance;
126     // Transfer all the funds to the crowdsale address.
127     sale.transfer(contract_eth_value);
128   }
129 
130   function force_refund(address _to_refund) onlyOwner {
131     require(!bought_tokens);
132     uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[_to_refund], 100), 99);
133     balances[_to_refund] = 0;
134     balances_bonus[_to_refund] = 0;
135     fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
136     _to_refund.transfer(eth_to_withdraw);
137   }
138 
139   function force_partial_refund(address _to_refund) onlyOwner {
140     require(allow_refunds && percent_reduction > 0);
141     //Amount to refund is the amount minus the X% of the reduction
142     //amount_to_refund = balance*X
143     uint256 basic_amount = SafeMath.div(SafeMath.mul(balances[_to_refund], percent_reduction), 100);
144     uint256 eth_to_withdraw = basic_amount;
145     if (!bought_tokens) {
146       //We have to take in account the partial refund of the fee too if the tokens weren't bought yet
147       eth_to_withdraw = SafeMath.div(SafeMath.mul(basic_amount, 100), 99);
148       fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
149     }
150     balances[_to_refund] = SafeMath.sub(balances[_to_refund], eth_to_withdraw);
151     balances_bonus[_to_refund] = balances[_to_refund];
152     _to_refund.transfer(eth_to_withdraw);
153   }
154 
155   function set_sale_address(address _sale) onlyOwner {
156     //Avoid mistake of putting 0x0 and can't change twice the sale address
157     require(_sale != 0x0 && sale == 0x0);
158     sale = _sale;
159   }
160 
161   function set_token_address(address _token) onlyOwner {
162     require(_token != 0x0);
163     token = ERC20(_token);
164   }
165 
166   function set_bonus_received(bool _boolean) onlyOwner {
167     bonus_received = _boolean;
168   }
169 
170   function set_allow_refunds(bool _boolean) onlyOwner {
171     /*
172     In case, for some reasons, the project refunds the money
173     */
174     allow_refunds = _boolean;
175   }
176 
177   function set_percent_reduction(uint256 _reduction) onlyOwner {
178       percent_reduction = _reduction;
179   }
180 
181   function change_individual_cap(uint256 _cap) onlyOwner {
182     individual_cap = _cap;
183   }
184 
185   function change_owner(address new_owner) onlyOwner {
186     require(new_owner != 0x0);
187     owner = new_owner;
188   }
189 
190   function change_max_amount(uint256 _amount) onlyOwner {
191       //ATTENTION! The new amount should be in wei
192       //Use https://etherconverter.online/
193       max_amount = SafeMath.div(SafeMath.mul(_amount, 100), 99);
194   }
195 
196   function change_min_amount(uint256 _amount) onlyOwner {
197       //ATTENTION! The new amount should be in wei
198       //Use https://etherconverter.online/
199       min_amount = _amount;
200   }
201 
202   //Public functions
203 
204   // Allows any user to withdraw his tokens.
205   function withdraw() {
206     // Disallow withdraw if tokens haven't been bought yet.
207     require(bought_tokens);
208     uint256 contract_token_balance = token.balanceOf(address(this));
209     // Disallow token withdrawals if there are no tokens to withdraw.
210     require(contract_token_balance != 0);
211     uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], contract_token_balance), contract_eth_value);
212     // Update the value of tokens currently held by the contract.
213     contract_eth_value = SafeMath.sub(contract_eth_value, balances[msg.sender]);
214     // Update the user's balance prior to sending to prevent recursive call.
215     balances[msg.sender] = 0;
216     // Send the funds.  Throws on failure to prevent loss of funds.
217     require(token.transfer(msg.sender, tokens_to_withdraw));
218   }
219 
220   function withdraw_bonus() {
221   /*
222     Special function to withdraw the bonus tokens after the 6 months lockup.
223     bonus_received has to be set to true.
224   */
225     require(bought_tokens && bonus_received);
226     uint256 contract_token_balance = token.balanceOf(address(this));
227     require(contract_token_balance != 0);
228     uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances_bonus[msg.sender], contract_token_balance), contract_eth_value_bonus);
229     contract_eth_value_bonus = SafeMath.sub(contract_eth_value_bonus, balances_bonus[msg.sender]);
230     balances_bonus[msg.sender] = 0;
231     require(token.transfer(msg.sender, tokens_to_withdraw));
232   }
233 
234   // Allows any user to get his eth refunded before the purchase is made.
235   function refund() {
236     require(!bought_tokens && allow_refunds && percent_reduction == 0);
237     //balance of contributor = contribution * 0.99
238     //so contribution = balance/0.99
239     uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], 100), 99);
240     // Update the user's balance prior to sending ETH to prevent recursive call.
241     balances[msg.sender] = 0;
242     //Updates the balances_bonus too
243     balances_bonus[msg.sender] = 0;
244     //Updates the fees variable by substracting the refunded fee
245     fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
246     // Return the user's funds.  Throws on failure to prevent loss of funds.
247     msg.sender.transfer(eth_to_withdraw);
248   }
249 
250   //Allows any user to get a part of his ETH refunded, in proportion
251   //to the % reduced of the allocation
252   function partial_refund() {
253     require(allow_refunds && percent_reduction > 0);
254     //Amount to refund is the amount minus the X% of the reduction
255     //amount_to_refund = balance*X
256     uint256 basic_amount = SafeMath.div(SafeMath.mul(balances[msg.sender], percent_reduction), 100);
257     uint256 eth_to_withdraw = basic_amount;
258     if (!bought_tokens) {
259       //We have to take in account the partial refund of the fee too if the tokens weren't bought yet
260       eth_to_withdraw = SafeMath.div(SafeMath.mul(basic_amount, 100), 99);
261       fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
262     }
263     balances[msg.sender] = SafeMath.sub(balances[msg.sender], eth_to_withdraw);
264     balances_bonus[msg.sender] = balances[msg.sender];
265     msg.sender.transfer(eth_to_withdraw);
266   }
267 
268   // Default function.  Called when a user sends ETH to the contract.
269   function () payable underMaxAmount {
270     require(!bought_tokens);
271     //1% fee is taken on the ETH
272     uint256 fee = SafeMath.div(msg.value, FEE);
273     fees = SafeMath.add(fees, fee);
274     //Updates both of the balances
275     balances[msg.sender] = SafeMath.add(balances[msg.sender], SafeMath.sub(msg.value, fee));
276     //Checks if the individual cap is respected
277     //If it's not, changes are reverted
278     require(individual_cap == 0 || balances[msg.sender] <= individual_cap);
279     balances_bonus[msg.sender] = balances[msg.sender];
280   }
281 }