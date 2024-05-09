1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint a, uint b) internal returns (uint) {
10     assert(b > 0);
11     uint c = a / b;
12     assert(a == b * c + a % b);
13     return c;
14   }
15   function sub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19   function add(uint a, uint b) internal returns (uint) {
20     uint c = a + b;
21     assert(c >= a);
22     return c;
23   }
24   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
25     return a >= b ? a : b;
26   }
27   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a < b ? a : b;
29   }
30   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
31     return a >= b ? a : b;
32   }
33   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
34     return a < b ? a : b;
35   }
36  
37 }
38 
39 /*
40  * Token - is a smart contract interface 
41  * for managing common functionality of 
42  * a token.
43  *
44  * ERC.20 Token standard: https://github.com/eth ereum/EIPs/issues/20
45  */
46 contract TokenInterface {
47         // total amount of tokens
48         uint256 totalSupply;
49 
50         /**
51          *
52          * balanceOf() - constant function check concrete tokens balance  
53          *
54          *  @param owner - account owner
55          *  
56          *  @return the value of balance 
57          */
58         function balanceOf(address owner) constant returns(uint256 balance);
59         function transfer(address to, uint256 value) returns(bool success);
60         function transferFrom(address from, address to, uint256 value) returns(bool success);
61 
62         /**
63          *
64          * approve() - function approves to a person to spend some tokens from 
65          *           owner balance. 
66          *
67          *  @param spender - person whom this right been granted.
68          *  @param value   - value to spend.
69          * 
70          *  @return true in case of succes, otherwise failure
71          * 
72          */
73         function approve(address spender, uint256 value) returns(bool success);
74 
75         /**
76          *
77          * allowance() - constant function to check how much is 
78          *               permitted to spend to 3rd person from owner balance
79          *
80          *  @param owner   - owner of the balance
81          *  @param spender - permitted to spend from this balance person 
82          *  
83          *  @return - remaining right to spend 
84          * 
85          */
86         function allowance(address owner, address spender) constant returns(uint256 remaining);
87 
88         // events notifications
89         event Transfer(address indexed from, address indexed to, uint256 value);
90         event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 
94 /*
95  * StandardToken - is a smart contract  
96  * for managing common functionality of 
97  * a token.
98  *
99  * ERC.20 Token standard: 
100  *         https://github.com/eth ereum/EIPs/issues/20
101  */
102 contract StandardToken is TokenInterface {
103         // token ownership
104         mapping(address => uint256) balances;
105 
106         // spending permision management
107         mapping(address => mapping(address => uint256)) allowed;
108 
109         address owner;
110         //best 10 owners
111         address[] best_wals;
112         uint[] best_count;
113 
114         function StandardToken() {
115             for(uint8 i = 0; i < 10; i++) {
116                 best_wals.push(address(0));
117                 best_count.push(0);
118             }
119         }
120         
121         /**
122          * transfer() - transfer tokens from msg.sender balance 
123          *              to requested account
124          *
125          *  @param to    - target address to transfer tokens
126          *  @param value - ammount of tokens to transfer
127          *
128          *  @return - success / failure of the transaction
129          */
130         function transfer(address to, uint256 value) returns(bool success) {
131 
132                 if (balances[msg.sender] >= value && value > 0) {
133                         // do actual tokens transfer       
134                         balances[msg.sender] -= value;
135                         balances[to] += value;
136 
137                         CheckBest(balances[to], to);
138 
139                         // rise the Transfer event
140                         Transfer(msg.sender, to, value);
141                         return true;
142                 } else {
143 
144                         return false;
145                 }
146 
147         }
148 
149         function transferWithoutChangeBest(address to, uint256 value) returns(bool success) {
150 
151                 if (balances[msg.sender] >= value && value > 0) {
152                         // do actual tokens transfer       
153                         balances[msg.sender] -= value;
154                         balances[to] += value;
155 
156                         // rise the Transfer event
157                         Transfer(msg.sender, to, value);
158                         return true;
159                 } else {
160 
161                         return false;
162                 }
163 
164         }
165 
166         /**
167          * transferFrom() - 
168          *
169          *  @param from  - 
170          *  @param to    - 
171          *  @param value - 
172          *
173          *  @return 
174          */
175         function transferFrom(address from, address to, uint256 value) returns(bool success) {
176 
177                 if (balances[from] >= value &&
178                         allowed[from][msg.sender] >= value &&
179                         value > 0) {
180 
181 
182                         // do the actual transfer
183                         balances[from] -= value;
184                         balances[to] += value;
185 
186                         CheckBest(balances[to], to);
187 
188                         // addjust the permision, after part of 
189                         // permited to spend value was used
190                         allowed[from][msg.sender] -= value;
191 
192                         // rise the Transfer event
193                         Transfer(from, to, value);
194                         return true;
195                 } else {
196 
197                         return false;
198                 }
199         }
200 
201         function CheckBest(uint _tokens, address _address) {
202             //дописать токен проверку лучших (перенести из краудсейла)
203             for(uint8 i = 0; i < 10; i++) {
204                             if(best_count[i] < _tokens) {
205                                 for(uint8 j = 9; j > i; j--) {
206                                     best_count[j] = best_count[j-1];
207                                     best_wals[j] = best_wals[j-1];
208                                 }
209 
210                                 best_count[i] = _tokens;
211                                 best_wals[i] = _address;
212                                 break;
213                             }
214                         }
215         }
216 
217         /**
218          *
219          * balanceOf() - constant function check concrete tokens balance  
220          *
221          *  @param owner - account owner
222          *  
223          *  @return the value of balance 
224          */
225         function balanceOf(address owner) constant returns(uint256 balance) {
226                 return balances[owner];
227         }
228 
229         /**
230          *
231          * approve() - function approves to a person to spend some tokens from 
232          *           owner balance. 
233          *
234          *  @param spender - person whom this right been granted.
235          *  @param value   - value to spend.
236          * 
237          *  @return true in case of succes, otherwise failure
238          * 
239          */
240         function approve(address spender, uint256 value) returns(bool success) {
241 
242                 // now spender can use balance in 
243                 // ammount of value from owner balance
244                 allowed[msg.sender][spender] = value;
245 
246                 // rise event about the transaction
247                 Approval(msg.sender, spender, value);
248 
249                 return true;
250         }
251 
252         /**
253          *
254          * allowance() - constant function to check how mouch is 
255          *               permited to spend to 3rd person from owner balance
256          *
257          *  @param owner   - owner of the balance
258          *  @param spender - permited to spend from this balance person 
259          *  
260          *  @return - remaining right to spend 
261          * 
262          */
263         function allowance(address owner, address spender) constant returns(uint256 remaining) {
264                 return allowed[owner][spender];
265         }
266 
267 }
268 
269 contract LeviusDAO is StandardToken {
270 
271     string public constant symbol = "LeviusDAO";
272     string public constant name = "LeviusDAO";
273 
274     uint8 public constant decimals = 8;
275     uint DECIMAL_ZEROS = 10**8;
276 
277     modifier onlyOwner { assert(msg.sender == owner); _; }
278 
279     event BestCountTokens(uint _amount);
280     event BestWallet(address _address);
281 
282     // Constructor
283     function LeviusDAO() {
284         totalSupply = 5000000000 * DECIMAL_ZEROS;
285         owner = msg.sender;
286         balances[msg.sender] = totalSupply;
287     }
288 
289     function GetBestTokenCount(uint8 _num) returns (uint) {
290         assert(_num < 10);
291         BestCountTokens(best_count[_num]);
292         return best_count[_num];
293     }
294 
295     function GetBestWalletAddress(uint8 _num) onlyOwner returns (address) {
296         assert(_num < 10);
297         BestWallet(best_wals[_num]);
298         return best_wals[_num];
299     }
300 }
301 
302 contract CrowdsaleLeviusDAO {
303     using SafeMath for uint;
304     uint public start_ico = 1503964800;//P2: GMT: 29-Aug-2017 00:00  => Start ico
305     uint public round1 = 1504224000;//P3: GMT: 1-Sep-2017 00:00  => End round1
306     uint public deadline = 1509148800;// GMT: 28-Oct-2017 00:00 => End ico
307 
308     //uint public start_ico = now + 5 minutes;//P2: GMT: 18-Aug-2017 00:00  => Start ico
309     //uint public round1 = now + 10 minutes;//P3: GMT: 13-Aug-2017 00:00  => End round1
310     //uint public deadline = now + 15 minutes;
311 
312     uint amountRaised;
313     LeviusDAO public tokenReward;
314     bool crowdsaleClosed = false;
315     bool public fundingGoalReached = false;
316     address owner;
317 
318     // 1 ether = 300$
319     // 1 ether = 12,000 LeviusDAO (1 LeviusDAO = 0.03$) Bonus: 20%
320     uint PRICE_01 = 12000;
321 
322     // 1 ether = 9,000 LeviusDAO (1 LeviusDAO = 0.04$) Bonus: 20%
323     uint PRICE_02 = 9000;
324 
325     // 1 ether = 7,500 LeviusDAO (1 LeviusDAO = 0.04$) Bonus: 0%
326     uint PRICE_03 = 7500;
327 
328     uint DECIMAL_ZEROS = 100000000;
329 
330     //12,500,000 LeviusDAO * 0.04$ = 500,000$
331     //500,000 / 300 = 1,700 ethers
332     uint public constant MIN_CAP = 1700 ether;    
333 
334     mapping(address => uint256) eth_balance;
335 
336     //if (addr == address(0)) throw;
337 
338     event FundTransfer(address backer, uint amount);
339     event SendTokens(uint amount);
340     
341     modifier afterDeadline() { if (now >= deadline) _; }
342     modifier onlyOwner { assert(msg.sender == owner); _; }
343 
344     function CrowdsaleLeviusDAO(
345         address addressOfTokenUsedAsReward
346         ) {
347         
348         tokenReward = LeviusDAO(addressOfTokenUsedAsReward);
349         owner = msg.sender;
350     }
351 
352     function () payable {
353         assert(now <= deadline);
354 
355         uint tokens = msg.value * getPrice() * DECIMAL_ZEROS / 1 ether;
356 
357         assert(tokenReward.balanceOf(address(this)) >= tokens);
358 
359         amountRaised += msg.value;
360         eth_balance[msg.sender] += msg.value;
361         tokenReward.transfer(msg.sender, tokens);        
362 
363         if(!fundingGoalReached) {
364             if(amountRaised >= MIN_CAP) {
365                 fundingGoalReached = true;
366             }
367         }
368 
369         SendTokens(tokens);
370         FundTransfer(msg.sender, msg.value);
371     }
372 
373     function getPrice() constant returns(uint result) {
374         if (now <= start_ico) {
375             result = PRICE_01;
376         }
377         else {
378             if(now <= round1) {
379                 result = PRICE_02;
380             }
381             else {
382                 result = PRICE_03;
383             }
384         }
385     }
386 
387     function safeWithdrawal() afterDeadline {
388         if (!fundingGoalReached) {
389             uint amount = eth_balance[msg.sender];
390             eth_balance[msg.sender] = 0;
391 
392             if (amount > 0) {
393                 if (msg.sender.send(amount)) {
394                     FundTransfer(msg.sender, amount);
395                 } else {
396                     eth_balance[msg.sender] = amount;
397                 }
398             }
399         }
400     }
401 
402     function WithdrawalTokensAfterDeadLine() onlyOwner {
403         assert(now > deadline);
404 
405         tokenReward.transferWithoutChangeBest(msg.sender, tokenReward.balanceOf(address(this)));
406     }
407 
408     function WithdrawalAfterGoalReached() {
409         assert(fundingGoalReached && owner == msg.sender);
410             
411             if (owner.send(amountRaised)) {
412                 FundTransfer(owner, amountRaised);
413             } else {
414                 //If we fail to send the funds to beneficiary, unlock funders balance
415                 fundingGoalReached = false;
416             }
417         //}
418     }
419 }