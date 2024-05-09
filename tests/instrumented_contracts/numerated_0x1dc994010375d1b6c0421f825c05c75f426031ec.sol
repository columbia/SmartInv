1 pragma solidity ^0.4.21;
2 
3 contract Math
4 {
5     /*
6     standard uint256 functions
7      */
8 
9     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
10         assert((z = x + y) >= x);
11     }
12 
13     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
14         assert((z = x - y) <= x);
15     }
16 
17     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
18         assert((z = x * y) >= x);
19     }
20 
21     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
22         z = x / y;
23     }
24 
25     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
26         return x <= y ? x : y;
27     }
28     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
29         return x >= y ? x : y;
30     }
31 }
32 
33 contract Grass is Math
34 {
35   uint256 public availableTokens;
36   uint256 currentTokenPriceInDollar;
37 
38   uint256 public lastUpdateEtherPrice;
39   uint256 public etherPriceInDollarIn;
40   uint256 public etherPriceInDollarOut;
41 
42   function getCurrentTokenPrice() public constant returns (uint256)
43   {
44       uint256 today = getToday();
45       return (tokenPriceHistory[today] == 0)?currentTokenPriceInDollar:tokenPriceHistory[today];
46   }
47 
48   mapping(uint256 => uint256) public tokenPriceHistory;
49   struct ExtraTokensInfo
50   {
51     uint256 timestamp;
52     uint256 extraTokens;
53     string  proofLink;
54     uint256 videoFileHash;
55   }
56 
57   ExtraTokensInfo[] public extraTokens;
58 
59   struct TokenInfo
60   {
61     uint256 amount;
62     bool isReturnedInPool;
63   }
64 
65   event Transfer(address indexed _from, address indexed _to, uint256 _value);
66 
67   // address => day => amount
68   mapping(address => mapping(uint256 => TokenInfo)) timeTable;
69   mapping(address => mapping(uint256 => uint256)) bonuses;
70   mapping (address => uint256) public balances;
71   uint256 public totalSupply;
72 
73   string public name;
74   uint8 public decimals;
75   string public symbol;
76 
77   bool isCanBuy = true;
78 
79   modifier canBuy()
80   {
81       assert(isCanBuy);
82       _;
83   }
84 
85   function changeState(bool bNewState) public onlyAdmin
86   {
87       isCanBuy = bNewState;
88   }
89 
90   address owner;
91   mapping(address => bool) admins;
92   modifier onlyAdmin()
93   {
94       assert(admins[msg.sender] == true || msg.sender == owner);
95       _;
96   }
97 
98   modifier onlyOwner()
99   {
100       assert(msg.sender == owner);
101       _;
102   }
103   function addAdmin(address addr) public onlyOwner
104   {
105       admins[addr] = true;
106   }
107   function removeAdmin(address addr) public onlyOwner
108   {
109       admins[addr] = false;
110   }
111 
112   function Grass() public
113   {
114     // startTime = block.timestamp;
115     owner = msg.sender;
116     admins[msg.sender] = true;
117     totalSupply = 0;
118     name = 'GRASS Token';
119     decimals = 18;
120     symbol = 'GRASS';
121     availableTokens = 800 * 10**18;
122     currentTokenPriceInDollar = 35 * 100; // 35.00$ (price may change)
123 
124     etherPriceInDollarIn = 388 * 100;
125     etherPriceInDollarOut = 450 * 100;
126     lastUpdateEtherPrice = block.timestamp;
127   }
128 
129   function increaseMaxAvailableTokens(uint256 amount, string link, uint256 videoFileHash) onlyAdmin public
130   {
131     extraTokens.push(ExtraTokensInfo(block.timestamp, amount, link, videoFileHash));
132     availableTokens = add(availableTokens, amount);
133   }
134 
135   function balanceOf(address _owner) public view returns (uint256 balance) {
136       return balances[_owner];
137   }
138 
139   function updateEtherPrice (uint256 newPriceIn, uint256 newPriceOut) onlyAdmin public
140   {
141     etherPriceInDollarIn = newPriceIn;
142     etherPriceInDollarOut = newPriceOut;
143     lastUpdateEtherPrice = block.timestamp;
144   }
145 
146   modifier isEtherPriceUpdated()
147   {
148       require(now - lastUpdateEtherPrice < 24 hours);
149       _;
150   }
151 
152   function updateTokenPrice (uint256 newPrice) onlyAdmin public
153   {
154     currentTokenPriceInDollar = newPrice;
155   }
156 
157   function getToday() public constant returns (uint256)
158   {
159     return block.timestamp / 24 hours;
160   }
161 
162   function() isEtherPriceUpdated canBuy isInitialized payable public
163   {
164     buyInternal(msg.sender);
165   }
166 
167   function buyFor(address addr) isEtherPriceUpdated canBuy onlyAdmin isInitialized payable public
168   {
169     buyInternal(addr);
170   }
171 
172   function buy() isEtherPriceUpdated canBuy payable isInitialized public
173   {
174     buyInternal(msg.sender);
175   }
176 
177   function getPartnerBalance (address addr) public view returns(uint256)
178   {
179     return partners[addr];
180   }
181 
182   function partnerWithdraw () isInitialized public
183   {
184     assert (partners[msg.sender] > 0);
185     uint256 ethToWidthdraw = partners[msg.sender];
186     partners[msg.sender] = 0;
187     msg.sender.transfer(ethToWidthdraw);
188   }
189 
190   mapping(address => uint256) partners;
191   // refferal => partner
192   mapping(address => address) referrals;
193 
194   function takeEther(address dest, uint256 amount) onlyAdmin public
195   {
196       dest.transfer(amount);
197   }
198 
199   function addEther() payable onlyAdmin public
200   {
201   }
202 
203   function buyWithPromo(address partner) isEtherPriceUpdated canBuy isInitialized payable public
204   {
205       if (referrals[msg.sender] == 0 && partner != msg.sender)
206       {
207         referrals[msg.sender] = partner;
208       }
209 
210       buyInternal(msg.sender);
211   }
212 
213   function buyInternal(address addr) internal
214   {
215     if (referrals[addr] != 0)
216     {
217         partners[referrals[addr]] += msg.value / 100; // 1% to partner
218     }
219 
220     assert (isContract(addr) == false);
221 
222     // проверка lastUpdateEtherPrice
223     uint256 today = getToday();
224     if (tokenPriceHistory[today] == 0) tokenPriceHistory[today] = currentTokenPriceInDollar;
225 
226     // timeTable
227     uint256 amount = msg.value * etherPriceInDollarIn / tokenPriceHistory[today] ;
228     if (amount > availableTokens)
229     {
230        addr.transfer((amount - availableTokens) * tokenPriceHistory[today] / etherPriceInDollarIn);
231        amount = availableTokens;
232     }
233 
234     assert(amount > 0);
235 
236     availableTokens = sub(availableTokens, amount);
237 
238     // is new day ?
239     if (timeTable[addr][today].amount == 0)
240     {
241       timeTable[addr][today] = TokenInfo(amount, false);
242     }
243     else
244     {
245       timeTable[addr][today].amount += amount;
246     }
247 
248     //                  < 30.03.2018
249     if (block.timestamp < 1522357200 && bonuses[addr][today] == 0)
250     {
251       bonuses[addr][today] = 1;
252     }
253 
254     balances[addr] = add(balances[addr], amount);
255     totalSupply = add(totalSupply, amount);
256     emit Transfer(0, addr, amount);
257   }
258 
259   function calculateProfit (uint256 day) public constant returns(int256)
260   {
261     uint256 today = getToday();
262     assert(today >= day);
263     uint256 daysLeft = today - day;
264     int256 extraProfit = 0;
265 
266     // is referral ?
267     if (referrals[msg.sender] != 0) extraProfit++;
268     // participant until March 30
269     if (bonuses[msg.sender][day] > 0) extraProfit++;
270 
271     if (daysLeft <= 7) return -10;
272     if (daysLeft <= 14) return -5;
273     if (daysLeft <= 21) return 1 + extraProfit;
274     if (daysLeft <= 28) return 3 + extraProfit;
275     if (daysLeft <= 60) return 5 + extraProfit;
276     if (daysLeft <= 90) return 12 + extraProfit;
277     return 18 + extraProfit;
278   }
279 
280   function getTokensPerDay(uint256 _day) public view returns (uint256)
281   {
282       return timeTable[msg.sender][_day].amount;
283   }
284 
285   // returns amount, ether
286   function getProfitForDay(uint256 day, uint256 amount) isEtherPriceUpdated public constant returns(uint256, uint256)
287   {
288     assert (day <= getToday());
289 
290     uint256 tokenPrice = tokenPriceHistory[day];
291     if (timeTable[msg.sender][day].amount < amount) amount = timeTable[msg.sender][day].amount;
292 
293     assert (amount > 0);
294 
295     return (amount, amount * tokenPrice * uint256(100 + calculateProfit(day)) / 100 / etherPriceInDollarOut);
296   }
297 
298   function returnTokensInPool (address[] addr, uint256[] _days) public
299   {
300     assert (addr.length == _days.length);
301 
302     TokenInfo storage info;
303     for(uint256 i = 0; i < addr.length;i++)
304     {
305       assert(_days[i] + 92 < getToday() && info.amount > 0);
306       info = timeTable[addr[i]][_days[i]];
307       info.isReturnedInPool = true;
308       availableTokens = add(availableTokens, info.amount);
309     }
310   }
311 
312   function getInfo(address addr, uint256 start, uint256 end) public constant returns (uint256[30] _days, uint256[30] _amounts, int256[30] _profits, uint256[30] _etherAmounts)
313   {
314       if (addr == 0) addr = msg.sender;
315 
316       uint256 j = 0;
317       for(uint256 iDay = start; iDay < end; iDay++)
318       {
319         if (timeTable[addr][iDay].amount > 0)
320         {
321           _days[j] = iDay;
322           _profits[j] = calculateProfit(iDay);
323           _amounts[j] = timeTable[addr][iDay].amount;
324           (_amounts[j], _etherAmounts[j]) = getProfitForDay(iDay, _amounts[j]);
325           j++;
326           if (j == 30) break;
327         }
328       }
329   }
330 
331   function returnTokensForDay(uint256 day, uint256 userTokensAmount) isInitialized public
332   {
333     uint256 tokensAmount;
334     uint256 etherAmount;
335     (tokensAmount, etherAmount) = getProfitForDay(day, userTokensAmount);
336 
337     require(day > 0);
338     require(balances[msg.sender] >= tokensAmount);
339 
340     balances[msg.sender] = sub(balances[msg.sender], tokensAmount);
341     totalSupply = sub(totalSupply, tokensAmount);
342     timeTable[msg.sender][day].amount = sub(timeTable[msg.sender][day].amount, tokensAmount);
343 
344     if (!timeTable[msg.sender][day].isReturnedInPool)
345     {
346       availableTokens = add(availableTokens, tokensAmount);
347     }
348 
349     msg.sender.transfer(etherAmount);
350     emit Transfer(msg.sender, 0, tokensAmount);
351   }
352 
353   function isContract(address addr) internal returns (bool)
354   {
355     uint256 size;
356     assembly { size := extcodesize(addr) }
357     return size > 0;
358   }
359 
360   bool public initialized = false;
361 
362   modifier isInitialized()
363   {
364       assert(initialized);
365       _;
366   }
367 
368   uint8 balancesTransferred = 0;
369   // restore tokens from previous contract 
370   function restoreBalances(address[60] addr, uint256[60] _days, uint256[60] _amounts) external onlyAdmin
371   {
372     // call when contract is not initialized
373     assert(initialized == false);
374 
375     if (totalSupply == 0)
376     {
377         balances[0x9d4f1d5c6da16f28405cb8b063500606e41b8279] = 151428571428571428571;
378         balances[0x35497d9c2beaa5debc48da2208d6b03222f5e753] = 75714285714285714285;
379         balances[0xb43f0c8ad004f7fdd50bc9b1c2ca06cad653f56d] = 60571428571428571428;
380         balances[0x006f2e159f3e3f2363a64b952122d27df1b307cd] = 49453400000000000000;
381         balances[0xb8c180dd09e611ac253ab321650b8b5393d6a00c] = 31972285714285714284;
382         balances[0xa209e963d089f03c26fff226a411028700fb6009] = 29281428571428571427;
383         balances[0xec185474a0c593f741cca00995aa22f078ec02e2] = 25000000000000000514;
384         balances[0x1c1a6b49bccb8b2c12ddf874fc69e14c4371343b] = 14655428571428571428;
385         balances[0x38aeeb7e8390632e45f44c01a7b982a9e03a1b10] = 11671422857142857142;
386         balances[0xfeff4cd1fc9273848c0cbabacc688c5e5707ddd5] = 9999999999999999428;
387         balances[0x1c0c4d7961c96576c21b63b0b892b88ec5b86742] = 8227208857142857142;
388         balances[0xdae0aca4b9b38199408ffab32562bf7b3b0495fe] = 5999999999999999957;
389         balances[0x2c46fb6e390d90f5742877728d81a5e354c2be0c] = 5990527428571428570;
390         balances[0x3c9e6d9a10956f29ec20d797c26ba720e4f0f327] = 5013159428571428571;
391         balances[0xb9621f1a9402fa3119fd6b011a23dd007e05b7af] = 5000108571428571427;
392         balances[0xae2856a1ea65093852b8828efcaabb16ac987d6b] = 4174942857142857142;
393         balances[0xb9507bfc17d6b70177d778ead1cd581c2572b6c1] = 3022857142857142857;
394         balances[0x2e983528f19633cf25eee2aa93c78542d660a20f] = 3000000000000000131;
395         balances[0xf4b733ff2f2eab631e2860bb60dc596074b9912d] = 3000000000000000131;
396         balances[0x431d78c14b570aafb4940c8df524b5a7f5373f46] = 2999999999999999851;
397         balances[0xda43b71d5ba11b61f315867ff8fc29db7d34ed31] = 3000000000000000131;
398         balances[0x7d9c012ea8e111cec46e89e01b7cd63687696862] = 2771866285714285714;
399         balances[0x1c1d8b576c7354dccd20d017b1cde68a942353b6] = 2490045714285714285;
400         balances[0x024c07e4e9631763d8db8294bfc8f4fd82113ef5] = 2109977142857142857;
401         balances[0x64f482e94e9781c42ada16742780709613ea7fe0] = 2031377142857142857;
402         balances[0x0c371ce4b7dcc1da7d68b004d5dea49667af7320] = 1999999999999999885;
403         balances[0x709b1599cfe4b06ff4fce1cc4fe8a72ac55c2f10] = 1999999999999999885;
404         balances[0xe217aee24b3181540d17f872d3d791b41224bc31] = 1999999999999999885;
405         balances[0x0d85570eef6baa41a8f918e48973ea54a9385ee7] = 2000000000000000120;
406         balances[0xcf1a033ae5b48def61c8ceb21d41c293a9e5d3c0] = 2000000000000000057;
407         balances[0xbc202f5082e403090d7dd483545f680a37efb7e5] = 1999999999999999885;
408         balances[0xdf18736dcafaa40b8880b481c5bfab5196089535] = 1999999999999999885;
409         balances[0x83da64ffdfe4f6c3a4cf9891d840096ee984b456] = 1271428571428571428;
410         balances[0x3babede4f2275762f1c6b4a8185a0056ceee4f5f] = 1051428571428571428;
411         balances[0x2f4f98d2489bec1c98515e0f75596e0b135a6023] = 1000480000000000000;
412         balances[0xe89156e5694f94b86fabfefab173cf6dd1f2ee00] = 1000000000000000125;
413         balances[0x890430d3dbc99846b72c77de7ec10e91ad956619] = 1000000000000000125;
414         balances[0x4ee63ad9a151d7c8360561bc00cbe9d7f81c4677] = 1000000000000000125;
415         balances[0xc5398714592750850693b56e74c8a5618ae14d38] = 1000000000000000125;
416         balances[0xab4a42f7a9ada127858c2e054778e000ea0b8325] = 1000000000000000125;
417         balances[0xfcc9b4658b296fe9d667c5a264f4da209dec13db] = 1000000000000000125;
418         balances[0x36a93d56e175947be686f0a65bb328d400c1a8b9] = 1000000000000000125;
419         balances[0x362a979afe6e5b6acb57d075be9e6f462acacc85] = 1000000000000000125;
420         balances[0xe50f079b8f9d67002c787cf9dbd456fc11bd5779] = 999999999999999942;
421         balances[0x68afff1424c27246647969dee18e7150124b2b28] = 999999999999999942;
422         balances[0x44aba76f01b6498a485dd8f8ee1615d422b8cbf8] = 999999999999999942;
423         balances[0x1d51752cd228c3d71714f16401ccdaecfe6d52c3] = 999999999999999942;
424         balances[0x5eb72c2bbd74d3e9cb61f5d43002104403a16b43] = 999999999999999942;
425         balances[0xa0a0d04bb08051780e5a6cba3080b623fc8404a6] = 999999999999999942;
426         balances[0xec49706126ae73db0ca54664d8b0feeb67c3c777] = 999999999999999942;
427         balances[0xa95413cd1bc9bdf336e9c2c074fb9ffa91bb89a6] = 999999999999999942;
428         balances[0x884a7cc58132ca80897d98bfae87ce72e0eaf461] = 999999999999999942;
429         balances[0xb6593630850c56aee328be42038fc6d347b37440] = 999999999999999942;
430         balances[0x324ddd8b98b23cb2b6ffaeb84b9bb99ec3de9db6] = 999999999999999942;
431         balances[0x1013809376254288325a7b49d60c395da80eeef5] = 1000000000000000028;
432         balances[0x3f6753388a491e958b2de57634060e28c7ff2c1e] = 1000000000000000062;
433         balances[0xe7800dc7166f11decd415c3a74ec9d0cfa3ceb06] = 431405714285714285;
434         totalSupply = 557335064857142857325;
435         availableTokens = availableTokens - totalSupply;
436         
437         uint256 today = getToday();
438         for(uint256 j=17614;j <= today;j++)
439         {
440             tokenPriceHistory[j] = currentTokenPriceInDollar;
441         }
442     }
443     else
444     {
445         uint8 start = balancesTransferred;
446         for(uint8 i=start; i < start+30; i++)
447         {
448             assert(addr[i] != 0 && _days[i] !=0 && _amounts[i] !=0);
449             timeTable[addr[i]][_days[i]] = TokenInfo(_amounts[i], false);
450             emit Transfer(0, addr[i], _amounts[i]);
451             if (_days[i] < 17620 && bonuses[addr[i]][_days[i]] == 0)
452             {
453                 bonuses[addr[i]][_days[i]] = 1;
454             }
455         }
456         balancesTransferred += 30;
457 
458         if (balancesTransferred == 60) initialized = true;
459     }
460   }
461 }