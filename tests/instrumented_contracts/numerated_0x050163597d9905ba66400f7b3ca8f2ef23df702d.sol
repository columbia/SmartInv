1 pragma solidity ^0.4.19;
2 
3 interface ERC20 {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   function allowance(address owner, address spender) public view returns (uint256);
8   function transferFrom(address from, address to, uint256 value) public returns (bool);
9   function approve(address spender, uint256 value) public returns (bool);
10 
11   event Approval(address indexed owner, address indexed spender, uint256 value);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * Owned Contract
17  *
18  * This is a contract trait to inherit from. Contracts that inherit from Owned
19  * are able to modify functions to be only callable by the owner of the
20  * contract.
21  *
22  * By default it is impossible to change the owner of the contract.
23  */
24 contract Owned {
25   /**
26    * Contract owner.
27    *
28    * This value is set at contract creation time.
29    */
30   address owner;
31 
32   /**
33    * Contract constructor.
34    *
35    * This sets the owner of the Owned contract at the time of contract
36    * creation.
37    */
38   function Owned() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * Modify method to only allow the owner to call it.
44    */
45   modifier onlyOwner {
46     require(msg.sender == owner);
47     _;
48   }
49 }
50 
51 /**
52  * Chi Token Sale Contract with revenue sharing
53  *
54  * The intention of this contract is to run until the total value of 2000 ETH
55  * is sold out. There is no time limit placed on the contract.
56  *
57  * The total number of CHI tokens allocated to the contract is equal to the
58  * maximum number of tokens that can be acquired. This maximum number is
59  * calculating the purchase of 2000 ETH of tokens, and adding the bonus tokens
60  * for that purchase.
61  *
62  * The bonus tiers thresholds are calculated using the absolute number of sold
63  * tokens (by this contract), and are as follows:
64  *  - the 1st 150.000 tokens (0 - 149.999) get a bonus of 75%;
65  *  - the 2nd 150.000 tokens (150.000 - 299.999) get a bonus of 60%;
66  *  - the 3rd 150.000 tokens (300.000 - 449.999) get a bonus of 50%;
67  *  - the 4th 150.000 tokens (450.000 - 599.999) get a bonus of 40%;
68  *  - the 5th 150.000 tokens (600.000 - 749.999) get a bonus of 30%;
69  *  - the 6th 150.000 tokens (750.000 - 899.999) get a bonus of 20%;
70  *  - the next 300.000 tokens (900.000 - 1.199.999) get a bonus of 10%;
71  *  - the next 300.000 tokens (1.200.000 - 1.499.999) get a bonus of 5%; and
72  *  - the next 500.000 tokens (1.500.000 - 1.999.999) get a bonus of 2%.
73  *
74  * The maximum number of tokens this contract is able to hand out, can be
75  * calculated using the following Python code:
76  *  https://pyfiddle.io/fiddle/9bbc870a-534e-47b1-87c3-5f000bdd7d74/
77  */
78 contract ChiSale is Owned {
79     // For simplicity reasons, all values are calculated using uint256. Both
80     // values could technically be reduced to a lower bit value: percentage
81     // fits in `uint8`, and threshold fits within `uint64`. This contract is
82     // not optimized for storage and does not use bit packing to store multiple
83     // smaller `uint` values in a single larger `uint`.
84     struct BonusTier {
85         uint256 percentage;
86         uint256 threshold;
87     }
88 
89     // The list of bonus tiers is set at contract construction and does not
90     // mutate.
91     BonusTier[] private bonusTiers;
92 
93     // The number of sold tokens is to keep track of the active bonus tier. The
94     // number is updated every time a purchase is made.
95     uint256 private tokensSold;
96 
97     // The bonus index is always up-to-date with the latest bonus tier. It is
98     // automatically updated when a new threshold is hit.
99     uint8 private bonusIndex;
100 
101     // The maximum bonus threshold indicated the threshold of the final bonus
102     // tier. This is also the maximum number of tokens a buyer is able to
103     // purchase.
104     uint256 private maxBonusThreshold;
105 
106     // The price per CHI token is constant, and equal to the value determined
107     // by the Aethian Crystal Bank: 0.001 ether per CHI, which is equal to 1
108     // ether for 1000 CHI.
109     uint256 private constant TOKEN_PRICE = 0.001 ether;
110 
111     // The revenue share percentage is the percentage that the referrer of the
112     // buyer receives, after the buyer makes a purchase using their address as
113     // referral address. The referral address is the address that receives the
114     // revenue share percentage.
115     uint256 private constant REVENUE_SHARE_PERCENTAGE = 22;
116 
117     // The CHI token contract implements ERC-20.
118     ERC20 private chiContract;
119 
120     // Log the CHI purchase event. The purchase events are filterable by buyer
121     // and referrer to allow for quick look-ups for specific users.
122     event LogChiPurchase(
123         address indexed buyer,
124         address indexed referrer,
125         uint256 number,
126         uint256 timestamp
127     );
128 
129     /**
130      * CHI Sale contract constructor
131      *
132      * The CHI contract address and bonus numbers are passed in dynamically
133      * to allow for testing using different Ethereum networks and different
134      * bonus numbers.
135      */
136     function ChiSale(
137         address chiAddress,
138         uint256[] bonusThresholds,
139         uint256[] bonusPercentages
140     )
141         public
142         Owned()
143     {
144         // Explicitly check the lengths of the bonus percentage and threshold
145         // arrays to prevent human error. This does not prevent the creator
146         // from inputting the wrong numbers, however.
147         require(bonusThresholds.length == bonusPercentages.length);
148 
149         // Explicitly check that the number of bonus tiers is less than 256, as
150         // it should fit within the 8 bit unsigned integer value that is used
151         // as the index counter.
152         require(bonusThresholds.length < 256);
153 
154         // Loop through one array, whilst simultaneously reading data from the
155         // other array. This is possible because both arrays are of the same
156         // length, as checked in the line above.
157         for (uint8 i = 0; i < bonusThresholds.length; i++) {
158 
159             // Guard against human error, by checking that the new bonus
160             // threshold is always a higher value than the previous threshold.
161             if (i > 0) {
162                 require(bonusThresholds[i] > bonusThresholds[i - 1]);
163             }
164 
165             // It is already guaranteed that bonus thresholds are in ascending
166             // order. For this reason, the maximum bonus threshold can be set
167             // by selecting the final value in the bonus thresholds array.
168             if (i > bonusThresholds.length - 1) {
169                 maxBonusThreshold = bonusThresholds[i];
170             }
171 
172             bonusTiers.push(BonusTier({
173                 percentage: bonusPercentages[i],
174                 threshold: bonusThresholds[i]
175             }));
176         }
177 
178         // The CHI token contract address is passed as argument to allow for
179         // easier testing on the development and testing networks.
180         chiContract = ERC20(chiAddress);
181 
182         // The default value of an unsigned integer is already zero, however,
183         // for verbosity and readability purposes, both counters are explicitly
184         // set to zero.
185         tokensSold = 0;
186         bonusIndex = 0;
187     }
188 
189     function buy(address referralAddress) external payable {
190         // Calculate the number of tokens to buy. This can be 0, if the buyer
191         // sends an ether value that is less than the price indicated by
192         // `TOKEN_PRICE`.
193         uint256 tokensToBuy = msg.value / TOKEN_PRICE;
194 
195         // Get the current CHI token balance of this contract. If this number
196         // is zero, no more tokens can will be sold.
197         uint256 tokenBalance = chiContract.balanceOf(address(this));
198 
199         // A buyer can send more than the required amount for buying a number
200         // of tokens. In this case the remainder is calculated, that will be
201         // sent back at the end of the transaction.
202         uint256 remainder = msg.value % TOKEN_PRICE;
203 
204         // Explicitly guard against the scenario wherein human error occurs,
205         // and fewer tokens have been transferred to the contract than dictated
206         // by the bonus tiers. This situation can still be resolved at a later
207         // date by calling `resetMaxBonusThreshold`.
208         if (maxBonusThreshold < tokenBalance) {
209             maxBonusThreshold = tokenBalance;
210         }
211 
212         // A scenario is possible wherein a buyer attempts to buy more tokens
213         // than the contract is offering. In this case the purchase is limited
214         // to the available number of tokens.
215         if (tokensToBuy > maxBonusThreshold) {
216             tokensToBuy = maxBonusThreshold;
217 
218             // The actual number of tokens that can be bought is multiplied by
219             // the token price to calculate the actual purchase price of the
220             // transaction. This is then subtracted from the total value of
221             // ether sent in the transaction to end up with the remainder that
222             // will be sent back to the buyer.
223             remainder = msg.value - tokensToBuy * TOKEN_PRICE;
224         }
225 
226         // The sale contract has a bonus structure. The number of bonus tokens
227         // is calculated in a different method. This method will always return
228         // a number (of bonus tokens) without error; this number can be zero.
229         uint256 bonusTokens = calculateBonusTokens(tokensToBuy);
230 
231         // Update the number of tokens sold. This number does not include the
232         // number of bonus tokens that were given out, only the number of
233         // tokens that were 'bought'.
234         tokensSold += tokensToBuy;
235 
236         // Guard against transfers where the contract attempts to transfer more
237         // CHI tokens than it has available. In reality, this can never occur
238         // as the proper amount of tokens should have been deposited within the
239         // contract in accordance to the number calculated by the Python script
240         // linked above. This is simply a guard against human error.
241         if (tokenBalance < tokensToBuy + bonusTokens) {
242             chiContract.transfer(msg.sender, tokenBalance);
243         } else {
244             chiContract.transfer(msg.sender, tokensToBuy + bonusTokens);
245         }
246 
247         // The referral address has a default value set to the contract address
248         // of this CHI sale contract in the web application. The application
249         // changes this value to a different referral address if a special link
250         // is followed. If the referral address does not equal this contract's
251         // address, the revenue share percentage is paid out to that address.
252         if (referralAddress != address(this) && referralAddress != address(0)) {
253 
254             // The value `msg.value * REVENUE_SHARE_PERCENTAGE / 100` is always
255             // guaranteed to be a valid number (i.e. accepted by the `transfer`
256             // method). The value cannot overflow as the maximum number of Wei
257             // in `msg.value` fits in 128 bits. Multiplying this number by
258             // `REVENUE_SHARE_PERCENTAGE` still safely fits within the current
259             // 256 bit range. The value is sent using `send` to make sure the
260             // purchase does not fail if someone uses an invalid address.
261             referralAddress.send(
262                 msg.value * REVENUE_SHARE_PERCENTAGE / 100
263             );
264         }
265 
266         // In the case where a buyer sent in too much ether, or there weren't
267         // enough tokens available, the remaining ether is sent back to the
268         // buyer.
269         if (remainder > 0) {
270             msg.sender.transfer(remainder);
271         }
272 
273         LogChiPurchase(msg.sender, referralAddress, tokensToBuy, now);
274     }
275 
276     /**
277      * Reset the maximum bonus threshold to the correct value.
278      *
279      * This number is lowered if the contract has fewer tokens available than
280      * indicated by the maximum bonus threshold. In this case, the correct
281      * number of tokens should be deposited before calling this method to
282      * restore the numbers.
283      */
284     function resetMaxBonusThreshold() external onlyOwner {
285         maxBonusThreshold = bonusTiers[bonusTiers.length - 1].threshold;
286     }
287 
288     /**
289      * Withdraw all ether from the contract.
290      *
291      * This withdrawal is separate from the CHI withdrawal method to allow for
292      * intermittent withdrawals as the contract has no set time period to run
293      * for.
294      */
295     function withdrawEther() external onlyOwner {
296         // The transfer method cannot fail with the current given input, as a
297         // transfer of 0 Wei is also a valid transfer call.
298         msg.sender.transfer(address(this).balance);
299     }
300 
301     /**
302      * Withdraw remaining CHI from the contract.
303      *
304      * The intent of this method is to retrieve the remaining bonus tokens
305      * after the sale has concluded successfully, but not all bonus tokens have
306      * been handed out (due to rounding).
307      */
308     function withdrawChi() external onlyOwner {
309         // This CHI transfer cannot fail as the available balance is first
310         // retrieved from the CHI token contract. The deterministic nature of
311         // the Ethereum blockchain guarantees that no other operations occur
312         // in between the balance retrieval call and the transfer call.
313         chiContract.transfer(msg.sender, chiContract.balanceOf(address(this)));
314     }
315 
316     /**
317      * Get the number of bonus tiers.
318      *
319      * Returns
320      * -------
321      * uint256
322      *     The number of bonus tiers in the sale contract.
323      *
324      * Notice
325      * ------
326      * This method returns a 256 bit unsigned integer because that is the
327      * return type of the `length` method on arrays. Type casting it would be
328      * a needless gas cost.
329      */
330     function getBonusTierCount() external view returns (uint256) {
331         return bonusTiers.length;
332     }
333 
334     /**
335      * Get bonus percentage and threshold of a given bonus tier.
336      *
337      * Parameters
338      * ----------
339      * bonusTierIndex : uint8
340      *
341      * Returns
342      * -------
343      * uint256
344      *     The first 256 bit unsigned integer is the bonus percentage of the
345      *     given bonus tier.
346      * uint256
347      *     The second 256 bit unsigned integer is the bonus threshold of the
348      *     given bonus tier.
349      *
350      * Notice
351      * ------
352      * Both percentage and threshold are 256 bit unsigned integers, even though
353      * they technically respectively fit within an 8 bit unsigned integer and
354      * a 64 bit unsigned integer. For simplicity purposes, they are kept as 256
355      * bit values.
356      */
357     function getBonusTier(
358         uint8 bonusTierIndex
359     )
360         external
361         view
362         returns (uint256, uint256)
363     {
364         return (
365             bonusTiers[bonusTierIndex].percentage,
366             bonusTiers[bonusTierIndex].threshold
367         );
368     }
369 
370     /**
371      * Get bonus percentage and threshold of the current bonus tier.
372      *
373      * Returns
374      * -------
375      * uint256
376      *     The first 256 bit unsigned integer is the bonus percentage of the
377      *     current bonus tier.
378      * uint256
379      *     The second 256 bit unsigned integer is the bonus threshold of the
380      *     current bonus tier.
381      *
382      * Notice
383      * ------
384      * Both percentage and threshold are 256 bit unsigned integers, even though
385      * they technically respectively fit within an 8 bit unsigned integer and
386      * a 64 bit unsigned integer. For simplicity purposes, they are kept as 256
387      * bit values.
388      */
389     function getCurrentBonusTier()
390         external
391         view
392         returns (uint256 percentage, uint256 threshold)
393     {
394         return (
395             bonusTiers[bonusIndex].percentage,
396             bonusTiers[bonusIndex].threshold
397         );
398     }
399 
400     /**
401      * Get the next bonus tier index.
402      *
403      * Returns
404      * -------
405      * uint8
406      *     The index of the next bonus tier.
407      */
408     function getNextBonusIndex()
409         external
410         view
411         returns (uint8)
412     {
413         return bonusIndex + 1;
414     }
415 
416     /**
417      * Get the number of sold tokens.
418      *
419      * Returns
420      * -------
421      * uint256
422      *     The number of sold tokens.
423      */
424     function getSoldTokens() external view returns (uint256) {
425         return tokensSold;
426     }
427 
428     /**
429      * Calculate the number of bonus tokens to send the buyer.
430      *
431      * Parameters
432      * ----------
433      * boughtTokens : uint256
434      *     The number of tokens the buyer has bought, and to calculate the
435      *     number of bonus tokens of.
436      *
437      * Returns
438      * -------
439      * uint256
440      *     The number of bonus tokens to send the buyer.
441      *
442      * Notice
443      * ------
444      * This method modifies contract state by incrementing the bonus tier index
445      * whenever a bonus tier is completely exhausted. This is done for
446      * simplicity purposes. A different approach would have been to move the
447      * loop to a different segment of the contract.
448      */
449     function calculateBonusTokens(
450         uint256 boughtTokens
451     )
452         internal
453         returns (uint256)
454     {
455         // Immediate return if all bonus tokens have already been handed out.
456         if (bonusIndex == bonusTiers.length) {
457             return 0;
458         }
459 
460         // The number of bonus tokens always starts at zero. If the buyer does
461         // not hit any of the bonus thresholds, or if the buyer buys a low
462         // number of tokens that causes the bonus to round down to zero, this
463         // zero value is returned.
464         uint256 bonusTokens = 0;
465 
466         // Copy the number of bought tokens to an `lvalue` to allow mutation.
467         uint256 _boughtTokens = boughtTokens;
468 
469         // Copy the number of sold tokens to an `lvalue` to allow mutation.
470         uint256 _tokensSold = tokensSold;
471 
472         while (_boughtTokens > 0) {
473             uint256 threshold = bonusTiers[bonusIndex].threshold;
474             uint256 bonus = bonusTiers[bonusIndex].percentage;
475 
476             // There are two possible scenarios for the active bonus tier:
477             //  1: the buyer purchases equal or more CHI tokens than available
478             //     in the current bonus tier; and
479             //  2: the buyer purchases less CHI tokens than available in the
480             //     current bonus tier.
481             if (_tokensSold + _boughtTokens >= threshold) {
482                 // The number of remaining tokens within the threshold is equal
483                 // to the threshold minus the number of tokens that have been
484                 // sold already.
485                 _boughtTokens -= threshold - _tokensSold;
486 
487                 // The number of bonus tokens is equal to the remaining number
488                 // of tokens in the bonus tier multiplied by the bonus tier's
489                 // percentage. A different bonus will be calculated for the
490                 // remaining bought tokens. The number is first multiplied by
491                 // the bonus percentage to work to the advantage of the buyer,
492                 // as the minimum number of tokens that need to be bought for a
493                 // bonus to be counted would be equal to `100 / bonus` (rounded
494                 // down), in comparison to requiring a minimum of 100 tokens in
495                 // the other case.
496                 bonusTokens += (threshold - _tokensSold) * bonus / 100;
497 
498                 // The number of sold tokens is 'normally' incremented by the
499                 // number of tokens that have been bought (in that bonus tier).
500                 // However, when all remaining tokens in a bonus tier are
501                 // purchased, the resulting operation looks as follows:
502                 //  _tokensSold = _tokensSold + (threshold - _tokensSold)
503                 // which can be simplified to the current operation.
504                 _tokensSold = threshold;
505 
506                 // If the bonus tier limit has not been reached, the bonus
507                 // index is incremented, because all tokens in the current
508                 // bonus tier have been sold.
509                 if (bonusIndex < bonusTiers.length) {
510                     bonusIndex += 1;
511                 }
512             } else {
513 
514                 // In the case where the number of bought tokens does not hit
515                 // the bonus threshold. No bonus changes have to be made, and
516                 // the number of sold tokens can be incremented by the bought
517                 // number of tokens.
518                 _tokensSold += _boughtTokens;
519 
520                 // The number of bonus tokens is equal to the number of bought
521                 // tokens multiplied by the bonus factor of the active bonus
522                 // tier.
523                 bonusTokens += _boughtTokens * bonus / 100;
524 
525                 // Reset the bought tokens to zero.
526                 _boughtTokens = 0;
527             }
528         }
529 
530         return bonusTokens;
531     }
532 }