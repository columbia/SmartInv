1 pragma solidity 0.4.25;
2 
3 /*
4 * Pantheon China 第一份智能合約提供穩定的收入。 
5 * 智能合約可確保您的資金免遭盜竊和黑客攻擊
6 * 不要投入超過你可以輸的
7 * 我們正在等待一場大型比賽
8 */
9 
10 contract PantheonEcoSystemChina {
11 
12     struct UserRecord {
13         address referrer;
14         uint tokens;
15         uint gained_funds;
16         uint ref_funds;
17         // 這個領域可能是負面的
18         int funds_correction;
19     }
20 
21     using SafeMath for uint;
22     using SafeMathInt for int;
23     using Fee for Fee.fee;
24     using ToAddress for bytes;
25 
26     // ERC20
27     string constant public name = "PantheonEcoSystem China";
28     string constant public symbol = "PEC";
29     uint8 constant public decimals = 18;
30 
31     // Fees
32     Fee.fee private fee_purchase = Fee.fee(1, 10); // 10%
33     Fee.fee private fee_selling  = Fee.fee(1, 20); // 5%
34     Fee.fee private fee_transfer = Fee.fee(1, 100); // 1%
35     Fee.fee private fee_referral = Fee.fee(33, 100); // 33%
36 
37     // 最少量的令牌將成為推薦計劃的參與者
38     uint constant private minimal_stake = 10e18;
39 
40     // 轉換eth < - >令牌的因素，具有所需的計算精度
41     uint constant private precision_factor = 1e18;
42 
43     // 定價政策
44     //  - 如果用戶購買1個令牌，價格將增加“price_offset”值
45     //  - 如果用戶賣出1個令牌，價格將降低“price_offset”值
46     // 有關詳細信息，請參閱方法“fundsToTokens”和“tokensToFunds”
47     uint private price = 1e29; // 100 Gwei * precision_factor
48     uint constant private price_offset = 1e28; // 10 Gwei * precision_factor
49 
50     // 令牌總數
51     uint private total_supply = 0;
52 
53     // 令牌持有者之間共享的總利潤。由於此參數，它並不能準確反映資金總額
54     // 可以修改以在總供應量發生變化時保持真實用戶的股息
55     // 有關詳細信息，請參閱方法“dividendsOf”並在代碼中使用“funds_correction”
56     uint private shared_profit = 0;
57 
58     // 用戶數據的映射
59     mapping(address => UserRecord) private user_data;
60 
61     // ==== 修改 ==== //
62 
63     modifier onlyValidTokenAmount(uint tokens) {
64         require(tokens > 0, "令牌數量必須大於零");
65         require(tokens <= user_data[msg.sender].tokens, "你沒有足夠的令牌");
66         _;
67     }
68 
69     // ==== 上市 API ==== //
70 
71     // ---- 寫作方法 ---- //
72 
73     function () public payable {
74         buy(msg.data.toAddr());
75     }
76 
77     /*
78     *  從收到的資金購買代幣
79     */
80     function buy(address referrer) public payable {
81 
82         // 報名費
83         (uint fee_funds, uint taxed_funds) = fee_purchase.split(msg.value);
84         require(fee_funds != 0, "Incoming funds is too small");
85 
86         // 更新用戶的推薦人
87         //  - 你不能成為自己的推薦人
88         //  - 用戶和他的推薦人將在一起生活
89         UserRecord storage user = user_data[msg.sender];
90         if (referrer != 0x0 && referrer != msg.sender && user.referrer == 0x0) {
91             user.referrer = referrer;
92         }
93 
94         // 申請推薦獎金
95         if (user.referrer != 0x0) {
96             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, msg.value);
97             require(fee_funds != 0, "收入資金太小");
98         }
99 
100         // 計算代幣金額和變更價格
101         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
102         require(tokens != 0, "收入資金太小");
103         price = _price;
104 
105         // 薄荷代幣，增加共享利潤
106         mintTokens(msg.sender, tokens);
107         shared_profit = shared_profit.add(fee_funds);
108 
109         emit Purchase(msg.sender, msg.value, tokens, price / precision_factor, now);
110     }
111 
112     /*
113     *  出售給定數量的代幣並獲得資金
114     */
115     function sell(uint tokens) public onlyValidTokenAmount(tokens) {
116 
117         // 計算資金數額和變更價格
118         (uint funds, uint _price) = tokensToFunds(tokens);
119         require(funds != 0, "沒有足夠的令牌來做這件事");
120         price = _price;
121 
122         // 申請費
123         (uint fee_funds, uint taxed_funds) = fee_selling.split(funds);
124         require(fee_funds != 0, "沒有足夠的令牌來做這件事");
125 
126         // 刻錄令牌並為用戶的股息增加資金
127         burnTokens(msg.sender, tokens);
128         UserRecord storage user = user_data[msg.sender];
129         user.gained_funds = user.gained_funds.add(taxed_funds);
130 
131         // 增加共享利潤
132         shared_profit = shared_profit.add(fee_funds);
133 
134         emit Selling(msg.sender, tokens, funds, price / precision_factor, now);
135     }
136 
137     /*
138     *  將給定數量的令牌從發件人轉移到另一個用戶
139     * ERC20
140     */
141     function transfer(address to_addr, uint tokens) public onlyValidTokenAmount(tokens) returns (bool success) {
142 
143         require(to_addr != msg.sender, "You cannot transfer tokens to yourself");
144 
145         // 申請費
146         (uint fee_tokens, uint taxed_tokens) = fee_transfer.split(tokens);
147         require(fee_tokens != 0, "Insufficient tokens to do that");
148 
149         // 計算資金數額和變更價格
150         (uint funds, uint _price) = tokensToFunds(fee_tokens);
151         require(funds != 0, "Insufficient tokens to do that");
152         price = _price;
153 
154         // 燃燒和薄荷代幣，不含費用
155         burnTokens(msg.sender, tokens);
156         mintTokens(to_addr, taxed_tokens);
157 
158         // 增加共享利潤
159         shared_profit = shared_profit.add(funds);
160 
161         emit Transfer(msg.sender, to_addr, tokens);
162         return true;
163     }
164 
165     /*
166     *  再投資所有股息
167     */
168     function reinvest() public {
169 
170         // 獲得所有股息
171         uint funds = dividendsOf(msg.sender);
172         require(funds > 0, "You have no dividends");
173 
174         // 做出更正，之後的事件將為0
175         UserRecord storage user = user_data[msg.sender];
176         user.funds_correction = user.funds_correction.add(int(funds));
177 
178         // 申請費
179         (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);
180         require(fee_funds != 0, "Insufficient dividends to do that");
181 
182         // 申請推薦獎金
183         if (user.referrer != 0x0) {
184             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);
185             require(fee_funds != 0, "Insufficient dividends to do that");
186         }
187 
188         // 計算代幣金額和變更價格
189         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
190         require(tokens != 0, "Insufficient dividends to do that");
191         price = _price;
192 
193         // 薄荷代幣，增加共享利潤
194         mintTokens(msg.sender, tokens);
195         shared_profit = shared_profit.add(fee_funds);
196 
197         emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);
198     }
199 
200     /*
201     *  撤回所有股息
202     */
203     function withdraw() public {
204 
205         // 獲得所有股息
206         uint funds = dividendsOf(msg.sender);
207         require(funds > 0, "You have no dividends");
208 
209         // 做出更正，之後的事件將為0
210         UserRecord storage user = user_data[msg.sender];
211         user.funds_correction = user.funds_correction.add(int(funds));
212 
213         // 發送資金
214         msg.sender.transfer(funds);
215 
216         emit Withdrawal(msg.sender, funds, now);
217     }
218 
219     /*
220     *  出售所有代幣和分紅
221     */
222     function exit() public {
223 
224         // 賣掉所有代幣
225         uint tokens = user_data[msg.sender].tokens;
226         if (tokens > 0) {
227             sell(tokens);
228         }
229 
230         withdraw();
231     }
232 
233     /*
234     * 警告！此方法在令牌持有者之間分配所有傳入資金，並且不提供任何內容
235     * 它將在未來由我們的生態系統中的其他合同/地址使用
236     * 但如果你想捐款，歡迎你
237     */
238     function donate() public payable {
239         shared_profit = shared_profit.add(msg.value);
240         emit Donation(msg.sender, msg.value, now);
241     }
242 
243     
244     function totalSupply() public view returns (uint) {
245         return total_supply;
246     }
247 
248    
249     function balanceOf(address addr) public view returns (uint) {
250         return user_data[addr].tokens;
251     }
252 
253    
254     function dividendsOf(address addr) public view returns (uint) {
255 
256         UserRecord memory user = user_data[addr];
257 
258        
259         int d = int(user.gained_funds.add(user.ref_funds));
260         require(d >= 0);
261 
262         if (total_supply > 0) {
263             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
264         }
265 
266         if (user.funds_correction > 0) {
267             d = d.sub(user.funds_correction);
268         }
269         else if (user.funds_correction < 0) {
270             d = d.add(-user.funds_correction);
271         }
272 
273         require(d >= 0);
274 
275         return uint(d);
276     }
277 
278    
279     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
280         if (funds == 0) {
281             return 0;
282         }
283         if (apply_fee) {
284             (,uint _funds) = fee_purchase.split(funds);
285             funds = _funds;
286         }
287         (uint tokens,) = fundsToTokens(funds);
288         return tokens;
289     }
290 
291     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
292         // 總共有空令牌或沒有銷售代幣
293         if (tokens == 0 || total_supply == 0) {
294             return 0;
295         }
296         // 比總共開採更多的令牌，只是從計算中排除不必要的令牌
297         else if (tokens > total_supply) {
298             tokens = total_supply;
299         }
300         (uint funds,) = tokensToFunds(tokens);
301         if (apply_fee) {
302             (,uint _funds) = fee_selling.split(funds);
303             funds = _funds;
304         }
305         return funds;
306     }
307 
308     /*
309     *  下一個令牌的購買價格
310     */
311     function buyPrice() public view returns (uint) {
312         return price / precision_factor;
313     }
314 
315     /*
316     *  售價下一個令牌
317     */
318     function sellPrice() public view returns (uint) {
319         return price.sub(price_offset) / precision_factor;
320     }
321 
322     // ==== 私人的 API ==== //
323 
324     function mintTokens(address addr, uint tokens) internal {
325 
326         UserRecord storage user = user_data[addr];
327 
328         bool not_first_minting = total_supply > 0;
329 
330         if (not_first_minting) {
331             shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;
332         }
333 
334         total_supply = total_supply.add(tokens);
335         user.tokens = user.tokens.add(tokens);
336 
337         if (not_first_minting) {
338             user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));
339         }
340     }
341 
342     function burnTokens(address addr, uint tokens) internal {
343 
344         UserRecord storage user = user_data[addr];
345 
346         uint dividends_from_tokens = 0;
347         if (total_supply == tokens) {
348             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
349         }
350 
351         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
352 
353         total_supply = total_supply.sub(tokens);
354         user.tokens = user.tokens.sub(tokens);
355 
356         if (total_supply > 0) {
357             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
358         }
359         else if (dividends_from_tokens != 0) {
360             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
361         }
362     }
363 
364     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
365         UserRecord storage referrer = user_data[referrer_addr];
366         if (referrer.tokens >= minimal_stake) {
367             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
368             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
369             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
370             return taxed_funds;
371         }
372         else {
373             return funds;
374         }
375     }
376 
377     function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {
378         uint b = price.mul(2).sub(price_offset);
379         uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));
380         uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);
381         uint anp1 = price.add(price_offset.mul(n) / precision_factor);
382         return (n, anp1);
383     }
384 
385     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
386         uint sell_price = price.sub(price_offset);
387         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
388         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
389         return (sn / precision_factor, an);
390     }
391 
392     // ==== 活動 ==== //
393 
394     event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);
395     event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);
396     event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);
397     event Withdrawal(address indexed addr, uint funds, uint time);
398     event Donation(address indexed addr, uint funds, uint time);
399     event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);
400 
401     //ERC20
402     event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);
403 
404 }
405 
406 library SafeMath {
407 
408     function mul(uint a, uint b) internal pure returns (uint) {
409         if (a == 0) {
410             return 0;
411         }
412         uint c = a * b;
413         require(c / a == b, "mul failed");
414         return c;
415     }
416 
417     function sub(uint a, uint b) internal pure returns (uint) {
418         require(b <= a, "sub failed");
419         return a - b;
420     }
421 
422     function add(uint a, uint b) internal pure returns (uint) {
423         uint c = a + b;
424         require(c >= a, "add failed");
425         return c;
426     }
427 
428     function sqrt(uint x) internal pure returns (uint y) {
429         uint z = add(x, 1) / 2;
430         y = x;
431         while (z < y) {
432             y = z;
433             z = add(x / z, z) / 2;
434         }
435     }
436 }
437 
438 library SafeMathInt {
439 
440     function sub(int a, int b) internal pure returns (int) {
441         int c = a - b;
442         require(c <= a, "sub failed");
443         return c;
444     }
445 
446     function add(int a, int b) internal pure returns (int) {
447         int c = a + b;
448         require(c >= a, "add failed");
449         return c;
450     }
451 }
452 
453 library Fee {
454 
455     using SafeMath for uint;
456 
457     struct fee {
458         uint num;
459         uint den;
460     }
461 
462     function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {
463         if (value == 0) {
464             return (0, 0);
465         }
466         tax = value.mul(f.num) / f.den;
467         taxed_value = value.sub(tax);
468     }
469 
470     function get_tax(fee memory f, uint value) internal pure returns (uint tax) {
471         if (value == 0) {
472             return 0;
473         }
474         tax = value.mul(f.num) / f.den;
475     }
476 }
477 
478 library ToAddress {
479 
480     function toAddr(bytes source) internal pure returns (address addr) {
481         assembly {
482             addr := mload(add(source, 0x14))
483         }
484         return addr;
485     }
486 }