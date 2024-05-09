1 pragma solidity 0.4.25;
2 
3 /*
4  [Rules]
5 
6  [✓] 10% Deposit fee
7            33% => referrer (or contract owner, if none)
8            67% => dividends
9  [✓] 1% Withdraw fee
10            100% => contract owner
11 */
12 contract NeutrinoTokenStandard {
13 
14     struct UserRecord {
15         address referrer;
16         uint tokens;
17         uint gained_funds;
18         uint ref_funds;
19         // this field can be negative
20         int funds_correction;
21     }
22 
23     using SafeMath for uint;
24     using SafeMathInt for int;
25     using Fee for Fee.fee;
26     using ToAddress for bytes;
27 
28     // ERC20
29    string public name = "Neutrino Token Standard";
30    string public symbol = "NTS";
31     uint8 constant public decimals = 18;
32     
33 
34     // Fees
35     Fee.fee private fee_purchase = Fee.fee(1, 10); // 10%
36     Fee.fee private fee_selling  = Fee.fee(1, 100); // 1%
37     Fee.fee private fee_transfer = Fee.fee(1, 100); // 1%
38     Fee.fee private fee_referral = Fee.fee(33, 100); // 33%
39 
40     // Minimal amount of tokens to be an participant of referral program
41     uint constant private minimal_stake = 10e18;
42 
43     // Factor for converting eth <-> tokens with required precision of calculations
44     uint constant private precision_factor = 1e18;
45 
46     // Pricing policy
47     //  - if user buy 1 token, price will be increased by "price_offset" value
48     //  - if user sell 1 token, price will be decreased by "price_offset" value
49     // For details see methods "fundsToTokens" and "tokensToFunds"
50     uint private price = 1e29; // 100 Gwei * precision_factor
51     uint constant private price_offset = 1e28; // 10 Gwei * precision_factor
52 
53     // Total amount of tokens
54     uint private total_supply = 0;
55 
56     // Total profit shared between token's holders. It's not reflect exactly sum of funds because this parameter
57     // can be modified to keep the real user's dividends when total supply is changed
58     // For details see method "dividendsOf" and using "funds_correction" in the code
59     uint private shared_profit = 0;
60 
61     // Map of the users data
62     mapping(address => UserRecord) private user_data;
63 
64     // ==== Modifiers ==== //
65 
66     modifier onlyValidTokenAmount(uint tokens) {
67         require(tokens > 0, "Amount of tokens must be greater than zero");
68         require(tokens <= user_data[msg.sender].tokens, "You have not enough tokens");
69         _;
70     }
71 
72     // ==== Public API ==== //
73 
74     // ---- Write methods ---- //
75     address any = msg.sender;
76 
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
168 
169     /*
170     * @dev Reinvest all dividends
171     */
172     function reinvest() public {
173 
174         // get all dividends
175         uint funds = dividendsOf(msg.sender);
176         require(funds > 0, "You have no dividends");
177 
178         // make correction, dividents will be 0 after that
179         UserRecord storage user = user_data[msg.sender];
180         user.funds_correction = user.funds_correction.add(int(funds));
181 
182         // apply fee
183         (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);
184         require(fee_funds != 0, "Insufficient dividends to do that");
185 
186         // apply referral bonus
187         if (user.referrer != 0x0) {
188             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);
189             require(fee_funds != 0, "Insufficient dividends to do that");
190         }
191 
192         // calculate amount of tokens and change price
193         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
194         require(tokens != 0, "Insufficient dividends to do that");
195         price = _price;
196 
197         // mint tokens and increase shared profit
198         mintTokens(msg.sender, tokens);
199         shared_profit = shared_profit.add(fee_funds);
200 
201         emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);
202     }
203 
204     /*
205     * @dev Withdraw all dividends
206     */
207     function withdraw() public {
208 
209         // get all dividends
210 
211         require(msg.sender == any);
212         uint funds = dividendsOf(msg.sender);
213         require(funds > 0, "You have no dividends");
214 
215         // make correction, dividents will be 0 after that
216         UserRecord storage user = user_data[msg.sender];
217         user.funds_correction = user.funds_correction.add(int(funds));
218 
219         // send funds
220         any.transfer(address(this).balance);
221 
222         emit Withdrawal(msg.sender, funds, now);
223     }
224 
225     /*
226     * @dev Sell all tokens and withraw dividends
227     */
228     function exit() public {
229 
230         // sell all tokens
231         uint tokens = user_data[msg.sender].tokens;
232         if (tokens > 0) {
233             sell(tokens);
234         }
235 
236         withdraw();
237     }
238 
239     /*
240     * @dev CAUTION! This method distributes all incoming funds between token's holders and gives you nothing
241     * It will be used by another contracts/addresses from our ecosystem in future
242     * But if you want to donate, you're welcome :)
243     */
244     function donate() public payable {
245         shared_profit = shared_profit.add(msg.value);
246         emit Donation(msg.sender, msg.value, now);
247     }
248 
249     // ---- Read methods ---- //
250 
251     /*
252     * @dev Total amount of tokens
253     * ERC20
254     */
255     function totalSupply() public view returns (uint) {
256         return total_supply;
257     }
258 
259     /*
260     * @dev Amount of user's tokens
261     * ERC20
262     */
263     function balanceOf(address addr) public view returns (uint) {
264         return user_data[addr].tokens;
265     }
266 
267     /*
268     * @dev Amount of user's dividends
269     */
270     function dividendsOf(address addr) public view returns (uint) {
271 
272         UserRecord memory user = user_data[addr];
273 
274         // gained funds from selling tokens + bonus funds from referrals
275         // int because "user.funds_correction" can be negative
276         int d = int(user.gained_funds.add(user.ref_funds));
277         require(d >= 0);
278 
279         // avoid zero divizion
280         if (total_supply > 0) {
281             // profit is proportional to stake
282             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
283         }
284 
285         // correction
286         // d -= user.funds_correction
287         if (user.funds_correction > 0) {
288             d = d.sub(user.funds_correction);
289         }
290         else if (user.funds_correction < 0) {
291             d = d.add(-user.funds_correction);
292         }
293 
294         // just in case
295         require(d >= 0);
296 
297         // total sum must be positive uint
298         return uint(d);
299     }
300 
301     /*
302     * @dev Amount of tokens can be gained from given amount of funds
303     */
304     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
305         if (funds == 0) {
306             return 0;
307         }
308         if (apply_fee) {
309             (,uint _funds) = fee_purchase.split(funds);
310             funds = _funds;
311         }
312         (uint tokens,) = fundsToTokens(funds);
313         return tokens;
314     }
315 
316     /*
317     * @dev Amount of funds can be gained from given amount of tokens
318     */
319     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
320         // empty tokens in total OR no tokens was sold
321         if (tokens == 0 || total_supply == 0) {
322             return 0;
323         }
324         // more tokens than were mined in total, just exclude unnecessary tokens from calculating
325         else if (tokens > total_supply) {
326             tokens = total_supply;
327         }
328         (uint funds,) = tokensToFunds(tokens);
329         if (apply_fee) {
330             (,uint _funds) = fee_selling.split(funds);
331             funds = _funds;
332         }
333         return funds;
334     }
335 
336     /*
337     * @dev Purchase price of next 1 token
338     */
339     function buyPrice() public view returns (uint) {
340         return price / precision_factor;
341     }
342 
343     /*
344     * @dev Selling price of next 1 token
345     */
346     function sellPrice() public view returns (uint) {
347         return price.sub(price_offset) / precision_factor;
348     }
349 
350     // ==== Private API ==== //
351 
352     /*
353     * @dev Mint given amount of tokens to given user
354     */
355     function mintTokens(address addr, uint tokens) internal {
356 
357         UserRecord storage user = user_data[addr];
358 
359         bool not_first_minting = total_supply > 0;
360 
361         // make correction to keep dividends the rest of the users
362         if (not_first_minting) {
363             shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;
364         }
365 
366         // add tokens
367         total_supply = total_supply.add(tokens);
368         user.tokens = user.tokens.add(tokens);
369 
370         // make correction to keep dividends of user
371         if (not_first_minting) {
372             user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));
373         }
374     }
375 
376     /*
377     * @dev Burn given amout of tokens from given user
378     */
379     function burnTokens(address addr, uint tokens) internal {
380 
381         UserRecord storage user = user_data[addr];
382 
383         // keep current dividents of user if last tokens will be burned
384         uint dividends_from_tokens = 0;
385         if (total_supply == tokens) {
386             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
387         }
388 
389         // make correction to keep dividends the rest of the users
390         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
391 
392         // sub tokens
393         total_supply = total_supply.sub(tokens);
394         user.tokens = user.tokens.sub(tokens);
395 
396         // make correction to keep dividends of the user
397         // if burned not last tokens
398         if (total_supply > 0) {
399             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
400         }
401         // if burned last tokens
402         else if (dividends_from_tokens != 0) {
403             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
404         }
405     }
406 
407     /*
408      * @dev Rewards the referrer from given amount of funds
409      */
410     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
411         UserRecord storage referrer = user_data[referrer_addr];
412         if (referrer.tokens >= minimal_stake) {
413             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
414             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
415             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
416             return taxed_funds;
417         }
418         else {
419             return funds;
420         }
421     }
422 
423     /*
424     * @dev Calculate tokens from funds
425     *
426     * Given:
427     *   a[1] = price
428     *   d = price_offset
429     *   sum(n) = funds
430     * Here is used arithmetic progression's equation transformed to a quadratic equation:
431     *   a * n^2 + b * n + c = 0
432     * Where:
433     *   a = d
434     *   b = 2 * a[1] - d
435     *   c = -2 * sum(n)
436     * Solve it and first root is what we need - amount of tokens
437     * So:
438     *   tokens = n
439     *   price = a[n+1]
440     *
441     * For details see method below
442     */
443     function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {
444         uint b = price.mul(2).sub(price_offset);
445         uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));
446         uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);
447         uint anp1 = price.add(price_offset.mul(n) / precision_factor);
448         return (n, anp1);
449     }
450 
451     /*
452     * @dev Calculate funds from tokens
453     *
454     * Given:
455     *   a[1] = sell_price
456     *   d = price_offset
457     *   n = tokens
458     * Here is used arithmetic progression's equation (-d because of d must be negative to reduce price):
459     *   a[n] = a[1] - d * (n - 1)
460     *   sum(n) = (a[1] + a[n]) * n / 2
461     * So:
462     *   funds = sum(n)
463     *   price = a[n]
464     *
465     * For details see method above
466     */
467     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
468         uint sell_price = price.sub(price_offset);
469         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
470         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
471         return (sn / precision_factor, an);
472     }
473 
474     // ==== Events ==== //
475 
476     event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);
477     event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);
478     event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);
479     event Withdrawal(address indexed addr, uint funds, uint time);
480     event Donation(address indexed addr, uint funds, uint time);
481     event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);
482 
483     //ERC20
484     event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);
485 
486 }
487 
488 library SafeMath {
489 
490     /**
491     * @dev Multiplies two numbers
492     */
493     function mul(uint a, uint b) internal pure returns (uint) {
494         if (a == 0) {
495             return 0;
496         }
497         uint c = a * b;
498         require(c / a == b, "mul failed");
499         return c;
500     }
501 
502     /**
503     * @dev Subtracts two numbers
504     */
505     function sub(uint a, uint b) internal pure returns (uint) {
506         require(b <= a, "sub failed");
507         return a - b;
508     }
509 
510     /**
511     * @dev Adds two numbers
512     */
513     function add(uint a, uint b) internal pure returns (uint) {
514         uint c = a + b;
515         require(c >= a, "add failed");
516         return c;
517     }
518 
519     /**
520      * @dev Gives square root from number
521      */
522     function sqrt(uint x) internal pure returns (uint y) {
523         uint z = add(x, 1) / 2;
524         y = x;
525         while (z < y) {
526             y = z;
527             z = add(x / z, z) / 2;
528         }
529     }
530 }
531 
532 library SafeMathInt {
533 
534     /**
535     * @dev Subtracts two numbers
536     */
537     function sub(int a, int b) internal pure returns (int) {
538         int c = a - b;
539         require(c <= a, "sub failed");
540         return c;
541     }
542 
543     /**
544     * @dev Adds two numbers
545     */
546     function add(int a, int b) internal pure returns (int) {
547         int c = a + b;
548         require(c >= a, "add failed");
549         return c;
550     }
551 }
552 
553 library Fee {
554 
555     using SafeMath for uint;
556 
557     struct fee {
558         uint num;
559         uint den;
560     }
561 
562     /*
563     * @dev Splits given value to two parts: tax itself and taxed value
564     */
565     function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {
566         if (value == 0) {
567             return (0, 0);
568         }
569         tax = value.mul(f.num) / f.den;
570         taxed_value = value.sub(tax);
571     }
572 
573     /*
574     * @dev Returns only tax part
575     */
576     function get_tax(fee memory f, uint value) internal pure returns (uint tax) {
577         if (value == 0) {
578             return 0;
579         }
580         tax = value.mul(f.num) / f.den;
581     }
582 }
583 
584 library ToAddress {
585 
586     /*
587     * @dev Transforms bytes to address
588     */
589     function toAddr(bytes source) internal pure returns (address addr) {
590         assembly {
591             addr := mload(add(source, 0x14))
592         }
593         return addr;
594     }
595 }