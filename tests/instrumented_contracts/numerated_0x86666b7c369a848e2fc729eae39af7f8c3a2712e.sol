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
65     uint256 correct_amount = SafeMath.div(SafeMath.mul(min_amount, 100), 99);
66     require(max_amount == 0 || this.balance <= correct_amount);
67     _;
68   }
69 
70   //Constants of the contract
71   uint256 constant FEE = 100;    //1% fee
72   uint256 constant FEE_DEV = SafeMath.div(20, 3); //15% on the 1% fee
73   address public owner;
74   address constant public developer = 0xEE06BdDafFA56a303718DE53A5bc347EfbE4C68f;
75 
76   //Variables subject to changes
77   uint256 public max_amount = 0 ether;  //0 means there is no limit
78   uint256 public min_amount = 0 ether;
79 
80   //Store the amount of ETH deposited by each account.
81   mapping (address => uint256) public balances;
82   mapping (address => uint256) public balances_bonus;
83   // Track whether the contract has bought the tokens yet.
84   bool public bought_tokens = false;
85   // Record ETH value of tokens currently held by contract.
86   uint256 public contract_eth_value;
87   uint256 public contract_eth_value_bonus;
88   //Set by the owner in order to allow the withdrawal of bonus tokens.
89   bool bonus_received;
90   //The address of the contact.
91   address public sale;
92   //Token address
93   ERC20 public token;
94   //Records the fees that have to be sent
95   uint256 fees;
96   //Set by the owner. Allows people to refund totally or partially.
97   bool allow_refunds;
98   //The reduction of the allocation in % | example : 40 -> 40% reduction
99   uint256 percent_reduction;
100   
101   function Moongang(uint256 max, uint256 min) {
102     /*
103     Constructor
104     */
105     owner = msg.sender;
106     max_amount = max;
107     min_amount = min;
108   }
109 
110   //Functions for the owner
111 
112   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
113   function buy_the_tokens() onlyOwner minAmountReached underMaxAmount {
114     require(!bought_tokens);
115     //Avoids burning the funds
116     require(sale != 0x0);
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
130   function set_sale_address(address _sale) onlyOwner {
131     //Avoid mistake of putting 0x0 and can't change twice the sale address
132     require(_sale != 0x0 && sale == 0x0);
133     sale = _sale;
134   }
135 
136   function set_token_address(address _token) onlyOwner {
137     require(_token != 0x0);
138     token = ERC20(_token);
139   }
140 
141   function set_bonus_received(bool _boolean) onlyOwner {
142     bonus_received = _boolean;
143   }
144 
145   function set_allow_refunds(bool _boolean) onlyOwner {
146     /*
147     In case, for some reasons, the project refunds the money
148     */
149     allow_refunds = _boolean;
150   }
151 
152   function set_percent_reduction(uint256 _reduction) onlyOwner {
153       percent_reduction = _reduction;
154   }
155 
156   function change_owner(address new_owner) onlyOwner {
157     require(new_owner != 0x0);
158     owner = new_owner;
159   }
160 
161   function change_max_amount(uint256 _amount) onlyOwner {
162       //ATTENTION! The new amount should be in wei
163       //Use https://etherconverter.online/
164       max_amount = _amount;
165   }
166 
167   function change_min_amount(uint256 _amount) onlyOwner {
168       //ATTENTION! The new amount should be in wei
169       //Use https://etherconverter.online/
170       min_amount = _amount;
171   }
172 
173   //Public functions
174 
175   // Allows any user to withdraw his tokens.
176   function withdraw() {
177     // Disallow withdraw if tokens haven't been bought yet.
178     require(bought_tokens);
179     uint256 contract_token_balance = token.balanceOf(address(this));
180     // Disallow token withdrawals if there are no tokens to withdraw.
181     require(contract_token_balance != 0);
182     uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], contract_token_balance), contract_eth_value);
183     // Update the value of tokens currently held by the contract.
184     contract_eth_value = SafeMath.sub(contract_eth_value, balances[msg.sender]);
185     // Update the user's balance prior to sending to prevent recursive call.
186     balances[msg.sender] = 0;
187     // Send the funds.  Throws on failure to prevent loss of funds.
188     require(token.transfer(msg.sender, tokens_to_withdraw));
189   }
190 
191   function withdraw_bonus() {
192   /*
193     Special function to withdraw the bonus tokens after the 6 months lockup.
194     bonus_received has to be set to true.
195   */
196     require(bought_tokens && bonus_received);
197     uint256 contract_token_balance = token.balanceOf(address(this));
198     require(contract_token_balance != 0);
199     uint256 tokens_to_withdraw = SafeMath.div(SafeMath.mul(balances_bonus[msg.sender], contract_token_balance), contract_eth_value_bonus);
200     contract_eth_value_bonus = SafeMath.sub(contract_eth_value_bonus, balances_bonus[msg.sender]);
201     balances_bonus[msg.sender] = 0;
202     require(token.transfer(msg.sender, tokens_to_withdraw));
203   }
204   
205   // Allows any user to get his eth refunded before the purchase is made.
206   function refund() {
207     require(allow_refunds && percent_reduction == 0);
208     //balance of contributor = contribution * 0.99
209     //so contribution = balance/0.99
210     uint256 eth_to_withdraw = SafeMath.div(SafeMath.mul(balances[msg.sender], 100), 99);
211     // Update the user's balance prior to sending ETH to prevent recursive call.
212     balances[msg.sender] = 0;
213     //Updates the balances_bonus too
214     balances_bonus[msg.sender] = 0;
215     //Updates the fees variable by substracting the refunded fee
216     fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
217     // Return the user's funds.  Throws on failure to prevent loss of funds.
218     msg.sender.transfer(eth_to_withdraw);
219   }
220 
221   //Allows any user to get a part of his ETH refunded, in proportion
222   //to the % reduced of the allocation
223   function partial_refund() {
224     require(allow_refunds && percent_reduction > 0);
225     //Amount to refund is the amount minus the X% of the reduction
226     //amount_to_refund = balance*X
227     uint256 basic_amount = SafeMath.div(SafeMath.mul(balances[msg.sender], percent_reduction), 100);
228     uint256 eth_to_withdraw = basic_amount;
229     if (!bought_tokens) {
230       //We have to take in account the partial refund of the fee too if the tokens weren't bought yet
231       eth_to_withdraw = SafeMath.div(SafeMath.mul(basic_amount, 100), 99);
232       fees = SafeMath.sub(fees, SafeMath.div(eth_to_withdraw, FEE));
233     }
234     balances[msg.sender] = SafeMath.sub(balances[msg.sender], eth_to_withdraw);
235     balances_bonus[msg.sender] = balances[msg.sender];
236     msg.sender.transfer(eth_to_withdraw);
237   }
238 
239   // Default function.  Called when a user sends ETH to the contract.
240   function () payable underMaxAmount {
241     require(!bought_tokens);
242     //1% fee is taken on the ETH
243     uint256 fee = SafeMath.div(msg.value, FEE);
244     fees = SafeMath.add(fees, fee);
245     //Updates both of the balances
246     balances[msg.sender] = SafeMath.add(balances[msg.sender], SafeMath.sub(msg.value, fee));
247     balances_bonus[msg.sender] = balances[msg.sender];
248   }
249 }