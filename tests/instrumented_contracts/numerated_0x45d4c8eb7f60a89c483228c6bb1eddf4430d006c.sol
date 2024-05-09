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
79   uint256 public max_amount = 1000000000000000000000;  //0 means there is no limit
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
108   function Moongang() {
109     /*
110     Constructor
111     */
112     owner = 0x72b485634DF6f90A7683Beed4ee892299Cf6D1a9;
113     //enable whitelist by default
114     whitelist_enabled = false;
115   }
116 
117   //Functions for the owner
118 
119   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
120   function buy_the_tokens() onlyOwner minAmountReached {
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
148     require(percent_reduction > 0);
149     //Amount to refund is the amount minus the X% of the reduction
150     //amount_to_refund = balance*X
151     uint256 basic_amount = SafeMath.div(SafeMath.mul(balances[_to_refund], percent_reduction), 100);
152     uint256 eth_to_withdraw = basic_amount;
153     if (!bought_tokens) {
154       //We have to take in account the partial refund of the fee too if the tokens weren't bought yet
155       eth_to_withdraw = SafeMath.div(SafeMath.mul(basic_amount, 100), 99);
156       fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
157     }
158     balances[_to_refund] = SafeMath.sub(balances[_to_refund], eth_to_withdraw);
159     balances_bonus[_to_refund] = balances[_to_refund];
160     _to_refund.transfer(eth_to_withdraw);
161   }
162 
163   function whitelist_addys(address[] _addys) onlyOwner {
164     for (uint256 i = 0; i < _addys.length; i++) {
165       whitelist[_addys[i]] = true;
166     }
167   }
168 
169   function blacklist_addys(address[] _addys) onlyOwner {
170     for (uint256 i = 0; i < _addys.length; i++) {
171       whitelist[_addys[i]] = false;
172     }
173   }
174 
175   function set_sale_address(address _sale) onlyOwner {
176     //Avoid mistake of putting 0x0 and can't change twice the sale address
177     require(_sale != 0x0);
178     sale = _sale;
179   }
180 
181   function set_token_address(address _token) onlyOwner {
182     require(_token != 0x0);
183     token = ERC20(_token);
184   }
185 
186   function set_bonus_received(bool _boolean) onlyOwner {
187     bonus_received = _boolean;
188   }
189 
190   function set_allow_refunds(bool _boolean) onlyOwner {
191     /*
192     In case, for some reasons, the project refunds the money
193     */
194     allow_refunds = _boolean;
195   }
196 
197   function set_percent_reduction(uint256 _reduction) onlyOwner {
198     require(_reduction <= 100);
199     percent_reduction = _reduction;
200   }
201 
202   function set_whitelist_enabled(bool _boolean) onlyOwner {
203     whitelist_enabled = _boolean;
204   }
205 
206   function change_individual_cap(uint256 _cap) onlyOwner {
207     individual_cap = _cap;
208   }
209 
210   function change_owner(address new_owner) onlyOwner {
211     require(new_owner != 0x0);
212     owner = new_owner;
213   }
214 
215   function change_max_amount(uint256 _amount) onlyOwner {
216       //ATTENTION! The new amount should be in wei
217       //Use https://etherconverter.online/
218       max_amount = SafeMath.div(SafeMath.mul(_amount, 100), 99);
219   }
220 
221   function change_min_amount(uint256 _amount) onlyOwner {
222       //ATTENTION! The new amount should be in wei
223       //Use https://etherconverter.online/
224       min_amount = _amount;
225   }
226 
227   //Public functions
228 
229   // Allows any user to withdraw his tokens.
230   function withdraw() {
231     // Disallow withdraw if tokens haven't been bought yet.
232     require(bought_tokens);
233     uint256 contract_token_balance = token.balanceOf(address(this));
234     // Disallow token withdrawals if there are no tokens to withdraw.
235     require(contract_token_balance != 0);
236     uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], contract_token_balance), contract_eth_value);
237     // Update the value of tokens currently held by the contract.
238     contract_eth_value = SafeMath.sub(contract_eth_value, balances[msg.sender]);
239     // Update the user's balance prior to sending to prevent recursive call.
240     balances[msg.sender] = 0;
241     // Send the funds.  Throws on failure to prevent loss of funds.
242     require(token.transfer(msg.sender, tokens_to_withdraw));
243   }
244 
245   function withdraw_bonus() {
246   /*
247     Special function to withdraw the bonus tokens after the 6 months lockup.
248     bonus_received has to be set to true.
249   */
250     require(bought_tokens && bonus_received);
251     uint256 contract_token_balance = token.balanceOf(address(this));
252     require(contract_token_balance != 0);
253     uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances_bonus[msg.sender], contract_token_balance), contract_eth_value_bonus);
254     contract_eth_value_bonus = SafeMath.sub(contract_eth_value_bonus, balances_bonus[msg.sender]);
255     balances_bonus[msg.sender] = 0;
256     require(token.transfer(msg.sender, tokens_to_withdraw));
257   }
258 
259   // Allows any user to get his eth refunded before the purchase is made.
260   function refund() {
261     require(!bought_tokens && allow_refunds && percent_reduction == 0);
262     //balance of contributor = contribution * 0.99
263     //so contribution = balance/0.99
264     uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], 100), 99);
265     // Update the user's balance prior to sending ETH to prevent recursive call.
266     balances[msg.sender] = 0;
267     //Updates the balances_bonus too
268     balances_bonus[msg.sender] = 0;
269     //Updates the fees variable by substracting the refunded fee
270     fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
271     // Return the user's funds.  Throws on failure to prevent loss of funds.
272     msg.sender.transfer(eth_to_withdraw);
273   }
274 
275   //Allows any user to get a part of his ETH refunded, in proportion
276   //to the % reduced of the allocation
277   function partial_refund() {
278     require(allow_refunds && percent_reduction > 0);
279     //Amount to refund is the amount minus the X% of the reduction
280     //amount_to_refund = balance*X
281     uint256 basic_amount = SafeMath.div(SafeMath.mul(balances[msg.sender], percent_reduction), 100);
282     uint256 eth_to_withdraw = basic_amount;
283     if (!bought_tokens) {
284       //We have to take in account the partial refund of the fee too if the tokens weren't bought yet
285       eth_to_withdraw = SafeMath.div(SafeMath.mul(basic_amount, 100), 99);
286       fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
287     }
288     balances[msg.sender] = SafeMath.sub(balances[msg.sender], eth_to_withdraw);
289     balances_bonus[msg.sender] = balances[msg.sender];
290     msg.sender.transfer(eth_to_withdraw);
291   }
292 
293   // Default function.  Called when a user sends ETH to the contract.
294   function () payable underMaxAmount {
295     require(!bought_tokens);
296     if (whitelist_enabled) {
297       require(whitelist[msg.sender]);
298     }
299     //1% fee is taken on the ETH
300     uint256 fee = SafeMath.div(msg.value, FEE);
301     fees = SafeMath.add(fees, fee);
302     //Updates both of the balances
303     balances[msg.sender] = SafeMath.add(balances[msg.sender], SafeMath.sub(msg.value, fee));
304     //Checks if the individual cap is respected
305     //If it's not, changes are reverted
306     require(individual_cap == 0 || balances[msg.sender] <= individual_cap);
307     balances_bonus[msg.sender] = balances[msg.sender];
308   }
309 }