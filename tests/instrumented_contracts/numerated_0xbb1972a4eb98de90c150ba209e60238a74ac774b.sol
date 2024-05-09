1 pragma solidity ^0.4.13;
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
65   address developer_address = 0x00119E4b6fC1D931f63FFB26B3EaBE2C4E779533; 
66   //0x650887B33BFA423240ED7Bc4BD26c66075E3bEaf;
67 
68 
69   /* This creates an array with all balances */
70     mapping (address => uint256) public balanceOf;
71     
72     /* This generates a public event on the blockchain that will notify clients */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74     
75     /* Initializes contract with initial supply tokens to the creator of the contract */
76     function ZiberToken() {
77         /* if supply not given then generate 100 million of the smallest unit of the token */
78         _supply = 10000000000;
79         
80         /* Unless you add other functions these variables will never change */
81         balanceOf[msg.sender] = _supply;
82         name = "ZIBER CW Tokens";     
83         symbol = "ZBR";
84         
85         /* If you want a divisible token then add the amount of decimals the base unit has  */
86         decimals = 2;
87     }
88 
89 
90     /// SafeMath contract - math operations with safety checks
91     /// @author dev@smartcontracteam.com
92     function safeMul(uint a, uint b) internal returns (uint) {
93       uint c = a * b;
94       assert(a == 0 || c / a == b);
95       return c;
96     }
97 
98     function safeDiv(uint a, uint b) internal returns (uint) {
99       assert(b > 0);
100       uint c = a / b;
101       assert(a == b * c + a % b);
102       return c;
103     }
104 
105     function safeSub(uint a, uint b) internal returns (uint) {
106       assert(b <= a);
107       return a - b;
108     }
109 
110     function safeAdd(uint a, uint b) internal returns (uint) {
111       uint c = a + b;
112       assert(c>=a && c>=b);
113       return c;
114     }
115 
116     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
117       return a >= b ? a : b;
118     }
119 
120     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
121       return a < b ? a : b;
122     }
123 
124     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
125       return a >= b ? a : b;
126     }
127 
128     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
129       return a < b ? a : b;
130     }
131 
132     function assert(bool assertion) internal {
133       if (!assertion) {
134         throw;
135       }
136     }
137 
138 
139     /**
140     * Allow load refunds back on the contract for the refunding.
141     *
142     * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
143     */
144     function loadRefund() payable {
145       if(msg.value == 0) throw;
146       loadedRefund = safeAdd(loadedRefund, msg.value);
147     }
148 
149     /**
150     * Investors can claim refund.
151     */
152     function refund() private  {
153       uint256 weiValue = this.balance;
154       if (weiValue == 0) throw;
155       uint256 weiRefunded;
156       weiRefunded = safeAdd(weiRefunded, weiValue);
157       refund();
158       if (!msg.sender.send(weiValue)) throw;
159     }
160 
161     /* Send coins */
162     function transfer(address _to, uint256 _value) {
163         /* if the sender doenst have enough balance then stop */
164         if (balanceOf[msg.sender] < _value) throw;
165         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
166         
167         /* Add and subtract new balances */
168         balanceOf[msg.sender] -= _value;
169         balanceOf[_to] += _value;
170         
171         /* Notifiy anyone listening that this transfer took place */
172         Transfer(msg.sender, _to, _value);
173     }
174   
175   // Allows the developer to shut down everything except withdrawals in emergencies.
176   function activate_kill_switch() {
177     // Only allow the developer to activate the kill switch.
178     if (msg.sender != developer_address) throw;
179     // Irreversibly activate the kill switch.
180     kill_switch = true;
181   }
182   
183   // Withdraws all ETH deposited or ZBR purchased by the sender.
184   function withdraw(){
185     // If called before the ICO, cancel caller's participation in the sale.
186     if (!bought_tokens) {
187       // Store the user's balance prior to withdrawal in a temporary variable.
188       uint256 eth_amount = balances[msg.sender];
189       // Update the user's balance prior to sending ETH to prevent recursive call.
190       balances[msg.sender] = 0;
191       // Return the user's funds.  Throws on failure to prevent loss of funds.
192       msg.sender.transfer(eth_amount);
193     }
194     // Withdraw the sender's tokens if the contract has already purchased them.
195     else {
196       // Store the user's ZBR balance in a temporary variable (1 ETHWei -> 2000 ZBRWei).
197       uint256 ZBR_amount = balances[msg.sender] * ZBR_per_eth;
198       // Update the user's balance prior to sending ZBR to prevent recursive call.
199       balances[msg.sender] = 0;
200       // No fee for withdrawing if the user would have made it into the crowdsale alone.
201       uint256 fee = 0;
202       // 1% fee if the user didn't check in during the crowdsale.
203       if (!checked_in[msg.sender]) {
204         fee = ZBR_amount / 100;
205         // Send any non-zero fees to developer.
206         if(!token.transfer(developer_address, fee)) throw;
207       }
208       // Send the user their tokens.  Throws if the crowdsale isn't over.
209       if(!token.transfer(msg.sender, ZBR_amount - fee)) throw;
210     }
211   }
212   
213   // Allow developer to add ETH to the buy execution bounty.
214   function add_to_bounty() payable {
215     // Only allow the developer to contribute to the buy execution bounty.
216     if (msg.sender != developer_address) throw;
217     // Disallow adding to bounty if kill switch is active.
218     if (kill_switch) throw;
219     // Disallow adding to the bounty if contract has already bought the tokens.
220     if (bought_tokens) throw;
221     // Update bounty to include received amount.
222     bounty += msg.value;
223   }
224   
225   // Buys tokens in the crowdsale and rewards the caller, callable by anyone.
226   function claim_bounty(){
227     // Short circuit to save gas if the contract has already bought tokens.
228     if (bought_tokens) return;
229     // Disallow buying into the crowdsale if kill switch is active.
230     if (kill_switch) throw;
231     // Record that the contract has bought the tokens.
232     bought_tokens = true;
233     // Record the time the contract bought the tokens.
234     time_bought = now + 1 days;
235     // Transfer all the funds (less the bounty) to the ZBR crowdsale contract
236     // to buy tokens.  Throws if the crowdsale hasn't started yet or has
237     // already completed, preventing loss of funds.
238     token.proxyPayment.value(this.balance - bounty)(address(this));
239     // Send the caller their bounty for buying tokens for the contract.
240     if(this.balance > ETH_to_end)
241     {
242         msg.sender.transfer(bounty);
243     }
244     else {
245         time_bought = now +  1 days * 9;
246         if(this.balance > ETH_to_end) {
247           msg.sender.transfer(bounty);
248         }
249       }
250   }
251 
252     //Check is msg_sender is contract dev
253   modifier onlyOwner() {
254     if (msg.sender != developer_address) {
255       throw;
256     }
257     _;
258   }
259   
260   // Send fund when ico end
261   function withdrawEth() onlyOwner {        
262         msg.sender.transfer(this.balance);
263   }
264   
265   //Kill contract
266   function kill() onlyOwner {        
267         selfdestruct(developer_address);
268   }
269   
270   // A helper function for the default function, allowing contracts to interact.
271   function default_helper() payable {
272     // Check if ICO Started: 27.07.2017 12:00 GMT to get ETH //1501156800
273     if (now < 1500484506 ) throw; 
274     else {
275       // Treat near-zero ETH transactions as check ins and withdrawal requests.
276       if (msg.value <= 1 finney) {
277         // Check in during the crowdsale.
278         if (bought_tokens) {
279           // Only allow checking in before the crowdsale has reached the cap.
280           if (token.totalEthers() >= token.CAP()) throw;
281           // Mark user as checked in, meaning they would have been able to enter alone.
282           checked_in[msg.sender] = true;
283         }
284         // Withdraw funds if the crowdsale hasn't begun yet or is already over.
285         else {
286           withdraw();
287         }
288       }
289       // Deposit the user's funds for use in purchasing tokens.
290       else {
291         // Disallow deposits if kill switch is active.
292         if (kill_switch) throw;
293         // Only allow deposits if the contract hasn't already purchased the tokens.
294         if (bought_tokens) throw;
295         // Update records of deposited ETH to include the received amount.
296         balances[msg.sender] += msg.value;
297       }
298     }
299   }
300   
301   // Default function.  Called when a user sends ETH to the contract.
302   function () payable {
303     // Delegate to the helper function.
304     default_helper();
305   }
306   
307 }