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
14         uint totalSupplyVar;
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
57         function totalSupply() constant returns(uint256 totalSupply) {
58                 return totalSupplyVar;
59         }
60 
61         // events notifications
62         event Transfer(address indexed from, address indexed to, uint256 value);
63         event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 
67 pragma solidity ^ 0.4 .2;
68 
69 /*
70  * StandardToken - is a smart contract  
71  * for managing common functionality of 
72  * a token.
73  *
74  * ERC.20 Token standard: 
75  *         https://github.com/eth ereum/EIPs/issues/20
76  */
77 contract StandardToken is TokenInterface {
78 
79 
80         // token ownership
81         mapping(address => uint256) balances;
82 
83         // spending permision management
84         mapping(address => mapping(address => uint256)) allowed;
85 
86 
87 
88         function StandardToken() {}
89 
90 
91         /**
92          * transfer() - transfer tokens from msg.sender balance 
93          *              to requested account
94          *
95          *  @param to    - target address to transfer tokens
96          *  @param value - ammount of tokens to transfer
97          *
98          *  @return - success / failure of the transaction
99          */
100         function transfer(address to, uint256 value) returns(bool success) {
101 
102 
103                 if (balances[msg.sender] >= value && value > 0) {
104 
105                         // do actual tokens transfer       
106                         balances[msg.sender] -= value;
107                         balances[to] += value;
108 
109                         // rise the Transfer event
110                         Transfer(msg.sender, to, value);
111                         return true;
112                 } else {
113 
114                         return false;
115                 }
116         }
117 
118 
119 
120 
121         /**
122          * transferFrom() - used to move allowed funds from other owner
123          *                  account 
124          *
125          *  @param from  - move funds from account
126          *  @param to    - move funds to account
127          *  @param value - move the value 
128          *
129          *  @return - return true on success false otherwise 
130          */
131         function transferFrom(address from, address to, uint256 value) returns(bool success) {
132 
133                 if (balances[from] >= value &&
134                         allowed[from][msg.sender] >= value &&
135                         value > 0) {
136 
137 
138                         // do the actual transfer
139                         balances[from] -= value;
140                         balances[to] += value;
141 
142 
143                         // addjust the permision, after part of 
144                         // permited to spend value was used
145                         allowed[from][msg.sender] -= value;
146 
147                         // rise the Transfer event
148                         Transfer(from, to, value);
149                         return true;
150                 } else {
151 
152                         return false;
153                 }
154         }
155 
156 
157 
158 
159         /**
160          *
161          * balanceOf() - constant function check concrete tokens balance  
162          *
163          *  @param owner - account owner
164          *  
165          *  @return the value of balance 
166          */
167         function balanceOf(address owner) constant returns(uint256 balance) {
168                 return balances[owner];
169         }
170 
171 
172 
173         /**
174          *
175          * approve() - function approves to a person to spend some tokens from 
176          *           owner balance. 
177          *
178          *  @param spender - person whom this right been granted.
179          *  @param value   - value to spend.
180          * 
181          *  @return true in case of succes, otherwise failure
182          * 
183          */
184         function approve(address spender, uint256 value) returns(bool success) {
185 
186 
187 
188                 // now spender can use balance in 
189                 // ammount of value from owner balance
190                 allowed[msg.sender][spender] = value;
191 
192                 // rise event about the transaction
193                 Approval(msg.sender, spender, value);
194 
195                 return true;
196         }
197 
198 
199         /**
200          *
201          * allowance() - constant function to check how mouch is 
202          *               permited to spend to 3rd person from owner balance
203          *
204          *  @param owner   - owner of the balance
205          *  @param spender - permited to spend from this balance person 
206          *  
207          *  @return - remaining right to spend 
208          * 
209          */
210         function allowance(address owner, address spender) constant returns(uint256 remaining) {
211                 return allowed[owner][spender];
212         }
213 
214 }
215 
216 
217 pragma solidity ^ 0.4 .0;
218 
219 /**
220  *
221  * @title Hacker Gold
222  * 
223  * The official token powering the hack.ether.camp virtual accelerator.
224  * This is the only way to acquire tokens from startups during the event.
225  *
226  * Whitepaper https://hack.ether.camp/whitepaper
227  *
228  */
229 contract HackerGold is StandardToken {
230 
231         // Name of the token    
232         string public name = "HackerGold";
233 
234         // Decimal places
235         uint8 public decimals = 3;
236         // Token abbreviation        
237         string public symbol = "HKG";
238 
239         // 1 ether = 200 hkg
240         uint BASE_PRICE = 200;
241         // 1 ether = 150 hkg
242         uint MID_PRICE = 150;
243         // 1 ether = 100 hkg
244         uint FIN_PRICE = 100;
245         // Safety cap
246         uint SAFETY_LIMIT = 4000000 ether;
247         // Zeros after the point
248         uint DECIMAL_ZEROS = 1000;
249 
250         // Total value in wei
251         uint totalValue;
252 
253         // Address of multisig wallet holding ether from sale
254         address wallet;
255 
256         // Structure of sale increase milestones
257         struct milestones_struct {
258                 uint p1;
259                 uint p2;
260                 uint p3;
261                 uint p4;
262                 uint p5;
263                 uint p6;
264         }
265         // Milestones instance
266         milestones_struct milestones;
267 
268         /**
269          * Constructor of the contract.
270          * 
271          * Passes address of the account holding the value.
272          * HackerGold contract itself does not hold any value
273          * 
274          * @param multisig address of MultiSig wallet which will hold the value
275          */
276         function HackerGold(address multisig) {
277 
278                 wallet = multisig;
279 
280                 // set time periods for sale
281                 milestones = milestones_struct(
282 
283                         1476972000, // P1: GMT: 20-Oct-2016 14:00  => The Sale Starts
284                         1478181600, // P2: GMT: 03-Nov-2016 14:00  => 1st Price Ladder 
285                         1479391200, // P3: GMT: 17-Nov-2016 14:00  => Price Stable, 
286                         //                                Hackathon Starts
287                         1480600800, // P4: GMT: 01-Dec-2016 14:00  => 2nd Price Ladder
288                         1481810400, // P5: GMT: 15-Dec-2016 14:00  => Price Stable
289                         1482415200 // P6: GMT: 22-Dec-2016 14:00  => Sale Ends, Hackathon Ends
290                 );
291 
292                 // assign recovery balance
293                 totalSupplyVar = 16110893000;
294                 balances[0x342e62732b76875da9305083ea8ae63125a4e667] = 16110893000;
295                 totalValue = 85362 ether;
296         }
297 
298 
299         /**
300          * Fallback function: called on ether sent.
301          * 
302          * It calls to createHKG function with msg.sender 
303          * as a value for holder argument
304          */
305         function() payable {
306                 createHKG(msg.sender);
307         }
308 
309         /**
310          * Creates HKG tokens.
311          * 
312          * Runs sanity checks including safety cap
313          * Then calculates current price by getPrice() function, creates HKG tokens
314          * Finally sends a value of transaction to the wallet
315          * 
316          * Note: due to lack of floating point types in Solidity,
317          * contract assumes that last 3 digits in tokens amount are stood after the point.
318          * It means that if stored HKG balance is 100000, then its real value is 100 HKG
319          * 
320          * @param holder token holder
321          */
322         function createHKG(address holder) payable {
323 
324                 if (now < milestones.p1) throw;
325                 if (now >= milestones.p6) throw;
326                 if (msg.value == 0) throw;
327 
328                 // safety cap
329                 if (getTotalValue() + msg.value > SAFETY_LIMIT) throw;
330 
331                 uint tokens = msg.value * getPrice() * DECIMAL_ZEROS / 1 ether;
332 
333                 totalSupplyVar += tokens;
334                 balances[holder] += tokens;
335                 totalValue += msg.value;
336 
337                 if (!wallet.send(msg.value)) throw;
338         }
339 
340         /**
341          * Denotes complete price structure during the sale.
342          *
343          * @return HKG amount per 1 ETH for the current moment in time
344          */
345         function getPrice() constant returns(uint result) {
346 
347                 if (now < milestones.p1) return 0;
348 
349                 if (now >= milestones.p1 && now < milestones.p2) {
350 
351                         return BASE_PRICE;
352                 }
353 
354                 if (now >= milestones.p2 && now < milestones.p3) {
355 
356                         uint days_in = 1 + (now - milestones.p2) / 1 days;
357                         return BASE_PRICE - days_in * 25 / 7; // daily decrease 3.5
358                 }
359 
360                 if (now >= milestones.p3 && now < milestones.p4) {
361 
362                         return MID_PRICE;
363                 }
364 
365                 if (now >= milestones.p4 && now < milestones.p5) {
366 
367                         days_in = 1 + (now - milestones.p4) / 1 days;
368                         return MID_PRICE - days_in * 25 / 7; // daily decrease 3.5
369                 }
370 
371                 if (now >= milestones.p5 && now < milestones.p6) {
372 
373                         return FIN_PRICE;
374                 }
375 
376                 if (now >= milestones.p6) {
377 
378                         return 0;
379                 }
380 
381         }
382 
383         /**
384          * Returns total stored HKG amount.
385          * 
386          * Contract assumes that last 3 digits of this value are behind the decimal place. i.e. 10001 is 10.001
387          * Thus, result of this function should be divided by 1000 to get HKG value
388          * 
389          * @return result stored HKG amount
390          */
391         function getTotalSupply() constant returns(uint result) {
392                 return totalSupplyVar;
393         }
394 
395         /**
396          * It is used for test purposes.
397          * 
398          * Returns the result of 'now' statement of Solidity language
399          * 
400          * @return unix timestamp for current moment in time
401          */
402         function getNow() constant returns(uint result) {
403                 return now;
404         }
405 
406         /**
407          * Returns total value passed through the contract
408          * 
409          * @return result total value in wei
410          */
411         function getTotalValue() constant returns(uint result) {
412                 return totalValue;
413         }
414 }