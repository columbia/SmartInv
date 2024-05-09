1 pragma solidity 0.4.19;
2 
3 
4 contract Ownable {
5     
6     address public owner;
7 
8     /**
9      * The address whcih deploys this contrcat is automatically assgined ownership.
10      * */
11     function Ownable() public {
12         owner = msg.sender;
13     }
14 
15     /**
16      * Functions with this modifier can only be executed by the owner of the contract. 
17      * */
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     event OwnershipTransferred(address indexed from, address indexed to);
24 
25     /**
26     * Transfers ownership to new Ethereum address. This function can only be called by the 
27     * owner.
28     * @param _newOwner the address to be granted ownership.
29     **/
30     function transferOwnership(address _newOwner) public onlyOwner {
31         require(_newOwner != 0x0);
32         OwnershipTransferred(owner, _newOwner);
33         owner = _newOwner;
34     }
35 }
36 
37 
38 
39 library SafeMath {
40     
41     function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
42         uint256 c = a * b;
43         assert(a == 0 || c / a == b);
44         return c;
45     }
46 
47     function div(uint256 a, uint256 b) internal pure  returns (uint256) {
48         uint256 c = a / b;
49         return c;
50     }
51 
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         assert(b <= a);
54         return a - b;
55     }
56 
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         assert(c >= a);
60         return c;
61     }
62 }
63 
64 
65 
66 contract ERC20TransferInterface {
67     function transfer(address to, uint256 value) public returns (bool);
68     function balanceOf(address who) constant public returns (uint256);
69 }
70 
71 
72 
73 contract ICO is Ownable {
74     
75     using SafeMath for uint256;
76 
77     event TokenAddressSet(address indexed tokenAddress);
78     event FirstPreIcoActivated(uint256 startTime, uint256 endTime, uint256 bonus);
79     event SecondPreIcoActivated(uint256 startTime, uint256 endTime, uint256 bonus);
80     event MainIcoActivated(uint256 startTime, uint256 endTime, uint256 bonus);
81     event TokenPriceChanged(uint256 newTokenPrice, uint256 newExchangeRate);
82     event ExchangeRateChanged(uint256 newExchangeRate, uint256 newTokenPrice);
83     event BonuseChanged(uint256 newBonus);
84     event OffchainPurchaseMade(address indexed recipient, uint256 tokensPurchased);
85     event TokensPurchased(address indexed recipient, uint256 tokensPurchased, uint256 weiSent);
86     event UnsoldTokensWithdrawn(uint256 tokensWithdrawn);
87     event ICOPaused(uint256 timeOfPause);
88     event ICOUnpaused(uint256 timeOfUnpause);
89     event IcoDeadlineExtended(State currentState, uint256 newDeadline);
90     event IcoDeadlineShortened(State currentState, uint256 newDeadline);
91     event IcoTerminated(uint256 terminationTime);
92     event AirdropInvoked();
93 
94     uint256 public endTime;
95     uint256 private pausedTime;
96     bool public IcoPaused;
97     uint256 public tokenPrice;
98     uint256 public rate;
99     uint256 public bonus;
100     uint256 public minInvestment;
101     ERC20TransferInterface public MSTCOIN;
102     address public multiSigWallet;
103     uint256 public tokensSold;
104 
105     mapping (address => uint256) public investmentOf;
106 
107     enum State {FIRST_PRE_ICO, SECOND_PRE_ICO, MAIN_ICO, TERMINATED}
108     State public icoState;
109 
110     uint256[4] public mainIcoBonusStages;
111 
112     function ICO() public {
113         endTime = now.add(7 days);
114         pausedTime = 0;
115         IcoPaused = false;
116         tokenPrice = 89e12; // tokenPrice is rate / 1e18
117         rate = 11235;  // rate is 1e18 / tokenPrice
118         bonus = 100;
119         minInvestment = 1e17;
120         multiSigWallet = 0xE1377e465121776d8810007576034c7E0798CD46;
121         tokensSold = 0;
122         icoState = State.FIRST_PRE_ICO;
123         FirstPreIcoActivated(now, endTime, bonus);
124     }
125 
126     /**
127     * Sets the address of the token. This function can only be executed by the 
128     * owner of the contract.
129     **/
130     function setTokenAddress(address _tokenAddress) public onlyOwner {
131         require(_tokenAddress != 0x0);
132         MSTCOIN = ERC20TransferInterface(_tokenAddress);
133         TokenAddressSet(_tokenAddress);
134     }
135 
136     /**
137     * Returns the address of the token. 
138     **/
139     function getTokenAddress() public view returns(address) {
140         return address(MSTCOIN);
141     }
142 
143     /**
144     * Allows the owner to activate the second pre ICO. This function can only be 
145     * executed once the first pre ICO has finished. 
146     **/
147     function activateSecondPreIco() public onlyOwner {
148         require(now >= endTime && icoState == State.FIRST_PRE_ICO);
149         icoState = State.SECOND_PRE_ICO;
150         endTime = now.add(4 days);
151         bonus = 50;
152         SecondPreIcoActivated(now, endTime, bonus);
153     }
154 
155     /**
156     * Allows the owner to activate the main public ICO stage. This function can only be 
157     * executed once the second pre ICO has finished. 
158     **/
159     function activateMainIco() public onlyOwner {
160         require(now >= endTime && icoState == State.SECOND_PRE_ICO);
161         icoState = State.MAIN_ICO;
162         mainIcoBonusStages[0] = now.add(7 days);
163         mainIcoBonusStages[1] = now.add(14 days);
164         mainIcoBonusStages[2] = now.add(21 days);
165         mainIcoBonusStages[3] = now.add(31 days);
166         endTime = now.add(31 days);
167         bonus = 35;
168         MainIcoActivated(now, endTime, bonus);
169     }
170 
171     /**
172     * Allows the owner to change the price of the token. 
173     *
174     * @param _newTokenPrice The new price per token. 
175     **/
176     function changeTokenPrice(uint256 _newTokenPrice) public onlyOwner {
177         require(tokenPrice != _newTokenPrice && _newTokenPrice > 0);
178         tokenPrice = _newTokenPrice;
179         uint256 eth = 1e18;
180         rate = eth.div(tokenPrice);
181         TokenPriceChanged(tokenPrice, rate);
182     }
183 
184     /**
185     * Allows the owner to change the exchange rate of the token.
186     *
187     * @param _newRate The new exchange rate
188     **/
189     function changeRate(uint256 _newRate) public onlyOwner {
190         require(rate != _newRate && _newRate > 0);
191         rate = _newRate;
192         uint256 x = 1e12;
193         tokenPrice = x.div(rate);
194         ExchangeRateChanged(rate, tokenPrice);
195     }
196 
197     /**
198     * Allows the owner to change the bonus of the current ICO stage. 
199     *
200     * @param _newBonus The new bonus percentage investors will receive.
201     **/
202     function changeBonus(uint256 _newBonus) public onlyOwner {
203         require(bonus != _newBonus && _newBonus > 0);
204         bonus = _newBonus;
205         BonuseChanged(bonus);
206     }
207 
208     /**
209     * Allows the owner to sell tokens with other forms of payment including fiat and all other
210     * cryptos. 
211     *
212     * @param _recipient The address to send tokens to.
213     * @param _value The amount of tokens to be sent.
214     **/
215     function processOffchainTokenPurchase(address _recipient, uint256 _value) public onlyOwner {
216         require(MSTCOIN.balanceOf(address(this)) >= _value);
217         require(_recipient != 0x0 && _value > 0);
218         MSTCOIN.transfer(_recipient, _value);
219         tokensSold = tokensSold.add(_value);
220         OffchainPurchaseMade(_recipient, _value);
221     }
222 
223     /**
224     * Fallback function calls the buyTokens function automatically when an investment is made.
225     **/
226     function() public payable {
227         buyTokens(msg.sender);
228     }
229 
230     /**
231     * Allows investors to send their ETH and automatically receive tokens in return.
232     *
233     * @param _recipient The addrewss which will receive tokens
234     **/
235     function buyTokens(address _recipient) public payable {
236         uint256 msgVal = msg.value.div(1e12); //because token has 6 decimals
237         require(MSTCOIN.balanceOf(address(this)) >= msgVal.mul(rate.mul(getBonus()).div(100)).add(rate) ) ;
238         require(msg.value >= minInvestment && withinPeriod());
239         require(_recipient != 0x0);
240         uint256 toTransfer = msgVal.mul(rate.mul(getBonus()).div(100).add(rate));
241         MSTCOIN.transfer(_recipient, toTransfer);
242         tokensSold = tokensSold.add(toTransfer);
243         investmentOf[msg.sender] = investmentOf[msg.sender].add(msg.value);
244         TokensPurchased(_recipient, toTransfer, msg.value);
245         forwardFunds();
246     }
247 
248     /**
249     * This function is internally called by the buyTokens function to automatically forward
250     * all investments made to the multi signature wallet. 
251     **/
252     function forwardFunds() internal {
253         multiSigWallet.transfer(msg.value);
254     }
255 
256     /**
257     * This function is internally called by the buyTokens function to ensure that investments
258     * are made during times when the ICO is not paused and when the duration of the current 
259     * phase has not finished.
260     **/
261     function withinPeriod() internal view returns(bool) {
262         return IcoPaused == false && now < endTime && icoState != State.TERMINATED;
263     }
264 
265     /**
266     * Calculates and returns the bonus of the current ICO stage. During the main public ICO, the
267     * first ICO the bonus stages are set as such:
268     *
269     * week 1: bonus = 35%
270     * week 2: bonus = 25%
271     * week 3: bonus = 15%
272     * week 4: bonus = 5%
273     **/
274     function getBonus() public view returns(uint256 _bonus) {
275         _bonus = bonus;
276         if(icoState == State.MAIN_ICO) {
277             if(now > mainIcoBonusStages[3]) {
278                 _bonus = 0;
279             } else {
280                 uint256 timeStamp = now;
281                 for(uint i = 0; i < mainIcoBonusStages.length; i++) {
282                     if(timeStamp <= mainIcoBonusStages[i]) {
283                         break;
284                     } else {
285                         if(_bonus >= 15) {
286                             _bonus = _bonus.sub(10);
287                         }
288                     }
289                 }
290             }
291         }
292         return _bonus;
293     }
294 
295     /**
296     * Allows the owner of the contract to withdraw all unsold tokens. This function can 
297     * only be executed once the ICO contract has been terminated after the main public 
298     * ICO has finished. 
299     *
300     * @param _recipient The address to withdraw all unsold tokens to. If this field is 
301     * left empty, then the tokens will just be sent to the owner of the contract. 
302     **/
303     function withdrawUnsoldTokens(address _recipient) public onlyOwner {
304         require(icoState == State.TERMINATED);
305         require(now >= endTime && MSTCOIN.balanceOf(address(this)) > 0);
306         if(_recipient == 0x0) { 
307             _recipient = owner; 
308         }
309         UnsoldTokensWithdrawn(MSTCOIN.balanceOf(address(this)));
310         MSTCOIN.transfer(_recipient, MSTCOIN.balanceOf(address(this)));
311     }
312 
313     /**
314     * Allows the owner to pause the ICO contract. While the ICO is paused investments cannot
315     * be made. 
316     **/
317     function pauseICO() public onlyOwner {
318         require(!IcoPaused);
319         IcoPaused = true;
320         pausedTime = now;
321         ICOPaused(now);
322     }
323 
324     /**
325     * Allows the owner to unpause the ICO only when the ICO contract has been paused. Once
326     * invoked, the deadline will automatically be extended by the duration the ICO was 
327     * paused for. 
328     **/
329     function unpauseICO() public onlyOwner {
330         require(IcoPaused);
331         IcoPaused = false;
332         endTime = endTime.add(now.sub(pausedTime));
333         ICOUnpaused(now);
334     }
335 
336 
337     /**
338     * Allows the owner of the ICO to extend the deadline of the current ICO stage. This
339     * function can only be executed if the ICO contract has not been terminated. 
340     *
341     * @param _days The number of days to increase the duration of the ICO by. 
342     **/
343     function extendDeadline(uint256 _days) public onlyOwner {
344         require(icoState != State.TERMINATED);
345         endTime = endTime.add(_days.mul(1 days));
346         if(icoState == State.MAIN_ICO) {
347             uint256 blocks = 0;
348             uint256 stage = 0;
349             for(uint i = 0; i < mainIcoBonusStages.length; i++) {
350                 if(now < mainIcoBonusStages[i]) {
351                     stage = i;
352                 }
353             }
354             blocks = (_days.mul(1 days)).div(mainIcoBonusStages.length.sub(stage));
355             for(uint x = stage; x < mainIcoBonusStages.length; x++) {
356                 mainIcoBonusStages[x] = mainIcoBonusStages[x].add(blocks);
357             }
358         }
359         IcoDeadlineExtended(icoState, endTime);
360     }
361 
362     /**
363     * Allows the owner of the contract to shorten the deadline of the current ICO stage.
364     *
365     * @param _days The number of days to reduce the druation of the ICO by. 
366     **/
367     function shortenDeadline(uint256 _days) public onlyOwner {
368         if(now.add(_days.mul(1 days)) >= endTime) {
369             revert();
370         } else {
371             endTime = endTime.sub(_days.mul(1 days));
372             if(icoState == State.MAIN_ICO) {
373                 uint256 blocks = 0;
374                 uint256 stage = 0;
375                 for(uint i = 0; i < mainIcoBonusStages.length; i++) {
376                     if(now < mainIcoBonusStages[i]) {
377                         stage = i;
378                     }
379                 }
380                 blocks = (_days.mul(1 days)).div(mainIcoBonusStages.length.sub(stage));
381                 for(uint x = stage; x < mainIcoBonusStages.length; x++) {
382                     mainIcoBonusStages[x] = mainIcoBonusStages[x].sub(blocks);
383                 }
384             }
385         }
386         IcoDeadlineShortened(icoState, endTime);
387     }
388 
389     /**
390     * Terminates the ICO early permanently. This function can only be called by the
391     * owner of the contract during the main public ICO. 
392     **/
393     function terminateIco() public onlyOwner {
394         require(icoState == State.MAIN_ICO);
395         require(now < endTime);
396         endTime = now;
397         icoState = State.TERMINATED;
398         IcoTerminated(now);
399     }
400 
401     /**
402     * Returns the amount of tokens that have been sold.
403     **/
404     function getTokensSold() public view returns(uint256) {
405         return tokensSold;
406     }
407 
408     /**
409     * Airdrops tokens to up to 100 ETH addresses. 
410     *
411     * @param _addrs The list of addresses to send tokens to
412     * @param _values The list of amounts of tokens to send to each corresponding address.
413     **/
414     function airdrop(address[] _addrs, uint256[] _values) public onlyOwner returns(bool) {
415         require(_addrs.length == _values.length && _addrs.length <= 100);
416         require(MSTCOIN.balanceOf(address(this)) >= getSumOfValues(_values));
417         for (uint i = 0; i < _addrs.length; i++) {
418             if (_addrs[i] != 0x0 && _values[i] > 0) {
419                 MSTCOIN.transfer(_addrs[i], _values[i]);
420             }
421         }
422         AirdropInvoked();
423         return true;
424     }
425 
426     /**
427     * Called internally by the airdrop function to ensure the contract holds enough tokens
428     * to succesfully execute the airdrop.
429     *
430     * @param _values The list of values representing the amount of tokens which will be airdroped.
431     **/
432     function getSumOfValues(uint256[] _values) internal pure returns(uint256) {
433         uint256 sum = 0;
434         for(uint i=0; i < _values.length; i++) {
435             sum = sum.add(_values[i]);
436         }
437         return sum;
438     } 
439 }