1 pragma solidity 0.4.19;
2 
3 
4 contract Ownable {
5 address public owner;
6 
7 
8 event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10 
11 /**
12 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13 * account.
14 */
15 function Ownable() public {
16 owner = msg.sender;
17 }
18 
19 
20 /**
21 * @dev Throws if called by any account other than the owner.
22 */
23 modifier onlyOwner() {
24 require(msg.sender == owner);
25 _;
26 }
27 
28 
29 /**
30 * @dev Allows the current owner to transfer control of the contract to a newOwner.
31 * @param newOwner The address to transfer ownership to.
32 */
33 function transferOwnership(address newOwner) public onlyOwner {
34 require(newOwner != address(0));
35 OwnershipTransferred(owner, newOwner);
36 owner = newOwner;
37 }
38 
39 }
40 
41 /**
42 * @title Pausable
43 * @dev Base contract which allows children to implement an emergency stop mechanism.
44 */
45 contract Pausable is Ownable {
46 event Pause();
47 event Unpause();
48 
49 bool public paused = false;
50 
51 
52 /**
53 * @dev Modifier to make a function callable only when the contract is not paused.
54 */
55 modifier whenNotPaused() {
56 require(!paused);
57 _;
58 }
59 
60 /**
61 * @dev Modifier to make a function callable only when the contract is paused.
62 */
63 modifier whenPaused() {
64 require(paused);
65 _;
66 }
67 
68 /**
69 * @dev called by the owner to pause, triggers stopped state
70 */
71 function pause() onlyOwner whenNotPaused public {
72 paused = true;
73 Pause();
74 }
75 
76 /**
77 * @dev called by the owner to unpause, returns to normal state
78 */
79 function unpause() onlyOwner whenPaused public {
80 paused = false;
81 Unpause();
82 }
83 }
84 
85 
86 contract BetContract is Pausable{
87 
88 //This contract is owned and desgined by etherbets.io
89 
90 //Our contract has only 5 transfer function calls,
91 //the first two are used to return all bets without collecting a fee
92 //in case something goes wrong.
93 //The next two are used to pay to the A team or B team respectively and after everything is payed,
94 //the left over balance (fee) is sent in the last transfer function call.
95 
96 //Its also important to note that we have to other contracts that are used to receive funds
97 //and send them directly to the main contract to the correct team, the main contract owns this two other contracts.
98 //This was made to make it easier to place bets.
99 
100 
101 
102 uint minAmount;
103 uint feePercentage;
104 uint AteamAmount = 0;
105 uint BteamAmount = 0;
106 
107 address Acontract;
108 address Bcontract;
109 address fundCollection;
110 uint public transperrun;
111 
112 team[] public AteamBets;
113 team[] public BteamBets;
114 
115 struct team{
116 address betOwner;
117 uint amount;
118 uint date;
119 
120 
121 }
122 
123 
124 
125 function BetContract() public {
126 
127 minAmount = 0.02 ether;
128 feePercentage = 9500;
129 
130 fundCollection = owner;
131 transperrun = 25;
132 Acontract = new BetA(this,minAmount,"A");
133 Bcontract = new BetB(this,minAmount,"B");
134 
135 }
136 
137 
138 
139 function changeFundCollection(address _newFundCollection) public onlyOwner{
140 fundCollection = _newFundCollection;
141 }
142 
143 function contractBalance () public view returns(uint balance){
144 
145 return this.balance;
146 
147 }
148 
149 
150 function contractFeeMinAmount () public view returns (uint _feePercentage, uint _minAmount){
151 return (feePercentage, minAmount);
152 }
153 
154 function betALenght() public view returns(uint lengthA){
155 return AteamBets.length;
156 }
157 
158 function betBLenght() public view returns(uint lengthB){
159 return BteamBets.length;
160 }
161 
162 function teamAmounts() public view returns(uint A,uint B){
163 return(AteamAmount,BteamAmount);
164 }
165 function BetAnB() public view returns(address A, address B){
166 return (Acontract,Bcontract);
167 }
168 
169 function setTransperRun(uint _transperrun) public onlyOwner{
170 transperrun = _transperrun;
171 }
172 
173 function cancelBet() public onlyOwner returns(uint _balance){
174 require(this.balance > 0);
175 //uint i;
176 team memory tempteam;
177 uint p;
178 
179 
180 if (AteamBets.length < transperrun)
181 p = AteamBets.length;
182 else
183 p = transperrun;
184 
185 //i = 0;
186 while (p > 0){
187 
188 tempteam = AteamBets[p-1];
189 AteamBets[p-1] = AteamBets[AteamBets.length -1];
190 delete AteamBets[AteamBets.length - 1 ];
191 AteamBets.length --;
192 p --;
193 //i ++;
194 AteamAmount = AteamAmount - tempteam.amount;
195 //****************TRANSFER***************
196 tempteam.betOwner.transfer(tempteam.amount);
197 tempteam.amount = 0;
198 
199 
200 }
201 
202 if (BteamBets.length < transperrun)
203 p = BteamBets.length;
204 else
205 p = transperrun;
206 //i= 0;
207 while (p > 0){
208 
209 tempteam = BteamBets[p-1];
210 BteamBets[p-1] = BteamBets[BteamBets.length - 1];
211 delete BteamBets[BteamBets.length - 1];
212 BteamBets.length --;
213 p--;
214 //i++;
215 BteamAmount = BteamAmount - tempteam.amount;
216 //****************TRANSFER***************
217 tempteam.betOwner.transfer(tempteam.amount);
218 tempteam.amount = 0;
219 
220 
221 }
222 
223 
224 return this.balance;
225 
226 
227 
228 }
229 
230 function result(uint _team) public onlyOwner returns (uint _balance){
231 require(this.balance > 0);
232 require(checkTeamValue(_team));
233 
234 //uint i;
235 uint transferAmount = 0;
236 team memory tempteam;
237 uint p;
238 
239 if(_team == 1){
240 
241 
242 
243 if (AteamBets.length < transperrun)
244 p = AteamBets.length;
245 else
246 p = transperrun;
247 
248 //i = 0;
249 while (p > 0){
250 transferAmount = AteamBets[p-1].amount + (AteamBets[p-1].amount * BteamAmount / AteamAmount);
251 tempteam = AteamBets[p-1];
252 
253 AteamBets[p-1] = AteamBets[AteamBets.length -1];
254 delete AteamBets[AteamBets.length - 1 ];
255 AteamBets.length --;
256 p --;
257 //i++;
258 
259 //AteamAmount = AteamAmount - tempteam.amount;
260 
261 //****************TRANSFER***************
262 tempteam.betOwner.transfer(transferAmount * feePercentage/10000);
263 tempteam.amount = 0;
264 transferAmount = 0;
265 
266 }
267 
268 
269 }else{
270 
271 if (BteamBets.length < transperrun)
272 p = BteamBets.length;
273 else
274 p = transperrun;
275 //i = 0;
276 while (p > 0){
277 transferAmount = BteamBets[p-1].amount + (BteamBets[p-1].amount * AteamAmount / BteamAmount);
278 tempteam = BteamBets[p-1];
279 BteamBets[p-1] = BteamBets[BteamBets.length - 1];
280 delete BteamBets[BteamBets.length - 1];
281 BteamBets.length --;
282 p--;
283 //i++;
284 //BteamAmount = BteamAmount - tempteam.amount;
285 //****************TRANSFER***************
286 tempteam.betOwner.transfer(transferAmount * feePercentage/10000);
287 tempteam.amount = 0;
288 transferAmount = 0;
289 
290 }
291 
292 
293 }
294 
295 
296 
297 //****************TRANSFER***************
298 if (AteamBets.length == 0 || BteamBets.length == 0){
299 fundCollection.transfer(this.balance);
300 }
301 
302 if(this.balance == 0){
303 delete AteamBets;
304 delete BteamBets;
305 AteamAmount = 0;
306 BteamAmount = 0;
307 }
308 return this.balance;
309 
310 
311 
312 }
313 
314 function checkTeamValue(uint _team) private pure returns (bool ct){
315 bool correctteam = false;
316 if (_team == 1){
317 correctteam = true;
318 }else{
319 if (_team == 2){
320 correctteam = true;
321 }
322 }
323 return correctteam;
324 }
325 
326 
327 function bet(uint _team,address _betOwner) payable public returns (bool success){
328 require(paused == false);
329 require(msg.value >= minAmount);
330 
331 
332 require(checkTeamValue(_team));
333 
334 bool _success = false;
335 
336 
337 uint finalBetAmount = msg.value;
338 
339 if (_team == 1){
340 AteamBets.push(team(_betOwner,finalBetAmount,now));
341 AteamAmount = AteamAmount + finalBetAmount;
342 _success = true;
343 }
344 
345 if(_team == 2){
346 BteamBets.push(team(_betOwner,finalBetAmount,now));
347 BteamAmount = BteamAmount + finalBetAmount;
348 _success = true;
349 }
350 
351 return _success;
352 
353 }
354 }
355 contract TeamBet{
356 uint minAmount;
357 
358 string teamName;
359 
360 
361 BetContract ownerContract;
362 
363 function showTeam() public view returns(string team){
364 return teamName;
365 }
366 
367 function showOwnerContract() public view returns(address _ownerContract) {
368 
369 return ownerContract;
370 }
371 
372 
373 }
374 contract BetA is TeamBet{
375 
376 function BetA(BetContract _BetContract,uint _minAmount, string _teamName) public{
377 
378 ownerContract = _BetContract;
379 minAmount = _minAmount;
380 teamName = _teamName;
381 }
382 
383 
384 function() public payable {
385 //****************TRANSFER TO MAIN CONTRACT***************
386 require(ownerContract.bet.value(msg.value)(1,msg.sender));
387 
388 }
389 
390 }
391 
392 contract BetB is TeamBet{
393 
394 function BetB(BetContract _BetContract,uint _minAmount, string _teamName) public{
395 
396 ownerContract = _BetContract;
397 minAmount = _minAmount;
398 teamName = _teamName;
399 }
400 
401 function() public payable {
402 //****************TRANSFER TO MAIN CONTRACT***************
403 require(ownerContract.bet.value(msg.value)(2,msg.sender));
404 
405 }
406 }