1 pragma solidity ^0.4.25;
2 
3 /**
4  * 
5  *                                  ╔╗╔╗╔╗╔══╗╔╗──╔╗──╔══╗╔═══╗──╔╗──╔╗╔═══╗
6  *                                  ║║║║║║║╔╗║║║──║║──╚╗╔╝║╔══╝──║║──║║║╔══╝
7  *                                  ║║║║║║║╚╝║║║──║║───║║─║╚══╗──║╚╗╔╝║║╚══╗
8  *                                  ║║║║║║║╔╗║║║──║║───║║─║╔══╝──║╔╗╔╗║║╔══╝
9  *                                  ║╚╝╚╝║║║║║║╚═╗║╚═╗╔╝╚╗║╚══╗╔╗║║╚╝║║║╚══╗
10  *                                  ╚═╝╚═╝╚╝╚╝╚══╝╚══╝╚══╝╚═══╝╚╝╚╝──╚╝╚═══╝
11  *                                  ┌──────────────────────────────────────┐  
12  *                                  │      Website:  http://wallie.me      │
13  *                                  │                                      │  
14  *                                  │  CN Telegram: https://t.me/WallieCH  │
15  *                                  │  RU Telegram: https://t.me/wallieRU  |
16  *                                  │  *  Telegram: https://t.me/WallieNews|
17  *                                  |Twitter: https://twitter.com/WalliemeO|
18  *                                  └──────────────────────────────────────┘ 
19  *                    | Youtube – https://www.youtube.com/channel/UC1q3sPOlXsaJGrT8k-BZuyw |
20  *
21  *                                     * WALLIE - distribution contract *
22  * 
23  *  - Growth of 1.44% in 24 hours (every 5900 blocks)
24  * 
25  * Distribution: *
26  * - 10% Advertising, promotion
27  * - 10% Referral program
28  * - 3% Cashback
29  * - 5% for developers and technical support
30  *
31  * Usage rules *
32  *  Holding:
33  *   1. Send any amount of ether but not less than 0.01 THD to make a contribution.
34  *   2. Send 0 ETH at any time to get profit from the Deposit.
35  *  
36  *  - You can make a profit at any time. Consider your transaction costs (GAS).
37  *  
38  * Affiliate program *
39  * - You have access to a single-level referral system for additional profit (10% of the referral's contribution).
40  * - * - Affiliate fees will come from each referral's Deposit as long as it doesn't change your wallet address Ethereum on the other.
41  * 1. The depositor in the transfer of funds indicates the DATA in your e-wallet Ethereum.
42  * 2. After successful transfer you will be charged 10% of the amount of his Deposit.
43  * * 3. Your partner receives a "Refback bonus" in the amount of 3% of his contribution.
44  * 
45  *  
46  * 
47  *
48  * RECOMMENDED GAS LIMIT: 250000
49  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
50  *
51  * The contract has been tested for vulnerabilities!
52  *
53  */ 
54 
55 contract WallieInvest{
56 
57     mapping (address => uint256) public invested;
58 
59     mapping (address => uint256) public payments; 
60      
61     mapping (address => address) public investedRef;
62     
63     mapping (address => uint256) public atBlock;
64     
65     mapping (address => uint256) public cashBack;
66     
67     mapping (address => uint256) public cashRef;
68     
69     mapping (address => uint256) public admComiss;
70     
71     using SafeMath for uint;
72     using ToAddress for *;
73     using Zero for *;
74     
75     address private adm_addr; //NB!
76     uint256 private start_block;
77     uint256 private constant dividends = 144;           // 1.44%
78     uint256 private constant adm_comission = 15;        // 15%
79     uint256 private constant ref_bonus = 10;            // 10%
80     uint256 private constant ref_cashback = 3;          // 3%
81     uint256 private constant block_of_24h = 5900;       // ~24 hour
82     uint256 private constant min_invesment = 10 finney; // 0.01 eth
83     
84     //Statistics
85     uint256 private all_invest_users_count = 0;
86     uint256 private all_invest = 0;
87     uint256 private all_payments = 0;
88     uint256 private all_cash_back_payments = 0;
89     uint256 private all_ref_payments = 0;
90     uint256 private all_adm_payments = 0;
91     uint256 private all_reinvest = 0;
92     address private last_invest_addr = 0;
93     uint256 private last_invest_amount = 0;
94     uint256 private last_invest_block = 0;
95     
96     constructor() public {
97     adm_addr = msg.sender;
98     start_block = block.number;
99     }
100     
101     // this function called every time anyone sends a transaction to this contract
102     function() public payable {
103         
104         uint256 amount = 0;
105         
106         // if sender is invested more than 0 ether
107         if (invested[msg.sender] != 0) {
108             
109             // calculate profit:
110             //amount = (amount invested) * 1.44% * (blocks since last transaction) / 5900
111             //amount = invested[msg.sender] * dividends / 10000 * (block.number - atBlock[msg.sender]) / block_of_24h;
112             amount = invested[msg.sender].mul(dividends).div(10000).mul(block.number.sub(atBlock[msg.sender])).div(block_of_24h);
113         }
114         
115 
116         if (msg.value == 0) {
117            
118             // Commission payment
119             if (admComiss[adm_addr] != 0 && msg.sender == adm_addr){
120                 amount = amount.add(admComiss[adm_addr]);
121                 admComiss[adm_addr] = 0;
122                 all_adm_payments += amount;
123                }
124            
125             // Payment of referral fees
126             if (cashRef[msg.sender] != 0){
127                 amount = amount.add(cashRef[msg.sender]);
128                 cashRef[msg.sender] = 0;
129                 all_ref_payments += amount;
130             }
131             
132             // Payment of cashback
133             if (cashBack[msg.sender] != 0){
134                 amount = amount.add(cashBack[msg.sender]);
135                 cashBack[msg.sender] = 0;
136                 all_cash_back_payments += amount;
137                }
138            }
139         else
140            {
141             
142             // Minimum payment
143             require(msg.value >= min_invesment, "msg.value must be >= 0.01 ether (10 finney)");
144                
145             // Enrollment fees
146             admComiss[adm_addr] += msg.value.mul(adm_comission).div(100);
147              
148             address ref_addr = msg.data.toAddr();
149             
150               if (ref_addr.notZero()) {
151                   
152                  //Anti-Cheat mode
153                  require(msg.sender != ref_addr, "referal must be != msg.sender");
154                   
155                  // Referral enrollment
156                  cashRef[ref_addr] += msg.value.mul(ref_bonus).div(100);
157                  
158                  // Securing the referral for the investor
159                  investedRef[msg.sender] = ref_addr;
160                  
161                  // Cashback Enrollment
162                  if (invested[msg.sender] == 0)
163                      cashBack[msg.sender] += msg.value.mul(ref_cashback).div(100);
164                  
165                  }
166                  else
167                  {
168                  // Referral enrollment
169                    if (investedRef[msg.sender].notZero())
170                       cashRef[investedRef[msg.sender]] += msg.value.mul(ref_bonus).div(100);    
171                  }
172                  
173                  
174             if (invested[msg.sender] == 0) all_invest_users_count++;   
175                
176             // investment accounting
177             invested[msg.sender] += msg.value;
178             
179             atBlock[msg.sender] = block.number;
180             
181             // statistics
182             all_invest += msg.value;
183             if (invested[msg.sender] > 0) all_reinvest += msg.value;
184             last_invest_addr = msg.sender;
185             last_invest_amount = msg.value;
186             last_invest_block = block.number;
187             
188            }
189            
190          // record block number and invested amount (msg.value) of this transaction
191          atBlock[msg.sender] = block.number;    
192            
193          if (amount != 0)
194             {
195             // send calculated amount of ether directly to sender (aka YOU)
196             address sender = msg.sender;
197             
198             all_payments += amount;
199             payments[sender] += amount;
200             
201             sender.transfer(amount);
202             }
203    }
204    
205     
206     //Stat
207     //getFundStatsMap
208     function getFundStatsMap() public view returns (uint256[7]){
209     uint256[7] memory stateMap; 
210     stateMap[0] = all_invest_users_count;
211     stateMap[1] = all_invest;
212     stateMap[2] = all_payments;
213     stateMap[3] = all_cash_back_payments;
214     stateMap[4] = all_ref_payments;
215     stateMap[5] = all_adm_payments;
216     stateMap[6] = all_reinvest;
217     return (stateMap); 
218     }
219     
220     //getUserStats
221     function getUserStats(address addr) public view returns (uint256,uint256,uint256,uint256,uint256,uint256,address){
222     return (invested[addr],cashBack[addr],cashRef[addr],atBlock[addr],block.number,payments[addr],investedRef[addr]); 
223     }
224     
225     //getWebStats
226     function getWebStats() public view returns (uint256,uint256,uint256,uint256,address,uint256,uint256){
227     return (all_invest_users_count,address(this).balance,all_invest,all_payments,last_invest_addr,last_invest_amount,last_invest_block); 
228     }
229   
230 }   
231     
232 
233 library SafeMath {
234  
235 
236 /**
237   * @dev Multiplies two numbers, reverts on overflow.
238   */
239   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
240     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
241     // benefit is lost if 'b' is also tested.
242     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
243     if (a == 0) {
244       return 0;
245     }
246 
247     uint256 c = a * b;
248     require(c / a == b);
249 
250     return c;
251   }
252 
253   /**
254   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
255   */
256   function div(uint256 a, uint256 b) internal pure returns (uint256) {
257     require(b > 0); // Solidity only automatically asserts when dividing by 0
258     uint256 c = a / b;
259     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
260 
261     return c;
262   }
263 
264   /**
265   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
266   */
267   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
268     require(b <= a);
269     uint256 c = a - b;
270 
271     return c;
272   }
273 
274   /**
275   * @dev Adds two numbers, reverts on overflow.
276   */
277   function add(uint256 a, uint256 b) internal pure returns (uint256) {
278     uint256 c = a + b;
279     require(c >= a);
280 
281     return c;
282   }
283 
284   /**
285   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
286   * reverts when dividing by zero.
287   */
288   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
289     require(b != 0);
290     return a % b;
291   }
292 }
293 
294 
295 library ToAddress {
296   function toAddr(uint source) internal pure returns(address) {
297     return address(source);
298   }
299 
300   function toAddr(bytes source) internal pure returns(address addr) {
301     assembly { addr := mload(add(source,0x14)) }
302     return addr;
303   }
304 }
305 
306 library Zero {
307   function requireNotZero(uint a) internal pure {
308     require(a != 0, "require not zero");
309   }
310 
311   function requireNotZero(address addr) internal pure {
312     require(addr != address(0), "require not zero address");
313   }
314 
315   function notZero(address addr) internal pure returns(bool) {
316     return !(addr == address(0));
317   }
318 
319   function isZero(address addr) internal pure returns(bool) {
320     return addr == address(0);
321   }
322 }