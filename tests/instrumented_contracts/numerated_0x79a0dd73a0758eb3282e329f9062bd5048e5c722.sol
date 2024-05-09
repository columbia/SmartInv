1 pragma solidity ^0.4.15;
2 /*
3     Utilities & Common Modifiers
4 */
5 contract Utils {
6     /**
7         constructor
8     */
9     function Utils() {
10     }
11 
12     // validates an address - currently only checks that it isn't null
13     modifier validAddress(address _address) {
14         require(_address != 0x0);
15         _;
16     }
17 
18     // verifies that the address is different than this contract address
19     modifier notThis(address _address) {
20         require(_address != address(this));
21         _;
22     }
23 
24     // Overflow protected math functions
25 
26     /**
27         @dev returns the sum of _x and _y, asserts if the calculation overflows
28 
29         @param _x   value 1
30         @param _y   value 2
31 
32         @return sum
33     */
34     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
35         uint256 z = _x + _y;
36         assert(z >= _x);
37         return z;
38     }
39 
40     /**
41         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
42 
43         @param _x   minuend
44         @param _y   subtrahend
45 
46         @return difference
47     */
48     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
49         assert(_x >= _y);
50         return _x - _y;
51     }
52 
53     /**
54         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
55 
56         @param _x   factor 1
57         @param _y   factor 2
58 
59         @return product
60     */
61     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
62         uint256 z = _x * _y;
63         assert(_x == 0 || z / _x == _y);
64         return z;
65     }
66 }
67 
68 /*
69     ERC20 Standard Token interface
70 */
71 contract IERC20Token {
72     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
73     function name() public constant returns (string) { name; }
74     function symbol() public constant returns (string) { symbol; }
75     function decimals() public constant returns (uint8) { decimals; }
76     function totalSupply() public constant returns (uint256) { totalSupply; }
77     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
78     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
79 
80     function transfer(address _to, uint256 _value) public returns (bool success);
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
82     function approve(address _spender, uint256 _value) public returns (bool success);
83 }
84 
85 
86 /**
87     ERC20 Standard Token implementation
88 */
89 contract ERC20Token is IERC20Token, Utils {
90     string public standard = "Token 0.1";
91     string public name = "";
92     string public symbol = "";
93     uint8 public decimals = 0;
94     uint256 public totalSupply = 0;
95     mapping (address => uint256) public balanceOf;
96     mapping (address => mapping (address => uint256)) public allowance;
97 
98     event Transfer(address indexed _from, address indexed _to, uint256 _value);
99     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100 
101     /**
102         @dev constructor
103 
104         @param _name        token name
105         @param _symbol      token symbol
106         @param _decimals    decimal points, for display purposes
107     */
108     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
109         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
110 
111         name = _name;
112         symbol = _symbol;
113         decimals = _decimals;
114     }
115 
116     /**
117         @dev send coins
118         throws on any error rather then return a false flag to minimize user errors
119 
120         @param _to      target address
121         @param _value   transfer amount
122 
123         @return true if the transfer was successful, false if it wasn't
124     */
125     function transfer(address _to, uint256 _value)
126         public
127         validAddress(_to)
128         returns (bool success)
129     {
130         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
131         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
132         Transfer(msg.sender, _to, _value);
133         return true;
134     }
135 
136     /**
137         @dev an account/contract attempts to get the coins
138         throws on any error rather then return a false flag to minimize user errors
139 
140         @param _from    source address
141         @param _to      target address
142         @param _value   transfer amount
143 
144         @return true if the transfer was successful, false if it wasn't
145     */
146     function transferFrom(address _from, address _to, uint256 _value)
147         public
148         validAddress(_from)
149         validAddress(_to)
150         returns (bool success)
151     {
152         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
153         balanceOf[_from] = safeSub(balanceOf[_from], _value);
154         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
155         Transfer(_from, _to, _value);
156         return true;
157     }
158 
159 
160 
161 
162     /**
163         @dev allow another account/contract to spend some tokens on your behalf
164         throws on any error rather then return a false flag to minimize user errors
165 
166         also, to minimize the risk of the approve/transferFrom attack vector
167         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
168         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
169 
170         @param _spender approved address
171         @param _value   allowance amount
172 
173         @return true if the approval was successful, false if it wasn't
174     */
175     function approve(address _spender, uint256 _value)
176         public
177         validAddress(_spender)
178         returns (bool success)
179     {
180         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
181         require(_value == 0 || allowance[msg.sender][_spender] == 0);
182 
183         allowance[msg.sender][_spender] = _value;
184         Approval(msg.sender, _spender, _value);
185         return true;
186     }
187 }
188 
189 /*
190     Owned contract interface
191 */
192 contract IOwned {
193     // this function isn't abstract since the compiler emits automatically generated getter functions as external
194     function owner() public constant returns (address) { owner; }
195 
196     function transferOwnership(address _newOwner) public;
197     function acceptOwnership() public;
198 }
199 
200 /*
201     Provides support and utilities for contract ownership
202 */
203 contract Owned is IOwned {
204     address public owner;
205     address public newOwner;
206 
207     event OwnerUpdate(address _prevOwner, address _newOwner);
208 
209     /**
210         @dev constructor
211     */
212     function Owned() {
213         owner = msg.sender;
214     }
215 
216     // allows execution by the owner only
217     modifier ownerOnly {
218         assert(msg.sender == owner);
219         _;
220     }
221 
222     /**
223         @dev allows transferring the contract ownership
224         the new owner still needs to accept the transfer
225         can only be called by the contract owner
226 
227         @param _newOwner    new contract owner
228     */
229     function transferOwnership(address _newOwner) public ownerOnly {
230         require(_newOwner != owner);
231         newOwner = _newOwner;
232     }
233 
234     /**
235         @dev used by a new owner to accept an ownership transfer
236     */
237     function acceptOwnership() public {
238         require(msg.sender == newOwner);
239         OwnerUpdate(owner, newOwner);
240         owner = newOwner;
241         newOwner = 0x0;
242     }
243 }
244 
245 /*
246     Token Holder interface
247 */
248 contract ITokenHolder is IOwned {
249     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
250 }
251 
252 
253 contract TokenHolder is ITokenHolder, Owned, Utils {
254     /**
255         @dev constructor
256     */
257     function TokenHolder() {
258     }
259 
260     /**
261         @dev withdraws tokens held by the contract and sends them to an account
262         can only be called by the owner
263 
264         @param _token   ERC20 token contract address
265         @param _to      account to receive the new amount
266         @param _amount  amount to withdraw
267     */
268     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
269         public
270         ownerOnly
271         validAddress(_token)
272         validAddress(_to)
273         notThis(_to)
274     {
275         assert(_token.transfer(_to, _amount));
276     }
277 }
278 
279 
280 contract CLRSToken is ERC20Token, TokenHolder {
281 
282 ///////////////////////////////////////// VARIABLE INITIALIZATION /////////////////////////////////////////
283 
284     uint256 constant public CLRS_UNIT = 10 ** 18;
285     uint256 public totalSupply = 86374977 * CLRS_UNIT;
286 
287     //  Constants
288     uint256 constant public maxIcoSupply = 48369987 * CLRS_UNIT;           // ICO pool allocation
289     uint256 constant public Company = 7773748 * CLRS_UNIT;     //  Company pool allocation
290     uint256 constant public Bonus = 16411245 * CLRS_UNIT;  // Bonus Allocation
291     uint256 constant public Bounty = 1727500 * CLRS_UNIT;  // Bounty Allocation
292     uint256 constant public advisorsAllocation = 4318748 * CLRS_UNIT;          // Advisors Allocation
293     uint256 constant public CLRSinTeamAllocation = 7773748 * CLRS_UNIT;    // CLRSin Team allocation
294 
295    // Addresses of Patrons
296    address public constant ICOSTAKE = 0xd82896Ea0B5848dc3b75bbECc747947F64077b7c;
297    address public constant COMPANY_STAKE_1 = 0x19333A742dcd220683C2231c0FAaCcb9c810C0B5;
298     address public constant COMPANY_STAKE_2 = 0x19333A742dcd220683C2231c0FAaCcb9c810C0B5;
299      address public constant COMPANY_STAKE_3 = 0x19333A742dcd220683C2231c0FAaCcb9c810C0B5;
300       address public constant COMPANY_STAKE_4 = 0x19333A742dcd220683C2231c0FAaCcb9c810C0B5;
301        address public constant COMPANY_STAKE_5 = 0x19333A742dcd220683C2231c0FAaCcb9c810C0B5;
302     address public constant ADVISOR_1 = 0xf0eB71d3b31fEe5D15220A2ac418A784c962Eb53;
303     address public constant ADVISOR_2 = 0xFd6b0691Cd486B4124fFD9FBe9e013463868E2B4;
304     address public constant ADVISOR_3 = 0xCFb32aFA7752170043aaC32794397C8673778765;
305     address public constant ADVISOR_4 = 0x08441513c0Fc653a739F34A97eF6B2B05609a4E4;
306     address public constant ADVISOR_5 = 0xFd6b0691Cd486B4124fFD9FBe9e013463868E2B4;
307     address public constant TEAM_1 = 0xc4896CB7486ed8821B525D858c85D4321e8e5685;
308     address public constant TEAM_2 = 0x304765b9c3072E54b7397E2F55D1463BD62802C3;
309     address public constant TEAM_3 = 0x46abC1d38573E8726c6C0568CC01f35fE5FF4765;
310     address public constant TEAM_4 = 0x36Bf4b1DDd796eaf1f962cB0E0327C15096fae41;
311     address public constant TEAM_5 = 0xc4896CB7486ed8821B525D858c85D4321e8e5685;
312     address public constant BONUS_1 = 0x19333A742dcd220683C2231c0FAaCcb9c810C0B5;
313     address public constant BONUS_2 = 0x19333A742dcd220683C2231c0FAaCcb9c810C0B5;
314     address public constant BONUS_3 = 0x19333A742dcd220683C2231c0FAaCcb9c810C0B5;
315     address public constant BONUS_4 = 0x19333A742dcd220683C2231c0FAaCcb9c810C0B5;
316     address public constant BONUS_5 = 0x19333A742dcd220683C2231c0FAaCcb9c810C0B5;
317     address public constant BOUNTY_1 = 0x19333A742dcd220683C2231c0FAaCcb9c810C0B5;
318     address public constant BOUNTY_2 = 0x19333A742dcd220683C2231c0FAaCcb9c810C0B5;
319     address public constant BOUNTY_3 = 0x19333A742dcd220683C2231c0FAaCcb9c810C0B5;
320     address public constant BOUNTY_4 = 0x19333A742dcd220683C2231c0FAaCcb9c810C0B5;
321     address public constant BOUNTY_5 = 0x19333A742dcd220683C2231c0FAaCcb9c810C0B5;
322 
323 
324 
325 
326 
327 
328     // Stakes of COMPANY
329 uint256 constant public COMPANY_1 = 7773744 * CLRS_UNIT; //token allocated to  company1
330 uint256 constant public COMPANY_2 = 1 * CLRS_UNIT; //token allocated to  company1
331 uint256 constant public COMPANY_3 = 1 * CLRS_UNIT; //token allocated to  company1
332 uint256 constant public COMPANY_4 = 1 * CLRS_UNIT; //token allocated to  company1
333 uint256 constant public COMPANY_5 = 1 * CLRS_UNIT; //token allocated to  company1
334 
335 // Stakes of ADVISORS
336 uint256 constant public ADVISOR1 = 863750 * CLRS_UNIT; //token allocated to adv1
337 uint256 constant public ADVISOR2 = 863750 * CLRS_UNIT; //token allocated to  adv2
338 uint256 constant public ADVISOR3 = 431875 * CLRS_UNIT; //token allocated to  adv3
339 uint256 constant public ADVISOR4 = 431875 * CLRS_UNIT; //token allocated to  adv4
340 uint256 constant public ADVISOR5 = 863750 * CLRS_UNIT; //token allocated to adv5
341 
342 
343 // Stakes of TEAM
344 uint256 constant public TEAM1 = 3876873 * CLRS_UNIT; //token allocated to  team1
345 uint256 constant public TEAM2 = 3876874 * CLRS_UNIT; //token allocated to  team2
346 uint256 constant public TEAM3 = 10000 * CLRS_UNIT; //token allocated to  team3
347 uint256 constant public TEAM4 = 10000 * CLRS_UNIT; //token allocated to  team4
348 uint256 constant public TEAM5 = 1 * CLRS_UNIT; //token allocated to  team5
349 
350 
351 // Stakes of BONUS
352 uint256 constant public BONUS1 = 16411241 * CLRS_UNIT; //token allocated to bonus1
353 uint256 constant public BONUS2 = 1 * CLRS_UNIT; //token allocated to bonus2
354 uint256 constant public BONUS3 = 1 * CLRS_UNIT; //token allocated to bonus3
355 uint256 constant public BONUS4 = 1 * CLRS_UNIT; //token allocated to bonus4
356 uint256 constant public BONUS5 = 1 * CLRS_UNIT; //token allocated to bonus5
357 
358 // Stakes of BOUNTY
359 uint256 constant public BOUNTY1 = 1727400 * CLRS_UNIT; //token allocated to bounty1
360 uint256 constant public BOUNTY2 = 1 * CLRS_UNIT; //token allocated to bounty2
361 uint256 constant public BOUNTY3 = 1 * CLRS_UNIT; //token allocated bounty3
362 uint256 constant public BOUNTY4 = 1 * CLRS_UNIT; //token allocated bounty4
363 uint256 constant public BOUNTY5 = 1 * CLRS_UNIT; //token allocated bounty5
364 
365 
366 
367 
368 
369 
370 
371 
372 
373 
374     //  Variables
375 
376 uint256 public totalAllocatedToCompany = 0;     // Counter to keep track of comapny token allocation
377 uint256 public totalAllocatedToAdvisor = 0;        // Counter to keep track of advisor token allocation
378 uint256 public totalAllocatedToTEAM = 0;     // Counter to keep track of team token allocation
379 uint256 public totalAllocatedToBONUS = 0;        // Counter to keep track of bonus token allocation
380 uint256 public totalAllocatedToBOUNTY = 0;      // Counter to keep track of bounty token allocation
381 
382 uint256 public remaintokensteam=0;
383 uint256 public remaintokensadvisors=0;
384 uint256 public remaintokensbounty=0;
385 uint256 public remaintokensbonus=0;
386 uint256 public remaintokenscompany=0;
387 uint256 public totremains=0;
388 
389 
390 uint256 public totalAllocated = 0;             // Counter to keep track of overall token allocation
391     uint256 public endTime;                                     // timestamp
392 
393     bool internal isReleasedToPublic = false; // Flag to allow transfer/transferFrom
394 
395     bool public isReleasedToadv = false;
396     bool public isReleasedToteam = false;
397 ///////////////////////////////////////// MODIFIERS /////////////////////////////////////////
398 
399     // CLRSin Team timelock
400    /* modifier safeTimelock() {
401         require(now >= endTime + 52 weeks);
402         _;
403     }
404 
405     // Advisor Team timelock
406     modifier advisorTimelock() {
407         require(now >= endTime + 26 weeks);
408         _;
409     }*/
410 
411 
412 
413     ///////////////////////////////////////// CONSTRUCTOR /////////////////////////////////////////
414 
415 
416     function CLRSToken()
417     ERC20Token("CLRS", "CLRS", 18)
418      {
419 
420 
421         balanceOf[ICOSTAKE] = maxIcoSupply; // ico CLRS tokens
422         balanceOf[COMPANY_STAKE_1] = COMPANY_1; // Company1 CLRS tokens
423          balanceOf[COMPANY_STAKE_2] = COMPANY_2; // Company2 CLRS tokens
424           balanceOf[COMPANY_STAKE_3] = COMPANY_3; // Company3 CLRS tokens
425            balanceOf[COMPANY_STAKE_4] = COMPANY_4; // Company4 CLRS tokens
426             balanceOf[COMPANY_STAKE_5] = COMPANY_5; // Company5 CLRS tokens
427             totalAllocatedToCompany = safeAdd(totalAllocatedToCompany, COMPANY_1);
428 totalAllocatedToCompany = safeAdd(totalAllocatedToCompany, COMPANY_2);
429 totalAllocatedToCompany = safeAdd(totalAllocatedToCompany, COMPANY_3);
430 totalAllocatedToCompany = safeAdd(totalAllocatedToCompany, COMPANY_4);
431 totalAllocatedToCompany = safeAdd(totalAllocatedToCompany, COMPANY_5);
432 
433 remaintokenscompany=safeSub(Company,totalAllocatedToCompany);
434 
435 balanceOf[ICOSTAKE]=safeAdd(balanceOf[ICOSTAKE],remaintokenscompany);
436 
437         balanceOf[BONUS_1] = BONUS1;       // bonus1 CLRS tokens
438         balanceOf[BONUS_2] = BONUS2;       // bonus2 CLRS tokens
439         balanceOf[BONUS_3] = BONUS3;       // bonus3 CLRS tokens
440         balanceOf[BONUS_4] = BONUS4;       // bonus4 CLRS tokens
441         balanceOf[BONUS_5] = BONUS5;       // bonus5 CLRS tokens
442         totalAllocatedToBONUS = safeAdd(totalAllocatedToBONUS, BONUS1);
443 totalAllocatedToBONUS = safeAdd(totalAllocatedToBONUS, BONUS2);
444 totalAllocatedToBONUS = safeAdd(totalAllocatedToBONUS, BONUS3);
445 totalAllocatedToBONUS = safeAdd(totalAllocatedToBONUS, BONUS4);
446 totalAllocatedToBONUS = safeAdd(totalAllocatedToBONUS, BONUS5);
447 
448 remaintokensbonus=safeSub(Bonus,totalAllocatedToBONUS);
449 
450 balanceOf[ICOSTAKE]=safeAdd(balanceOf[ICOSTAKE],remaintokensbonus);
451 
452         balanceOf[BOUNTY_1] = BOUNTY1;       // BOUNTY1 CLRS tokens
453         balanceOf[BOUNTY_2] = BOUNTY2;       // BOUNTY2 CLRS tokens
454         balanceOf[BOUNTY_3] = BOUNTY3;       // BOUNTY3 CLRS tokens
455         balanceOf[BOUNTY_4] = BOUNTY4;       // BOUNTY4 CLRS tokens
456         balanceOf[BOUNTY_5] = BOUNTY5;       // BOUNTY5 CLRS tokens
457 
458 totalAllocatedToBOUNTY = safeAdd(totalAllocatedToBOUNTY, BOUNTY1);
459 totalAllocatedToBOUNTY = safeAdd(totalAllocatedToBOUNTY, BOUNTY2);
460 totalAllocatedToBOUNTY = safeAdd(totalAllocatedToBOUNTY, BOUNTY3);
461 totalAllocatedToBOUNTY = safeAdd(totalAllocatedToBOUNTY, BOUNTY4);
462 totalAllocatedToBOUNTY = safeAdd(totalAllocatedToBOUNTY, BOUNTY5);
463 
464 remaintokensbounty=safeSub(Bounty,totalAllocatedToBOUNTY);
465 balanceOf[ICOSTAKE]=safeAdd(balanceOf[ICOSTAKE],remaintokensbounty);
466 
467 
468         allocateAdvisorTokens() ;
469         allocateCLRSinTeamTokens();
470 
471 
472         totremains=safeAdd(totremains,remaintokenscompany);
473         totremains=safeAdd(totremains,remaintokensbounty);
474         totremains=safeAdd(totremains,remaintokensbonus);
475         totremains=safeAdd(totremains,remaintokensteam);
476         totremains=safeAdd(totremains,remaintokensadvisors);
477 
478 
479 
480   burnTokens(totremains);
481 
482 totalAllocated += maxIcoSupply+ totalAllocatedToCompany+ totalAllocatedToBONUS + totalAllocatedToBOUNTY;  // Add to total Allocated funds
483     }
484 
485 ///////////////////////////////////////// ERC20 OVERRIDE /////////////////////////////////////////
486 
487     /**
488         @dev send coins
489         throws on any error rather then return a false flag to minimize user errors
490         in addition to the standard checks, the function throws if transfers are disabled
491 
492         @param _to      target address
493         @param _value   transfer amount
494 
495         @return true if the transfer was successful, throws if it wasn't
496     */
497     /*function transfer(address _to, uint256 _value) public returns (bool success) {
498         if (isTransferAllowed() == true) {
499             assert(super.transfer(_to, _value));
500             return true;
501         }
502         revert();
503     }
504 
505     /**
506         @dev an account/contract attempts to get the coins
507         throws on any error rather then return a false flag to minimize user errors
508         in addition to the standard checks, the function throws if transfers are disabled
509 
510         @param _from    source address
511         @param _to      target address
512         @param _value   transfer amount
513 
514         @return true if the transfer was successful, throws if it wasn't
515     */
516    /* function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
517         if (isTransferAllowed() == true ) {
518             assert(super.transferFrom(_from, _to, _value));
519             return true;
520         }
521 
522         revert();
523     }*/
524 
525 
526      /**
527      * Allow transfer only after finished
528      */
529         //allows to dissable transfers while minting and in case of emergency
530 
531 
532 
533     modifier canTransfer() {
534         require( isTransferAllowedteam()==true );
535         _;
536     }
537 
538    modifier canTransferadv() {
539         require( isTransferAllowedadv()==true );
540         _;
541     }
542 
543 
544     function transfer(address _to, uint256 _value) canTransfer canTransferadv public returns (bool) {
545         return super.transfer(_to, _value);
546     }
547 
548     function transferFrom(address _from, address _to, uint256 _value) canTransfer canTransferadv public returns (bool) {
549         return super.transferFrom(_from, _to, _value);
550     }
551 
552 
553 
554 
555 
556 ///////////////////////////////////////// ALLOCATION FUNCTIONS /////////////////////////////////////////
557 
558 
559     function allocateCLRSinTeamTokens() public returns(bool success) {
560         require(totalAllocatedToTEAM < CLRSinTeamAllocation);
561 
562         balanceOf[TEAM_1] = safeAdd(balanceOf[TEAM_1], TEAM1);       // TEAM1 CLRS tokens
563         balanceOf[TEAM_2] = safeAdd(balanceOf[TEAM_2], TEAM2);       // TEAM2 CLRS tokens
564         balanceOf[TEAM_3] = safeAdd(balanceOf[TEAM_3], TEAM3);        // TEAM3 CLRS tokens
565         balanceOf[TEAM_4] = safeAdd(balanceOf[TEAM_4], TEAM4);        // TEAM4 CLRS tokens
566         balanceOf[TEAM_5] = safeAdd(balanceOf[TEAM_5], TEAM5);       // TEAM5 CLRS tokens
567        /*Transfer(0x0, TEAM_1, TEAM1);
568        Transfer(0x0, TEAM_2, TEAM2);
569        Transfer(0x0, TEAM_3, TEAM3);
570        Transfer(0x0, TEAM_4, TEAM4);
571        Transfer(0x0, TEAM_5, TEAM5);*/
572 
573        totalAllocatedToTEAM = safeAdd(totalAllocatedToTEAM, TEAM1);
574 totalAllocatedToTEAM = safeAdd(totalAllocatedToTEAM, TEAM2);
575 totalAllocatedToTEAM = safeAdd(totalAllocatedToTEAM, TEAM3);
576 totalAllocatedToTEAM = safeAdd(totalAllocatedToTEAM, TEAM4);
577 totalAllocatedToTEAM = safeAdd(totalAllocatedToTEAM, TEAM5);
578 
579 totalAllocated +=  totalAllocatedToTEAM;
580 
581 
582  remaintokensteam=safeSub(CLRSinTeamAllocation,totalAllocatedToTEAM);
583 
584 balanceOf[ICOSTAKE]=safeAdd(balanceOf[ICOSTAKE],remaintokensteam);
585 
586             return true;
587 
588 
589     }
590 
591 
592     function allocateAdvisorTokens() public returns(bool success) {
593         require(totalAllocatedToAdvisor < advisorsAllocation);
594 
595         balanceOf[ADVISOR_1] = safeAdd(balanceOf[ADVISOR_1], ADVISOR1);
596         balanceOf[ADVISOR_2] = safeAdd(balanceOf[ADVISOR_2], ADVISOR2);
597         balanceOf[ADVISOR_3] = safeAdd(balanceOf[ADVISOR_3], ADVISOR3);
598         balanceOf[ADVISOR_4] = safeAdd(balanceOf[ADVISOR_4], ADVISOR4);
599         balanceOf[ADVISOR_5] = safeAdd(balanceOf[ADVISOR_5], ADVISOR5);
600        /*Transfer(0x0, ADVISOR_1, ADVISOR1);
601        Transfer(0x0, ADVISOR_2, ADVISOR2);
602        Transfer(0x0, ADVISOR_3, ADVISOR3);
603        Transfer(0x0, ADVISOR_4, ADVISOR4);
604        Transfer(0x0, ADVISOR_5, ADVISOR5);*/
605 
606        totalAllocatedToAdvisor = safeAdd(totalAllocatedToAdvisor, ADVISOR1);
607 totalAllocatedToAdvisor = safeAdd(totalAllocatedToAdvisor, ADVISOR2);
608 totalAllocatedToAdvisor = safeAdd(totalAllocatedToAdvisor, ADVISOR3);
609 totalAllocatedToAdvisor = safeAdd(totalAllocatedToAdvisor, ADVISOR4);
610 totalAllocatedToAdvisor = safeAdd(totalAllocatedToAdvisor, ADVISOR5);
611 
612 totalAllocated +=  totalAllocatedToAdvisor;
613 
614 
615 remaintokensadvisors=safeSub(advisorsAllocation,totalAllocatedToAdvisor);
616 
617 balanceOf[ICOSTAKE]=safeAdd(balanceOf[ICOSTAKE],remaintokensadvisors);
618 
619         return true;
620     }
621 
622 
623 
624     function releaseAdvisorTokens() ownerOnly {
625 
626          isReleasedToadv = true;
627 
628 
629     }
630 
631      function releaseCLRSinTeamTokens() ownerOnly  {
632 
633          isReleasedToteam = true;
634 
635 
636 
637 
638 
639     }
640 
641 
642 
643     function burnTokens(uint256 _value) ownerOnly returns(bool success) {
644         uint256 amountOfTokens = _value;
645 
646         balanceOf[msg.sender]=safeSub(balanceOf[msg.sender], amountOfTokens);
647         totalSupply=safeSub(totalSupply, amountOfTokens);
648         Transfer(msg.sender, 0x0, amountOfTokens);
649         return true;
650     }
651 
652 
653 
654     /**
655         @dev Function to allow transfers
656         can only be called by the owner of the contract
657         Transfers will be allowed regardless after the crowdfund end time.
658     */
659     function allowTransfers() ownerOnly {
660         isReleasedToPublic = true;
661 
662     }
663 
664     function starttime() ownerOnly {
665 endTime =  now;
666 	}
667 
668 
669     /**
670         @dev User transfers are allowed/rejected
671         Transfers are forbidden before the end of the crowdfund
672     */
673     function isTransferAllowedteam() public returns(bool)
674     {
675 
676         if (isReleasedToteam==true)
677         return true;
678 
679         if(now < endTime + 52 weeks)
680 
681 {
682 if(msg.sender==TEAM_1 || msg.sender==TEAM_2 || msg.sender==TEAM_3 || msg.sender==TEAM_4 || msg.sender==TEAM_5)
683 
684 return false;
685 
686 
687 }
688 
689 
690 return true;
691     }
692 
693 
694  function isTransferAllowedadv() public returns(bool)
695     {
696         if (isReleasedToadv==true)
697         return true;
698 
699 
700 
701 
702         if(now < endTime + 26 weeks)
703 
704 {
705 if(msg.sender==ADVISOR_1 || msg.sender==ADVISOR_2 || msg.sender==ADVISOR_3 || msg.sender==ADVISOR_4 || msg.sender==ADVISOR_5)
706 
707 return false;
708 
709 
710 }
711 
712 return true;
713     }
714 
715 
716 
717 
718 }