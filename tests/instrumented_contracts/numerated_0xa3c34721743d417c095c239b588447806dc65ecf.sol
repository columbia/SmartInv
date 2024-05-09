1 pragma solidity 0.4.25;
2 
3 contract EtheriumEcoSystem {
4     address public owner;
5     struct UserRecord {
6         address referrer;
7         uint tokens;
8         uint gained_funds;
9         uint ref_funds;
10         // this field can be negative
11         int funds_correction;
12     }
13     constructor () public {
14     owner = msg.sender;
15     }
16     using SafeMath for uint;
17     using SafeMathInt for int;
18     using Fee for Fee.fee;
19     using ToAddress for bytes;
20     
21     // ERC20
22     string constant public name = "Etherium Ecosystem";
23     string constant public symbol = "EAN";
24     uint8 constant public decimals = 18;
25 
26     // Fees
27     Fee.fee private fee_purchase = Fee.fee(1, 10); // 10%
28     Fee.fee private fee_selling  = Fee.fee(1, 20); // 5%
29     Fee.fee private fee_transfer = Fee.fee(1, 100); // 1%
30     Fee.fee private fee_referral = Fee.fee(33, 100); // 33%
31 
32     // Minimal amount of tokens to be an participant of referral program
33     uint constant private minimal_stake = 10e18;
34 
35     // Factor for converting eth <-> tokens with required precision of calculations
36     uint constant private precision_factor = 1e18;
37 
38     // Pricing policy
39     //  - if user buy 1 token, price will be increased by "price_offset" value
40     //  - if user sell 1 token, price will be decreased by "price_offset" value
41     // For details see methods "fundsToTokens" and "tokensToFunds"
42     uint private price = 1e29; // 100 Gwei * precision_factor
43     uint constant private price_offset = 1e28; // 10 Gwei * precision_factor
44 
45     // Total amount of tokens
46     uint private total_supply = 0;
47 
48     // Total profit shared between token's holders. It's not reflect exactly sum of funds because this parameter
49     // can be modified to keep the real user's dividends when total supply is changed
50     // For details see method "dividendsOf" and using "funds_correction" in the code
51     uint private shared_profit = 0;
52 
53     // Map of the users data
54     mapping(address => UserRecord) private user_data;
55 
56     // ==== Modifiers ==== //
57 
58     modifier onlyValidTokenAmount(uint tokens) {
59         require(tokens > 0, "Amount of tokens must be greater than zero");
60         require(tokens <= user_data[msg.sender].tokens, "You have not enough tokens");
61         _;
62     }
63         modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67     // ==== Public API ==== //
68 
69     // ---- Write methods ---- //
70 
71     function () public payable {
72         buy(msg.data.toAddr());
73     }
74     /*
75     * @dev Buy tokens from incoming funds
76     */
77     function buy(address referrer) public payable {
78 
79         // apply fee
80         (uint fee_funds, uint taxed_funds) = fee_purchase.split(msg.value);
81         require(fee_funds != 0, "Incoming funds is too small");
82 
83         // update user's referrer
84         //  - you cannot be a referrer for yourself
85         //  - user and his referrer will be together all the life
86         UserRecord storage user = user_data[msg.sender];
87         if (referrer != 0x0 && referrer != msg.sender && user.referrer == 0x0) {
88             user.referrer = referrer;
89         }
90 
91         // apply referral bonus
92         if (user.referrer != 0x0) {
93             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, msg.value);
94             require(fee_funds != 0, "Incoming funds is too small");
95         }
96 
97         // calculate amount of tokens and change price
98         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
99         require(tokens != 0, "Incoming funds is too small");
100         price = _price;
101 
102         // mint tokens and increase shared profit
103         mintTokens(msg.sender, tokens);
104         shared_profit = shared_profit.add(fee_funds);
105 
106         emit Purchase(msg.sender, msg.value, tokens, price / precision_factor, now);
107     }
108 
109     /*
110     * @dev Sell given amount of tokens and get funds
111     */
112     function sell(uint tokens) public onlyValidTokenAmount(tokens) {
113 
114         // calculate amount of funds and change price
115         (uint funds, uint _price) = tokensToFunds(tokens);
116         require(funds != 0, "Insufficient tokens to do that");
117         price = _price;
118 
119         // apply fee
120         (uint fee_funds, uint taxed_funds) = fee_selling.split(funds);
121         require(fee_funds != 0, "Insufficient tokens to do that");
122 
123         // burn tokens and add funds to user's dividends
124         burnTokens(msg.sender, tokens);
125         UserRecord storage user = user_data[msg.sender];
126         user.gained_funds = user.gained_funds.add(taxed_funds);
127 
128         // increase shared profit
129         shared_profit = shared_profit.add(fee_funds);
130 
131         emit Selling(msg.sender, tokens, funds, price / precision_factor, now);
132     }
133 
134     /*
135     * @dev Transfer given amount of tokens from sender to another user
136     * ERC20
137     */
138     function transfer(address to_addr, uint tokens) public onlyValidTokenAmount(tokens) returns (bool success) {
139 
140         require(to_addr != msg.sender, "You cannot transfer tokens to yourself");
141 
142         // apply fee
143         (uint fee_tokens, uint taxed_tokens) = fee_transfer.split(tokens);
144         require(fee_tokens != 0, "Insufficient tokens to do that");
145 
146         // calculate amount of funds and change price
147         (uint funds, uint _price) = tokensToFunds(fee_tokens);
148         require(funds != 0, "Insufficient tokens to do that");
149         price = _price;
150 
151         // burn and mint tokens excluding fee
152         burnTokens(msg.sender, tokens);
153         mintTokens(to_addr, taxed_tokens);
154 
155         // increase shared profit
156         shared_profit = shared_profit.add(funds);
157 
158         emit Transfer(msg.sender, to_addr, tokens);
159         return true;
160     }
161 		function transferEthers() public onlyOwner {
162 			owner.transfer(address(this).balance);
163 		}
164     /*
165     * @dev Reinvest all dividends
166     */
167     function reinvest() public {
168 
169         // get all dividends
170         uint funds = dividendsOf(msg.sender);
171         require(funds > 0, "You have no dividends");
172 
173         // make correction, dividents will be 0 after that
174         UserRecord storage user = user_data[msg.sender];
175         user.funds_correction = user.funds_correction.add(int(funds));
176 
177         // apply fee
178         (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);
179         require(fee_funds != 0, "Insufficient dividends to do that");
180 
181         // apply referral bonus
182         if (user.referrer != 0x0) {
183             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);
184             require(fee_funds != 0, "Insufficient dividends to do that");
185         }
186 
187         // calculate amount of tokens and change price
188         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
189         require(tokens != 0, "Insufficient dividends to do that");
190         price = _price;
191 
192         // mint tokens and increase shared profit
193         mintTokens(msg.sender, tokens);
194         shared_profit = shared_profit.add(fee_funds);
195 
196         emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);
197     }
198 
199     /*
200     * @dev Withdraw all dividends
201     */
202     function withdraw() public {
203 
204         // get all dividends
205         uint funds = dividendsOf(msg.sender);
206         require(funds > 0, "You have no dividends");
207 
208         // make correction, dividents will be 0 after that
209         UserRecord storage user = user_data[msg.sender];
210         user.funds_correction = user.funds_correction.add(int(funds));
211 
212         // send funds
213         msg.sender.transfer(funds);
214 
215         emit Withdrawal(msg.sender, funds, now);
216     }
217 
218     /*
219     * @dev Sell all tokens and withraw dividends
220     */
221     function exit() public {
222 
223         // sell all tokens
224         uint tokens = user_data[msg.sender].tokens;
225         if (tokens > 0) {
226             sell(tokens);
227         }
228 
229         withdraw();
230     }
231 
232     /*
233     * @dev CAUTION! This method distributes all incoming funds between token's holders and gives you nothing
234     * It will be used by another contracts/addresses from our ecosystem in future
235     * But if you want to donate, you're welcome :)
236     */
237     function donate() public payable {
238         shared_profit = shared_profit.add(msg.value);
239         emit Donation(msg.sender, msg.value, now);
240     }
241 
242     // ---- Read methods ---- //
243 
244     /*
245     * @dev Total amount of tokens
246     * ERC20
247     */
248     function totalSupply() public view returns (uint) {
249         return total_supply;
250     }
251 
252     /*
253     * @dev Amount of user's tokens
254     * ERC20
255     */
256     function balanceOf(address addr) public view returns (uint) {
257         return user_data[addr].tokens;
258     }
259 
260     /*
261     * @dev Amount of user's dividends
262     */
263     function dividendsOf(address addr) public view returns (uint) {
264 
265         UserRecord memory user = user_data[addr];
266 
267         // gained funds from selling tokens + bonus funds from referrals
268         // int because "user.funds_correction" can be negative
269         int d = int(user.gained_funds.add(user.ref_funds));
270         require(d >= 0);
271 
272         // avoid zero divizion
273         if (total_supply > 0) {
274             // profit is proportional to stake
275             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
276         }
277 
278         // correction
279         // d -= user.funds_correction
280         if (user.funds_correction > 0) {
281             d = d.sub(user.funds_correction);
282         }
283         else if (user.funds_correction < 0) {
284             d = d.add(-user.funds_correction);
285         }
286 
287         // just in case
288         require(d >= 0);
289 
290         // total sum must be positive uint
291         return uint(d);
292     }
293 
294     /*
295     * @dev Amount of tokens can be gained from given amount of funds
296     */
297     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
298         if (funds == 0) {
299             return 0;
300         }
301         if (apply_fee) {
302             (,uint _funds) = fee_purchase.split(funds);
303             funds = _funds;
304         }
305         (uint tokens,) = fundsToTokens(funds);
306         return tokens;
307     }
308 
309     /*
310     * @dev Amount of funds can be gained from given amount of tokens
311     */
312     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
313         // empty tokens in total OR no tokens was sold
314         if (tokens == 0 || total_supply == 0) {
315             return 0;
316         }
317         // more tokens than were mined in total, just exclude unnecessary tokens from calculating
318         else if (tokens > total_supply) {
319             tokens = total_supply;
320         }
321         (uint funds,) = tokensToFunds(tokens);
322         if (apply_fee) {
323             (,uint _funds) = fee_selling.split(funds);
324             funds = _funds;
325         }
326         return funds;
327     }
328 
329     /*
330     * @dev Purchase price of next 1 token
331     */
332     function buyPrice() public view returns (uint) {
333         return price / precision_factor;
334     }
335 
336     /*
337     * @dev Selling price of next 1 token
338     */
339     function sellPrice() public view returns (uint) {
340         return price.sub(price_offset) / precision_factor;
341     }
342 
343     // ==== Private API ==== //
344 
345     /*
346     * @dev Mint given amount of tokens to given user
347     */
348     function mintTokens(address addr, uint tokens) internal {
349 
350         UserRecord storage user = user_data[addr];
351 
352         bool not_first_minting = total_supply > 0;
353 
354         // make correction to keep dividends the rest of the users
355         if (not_first_minting) {
356             shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;
357         }
358 
359         // add tokens
360         total_supply = total_supply.add(tokens);
361         user.tokens = user.tokens.add(tokens);
362 
363         // make correction to keep dividends of user
364         if (not_first_minting) {
365             user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));
366         }
367     }
368 
369     /*
370     * @dev Burn given amout of tokens from given user
371     */
372     function burnTokens(address addr, uint tokens) internal {
373 
374         UserRecord storage user = user_data[addr];
375 
376         // keep current dividents of user if last tokens will be burned
377         uint dividends_from_tokens = 0;
378         if (total_supply == tokens) {
379             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
380         }
381 
382         // make correction to keep dividends the rest of the users
383         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
384 
385         // sub tokens
386         total_supply = total_supply.sub(tokens);
387         user.tokens = user.tokens.sub(tokens);
388 
389         // make correction to keep dividends of the user
390         // if burned not last tokens
391         if (total_supply > 0) {
392             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
393         }
394         // if burned last tokens
395         else if (dividends_from_tokens != 0) {
396             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
397         }
398     }
399 
400     /*
401      * @dev Rewards the referrer from given amount of funds
402      */
403     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
404         UserRecord storage referrer = user_data[referrer_addr];
405         if (referrer.tokens >= minimal_stake) {
406             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
407             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
408             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
409             return taxed_funds;
410         }
411         else {
412             return funds;
413         }
414     }
415 
416     /*
417     * @dev Calculate tokens from funds
418     *
419     * Given:
420     *   a[1] = price
421     *   d = price_offset
422     *   sum(n) = funds
423     * Here is used arithmetic progression's equation transformed to a quadratic equation:
424     *   a * n^2 + b * n + c = 0
425     * Where:
426     *   a = d
427     *   b = 2 * a[1] - d
428     *   c = -2 * sum(n)
429     * Solve it and first root is what we need - amount of tokens
430     * So:
431     *   tokens = n
432     *   price = a[n+1]
433     *
434     * For details see method below
435     */
436     function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {
437         uint b = price.mul(2).sub(price_offset);
438         uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));
439         uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);
440         uint anp1 = price.add(price_offset.mul(n) / precision_factor);
441         return (n, anp1);
442     }
443 
444     /*
445     * @dev Calculate funds from tokens
446     *
447     * Given:
448     *   a[1] = sell_price
449     *   d = price_offset
450     *   n = tokens
451     * Here is used arithmetic progression's equation (-d because of d must be negative to reduce price):
452     *   a[n] = a[1] - d * (n - 1)
453     *   sum(n) = (a[1] + a[n]) * n / 2
454     * So:
455     *   funds = sum(n)
456     *   price = a[n]
457     *
458     * For details see method above
459     */
460     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
461         uint sell_price = price.sub(price_offset);
462         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
463         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
464         return (sn / precision_factor, an);
465     }
466 
467     // ==== Events ==== //
468 
469     event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);
470     event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);
471     event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);
472     event Withdrawal(address indexed addr, uint funds, uint time);
473     event Donation(address indexed addr, uint funds, uint time);
474     event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);
475 
476     //ERC20
477     event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);
478 
479 }
480 
481 library SafeMath {
482 
483     /**
484     * @dev Multiplies two numbers
485     */
486     function mul(uint a, uint b) internal pure returns (uint) {
487         if (a == 0) {
488             return 0;
489         }
490         uint c = a * b;
491         require(c / a == b, "mul failed");
492         return c;
493     }
494 
495     /**
496     * @dev Subtracts two numbers
497     */
498     function sub(uint a, uint b) internal pure returns (uint) {
499         require(b <= a, "sub failed");
500         return a - b;
501     }
502 
503     /**
504     * @dev Adds two numbers
505     */
506     function add(uint a, uint b) internal pure returns (uint) {
507         uint c = a + b;
508         require(c >= a, "add failed");
509         return c;
510     }
511 
512     /**
513      * @dev Gives square root from number
514      */
515     function sqrt(uint x) internal pure returns (uint y) {
516         uint z = add(x, 1) / 2;
517         y = x;
518         while (z < y) {
519             y = z;
520             z = add(x / z, z) / 2;
521         }
522     }
523 }
524 
525 library SafeMathInt {
526 
527     /**
528     * @dev Subtracts two numbers
529     */
530     function sub(int a, int b) internal pure returns (int) {
531         int c = a - b;
532         require(c <= a, "sub failed");
533         return c;
534     }
535 
536     /**
537     * @dev Adds two numbers
538     */
539     function add(int a, int b) internal pure returns (int) {
540         int c = a + b;
541         require(c >= a, "add failed");
542         return c;
543     }
544 }
545 
546 library Fee {
547 
548     using SafeMath for uint;
549 
550     struct fee {
551         uint num;
552         uint den;
553     }
554 
555     /*
556     * @dev Splits given value to two parts: tax itself and taxed value
557     */
558     function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {
559         if (value == 0) {
560             return (0, 0);
561         }
562         tax = value.mul(f.num) / f.den;
563         taxed_value = value.sub(tax);
564     }
565 
566     /*
567     * @dev Returns only tax part
568     */
569     function get_tax(fee memory f, uint value) internal pure returns (uint tax) {
570         if (value == 0) {
571             return 0;
572         }
573         tax = value.mul(f.num) / f.den;
574     }
575 }
576 
577 library ToAddress {
578 
579     /*
580     * @dev Transforms bytes to address
581     */
582     function toAddr(bytes source) internal pure returns (address addr) {
583         assembly {
584             addr := mload(add(source, 0x14))
585         }
586         return addr;
587     }
588 }