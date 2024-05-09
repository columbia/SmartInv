1 pragma solidity ^0.4.17;
2 
3 // ----------------------------------------------------------------------------
4 // GAT Ownership Contract
5 //
6 // Copyright (c) 2017 GAT Systems Ltd.
7 // http://www.gatcoin.io/
8 //
9 // The MIT Licence.
10 // ----------------------------------------------------------------------------
11 
12 
13 // Implementation of a simple ownership model with transfer acceptance.
14 //
15 contract Owned {
16 
17     address public owner;
18     address public newOwner;
19 
20     event OwnerChanged(address indexed _newOwner);
21 
22 
23     function Owned() public {
24         owner = msg.sender;
25     }
26 
27 
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32 
33 
34     function transferOwnership(address _newOwner) public onlyOwner returns (bool) {
35         require(_newOwner != address(0));
36         require(_newOwner != owner);
37 
38         newOwner = _newOwner;
39 
40         return true;
41     }
42 
43 
44     function acceptOwnership() public returns (bool) {
45         require(msg.sender == newOwner);
46 
47         owner = msg.sender;
48 
49         OwnerChanged(msg.sender);
50 
51         return true;
52     }
53 }
54 
55 
56 pragma solidity ^0.4.17;
57 
58 
59 /**
60  * @title SafeMath
61  * @dev Math operations with safety checks that throw on error
62  */
63 library SafeMath {
64 
65   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a * b;
67     assert(a == 0 || c / a == b);
68     return c;
69   }
70 
71   function div(uint256 a, uint256 b) internal pure returns (uint256) {
72     // assert(b > 0); // Solidity automatically throws when dividing by 0
73     uint256 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75     return c;
76   }
77 
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 
91 
92 pragma solidity ^0.4.17;
93 
94 // ----------------------------------------------------------------------------
95 // GAT Token ERC20 Interface
96 //
97 // Copyright (c) 2017 GAT Systems Ltd.
98 // http://www.gatcoin.io/
99 //
100 // The MIT Licence.
101 // ----------------------------------------------------------------------------
102 
103 
104 // ----------------------------------------------------------------------------
105 // ERC20 Standard Interface as specified at:
106 // https://github.com/ethereum/EIPs/issues/20
107 // ----------------------------------------------------------------------------
108 
109 contract ERC20Interface {
110 
111     uint256 public totalSupply;
112 
113     event Transfer(address indexed _from, address indexed _to, uint256 _value);
114     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
115 
116     function balanceOf(address _owner) public view returns (uint256 balance);
117     function transfer(address _to, uint256 _value) public returns (bool success);
118     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
119     function approve(address _spender, uint256 _value) public returns (bool success);
120     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
121 }
122 
123 
124 pragma solidity ^0.4.17;
125 
126 // ----------------------------------------------------------------------------
127 // GAT Token Implementation
128 //
129 // Copyright (c) 2017 GAT Systems Ltd.
130 // http://www.gatcoin.io/
131 //
132 // The MIT Licence.
133 // ----------------------------------------------------------------------------
134 
135 
136 
137 
138 // Implementation of standard ERC20 token with ownership.
139 //
140 contract GATToken is ERC20Interface, Owned {
141 
142     using SafeMath for uint256;
143 
144     string public symbol;
145     string public name;
146     uint256 public decimals;
147 
148     mapping(address => uint256) balances;
149     mapping(address => mapping (address => uint256)) allowed;
150 
151 
152     function GATToken(string _symbol, string _name, uint256 _decimals, uint256 _totalSupply) public
153         Owned()
154     {
155         symbol      = _symbol;
156         name        = _name;
157         decimals    = _decimals;
158         totalSupply = _totalSupply;
159 
160         Transfer(0x0, owner, _totalSupply);
161     }
162 
163 
164     function balanceOf(address _owner) public view returns (uint256 balance) {
165         return balances[_owner];
166     }
167 
168 
169     function transfer(address _to, uint256 _value) public returns (bool success) {
170         balances[msg.sender] = balances[msg.sender].sub(_value);
171         balances[_to] = balances[_to].add(_value);
172 
173         Transfer(msg.sender, _to, _value);
174 
175         return true;
176     }
177 
178 
179     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
180         balances[_from] = balances[_from].sub(_value);
181         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182         balances[_to] = balances[_to].add(_value);
183 
184         Transfer(_from, _to, _value);
185 
186         return true;
187      }
188 
189 
190      function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
191          return allowed[_owner][_spender];
192      }
193 
194 
195      function approve(address _spender, uint256 _value) public returns (bool success) {
196          allowed[msg.sender][_spender] = _value;
197 
198          Approval(msg.sender, _spender, _value);
199 
200          return true;
201      }
202 }
203 
204 
205 pragma solidity ^0.4.17;
206 
207 // ----------------------------------------------------------------------------
208 // GAT Token Sale Configuration
209 //
210 // Copyright (c) 2017 GAT Systems Ltd.
211 // http://www.gatcoin.io/
212 //
213 // The MIT Licence.
214 // ----------------------------------------------------------------------------
215 
216 
217 contract GATTokenSaleConfig {
218 
219     string  public constant SYMBOL                  = "GAT";
220     string  public constant NAME                    = "GAT Token";
221     uint256 public constant DECIMALS                = 18;
222 
223     uint256 public constant DECIMALSFACTOR          = 10**uint256(DECIMALS);
224     uint256 public constant START_TIME              = 1509192000; // 28-Oct-2017, 12:00:00 UTC
225     uint256 public constant END_TIME                = 1511870399; // 28-Nov-2017, 11:59:59 UTC
226     uint256 public constant CONTRIBUTION_MIN        = 0.1 ether;
227     uint256 public constant TOKEN_TOTAL_CAP         = 1000000000  * DECIMALSFACTOR;
228     uint256 public constant TOKEN_PRIVATE_SALE_CAP  =   70000000  * DECIMALSFACTOR;
229     uint256 public constant TOKEN_PRESALE_CAP       =   15000000  * DECIMALSFACTOR;
230     uint256 public constant TOKEN_PUBLIC_SALE_CAP   =  130000000  * DECIMALSFACTOR; // This also includes presale
231     uint256 public constant TOKEN_FOUNDATION_CAP    =  100000000  * DECIMALSFACTOR;
232     uint256 public constant TOKEN_RESERVE1_CAP      =   50000000  * DECIMALSFACTOR;
233     uint256 public constant TOKEN_RESERVE2_CAP      =   50000000  * DECIMALSFACTOR;
234     uint256 public constant TOKEN_FUTURE_CAP        =  600000000  * DECIMALSFACTOR;
235 
236     // Default bonus amount for the presale.
237     // 100 = no bonus
238     // 120 = 20% bonus.
239     // Note that the owner can change the amount of bonus given.
240     uint256 public constant PRESALE_BONUS      = 120;
241 
242     // Default value for tokensPerKEther based on ETH at 300 USD.
243     // The owner can update this value before the sale starts based on the
244     // price of ether at that time.
245     // E.g. 300 USD/ETH -> 300,000 USD/KETH / 0.2 USD/TOKEN = 1,500,000
246     uint256 public constant TOKENS_PER_KETHER = 1500000;
247 }
248 
249 
250 pragma solidity ^0.4.17;
251 
252 // ----------------------------------------------------------------------------
253 // GAT Token Sample Implementation
254 //
255 // Copyright (c) 2017 GAT Systems Ltd.
256 // http://www.gatcoin.io/
257 //
258 // The MIT Licence.
259 // ----------------------------------------------------------------------------
260 
261 
262 
263 
264 
265 // This is the main contract that drives the GAT token sale.
266 // It exposes the ERC20 interface along with various sale-related functions.
267 //
268 contract GATTokenSale is GATToken, GATTokenSaleConfig {
269 
270     using SafeMath for uint256;
271 
272     // Once finalized, tokens will be freely tradable
273     bool public finalized;
274 
275     // Sale can be suspended or resumed by the owner
276     bool public suspended;
277 
278     // Addresses for the bank, funding and reserves.
279     address public bankAddress;
280     address public fundingAddress;
281     address public reserve1Address;
282     address public reserve2Address;
283 
284     // Price of tokens per 1000 ETH
285     uint256 public tokensPerKEther;
286 
287     // The bonus amount on token purchases
288     // E.g. 120 means a 20% bonus will be applied.
289     uint256 public bonus;
290 
291     // Total number of tokens that have been sold through the sale contract so far.
292     uint256 public totalTokensSold;
293 
294     // Keep track of start time and end time for the sale. These have default
295     // values when the contract is deployed but can be changed by owner as needed.
296     uint256 public startTime;
297     uint256 public endTime;
298 
299 
300     // Events
301     event TokensPurchased(address indexed beneficiary, uint256 cost, uint256 tokens);
302     event TokensPerKEtherUpdated(uint256 newAmount);
303     event BonusAmountUpdated(uint256 newAmount);
304     event TimeWindowUpdated(uint256 newStartTime, uint256 newEndTime);
305     event SaleSuspended();
306     event SaleResumed();
307     event TokenFinalized();
308     event ContractTokensReclaimed(uint256 amount);
309 
310 
311     function GATTokenSale(address _bankAddress, address _fundingAddress, address _reserve1Address, address _reserve2Address) public
312         GATToken(SYMBOL, NAME, DECIMALS, 0)
313     {
314         // Can only create the contract is the sale has not yet started or ended.
315         require(START_TIME >= currentTime());
316         require(END_TIME > START_TIME);
317 
318         // Need valid wallet addresses
319         require(_bankAddress    != address(0x0));
320         require(_bankAddress    != address(this));
321         require(_fundingAddress != address(0x0));
322         require(_fundingAddress != address(this));
323         require(_reserve1Address != address(0x0));
324         require(_reserve1Address != address(this));
325         require(_reserve2Address != address(0x0));
326         require(_reserve2Address != address(this));
327 
328         uint256 salesTotal = TOKEN_PUBLIC_SALE_CAP.add(TOKEN_PRIVATE_SALE_CAP);
329         require(salesTotal.add(TOKEN_FUTURE_CAP).add(TOKEN_FOUNDATION_CAP).add(TOKEN_RESERVE1_CAP).add(TOKEN_RESERVE2_CAP) == TOKEN_TOTAL_CAP);
330 
331         // Start in non-finalized state
332         finalized = false;
333         suspended = false;
334 
335         // Start and end times (used for presale).
336         startTime = START_TIME;
337         endTime   = END_TIME;
338 
339         // Initial pricing
340         tokensPerKEther = TOKENS_PER_KETHER;
341 
342         // Bonus for contributions
343         bonus = PRESALE_BONUS;
344 
345         // Initialize wallet addresses
346         bankAddress    = _bankAddress;
347         fundingAddress = _fundingAddress;
348         reserve1Address = _reserve1Address;
349         reserve2Address = _reserve2Address;
350 
351         // Assign initial balances
352         balances[address(this)] = balances[address(this)].add(TOKEN_PRESALE_CAP);
353         totalSupply = totalSupply.add(TOKEN_PRESALE_CAP);
354         Transfer(0x0, address(this), TOKEN_PRESALE_CAP);
355 
356         balances[reserve1Address] = balances[reserve1Address].add(TOKEN_RESERVE1_CAP);
357         totalSupply = totalSupply.add(TOKEN_RESERVE1_CAP);
358         Transfer(0x0, reserve1Address, TOKEN_RESERVE1_CAP);
359 
360         balances[reserve2Address] = balances[reserve2Address].add(TOKEN_RESERVE2_CAP);
361         totalSupply = totalSupply.add(TOKEN_RESERVE2_CAP);
362         Transfer(0x0, reserve2Address, TOKEN_RESERVE2_CAP);
363 
364         uint256 bankBalance = TOKEN_TOTAL_CAP.sub(totalSupply);
365         balances[bankAddress] = balances[bankAddress].add(bankBalance);
366         totalSupply = totalSupply.add(bankBalance);
367         Transfer(0x0, bankAddress, bankBalance);
368 
369         // The total supply that we calculated here should be the same as in the config.
370         require(balanceOf(address(this))  == TOKEN_PRESALE_CAP);
371         require(balanceOf(reserve1Address) == TOKEN_RESERVE1_CAP);
372         require(balanceOf(reserve2Address) == TOKEN_RESERVE2_CAP);
373         require(balanceOf(bankAddress)    == bankBalance);
374         require(totalSupply == TOKEN_TOTAL_CAP);
375     }
376 
377 
378     function currentTime() public constant returns (uint256) {
379         return now;
380     }
381 
382 
383     // Allows the owner to change the price for tokens.
384     //
385     function setTokensPerKEther(uint256 _tokensPerKEther) external onlyOwner returns(bool) {
386         require(_tokensPerKEther > 0);
387 
388         // Set the tokensPerKEther amount for any new sale.
389         tokensPerKEther = _tokensPerKEther;
390 
391         TokensPerKEtherUpdated(_tokensPerKEther);
392 
393         return true;
394     }
395 
396 
397     // Allows the owner to change the bonus amount applied to purchases.
398     //
399     function setBonus(uint256 _bonus) external onlyOwner returns(bool) {
400         // 100 means no bonus
401         require(_bonus >= 100);
402 
403         // 200 means 100% bonus
404         require(_bonus <= 200);
405 
406         bonus = _bonus;
407 
408         BonusAmountUpdated(_bonus);
409 
410         return true;
411     }
412 
413 
414     // Allows the owner to change the time window for the sale.
415     //
416     function setTimeWindow(uint256 _startTime, uint256 _endTime) external onlyOwner returns(bool) {
417         require(_startTime >= START_TIME);
418         require(_endTime > _startTime);
419 
420         startTime = _startTime;
421         endTime   = _endTime;
422 
423         TimeWindowUpdated(_startTime, _endTime);
424 
425         return true;
426     }
427 
428 
429     // Allows the owner to suspend / stop the sale.
430     //
431     function suspend() external onlyOwner returns(bool) {
432         if (suspended == true) {
433             return false;
434         }
435 
436         suspended = true;
437 
438         SaleSuspended();
439 
440         return true;
441     }
442 
443 
444     // Allows the owner to resume the sale.
445     //
446     function resume() external onlyOwner returns(bool) {
447         if (suspended == false) {
448             return false;
449         }
450 
451         suspended = false;
452 
453         SaleResumed();
454 
455         return true;
456     }
457 
458 
459     // Accept ether contributions during the token sale.
460     //
461     function () payable public {
462         buyTokens(msg.sender);
463     }
464 
465 
466     // Allows the caller to buy tokens for another recipient (proxy purchase).
467     // This can be used by exchanges for example.
468     //
469     function buyTokens(address beneficiary) public payable returns (uint256) {
470         require(!suspended);
471         require(beneficiary != address(0x0));
472         require(beneficiary != address(this));
473         require(currentTime() >= startTime);
474         require(currentTime() <= endTime);
475         require(msg.value >= CONTRIBUTION_MIN);
476         require(msg.sender != fundingAddress);
477 
478         // Check if the sale contract still has tokens for sale.
479         uint256 saleBalance = balanceOf(address(this));
480         require(saleBalance > 0);
481 
482         // Calculate the number of tokens that the ether should convert to.
483         uint256 tokens = msg.value.mul(tokensPerKEther).mul(bonus).div(10**(18 - DECIMALS + 3 + 2));
484         require(tokens > 0);
485 
486         uint256 cost = msg.value;
487         uint256 refund = 0;
488 
489         if (tokens > saleBalance) {
490             // Not enough tokens left for sale to fulfill the full order.
491             tokens = saleBalance;
492 
493             // Calculate the actual cost for the tokens that can be purchased.
494             cost = tokens.mul(10**(18 - DECIMALS + 3 + 2)).div(tokensPerKEther.mul(bonus));
495 
496             // Calculate the amount of ETH refund to the contributor.
497             refund = msg.value.sub(cost);
498         }
499 
500         totalTokensSold = totalTokensSold.add(tokens);
501 
502         // Move tokens from the sale contract to the beneficiary
503         balances[address(this)] = balances[address(this)].sub(tokens);
504         balances[beneficiary]   = balances[beneficiary].add(tokens);
505         Transfer(address(this), beneficiary, tokens);
506 
507         if (refund > 0) {
508            msg.sender.transfer(refund);
509         }
510 
511         // Transfer the contributed ether to the crowdsale wallets.
512         uint256 contribution      = msg.value.sub(refund);
513         uint256 reserveAllocation = contribution.div(20);
514 
515         fundingAddress.transfer(contribution.sub(reserveAllocation));
516         reserve1Address.transfer(reserveAllocation);
517 
518         TokensPurchased(beneficiary, cost, tokens);
519 
520         return tokens;
521     }
522 
523 
524     // ERC20 transfer function, modified to only allow transfers once the sale has been finalized.
525     //
526     function transfer(address _to, uint256 _amount) public returns (bool success) {
527         if (!isTransferAllowed(msg.sender, _to)) {
528             return false;
529         }
530 
531         return super.transfer(_to, _amount);
532     }
533 
534 
535     // ERC20 transferFrom function, modified to only allow transfers once the sale has been finalized.
536     //
537     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
538         if (!isTransferAllowed(_from, _to)) {
539             return false;
540         }
541 
542         return super.transferFrom(_from, _to, _amount);
543     }
544 
545 
546     // Internal helper to check if the transfer should be allowed
547     //
548     function isTransferAllowed(address _from, address _to) private view returns (bool) {
549         if (finalized) {
550             // We allow everybody to transfer tokens once the sale is finalized.
551             return true;
552         }
553 
554         if (_from == bankAddress || _to == bankAddress) {
555             // We allow the bank to initiate transfers. We also allow it to be the recipient
556             // of transfers before the token is finalized in case a recipient wants to send
557             // back tokens. E.g. KYC requirements cannot be met.
558             return true;
559         }
560 
561         return false;
562     }
563 
564 
565     // Allows owner to transfer tokens assigned to the sale contract, back to the bank wallet.
566     function reclaimContractTokens() external onlyOwner returns (bool) {
567         uint256 tokens = balanceOf(address(this));
568 
569         if (tokens == 0) {
570             return false;
571         }
572 
573         balances[address(this)] = balances[address(this)].sub(tokens);
574         balances[bankAddress]   = balances[bankAddress].add(tokens);
575         Transfer(address(this), bankAddress, tokens);
576 
577         ContractTokensReclaimed(tokens);
578 
579         return true;
580     }
581 
582 
583     // Allows the owner to finalize the sale and allow tokens to be traded.
584     //
585     function finalize() external onlyOwner returns (bool) {
586         require(!finalized);
587 
588         finalized = true;
589 
590         TokenFinalized();
591 
592         return true;
593     }
594 }