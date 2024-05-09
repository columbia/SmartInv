1 pragma solidity ^0.4.25;
2 
3 /**
4  *                                     * OnePerDay - distribution contract *
5  * 
6  *  - Growth of 1% in 24 hours (every 5900 blocks)
7  * 
8  * Distribution: *
9  * - 5% Advertising, promotion
10  * - 5% Referral program
11  * - 5% Cashback
12  * - 5% for developers and technical support
13  *
14  * Usage rules *
15  *  Holding:
16  *   1. Send any amount of ether but not less than 0.01 THD to make a contribution.
17  *   2. Send 0 ETH at any time to get profit from the Deposit.
18  *  
19  *  - You can make a profit at any time. Consider your transaction costs (GAS).
20  *  
21  * Affiliate program *
22   * - * - Affiliate fees will come from each referral's Deposit as long as it doesn't change your wallet address Ethereum on the other.
23  * 1. The depositor in the transfer of funds indicates the DATA in your e-wallet Ethereum.
24  * 2. After successful transfer you will be charged 5% of the amount of his Deposit.
25  * * 3. Your partner receives a "Refback bonus" in the amount of 5% of his contribution.
26  * 
27  *  
28  * 
29  *
30  * RECOMMENDED GAS LIMIT: 250000
31  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
32  *
33  * The contract has been tested for vulnerabilities!
34  *
35  */ 
36 
37 contract oneperday{
38 
39     mapping (address => uint256) public invested;
40 
41     mapping (address => uint256) public payments; 
42      
43     mapping (address => address) public investedRef;
44     
45     mapping (address => uint256) public atBlock;
46     
47     mapping (address => uint256) public cashBack;
48     
49     mapping (address => uint256) public cashRef;
50     
51     mapping (address => uint256) public admComiss;
52     
53     using SafeMath for uint;
54     using ToAddress for *;
55     using Zero for *;
56     
57     address private adm_addr; //NB!
58     uint256 private start_block;
59     uint256 private constant dividends = 100;           // 1%
60     uint256 private constant adm_comission = 10;        // 10%
61     uint256 private constant ref_bonus = 5;            // 5%
62     uint256 private constant ref_cashback = 5;          // 5%
63     uint256 private constant block_of_24h = 5900;       // ~24 hour
64     uint256 private constant min_invesment = 10 finney; // 0.01 eth
65     
66     //Statistics
67     uint256 private all_invest_users_count = 0;
68     uint256 private all_invest = 0;
69     uint256 private all_payments = 0;
70     uint256 private all_cash_back_payments = 0;
71     uint256 private all_ref_payments = 0;
72     uint256 private all_adm_payments = 0;
73     uint256 private all_reinvest = 0;
74     address private last_invest_addr = 0;
75     uint256 private last_invest_amount = 0;
76     uint256 private last_invest_block = 0;
77     
78     constructor() public {
79     adm_addr = msg.sender;
80     start_block = block.number;
81     }
82     
83     // this function called every time anyone sends a transaction to this contract
84     function() public payable {
85         
86         uint256 amount = 0;
87         
88         // if sender is invested more than 0 ether
89         if (invested[msg.sender] != 0) {
90             
91             // calculate profit:
92             //amount = (amount invested) * 1% * (blocks since last transaction) / 5900
93             //amount = invested[msg.sender] * dividends / 10000 * (block.number - atBlock[msg.sender]) / block_of_24h;
94             amount = invested[msg.sender].mul(dividends).div(10000).mul(block.number.sub(atBlock[msg.sender])).div(block_of_24h);
95         }
96         
97 
98         if (msg.value == 0) {
99            
100             // Commission payment
101             if (admComiss[adm_addr] != 0 && msg.sender == adm_addr){
102                 amount = amount.add(admComiss[adm_addr]);
103                 admComiss[adm_addr] = 0;
104                 all_adm_payments += amount;
105                }
106            
107             // Payment of referral fees
108             if (cashRef[msg.sender] != 0){
109                 amount = amount.add(cashRef[msg.sender]);
110                 cashRef[msg.sender] = 0;
111                 all_ref_payments += amount;
112             }
113             
114             // Payment of cashback
115             if (cashBack[msg.sender] != 0){
116                 amount = amount.add(cashBack[msg.sender]);
117                 cashBack[msg.sender] = 0;
118                 all_cash_back_payments += amount;
119                }
120            }
121         else
122            {
123             
124             // Minimum payment
125             require(msg.value >= min_invesment, "msg.value must be >= 0.01 ether (10 finney)");
126                
127             // Enrollment fees
128             admComiss[adm_addr] += msg.value.mul(adm_comission).div(100);
129              
130             address ref_addr = msg.data.toAddr();
131             
132               if (ref_addr.notZero()) {
133                   
134                  //Anti-Cheat mode
135                  require(msg.sender != ref_addr, "referal must be != msg.sender");
136                   
137                  // Referral enrollment
138                  cashRef[ref_addr] += msg.value.mul(ref_bonus).div(100);
139                  
140                  // Securing the referral for the investor
141                  investedRef[msg.sender] = ref_addr;
142                  
143                  // Cashback Enrollment
144                  if (invested[msg.sender] == 0)
145                      cashBack[msg.sender] += msg.value.mul(ref_cashback).div(100);
146                  
147                  }
148                  else
149                  {
150                  // Referral enrollment
151                    if (investedRef[msg.sender].notZero())
152                       cashRef[investedRef[msg.sender]] += msg.value.mul(ref_bonus).div(100);    
153                  }
154                  
155                  
156             if (invested[msg.sender] == 0) all_invest_users_count++;   
157                
158             // investment accounting
159             invested[msg.sender] += msg.value;
160             
161             atBlock[msg.sender] = block.number;
162             
163             // statistics
164             all_invest += msg.value;
165             if (invested[msg.sender] > 0) all_reinvest += msg.value;
166             last_invest_addr = msg.sender;
167             last_invest_amount = msg.value;
168             last_invest_block = block.number;
169             
170            }
171            
172          // record block number and invested amount (msg.value) of this transaction
173          atBlock[msg.sender] = block.number;    
174            
175          if (amount != 0)
176             {
177             // send calculated amount of ether directly to sender (aka YOU)
178             address sender = msg.sender;
179             
180             all_payments += amount;
181             payments[sender] += amount;
182             
183             sender.transfer(amount);
184             }
185    }
186    
187     
188     //Stat
189     //getFundStatsMap
190     function getFundStatsMap() public view returns (uint256[7]){
191     uint256[7] memory stateMap; 
192     stateMap[0] = all_invest_users_count;
193     stateMap[1] = all_invest;
194     stateMap[2] = all_payments;
195     stateMap[3] = all_cash_back_payments;
196     stateMap[4] = all_ref_payments;
197     stateMap[5] = all_adm_payments;
198     stateMap[6] = all_reinvest;
199     return (stateMap); 
200     }
201     
202     //getUserStats
203     function getUserStats(address addr) public view returns (uint256,uint256,uint256,uint256,uint256,uint256,address){
204     return (invested[addr],cashBack[addr],cashRef[addr],atBlock[addr],block.number,payments[addr],investedRef[addr]); 
205     }
206     
207     //getWebStats
208     function getWebStats() public view returns (uint256,uint256,uint256,uint256,address,uint256,uint256){
209     return (all_invest_users_count,address(this).balance,all_invest,all_payments,last_invest_addr,last_invest_amount,last_invest_block); 
210     }
211   
212 }   
213     
214 
215 library SafeMath {
216  
217 
218 /**
219   * @dev Multiplies two numbers, reverts on overflow.
220   */
221   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
222     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
223     // benefit is lost if 'b' is also tested.
224     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
225     if (a == 0) {
226       return 0;
227     }
228 
229     uint256 c = a * b;
230     require(c / a == b);
231 
232     return c;
233   }
234 
235   /**
236   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
237   */
238   function div(uint256 a, uint256 b) internal pure returns (uint256) {
239     require(b > 0); // Solidity only automatically asserts when dividing by 0
240     uint256 c = a / b;
241     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
242 
243     return c;
244   }
245 
246   /**
247   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
248   */
249   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
250     require(b <= a);
251     uint256 c = a - b;
252 
253     return c;
254   }
255 
256   /**
257   * @dev Adds two numbers, reverts on overflow.
258   */
259   function add(uint256 a, uint256 b) internal pure returns (uint256) {
260     uint256 c = a + b;
261     require(c >= a);
262 
263     return c;
264   }
265 
266   /**
267   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
268   * reverts when dividing by zero.
269   */
270   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
271     require(b != 0);
272     return a % b;
273   }
274 }
275 
276 
277 library ToAddress {
278   function toAddr(uint source) internal pure returns(address) {
279     return address(source);
280   }
281 
282   function toAddr(bytes source) internal pure returns(address addr) {
283     assembly { addr := mload(add(source,0x14)) }
284     return addr;
285   }
286 }
287 
288 library Zero {
289   function requireNotZero(uint a) internal pure {
290     require(a != 0, "require not zero");
291   }
292 
293   function requireNotZero(address addr) internal pure {
294     require(addr != address(0), "require not zero address");
295   }
296 
297   function notZero(address addr) internal pure returns(bool) {
298     return !(addr == address(0));
299   }
300 
301   function isZero(address addr) internal pure returns(bool) {
302     return addr == address(0);
303   }
304 }