1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 contract ERC20 {
35   uint256 public totalSupply;
36   function balanceOf(address who) public view returns (uint256);
37   function transfer(address to, uint256 value) public returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39   function allowance(address owner, address spender) public view returns (uint256);
40   function transferFrom(address from, address to, uint256 value) public returns (bool);
41   function approve(address spender, uint256 value) public returns (bool);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43     
44 }
45 
46 
47 contract BasicToken is ERC20 {
48     using SafeMath for uint256;
49 
50     mapping(address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;
52 
53     /**
54   * @dev transfer token for a specified address
55   * @param _to The address to transfer to.
56   * @param _value The amount to be transferred.
57   */
58 
59     function transfer(address _to, uint256 _value) public returns (bool) {
60         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
61             balances[msg.sender] = balances[msg.sender].sub(_value);
62             balances[_to] = balances[_to].add(_value);
63             Transfer(msg.sender, _to, _value);
64             return true;
65         }else {
66             return false;
67         }
68     }
69     
70 
71     /**
72    * @dev Transfer tokens from one address to another
73    * @param _from address The address which you want to send tokens from
74    * @param _to address The address which you want to transfer to
75    * @param _value uint256 the amout of tokens to be transfered
76    */
77 
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
80         uint256 _allowance = allowed[_from][msg.sender];
81         allowed[_from][msg.sender] = _allowance.sub(_value);
82         balances[_to] = balances[_to].add(_value);
83         balances[_from] = balances[_from].sub(_value);
84         Transfer(_from, _to, _value);
85         return true;
86       } else {
87         return false;
88       }
89 }
90 
91 
92     /**
93   * @dev Gets the balance of the specified address.
94   * @param _owner The address to query the the balance of. 
95   * @return An uint256 representing the amount owned by the passed address.
96   */
97 
98     function balanceOf(address _owner) public view returns (uint256 balance) {
99     return balances[_owner];
100   }
101 
102   function approve(address _spender, uint256 _value) public returns (bool) {
103 
104     // To change the approve amount you first have to reduce the addresses`
105     //  allowance to zero by calling `approve(_spender, 0)` if it is not
106     //  already 0 to mitigate the race condition described here:
107     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
109 
110     allowed[msg.sender][_spender] = _value;
111     Approval(msg.sender, _spender, _value);
112     return true;
113   }
114 
115   /**
116    * @dev Function to check the amount of tokens that an owner allowed to a spender.
117    * @param _owner address The address which owns the funds.
118    * @param _spender address The address which will spend the funds.
119    * @return A uint256 specifing the amount of tokens still avaible for the spender.
120    */
121   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
122     return allowed[_owner][_spender];
123   }
124 
125 
126 }
127 
128 contract ANOToken is BasicToken {
129 
130 using SafeMath for uint256;
131 
132 string public name = "Anonium";                                 // Name of the token
133 string public symbol = "ANO";                                   // Symbol of the token
134 uint8 public decimals = 18;                                     // Decimals
135 uint256 public totalSupply = 21000000000 * 10**18;              // Total supply of SPC Tokens  
136 
137 //Variables
138 uint256 public tokensAllocatedToCrowdFund;                      // variable to track the allocations of the token to crowdfund
139 uint256 public totalAllocatedTokens;                            // variable to track the supply in to the market
140 
141 //Address
142 address public crowdFundAddress;                                // Address of the crowdfund
143 address public founderMultiSigAddress;                          // Address of the founder
144 
145 //events
146 event ChangeFoundersWalletAddress(uint256  _blockTimeStamp, address indexed _foundersWalletAddress);
147 
148 //modifiers
149 
150   modifier onlyCrowdFundAddress() {
151     require(msg.sender == crowdFundAddress);
152     _;
153   }
154 
155   modifier nonZeroAddress(address _to) {
156     require(_to != 0x0);
157     _;
158   }
159 
160   modifier onlyFounders() {
161     require(msg.sender == founderMultiSigAddress);
162     _;
163   }
164 
165 
166   
167    // creation of the token contract 
168    function ANOToken (address _crowdFundAddress) public {
169     crowdFundAddress = _crowdFundAddress;
170     founderMultiSigAddress = msg.sender;
171 
172     tokensAllocatedToCrowdFund = totalSupply;                   // 100 % allocation of totalSupply
173 
174     // Assigned balances to respective stakeholders
175     balances[crowdFundAddress] = tokensAllocatedToCrowdFund;
176   
177   }
178 
179 // function to keep track of the total token allocation
180   function changeSupply(uint256 _amount) public onlyCrowdFundAddress {
181     totalAllocatedTokens += _amount;
182   }
183 
184 // function to change founder multisig wallet address            
185   function changeFounderMultiSigAddress(address _newFounderMultiSigAddress) public onlyFounders nonZeroAddress(_newFounderMultiSigAddress) {
186     founderMultiSigAddress = _newFounderMultiSigAddress;
187     ChangeFoundersWalletAddress(now, founderMultiSigAddress);
188   }
189 
190   /**
191     @dev `burnToken` used to burn the remianing token after the end of crowdsale
192     it only be called by the crowdfund address only 
193    */
194 
195   function burnToken() public onlyCrowdFundAddress returns (bool) {
196     totalSupply = totalSupply.sub(balances[msg.sender]);
197     balances[msg.sender] = 0;
198     return true;
199   }
200 
201 }
202 
203 contract ANOCrowdsale {
204 
205 using SafeMath for uint256;
206 
207 ANOToken token;                                                  // Token variable
208 
209 uint256 public startDate;                                        // Start date of the crowdsale
210 uint256 public endDate;                                          // End date of crowdsale
211 uint256 private weekNo = 0;                                       // Flag variable to track the week no.
212 uint256 public allocatedToken = 21000000000 * 10 ** 18;          // Total tokens allocated to crowdsale 
213 uint256 private tokenAllocatedForWeek;                           // Variable to track the allocation per week
214 uint256 private tokenSoldForWeek;                                // Token sold per week
215 uint256 public ethRaised;                                        // Public variable to track the amount of ETH raised
216 uint32 public tokenRate = 6078;                                  // Initialization of token rate 
217 uint32 public appreciationRate = 1216;                           // The rate of token will increased by that much amount
218 bool private isTokenSet = false;                                 // Flag variable to track the token address
219 
220 address public founderAddress;                                   // Founder address which will control the operations of the crowdsale
221 address public beneficiaryAddress;                               // Address where ETH get trasferred  
222 
223 /**
224     @note structure for keeping the weekly data to track
225     the week rate of the crowdsale
226  */
227 struct weeklyData {
228     uint256 startTime;
229     uint256 endTime;
230     uint32 weekRate;
231 }
232 
233 // mapping is used to store the weeklyData corresponds to integer
234 mapping(uint256 => weeklyData) public weeklyRate;
235 
236 //Event 
237 event LogWeekRate(uint32 _weekRate, uint256 _timestamp);
238 
239 // Modifier for validating the time lapse should between in start and end date
240 modifier isBetween() {
241     require(now >= startDate && now <= endDate);
242     _;
243 }
244 
245 // Modifier for validating the msg.sender should be founder address
246 modifier onlyFounder() {
247     require(msg.sender == founderAddress);
248     _;
249 }
250 
251 //Event 
252 event TokenBought(address indexed _investor, uint256 _tokenQuantity);
253 
254 /**
255     @dev Fallback function
256     minimum 2,00,000 gas should be used at the time calling this function 
257  */
258 
259 function () public payable {
260     buyTokens(msg.sender);
261 }
262 
263 /**
264     @dev Private function to set the weekly rate it called only once
265     in the constructor.
266     @return bool
267  */
268 
269 function setWeeklyRate() private returns (bool) {
270     for (uint32 i = 0; i < 40; ++i) {
271         uint32 weekRate = tokenRate + appreciationRate * i;
272         uint256 weekStartTime = now + i * 1 weeks;
273         uint256 weekEndTime = now + (i+1) * 1 weeks;
274         weeklyRate[i] = weeklyData(weekStartTime, weekEndTime, weekRate);
275     }
276     return true;
277 }
278 
279 /**
280     @dev Private function to get the weekly rate 
281     as per the week no.
282     @return uint32
283  */
284 
285 function getWeeklyRate() private returns (uint32) {
286    if (now <= weeklyRate[weekNo].endTime && now >= weeklyRate[weekNo].startTime) {
287        return weeklyRate[weekNo].weekRate;
288    } if (now <= weeklyRate[weekNo + 1].endTime && now >= weeklyRate[weekNo + 1].startTime ) {
289         weekNo = weekNo + 1;
290         setWeeklyAllocation();
291         return weeklyRate[weekNo + 1].weekRate;
292    } else {
293        uint256 increasedBy = now - startDate;
294        uint256 weekIncreasedBy = increasedBy.div(604800);    // 7 days seconds 7 * 24 * 60 * 60
295        setWeeklyAllocation();
296        weekNo = weekNo.add(weekIncreasedBy);
297        LogWeekRate(weeklyRate[weekNo].weekRate, now);
298        return weeklyRate[weekNo].weekRate;
299    }
300 }
301 
302 // function to transfer the funds to founders account
303 function fundTransfer(uint256 weiAmount) internal {
304         beneficiaryAddress.transfer(weiAmount);
305     }
306 
307 /**
308     @dev Simple function to track the token allocation for a week
309  */
310 function setWeeklyAllocation() private {
311     tokenAllocatedForWeek = (tokenAllocatedForWeek + (tokenAllocatedForWeek - tokenSoldForWeek)).div(2);
312     tokenSoldForWeek = 0;
313 }
314 
315 /**
316     @dev ANOCrowdsale constructor to set the founder and beneficiary
317     as well as to set start & end date.
318     @param _founderAddress address which operates all the admin functionality of the contract
319     @param _beneficiaryAddress address where all invested amount get transferred 
320  */
321 
322 function ANOCrowdsale (address _founderAddress, address _beneficiaryAddress) public {
323     startDate = now;
324     endDate = now + 40 weeks;
325     founderAddress = _founderAddress;
326     beneficiaryAddress = _beneficiaryAddress;
327     require(setWeeklyRate());
328     tokenAllocatedForWeek = allocatedToken.div(2);
329 }
330 
331 /**
332     @dev `setTokenAddress` used to assign the token address into the variable
333     only be called by founder and called only once.
334     @param _tokenAddress address of the token which will be distributed using this crowdsale
335     @return bool
336  */
337 
338 function setTokenAddress (address _tokenAddress) public onlyFounder returns (bool) {
339     require(isTokenSet == false);
340     token = ANOToken(_tokenAddress);
341     isTokenSet = !isTokenSet;
342     return true;
343 }
344 
345 /**
346     @dev `buyTokens` function used to buy the token
347     @param _investor address of the investor where ROI will transferred
348     @return bool
349  */
350 
351 function buyTokens(address _investor) 
352 public 
353 isBetween
354 payable
355 returns (bool) 
356 {
357    require(isTokenSet == true);
358    require(_investor != address(0));
359    uint256 rate = uint256(getWeeklyRate());
360    uint256 tokenAmount = (msg.value.div(rate)).mul(10 ** 8);
361    require(tokenAllocatedForWeek >= tokenSoldForWeek + tokenAmount);
362    fundTransfer(msg.value);
363    require(token.transfer(_investor, tokenAmount));
364    tokenSoldForWeek = tokenSoldForWeek.add(tokenAmount);
365    token.changeSupply(tokenAmount);
366    ethRaised = ethRaised.add(msg.value);
367    TokenBought(_investor, tokenAmount);
368    return true;
369 }
370 
371 /**
372     @dev `getWeekNo` public function to get the current week no
373  */
374 
375 function getWeekNo() public view returns (uint256) {
376     return weekNo;
377 }
378 
379 /**
380     @dev `endCrowdfund` function used to end the crowdfund
381     called only by the founder and remiaining tokens get burned 
382  */
383 
384 function endCrowdfund() public onlyFounder returns (bool) {
385     require(isTokenSet == true);
386     require(now > endDate);
387     require(token.burnToken());
388     return true;
389 }
390 
391 }