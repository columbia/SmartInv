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
26  *      dividends  =  1.44%
27  *   adm comission =  1%
28  *   ref bonus     =  1%
29  *   ref cashback  =  3%
30  * 
31  * 
32  * 
33  *
34  * Usage rules *
35  *  Holding:
36  *   1. Send any amount of ether but not less than 0.01 THD to make a contribution.
37  *   2. Send 0 ETH at any time to get profit from the Deposit.
38  *  
39  *  - You can make a profit at any time. Consider your transaction costs (GAS).
40  *  
41  * Affiliate program *
42  * - You have access to a single-level referral system for additional profit (10% of the referral's contribution).
43  * - * - Affiliate fees will come from each referral's Deposit as long as it doesn't change your wallet address Ethereum on the other.
44  * 1. The depositor in the transfer of funds indicates the DATA in your e-wallet Ethereum.
45  * 2. After successful transfer you will be charged 10% of the amount of his Deposit.
46  * * 3. Your partner receives a "Refback bonus" in the amount of 3% of his contribution.
47  * 
48  *  
49  * 
50  *
51  * RECOMMENDED GAS LIMIT: 250000
52  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
53  *
54  * The contract has been tested for vulnerabilities!
55  *
56  */ 
57 
58 contract WallieInvest{
59 
60     mapping (address => uint256) public invested;
61 
62     mapping (address => uint256) public payments; 
63      
64     mapping (address => address) public investedRef;
65     
66     mapping (address => uint256) public atBlock;
67     
68     mapping (address => uint256) public cashBack;
69     
70     mapping (address => uint256) public cashRef;
71     
72     mapping (address => uint256) public admComiss;
73     
74     using SafeMath for uint;
75     using ToAddress for *;
76     using Zero for *;
77     
78     address private adm_addr; //NB!
79     uint256 private start_block;
80     uint256 private constant dividends = 144;           // 1.44%
81     uint256 private constant adm_comission = 1;        // 3%
82     uint256 private constant ref_bonus = 1;            // 3%
83     uint256 private constant ref_cashback = 3;          // 3%
84     uint256 private constant block_of_24h = 5900;       // ~24 hour
85     uint256 private constant min_invesment = 10 finney; // 0.01 eth
86     
87     //Statistics
88     uint256 private all_invest_users_count = 0;
89     uint256 private all_invest = 0;
90     uint256 private all_payments = 0;
91     uint256 private all_cash_back_payments = 0;
92     uint256 private all_ref_payments = 0;
93     uint256 private all_adm_payments = 0;
94     uint256 private all_reinvest = 0;
95     address private last_invest_addr = 0;
96     uint256 private last_invest_amount = 0;
97     uint256 private last_invest_block = 0;
98     
99     constructor() public {
100     adm_addr = msg.sender;
101     start_block = block.number;
102     }
103     
104     // this function called every time anyone sends a transaction to this contract
105     function() public payable {
106         
107         uint256 amount = 0;
108         
109         // if sender is invested more than 0 ether
110         if (invested[msg.sender] != 0) {
111             
112             // calculate profit:
113             //amount = (amount invested) * 1.44% * (blocks since last transaction) / 5900
114             //amount = invested[msg.sender] * dividends / 10000 * (block.number - atBlock[msg.sender]) / block_of_24h;
115             amount = invested[msg.sender].mul(dividends).div(10000).mul(block.number.sub(atBlock[msg.sender])).div(block_of_24h);
116         }
117         
118 
119         if (msg.value == 0) {
120            
121             // Commission payment
122             if (admComiss[adm_addr] != 0 && msg.sender == adm_addr){
123                 amount = amount.add(admComiss[adm_addr]);
124                 admComiss[adm_addr] = 0;
125                 all_adm_payments += amount;
126                }
127            
128             // Payment of referral fees
129             if (cashRef[msg.sender] != 0){
130                 amount = amount.add(cashRef[msg.sender]);
131                 cashRef[msg.sender] = 0;
132                 all_ref_payments += amount;
133             }
134             
135             // Payment of cashback
136             if (cashBack[msg.sender] != 0){
137                 amount = amount.add(cashBack[msg.sender]);
138                 cashBack[msg.sender] = 0;
139                 all_cash_back_payments += amount;
140                }
141            }
142         else
143            {
144             
145             // Minimum payment
146             require(msg.value >= min_invesment, "msg.value must be >= 0.01 ether (10 finney)");
147                
148             // Enrollment fees
149             admComiss[adm_addr] += msg.value.mul(adm_comission).div(100);
150              
151             address ref_addr = msg.data.toAddr();
152             
153               if (ref_addr.notZero()) {
154                   
155                  //Anti-Cheat mode
156                  require(msg.sender != ref_addr, "referal must be != msg.sender");
157                   
158                  // Referral enrollment
159                  cashRef[ref_addr] += msg.value.mul(ref_bonus).div(100);
160                  
161                  // Securing the referral for the investor
162                  investedRef[msg.sender] = ref_addr;
163                  
164                  // Cashback Enrollment
165                  if (invested[msg.sender] == 0)
166                      cashBack[msg.sender] += msg.value.mul(ref_cashback).div(100);
167                  
168                  }
169                  else
170                  {
171                  // Referral enrollment
172                    if (investedRef[msg.sender].notZero())
173                       cashRef[investedRef[msg.sender]] += msg.value.mul(ref_bonus).div(100);    
174                  }
175                  
176                  
177             if (invested[msg.sender] == 0) all_invest_users_count++;   
178                
179             // investment accounting
180             invested[msg.sender] += msg.value;
181             
182             atBlock[msg.sender] = block.number;
183             
184             // statistics
185             all_invest += msg.value;
186             if (invested[msg.sender] > 0) all_reinvest += msg.value;
187             last_invest_addr = msg.sender;
188             last_invest_amount = msg.value;
189             last_invest_block = block.number;
190             
191            }
192            
193          // record block number and invested amount (msg.value) of this transaction
194          atBlock[msg.sender] = block.number;    
195            
196          if (amount != 0)
197             {
198             // send calculated amount of ether directly to sender (aka YOU)
199             address sender = msg.sender;
200             
201             all_payments += amount;
202             payments[sender] += amount;
203             
204             sender.transfer(amount);
205             }
206    }
207    
208     
209     //Stat
210     //getFundStatsMap
211     function getFundStatsMap() public view returns (uint256[7]){
212     uint256[7] memory stateMap; 
213     stateMap[0] = all_invest_users_count;
214     stateMap[1] = all_invest;
215     stateMap[2] = all_payments;
216     stateMap[3] = all_cash_back_payments;
217     stateMap[4] = all_ref_payments;
218     stateMap[5] = all_adm_payments;
219     stateMap[6] = all_reinvest;
220     return (stateMap); 
221     }
222     
223     //getUserStats
224     function getUserStats(address addr) public view returns (uint256,uint256,uint256,uint256,uint256,uint256,address){
225     return (invested[addr],cashBack[addr],cashRef[addr],atBlock[addr],block.number,payments[addr],investedRef[addr]); 
226     }
227     
228     //getWebStats
229     function getWebStats() public view returns (uint256,uint256,uint256,uint256,address,uint256,uint256){
230     return (all_invest_users_count,address(this).balance,all_invest,all_payments,last_invest_addr,last_invest_amount,last_invest_block); 
231     }
232   
233 }   
234     
235 
236 library SafeMath {
237  
238 
239 /**
240   * @dev Multiplies two numbers, reverts on overflow.
241   */
242   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
243     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
244     // benefit is lost if 'b' is also tested.
245     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
246     if (a == 0) {
247       return 0;
248     }
249 
250     uint256 c = a * b;
251     require(c / a == b);
252 
253     return c;
254   }
255 
256   /**
257   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
258   */
259   function div(uint256 a, uint256 b) internal pure returns (uint256) {
260     require(b > 0); // Solidity only automatically asserts when dividing by 0
261     uint256 c = a / b;
262     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
263 
264     return c;
265   }
266 
267   /**
268   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
269   */
270   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
271     require(b <= a);
272     uint256 c = a - b;
273 
274     return c;
275   }
276 
277   /**
278   * @dev Adds two numbers, reverts on overflow.
279   */
280   function add(uint256 a, uint256 b) internal pure returns (uint256) {
281     uint256 c = a + b;
282     require(c >= a);
283 
284     return c;
285   }
286 
287   /**
288   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
289   * reverts when dividing by zero.
290   */
291   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
292     require(b != 0);
293     return a % b;
294   }
295 }
296 
297 
298 library ToAddress {
299   function toAddr(uint source) internal pure returns(address) {
300     return address(source);
301   }
302 
303   function toAddr(bytes source) internal pure returns(address addr) {
304     assembly { addr := mload(add(source,0x14)) }
305     return addr;
306   }
307 }
308 
309 library Zero {
310   function requireNotZero(uint a) internal pure {
311     require(a != 0, "require not zero");
312   }
313 
314   function requireNotZero(address addr) internal pure {
315     require(addr != address(0), "require not zero address");
316   }
317 
318   function notZero(address addr) internal pure returns(bool) {
319     return !(addr == address(0));
320   }
321 
322   function isZero(address addr) internal pure returns(bool) {
323     return addr == address(0);
324   }
325 }