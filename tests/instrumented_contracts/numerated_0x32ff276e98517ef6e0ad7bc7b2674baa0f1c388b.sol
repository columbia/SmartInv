1 pragma solidity ^0.4.16;
2 
3 
4 contract Token {
5     uint256 public totalSupply;
6 
7     function balanceOf(address who) constant returns (uint256);
8 
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool);
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
21         uint256 c = a * b;
22         assert(a == 0 || c / a == b);
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal constant returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     function add(uint256 a, uint256 b) internal constant returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable {
52     address public owner;
53 
54 
55     /**
56      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57      * account.
58      */
59     function Ownable() {
60         owner = msg.sender;
61     }
62 
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(msg.sender == owner);
69         _;
70     }
71 
72 
73     /**
74      * @dev Allows the current owner to transfer control of the contract to a newOwner.
75      * @param newOwner The address to transfer ownership to.
76      */
77     function transferOwnership(address newOwner) onlyOwner {
78         require(newOwner != address(0));
79         owner = newOwner;
80     }
81 
82 }
83 
84 
85 /**
86  * @title Pausable
87  * @dev Base contract which allows children to implement an emergency stop mechanism.
88  */
89 contract Pausable is Ownable {
90     event Pause();
91 
92     event Unpause();
93 
94     bool public paused = false;
95 
96 
97     /**
98      * @dev modifier to allow actions only when the contract IS paused
99      */
100     modifier whenNotPaused() {
101         require(!paused);
102         _;
103     }
104 
105     /**
106      * @dev modifier to allow actions only when the contract IS NOT paused
107      */
108     modifier whenPaused() {
109         require(paused);
110         _;
111     }
112 
113     /**
114      * @dev called by the owner to pause, triggers stopped state
115      */
116     function pause() onlyOwner whenNotPaused {
117         paused = true;
118         Pause();
119     }
120 
121     /**
122      * @dev called by the owner to unpause, returns to normal state
123      */
124     function unpause() onlyOwner whenPaused {
125         paused = false;
126         Unpause();
127     }
128 }
129 
130 
131 contract BillPokerPreICO is Ownable, Pausable {
132     using SafeMath for uint;
133 
134     /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
135     address public tokenWallet = 0xf91E6d611ec35B985bADAD2F0DA96820930B9BD2;
136 
137     uint public tokensSold;
138 
139     uint public weiRaised;
140 
141     mapping (address => uint256) public holdTokens;
142 
143     mapping (address => uint256) public purchaseTokens;
144 
145     address[] public holdTokenInvestors;
146 
147     Token public token = Token(0xc305fcdc300fa43c527e9327711f360e79528a70);
148 
149     uint public constant minInvest = 0.0001 ether;
150 
151     uint public constant tokensLimit = 25000000 ether;
152 
153     // start and end timestamps where investments are allowed
154     uint256 public startTime = 1510339500; // 14 November 2017 00:00 UTC
155 
156     uint256 public endTime = 1519689600; // 28 December 2017 00:00 UTC
157 
158     uint public price = 0.0001 ether;
159 
160     bool public isHoldTokens = false;
161 
162     uint public investorCount;
163 
164     mapping (bytes32 => Promo) public promoMap;
165 
166     struct Promo {
167     bool enable;
168     uint investorPercentToken;
169     address dealer;
170     uint dealerPercentToken;
171     uint dealerPercentETH;
172     uint buyCount;
173     uint investorTokenAmount;
174     uint dealerTokenAmount;
175     uint investorEthAmount;
176     uint dealerEthAmount;
177     }
178     
179     function addPromo(bytes32 promoPublicKey, uint userPercentToken, address dealer, uint dealerPercentToken, uint dealerPercentETH) public onlyOwner {
180         promoMap[promoPublicKey] = Promo(true, userPercentToken, dealer, dealerPercentToken, dealerPercentETH, 0, 0, 0, 0, 0);
181     }
182 
183     function removePromo(bytes32 promoPublicKey) public onlyOwner {
184         promoMap[promoPublicKey].enable = false;
185     }
186 
187 
188     /**
189      * event for token purchase logging
190      * @param purchaser who paid for the tokens
191      * @param beneficiary who got the tokens
192      * @param value weis paid for purchase
193      * @param amount amount of tokens purchased
194      */
195     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
196 
197     // fallback function can be used to buy tokens
198     function() public payable {
199         buyTokens(msg.sender);
200     }
201 
202     // low level token purchase function
203     function buyTokens(address beneficiary) public whenNotPaused payable {
204         require(startTime <= now && now <= endTime);
205 
206         uint weiAmount = msg.value;
207 
208         require(weiAmount >= minInvest);
209 
210         uint tokenAmountEnable = tokensLimit.sub(tokensSold);
211 
212         require(tokenAmountEnable > 0);
213 
214         uint tokenAmount = weiAmount / price * 1 ether;
215 
216         if (tokenAmount > tokenAmountEnable) {
217             tokenAmount = tokenAmountEnable;
218             weiAmount = tokenAmount * price / 1 ether;
219             msg.sender.transfer(msg.value.sub(weiAmount));
220 
221 
222             if (msg.data.length > 0) {
223                 Promo storage promo = promoMap[sha3(msg.data)];
224                 if (promo.enable && promo.dealerPercentETH > 0) {
225                     uint dealerEthAmount = weiAmount * promo.dealerPercentETH / 10000;
226                     promo.dealer.transfer(dealerEthAmount);
227                     weiAmount = weiAmount.sub(dealerEthAmount);
228 
229                     promo.dealerEthAmount += dealerEthAmount;
230                 }
231             }
232         }
233         else {
234             uint countBonusAmount = tokenAmount * getCountBonus(weiAmount) / 1000;
235             uint timeBonusAmount = tokenAmount * getTimeBonus(now) / 1000;
236 
237             if (msg.data.length > 0) {
238                 bytes32 promoPublicKey = sha3(msg.data);
239                 promo = promoMap[promoPublicKey];
240                 if (promo.enable) {
241                     
242                     promo.buyCount++;
243                     promo.investorTokenAmount += tokenAmount;
244                     promo.investorEthAmount += weiAmount;
245                     
246                     if (promo.dealerPercentToken > 0) {
247                         uint dealerTokenAmount = tokenAmount * promo.dealerPercentToken / 10000;
248                         sendTokens(promo.dealer, dealerTokenAmount);
249                         promo.dealerTokenAmount += dealerTokenAmount;
250                     }
251 
252                     if (promo.dealerPercentETH > 0) {
253                         dealerEthAmount = weiAmount * promo.dealerPercentETH / 10000;
254                         promo.dealer.transfer(dealerEthAmount);
255                         weiAmount = weiAmount.sub(dealerEthAmount);
256                         promo.dealerEthAmount += dealerEthAmount;
257                     }
258 
259                         
260                     if (promo.investorPercentToken > 0) {
261                         uint promoBonusAmount = tokenAmount * promo.investorPercentToken / 10000;
262                         tokenAmount += promoBonusAmount;
263                     }
264 
265                 }
266             }
267 
268             tokenAmount += countBonusAmount + timeBonusAmount;
269 
270             if (tokenAmount > tokenAmountEnable) {
271                 tokenAmount = tokenAmountEnable;
272             }
273         }
274 
275 
276         if (purchaseTokens[beneficiary] == 0) investorCount++;
277 
278         purchaseTokens[beneficiary] = purchaseTokens[beneficiary].add(tokenAmount);
279 
280         sendTokens(beneficiary, tokenAmount);
281 
282         weiRaised = weiRaised.add(weiAmount);
283 
284         TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
285     }
286 
287     function sendTokens(address to, uint tokenAmount) private {
288         if (isHoldTokens) {
289             if (holdTokens[to] == 0) holdTokenInvestors.push(to);
290             holdTokens[to] = holdTokens[to].add(tokenAmount);
291         }
292         else {
293             require(token.transferFrom(tokenWallet, to, tokenAmount));
294         }
295 
296         tokensSold = tokensSold.add(tokenAmount);
297     }
298 
299     uint[] etherForCountBonus = [2 ether, 3 ether, 5 ether, 7 ether, 9 ether, 12 ether, 15 ether, 20 ether, 25 ether, 30 ether, 35 ether, 40 ether, 45 ether, 50 ether, 60 ether, 70 ether, 80 ether, 90 ether, 100 ether, 120 ether, 150 ether, 200 ether, 250 ether, 300 ether, 350 ether, 400 ether, 450 ether, 500 ether];
300 
301     uint[] amountForCountBonus = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 90, 100, 105, 110, 115, 120, 125, 130, 135, 140, 145, 150];
302 
303 
304     function getCountBonus(uint weiAmount) public constant returns (uint) {
305         for (uint i = 0; i < etherForCountBonus.length; i++) {
306             if (weiAmount < etherForCountBonus[i]) return amountForCountBonus[i];
307         }
308         return amountForCountBonus[amountForCountBonus.length - 1];
309     }
310 
311     function getTimeBonus(uint time) public constant returns (uint) {
312         if (time < startTime + 604800) return 250;
313         if (time < startTime + 604800) return 200;
314         if (time < startTime + 259200) return 100;
315         return 0;
316     }
317 
318     function withdrawal(address to) public onlyOwner {
319         to.transfer(this.balance);
320     }
321 
322     function holdTokenInvestorsCount() public constant returns(uint){
323         return holdTokenInvestors.length;
324     }
325 
326     uint public sendInvestorIndex = 0;
327 
328     function finalSendTokens() public onlyOwner {
329         isHoldTokens = false;
330         
331         for (uint i = sendInvestorIndex; i < holdTokenInvestors.length; i++) {
332             address investor = holdTokenInvestors[i];
333             uint tokenAmount = holdTokens[investor];
334 
335             if (tokenAmount > 0) {
336                 holdTokens[investor] = 0;
337                 require(token.transferFrom(tokenWallet, investor, tokenAmount));
338             }
339 
340             if (msg.gas < 100000) {
341                 sendInvestorIndex = i;
342                 return;
343             }
344         }
345 
346         sendInvestorIndex = holdTokenInvestors.length;
347     }
348 
349 }