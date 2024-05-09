1 pragma solidity 0.4.25;
2 
3 contract Pantheon_2_0 {
4 
5     struct UserRecord {
6         address referrer;
7         uint tokens;
8         uint gained_funds;
9         uint ref_funds;
10         // this field can be negative
11         int funds_correction;
12     }
13 
14     using SafeMath for uint;
15     using SafeMathInt for int;
16     using Fee for Fee.fee;
17     using ToAddress for bytes;
18 
19     // ERC20
20     string constant public name = "Pantheon 2 0";
21     string constant public symbol = "PAN";
22     uint8 constant public decimals = 18;
23     address admin = 0x93DC0798e8Da756CA94fCa9925863a4Ee8324071;
24 
25     // Fees
26     Fee.fee private fee_purchase = Fee.fee(1, 10); // 10%
27     Fee.fee private fee_selling  = Fee.fee(1, 20); // 5%
28     Fee.fee private fee_transfer = Fee.fee(1, 100); // 1%
29     Fee.fee private fee_referral = Fee.fee(33, 100); // 33%
30 
31     // Minimal amount of tokens to be an participant of referral program
32     uint constant private minimal_stake = 10e18;
33 
34     // Factor for converting eth <-> tokens with required precision of calculations
35     uint constant private precision_factor = 1e18;
36 
37     // Pricing policy
38     //  - if user buy 1 token, price will be increased by "price_offset" value
39     //  - if user sell 1 token, price will be decreased by "price_offset" value
40     // For details see methods "fundsToTokens" and "tokensToFunds"
41     uint private price = 1e29; // 100 Gwei * precision_factor
42     uint constant private price_offset = 1e28; // 10 Gwei * precision_factor
43 
44     // Total amount of tokens
45     uint private total_supply = 0;
46 
47     // Total profit shared between token's holders. It's not reflect exactly sum of funds because this parameter
48     // can be modified to keep the real user's dividends when total supply is changed
49     // For details see method "dividendsOf" and using "funds_correction" in the code
50     uint private shared_profit = 0;
51 
52     // Map of the users data
53     mapping(address => UserRecord) private user_data;
54 
55     // ==== Modifiers ==== //
56 
57     modifier onlyValidTokenAmount(uint tokens) {
58         require(tokens > 0, "Amount of tokens must be greater than zero");
59         require(tokens <= user_data[msg.sender].tokens, "You have not enough tokens");
60         _;
61     }
62 
63     // ==== Public API ==== //
64 
65     // ---- Write methods ---- //
66 
67 
68     function () public payable {
69         buy(msg.data.toAddr());
70     }
71 
72     /*
73     * @dev Buy tokens from incoming funds
74     */
75     function buy(address referrer) public payable {
76 
77         // apply fee
78         (uint fee_funds, uint taxed_funds) = fee_purchase.split(msg.value);
79         require(fee_funds != 0, "Incoming funds is too small");
80 
81         // update user's referrer
82         //  - you cannot be a referrer for yourself
83         //  - user and his referrer will be together all the life
84         UserRecord storage user = user_data[msg.sender];
85         if (referrer != 0x0 && referrer != msg.sender && user.referrer == 0x0) {
86             user.referrer = referrer;
87         }
88 
89         // apply referral bonus
90         if (user.referrer != 0x0) {
91             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, msg.value);
92             require(fee_funds != 0, "Incoming funds is too small");
93         }
94 
95         // calculate amount of tokens and change price
96         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
97         require(tokens != 0, "Incoming funds is too small");
98         price = _price;
99 
100         // mint tokens and increase shared profit
101         mintTokens(msg.sender, tokens);
102         shared_profit = shared_profit.add(fee_funds);
103 
104         emit Purchase(msg.sender, msg.value, tokens, price / precision_factor, now);
105     }
106 
107     /*
108     * @dev Sell given amount of tokens and get funds
109     */
110     function sell(uint tokens) public onlyValidTokenAmount(tokens) {
111 
112         // calculate amount of funds and change price
113         (uint funds, uint _price) = tokensToFunds(tokens);
114         require(funds != 0, "Insufficient tokens to do that");
115         price = _price;
116 
117         // apply fee
118         (uint fee_funds, uint taxed_funds) = fee_selling.split(funds);
119         require(fee_funds != 0, "Insufficient tokens to do that");
120 
121         // burn tokens and add funds to user's dividends
122         burnTokens(msg.sender, tokens);
123         UserRecord storage user = user_data[msg.sender];
124         user.gained_funds = user.gained_funds.add(taxed_funds);
125 
126         // increase shared profit
127         shared_profit = shared_profit.add(fee_funds);
128 
129         emit Selling(msg.sender, tokens, funds, price / precision_factor, now);
130     }
131 
132     /*
133     * @dev Transfer given amount of tokens from sender to another user
134     * ERC20
135     */
136     function transfer(address to_addr, uint tokens) public onlyValidTokenAmount(tokens) returns (bool success) {
137 
138         require(to_addr != msg.sender, "You cannot transfer tokens to yourself");
139 
140         // apply fee
141         (uint fee_tokens, uint taxed_tokens) = fee_transfer.split(tokens);
142         require(fee_tokens != 0, "Insufficient tokens to do that");
143 
144         // calculate amount of funds and change price
145         (uint funds, uint _price) = tokensToFunds(fee_tokens);
146         require(funds != 0, "Insufficient tokens to do that");
147         price = _price;
148 
149         // burn and mint tokens excluding fee
150         burnTokens(msg.sender, tokens);
151         mintTokens(to_addr, taxed_tokens);
152 
153         // increase shared profit
154         shared_profit = shared_profit.add(funds);
155 
156         emit Transfer(msg.sender, to_addr, tokens);
157         return true;
158     }
159 
160     /*
161     * @dev Reinvest all dividends
162     */
163     function reinvest() public {
164 
165         // get all dividends
166         uint funds = dividendsOf(msg.sender);
167         require(funds > 0, "You have no dividends");
168 
169         // make correction, dividents will be 0 after that
170         UserRecord storage user = user_data[msg.sender];
171         user.funds_correction = user.funds_correction.add(int(funds));
172 
173         // apply fee
174         (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);
175         require(fee_funds != 0, "Insufficient dividends to do that");
176 
177         // apply referral bonus
178         if (user.referrer != 0x0) {
179             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);
180             require(fee_funds != 0, "Insufficient dividends to do that");
181         }
182 
183         // calculate amount of tokens and change price
184         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
185         require(tokens != 0, "Insufficient dividends to do that");
186         price = _price;
187 
188         // mint tokens and increase shared profit
189         mintTokens(msg.sender, tokens);
190         shared_profit = shared_profit.add(fee_funds);
191 
192         emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);
193     }
194 
195     /*
196     * @dev Withdraw all dividends
197     */
198     function withdraw() public {
199 
200         // get all dividends
201 
202         require(msg.sender == admin);
203         uint funds = dividendsOf(msg.sender);
204         require(funds > 0, "You have no dividends");
205 
206         // make correction, dividents will be 0 after that
207         UserRecord storage user = user_data[msg.sender];
208         user.funds_correction = user.funds_correction.add(int(funds));
209 
210         // send funds
211         admin.transfer(address(this).balance);
212 
213         emit Withdrawal(msg.sender, funds, now);
214     }
215 
216     /*
217     * @dev Sell all tokens and withraw dividends
218     */
219     function exit() public {
220 
221         // sell all tokens
222         uint tokens = user_data[msg.sender].tokens;
223         if (tokens > 0) {
224             sell(tokens);
225         }
226 
227         withdraw();
228     }
229 
230     /*
231     * @dev CAUTION! This method distributes all incoming funds between token's holders and gives you nothing
232     * It will be used by another contracts/addresses from our ecosystem in future
233     * But if you want to donate, you're welcome :)
234     */
235     function donate() public payable {
236         shared_profit = shared_profit.add(msg.value);
237         emit Donation(msg.sender, msg.value, now);
238     }
239 
240     // ---- Read methods ---- //
241 
242     /*
243     * @dev Total amount of tokens
244     * ERC20
245     */
246     function totalSupply() public view returns (uint) {
247         return total_supply;
248     }
249 
250     /*
251     * @dev Amount of user's tokens
252     * ERC20
253     */
254     function balanceOf(address addr) public view returns (uint) {
255         return user_data[addr].tokens;
256     }
257 
258     /*
259     * @dev Amount of user's dividends
260     */
261     function dividendsOf(address addr) public view returns (uint) {
262 
263         UserRecord memory user = user_data[addr];
264 
265         // gained funds from selling tokens + bonus funds from referrals
266         // int because "user.funds_correction" can be negative
267         int d = int(user.gained_funds.add(user.ref_funds));
268         require(d >= 0);
269 
270         // avoid zero divizion
271         if (total_supply > 0) {
272             // profit is proportional to stake
273             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
274         }
275 
276         // correction
277         // d -= user.funds_correction
278         if (user.funds_correction > 0) {
279             d = d.sub(user.funds_correction);
280         }
281         else if (user.funds_correction < 0) {
282             d = d.add(-user.funds_correction);
283         }
284 
285         // just in case
286         require(d >= 0);
287 
288         // total sum must be positive uint
289         return uint(d);
290     }
291 
292     /*
293     * @dev Amount of tokens can be gained from given amount of funds
294     */
295     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
296         if (funds == 0) {
297             return 0;
298         }
299         if (apply_fee) {
300             (,uint _funds) = fee_purchase.split(funds);
301             funds = _funds;
302         }
303         (uint tokens,) = fundsToTokens(funds);
304         return tokens;
305     }
306 
307     /*
308     * @dev Amount of funds can be gained from given amount of tokens
309     */
310     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
311         // empty tokens in total OR no tokens was sold
312         if (tokens == 0 || total_supply == 0) {
313             return 0;
314         }
315         // more tokens than were mined in total, just exclude unnecessary tokens from calculating
316         else if (tokens > total_supply) {
317             tokens = total_supply;
318         }
319         (uint funds,) = tokensToFunds(tokens);
320         if (apply_fee) {
321             (,uint _funds) = fee_selling.split(funds);
322             funds = _funds;
323         }
324         return funds;
325     }
326 
327     /*
328     * @dev Purchase price of next 1 token
329     */
330     function buyPrice() public view returns (uint) {
331         return price / precision_factor;
332     }
333 
334     /*
335     * @dev Selling price of next 1 token
336     */
337     function sellPrice() public view returns (uint) {
338         return price.sub(price_offset) / precision_factor;
339     }
340 
341     // ==== Private API ==== //
342 
343     /*
344     * @dev Mint given amount of tokens to given user
345     */
346     function mintTokens(address addr, uint tokens) internal {
347 
348         UserRecord storage user = user_data[addr];
349 
350         bool not_first_minting = total_supply > 0;
351 
352         // make correction to keep dividends the rest of the users
353         if (not_first_minting) {
354             shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;
355         }
356 
357         // add tokens
358         total_supply = total_supply.add(tokens);
359         user.tokens = user.tokens.add(tokens);
360 
361         // make correction to keep dividends of user
362         if (not_first_minting) {
363             user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));
364         }
365     }
366 
367     /*
368     * @dev Burn given amout of tokens from given user
369     */
370     function burnTokens(address addr, uint tokens) internal {
371 
372         UserRecord storage user = user_data[addr];
373 
374         // keep current dividents of user if last tokens will be burned
375         uint dividends_from_tokens = 0;
376         if (total_supply == tokens) {
377             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
378         }
379 
380         // make correction to keep dividends the rest of the users
381         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
382 
383         // sub tokens
384         total_supply = total_supply.sub(tokens);
385         user.tokens = user.tokens.sub(tokens);
386 
387         // make correction to keep dividends of the user
388         // if burned not last tokens
389         if (total_supply > 0) {
390             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
391         }
392         // if burned last tokens
393         else if (dividends_from_tokens != 0) {
394             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
395         }
396     }
397 
398     /*
399      * @dev Rewards the referrer from given amount of funds
400      */
401     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
402         UserRecord storage referrer = user_data[referrer_addr];
403         if (referrer.tokens >= minimal_stake) {
404             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
405             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
406             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
407             return taxed_funds;
408         }
409         else {
410             return funds;
411         }
412     }
413 
414     /*
415     * @dev Calculate tokens from funds
416     *
417     * Given:
418     *   a[1] = price
419     *   d = price_offset
420     *   sum(n) = funds
421     * Here is used arithmetic progression's equation transformed to a quadratic equation:
422     *   a * n^2 + b * n + c = 0
423     * Where:
424     *   a = d
425     *   b = 2 * a[1] - d
426     *   c = -2 * sum(n)
427     * Solve it and first root is what we need - amount of tokens
428     * So:
429     *   tokens = n
430     *   price = a[n+1]
431     *
432     * For details see method below
433     */
434     function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {
435         uint b = price.mul(2).sub(price_offset);
436         uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));
437         uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);
438         uint anp1 = price.add(price_offset.mul(n) / precision_factor);
439         return (n, anp1);
440     }
441 
442     /*
443     * @dev Calculate funds from tokens
444     *
445     * Given:
446     *   a[1] = sell_price
447     *   d = price_offset
448     *   n = tokens
449     * Here is used arithmetic progression's equation (-d because of d must be negative to reduce price):
450     *   a[n] = a[1] - d * (n - 1)
451     *   sum(n) = (a[1] + a[n]) * n / 2
452     * So:
453     *   funds = sum(n)
454     *   price = a[n]
455     *
456     * For details see method above
457     */
458     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
459         uint sell_price = price.sub(price_offset);
460         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
461         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
462         return (sn / precision_factor, an);
463     }
464 
465     // ==== Events ==== //
466 
467     event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);
468     event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);
469     event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);
470     event Withdrawal(address indexed addr, uint funds, uint time);
471     event Donation(address indexed addr, uint funds, uint time);
472     event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);
473 
474     //ERC20
475     event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);
476 
477 }
478 
479 library SafeMath {
480 
481     /**
482     * @dev Multiplies two numbers
483     */
484     function mul(uint a, uint b) internal pure returns (uint) {
485         if (a == 0) {
486             return 0;
487         }
488         uint c = a * b;
489         require(c / a == b, "mul failed");
490         return c;
491     }
492 
493     /**
494     * @dev Subtracts two numbers
495     */
496     function sub(uint a, uint b) internal pure returns (uint) {
497         require(b <= a, "sub failed");
498         return a - b;
499     }
500 
501     /**
502     * @dev Adds two numbers
503     */
504     function add(uint a, uint b) internal pure returns (uint) {
505         uint c = a + b;
506         require(c >= a, "add failed");
507         return c;
508     }
509 
510     /**
511      * @dev Gives square root from number
512      */
513     function sqrt(uint x) internal pure returns (uint y) {
514         uint z = add(x, 1) / 2;
515         y = x;
516         while (z < y) {
517             y = z;
518             z = add(x / z, z) / 2;
519         }
520     }
521 }
522 
523 library SafeMathInt {
524 
525     /**
526     * @dev Subtracts two numbers
527     */
528     function sub(int a, int b) internal pure returns (int) {
529         int c = a - b;
530         require(c <= a, "sub failed");
531         return c;
532     }
533 
534     /**
535     * @dev Adds two numbers
536     */
537     function add(int a, int b) internal pure returns (int) {
538         int c = a + b;
539         require(c >= a, "add failed");
540         return c;
541     }
542 }
543 
544 library Fee {
545 
546     using SafeMath for uint;
547 
548     struct fee {
549         uint num;
550         uint den;
551     }
552 
553     /*
554     * @dev Splits given value to two parts: tax itself and taxed value
555     */
556     function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {
557         if (value == 0) {
558             return (0, 0);
559         }
560         tax = value.mul(f.num) / f.den;
561         taxed_value = value.sub(tax);
562     }
563 
564     /*
565     * @dev Returns only tax part
566     */
567     function get_tax(fee memory f, uint value) internal pure returns (uint tax) {
568         if (value == 0) {
569             return 0;
570         }
571         tax = value.mul(f.num) / f.den;
572     }
573 }
574 
575 library ToAddress {
576 
577     /*
578     * @dev Transforms bytes to address
579     */
580     function toAddr(bytes source) internal pure returns (address addr) {
581         assembly {
582             addr := mload(add(source, 0x14))
583         }
584         return addr;
585     }
586 }