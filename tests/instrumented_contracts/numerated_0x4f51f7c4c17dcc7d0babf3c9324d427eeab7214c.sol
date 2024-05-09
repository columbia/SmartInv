1 pragma solidity ^0.4.18;
2 
3 //
4 // EtherPiggyBank
5 // (etherpiggybank.com)
6 //        
7 //   <`--'\>______
8 //   /. .  `'     \
9 //  (`')  ,        @
10 //   `-._,        /
11 //      )-)_/--( >  
12 //     ''''  ''''
13 //
14 // Invest Ethereum into a long term stable solution where
15 // your investment can grow organically as the system expands.
16 // You will gain +1.5% of your invested Ethereum every day that
17 // you leave it in the Ether Piggy Bank!
18 // You can withdraw your investments at any time but it will
19 // incur a 20% withdrawal fee (~13 days of investing).
20 // You can also invest your profits back into your account and
21 // your gains will compound the more you do this!
22 // 
23 // Big players can compete for the investment positions available,
24 // every time someone makes a deposit into the Ether Piggy Bank,
25 // they will receive a percentage of that sale in their
26 // affiliate commision.
27 // You can buy this position off anyone and double it's current
28 // buying price but every 3-7 days (depending on the position),
29 // the buying price will halve until it reaches 0.125 ether.
30 // Upon buying, the previous investor gets 75% of the buying price,
31 // the dev gets 5% and the rest goes into the contract to encourage
32 // an all round balanced ecosystem!
33 //
34 // You will also receive a 5% bonus, which will appear in your
35 // affiliate commission, by referring another player to the game 
36 // via your referral URL! It's a HYIP on a smart contract, fully
37 // transparent and you'll never need to worry about an exit scam or
38 // someone taking all the money and leaving!
39 
40 
41 contract EtherPiggyBank {
42     
43     // investment tracking for each address
44     mapping (address => uint256) public investedETH;
45     mapping (address => uint256) public lastInvest;
46     
47     // for referrals and investor positions
48     mapping (address => uint256) public affiliateCommision;
49     uint256 REF_BONUS = 4; // 4% of the ether invested
50     // goes into the ref address' affiliate commision
51     uint256 DEV_TAX = 1; // 1% of all ether invested
52     // goes into the dev address' affiliate commision
53     
54     uint256 BASE_PRICE = 0.125 ether; // 1/8 ether
55     uint256 INHERITANCE_TAX = 75; // 75% will be returned to the
56     // investor if their position is purchased, the rest will
57     // go to the contract and the dev
58     uint256 DEV_TRANSFER_TAX = 5;
59     // this means that when purchased the sale will be distrubuted:
60     // 75% to the old position owner
61     // 5% to the dev
62     // and 20% to the contract for all the other investors
63     // ^ this will encourage a healthy ecosystem
64     struct InvestorPosition {
65         address investor;
66         uint256 startingLevel;
67         uint256 startingTime;
68         uint256 halfLife;
69         uint256 percentageCut;
70     }
71 
72     InvestorPosition[] investorPositions; 
73     address public dev;
74 
75     // start up the contract!
76     function EtherPiggyBank() public {
77         
78         // set the dev address
79         dev = msg.sender;
80         
81         // make the gold level investor
82         investorPositions.push(InvestorPosition({
83             investor: dev,
84             startingLevel: 5, // 1/8 ether * 2^5 = 4 ether
85             startingTime: now,
86             halfLife: 7 days, // 7 days until the level decreases
87             percentageCut: 5 // with 5% cut of all investments
88             }));
89 
90         // make the silver level investor
91         investorPositions.push(InvestorPosition({
92             investor: 0x6c0cf053076681cecbe31e5e19df8fb97deb5756,
93             startingLevel: 4, // 1/8 ether * 2^4 = 2 ether
94             startingTime: now,
95             halfLife: 5 days, // 5 days until the level decreases
96             percentageCut: 3 // with 3% cut of all investments
97             }));
98 
99         // make the bronze level investor
100         investorPositions.push(InvestorPosition({
101             investor: 0x66fe910c6a556173ea664a94f334d005ddc9ce9e,
102             startingLevel: 3, // 1/8 ether * 2^3 = 1 ether
103             startingTime: now,
104             halfLife: 3 days, // 3 days until the level decreases
105             percentageCut: 1 // with 1% cut of all investments
106             }));
107     }
108     
109     function investETH(address referral) public payable {
110         
111         require(msg.value >= 0.01 ether);
112         
113         if (getProfit(msg.sender) > 0) {
114             uint256 profit = getProfit(msg.sender);
115             lastInvest[msg.sender] = now;
116             msg.sender.transfer(profit);
117         }
118         
119         uint256 amount = msg.value;
120 
121         // handle all of our investor positions first
122         bool flaggedRef = (referral == msg.sender || referral == dev); // ref cannot be the sender or the dev
123         for(uint256 i = 0; i < investorPositions.length; i++) {
124             
125             InvestorPosition memory position = investorPositions[i];
126 
127             // check that our ref isn't an investor too
128             if (position.investor == referral) {
129                 flaggedRef = true;
130             }
131             
132             // we cannot claim on our own investments
133             if (position.investor != msg.sender) {
134                 uint256 commision = SafeMath.div(SafeMath.mul(amount, position.percentageCut), 100);
135                 affiliateCommision[position.investor] = SafeMath.add(affiliateCommision[position.investor], commision);
136             }
137 
138         }
139 
140         // now for the referral (if we have one)
141         if (!flaggedRef && referral != 0x0) {
142             uint256 refBonus = SafeMath.div(SafeMath.mul(amount, REF_BONUS), 100); // 4%
143             affiliateCommision[referral] = SafeMath.add(affiliateCommision[referral], refBonus);
144         }
145         
146         // hand out the dev tax
147         uint256 devTax = SafeMath.div(SafeMath.mul(amount, DEV_TAX), 100); // 1%
148         affiliateCommision[dev] = SafeMath.add(affiliateCommision[dev], devTax);
149 
150         
151         // now put it in your own piggy bank!
152         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], amount);
153         lastInvest[msg.sender] = now;
154 
155     }
156     
157     function divestETH() public {
158 
159         uint256 profit = getProfit(msg.sender);
160         
161         // 20% fee on taking capital out
162         uint256 capital = investedETH[msg.sender];
163         uint256 fee = SafeMath.div(capital, 5);
164         capital = SafeMath.sub(capital, fee);
165         
166         uint256 total = SafeMath.add(capital, profit);
167 
168         require(total > 0);
169         investedETH[msg.sender] = 0;
170         lastInvest[msg.sender] = now;
171         msg.sender.transfer(total);
172 
173     }
174     
175     function withdraw() public{
176 
177         uint256 profit = getProfit(msg.sender);
178 
179         require(profit > 0);
180         lastInvest[msg.sender] = now;
181         msg.sender.transfer(profit);
182 
183     }
184 
185     function withdrawAffiliateCommision() public {
186 
187         require(affiliateCommision[msg.sender] > 0);
188         uint256 commision = affiliateCommision[msg.sender];
189         affiliateCommision[msg.sender] = 0;
190         msg.sender.transfer(commision);
191 
192     }
193     
194     function reinvestProfit() public {
195 
196         uint256 profit = getProfit(msg.sender);
197 
198         require(profit > 0);
199         lastInvest[msg.sender] = now;
200         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], profit);
201 
202     }
203 
204     function inheritInvestorPosition(uint256 index) public payable {
205 
206         require(investorPositions.length > index);
207         require(msg.sender == tx.origin);
208 
209         InvestorPosition storage position = investorPositions[index];
210         uint256 currentLevel = getCurrentLevel(position.startingLevel, position.startingTime, position.halfLife);
211         uint256 currentPrice = getCurrentPrice(currentLevel);
212 
213         require(msg.value >= currentPrice);
214         uint256 purchaseExcess = SafeMath.sub(msg.value, currentPrice);
215         position.startingLevel = currentLevel + 1;
216         position.startingTime = now;
217 
218         // now do the transfers
219         uint256 inheritanceTax = SafeMath.div(SafeMath.mul(currentPrice, INHERITANCE_TAX), 100); // 75%
220         position.investor.transfer(inheritanceTax);
221         position.investor = msg.sender; // set the new investor address
222 
223         // now the dev transfer tax
224         uint256 devTransferTax = SafeMath.div(SafeMath.mul(currentPrice, DEV_TRANSFER_TAX), 100); // 5%
225         dev.transfer(devTransferTax);
226 
227         // and finally the excess
228         msg.sender.transfer(purchaseExcess);
229 
230         // after this point there will be 20% of currentPrice left in the contract
231         // this will be automatically go towards paying for profits and withdrawals
232 
233     }
234 
235     function getInvestorPosition(uint256 index) public view returns(address investor, uint256 currentPrice, uint256 halfLife, uint256 percentageCut) {
236         InvestorPosition memory position = investorPositions[index];
237         return (position.investor, getCurrentPrice(getCurrentLevel(position.startingLevel, position.startingTime, position.halfLife)), position.halfLife, position.percentageCut);
238     }
239 
240     function getCurrentPrice(uint256 currentLevel) internal view returns(uint256) {
241         return BASE_PRICE * 2**currentLevel; // ** is exponent, price doubles every level
242     }
243 
244     function getCurrentLevel(uint256 startingLevel, uint256 startingTime, uint256 halfLife) internal view returns(uint256) {
245         uint256 timePassed = SafeMath.sub(now, startingTime);
246         uint256 levelsPassed = SafeMath.div(timePassed, halfLife);
247         if (startingLevel < levelsPassed) {
248             return 0;
249         }
250         return SafeMath.sub(startingLevel,levelsPassed);
251     }
252 
253     function getProfitFromSender() public view returns(uint256){
254         return getProfit(msg.sender);
255     }
256 
257     function getProfit(address customer) public view returns(uint256){
258         uint256 secondsPassed = SafeMath.sub(now, lastInvest[customer]);
259         return SafeMath.div(SafeMath.mul(secondsPassed, investedETH[customer]), 5760000); // = days * amount * 0.015 (+1.5% per day)
260     }
261     
262     function getAffiliateCommision() public view returns(uint256){
263         return affiliateCommision[msg.sender];
264     }
265     
266     function getInvested() public view returns(uint256){
267         return investedETH[msg.sender];
268     }
269     
270     function getBalance() public view returns(uint256){
271         return this.balance;
272     }
273 
274 }
275 
276 library SafeMath {
277 
278   /**
279   * @dev Multiplies two numbers, throws on overflow.
280   */
281   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
282     if (a == 0) {
283       return 0;
284     }
285     uint256 c = a * b;
286     assert(c / a == b);
287     return c;
288   }
289 
290   /**
291   * @dev Integer division of two numbers, truncating the quotient.
292   */
293   function div(uint256 a, uint256 b) internal pure returns (uint256) {
294     // assert(b > 0); // Solidity automatically throws when dividing by 0
295     uint256 c = a / b;
296     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
297     return c;
298   }
299 
300   /**
301   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
302   */
303   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
304     assert(b <= a);
305     return a - b;
306   }
307 
308   /**
309   * @dev Adds two numbers, throws on overflow.
310   */
311   function add(uint256 a, uint256 b) internal pure returns (uint256) {
312     uint256 c = a + b;
313     assert(c >= a);
314     return c;
315   }
316 
317 }