1 pragma solidity ^0.4.20;
2 
3 contract EtherPaint {
4    // scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
5    // orders of magnitude, hence the need to bridge between the two.
6    uint256 constant scaleFactor = 0x10000000000000000; //0x10000000000000000;  // 2^64
7 
8    // CRR = 50%
9    // CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
10    // For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
11    int constant crr_n = 1; // CRR numerator
12    int constant crr_d = 2; // CRR denominator
13 
14    // The price coefficient. Chosen such that at 1 token total supply
15    // the amount in reserve is 0.5 ether and token price is 1 Ether.
16    int constant price_coeff = -0x296ABF784A358468C;
17 
18    // Array between each address and their number of tokens.
19    mapping(address => uint256[16]) public tokenBalance;
20 
21    uint256[128][128] public colorPerCoordinate;
22    uint256[16] public colorPerCanvas;
23 
24    event colorUpdate(uint8 posx, uint8 posy, uint8 colorid);
25    event priceUpdate(uint8 colorid);
26    event tokenUpdate(uint8 colorid, address who);
27    event dividendUpdate();
28 
29    event pushuint(uint256 s);
30       
31    // Array between each address and how much Ether has been paid out to it.
32    // Note that this is scaled by the scaleFactor variable.
33    mapping(address => int256[16]) public payouts;
34 
35    // Variable tracking how many tokens are in existence overall.
36    uint256[16] public totalSupply;
37 
38    uint256 public allTotalSupply;
39 
40    // Aggregate sum of all payouts.
41    // Note that this is scaled by the scaleFactor variable.
42    int256[16] totalPayouts;
43 
44    // Variable tracking how much Ether each token is currently worth.
45    // Note that this is scaled by the scaleFactor variable.
46    uint256[16] earningsPerToken;
47    
48    // Current contract balance in Ether
49    uint256[16] public contractBalance;
50 
51    address public owner;
52 
53    uint256 public ownerFee;
54 
55 
56 
57    function EtherPaint() public {
58        owner = msg.sender;
59        colorPerCanvas[0] = 128*128;
60       pushuint(1 finney);
61    }
62 
63    // Returns the number of tokens currently held by _owner.
64    function balanceOf(address _owner, uint8 colorid) public constant returns (uint256 balance) {
65       if (colorid >= 16){
66          revert();
67       }
68       return tokenBalance[_owner][colorid];
69    }
70 
71    // Withdraws all dividends held by the caller sending the transaction, updates
72    // the requisite global variables, and transfers Ether back to the caller.
73    function withdraw(uint8 colorid) public {
74       if (colorid >= 16){
75          revert();
76       }
77       // Retrieve the dividends associated with the address the request came from.
78       var balance = dividends(msg.sender, colorid);
79       
80       // Update the payouts array, incrementing the request address by `balance`.
81       payouts[msg.sender][colorid] += (int256) (balance * scaleFactor);
82       
83       // Increase the total amount that's been paid out to maintain invariance.
84       totalPayouts[colorid] += (int256) (balance * scaleFactor);
85       
86       // Send the dividends to the address that requested the withdraw.
87       contractBalance[colorid] = sub(contractBalance[colorid], div(mul(balance, 95),100));
88       msg.sender.transfer(balance);
89    }
90 
91    function withdrawOwnerFee() public{
92       if (msg.sender == owner){
93          owner.transfer(ownerFee);
94          ownerFee = 0;
95       }
96    }
97 
98    // Sells your tokens for Ether. This Ether is assigned to the callers entry
99    // in the tokenBalance array, and therefore is shown as a dividend. A second
100    // call to withdraw() must be made to invoke the transfer of Ether back to your address.
101    function sellMyTokens(uint8 colorid) public {
102       if (colorid >= 16){
103          revert();
104       }
105       var balance = balanceOf(msg.sender, colorid);
106       sell(balance, colorid);
107       priceUpdate(colorid);
108       dividendUpdate();
109       tokenUpdate(colorid, msg.sender);
110    }
111    
112     function sellMyTokensAmount(uint8 colorid, uint256 amount) public {
113       if (colorid >= 16){
114          revert();
115       }
116       var balance = balanceOf(msg.sender, colorid);
117       if (amount <= balance){
118         sell(amount, colorid);
119         priceUpdate(colorid);
120         dividendUpdate();
121         tokenUpdate(colorid, msg.sender);
122       }
123    }
124 
125    // The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
126    // invokes the withdraw() function, sending the resulting Ether to the callers address.
127     function getMeOutOfHere() public {
128       for (uint8 i=0; i<16; i++){
129          sellMyTokens(i);
130          withdraw(i);
131       }
132 
133    }
134 
135    // Gatekeeper function to check if the amount of Ether being sent isn't either
136    // too small or too large. If it passes, goes direct to buy().
137    function fund(uint8 colorid, uint8 posx, uint8 posy) payable public {
138       // Don't allow for funding if the amount of Ether sent is less than 1 szabo.
139       if (colorid >= 16){
140          revert();
141       }
142       if ((msg.value > 0.000001 ether) && (posx >= 0) && (posx <= 127) && (posy >= 0) && (posy <= 127)) {
143          contractBalance[colorid] = add(contractBalance[colorid], div(mul(msg.value, 95),100));
144          buy(colorid);
145          colorPerCanvas[colorPerCoordinate[posx][posy]] = sub(colorPerCanvas[colorPerCoordinate[posx][posy]], 1);
146          colorPerCoordinate[posx][posy] = colorid;
147          colorPerCanvas[colorid] = add(colorPerCanvas[colorid],1);
148          colorUpdate(posx, posy, colorid);
149          priceUpdate(colorid);
150          dividendUpdate();
151          tokenUpdate(colorid, msg.sender);
152 
153       } else {
154          revert();
155       }
156     }
157 
158    // Function that returns the (dynamic) price of buying a finney worth of tokens.
159    function buyPrice(uint8 colorid) public constant returns (uint) {
160       if (colorid >= 16){
161          revert();
162       }
163       return getTokensForEther(1 finney, colorid);
164    }
165 
166    // Function that returns the (dynamic) price of selling a single token.
167    function sellPrice(uint8 colorid) public constant returns (uint) {
168          if (colorid >= 16){
169             revert();
170          }
171         var eth = getEtherForTokens(1 finney, colorid);
172         var fee = div(eth, 10);
173         return eth - fee;
174     }
175 
176    // Calculate the current dividends associated with the caller address. This is the net result
177    // of multiplying the number of tokens held by their current value in Ether and subtracting the
178    // Ether that has already been paid out.
179    function dividends(address _owner, uint8 colorid) public constant returns (uint256 amount) {
180       if (colorid >= 16){
181          revert();
182       }
183       return (uint256) ((int256)(earningsPerToken[colorid] * tokenBalance[_owner][colorid]) - payouts[_owner][colorid]) / scaleFactor;
184    }
185 
186    // Version of withdraw that extracts the dividends and sends the Ether to the caller.
187    // This is only used in the case when there is no transaction data, and that should be
188    // quite rare unless interacting directly with the smart contract.
189    //function withdrawOld(address to) public {
190       // Retrieve the dividends associated with the address the request came from.
191      // var balance = dividends(msg.sender);
192       
193       // Update the payouts array, incrementing the request address by `balance`.
194       //payouts[msg.sender] += (int256) (balance * scaleFactor);
195       
196       // Increase the total amount that's been paid out to maintain invariance.
197       //totalPayouts += (int256) (balance * scaleFactor);
198       
199       // Send the dividends to the address that requested the withdraw.
200       //contractBalance = sub(contractBalance, balance);
201       //to.transfer(balance);      
202    //}
203 
204    // Internal balance function, used to calculate the dynamic reserve value.
205    function balance(uint8 colorid) internal constant returns (uint256 amount) {
206 
207       // msg.value is the amount of Ether sent by the transaction.
208       return contractBalance[colorid] - msg.value;
209    }
210 
211    function buy(uint8 colorid) internal {
212 
213       // Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
214 
215       if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
216          revert();
217                   
218       // msg.sender is the address of the caller.
219       //var sender = msg.sender;
220       
221       // 10% of the total Ether sent is used to pay existing holders.
222       var fee = mul(div(msg.value, 20), 4);
223       
224       // The amount of Ether used to purchase new tokens for the caller.
225       //var numEther = msg.value - fee;
226       
227       // The number of tokens which can be purchased for numEther.
228       var numTokens = getTokensForEther(msg.value - fee, colorid);
229       
230       // The buyer fee, scaled by the scaleFactor variable.
231       uint256 buyerFee = 0;
232       
233       // Check that we have tokens in existence (this should always be true), or
234       // else you're gonna have a bad time.
235       if (totalSupply[colorid] > 0) {
236          // Compute the bonus co-efficient for all existing holders and the buyer.
237          // The buyer receives part of the distribution for each token bought in the
238          // same way they would have if they bought each token individually.
239 
240          for (uint8 c=0; c<16; c++){
241             if (totalSupply[c] > 0){
242                var theExtraFee = mul(div(mul(div(fee,4), scaleFactor), allTotalSupply), totalSupply[c]) + mul(div(div(fee,4), 128*128),mul(colorPerCanvas[c], scaleFactor));
243                //var globalFee = div(mul(mul(div(div(fee,4), allTotalSupply), totalSupply[c]), scaleFactor),totalSupply[c]);
244 
245                if (c==colorid){
246                   
247                 buyerFee = (div(fee,4) + div(theExtraFee,scaleFactor))*scaleFactor - (div(fee, 4) + div(theExtraFee,scaleFactor)) * (scaleFactor - (reserve(colorid) + msg.value - fee) * numTokens * scaleFactor / (totalSupply[colorid] + numTokens) / (msg.value - fee))
248 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
249              
250 
251 
252 
253 
254                }
255                else{
256 
257                    
258                   earningsPerToken[c] = add(earningsPerToken[c], div(theExtraFee, totalSupply[c]));
259 
260 
261                }
262             }
263          }
264          
265 
266 
267          
268 
269 
270 
271          ownerFee = add(ownerFee, div(fee,4));
272             
273          // The total reward to be distributed amongst the masses is the fee (in Ether)
274          // multiplied by the bonus co-efficient.
275 
276 
277          // Fee is distributed to all existing token holders before the new tokens are purchased.
278          // rewardPerShare is the amount gained per token thanks to this buy-in.
279 
280          
281          // The Ether value per token is increased proportionally.
282          // 5%
283 
284          earningsPerToken[colorid] = earningsPerToken[colorid] +  buyerFee / (totalSupply[colorid]);
285 
286              
287          
288       }
289 
290          totalSupply[colorid] = add(totalSupply[colorid], numTokens);
291 
292          allTotalSupply = add(allTotalSupply, numTokens);
293 
294       // Add the numTokens which were just created to the total supply. We're a crypto central bank!
295 
296 
297       
298 
299       // Assign the tokens to the balance of the buyer.
300       tokenBalance[msg.sender][colorid] = add(tokenBalance[msg.sender][colorid], numTokens);
301 
302       // Update the payout array so that the buyer cannot claim dividends on previous purchases.
303       // Also include the fee paid for entering the scheme.
304       // First we compute how much was just paid out to the buyer...
305 
306       
307       // Then we update the payouts array for the buyer with this amount...
308       payouts[msg.sender][colorid] +=  (int256) ((earningsPerToken[colorid] * numTokens) - buyerFee);
309       
310       // And then we finally add it to the variable tracking the total amount spent to maintain invariance.
311       totalPayouts[colorid]    +=  (int256) ((earningsPerToken[colorid] * numTokens) - buyerFee);
312       
313    }
314 
315    // Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
316    // to discouraging dumping, and means that if someone near the top sells, the fee distributed
317    // will be *significant*.
318    function sell(uint256 amount, uint8 colorid) internal {
319        // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
320       var numEthersBeforeFee = getEtherForTokens(amount, colorid);
321       
322       // 20% of the resulting Ether is used to pay remaining holders.
323       var fee = mul(div(numEthersBeforeFee, 20), 4);
324       
325       // Net Ether for the seller after the fee has been subtracted.
326       var numEthers = numEthersBeforeFee - fee;
327       
328       // *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
329       totalSupply[colorid] = sub(totalSupply[colorid], amount);
330       allTotalSupply = sub(allTotalSupply, amount);
331       
332         // Remove the tokens from the balance of the buyer.
333       tokenBalance[msg.sender][colorid] = sub(tokenBalance[msg.sender][colorid], amount);
334 
335         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
336       // First we compute how much was just paid out to the seller...
337       var payoutDiff = (int256) (earningsPerToken[colorid] * amount + (numEthers * scaleFactor));
338       
339         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
340       // since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
341       // they decide to buy back in.
342       payouts[msg.sender][colorid] -= payoutDiff;     
343       
344       // Decrease the total amount that's been paid out to maintain invariance.
345       totalPayouts[colorid] -= payoutDiff;
346       
347       // Check that we have tokens in existence (this is a bit of an irrelevant check since we're
348       // selling tokens, but it guards against division by zero).
349       if (totalSupply[colorid] > 0) {
350          // Scale the Ether taken as the selling fee by the scaleFactor variable.
351 
352          for (uint8 c=0; c<16; c++){
353             if (totalSupply[c] > 0){
354                var theExtraFee = mul(div(mul(div(fee,4), scaleFactor), allTotalSupply), totalSupply[c]) + mul(div(div(fee,4), 128*128),mul(colorPerCanvas[c], scaleFactor));
355             
356                earningsPerToken[c] = add(earningsPerToken[c], div(theExtraFee,totalSupply[c]));
357             }
358          }
359 
360          ownerFee = add(ownerFee, div(fee,4));
361 
362          var etherFee = div(fee,4) * scaleFactor;
363          
364          // Fee is distributed to all remaining token holders.
365          // rewardPerShare is the amount gained per token thanks to this sell.
366          var rewardPerShare = etherFee / totalSupply[colorid];
367          
368          // The Ether value per token is increased proportionally.
369          earningsPerToken[colorid] = add(earningsPerToken[colorid], rewardPerShare);
370 
371          
372       }
373    }
374 
375    // Dynamic value of Ether in reserve, according to the CRR requirement.
376    function reserve(uint8 colorid) internal constant returns (uint256 amount) {
377       return sub(balance(colorid),
378           ((uint256) ((int256) (earningsPerToken[colorid] * totalSupply[colorid]) - totalPayouts[colorid]) / scaleFactor));
379    }
380 
381    // Calculates the number of tokens that can be bought for a given amount of Ether, according to the
382    // dynamic reserve and totalSupply values (derived from the buy and sell prices).
383    function getTokensForEther(uint256 ethervalue, uint8 colorid) public constant returns (uint256 tokens) {
384       if (colorid >= 16){
385          revert();
386       }
387       return sub(fixedExp(fixedLog(reserve(colorid) + ethervalue)*crr_n/crr_d + price_coeff), totalSupply[colorid]);
388    }
389 
390 
391 
392    // Converts a number tokens into an Ether value.
393    function getEtherForTokens(uint256 tokens, uint8 colorid) public constant returns (uint256 ethervalue) {
394       if (colorid >= 16){
395          revert();
396       }
397       // How much reserve Ether do we have left in the contract?
398       var reserveAmount = reserve(colorid);
399 
400       // If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
401       if (tokens == totalSupply[colorid])
402          return reserveAmount;
403 
404       // If there would be excess Ether left after the transaction this is called within, return the Ether
405       // corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
406       // at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
407       // and denominator altered to 1 and 2 respectively.
408       return sub(reserveAmount, fixedExp((fixedLog(totalSupply[colorid] - tokens) - price_coeff) * crr_d/crr_n));
409    }
410 
411 // You don't care about these, but if you really do they're hex values for 
412    // co-efficients used to simulate approximations of the log and exp functions.
413    int256  constant one        = 0x10000000000000000;
414    uint256 constant sqrt2      = 0x16a09e667f3bcc908;
415    uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
416    int256  constant ln2        = 0x0b17217f7d1cf79ac;
417    int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
418    int256  constant c1         = 0x1ffffffffff9dac9b;
419    int256  constant c3         = 0x0aaaaaaac16877908;
420    int256  constant c5         = 0x0666664e5e9fa0c99;
421    int256  constant c7         = 0x049254026a7630acf;
422    int256  constant c9         = 0x038bd75ed37753d68;
423    int256  constant c11        = 0x03284a0c14610924f;
424 
425    // The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
426    // approximates the function log(1+x)-log(1-x)
427    // Hence R(s) = log((1+s)/(1-s)) = log(a)
428    function fixedLog(uint256 a) internal pure returns (int256 log) {
429       int32 scale = 0;
430       while (a > sqrt2) {
431          a /= 2;
432          scale++;
433       }
434       while (a <= sqrtdot5) {
435          a *= 2;
436          scale--;
437       }
438       int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
439       var z = (s*s) / one;
440       return scale * ln2 +
441          (s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
442             /one))/one))/one))/one))/one);
443    }
444 
445    int256 constant c2 =  0x02aaaaaaaaa015db0;
446    int256 constant c4 = -0x000b60b60808399d1;
447    int256 constant c6 =  0x0000455956bccdd06;
448    int256 constant c8 = -0x000001b893ad04b3a;
449    
450    // The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
451    // approximates the function x*(exp(x)+1)/(exp(x)-1)
452    // Hence exp(x) = (R(x)+x)/(R(x)-x)
453    function fixedExp(int256 a) internal pure returns (uint256 exp) {
454       int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
455       a -= scale*ln2;
456       int256 z = (a*a) / one;
457       int256 R = ((int256)(2) * one) +
458          (z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
459       exp = (uint256) (((R + a) * one) / (R - a));
460       if (scale >= 0)
461          exp <<= scale;
462       else
463          exp >>= -scale;
464       return exp;
465    }
466    
467    // The below are safemath implementations of the four arithmetic operators
468    // designed to explicitly prevent over- and under-flows of integer values.
469 
470    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
471       if (a == 0) {
472          return 0;
473       }
474       uint256 c = a * b;
475       assert(c / a == b);
476       return c;
477    }
478 
479    function div(uint256 a, uint256 b) internal pure returns (uint256) {
480       // assert(b > 0); // Solidity automatically throws when dividing by 0
481       uint256 c = a / b;
482       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
483       return c;
484    }
485 
486    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
487       assert(b <= a);
488       return a - b;
489    }
490 
491    function add(uint256 a, uint256 b) internal pure returns (uint256) {
492       uint256 c = a + b;
493       assert(c >= a);
494       return c;
495    }
496 
497    // This allows you to buy tokens by sending Ether directly to the smart contract
498    // without including any transaction data (useful for, say, mobile wallet apps).
499    function () payable public {
500       // msg.value is the amount of Ether sent by the transaction.
501       revert();
502       //if (msg.value > 0) {
503       //   revert();
504       //} else {
505       //   for (uint8 i=0; i<16; i++){
506       //     withdraw(i);
507       //   }
508 
509       //}
510    }
511    
512 }