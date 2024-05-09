1 pragma solidity ^0.4.11;
2 
3 /**
4  * Eloplay Crowdsale Token Contract
5  * @author Eloplay team (2017)
6  * The MIT Licence
7  */
8 
9 
10 /**
11  * Safe maths, borrowed from OpenZeppelin
12  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
13  */
14 library SafeMath {
15 
16     /**
17      * Add a number to another number, checking for overflows
18      *
19      * @param a           first number
20      * @param b           second number
21      * @return            sum of a + b
22      */
23      function add(uint256 a, uint256 b) internal constant returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27      }
28 
29     /**
30      * Subtract a number from another number, checking for underflows
31      *
32      * @param a           first number
33      * @param b           second number
34      * @return            a - b
35      */
36     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41 }
42 
43 
44 /**
45  * Owned contract gives ownership checking
46  */
47 contract Owned {
48 
49     /**
50      * Current contract owner
51      */
52     address public owner;
53     /**
54      * New owner / pretender
55      */
56     address public newOwner;
57 
58     /**
59      * Event fires when ownership is transferred and accepted
60      *
61      * @param _from         initial owner
62      * @param _to           new owner
63      */
64     event OwnershipTransferred(address indexed _from, address indexed _to);
65 
66     /**
67      * Owned contract constructor
68      */
69     function Owned() {
70         owner = msg.sender;
71     }
72 
73     /**
74      * Modifier - used to check actions allowed only for contract owner
75      */
76     modifier onlyOwner {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     /**
82      * Request to change ownership (called by current owner)
83      *
84      * @param _newOwner         address to transfer ownership to
85      */
86     function transferOwnership(address _newOwner) onlyOwner {
87         newOwner = _newOwner;
88     }
89 
90     /**
91      * Accept ownership request, works only if called by new owner
92      */
93     function acceptOwnership() {
94         // Avoid multiple events triggering in case of several calls from owner
95         if (msg.sender == newOwner && owner != newOwner) {
96             OwnershipTransferred(owner, newOwner);
97             owner = newOwner;
98         }
99     }
100 }
101 
102 
103 /**
104  * ERC20 Token, with the addition of symbol, name and decimals
105  * https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20Token {
108     /**
109      * Use SafeMath to check over/underflows
110      */
111     using SafeMath for uint;
112 
113     /**
114      * Total Supply
115      */
116     uint256 public totalSupply = 0;
117 
118     /**
119      * Balances for each account
120      */
121     mapping(address => uint256) public balanceOf;
122 
123     /**
124      * Owner of account approves the transfer of an amount to another account
125      */
126     mapping(address => mapping (address => uint256)) public allowance;
127 
128     /**
129      * Event fires when tokens are transferred
130      *
131      * @param _from         spender address
132      * @param _to           target address
133      * @param _value        amount of tokens
134      */
135     event Transfer(address indexed _from, address indexed _to, uint256 _value);
136 
137     /**
138      * Event fires when spending of tokens are approved
139      *
140      * @param _owner        owner address
141      * @param _spender      spender address
142      * @param _value        amount of allowed tokens
143      */
144     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
145 
146     /**
147      * Transfer the balance from owner's account to another account
148      *
149      * @param _to         target address
150      * @param _amount     amount of tokens
151      * @return            true on success
152      */
153     function transfer(address _to, uint256 _amount) returns (bool success) {
154         if (balanceOf[msg.sender] >= _amount                // User has balance
155             && _amount > 0                                 // Non-zero transfer
156             && balanceOf[_to] + _amount > balanceOf[_to]     // Overflow check
157         ) {
158             balanceOf[msg.sender] -= _amount;
159             balanceOf[_to] += _amount;
160             Transfer(msg.sender, _to, _amount);
161             return true;
162         } else {
163             return false;
164         }
165     }
166 
167     /**
168      * Allow _spender to withdraw from your account, multiple times, up to the
169      * _value amount. If this function is called again it overwrites the
170      * current allowance with _value.
171      *
172      * @param _spender    spender address
173      * @param _amount     amount of tokens
174      * @return            true on success
175      */
176     function approve(address _spender, uint256 _amount) returns (bool success) {
177         allowance[msg.sender][_spender] = _amount;
178         Approval(msg.sender, _spender, _amount);
179         return true;
180     }
181 
182     /**
183      * Spender of tokens transfer an amount of tokens from the token owner's
184      * balance to the spender's account. The owner of the tokens must already
185      * have approve(...)-d this transfer
186      *
187      * @param _from       spender address
188      * @param _to         target address
189      * @param _amount     amount of tokens
190      * @return            true on success
191      */
192     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
193         if (balanceOf[_from] >= _amount                  // From a/c has balance
194             && allowance[_from][msg.sender] >= _amount    // Transfer approved
195             && _amount > 0                              // Non-zero transfer
196             && balanceOf[_to] + _amount > balanceOf[_to]  // Overflow check
197         ) {
198             balanceOf[_from] -= _amount;
199             allowance[_from][msg.sender] -= _amount;
200             balanceOf[_to] += _amount;
201             Transfer(_from, _to, _amount);
202             return true;
203         } else {
204             return false;
205         }
206     }
207 }
208 
209 
210 contract EloPlayToken is ERC20Token, Owned {
211 
212     /**
213      * Token data
214      */
215     string public constant symbol = "ELT";
216     string public constant name = "EloPlayToken";
217     uint8 public constant decimals = 18;
218 
219     /**
220      * Wallet where invested Ethers will be sent
221      */
222     address public TARGET_ADDRESS;
223 
224     /**
225      * Wallet where bonus tokens will be sent
226      */
227     address public TARGET_TOKENS_ADDRESS;
228 
229     /**
230      * Start/end timestamp (unix)
231      */
232     uint256 public START_TS;
233     uint256 public END_TS;
234 
235     /**
236      * CAP in ether - may be changed before crowdsale starts to match actual ETH/USD rate
237      */
238     uint256 public CAP;
239 
240     /**
241      * Usd/eth rate at start of ICO. Used for raised funds calculations
242      */
243     uint256 public USDETHRATE;
244 
245     /**
246      * Is contract halted (in case of emergency)
247      * Default value will be false (not halted)
248      */
249     bool public halted;
250 
251     /**
252      * Total Ethers invested
253      */
254     uint256 public totalEthers;
255 
256     /**
257      * Event fires when tokens are bought
258      *
259      * @param buyer                     tokens buyer
260      * @param ethers                    total Ethers invested (in wei)
261      * @param new_ether_balance         new Ethers balance (in wei)
262      * @param tokens                    tokens bought for transaction
263      * @param target_address_tokens     additional tokens generated for multisignature wallet
264      * @param new_total_supply          total tokens bought
265      * @param buy_price                 tokens/ETH rate for transaction
266      */
267     event TokensBought(address indexed buyer, uint256 ethers,
268         uint256 new_ether_balance, uint256 tokens, uint256 target_address_tokens,
269         uint256 new_total_supply, uint256 buy_price);
270 
271     /**
272      * Event fires when tokens are bought
273      *
274      * @param backer                    buyer
275      * @param amount                    total Ethers invested (in wei)
276      * @param isContribution            always true in our case
277      */
278     event FundTransfer(address backer, uint amount, bool isContribution);
279 
280 
281     /**
282      * EloPlayToken contract constructor
283      *
284      * @param _start_ts         crowdsale start timestamp (unix)
285      * @param _end_ts           crowdsale end timestamp (unix)
286      * @param _cap              crowdsale upper cap (in wei)
287      * @param _target_address   multisignature wallet where Ethers will be sent to
288      * @param _target_tokens_address   account where 30% of tokens will be sent to
289      * @param _usdethrate       USD to ETH rate
290      */
291     function EloPlayToken(uint256 _start_ts, uint256 _end_ts, uint256 _cap, address _target_address,  address _target_tokens_address, uint256 _usdethrate) {
292         START_TS        = _start_ts;
293         END_TS          = _end_ts;
294         CAP             = _cap;
295         USDETHRATE      = _usdethrate;
296         TARGET_ADDRESS  = _target_address;
297         TARGET_TOKENS_ADDRESS  = _target_tokens_address;
298     }
299 
300     /**
301      * Update cap before crowdsale starts
302      *
303      * @param _cap          new crowdsale upper cap (in wei)
304      * @param _usdethrate   USD to ETH rate
305      */
306     function updateCap(uint256 _cap, uint256 _usdethrate) onlyOwner {
307         // Don't process if halted
308         require(!halted);
309         // Make sure crowdsale isnt started yet
310         require(now < START_TS);
311         CAP = _cap;
312         USDETHRATE = _usdethrate;
313     }
314 
315     /**
316      * Get raised USD based on USDETHRATE
317      *
318      * @return            USD raised value
319      */
320     function totalUSD() constant returns (uint256) {
321         return totalEthers * USDETHRATE;
322     }
323 
324     /**
325      * Get tokens per ETH for current date/time
326      *
327      * @return            current tokens/ETH rate
328      */
329     function buyPrice() constant returns (uint256) {
330         return buyPriceAt(now);
331     }
332 
333     /**
334      * Get tokens per ETH for given date/time
335      *
336      * @param _at         timestamp (unix)
337      * @return            tokens/ETH rate for given timestamp
338      */
339     function buyPriceAt(uint256 _at) constant returns (uint256) {
340         if (_at < START_TS) {
341             return 0;
342         } else if (_at < START_TS + 3600) {
343             // 1st hour = 10000 + 20% = 12000
344             return 12000;
345         } else if (_at < START_TS + 3600 * 24) {
346             // 1st day = 10000 + 15% = 11500
347             return 11500;
348         } else if (_at < START_TS + 3600 * 24 * 7) {
349             // 1st week = 10000 + 10% = 11000
350             return 11000;
351         } else if (_at < START_TS + 3600 * 24 * 7 * 2) {
352             // 2nd week = 10000 + 5% = 10500
353             return 10500;
354         } else if (_at <= END_TS) {
355             // More than 2 weeks = 10000
356             return 10000;
357         } else {
358             return 0;
359         }
360     }
361 
362     /**
363      * Halt transactions in case of emergency
364      */
365     function halt() onlyOwner {
366         require(!halted);
367         halted = true;
368     }
369 
370     /**
371      * Unhalt halted contract
372      */
373     function unhalt() onlyOwner {
374         require(halted);
375         halted = false;
376     }
377 
378     /**
379      * Owner to add precommitment funding token balance before the crowdsale commences
380      * Used for pre-sale commitments, added manually
381      *
382      * @param _participant         address that will receive tokens
383      * @param _balance             number of tokens
384      * @param _ethers         Ethers value (needed for stats)
385      *
386      */
387     function addPrecommitment(address _participant, uint256 _balance, uint256 _ethers) onlyOwner {
388         require(now < START_TS);
389         // Minimum value = 1ELT
390         // Since we are using 18 decimals for token
391         require(_balance >= 1 ether);
392 
393         // To avoid overflow, first divide then multiply (to clearly show 70%+30%, result wasn't precalculated)
394         uint additional_tokens = _balance / 70 * 30;
395 
396         balanceOf[_participant] = balanceOf[_participant].add(_balance);
397         balanceOf[TARGET_TOKENS_ADDRESS] = balanceOf[TARGET_TOKENS_ADDRESS].add(additional_tokens);
398 
399         totalSupply = totalSupply.add(_balance);
400         totalSupply = totalSupply.add(additional_tokens);
401 
402         // Add ETH raised to total
403         totalEthers = totalEthers.add(_ethers);
404 
405         Transfer(0x0, _participant, _balance);
406         Transfer(0x0, TARGET_TOKENS_ADDRESS, additional_tokens);
407     }
408 
409     /**
410      * Buy tokens from the contract
411      */
412     function () payable {
413         proxyPayment(msg.sender);
414     }
415 
416     /**
417      * Exchanges can buy on behalf of participant
418      *
419      * @param _participant         address that will receive tokens
420      */
421     function proxyPayment(address _participant) payable {
422         // Don't process if halted
423         require(!halted);
424         // No contributions before the start of the crowdsale
425         require(now >= START_TS);
426         // No contributions after the end of the crowdsale
427         require(now <= END_TS);
428         // No contributions after CAP is reached
429         require(totalEthers < CAP);
430         // Require 0.1 eth minimum
431         require(msg.value >= 0.1 ether);
432 
433         // Add ETH raised to total
434         totalEthers = totalEthers.add(msg.value);
435         // Cannot exceed cap more than 0.1 ETH (to be able to finish ICO if CAP - totalEthers < 0.1)
436         require(totalEthers < CAP + 0.1 ether);
437 
438         // What is the ELT to ETH rate
439         uint256 _buyPrice = buyPrice();
440 
441         // Calculate #ELT - this is safe as _buyPrice is known
442         // and msg.value is restricted to valid values
443         uint tokens = msg.value * _buyPrice;
444 
445         // Check tokens > 0
446         require(tokens > 0);
447         // Compute tokens for foundation; user tokens = 70%; TARGET_ADDRESS = 30%
448         // Number of tokens restricted so maths is safe
449         // To clearly show 70%+30%, result wasn't precalculated
450         uint additional_tokens = tokens * 30 / 70;
451 
452         // Add to total supply
453         totalSupply = totalSupply.add(tokens);
454         totalSupply = totalSupply.add(additional_tokens);
455 
456         // Add to balances
457         balanceOf[_participant] = balanceOf[_participant].add(tokens);
458         balanceOf[TARGET_TOKENS_ADDRESS] = balanceOf[TARGET_TOKENS_ADDRESS].add(additional_tokens);
459 
460         // Log events
461         TokensBought(_participant, msg.value, totalEthers, tokens, additional_tokens,
462             totalSupply, _buyPrice);
463         FundTransfer(_participant, msg.value, true);
464         Transfer(0x0, _participant, tokens);
465         Transfer(0x0, TARGET_TOKENS_ADDRESS, additional_tokens);
466 
467         // Move the funds to a safe wallet
468         TARGET_ADDRESS.transfer(msg.value);
469     }
470 
471     /**
472      * Transfer the balance from owner's account to another account, with a
473      * check that the crowdsale is finalized
474      *
475      * @param _to                tokens receiver
476      * @param _amount            tokens amount
477      * @return                   true on success
478      */
479     function transfer(address _to, uint _amount) returns (bool success) {
480         // Cannot transfer before crowdsale ends or cap reached
481         require(now > END_TS || totalEthers >= CAP);
482         // Standard transfer
483         return super.transfer(_to, _amount);
484     }
485 
486     /**
487      * Spender of tokens transfer an amount of tokens from the token owner's
488      * balance to another account, with a check that the crowdsale is
489      * finalized
490      *
491      * @param _from              tokens sender
492      * @param _to                tokens receiver
493      * @param _amount            tokens amount
494      * @return                   true on success
495      */
496     function transferFrom(address _from, address _to, uint _amount)
497             returns (bool success) {
498         // Cannot transfer before crowdsale ends or cap reached
499         require(now > END_TS || totalEthers >= CAP);
500         // Standard transferFrom
501         return super.transferFrom(_from, _to, _amount);
502     }
503 
504     /**
505      * Owner can transfer out any accidentally sent ERC20 tokens
506      *
507      * @param _tokenAddress       tokens address
508      * @param _amount             tokens amount
509      * @return                   true on success
510      */
511     function transferAnyERC20Token(address _tokenAddress, uint _amount)
512       onlyOwner returns (bool success) {
513         return ERC20Token(_tokenAddress).transfer(owner, _amount);
514     }
515 }