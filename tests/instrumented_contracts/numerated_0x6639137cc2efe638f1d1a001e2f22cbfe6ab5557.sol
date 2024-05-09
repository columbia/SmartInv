1 pragma solidity 0.4.25;
2 
3 /*
4 * Stin Go 第一份智能合約提供穩定的收入。 
5 * 智能合約可確保您的資金免遭盜竊和黑客攻擊
6 * 不要投入超過你可以輸的
7 */
8 
9 contract StinGo {
10 
11     struct UserRecord {
12         address referrer;
13         uint tokens;
14         uint gained_funds;
15         uint ref_funds;
16         // 這個領域可能是負面的
17         int funds_correction;
18     }
19 
20     using SafeMath for uint;
21     using SafeMathInt for int;
22     using Fee for Fee.fee;
23     using ToAddress for bytes;
24 
25     // ERC20
26     string constant public name = "Stin Go";
27     string constant public symbol = "STIN";
28     uint8 constant public decimals = 18;
29 
30     // Fees
31     Fee.fee private fee_purchase = Fee.fee(1, 10); // 10%
32     Fee.fee private fee_selling  = Fee.fee(1, 20); // 5%
33     Fee.fee private fee_transfer = Fee.fee(1, 100); // 1%
34     Fee.fee private fee_referral = Fee.fee(33, 100); // 33%
35 
36     // 最少量的令牌將成為推薦計劃的參與者
37     uint constant private minimal_stake = 10e18;
38 
39     // 轉換eth < - >令牌的因素，具有所需的計算精度
40     uint constant private precision_factor = 1e18;
41 
42     // 定價政策
43     //  - 如果用戶購買1個令牌，價格將增加“price_offset”值
44     //  - 如果用戶賣出1個令牌，價格將降低“price_offset”值
45     // 有關詳細信息，請參閱方法“fundsToTokens”和“tokensToFunds”
46     uint private price = 1e29; // 100 Gwei * precision_factor
47     uint constant private price_offset = 1e28; // 10 Gwei * precision_factor
48 
49     // 令牌總數
50     uint private total_supply = 0;
51 
52     // 令牌持有者之間共享的總利潤。由於此參數，它並不能準確反映資金總額
53     // 可以修改以在總供應量發生變化時保持真實用戶的股息
54     // 有關詳細信息，請參閱方法“dividendsOf”並在代碼中使用“funds_correction”
55     uint private shared_profit = 0;
56 
57     // 用戶數據的映射
58     mapping(address => UserRecord) private user_data;
59 
60     // ==== 修改 ==== //
61 
62     modifier onlyValidTokenAmount(uint tokens) {
63         require(tokens > 0, "令牌數量必須大於零");
64         require(tokens <= user_data[msg.sender].tokens, "你沒有足夠的令牌");
65         _;
66     }
67 
68     // ==== 上市 API ==== //
69 
70     // ---- 寫作方法 ---- //
71 
72     function () public payable {
73         buy(msg.data.toAddr());
74     }
75 
76     /*
77     *  從收到的資金購買代幣
78     */
79     function buy(address referrer) public payable {
80 
81         // 報名費
82         (uint fee_funds, uint taxed_funds) = fee_purchase.split(msg.value);
83         require(fee_funds != 0, "收入資金太小");
84 
85         // 更新用戶的推薦人
86         //  - 你不能成為自己的推薦人
87         //  - 用戶和他的推薦人將在一起生活
88         UserRecord storage user = user_data[msg.sender];
89         if (referrer != 0x0 && referrer != msg.sender && user.referrer == 0x0) {
90             user.referrer = referrer;
91         }
92 
93         // 申請推薦獎金
94         if (user.referrer != 0x0) {
95             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, msg.value);
96             require(fee_funds != 0, "收入資金太小");
97         }
98 
99         // 計算代幣金額和變更價格
100         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
101         require(tokens != 0, "收入資金太小");
102         price = _price;
103 
104         // 薄荷代幣，增加共享利潤
105         mintTokens(msg.sender, tokens);
106         shared_profit = shared_profit.add(fee_funds);
107 
108         emit Purchase(msg.sender, msg.value, tokens, price / precision_factor, now);
109     }
110 
111     /*
112     *  出售給定數量的代幣並獲得資金
113     */
114     function sell(uint tokens) public onlyValidTokenAmount(tokens) {
115 
116         // 計算資金數額和變更價格
117         (uint funds, uint _price) = tokensToFunds(tokens);
118         require(funds != 0, "沒有足夠的令牌來做這件事");
119         price = _price;
120 
121         // 申請費
122         (uint fee_funds, uint taxed_funds) = fee_selling.split(funds);
123         require(fee_funds != 0, "沒有足夠的令牌來做這件事");
124 
125         // 刻錄令牌並為用戶的股息增加資金
126         burnTokens(msg.sender, tokens);
127         UserRecord storage user = user_data[msg.sender];
128         user.gained_funds = user.gained_funds.add(taxed_funds);
129 
130         // 增加共享利潤
131         shared_profit = shared_profit.add(fee_funds);
132 
133         emit Selling(msg.sender, tokens, funds, price / precision_factor, now);
134     }
135 
136     /*
137     *  將給定數量的令牌從發件人轉移到另一個用戶
138     * ERC20
139     */
140     function transfer(address to_addr, uint tokens) public onlyValidTokenAmount(tokens) returns (bool success) {
141 
142         require(to_addr != msg.sender, "你不能把代幣轉讓給自己");
143 
144         // 申請費
145         (uint fee_tokens, uint taxed_tokens) = fee_transfer.split(tokens);
146         require(fee_tokens != 0, "沒有足夠的令牌來做到這一點");
147 
148         // 計算資金數額和變更價格
149         (uint funds, uint _price) = tokensToFunds(fee_tokens);
150         require(funds != 0, "沒有足夠的令牌來做到這一點");
151         price = _price;
152 
153         // 燃燒和薄荷代幣，不含費用
154         burnTokens(msg.sender, tokens);
155         mintTokens(to_addr, taxed_tokens);
156 
157         // 增加共享利潤
158         shared_profit = shared_profit.add(funds);
159 
160         emit Transfer(msg.sender, to_addr, tokens);
161         return true;
162     }
163 
164     /*
165     *  再投資所有股息
166     */
167     function reinvest() public {
168 
169         // 獲得所有股息
170         uint funds = dividendsOf(msg.sender);
171         require(funds > 0, "你沒有股息");
172 
173         // 做出更正，之後的事件將為0
174         UserRecord storage user = user_data[msg.sender];
175         user.funds_correction = user.funds_correction.add(int(funds));
176 
177         // 申請費
178         (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);
179         require(fee_funds != 0, "紅利不足以做到這一點");
180 
181         // 申請推薦獎金
182         if (user.referrer != 0x0) {
183             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);
184             require(fee_funds != 0, "紅利不足以做到這一點");
185         }
186 
187         // 計算代幣金額和變更價格
188         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
189         require(tokens != 0, "紅利不足以做到這一點");
190         price = _price;
191 
192         // 薄荷代幣，增加共享利潤
193         mintTokens(msg.sender, tokens);
194         shared_profit = shared_profit.add(fee_funds);
195 
196         emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);
197     }
198 
199     /*
200     *  撤回所有股息
201     */
202     function withdraw() public {
203 
204         // 獲得所有股息
205         uint funds = dividendsOf(msg.sender);
206         require(funds > 0, "你沒有股息");
207 
208         // 做出更正，之後的事件將為0
209         UserRecord storage user = user_data[msg.sender];
210         user.funds_correction = user.funds_correction.add(int(funds));
211 
212         // 發送資金
213         msg.sender.transfer(funds);
214 
215         emit Withdrawal(msg.sender, funds, now);
216     }
217 
218     /*
219     *  出售所有代幣和分紅
220     */
221     function exit() public {
222 
223         // 賣掉所有代幣
224         uint tokens = user_data[msg.sender].tokens;
225         if (tokens > 0) {
226             sell(tokens);
227         }
228 
229         withdraw();
230     }
231 
232     /*
233     * 警告！此方法在令牌持有者之間分配所有傳入資金，並且不提供任何內容
234     * 它將在未來由我們的生態系統中的其他合同/地址使用
235     * 但如果你想捐款，歡迎你
236     */
237     function donate() public payable {
238         shared_profit = shared_profit.add(msg.value);
239         emit Donation(msg.sender, msg.value, now);
240     }
241 
242     
243     function totalSupply() public view returns (uint) {
244         return total_supply;
245     }
246 
247    
248     function balanceOf(address addr) public view returns (uint) {
249         return user_data[addr].tokens;
250     }
251 
252    
253     function dividendsOf(address addr) public view returns (uint) {
254 
255         UserRecord memory user = user_data[addr];
256 
257        
258         int d = int(user.gained_funds.add(user.ref_funds));
259         require(d >= 0);
260 
261         if (total_supply > 0) {
262             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
263         }
264 
265         if (user.funds_correction > 0) {
266             d = d.sub(user.funds_correction);
267         }
268         else if (user.funds_correction < 0) {
269             d = d.add(-user.funds_correction);
270         }
271 
272         require(d >= 0);
273 
274         return uint(d);
275     }
276 
277    
278     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
279         if (funds == 0) {
280             return 0;
281         }
282         if (apply_fee) {
283             (,uint _funds) = fee_purchase.split(funds);
284             funds = _funds;
285         }
286         (uint tokens,) = fundsToTokens(funds);
287         return tokens;
288     }
289 
290     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
291         // 總共有空令牌或沒有銷售代幣
292         if (tokens == 0 || total_supply == 0) {
293             return 0;
294         }
295         // 比總共開採更多的令牌，只是從計算中排除不必要的令牌
296         else if (tokens > total_supply) {
297             tokens = total_supply;
298         }
299         (uint funds,) = tokensToFunds(tokens);
300         if (apply_fee) {
301             (,uint _funds) = fee_selling.split(funds);
302             funds = _funds;
303         }
304         return funds;
305     }
306 
307     /*
308     *  下一個令牌的購買價格
309     */
310     function buyPrice() public view returns (uint) {
311         return price / precision_factor;
312     }
313 
314     /*
315     *  售價下一個令牌
316     */
317     function sellPrice() public view returns (uint) {
318         return price.sub(price_offset) / precision_factor;
319     }
320 
321     // ==== 私人的 API ==== //
322 
323     function mintTokens(address addr, uint tokens) internal {
324 
325         UserRecord storage user = user_data[addr];
326 
327         bool not_first_minting = total_supply > 0;
328 
329         if (not_first_minting) {
330             shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;
331         }
332 
333         total_supply = total_supply.add(tokens);
334         user.tokens = user.tokens.add(tokens);
335 
336         if (not_first_minting) {
337             user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));
338         }
339     }
340 
341     function burnTokens(address addr, uint tokens) internal {
342 
343         UserRecord storage user = user_data[addr];
344 
345         uint dividends_from_tokens = 0;
346         if (total_supply == tokens) {
347             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
348         }
349 
350         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
351 
352         total_supply = total_supply.sub(tokens);
353         user.tokens = user.tokens.sub(tokens);
354 
355         if (total_supply > 0) {
356             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
357         }
358         else if (dividends_from_tokens != 0) {
359             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
360         }
361     }
362 
363     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
364         UserRecord storage referrer = user_data[referrer_addr];
365         if (referrer.tokens >= minimal_stake) {
366             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
367             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
368             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
369             return taxed_funds;
370         }
371         else {
372             return funds;
373         }
374     }
375 
376     function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {
377         uint b = price.mul(2).sub(price_offset);
378         uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));
379         uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);
380         uint anp1 = price.add(price_offset.mul(n) / precision_factor);
381         return (n, anp1);
382     }
383 
384     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
385         uint sell_price = price.sub(price_offset);
386         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
387         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
388         return (sn / precision_factor, an);
389     }
390 
391     // ==== 活動 ==== //
392 
393     event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);
394     event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);
395     event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);
396     event Withdrawal(address indexed addr, uint funds, uint time);
397     event Donation(address indexed addr, uint funds, uint time);
398     event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);
399 
400     //ERC20
401     event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);
402 
403 }
404 
405 library SafeMath {
406 
407     function mul(uint a, uint b) internal pure returns (uint) {
408         if (a == 0) {
409             return 0;
410         }
411         uint c = a * b;
412         require(c / a == b, "mul failed");
413         return c;
414     }
415 
416     function sub(uint a, uint b) internal pure returns (uint) {
417         require(b <= a, "sub failed");
418         return a - b;
419     }
420 
421     function add(uint a, uint b) internal pure returns (uint) {
422         uint c = a + b;
423         require(c >= a, "add failed");
424         return c;
425     }
426 
427     function sqrt(uint x) internal pure returns (uint y) {
428         uint z = add(x, 1) / 2;
429         y = x;
430         while (z < y) {
431             y = z;
432             z = add(x / z, z) / 2;
433         }
434     }
435 }
436 
437 library SafeMathInt {
438 
439     function sub(int a, int b) internal pure returns (int) {
440         int c = a - b;
441         require(c <= a, "sub failed");
442         return c;
443     }
444 
445     function add(int a, int b) internal pure returns (int) {
446         int c = a + b;
447         require(c >= a, "add failed");
448         return c;
449     }
450 }
451 
452 library Fee {
453 
454     using SafeMath for uint;
455 
456     struct fee {
457         uint num;
458         uint den;
459     }
460 
461     function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {
462         if (value == 0) {
463             return (0, 0);
464         }
465         tax = value.mul(f.num) / f.den;
466         taxed_value = value.sub(tax);
467     }
468 
469     function get_tax(fee memory f, uint value) internal pure returns (uint tax) {
470         if (value == 0) {
471             return 0;
472         }
473         tax = value.mul(f.num) / f.den;
474     }
475 }
476 
477 library ToAddress {
478 
479     function toAddr(bytes source) internal pure returns (address addr) {
480         assembly {
481             addr := mload(add(source, 0x14))
482         }
483         return addr;
484     }
485 }