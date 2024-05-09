1 pragma solidity ^0.4.11;
2 
3 
4 
5 /**
6 
7 * @author Jefferson Davis
8 
9 * HashRuchICO.sol creates the client's token for crowdsale and allows for subsequent token sales and minting of tokens
10 
11 *   Crowdsale contracts edited from original contract code at https://www.ethereum.org/crowdsale#crowdfund-your-idea
12 
13 *   Additional crowdsale contracts, functions, libraries from OpenZeppelin
14 
15 *       at https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token
16 
17 *   Token contract edited from original contract code at https://www.ethereum.org/token
18 
19 *   ERC20 interface and certain token functions adapted from https://github.com/ConsenSys/Tokens
20 
21 **/
22 
23 
24 
25 contract ERC20 {
26 
27     //Sets events and functions for ERC20 token
28 
29     event Approval(address indexed _owner, address indexed _spender, uint _value);
30 
31     event Transfer(address indexed _from, address indexed _to, uint _value);
32 
33     
34 
35     function allowance(address _owner, address _spender) constant returns (uint remaining);
36 
37     function approve(address _spender, uint _value) returns (bool success);
38 
39     function balanceOf(address _owner) constant returns (uint balance);
40 
41     function transfer(address _to, uint _value) returns (bool success);
42 
43     function transferFrom(address _from, address _to, uint _value) returns (bool success);
44 
45 }
46 
47 
48 
49 
50 
51 contract Owned {
52 
53     //Public variable
54 
55     address public owner;
56 
57 
58 
59     //Sets contract creator as the owner
60 
61     function Owned() {
62 
63         owner = msg.sender;
64 
65     }
66 
67     
68 
69     //Sets onlyOwner modifier for specified functions
70 
71     modifier onlyOwner {
72 
73         require(msg.sender == owner);
74 
75         _;
76 
77     }
78 
79 
80 
81     //Allows for transfer of contract ownership
82 
83     function transferOwnership(address newOwner) onlyOwner {
84 
85         owner = newOwner;
86 
87     }
88 
89 }
90 
91 
92 
93 
94 
95 library SafeMath {
96 
97     function add(uint256 a, uint256 b) internal returns (uint256) {
98 
99         uint256 c = a + b;
100 
101         assert(c >= a);
102 
103         return c;
104 
105     }  
106 
107 
108 
109     function div(uint256 a, uint256 b) internal returns (uint256) {
110 
111         // assert(b > 0); // Solidity automatically throws when dividing by 0
112 
113         uint256 c = a / b;
114 
115         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116 
117         return c;
118 
119     }
120 
121 
122 
123     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
124 
125         return a >= b ? a : b;
126 
127     }
128 
129 
130 
131     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
132 
133         return a >= b ? a : b;
134 
135     }
136 
137 
138 
139     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
140 
141         return a < b ? a : b;
142 
143     }
144 
145 
146 
147     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
148 
149         return a < b ? a : b;
150 
151     }
152 
153   
154 
155     function mul(uint256 a, uint256 b) internal returns (uint256) {
156 
157         uint256 c = a * b;
158 
159         assert(a == 0 || c / a == b);
160 
161         return c;
162 
163     }
164 
165 
166 
167     function sub(uint256 a, uint256 b) internal returns (uint256) {
168 
169         assert(b <= a);
170 
171         return a - b;
172 
173     }
174 
175 }
176 
177 
178 
179 
180 
181 contract HashRush is ERC20, Owned {
182 
183     //Applies SafeMath library to uint256 operations 
184 
185     using SafeMath for uint256;
186 
187 
188 
189     //Public variables
190 
191     string public name; 
192 
193     string public symbol; 
194 
195     uint256 public decimals;  
196 
197     uint256 public totalSupply; 
198 
199 
200 
201     //Variables
202 
203     uint256 multiplier; 
204 
205     
206 
207     //Creates arrays for balances
208 
209     mapping (address => uint256) balance;
210 
211     mapping (address => mapping (address => uint256)) allowed;
212 
213 
214 
215     //Creates modifier to prevent short address attack
216 
217     modifier onlyPayloadSize(uint size) {
218 
219         if(msg.data.length < size + 4) revert();
220 
221         _;
222 
223     }
224 
225 
226 
227     //Constructor
228 
229     function HashRush(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 decimalMultiplier) {
230 
231         name = tokenName; 
232 
233         symbol = tokenSymbol; 
234 
235         decimals = decimalUnits; 
236 
237         multiplier = decimalMultiplier;  
238 
239     }
240 
241     
242 
243     //Provides the remaining balance of approved tokens from function approve 
244 
245     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
246 
247       return allowed[_owner][_spender];
248 
249     }
250 
251 
252 
253     //Allows for a certain amount of tokens to be spent on behalf of the account owner
254 
255     function approve(address _spender, uint256 _value) returns (bool success) { 
256 
257         allowed[msg.sender][_spender] = _value;
258 
259         Approval(msg.sender, _spender, _value);
260 
261         return true;
262 
263     }
264 
265 
266 
267     //Returns the account balance 
268 
269     function balanceOf(address _owner) constant returns (uint256 remainingBalance) {
270 
271         return balance[_owner];
272 
273     }
274 
275 
276 
277     //Allows contract owner to mint new tokens, prevents numerical overflow
278 
279     function mintToken(address target, uint256 mintedAmount) onlyOwner returns (bool success) {
280 
281         require(mintedAmount > 0); 
282 
283         uint256 addTokens = mintedAmount; 
284 
285         balance[target] += addTokens;
286 
287         totalSupply += addTokens;
288 
289         Transfer(0, target, addTokens);
290 
291         return true; 
292 
293     }
294 
295 
296 
297     //Sends tokens from sender's account
298 
299     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
300 
301         if ((balance[msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
302 
303             balance[msg.sender] -= _value;
304 
305             balance[_to] += _value;
306 
307             Transfer(msg.sender, _to, _value);
308 
309             return true;
310 
311         } else { 
312 
313             return false; 
314 
315         }
316 
317     }
318 
319     
320 
321     //Transfers tokens from an approved account 
322 
323     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
324 
325         if ((balance[_from] >= _value) && (allowed[_from][msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
326 
327             balance[_to] += _value;
328 
329             balance[_from] -= _value;
330 
331             allowed[_from][msg.sender] -= _value;
332 
333             Transfer(_from, _to, _value);
334 
335             return true;
336 
337         } else { 
338 
339             return false; 
340 
341         }
342 
343     }
344 
345 }
346 
347 
348 
349 
350 
351 contract HashRushICO is Owned, HashRush {
352 
353     //Applies SafeMath library to uint256 operations 
354 
355     using SafeMath for uint256;
356 
357 
358 
359     //Public Variables
360 
361     address public multiSigWallet;                  
362 
363     uint256 public amountRaised; 
364 
365     uint256 public startTime; 
366 
367     uint256 public stopTime; 
368 
369     uint256 public hardcap; 
370 
371     uint256 public price;                            
372 
373 
374 
375     //Variables
376 
377     bool crowdsaleClosed = true;                    
378 
379     string tokenName = "HashRush"; 
380 
381     string tokenSymbol = "RC"; 
382 
383     uint256 multiplier = 100000000; 
384 
385     uint8 decimalUnits = 8;  
386 
387 
388 
389     
390 
391 
392 
393     //Initializes the token
394 
395     function HashRushICO() 
396 
397         HashRush(tokenName, tokenSymbol, decimalUnits, multiplier) {  
398 
399             multiSigWallet = msg.sender;        
400 
401             hardcap = 70000000;    
402 
403             hardcap = hardcap.mul(multiplier); 
404 
405     }
406 
407 
408 
409     //Fallback function creates tokens and sends to investor when crowdsale is open
410 
411     function () payable {
412 
413         require(!crowdsaleClosed 
414 
415             && (now < stopTime) 
416 
417             && (totalSupply.add(msg.value.mul(getPrice()).mul(multiplier).div(1 ether)) <= hardcap)); 
418 
419         address recipient = msg.sender; 
420 
421         amountRaised = amountRaised.add(msg.value.div(1 ether)); 
422 
423         uint256 tokens = msg.value.mul(getPrice()).mul(multiplier).div(1 ether);
424 
425         totalSupply = totalSupply.add(tokens);
426 
427         balance[recipient] = balance[recipient].add(tokens);
428 
429         require(multiSigWallet.send(msg.value)); 
430 
431         Transfer(0, recipient, tokens);
432 
433     }   
434 
435 
436 
437     //Returns the current price of the token for the crowdsale
438 
439     function getPrice() returns (uint256 result) {
440 
441         return price;
442 
443     }
444 
445 
446 
447     //Returns time remaining on crowdsale
448 
449     function getRemainingTime() constant returns (uint256) {
450 
451         return stopTime; 
452 
453     }
454 
455 
456 
457     //Set the sale hardcap amount
458 
459     function setHardCapValue(uint256 newHardcap) onlyOwner returns (bool success) {
460 
461         hardcap = newHardcap.mul(multiplier); 
462 
463         return true; 
464 
465     }
466 
467 
468 
469     //Sets the multisig wallet for a crowdsale
470 
471     function setMultiSigWallet(address wallet) onlyOwner returns (bool success) {
472 
473         multiSigWallet = wallet; 
474 
475         return true; 
476 
477     }
478 
479 
480 
481     //Sets the token price 
482 
483     function setPrice(uint256 newPriceperEther) onlyOwner returns (uint256) {
484 
485         require(newPriceperEther > 0);  
486 
487         price = newPriceperEther; 
488 
489         return price; 
490 
491     }
492 
493 
494 
495     //Allows owner to start the crowdsale from the time of execution until a specified stopTime
496 
497     function startSale(uint256 saleStart, uint256 saleStop, uint256 salePrice, address setBeneficiary) onlyOwner returns (bool success) {
498 
499         require(saleStop > now);     
500 
501         //startTime = 1502881261; // 16 August 2017, 11:01 AM GMT 
502 
503         //stopTime = 1504263601;  // 1 September 2017, 11:00 AM GMT
504 
505         startTime = saleStart; 
506 
507         stopTime = saleStop; 
508 
509         crowdsaleClosed = false; 
510 
511         setPrice(salePrice); 
512 
513         setMultiSigWallet(setBeneficiary); 
514 
515         return true; 
516 
517     }
518 
519 
520 
521     //Allows owner to stop the crowdsale immediately
522 
523     function stopSale() onlyOwner returns (bool success) {
524 
525         stopTime = now; 
526 
527         crowdsaleClosed = true;
528 
529         return true; 
530 
531     }
532 
533 }