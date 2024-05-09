1 pragma solidity ^ 0.4 .0;
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
13         // total amount of tokens
14         uint totalSupply;
15 
16 
17         /**
18          *
19          * balanceOf() - constant function check concrete tokens balance  
20          *
21          *  @param owner - account owner
22          *  
23          *  @return the value of balance 
24          */
25         function balanceOf(address owner) constant returns(uint256 balance);
26 
27         function transfer(address to, uint256 value) returns(bool success);
28 
29         function transferFrom(address from, address to, uint256 value) returns(bool success);
30 
31         /**
32          *
33          * approve() - function approves to a person to spend some tokens from 
34          *           owner balance. 
35          *
36          *  @param spender - person whom this right been granted.
37          *  @param value   - value to spend.
38          * 
39          *  @return true in case of succes, otherwise failure
40          * 
41          */
42         function approve(address spender, uint256 value) returns(bool success);
43 
44         /**
45          *
46          * allowance() - constant function to check how much is 
47          *               permitted to spend to 3rd person from owner balance
48          *
49          *  @param owner   - owner of the balance
50          *  @param spender - permitted to spend from this balance person 
51          *  
52          *  @return - remaining right to spend 
53          * 
54          */
55         function allowance(address owner, address spender) constant returns(uint256 remaining);
56 
57         // events notifications
58         event Transfer(address indexed from, address indexed to, uint256 value);
59         event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 
63 pragma solidity ^ 0.4 .2;
64 
65 /*
66  * StandardToken - is a smart contract  
67  * for managing common functionality of 
68  * a token.
69  *
70  * ERC.20 Token standard: 
71  *         https://github.com/eth ereum/EIPs/issues/20
72  */
73 contract StandardToken is TokenInterface {
74 
75 
76         // token ownership
77         mapping(address => uint256) balances;
78 
79         // spending permision management
80         mapping(address => mapping(address => uint256)) allowed;
81 
82 
83 
84         function StandardToken() {}
85 
86 
87         /**
88          * transfer() - transfer tokens from msg.sender balance 
89          *              to requested account
90          *
91          *  @param to    - target address to transfer tokens
92          *  @param value - ammount of tokens to transfer
93          *
94          *  @return - success / failure of the transaction
95          */
96         function transfer(address to, uint256 value) returns(bool success) {
97 
98 
99                 if (balances[msg.sender] >= value && value > 0) {
100 
101                         // do actual tokens transfer       
102                         balances[msg.sender] -= value;
103                         balances[to] += value;
104 
105                         // rise the Transfer event
106                         Transfer(msg.sender, to, value);
107                         return true;
108                 } else {
109 
110                         return false;
111                 }
112         }
113 
114 
115 
116 
117         /**
118          * transferFrom() - used to move allowed funds from other owner
119          *                  account 
120          *
121          *  @param from  - move funds from account
122          *  @param to    - move funds to account
123          *  @param value - move the value 
124          *
125          *  @return - return true on success false otherwise 
126          */
127         function transferFrom(address from, address to, uint256 value) returns(bool success) {
128 
129                 if (balances[from] >= value &&
130                         allowed[from][msg.sender] >= value &&
131                         value > 0) {
132 
133 
134                         // do the actual transfer
135                         balances[from] -= value;
136                         balances[to] += value;
137 
138 
139                         // addjust the permision, after part of 
140                         // permited to spend value was used
141                         allowed[from][msg.sender] -= value;
142 
143                         // rise the Transfer event
144                         Transfer(from, to, value);
145                         return true;
146                 } else {
147 
148                         return false;
149                 }
150         }
151 
152 
153 
154 
155         /**
156          *
157          * balanceOf() - constant function check concrete tokens balance  
158          *
159          *  @param owner - account owner
160          *  
161          *  @return the value of balance 
162          */
163         function balanceOf(address owner) constant returns(uint256 balance) {
164                 return balances[owner];
165         }
166 
167 
168 
169         /**
170          *
171          * approve() - function approves to a person to spend some tokens from 
172          *           owner balance. 
173          *
174          *  @param spender - person whom this right been granted.
175          *  @param value   - value to spend.
176          * 
177          *  @return true in case of succes, otherwise failure
178          * 
179          */
180         function approve(address spender, uint256 value) returns(bool success) {
181 
182 
183 
184                 // now spender can use balance in 
185                 // ammount of value from owner balance
186                 allowed[msg.sender][spender] = value;
187 
188                 // rise event about the transaction
189                 Approval(msg.sender, spender, value);
190 
191                 return true;
192         }
193 
194         /**
195          *
196          * allowance() - constant function to check how mouch is 
197          *               permited to spend to 3rd person from owner balance
198          *
199          *  @param owner   - owner of the balance
200          *  @param spender - permited to spend from this balance person 
201          *  
202          *  @return - remaining right to spend 
203          * 
204          */
205         function allowance(address owner, address spender) constant returns(uint256 remaining) {
206                 return allowed[owner][spender];
207         }
208 
209 }
210 
211 
212 pragma solidity ^ 0.4 .0;
213 
214 /**
215  *
216  * @title Hacker Gold
217  * 
218  * The official token powering the hack.ether.camp virtual accelerator.
219  * This is the only way to acquire tokens from startups during the event.
220  *
221  * Whitepaper https://hack.ether.camp/whitepaper
222  *
223  */
224 contract HackerGold is StandardToken {
225 
226         // Name of the token    
227         string public name = "HackerGold";
228 
229         // Decimal places
230         uint8 public decimals = 3;
231         // Token abbreviation        
232         string public symbol = "HKG";
233 
234         // 1 ether = 200 hkg
235         uint BASE_PRICE = 200;
236         // 1 ether = 150 hkg
237         uint MID_PRICE = 150;
238         // 1 ether = 100 hkg
239         uint FIN_PRICE = 100;
240         // Safety cap
241         uint SAFETY_LIMIT = 4000000 ether;
242         // Zeros after the point
243         uint DECIMAL_ZEROS = 1000;
244 
245         // Total value in wei
246         uint totalValue;
247 
248         // Address of multisig wallet holding ether from sale
249         address wallet;
250 
251         // Structure of sale increase milestones
252         struct milestones_struct {
253                 uint p1;
254                 uint p2;
255                 uint p3;
256                 uint p4;
257                 uint p5;
258                 uint p6;
259         }
260         // Milestones instance
261         milestones_struct milestones;
262 
263         /**
264          * Constructor of the contract.
265          * 
266          * Passes address of the account holding the value.
267          * HackerGold contract itself does not hold any value
268          * 
269          * @param multisig address of MultiSig wallet which will hold the value
270          */
271         function HackerGold(address multisig) {
272 
273                 wallet = multisig;
274 
275                 // set time periods for sale
276                 milestones = milestones_struct(
277 
278                         1476972000, // P1: GMT: 20-Oct-2016 14:00  => The Sale Starts
279                         1478181600, // P2: GMT: 03-Nov-2016 14:00  => 1st Price Ladder 
280                         1479391200, // P3: GMT: 17-Nov-2016 14:00  => Price Stable, 
281                         //                                Hackathon Starts
282                         1480600800, // P4: GMT: 01-Dec-2016 14:00  => 2nd Price Ladder
283                         1481810400, // P5: GMT: 15-Dec-2016 14:00  => Price Stable
284                         1482415200 // P6: GMT: 22-Dec-2016 14:00  => Sale Ends, Hackathon Ends
285                 );
286 
287                 // assign recovery balance
288                 totalSupply = 16110893000;
289                 balances[0x342e62732b76875da9305083ea8ae63125a4e667] = 16110893000;
290                 totalValue = 85362 ether;
291         }
292 
293 
294         /**
295          * Fallback function: called on ether sent.
296          * 
297          * It calls to createHKG function with msg.sender 
298          * as a value for holder argument
299          */
300         function() payable {
301                 createHKG(msg.sender);
302         }
303 
304         /**
305          * Creates HKG tokens.
306          * 
307          * Runs sanity checks including safety cap
308          * Then calculates current price by getPrice() function, creates HKG tokens
309          * Finally sends a value of transaction to the wallet
310          * 
311          * Note: due to lack of floating point types in Solidity,
312          * contract assumes that last 3 digits in tokens amount are stood after the point.
313          * It means that if stored HKG balance is 100000, then its real value is 100 HKG
314          * 
315          * @param holder token holder
316          */
317         function createHKG(address holder) payable {
318 
319                 if (now < milestones.p1) throw;
320                 if (now >= milestones.p6) throw;
321                 if (msg.value == 0) throw;
322 
323                 // safety cap
324                 if (getTotalValue() + msg.value > SAFETY_LIMIT) throw;
325 
326                 uint tokens = msg.value * getPrice() * DECIMAL_ZEROS / 1 ether;
327 
328                 totalSupply += tokens;
329                 balances[holder] += tokens;
330                 totalValue += msg.value;
331 
332                 if (!wallet.send(msg.value)) throw;
333         }
334 
335         /**
336          * Denotes complete price structure during the sale.
337          *
338          * @return HKG amount per 1 ETH for the current moment in time
339          */
340         function getPrice() constant returns(uint result) {
341 
342                 if (now < milestones.p1) return 0;
343 
344                 if (now >= milestones.p1 && now < milestones.p2) {
345 
346                         return BASE_PRICE;
347                 }
348 
349                 if (now >= milestones.p2 && now < milestones.p3) {
350 
351                         uint days_in = 1 + (now - milestones.p2) / 1 days;
352                         return BASE_PRICE - days_in * 25 / 7; // daily decrease 3.5
353                 }
354 
355                 if (now >= milestones.p3 && now < milestones.p4) {
356 
357                         return MID_PRICE;
358                 }
359 
360                 if (now >= milestones.p4 && now < milestones.p5) {
361 
362                         days_in = 1 + (now - milestones.p4) / 1 days;
363                         return MID_PRICE - days_in * 25 / 7; // daily decrease 3.5
364                 }
365 
366                 if (now >= milestones.p5 && now < milestones.p6) {
367 
368                         return FIN_PRICE;
369                 }
370 
371                 if (now >= milestones.p6) {
372 
373                         return 0;
374                 }
375 
376         }
377 
378         /**
379          * Returns total stored HKG amount.
380          * 
381          * Contract assumes that last 3 digits of this value are behind the decimal place. i.e. 10001 is 10.001
382          * Thus, result of this function should be divided by 1000 to get HKG value
383          * 
384          * @return result stored HKG amount
385          */
386         function getTotalSupply() constant returns(uint result) {
387                 return totalSupply;
388         }
389 
390         /**
391          * It is used for test purposes.
392          * 
393          * Returns the result of 'now' statement of Solidity language
394          * 
395          * @return unix timestamp for current moment in time
396          */
397         function getNow() constant returns(uint result) {
398                 return now;
399         }
400 
401         /**
402          * Returns total value passed through the contract
403          * 
404          * @return result total value in wei
405          */
406         function getTotalValue() constant returns(uint result) {
407                 return totalValue;
408         }
409 }