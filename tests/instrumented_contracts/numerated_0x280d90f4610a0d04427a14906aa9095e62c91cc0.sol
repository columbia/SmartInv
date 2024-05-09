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
108   function Moongang() {
109     /*
110     Constructor
111     */
112     owner = msg.sender;
113     uint val = 1000 ether;
114     max_amount = SafeMath.div(SafeMath.mul(val, 100), 99);
115     min_amount = 0;
116     individual_cap = 0;
117     //enable whitelist by default
118     whitelist_enabled = false;
119     whitelist[msg.sender] = true;
120   }
121 
122   //Functions for the owner
123 
124   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
125   function buy_the_tokens() onlyOwner minAmountReached underMaxAmount {
126     //Avoids burning the funds
127     require(!bought_tokens && sale != 0x0);
128     //Record that the contract has bought the tokens.
129     bought_tokens = true;
130     //Sends the fee before so the contract_eth_value contains the correct balance
131     uint256 dev_fee = SafeMath.div(fees, FEE_DEV);
132     uint256 audit_fee = SafeMath.div(fees, FEE_AUDIT);
133     owner.transfer(SafeMath.sub(SafeMath.sub(fees, dev_fee), audit_fee));
134     developer.transfer(dev_fee);
135     auditor.transfer(audit_fee);
136     //Record the amount of ETH sent as the contract's current value.
137     contract_eth_value = this.balance;
138     contract_eth_value_bonus = this.balance;
139     // Transfer all the funds to the crowdsale address.
140     sale.transfer(contract_eth_value);
141   }
142 
143   function set_sale_address(address _sale) onlyOwner {
144     //Avoid mistake of putting 0x0 and can't change twice the sale address
145     require(_sale != 0x0);
146     sale = _sale;
147   }
148 
149   function set_token_address(address _token) onlyOwner {
150     require(_token != 0x0);
151     token = ERC20(_token);
152   }
153 
154   function set_bonus_received(bool _boolean) onlyOwner {
155     bonus_received = _boolean;
156   }
157 
158   function set_allow_refunds(bool _boolean) onlyOwner {
159     /*
160     In case, for some reasons, the project refunds the money
161     */
162     allow_refunds = _boolean;
163   }
164 
165   function set_percent_reduction(uint256 _reduction) onlyOwner {
166     require(_reduction <= 100);
167     percent_reduction = _reduction;
168   }
169 
170   function change_individual_cap(uint256 _cap) onlyOwner {
171     individual_cap = _cap;
172   }
173 
174   function change_owner(address new_owner) onlyOwner {
175     require(new_owner != 0x0);
176     owner = new_owner;
177   }
178 
179   function change_max_amount(uint256 _amount) onlyOwner {
180       //ATTENTION! The new amount should be in wei
181       //Use https://etherconverter.online/
182       max_amount = SafeMath.div(SafeMath.mul(_amount, 100), 99);
183   }
184 
185   function change_min_amount(uint256 _amount) onlyOwner {
186       //ATTENTION! The new amount should be in wei
187       //Use https://etherconverter.online/
188       min_amount = _amount;
189   }
190 
191   //Public functions
192 
193   // Allows any user to withdraw his tokens.
194   function withdraw() {
195     // Disallow withdraw if tokens haven't been bought yet.
196     require(bought_tokens);
197     uint256 contract_token_balance = token.balanceOf(address(this));
198     // Disallow token withdrawals if there are no tokens to withdraw.
199     require(contract_token_balance != 0);
200     uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], contract_token_balance), contract_eth_value);
201     // Update the value of tokens currently held by the contract.
202     contract_eth_value = SafeMath.sub(contract_eth_value, balances[msg.sender]);
203     // Update the user's balance prior to sending to prevent recursive call.
204     balances[msg.sender] = 0;
205     // Send the funds.  Throws on failure to prevent loss of funds.
206     require(token.transfer(msg.sender, tokens_to_withdraw));
207   }
208 
209   function withdraw_bonus() {
210   /*
211     Special function to withdraw the bonus tokens after the 6 months lockup.
212     bonus_received has to be set to true.
213   */
214     require(bought_tokens && bonus_received);
215     uint256 contract_token_balance = token.balanceOf(address(this));
216     require(contract_token_balance != 0);
217     uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances_bonus[msg.sender], contract_token_balance), contract_eth_value_bonus);
218     contract_eth_value_bonus = SafeMath.sub(contract_eth_value_bonus, balances_bonus[msg.sender]);
219     balances_bonus[msg.sender] = 0;
220     require(token.transfer(msg.sender, tokens_to_withdraw));
221   }
222 
223   // Allows any user to get his eth refunded before the purchase is made.
224   function refund() {
225     require(!bought_tokens && allow_refunds && percent_reduction == 0);
226     //balance of contributor = contribution * 0.99
227     //so contribution = balance/0.99
228     uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], 100), 99);
229     // Update the user's balance prior to sending ETH to prevent recursive call.
230     balances[msg.sender] = 0;
231     //Updates the balances_bonus too
232     balances_bonus[msg.sender] = 0;
233     //Updates the fees variable by substracting the refunded fee
234     fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
235     // Return the user's funds.  Throws on failure to prevent loss of funds.
236     msg.sender.transfer(eth_to_withdraw);
237   }
238 
239   //Allows any user to get a part of his ETH refunded, in proportion
240   //to the % reduced of the allocation
241   function partial_refund() {
242     require(allow_refunds && percent_reduction > 0);
243     //Amount to refund is the amount minus the X% of the reduction
244     //amount_to_refund = balance*X
245     uint256 basic_amount = SafeMath.div(SafeMath.mul(balances[msg.sender], percent_reduction), 100);
246     uint256 eth_to_withdraw = basic_amount;
247     if (!bought_tokens) {
248       //We have to take in account the partial refund of the fee too if the tokens weren't bought yet
249       eth_to_withdraw = SafeMath.div(SafeMath.mul(basic_amount, 100), 99);
250       fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
251     }
252     balances[msg.sender] = SafeMath.sub(balances[msg.sender], eth_to_withdraw);
253     balances_bonus[msg.sender] = balances[msg.sender];
254     msg.sender.transfer(eth_to_withdraw);
255   }
256 
257   // Default function.  Called when a user sends ETH to the contract.
258   function () payable underMaxAmount {
259     require(!bought_tokens);
260     if (whitelist_enabled) {
261       require(whitelist[msg.sender]);
262     }
263     //1% fee is taken on the ETH
264     uint256 fee = SafeMath.div(msg.value, FEE);
265     fees = SafeMath.add(fees, fee);
266     //Updates both of the balances
267     balances[msg.sender] = SafeMath.add(balances[msg.sender], SafeMath.sub(msg.value, fee));
268     //Checks if the individual cap is respected
269     //If it's not, changes are reverted
270     require(individual_cap == 0 || balances[msg.sender] <= individual_cap);
271     balances_bonus[msg.sender] = balances[msg.sender];
272   }
273 }