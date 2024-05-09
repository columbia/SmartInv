1 pragma solidity ^0.4.17;
2 
3 // ----------------------------------------------------------------------------
4 // Copyright (c) 2017 GAT International Limited.
5 // http://www.gatcoin.io/
6 //
7 // The MIT Licence.
8 // ----------------------------------------------------------------------------
9 contract Owned {
10 
11     address public owner;
12     address public newOwner;
13 
14     event OwnerChanged(address indexed _newOwner);
15 
16 
17     function Owned() public {
18         owner = msg.sender;
19     }
20 
21 
22     modifier onlyOwner() {
23         require(msg.sender == owner);
24         _;
25     }
26 
27 
28     function transferOwnership(address _newOwner) public onlyOwner returns (bool) {
29         require(_newOwner != address(0));
30         require(_newOwner != owner);
31 
32         newOwner = _newOwner;
33 
34         return true;
35     }
36 
37 
38     function acceptOwnership() public returns (bool) {
39         require(msg.sender == newOwner);
40 
41         owner = msg.sender;
42 
43         OwnerChanged(msg.sender);
44 
45         return true;
46     }
47 }
48 
49 
50 contract GATTokenSaleConfig {
51 
52     string  public constant SYMBOL                  = "GAT";
53     string  public constant NAME                    = "GAT Token";
54     uint256 public constant DECIMALS                = 18;
55 
56     uint256 public constant DECIMALSFACTOR          = 10**uint256(DECIMALS);
57     uint256 public constant START_TIME              = 1513512000; // 2017-12-17T12:00:00Z
58     uint256 public constant END_TIME                = 1515326399; // 2018-01-07T11:59:59Z
59     uint256 public constant CONTRIBUTION_MIN        = 2 ether;
60     uint256 public constant TOKEN_TOTAL_CAP         = 1000000000  * DECIMALSFACTOR;
61     uint256 public constant TOKEN_PRIVATE_SALE_CAP  =   54545172  * DECIMALSFACTOR; // past presale
62     uint256 public constant TOKEN_PRESALE_CAP       =  145454828  * DECIMALSFACTOR; // 200000000 - what was raised in round 1
63     uint256 public constant TOKEN_PUBLIC_SALE_CAP   =  445454828  * DECIMALSFACTOR; // This also includes presale
64     uint256 public constant TOKEN_FOUNDATION_CAP    =          0  * DECIMALSFACTOR;
65     uint256 public constant TOKEN_RESERVE1_CAP      =  100000000  * DECIMALSFACTOR;
66     uint256 public constant TOKEN_RESERVE2_CAP      =          0  * DECIMALSFACTOR;
67     uint256 public constant TOKEN_FUTURE_CAP        =  400000000  * DECIMALSFACTOR;
68 
69     // Default bonus amount for the presale.
70     // 100 = no bonus
71     // 120 = 20% bonus.
72     // Note that the owner can change the amount of bonus given.
73     uint256 public constant PRESALE_BONUS      = 120;
74 
75     // Default value for tokensPerKEther based on ETH at 300 USD.
76     // The owner can update this value before the sale starts based on the
77     // price of ether at that time.
78     // E.g. 300 USD/ETH -> 300,000 USD/KETH / 0.2 USD/TOKEN = 1,500,000
79     uint256 public constant TOKENS_PER_KETHER = 14800000;
80 }
81 
82 library SafeMath {
83 
84   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a * b;
86     assert(a == 0 || c / a == b);
87     return c;
88   }
89 
90   function div(uint256 a, uint256 b) internal pure returns (uint256) {
91     // assert(b > 0); // Solidity automatically throws when dividing by 0
92     uint256 c = a / b;
93     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94     return c;
95   }
96 
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   function add(uint256 a, uint256 b) internal pure returns (uint256) {
103     uint256 c = a + b;
104     assert(c >= a);
105     return c;
106   }
107 }
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
123 // Implementation of standard ERC20 token with ownership.
124 //
125 contract GATToken is ERC20Interface, Owned {
126 
127     using SafeMath for uint256;
128 
129     string public symbol;
130     string public name;
131     uint256 public decimals;
132 
133     mapping(address => uint256) balances;
134     mapping(address => mapping (address => uint256)) allowed;
135 
136 
137     function GATToken(string _symbol, string _name, uint256 _decimals, uint256 _totalSupply) public
138         Owned()
139     {
140         symbol      = _symbol;
141         name        = _name;
142         decimals    = _decimals;
143         totalSupply = _totalSupply;
144 
145         Transfer(0x0, owner, _totalSupply);
146     }
147 
148 
149     function balanceOf(address _owner) public view returns (uint256 balance) {
150         return balances[_owner];
151     }
152 
153 
154     function transfer(address _to, uint256 _value) public returns (bool success) {
155         balances[msg.sender] = balances[msg.sender].sub(_value);
156         balances[_to] = balances[_to].add(_value);
157 
158         Transfer(msg.sender, _to, _value);
159 
160         return true;
161     }
162 
163 
164     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
165         balances[_from] = balances[_from].sub(_value);
166         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
167         balances[_to] = balances[_to].add(_value);
168 
169         Transfer(_from, _to, _value);
170 
171         return true;
172      }
173 
174 
175      function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
176          return allowed[_owner][_spender];
177      }
178 
179 
180      function approve(address _spender, uint256 _value) public returns (bool success) {
181          allowed[msg.sender][_spender] = _value;
182 
183          Approval(msg.sender, _spender, _value);
184 
185          return true;
186      }
187 }
188 
189 
190 // This is the main contract that drives the GAT token sale.
191 // It exposes the ERC20 interface along with various sale-related functions.
192 //
193 contract GATTokenSale is GATToken, GATTokenSaleConfig {
194 
195     using SafeMath for uint256;
196 
197     // Once finalized, tokens will be freely tradable
198     bool public finalized;
199 
200     // Sale can be suspended or resumed by the owner
201     bool public suspended;
202 
203     // Addresses for the bank, funding and reserves.
204     address public bankAddress;
205     address public fundingAddress;
206     address public reserve1Address;
207     address public reserve2Address;
208 
209     // Price of tokens per 1000 ETH
210     uint256 public tokensPerKEther;
211 
212     // The bonus amount on token purchases
213     // E.g. 120 means a 20% bonus will be applied.
214     uint256 public bonus;
215 
216     // Total number of tokens that have been sold through the sale contract so far.
217     uint256 public totalTokensSold;
218 
219     // Minimum contribution value
220     uint256 public contributionMinimum;
221 
222     // Keep track of start time and end time for the sale. These have default
223     // values when the contract is deployed but can be changed by owner as needed.
224     uint256 public startTime;
225     uint256 public endTime;
226 
227 
228     // Events
229     event TokensPurchased(address indexed beneficiary, uint256 cost, uint256 tokens);
230     event TokensPerKEtherUpdated(uint256 newAmount);
231     event ContributionMinimumUpdated(uint256 newAmount);
232     event BonusAmountUpdated(uint256 newAmount);
233     event TimeWindowUpdated(uint256 newStartTime, uint256 newEndTime);
234     event SaleSuspended();
235     event SaleResumed();
236     event TokenFinalized();
237     event ContractTokensReclaimed(uint256 amount);
238 
239 // "0x1a4FBba7231Ec0707925c52b047b951a0BeAA325", "0xa85b419eee304563d3587fe934e932f056ca3c14", "0xa85b419eee304563d3587fe934e932f056ca3c14", "0x587d06eb855811ee987cc842880b9255a3aab45b", 
240     function GATTokenSale(address _bankAddress, address _fundingAddress, address _reserve1Address, address _reserve2Address) public
241         GATToken(SYMBOL, NAME, DECIMALS, 0)
242     {
243         // Can only create the contract is the sale has not yet started or ended.
244         require(START_TIME >= currentTime());
245         require(END_TIME > START_TIME);
246 
247         // Need valid wallet addresses
248         require(_bankAddress    != address(0x0));
249         require(_bankAddress    != address(this));
250         require(_fundingAddress != address(0x0));
251         require(_fundingAddress != address(this));
252         require(_reserve1Address != address(0x0));
253         require(_reserve1Address != address(this));
254         require(_reserve2Address != address(0x0));
255         require(_reserve2Address != address(this));
256 
257         uint256 salesTotal = TOKEN_PUBLIC_SALE_CAP.add(TOKEN_PRIVATE_SALE_CAP);
258         require(salesTotal.add(TOKEN_FUTURE_CAP).add(TOKEN_FOUNDATION_CAP).add(TOKEN_RESERVE1_CAP).add(TOKEN_RESERVE2_CAP) == TOKEN_TOTAL_CAP);
259 
260         // Start in non-finalized state
261         finalized = false;
262         suspended = false;
263 
264         // Start and end times (used for presale).
265         startTime = START_TIME;
266         endTime   = END_TIME;
267 
268         // Initial pricing
269         tokensPerKEther = TOKENS_PER_KETHER;
270 
271         // Initial contribution minimum
272         contributionMinimum = CONTRIBUTION_MIN;
273 
274         // Bonus for contributions
275         bonus = PRESALE_BONUS;
276 
277         // Initialize wallet addresses
278         bankAddress    = _bankAddress;
279         fundingAddress = _fundingAddress;
280         reserve1Address = _reserve1Address;
281         reserve2Address = _reserve2Address;
282 
283         // Assign initial balances
284         balances[address(this)] = balances[address(this)].add(TOKEN_PRESALE_CAP);
285         totalSupply = totalSupply.add(TOKEN_PRESALE_CAP);
286         Transfer(0x0, address(this), TOKEN_PRESALE_CAP);
287 
288         balances[reserve1Address] = balances[reserve1Address].add(TOKEN_RESERVE1_CAP);
289         totalSupply = totalSupply.add(TOKEN_RESERVE1_CAP);
290         Transfer(0x0, reserve1Address, TOKEN_RESERVE1_CAP);
291 
292         balances[reserve2Address] = balances[reserve2Address].add(TOKEN_RESERVE2_CAP);
293         totalSupply = totalSupply.add(TOKEN_RESERVE2_CAP);
294         Transfer(0x0, reserve2Address, TOKEN_RESERVE2_CAP);
295 
296         uint256 bankBalance = TOKEN_TOTAL_CAP.sub(totalSupply);
297         balances[bankAddress] = balances[bankAddress].add(bankBalance);
298         totalSupply = totalSupply.add(bankBalance);
299         Transfer(0x0, bankAddress, bankBalance);
300 
301         // The total supply that we calculated here should be the same as in the config.
302         require(balanceOf(address(this))  == TOKEN_PRESALE_CAP);
303         require(balanceOf(reserve1Address) == TOKEN_RESERVE1_CAP);
304         require(balanceOf(reserve2Address) == TOKEN_RESERVE2_CAP);
305         require(balanceOf(bankAddress)    == bankBalance);
306         require(totalSupply == TOKEN_TOTAL_CAP);
307     }
308 
309 
310     function currentTime() public constant returns (uint256) {
311         return now;
312     }
313 
314 
315     // Allows the owner to change the price for tokens.
316     //
317     function setTokensPerKEther(uint256 _tokensPerKEther) external onlyOwner returns(bool) {
318         require(_tokensPerKEther > 0);
319 
320         // Set the tokensPerKEther amount for any new sale.
321         tokensPerKEther = _tokensPerKEther;
322 
323         TokensPerKEtherUpdated(_tokensPerKEther);
324 
325         return true;
326     }
327 
328     // Allows the owner to change the minimum contribution amount
329     //
330     function setContributionMinimum(uint256 _contributionMinimum) external onlyOwner returns(bool) {
331         require(_contributionMinimum > 0);
332 
333         // Set the tokensPerKEther amount for any new sale.
334         contributionMinimum = _contributionMinimum;
335 
336         ContributionMinimumUpdated(_contributionMinimum);
337 
338         return true;
339     }
340 
341     // Allows the owner to change the bonus amount applied to purchases.
342     //
343     function setBonus(uint256 _bonus) external onlyOwner returns(bool) {
344         // 100 means no bonus
345         require(_bonus >= 100);
346 
347         // 200 means 100% bonus
348         require(_bonus <= 200);
349 
350         bonus = _bonus;
351 
352         BonusAmountUpdated(_bonus);
353 
354         return true;
355     }
356 
357 
358     // Allows the owner to change the time window for the sale.
359     //
360     function setTimeWindow(uint256 _startTime, uint256 _endTime) external onlyOwner returns(bool) {
361         require(_startTime >= START_TIME);
362         require(_endTime > _startTime);
363 
364         startTime = _startTime;
365         endTime   = _endTime;
366 
367         TimeWindowUpdated(_startTime, _endTime);
368 
369         return true;
370     }
371 
372 
373     // Allows the owner to suspend / stop the sale.
374     //
375     function suspend() external onlyOwner returns(bool) {
376         if (suspended == true) {
377             return false;
378         }
379 
380         suspended = true;
381 
382         SaleSuspended();
383 
384         return true;
385     }
386 
387 
388     // Allows the owner to resume the sale.
389     //
390     function resume() external onlyOwner returns(bool) {
391         if (suspended == false) {
392             return false;
393         }
394 
395         suspended = false;
396 
397         SaleResumed();
398 
399         return true;
400     }
401 
402 
403     // Accept ether contributions during the token sale.
404     //
405     function () payable public {
406         buyTokens(msg.sender);
407     }
408 
409 
410     // Allows the caller to buy tokens for another recipient (proxy purchase).
411     // This can be used by exchanges for example.
412     //
413     function buyTokens(address beneficiary) public payable returns (uint256) {
414         require(!suspended);
415         require(beneficiary != address(0x0));
416         require(beneficiary != address(this));
417         require(currentTime() >= startTime);
418         require(currentTime() <= endTime);
419         require(msg.value >= contributionMinimum);
420         require(msg.sender != fundingAddress);
421 
422         // Check if the sale contract still has tokens for sale.
423         uint256 saleBalance = balanceOf(address(this));
424         require(saleBalance > 0);
425 
426         // Calculate the number of tokens that the ether should convert to.
427         uint256 tokens = msg.value.mul(tokensPerKEther).mul(bonus).div(10**(18 - DECIMALS + 3 + 2));
428         require(tokens > 0);
429 
430         uint256 cost = msg.value;
431         uint256 refund = 0;
432 
433         if (tokens > saleBalance) {
434             // Not enough tokens left for sale to fulfill the full order.
435             tokens = saleBalance;
436 
437             // Calculate the actual cost for the tokens that can be purchased.
438             cost = tokens.mul(10**(18 - DECIMALS + 3 + 2)).div(tokensPerKEther.mul(bonus));
439 
440             // Calculate the amount of ETH refund to the contributor.
441             refund = msg.value.sub(cost);
442         }
443 
444         totalTokensSold = totalTokensSold.add(tokens);
445 
446         // Move tokens from the sale contract to the beneficiary
447         balances[address(this)] = balances[address(this)].sub(tokens);
448         balances[beneficiary]   = balances[beneficiary].add(tokens);
449         Transfer(address(this), beneficiary, tokens);
450 
451         if (refund > 0) {
452            msg.sender.transfer(refund);
453         }
454 
455         // Transfer the contributed ether to the crowdsale wallets.
456         uint256 contribution      = msg.value.sub(refund);
457 
458         fundingAddress.transfer(contribution);
459 
460         TokensPurchased(beneficiary, cost, tokens);
461 
462         return tokens;
463     }
464 
465 
466     // ERC20 transfer function, modified to only allow transfers once the sale has been finalized.
467     //
468     function transfer(address _to, uint256 _amount) public returns (bool success) {
469         if (!isTransferAllowed(msg.sender, _to)) {
470             return false;
471         }
472 
473         return super.transfer(_to, _amount);
474     }
475 
476 
477     // ERC20 transferFrom function, modified to only allow transfers once the sale has been finalized.
478     //
479     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
480         if (!isTransferAllowed(_from, _to)) {
481             return false;
482         }
483 
484         return super.transferFrom(_from, _to, _amount);
485     }
486 
487 
488     // Internal helper to check if the transfer should be allowed
489     //
490     function isTransferAllowed(address _from, address _to) private view returns (bool) {
491         if (finalized) {
492             // We allow everybody to transfer tokens once the sale is finalized.
493             return true;
494         }
495 
496         if (_from == bankAddress || _to == bankAddress) {
497             // We allow the bank to initiate transfers. We also allow it to be the recipient
498             // of transfers before the token is finalized in case a recipient wants to send
499             // back tokens. E.g. KYC requirements cannot be met.
500             return true;
501         }
502 
503         return false;
504     }
505 
506 
507     // Allows owner to transfer tokens assigned to the sale contract, back to the bank wallet.
508     function reclaimContractTokens() external onlyOwner returns (bool) {
509         uint256 tokens = balanceOf(address(this));
510 
511         if (tokens == 0) {
512             return false;
513         }
514 
515         balances[address(this)] = balances[address(this)].sub(tokens);
516         balances[bankAddress]   = balances[bankAddress].add(tokens);
517         Transfer(address(this), bankAddress, tokens);
518 
519         ContractTokensReclaimed(tokens);
520 
521         return true;
522     }
523 
524 
525     // Allows the owner to finalize the sale and allow tokens to be traded.
526     //
527     function finalize() external onlyOwner returns (bool) {
528         require(!finalized);
529 
530         finalized = true;
531 
532         TokenFinalized();
533 
534         return true;
535     }
536 }