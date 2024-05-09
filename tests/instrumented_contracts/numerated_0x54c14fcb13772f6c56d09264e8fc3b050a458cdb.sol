1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public{
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner public {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43   
44 }
45 
46 library SafeMath {
47   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48 	if (a == 0) {
49       return 0;
50     }
51     uint256 c = a * b;
52     assert(c / a == b);
53     return c;
54   }
55 
56   function div(uint256 a, uint256 b) internal pure returns (uint256) {
57     // assert(b > 0); // Solidity automatically throws when dividing by 0
58     uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60     return c;
61   }
62 
63   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67 
68   function add(uint256 a, uint256 b) internal pure returns (uint256) {
69     uint256 c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 
76 interface token {
77     function balanceOf(address who) public constant returns (uint256);
78 	function transfer(address to, uint256 value) public returns (bool);
79 	function getTotalSupply() public view returns (uint256);
80 }
81 
82 
83 
84 contract ApolloSeptemBaseCrowdsale {
85     using SafeMath for uint256;
86 
87     // The token being sold
88     token public tokenReward;
89 	
90     // start and end timestamps where investments are allowed (both inclusive)
91     uint256 public startTime;
92     uint256 public endTime;
93 
94     // address where funds are collected
95     address public wallet;
96 	
97 	// token address
98 	address public tokenAddress;
99 
100     // amount of raised money in wei
101     uint256 public weiRaised;
102 	
103 	// a presale limit of 50% from ico tokens to be sold 
104    uint256 public constant PRESALE_LIMIT = 90 * (10 ** 6) * (10 ** 18);    
105     
106 	// a presale limit is set to minimum of 0.1 ether (100 finney)
107     uint256 public constant PRESALE_BONUS_LIMIT = 100 finney;
108 	
109     // Presale period (includes holidays)
110     uint public constant PRESALE_PERIOD = 30 days;
111     // Crowdsale first Wave period
112     uint public constant CROWD_WAVE1_PERIOD = 10 days;
113     // Crowdsale second Wave period
114     uint public constant CROWD_WAVE2_PERIOD = 10 days;
115     // Crowdsale third Wave period
116     uint public constant CROWD_WAVE3_PERIOD = 10 days;
117 	
118 	// Bonus in percentage 
119     uint public constant PRESALE_BONUS = 40;
120     uint public constant CROWD_WAVE1_BONUS = 15;
121     uint public constant CROWD_WAVE2_BONUS = 10;
122     uint public constant CROWD_WAVE3_BONUS = 5;
123 
124     uint256 public limitDatePresale;
125     uint256 public limitDateCrowdWave1;
126     uint256 public limitDateCrowdWave2;
127     uint256 public limitDateCrowdWave3;
128 	
129 
130     /**
131     * event for token purchase logging
132     * @param purchaser who paid for the tokens
133     * @param beneficiary who got the tokens
134     * @param value weis paid for purchase
135     * @param amount amount of tokens purchased
136     */
137     event ApolloSeptemTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
138     event ApolloSeptemTokenSpecialPurchase(address indexed purchaser, address indexed beneficiary, uint256 amount);
139 
140     function ApolloSeptemBaseCrowdsale(address _wallet, address _tokens) public{		
141         require(_wallet != address(0));
142 		tokenAddress = _tokens;
143         tokenReward = token(tokenAddress);
144         wallet = _wallet;
145     }
146 
147     // fallback function can be used to buy tokens
148     function () public payable {
149         buyTokens(msg.sender);
150     }
151 
152     // low level token purchase function
153     function buyTokens(address beneficiary) public payable {
154         require(beneficiary != address(0));
155         require(validPurchase());
156 
157         uint256 weiAmount = msg.value;
158 
159         // calculate token to be substracted
160         uint256 tokens = computeTokens(weiAmount);
161 
162         require(isWithinTokenAllocLimit(tokens));
163 
164         // update state
165         weiRaised = weiRaised.add(weiAmount);
166 
167 		// send tokens to beneficiary
168 		tokenReward.transfer(beneficiary, tokens);
169 
170         ApolloSeptemTokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
171 
172         forwardFunds();
173     }
174 
175 
176 	//transfer used for special contribuitions
177 	function specialTransfer(address _to, uint _amount) internal returns(bool){
178 		require(_to != address(0));
179 		require(_amount > 0 );
180 		
181 		// calculate token to be substracted
182         uint256 tokens = _amount * (10 ** 18);
183 		
184 		tokenReward.transfer(_to, tokens);		
185 		ApolloSeptemTokenSpecialPurchase(msg.sender, _to, tokens);
186 		
187 		return true;
188 	}
189 
190     // @return true if crowdsale event has ended
191     function hasEnded() public constant returns (bool) {
192         return now > endTime;
193     }
194 
195     // send ether to the fund collection wallet
196     function forwardFunds() internal {
197         wallet.transfer(msg.value);
198     }
199 
200     // @return true if the transaction can buy tokens
201     function validPurchase() internal view returns (bool) {
202         bool withinPeriod = now >= startTime && now <= endTime;
203         bool nonZeroPurchase = msg.value != 0;
204 		
205         return withinPeriod && nonZeroPurchase &&
206                  !(isWithinPresaleTimeLimit() && msg.value < PRESALE_BONUS_LIMIT);
207     }
208     
209     function isWithinPresaleTimeLimit() internal view returns (bool) {
210         return now <= limitDatePresale;
211     }
212 
213     function isWithinCrowdWave1TimeLimit() internal view returns (bool) {
214         return now <= limitDateCrowdWave1;
215     }
216 
217     function isWithinCrowdWave2TimeLimit() internal view returns (bool) {
218         return now <= limitDateCrowdWave2;
219     }
220 
221     function isWithinCrowdWave3TimeLimit() internal view returns (bool) {
222         return now <= limitDateCrowdWave3;
223     }
224 
225     function isWithinCrodwsaleTimeLimit() internal view returns (bool) {
226         return now <= endTime && now > limitDatePresale;
227     }
228 	
229 	function isWithinPresaleLimit(uint256 _tokens) internal view returns (bool) {
230         return tokenReward.balanceOf(this).sub(_tokens) >= PRESALE_LIMIT;
231     }
232 
233     function isWithinCrowdsaleLimit(uint256 _tokens) internal view returns (bool) {			
234         return tokenReward.balanceOf(this).sub(_tokens) >= 0;
235     }
236 
237     function isWithinTokenAllocLimit(uint256 _tokens) internal view returns (bool) {
238         return (isWithinPresaleTimeLimit() && isWithinPresaleLimit(_tokens)) || 
239                         (isWithinCrodwsaleTimeLimit() && isWithinCrowdsaleLimit(_tokens));
240     }
241 	
242 	function sendAllToOwner(address beneficiary) internal returns(bool){
243 		
244 		tokenReward.transfer(beneficiary, tokenReward.balanceOf(this));
245 		return true;
246 	}
247 
248     function computeTokens(uint256 weiAmount) internal view returns (uint256) {
249         uint256 appliedBonus = 0;
250         if (isWithinPresaleTimeLimit()) {
251             appliedBonus = PRESALE_BONUS;
252         } else if (isWithinCrowdWave1TimeLimit()) {
253             appliedBonus = CROWD_WAVE1_BONUS;
254         } else if (isWithinCrowdWave2TimeLimit()) {
255             appliedBonus = CROWD_WAVE2_BONUS;
256         } else if (isWithinCrowdWave3TimeLimit()) {
257             appliedBonus = CROWD_WAVE3_BONUS;
258         }
259 
260 		// 1 ETH = 4200 APO 
261         return weiAmount.mul(42).mul(100 + appliedBonus);
262     }
263 }
264 
265 
266 
267 
268 /**
269  * @title ApolloSeptemCappedCrowdsale
270  * @dev Extension of ApolloSeptemBaseCrowdsale with a max amount of funds raised
271  */
272 contract ApolloSeptemCappedCrowdsale is ApolloSeptemBaseCrowdsale{
273     using SafeMath for uint256;
274 
275     // HARD_CAP = 30,000 ether 
276     uint256 public constant HARD_CAP = (3 ether)*(10**4);
277 
278     function ApolloSeptemCappedCrowdsale() public {}
279 
280     // overriding ApolloSeptemBaseCrowdsale#validPurchase to add extra cap logic
281     // @return true if investors can buy at the moment
282     function validPurchase() internal view returns (bool) {
283         bool withinCap = weiRaised.add(msg.value) <= HARD_CAP;
284 
285         return super.validPurchase() && withinCap;
286     }
287 
288     // overriding Crowdsale#hasEnded to add cap logic
289     // @return true if crowdsale event has ended
290     function hasEnded() public constant returns (bool) {
291         bool capReached = weiRaised >= HARD_CAP;
292         return super.hasEnded() || capReached;
293     }
294 }
295 
296 
297 /**
298  * @title ApolloSeptemCrowdsale
299  * @dev This is ApolloSeptem's crowdsale contract.
300  */
301 contract ApolloSeptemCrowdsale is ApolloSeptemCappedCrowdsale, Ownable {
302 
303 	bool public isFinalized = false;
304 	bool public isStarted = false;
305 
306 	event ApolloSeptemStarted();
307 	event ApolloSeptemFinalized();
308 
309     function ApolloSeptemCrowdsale(address _wallet,address _tokensAddress) public
310         ApolloSeptemCappedCrowdsale()
311         ApolloSeptemBaseCrowdsale(_wallet,_tokensAddress) 
312     {
313    
314     }
315 	
316 	/**
317    * @dev Must be called to start the crowdsale. 
318    */
319 	function start() onlyOwner public {
320 		require(!isStarted);
321 
322 		starting();
323 		ApolloSeptemStarted();
324 
325 		isStarted = true;
326 	}
327 	
328 
329     function starting() internal {
330         startTime = now;
331         limitDatePresale = startTime + PRESALE_PERIOD;
332         limitDateCrowdWave1 = limitDatePresale + CROWD_WAVE1_PERIOD; 
333         limitDateCrowdWave2 = limitDateCrowdWave1 + CROWD_WAVE2_PERIOD; 
334         limitDateCrowdWave3 = limitDateCrowdWave2 + CROWD_WAVE3_PERIOD;         
335         endTime = limitDateCrowdWave3;
336     }
337 	
338 	/**
339 	* @dev Must be called after crowdsale ends, to do some extra finalization
340 	* work. Calls the contract's finalization function.
341 	*/
342 	function finalize() onlyOwner public {
343 		require(!isFinalized);
344 		require(hasEnded());
345 
346 		ApolloSeptemFinalized();
347 
348 		isFinalized = true;
349 	}	
350 	
351 	/**
352 	* @dev Must be called only in special cases 
353 	*/
354 	function apolloSpecialTransfer(address _beneficiary, uint _amount) onlyOwner public {		 
355 		 specialTransfer(_beneficiary, _amount);
356 	}
357 	
358 	
359 	/**
360 	*@dev Must be called after the crowdsale ends, to send the remaining tokens back to owner
361 	**/
362 	function sendRemaningBalanceToOwner(address _tokenOwner) onlyOwner public {
363 		require(!isFinalized);
364 		require(_tokenOwner != address(0));
365 		
366 		sendAllToOwner(_tokenOwner);	
367 	}
368 	
369 	
370 }