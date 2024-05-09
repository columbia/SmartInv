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
103 
104   //Internal functions
105   function Moongang(uint256 max, uint256 min, uint256 cap) {
106     /*
107     Constructor
108     */
109     owner = msg.sender;
110     max_amount = SafeMath.div(SafeMath.mul(max, 100), 99);
111     min_amount = min;
112     individual_cap = cap;
113   }
114 
115   //Functions for the owner
116 
117   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
118   function buy_the_tokens() onlyOwner minAmountReached underMaxAmount {
119     //Avoids burning the funds
120     require(!bought_tokens && sale != 0x0);
121     //Record that the contract has bought the tokens.
122     bought_tokens = true;
123     //Sends the fee before so the contract_eth_value contains the correct balance
124     uint256 dev_fee = SafeMath.div(fees, FEE_DEV);
125     uint256 audit_fee = SafeMath.div(fees, FEE_AUDIT);
126     owner.transfer(SafeMath.sub(SafeMath.sub(fees, dev_fee), audit_fee));
127     developer.transfer(dev_fee);
128     auditor.transfer(audit_fee);
129     //Record the amount of ETH sent as the contract's current value.
130     contract_eth_value = this.balance;
131     contract_eth_value_bonus = this.balance;
132     // Transfer all the funds to the crowdsale address.
133     sale.transfer(contract_eth_value);
134   }
135 
136   function force_refund(address _to_refund) onlyOwner {
137     require(!bought_tokens);
138     uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[_to_refund], 100), 99);
139     balances[_to_refund] = 0;
140     balances_bonus[_to_refund] = 0;
141     fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
142     _to_refund.transfer(eth_to_withdraw);
143   }
144 
145   function force_partial_refund(address _to_refund) onlyOwner {
146     require(bought_tokens && percent_reduction > 0);
147     //Amount to refund is the amount minus the X% of the reduction
148     //amount_to_refund = balance*X
149     uint256 amount = SafeMath.div(SafeMath.mul(balances[_to_refund], percent_reduction), 100);
150     balances[_to_refund] = SafeMath.sub(balances[_to_refund], amount);
151     balances_bonus[_to_refund] = balances[_to_refund];
152     if (owner_supplied_eth) {
153       //dev fees aren't refunded, only owner fees
154       uint256 fee = amount.div(FEE).mul(percent_reduction).div(100);
155       amount = amount.add(fee);
156     }
157     _to_refund.transfer(amount);
158   }
159 
160   function set_sale_address(address _sale) onlyOwner {
161     //Avoid mistake of putting 0x0 and can't change twice the sale address
162     require(_sale != 0x0);
163     sale = _sale;
164   }
165 
166   function set_token_address(address _token) onlyOwner {
167     require(_token != 0x0);
168     token = ERC20(_token);
169   }
170 
171   function set_bonus_received(bool _boolean) onlyOwner {
172     bonus_received = _boolean;
173   }
174 
175   function set_allow_refunds(bool _boolean) onlyOwner {
176     /*
177     In case, for some reasons, the project refunds the money
178     */
179     allow_refunds = _boolean;
180   }
181 
182   function set_percent_reduction(uint256 _reduction) onlyOwner payable {
183     require(bought_tokens && _reduction <= 100);
184     percent_reduction = _reduction;
185     if (msg.value > 0) {
186       owner_supplied_eth = true;
187     }
188     //we substract by contract_eth_value*_reduction basically
189     contract_eth_value = contract_eth_value.sub((contract_eth_value.mul(_reduction)).div(100));
190     contract_eth_value_bonus = contract_eth_value;
191   }
192 
193   function change_individual_cap(uint256 _cap) onlyOwner {
194     individual_cap = _cap;
195   }
196 
197   function change_owner(address new_owner) onlyOwner {
198     require(new_owner != 0x0);
199     owner = new_owner;
200   }
201 
202   function change_max_amount(uint256 _amount) onlyOwner {
203       //ATTENTION! The new amount should be in wei
204       //Use https://etherconverter.online/
205       max_amount = SafeMath.div(SafeMath.mul(_amount, 100), 99);
206   }
207 
208   function change_min_amount(uint256 _amount) onlyOwner {
209       //ATTENTION! The new amount should be in wei
210       //Use https://etherconverter.online/
211       min_amount = _amount;
212   }
213 
214   //Public functions
215 
216   // Allows any user to withdraw his tokens.
217   function withdraw() {
218     // Disallow withdraw if tokens haven't been bought yet.
219     require(bought_tokens);
220     uint256 contract_token_balance = token.balanceOf(address(this));
221     // Disallow token withdrawals if there are no tokens to withdraw.
222     require(contract_token_balance != 0);
223     uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], contract_token_balance), contract_eth_value);
224     // Update the value of tokens currently held by the contract.
225     contract_eth_value = SafeMath.sub(contract_eth_value, balances[msg.sender]);
226     // Update the user's balance prior to sending to prevent recursive call.
227     balances[msg.sender] = 0;
228     // Send the funds.  Throws on failure to prevent loss of funds.
229     require(token.transfer(msg.sender, tokens_to_withdraw));
230   }
231 
232   function withdraw_bonus() {
233   /*
234     Special function to withdraw the bonus tokens after the 6 months lockup.
235     bonus_received has to be set to true.
236   */
237     require(bought_tokens && bonus_received);
238     uint256 contract_token_balance = token.balanceOf(address(this));
239     require(contract_token_balance != 0);
240     uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances_bonus[msg.sender], contract_token_balance), contract_eth_value_bonus);
241     contract_eth_value_bonus = SafeMath.sub(contract_eth_value_bonus, balances_bonus[msg.sender]);
242     balances_bonus[msg.sender] = 0;
243     require(token.transfer(msg.sender, tokens_to_withdraw));
244   }
245 
246   // Allows any user to get his eth refunded before the purchase is made.
247   function refund() {
248     require(!bought_tokens && allow_refunds && percent_reduction == 0);
249     //balance of contributor = contribution * 0.99
250     //so contribution = balance/0.99
251     uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], 100), 99);
252     // Update the user's balance prior to sending ETH to prevent recursive call.
253     balances[msg.sender] = 0;
254     //Updates the balances_bonus too
255     balances_bonus[msg.sender] = 0;
256     //Updates the fees variable by substracting the refunded fee
257     fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
258     // Return the user's funds.  Throws on failure to prevent loss of funds.
259     msg.sender.transfer(eth_to_withdraw);
260   }
261 
262   //Allows any user to get a part of his ETH refunded, in proportion
263   //to the % reduced of the allocation
264   function partial_refund() {
265     require(bought_tokens && percent_reduction > 0);
266     //Amount to refund is the amount minus the X% of the reduction
267     //amount_to_refund = balance*X
268     uint256 amount = SafeMath.div(SafeMath.mul(balances[msg.sender], percent_reduction), 100);
269     balances[msg.sender] = SafeMath.sub(balances[msg.sender], amount);
270     balances_bonus[msg.sender] = balances[msg.sender];
271     if (owner_supplied_eth) {
272       //dev fees aren't refunded, only owner fees
273       uint256 fee = amount.div(FEE).mul(percent_reduction).div(100);
274       amount = amount.add(fee);
275     }
276     msg.sender.transfer(amount);
277   }
278 
279   // Default function.  Called when a user sends ETH to the contract.
280   function () payable underMaxAmount {
281     require(!bought_tokens);
282     //1% fee is taken on the ETH
283     uint256 fee = SafeMath.div(msg.value, FEE);
284     fees = SafeMath.add(fees, fee);
285     //Updates both of the balances
286     balances[msg.sender] = SafeMath.add(balances[msg.sender], SafeMath.sub(msg.value, fee));
287     //Checks if the individual cap is respected
288     //If it's not, changes are reverted
289     require(individual_cap == 0 || balances[msg.sender] <= individual_cap);
290     balances_bonus[msg.sender] = balances[msg.sender];
291   }
292 }