1 pragma solidity ^0.4.11;
2 
3 
4 
5 /**
6 * privlocatum.sol build token for crowdsale and allows for subsequent token sales and minting of tokens
7 **/
8 
9 
10 
11 contract ERC20 {
12 
13     //Sets events and functions for ERC20 token
14 
15     event Approval(address indexed _owner, address indexed _spender, uint _value);
16 
17     event Transfer(address indexed _from, address indexed _to, uint _value);
18 
19 
20 
21     function allowance(address _owner, address _spender) constant returns (uint remaining);
22 
23     function approve(address _spender, uint _value) returns (bool success);
24 
25     function balanceOf(address _owner) constant returns (uint balance);
26 
27     function transfer(address _to, uint _value) returns (bool success);
28 
29     function transferFrom(address _from, address _to, uint _value) returns (bool success);
30 
31 }
32 
33 
34 
35 
36 
37 contract Owned {
38 
39     //Public variable
40 
41     address public owner;
42 
43 
44 
45     //Sets contract creator as the owner
46 
47     function Owned() {
48 
49         owner = msg.sender;
50 
51     }
52 
53 
54 
55     //Sets onlyOwner modifier for specified functions
56 
57     modifier onlyOwner {
58 
59         require(msg.sender == owner);
60 
61         _;
62 
63     }
64 
65 
66 
67     //Allows for transfer of contract ownership
68 
69     function transferOwnership(address newOwner) onlyOwner {
70 
71         owner = newOwner;
72 
73     }
74 
75 }
76 
77 
78 
79 
80 
81 library SafeMath {
82 
83     function add(uint256 a, uint256 b) internal returns (uint256) {
84 
85         uint256 c = a + b;
86 
87         assert(c >= a);
88 
89         return c;
90 
91     }
92 
93 
94 
95     function div(uint256 a, uint256 b) internal returns (uint256) {
96 
97         // assert(b > 0); // Solidity automatically throws when dividing by 0
98 
99         uint256 c = a / b;
100 
101         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102 
103         return c;
104 
105     }
106 
107 
108 
109     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
110 
111         return a >= b ? a : b;
112 
113     }
114 
115 
116 
117     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
118 
119         return a >= b ? a : b;
120 
121     }
122 
123 
124 
125     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
126 
127         return a < b ? a : b;
128 
129     }
130 
131 
132 
133     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
134 
135         return a < b ? a : b;
136 
137     }
138 
139 
140 
141     function mul(uint256 a, uint256 b) internal returns (uint256) {
142 
143         uint256 c = a * b;
144 
145         assert(a == 0 || c / a == b);
146 
147         return c;
148 
149     }
150 
151 
152 
153     function sub(uint256 a, uint256 b) internal returns (uint256) {
154 
155         assert(b <= a);
156 
157         return a - b;
158 
159     }
160 
161 }
162 
163 
164 
165 
166 
167 contract privlocatum is ERC20, Owned {
168 
169     //Applies SafeMath library to uint256 operations
170 
171     using SafeMath for uint256;
172 
173 
174 
175     //Public variables
176 
177     string public name;
178 
179     string public symbol;
180 
181     uint256 public decimals;
182 
183     uint256 public totalSupply;
184 
185 
186 
187     //Variables
188 
189     uint256 multiplier;
190 
191 
192 
193     //Creates arrays for balances
194 
195     mapping (address => uint256) balance;
196 
197     mapping (address => mapping (address => uint256)) allowed;
198 
199 
200 
201     //Creates modifier to prevent short address attack
202 
203     modifier onlyPayloadSize(uint size) {
204 
205         if(msg.data.length < size + 4) revert();
206 
207         _;
208 
209     }
210 
211 
212 
213     //Constructor
214 
215     function privlocatum(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 decimalMultiplier) {
216 
217         name = tokenName;
218 
219         symbol = tokenSymbol;
220 
221         decimals = decimalUnits;
222 
223         multiplier = decimalMultiplier;
224 
225     }
226 
227 
228 
229     //Provides the remaining balance of approved tokens from function approve
230 
231     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
232 
233       return allowed[_owner][_spender];
234 
235     }
236 
237 
238 
239     //Allows for a certain amount of tokens to be spent on behalf of the account owner
240 
241     function approve(address _spender, uint256 _value) returns (bool success) {
242 
243         allowed[msg.sender][_spender] = _value;
244 
245         Approval(msg.sender, _spender, _value);
246 
247         return true;
248 
249     }
250 
251 
252 
253     //Returns the account balance
254 
255     function balanceOf(address _owner) constant returns (uint256 remainingBalance) {
256 
257         return balance[_owner];
258 
259     }
260 
261 
262 
263     //Allows contract owner to mint new tokens, prevents numerical overflow
264 
265     function mintToken(address target, uint256 mintedAmount) onlyOwner returns (bool success) {
266 
267         require(mintedAmount > 0);
268 
269         uint256 addTokens = mintedAmount;
270 
271         balance[target] += addTokens;
272 
273         totalSupply += addTokens;
274 
275         Transfer(0, target, addTokens);
276 
277         return true;
278 
279     }
280 
281 
282 
283     //Sends tokens from sender's account
284 
285     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
286 
287         if ((balance[msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
288 
289             balance[msg.sender] -= _value;
290 
291             balance[_to] += _value;
292 
293             Transfer(msg.sender, _to, _value);
294 
295             return true;
296 
297         } else {
298 
299             return false;
300 
301         }
302 
303     }
304 
305 
306     //Transfers tokens from an approved account
307 
308     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
309 
310         if ((balance[_from] >= _value) && (allowed[_from][msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
311 
312             balance[_to] += _value;
313 
314             balance[_from] -= _value;
315 
316             allowed[_from][msg.sender] -= _value;
317 
318             Transfer(_from, _to, _value);
319 
320             return true;
321 
322         } else {
323 
324             return false;
325 
326         }
327 
328     }
329 
330 }
331 
332 
333 
334 
335 
336 contract privlocatumICO is Owned, privlocatum {
337 
338     //Applies SafeMath library to uint256 operations
339 
340     using SafeMath for uint256;
341 
342 
343 
344     //Public Variables
345 
346     address public multiSigWallet;
347 
348     uint256 public amountRaised;
349 
350     uint256 public startTime;
351 
352     uint256 public stopTime;
353 
354     uint256 public hardcap;
355 
356     uint256 public price;
357 
358 
359 
360     //Variables
361 
362     bool crowdsaleClosed = true;
363 
364     string tokenName = "Privlocatum";
365 
366     string tokenSymbol = "PLT";
367 
368     uint256 multiplier = 100000000;
369 
370     uint8 decimalUnits = 8;
371 
372 
373 
374 
375 
376 
377 
378     //Initializes the token
379 
380     function privlocatumICO()
381 
382         privlocatum(tokenName, tokenSymbol, decimalUnits, multiplier) {
383 
384             multiSigWallet = msg.sender;
385 
386             hardcap = 70000000;
387 
388             hardcap = hardcap.mul(multiplier);
389 
390     }
391 
392 
393 
394     //Fallback function creates tokens and sends to investor when crowdsale is open
395 
396     function () payable {
397 
398         require(!crowdsaleClosed
399 
400             && (now < stopTime)
401 
402             && (totalSupply.add(msg.value.mul(getPrice()).mul(multiplier).div(1 ether)) <= hardcap));
403 
404         address recipient = msg.sender;
405 
406         amountRaised = amountRaised.add(msg.value.div(1 ether));
407 
408         uint256 tokens = msg.value.mul(getPrice()).mul(multiplier).div(1 ether);
409 
410         totalSupply = totalSupply.add(tokens);
411 
412         balance[recipient] = balance[recipient].add(tokens);
413 
414         require(multiSigWallet.send(msg.value));
415 
416         Transfer(0, recipient, tokens);
417 
418     }
419 
420 
421 
422     //Returns the current price of the token for the crowdsale
423 
424     function getPrice() returns (uint256 result) {
425 
426         return price;
427 
428     }
429 
430 
431 
432     //Returns time remaining on crowdsale
433 
434     function getRemainingTime() constant returns (uint256) {
435 
436         return stopTime;
437 
438     }
439 
440 
441 
442     //Set the sale hardcap amount
443 
444     function setHardCapValue(uint256 newHardcap) onlyOwner returns (bool success) {
445 
446         hardcap = newHardcap.mul(multiplier);
447 
448         return true;
449 
450     }
451 
452 
453 
454     //Sets the multisig wallet for a crowdsale
455 
456     function setMultiSigWallet(address wallet) onlyOwner returns (bool success) {
457 
458         multiSigWallet = wallet;
459 
460         return true;
461 
462     }
463 
464 
465 
466     //Sets the token price
467 
468     function setPrice(uint256 newPriceperEther) onlyOwner returns (uint256) {
469 
470         require(newPriceperEther > 0);
471 
472         price = newPriceperEther;
473 
474         return price;
475 
476     }
477 
478 
479 
480     //Allows owner to start the crowdsale from the time of execution until a specified stopTime
481 
482     function startSale(uint256 saleStart, uint256 saleStop, uint256 salePrice, address setBeneficiary) onlyOwner returns (bool success) {
483 
484         require(saleStop > now);
485 
486         startTime = saleStart;
487 
488         stopTime = saleStop;
489 
490         crowdsaleClosed = false;
491 
492         setPrice(salePrice);
493 
494         setMultiSigWallet(setBeneficiary);
495 
496         return true;
497 
498     }
499 
500 
501 
502     //Allows owner to stop the crowdsale immediately
503 
504     function stopSale() onlyOwner returns (bool success) {
505 
506         stopTime = now;
507 
508         crowdsaleClosed = true;
509 
510         return true;
511 
512     }
513 
514 }