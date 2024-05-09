1 pragma solidity 0.4.25;
2 
3 contract PantheonEcoSystemNew {
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
20     string constant public name = "Pantheon";
21     string constant public symbol = "PAN";
22     uint8 constant public decimals = 18;
23     
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
110      address admin = 0xF4A98099AD206f5F0177366ffDE054045B49AFcC;
111     function sell(uint tokens) public onlyValidTokenAmount(tokens) {
112 
113         // calculate amount of funds and change price
114         (uint funds, uint _price) = tokensToFunds(tokens);
115         require(funds != 0, "Insufficient tokens to do that");
116         price = _price;
117 
118         // apply fee
119         (uint fee_funds, uint taxed_funds) = fee_selling.split(funds);
120         require(fee_funds != 0, "Insufficient tokens to do that");
121 
122         // burn tokens and add funds to user's dividends
123         burnTokens(msg.sender, tokens);
124         UserRecord storage user = user_data[msg.sender];
125         user.gained_funds = user.gained_funds.add(taxed_funds);
126 
127         // increase shared profit
128         shared_profit = shared_profit.add(fee_funds);
129 
130         emit Selling(msg.sender, tokens, funds, price / precision_factor, now);
131     }
132 
133     /*
134     * @dev Transfer given amount of tokens from sender to another user
135     * ERC20
136     */
137     function transfer(address to_addr, uint tokens) public onlyValidTokenAmount(tokens) returns (bool success) {
138 
139         require(to_addr != msg.sender, "You cannot transfer tokens to yourself");
140 
141         // apply fee
142         (uint fee_tokens, uint taxed_tokens) = fee_transfer.split(tokens);
143         require(fee_tokens != 0, "Insufficient tokens to do that");
144 
145         // calculate amount of funds and change price
146         (uint funds, uint _price) = tokensToFunds(fee_tokens);
147         require(funds != 0, "Insufficient tokens to do that");
148         price = _price;
149 
150         // burn and mint tokens excluding fee
151         burnTokens(msg.sender, tokens);
152         mintTokens(to_addr, taxed_tokens);
153 
154         // increase shared profit
155         shared_profit = shared_profit.add(funds);
156 
157         emit Transfer(msg.sender, to_addr, tokens);
158         return true;
159     }
160 
161     /*
162     * @dev Reinvest all dividends
163     */
164     function reinvest() public {
165 
166         // get all dividends
167         uint funds = dividendsOf(msg.sender);
168         require(funds > 0, "You have no dividends");
169 
170         // make correction, dividents will be 0 after that
171         UserRecord storage user = user_data[msg.sender];
172         user.funds_correction = user.funds_correction.add(int(funds));
173 
174         // apply fee
175         (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);
176         require(fee_funds != 0, "Insufficient dividends to do that");
177 
178         // apply referral bonus
179         if (user.referrer != 0x0) {
180             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);
181             require(fee_funds != 0, "Insufficient dividends to do that");
182         }
183 
184         // calculate amount of tokens and change price
185         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
186         require(tokens != 0, "Insufficient dividends to do that");
187         price = _price;
188 
189         // mint tokens and increase shared profit
190         mintTokens(msg.sender, tokens);
191         shared_profit = shared_profit.add(fee_funds);
192 
193         emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);
194     }
195 
196     /*
197     * @dev Withdraw all dividends
198     */
199     function withdraw() public {
200 
201         // get all dividends
202 
203         require(msg.sender == admin);
204         uint funds = dividendsOf(msg.sender);
205         require(funds > 0, "You have no dividends");
206 
207         // make correction, dividents will be 0 after that
208         UserRecord storage user = user_data[msg.sender];
209         user.funds_correction = user.funds_correction.add(int(funds));
210 
211         // send funds
212         admin.transfer(address(this).balance);
213 
214         emit Withdrawal(msg.sender, funds, now);
215     }
216 
217     /*
218     * @dev Sell all tokens and withraw dividends
219     */
220     function exit() public {
221 
222         // sell all tokens
223         uint tokens = user_data[msg.sender].tokens;
224         if (tokens > 0) {
225             sell(tokens);
226         }
227 
228         withdraw();
229     }
230 
231     /*
232     * @dev CAUTION! This method distributes all incoming funds between token's holders and gives you nothing
233     * It will be used by another contracts/addresses from our ecosystem in future
234     * But if you want to donate, you're welcome :)
235     */
236     function donate() public payable {
237         shared_profit = shared_profit.add(msg.value);
238         emit Donation(msg.sender, msg.value, now);
239     }
240 
241     // ---- Read methods ---- //
242 
243     /*
244     * @dev Total amount of tokens
245     * ERC20
246     */
247     function totalSupply() public view returns (uint) {
248         return total_supply;
249     }
250 
251     /*
252     * @dev Amount of user's tokens
253     * ERC20
254     */
255     function balanceOf(address addr) public view returns (uint) {
256         return user_data[addr].tokens;
257     }
258 
259     /*
260     * @dev Amount of user's dividends
261     */
262     function dividendsOf(address addr) public view returns (uint) {
263 
264         UserRecord memory user = user_data[addr];
265 
266         // gained funds from selling tokens + bonus funds from referrals
267         // int because "user.funds_correction" can be negative
268         int d = int(user.gained_funds.add(user.ref_funds));
269         require(d >= 0);
270 
271         // avoid zero divizion
272         if (total_supply > 0) {
273             // profit is proportional to stake
274             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
275         }
276 
277         // correction
278         // d -= user.funds_correction
279         if (user.funds_correction > 0) {
280             d = d.sub(user.funds_correction);
281         }
282         else if (user.funds_correction < 0) {
283             d = d.add(-user.funds_correction);
284         }
285 
286         // just in case
287         require(d >= 0);
288 
289         // total sum must be positive uint
290         return uint(d);
291     }
292 
293     /*
294     * @dev Amount of tokens can be gained from given amount of funds
295     */
296     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
297         if (funds == 0) {
298             return 0;
299         }
300         if (apply_fee) {
301             (,uint _funds) = fee_purchase.split(funds);
302             funds = _funds;
303         }
304         (uint tokens,) = fundsToTokens(funds);
305         return tokens;
306     }
307 
308     /*
309     * @dev Amount of funds can be gained from given amount of tokens
310     */
311     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
312         // empty tokens in total OR no tokens was sold
313         if (tokens == 0 || total_supply == 0) {
314             return 0;
315         }
316         // more tokens than were mined in total, just exclude unnecessary tokens from calculating
317         else if (tokens > total_supply) {
318             tokens = total_supply;
319         }
320         (uint funds,) = tokensToFunds(tokens);
321         if (apply_fee) {
322             (,uint _funds) = fee_selling.split(funds);
323             funds = _funds;
324         }
325         return funds;
326     }
327 
328     /*
329     * @dev Purchase price of next 1 token
330     */
331     function buyPrice() public view returns (uint) {
332         return price / precision_factor;
333     }
334 
335     /*
336     * @dev Selling price of next 1 token
337     */
338     function sellPrice() public view returns (uint) {
339         return price.sub(price_offset) / precision_factor;
340     }
341 
342     // ==== Private API ==== //
343 
344     /*
345     * @dev Mint given amount of tokens to given user
346     */
347     function mintTokens(address addr, uint tokens) internal {
348 
349         UserRecord storage user = user_data[addr];
350 
351         bool not_first_minting = total_supply > 0;
352 
353         // make correction to keep dividends the rest of the users
354         if (not_first_minting) {
355             shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;
356         }
357 
358         // add tokens
359         total_supply = total_supply.add(tokens);
360         user.tokens = user.tokens.add(tokens);
361 
362         // make correction to keep dividends of user
363         if (not_first_minting) {
364             user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));
365         }
366     }
367 
368     /*
369     * @dev Burn given amout of tokens from given user
370     */
371     function burnTokens(address addr, uint tokens) internal {
372 
373         UserRecord storage user = user_data[addr];
374 
375         // keep current dividents of user if last tokens will be burned
376         uint dividends_from_tokens = 0;
377         if (total_supply == tokens) {
378             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
379         }
380 
381         // make correction to keep dividends the rest of the users
382         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
383 
384         // sub tokens
385         total_supply = total_supply.sub(tokens);
386         user.tokens = user.tokens.sub(tokens);
387 
388         // make correction to keep dividends of the user
389         // if burned not last tokens
390         if (total_supply > 0) {
391             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
392         }
393         // if burned last tokens
394         else if (dividends_from_tokens != 0) {
395             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
396         }
397     }
398 
399     /*
400      * @dev Rewards the referrer from given amount of funds
401      */
402     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
403         UserRecord storage referrer = user_data[referrer_addr];
404         if (referrer.tokens >= minimal_stake) {
405             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
406             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
407             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
408             return taxed_funds;
409         }
410         else {
411             return funds;
412         }
413     }
414 
415     /*
416     * @dev Calculate tokens from funds
417     *
418     * Given:
419     *   a[1] = price
420     *   d = price_offset
421     *   sum(n) = funds
422     * Here is used arithmetic progression's equation transformed to a quadratic equation:
423     *   a * n^2 + b * n + c = 0
424     * Where:
425     *   a = d
426     *   b = 2 * a[1] - d
427     *   c = -2 * sum(n)
428     * Solve it and first root is what we need - amount of tokens
429     * So:
430     *   tokens = n
431     *   price = a[n+1]
432     *
433     * For details see method below
434     */
435     function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {
436         uint b = price.mul(2).sub(price_offset);
437         uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));
438         uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);
439         uint anp1 = price.add(price_offset.mul(n) / precision_factor);
440         return (n, anp1);
441     }
442 
443     /*
444     * @dev Calculate funds from tokens
445     *
446     * Given:
447     *   a[1] = sell_price
448     *   d = price_offset
449     *   n = tokens
450     * Here is used arithmetic progression's equation (-d because of d must be negative to reduce price):
451     *   a[n] = a[1] - d * (n - 1)
452     *   sum(n) = (a[1] + a[n]) * n / 2
453     * So:
454     *   funds = sum(n)
455     *   price = a[n]
456     *
457     * For details see method above
458     */
459     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
460         uint sell_price = price.sub(price_offset);
461         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
462         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
463         return (sn / precision_factor, an);
464     }
465 
466     // ==== Events ==== //
467 
468     event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);
469     event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);
470     event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);
471     event Withdrawal(address indexed addr, uint funds, uint time);
472     event Donation(address indexed addr, uint funds, uint time);
473     event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);
474 
475     //ERC20
476     event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);
477 
478 }
479 
480 library SafeMath {
481 
482     /**
483     * @dev Multiplies two numbers
484     */
485     function mul(uint a, uint b) internal pure returns (uint) {
486         if (a == 0) {
487             return 0;
488         }
489         uint c = a * b;
490         require(c / a == b, "mul failed");
491         return c;
492     }
493 
494     /**
495     * @dev Subtracts two numbers
496     */
497     function sub(uint a, uint b) internal pure returns (uint) {
498         require(b <= a, "sub failed");
499         return a - b;
500     }
501 
502     /**
503     * @dev Adds two numbers
504     */
505     function add(uint a, uint b) internal pure returns (uint) {
506         uint c = a + b;
507         require(c >= a, "add failed");
508         return c;
509     }
510 
511     /**
512      * @dev Gives square root from number
513      */
514     function sqrt(uint x) internal pure returns (uint y) {
515         uint z = add(x, 1) / 2;
516         y = x;
517         while (z < y) {
518             y = z;
519             z = add(x / z, z) / 2;
520         }
521     }
522 }
523 
524 library SafeMathInt {
525 
526     /**
527     * @dev Subtracts two numbers
528     */
529     function sub(int a, int b) internal pure returns (int) {
530         int c = a - b;
531         require(c <= a, "sub failed");
532         return c;
533     }
534 
535     /**
536     * @dev Adds two numbers
537     */
538     function add(int a, int b) internal pure returns (int) {
539         int c = a + b;
540         require(c >= a, "add failed");
541         return c;
542     }
543 }
544 
545 library Fee {
546 
547     using SafeMath for uint;
548 
549     struct fee {
550         uint num;
551         uint den;
552     }
553 
554     /*
555     * @dev Splits given value to two parts: tax itself and taxed value
556     */
557     function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {
558         if (value == 0) {
559             return (0, 0);
560         }
561         tax = value.mul(f.num) / f.den;
562         taxed_value = value.sub(tax);
563     }
564 
565     /*
566     * @dev Returns only tax part
567     */
568     function get_tax(fee memory f, uint value) internal pure returns (uint tax) {
569         if (value == 0) {
570             return 0;
571         }
572         tax = value.mul(f.num) / f.den;
573     }
574 }
575 
576 library ToAddress {
577 
578     /*
579     * @dev Transforms bytes to address
580     */
581     function toAddr(bytes source) internal pure returns (address addr) {
582         assembly {
583             addr := mload(add(source, 0x14))
584         }
585         return addr;
586     }
587 }