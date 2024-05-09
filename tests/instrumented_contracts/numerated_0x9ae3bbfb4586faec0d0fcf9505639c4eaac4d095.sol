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
51   using SafeMath for uint256;
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
85   // Track whether the contract has bought the tokens yet.
86   bool public bought_tokens;
87   // Record ETH value of tokens currently held by contract.
88   uint256 public contract_eth_value;
89   uint256 public contract_eth_value_bonus;
90   //Set by the owner in order to allow the withdrawal of bonus tokens.
91   bool public bonus_received;
92   //The address of the contact.
93   address public sale;
94   //Token address
95   ERC20 public token;
96   //Records the fees that have to be sent
97   uint256 fees;
98   //Set by the owner. Allows people to refund totally or partially.
99   bool public allow_refunds;
100   //The reduction of the allocation in % | example : 40 -> 40% reduction
101   uint256 public percent_reduction;
102   bool public owner_supplied_eth;
103   bool public allow_contributions;
104 
105   //Internal functions
106   function Moongang(uint256 max, uint256 min, uint256 cap) {
107     /*
108     Constructor
109     */
110     owner = msg.sender;
111     max_amount = SafeMath.div(SafeMath.mul(max, 100), 99);
112     min_amount = min;
113     individual_cap = cap;
114     allow_contributions = true;
115   }
116 
117   //Functions for the owner
118 
119   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
120   function buy_the_tokens() onlyOwner minAmountReached underMaxAmount {
121     //Avoids burning the funds
122     require(!bought_tokens && sale != 0x0);
123     //Record that the contract has bought the tokens.
124     bought_tokens = true;
125     //Sends the fee before so the contract_eth_value contains the correct balance
126     uint256 dev_fee = SafeMath.div(fees, FEE_DEV);
127     uint256 audit_fee = SafeMath.div(fees, FEE_AUDIT);
128     owner.transfer(SafeMath.sub(SafeMath.sub(fees, dev_fee), audit_fee));
129     developer.transfer(dev_fee);
130     auditor.transfer(audit_fee);
131     //Record the amount of ETH sent as the contract's current value.
132     contract_eth_value = this.balance;
133     contract_eth_value_bonus = this.balance;
134     // Transfer all the funds to the crowdsale address.
135     sale.transfer(contract_eth_value);
136   }
137 
138   function force_refund(address _to_refund) onlyOwner {
139     require(!bought_tokens);
140     uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[_to_refund], 100), 99);
141     balances[_to_refund] = 0;
142     balances_bonus[_to_refund] = 0;
143     fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
144     _to_refund.transfer(eth_to_withdraw);
145   }
146 
147   function force_partial_refund(address _to_refund) onlyOwner {
148     require(bought_tokens && percent_reduction > 0);
149     //Amount to refund is the amount minus the X% of the reduction
150     //amount_to_refund = balance*X
151     uint256 amount = SafeMath.div(SafeMath.mul(balances[_to_refund], percent_reduction), 100);
152     balances[_to_refund] = SafeMath.sub(balances[_to_refund], amount);
153     balances_bonus[_to_refund] = balances[_to_refund];
154     if (owner_supplied_eth) {
155       //dev fees aren't refunded, only owner fees
156       uint256 fee = amount.div(FEE).mul(percent_reduction).div(100);
157       amount = amount.add(fee);
158     }
159     _to_refund.transfer(amount);
160   }
161 
162   function set_sale_address(address _sale) onlyOwner {
163     //Avoid mistake of putting 0x0 and can't change twice the sale address
164     require(_sale != 0x0);
165     sale = _sale;
166   }
167 
168   function set_token_address(address _token) onlyOwner {
169     require(_token != 0x0);
170     token = ERC20(_token);
171   }
172 
173   function set_bonus_received(bool _boolean) onlyOwner {
174     bonus_received = _boolean;
175   }
176 
177   function set_allow_refunds(bool _boolean) onlyOwner {
178     /*
179     In case, for some reasons, the project refunds the money
180     */
181     allow_refunds = _boolean;
182   }
183 
184   function set_allow_contributions(bool _boolean) onlyOwner {
185       allow_contributions = _boolean;
186   }
187 
188   function set_percent_reduction(uint256 _reduction) onlyOwner payable {
189     require(bought_tokens && _reduction <= 100);
190     percent_reduction = _reduction;
191     if (msg.value > 0) {
192       owner_supplied_eth = true;
193     }
194     //we substract by contract_eth_value*_reduction basically
195     contract_eth_value = contract_eth_value.sub((contract_eth_value.mul(_reduction)).div(100));
196     contract_eth_value_bonus = contract_eth_value;
197   }
198 
199   function change_individual_cap(uint256 _cap) onlyOwner {
200     individual_cap = _cap;
201   }
202 
203   function change_owner(address new_owner) onlyOwner {
204     require(new_owner != 0x0);
205     owner = new_owner;
206   }
207 
208   function change_max_amount(uint256 _amount) onlyOwner {
209       //ATTENTION! The new amount should be in wei
210       //Use https://etherconverter.online/
211       max_amount = SafeMath.div(SafeMath.mul(_amount, 100), 99);
212   }
213 
214   function change_min_amount(uint256 _amount) onlyOwner {
215       //ATTENTION! The new amount should be in wei
216       //Use https://etherconverter.online/
217       min_amount = _amount;
218   }
219 
220   //Public functions
221 
222   // Allows any user to withdraw his tokens.
223   function withdraw() {
224     // Disallow withdraw if tokens haven't been bought yet.
225     require(bought_tokens);
226     uint256 contract_token_balance = token.balanceOf(address(this));
227     // Disallow token withdrawals if there are no tokens to withdraw.
228     require(contract_token_balance != 0);
229     uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], contract_token_balance), contract_eth_value);
230     // Update the value of tokens currently held by the contract.
231     contract_eth_value = SafeMath.sub(contract_eth_value, balances[msg.sender]);
232     // Update the user's balance prior to sending to prevent recursive call.
233     balances[msg.sender] = 0;
234     // Send the funds.  Throws on failure to prevent loss of funds.
235     require(token.transfer(msg.sender, tokens_to_withdraw));
236   }
237 
238   function withdraw_bonus() {
239   /*
240     Special function to withdraw the bonus tokens after the 6 months lockup.
241     bonus_received has to be set to true.
242   */
243     require(bought_tokens && bonus_received);
244     uint256 contract_token_balance = token.balanceOf(address(this));
245     require(contract_token_balance != 0);
246     uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances_bonus[msg.sender], contract_token_balance), contract_eth_value_bonus);
247     contract_eth_value_bonus = SafeMath.sub(contract_eth_value_bonus, balances_bonus[msg.sender]);
248     balances_bonus[msg.sender] = 0;
249     require(token.transfer(msg.sender, tokens_to_withdraw));
250   }
251 
252   // Allows any user to get his eth refunded before the purchase is made.
253   function refund() {
254     require(!bought_tokens && allow_refunds && percent_reduction == 0);
255     //balance of contributor = contribution * 0.99
256     //so contribution = balance/0.99
257     uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], 100), 99);
258     // Update the user's balance prior to sending ETH to prevent recursive call.
259     balances[msg.sender] = 0;
260     //Updates the balances_bonus too
261     balances_bonus[msg.sender] = 0;
262     //Updates the fees variable by substracting the refunded fee
263     fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
264     // Return the user's funds.  Throws on failure to prevent loss of funds.
265     msg.sender.transfer(eth_to_withdraw);
266   }
267 
268   //Allows any user to get a part of his ETH refunded, in proportion
269   //to the % reduced of the allocation
270   function partial_refund() {
271     require(bought_tokens && percent_reduction > 0);
272     //Amount to refund is the amount minus the X% of the reduction
273     //amount_to_refund = balance*X
274     uint256 amount = SafeMath.div(SafeMath.mul(balances[msg.sender], percent_reduction), 100);
275     balances[msg.sender] = SafeMath.sub(balances[msg.sender], amount);
276     balances_bonus[msg.sender] = balances[msg.sender];
277     if (owner_supplied_eth) {
278       //dev fees aren't refunded, only owner fees
279       uint256 fee = amount.div(FEE).mul(percent_reduction).div(100);
280       amount = amount.add(fee);
281     }
282     msg.sender.transfer(amount);
283   }
284 
285   // Default function.  Called when a user sends ETH to the contract.
286   function () payable underMaxAmount {
287     require(!bought_tokens && allow_contributions);
288     //1% fee is taken on the ETH
289     uint256 fee = SafeMath.div(msg.value, FEE);
290     fees = SafeMath.add(fees, fee);
291     //Updates both of the balances
292     balances[msg.sender] = SafeMath.add(balances[msg.sender], SafeMath.sub(msg.value, fee));
293     //Checks if the individual cap is respected
294     //If it's not, changes are reverted
295     require(individual_cap == 0 || balances[msg.sender] <= individual_cap);
296     balances_bonus[msg.sender] = balances[msg.sender];
297   }
298 }