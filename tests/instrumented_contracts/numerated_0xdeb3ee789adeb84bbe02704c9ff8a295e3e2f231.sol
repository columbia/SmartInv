1 pragma solidity ^0.4.18;
2 
3 /**
4 
5  * This is BreezeCoin contract
6 
7  */
8 
9  
10 
11 /**
12 
13  * Defining basic ERC20 interface. Standard ERC20 interface functions.
14 
15  * Please check https://github.com/ethereum/EIPs/issues/179
16 
17  */
18 
19 contract ERC20Basic {
20 
21     function totalSupply() public view returns (uint256);
22 
23     function balanceOf(address who) public view returns (uint256);
24 
25     function transfer(address to, uint256 value) public returns (bool);
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29 }
30 
31 /**
32 
33  * Defining ERC20 interface. This functions are standard for every token.
34 
35  * Please check https://github.com/ethereum/EIPs/issues/20
36 
37  */
38 
39 contract ERC20 is ERC20Basic {
40 
41     function allowance(address owner, address spender) public view returns (uint256);
42 
43     function transferFrom(address from, address to, uint256 value) public returns (bool);
44 
45     function approve(address spender, uint256 value) public returns (bool);
46 
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 
49 }
50 
51 /**
52 
53  *OpenZeppelin SafeMath library to make the contract secure.
54 
55  */
56 
57 library SafeMath {
58 
59 
60 
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62 
63         if (a == 0) {
64 
65             return 0;
66 
67         }
68 
69         uint256 c = a * b;
70 
71         assert(c / a == b);
72 
73         return c;
74 
75     }
76 
77 
78 
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80 
81         uint256 c = a / b;
82 
83         return c;
84 
85     }
86 
87 
88 
89     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90 
91         assert(b <= a);
92 
93         return a - b;
94 
95     }
96 
97 
98 
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100 
101         uint256 c = a + b;
102 
103         assert(c >= a);
104 
105         return c;
106 
107     }
108 
109 }
110 
111 /**
112 
113  * Defining BasicToken with
114 
115  * fucntions of check total supply of the token, token transfer and check balance
116 
117  * of the input address. These functions are standard for every basic token.
118 
119  */
120 
121 contract BasicToken is ERC20Basic {
122 
123     using SafeMath for uint256;
124 
125 
126 
127     mapping(address => uint256) balances;
128 
129 
130 
131     uint256 totalSupply_;
132 
133 
134 
135     function totalSupply() public view returns (uint256) {
136 
137         return totalSupply_;
138 
139     }
140 
141 
142 
143     function transfer(address _to, uint256 _value) public returns (bool) {
144 
145         require(_to != address(0));
146 
147         require(_value <= balances[msg.sender]);
148 
149 
150 
151         balances[msg.sender] = balances[msg.sender].sub(_value);
152 
153         balances[_to] = balances[_to].add(_value);
154 
155         emit Transfer(msg.sender, _to, _value);
156 
157         return true;
158 
159     }
160 
161 
162 
163     function balanceOf(address _owner) public view returns (uint256 balance) {
164 
165         return balances[_owner];
166 
167     }
168 
169 
170 
171 }
172 
173 /**
174 
175  * Defining StandardToken with
176 
177  * approval function. These functions are standard for every token.
178 
179  * Please check https://github.com/ethereum/EIPs/issues/20
180 
181  */
182 
183 contract StandardToken is ERC20, BasicToken {
184 
185 
186 
187     mapping (address => mapping (address => uint256)) internal allowed;
188 
189 
190 
191     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
192 
193         require(_to != address(0));
194 
195         require(_value <= balances[_from]);
196 
197         require(_value <= allowed[_from][msg.sender]);
198 
199 
200 
201         balances[_from] = balances[_from].sub(_value);
202 
203         balances[_to] = balances[_to].add(_value);
204 
205         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
206 
207         emit Transfer(_from, _to, _value);
208 
209         return true;
210 
211     }
212 
213 
214 
215     function approve(address _spender, uint256 _value) public returns (bool) {
216 
217         allowed[msg.sender][_spender] = _value;
218 
219         emit Approval(msg.sender, _spender, _value);
220 
221         return true;
222 
223     }
224 
225 
226 
227     function allowance(address _owner, address _spender) public view returns (uint256) {
228 
229         return allowed[_owner][_spender];
230 
231     }
232 
233 
234 
235     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
236 
237         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238 
239         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240 
241         return true;
242 
243     }
244 
245 
246 
247     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
248 
249         uint oldValue = allowed[msg.sender][_spender];
250 
251         if (_subtractedValue > oldValue) {
252 
253             allowed[msg.sender][_spender] = 0;
254 
255         } else {
256 
257             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258 
259         }
260 
261         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
262 
263         return true;
264 
265     }
266 
267 
268 
269 }
270 
271 
272 
273 /**
274 
275  * Defining ownershipTransfer
276 
277  * function. Function takes the new address and transfer the ownership.
278 
279  *
280 
281  */
282 
283 contract Ownable {
284 
285     address public owner;
286 
287 
288 
289 
290 
291     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
292 
293 
294 
295 
296 
297     function Ownable() public {
298 
299         owner = msg.sender;
300 
301     }
302 
303 
304 
305     modifier onlyOwner() {
306 
307         require(msg.sender == owner);
308 
309         _;
310 
311     }
312 
313 
314 
315     function transferOwnership(address newOwner) public onlyOwner {
316 
317         require(newOwner != address(0));
318 
319         emit OwnershipTransferred(owner, newOwner);
320 
321         owner = newOwner;
322 
323     }
324 
325 
326 
327 }
328 
329 /**
330 
331  * Creating BreezeCoin.
332 
333  * BreezeCoin calls the contracts StandardToken and ownable.
334 
335  */
336 
337 contract BreezeCoin is StandardToken, Ownable {
338 
339 
340 
341     string public constant name = "BreezeCoin";
342 
343 
344 
345     string public constant symbol = "BRZC";
346 
347 
348 
349     uint256 public constant decimals = 18;
350 
351 
352 
353     bool public released = false;
354 
355     event Release();
356 
357     address public holder;
358 
359     address private wallet1;
360     address private wallet2;
361     address private team_tips;
362     address private Reserve;
363 /** 
364  * This modifier allows only owner of the token and holder of the token call a function.
365  */
366     modifier isReleased () {
367 
368         require(released || msg.sender == holder || msg.sender == owner);
369 
370         _;
371 
372     }
373 
374 
375 
376     function BreezeCoin() public {
377 
378         owner = 0xE601Bb5Ef5Ca433e6B467a5fc8453dcACE3974De;
379 
380         wallet1 = 0x5a86671071Ad67f2DF02c821e587BCe5B8e26C38; //early investors
381 
382         wallet2 = 0x25b25f5dE7C81b14DEf6db5B65107853687702EC; //manager
383 
384         team_tips =  0x6FcF24c918631Bb385DeeDC6d01e8f68293E2641; //team tips
385 
386         Reserve =  0x3d4Bd578291737fAED39bA3F20F32DF25111D724; //Reserve
387 
388         holder = 0x2bb3a4f80bFb939716E6d85799116feB1906748B; //ico coins holder
389 
390         totalSupply_ = 200000000 * (10 ** decimals); // our total supply is 200 million
391 
392         balances[holder] = 30000000* (10 ** decimals); //ico wallet holds 30 million
393 
394         balances[wallet1] = 10000000* (10 ** decimals);
395         balances[wallet2] = 1250000* (10 ** decimals);
396         balances[team_tips] = 8750000* (10 ** decimals);
397         balances[Reserve] = 150000000* (10 ** decimals);
398 
399 
400         emit Transfer(0x0, holder, 30000000* (10 ** decimals)); // creating token out of thin air to ICO holder account address.
401         emit Transfer(0x0, wallet1, 10000000* (10 ** decimals)); // creating token out of thin air to team wallet1 account address.
402         emit Transfer(0x0, team_tips, 8750000* (10 ** decimals)); // creating token out of thin air to team tips account address.
403         emit Transfer(0x0, wallet2, 1250000* (10 ** decimals)); // creating token out of thin air to wallet2 account address.
404         emit Transfer(0x0, Reserve, 150000000* (10 ** decimals)); // creating token out of thin air to reserve account address.
405 
406 
407 
408         
409 
410     }
411 
412 /** 
413  * Tokens are first not released. This function can be called only by owner. This function releases the tokens and allow token transfers.
414  */
415 
416     function release() onlyOwner public returns (bool) {
417 
418         require(!released);
419 
420         released = true;
421 
422         emit Release();
423 
424 
425 
426         return true;
427 
428     }
429 
430 
431 
432     function getOwner() public view returns (address) {
433 
434         return owner;
435 
436     }
437 
438 
439 /** 
440  * These functions allow users to use transfer and approve functions if the token is released.
441  */
442     function transfer(address _to, uint256 _value) public isReleased returns (bool) {
443 
444         return super.transfer(_to, _value);
445 
446     }
447 
448 
449 
450     function transferFrom(address _from, address _to, uint256 _value) public isReleased returns (bool) {
451 
452         return super.transferFrom(_from, _to, _value);
453 
454     }
455 
456 
457 
458     function approve(address _spender, uint256 _value) public isReleased returns (bool) {
459 
460         return super.approve(_spender, _value);
461 
462     }
463 
464 
465 
466     function increaseApproval(address _spender, uint _addedValue) public isReleased returns (bool success) {
467 
468         return super.increaseApproval(_spender, _addedValue);
469 
470     }
471 
472 
473 
474     function decreaseApproval(address _spender, uint _subtractedValue) public isReleased returns (bool success) {
475 
476         return super.decreaseApproval(_spender, _subtractedValue);
477 
478     }
479 
480 
481 
482     function transferOwnership(address newOwner) public onlyOwner {
483 
484         address oldOwner = owner;
485 
486         super.transferOwnership(newOwner);
487 
488 
489 
490         if (oldOwner != holder) {
491 
492             allowed[holder][oldOwner] = 0;
493 
494             emit Approval(holder, oldOwner, 0);
495 
496         }
497 
498 
499 
500         if (owner != holder) {
501 
502             allowed[holder][owner] = balances[holder];
503 
504             emit Approval(holder, owner, balances[holder]);
505 
506         }
507 
508     }
509 
510 
511 
512 }
513 /** Creating ICO contract
514  * It starts on 01.06.2018 and ends on 20.06.2018 
515  * The hard cap of the ICO is 30 million coin.
516  */
517 
518 contract BreezeCoinICO is Ownable {
519     uint public constant SALES_START = 1527800400; //we are defining the starting time of ICO
520     uint public constant SALES_END = 1529528399; //we are defining the ending time of ICO
521     
522     address public constant return_owner =0xE601Bb5Ef5Ca433e6B467a5fc8453dcACE3974De; //after ICO ends, ownership will return to creator
523     address public constant ICO_WALLET = 0x2bb3a4f80bFb939716E6d85799116feB1906748B; //defining ICO wallet address
524     address public constant COMPANY_WALLET = 0x2bb3a4f80bFb939716E6d85799116feB1906748B; //defining company wallet address
525     address public constant TOKEN_ADDRESS = 0xe12128D653B62F08fbED56BdeB65dB729B6691C3; //defining BreezeCoin address
526 
527     uint public constant SMALLEST_TOKEN = 1* (10 ** 18); // defining the decimal 
528     uint public constant TOKEN_PRICE = 0.001423964 ether; // BreezeCoin prize.
529 
530 
531     uint public constant SALE_MAX_CAP = 30000000 * SMALLEST_TOKEN; // defining the hardcap
532 
533 
534     uint public saleContributions; //total ETH contributed
535     uint public tokensPurchased; //total BreezeCoin purchased.
536 
537     address public whitelistSupplier;
538     address public second_whitelistSupplier;
539     address public third_whitelistSupplier;
540     address public fourth_whitelistSupplier;
541     mapping(address => bool) public whitelistPublic;
542     mapping (address => uint256) public investedAmountOf;
543 
544 
545     event Contributed(address receiver, uint contribution, uint reward); // this event store address of the contributor, the amount of the contribution and token will be send.
546     event PublicWhitelistUpdated(address participant, bool isWhitelisted); // this event store the address of the participant and boolean value of that address. 
547 
548     function BreezeCoinICO() public {
549         whitelistSupplier = msg.sender;
550         second_whitelistSupplier = 0xC578FFd5629B0e89F4384b27227C2AE66Dbee843;
551 	third_whitelistSupplier = 0x2bb3a4f80bFb939716E6d85799116feB1906748B;
552 	fourth_whitelistSupplier = 0x8aFC72dA31185182605E5b51053e96D3f48ea6ea;
553         owner = return_owner;
554     }
555 /** 
556  * This modifier allows only whitelist suppliers call a function.
557  */
558 
559     modifier onlyWhitelistSupplier() {
560         require(msg.sender == whitelistSupplier || msg.sender == owner || msg.sender == second_whitelistSupplier || msg.sender == third_whitelistSupplier || msg.sender == fourth_whitelistSupplier);
561         _;
562     }
563 
564     function contribute() public payable returns(bool) {
565         return contributeFor(msg.sender);
566     }
567 /** 
568  * Main ICO function, it requires time is smaller than the ending time of ICO and bigger than starting time of ICO.
569  * function takes participant address and the amount of the sender. And send the amount of the ETH to company wallet.
570  * send BreezeCoin to participant from ICO wallet.
571  */
572     function contributeFor(address _participant) public payable returns(bool) {
573         require(now < SALES_END);
574 	    require(now >= SALES_START);
575 	    if (now >= SALES_START) {
576             require(whitelistPublic[_participant]);
577         }
578         
579         uint tokensAmount = (msg.value * SMALLEST_TOKEN) / TOKEN_PRICE;
580         require(tokensAmount > 0);
581         uint totalTokens = tokensAmount;
582         
583         COMPANY_WALLET.transfer(msg.value);
584         tokensPurchased += totalTokens;
585         require(tokensPurchased <= SALE_MAX_CAP);
586         require(BreezeCoin(TOKEN_ADDRESS).transferFrom(ICO_WALLET, _participant, totalTokens));
587         saleContributions += msg.value;
588 	    investedAmountOf[_participant] = investedAmountOf[_participant]+msg.value;
589         emit Contributed(_participant, msg.value, totalTokens);
590         return true;
591     }
592 /** 
593  * These two function can be called by only whitelist suppliers.
594  * First function take participants wallet address and add to whitelist.
595  * Second function take participants wallet address and remove from whitelist.
596  */
597 
598     function addToPublicWhitelist(address _participant) onlyWhitelistSupplier() public returns(bool) {
599         if (whitelistPublic[_participant]) {
600             return true;
601         }
602         whitelistPublic[_participant] = true;
603         emit PublicWhitelistUpdated(_participant, true);
604         return true;
605     }
606 
607     function removeFromPublicWhitelist(address _participant) onlyWhitelistSupplier() public returns(bool) {
608         if (!whitelistPublic[_participant]) {
609             return true;
610         }
611         whitelistPublic[_participant] = false;
612         emit PublicWhitelistUpdated(_participant, false);
613         return true;
614     }
615 /** 
616  * With this function, the token ownership will be transferred to token creator.
617  */
618     function getTokenOwner() public view returns (address) {
619         return BreezeCoin(TOKEN_ADDRESS).getOwner();
620     }
621 
622     function restoreTokenOwnership() public onlyOwner {
623         BreezeCoin(TOKEN_ADDRESS).transferOwnership(return_owner);
624     }
625 
626     function () public payable {
627         contribute();
628     }
629 
630 }