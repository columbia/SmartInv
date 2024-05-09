1 pragma solidity ^0.4.11;
2 
3 // ----------------------------------------------------------------------------
4 // OAX 'openANX Token' crowdfunding contract
5 //
6 // Refer to http://openanx.org/ for further information.
7 //
8 // Enjoy. (c) openANX and BokkyPooBah / Bok Consulting Pty Ltd 2017. 
9 // The MIT Licence.
10 // ----------------------------------------------------------------------------
11 
12 
13 // ----------------------------------------------------------------------------
14 // OAX 'openANX Token' crowdfunding contract - ERC20 Token Interface
15 //
16 // Refer to http://openanx.org/ for further information.
17 //
18 // Enjoy. (c) openANX and BokkyPooBah / Bok Consulting Pty Ltd 2017. 
19 // The MIT Licence.
20 // ----------------------------------------------------------------------------
21 
22 
23 // ----------------------------------------------------------------------------
24 // ERC Token Standard #20 Interface
25 // https://github.com/ethereum/EIPs/issues/20
26 // ----------------------------------------------------------------------------
27 contract ERC20Interface {
28     uint public totalSupply;
29     function balanceOf(address _owner) constant returns (uint balance);
30     function transfer(address _to, uint _value) returns (bool success);
31     function transferFrom(address _from, address _to, uint _value) 
32         returns (bool success);
33     function approve(address _spender, uint _value) returns (bool success);
34     function allowance(address _owner, address _spender) constant 
35         returns (uint remaining);
36     event Transfer(address indexed _from, address indexed _to, uint _value);
37     event Approval(address indexed _owner, address indexed _spender, 
38         uint _value);
39 }
40 
41 
42 // ----------------------------------------------------------------------------
43 // OAX 'openANX Token' crowdfunding contract - Owned contracts
44 //
45 // Refer to http://openanx.org/ for further information.
46 //
47 // Enjoy. (c) openANX and BokkyPooBah / Bok Consulting Pty Ltd 2017. 
48 // The MIT Licence.
49 // ----------------------------------------------------------------------------
50 
51 // ----------------------------------------------------------------------------
52 // Owned contract
53 // ----------------------------------------------------------------------------
54 contract Owned {
55 
56     // ------------------------------------------------------------------------
57     // Current owner, and proposed new owner
58     // ------------------------------------------------------------------------
59     address public owner;
60     address public newOwner;
61 
62     // ------------------------------------------------------------------------
63     // Constructor - assign creator as the owner
64     // ------------------------------------------------------------------------
65     function Owned() {
66         owner = msg.sender;
67     }
68 
69 
70     // ------------------------------------------------------------------------
71     // Modifier to mark that a function can only be executed by the owner
72     // ------------------------------------------------------------------------
73     modifier onlyOwner {
74         require(msg.sender == owner);
75         _;
76     }
77 
78 
79     // ------------------------------------------------------------------------
80     // Owner can initiate transfer of contract to a new owner
81     // ------------------------------------------------------------------------
82     function transferOwnership(address _newOwner) onlyOwner {
83         newOwner = _newOwner;
84     }
85 
86  
87     // ------------------------------------------------------------------------
88     // New owner has to accept transfer of contract
89     // ------------------------------------------------------------------------
90     function acceptOwnership() {
91         require(msg.sender == newOwner);
92         OwnershipTransferred(owner, newOwner);
93         owner = newOwner;
94     }
95     event OwnershipTransferred(address indexed _from, address indexed _to);
96 }
97 
98 
99 // ----------------------------------------------------------------------------
100 // OAX 'openANX Token' crowdfunding contract
101 //
102 // Refer to http://openanx.org/ for further information.
103 //
104 // Enjoy. (c) openANX and BokkyPooBah / Bok Consulting Pty Ltd 2017. 
105 // The MIT Licence.
106 // ----------------------------------------------------------------------------
107 
108 
109 // ----------------------------------------------------------------------------
110 // Safe maths, borrowed from OpenZeppelin
111 // ----------------------------------------------------------------------------
112 library SafeMath {
113 
114     // ------------------------------------------------------------------------
115     // Add a number to another number, checking for overflows
116     // ------------------------------------------------------------------------
117     function add(uint a, uint b) internal returns (uint) {
118         uint c = a + b;
119         assert(c >= a && c >= b);
120         return c;
121     }
122 
123     // ------------------------------------------------------------------------
124     // Subtract a number from another number, checking for underflows
125     // ------------------------------------------------------------------------
126     function sub(uint a, uint b) internal returns (uint) {
127         assert(b <= a);
128         return a - b;
129     }
130 }
131 
132 
133 // ----------------------------------------------------------------------------
134 // OAX 'openANX Token' crowdfunding contract - Configuration
135 //
136 // Refer to http://openanx.org/ for further information.
137 //
138 // Enjoy. (c) openANX and BokkyPooBah / Bok Consulting Pty Ltd 2017. 
139 // The MIT Licence.
140 // ----------------------------------------------------------------------------
141 
142 // ----------------------------------------------------------------------------
143 // openANX crowdsale token smart contract - configuration parameters
144 // ----------------------------------------------------------------------------
145 contract OpenANXTokenConfig {
146 
147     // ------------------------------------------------------------------------
148     // Token symbol(), name() and decimals()
149     // ------------------------------------------------------------------------
150     string public constant SYMBOL = "OAX";
151     string public constant NAME = "openANX Token";
152     uint8 public constant DECIMALS = 18;
153 
154 
155     // ------------------------------------------------------------------------
156     // Decimal factor for multiplications from OAX unit to OAX natural unit
157     // ------------------------------------------------------------------------
158     uint public constant DECIMALSFACTOR = 10**uint(DECIMALS);
159 
160     // ------------------------------------------------------------------------
161     // Tranche 1 soft cap and hard cap, and total tokens
162     // ------------------------------------------------------------------------
163     uint public constant TOKENS_SOFT_CAP = 13000000 * DECIMALSFACTOR;
164     uint public constant TOKENS_HARD_CAP = 30000000 * DECIMALSFACTOR;
165     uint public constant TOKENS_TOTAL = 100000000 * DECIMALSFACTOR;
166 
167     // ------------------------------------------------------------------------
168     // Tranche 1 crowdsale start date and end date
169     // Do not use the `now` function here
170     // Start - Thursday, 22-Jun-17 13:00:00 UTC / 1pm GMT 22 June 2017
171     // End - Saturday, 22-Jul-17 13:00:00 UTC / 1pm GMT 22 July 2017 
172     // ------------------------------------------------------------------------
173     uint public constant START_DATE = 1498136400;
174     uint public constant END_DATE = 1500728400;
175 
176     // ------------------------------------------------------------------------
177     // 1 year and 2 year dates for locked tokens
178     // Do not use the `now` function here 
179     // ------------------------------------------------------------------------
180     uint public constant LOCKED_1Y_DATE = START_DATE + 365 days;
181     uint public constant LOCKED_2Y_DATE = START_DATE + 2 * 365 days;
182 
183     // ------------------------------------------------------------------------
184     // Individual transaction contribution min and max amounts
185     // Set to 0 to switch off, or `x ether`
186     // ------------------------------------------------------------------------
187     uint public CONTRIBUTIONS_MIN = 0 ether;
188     uint public CONTRIBUTIONS_MAX = 0 ether;
189 }
190 
191 
192 // ----------------------------------------------------------------------------
193 // OAX 'openANX Token' crowdfunding contract - locked tokens
194 //
195 // Refer to http://openanx.org/ for further information.
196 //
197 // Enjoy. (c) openANX and BokkyPooBah / Bok Consulting Pty Ltd 2017. 
198 // The MIT Licence.
199 // ----------------------------------------------------------------------------
200 
201 
202 
203 // ----------------------------------------------------------------------------
204 // Contract that holds the 1Y and 2Y locked token information
205 // ----------------------------------------------------------------------------
206 contract LockedTokens is OpenANXTokenConfig {
207     using SafeMath for uint;
208 
209     // ------------------------------------------------------------------------
210     // 1y and 2y locked totals, not including unsold tranche1 and all tranche2
211     // tokens
212     // ------------------------------------------------------------------------
213     uint public constant TOKENS_LOCKED_1Y_TOTAL = 14000000 * DECIMALSFACTOR;
214     uint public constant TOKENS_LOCKED_2Y_TOTAL = 26000000 * DECIMALSFACTOR;
215     
216     // ------------------------------------------------------------------------
217     // Tokens locked for 1 year for sale 2 in the following account
218     // ------------------------------------------------------------------------
219     address public TRANCHE2_ACCOUNT = 0x813703Eb676f3B6C76dA75cBa0cbC49DdbCA7B37;
220 
221     // ------------------------------------------------------------------------
222     // Current totalSupply of 1y and 2y locked tokens
223     // ------------------------------------------------------------------------
224     uint public totalSupplyLocked1Y;
225     uint public totalSupplyLocked2Y;
226 
227     // ------------------------------------------------------------------------
228     // Locked tokens mapping
229     // ------------------------------------------------------------------------
230     mapping (address => uint) public balancesLocked1Y;
231     mapping (address => uint) public balancesLocked2Y;
232 
233     // ------------------------------------------------------------------------
234     // Address of openANX crowdsale token contract
235     // ------------------------------------------------------------------------
236     ERC20Interface public tokenContract;
237 
238 
239     // ------------------------------------------------------------------------
240     // Constructor - called by crowdsale token contract
241     // ------------------------------------------------------------------------
242     function LockedTokens(address _tokenContract) {
243         tokenContract = ERC20Interface(_tokenContract);
244 
245         // --- 1y locked tokens ---
246 
247         // Confirm 1Y totals        
248         add1Y(0x4beE088efDBCC610EEEa101ded7204150AF1C8b9,1000000 * DECIMALSFACTOR);
249         add1Y(0x839551201f866907Eb5017bE79cEB48aDa58650c,925000 * DECIMALSFACTOR);
250         add1Y(0xa92d4Cd3412862386c234Be572Fe4A8FA4BB09c6,925000 * DECIMALSFACTOR);
251         add1Y(0xECf2B5fce33007E5669D63de39a4c663e56958dD,925000 * DECIMALSFACTOR);
252         add1Y(0xD6B7695bc74E2C950eb953316359Eab283C5Bda8,925000 * DECIMALSFACTOR);
253         add1Y(0xBE3463Eae26398D55a7118683079264BcF3ab24B,150000 * DECIMALSFACTOR);
254         add1Y(0xf47428Fb9A61c9f3312cB035AEE049FBa76ba62a,150000 * DECIMALSFACTOR);
255         add1Y(0xfCcc77165D822Ef9004714d829bDC267C743658a,50000 * DECIMALSFACTOR);
256         add1Y(0xaf8df2aCAec3d5d92dE42a6c19d7706A4F3E8D8b,50000 * DECIMALSFACTOR);
257         add1Y(0x22a6f9693856374BF2922cd837d07F6670E7FA4d,250000 * DECIMALSFACTOR);
258         add1Y(0x3F720Ca8FfF598F00a51DE32A8Cb58Ca73f22aDe,50000 * DECIMALSFACTOR);
259         add1Y(0xBd0D1954B301E414F0b5D0827A69EC5dD559e50B,50000 * DECIMALSFACTOR);
260         add1Y(0x2ad6B011FEcDE830c9cc4dc0d0b77F055D6b5990,50000 * DECIMALSFACTOR);
261         add1Y(0x0c5cD0E971cA18a0F0E0d581f4B93FaD31D608B0,2000085 * DECIMALSFACTOR);
262         add1Y(0xFaaDC4d80Eaf430Ab604337CB67d77eC763D3e23,200248 * DECIMALSFACTOR);
263         add1Y(0xDAef46f89c264182Cd87Ce93B620B63c7AfB14f7,1616920 * DECIMALSFACTOR);
264         add1Y(0x19cc59C30cE54706633dC29EdEbAE1efF1757b25,224980 * DECIMALSFACTOR);
265         add1Y(0xa130fE5D399104CA5AF168fbbBBe19F95d739741,745918 * DECIMALSFACTOR);
266         add1Y(0xC0cD1bf6F2939095a56B0DFa085Ba2886b84E7d1,745918 * DECIMALSFACTOR);
267         add1Y(0xf2C26e79eD264B0E3e5A5DFb1Dd91EA61f512C6e,745918 * DECIMALSFACTOR);
268         add1Y(0x5F876a8A5F1B66fbf3D0D119075b62aF4386e319,745918 * DECIMALSFACTOR);
269         add1Y(0xb8E046570800Dd76720aF6d42d3cCae451F54f15,745920 * DECIMALSFACTOR);
270         add1Y(0xA524fa65Aac4647fa7bA2c20D22F64450c351bBd,714286 * DECIMALSFACTOR);
271         add1Y(0x27209b276C15a936BCE08D7D70f0c97aeb3CE8c3,13889 * DECIMALSFACTOR);
272 
273         assert(totalSupplyLocked1Y == TOKENS_LOCKED_1Y_TOTAL);
274 
275         // --- 2y locked tokens ---
276         add2Y(0x4beE088efDBCC610EEEa101ded7204150AF1C8b9,1000000 * DECIMALSFACTOR);
277         add2Y(0x839551201f866907Eb5017bE79cEB48aDa58650c,925000 * DECIMALSFACTOR);
278         add2Y(0xa92d4Cd3412862386c234Be572Fe4A8FA4BB09c6,925000 * DECIMALSFACTOR);
279         add2Y(0xECf2B5fce33007E5669D63de39a4c663e56958dD,925000 * DECIMALSFACTOR);
280         add2Y(0xD6B7695bc74E2C950eb953316359Eab283C5Bda8,925000 * DECIMALSFACTOR);
281         add2Y(0xBE3463Eae26398D55a7118683079264BcF3ab24B,150000 * DECIMALSFACTOR);
282         add2Y(0xf47428Fb9A61c9f3312cB035AEE049FBa76ba62a,150000 * DECIMALSFACTOR);
283         add2Y(0xfCcc77165D822Ef9004714d829bDC267C743658a,50000 * DECIMALSFACTOR);
284         add2Y(0xDAef46f89c264182Cd87Ce93B620B63c7AfB14f7,500000 * DECIMALSFACTOR);
285         add2Y(0xaf8df2aCAec3d5d92dE42a6c19d7706A4F3E8D8b,50000 * DECIMALSFACTOR);
286         add2Y(0x22a6f9693856374BF2922cd837d07F6670E7FA4d,250000 * DECIMALSFACTOR);
287         add2Y(0x3F720Ca8FfF598F00a51DE32A8Cb58Ca73f22aDe,50000 * DECIMALSFACTOR);
288         add2Y(0xBd0D1954B301E414F0b5D0827A69EC5dD559e50B,50000 * DECIMALSFACTOR);
289         add2Y(0x2ad6B011FEcDE830c9cc4dc0d0b77F055D6b5990,50000 * DECIMALSFACTOR);
290 
291         //treasury
292         add2Y(0x990a2D172398007fcbd5078D84696BdD8cCDf7b2,20000000 * DECIMALSFACTOR);
293 
294         assert(totalSupplyLocked2Y == TOKENS_LOCKED_2Y_TOTAL);
295     }
296 
297 
298     // ------------------------------------------------------------------------
299     // Add remaining tokens to locked 1y balances
300     // ------------------------------------------------------------------------
301     function addRemainingTokens() {
302         // Only the crowdsale contract can call this function
303         require(msg.sender == address(tokenContract));
304         // Total tokens to be created
305         uint remainingTokens = TOKENS_TOTAL;
306         // Minus precommitments and public crowdsale tokens
307         remainingTokens = remainingTokens.sub(tokenContract.totalSupply());
308         // Minus 1y locked tokens
309         remainingTokens = remainingTokens.sub(totalSupplyLocked1Y);
310         // Minus 2y locked tokens
311         remainingTokens = remainingTokens.sub(totalSupplyLocked2Y);
312         // Unsold tranche1 and tranche2 tokens to be locked for 1y 
313         add1Y(TRANCHE2_ACCOUNT, remainingTokens);
314     }
315 
316 
317     // ------------------------------------------------------------------------
318     // Add to 1y locked balances and totalSupply
319     // ------------------------------------------------------------------------
320     function add1Y(address account, uint value) private {
321         balancesLocked1Y[account] = balancesLocked1Y[account].add(value);
322         totalSupplyLocked1Y = totalSupplyLocked1Y.add(value);
323     }
324 
325 
326     // ------------------------------------------------------------------------
327     // Add to 2y locked balances and totalSupply
328     // ------------------------------------------------------------------------
329     function add2Y(address account, uint value) private {
330         balancesLocked2Y[account] = balancesLocked2Y[account].add(value);
331         totalSupplyLocked2Y = totalSupplyLocked2Y.add(value);
332     }
333 
334 
335     // ------------------------------------------------------------------------
336     // 1y locked balances for an account
337     // ------------------------------------------------------------------------
338     function balanceOfLocked1Y(address account) constant returns (uint balance) {
339         return balancesLocked1Y[account];
340     }
341 
342 
343     // ------------------------------------------------------------------------
344     // 2y locked balances for an account
345     // ------------------------------------------------------------------------
346     function balanceOfLocked2Y(address account) constant returns (uint balance) {
347         return balancesLocked2Y[account];
348     }
349 
350 
351     // ------------------------------------------------------------------------
352     // 1y and 2y locked balances for an account
353     // ------------------------------------------------------------------------
354     function balanceOfLocked(address account) constant returns (uint balance) {
355         return balancesLocked1Y[account].add(balancesLocked2Y[account]);
356     }
357 
358 
359     // ------------------------------------------------------------------------
360     // 1y and 2y locked total supply
361     // ------------------------------------------------------------------------
362     function totalSupplyLocked() constant returns (uint) {
363         return totalSupplyLocked1Y + totalSupplyLocked2Y;
364     }
365 
366 
367     // ------------------------------------------------------------------------
368     // An account can unlock their 1y locked tokens 1y after token launch date
369     // ------------------------------------------------------------------------
370     function unlock1Y() {
371         require(now >= LOCKED_1Y_DATE);
372         uint amount = balancesLocked1Y[msg.sender];
373         require(amount > 0);
374         balancesLocked1Y[msg.sender] = 0;
375         totalSupplyLocked1Y = totalSupplyLocked1Y.sub(amount);
376         if (!tokenContract.transfer(msg.sender, amount)) throw;
377     }
378 
379 
380     // ------------------------------------------------------------------------
381     // An account can unlock their 2y locked tokens 2y after token launch date
382     // ------------------------------------------------------------------------
383     function unlock2Y() {
384         require(now >= LOCKED_2Y_DATE);
385         uint amount = balancesLocked2Y[msg.sender];
386         require(amount > 0);
387         balancesLocked2Y[msg.sender] = 0;
388         totalSupplyLocked2Y = totalSupplyLocked2Y.sub(amount);
389         if (!tokenContract.transfer(msg.sender, amount)) throw;
390     }
391 }
392 
393 
394 
395 // ----------------------------------------------------------------------------
396 // ERC20 Token, with the addition of symbol, name and decimals
397 // ----------------------------------------------------------------------------
398 contract ERC20Token is ERC20Interface, Owned {
399     using SafeMath for uint;
400 
401     // ------------------------------------------------------------------------
402     // symbol(), name() and decimals()
403     // ------------------------------------------------------------------------
404     string public symbol;
405     string public name;
406     uint8 public decimals;
407 
408     // ------------------------------------------------------------------------
409     // Balances for each account
410     // ------------------------------------------------------------------------
411     mapping(address => uint) balances;
412 
413     // ------------------------------------------------------------------------
414     // Owner of account approves the transfer of an amount to another account
415     // ------------------------------------------------------------------------
416     mapping(address => mapping (address => uint)) allowed;
417 
418 
419     // ------------------------------------------------------------------------
420     // Constructor
421     // ------------------------------------------------------------------------
422     function ERC20Token(
423         string _symbol, 
424         string _name, 
425         uint8 _decimals, 
426         uint _totalSupply
427     ) Owned() {
428         symbol = _symbol;
429         name = _name;
430         decimals = _decimals;
431         totalSupply = _totalSupply;
432         balances[owner] = _totalSupply;
433     }
434 
435 
436     // ------------------------------------------------------------------------
437     // Get the account balance of another account with address _owner
438     // ------------------------------------------------------------------------
439     function balanceOf(address _owner) constant returns (uint balance) {
440         return balances[_owner];
441     }
442 
443 
444     // ------------------------------------------------------------------------
445     // Transfer the balance from owner's account to another account
446     // ------------------------------------------------------------------------
447     function transfer(address _to, uint _amount) returns (bool success) {
448         if (balances[msg.sender] >= _amount             // User has balance
449             && _amount > 0                              // Non-zero transfer
450             && balances[_to] + _amount > balances[_to]  // Overflow check
451         ) {
452             balances[msg.sender] = balances[msg.sender].sub(_amount);
453             balances[_to] = balances[_to].add(_amount);
454             Transfer(msg.sender, _to, _amount);
455             return true;
456         } else {
457             return false;
458         }
459     }
460 
461 
462     // ------------------------------------------------------------------------
463     // Allow _spender to withdraw from your account, multiple times, up to the
464     // _value amount. If this function is called again it overwrites the
465     // current allowance with _value.
466     // ------------------------------------------------------------------------
467     function approve(
468         address _spender,
469         uint _amount
470     ) returns (bool success) {
471         allowed[msg.sender][_spender] = _amount;
472         Approval(msg.sender, _spender, _amount);
473         return true;
474     }
475 
476 
477     // ------------------------------------------------------------------------
478     // Spender of tokens transfer an amount of tokens from the token owner's
479     // balance to another account. The owner of the tokens must already
480     // have approve(...)-d this transfer
481     // ------------------------------------------------------------------------
482     function transferFrom(
483         address _from,
484         address _to,
485         uint _amount
486     ) returns (bool success) {
487         if (balances[_from] >= _amount                  // From a/c has balance
488             && allowed[_from][msg.sender] >= _amount    // Transfer approved
489             && _amount > 0                              // Non-zero transfer
490             && balances[_to] + _amount > balances[_to]  // Overflow check
491         ) {
492             balances[_from] = balances[_from].sub(_amount);
493             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
494             balances[_to] = balances[_to].add(_amount);
495             Transfer(_from, _to, _amount);
496             return true;
497         } else {
498             return false;
499         }
500     }
501 
502 
503     // ------------------------------------------------------------------------
504     // Returns the amount of tokens approved by the owner that can be
505     // transferred to the spender's account
506     // ------------------------------------------------------------------------
507     function allowance(
508         address _owner, 
509         address _spender
510     ) constant returns (uint remaining) {
511         return allowed[_owner][_spender];
512     }
513 }
514 
515 
516 // ----------------------------------------------------------------------------
517 // openANX crowdsale token smart contract
518 // ----------------------------------------------------------------------------
519 contract OpenANXToken is ERC20Token, OpenANXTokenConfig {
520 
521     // ------------------------------------------------------------------------
522     // Has the crowdsale been finalised?
523     // ------------------------------------------------------------------------
524     bool public finalised = false;
525 
526     // ------------------------------------------------------------------------
527     // Number of tokens per 1,000 ETH
528     // This can be adjusted as the ETH/USD rate changes
529     //
530     // Indicative rate of ETH per token of 0.00290923 at 8 June 2017
531     // 
532     // This is the same as 1 / 0.00290923 = 343.733565238912015 OAX per ETH
533     //
534     // tokensPerEther  = 343.733565238912015
535     // tokensPerKEther = 343,733.565238912015
536     // tokensPerKEther = 343,734 rounded to an uint, six significant figures
537     // ------------------------------------------------------------------------
538     uint public tokensPerKEther = 343734;
539 
540     // ------------------------------------------------------------------------
541     // Locked Tokens - holds the 1y and 2y locked tokens information
542     // ------------------------------------------------------------------------
543     LockedTokens public lockedTokens;
544 
545     // ------------------------------------------------------------------------
546     // Wallet receiving the raised funds 
547     // ------------------------------------------------------------------------
548     address public wallet;
549 
550     // ------------------------------------------------------------------------
551     // Crowdsale participant's accounts need to be KYC verified KYC before
552     // the participant can move their tokens
553     // ------------------------------------------------------------------------
554     mapping(address => bool) public kycRequired;
555 
556 
557     // ------------------------------------------------------------------------
558     // Constructor
559     // ------------------------------------------------------------------------
560     function OpenANXToken(address _wallet) 
561         ERC20Token(SYMBOL, NAME, DECIMALS, 0)
562     {
563         wallet = _wallet;
564         lockedTokens = new LockedTokens(this);
565         require(address(lockedTokens) != 0x0);
566     }
567 
568     // ------------------------------------------------------------------------
569     // openANX can change the crowdsale wallet address
570     // Can be set at any time before or during the crowdsale
571     // Not relevant after the crowdsale is finalised as no more contributions
572     // are accepted
573     // ------------------------------------------------------------------------
574     function setWallet(address _wallet) onlyOwner {
575         wallet = _wallet;
576         WalletUpdated(wallet);
577     }
578     event WalletUpdated(address newWallet);
579 
580 
581     // ------------------------------------------------------------------------
582     // openANX can set number of tokens per 1,000 ETH
583     // Can only be set before the start of the crowdsale
584     // ------------------------------------------------------------------------
585     function setTokensPerKEther(uint _tokensPerKEther) onlyOwner {
586         require(now < START_DATE);
587         require(_tokensPerKEther > 0);
588         tokensPerKEther = _tokensPerKEther;
589         TokensPerKEtherUpdated(tokensPerKEther);
590     }
591     event TokensPerKEtherUpdated(uint tokensPerKEther);
592 
593 
594     // ------------------------------------------------------------------------
595     // Accept ethers to buy tokens during the crowdsale
596     // ------------------------------------------------------------------------
597     function () payable {
598         proxyPayment(msg.sender);
599     }
600 
601 
602     // ------------------------------------------------------------------------
603     // Accept ethers from one account for tokens to be created for another
604     // account. Can be used by exchanges to purchase tokens on behalf of 
605     // it's user
606     // ------------------------------------------------------------------------
607     function proxyPayment(address participant) payable {
608         // No contributions after the crowdsale is finalised
609         require(!finalised);
610 
611         // No contributions before the start of the crowdsale
612         require(now >= START_DATE);
613         // No contributions after the end of the crowdsale
614         require(now <= END_DATE);
615 
616         // No contributions below the minimum (can be 0 ETH)
617         require(msg.value >= CONTRIBUTIONS_MIN);
618         // No contributions above a maximum (if maximum is set to non-0)
619         require(CONTRIBUTIONS_MAX == 0 || msg.value < CONTRIBUTIONS_MAX);
620 
621         // Calculate number of tokens for contributed ETH
622         // `18` is the ETH decimals
623         // `- decimals` is the token decimals
624         // `+ 3` for the tokens per 1,000 ETH factor
625         uint tokens = msg.value * tokensPerKEther / 10**uint(18 - decimals + 3);
626 
627         // Check if the hard cap will be exceeded
628         require(totalSupply + tokens <= TOKENS_HARD_CAP);
629 
630         // Add tokens purchased to account's balance and total supply
631         balances[participant] = balances[participant].add(tokens);
632         totalSupply = totalSupply.add(tokens);
633 
634         // Log the tokens purchased 
635         Transfer(0x0, participant, tokens);
636         TokensBought(participant, msg.value, this.balance, tokens,
637              totalSupply, tokensPerKEther);
638 
639         // KYC verification required before participant can transfer the tokens
640         kycRequired[participant] = true;
641 
642         // Transfer the contributed ethers to the crowdsale wallet
643         if (!wallet.send(msg.value)) throw;
644     }
645     event TokensBought(address indexed buyer, uint ethers, 
646         uint newEtherBalance, uint tokens, uint newTotalSupply, 
647         uint tokensPerKEther);
648 
649 
650     // ------------------------------------------------------------------------
651     // openANX to finalise the crowdsale - to adding the locked tokens to 
652     // this contract and the total supply
653     // ------------------------------------------------------------------------
654     function finalise() onlyOwner {
655         // Can only finalise if raised > soft cap or after the end date
656         require(totalSupply >= TOKENS_SOFT_CAP || now > END_DATE);
657 
658         // Can only finalise once
659         require(!finalised);
660 
661         // Calculate and add remaining tokens to locked balances
662         lockedTokens.addRemainingTokens();
663 
664         // Allocate locked and premined tokens
665         balances[address(lockedTokens)] = balances[address(lockedTokens)].
666             add(lockedTokens.totalSupplyLocked());
667         totalSupply = totalSupply.add(lockedTokens.totalSupplyLocked());
668 
669         // Can only finalise once
670         finalised = true;
671     }
672 
673 
674     // ------------------------------------------------------------------------
675     // openANX to add precommitment funding token balance before the crowdsale
676     // commences
677     // ------------------------------------------------------------------------
678     function addPrecommitment(address participant, uint balance) onlyOwner {
679         require(now < START_DATE);
680         require(balance > 0);
681         balances[participant] = balances[participant].add(balance);
682         totalSupply = totalSupply.add(balance);
683         Transfer(0x0, participant, balance);
684     }
685     event PrecommitmentAdded(address indexed participant, uint balance);
686 
687 
688     // ------------------------------------------------------------------------
689     // Transfer the balance from owner's account to another account, with KYC
690     // verification check for the crowdsale participant's first transfer
691     // ------------------------------------------------------------------------
692     function transfer(address _to, uint _amount) returns (bool success) {
693         // Cannot transfer before crowdsale ends
694         require(finalised);
695         // Cannot transfer if KYC verification is required
696         require(!kycRequired[msg.sender]);
697         // Standard transfer
698         return super.transfer(_to, _amount);
699     }
700 
701 
702     // ------------------------------------------------------------------------
703     // Spender of tokens transfer an amount of tokens from the token owner's
704     // balance to another account, with KYC verification check for the
705     // crowdsale participant's first transfer
706     // ------------------------------------------------------------------------
707     function transferFrom(address _from, address _to, uint _amount) 
708         returns (bool success)
709     {
710         // Cannot transfer before crowdsale ends
711         require(finalised);
712         // Cannot transfer if KYC verification is required
713         require(!kycRequired[_from]);
714         // Standard transferFrom
715         return super.transferFrom(_from, _to, _amount);
716     }
717 
718 
719     // ------------------------------------------------------------------------
720     // openANX to KYC verify the participant's account
721     // ------------------------------------------------------------------------
722     function kycVerify(address participant) onlyOwner {
723         kycRequired[participant] = false;
724         KycVerified(participant);
725     }
726     event KycVerified(address indexed participant);
727 
728 
729     // ------------------------------------------------------------------------
730     // Any account can burn _from's tokens as long as the _from account has 
731     // approved the _amount to be burnt using
732     //   approve(0x0, _amount)
733     // ------------------------------------------------------------------------
734     function burnFrom(
735         address _from,
736         uint _amount
737     ) returns (bool success) {
738         if (balances[_from] >= _amount                  // From a/c has balance
739             && allowed[_from][0x0] >= _amount           // Transfer approved
740             && _amount > 0                              // Non-zero transfer
741             && balances[0x0] + _amount > balances[0x0]  // Overflow check
742         ) {
743             balances[_from] = balances[_from].sub(_amount);
744             allowed[_from][0x0] = allowed[_from][0x0].sub(_amount);
745             balances[0x0] = balances[0x0].add(_amount);
746             totalSupply = totalSupply.sub(_amount);
747             Transfer(_from, 0x0, _amount);
748             return true;
749         } else {
750             return false;
751         }
752     }
753 
754 
755     // ------------------------------------------------------------------------
756     // 1y locked balances for an account
757     // ------------------------------------------------------------------------
758     function balanceOfLocked1Y(address account) constant returns (uint balance) {
759         return lockedTokens.balanceOfLocked1Y(account);
760     }
761 
762 
763     // ------------------------------------------------------------------------
764     // 2y locked balances for an account
765     // ------------------------------------------------------------------------
766     function balanceOfLocked2Y(address account) constant returns (uint balance) {
767         return lockedTokens.balanceOfLocked2Y(account);
768     }
769 
770 
771     // ------------------------------------------------------------------------
772     // 1y and 2y locked balances for an account
773     // ------------------------------------------------------------------------
774     function balanceOfLocked(address account) constant returns (uint balance) {
775         return lockedTokens.balanceOfLocked(account);
776     }
777 
778 
779     // ------------------------------------------------------------------------
780     // 1y locked total supply
781     // ------------------------------------------------------------------------
782     function totalSupplyLocked1Y() constant returns (uint) {
783         if (finalised) {
784             return lockedTokens.totalSupplyLocked1Y();
785         } else {
786             return 0;
787         }
788     }
789 
790 
791     // ------------------------------------------------------------------------
792     // 2y locked total supply
793     // ------------------------------------------------------------------------
794     function totalSupplyLocked2Y() constant returns (uint) {
795         if (finalised) {
796             return lockedTokens.totalSupplyLocked2Y();
797         } else {
798             return 0;
799         }
800     }
801 
802 
803     // ------------------------------------------------------------------------
804     // 1y and 2y locked total supply
805     // ------------------------------------------------------------------------
806     function totalSupplyLocked() constant returns (uint) {
807         if (finalised) {
808             return lockedTokens.totalSupplyLocked();
809         } else {
810             return 0;
811         }
812     }
813 
814 
815     // ------------------------------------------------------------------------
816     // Unlocked total supply
817     // ------------------------------------------------------------------------
818     function totalSupplyUnlocked() constant returns (uint) {
819         if (finalised && totalSupply >= lockedTokens.totalSupplyLocked()) {
820             return totalSupply.sub(lockedTokens.totalSupplyLocked());
821         } else {
822             return 0;
823         }
824     }
825 
826 
827     // ------------------------------------------------------------------------
828     // openANX can transfer out any accidentally sent ERC20 tokens
829     // ------------------------------------------------------------------------
830     function transferAnyERC20Token(address tokenAddress, uint amount)
831       onlyOwner returns (bool success) 
832     {
833         return ERC20Interface(tokenAddress).transfer(owner, amount);
834     }
835 }