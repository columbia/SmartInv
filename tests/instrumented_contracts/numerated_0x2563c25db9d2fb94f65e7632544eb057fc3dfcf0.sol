1 pragma solidity ^0.4.0;
2 
3 /*
4  * Token - is a smart contract interface 
5  * for managing common functionality of 
6  * a token.
7  *
8  * ERC.20 Token standard: https://github.com/eth ereum/EIPs/issues/20
9  */
10 contract TokenInterface {
11 
12         
13     // total amount of tokens
14     uint totalSupply;
15 
16     
17     /**
18      *
19      * balanceOf() - constant function check concrete tokens balance  
20      *
21      *  @param owner - account owner
22      *  
23      *  @return the value of balance 
24      */                               
25     function balanceOf(address owner) constant returns (uint256 balance);
26     
27     function transfer(address to, uint256 value) returns (bool success);
28 
29     function transferFrom(address from, address to, uint256 value) returns (bool success);
30 
31     /**
32      *
33      * approve() - function approves to a person to spend some tokens from 
34      *           owner balance. 
35      *
36      *  @param spender - person whom this right been granted.
37      *  @param value   - value to spend.
38      * 
39      *  @return true in case of succes, otherwise failure
40      * 
41      */
42     function approve(address spender, uint256 value) returns (bool success);
43 
44     /**
45      *
46      * allowance() - constant function to check how much is 
47      *               permitted to spend to 3rd person from owner balance
48      *
49      *  @param owner   - owner of the balance
50      *  @param spender - permitted to spend from this balance person 
51      *  
52      *  @return - remaining right to spend 
53      * 
54      */
55     function allowance(address owner, address spender) constant returns (uint256 remaining);
56 
57     // events notifications
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 /*
63  * StandardToken - is a smart contract  
64  * for managing common functionality of 
65  * a token.
66  *
67  * ERC.20 Token standard: 
68  *         https://github.com/eth ereum/EIPs/issues/20
69  */
70 contract StandardToken is TokenInterface {
71 
72 
73     // token ownership
74     mapping (address => uint256) balances;
75 
76     // spending permision management
77     mapping (address => mapping (address => uint256)) allowed;
78     
79     
80     
81     function StandardToken(){
82     }
83     
84     
85     /**
86      * transfer() - transfer tokens from msg.sender balance 
87      *              to requested account
88      *
89      *  @param to    - target address to transfer tokens
90      *  @param value - ammount of tokens to transfer
91      *
92      *  @return - success / failure of the transaction
93      */    
94     function transfer(address to, uint256 value) returns (bool success) {
95         
96         
97         if (balances[msg.sender] >= value && value > 0) {
98 
99             // do actual tokens transfer       
100             balances[msg.sender] -= value;
101             balances[to]         += value;
102             
103             // rise the Transfer event
104             Transfer(msg.sender, to, value);
105             return true;
106         } else {
107             
108             return false; 
109         }
110     }
111     
112     
113 
114     
115     /**
116      * transferFrom() - 
117      *
118      *  @param from  - 
119      *  @param to    - 
120      *  @param value - 
121      *
122      *  @return 
123      */
124     function transferFrom(address from, address to, uint256 value) returns (bool success) {
125     
126         if ( balances[from] >= value && 
127              allowed[from][msg.sender] >= value && 
128              value > 0) {
129                                           
130     
131             // do the actual transfer
132             balances[from] -= value;    
133             balances[to] =+ value;            
134             
135 
136             // addjust the permision, after part of 
137             // permited to spend value was used
138             allowed[from][msg.sender] -= value;
139             
140             // rise the Transfer event
141             Transfer(from, to, value);
142             return true;
143         } else { 
144             
145             return false; 
146         }
147     }
148 
149     
150 
151     
152     /**
153      *
154      * balanceOf() - constant function check concrete tokens balance  
155      *
156      *  @param owner - account owner
157      *  
158      *  @return the value of balance 
159      */                               
160     function balanceOf(address owner) constant returns (uint256 balance) {
161         return balances[owner];
162     }
163 
164     
165     
166     /**
167      *
168      * approve() - function approves to a person to spend some tokens from 
169      *           owner balance. 
170      *
171      *  @param spender - person whom this right been granted.
172      *  @param value   - value to spend.
173      * 
174      *  @return true in case of succes, otherwise failure
175      * 
176      */
177     function approve(address spender, uint256 value) returns (bool success) {
178         
179         // now spender can use balance in 
180         // ammount of value from owner balance
181         allowed[msg.sender][spender] = value;
182         
183         // rise event about the transaction
184         Approval(msg.sender, spender, value);
185         
186         return true;
187     }
188 
189     /**
190      *
191      * allowance() - constant function to check how mouch is 
192      *               permited to spend to 3rd person from owner balance
193      *
194      *  @param owner   - owner of the balance
195      *  @param spender - permited to spend from this balance person 
196      *  
197      *  @return - remaining right to spend 
198      * 
199      */
200     function allowance(address owner, address spender) constant returns (uint256 remaining) {
201       return allowed[owner][spender];
202     }
203 
204 }
205 
206 /**
207  *
208  * @title Hacker Gold
209  * 
210  * The official token powering the hack.ether.camp virtual accelerator.
211  * This is the only way to acquire tokens from startups during the event.
212  *
213  * Whitepaper https://hack.ether.camp/whitepaper
214  *
215  */
216 contract HackerGold is StandardToken {
217 
218     // Name of the token    
219     string public name = "HackerGold";
220 
221     // Decimal places
222     uint8  public decimals = 3;
223     // Token abbreviation        
224     string public symbol = "HKG";
225     
226     // 1 ether = 200 hkg
227     uint BASE_PRICE = 200;
228     // 1 ether = 150 hkg
229     uint MID_PRICE = 150;
230     // 1 ether = 100 hkg
231     uint FIN_PRICE = 100;
232     // Safety cap
233     uint SAFETY_LIMIT = 4000000 ether;
234     // Zeros after the point
235     uint DECIMAL_ZEROS = 1000;
236     
237     // Total value in wei
238     uint totalValue;
239     
240     // Address of multisig wallet holding ether from sale
241     address wallet;
242 
243     // Structure of sale increase milestones
244     struct milestones_struct {
245       uint p1;
246       uint p2; 
247       uint p3;
248       uint p4;
249       uint p5;
250       uint p6;
251     }
252     // Milestones instance
253     milestones_struct milestones;
254     
255     /**
256      * Constructor of the contract.
257      * 
258      * Passes address of the account holding the value.
259      * HackerGold contract itself does not hold any value
260      * 
261      * @param multisig address of MultiSig wallet which will hold the value
262      */
263     function HackerGold(address multisig) {
264         
265         wallet = multisig;
266 
267         // set time periods for sale
268         milestones = milestones_struct(
269         
270           1476799200,  // P1: GMT: 18-Oct-2016 14:00  => The Sale Starts
271           1478181600,  // P2: GMT: 03-Nov-2016 14:00  => 1st Price Ladder 
272           1479391200,  // P3: GMT: 17-Nov-2016 14:00  => Price Stable, 
273                        //                                Hackathon Starts
274           1480600800,  // P4: GMT: 01-Dec-2016 14:00  => 2nd Price Ladder
275           1481810400,  // P5: GMT: 15-Dec-2016 14:00  => Price Stable
276           1482415200   // P6: GMT: 22-Dec-2016 14:00  => Sale Ends, Hackathon Ends
277         );
278                 
279     }
280     
281     
282     /**
283      * Fallback function: called on ether sent.
284      * 
285      * It calls to createHKG function with msg.sender 
286      * as a value for holder argument
287      */
288     function () payable {
289         createHKG(msg.sender);
290     }
291     
292     /**
293      * Creates HKG tokens.
294      * 
295      * Runs sanity checks including safety cap
296      * Then calculates current price by getPrice() function, creates HKG tokens
297      * Finally sends a value of transaction to the wallet
298      * 
299      * Note: due to lack of floating point types in Solidity,
300      * contract assumes that last 3 digits in tokens amount are stood after the point.
301      * It means that if stored HKG balance is 100000, then its real value is 100 HKG
302      * 
303      * @param holder token holder
304      */
305     function createHKG(address holder) payable {
306         
307         if (now < milestones.p1) throw;
308         if (now >= milestones.p6) throw;
309         if (msg.value == 0) throw;
310     
311         // safety cap
312         if (getTotalValue() + msg.value > SAFETY_LIMIT) throw; 
313     
314         uint tokens = msg.value * getPrice() * DECIMAL_ZEROS / 1 ether;
315 
316         totalSupply += tokens;
317         balances[holder] += tokens;
318         totalValue += msg.value;
319         
320         if (!wallet.send(msg.value)) throw;
321     }
322     
323     /**
324      * Denotes complete price structure during the sale.
325      *
326      * @return HKG amount per 1 ETH for the current moment in time
327      */
328     function getPrice() constant returns (uint result) {
329         
330         if (now < milestones.p1) return 0;
331         
332         if (now >= milestones.p1 && now < milestones.p2) {
333         
334             return BASE_PRICE;
335         }
336         
337         if (now >= milestones.p2 && now < milestones.p3) {
338             
339             uint days_in = 1 + (now - milestones.p2) / 1 days; 
340             return BASE_PRICE - days_in * 25 / 7;  // daily decrease 3.5
341         }
342 
343         if (now >= milestones.p3 && now < milestones.p4) {
344         
345             return MID_PRICE;
346         }
347         
348         if (now >= milestones.p4 && now < milestones.p5) {
349             
350             days_in = 1 + (now - milestones.p4) / 1 days; 
351             return MID_PRICE - days_in * 25 / 7;  // daily decrease 3.5
352         }
353 
354         if (now >= milestones.p5 && now < milestones.p6) {
355         
356             return FIN_PRICE;
357         }
358         
359         if (now >= milestones.p6){
360 
361             return 0;
362         }
363 
364      }
365     
366     /**
367      * Returns total stored HKG amount.
368      * 
369      * Contract assumes that last 3 digits of this value are behind the decimal place. i.e. 10001 is 10.001
370      * Thus, result of this function should be divided by 1000 to get HKG value
371      * 
372      * @return result stored HKG amount
373      */
374     function getTotalSupply() constant returns (uint result) {
375         return totalSupply;
376     } 
377 
378     /**
379      * It is used for test purposes.
380      * 
381      * Returns the result of 'now' statement of Solidity language
382      * 
383      * @return unix timestamp for current moment in time
384      */
385     function getNow() constant returns (uint result) {
386         return now;
387     }
388 
389     /**
390      * Returns total value passed through the contract
391      * 
392      * @return result total value in wei
393      */
394     function getTotalValue() constant returns (uint result) {
395         return totalValue;  
396     }
397 }