1 pragma solidity ^0.4.25;
2 
3 /**
4  * RECOMMENDED GAS LIMIT: 250000
5  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
6  *
7  * The contract has been tested for vulnerabilities!
8  *
9  */ 
10 
11 contract ZzzInvest{
12 
13     mapping (address => uint256) public invested;
14 
15     mapping (address => uint256) public payments; 
16      
17     mapping (address => address) public investedRef;
18     
19     mapping (address => uint256) public atBlock;
20 	
21 	mapping (address => uint256) public regBlock;
22 	
23 	mapping (address => uint256) public remaining;
24 	
25 	mapping (address => uint256) public remday;
26     
27     mapping (address => uint256) public cashBack;
28     
29     mapping (address => uint256) public cashRef;
30     
31     mapping (address => uint256) public admComiss;
32     
33     using SafeMath for uint;
34     using ToAddress for *;
35     using Zero for *;
36     
37     address private adm_addr; //NB!
38     uint256 private start_block;
39     uint256 private constant dividends = 2000;           	// 20.00%
40     uint256 private constant adm_comission = 15;        	// 15%
41     uint256 private constant ref_bonus = 10;            	// 10%
42     uint256 private constant ref_cashback = 3;          	// 3%
43     uint256 private constant block_of_24h = 5900;       	// ~24 hour
44 	uint256 private constant block_of_contract = 23600;   // ~24 hour * 365 * 2 4307000
45     uint256 private constant min_invesment = 10 finney; // 0.01 eth
46     
47     //Statistics
48     uint256 private all_invest_users_count = 0;
49     uint256 private all_invest = 0;
50     uint256 private all_payments = 0;
51     uint256 private all_cash_back_payments = 0;
52     uint256 private all_ref_payments = 0;
53     uint256 private all_adm_payments = 0;
54     uint256 private all_reinvest = 0;
55     address private last_invest_addr = 0;
56     uint256 private last_invest_amount = 0;
57     uint256 private last_invest_block = 0;
58     
59     constructor() public {
60     adm_addr = msg.sender;
61     start_block = block.number;
62     }
63     
64     // this function called every time anyone sends a transaction to this contract
65     function() public payable {
66         
67         uint256 amount = 0;
68 		
69 			
70 				// Block Registration
71             if (regBlock[msg.sender] == 0){
72                 regBlock[msg.sender] = block.number; 
73 				remaining[msg.sender] = block_of_contract;
74 				remday[msg.sender] = remaining[msg.sender].div(block_of_24h);
75             }	
76             else
77                  {
78                    remaining[msg.sender] = block_of_contract.sub(block.number).sub(regBlock[msg.sender]);
79 				   remday[msg.sender] = remaining[msg.sender].div(block_of_24h);
80 				   
81                  }
82 			
83 			
84 			if (remaining[msg.sender] == 0){
85                 invested[msg.sender] = 0; 
86                 regBlock[msg.sender] = block.number; 
87 				remaining[msg.sender] = block_of_contract;
88 				remday[msg.sender] = remaining[msg.sender].div(block_of_24h);
89             }
90 			
91 			
92         
93         // if sender is invested more than 0 ether
94         if (invested[msg.sender] != 0 && remaining[msg.sender] != 0){
95 		
96             // calculate profit:
97 //amount = (amount invested) * 20.00% * (blocks since last transaction) / 5900
98 //amount = invested[msg.sender] * dividends / 10000 * (block.number - atBlock[msg.sender]) / block_of_24h;
99 amount = invested[msg.sender].mul(dividends).div(10000).mul(block.number.sub(atBlock[msg.sender])).div(block_of_24h);
100         }
101         
102         if (msg.value == 0) {
103            
104             // Commission payment
105             if (admComiss[adm_addr] != 0 && msg.sender == adm_addr){
106                 amount = amount.add(admComiss[adm_addr]);
107                 admComiss[adm_addr] = 0;
108                 all_adm_payments += amount;
109                }
110            
111             // Payment of referral fees
112             if (cashRef[msg.sender] != 0){
113                 amount = amount.add(cashRef[msg.sender]);
114                 cashRef[msg.sender] = 0;
115                 all_ref_payments += amount;
116             }
117             
118             // Payment of cashback
119             if (cashBack[msg.sender] != 0){
120                 amount = amount.add(cashBack[msg.sender]);
121                 cashBack[msg.sender] = 0;
122                 all_cash_back_payments += amount;
123                }
124            }
125         else
126            {
127             
128             // Minimum payment
129             require(msg.value >= min_invesment, "msg.value must be >= 0.01 ether (10 finney)");
130                
131             // Enrollment fees
132             admComiss[adm_addr] += msg.value.mul(adm_comission).div(100);
133              
134             address ref_addr = msg.data.toAddr();
135             
136               if (ref_addr.notZero()) {
137                   
138                  //Anti-Cheat mode
139                  require(msg.sender != ref_addr, "referal must be != msg.sender");
140                   
141                  // Referral enrollment
142                  cashRef[ref_addr] += msg.value.mul(ref_bonus).div(100);
143                  
144                  // Securing the referral for the investor
145                  investedRef[msg.sender] = ref_addr;
146                  
147                  // Cashback Enrollment
148                  if (invested[msg.sender] == 0)
149                      cashBack[msg.sender] += msg.value.mul(ref_cashback).div(100);
150                  
151                  }
152                  else
153                  {
154                  // Referral enrollment
155                    if (investedRef[msg.sender].notZero())
156                       cashRef[investedRef[msg.sender]] += msg.value.mul(ref_bonus).div(100);    
157                  }
158                  
159                  
160             if (invested[msg.sender] == 0) all_invest_users_count++;   
161                
162             // investment accounting
163             invested[msg.sender] += msg.value;  
164             atBlock[msg.sender] = block.number;
165 			
166             // statistics
167             all_invest += msg.value;
168             if (invested[msg.sender] > 0) all_reinvest += msg.value;
169             last_invest_addr = msg.sender;
170             last_invest_amount = msg.value;
171             last_invest_block = block.number;
172             
173            }
174            
175          // record block number and invested amount (msg.value) of this transaction
176          atBlock[msg.sender] = block.number;    
177            
178          if (amount != 0)
179             {
180             // send calculated amount of ether directly to sender (aka YOU)
181             address sender = msg.sender;
182             
183             all_payments += amount;
184             payments[sender] += amount;
185             
186             sender.transfer(amount);
187             }
188 		
189 		
190 			
191 			
192    }
193    
194     
195     //Stat
196     //getFundStatsMap
197     function getFundStatsMap() public view returns (uint256[7]){
198     uint256[7] memory stateMap; 
199     stateMap[0] = all_invest_users_count;
200     stateMap[1] = all_invest;
201     stateMap[2] = all_payments;
202     stateMap[3] = all_cash_back_payments;
203     stateMap[4] = all_ref_payments;
204     stateMap[5] = all_adm_payments;
205     stateMap[6] = all_reinvest;
206     return (stateMap); 
207     }
208     
209     //getUserStats
210     function getUserStats(address addr) public view returns (uint256,uint256,uint256,uint256,uint256,uint256,address){
211     return (invested[addr],cashBack[addr],cashRef[addr],atBlock[addr],block.number,payments[addr],investedRef[addr]); 
212     }
213 	
214 	//getRemainingDays
215     function getRemainingDays(address addr) public view returns (uint256,uint256,uint256){
216     return (remaining[addr],remday[addr],regBlock[addr]); 
217     }
218     
219     //getWebStats
220     function getWebStats() public view returns (uint256,uint256,uint256,uint256,address,uint256,uint256){
221     return (all_invest_users_count,address(this).balance,all_invest,all_payments,last_invest_addr,last_invest_amount,last_invest_block); 
222     }
223   
224 }   
225     
226 
227 library SafeMath {
228  
229 
230 /**
231   * @dev Multiplies two numbers, reverts on overflow.
232   */
233   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
234     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
235     // benefit is lost if 'b' is also tested.
236     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
237     if (a == 0) {
238       return 0;
239     }
240 
241     uint256 c = a * b;
242     require(c / a == b);
243 
244     return c;
245   }
246 
247   /**
248   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
249   */
250   function div(uint256 a, uint256 b) internal pure returns (uint256) {
251     require(b > 0); // Solidity only automatically asserts when dividing by 0
252     uint256 c = a / b;
253     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
254 
255     return c;
256   }
257 
258   /**
259   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
260   */
261   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
262     require(b <= a);
263     uint256 c = a - b;
264 
265     return c;
266   }
267 
268   /**
269   * @dev Adds two numbers, reverts on overflow.
270   */
271   function add(uint256 a, uint256 b) internal pure returns (uint256) {
272     uint256 c = a + b;
273     require(c >= a);
274 
275     return c;
276   }
277 
278   /**
279   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
280   * reverts when dividing by zero.
281   */
282   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
283     require(b != 0);
284     return a % b;
285   }
286 }
287 
288 
289 library ToAddress {
290   function toAddr(uint source) internal pure returns(address) {
291     return address(source);
292   }
293 
294   function toAddr(bytes source) internal pure returns(address addr) {
295     assembly { addr := mload(add(source,0x14)) }
296     return addr;
297   }
298 }
299 
300 library Zero {
301   function requireNotZero(uint a) internal pure {
302     require(a != 0, "require not zero");
303   }
304 
305   function requireNotZero(address addr) internal pure {
306     require(addr != address(0), "require not zero address");
307   }
308 
309   function notZero(address addr) internal pure returns(bool) {
310     return !(addr == address(0));
311   }
312 
313   function isZero(address addr) internal pure returns(bool) {
314     return addr == address(0);
315   }
316 }