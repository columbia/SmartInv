1 pragma solidity ^0.4.11;
2 
3 /*
4 
5   Ziber.io Contract
6   ========================
7   Buys ZBR tokens from the DAO crowdsale on your behalf.
8   Author: /u/Leo
9 
10 */
11 
12 
13 // Interface to ZBR ICO Contract
14 contract DaoToken {
15   uint256 public CAP;
16   uint256 public totalEthers;
17   function proxyPayment(address participant) payable;
18   function transfer(address _to, uint _amount) returns (bool success);
19 }
20 
21 contract ZiberToken {
22   // Store the amount of ETH deposited by each account.
23   mapping (address => uint256) public balances;
24   // Store whether or not each account would have made it into the crowdsale.
25   mapping (address => bool) public checked_in;
26   // Bounty for executing buy.
27   uint256 public bounty;
28   // Track whether the contract has bought the tokens yet.
29   bool public bought_tokens;
30   // Record the time the contract bought the tokens.
31   uint256 public time_bought;
32   // Emergency kill switch in case a critical bug is found.
33   bool public kill_switch;
34   
35   /* Public variables of the token */
36   string public name;
37   string public symbol;
38   uint8 public decimals;
39   
40   // Ratio of ZBR tokens received to ETH contributed
41   // 1.000.000 BGP = 80.000.000 ZBR
42   // 1ETH = 218 BGP (03.07.2017: https://www.coingecko.com/en/price_charts/ethereum/gbp)
43   // 1 ETH = 17440 ZBR
44   uint256 ZBR_per_eth = 17440;
45   //Total ZBR Tokens Reserve
46   uint256 ZBR_total_reserve = 100000000;
47   // ZBR Tokens for Developers
48   uint256 ZBR_dev_reserved = 10000000;
49   // ZBR Tokens for Selling over ICO
50   uint256 ZBR_for_selling = 80000000;
51   // ZBR Tokens for Bounty
52   uint256 ZBR_for_bounty= 10000000;
53   // ETH for activate kill-switch in contract
54   uint256 ETH_to_end = 50000 ether;
55   uint registredTo;
56   uint256 loadedRefund;
57   uint256 _supply;
58   string _name;
59   string _symbol;
60   uint8 _decimals;
61 
62   // The ZBR Token address and sale address are the same.
63   DaoToken public token = DaoToken(0xa9d585CE3B227d69985c3F7A866fE7d0e510da50);
64   // The developer address.
65   address developer_address = 0x650887B33BFA423240ED7Bc4BD26c66075E3bEaf;
66 
67 
68   /* This creates an array with all balances */
69     mapping (address => uint256) public balanceOf;
70     
71     /* This generates a public event on the blockchain that will notify clients */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     
74     /* Initializes contract with initial supply tokens to the creator of the contract */
75     function ZiberToken() {
76         /* if supply not given then generate 100 million of the smallest unit of the token */
77         _supply = 10000000000;
78         
79         /* Unless you add other functions these variables will never change */
80         balanceOf[msg.sender] = _supply;
81         name = "ZIBER Crowdsale Tokens";     
82         symbol = "ZBR";
83         
84         /* If you want a divisible token then add the amount of decimals the base unit has  */
85         decimals = 2;
86     }
87 
88 
89     /// SafeMath contract - math operations with safety checks
90     /// @author dev@smartcontracteam.com
91     function safeMul(uint a, uint b) internal returns (uint) {
92       uint c = a * b;
93       assert(a == 0 || c / a == b);
94       return c;
95     }
96 
97     function safeDiv(uint a, uint b) internal returns (uint) {
98       assert(b > 0);
99       uint c = a / b;
100       assert(a == b * c + a % b);
101       return c;
102     }
103 
104     function safeSub(uint a, uint b) internal returns (uint) {
105       assert(b <= a);
106       return a - b;
107     }
108 
109     function safeAdd(uint a, uint b) internal returns (uint) {
110       uint c = a + b;
111       assert(c>=a && c>=b);
112       return c;
113     }
114 
115     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
116       return a >= b ? a : b;
117     }
118 
119     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
120       return a < b ? a : b;
121     }
122 
123     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
124       return a >= b ? a : b;
125     }
126 
127     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
128       return a < b ? a : b;
129     }
130 
131     function assert(bool assertion) internal {
132       if (!assertion) {
133         throw;
134       }
135     }
136 
137 
138     /**
139     * Allow load refunds back on the contract for the refunding.
140     *
141     * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
142     */
143     function loadRefund() payable {
144       if(msg.value == 0) throw;
145       loadedRefund = safeAdd(loadedRefund, msg.value);
146     }
147 
148     /**
149     * Investors can claim refund.
150     */
151     function refund() private  {
152       uint256 weiValue = this.balance;
153       if (weiValue == 0) throw;
154       uint256 weiRefunded;
155       weiRefunded = safeAdd(weiRefunded, weiValue);
156       refund();
157       if (!msg.sender.send(weiValue)) throw;
158     }
159 
160     /* Send coins */
161     function transfer(address _to, uint256 _value) {
162         /* if the sender doenst have enough balance then stop */
163         if (balanceOf[msg.sender] < _value) throw;
164         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
165         
166         /* Add and subtract new balances */
167         balanceOf[msg.sender] -= _value;
168         balanceOf[_to] += _value;
169         
170         /* Notifiy anyone listening that this transfer took place */
171         Transfer(msg.sender, _to, _value);
172     }
173   
174   // Allows the developer to shut down everything except withdrawals in emergencies.
175   function activate_kill_switch() {
176     // Only allow the developer to activate the kill switch.
177     if (msg.sender != developer_address) throw;
178     // Irreversibly activate the kill switch.
179     kill_switch = true;
180   }
181   
182   // Withdraws all ETH deposited or ZBR purchased by the sender.
183   function withdraw(){
184     // If called before the ICO, cancel caller's participation in the sale.
185     if (!bought_tokens) {
186       // Store the user's balance prior to withdrawal in a temporary variable.
187       uint256 eth_amount = balances[msg.sender];
188       // Update the user's balance prior to sending ETH to prevent recursive call.
189       balances[msg.sender] = 0;
190       // Return the user's funds.  Throws on failure to prevent loss of funds.
191       msg.sender.transfer(eth_amount);
192     }
193     // Withdraw the sender's tokens if the contract has already purchased them.
194     else {
195       // Store the user's ZBR balance in a temporary variable (1 ETHWei -> 2000 ZBRWei).
196       uint256 ZBR_amount = balances[msg.sender] * ZBR_per_eth;
197       // Update the user's balance prior to sending ZBR to prevent recursive call.
198       balances[msg.sender] = 0;
199       // No fee for withdrawing if the user would have made it into the crowdsale alone.
200       uint256 fee = 0;
201       // 1% fee if the user didn't check in during the crowdsale.
202       if (!checked_in[msg.sender]) {
203         fee = ZBR_amount / 100;
204         // Send any non-zero fees to developer.
205         if(!token.transfer(developer_address, fee)) throw;
206       }
207       // Send the user their tokens.  Throws if the crowdsale isn't over.
208       if(!token.transfer(msg.sender, ZBR_amount - fee)) throw;
209     }
210   }
211   
212   // Allow developer to add ETH to the buy execution bounty.
213   function add_to_bounty() payable {
214     // Only allow the developer to contribute to the buy execution bounty.
215     if (msg.sender != developer_address) throw;
216     // Disallow adding to bounty if kill switch is active.
217     if (kill_switch) throw;
218     // Disallow adding to the bounty if contract has already bought the tokens.
219     if (bought_tokens) throw;
220     // Update bounty to include received amount.
221     bounty += msg.value;
222   }
223   
224   // Buys tokens in the crowdsale and rewards the caller, callable by anyone.
225   function claim_bounty(){
226     // Short circuit to save gas if the contract has already bought tokens.
227     if (bought_tokens) return;
228     // Disallow buying into the crowdsale if kill switch is active.
229     if (kill_switch) throw;
230     // Record that the contract has bought the tokens.
231     bought_tokens = true;
232     // Record the time the contract bought the tokens.
233     time_bought = now + 1 days;
234     // Transfer all the funds (less the bounty) to the ZBR crowdsale contract
235     // to buy tokens.  Throws if the crowdsale hasn't started yet or has
236     // already completed, preventing loss of funds.
237     token.proxyPayment.value(this.balance - bounty)(address(this));
238     // Send the caller their bounty for buying tokens for the contract.
239     if(this.balance > ETH_to_end)
240     {
241         msg.sender.transfer(bounty);
242     }
243     else {
244         time_bought = now +  1 days * 9;
245         if(this.balance > ETH_to_end) {
246           msg.sender.transfer(bounty);
247         }
248       }
249   }
250   
251   // A helper function for the default function, allowing contracts to interact.
252   function default_helper() payable {
253     // Treat near-zero ETH transactions as check ins and withdrawal requests.
254     if (msg.value <= 1 finney) {
255       // Check in during the crowdsale.
256       if (bought_tokens) {
257         // Only allow checking in before the crowdsale has reached the cap.
258         if (token.totalEthers() >= token.CAP()) throw;
259         // Mark user as checked in, meaning they would have been able to enter alone.
260         checked_in[msg.sender] = true;
261       }
262       // Withdraw funds if the crowdsale hasn't begun yet or is already over.
263       else {
264         withdraw();
265       }
266     }
267     // Deposit the user's funds for use in purchasing tokens.
268     else {
269       // Disallow deposits if kill switch is active.
270       if (kill_switch) throw;
271       // Only allow deposits if the contract hasn't already purchased the tokens.
272       if (bought_tokens) throw;
273       // Update records of deposited ETH to include the received amount.
274       balances[msg.sender] += msg.value;
275     }
276   }
277   
278   // Default function.  Called when a user sends ETH to the contract.
279   function () payable {
280     // Delegate to the helper function.
281     default_helper();
282   }
283   
284   //Check is msg_sender is contract dev
285   modifier onlyOwner() {
286     if (msg.sender != developer_address) {
287       throw;
288     }
289     _;
290   }
291   
292   // Send fund when ico end
293   function withdrawEth() onlyOwner {        
294         msg.sender.transfer(this.balance);
295   }
296   
297   //Kill contract
298   function kill() onlyOwner {        
299         selfdestruct(developer_address);
300   }
301 }