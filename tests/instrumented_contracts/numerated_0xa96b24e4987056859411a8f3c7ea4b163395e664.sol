1 pragma solidity ^0.4.18;
2 
3 /*--------------------------------------------------
4 
5           __  __                                 
6     ___  / /_/ /_  ___  ________  __  ______ ___ 
7    / _ \/ __/ __ \/ _ \/ ___/ _ \/ / / / __ `__ \
8   /  __/ /_/ / / /  __/ /  /  __/ /_/ / / / / / /
9   \___/\__/_/ /_/\___/_/   \___/\__,_/_/ /_/ /_/                       
10        ____ ___  ____  ____/ /__  _________ 
11       / __ `__ \/ __ \/ __  / _ \/ ___/ __ \
12      / / / / / / /_/ / /_/ /  __/ /  / / / /
13     /_/ /_/ /_/\____/\__,_/\___/_/  /_/ /_/ 
14 
15               Ethereum Modern 1.17
16              www.ethereummodern.com
17         
18         *******************************
19 
20 
21         Ethereum Modern
22         ---------------
23         ETHMD
24         Limited 15M Coins
25         18 Decimal
26 
27 
28         ***********
29         * ROADMAP *
30         ***********
31 
32        -Stage 1 Pre Sale
33         Price: 10,000 ETHMD (Bonus x5) = 1 ETH 
34         Bonus transaction = 0.001 ETHMD
35 
36        -Stage 2 ICO
37         Price: 10,000 ETHMD = 1 ETH
38         Bonus transaction = 0.001 ETHMD
39 
40        -Stage 3 Special Sale
41         Price: 10,000 ETHMD/X = 1 ETH (X++ ~ payable() > 0.1 ETH)
42         Bonus transaction = 0.001 ETHMD
43 
44        -Stage 4 Done
45         Price: Closed
46         Bonus transaction = 0.01 ETHMD
47         
48 
49         **************************
50         * ADMIN POSSIBLE ACTIONS *
51         **************************
52 
53         1. Start the Ethereum Modern project
54         2. Change the Ethereum Modern Stage
55 
56         "immutable unstoppable"
57         (The Admin cannot modify coin limit, users' balances, lock accounts, etc.)
58 
59         ******************************************************
60 
61         License:
62         Public Domain CC0 License.
63         https://creativecommons.org/publicdomain/zero/1.0/
64 
65 
66 --------------------------------------------------*/
67 
68 
69 library SafeMath {
70     function add(uint a, uint b) internal pure returns (uint c) {
71         c = a + b;
72         require(c >= a);
73     }
74     function sub(uint a, uint b) internal pure returns (uint c) {
75         require(b <= a);
76         c = a - b;
77     }
78     function mul(uint a, uint b) internal pure returns (uint c) {
79         c = a * b;
80         require(a == 0 || c / a == b);
81     }
82     function div(uint a, uint b) internal pure returns (uint c) {
83         require(b > 0);
84         c = a / b;
85     }
86 }
87 
88     // Interface ERC20
89 contract ERC20Interface {
90     function totalSupply() public constant returns (uint256);
91     function balanceOf(address tokenOwner) public constant returns (uint balance);
92     function transfer(address to, uint tokens) public returns (bool success);
93     event Transfer(address indexed from, address indexed to, uint tokens);
94 }
95 
96 contract EthereumModern is ERC20Interface {
97     using SafeMath for uint;
98 
99     // Stage 1 Pre Sale Offer
100     // Stage 2 ICO
101     // Stage 3 Special Stage
102     uint private CurrentStage = 1;
103     uint256 private stage3divisor = 2;
104 
105     address admin;
106     address vault_developers = 0x2E3067e55FE0F78Cc7C04cdA3A4E200619DaA03F;
107     address vault_designers = 0xa47100b57e3B5c331FA9b4979945335be7d1E5ba;
108     address vault_marketing = 0x308445b1C9349a3E502141FBe77506B7a7e51a95;
109     address vault_community = 0x0C5e9AF88D03528F964760b13fe915C661972246;
110     address vault_manualSale = 0x4FBC7650e9b6973E9949bBd0e3Aa48D72Fb484d4;
111 
112     // Max Coins 15M (10M Distribution) Unstoppable
113     uint256 private MaxCoinsLimit15M = 15000000 * 1000000000000000000;
114     
115     // 2M Reserved for the Staff
116     // 2M Reserved for community
117     uint256 private amountPreDonateETHMD = 4000000 * 1000000000000000000;
118 
119     // >1M Manual Sale Promotional
120     uint256 private amountManualSaleETHMD = 1125800 * 1000000000000000000;
121     
122     uint256 private amountPreSaleETHMD = 0;
123     uint256 private amountICOETHMD = 0;
124     uint256 private amountSpecialETHMD = 0;
125     uint256 private amountTransETHMD = 0;
126     
127     uint256 private amountPreSaleETH = 0;
128     uint256 private amountICOETH = 0;
129     uint256 private amountSpecialETH = 0;
130     
131 
132     string public symbol;
133     string public name;
134     string public webSite;
135     
136     uint8 public decimals;
137     uint private _totalSupply;
138 
139     mapping(address => uint) balances;
140     mapping(address => uint) rewards;
141 
142     function EthereumModern() public {
143         
144         symbol = "ETHMD";
145         name = "Ethereum Modern";
146         webSite = "www.ethereummodern.com";
147         decimals = 18;
148 
149         // Max Coins 15M (2M Staff / 2M Community / 1M Promotional / 10M Distribution / 1M < RewardTransactionSystem)
150         _totalSupply = MaxCoinsLimit15M;
151         
152         admin = msg.sender;
153         
154         // 2M Reserved for the Staff
155         balances[vault_developers] += amountPreDonateETHMD / 4;
156         Transfer(address(0), vault_developers, amountPreDonateETHMD / 4);
157         balances[vault_designers] += amountPreDonateETHMD / 4;
158         Transfer(address(0), vault_designers, amountPreDonateETHMD / 4);
159         
160         // 2M Reserved for Community
161         balances[vault_community] += amountPreDonateETHMD / 2;
162         Transfer(address(0), vault_community, amountPreDonateETHMD / 2);
163         
164         // 1M Manual Sale Promotional
165         balances[vault_manualSale] += amountManualSaleETHMD;
166         Transfer(address(0), vault_manualSale, amountManualSaleETHMD);
167         
168     }
169       
170     function currentStatus() public constant returns (string)
171     {
172         if(CurrentStage==1) { 
173             return "Stage 1/4. Pre Sale.";
174         }else if (CurrentStage == 2){
175             return "Stage 2/4. ICO Sale.";
176         }else if (CurrentStage == 3){
177             return "Stage 3/4. Special Sale.";
178         }else{
179             return "All working correctly.";
180         }
181     }
182 
183     
184     function currentAmountReceivedDeposit1Ether18Decimals() public constant returns (uint256)
185     {
186         uint256 amountETHMD = 0;
187         uint256 amountETH = 1000000000000000000 * 10000;
188         if(CurrentStage==1) { 
189             amountETHMD = amountETH.mul(5) ;
190         }else if (CurrentStage == 2){
191             amountETHMD = amountETH ;
192         }else if (CurrentStage == 3){
193             amountETHMD = amountETH.div(stage3divisor);
194         }
195         return amountETHMD;
196     }
197 
198     function currentCoinsCreated18Decimals() public constant returns (uint256)
199     {
200         return amountPreSaleETHMD + 
201                amountICOETHMD + 
202                amountSpecialETHMD + 
203                amountPreDonateETHMD + 
204                amountManualSaleETHMD + 
205                amountTransETHMD;
206     }
207 
208     function currentCoinsCreatedInteger() public constant returns (uint256)
209     {
210         return (amountPreSaleETHMD + 
211                 amountICOETHMD + 
212                 amountSpecialETHMD + 
213                 amountPreDonateETHMD + 
214                 amountManualSaleETHMD + 
215                 amountTransETHMD).div(1000000000000000000);
216     }
217 
218     function CoinsLimitUnalterableInteger() public constant returns (uint256)
219     {
220         return MaxCoinsLimit15M.div(1000000000000000000);
221     }
222 
223     function currentCoinsCreatedPercentage() public constant returns (uint256)
224     {
225         return (amountPreSaleETHMD + 
226                 amountICOETHMD +
227                 amountSpecialETHMD + 
228                 amountPreDonateETHMD + 
229                 amountManualSaleETHMD + 
230                 amountTransETHMD).mul(1000).div(MaxCoinsLimit15M).mul(100).div(1000) ;
231     }
232 
233     function totalSupply() public constant returns (uint256) {
234         return _totalSupply  - balances[address(0)];
235     }
236 
237     function balanceOf(address tokenOwner) public constant returns (uint balance) {
238         return balances[tokenOwner];
239     }
240 
241     function transfer(address to, uint tokens) public returns (bool success) {
242 
243         /*********************/
244         /* Transaction Check */
245         /*********************/
246 
247         require(to != 0x0);
248         require(tokens > 0);
249         require(balances[msg.sender] >= tokens);
250         require(balances[to] + tokens > balances[to]);
251 
252         /***************/
253         /* Transaction */
254         /***************/
255 
256         balances[msg.sender] = balances[msg.sender].sub(tokens);
257         balances[to] = balances[to].add(tokens);
258 
259         Transfer(msg.sender, to, tokens);
260 
261         /*********************************************/
262         /* Ethereum Modern Reward Transaction System */
263         /*********************************************/
264 
265             uint256 rewardvalue = 1000000000000000;
266             if (CurrentStage==4) { rewardvalue = 10000000000000000; }
267             if ( amountPreSaleETHMD + 
268                  amountICOETHMD + 
269                  amountSpecialETHMD + 
270                  amountPreDonateETHMD + 
271                  amountManualSaleETHMD + 
272                  rewardvalue + 
273                  amountTransETHMD + 1000000000000000000
274                  <= MaxCoinsLimit15M ) {
275                 if (tokens > 100 * 1000000000000000000) {
276                     // 1M Reward Max
277                     if (amountTransETHMD < 1000000 * 1000000000000000000 ) {
278                         if (rewards[msg.sender] < 10 ) { 
279                         rewards[msg.sender]++;
280                         amountTransETHMD += rewardvalue;
281                         balances[msg.sender] += rewardvalue;
282                         Transfer(address(0), msg.sender, rewardvalue);
283                         }
284                     }
285                 }
286             }
287 
288         return true;
289     }
290 
291         /*****************/
292         /* Stages System */
293         /*****************/
294 
295     function nextStage() public {
296         
297         require(msg.sender == admin);
298         
299         if (CurrentStage == 1) {
300             recoverVault(amountPreSaleETH.div(3).div(3));
301             CurrentStage = 2;
302         }else if( CurrentStage == 2) {
303             recoverVault(amountPreSaleETH.div(3).div(3));
304             recoverVault(amountICOETH.div(2).div(3));
305             CurrentStage = 3;
306         }else if( CurrentStage == 3) {
307             recoverVault(amountPreSaleETH.div(3).div(3));
308             recoverVault(amountICOETH.div(2).div(3));
309             recoverVault(amountSpecialETH.div(3));
310             CurrentStage = 4;
311         }else if( CurrentStage == 4) {
312             stage4();
313         }
314     }
315 
316     function stage4() private {
317 
318         // if > 1M = exced for community
319         // if < 1M = reward for transactions
320 
321         if ( amountPreSaleETHMD + 
322             amountICOETHMD + 
323             amountSpecialETHMD + 
324             amountPreDonateETHMD + 
325             amountManualSaleETHMD + 
326             1000000 * 1000000000000000000 + 
327             amountTransETHMD 
328             <= MaxCoinsLimit15M ) {
329 
330             balances[vault_community] += 1000000 * 1000000000000000000;
331             Transfer(address(0), vault_community, 1000000 * 1000000000000000000);
332             amountPreDonateETHMD += 1000000 * 1000000000000000000;
333 
334         }
335     }
336 
337     function recoverVault(uint256 founds) private {
338         vault_developers.transfer(founds);
339         vault_designers.transfer(founds);
340         vault_marketing.transfer(founds);
341     }
342 
343         /******************/
344         /* Payable System */
345         /******************/
346 
347     function () public payable {
348 
349       require(CurrentStage < 4);
350       require( msg.value >= 1* (1 ether) / 100 ); // 0.01 ether min
351           
352           uint256 amountETHMD = 0;
353           uint256 amountETH = msg.value;
354           
355           if(CurrentStage==1) { 
356               amountETHMD = (amountETH * 10000).mul(5);
357           }else if (CurrentStage == 2){
358               amountETHMD = amountETH * 10000;
359           }else if (CurrentStage == 3){
360               amountETHMD = (amountETH * 10000).div(stage3divisor) ;
361           }
362           
363       require(  amountPreSaleETHMD + 
364                 amountICOETHMD + 
365                 amountSpecialETHMD + 
366                 amountPreDonateETHMD + 
367                 amountManualSaleETHMD + 
368                 amountETHMD + 
369                 amountTransETHMD 
370                 <= MaxCoinsLimit15M );
371 
372           if(CurrentStage==1) { 
373               amountPreSaleETHMD += amountETHMD;
374               amountPreSaleETH += amountETH;
375           }else if (CurrentStage == 2){
376               amountICOETHMD += amountETHMD;
377               amountICOETH += amountETH;
378           }else if (CurrentStage == 3){
379               amountSpecialETHMD += amountETHMD;
380               amountSpecialETH += amountETH;
381               if (amountETH >= 100000000000000000) { // 0.1 eth
382               stage3divisor += 1;
383               }
384           }
385 
386         balances[msg.sender] += amountETHMD;
387         Transfer(address(0), msg.sender, amountETHMD);
388          
389     }
390 
391 
392 }