1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers, truncating the quotient.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         // uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return a / b;
34     }
35 
36     /**
37     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38     */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     /**
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 
55 contract TokenInterface {
56     function totalSupply() public view returns (uint256);
57     function balanceOf(address who) public view returns (uint256);
58     function getMaxTotalSupply() public view returns (uint256);
59     function mint(address _to, uint256 _amount) public returns (bool);
60     function transfer(address _to, uint256 _amount) public returns (bool);
61 
62     function allowance(
63         address _who,
64         address _spender
65     )
66         public
67         view
68         returns (uint256);
69 
70     function transferFrom(
71         address _from,
72         address _to,
73         uint256 _value
74     )
75         public
76         returns (bool);
77 }
78 
79 
80 contract MiningTokenInterface {
81     function multiMint(address _to, uint256 _amount) external;
82     function getTokenTime(uint256 _tokenId) external returns(uint256);
83     function mint(address _to, uint256 _id) external;
84     function ownerOf(uint256 _tokenId) public view returns (address);
85     function totalSupply() public view returns (uint256);
86     function balanceOf(address _owner) public view returns (uint256 _balance);
87     function tokenByIndex(uint256 _index) public view returns (uint256);
88 
89     function arrayOfTokensByAddress(address _holder)
90         public
91         view
92         returns(uint256[]);
93 
94     function getTokensCount(address _owner) public returns(uint256);
95 
96     function tokenOfOwnerByIndex(
97         address _owner,
98         uint256 _index
99     )
100         public
101         view
102         returns (uint256 _tokenId);
103 }
104 
105 
106 contract Management {
107     using SafeMath for uint256;
108 
109     uint256 public startPriceForHLPMT = 10000;
110     uint256 public maxHLPMTMarkup = 40000;
111     uint256 public stepForPrice = 1000;
112 
113     uint256 public startTime;
114     uint256 public lastMiningTime;
115 
116     // default value
117     uint256 public decimals = 18;
118 
119     TokenInterface public token;
120     MiningTokenInterface public miningToken;
121 
122     address public dao;
123     address public fund;
124     address public owner;
125 
126     // num of mining times
127     uint256 public numOfMiningTimes;
128 
129     mapping(address => uint256) public payments;
130     mapping(address => uint256) public paymentsTimestamps;
131 
132     // mining time => mining reward
133     mapping(uint256 => uint256) internal miningReward;
134 
135     // id mining token => getting reward last mining
136     mapping(uint256 => uint256) internal lastGettingReward;
137 
138     modifier onlyOwner() {
139         require(msg.sender == owner);
140         _;
141     }
142 
143     modifier onlyDao() {
144         require(msg.sender == dao);
145         _;
146     }
147 
148     constructor(
149         address _token,
150         address _miningToken,
151         address _dao,
152         address _fund
153     )
154         public
155     {
156         require(_token != address(0));
157         require(_miningToken != address(0));
158         require(_dao != address(0));
159         require(_fund != address(0));
160 
161         startTime = now;
162         lastMiningTime = startTime - (startTime % (1 days)) - 1 days;
163         owner = msg.sender;
164 
165         token = TokenInterface(_token);
166         miningToken = MiningTokenInterface(_miningToken);
167         dao = _dao;
168         fund = _fund;
169     }
170 
171     /**
172      * @dev Exchanges the HLT tokens to HLPMT tokens. Works up to 48 HLPMT
173      * tokens at one-time buying. Should call after approving HLT tokens to
174      * manager address.
175      */
176     function buyHLPMT() external {
177 
178         uint256 _currentTime = now;
179         uint256 _allowed = token.allowance(msg.sender, address(this));
180         uint256 _currentPrice = getPrice(_currentTime);
181         require(_allowed >= _currentPrice);
182 
183         //remove the remainder
184         uint256 _hlpmtAmount = _allowed.div(_currentPrice);
185         _allowed = _hlpmtAmount.mul(_currentPrice);
186 
187         require(token.transferFrom(msg.sender, fund, _allowed));
188 
189         for (uint256 i = 0; i < _hlpmtAmount; i++) {
190             uint256 _id = miningToken.totalSupply();
191             miningToken.mint(msg.sender, _id);
192             lastGettingReward[_id] = numOfMiningTimes;
193         }
194     }
195 
196     /**
197      * @dev Produces the mining process and sends reward to dao and fund.
198      */
199     function mining() external {
200 
201         uint256 _currentTime = now;
202         require(_currentTime > _getEndOfLastMiningDay());
203 
204 
205         uint256 _missedDays = (_currentTime - lastMiningTime) / (1 days);
206 
207         updateLastMiningTime(_currentTime);
208 
209         for (uint256 i = 0; i < _missedDays; i++) {
210             // 0.1% daily from remaining unmined tokens.
211             uint256 _dailyTokens = token.getMaxTotalSupply().sub(token.totalSupply()).div(1000);
212 
213             uint256 _tokensToDao = _dailyTokens.mul(3).div(10); // 30 percent
214             token.mint(dao, _tokensToDao);
215 
216             uint256 _tokensToFund = _dailyTokens.mul(3).div(10); // 30 percent
217             token.mint(fund, _tokensToFund);
218 
219             uint256 _miningTokenSupply = miningToken.totalSupply();
220             uint256 _tokensToMiners = _dailyTokens.mul(4).div(10); // 40 percent
221             uint256 _tokensPerMiningToken = _tokensToMiners.div(_miningTokenSupply);
222 
223             miningReward[++numOfMiningTimes] = _tokensPerMiningToken;
224 
225             token.mint(address(this), _tokensToMiners);
226         }
227     }
228 
229     /**
230      * @dev Sends the daily mining reward to HLPMT holder.
231      */
232     function getReward(uint256[] tokensForReward) external {
233         uint256 _rewardAmount = 0;
234         for (uint256 i = 0; i < tokensForReward.length; i++) {
235             if (
236                 msg.sender == miningToken.ownerOf(tokensForReward[i]) &&
237                 numOfMiningTimes > getLastRewardTime(tokensForReward[i])
238             ) {
239                 _rewardAmount += _calculateReward(tokensForReward[i]);
240                 setLastRewardTime(tokensForReward[i], numOfMiningTimes);
241             }
242         }
243 
244         require(_rewardAmount > 0);
245         token.transfer(msg.sender, _rewardAmount);
246     }
247 
248     function checkReward(uint256[] tokensForReward) external view returns (uint256) {
249         uint256 reward = 0;
250 
251         for (uint256 i = 0; i < tokensForReward.length; i++) {
252             if (numOfMiningTimes > getLastRewardTime(tokensForReward[i])) {
253                 reward += _calculateReward(tokensForReward[i]);
254             }
255         }
256 
257         return reward;
258     }
259 
260     /**
261      * @param _tokenId token id
262      * @return timestamp of token creation
263      */
264     function getLastRewardTime(uint256 _tokenId) public view returns(uint256) {
265         return lastGettingReward[_tokenId];
266     }
267 
268     /**
269     * @dev Sends the daily mining reward to HLPMT holder.
270     */
271     function sendReward(uint256[] tokensForReward) public onlyOwner {
272         for (uint256 i = 0; i < tokensForReward.length; i++) {
273             if (numOfMiningTimes > getLastRewardTime(tokensForReward[i])) {
274                 uint256 reward = _calculateReward(tokensForReward[i]);
275                 setLastRewardTime(tokensForReward[i], numOfMiningTimes);
276                 token.transfer(miningToken.ownerOf(tokensForReward[i]), reward);
277             }
278         }
279     }
280 
281     /**
282      * @dev Returns the HLPMT token amount of holder.
283      */
284     function miningTokensOf(address holder) public view returns (uint256[]) {
285         return miningToken.arrayOfTokensByAddress(holder);
286     }
287 
288     /**
289      * @dev Sets the DAO address
290      * @param _dao DAO address.
291      */
292     function setDao(address _dao) public onlyOwner {
293         require(_dao != address(0));
294         dao = _dao;
295     }
296 
297     /**
298      * @dev Sets the fund address
299      * @param _fund Fund address.
300      */
301     function setFund(address _fund) public onlyOwner {
302         require(_fund != address(0));
303         fund = _fund;
304     }
305 
306     /**
307      * @dev Sets the token address
308      * @param _token Token address.
309      */
310     function setToken(address _token) public onlyOwner {
311         require(_token != address(0));
312         token = TokenInterface(_token);
313     }
314 
315     /**
316      * @dev Sets the mining token address
317      * @param _miningToken Mining token address.
318      */
319     function setMiningToken(address _miningToken) public onlyOwner {
320         require(_miningToken != address(0));
321         miningToken = MiningTokenInterface(_miningToken);
322     }
323 
324     /**
325      * @return uint256 the current HLPMT token price in HLT (without decimals).
326      */
327     function getPrice(uint256 _timestamp) public view returns(uint256) {
328         uint256 _raising = _timestamp.sub(startTime).div(30 days);
329         _raising = _raising.mul(stepForPrice);
330         if (_raising > maxHLPMTMarkup) _raising = maxHLPMTMarkup;
331         return (startPriceForHLPMT + _raising) * 10 ** 18;
332     }
333 
334     /**
335      * @param _numOfMiningTime is time
336      * @return getting token reward
337      */
338     function getMiningReward(uint256 _numOfMiningTime) public view returns (uint256) {
339         return miningReward[_numOfMiningTime];
340     }
341 
342     /**
343      * @dev Returns the calculated reward amount.
344      */
345     function _calculateReward(uint256 tokenID)
346         internal
347         view
348         returns (uint256 reward)
349     {
350         for (uint256 i = getLastRewardTime(tokenID) + 1; i <= numOfMiningTimes; i++) {
351             reward += miningReward[i];
352         }
353         return reward;
354     }
355 
356     /**
357      * @dev set last getting token reward time
358      */
359     function setLastRewardTime(uint256 _tokenId, uint256 _num) internal {
360         lastGettingReward[_tokenId] = _num;
361     }
362 
363     /**
364      * @dev set last getting token reward time
365      */
366     function updateLastMiningTime(uint256 _currentTime) internal {
367         lastMiningTime = _currentTime - _currentTime % (1 days);
368     }
369 
370     /**
371      * @return uint256 the unix timestamp of the end of the last mining day.
372      */
373     function _getEndOfLastMiningDay() internal view returns(uint256) {
374         return lastMiningTime + 1 days;
375     }
376 
377     /**
378      * @dev Withdraw accumulated balance, called by payee.
379      */
380     function withdrawPayments() public {
381         address payee = msg.sender;
382         uint256 payment = payments[payee];
383         uint256 timestamp = paymentsTimestamps[payee];
384 
385         require(payment != 0);
386         require(now >= timestamp);
387 
388         payments[payee] = 0;
389 
390         require(token.transfer(msg.sender, payment));
391     }
392 
393     /**
394      * @dev Called by the payer to store the sent _amount as credit to be pulled.
395      * @param _dest The destination address of the funds.
396      * @param _amount The amount to transfer.
397      */
398     function asyncSend(address _dest, uint256 _amount, uint256 _timestamp) external onlyDao {
399         payments[_dest] = payments[_dest].add(_amount);
400         paymentsTimestamps[_dest] = _timestamp;
401         require(token.transferFrom(dao, address(this), _amount));
402     }
403 }